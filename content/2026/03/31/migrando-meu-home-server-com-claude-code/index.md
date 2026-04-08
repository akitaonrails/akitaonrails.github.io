---
title: "Migrando meu Home Server com Claude Code | openSUSE MicroOS"
date: '2026-03-31T16:00:00-03:00'
draft: false
translationKey: home-server-migration-claude-code
tags:
  - homeserver
  - docker
  - opensuse
  - microos
  - claude-code
  - AI
  - vibe-coding
---

Meu home server antigo era uma bagunça. Um Intel NUC com Ubuntu Server que eu fui remendando ao longo de dois anos. Containers com caminhos hardcoded, volumes montados em locais aleatórios (`/home/akitaonrails/docker/`, `/home/akitaonrails/sonarr/`, `/mnt/terachad/`), docker-compose files espalhados sem padrão nenhum. Funcionava, mas se eu perdesse o disco, levaria dias pra reconstruir tudo de memória.

Com o [novo Minisforum MS-S1 Max](/2026/03/31/review-minisforum-ms-s1-max-amd-ai-max-395/) que comprei, decidi fazer a migração direito. E decidi usar Claude Code desde o início pra acelerar o processo. É um servidor caseiro, só eu uso, o risco de fazer besteira é baixo. Mas se fosse um servidor de produção real, eu jamais faria isso sem review humano rigoroso em cada passo.

O que segue é o relato da migração e o guia pra quem quiser replicar. Se um dia eu precisar reconstruir do zero, esse post é a documentação.

## Escolha do sistema operacional

### Por que não Ubuntu Server de novo

Eu usei Ubuntu Server no NUC por praticidade. Mas `do-release-upgrade` é uma roleta russa. Toda vez que o Ubuntu lança versão nova, a atualização é um risco real de quebrar coisas. Pacotes mudam, configs são sobrescritas, dependências conflitam. Pra um servidor que precisa estar sempre rodando, isso é inaceitável.

### Por que não Arch Linux

Eu uso Arch no desktop e gosto. Mas Arch é uma rolling release sem nenhuma garantia de estabilidade. Pra um desktop onde eu posso parar e resolver problemas, ótimo. Pra um servidor headless que roda 49 containers Docker e precisa funcionar depois de cada reboot, não.

### Fedora CoreOS vs openSUSE MicroOS

As duas opções modernas pra servidor de containers são Fedora CoreOS e openSUSE MicroOS. As duas são sistemas imutáveis: o root filesystem é read-only, atualizações são atômicas (ou aplicam inteiro ou não aplicam nada), e rollback é instantâneo.

A diferença: Fedora CoreOS usa Ignition (configuração declarativa antes do primeiro boot) e é projetada pra ser provisionada automaticamente. MicroOS usa `transactional-update` e permite uso interativo normal. Pra um home server onde eu quero SSH e mexer manualmente quando precisar, MicroOS se encaixa melhor.

### O que torna MicroOS diferente

O conceito de sistema imutável muda como você opera o servidor:

Toda instalação de pacote ou edição de `/etc` passa por `transactional-update`, que cria um snapshot btrfs novo, aplica a mudança nesse snapshot, e no reboot seguinte o sistema boota no snapshot atualizado. Se a mudança quebrar alguma coisa, você faz `transactional-update rollback` e volta pro snapshot anterior em segundos.

Atualizações são automáticas e diárias. O `transactional-update.timer` baixa patches, cria snapshot, e o `rebootmgr` reinicia numa janela configurada (no meu caso, entre 4h e 5h30 da manhã). Se a atualização quebra o boot, o GRUB automaticamente volta pro snapshot anterior.

SELinux vem enforcing por padrão. Isso causou 90% dos problemas durante a migração, mas é a configuração certa pra segurança.

## Setup inicial

### Hardware

- AMD Ryzen AI Max+ 395, 128GB LPDDR5X
- 96GB alocados como VRAM via BIOS (UMA Frame Buffer Size)
- NVMe de 2TB (sistema + Docker)
- Rede cabeada 2.5Gbps
- Synology DS1821+ NAS em 192.168.0.21 (NFS)

### Primeiros passos

Instalação do MicroOS é padrão. Depois:

