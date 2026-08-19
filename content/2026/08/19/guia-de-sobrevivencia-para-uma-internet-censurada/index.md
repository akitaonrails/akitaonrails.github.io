---
title: "Guia de Sobrevivência para uma Internet Censurada"
slug: guia-de-sobrevivencia-para-uma-internet-censurada
date: '2026-08-19T12:00:00-03:00'
draft: false
translationKey: guia-de-sobrevivencia-para-uma-internet-censurada
description: "Do bloqueio do X à majorante de pena pra VPN: o Brasil ensaia censura de verdade. Guia em três fases (VPN comercial, VPN auto-hospedada passo a passo e protocolos ofuscados) pra manter sua comunicação de pé enquanto ainda dá."
tags:
- redes
- seguranca
- leis-e-regulacao
---

Semana passada eu escrevi sobre [a censura ao Discord e a ECA Digital](/2026/08/13/entendendo-a-censura-ao-discord-e-a-eca-digital/): a ANPD mandou desligar o Go Live no país inteiro porque a criptografia de ponta a ponta impede a vigilância do conteúdo, e no mesmo pacote veio a primeira majorante de pena da história pra quem comete crime "usando VPN". Depois daquele artigo, a pergunta que mais recebi foi a óbvia: *"tá, e o que eu faço?"*

Este artigo é a resposta. Não é teoria de conspiração nem exercício de estilo: é um guia prático, do mais fácil ao mais complicado, pra você manter seus canais de comunicação de pé conforme o cerco for fechando. Porque o cerco **está** fechando, e convém entender o ritmo dele antes de escolher suas ferramentas.

## O histórico: nada disso é novo

Quem se surpreendeu com o caso do Discord não estava prestando atenção. O Judiciário brasileiro bloqueia serviços de comunicação há mais de uma década, sempre por cima de milhões de usuários inocentes pra atingir meia dúzia de investigados:

