---
title: "Bitcoin no Home Server: Soberania e Privacidade com Coldcard, Sparrow e Fulcrum"
date: '2026-04-01T19:00:00-03:00'
draft: false
translationKey: bitcoin-home-server-sovereignty
tags:
  - bitcoin
  - homeserver
  - self-hosting
  - privacy
  - security
  - lightning
---

Este post é complemento direto dos meus artigos recentes sobre o [novo home server com openSUSE MicroOS](/2026/03/31/migrando-meu-home-server-com-claude-code/) e sobre o [Minisforum MS-S1 Max](/2026/03/31/review-minisforum-ms-s1-max-amd-ai-max-395/). Naqueles textos eu falei da base. Aqui eu quero mostrar um uso concreto dela: montar uma stack decente de Bitcoin em casa, com foco em privacidade, soberania operacional e transações seguras do meu lado.

Antes de mais nada: isto aqui não é texto de evangelismo nem chamada pra day trade. Muito pelo contrário. No momento em que escrevo, em 1 de abril de 2026, o Bitcoin está na faixa de US$ 68 mil e perto de R$ 391 mil, abaixo dos picos de 2025. Muita gente olha pra isso e entra em pânico ou começa a fantasiar trade alavancado. Eu acho as duas reações erradas. Existe uma tese de "super cycle" baseada em demanda institucional, ETFs spot e efeito defasado do halving. Pode ser. Pode não ser. O que eu sei é que candle de curto prazo não muda a parte que realmente me interessa: infraestrutura. Se você precisa de alavancagem pra "acelerar ganhos", você provavelmente está só acelerando sua chance de ser liquidado.

Pra mim, a pergunta útil não é "vai subir amanhã?". A pergunta útil é: "se eu quiser guardar e movimentar Bitcoin sem terceirizar tudo pra exchange, wallet web e API pública, como eu monto isso direito aqui em casa?"

## O problema real: conveniência demais custa privacidade demais

O fluxo padrão da maioria das pessoas é simples: compra em exchange, deixa parado lá, ou então instala uma wallet qualquer no celular e pronto. Funciona. Também concentra risco e vaza metadado pra todo lado.

Se você deixa saldo em exchange, você tem risco de custódia. Se você usa wallet desktop apontando pra servidor público, você tem risco de privacidade. Se você usa hardware wallet de forma relaxada, comprada no Mercado Livre de segunda mão, você tem risco de supply chain. Se mistura tudo isso com pressa, pior ainda.

Por isso eu acabei chegando numa combinação que, pra quem é técnico e quer montar a própria infra, me parece bastante sólida:

- Coldcard pro armazenamento frio
- Sparrow Wallet no Linux como carteira desktop e coordenadora das transações
- Fulcrum no home server como servidor Electrum privado
- bitcoind no mesmo servidor como full node de verdade, validando a cadeia e fazendo broadcast sem depender de terceiros

Não é o caminho mais fácil. Mas esse é justamente o ponto. Segurança de verdade raramente vem do caminho mais fácil.

## Os conceitos que confundem quem está começando

Antes de entrar no stack, vale alinhar quatro termos que normalmente são jogados no ar como se todo mundo já soubesse:

| Conceito | O que é | Por que importa |
|---|---|---|
| Airgap | Dispositivo que nunca toca na internet nem por USB de dados | Reduz a superfície de ataque do signer |
| PSBT | Partially Signed Bitcoin Transaction | Formato padrão pra preparar, assinar e finalizar transações em etapas |
| Watch-only wallet | Carteira que enxerga saldo/endereço mas não guarda chave privada | Ótima pra desktop: observa e monta a transação, mas não assina |
| Full node | Nó que valida blocos e regras do protocolo localmente | Você não precisa "acreditar" em API de ninguém |
| Electrum server | Camada de índice que responde rápido consultas de carteira | Sem isso, wallets desktop ficam dependentes de servidores públicos |

Em português claro, o fluxo fica assim:

1. A Sparrow, no desktop, monta a transação.
2. Essa transação vira um PSBT.
3. O PSBT vai pra Coldcard por microSD.
4. A Coldcard assina offline.
5. O arquivo assinado volta pra Sparrow.
6. A Sparrow faz o broadcast via seu próprio servidor, não via infraestrutura pública de terceiros.

