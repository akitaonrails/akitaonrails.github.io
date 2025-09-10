---
title: Acessando meu Home Server com Domínio de Verdade
date: "2025-09-09T17:00:00-03:00"
slug: acessando-meu-home-server-com-dominio-de-verdade
tags:
  - ubuntu
  - servarr
  - docker
  - cloudflare
  - tunnel
  - ssl
  - homeserver
draft: false
---

Agora uma dica avançada que complementa meu artigo sobre meu [Home Server](https://akitaonrails.com/2024/04/03/meu-netflix-pessoal-com-docker-compose/). Em resumo, além do meu desktop PC, que agora roda Omarchy, eu tenho um mini-PC (um simples Intel NUC, não precisa ser muito potente), exclusivamente pra rodar containers Docker.

Eu tenho um bom Synology DS1821+ que também tem suporte pra rodar Docker, mas eu prefiro deixar o NAS somente pra funções de NAS e não arriscar comprometer meus dados com outras coisas rodando nele. Não é um "problema" ter um servidor só que faz tudo, mas já que eu posso, prefiro separar as coisas.

Esse Intel NUC roda um Ubuntu Server LTS headless (sem desktop manager), que eu uso só acessando via SSH (como expliquei no [post anterior sobre SSH](https://akitaonrails.com/2025/09/09/omarchy-2-0-entendendo-ssh-e-yubikeys/)). Nele rodo coisas como Portainer, Plex, Sonarr, Bazarr, qBitTorrent e muito mais.

Da forma como está eu só adicionei uma entrada no `/etc/hosts` do meu desktop assim:

```
192.168.0.100 synology.lan
192.168.0.200 plex.lan
```

**A partir de agora todos os meus domínios e endereços IPs vão ser falsos, obviamente.**

Enfim, dessa forma eu posso abrir meu navegador e entrar em `http://plex.lan:32400` pra acessar meu Plex, por exemplo. Mas isso tem três desvantagens:

1. Só no meu desktop consigo usar esses hostnames, do meu notebook precisaria editar o arquivo hosts também. Além disso preciso saber as portas pra cada container.
2. Não tenho SSL pra nada, então toda autenticação vai em texto aberto. Não é um problema muito grande porque o tráfego é somente interno na minha LAN local. Não tenho acessado de fora de casa.
3. Se por acaso eu quiser acessar de fora, nada disso funciona.

Existem dezenas de formas de resolver esse problema, soluções que envolvem WireGuard, ou soluções comerciais como TailScale ou coisas assim. Mas tem uma solução razoavelmente simples que resolve todos os problemas de uma só vez: **Cloudflare Tunnels**.

A idéia é criar túneis seguros via Cloudflare, pra ter acesso aos meus serviços na minha LAN interna **SEM** precisar expor portas pra fora do meu roteador ou coisas assim. Minha rede permanece isolada e inalterada.

### 1. Registrando Domínio

A primeira recomendação é registrar um domínio de verdade. Fazendo isso é possível ter certificados SSL de verdade que a própria Cloudflare gerencia e renova automaticamente.

![Cloudflare Domain](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-09_16-52-14.png)

Eu tenho alguns domínios registrados e não vou revelar qual uso pro meu Home Server. Vou usar esse vazio **fabioakita.dev** como exemplo só pra este post.

Domínios são baratos, faixa de USD 12 por ano, dependendo do nome que escolher. Escolha um curto e fácil de digitar.

### 2. Instalando Cloudflared

Com o domínio criado, agora precisamos instalar o serviço [**cloudflared**](https://pkg.cloudflare.com/index.html) no Home Server. Ele é quem vai se conectar aos servidores da Cloudflare a abrir o túnel pra dentro do meu servidor local. Clique no link pra instruções de como instalar, mas num Ubuntu Server 22.04 é assim:

```bash
# Add cloudflare gpg key
sudo mkdir -p --mode=0755 /usr/share/keyrings
curl -fsSL https://pkg.cloudflare.com/cloudflare-main.gpg | sudo tee /usr/share/keyrings/cloudflare-main.gpg >/dev/null

# Add this repo to your apt repositories
echo 'deb [signed-by=/usr/share/keyrings/cloudflare-main.gpg] https://pkg.cloudflare.com/cloudflared jammy main' | sudo tee /etc/apt/sources.list.d/cloudflared.list

# install cloudflared
sudo apt-get update && sudo apt-get install cloudflared
```

Agora precisamos fazer login:

```bash
# login
sudo cloudflared tunnel login

# adicione tunel homelab
sudo cloudflared tunnel create homelab

# crie diretório pra configurações
sudo mkdir -p /etc/cloudflared
```

Use as mesmas credenciais que usa pra logar no website da Cloudflare. Se tudo der certo, no final ele vai criar um arquivo em `/root/.cloudflared/xxxxx-yyyy-zzzz...json`, são suas credenciais, assim como uma chave privada SSH, não jogue num pendrive ou num drive de cloud da vida. Guarde muito bem. Vamos mover:

```
sudo mv /root/.cloudflared/*.json /etc/cloudflared
sudo chmod 600 /etc/cloudflared/*.json
```

Finalmente, precisamos criar um arquivo de configurações `/etc/cloudflared/config.yml` com todos os hostnames que queremos pra cada um dos containers, apontando pras portas corretas. Vou dar um trecho de exemplo da minha config, modificado com IPs falsos e o domínio falso:

```yaml
# /etc/cloudflared/config.yml
tunnel: homelab
credentials-file: /etc/cloudflared/xxxx-yyyy-....json
ingress:
  ...
  - hostname: plex.fabioakita.dev
    service: http://192.168.0.254:32400
    originRequest:
      httpHostHeader: plex.fabioakita.dev
  - hostname: immich.fabioakita.dev
    service: http://192.168.0.200:2283
    originRequest:
      httpHostHeader: immich.fabioakita.dev
  - hostname: overseer.fabioakita.dev
    service: http://192.168.0.200:5055
    originRequest:
      httpHostHeader: overseer.fabioakita.dev
  - hostname: syncthing.fabioakita.dev
    service: http://192.168.0.200:8384
    originRequest:
      httpHostHeader: qbittorrent.fabioakita.dev
  - hostname: radarr.fabioakita.dev
    service: http://192.168.0.200:7878
    originRequest:
      httpHostHeader: radarr.fabioakita.dev
  - hostname: sonarr.fabioakita.dev
    service: http://192.168.0.200:8989
    originRequest:
      httpHostHeader: sonarr.fabioakita.dev
  - hostname: bazarr.fabioakita.dev
    service: http://192.168.0.200:6767
    originRequest:
      httpHostHeader: bazarr.fabioakita.dev
  - hostname: prowlarr.fabioakita.dev
    service: http://192.168.0.200:9696
    originRequest:
      httpHostHeader: prowlarr.fabioakita.dev
  - hostname: portainer.fabioakita.dev
    service: http://192.168.0.200:9000
    originRequest:
      httpHostHeader: portainer.fabioakita.dev
  - hostname: grafana.fabioakita.dev
    service: http://192.168.0.200:3001
    originRequest:
      httpHostHeader: grafana.fabioakita.dev
  - service: http_status:404 # this has to be the LAST ONE
```

Como podem ver, é um arquivo extremamente simples. Acho que qualquer um consegue entender o que isso faz. Modifique pras suas próprias necessidades.

Depois de salvar o arquivo e voltar pra linha de comando, precisa manualmente rodar este comando pra cada hostname:

```bash
sudo cloudflared tunnel route dns homelab plex.fabioakita.dev
```

Mas isso é muito trabalhoso, com esse tanto de hostname, achei mais fácil criar um script `/etc/cloudflared/add.sh` assim:

```bash
# run only once
TUN=homelab
CONF=/etc/cloudflared/config.yml
grep -E '^[[:space:]]*-[[:space:]]*hostname:' "$CONF" \
| awk '{print $3}' | tr -d '"' | tr -d "'" \
| while read -r h; do
    echo "adding $h"
    sudo cloudflared tunnel route dns "$TUN" "$h"
  done
```

Agora é só rodar: `sudo sh /etc/cloudflared/add.sh`, **só uma vez!** Então garanta que seu arquivo de config está correto antes!

Finalmente, podemos configurar o serviço pra reiniciar sozinho em todo boot:

```bash
sudo cloudflared --config /etc/cloudflared/config.yml service install

sudo systemctl enable --now cloudflared
```

### 3. Acessando seus serviços via túnel

Se nada deu errado, já acabou! Já pode ir direto pro seu navegador e testar:

![Immich](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-09_17-06-40.png)

Olha só que beleza. Note na barra de URL que digitei `https://immich.fabioakita.dev` e acessou normalmente. Aliás, se não conhecia o [Immich](https://immich.app/) funciona idêntico a um Google Photos, só que sob seu total controle! Tem app pra smartphone e sincroniza bonitinho.

Mais importante, note que está com **HTTPS** que foi provido pelo Cloudflare pro meu domínio inteiro. Quando fizer login, vai ser via **túnel encriptado**. E mais do que isso: mesmo se eu estiver via 5G, fora de casa, no meu celular, vou poder acessar minhas fotos usando esse endereço!

Do meu celular vai abrir um túnel seguro pra Cloudflare, e aquele serviço `cloudflared` no meu home server está também com um túnel seguro aberto pra Cloudflare, daí ele faz uma ponte entre os dois túneis e pronto! Tenho acesso remoto sem abrir meu servidor direto pra internet! O melhor dos dois mundos!

Não se esqueça de configurar todos os seus serviços com senhas fortes (eu gero elas via Bitwarden, mas qualquer um server 1Password, o que for):

![Radarr General Auth Settings](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-09_17-10-15.png)

### 4. Bridge pra vlans

Eu não lembro exatamente o motivo, mas só meu container de Plex deu mais trabalho. Isso porque ele usa uma VLAN diferente das demais. Novamente, não lembro porque fiz isso na época, mas está assim:

```yaml
  plex:
    #image: plexinc/pms-docker:latest
    image: linuxserver/plex:latest
    restart: unless-stopped
    environment:
      - TZ=America/Sao_Paulo
      - PUID=1026
      - PGID=1026
      - VA_DRIVER=IHD
      - PLEX_HW_TRANS_MAX=16
      - PLEX_MEDIA_SERVER_OPTS=--network-host
    volumes:
      - /config:/config
      - /data:/data
      - /transcode:/transcode
      - /Videos:/media
    devices:
      - /dev/dri:/dev/dri
      - /dev/bus/usb:/dev/bus/usb
    healthcheck:
      test: curl --connect-timeout 15 --silent --show-error --fail http://localhost:32400/identity
      interval: 1m00s
      timeout: 15s
      retries: 3
      start_period: 1m00s
    mem_limit: 4g
    cpus: 5.0
    networks:
      plex_macvlan:
        ipv4_address: 192.168.0.254
        mac_address: "xx:xx:xx:xx:xx:xx"

networks:
  plex_macvlan:
    external: true
    name: plex_macvlan
```

Por causa disso o `cloudflared` não consegue rotear pra esse container. A forma de consertar isso é criando uma ponte dessa vlan pra minha ethernet.

```bash
sudo ip link add macvlan0 link enp3s0 type macvlan mode bridge
sudo ip addr add 192.168.0.200/24 dev macvlan0   # free IP in your LAN
sudo ip link set macvlan0 up
```

Obviamente, trocar `enp3s0` pelo nome correto da sua ethernet. Cheque com `ip addr` ou `ip link` por exemplo. Só de rodar os comandos acima, se eu for no navegador e digitar `https://plex.fabioakita.dev` já deve conseguir acessar. Pra tornar isso permanente, precisamos do systemd:

```toml
# /etc/systemd/network/80-macvlan0.netdev
[NetDev]
Name=macvlan0
Kind=macvlan

[MACVLAN]
Mode=bridge
```

```toml
# /etc/systemd/network/80-macvlan0.network
[Match]
Name=macvlan0

[Network]
Address=192.168.0.200/24
Gateway=192.168.0.1
DNS=192.168.0.1
```

E agora, só reiniciar os serviços:

```bash
sudo systemctl restart systemd-networkd
ip addr show macvlan0
```

O "correto" seria meu Plex estar configurado com `network_mode: host`mas, de novo, não lembro porque não estava e não estava a fim de desconfigurar tudo pra descobrir. Caso alguém tenha configurações similares, é assim que bypassa.

Falando em Plex, eu já tinha ouvido falar que tem que tomar cuidado com streaming via cloudflared, não sei se tem limites ou custos extras. Achei [este artigo](https://mythofechelon.co.uk/blog/2024/1/7/how-to-set-up-free-secure-high-quality-remote-access-for-plex) que fala mais sobre isso mas não parei pra ver a fundo. A única coisa que fiz extra, no dashboard da Cloudflare, foi adicionar uma regra pra não fazer **CACHING** do subdomínio `plex`, pra evitar custos adicionais.

### Conclusão

Como podem ver, é extremamente fácil ter um home server, isolar tudo com Docker e depois expor seus containers via túnel seguro pra acessar remotamente. Nada disso significa segurança instantânea. Garanta que seus containers sempre estejam atualizados usando serviços como [Watchtower](https://github.com/containrrr/watchtower), garanta que cada serviço tenha senhas fortes aleatórias e únicas - não use a mesma senha pra tudo. Garanta que seu firewall esteja bem configurado e ativo, mesmo numa LAN.

Muitos routers de Wi-Fi modernos permitem criar uma VLAN separada pra Wi-Fi pra visitas. Assim eles podem usar seu Wi-Fi mas não enxergam seus computadores, que vão estar logicamente isoladas em outra VLAN. Cheque a documentação do seu roteador. Eu uso uma **TP-Link BE1900 Tri-Band Wi-Fi 7**, mas pra maioria das pessoas ela é cara demais e excessiva demais. Pesquise bem. E não adianta ficar me perguntando de outros modelos: eu não testei todos pra saber as diferenças.

Se você viu nomes como Radarr, Sonarr e não sabe o que isso significa, leia o [Wiki do Servarr](https://wiki.servarr.com/) que consolida todas as documentações desses serviços num único lugar. É a infraestrutura que permite você ter sua própria "Netflix Particular".

Também não perguntem porque eu uso Plex e não Jellyfin. É escolha pessoal, escolha o que é melhor pra você. Eu gosto de Plex, já usei Jellyfin, e não pretendo mudar.

Eu odeio a idéia de pagar assinaturas pra tudo e não ter propriedade de nada. Acho dinheiro jogado fora. Eu prefiro **TER** as minhas próprias coisas sob **MEU CONTROLE**. É mais caro, é mais trabalhoso. Conveniência demais significa que você não tem controle de nada e sempre depende dos outros.

Eu odeio depender dos outros.
