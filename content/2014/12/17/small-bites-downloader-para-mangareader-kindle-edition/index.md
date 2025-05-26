---
title: "[Small Bites] Downloader para MangaReader (Kindle Edition)"
date: '2014-12-17T21:24:00-02:00'
slug: small-bites-downloader-para-mangareader-kindle-edition
tags:
- ruby
draft: false
---

Acho que esta vai ser realmente a primeira small bite versão miniatura mesmo! :-)

![Kindle Paperwhite + Manga = Diversão](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/476/IMG_20141216_162841251.jpg)

Quem acompanha o blog faz tempo sabe que curto muito mangas/animes (me perguntem qualquer coisa, especialmente se for das décadas de 60 a 90). 4 anos atrás eu fiz um [downloader](http://www.akitaonrails.com/2010/07/31/downloader-para-onemanga-com#.VJIOdcZHnxg) para o antigo site OneManga (que fechou). 

Recentemente resolvi adquirir um Kindle Paperwhite (que aliás, é excepcional, principalmente se comparado ao último Kindle 2 que eu tive). E além de tudo é o formato perfeito para mangas (que são preto-e-branco por natureza).

Procurei ferramentas e achei vários horríveis, pra Windows. Então, por que não desenferrujar um pouco e fazer um pacote completo que baixa sua coleção completa de mangas e já gera um PDF otimizado pro tamanho do Kindle? 

Aproveitei pra abusar um pouco do [Typhoeus](https://github.com/typhoeus/typhoeus) que usa a libcurl por baixo e permite fazer downloads paralelos. A única coisa que vai limitar o processo é a velocidade de banda do seu provedor de internet.

Sem enrolar mais, o código-fonte [está no Github](https://github.com/akitaonrails/manga-downloadr) ou instale diretamente a [gem](https://rubygems.org/gems/manga-downloadr):

---
gem install manga-downloadr
---

E para usar, navegue no site do [MangaReader.net](http://www.mangareader.net) escolha o manga que quiser e faça assim:

---
manga-downloadr -n monster -u http://www.mangareader.net/99/monster.html -d /Users/akitaonrails/Documents/MangaReader
---

E pronto! Se acontecer alguma interrupção (a internet cair ou coisa parecida) só execute novamente o mesmo comando e ele vai continuar de onde parou. Boa diversão!

PS: Não preciso dizer que não funciona em Windows ;-)
