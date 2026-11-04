---
title: "TikTok tecnicamente não se enquadra nas leis Brasileiras (LGPD/Felca). Entenda"
slug: "tiktok-tecnicamente-nao-se-enquadra-nas-leis-brasileiras-lgpd-felca"
date: '2026-11-04T16:00:00-03:00'
draft: false
translationKey: tiktok-tecnicamente-nao-se-enquadra-nas-leis-brasileiras-lgpd-felca
description: "Analisei a versão 47.7.1 do TikTok com o REA: o app não espiona o resto do celular, mas monta um fingerprint persistente e criptografado do aparelho, reenvia seus identificadores, mede como você toca e segura o celular e registra tudo o que você faz dentro dele. Explico por que bloquear no DNS ou modificar o app não resolve, por que a única saída hoje é isolar o TikTok num celular secundário ou perfil separado, como o app dá aos EUA e à Europa um tratamento que o Brasil não recebe, e onde ele bate de frente com a LGPD e a Lei Felca, com a ANPD já tendo multado a ByteDance."
tags:
- seguranca
- leis-e-regulacao
---

Em julho eu [pedi pro Fable 5 analisar o código do TikTok](/2026/07/08/fable-5-analisar-codigo-tiktok-clash-of-kings-govbr-fingerprint/), junto com o Clash of Kings e o app do gov.br. Foi uma descompilação da versão 46 do app Android, feita com jadx, uma varredura de strings nas bibliotecas nativas e bastante leitura de código, bem antes do [REA](/2026/10/13/engenharia-reversa-com-ia-a-adobe-morreu/) existir. A conclusão daquela vez: o TikTok não é malware disfarçado, mas faz uma coleta de dados grau industrial, projetada pra ser difícil de auditar.