```bash
# Criar usuário com UID que bate com o NAS (pra NFS funcionar sem problemas de permissão)
useradd -u 1026 -m akitaonrails
passwd akitaonrails

# Configurar sudo (dentro de transactional-update shell)
sudo transactional-update shell
# dentro: adicionar akitaonrails ao sudoers
exit
sudo reboot
```

### NFS do Synology

O NAS Synology exporta `/volume1/TERACHAD` via NFS. O ponto de montagem no MicroOS é `/var/mnt/terachad` (não `/mnt/`, que fica no root imutável).

No `/etc/fstab` (aplicado via transactional-update):

```
192.168.0.21:/volume1/TERACHAD /var/mnt/terachad nfs4 nfsvers=4.1,rsize=262144,wsize=262144,hard,_netdev 0 0
```

Detalhes que importam: `nfsvers=4.1` porque 4.2 não funcionou com o Synology. `rsize=262144,wsize=262144` (256KB buffers) foi a maior melhoria de performance NFS. `hard` em vez de `nofail` pra que o mount retente indefinidamente se o NAS desconectar temporariamente.

### GPU / ROCm

Esse passo deu trabalho. O Radeon 8060S do AI Max+ 395 é gfx1151, que o ROCm não suporta oficialmente. Foram necessários três passos, e os três são obrigatórios:

1. BIOS: setar UMA Frame Buffer Size pra 96GB
2. Kernel: adicionar `amdttm.pages_limit=25165824 amdttm.page_pool_size=25165824` em `/etc/kernel/cmdline`
3. Docker: usar `HSA_OVERRIDE_GFX_VERSION=11.5.1` em todo container ROCm

Sem o passo 2, o ROCm só vê 15.5GB mesmo com a alocação do BIOS. Os números são 96GB / 4KB (page size) = 25.165.824 pages.

```bash
sudo transactional-update shell
echo "amdttm.pages_limit=25165824 amdttm.page_pool_size=25165824" >> /etc/kernel/cmdline
exit
sudo sdbootutil update-all-entries  # FORA do transactional shell
sudo reboot
```

Verificação:
```bash
cat /sys/class/drm/card1/device/mem_info_vram_total
# 103079215104 (96 * 1024^3)
```

## Docker no MicroOS

```bash
sudo transactional-update --non-interactive pkg install docker
sudo reboot

sudo systemctl enable --now docker
sudo usermod -aG docker akitaonrails
# logout e login pra o grupo pegar

# Instalar docker-compose standalone (o pacote openSUSE não inclui)
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64" \
  -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
mkdir -p ~/.docker/cli-plugins
ln -s /usr/local/bin/docker-compose ~/.docker/cli-plugins/docker-compose
```

### daemon.json

```json
{
  "log-level": "warn",
  "log-driver": "local",
  "log-opts": {"max-size": "10m", "max-file": "5"},
  "selinux-enabled": true,
  "live-restore": true,
  "userland-proxy": false,
  "exec-opts": ["native.cgroupdriver=systemd"]
}
```

`live-restore: true` faz containers sobreviverem restart do daemon Docker. `userland-proxy: false` usa iptables direto em vez de processos proxy (menos overhead). `selinux-enabled: true` é obrigatório no MicroOS.

## SELinux e Docker: a maior fonte de problemas

Isso merece uma seção inteira porque foi responsável por 90% dos bugs durante a migração.

No MicroOS com SELinux enforcing, todo container que escreve em diretório bind-mounted do host precisa de tratamento especial. Existem duas abordagens: o sufixo `:Z` nos volumes e a opção `security_opt: label:disable`.

### NUNCA use `:Z`. Use `security_opt: label:disable`.

O `:Z` diz pro Docker relabeling o diretório do host com o contexto SELinux do container. Parece a coisa certa. Na prática:

- Bancos SQLite quebram. O relabeling muda o contexto do arquivo e o SQLite pode recusar abrir o WAL journal.
- Mounts NFS ignoram `:Z` silenciosamente. O NFS não suporta xattrs do SELinux. O kernel ignora o flag sem erro, mas o container continua sem permissão.
- Mounts `:ro,Z` tentam relabeling mesmo sendo read-only, o que falha em NFS e pode corromper contexto em paths locais.

A solução correta pra todo container nesse sistema:

```yaml
services:
  meuservico:
    security_opt:
      - label:disable     # desliga enforcement SELinux pra esse container
    volumes:
      - ./data:/data      # SEM :Z
      - ./config.yml:/etc/config.yml:ro  # SEM :Z mesmo em :ro
```

