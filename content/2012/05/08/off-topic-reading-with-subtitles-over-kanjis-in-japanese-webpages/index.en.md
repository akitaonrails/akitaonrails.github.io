---
title: "[Off-Topic] Reading with subtitles over Kanjis in Japanese webpages"
date: '2012-05-08T10:36:00-03:00'
slug: off-topic-reading-with-subtitles-over-kanjis-in-japanese-webpages
translationKey: kanji-subtitles-japanese-webpages
description: "Rikaichan, Furigana Inserter, HTML Ruby, and Mecab can add hiragana or katakana readings to Japanese webpages. The combination helps reading, but Furigana must be disabled to use Rikaichan."
tags:
- learning
- developer-tools
- off-topic
draft: false
---

This is something I just stumbled upon and because it's tricky to install the first time I decided to grab the pieces that make it work. It's so useful I had to post about it.

If you're learning Japanese this will definitely prove to be an invaluable tool. I am Japanese but I didn't pay attention to proper Kanji training when I was a child. It shows now, as I can read Kanji only to what would be considered below high-school level in Japan. Still very useful, but it means I can't read most websites in Japanese fast enough.

I've known of a Firefox add-on I'm very fond of for a long time now called [Rikaichan](http://web.archive.org/web/20120624074033/https://addons.mozilla.org/pt-br/firefox/addon/rikaichan/). When enabled, you hover your mouse over the kanji text and it will popup a box with the translation. You install the Firefox add-on in the previous link and a proper dictionary to your native language from [Rikaichan's webpage](http://web.archive.org/web/20120512063523/http://polarcloud.com/rikaichan). And that's it.

![](http://s3.amazonaws.com/akitaonrails/assets/2012/5/8/Screen%20Shot%202012-05-08%20at%2010.30.34%20AM_original.png?1336483998)


But if you like to read Manga (Japanese Comics), you're probably familiar with Furigana. It's kind of like "subtitling" over the Kanjis with Hiragana or Katakana, the Japanese syllabaries (the first for Japanese only words, the second for foreign words).

That makes reading the more difficult Kanjis way easier and faster than hovering over each one or looking manually into the dictionary ideogram by ideogram.

A normal snippet of a Japanese webpage looks like this:

![](http://s3.amazonaws.com/akitaonrails/assets/2012/5/8/Screen%20Shot%202012-05-08%20at%2010.17.14%20AM_original.png?1336483852)

But with [Furigana Inserter](http://web.archive.org/web/20131115215917/https://addons.mozilla.org/pt-BR/firefox/addon/furigana-inserter/) the same snippet looks like this:

![](http://s3.amazonaws.com/akitaonrails/assets/2012/5/8/Screen%20Shot%202012-05-08%20at%2010.17.25%20AM_original.png?1336483884)

To install it, first you install the [add-on](http://web.archive.org/web/20131115215917/https://addons.mozilla.org/pt-BR/firefox/addon/furigana-inserter/). Then you install the [HTML Ruby](http://web.archive.org/web/20130501123822/https://addons.mozilla.org/en-US/firefox/addon/html-ruby/) add-on as well. Finally, you install this [dictionary](http://web.archive.org/web/20111115202242/http://code.google.com:80/p/itadaki/downloads/detail?name=furiganainserter-dictionary-1.2.7z). It's a 7-zip file you must decompress and manually drag it over Firefox to install.

If you're on a Mac, I'm assuming you know what [Homebrew](https://github.com/mxcl/homebrew) is and already have that installed. Because then you can install Mecab like this:

```bash
brew install mecab
brew install mecab-ipadic
```

Finally, it seems like you must manually make Furigana Inserter aware of Mecab by adding a symlink into its extension folder:

```bash
ln -s /usr/local/lib/libmecab.dylib ~/Library/Application\ Support/Firefox/Profiles/454dy2eg.default/extensions/furiganainserter@zorkzero.net/mecab/libmecab.dylib
```

Understand that the Firefox Profile folder will have a different name on your computer. The one in the example is in my Mac. Open the terminal and tab to autocomplete each folder as you type and it should work just fine.

Restart Firefox, right-click in Japanese pages and you will have an "Enable Furigana" option waiting for you. Rikaichan seems to misbehave when hovering over Furigana enabled Kanji, so you may need to disable Furigana to use Rikaichan. But it's a good compromise and may open a whole lot of new content in Japanese for us to consume.

One more reason to use Firefox.