É isso que as pessoas querem dizer quando falam em "airgapped workflow". Não é magia. É só separação de papéis feita de forma disciplinada.

## Coldcard: signer frio, offline, chato do jeito certo

Eu uso [Coldcard](https://coldcard.com/) como cold storage. O motivo é simples: ela foi pensada desde o começo como dispositivo Bitcoin-only, com foco forte em operação airgapped por microSD. Isso já elimina uma categoria enorme de "comodidades" que muita gente acha prática, mas que eu prefiro não ter perto das minhas chaves.

[![Coldcard Mk4 no site oficial da Coinkite](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/01/bitcoin-sovereignty/coldcard-mk4-official.png)](https://coldcard.com/mk4)

Na prática, a Coldcard fica com a parte mais importante do sistema: a chave privada. Ela não precisa saber de servidor, de Electrum, de API pública, de exchange, de nada disso. O trabalho dela é um só: assinar transação offline.

Esse desacoplamento é ótimo por dois motivos:

- O desktop pode ser conveniente sem virar ponto único de desastre.
- O signer continua isolado mesmo se sua máquina principal der problema.

E aqui entra um aviso que eu realmente quero deixar em caixa alta mental:

**Nunca compre hardware wallet de segunda mão. Nunca.**

Não é exagero. Você não tem como saber, de verdade, o que aconteceu com aquele dispositivo antes de chegar na sua mão. Pode ter seed pré-gerada, firmware adulterado, componente trocado, embalagem refeita, supply chain comprometida, ou simplesmente algum truque bobo esperando você baixar a guarda. Hardware wallet é uma daquelas categorias em que economizar R$ 300 comprando usado é insanidade. Compre sempre do site oficial do fabricante ou de revendedor oficialmente autorizado pelo fabricante. E mesmo assim confira lacres, procedência e firmware.

## Dá pra fazer parecido com um celular velho?

Dá. Mas eu trataria isso como alternativa de estudo ou de orçamento, não como substituto óbvio de uma Coldcard.

O caminho mais sério hoje pra isso é o [AirGap Vault](https://airgap.it/), que foi justamente desenhado pra usar um smartphone antigo como signer offline, via QR code, mantendo o aparelho fora da rede. A ideia é boa, e pra muita gente pode ser a porta de entrada correta.

Mas tem trade-off:

- smartphone velho não foi desenhado como hardware wallet dedicada
- histórico anterior do aparelho importa
- bateria envelhecida, tela ruim e Android abandonado são problemas reais
- o modelo de ameaça é menos claro do que num dispositivo dedicado

Então minha visão é simples: dá pra usar? Dá. Eu recomendaria como solução principal pra guardar patrimônio relevante? Não. Pra isso eu ainda prefiro hardware dedicado comprado da fonte correta.

## Sparrow Wallet: a melhor peça de desktop desse quebra-cabeça

No Linux, eu uso [Sparrow Wallet](https://sparrowwallet.com/). Pra mim, hoje, ela é uma das melhores peças de software nesse ecossistema.

[![Sparrow Wallet em execução, mostrando o histórico detalhado da carteira e das transações](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/04/01/bitcoin-sovereignty/sparrow-transactions.png)](https://www.sparrowwallet.com/features/)

O que eu gosto nela:

- funciona muito bem em desktop Linux
- suporta hardware wallets direito
- entende PSBT sem drama
- deixa muito claro o que está acontecendo na transação
- é ótima como watch-only wallet

No meu fluxo, a Sparrow faz três coisas:

1. Guarda a carteira watch-only.
2. Monta a transação com os outputs e taxas.
3. Recebe de volta a assinatura da Coldcard e faz o broadcast.

Essa separação é elegante. O desktop vira coordenador. O signer continua frio.

## Por que Coldcard + Sparrow funciona tão bem

Essa combinação é boa porque cada peça faz o que faz melhor:

- a Coldcard protege a chave
- a Sparrow organiza o uso humano da carteira
- o servidor cuida da infraestrutura

Muita wallet tenta fazer tudo. Eu prefiro esse desenho modular. É menos "mágico", mais explícito, e mais fácil de raciocinar sobre ele sem autoengano.

Se eu estou no desktop, eu quero visibilidade. Se eu estou no signer, eu quero isolamento. Se eu estou no servidor, eu quero validação e índice local. Essa divisão é limpa.

## O problema da Sparrow sem infra própria

Agora vem o detalhe importante. A Sparrow sozinha não resolve privacidade.

Se você instalar, abrir e simplesmente usar servidores públicos, alguém do outro lado passa a aprender bastante coisa sobre sua carteira: conjunto de endereços, xpubs ou derivadas, saldo, histórico, comportamento de consulta, broadcast. Não é custódia, mas ainda é exposição.

Esse é o buraco que o Fulcrum preenche.

## Fulcrum: o servidor Electrum privado da casa

[Fulcrum](https://github.com/cculianu/Fulcrum) é um servidor Electrum. Em vez de deixar a Sparrow perguntando coisas pra servidor público de terceiros, ela pergunta pro meu próprio servidor.

Na prática, isso significa:

- consulta de saldo local
- histórico local
- descoberta de endereços local
- broadcast local

Ou seja: a wallet desktop para de "telefonar" pro mundo toda vez que você abre o programa.

No meu setup atual, a Sparrow aponta pra um Fulcrum rodando no home server da LAN, com porta `50001` na rede interna e `50002` com TLS.

## E por que Fulcrum não basta sozinho

Porque Fulcrum não substitui um full node. Ele indexa em cima de um full node.

Quem realmente valida bloco, regra de consenso, script, transação e cadeia é o `bitcoind`. O Fulcrum fica na frente como camada de índice, porque Bitcoin Core puro não foi feito pra servir carteira desktop com esse tipo de consulta rápida.

Então a arquitetura correta é:

```text
Coldcard (offline signer)
        ^
        | microSD / PSBT
        v
Sparrow Wallet (desktop watch-only + coordinator)
        |
        v
Fulcrum (Electrum server privado)
        |
        v
bitcoind (full node)
```

## O que eu subi no home server de verdade

No meu home server, a stack mora numa pasta dedicada do Docker Compose e é composta por dois containers:

- `bitcoin-bitcoind`
- `bitcoin-fulcrum`

O compose é simples. E isso é bom. Infra sensível não ganha nada ficando esperta demais no YAML.

O desenho principal é este:

```yaml
services:
  bitcoin:
    image: lncm/bitcoind:v28.0
    container_name: bitcoin-bitcoind
    user: "${BITCOIN_UID}:${BITCOIN_GID}"
    restart: always
    security_opt:
      - label:disable
    volumes:
      - /srv/bitcoin/data:/data/.bitcoin
    ports:
      - "8333:8333"
    stop_grace_period: 5m
    healthcheck:
      test: ["CMD", "bitcoin-cli", "-datadir=/data/.bitcoin", "ping"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 60s

  fulcrum:
    image: cculianu/fulcrum:latest
    container_name: bitcoin-fulcrum
    restart: always
    security_opt:
      - label:disable
    volumes:
      - /srv/bitcoin/fulcrum:/data
      - /srv/bitcoin/data:/bitcoin:ro
    command: ["Fulcrum", "/data/fulcrum.conf"]
    ports:
      - "50001:50001"
      - "50002:50002"
    depends_on:
      bitcoin:
        condition: service_healthy
```

No meu caso, a restrição do `50001` à LAN acontece na camada de rede do host. O YAML acima é o esqueleto do stack, não a política inteira de firewall.

As partes mais importantes disso:

- `restart: always` porque isso é serviço de longa duração
- volume explícito pra não perder estado
- `user: "${BITCOIN_UID}:${BITCOIN_GID}"` porque o diretório persistente precisa casar com o ownership real do storage, então eu prefiro fixar UID/GID de forma explícita em vez de confiar no default da imagem
- o RPC não é publicado no host; ele fica só na rede interna do Compose, que é tudo o que o Fulcrum precisa
- o healthcheck usa o próprio `.cookie` local do Bitcoin Core, então não precisa espalhar senha fixa em comando
- o Fulcrum monta o datadir do node em leitura apenas para autenticar via `.cookie` sem inventar credencial paralela
- no `fulcrum.conf`, isso vira uma configuração simples: falar com `bitcoin:8332` e ler o `.cookie` montado, em vez de repetir credencial em texto puro
- `security_opt: label:disable` porque neste host com MicroOS, SELinux e bind mounts sensíveis eu preferi a rota pragmática de desarmar esse atrito específico em vez de perder tempo brigando com label em volume que já está sendo tratado de forma controlada
- `depends_on` com `service_healthy` pra o Fulcrum só subir depois que o RPC do bitcoind responder
- `stop_grace_period: 5m` porque bitcoind precisa tempo real pra flushar estado em shutdown gracioso

## A versão final

Hoje, o desenho que eu quero manter é esse: `bitcoind` com `txindex`, `dbcache=1024`, volume persistente, parada graciosa de 5 minutos, autenticação por `.cookie`, e Fulcrum na frente servindo Sparrow pela LAN ou via TLS.

A stack atual está assim:

| Componente | Estado |
|---|---|
| Bitcoin Core | `28.0` |
| Fulcrum | `2.1.0` |
| Stop timeout do container | `300` segundos |
| Data dir do node | volume persistente dedicado montado em `/data/.bitcoin` |
| Rede | `8333` pra P2P, RPC só na rede interna do Compose, `50001/50002` pro Electrum privado |

Não me interessa transformar isso em espetáculo. O ponto é mais simples: a infra final precisa ser chata, previsível e estável.

## Os tunings que importam de verdade

Não tem mágica aqui. Tem alguns parâmetros que fazem diferença real e um monte de coisa que só serve pra enfeitar compose.

O `stop_grace_period: 5m` existe porque bitcoind não é container descartável de stateless API. Ele mantém chainstate, índices e cache em memória. Se você não dá tempo pro processo encerrar direito, você cria trabalho desnecessário no próximo start.

O `user: "${BITCOIN_UID}:${BITCOIN_GID}"` está ali por um motivo bem menos glamouroso e muito mais importante: storage persistente com permissão errada é um jeito excelente de quebrar serviço bom. Então eu prefiro alinhar o container ao ownership real do volume em vez de deixar isso implícito.

O `dbcache=1024` é o ponto que eu acho mais sensato pra node doméstico sempre ligado. Grande o suficiente pra não ficar sofrendo em I/O o tempo todo, pequeno o suficiente pra não transformar cada restart num parto.

O `txindex=1` eu mantenho porque quero o node completo, não uma instalação minimalista só pra dizer que "roda Bitcoin". Se a ideia aqui é autonomia operacional, eu prefiro ter o índice completo.

O `rpcworkqueue=512` e `rpcthreads=16` são o tipo de ajuste que faz sentido quando você sabe que vai colocar Fulcrum perguntando pro node o dia inteiro e quer alguma folga.

No lado do Fulcrum, os parâmetros principais são:

- `db_mem = 8192`
- `db_max_open_files = -1`
- `bitcoind_clients = 8`
- `worker_threads = 0`
- `peering = false`

De novo: nada de esoterismo. Só cache suficiente, paralelismo razoável e nada de anunciar esse servidor como serviço público.

No meu `bitcoin.conf` atual, o núcleo importante ficou assim:

```ini
server=1
txindex=1
prune=0
rpcbind=0.0.0.0
rpcallowip=172.0.0.0/8
rpcthreads=16
rpcworkqueue=512
dbcache=1024
maxmempool=512
```

Tudo isso faz sentido num servidor com RAM decente e NVMe rápido. Mas o detalhe que mais importa continua sendo o shutdown limpo. Infra de wallet não tem espaço pra mentalidade de "depois a gente vê".

## O tamanho real disso tudo

Esse é outro ponto que muita gente subestima.

Se você olhar documentação mais antiga do Bitcoin Core, vai encontrar números como 350 GB de disco para um node com configuração padrão. Isso já ficou pra trás. Dados mais atuais do tamanho da blockchain apontam algo em torno de **725.82 GB em 11 de março de 2026**, e isso é só a cadeia bruta, sem contar os índices extras que muita gente técnica vai querer manter.

E aqui entra a pegadinha: o stack que eu estou descrevendo não é "Bitcoin Core pelado só pra dizer que roda um node". É `bitcoind` com `txindex`, mais Fulcrum, mais margem pra rebuild, logs, snapshots e crescimento normal da rede.

Por isso, pra montar algo parecido hoje, eu pensaria assim:

- abaixo de 1 TB: eu nem começaria
- 1 TB: mínimo pragmático
- 2 TB: faixa confortável
- acima disso: se você quer folga de longo prazo, snapshots e menos ansiedade operacional

E aqui vai a observação mais importante de todas em self-hosting: não assuma que persistência, montagem e backup estão certos só porque o YAML está bonito. Verifique de verdade.

Outra coisa que eu não esqueceria num host com btrfs: colocar o banco do Fulcrum (`fulc2_db`) em subvolume separado. O motivo é bem mundano. Esse diretório cresce, muda o tempo inteiro e não tem nada a ver com snapshot automático genérico de `/var`. Se você mistura tudo, acaba arrastando índice grande e reconstruível junto com snapshot de sistema, queimando espaço e deixando a manutenção mais irritante do que precisava. Índice do Fulcrum não é configuração delicada. É dado pesado, volátil e reconstruível. Eu trato exatamente assim.

## Hardening: o que já deixei aplicado

Aqui é onde aparece a diferença entre "rodou no meu notebook" e "eu confiaria nisso pra operar minha carteira".

No estado atual da stack, os pontos que eu considero importantes ficaram assim:

- o RPC do Bitcoin Core não depende mais de exposição desnecessária no host; o Fulcrum fala com o `bitcoind` pela rede interna do Docker, que é o que interessa de verdade
- `50001` fica restrita ao uso interno da LAN
- `50002` fica disponível com TLS, que é a forma certa quando você precisa sair do plaintext
- o shutdown é gracioso, com `stop_grace_period: 5m`, pra o `bitcoind` ter tempo de flushar estado em vez de morrer de qualquer jeito
- a montagem do storage não fica na base do "depois eu vejo"; existe checagem de mount antes do Docker subir, justamente pra evitar drift silencioso

Cada um desses itens existe por um motivo bem concreto.

Tirar o RPC da superfície do host reduz ataque sem custo nenhum. O Fulcrum já está no mesmo Compose e já consegue falar com o serviço pelo nome interno. Não existe ganho real em deixar essa porta aparecendo onde ela não precisa aparecer.

Separar `50001` e `50002` também ajuda a manter a casa em ordem. Dentro de LAN controlada, plaintext é aceitável. Fora disso, o mínimo razoável é TLS. Misturar os dois cenários costuma virar bagunça.

O `stop_grace_period: 5m` parece detalhe de container, mas não é. Quem já teve banco de dados, índice ou node de blockchain encerrado no tapa sabe o quanto isso vira horas de trabalho depois. Serviço stateful precisa de parada decente.

E a checagem de mount é uma daquelas coisas chatas que salvam você de si mesmo. O YAML pode estar lindo. Se o storage não montou e o serviço subiu gravando onde não devia, você acabou de fabricar um problema bem irritante.

Tem também um ponto que eu gosto bastante nesta versão final do stack: o Fulcrum autentica no `bitcoind` via arquivo `.cookie`, não via senha fixa em texto puro. Isso é interessante por dois motivos:

- você não precisa deixar credencial estática aparecendo em compose, inspect, healthcheck ou documentação
- a autenticação fica mais alinhada com o próprio jeito que o Bitcoin Core já sabe operar localmente

Em termos práticos, isso reduz vazamento acidental de segredo operacional. Não é uma solução mágica pra tudo, mas é muito melhor do que espalhar `rpcuser` e `rpcpassword` em arquivo, log e comando.

O único tipo de hardening que eu tento evitar aqui é o hardening performático demais no YAML e frouxo demais na operação. Eu prefiro menos "engenharia de palco" e mais disciplina básica:

- rede mínima
- segredo mínimo
- privilégio mínimo
- shutdown limpo
- storage verificado
- subvolume separado pra dado grande e reconstruível, como o índice do Fulcrum

E, de novo, documente tudo. Infra boa não é a que só funciona hoje. É a que continua funcionando quando você volta nela seis meses depois.

## Por que isso melhora transações do seu lado

Quando eu monto uma transação na Sparrow e assino na Coldcard, a cadeia de confiança fica muito melhor definida:

- a chave privada não toca internet
- a wallet desktop não precisa confiar em servidor público
- o broadcast pode sair do meu próprio node
- o histórico de endereços não precisa ir parar em Electrum server de terceiro

Isso não torna nada invulnerável. Ainda existe risco de malware no desktop, seed mal armazenada, erro humano, engenharia social e desastre físico. Mas o desenho fica bem mais coerente.

## E o Lightning? Especialmente no Brasil?

Aí eu separo as coisas.

Reserva e transação de valor maior eu trato de um jeito. Gasto cotidiano eu trato de outro.

Pra gasto cotidiano, especialmente no Brasil, eu acho burrice operacional carregar muito saldo em wallet quente. Wallet de Lightning e app de gasto têm que ser quase "carteira de bolso": só o suficiente pro dia a dia.

Isso vale em dobro se você usar solução híbrida ou custodial, como [RedotPay](https://www.redotpay.com/). Eu entendo por que ela é interessante pra brasileiro: empresa de Hong Kong, foco internacional, bridge razoavelmente prática entre cripto e gasto com cartão. Pra viagens, compra online e vida fora do eixo bancário brasileiro, faz sentido. Mas eu jamais trataria isso como lugar de guardar patrimônio. Isso é ferramenta de spending, não cofre.

Mesma lógica pro [Bitrefill Brasil](https://www.bitrefill.com/br/pt/). Eu acho o serviço interessante justamente porque ele resolve uma dor real no Brasil: transformar sats em utilidade concreta sem vender toda posição nem depender de integração bancária o tempo todo. Gift card, recarga, pequenas despesas. Como ferramenta de uso, faz bastante sentido.

Pra wallet Lightning no celular, eu olharia primeiro para:

- [Phoenix](https://phoenix.acinq.co/) pra quem quer algo muito bom e simples
- [Breez](https://breez.technology/) pra quem quer experiência boa de pagamentos
- [ZEUS](https://zeusln.com/) se você é mais técnico e eventualmente pretende operar seu próprio node Lightning

Todas elas, na minha cabeça, entram na categoria "carteira de bolso". Saldo pequeno. Uso diário. Nada de transformar app de celular em cofre de aposentadoria.

## Notícias recentes que reforçam esse raciocínio

Eu não monto esse tipo de stack porque acho bonito. Eu monto porque terceirização demais dá ruim com frequência demais.

Dois exemplos recentes:

- o [hack da Bybit em 2025](https://www.cnbc.com/2025/02/21/hackers-steal-1point5-billion-from-exchange-bybit-biggest-crypto-heist.html) mostrou, de novo, o risco básico de deixar custódia relevante em exchange
- o [vazamento de dados de clientes da Coinbase em 2025](https://techcrunch.com/2025/05/15/coinbase-says-customers-personal-information-stolen-in-data-breach/) mostrou o outro lado do problema: mesmo quando a custódia não é o foco imediato, sua identidade, saldo e histórico viram superfície de ataque

Uma stack como Coldcard + Sparrow + Fulcrum + full node não elimina todo risco do mundo. Mas evita duas classes de problema bem reais:

- perder soberania de custódia
- entregar privacidade de carteira e transação de bandeja pra terceiros

## Então vale a pena?

Pra maioria das pessoas, honestamente, provavelmente não no primeiro mês. É trabalhoso, tem curva de aprendizado, e exige disciplina.

Mas pra programador, engenheiro e qualquer pessoa técnica que quer aprender a não depender sempre de serviço alheio, eu acho um exercício excelente.

Você aprende sobre:

- separação de responsabilidades
- persistência e estado
- shutdown gracioso
- observabilidade
- isolamento de segredo
- trade-off entre conveniência e segurança

E tudo isso vale além de Bitcoin.

No fim das contas, é isso que mais me interessa nesse stack. Não é sair pregando "hyperbitcoinization" nem posar de profeta de preço. É montar um sistema em casa em que eu consigo confiar mais porque fui eu que instalei, medi, quebrei, consertei e documentei.

Dá trabalho? Dá.

Mas esse tipo de trabalho ensina exatamente o que software moderno tenta fazer você esquecer: depender menos dos outros dá mais trabalho no começo, mas costuma comprar muito mais controle no longo prazo.
