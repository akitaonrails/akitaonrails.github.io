---
title: "Fiz o Fable 5 analisar código do TikTok, Clash of Kings e Gov.br - Entendendo Fingerprint"
slug: "fable-5-analisar-codigo-tiktok-clash-of-kings-govbr-fingerprint"
date: '2026-07-08T16:00:00-03:00'
draft: false
translationKey: fable-5-analyze-tiktok-clash-of-kings-govbr-fingerprint
description: "Uma análise estática, feita com o Fable 5, compara o fingerprint opaco do TikTok, o UUID persistente do Clash of Kings e os cuidados de privacidade do gov.br, com ressalvas sobre o método."
tags:
- seguranca
- engenharia-de-software
---

Deixa eu começar com o disclaimer mais importante do post inteiro, porque ele muda como você deve ler tudo daqui pra baixo: **nada aqui é 100% factual.** Eu pedi pro Claude Fable 5 fazer uma análise completa do código de três apps Android, mas eu não tenho como garantir o quão fundo ele foi de verdade sem reauditar arquivo por arquivo na mão, e isso são centenas de milhares de arquivos por app. Então trata isso como um panorama, não como um laudo pericial.

E tem mais camadas de incerteza. Os APKs vieram do [APKPure](https://apkpure.com/), não da Play Store oficial, então existe a possibilidade (pequena, mas existe) de terem sido adulterados no caminho. E mesmo depois de descompilar, sobra um monte de biblioteca binária e SDK que a gente não abriu, assumindo que são libs comuns tipo Google Firebase ou Google Play Services. Esse mini-projeto foi, no fundo, curiosidade minha: eu queria saber o que tem dentro desses apps que a gente instala sem pensar.

## Descompilar Android é fácil demais

Uma coisa que muita gente não sabe: app Android é **fácil demais** de descompilar. O APK é basicamente um zip. Você descompacta, roda uma ferramenta como o [jadx](https://github.com/skylot/jadx) nos arquivos `.dex`, e sai Java legível do outro lado. Se o app é Flutter, dá pra reconstruir o Dart com o [Blutter](https://github.com/worawit/blutter). Se é um jogo Cocos2d-x, muitas vezes os scripts Lua estão ali em texto puro, sem nem precisar descriptografar.

Isso **não** te deixa recompilar o app a partir do fonte (os nomes de classe e método vêm embaralhados pela ofuscação, faltam recursos, faltam as chaves de assinatura). Mas pra **análise estática** é mais que suficiente: dá pra ler os endpoints que o app contata, as permissões que ele pede, os identificadores que ele monta, os SDKs que ele embute. É exatamente esse tipo de leitura que eu pedi pro Fable 5 fazer.

Um limite honesto: a parte mais sensível costuma estar em **código nativo** (`.so`), C/C++ compilado, que não descompila em nada legível. No caso do TikTok, é justamente aí que mora o miolo, e volto nisso já já.

## "Se é de graça, você é o produto"

Você já ouviu essa frase mil vezes. Ela é verdadeira, mas quase sempre fica no abstrato. Vamos concretizar: como exatamente você vira o produto? A resposta tem um nome técnico, e é o motivo de eu ter escolhido esse tema pro título: **fingerprint**.

Fingerprint (impressão digital do dispositivo) é um identificador persistente que a plataforma monta juntando dezenas de sinais do seu aparelho: modelo do celular, versão do sistema, resolução de tela, CPU, RAM, operadora, fuso horário, idioma, bateria, fontes instaladas, redes Wi-Fi e Bluetooth por perto, sensores de movimento, e por aí vai. Nenhum desses dados sozinho te identifica. Mas a **combinação** deles é tão específica que vira praticamente único, um "número de série" implícito do seu dispositivo que você nunca autorizou explicitamente.

O pulo do gato, e o motivo pelo qual isso é tão valioso, é a **persistência**. Um cookie você limpa. O identificador de anúncio você reseta. Mas um fingerprint bem montado sobrevive a você limpar os dados do app, sobrevive a reinstalar, às vezes sobrevive até a resetar o aparelho. Ele re-identifica você como a mesma pessoa depois de qualquer tentativa de recomeçar do zero. É por isso que as empresas querem tanto: com o fingerprint, elas cruzam seu comportamento entre apps, entre sessões, entre reinstalações, e montam um perfil que segue você mesmo quando você acha que apagou seus rastros. Esse perfil é o produto da tal frase. E o produto é você.

Os três apps que analisei mostram três pontos bem diferentes desse espectro, e é aí que a coisa fica interessante.

## Os três apps

### TikTok: coleta grau industrial, blindada contra auditoria

O [tiktok_analysis](https://github.com/akitaonrails/tiktok_analysis) foi o mais denso. Versão 46.0.1, 37 arquivos dex, 204 bibliotecas nativas. A conclusão honesta, e que eu acho a mais justa: **não é malware disfarçado, mas é coleta grau industrial projetada pra ser difícil de auditar.**

Do lado tranquilizador: nenhum servidor secreto. Todo host que o app contata é da TikTok/ByteDance ou de um fornecedor de anúncio/analytics *nomeado* (Adjust, AppsFlyer, Facebook, Google, ThreatMetrix, Amazon). Não achamos coleta de IMEI nem de MAC, não tem `QUERY_ALL_PACKAGES`, não lê SMS nem registro de chamadas. Dados de usuários dos EUA e da UE vão pra enclaves dedicados (o famoso Project Texas com a Oracle em Ashburn).

Do lado preocupante: ele coleta **muito**. Fingerprint persistente do dispositivo, localização precisa, varredura de Wi-Fi e Bluetooth, upload de contatos (se você habilitar "encontrar amigos"), sensores de movimento, e uma checagem contra uma lista fixa de **91 apps nomeados** pra ver quais você tem instalado (concorrentes, PayPal, Venmo, Spotify, apps irmãos da ByteDance). Seu ID de anúncio se espalha pra uns 6 terceiros.

E o achado central: o fingerprint e boa parte da telemetria são montados em **código nativo** (a `libmetasec_ov.so` e uma pilha de libs de cripto), com a assinatura de cada requisição saindo encriptada. Ou seja, mesmo descompilando o app inteiro, não dá pra saber exatamente quais bytes saem do aparelho.

Pra atacar justamente essa caixa-preta, uma das análises passou um `strings` nas 204 bibliotecas nativas (o [relatório 13](https://github.com/akitaonrails/tiktok_analysis/blob/main/docs/13-native-library-analysis.md) do repo), e aí a `libmetasec_ov.so` entrega o jogo em texto puro. Dá pra ler os campos que ela coleta (`secdeviceid`, `device_id`, nível e estado da bateria, tamanho da tela), a função que assina as requisições, os endpoints de telemetria da ByteDance cravados no binário, e até o agendador que dispara o envio num timer. O que a camada Java só deixava inferir, o nativo confirma. É uma máquina de fingerprint, sem tirar nem pôr.

E a mesma varredura foi atrás justamente do que todo mundo tem medo de achar (keylogger, gravador de tela, injeção de input) e não achou nada disso. Os hits assustadores de palavra-chave eram falsos amigos: `keylog` era o log de debug do TLS, `screenshot` era o player de vídeo e a autenticidade de conteúdo C2PA, `getevent` era nome de método de mídia. Tem anti-debug e detecção de frida/xposed, sim, mas é o app se inspecionando por dentro, coisa normal de biblioteca de segurança, não bisbilhotando o resto do celular.

Então a opacidade continua sendo o ponto, só que mais afiada: a gente sabe o que a `libmetasec_ov` faz e pra onde ela reporta, e o que segue trancado são os bytes exatos do payload, que só disassembly do nativo ou captura ao vivo revelariam. "Não está provado que é spyware" e "coleta muito mais do que precisa, de forma opaca" seguem verdadeiras ao mesmo tempo, agora com a confirmação em texto puro de que o motor de fingerprint é real.

### Clash of Kings: o jogo é honesto, a monetização é predatória

O [clash_of_kings_analysis](https://github.com/akitaonrails/clash_of_kings_analysis) foi uma surpresa agradável no quesito privacidade. É um jogo de estratégia da chinesa Elex, engine Cocos2d-x com quase 12 mil scripts Lua em texto puro. E, olha só: **sem GPS, sem câmera, sem microfone, sem contatos, sem SMS, sem IMEI.** As duas leituras mais sensíveis que ele *pode* fazer (lista de apps instalados e MAC do Wi-Fi) são ambas condicionadas a consentimento. Nada de malware, nada de exfiltração escondida.

A preocupação de privacidade é o mesmo vilão do TikTok em versão mais simples: um **UUID de dispositivo resistente a reset**, gravado em quatro lugares diferentes (configurações do sistema, preferências, cartão SD e backup na nuvem) justamente pra sobreviver a uma reinstalação. Mais telemetria pra infra em região da China e pro Tencent Bugly.

Onde o Clash of Kings realmente pesa é na **monetização**. É o kit completo de free-to-play predatório: loot boxes (as "luck draws" de heróis), ofertas com contador regressivo pra criar FOMO, tiers VIP pay-to-win, escadas de gasto acumulado com ranking de quem gasta mais (a caça à "baleia"), cartão mensal, o pacote inteiro. O lado meio-copo-cheio: as probabilidades de drop são divulgadas no jogo, e existe o sistema chinês de anti-vício e nome-real pra menores. Privacidade decente, carteira em perigo.

### Gov.br: o exemplo de como fazer direito (com uma ressalva)

O [govbr_analysis](https://github.com/akitaonrails/govbr_analysis) é o contraponto, e me deixou até aliviado. É o app oficial de identidade digital do governo brasileiro, feito em Flutter (reconstruí o Dart com o Blutter). Pros padrões de um app de governo obrigatório, ele é **bem construído e respeitoso com privacidade**: o tráfego é quase todo pra `*.gov.br`, SERPRO e Dataprev, o TLS tem certificate pinning, as credenciais ficam no KeyStore criptografado do Android, a assinatura ICP-Brasil usa cripto grau FIPS, e o app se defende com força contra aparelho rooteado ou adulterado. E o mais importante: **nenhum tracker comercial de anúncio.** Nada de Segment, Adjust, AppsFlyer ou Meta.

As duas ressalvas honestas: ele embute o **Google Firebase** (Analytics, Crashlytics, Messaging, Remote Config) com coleta ligada por padrão e permissão de ad-id declarada, o que é o padrão preguiçoso de quase todo app hoje; e a sua **selfie de prova de vida sobe pro backend do governo** pra bater identidade, o que é inerente ao propósito e não vai pra terceiros. O item que só a captura de tráfego ao vivo resolveria é se o seu CPF vai anexado aos relatórios do Crashlytics. Mas no geral, se todo app fosse construído com esse cuidado, esse post nem existiria.

## O que quase todo app carrega junto

Cruzando os três (e é aí que o padrão aparece), dá pra ver o que costuma vir embutido no app que você baixa, mesmo num app de governo:

- **Google Firebase / Play Services**: presente nos três. Analytics, Crashlytics (relatório de erro), Cloud Messaging (push), Remote Config. É tão onipresente que virou infraestrutura invisível. E vem com coleta ligada por padrão.
- **Stack de atribuição de anúncio**: Adjust, AppsFlyer, Branch.io, Singular, Facebook SDK. A função é ligar "você clicou nesse anúncio" a "você instalou e usou o app". No TikTok tinha um empilhamento redundante: cinco desses ao mesmo tempo, cada um coletando seu ad-id de forma independente.
- **Redes de anúncio**: AdMob/DoubleClick do Google, e no caso dos jogos o ecossistema de mediação de ads.
- **Analytics/crash de origem regional**: o Tencent Bugly no Clash of Kings é o exemplo, telemetria indo pra infra chinesa.
- **Um serviço especializado de fingerprint/antifraude**: o caso mais chamativo foi o [ThreatMetrix da LexisNexis](https://risk.lexisnexis.com/products/threatmetrix) no TikTok: uma empresa cujo negócio *é* montar impressão digital de dispositivo pra detecção de fraude. Legítimo no uso antifraude, mas é literalmente uma máquina de fingerprint como serviço, embutida.

O recado é que aquele "produto" não é montado por uma empresa só. São cinco, seis, sete parceiros, cada um pegando um pedaço, e o fingerprint costurando tudo de volta num perfil só. Ninguém está te espionando sozinho. É um mutirão.

## O que dá pra fazer

Você não vai zerar isso sem sair da internet, mas dá pra reduzir bastante a superfície exposta:

- **Não consinta o que não precisa.** GPS é o maior. Um app de vídeo não precisa da sua localização precisa pra funcionar. Negue, ou libere só "enquanto usa o app". O mesmo vale pra contatos, microfone e câmera: só libere quando o recurso que você quer usar naquele momento exige.
- **Resete seu ID de anúncio de vez em quando** (e, no Android, dá pra escolher "excluir ID de publicidade" de vez). Não mata o fingerprint, mas quebra parte do rastro.
- **Desconfie de "encontrar amigos".** É o gatilho de upload de contatos. Você entrega a rede social inteira das pessoas que confiaram seu número a você.
- **Prefira a versão web quando der.** Navegador com bloqueador de rastreador exposto menos fingerprint que o app nativo, que tem acesso a sensores e sinais que o browser não dá.
- **Aceite o trade-off conscientemente.** A questão não é virar paranoico e desinstalar tudo. É saber o preço. Se você acha o TikTok divertido o suficiente pra pagar com seu fingerprint, ótimo, é uma decisão informada. O problema é pagar sem saber que está pagando.

## O ponto do post

Nada disso prova ou desprova que um app específico é 100% seguro. Análise estática mostra o que o app é **capaz** de fazer, o que está construído dentro dele; só a captura de tráfego ao vivo, com aparelho rooteado e proxy MITM, mostraria o que de fato sai pela rede em cada requisição. Eu não fui até lá. Isso aqui é um vislumbre, não um veredito.

E é exatamente esse o ponto. Hoje, com um LLM bom e uma tarde livre, qualquer desenvolvedor curioso consegue abrir o próprio celular e ver o que está rodando ali dentro, sem depender da opinião de um influenciador de tecnologia ou de manchete alarmista. As três análises completas estão no GitHub ([TikTok](https://github.com/akitaonrails/tiktok_analysis), [Clash of Kings](https://github.com/akitaonrails/clash_of_kings_analysis), [gov.br](https://github.com/akitaonrails/govbr_analysis)) com o passo a passo pra reproduzir. Pega um app que você usa todo dia e faz o mesmo. É a coisa mais próxima de ler o rótulo antes de comer que a gente tem no mundo do software.
