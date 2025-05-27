---
title: "[Small Bites] Trocando de SASS para SASSC e colocando no Heroku"
date: '2015-05-15T13:07:00-03:00'
slug: small-bites-trocando-de-sass-para-sassc-e-colocando-no-heroku
tags:
- learning
- rails
- heroku
- front-end
draft: false
---

Obs: libsass não necessariamente é 100% compatível com Sass-Ruby ainda. Em muitos casos você não deve ter problemas (teste!) Mas fique de olho nesta [tabela comparativa de compatibilidade](http://sass-compatibility.github.io). No instante da publicação o libsass 3.2 está a 98.53% de compatibilidade!

Nada foi mais disruptivo no mundo de desenvolvimento de stylesheets do que o advento do SASS em 2007. Sim, faz 8 anos, e sim, estou exagerando, CSS 3 foi bem mais disruptivo, mas vocês entenderam! A menos que eu esteja enganado foi quando se entendeu também que era possível transformar uma linguagem tosca (CSS 2) em algo bem mais trabalhável, foi o início do uso do conceito de [transpilers](http://en.wikipedia.org/wiki/Source-to-source_compiler) para Web.

Por todos esses anos o Sass, escrito em Ruby, serviu seu propósito muito bem, mas sabemos que ele é um dos calcanhares de aquiles quando fazemos deployment de projetos Ruby. Em paralelo se iniciou uma reimplementação em C ([libsass](http://libsass.org)) para tornar o Sass não dependente de Ruby (agnóstico de linguagem) e com performance mais adequada.

O pessoal de Node e outras linguagens já usa o libsass em pacotes como o node-sass. É hora do filho pródigo retornar à sua casa. Para usar em projetos Ruby on Rails precisamos fazer o seguinte:

Atualizar o arquivo <tt>Gemfile</tt> e trocar <tt>sass-rails</tt> por <tt>sassc-rails</tt>:

--- ruby
gem 'sassc-rails'
```

Rodar o bom e velho <tt>bundle install</tt> e adicionar um arquivo chamado <tt>.buildpacks</tt> à raiz do seu projeto:

```
https://github.com/djmattyg007/heroku-buildpack-sassc.git#1.1.0
https://github.com/heroku/heroku-buildpack-ruby.git#v137
```

Então execute a seguinte linha de comando:

```
heroku config:add BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git
```

O conceito é simples: todo container do Heroku é configurado através de uma [buildpack](https://devcenter.heroku.com/articles/buildpacks) (que controla os fluxos de compilação e lançamento). O Heroku escolhe o padrão correto para sua aplicação. O que fizemos acima foi substituir por um [Custom Buildpack](https://devcenter.heroku.com/articles/third-party-buildpacks). Uma das alternativas seria fazer um fork do buildpack de Ruby e adicionar o libsass. Por outro lado já existe um buildpack só com o libsass e podemos criar um slug com duas buildpacks usando a buildpack "heroku-buildpack-multi" criada pelo [@ddollar](https://github.com/ddollar).

Ou digamos que gostaríamos de rodar uma aplicação Ruby mas queremos ter dependências de Node ou Python para executar alguma coisa específica durante o deployment, basta adicionar outras buildpacks ao arquivo <tt>.buildpacks</tt>.

Enfim, com isso vamos conseguir reduzir consideravelmente (depende da quantidade de stylesheets que você tem no seu projeto) o tempo de cada deployment.