`label:disable` desliga enforcement de labels SELinux apenas pra aquele container, não pro sistema inteiro. Combinado com o isolamento de rede e processos do Docker, é seguro pra home server.

## A migração dos stacks

Todos os stacks Docker foram reorganizados em `/var/opt/docker/<stack>/docker-compose.yml`. No servidor antigo, estavam espalhados em `/home/akitaonrails/docker/`, `/home/akitaonrails/<servico>/`, sem padrão.

### Substituições aplicadas em todos os compose files

| Antes | Depois |
|---|---|
| `/mnt/terachad/` | `/var/mnt/terachad/` |
| `192.168.0.145` | `192.168.0.90` |
| `/home/akitaonrails/<servico>/` | `/var/opt/docker/<stack>/<servico>/` |
| `OLLAMA_BASE_URL=http://192.168.0.14:11434` | `OLLAMA_BASE_URL=http://192.168.0.90:11434` |

### Stack de media (Plex, Radarr, Sonarr, etc.)

O stack de media é o mais complexo. Plex precisa de IP próprio na LAN (macvlan) pro streaming direto funcionar. O setup:

```bash
docker network create -d macvlan \
  --subnet=192.168.0.0/24 \
  --gateway=192.168.0.1 \
  -o parent=enp97s0 \
  plex_macvlan
```

No compose, o Plex precisa estar em duas redes: a macvlan (pro IP 192.168.0.6) e a bridge default (pra outros containers como Seerr conseguirem se comunicar):

```yaml
plex:
  networks:
    plex_macvlan:
      ipv4_address: 192.168.0.6
      mac_address: "02:42:c0:a8:00:06"
    default: {}    # obrigatório — sem isso, Seerr não enxerga o Plex
```

Detalhe que quase me quebrou: o Plex guarda paths absolutos no banco de dados. Se o volume interno do container mudou de `/media` pra `/data`, o Plex não encontra mais nada. Tem que usar exatamente o mesmo mount target do compose antigo.

### Ollama com ROCm

Stack novo, não existia no servidor anterior:

```yaml
ollama:
  image: ollama/ollama:rocm
  container_name: ollama
  devices:
    - /dev/kfd:/dev/kfd
    - /dev/dri:/dev/dri
  security_opt:
    - seccomp:unconfined
    - label:disable
  group_add:
    - "485"   # render group GID
    - "488"   # video group GID
  environment:
    - HSA_OVERRIDE_GFX_VERSION=11.5.1
    - PYTORCH_ROCM_ARCH=gfx1151
    - OLLAMA_KEEP_ALIVE=30m
    - OLLAMA_NUM_PARALLEL=4
    - OLLAMA_FLASH_ATTENTION=1
    - OLLAMA_KV_CACHE_TYPE=q8_0
  volumes:
    - /var/lib/ollama:/root/.ollama
  ports:
    - "11434:11434"
```

`OLLAMA_FLASH_ATTENTION=1` ativa flash attention. `OLLAMA_KV_CACHE_TYPE=q8_0` usa KV cache em 8-bit, cortando bandwidth necessária por token pela metade. São otimizações de performance gratuitas.

### Monitoramento (Grafana + Prometheus)

O Grafana usa named volume (`grafana_data`) que NÃO é incluído em backups normais de filesystem. Foi o motivo pelo qual perdi todos os dashboards na primeira tentativa. A solução é backup explícito do named volume:

```bash
# No servidor antigo:
docker run --rm -v grafana_data:/data:ro -v /tmp:/backup alpine \
  tar czf /backup/grafana_data.tar.gz -C /data .

# Transferir e restaurar no novo:
docker run --rm -v grafana_data:/data -v /tmp:/backup alpine \
  sh -c "cd /data && tar xzf /backup/grafana_data.tar.gz"
```

Mesma coisa pro Portainer (`portainer_data`). Qualquer volume definido no bloco `volumes:` do compose sem host path precisa desse tratamento.

### Cloudflare Tunnel

Eu uso [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/) pra acessar todos os serviços fora de casa sem abrir portas no roteador. A migração foi a mais fácil: copiar o arquivo de credenciais JSON do túnel e o `config.yml`, atualizar os IPs de `.145` pra `.90`, e subir o container. O túnel mantém o mesmo ID, não precisa recriar DNS.

