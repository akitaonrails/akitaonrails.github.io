---
title: "[Discussão] Como proteger nosso trabalho de provedores de DNS sofrendo ataques DDoS?"
date: '2016-10-31T15:00:00-02:00'
slug: discussao-como-proteger-nosso-trabalho-de-provedores-de-dns-sofrendo-ataques-ddos
translationKey: protecting-from-dns-ddos
aliases:
- /2016/10/31/discussion-can-we-protect-our-work-from-dns-providers-suffering-ddos-attacks/
tags:
- security
- ddos
- devops
- whitehat
- traduzido
draft: false
---

Alguns dias atrás testemunhamos um [ataque coordenado de amplificação de DNS](https://dyn.com/blog/dyn-statement-on-10212016-ddos-attack/) contra a Dyn DNS. Tem muito problema no caminho, muita [gente jogando a culpa](https://threatpost.com/mirai-fueled-iot-botnet-behind-ddos-attacks-on-dns-providers/121475/) pra todo lado, e um monte de [possíveis soluções](http://dyn.com/blog/ddos-attacks-bcp38-internet-security-cloudflare-downtime-managed-dns-open-recursives/).

No fim das contas, ataques como esse provavelmente [vão acontecer de novo, cada vez com mais frequência](https://github.com/emc-advanced-dev/unik/wiki/Worried-about-IoT-DDoS%3F-Think-Unikernels). Quanto mais dispositivos online mal administrados (IoT) a gente pluga na rede, quanto mais servidores de DNS recursivos abertos espalhados por aí, e quanto mais blackhats percebem como é fácil rodar ataques desse tipo, pior a coisa fica.

Então, como mitigar esse tipo de problema?

O que eu vou sugerir agora está longe de ser a solução definitiva. Como disclaimer, eu não sou whitehat hacker nem administrador de sistemas totalmente experiente. Se você é, por favor me avise nos comentários abaixo se o que eu estou falando é furada completa ou se realmente funciona do jeito que estou descrevendo.

Eu tenho uma pequena empresa onde trabalham até umas 100 pessoas todo dia, seja como desenvolvedores de software ou no back-office administrativo. A gente precisa acessar uma série de serviços como GitHub, CodeClimate, Google Apps, Dropbox, e vários serviços internos como GitLab, Mattermost e assim por diante.

Quando aconteceu o ataque na DynDNS, tivemos alguns problemas por algumas horas. Mas a gente não apagou totalmente, felizmente.

Alguns dos serviços internos que usamos não foram afetados porque o DNS autoritativo não era a DynDNS. Então nosso chat interno, o Mattermost, por exemplo, continuou respondendo e online. O mesmo vale pro GitLab. Então não paramos todas as nossas atividades de trabalho. Mas alguns dos nossos projetos no GitHub e deploys no Heroku ficaram comprometidos.

Então esse é o plano de mitigação que estou testando: instalar meu próprio servidor de DNS recursivo/forwarder. Eu quero encaminhar todas as queries de DNS para algum DNS recursivo público como o do Google (8.8.8.8) ou o OpenDNS (208.69.38.170) e cachear os resultados por mais tempo do que o TTL que volta da query.

Caso você não saiba, toda vez que você faz um lookup de DNS, ele retorna o endereço de IP para um determinado nome (por exemplo, 50.19.85.154, 50.19.85.156, e 50.19.85.132 para heroku.com) e um **Time To Live** (por exemplo, 28 segundos quando rodei `dig` contra heroku.com).

Isso significa que, dentro daquela janela de 28 segundos, qualquer outro lookup de DNS pode confiar nos endereços de IP fornecidos sem precisar rodar as queries contra os servidores de DNS de novo (caching).

Depois que o TTL expira, eu devo consultar de novo para ver se os endereços de IP mudaram. TTLs normalmente são pequenos para que os administradores dos serviços possam livremente mover e descomissionar servidores ao menos depois de uma certa pequena janela (TTL) e ter certeza que quase todo mundo vai ver os novos endereços de IP quando o TTL expirar. Por outro lado, quanto menor o TTL, mais tráfego de DNS todo mundo precisa gerar ficando re-consultando endereços o tempo todo.

Na prática eu acredito que a maioria dos serviços é estável o bastante para não ficar trocando de servidor o tempo todo. Eles fazem isso eventualmente, por manutenção ou até por questões de escalabilidade, mas acredito que seja "raro".

Na verdade, eu acredito que se eu tivesse meu próprio servidor de DNS, cacheando os resultados de DNS e sobrescrevendo os TTLs de 60 segundos/15 minutos para algo bem maior (digamos, 1 dia inteiro) antes de expirar e exigir uma nova query, a gente teria atravessado aquele episódio de DDoS sem nem perceber.

Aliás, eu manualmente coloquei o endereço web do GitHub no meu arquivo local `/etc/hosts` e consegui navegar no GitHub no meio dos ataques de DDoS.

Para a maioria das pessoas, aquele episódio apocalíptico todo pareceu que "a internet caiu", mas na verdade só os servidores autoritativos da DynDNS caíram e todos os outros DNS recursivos, obedecendo aos TTLs, também falharam em conseguir respostas.

O efeito em cascata é que a gente simplesmente ficou sem conseguir traduzir queries de nomes de domínio como spotify.com ou heroku.com para os seus endereços IP estáticos. Mas se a gente tivesse esses endereços nos caches locais, nem teríamos sentido, porque os servidores do Spotify, do ZenDesk, do Heroku estavam todos online e bem.

É diferente de quando [o data center da AWS em Sydney sofreu uma queda](http://www.theregister.co.uk/2016/06/05/aws_oz_downed_by_weather/). Isso é bem mais raro e eu vi acontecer apenas uma vez a cada par de anos.

### Unbound

Eu ia instalar o BIND9 numa máquina EC2 t2.micro da AWS. Mas li que provavelmente é exagero se eu não estou interessado em montar um servidor autoritativo. Além disso, eu não consigo setar um TTL mínimo no BIND se não me engano.

Então a outra opção mais simples é o [Unbound](http://unbound.net/index.html). Está a um simples `apt-get install unbound` de distância.

A configuração também é super fácil, eu só adicionei isto:

```
server:
  interface: 0.0.0.0
  do-ip4: yes
  do-ip6: yes
  do-udp: yes
  do-tcp: yes
  do-daemonize: yes
  # access-control: 0.0.0.0/0 allow
  access-control: <seu IP público>/8 allow
  access-control: <seu IP público>/8 allow

  # Usar todas as threads (mais ou menos o mesmo número de cores disponíveis)
  num-threads: 4

  # 2^{number_of_threads}
  msg-cache-slabs: 16
  rrset-cache-slabs: 16
  infra-cache-slabs: 16
  key-cache-slabs: 16

  # Mais memória de cache (isso é por thread, se não me engano)
  rrset-cache-size: 150m
  msg-cache-size: 75m

  # Mais conexões de saída
  # Depende do número de threads
  outgoing-range: 206 # <(1024/threads)-50>
  num-queries-per-thread: 128 # <(1024/threads)/2>

  # Buffer de socket maior
  so-rcvbuf: 4m
  so-sndbuf: 4m

  # UDP mais rápido com multithreading (só no Linux)
  so-reuseport: yes

  # cache por pelo menos 1 dia
  cache-min-ttl: 172800

  # cache por no máximo 1.5 dia
  cache-max-ttl: 259200

  # segurança
  hide-identity: yes
  hide-version: yes
  harden-short-bufsize: yes
  harden-large-queries: yes
  harden-glue: yes
  harden-dnssec-stripped: yes
  harden-below-nxdomain: yes
  harden-referral-path: yes
  use-caps-for-id: yes

  use-syslog: yes

  python:
    remote-control:
            control-enable: no

  forward-zone:
    name: "."
    forward-addr: 8.8.8.8
    forward-addr: 8.8.4.4
```

Troque o `<seu IP público>` pelo que aparecer quando você pesquisar "what's my IP" no Google, é melhor fazer whitelist de cada IP que você quer habilitar para consultar esse servidor.

O Unbound já vem pré-configurado para DNSSEC e parece funcionar out of the box (ou pelo menos é isso que [esse teste](https://dnssec.vs.uni-due.de/) diz).

Na minha conta de ISP "enterprise" eu tenho um endereço IP estático e consigo setar o meu Airport Extreme e adicionar o IP do meu novo servidor de DNS e todos os clientes que conectam lá recebem o novo DNS automaticamente.

Na minha conta de ISP barata de backup (o tipico serviço de DSL ou Cable), não tem IP estático então tenho que usar o DHCP e NAT do ISP e habilitar o "Bridge Mode" no roteador. Nesse caso eu não consigo deixar um DHCP secundário ligado para setar o DNS automaticamente nos clientes, então tenho que adicionar manualmente na configuração de rede do meu notebook.

De qualquer forma, uma vantagem imediata de montar meu próprio servidor de DNS é que os tempos de resposta ficam muito mais rápidos já que escolhi um data center bem próximo de mim, geograficamente. Então ao invés dos usuais 60ms do DNS do Google eu tenho menos de 30ms em média agora (não é uma melhora dramática, mas dá pra notar um pouco navegando na web).

A desvantagem é que um DNS recursivo deveria obedecer ao protocolo e usar o TTL autoritativo, sem sobrescrever nunca. Mas como estou usando apenas para IPs em whitelist dentro da minha própria organização, acredito que com um flush manual ocasional, eu devo estar ok na maior parte do tempo.

Isso não é uma garantia 100% de que a gente não vai sofrer nada no caso de outro episódio de DDoS como tivemos, porque nem todos os nomes de domínio vão estar cacheados nesse DNS local. Mas os que a gente mais usa provavelmente vão estar, particularmente serviços essenciais como acesso ao GitHub ou Heroku ou ZenDesk.

Com esse novo sistema de "caching" de DNS todas as minhas queries vão retornar e ser cacheadas com um TTL maior, por exemplo:

```
$ dig heroku.com

; <<>> DiG 9.8.3-P1 <<>> heroku.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 34732
;; flags: qr rd ra; QUERY: 1, ANSWER: 3, AUTHORITY: 0, ADDITIONAL: 0

;; QUESTION SECTION:
;heroku.com.      IN  A

;; ANSWER SECTION:
heroku.com.   172800  IN  A 50.19.85.156
heroku.com.   172800  IN  A 50.19.85.132
heroku.com.   172800  IN  A 50.19.85.154

;; Query time: 357 msec
;; SERVER: xx.xx.xx.xx#53(xx.xx.xx.xx)
;; WHEN: Mon Oct 31 15:07:37 2016
;; MSG SIZE  rcvd: 76
```

Estou ofuscando o IP do meu DNS, claro. O importante é que dá pra ver que meu DNS está retornando um TTL de **172800 segundos** agora. O cache local do meu notebook também deveria manter isso por esse tempo todo.

E agora minha organização deveria (possivelmente) estar protegida contra mais um ataque DDoS de DNS como tivemos com a Dyn DNS. A Zerigo já passou por isso. A SimpleDNS já passou por isso. Quem sabe qual vai sofrer em seguida, talvez todas elas de novo.

Como eu disse antes, eu não tenho 100% de certeza que essa é uma boa mitigação. Vamos ver se funciona no próximo ataque do Mirai. E um **GRANDE DISCLAIMER** final:

> TODO servidor de DNS recursivo TEM que obedecer ao TTL autoritativo!! TTLs existem por várias razões importantes, então se você administra um servidor de DNS publicamente disponível, você NÃO PODE sobrescrever o TTL com um tempo mínimo de cache como eu fiz. Tenha certeza do que você está fazendo!

Você é um whitehat hacker experiente? Me avise se tem algo mais fácil/mais seguro. O objetivo não é consertar a internet, é só proteger a produtividade da minha pequena organização.
