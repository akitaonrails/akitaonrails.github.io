---
title: "Como me precaver pros meus agentes não apagarem minhas coisas?"
slug: "como-me-precaver-pros-meus-agentes-nao-apagarem-minhas-coisas"
date: '2026-07-11T21:00:00-03:00'
draft: false
translationKey: how-to-protect-yourself-from-agents-deleting-your-stuff
description: "LLMs apagando arquivos de gente famosa viraram manchete essa semana. Em cinco meses de uso pesado, em YOLO mode, nunca aconteceu comigo. Mas eu também não confio: snapshots BTRFS, backups restic, sandbox e disciplina."
tags:
  - ai
  - llm
  - vibecoding
  - btrfs
  - backup
  - restic
  - ansible
  - kubernetes
  - devops
  - linux
---

Essa semana o assunto no Twitter foi LLM apagando arquivo dos outros. O [Matt Shumer postou](https://x.com/mattshumer_/status/2075657271401390161) que o GPT-5.6-Sol acidentalmente deletou quase TODOS os arquivos do Mac dele. Um subagente de review expandiu errado a variável `$HOME` e rodou `rm -rf /Users/mattsdevbox`. Ele matou o processo no meio, mas o estrago já estava feito.

![Tweet do Matt Shumer: GPT-5.6-Sol acidentalmente deletou quase todos os arquivos do Mac dele, rodando rm -rf /Users/mattsdevbox por causa de uma expansão errada de $HOME.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/11/agentes-apagando/tweet-mattshumer.webp)

No dia seguinte o [goodalexander reproduziu](https://x.com/goodalexander/status/2076019436767584347) o mesmo comportamento num devnet descartável: um `rsync --delete-delay` contra `/` varreu `/var`, `/etc` e o estado dos validators dele, corrompendo o filesystem a ponto de precisar reinstalar o sistema operacional. A conclusão dele: "you can't use this thing in prod".

![Tweet do goodalexander: reproduziu o comportamento destrutivo do GPT 5.6 Sol num devnet descartável, com rsync --delete-delay apagando /var e /etc e corrompendo o filesystem.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/11/agentes-apagando/tweet-goodalexander.webp)

Casos assim aparecem de tempos em tempos desde que agentes de coding viraram mainstream. E toda vez a discussão descamba pros mesmos dois extremos: de um lado "viu? IA é perigosa, nunca deixe rodar nada sozinha", do outro "quem deixa um agente solto no sistema merece o que acontece". Eu acho os dois lados preguiçosos. Deixa eu contar minha experiência real e o que eu faço a respeito.

## Cinco meses de maratona, zero acidentes

Desde fevereiro eu estou maratonando Claude Code, Codex e OpenCode. Quase todos os dias, quase o tempo todo, em sessões muito longas que às vezes atravessam dias. Estourando o limite do meu plano Max da Anthropic e do meu plano Plus da OpenAI com folga. O resultado concreto até agora: quase 40 repositórios novos no meu GitHub e mais de 500 mil linhas de código produzidas.

E nos últimos dois meses eu rodo tudo exclusivamente em "YOLO mode". Pra quem não conhece o jargão: por padrão, esses agentes pedem permissão antes de cada comando que vão executar no seu terminal. O YOLO mode desliga essa trava. No Claude Code é a flag `--dangerously-skip-permissions`, no Codex é o `--yolo`, no OpenCode você configura as permissões pra aprovar tudo. O agente roda o que quiser, quando quiser, sem me perguntar nada.

Em cinco meses nesse regime, nem uma vez um agente apagou um arquivo que eu não pedi. Nem uma vez rodou um comando destrutivo fora do escopo. As frustrações que eu tenho com agentes são de outra natureza (teimosia, solução preguiçosa, contexto que se perde), coisas irritantes mas a quilômetros de distância de um `rm -rf` no meu home.

Então quando eu vejo esses relatos, minha primeira hipótese sempre vai pro mesmo lugar: o prompt. Pra um agente "enlouquecer" desse jeito, em geral o usuário escreveu instruções muito ruins. Vagas, ambíguas, pedindo limpeza sem definir o que é lixo, mandando o agente "resolver" sem dar contexto. Falta de habilidade de comunicação combinada com falta de conhecimento técnico pra perceber que o pedido estava mal formulado. O agente executa a instrução que você escreveu, com todas as ambiguidades que você deixou nela.

Dito isso, eu NÃO confio completamente em LLMs. Ninguém deveria.

> A diferença é que a minha desconfiança vira engenharia em vez de virar tweet.

Camada por camada, é assim que eu durmo tranquilo.

## Camada 1: sandbox com ai-jail

Quando eu realmente suspeito que uma sessão pode fazer besteira (vou mexer em scripts de sistema, vou deixar o agente rodar por horas sem supervisão num código que toca no filesystem), eu abro o harness dentro do [ai-jail](https://github.com/akitaonrails/ai-jail), uma ferramenta minha, open source, escrita em Rust.

O ai-jail é um wrapper de sandbox pra agentes de coding. No Linux ele usa o `bwrap` (bubblewrap, a mesma base do Flatpak), no macOS usa o `sandbox-exec`. A ideia: o processo enxerga um filesystem que parece normal, mas só o diretório do projeto atual é real e persistente. O resto do `$HOME`, os diretórios vizinhos, o `/tmp`, tudo vive em tmpfs e evapora quando a sessão termina. O estado do agente (`~/.claude`, `~/.codex` etc) é montado de verdade pra ele continuar logado e configurado, mas `~/.ssh`, `~/.gnupg`, `~/.aws` e perfis de browser nunca entram na jaula.

Instalar é um comando:

```bash
# Arch Linux
yay -S ai-jail-bin

# macOS / Linux via Homebrew
brew tap akitaonrails/tap && brew install ai-jail

# ou direto do crates.io
cargo install ai-jail
```

E usar é mais simples ainda:

```bash
cd ~/Projects/meu-app
ai-jail claude       # Claude Code na jaula
ai-jail codex        # Codex na jaula
ai-jail --dry-run claude  # mostra a política sem rodar
```

Se o agente resolver rodar `rm -rf ~` lá dentro, ele apaga um tmpfs que ia sumir de qualquer jeito. Meu home real nem foi montado. Pra quem está começando com YOLO mode e ainda não tem calo, é o jeito mais barato de errar sem consequência.

## Camada 2: BTRFS e snapshots (a rede de segurança de verdade)

Agora o ponto principal desse post. Eu advogo há ANOS que usuário de Linux deveria usar BTRFS em vez de EXT4. Fiz [um episódio inteiro do Akitando sobre isso em 2023](/2023/10/19/akitando-146-protegendo-e-recuperando-dados-perdidos-git-backup-btrfs/), muito antes de existir agente de coding pra levar a culpa. O argumento era o mesmo: seus dados precisam sobreviver a erro humano. Um LLM rodando `rm -rf` no lugar errado é só uma categoria nova de erro humano, terceirizado.

Por que BTRFS é superior pra desktop? Copy-on-write (CoW): o filesystem nunca sobrescreve um bloco no lugar, ele escreve a versão nova em outro bloco e atualiza os ponteiros. Checksum de dados e metadados, então bitrot silencioso é detectado em vez de corromper seu arquivo caladinho. Compressão transparente. Subvolumes, que funcionam como partições flexíveis sem tamanho fixo. E a consequência mais valiosa do CoW: **snapshots leves**.

Um snapshot BTRFS é instantâneo e custa perto de zero espaço no momento em que é criado. Ele congela os ponteiros dos blocos atuais em vez de copiar dados. Só o que divergir a partir dali (blocos novos ou modificados) passa a ocupar espaço extra. Na prática você pode tirar dezenas de snapshots por dia sem sentir. Neste exato momento minha máquina mantém 23 snapshots do sistema, e o custo é a diferença entre eles, alguns poucos gigas.

### Agendando snapshots

As duas ferramentas clássicas são o **Timeshift** e o **snapper**. O Timeshift é o mais amigável: interface gráfica, você marca "quantos snapshots manter" por hora/dia/semana/mês e ele cuida do resto. Ele espera o layout de subvolumes `@` (raiz) e `@home`, que é o padrão da maioria das distros que instalam em BTRFS hoje. O snapper (nascido no openSUSE) é mais granular: configs por subvolume, timeline automática, integração com o gerenciador de pacotes pra tirar snapshot antes e depois de cada instalação.

```bash
# Timeshift: snapshot manual antes de uma sessão suspeita
sudo timeshift --create --comments "antes de soltar o agente"

# snapper: criar config pro /home e ligar a timeline
sudo snapper -c home create-config /home
sudo systemctl enable --now snapper-timeline.timer
```

Meu setup roda Timeshift agendado, mais o `grub-btrfsd` de plantão (já explico por quê).

### Recuperando arquivos apagados

Aqui está a mágica que todo mundo que perdeu arquivo pra um agente gostaria de ter tido. Snapshot BTRFS é navegável como um diretório comum. O agente apagou seu projeto às 15h? O snapshot das 14h ainda tem tudo:

```bash
# com Timeshift, os snapshots ficam montados em /run/timeshift
sudo ls /run/timeshift/backup/timeshift-btrfs/snapshots/

# achou o snapshot de antes do estrago? copia de volta e pronto
sudo cp -a /run/timeshift/backup/timeshift-btrfs/snapshots/2026-07-11_14-00-01/@home/akitaonrails/Projects/meu-app ~/Projects/
```

Com snapper é a mesma coisa via `.snapshots` dentro do subvolume, e ele ainda tem o `snapper undochange` pra reverter mudanças específicas entre dois snapshots. Recuperação em segundos, sem drama, sem ferramenta forense.

### E se o sistema nem ligar mais?

O caso do goodalexander foi além de perder arquivos: o agente varreu `/var` e `/etc` e o sistema ficou imprestável, precisou reinstalar o OS. Com BTRFS nem isso seria necessário. É pra esse cenário que existe o [grub-btrfs](https://github.com/Antynea/grub-btrfs): um daemon que observa seus snapshots e regenera o menu do GRUB com uma entrada de boot pra cada um.

Sistema não sobe mais? Reinicia, segura o menu do GRUB, escolhe "snapshots" e dá boot direto num snapshot de ontem, read-only. De dentro dele, roda `timeshift --restore`, escolhe o snapshot bom, reinicia de novo. Sistema inteiro de volta ao estado de antes do desastre, em menos tempo do que você levaria pra achar o pendrive de instalação. No pior caso absoluto (o próprio GRUB foi junto), um live USB qualquer monta a partição BTRFS, aponta o subvolume padrão de volta pro snapshot bom e resolve.

## Camada 3: backup externo com restic

Snapshot mora no mesmo disco que os dados. Se o NVMe morrer, morrem os dois juntos. Por isso a outra coisa que eu repito há anos: **todo mundo precisa de backup externo**, seja num HD externo, seja num NAS. Eu uso um Synology na rede local, montado via NFS, e [documentei o setup completo aqui](/2025/04/17/configurando-meu-nas-synology-com-nfs-no-linux/).

Em cima dele roda o [restic](https://restic.net/), que na minha opinião é a melhor ferramenta de backup pra essa finalidade: deduplicação, criptografia, snapshots incrementais e restore simples. Minha configuração real é um script disparado por um timer do systemd todo dia às 3 da manhã. Ele confere se o NAS está montado, faz o backup do `/home` e do `/mnt/data/Projects` pulando caches (`node_modules`, `target/` do Rust, `__pycache__` e afins, tudo num arquivo de excludes), e depois aplica a política de retenção: 7 diários, 4 semanais, 6 mensais, 1 anual.

Reproduzir o essencial é isso aqui:

```bash
# uma vez: criar o repositório no NAS
restic init --repo /mnt/nas/desktop-backup

# todo dia (via cron ou systemd timer):
restic -r /mnt/nas/desktop-backup backup ~ /mnt/data/Projects \
    --exclude-file=~/.config/restic/excludes --exclude-caches

restic -r /mnt/nas/desktop-backup forget \
    --keep-daily 7 --keep-weekly 4 --keep-monthly 6 --keep-yearly 1 --prune
```

E se o dia ruim chegar de verdade (agente destrutivo, disco morto, ransomware, tanto faz a causa):

```bash
# listar os snapshots disponíveis
restic -r /mnt/nas/desktop-backup snapshots

# restaurar um arquivo ou diretório específico
restic -r /mnt/nas/desktop-backup restore latest \
    --target /tmp/recuperado --include /home/akitaonrails/Projects/meu-app

# ou montar o repositório inteiro como filesystem e navegar com calma
restic -r /mnt/nas/desktop-backup mount /mnt/restic
```

Repara na arquitetura em camadas: o snapshot BTRFS resolve o acidente de minutos atrás em segundos. O restic resolve o desastre de dias atrás, incluindo hardware morto. Um agente de IA teria que ser muito dedicado pra atravessar as duas camadas, e mesmo assim ainda existiria a cópia de ontem no NAS, que ele nem alcança.

## E nas empresas? Profissionalismo

Tudo acima é sobre a minha máquina pessoal. Agora sobe o sarrafo: ambiente corporativo.

A regra número um é simples e inegociável: **nenhum agente de IA deve ter acesso a produção. Nunca.** Nem SSH direto em servidor de produção, nem credencial de banco de produção, nem token de admin de serviço em produção. Se o seu agente consegue rodar um `DELETE` na base que atende clientes, o problema deixou de ser a IA faz tempo: qualquer estagiário com o mesmo acesso é a mesma bomba-relógio, só com menos velocidade de digitação.

Agente em **staging**, por outro lado, eu defendo. É pra isso que staging existe. Mas mesmo em staging tem jeito certo: você resiste à tentação de pedir ações one-shot ("roda um `apt install` aí", "dá um `systemctl restart`", "conecta no postgres e executa isso"). Comando avulso executado na mão é conhecimento que evapora. Sua infraestrutura precisa ser automatizada e reproduzível: Ansible, Kubernetes, Terraform, o que fizer sentido pro seu stack. O papel do agente passa a ser escrever e refinar essas receitas, que ficam versionadas em git.

### Um exemplo pequeno, aqui da minha mesa

Eu tenho um ambiente de jogos no meu PC principal, mas eu me recuso a misturar pacote de emulador com meu ambiente de desenvolvimento. Então isolei os jogos dentro de um [distrobox](https://github.com/89luca89/distrobox). Pra quem não conhece: o distrobox cria containers (via podman ou docker) que se integram com seu desktop como se fossem nativos. Compartilham seu home (ou um home dedicado), acesso a GPU, Wayland, áudio. Na prática é uma distro completa dentro da sua distro, com espaço de pacotes separado.

O [distrobox-gaming](https://github.com/akitaonrails/distrobox-gaming) é um repositório de playbooks Ansible que constrói uma box Arch chamada `gaming` do zero: ES-DE de frontend, emuladores standalone (shadPS4, RPCS3, PCSX2, Dolphin, DuckStation, Eden e mais uma dúzia), cores do RetroArch, configs otimizadas por jogo, atalhos no launcher do host. E o [distrobox-llm](https://github.com/akitaonrails/distrobox-llm) faz o mesmo pra uma box de trabalho com LLMs locais: CUDA, cuDNN, Ollama, whisper.cpp e LM Studio isolados numa box com `--nvidia`, enquanto o host só carrega o driver. Upgrade de versão maior do CUDA deixa de chacoalhar meu ambiente de desenvolvimento.

Quem escreveu a esmagadora maioria desses playbooks? Os agentes. Em vez de pedir "instala o RPCS3 pra mim", meu prompt é "escreve a receita Ansible idempotente que instala e configura o RPCS3, roda ela, verifica o resultado e corrige até passar". Olha um trecho real do role que cria a box do LLM:

```yaml
- name: Check if distrobox exists
  ansible.builtin.shell: "distrobox list 2>/dev/null | awk '{print $3}' | grep -qx {{ dl_box_name }}"
  register: _box_exists
  changed_when: false
  failed_when: false

- name: Create distrobox
  ansible.builtin.command: >-
    distrobox create
    --name {{ dl_box_name }}
    --image {{ dl_image }}
    --home {{ dl_box_home }}
    {{ '--nvidia' if dl_nvidia_enabled else '' }}
  when: _box_exists.rc != 0
```

Idempotente: confere se a box existe antes de criar, rodar duas vezes dá no mesmo. Se meu PC pegar fogo amanhã, eu recrio os dois ambientes inteiros com um `ansible-playbook site.yml` em cada repo. O conhecimento está na receita, versionado, auditável. Zero comando perdido no histórico do shell.

### Escalando o mesmo princípio pra produção

Numa empresa, troca distrobox por Kubernetes e o princípio é idêntico. O agente escreve o manifesto, testa no cluster de staging, você promove pra produção manualmente:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: minha-api
spec:
  replicas: 3
  selector:
    matchLabels:
      app: minha-api
  template:
    metadata:
      labels:
        app: minha-api
    spec:
      containers:
        - name: minha-api
          image: registry.exemplo.com/minha-api:v42
          readinessProbe:
            httpGet:
              path: /healthz
              port: 8080
          resources:
            limits:
              memory: 512Mi
```

O fluxo profissional: o agente produz e ajusta o manifesto (ou o chart do Helm, ou o módulo do Terraform), aplica em staging (`kubectl apply -n staging`), roda os testes, observa efeitos colaterais, bugs, comportamento não intencional, e itera até você estar satisfeito. Aí VOCÊ, humano, promove pra produção (via PR revisado num fluxo GitOps, ou um `kubectl apply` manual e consciente), monitorando cada passo. O agente fez todo o trabalho pesado: os artefatos, os procedimentos, os checklists. Dá até pra pedir pra ele gerar a documentação de auditoria no final. Mas o dedo que aperta o botão de produção tem CPF.

### Até o SQL "simples" de manutenção

Um caso que parece inofensivo e me incomoda muito: comando SQL de manutenção em produção. Muita gente sempre rodou esses comandos na mão, direto no client de produção, e agora está pedindo pro agente escrever E executar. Isso é inaceitável, com ou sem IA. Seu sistema deve ter um fluxo de **migrations**: a mudança vira código versionado, roda em staging primeiro, é validada, e só então executa em produção dentro do processo normal de deploy.

E "produção", por definição, significa duas coisas que muita empresa finge ter. Primeiro: backups de verdade, testados, com restore ensaiado.

> Jamais rode em produção qualquer coisa da qual você não consegue se recuperar.

Segundo: monitoramento. Se você não tem visibilidade do estado do sistema, você não tem produção, tem um servidor ligado na tomada e reza.

## Monitoramento: até no meu humilde PC

E monitoramento é tão parte da disciplina que eu aplico até na minha máquina pessoal. Recentemente eu desenvolvi um widget de system health pro meu [clock-tui](https://github.com/akitaonrails/clock-tui) (meu fork mantido do clock-tui original, com widgets de comando no modo relógio). Ele fica aberto num canto mostrando isso aqui:

![Widget de system health do clock-tui: backups restic ok há 19h, 23 snapshots do timeshift, limpeza de dev-cache ok, scrub e trim do btrfs em dia, zero erros de IO, load, memória e uso de storage por filesystem.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/11/agentes-apagando/system-health-widget.webp)

Uma linha de veredito ("all systems healthy") e o estado de tudo que este post descreveu: o backup do restic rodou há 19 horas e o próximo é às 03:03; o Timeshift mantém 23 snapshots; a limpeza de caches de desenvolvimento rodou há 32 horas; o scrub do BTRFS está em dia em cada filesystem, com trim recente, alocação saudável e zero erros de I/O; mais zumbis, load, memória e ocupação de cada disco. O widget (`tclock-system-health`) vem junto no repositório e no pacote do AUR, e detecta a maior parte disso sozinho.

Por trás dele estão as manutenções automatizadas, todas em timers do systemd: o restic diário às 3h; o `dev-cache-clean` (dia 1 e dia 15) varrendo `target/` órfãos de Rust e cache do yay, que juntos devolvem dezenas de gigas; o `btrfs-scrub` mensal por filesystem validando checksums; o `fstrim` semanal. Nada disso exige que eu lembre de nada. Quando algum atrasar ou falhar, o widget muda de cor na minha cara.

## Conclusão: disciplina

Volta nos dois tweets do começo. Em ambos os casos, um único comando errado causou perda real, e a discussão pública virou "em quem eu confio mais". A pergunta certa é outra: **por que um único comando errado, de qualquer origem, tem o poder de causar perda irrecuperável na sua máquina?**

Ser profissional é ser disciplinado, e a disciplina começa em casa. Meu PC pessoal opera com o mesmo rigor que eu cobraria de um ambiente corporativo: filesystem com snapshots leves e agendados, boot recuperável via GRUB, backup externo diário com política de retenção, sandbox pra sessões suspeitas, ambientes isolados e reconstruíveis por receitas versionadas, manutenção automatizada e um monitor que me avisa quando qualquer peça atrasa. Custo de manutenção mensal disso tudo: perto de zero. Foi montado uma vez (em boa parte pelos próprios agentes) e funciona sozinho.

Com essas camadas, a pergunta do título quase perde o sentido. O agente apagou um diretório? Snapshot de uma hora atrás, dois minutos de recuperação. Destruiu o sistema? Boot num snapshot pelo GRUB, restore, dez minutos. Fritou o disco junto? Restic no NAS, backup de ontem. Em cinco meses de YOLO mode eu nunca precisei de nenhuma dessas redes pra acidente de IA. Mas eu durmo tranquilo justamente porque elas estão lá.

LLM rodando solto no seu sistema é só o teste de estresse mais recente da sua disciplina. Se um agente descontrolado consegue causar perda permanente nos seus dados, a vulnerabilidade sempre esteve aí, esperando um erro seu, um disco ruim ou um ransomware. O agente foi só o mensageiro que chegou primeiro.
