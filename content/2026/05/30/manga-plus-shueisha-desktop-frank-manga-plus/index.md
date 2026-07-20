---
title: "Solução Completa de Mangá: Frank Manga+, Frank Yomik, extensão Prettify-Manga"
slug: "manga-plus-shueisha-desktop-frank-manga-plus"
date: '2026-05-30T09:00:00-03:00'
draft: false
translationKey: manga-plus-shueisha-desktop-frank-manga-plus
description: "Frank Manga+ leva o catálogo do MANGA Plus ao desktop, enquanto Prettify melhora a leitura em sites e Kindle e Frank Yomik acrescenta furigana ou tradução em páginas japonesas e coreanas."
tags:
- frank-yomik
- frank
- llms
- inteligencia-artificial
---

![Logo do Frank Manga+: o nome estilizado em vermelho e branco sobre fundo preto.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/30/manga-plus/logo.png)

Eu sou assinante do app **MANGA Plus by Shueisha** na Google Play Store do Android. Pra quem não conhece, é o canal oficial da Shueisha (editora japonesa por trás da Shonen Jump) pra ler os mangás dela legalmente, capítulo lançando semanalmente quase no mesmo dia da publicação no Japão. Por dois dólares por mês dá acesso ao catálogo inteiro, com tradução oficial em inglês.

Tenho um Samsung ZFold 7, que é uma das poucas exceções de celular que serve bem pra ler mangá e Kindle (já comentei sobre isso e sobre o [Frank Yomik](/2026/05/14/terminando-maratona-ia-sucesso-ou-fracasso/) no ranking final da maratona de IA). O Fold aberto dá uma tela maior que celular normal e ajuda muito. Mas tem dia que meu olho já está cansado de telinha pequena, e o que eu queria mesmo era ler num monitor OLED de 32 polegadas que está bem na minha frente, perfeito pra leituras longas.

O problema é que **MANGA Plus não tem site oficial pra leitura**. A assinatura está presa ao Android. Existe uma versão pra iOS também, mas web não tem. Tablet ajuda, mas nada bate o conforto de uma tela grande e estática quando você quer ler um arco inteiro de One Piece numa tacada só.

Pra contexto, ultimamente coloquei muita coisa em dia: finalmente fechei Chainsaw Man, Dan Da Dan, Jujutsu Kaisen, Kagurabachi, Akane-banashi, Sakamoto Days e, claro, One Piece. Tem muito mais que eu quero acompanhar, e o conforto do monitor grande virou um problema real pra resolver.