Agora que eu tenho o REA, resolvi ir mais fundo. Peguei a versão 47.7.1, a mais recente, e dessa vez abri também o código nativo da pilha de rede no Ghidra. Tudo está no repositório [tiktok_analysis](https://github.com/akitaonrails/tiktok_analysis), com os relatórios novos de 14 a 17 e as evidências linha por linha.

Este artigo é pra duas pessoas ao mesmo tempo: o usuário comum, que quer saber o que o app faz com ele, e o engenheiro de software, que quer saber se dá pra bloquear. E no final tem a parte que interessa a todo brasileiro.

O TikTok não trata todo mundo igual. O app separa os usuários por região, e Estados Unidos, Europa e Coreia do Sul ganham tratamento próprio. O resto do mundo cai num balde só, e o Brasil está nele, [no grupo menos protegido](#o-brasileiro-é-o-usuário-menos-protegido). É por isso que, do jeito que está, o TikTok bate de frente com a LGPD e com a Lei Felca.

> Tudo aqui vem de **análise estática**: eu li o código do app, não capturei o tráfego de um celular rodando. Isso prova o que o app foi construído pra fazer e pra onde ele foi construído pra mandar. Não prova byte a byte o que sai em cada requisição, porque a parte mais sensível é criptografada em código nativo.

### Como foi feita, e como reproduzir

Na versão 46, o trabalho foi o jadx transformando o app em Java legível e o LLM lendo o código. O código nativo, as bibliotecas `.so` em C e C++, ficou só na varredura de strings.

Na 47, um agente rodou tudo sozinho:

- o **jadx** descompilou as 58 partes de código Java do app, umas 365 mil classes;
- o **REA** abriu as bibliotecas nativas no Ghidra e decompilou funções específicas, como o resolvedor de DNS próprio dentro da `libsscronet.so`;
- **subagentes em paralelo** varreram a árvore inteira, um por assunto (identificadores, fingerprint, servidores), devolvendo arquivo e linha de cada evidência.

Se você quiser refazer, ou aplicar o mesmo método em outro app, o [relatório 11](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/11-diy-reproduce-guide.md#step-8--the-agent--rea-workflow-2026-update-what-reports-1417-used) tem o passo a passo, com os prompts prontos pro agente principal e pros subagentes e a sequência exata de ferramentas do REA.

## O que o TikTok coleta, em português claro

Primeiro a boa notícia, porque ela é importante e muita gente erra aqui. O TikTok **não** espiona o resto do seu celular:

- não lê seus SMS, seu histórico de ligações, suas notificações, nem o que você digita em outros apps;
- não tem serviço de acessibilidade, que é o jeito que apps maliciosos usam pra ler a tela de outros apps;
- não lista todos os apps instalados;
- não pega IMEI, número de telefone nem endereço MAC.

O sandbox do Android impede, e o app não pede as permissões que contornariam isso. O [relatório 10](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/10-os-and-clipboard-access.md) verificou isso na árvore inteira, inclusive a área de transferência, que só é lida quando você cola algo. A única permissão nova do Android na versão 47 serve pra detectar quando alguém está gravando a tela *do próprio TikTok*.

A má notícia é o que ele coleta **sem pedir nada**, porque o Android não exige permissão pra isso. O [relatório 14](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/14-v47-data-inventory-and-dns-blocking.md) tem o inventário completo. Resumindo:

- **quem é o seu aparelho**: vários identificadores persistentes, incluindo o `ANDROID_ID`, que sobrevive a limpar os dados e a reinstalar o app. E toda vez que você abre ou volta pro app, no máximo uma vez por hora, ele reenvia os principais identificadores, criptografados, pra um endpoint dedicado;
- **o que o seu aparelho é**: modelo, CPU, GPU, memória, a lista de sensores, a especificação completa de cada câmera (sem pedir permissão de câmera), os teclados instalados e os serviços de acessibilidade ativos;
- **uma prova assinada pelo Google do seu aparelho**: o app pede ao chip de segurança do celular uma atestação de hardware, que confirma o modelo, o estado do bootloader e o nível de patch. Isso não dá pra falsificar;
- **como você segura e toca o celular**: pressão e tamanho do toque em cada tela, e amostras de seis sensores de movimento (detalhes logo abaixo);
- **onde você está, sem pedir localização**: operadora, país do chip, fuso horário, idioma, os servidores de DNS do seu Wi-Fi e se você está usando VPN ou proxy;
- **tudo o que você faz dentro do app**: são mais de 6 mil [tipos de evento diferentes](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/_evidence/v47/applog_event_names.txt), incluindo quanto tempo você assiste cada vídeo, o que você pesquisa, o que curte, quem visita.

### Coisas que você nem imagina que são medidas

A lista acima já é grande, mas o detalhe impressiona mais. A sonda de risco do app sozinha tem cerca de 90 campos, e o motor de segurança nativo tem outra lista própria. Algumas das variáveis que o código lê, todas sem pedir permissão:

- **cada toque na tela**: a pressão, o tamanho da área de contato, o tipo de "ferramenta" (dedo, caneta), o dispositivo de entrada e o caminho completo do dedo, ponto a ponto, com o tempo de cada ponto. Isso descreve cada rolagem e cada deslizar, e é registrado em todas as telas do app. As teclas que você digita ficam de fora;
- **como o celular se move na sua mão**: acelerômetro, giroscópio, magnetômetro, gravidade, aceleração linear e rotação, além da orientação do aparelho calculada a partir deles. O app usa isso pra saber se tem um humano segurando o celular. Mas são exatamente esses os sinais que permitem dizer se você está andando, sentado, deitado ou dentro de um carro;
- **o "tremor" do giroscópio e a variação do sensor de luz**, ou seja, o quanto sua mão treme e o quanto a luz em volta muda;
- **a bateria**: nível, se está carregando, e um histórico das últimas 20 leituras mais ou menos;
- **o volume da mídia, o modo avião e o estado do chip**;
- **se o microfone e a câmera têm permissão**, mesmo quando você não está usando;
- **quando o celular foi ligado pela última vez** e há quanto tempo está ligado, o que permite juntar sessões mesmo depois de reinstalar o app;
- **quais teclados e quais serviços de acessibilidade estão instalados**;
- **espaço em disco, memória, taxa de atualização da tela, modelo da GPU**, criando um contexto gráfico só pra perguntar;
- **se você está numa ligação** ou com o microfone ativo em outro app, se o modo desenvolvedor está ligado, se tem cabo USB conectado.

E dentro do app, além do que você assiste, ele registra quanto tempo você fica em cada vídeo, quando você pausa, repete ou arrasta a barra de progresso, e o texto de cada busca.

> Nenhum desses dados sozinho parece grave. Juntos, eles descrevem o seu aparelho, a sua mão e os seus hábitos com uma precisão que nenhum formulário de cadastro jamais pediria.

## O que é fingerprinting, e por que isso é perigoso

Quase tudo da lista acima serve pra montar uma coisa chamada **fingerprint**, a impressão digital do dispositivo.

A ideia é simples. Nenhum dado sozinho identifica você: milhões de pessoas têm o mesmo modelo de celular, o mesmo fuso horário, a mesma operadora. Mas a **combinação** de dezenas desses sinais é tão específica que vira praticamente única. É um número de série que você nunca autorizou e nem sabe que existe.

O que torna isso valioso, e perigoso, é a **persistência**:

- um cookie você apaga;
- o identificador de anúncio você reseta;
- o fingerprint sobrevive a limpar os dados e a reinstalar o app. Só um reset de fábrica troca o `ANDROID_ID`, e mesmo assim o modelo, os sensores e a atestação continuam descrevendo o mesmo aparelho.

O servidor ainda pode reemitir o mesmo identificador de dispositivo quando reconhece os outros sinais. No mesmo aparelho e no mesmo perfil, recomeçar do zero é muito difícil.

### Por que isso é nefasto

O problema não é só anúncio. Um identificador que não morre permite:

- **juntar tudo**: o que você assiste, pesquisa e curte vira um perfil ligado ao *aparelho*, que sobrevive mesmo se você apagar a conta;
- **cruzar entre apps**: o TikTok tem um endpoint específico pra ligar os identificadores do seu aparelho entre os apps da ByteDance, como CapCut e Lemon8;
- **reidentificar você**: se você apaga a conta e cria outra no mesmo celular, a plataforma tem como saber que é o mesmo aparelho, porque o `ANDROID_ID` é o mesmo;
- **inferir o que você não contou**: o que você assiste e por quanto tempo pode revelar interesses, estado emocional, orientação, religião, política. E você não tem como ver nem corrigir esse perfil.

E tem o agravante que já apareceu na análise de julho: o fingerprint é montado e **criptografado em código nativo**, dentro da biblioteca `libmetasec_ov.so` (o [relatório 13](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/13-native-library-analysis.md) mostra o que dá pra ler dela). Nem descompilando o app inteiro dá pra saber exatamente o que vai nele. Na versão 47, as strings dessa biblioteca parecem ainda mais criptografadas que na 46.

> Você não consegue auditar, não consegue apagar, e no mesmo aparelho é muito difícil recomeçar. Esse é o ponto central.

## Dá pra bloquear? A parte pros engenheiros

A minha primeira ideia foi a óbvia: bloquear os servidores de telemetria no meu DNS, o NextDNS, ou modificar o app pra tirar a coleta. Pedi pro agente estudar as duas opções a fundo. Nenhuma das duas resolve.

### Por que bloquear no DNS não funciona

Bloquear por DNS (NextDNS, Pi-hole, AdGuard) funciona assim: o app pergunta "qual o IP de `log.tiktokv.com`?" e o seu DNS responde "nenhum". Só que o TikTok foi construído pra não depender do seu DNS:

- **ele tem o próprio resolvedor de DNS**, ligado por padrão, e chega nele por **IP direto** (`34.102.215.99` fora dos EUA). Quando o app usa esse resolvedor, o seu DNS não vê a consulta, e quem decide quando usar é o servidor;
- **os servidores principais da API estão fixados em IPs** da própria ByteDance, cravados no código;
- **o servidor pode reescrever as rotas a qualquer momento**: na abertura, o app baixa uma lista de regras que pode mandar qualquer endereço pra outro, ou fixar qualquer nome num IP;
- **os IPs de resolvedor de reserva ficam salvos no celular**, então um IP aprendido uma vez sobrevive ao bloqueio que você fizer depois;
- **as estatísticas de cada vídeo assistido viajam no mesmo servidor do feed**. Uma regra embutida força isso. Se você bloquear, o feed para junto.

Dá pra reduzir bastante. O [relatório 14](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/14-v47-data-inventory-and-dns-blocking.md#4-where-it-goes-and-the-blocklist) tem uma lista de bloqueio em camadas e as regras de firewall pro roteador que fecham o resolvedor próprio. Isso corta rastreadores de terceiros, uploads de log e crash, o reenvio de identificadores de hora em hora e boa parte do fluxo de eventos. Mas não esconde do TikTok o que você assiste, e o servidor pode mudar as rotas na próxima atualização.

### Por que modificar o app também não funciona

A segunda ideia era reempacotar: descompilar, transformar os coletores em código morto, reassinar e instalar. O [relatório 15](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/15-repackaging-feasibility-and-patch-plan.md) estudou isso, e esbarra em três paredes:

1. **o fingerprint é o assinador das requisições.** A mesma biblioteca nativa que monta o fingerprint assina todas as chamadas à API. Se você tira um, perde o outro, e o servidor rejeita a requisição sem assinatura. O feed para;
2. **a sua assinatura entra na assinatura do aparelho.** O código nativo lê o certificado com que o app foi assinado. Reassinar com a sua chave muda isso, e o servidor sabe que você roda um cliente modificado. Pode responder com captcha, verificação de telefone ou conta limitada, quando quiser;
3. **a configuração vem do servidor.** Rotas, regras de DNS e listas de eventos são baixadas em tempo de execução, então um patch estático só muda os valores padrão.

Dá pra remover a telemetria "de luxo" na fonte: o reenvio de identificadores, o AppsFlyer, o Firebase Analytics, os uploads de crash. Mas não o fingerprint nem o seu comportamento, e você entra numa esteira de refazer o patch a cada atualização do TikTok.

### Falsificar também não

E falsificar os dados piora.

O app verifica root, Magisk, Xposed, Frida, emulador, localização falsa, bootloader destravado e modo desenvolvedor. A atestação de hardware assinada pelo Google denuncia qualquer modelo falsificado. Os sensores de toque e movimento existem justamente pra detectar valores sintéticos. O [relatório 8](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/08-mitigation-options.md) explica por que cada tentativa de falsificar sai pela culatra. Falsificar coloca você no balde de "aparelho adulterado", e o fingerprint sai do mesmo jeito.

## A única saída hoje: isolar

Se não dá pra esconder o comportamento de quem te entrega o feed, o objetivo muda: fazer com que esse comportamento fique ligado a uma **identidade descartável**, que não leva até você. Isolar, sem falsificar nada. Tem dois jeitos:

### Um celular secundário

Um aparelho barato, ou um tablet, só pro TikTok:

- **sem chip**, ou só no Wi-Fi: os campos de operadora e país do chip vão vazios, o que é normal em tablet;
- **sem login**, ou com um e-mail que você não usa em nenhum outro lugar. Nada de entrar com Google, Facebook ou número de telefone;
- **sem permissões**: negue localização, contatos, fotos, microfone e câmera;
- **ID de anúncio apagado**, em Configurações → Privacidade → Anúncios;
- na rede, a lista de bloqueio e as regras de roteador do [relatório 14](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/14-v47-data-inventory-and-dns-blocking.md#5-the-fake-substitute-plan).

**Prós:** é a separação mais completa. Tudo o que o fingerprint descreve é *aquele* aparelho, e nada é falsificado, então nada contradiz a atestação. O CapCut e os outros apps da ByteDance ficam longe da sua vida real.

**Contras:** custa um aparelho, é mais um equipamento pra carregar e atualizar, e é menos prático. E o que você assiste continua sendo registrado, só que preso a uma identidade que não é a sua.

### Um perfil separado no mesmo celular

O Android permite um espaço isolado: o **Espaço Privado** no Android 15 ou mais novo, ou um perfil de trabalho com apps como Shelter ou Island. O TikTok vai lá dentro, com as mesmas regras de sem login e sem permissões.

**Prós:** custo zero. Cada perfil tem o próprio `ANDROID_ID`, o app não enxerga seus contatos, fotos e outros apps, e nada é falsificado.

**Contras:** o hardware é o mesmo. O fingerprint de hardware, a atestação e o chip do seu celular continuam iguais, então quem quiser cruzar consegue ligar o perfil ao aparelho. Isola bem os identificadores de software, mas o aparelho continua o mesmo.

> Não existe configuração que faça o TikTok parar de saber o que você assiste. O que existe é garantir que esse "você" seja uma identidade descartável.

## O brasileiro é o usuário menos protegido

Aqui fica pior pra gente. O [relatório 16](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/16-regional-data-treatment.md) mostra que o app separa todo usuário em cinco regiões de compliance:

- **US**: Estados Unidos;
- **EU**: Europa, no caso o Espaço Econômico Europeu;
- **KR**: Coreia do Sul, por causa da lei de proteção de dados de lá;
- **ROW**: "rest of world", o resto do mundo. **O Brasil cai aqui**;
- **UNKNOWN**: ainda não determinado.

O que muda entre elas:

| | EUA | Europa (EEE) | Brasil |
| --- | --- | --- | --- |
| Infraestrutura dedicada pros dados | Sim (Project Texas, com a Oracle; desde janeiro de 2026, uma joint venture americana) | Sim (Project Clover, Noruega e Irlanda) | Não, vai pra infraestrutura global da ByteDance |
| Modo do motor de fingerprint | 503, o modo de compliance | 503, o modo de compliance | 603, o modo padrão |
| Tratamento regulatório específico | Sim (exigência do governo americano) | Sim (GDPR) | Nenhum. Zero ocorrências de "LGPD" no código |

O que cada modo coleta exatamente fica dentro do código nativo criptografado, então não dá pra medir a diferença byte a byte. Mas a estrutura é clara: o caminho com freio regulatório foi escrito pros EUA e pra Europa, e o Brasil cai no padrão. A Coreia pelo menos ganhou o próprio balde no código; o Brasil, com uma lei inspirada na GDPR, não ganhou nem isso.

E não adianta trocar a região da loja do Google pra Europa. O balde vem da região da conta TikTok, que o servidor define, e forçar divergências tende a virar sinal de fraude.

## LGPD e Lei Felca: por que o TikTok precisa se adequar

O [relatório 17](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/17-brazilian-law-compliance.md) cruza essas descobertas com a lei. Vale a ressalva: quem decide se houve infração é a ANPD e a Justiça, olhando também a política de privacidade, as telas de consentimento e o que acontece no servidor. A análise do app mostra onde ele **bate de frente** com a lei.

### LGPD

A [Lei Geral de Proteção de Dados](https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm) tem princípios que o app tem dificuldade de cumprir:

- **necessidade** (art. 6º): coletar só o necessário pra finalidade. Reenviar os principais identificadores a cada hora, uma sonda de cerca de 90 campos sobre root e hardware, toque e sensores de movimento, tudo isso vai muito além do que assistir vídeo curto exige;
- **transparência** (arts. 6º e 9º): o titular tem direito a saber o que é coletado. Com o fingerprint criptografado em código nativo, o usuário não tem como saber, e nem descompilando o app dá pra ver;
- **direitos do titular** (art. 18, IV e VI): eliminação de dados desnecessários ou excessivos, e dos dados tratados com consentimento. Um identificador que sobrevive à limpeza e à reinstalação, e que o servidor pode reemitir ao reconhecer o aparelho, esvazia esse direito na prática;
- **transferência internacional** (art. 33): sem infraestrutura dedicada pro Brasil, os dados vão pra infraestrutura global da ByteDance;
- **dados de crianças** (art. 14): o app tem um Modo Infantil que apaga identificadores e zera o ID de anúncio, mas ele só vale se o app souber que o usuário é criança. O caminho padrão perfila todo mundo.

Esse último ponto não é teoria. A ANPD já [abriu processo contra o TikTok](https://teletime.com.br/04/11/2024/anpd-tiktok-falha-no-tratamento-de-dados-de-criancas-e-adolescentes/) em novembro de 2024 por tratar dados de crianças e adolescentes sem verificação de idade, e [mandou desativar o acesso ao feed sem cadastro](https://canaltech.com.br/redes-sociais/tiktok-tera-que-desativar-acesso-ao-feed-sem-cadastro-no-brasil-determina-anpd/) no Brasil.

Em agosto de 2026 veio a conta: a ANPD [multou a ByteDance em R$ 153,7 milhões](https://www.poder360.com.br/poder-tech/anpd-multa-dona-do-tiktok-em-r-1537-milhoes/) por tratar dados de crianças e adolescentes, dizendo que a empresa "aceitou o risco de realizar o tratamento massivo de dados pessoais de crianças e adolescentes". O feed sem cadastro [continua existindo](https://teletime.com.br/25/08/2026/tiktok-muda-feed-multa-anpd/), mas dentro de um plano de conformidade, sem anúncios e com a coleta limitada.

### Lei Felca (ECA Digital)

A [Lei 15.211/2025](https://www.planalto.gov.br/ccivil_03/_ato2023-2026/2025/lei/l15211.htm), o ECA Digital, ganhou o apelido de Lei Felca por causa dos vídeos do influenciador Felca sobre adultização de crianças na internet, que empurraram o projeto em 2025. Está em vigor desde março de 2026 e exige das plataformas, entre outras coisas:

- verificação de idade confiável, que não seja só autodeclaração;
- contas de menores de 16 anos vinculadas a um responsável;
- proibição de publicidade direcionada com dados de crianças;
- proteção desde o design.

A maior parte disso acontece no servidor, então a análise do app não prova nem cumprimento nem infração. O que ela mostra: a ferramenta pra proteger dados de crianças existe no código (o Modo Infantil), mas depende inteiramente de o app saber quem é menor. E é exatamente aí que a ANPD já apontou falha.

### Se adequar ou sair

Juntando tudo:

- o app tem tratamento regulatório pros EUA e pra Europa, e nada pensado pro Brasil (a única minimização que vale aqui é o Modo Infantil, que é igual em todo lugar);
- os dados dos brasileiros não têm infraestrutura dedicada;
- o fingerprint não é auditável nem apagável;
- a proteção de menores depende de uma verificação de idade que o regulador já considerou fraca.

A ByteDance sabe fazer diferente: fez pros americanos e pros europeus, porque lá foi obrigada. Nos EUA, a obrigação foi tão longe que a operação americana virou uma joint venture separada. O Brasil tem uma lei de proteção de dados no mesmo espírito da GDPR e agora uma lei específica pra crianças.

> O TikTok precisa tratar o usuário brasileiro como trata o europeu: com infraestrutura dedicada, minimização de verdade e verificação de idade que funcione. Se não fizer isso, não deveria poder operar aqui.

Enquanto isso não acontece, a proteção fica nas suas mãos. Se for usar, use num aparelho ou perfil isolado, sem login e sem permissões. E se tem criança em casa com TikTok no celular, agora você sabe o que está sendo coletado.