- **WhatsApp, 2015 e 2016**: bloqueado [três vezes por juízes de primeira instância](https://g1.globo.com/tecnologia/noticia/2022/03/18/whatsapp-ja-foi-bloqueado-por-decisao-judicial-em-2015-e-2016-no-brasil.ghtml), sempre porque a empresa não entregava conversas que, por desenho, ela não consegue ler.
- **Telegram, 2022 e 2023**: suspenso [por dois dias por ordem de Moraes em março de 2022](https://www.gazetadopovo.com.br/republica/stf-voltara-a-julgar-bloqueio-do-whatsapp-moraes-ja-suspendeu-telegram/), e de novo por um juiz federal em 2023. O [Migalhas tem a linha do tempo completa](https://www.migalhas.com.br/depeso/414499/stf-alem-do-x-relembre-os-bloqueios-do-whatsapp-e-telegram-no-brasil).
- **X/Twitter, 2024**: o marco. [Suspensão nacional de 30 de agosto a 8 de outubro](https://itforum.com.br/noticias/de-outubro-a-outubro-confronto-x-e-stf/), **40 dias**, por ordem monocrática. E aqui vem o detalhe que importa pra este guia: a decisão incluía [multa de R$ 50 mil por dia pra qualquer pessoa física que acessasse o X por VPN](https://www.gazetadopovo.com.br/mundo/crise-eua-moraes-twitter-files-lei-magnitsky/), ordem pras lojas de app removerem aplicativos de VPN (recuou horas depois), e [PF e Anatel produzindo relatórios sobre quem burlou o bloqueio](https://istoedinheiro.com.br/pf-e-anatel-enviam-ao-stf-relatorios-sobre-acessos-ao-x-mesmo-com-bloqueio) pra subsidiar as multas.

Repare no que aconteceu ali: pela primeira vez, usar uma ferramenta neutra de privacidade virou, por si só, conduta punível no Brasil. Ninguém foi multado no fim das contas, mas a infraestrutura pra multar foi montada, testada e documentada. E em 2026 o Congresso votou e o presidente sancionou a majorante de pena pra crimes cometidos com VPN. O precedente do X deixou de ser exceção e virou repertório.

> **Pra guardar:** no caso do X, o Estado brasileiro já tratou usuário de VPN como infrator, já tentou tirar VPN da loja de apps e já pediu relatório de quem burlou. Não é hipótese. É histórico.

## O destino final: o modelo chinês

Não me resta dúvida de que gente muito bem posicionada no governo olha pra [Grande Muralha da China](https://freedomhouse.org/country/china/freedom-net/2024) com inveja, não com horror. E vale entender o que ela é, porque ela define o limite do jogo.

A Muralha não é um "bloqueio de site". É inspeção profunda de pacotes (DPI) em escala nacional, rodando na espinha dorsal da internet do país: todo tráfego é classificado em tempo real, protocolos de VPN conhecidos são identificados pelo formato do aperto de mão e derrubados, o Tor é bloqueado por padrão, e só VPNs **homologadas pelo Estado** (ou seja, com porta dos fundos) operam legalmente. Cidadão comum pego usando VPN não autorizada toma multa. E mesmo quando o tráfego não pode ser lido, os metadados entregam o jogo: quem fala com quem, quando, por quanto tempo.

Por isso a resposta honesta pra pergunta "dá pra burlar uma Muralha dessas sem ser notado?" é: **não, não pra um cidadão comum**. Contra um firewall estatal desse nível, nenhuma ferramenta doméstica te torna invisível. No máximo te torna caro demais pra valer a pena perseguir em massa. Quem te vender invisibilidade total está mentindo.

A boa notícia é que o Brasil não está nem perto desse ponto. Censura não é um interruptor, é uma escada, e cada degrau tem uma defesa correspondente. O resto deste guia é essa escada, degrau por degrau. A lógica de tudo que vem a seguir é uma só: **censura é uma questão de custo**. Nosso trabalho é deixar o bloqueio caro, tecnicamente e politicamente, até que massificar ele seja impraticável.

## Fase 1: VPN comercial, o mínimo que todo mundo deveria ter

Comece pelo óbvio. Uma VPN (rede privada virtual) cria um túnel criptografado entre o seu dispositivo e um servidor do provedor. Seu provedor de internet passa a ver só um fluxo cifrado indo pra um endereço só; os sites que você acessa veem o IP da VPN, não o seu. Eu explico a fundo, com a teoria de redes por baixo, no [Akitando 126](https://akitaonrails.com/2022/08/29/akitando-126-criando-uma-rede-segura-introducao-a-redes-parte-6-vpn-e-nas/).

O que uma VPN **faz**: esconde seu tráfego do provedor de internet, troca seu IP de saída, te tira de bloqueios geográficos e de bloqueios judiciais por DNS/IP. O que ela **não faz**:

- **Não te torna anônimo.** O provedor da VPN vê todo o seu tráfego no lugar do seu ISP. Você não eliminou o vigia, só trocou de vigia.
- **Não esconde sua identidade se você pagou com cartão.** Assinatura com cartão de crédito amarra a conta de VPN ao seu CPF. Se a autoridade chegar com ordem judicial no provedor, seu nome está lá.
- **Não protege o conteúdo depois do túnel.** Da saída da VPN até o site final vale a criptografia normal da web (HTTPS). A VPN é um trecho do caminho, não o caminho inteiro.

Dito isso, pras fases iniciais do cerco ela resolve. Minhas recomendações, em ordem:

- **[ProtonVPN](https://protonvpn.com/)**: Suíça, fora da jurisdição fácil, código aberto e auditado, política de não guardar registros testada em tribunal, tem plano gratuito decente e aceita pagamento até em dinheiro pelo correio.
- **[Mullvad](https://mullvad.net/)**: Suécia, a mais paranoica do mercado: não pede nem e-mail, sua conta é um número aleatório. Preço fixo de €5/mês, aceita dinheiro vivo num envelope e criptomoeda. É o mais próximo de "VPN sem identidade" que existe em produto comercial.
- NordVPN e similares funcionam tecnicamente, mas o dinheiro delas vai mais pra marketing do que pra postura de privacidade. Entre as grandes, fico com as duas acima.

**O limite dessa fase** é conhecido: os IPs de saída das VPNs famosas são públicos e catalogados. Uma ordem da ANPD ou da Anatel pros provedores nacionais bloquearem esses ranges é tecnicamente trivial, e o caso do X mostrou que remover o app da loja também está no cardápio. Quando (não se) isso acontecer, a VPN comercial morre em um dia. Por isso existe a Fase 2.

> **Pra guardar:** VPN comercial é o cinto de segurança: use sempre, mas saiba que ela depende de três coisas fora do seu controle. O app continuar na loja, os IPs continuarem desbloqueados e o provedor continuar honesto.

## Fase 2: VPN auto-hospedada, seu próprio túnel

A jogada aqui muda de figura: em vez de assinar um serviço com milhões de usuários e IPs catalogados, você aluga um servidorzinho barato fora do Brasil e monta a sua VPN pessoal. Não existe lista pública do seu IP pra censura baixar. Você é um usuário de um IP desconhecido, indistinguível de qualquer outro tráfego até ser analisado de perto.

**Escolha do provedor (e por que não AWS, Azure ou Google Cloud).** As nuvens grandes têm faixas de IP (ASNs) enormes, públicas e mapeadas. Bloquear elas inteiras é uma linha numa tabela de roteamento; o freio é só o dano colateral (muita empresa brasileira legítima está lá), e outros países já pagaram esse preço em situações de crise. Provedores menores diluem esse alvo. Opções que eu consideraria, do médio pro pequeno:

| Provedor | Sede | Por que |
|---|---|---|
| [Hetzner](https://www.hetzner.com/cloud) | Alemanha/Finlândia | Barato, confiável, fora do alcance fácil |
| [OVH](https://www.ovhcloud.com/) / [Scaleway](https://www.scaleway.com/) | França | Idem, jurisdição europeia |
| [Contabo](https://contabo.com/) | Alemanha | Muito barato, perfil baixo |
| [Vultr](https://www.vultr.com/) / [DigitalOcean](https://www.digitalocean.com/) | EUA/global | Médios, conhecidos mas não gigantes |
| [BuyVM](https://my.frantech.ca/), [HostHatch](https://hosthatch.com/), [LiteServer](https://liteserver.nl/) | EUA/Europa | Pequenos, fora de qualquer lista óbvia |

Uma máquina de US$ 3 a 5 por mês, com 1 GB de RAM, sobra pra uma VPN pessoal. **Ressalva importante:** pagar VPS com cartão deixa rastro igual à VPN comercial: seu nome está no cadastro do provedor, e o provedor pode ser compelido judicialmente. Alguns aceitam criptomoeda, o que reduz (não elimina) o rastro. Pra maioria das pessoas, nesta fase, o risco de cadastro é aceitável: você não está se escondendo de uma investigação, está saindo da mira de um bloqueio em massa.

### Passo a passo: WireGuard com wg-easy

Vou usar o [wg-easy](https://github.com/wg-easy/wg-easy), que empacota o WireGuard (o protocolo de VPN moderno, rápido e auditável) num container Docker com painel web e QR code pra configurar o celular em segundos.

**1. Alugue o VPS.** Ubuntu 24.04, a menor máquina disponível, região fora do Brasil (Amsterdã, Frankfurt e Helsinque são escolhas clássicas por jurisdição e latência aceitável).

**2. Acesse e atualize:**

```bash
ssh root@SEU_IP
apt update && apt upgrade -y
```

**3. Instale o Docker:**

```bash
curl -fsSL https://get.docker.com | sh
```

**4. Gere o hash da senha do painel** (o wg-easy não aceita senha em texto puro; anote a senha que você escolher):

```bash
docker run --rm -it ghcr.io/wg-easy/wg-easy wgpw 'SuaSenhaForteAqui'
# a saída é algo como: PASSWORD_HASH=$2b$12$abc...
# no comando abaixo, duplique cada cifrão: $ vira $$
```

**5. Suba o container:**

```bash
docker run -d \
  --name=wg-easy \
  -e WG_HOST=SEU_IP \
  -e PASSWORD_HASH='$$2b$$12$$abc...' \
  -v ~/.wg-easy:/etc/wireguard \
  -p 51820:51820/udp \
  -p 51821:51821/tcp \
  --cap-add=NET_ADMIN \
  --sysctl="net.ipv4.conf.all.src_valid_mark=1" \
  --sysctl="net.ipv4.ip_forward=1" \
  --restart unless-stopped \
  ghcr.io/wg-easy/wg-easy
```

**6. Libere o firewall.** A porta 51820/UDP é o túnel em si. A 51821/TCP é o painel: **não deixe o painel exposto pra internet**. O jeito certo é abri-lo só via túnel SSH (`ssh -L 51821:localhost:51821 root@SEU_IP` e acessar `localhost:51821` no navegador), ou liberar 51821 só pra criar seus clientes e fechar em seguida.

**7. Crie os clientes.** No painel, um clique gera um cliente com QR code. Aponte a câmera do app oficial do WireGuard (Android/iOS) e está pronto. No notebook, baixe o arquivo de configuração e importe no cliente WireGuard.

Pronto: todo o tráfego do seu dispositivo sai pelo seu servidor europeu. Seu provedor brasileiro vê apenas um fluxo cifrado pra um IP qualquer da Alemanha.

### E na sua máquina, como usa?

O servidor é metade da história. No seu dispositivo, o ritual é esse:

**No celular (Android/iOS):** instale o app oficial do [WireGuard](https://www.wireguard.com/install/) pela loja (ou pelo F-Droid, no Android). Toque no **"+"**, escolha "Escanear QR code" e aponte pro código que o painel do wg-easy mostrou. Aparece um "túnel" novo na lista: um toque no interruptor e você está dentro. No iOS, ative o "On-Demand" nas configurações do túnel pra ele religar sozinho quando trocar de rede (Wi-Fi pro 4G, por exemplo).

**No notebook (Windows/macOS):** baixe o cliente oficial do WireGuard pro seu sistema, clique em "Importar túnel de arquivo" e selecione o `.conf` que você baixou do painel. Um clique em "Ativar" e pronto. Detalhe importante: o cliente oficial tem a opção **"Bloquear tráfego fora do túnel"** (o kill switch): ligue ela. Se o túnel cair, sua internet para em vez de vazar pelo IP real.

**No Linux:** copie o `.conf` pra `/etc/wireguard/wg0.conf` e suba com `sudo wg-quick up wg0` (e `sudo systemctl enable wg-quick@wg0` pra subir no boot). Ou importe o arquivo direto no NetworkManager pela interface gráfica, se preferir clicar em vez de digitar.

Um `.conf` de cliente completo, pra referência, é assim:

```ini
[Interface]
PrivateKey = <chave privada DESTE dispositivo>
Address = 10.10.0.2/32
DNS = 1.1.1.1

[Peer]
PublicKey = <chave pública do servidor>
Endpoint = IP_DO_SERVIDOR:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
```

Dois detalhes que valem ouro aqui. O `PersistentKeepalive = 25` mantém o túnel vivo quando você está atrás de NAT (rede doméstica, 4G), evitando que a conexão morra em silêncio. E o `AllowedIPs = 0.0.0.0/0` é o que faz **todo** o tráfego entrar no túnel; sem ele, só o tráfego pros IPs da própria VPN sai criptografado. (A linha `DNS =` funciona bem no Windows, macOS e celular; no Linux com systemd-resolved ela pode atrapalhar, como explico nos erros comuns mais abaixo.)

**Conferindo se funcionou:** com o túnel ativado, rode `curl ifconfig.me` no terminal (ou abra `ipleak.net` no navegador). Tem que aparecer o IP da sua VPS, não o da sua casa. Se a sua rede tiver IPv6, confira separadamente com `curl -4 ifconfig.me` e `curl -6 ifconfig.me`: **os dois** precisam mostrar o servidor. E visite `dnsleaktest.com`: o DNS também tem que sair pelo túnel. Se aparecer o servidor de DNS do seu provedor de internet, tem vazamento pra corrigir.

**Manutenção mínima:** ative `unattended-upgrades` pro sistema se atualizar sozinho, use chave SSH em vez de senha, e não instale mais nada nessa máquina. Superfície pequena, risco pequeno.

### O jeito 2026 de fazer isso: deixe a IA configurar

Se você travou em algum passo, lembre que estamos em 2026: você não precisa mais dominar cada comando desse guia. Eu mesmo fui por esse caminho. Aluguei a VPS, entreguei o acesso SSH pro agente de IA e pedi a configuração completa; do outro lado, na minha máquina, ele importou o `.conf`, subiu o `wg-quick`, ativou no boot e conferiu vazamento no final. Hoje meu servidor é um playbook Ansible reproduzível (derrubou a VPS, sobe outra e roda um comando) e a config do meu notebook segue o mesmo padrão. Tudo em repositórios **privados**, e privados de propósito: configuração de VPN não é o tipo de coisa que eu quero que estranhos fiquem espiando.

E se for pedir pra IA configurar, pula o "me instala uma VPN" genérico e entrega os requisitos de verdade. Algo assim:

```text
Transforme esta VPS Ubuntu 24.04 limpa em um servidor WireGuard robusto,
de preferência via playbook Ansible idempotente (quero poder destruir a
VPS e recriar tudo rodando um comando). Requisitos:

- WireGuard gerenciado por wg-quick@wg0, chave do servidor gerada no
  próprio servidor (permissão 0600), sem painel web exposto
- Túnel dual-stack: IPv4 e IPv6 (subnet ULA fd00::/64 com NAT66), pra
  nenhum tráfego vazar por fora em redes com IPv6 nativo
- ufw negando tudo, exceto SSH e a porta UDP do WireGuard
- sshd somente com chave (sem senha), fail2ban no sshd,
  unattended-upgrades sem reboot automático
- Peers declarados como dados num arquivo de configuração: adicionar
  cliente = adicionar uma entrada e rodar o playbook de novo
- Gere os .conf dos clientes com PersistentKeepalive=25, AllowedIPs em
  full-tunnel e QR code via qrencode
- Ao final, imprima os comandos de verificação (curl -4/-6 ifconfig.me,
  wg show)

No fim, me entregue um README curto de operação: como adicionar cliente,
como atualizar, quando reiniciar.
```

A diferença entre um servidor "funcionando" e um servidor sólido está inteirinha nesses requisitos: dual-stack, firewall fechado, sshd sem senha, peers como dados, reprodutibilidade. A barreira técnica desse artigo inteiro, na prática, virou uma conversa.

### Erros comuns (e como evitar)

Vejo sempre os mesmos tropeços quando alguém monta a primeira VPN própria. Todos evitáveis:

- **Expor o painel do wg-easy pra internet.** O erro clássico número um. O painel é a chave do cofre: aberto na 51821, qualquer scan de botnet acha em horas. Túnel SSH sempre, porta aberta nunca.
- **Senha fraca ou reciclada no painel e no SSH.** A VPN inteira protegida por `123mudar` é pior que não ter VPN. E desligue o login SSH por senha de vez (`PasswordAuthentication no` no `sshd_config`) depois de configurar sua chave.
- **Achar que está anônimo porque o IP é "seu".** A VPS está no seu nome, paga com o seu cartão. Ela te protege de bloqueio em massa, não de investigação com o seu nome nela. Nível de paranoia errado gera falsa sensação de segurança, que é pior que nenhuma.
- **VPS no Brasil ou de empresa brasileira.** Já vi gente montar "VPN de privacidade" em provedor nacional. Se a ordem judicial chega no mesmo país, você não saiu do alcance, só mudou de prateleira. Servidor fora, jurisdição fora.
- **Distribuir acesso pra meio mundo.** Cada pessoa extra é um dispositivo a mais, um padrão de uso a mais, uma boca a mais. Família próxima, ok; grupo de 40 contatos, não. Quanto mais gente no mesmo IP, mais rápido ele entra em alguma lista.
- **Usar a mesma máquina pra outras coisas.** Blog pessoal, bot de Telegram, seedbox: tudo isso aumenta a superfície de ataque e amarra identidades que você queria separadas. VPS da VPN é só da VPN.
- **Confiar sem testar vazamento.** Depois de configurar, teste: `ipleak.net` ou `dnsleaktest.com` com a VPN ligada. Se aparecer seu IP real ou o DNS do seu provedor, algo está errado, e você só descobre assim.
- **Esquecer o IPv6.** Esse pegou até eu: túnel só IPv4 numa rede com IPv6 nativo, e todo o tráfego v6 passa por fora da VPN, às claras, sem você perceber. Ou o túnel é dual-stack, ou metade do seu tráfego vaza. Teste com `curl -6 ifconfig.me`.
- **A linha `DNS =` quebrando o cliente Linux.** Em sistemas com systemd-resolved (Ubuntu, Fedora e afins), o `wg-quick` chama o openresolv pra escrever o DNS, o openresolv se recusa a mexer no `/etc/resolv.conf` que pertence ao systemd-resolved (erro de "signature mismatch") e a interface inteira falha ao subir. Se o DNS do seu sistema já funciona bem, simplesmente remova a linha: as consultas vão pelo túnel de qualquer jeito.
- **Perder a impressora, o NAS e a rede local.** Com `AllowedIPs = 0.0.0.0/0`, até o tráfego pra dentro da sua própria casa tenta ir pelo túnel. A correção é uma regra de policy routing avaliada antes das regras do próprio WireGuard: `PostUp = ip rule add to 192.168.0.0/16 lookup main priority 1000` (e o `PostDown` correspondente pra desfazer ao desligar).
- **Encadear `wg-quick down && up`.** O `down` retorna erro quando a interface já está desligada, e com `&&` o `up` nunca executa. Rode o `up` sozinho.
- **Instalar e abandonar.** Servidor sem atualização por um ano é servidor com vulnerabilidade conhecida. E teste a conexão de tempos em tempos: o que funciona hoje pode estar fingerprintado amanhã.
- **Não ter backup da configuração.** O diretório `~/.wg-easy` guarda tudo (chaves, clientes). Guarde uma cópia criptografada local. Se a VPS morrer ou for desligada pelo provedor, você sobe outra em dez minutos em vez de recomeçar do zero.

> **Pra guardar:** uma VPS de US$ 5 fora do Brasil com WireGuard te tira de qualquer bloqueio em massa por IP catalogado. O preço é o cadastro no provedor: aceitável contra bloqueio, insuficiente contra investigação nominada.

## O inimigo invisível: DPI

Até aqui, assumi que o censor bloqueia **endereços**. O próximo nível dele é bloquear **formatos**, e é aí que mora a inspeção profunda de pacotes (DPI).

Mesmo criptografado, um túnel de VPN tem assinatura. O aperto de mão inicial do WireGuard e do OpenVPN tem tamanhos de pacote, sequências e tempos característicos. O conteúdo é ilegível, mas o formato grita "eu sou uma VPN". A China faz exatamente isso em escala nacional: não precisa ler seu tráfego, basta reconhecer o protocolo e derrubar a conexão.

A resposta técnica é **ofuscação**: fazer o túnel parecer outra coisa.

- **[AmneziaWG](https://amnezia.org/)**: um fork do WireGuard que injeta pacotes de lixo e embaralha os cabeçalhos até a assinatura sumir. Mesma base auditada do WireGuard, app gratuito pra todas as plataformas, e aponta pro mesmo tipo de VPS da Fase 2. Se você montou wg-easy, migrar pra Amnezia é o passo natural quando o DPI chegar.
- **udp2raw**: enfia o tráfego UDP do WireGuard dentro de pacotes TCP falsos, que parecem uma conexão comum.
- **Shadowsocks**: nasceu na China exatamente pra isso, um proxy criptografado desenhado pra não ter assinatura reconhecível.

Repare que ainda estamos falando de ferramentas gratuitas e de uma VPS de US$ 5. O custo sobe pro censor muito mais rápido do que pra você.

## Fase 3: quando nem a sua VPS basta

Se o cenário degradar ao ponto de DPI nacional com bloqueio de protocolos, o jogo vira camuflagem pesada e redundância. As opções reais, em ordem de esforço:

**Protocolos que se disfarçam de HTTPS comum.** O estado da arte hoje é o **VLESS com Reality** (do projeto Xray-core): seu tráfego se apresenta como uma conexão TLS 1.3 legítima pra um site real e inocente, com certificado, aperto de mão e padrão de pacotes indistinguíveis de um acesso normal. Pra bloquear você, o censor teria que bloquear o site inocente junto, e o dano colateral é a defesa. **Trojan-Go** segue filosofia parecida. O **Outline**, da Jigsaw (Google), empacota Shadowsocks com um gerenciador amigável se você quiser distribuir acessos pra família e amigos.

**Tor com pontes (bridges).** O Tor puro é bloqueado por padrão nos países censurados, mas as pontes obfs4 e o Snowflake foram feitos sob medida pra esse cenário: Snowflake mascara sua entrada na rede Tor como uma videochamada comum de WebRTC. É lento, esquece streaming, mas é a rede mais difícil de extinguir que existe, mantida justamente pra jornalista e ativista em país hostil.

**Redundância e rotação.** Duas ou três VPS baratas em provedores diferentes, com failover automático. Se uma cair numa lista negra, você troca em minutos: instância nova, IP novo. Seu custo: mais US$ 5. O custo do censor: descobrir e bloquear de novo, toda vez.

**Acessos alternativos.** Starlink e outros links via satélite saem completamente da infraestrutura terrestre nacional. Enquanto não forem também regulados, são o último recurso físico. E pros casos extremos, a sneakernet de sempre: pendrive, disco externo, cópia física.

**Higiene do lado do cliente**, que vale em todas as fases:

- **Kill switch ligado**: se o túnel cai, o dispositivo corta a internet em vez de vazar pelo IP real.
- **Proteção contra vazamento de DNS**: suas consultas de DNS têm que ir pelo túnel, senão seu provedor continua vendo cada site que você visita.
- **WebRTC desligado no navegador** (ou use extensão): ele vaza seu IP real mesmo com VPN ativa.
- **VPN ligada quando necessário, não sempre**: padrão de uso 24/7 vira ele mesmo uma assinatura comportamental.

E as notas honestas de sempre: rodar seu próprio servidor pra uso pessoal é legal; usá-lo pra cometer crime, não. E a partir de 2026, com a nova majorante, "usando VPN" pesa na pena de qualquer crime que você cometeria de qualquer forma. Mantenha a superfície pequena, teste sua conectividade de dentro do Brasil com regularidade (o que funciona hoje pode ser fingerprint amanhã), tenha plano B (uma segunda VPS, um perfil de Tor com pontes) e mantenha cópias offline de tudo que for crítico.

**Avaliação realista:** nenhuma solução é permanente contra um censor determinado e bem financiado. Não é esse o objetivo. O objetivo é encarecer o bloqueio em massa até ele virar mau negócio, técnica e politicamente. Um país que precisa derrubar metade da internet legítima pra calar meia dúzia de vozes tem um problema de relações públicas, não de tecnologia. É nesse custo que a gente aposta.

> **Pra guardar:** a escada é VPN comercial, depois VPN própria, depois protocolo ofuscado, depois Tor com pontes, depois satélite. Cada degrau sobe pouco o seu custo e muito o do censor. Comece a subir antes de precisar.

## Conclusão

O padrão brasileiro é o que eu chamei de censura por acumulado: nenhum degrau isolado parece o fim do mundo, e cada um vem com sua plaquinha de boa intenção. Mas a infraestrutura de bloqueio, uma vez montada, não tem dono moral: serve pro governo de hoje e pro de amanhã, contra o alvo de hoje e contra você.

A infraestrutura de comunicação livre funciona igualzinho: também se constrói por acumulado, também tijolo por tijolo. Uma VPN comercial configurada hoje. Uma VPS sua amanhã. Um protocolo ofuscado na gaveta pra quando precisar. Nada disso é paranoia, é a mesma lógica de fazer backup antes do disco falhar.

E se você quer acompanhar essa fronteira de perto, uma recomendação pessoal: siga o [Ayub](https://x.com/ayubio). É hoje a melhor fonte em português sobre infraestrutura de internet e censura estatal no Brasil. Foi ele quem [soou o alarme sobre a criminalização de VPNs no PL 3066/2025](https://x.com/ayubio/status/2058990595503509513) meses antes de virar lei. E nos últimos dias ele está cobrindo duas coisas que a grande imprensa mal tocou: a entrega de mais de R$ 100 bilhões em redes públicas, dutos e imóveis da União pras operadoras e pro BTG Pactual, e o aparato técnico da nova regulamentação do Marco Civil, que segundo ele deu à Anatel [acesso remoto aos roteadores de borda dos provedores](https://rendageek.com.br/noticias/marco-civil-da-internet-novas-regras/). Leitura obrigatória pra entender por onde vem o próximo degrau da escada.

A melhor hora de montar o seu túnel era antes de precisar dele. A segunda melhor é agora.