O foco começa no **Frank Manga+**, que resolve o buraco da Shueisha no desktop. No fim também falo de dois complementos do meu setup: [Prettify Manga Reader](#prettify-manga), pra transformar sites de fansub e Kindle Web em leitores decentes, e [Frank Yomik no navegador](#frank-yomik), pra furigana/tradução em Kindle Japan e Naver.

## Decompilando o app

Resolvi atacar. Sentei com o Claude Code e baixamos o xapk oficial do MANGA Plus. Decompilamos pra fonte Java com [jadx](https://github.com/skylot/jadx) e fomos navegando até entender como o app se autentica com a API da Shueisha.

A conclusão é direta: a "assinatura" do usuário, do ponto de vista do app, é um **deviceSecret** de 32 caracteres hexadecimais guardado num arquivo XML simples dentro dos shared preferences do Android. O app gera esse segredo uma vez quando você loga, e a partir daí toda chamada à API (`jumpg-api.tokyo-cdn.com`) é assinada com ele. Sem DRM elaborado, sem token rotativo, sem nada disso. É um segredo único e estático por aparelho.

O detalhe é que **extrair esse segredo do app dá trabalho**, porque por padrão você não tem acesso ao `/data/data/jp.co.shueisha.mangaplus/shared_prefs/config.xml` num Android sem root. Existem três caminhos:

1. **Celular rooteado**: roda `adb shell su -c "cat /data/data/jp.co.shueisha.mangaplus/shared_prefs/config.xml"` e procura o `<string name="secret">...</string>`.
2. **Emulador com root**: instala o Android Studio, cria um AVD com Google Play x86_64, aplica o [rootAVD](https://gitlab.com/newbit/rootAVD) pra ter root via Magisk, loga na sua conta Google que tem a assinatura, instala o MANGA Plus pela Play Store, e roda o mesmo `adb shell` de cima.
3. **Captura de rede com mitmproxy** (mais avançado): roda o emulador root, injeta o CA do mitmproxy via Conscrypt APEX, e intercepta o segredo na primeira chamada autenticada do app.

Os três caminhos estão documentados em detalhe nos [docs/install.md](https://github.com/akitaonrails/frank_mangaplus/blob/main/docs/install.md) e [docs/debugging.md](https://github.com/akitaonrails/frank_mangaplus/blob/main/docs/debugging.md) do repositório. Não vou repetir aqui passo a passo porque é mais ferramenta do que técnica em si, e quem topa o trabalho vai querer ler o original. O importante é que **funciona**, e que basta fazer **uma vez**: depois de extraído, o segredo serve pro app desktop pelo tempo que durar sua assinatura.

Sim, é chato. Mas é o preço de ter um único ponto de configuração que destrava o resto.

## O app desktop

Com o segredo na mão, o resto foi fácil. Montei o **Frank Manga+**, um app nativo em **Rust + Tauri**, com WebView SvelteKit no frontend e cliente Rust com `reqwest` no backend conversando direto com a API da Shueisha. Pra carregar imagens dos capítulos sem vazar URL nem ter dor de cabeça com CORS, criei um esquema custom `mpimg://` interceptado pelo Tauri, que baixa, descriptografa (a API entrega as páginas com XOR simples) e devolve pro WebView.

O app abre numa visão de biblioteca com busca:

![Frank Manga+ aberto na aba Library/Search mostrando uma grade de capas de mangá: One Piece, Sakamoto Days, Kagurabachi, Jujutsu Kaisen, Akane-banashi, Chainsaw Man, Dan Da Dan, entre outros.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/30/manga-plus/library.png)

Clicando num título você vai pra página de detalhe com a lista completa de capítulos e um botão "Continue" que retoma do último capítulo lido:

![Página de detalhe do Kagurabachi no Frank Manga+: capa grande à esquerda, sinopse, e lista virtualizada de capítulos numerados à direita com botão Continue no topo.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/30/manga-plus/title-detail.png)

O leitor abre em página única, com snap por página e as zonas de clique no estilo mangá: clica na **metade esquerda** da página pra avançar e na **direita** pra voltar (sentido de leitura japonês, da direita pra esquerda). Quem prefere teclado tem seta, espaço, `j`/`k` e PageUp/PageDown, tudo funciona. Quando você chega no fim de um capítulo, o próximo já vem em prefetch e é anexado no scroll, então não precisa voltar pra lista de capítulos toda hora. E o resume é por capítulo: se você sai no meio, da próxima vez que abrir aquele capítulo cai exatamente na página onde parou. Pra séries gigantes como One Piece (1100+ capítulos), a lista é virtualizada, então abre instantâneo:

![Leitor do Frank Manga+ em página única mostrando página 12 de 19 do capítulo de Kagurabachi: cena dramática em preto e branco do Chihiro empunhando a espada, com indicador de página no topo e barra de progresso no rodapé.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/30/manga-plus/reader.png)

Num monitor de 32 polegadas, página única desperdiça metade da tela. Por isso tem o **modo página dupla**: aperta `D` (ou clica no ícone de layout no cabeçalho) e o leitor junta as páginas que formam par: a dobra inteira preenche a tela do jeito que o autor desenhou. É como mangá foi feito pra ser lido.

E dá pra ver como isso importa quando compara com encadernação barata. Paperback ruim engole o meio da dobra, exatamente onde a arte deveria se conectar. No digital, quando o leitor junta direito, a cena respira:

| Frank Manga+ juntando a página dupla | Paperback barato engolindo a dobra |
| --- | --- |
| ![Frank Manga+ em modo página dupla num monitor widescreen: uma cena dramática em preto e branco preenche a tela inteira, com uma personagem de maria-chiquinha chorando e os balões "I...." e "...WANT TO GET STRONGER.".](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/30/manga-plus/reader-double-page.png) | ![Paperback de Kaiju No. 8 aberto numa página dupla da Kikoru, com a arte sendo engolida e distorcida pela lombada no centro.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/30/manga-plus/kikoru-paperback-spread.jpeg) |

O `D` cicla por três layouts: **single** (uma página por vez), **double** (pares sequenciais a partir da página 1) e **double-cover** (a primeira página de cada capítulo sozinha e o resto em pares, que é como mangá impresso encaderna a capa solta antes da primeira dobra). A escolha persiste entre capítulos e sessões, então você configura uma vez e esquece.

Tem também um filtro de leitura noturna. Aperta `F` (ou clica no ícone de lua no cabeçalho) e os brancos da página esquentam pro sépia. Branco de LCD castiga a vista no escuro, e isso suaviza sem achatar o contraste:

![Frank Manga+ com o filtro de leitura noturna ativo: uma página dupla em preto e branco ganha um tom âmbar quente, com vários quadros e balões de diálogo em inglês.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/30/manga-plus/reader-eye-protection.png)

O `F` cicla por quatro níveis: **off → low → med → high → off**. O botão fica âmbar e mostra de um a três pontinhos pro nível ativo, e a escolha fica salva no `localStorage` igual às outras preferências do leitor. Por baixo é um filtro CSS de `sepia + brightness + saturate` na pilha inteira de páginas: o sépia empurra a cor pro âmbar mas preserva a faixa de luminância, então preto continua preto e o contraste da arte fica intacto.

Estado de leitura (último capítulo, página corrente) fica no `localStorage` do WebView. Cache de imagens em `~/.cache/mangaplus-reader/`. O `deviceSecret` extraído fica em `~/.config/mangaplus-reader/secret` (Linux/macOS) ou `%APPDATA%\mangaplus-reader\secret` (Windows). Dá pra sobrescrever com a variável de ambiente `MANGAPLUS_SECRET` se preferir.

## Instalação

Tem build pronto pra todas as plataformas principais:

- **Linux**: AppImage, `.deb`, `.rpm`, ou via AUR (`yay -S mangaplus-reader-bin`).
- **macOS**: `.dmg` separado pra Apple Silicon (aarch64) e Intel (x64).
- **Windows**: instalador `.exe`. Não está assinado, então o Windows SmartScreen vai reclamar — clica em "More info → Run anyway".

Todos os artefatos saem nos [Releases do GitHub](https://github.com/akitaonrails/frank_mangaplus/releases).

## Status e contribuições

Isso é **beta**. Funciona pro meu uso (leio várias séries por semana sem dor de cabeça), mas tem features que faltam: filtros de gênero na busca, modo offline real (hoje guarda em cache só o que já foi lido), e o caminho de extração do segredo pra usuários menos técnicos.

Se você assina o MANGA Plus e topa testar, manda issue ou PR. O código é Rust + Svelte, MIT, contribuição bem-vinda: [github.com/akitaonrails/frank_mangaplus](https://github.com/akitaonrails/frank_mangaplus).

Agora finalmente leio One Piece no monitor grande, sem precisar segurar celular ou ficar de pescoço torto. Já valeu o trabalho.

<a id="prettify-manga"></a>

## Bônus: Prettify Manga Reader pra sites de fansub

Além do app desktop, mantenho uma extensão mais simples: [Prettify Manga Reader](https://github.com/akitaonrails/prettify-manga). Ela não traduz nada. O objetivo é arrumar a leitura.

A maioria dos sites de fansub é feia, cheia de banner, e claramente pensada pra celular: uma página embaixo da outra, scroll vertical infinito, boa sorte. Isso é prático pra ler no telefone, mas mangá não foi desenhado como feed de Instagram. Mangá foi pensado pra virar página. Duas páginas abertas ao mesmo tempo. O ritmo de leitura, a virada, o respiro entre quadros, tudo considera esse par.

E vários autores usam isso pra fazer spread de duas páginas. **Kaiju No. 8** faz várias vezes. Se o site joga uma página embaixo da outra, você até lê os balões, mas perde a composição inteira. Você está vendo metade da arte de cada vez e achando que viu tudo.

O normal nesses sites é isso:

![Página típica de fansub antes de ativar a extensão, com a página de mangá cercada pelo layout original do site.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/30/manga-plus/prettify-manga-reader-before.webp)

O Prettify abre um overlay escuro, encaixa a arte na tela e junta páginas no centro quando está em **Book** ou **Double**. O spread volta a parecer uma página dupla de verdade:

![Prettify Manga Reader mostrando um spread de duas páginas corretamente unido no centro, em tela cheia e fundo escuro.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/30/manga-plus/prettify-manga-reader-spread.webp)

Ele tem três modos: **Single** (uma página por tela), **Double** (pares desde o começo) e **Book** (primeira página sozinha, depois pares, que é o jeito de encadernação). Abre em Book por padrão. Se a imagem já é horizontal, mantém como spread em tela cheia. Tem scroll snap pra cada página parar no lugar certo, atalho de teclado, controles pequenos de mouse, ajuda com `?`, e um cartão no fim do capítulo tentando achar próximo/anterior quando o site deixa isso claro.

Também tem filtro noturno em três níveis. Aperta `N` e ele esquenta a página com sepia, brilho e contraste, sem transformar o desenho num cinza morto. Página branca no monitor grande de noite é uma lanterna na cara. Isso resolve.

Pra instalar, vai no [GitHub do Prettify Manga Reader](https://github.com/akitaonrails/prettify-manga), baixa o zip em **Releases**, descompacta numa pasta permanente, abre `chrome://extensions` ou `brave://extensions`, liga **Developer mode**, clica em **Load unpacked** e escolhe a pasta descompactada. Se quiser montar do fonte, clona o repo, roda `npm test`, depois `npm run package`, descompacta o zip gerado em `dist/` e carrega essa pasta.

No Kindle Web Reader, o Prettify faz menos de propósito. Em URLs tipo `read.amazon.com/manga/...`, `read.amazon.co.jp/manga/...`, `read.amazon.co.uk/manga/...` e domínios `read.kindle.*`, não tenta reconstruir o livro numa overlay própria. O leitor da Amazon já resolve conta, página e DRM; a extensão só injeta uma barrinha discreta no canto inferior direito e atalhos de teclado por cima do reader nativo.

![Kindle Web Reader com a barra discreta do Prettify Manga Reader no canto inferior direito, mostrando o botão de Night ativo pra suavizar a página de mangá.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/30/manga-plus/prettify-manga-reader-kindle.webp)

Espaço, PageDown e setas avançam página; Shift+Space, PageUp e setas opostas voltam; Home/End vão pro começo ou fim quando o reader nativo aceita, com fallback de scroll; `N` cicla o filtro noturno. Não guarda credenciais da Amazon, não mexe em sessão, não precisa token no código. É só conforto visual e teclado em cima do Kindle Web que já existe.

<a id="frank-yomik"></a>

## Bônus 2: Frank Yomik agora também no desktop via extensão

Quem leu o [balanço da maratona de IA](/2026/05/14/terminando-maratona-ia-sucesso-ou-fracasso/) lembra do [Frank Yomik](https://github.com/akitaonrails/FrankYomik), meu projeto self-hosted que pega uma página de mangá ou webtoon, detecta os balões com RT-DETR-v2, faz OCR, manda pro Ollama local (`qwen3:14b`) traduzir, e devolve a página com o texto traduzido no lugar. Já expliquei a história e os detalhes técnicos no post [Meu primeiro fracasso com Vibe Code e como consertei | Frank Yomik](/2026/03/05/meu-primeiro-fracasso-com-vibe-code-e-como-consertei-frank-yomik/). Aqui o ponto é o pedaço novo no desktop.

Originalmente tinha só cliente Flutter pra Android e Linux, que abria Kindle Japan e Naver Webtoon dentro de um WebView. Acontece que rodar app Flutter dentro de WebView no desktop pra ler Kindle é meio canhão pra mosca. No desktop você já tem Chromium aberto. O que faltava era uma extensão de navegador.

Nas últimas semanas adicionei isso. Extensão Manifest V3 pra Chromium/Brave/Edge, conversando com o mesmo servidor self-hosted do Yomik. Roda em [read.amazon.co.jp](https://read.amazon.co.jp), [read.kindle.co.jp](https://read.kindle.co.jp), [comic.naver.com](https://comic.naver.com) e na versão mobile do Naver. A página fica visualmente idêntica ao original, sem botão injetado nem HUD na cara do leitor. Toda configuração mora no popup:

![Popup do Frank Yomik aberto sobre uma página do Kindle Japan mostrando Initial D em japonês: campos pra API base URL, auth token, checkboxes pra Kindle reader e Naver Webtoon, dropdown de manga pipeline em Furigana, target language English, e bloco de webtoon prefetch.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/30/manga-plus/yomik-extension-popup.png)

O content script pega a imagem da página atual e manda pro servidor. O bearer token fica no service worker, então não vaza pro JS da página. Quando a tradução volta, a imagem é trocada na hora no lugar da original. Tem cache local pra não retraduzir página já vista, botão de "force reprocess" pra quando precisa reportar bug, e autosave de configuração. Detalhes no [README da extensão](https://github.com/akitaonrails/FrankYomik/tree/main/extension), e o zip pra Load Unpacked sai nos Releases do repo.

Na prática, hoje o monitor de 32" virou minha mesa de leitura. Frank Manga+ abre o catálogo oficial da Shueisha em inglês (One Piece, Chainsaw Man, e o que mais a Shonen Jump publicar). Quando é fansub ou Kindle Web e só quero conforto visual, o Prettify resolve reader, teclado e filtro noturno. Quando quero ler coisa japonesa sem tradução oficial, abro Kindle Japan numa aba e o Yomik manda furigana ou tradução LLM em cima da página. Pra webtoon coreano da Naver, mesma história, mesma extensão.

A parte boa é que cada projeto resolve um pedaço diferente e eles se completam. Frank Manga+ existe porque a Shueisha não tem site. Prettify deixa readers de navegador menos sofridos. O Yomik existe porque o resto do mangá que eu leio não tem tradução oficial decente em tempo hábil. Pra quem é doente de mangá igual eu, é o setup que eu queria há anos.
