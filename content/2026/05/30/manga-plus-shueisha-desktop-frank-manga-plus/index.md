---
title: "Manga Plus (Shueisha) no Desktop: Frank Manga+"
slug: "manga-plus-shueisha-desktop-frank-manga-plus"
date: '2026-05-30T09:00:00-03:00'
draft: false
translationKey: manga-plus-shueisha-desktop-frank-manga-plus
tags:
  - rust
  - tauri
  - manga
  - desktop
  - opensource
  - shueisha
---

![Logo do Frank Manga+: o nome estilizado em vermelho e branco sobre fundo preto.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/30/manga-plus/logo.png)

Eu sou assinante do app **MANGA Plus by Shueisha** na Google Play Store do Android. Pra quem não conhece, é o canal oficial da Shueisha (editora japonesa por trás da Shonen Jump) pra ler os mangás dela legalmente, capítulo lançando semanalmente quase no mesmo dia da publicação no Japão. Por dois dólares por mês dá acesso ao catálogo inteiro, com tradução oficial em inglês.

Tenho um Samsung ZFold 7, que é uma das poucas exceções de celular que serve bem pra ler mangá e Kindle (já comentei sobre isso e sobre o [Frank Yomik](/2026/05/14/terminando-maratona-ia-sucesso-ou-fracasso/) no ranking final da maratona de IA). O Fold aberto dá uma tela maior que celular normal e ajuda muito. Mas tem dia que meu olho já está cansado de telinha pequena, e o que eu queria mesmo era ler num monitor OLED de 32 polegadas que está bem na minha frente, perfeito pra leituras longas.

O problema é que **MANGA Plus não tem site oficial pra leitura**. A assinatura está presa ao Android. Existe uma versão pra iOS também, mas web não tem. Tablet ajuda, mas nada bate o conforto de uma tela grande e estática quando você quer ler um arco inteiro de One Piece numa tacada só.

Pra contexto, ultimamente coloquei muita coisa em dia: finalmente fechei Chainsaw Man, Dan Da Dan, Jujutsu Kaisen, Kagurabachi, Akane-banashi, Sakamoto Days e, claro, One Piece. Tem muito mais que eu quero acompanhar, e o conforto do monitor grande virou um problema real pra resolver.

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

E o leitor em si tem snap por página, navegação por teclado, clique no rodapé pra avançar, e prefetch do próximo capítulo enquanto você lê o atual. Pra séries gigantes como One Piece (1100+ capítulos), a lista é virtualizada, então abre instantâneo:

![Leitor do Frank Manga+ mostrando página 12 de 19 do capítulo de Kagurabachi: cena dramática em preto e branco do Chihiro empunhando a espada, com indicador de página no topo e barra de progresso no rodapé.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/30/manga-plus/reader.png)

Estado de leitura (último capítulo, página corrente) fica no `localStorage` do WebView. Cache de imagens em `~/.cache/mangaplus-reader/`. O `deviceSecret` extraído fica em `~/.config/mangaplus-reader/secret` (Linux/macOS) ou `%APPDATA%\mangaplus-reader\secret` (Windows). Dá pra sobrescrever com a variável de ambiente `MANGAPLUS_SECRET` se preferir.

## Instalação

Tem build pronto pra todas as plataformas principais:

- **Linux**: AppImage, `.deb`, `.rpm`, ou via AUR (`yay -S mangaplus-reader-bin`).
- **macOS**: `.dmg` separado pra Apple Silicon (aarch64) e Intel (x64).
- **Windows**: instalador `.exe`. Não está assinado, então o Windows SmartScreen vai reclamar — clica em "More info → Run anyway".

Todos os artefatos saem nos [Releases do GitHub](https://github.com/akitaonrails/frank_mangaplus/releases).

## Status e contribuições

Isso é **beta**. Funciona pro meu uso (leio várias séries por semana sem dor de cabeça), mas tem features que faltam: paginação invertida pra mangá tradicional japonês, filtros de gênero na busca, modo offline real (hoje guarda em cache só o que já foi lido), e o caminho de extração do segredo pra usuários menos técnicos.

Se você assina o MANGA Plus e topa testar, manda issue ou PR. O código é Rust + Svelte, MIT, contribuição bem-vinda: [github.com/akitaonrails/frank_mangaplus](https://github.com/akitaonrails/frank_mangaplus).

Agora finalmente leio One Piece no monitor grande, sem precisar segurar celular ou ficar de pescoço torto. Já valeu o trabalho.

## Bônus: Frank Yomik agora também no desktop via extensão

Quem leu o [balanço da maratona de IA](/2026/05/14/terminando-maratona-ia-sucesso-ou-fracasso/) lembra do [Frank Yomik](https://github.com/akitaonrails/FrankYomik), meu projeto self-hosted que pega uma página de mangá ou webtoon, detecta os balões com RT-DETR-v2, faz OCR, manda pro Ollama local (`qwen3:14b`) traduzir, e devolve a página com o texto traduzido no lugar. Originalmente tinha só cliente Flutter pra Android e Linux, que abria Kindle Japan e Naver Webtoon dentro de um WebView.

Acontece que rodar app Flutter dentro de WebView no desktop pra ler Kindle é meio canhão pra mosca. No desktop você já tem Chromium aberto. O que faltava era uma extensão de navegador.

Nas últimas semanas adicionei isso. Extensão Manifest V3 pra Chromium/Brave/Edge, conversando com o mesmo servidor self-hosted do Yomik. Roda em [read.amazon.co.jp](https://read.amazon.co.jp), [read.kindle.co.jp](https://read.kindle.co.jp), [comic.naver.com](https://comic.naver.com) e na versão mobile do Naver. A página fica visualmente idêntica ao original, sem botão injetado nem HUD na cara do leitor. Toda configuração mora no popup:

![Popup do Frank Yomik aberto sobre uma página do Kindle Japan mostrando Initial D em japonês: campos pra API base URL, auth token, checkboxes pra Kindle reader e Naver Webtoon, dropdown de manga pipeline em Furigana, target language English, e bloco de webtoon prefetch.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/30/manga-plus/yomik-extension-popup.png)

O content script pega a imagem da página atual e manda pro servidor. O bearer token fica no service worker, então não vaza pro JS da página. Quando a tradução volta, a imagem é trocada na hora no lugar da original. Tem cache local pra não retraduzir página já vista, botão de "force reprocess" pra quando precisa reportar bug, e autosave de configuração. Detalhes no [README da extensão](https://github.com/akitaonrails/FrankYomik/tree/main/extension), e o zip pra Load Unpacked sai nos Releases do repo.

Na prática, hoje o monitor de 32" virou minha mesa de leitura. Frank Manga+ abre o catálogo oficial da Shueisha em inglês (One Piece, Chainsaw Man, e o que mais a Shonen Jump publicar). Quando bate vontade de ler coisa japonesa que não tem tradução oficial, abro Kindle Japan numa aba e o Yomik manda furigana ou tradução LLM em cima da página. Pra webtoon coreano da Naver, mesma história, mesma extensão.

A parte boa é que os dois projetos resolvem problemas diferentes e se completam. Frank Manga+ existe porque a Shueisha não tem site. O Yomik existe porque o resto do mangá que eu leio não tem tradução oficial decente em tempo hábil. Pra quem é doente de mangá igual eu, é o setup que eu queria há anos.