Os hostnames ficam em `config.yml`: portainer, grafana, plex, seerr, qbittorrent, syncthing, radarr, sonarr, bazarr, prowlarr, vault, gitea, kavita, e outros. Tudo acessível via `https://<servico>.example.com` de qualquer lugar.

### Gitea (registry de imagens)

O [Gitea](https://github.com/go-gitea/gitea) funciona como registry Docker privado na porta 3007. Os projetos Frank FBI, Frank Mega, Frank Yomik e Mila têm imagens Docker que são buildadas e pushadas pro Gitea. Pra funcionar, o `daemon.json` do Docker precisa de:

```json
{
  "insecure-registries": ["192.168.0.90:3007"]
}
```

O SSH do Gitea deu problema na migração: o app.ini antigo tinha `SSH_LISTEN_PORT=22`, mas o entrypoint do container também inicia sshd na porta 22. Conflito. Solução: `GITEA__server__SSH_LISTEN_PORT=2222` como variável de ambiente no compose.

### Todos os 49 containers rodando

O servidor migrado roda 49 containers em 15 stacks. O stack de media sozinho tem 10 containers ([Plex](https://www.plex.tv/), [Radarr](https://github.com/Radarr/Radarr), [Sonarr](https://github.com/Sonarr/Sonarr), [Bazarr](https://github.com/morpheus65535/bazarr), [Prowlarr](https://github.com/Prowlarr/Prowlarr), [qBittorrent](https://github.com/qbittorrent/qBittorrent), [SABnzbd](https://github.com/sabnzbd/sabnzbd), [Jackett](https://github.com/Jackett/Jackett), [FlareSolverr](https://github.com/FlareSolverr/FlareSolverr), [Seerr](https://github.com/seerr/seerr)). Os projetos pessoais ([Frank FBI](https://github.com/akitaonrails/frank_fbi), [Frank Mega](/2026/02/21/vibe-code-fiz-um-clone-do-mega-em-rails-em-1-dia-pro-meu-home-server/), [Frank Yomik](https://github.com/akitaonrails/FrankYomik), Mila) somam mais 11. Monitoramento com [Grafana](https://github.com/grafana/grafana), [Prometheus](https://github.com/prometheus/prometheus), node-exporter e [cAdvisor](https://github.com/google/cadvisor). Utilitários como [Portainer](https://github.com/portainer/portainer), [Vaultwarden](https://github.com/dani-garcia/vaultwarden), [Syncthing](https://github.com/syncthing/syncthing), [Organizr](https://github.com/causefx/Organizr), [Watchtower](https://github.com/containrrr/watchtower). [Gitea](https://github.com/go-gitea/gitea) como registry Docker privado. [Immich](https://github.com/immich-app/immich) como Google Photos self-hosted. [Kaizoku](https://github.com/oae/kaizoku) pra manga com [Kavita](https://github.com/Kareadita/Kavita) como reader. [Ollama](https://github.com/ollama/ollama) com ROCm. E o [Bitcoin Core](https://github.com/bitcoin/bitcoin)/[Fulcrum](https://github.com/cculianu/Fulcrum) indexando a blockchain do NAS.

## Backups: duas camadas

### Camada 1: snapshots btrfs locais (snapper)

O `/var` vive numa partição btrfs de 3.7TB. O snapper cria snapshots automáticos: 7 diários + 1 semanal. São crash-consistent, não application-consistent (postgres pode ficar levemente inconsistente se tiver write pesado no momento do snapshot).

Pra recuperar um arquivo apagado acidentalmente:
```bash
sudo snapper -c var list
sudo cp /var/.snapshots/5/snapshot/opt/docker/media/radarr/appdata/config/radarr.db \
        /var/opt/docker/media/radarr/appdata/config/radarr.db
```

Pra rollback completo de um stack:
```bash
sudo docker compose -p media down
sudo snapper -c var undochange 7..0 /var/opt/docker/media
sudo docker compose -p media up -d
```

### Camada 2: restic pro NAS (off-machine)

O [restic](https://github.com/restic/restic) roda toda noite às 3h, faz backup incremental pra `/var/mnt/terachad/homelab-backups/`. Retenção: 7 diários + 4 semanais. Deduplicação por conteúdo, então Plex config (19GB) e Gitea repos (12GB) transferem apenas deltas.

Antes do restic rodar, um `pg_dump` exporta os bancos postgres (Immich, Kaizoku). Os dumps vão pra `/tmp/homelab-db-dumps/` e são incluídos no backup.

O que NÃO é incluído no backup (re-downloadável): blockchain Bitcoin (785GB no NAS), imagens Docker (re-pullable), modelos Ollama (re-downloadable), cache do HuggingFace/EasyOCR, transcoding temporário do Plex.

Diretórios grandes e re-downloadáveis foram convertidos em subvolumes btrfs pra que o snapper os ignore: `/var/lib/ollama` e `/var/opt/docker/bitcoin/fulcrum/fulc2_db`.

## Tuning de performance

### btrfs com compressão zstd

Adicionei `compress=zstd:1` no fstab pra partição `/var`. O zstd nível 1 tem overhead de CPU quase zero em NVMe e comprime bem metadata Docker, JSON configs e logs. Dados incompressíveis (SQLite, postgres) são ignorados automaticamente pelo btrfs.

### zram swap

Com ~30GB de RAM disponível pro sistema (96GB vão pra VRAM), swap comprimido em memória ajuda. O zram cria um dispositivo de swap de ~15GB (ram/2) com compressão zstd, muito mais rápido que swap em disco.

```ini
# /etc/systemd/zram-generator.conf
[zram0]
zram-size = ram / 2
compression-algorithm = zstd
swap-priority = 100
```

### btrfs nodatacow em diretórios de banco de dados

Copy-on-write + escrita aleatória de banco de dados = write amplification. Desabilitei CoW nos diretórios que guardam SQLite e postgres:

```bash
sudo chattr +C /var/opt/docker/gitea/data/gitea.db
sudo chattr +C /var/opt/docker/immich/db/
sudo chattr +C /var/opt/docker/media/radarr/appdata/config/
```

### CPU em modo performance

Num servidor headless, não faz sentido economizar energia:

```bash
echo performance | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference
```

Persistido via systemd service `cpu-epp.service`.

### Docker shutdown fix

Problema que descobri: o Docker vem com `KillMode=process`, que significa que no shutdown do sistema, o systemd mata só o dockerd e deixa todos os `containerd-shim` (um por container, ~49 no meu caso) órfãos. O systemd-shutdown precisa caçar eles um a um depois que o journal já parou, causando um hang silencioso de vários minutos.

Fix:
```ini
# /etc/systemd/system/docker.service.d/shutdown.conf
[Service]
KillMode=control-group
TimeoutStopSec=30
```

## Os problemas que encontramos

Essa é a tabela de problemas reais que tivemos durante a migração. Se você está planejando algo parecido, leia antes de começar:

| Problema | Causa | Solução |
|---|---|---|
| ROCm vê só 15.5GB de VRAM | Kernel TTM limita pages mesmo com BIOS em 96GB | Adicionar `amdttm.pages_limit=25165824` no kernel cmdline |
| Todos containers: permission denied em volumes | SELinux `container_t` não escreve em paths sem label | `security_opt: label:disable` em todo serviço |
| NFS com `:Z` falha silenciosamente | NFS não suporta xattr do SELinux | Nunca usar `:Z` em paths NFS |
| SQLite quebra com `:Z` | Relabeling muda contexto, WAL mode falha | Remover `:Z`, usar `label:disable` |
| Radarr/Sonarr mostraram tela de setup | Backup em `appdata/config/` mas compose montava `appdata/` | Corrigir: `appdata/config:/config` |
| Grafana perdeu dashboards | Named volume não incluído no backup de filesystem | Backup explícito do named volume |
| Plex não encontra mídia | Path interno mudou de `/media` pra `/data` | Restaurar path original no compose |
| Seerr não conecta no Plex | macvlan isolada da bridge network | Adicionar `default: {}` nas networks do Plex |
| Fulcrum crash: "option -b missing" | Env vars não suportadas pela imagem | Usar flags CLI em `command:` |
| bitcoind rejeita RPC | Bind em `::1` por padrão | Adicionar `-rpcbind=0.0.0.0 -rpcallowip=172.0.0.0/8` |
| sdbootutil warning no transactional shell | Deve rodar fora da transação | Executar `sdbootutil update-all-entries` no shell normal |
| Watchtower permission denied em docker.sock | SELinux bloqueia acesso ao socket | `label:disable` |
| Gitea SSH crash | Conflito: entrypoint sshd porta 22 + app porta 22 | `GITEA__server__SSH_LISTEN_PORT=2222` |
| docker-compose não instalado com Docker | Pacote openSUSE só instala o daemon | Instalar binário standalone manualmente |

## O que dizer pro Claude Code antes de começar

Se eu fosse refazer a migração do zero, daria estas instruções pro Claude Code na primeira mensagem. Na ordem de importância:

Diga que SELinux está enforcing e que ele NÃO deve usar `:Z` em nenhum volume Docker, e sim `security_opt: label:disable` em todo serviço. Diga que `/var/mnt/terachad/` é mount NFS e que `:Z` nunca deve aparecer em paths NFS. Diga pra sempre olhar o compose original antes de reescrever e só mudar IPs, paths e nomes de container, sem inventar novos layouts de volume. Avise que named volumes precisam de backup explícito (Grafana, Portainer). Explique que Plex roda em macvlan e precisa de `default: {}` nas networks. Informe que a GPU é gfx1151, não suportada oficialmente, e que precisa de UMA 96GB no BIOS + kernel TTM params + `HSA_OVERRIDE_GFX_VERSION=11.5.1`. E diga que Bitcoin/Fulcrum não processam variáveis de ambiente, tudo vai como argumento no `command:`.

Essas instruções teriam evitado 80% dos problemas que encontramos.

## Layout final do servidor

```
/var/opt/docker/
├── bitcoin/          (bitcoind + fulcrum)
├── cloudflared/      (túnel Cloudflare)
├── frank_fbi/        (análise de fraude por email)
├── frank_mega/       (clone do Mega)
├── frank_yomik/      (tradução de mangás)
├── gitea/            (registry Docker)
├── immich/           (Google Photos self-hosted)
├── kaizoku/          (manga downloader + reader)
├── media/            (Plex + *arr stack)
├── mila/             (bot Discord)
├── monitor/          (Grafana + Prometheus)
├── ollama/           (LLM local com ROCm)
├── rip/              (HandBrake)
└── utils/            (Portainer, Vaultwarden, Syncthing, etc.)

/var/mnt/terachad/    (NFS do Synology)
├── Bitcoin/data/     (blockchain, 785GB)
├── Downloads/        (torrents + nzbget)
├── Videos/           (Radarr movies + Sonarr series)
└── Ollama/models/    (overflow de modelos se disco local encher)
```

## Aviso sobre usar IA pra administrar servidor

Eu usei Claude Code pra acelerar a migração. Criou compose files, escreveu scripts de backup, configurou firewall, diagnosticou problemas de SELinux. Funcionou bem pro meu caso: home server, só eu uso, e eu estava revisando cada passo.

Mas tem armadilhas. O Claude não sabe que `:Z` quebra SQLite a menos que você diga. Ele não sabe que o Fulcrum não aceita env vars a menos que já tenha visto o Dockerfile. Ele vai inventar layouts de volume "melhores" que quebram o Plex porque o Plex guarda paths absolutos no banco de dados.

Se fosse produção real: não faça isso sem review. Cada compose file que o Claude gerar, leia inteiro antes de aplicar. Cada comando destrutivo (rollback, delete, recreate), confirme manualmente. E tenha backups testados antes de começar. O Claude é bom pra gerar a primeira versão e diagnosticar erros, mas as decisões de arquitetura e as validações de segurança são suas.

Os posts anteriores sobre o home server que podem dar contexto adicional:
- [Meu "Netflix Pessoal" com Docker Compose](/2024/04/03/meu-netflix-pessoal-com-docker-compose/)
- [Acessando meu Home Server com domínio de verdade](/2025/09/09/acessando-meu-home-server-com-dominio-de-verdade/)
- [Protegendo seu Home Server com Cloudflare Zero Trust](/2025/09/10/protegendo-seu-home-server-com-cloudflare-zero-trust/)
- [Instalando Grafana no meu Home Server](/2025/09/10/instalando-grafana-no-meu-home-server/)
- [Vaultwarden self-hosted](/2025/09/10/omarchy-2-0-bitwarden-self-hosted-vaultwarden/)
