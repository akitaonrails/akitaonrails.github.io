---
title: "Davi e Golias digital: Entendendo MegaLag vs Honey/Paypal"
slug: davi-e-golias-digital-entendendo-megalag-vs-honey-paypal
date: '2026-08-12T11:00:00-03:00'
draft: false
translationKey: davi-e-golias-digital-entendendo-megalag-vs-honey-paypal
description: "O Honey roubou comissões de criadores por anos com um defeat device em JSON puro. Explico o ssd.json linha por linha, a reescrita sob o PayPal e a ação coletiva que o PayPal não conseguiu derrubar."
tags:
- seguranca
- mercado-de-tecnologia
---

Quem vive de criar conteúdo na internet sabe: comissão de afiliado paga conta. Você testa um produto, grava o review, coloca o link na descrição. Alguém assiste, clica, compra dias depois, e uma fatia da venda pinga na sua conta. Foi assim que boa parte do YouTube independente se financiou na última década.

Agora imagina descobrir que um dos seus patrocinadores estava plantado no checkout dos seus espectadores, trocando a sua etiqueta pela dele e embolsando essas comissões. Milhões de vezes. Por anos.

Foi isso que o MegaLag mostrou em dezembro de 2024, expondo as práticas do Honey, aquela extensão de cupons que o PayPal comprou por 4 bilhões de dólares e que prometia *"achar todos os cupons de desconto da internet"* pra você. Eu acompanho o canal dele desde esse vídeo e virei fã na hora: é jornalismo técnico com demonstração ao vivo, código e packet capture, não só denúncia no grito.

Um ano e meio depois, a história só engrossou: o PayPal tentou descartar tudo como fake news, o MegaLag voltou com evidência técnica irrefutável, a Rakuten e outras redes de afiliados cortaram o Honey publicamente, e o caso virou uma ação coletiva que acabou de sobreviver ao pedido de extinção (o *motion to dismiss* americano).

{{< youtube id="vc4yL3YTwWk" >}}

A linha do tempo dos vídeos, que são as fontes primárias deste artigo:

1. [Exposing the Honey Influencer Scam](https://www.youtube.com/watch?v=vc4yL3YTwWk), 21 de dezembro de 2024
2. [Exposing Honey's Evil Business Model (PART 2)](https://www.youtube.com/watch?v=wwB3FmbcC88), 22 de dezembro de 2025
3. [The Honey Scam is Worse Than I Thought](https://www.youtube.com/watch?v=qCGT_CKGgFE), 30 de dezembro de 2025
4. [Honey Gets Terminated as Lawsuits Proceed](https://www.youtube.com/watch?v=EXDemfGNGz0), 11 de agosto de 2026 (ontem)

Vou contar a história em três atos: o truque do último clique contra os criadores, o modelo de extorsão contra as lojas, e o dispositivo de fraude que enganava os auditores das redes. O miolo técnico, o que interessa pra nós desenvolvedores, está no terceiro ato. Mas sem os dois primeiros ele não faz sentido.

## O que o Honey deveria ser

O pitch pro consumidor era irresistível: uma extensão gratuita que, na hora do checkout, testa todos os cupons de desconto conhecidos e aplica o melhor no seu carrinho. *"É literalmente dinheiro de graça."* E não, eles juravam, não vendiam seus dados.

Pra criadores de conteúdo, o Honey era um patrocinador generoso. O MegaLag mapeou cerca de 5.000 vídeos patrocinados em mais de 1.000 canais, somando quase 8 bilhões de views. O MrBeast foi o primeiro grande nome, e a ex-presidente do Honey, Joanne Bradford, se gabava: *"todo garoto nos EUA conhece o Honey"*.

Criador ganhava dinheiro fácil recomendando uma ferramenta que parecia útil. A ironia, que o primeiro vídeo expõe com requinte: esses mesmos criadores estavam instalando no público deles, o público que mais clicava nos links de afiliado deles, a ferramenta que roubava essas mesmas comissões.

Pra lojas e marketplaces, o Honey se vendia como ferramenta de conversão: menos carrinho abandonado, ticket médio maior. E tinha um pitch extra, mais escuso, que aparece no FAQ de parceiros e num podcast do próprio Honey: a loja controlava quais cupons ficavam visíveis. Ou seja, pro consumidor o discurso era *"achamos todos os cupons"*, e pra loja era *"você impede o consumidor de achar os cupons bons"*. Os dois discursos eram oficiais.

## Afiliados em 30 segundos

Pra entender o crime, precisa entender a vítima. Marketing de afiliados funciona assim: um criador coloca um link com uma tag de rastreamento (tipo `?tag=shortcircuit` num link da Newegg). Você clica, a loja grava um cookie com validade de uns 30 dias, e se você comprar qualquer coisa nesse período, a comissão vai pra quem gerou aquele clique.

O MegaLag tem uma analogia boa pra isso: é como o vendedor de uma loja de departamentos que te atende, te dá um cartão de indicação com o nome dele, e o caixa sabe de quem foi a venda. O cookie de afiliado é a versão digital desse cartão.

O padrão da indústria é o **last-click attribution**: o último clique leva tudo. Não é o sistema mais justo do mundo, mas é o mais simples de implementar. E é aqui que mora o problema: quem aparece no último segundo antes do pagamento sempre vence. E quem aparece no último segundo? Uma extensão instalada no seu navegador, que acorda exatamente na tela de checkout. É como se um segundo vendedor, que não te atendeu em momento nenhum, arrancasse o cartão da sua mão na fila do caixa e entregasse o dele no lugar.

## O que o Honey realmente fazia

O primeiro vídeo documenta os cenários, todos variações do mesmo truque:

- **O popup de cupom**: você clica em "aplicar descontos", o Honey abre uma aba minúscula e escondida que simula um clique de afiliado com a tag do PayPal, e fecha sozinha. Seu cookie do criador é substituído. Comissão roubada, mesmo quando o Honey não acha cupom nenhum.
- **O Honey Gold**: quando não existe cupom, aparece um popup oferecendo pontos de cashback. Clicou, mesma coisa: último clique, comissão do PayPal.
- **O popup vazio**: sem cupom, sem cashback, o Honey ainda abre um popup pra você clicar em "got it". Clicou pra dispensar? Já era, o clique valeu.
- **O botão PayPal**: num checkout que já tem opção de pagar com PayPal, o Honey oferece um botão "check out with PayPal". Qualquer desculpa vale pra conseguir o último clique.

O experimento que o MegaLag fez com a NordVPN deixa tudo concreto: comissão de 40% por venda. Duas compras feitas pelo próprio link de afiliado dele. Sem o Honey: $35 de comissão. Com o Honey Gold ativado: $0. A parte dele, como "consumidor", do roubo da própria comissão? 89 pontos, ou seja, **89 centavos de dólar**. O Honey ficou com 97,5% do valor que era dele por direito.

> **Pra guardar:** mesmo quando você clica no link de afiliado do criador, a comissão vai pro PayPal se o Honey aparecer no checkout. No teste da NordVPN, dos $35 de comissão, o "benefício" que sobrou pro usuário foi 89 centavos.

E isso não era hipótese, acontecia em escala industrial. O exemplo central do primeiro vídeo usa a tag de afiliado do Linus Tech Tips na Newegg: o Linus Media Group promoveu o Honey por anos, em algo como 160 segmentos patrocinados, e encerrou a parceria em 2022 ao perceber que o Honey sobrescrevia o link de afiliado deles *mesmo quando não encontrava desconto nenhum*. Repare na armadilha demográfica: quem instala extensão de cupom é exatamente o espectador que caça preço e clica em link de afiliado. O Honey pagava o patrocínio uma vez e passava a taxar as comissões futuras do criador pra sempre.

{{< youtube id="wwB3FmbcC88" >}}

Até aqui, a vítima era o criador. O segundo vídeo mostra o outro lado do balcão: as lojas.

## O modelo de negócio contra as lojas

O arquivo `supported domains` da extensão listava mais de 180.000 lojas, contra "30.000 participantes" no marketing. A análise da planilha (um desenvolvedor rastreou tudo e publicou) mostrava 146.000 lojas sem nenhum vínculo, incluídas presumivelmente sem consentimento.

Tem mais: cupom digitado manualmente no checkout era enviado pros servidores do Honey *antes* de pedir consentimento. E códigos privados vazavam pra base pública: desconto militar, cupom de funcionário, um código de $75 sem valor mínimo que dava mercadoria de graça ilimitada.

O estrago era mensurável. Um lojista relatou prejuízo de $100 mil depois que o código exclusivo do podcast que ele patrocinava vazou pra base do Honey, e ele só percebeu meses depois, quando a comissão de afiliado do podcast já tinha ido embora faz tempo. O Chip, CEO da Made In Cookware, resumiu o efeito: *"se o Honey vai ficar com 10% da sua receita o tempo todo, no fim das contas você é obrigado a subir os preços."*

E quando um lojista pedia pra sair, a resposta oficial era *"não removemos códigos sem um relacionamento comercial"*, o que o MegaLag chama, com precisão, de extorsão econômica: **as lojas não pagam pra entrar, pagam pra sair**.

## Stand down: a regra que o Honey fingia cumprir

Contra tudo isso, a defesa do PayPal sempre foi a mesma: *"o Honey segue as regras e práticas da indústria, incluindo o last-click"*. Era uma saída retórica esperta, porque dá pra discutir se o last-click é justo. O que vem a seguir é diferente em natureza: prova de que o Honey sabia que estava errando e construiu um sistema pra não ser pego.

Pra entender, um pouco de contexto. As redes de afiliados (Rakuten Advertising, CJ, Impact, Awin) sabem desde 2002 que extensões de navegador são parasitas naturais desse ecossistema. Então criaram uma regra contratual chamada **stand down**: se o usuário já chegou à loja pelo link de outro afiliado, a extensão deve se desativar e não interferir. Ponto. Está escrito nos contratos. A política da Rakuten, por exemplo, diz que o publisher deve *"se retirar e não exibir nenhuma forma de slider ou popup"* quando outro afiliado já referenciou o usuário, e *"não pode forçar cliques nem fazer cookie stuffing"*.

E o Honey cumpria. Tecnicamente. Quando testado.

Aqui chegamos no coração do terceiro vídeo, o que o MegaLag chama de Cookie Gate, e a analogia que ele usa é precisa: o Dieselgate da Volkswagen. A VW programava os carros pra reduzir emissões só durante os testes de laboratório. O Honey programava a extensão pra respeitar o stand down só quando detectava que o usuário provavelmente era um auditor.

> **Pra guardar:** stand down é obrigação contratual desde 2002, não cortesia. Se o usuário chegou à loja pelo link de outro afiliado, a extensão tem que se retirar. O Honey se retirava só quando o usuário cheirava a auditor.

## A evidência: ssd.json, linha por linha

Depois que o PayPal comprou o Honey, a extensão foi reescrita e as regras passaram a vir em texto claro de um servidor. Isso permitiu ao MegaLag, e ao Ben Edelman, pesquisador de segurança que trabalhou no caso de fraude de afiliados do eBay nos anos 2000 e verificou tudo independentemente ([análise completa dele aqui](https://www.benedelman.org/honey-detecting-testers/)), expor o mecanismo inteiro.

Primeiro ponto arquitetural: **as regras de stand down moram na nuvem, não na extensão**. A extensão busca dois arquivos JSON dos servidores do Honey e verifica atualizações a cada hora: `standdown-rules.json` (as regras normais) e `ssd.json` (as regras de *selective stand down*). Ou seja: o PayPal podia mudar o comportamento de ~14 milhões de usuários em uma hora, sem atualização de extensão, sem revisão da Chrome Web Store, sem ninguém ver.

Segundo: as regras normais já eram uma piada. O temporizador de stand down, o tempo em que o Honey respeita o cookie do afiliado original, era de 3.600 segundos. Uma hora. Clicou no link do seu YouTuber favorito de manhã, comprou à tarde, o Honey já podia agir de novo. E um arquivamento de 2023 da Wayback Machine mostra que já foi de **360 segundos. Seis minutos**. Como o MegaLag diz, ele leva mais de seis minutos só pra digitar o cartão de crédito. Nenhuma rede de afiliados define prazo de expiração. O Honey inventou um.

Terceiro, o prato principal. Este é o `ssd.json` capturado em 22 de outubro de 2025 (comentários meus):

```json
{"ssd": {
  "base": {
    "gca": 1,      // checar cookie de console de afiliados
    "bl": 1,       // checar blacklist no servidor
    "uP": 65000,   // mínimo de pontos pra IGNORAR o stand down
    "adb": 26298469858850
  },
  // domínios onde procurar cookies de "insider da indústria":
  "affiliates": ["https://www.cj.com", "https://www.linkshare",
                 "https://www.rakuten.com", "https://ui.awin.com",
                 "https://www.swagbucks.com"],
  "LS": { "uP": 5001 },  // exceção pra Rakuten (antiga LinkShare)
  "PAYPAL": { "uL": 1, "uP": 5000001, "adb": 26298469858850 }
  },
  "ex": {  // exceções por loja (IDs internos do Honey)
    "7555272277853494990": { "uP": 5001 },                         // TJ Maxx
    "7394089402903213168": { "uL": 1, "adb": 120000, "uP": 1001 }, // Booking.com
    "243862338372998182": { "uL": 0, "uP": 100000 },               // Kayo Sports
    // cookies procurados, na MESMA ORDEM dos domínios acima:
    "GA": ["CONTID", "s_vi", "_ga", "networkGroup", "_gid"]
  }
}
```

Vamos decodificar. Quando a extensão detecta que você clicou num link de afiliado, ela consulta essas regras antes de decidir se obedece o stand down:

- **`uL`** (user logged in): você precisa estar logado numa conta Honey.
- **`uA`** (user account age): sua conta precisa ter uma idade mínima, 30 dias, em milissegundos, *"por algum motivo"*, como nota o MegaLag. Conta nova é o padrão de quem testa extensão pra auditoria.
- **`uP`** (user points): você precisa ter acumulado um mínimo de pontos de cashback. Na configuração atual: 65.000 pontos. Como 1.000 pontos valem $10 em vale-compras, isso exige $650 de ganho acumulado, praticamente nenhum usuário real, e com certeza nenhum auditor com conta de teste.
- **`bl`** (blacklist): o servidor pode marcar seu ID, cookie ou IP (quem já reclamou do Honey, por exemplo) e te tratar como "alto risco".
- **`gca`**: a mais incriminadora de todas, e merece parágrafo próprio.

Se você passa em todos os filtros, o sistema te classifica como consumidor legítimo e o Honey **ignora o stand down**, rouba a comissão. Se falha em qualquer um, te classifica como possível auditor e o Honey se comporta direitinho. O Edelman resume: *"o Honey respeita o stand down, mas só às vezes. E esse 'às vezes' é previsível."* Determinístico, na verdade: mesmas condições, mesmo resultado, reproduzível.

### O gca: procurando cookie de auditor

O `gca` é o equivalente a revistar seu bolso procurando crachá de fiscal. As listas `affiliates` e `GA` são pareadas posicionalmente: no domínio `cj.com`, procure o cookie `CONTID`; no `linkshare`, o `s_vi`; no `ui.awin.com`, o `networkGroup`. O código, recuperado via `sourceMappingURL` do app iOS que vazou praticamente sem ofuscação:

```javascript
m = p.ex && p.ex.GA || []
g = i().map(p.ssd && p.ssd.affiliates, (function(e) {
    return f += 1, u.A.get({
        name: m[f], // nome do cookie vindo do array GA
        url: e      // domínio a ser verificado
    }).then((function(e) {
        e && (o.gca = 0) // achou o cookie: gca = 0, entra em modo compliance
    }))
```

Se você tem cookie de login do painel de afiliados da CJ, da Rakuten ou da Awin, ou seja, se você trabalha na indústria, o Honey respeita o stand down em tudo, sempre, não importa o link. O MegaLag descobriu isso por acidente, testando a própria extensão que ele construiu (a Cookie Guard): logou na conta de afiliado dele da CJ numa aba, e de repente o Honey virou um anjo.

E tem um detalhe cínico no design: domínios e nomes de cookie ficam em duas listas separadas em vez de pares nome-valor. Como nota o Edelman, o efeito é dificultar que alguém olhando o arquivo perceba a relação entre eles.

O Edelman é categórico sobre o que isso significa: não existe nenhuma razão legítima pra uma extensão de cupons verificar se você logou num painel de afiliados. A única função é se esconder de quem fiscaliza. E quem se esconde sabe que está fazendo algo proibido.

### Os outros truques: email "test", killswitch e eBay

Tem mais duas pérolas no código. A extensão escaneia seu endereço de email procurando a palavra "test". Achou, modo compliance:

```javascript
if (r.email && r.email.match("test") && (o.bl = 0), !r.isLoggedIn || t) {
```

E existe um killswitch mestre no servidor: a extensão consulta periodicamente uma URL, e dependendo da resposta o sistema SSD inteiro liga ou desliga:

```javascript
return e.next = 7, fetch("".concat("https://s.joinhoney.com", "/ck/alive"));
```

```javascript
c = S().then((function(e) {
    e && "alive" === e.is && (o.bl = 0)
}))
```

Um flip no servidor e 14 milhões de extensões entram em modo compliance instantaneamente. Útil, por exemplo, no dia em que uma auditoria grande for anunciada.

E o eBay? O eBay tem tratamento VIP, direto no código: enquanto o stand down normal dura uma hora, o do eBay dura 86.400 segundos (24 horas), e a lógica SSD é explicitamente desativada pra domínios eBay:

```javascript
"regex": "^https?\\:\\/\\/rover\\.ebay((?![\\?\\&]pub=5575133559).)*$",
"provider": "LS",
"overrideBl": true,
"ttl": 86400
```

```javascript
a = "ssd" === r && !/ebay/.test(p);
```

Por quê? Porque em 2008 o eBay processou civil e criminalmente seus dois maiores afiliados, Shawn Hogan e Brian Dunning, que receberam mais de $20 milhões em 18 meses com esquemas de cookie stuffing, e os dois foram presos. O próprio Edelman ajudou a pegá-los. O Honey sabia exatamente com quem não devia brincar. Todo o resto do mercado, aparentemente, era presa fácil.

### A telemetria: a prova que se autodocumenta

A parte que me deixou de queixo caído: desde o primeiro dia, o defeat device (o "dispositivo de fraude", no jargão do Dieselgate) **registrava cada decisão que tomava**. Quando a extensão decide respeitar o stand down, ela manda telemetria com `"method":"suspend"` e um `state` dizendo exatamente qual regra disparou, `"uP:5001"`, `"gca"`, `"ssd"`, junto com o link de afiliado original, que frequentemente contém o ID e às vezes o nome do afiliado prejudicado.

Em algum lugar nos servidores do PayPal existe um registro detalhado de cada comissão que esse sistema ajudou a roubar. O MegaLag fecha o quarto vídeo pedindo que as redes exijam esses dados e cobrem o reembolso. É difícil discordar.

### Como o MegaLag provou na extensão pública

Um detalhe de engenharia que merece respeito. Depois do primeiro vídeo, o PayPal subiu o limiar base pra 65.000 pontos, na prática desativando o mecanismo pra quase todo mundo e limitando o comportamento suspeito. Só que quem editou o `ssd.json` esqueceu a exceção da Rakuten: `"LS": {"uP": 5001}`.

O MegaLag fez o que ele chama de *"uma maratona de compras dolorosamente cara"* até passar de 5.000 pontos e reproduziu a fraude na extensão pública, intacta, sem modificar uma linha. (O Edelman fez mais simples: interceptou a resposta do servidor com o Fiddler e mentiu o próprio saldo de pontos. O código dele está no artigo linkado acima.)

## A reescrita do PayPal

A genealogia do sistema, reconstruída pelo MegaLag com ~300 builds arquivados da extensão desde 2014:

- **Outubro de 2017**: o SSD aparece pela primeira vez, na versão 10.5.2, ainda sob os fundadores Ryan Hudson e George Ruan, mas criptografado, embaralhado, ilegível pra quem encontrasse. O pesquisador Wladimir Palant já tinha documentado em 2020 que o Honey escondia trechos do próprio código.
- **Março de 2021**: sob o PayPal, versão 13.1.0, **o sistema inteiro foi reconstruído**. As regras foram reestruturadas num formato novo e passaram a morar em texto claro nos servidores do PayPal. Foi essa reescrita descuidada que expôs tudo.

Guarde essa informação e compare com a declaração oficial do PayPal depois que a casa caiu:

> *"O código causador desse comportamento foi identificado e não tem mais impacto. O código foi implementado antes da aquisição pelo PayPal e aparentemente afeta menos de 0,1% do tráfego do Honey."*
>
> — PayPal ao Hello Partner, janeiro de 2026

O MegaLag chama isso do que é: mentira. Você não reconstrói um sistema do zero, ajusta as regras dele ano após ano, e depois alega que não sabia que ele existia.

A cronologia entrega: o MegaLag avisou o PayPal pedindo comentário em 18 de dezembro de 2025; chamaram as acusações de *"imprecisas"* e mandaram os advogados ameaçarem ele. A Rakuten desligou o Honey da rede em 12 de janeiro de 2026. O defeat device foi desativado em 13 de janeiro, um dia depois, quase um mês após o aviso. E o "0,1% do tráfego" é retórica vazia: as regras moram no servidor, então a abrangência sempre foi ajustável remotamente. Nas regras de 2023, o alvo era praticamente todo mundo.

## As consequências

Depois do Cookie Gate, a fila andou:

- **Rakuten Advertising** (12 de janeiro de 2026): terminou o Honey da rede inteira, mais de 2.000 lojas, incluindo Walmart, Lego, Sephora, Newegg, Uniqlo e Samsung. Detalhe sórdido: emails internos que vieram a público no processo mostram que a Rakuten sabia das violações de stand down desde julho de 2020 e manteve o Honey mesmo assim, e o PayPal ainda respondeu que as políticas de stand down eram *"exagero"*. Em maio de 2026 a Rakuten readmitiu o Honey discretamente, depois de publicar um [SDK de stand down de código aberto](https://github.com/rakutenrewards/PublisherStandown-SDK) que o Honey implementou.
- **Impact** (16 de janeiro): removeu o Honey do marketplace de descoberta e suspendeu a conta, confirmando violação das *"exigências universais de stand down"*.
- **Awin** (21 de janeiro): a maior rede afetada, com mais de 16.000 lojistas. Confirmou *"violações das nossas políticas de publisher"*, suspendeu pagamentos e impôs um plano de remediação que inclui **dar às redes acesso ao código-fonte do Honey**.
- **Google**: em março de 2025 a Chrome Web Store passou a exigir *"benefício direto e transparente ao usuário"* pra qualquer extensão que injete links de afiliado. O jeitinho do Honey foi ativar cashback de 0,1% a 1% em quase todas as lojas parceiras. Tecnicamente um benefício, na prática troco de bala.
- **O mercado respondeu**: o Honey perdeu cerca de 7 milhões de usuários (de 20 milhões pra 14), mais de 7.000 lojas (de ~35.000 pra ~28.000), e a base de cupons encolheu de ~90.000 pra ~50.000 códigos. A Apple, que sozinha gerava mais tráfego monetizável que as 27.000 menores lojas juntas, caiu fora.

{{< youtube id="EXDemfGNGz0" >}}

## A ação coletiva

Aqui o Davi encontra o Golias no tribunal. Dias depois do primeiro vídeo, em 29 de dezembro de 2024, a Wendover Productions (do Sam Denby) entrou com a primeira ação; o Devin Stone, do LegalEagle, que é advogado de verdade, organizou o esforço, e umas vinte firmas abriram ações parecidas em vários estados, incluindo o GamersNexus como autor principal de uma delas. Os casos foram consolidados no distrito norte da Califórnia: *In re PayPal Honey Browser Extension Litigation*, caso 5:24-cv-09470-BLF, juíza Beth Labson Freeman.

As acusações na petição atual: enriquecimento sem causa, interferência intencional em relações contratuais e em vantagem econômica prospectiva, violação do Computer Fraud and Abuse Act (a lei anti-hacking americana), da lei de acesso indevido a dados da Califórnia, e das leis de concorrência desleal da Califórnia e de Washington.

A cronologia processual é uma novela:

- **Novembro de 2025**: o PayPal tentou forçar arbitragem e perdeu. Semanas depois, a juíza Freeman rejeitou a primeira petição, com permissão pra emendar, porque os contratos de afiliado eram com as lojas, não com o PayPal, e a simulação de Monte Carlo que os autores usaram pra estimar o dano não convenceu. O Ryan Hudson tuitou *"Case dismissed"* fazendo graça. O Hello Partner, publicação da indústria que tinha o Honey como patrocinador master da conferência deles, correu pra publicar *"o que o MegaLag errou"*.
- **Janeiro de 2026**: a segunda petição chegou com 101 páginas, dez autores nomeados, os contratos reais das lojas, evidência de compras-teste e, crucialmente, as descobertas do Cookie Gate incorporadas. A página 65 descreve o dispositivo de fraude em detalhe: *"o PayPal criou vários métodos pra ignorar ou contornar os protocolos de stand down"*, incluindo a detecção de visita a sites de redes de afiliados, que a petição chama de *"a revelação mais gritante da má intenção do PayPal"*.
- **4 de junho de 2026**: segunda audiência. A juíza avisou o advogado do PayPal, Richard Jacobson, o mesmo que assinou a notificação extrajudicial contra o MegaLag, que ele tinha *"uma batalha difícil pela frente"*. Quando a defesa argumentou que IDs de afiliado são *"só sequências curtas de números e letras"*, sem valor intrínseco, a juíza respondeu que dá pra dizer o mesmo de uma nota de dólar. Jacobson: *"não sei como responder a isso."*
- **22 de junho de 2026**: o pedido de extinção foi **negado integralmente**. Todas as acusações sobreviveram. O caso agora entra na fase de produção de provas (o *discovery* americano): documentos internos, comunicações, depoimentos, possivelmente dos fundadores e dos engenheiros do PayPal. Julgamento, se houver, lá pro fim de 2027. O palpite do MegaLag, e o meu também: o PayPal vai tentar acordo pra enterrar esses depoimentos.

Vale registrar: uma ação paralela de consumidores do Reino Unido, sobre a propaganda enganosa de *"melhores cupons"*, foi rejeitada em junho de 2026. E a Capital One Shopping, processada por esquema parecido, fechou acordo em setembro de 2025 negando culpa.

## Conclusão

O que me pega nessa história toda é o padrão de comportamento do PayPal em cada etapa. Acusado com vídeo e demonstração ao vivo, chamou de fake news. Confrontado com o código, mandou notificação extrajudicial e tentou derrubar o vídeo do Patreon alegando violação de direitos autorais. Alertado formalmente sobre o dispositivo de fraude, chamou de *"impreciso"* e esperou a Rakuten agir pra desligar. Pego, divulgou que *"descobriu recentemente"* um sistema que a própria empresa reconstruiu em 2021.

Em cada degrau, a escolha foi negar, ameaçar, minimizar, até a evidência tornar a posição insustentável; aí recuava meio passo fingindo surpresa.

O Honey, como produto, é causa perdida. Mesmo se você não liga pra ética de quem rouba comissão de criador, lembra do que a Amazon avisou lá em 2020: é uma extensão com permissão de ler e modificar seus dados em qualquer site, que escaneia seus cookies, loga seu histórico de navegação com geolocalização, e que aplicava cupom sabidamente expirado só pra fazer volume. Desinstala. Não existe cupom que pague isso.

E o lado inspirador, porque tem um: um desenvolvedor neozelandês motivado, com um analisador de pacotes, uma conta de teste e paciência, fez o que redes bilionárias com times de compliance não fizeram em oito anos. A arma dele foi um arquivo JSON em texto claro e algumas dezenas de linhas de JavaScript que o próprio PayPal serviu pra quem quisesse olhar. A frase que fecha o quarto vídeo resume a arrogância que ele derrubou:

> *"Quando eu erro, sou o MegaLag. Quando eu acerto, sou só um comentarista da indústria."*

Pois agora ele é testemunha técnica de fato num processo federal. Davi venceu essa rodada. E foi lindo de assistir.
