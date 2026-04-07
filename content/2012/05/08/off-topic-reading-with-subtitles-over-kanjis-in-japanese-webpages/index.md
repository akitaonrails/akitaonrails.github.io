---
title: "[Off-Topic] Lendo com legendas sobre Kanjis em páginas japonesas"
date: '2012-05-08T10:36:00-03:00'
slug: lendo-com-legendas-sobre-kanjis-em-paginas-japonesas
translationKey: kanji-subtitles-japanese-webpages
aliases:
- /2012/05/08/off-topic-reading-with-subtitles-over-kanjis-in-japanese-webpages/
tags:
- off-topic
- learning
- mac
- traduzido
draft: false
---

Acabei de tropeçar nisso e, como é meio chato de instalar da primeira vez, resolvi juntar as peças que fazem funcionar. É tão útil que eu precisava postar a respeito.

Se você está aprendendo japonês, isso vai se mostrar uma ferramenta que vale ouro. Eu sou japonês, mas não dei a devida atenção ao treino de Kanji quando era criança. E hoje aparece a fatura: consigo ler Kanji só até um nível que no Japão seria considerado abaixo do colegial. Ainda é bem útil, mas significa que não consigo ler a maioria dos sites em japonês com velocidade suficiente.

Eu já conheço há bastante tempo um add-on do Firefox do qual gosto muito, chamado [Rikaichan](https://addons.mozilla.org/pt-BR/firefox/addon/rikaichan/). Quando habilitado, basta passar o mouse sobre o texto em kanji e ele abre um popup com a tradução. Você precisa instalar o add-on do Firefox no link acima e um dicionário apropriado para o seu idioma nativo a partir da [página do Rikaichan](http://www.polarcloud.com/rikaichan/). E pronto.

![](http://s3.amazonaws.com/akitaonrails/assets/2012/5/8/Screen%20Shot%202012-05-08%20at%2010.30.34%20AM_original.png?1336483998)


Mas se você gosta de ler mangá (quadrinhos japoneses), provavelmente conhece o "Furigana", que é mais ou menos como "legendar" os Kanjis com Hiragana ou Katakana, que são os alfabetos silábicos japoneses (o primeiro para palavras puramente japonesas, o segundo para palavras estrangeiras). Isso torna a leitura e a compreensão dos Kanjis mais difíceis super fáceis e muito mais rápida do que ficar passando o mouse em cima dos Kanjis ou consultando manualmente o dicionário para cada ideograma.

Um trecho normal de uma página japonesa fica assim:

![](http://s3.amazonaws.com/akitaonrails/assets/2012/5/8/Screen%20Shot%202012-05-08%20at%2010.17.14%20AM_original.png?1336483852)

Mas com o [Furigana Inserter](https://addons.mozilla.org/pt-BR/firefox/addon/furigana-inserter/) o mesmo trecho fica assim:

![](http://s3.amazonaws.com/akitaonrails/assets/2012/5/8/Screen%20Shot%202012-05-08%20at%2010.17.25%20AM_original.png?1336483884)

Para instalar, primeiro você instala o [add-on](https://addons.mozilla.org/pt-BR/firefox/addon/furigana-inserter/). Depois precisa instalar também o add-on [HTML Ruby](https://addons.mozilla.org/firefox/addon/html-ruby/). Por fim, precisa instalar este [dicionário](http://code.google.com/p/itadaki/downloads/detail?name=furiganainserter-dictionary-1.2.7z). É um arquivo 7-zip que você precisa descompactar e arrastar manualmente sobre o Firefox para instalar.

Se você está num Mac, vou assumir que sabe o que é o [Homebrew](https://github.com/mxcl/homebrew) e que já tem ele instalado. Porque aí dá para instalar o Mecab assim:

* * *

brew install mecab  
brew install mecab-ipadic  
-

Por fim, parece que você precisa avisar manualmente o Furigana Inserter sobre o Mecab, criando um symlink dentro da pasta da extensão:

* * *

ln s /usr/local/lib/libmecab.dylib ~/Library/Application\ Support/Firefox/Profiles/454dy2eg.default/extensions/furiganainserter@zorkzero.net/mecab/libmecab.dylib  
--

Tenha em mente que a pasta de Profile do Firefox vai ter um nome diferente no seu computador. A do exemplo é a do meu Mac. Abre o terminal e usa tab para autocompletar cada pasta enquanto digita, que deve funcionar tranquilamente.

Reinicia o Firefox, clica com o botão direito em páginas em japonês e vai aparecer uma opção "Enable Furigana" esperando por você. O Rikaichan parece se comportar mal quando você passa o mouse sobre Kanjis com Furigana habilitado, então pode ser necessário desabilitar o Furigana para usar o Rikaichan. Mas é um bom compromisso e pode abrir um monte de conteúdo novo em japonês para a gente consumir.

Mais uma razão para usar Firefox.
