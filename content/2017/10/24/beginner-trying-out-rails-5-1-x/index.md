---
title: "Iniciante Experimentando o Rails 5.1.x"
date: '2017-10-24T16:29:00-02:00'
slug: iniciante-experimentando-o-rails-5-1-x
translationKey: beginner-trying-rails-51
aliases:
- /2017/10/24/beginner-trying-out-rails-5-1-x/
tags:
- beginner
- rubyonrails
- rails51
- nodejs
- webpack
- reactjs
- traduzido
draft: false
---

Uma coisa chata de lidar com projetos de clientes é que a maioria deles demora para fazer um upgrade completo de framework. E não dá para culpá-los, já que boa parte das dependências do ecossistema também leva um tempão para atualizar.

O [Rails 5.2 Beta](http://weblog.rubyonrails.org/2017/9/29/this-week-in-rails-getting-closer-to-rails-5-2-beta/) está chegando, e eu apostaria que a maioria dos projetos Rails lá fora ainda está na versão 4.2, ainda cogitando o salto para o 5.0 (que até não é um upgrade tão complicado).

A propósito, caso você não saiba, o site oficial do Rails Guides tem uma seção dedicada a upgrades. É o [A Guide for Upgrading Ruby on Rails](http://guides.rubyonrails.org/upgrading_ruby_on_rails.html). O processo de upgrade não é tão difícil **se, e somente se**:

- Você tiver uma cobertura de testes razoável. No mínimo, feature specs para as partes mais críticas do sistema.

- Você subir apenas uma versão de cada vez, nunca pular direto para a mais recente. Por exemplo: se está no Rails 4.1, primeiro sobe para o 4.2, confirma que tudo funciona. Depois vai para o 5.0. E só então vai para o 5.1. Cada versão tem **muitas** deprecations, mudanças de comportamento, alterações na configuração padrão e recursos novos. Cada ponto merece atenção cuidadosa.

Então, o que você está perdendo se ainda está no Rails 4.2?

De novo, caso não saiba, o site oficial do Rails Guides também compila Release Notes detalhadas e fáceis de ler para cada nova versão. As mais recentes são as [Ruby on Rails 5.1 Release Notes](http://guides.rubyonrails.org/5_1_release_notes.html).

## Começando um novo projeto

O comando `rails new` ganhou várias flags novas. Acho que as que a maioria vai usar são:

```
rails new --skip-action-mailer --skip-coffee --webpack=react my_fancy_new_project
```

Você pode desabilitar recursos que não precisa, como o ActionMailer. Pode desabilitar o CoffeeScript. Foi legal por um tempo, mas agora que temos ES6 é melhor usar direto.

O Rails 5.1 vem com suporte a webpack. Mas até o Rails 5.2 chegar, precisamos rodar o `webpack-dev-server` manualmente em modo de desenvolvimento para ter hot reload dos assets. Para isso, recomendo instalar o bom e velho [Foreman](https://github.com/ddollar/foreman). Instale assim:

```
gem install foreman
```

E adicione um arquivo `Procfile.dev` no seu projeto com o seguinte conteúdo:

```
web: ./bin/rails s -b 0.0.0.0 -p 3000
webpack: ./bin/webpack-dev-server
```

Agora você pode subir seu servidor de desenvolvimento assim:

```
foreman start -f Procfile.dev
```

Em produção, não precisa do `webpack-dev-server`, pois a task `bin/rails assets:precompile` consegue compilar todos os assets como arquivos estáticos com timestamps em `public/assets`.

## Mudanças no Front-end

Agora você pode comemorar: Yarn, Webpack, e sem mais jQuery pré-instalado. Samuel Muller tem um [artigo bem bacana](http://samuelmullen.com/articles/embracing-change-rails51-adopts-yarn-webpack-and-the-js-ecosystem/) que resume a maioria dessas mudanças em mais detalhes.

O Ruby on Rails agora suporta oficialmente tudo o que o ecossistema Javascript tem a oferecer. Não falta mais nada.

Acabou a era de fazer vendor manual de assets JS no diretório `vendor/assets/javascripts`. Não precisa mais do [Rails Assets](https://rails-assets.org/), que era uma fonte secundária do RubyGems específica para empacotar bibliotecas JS como gems.

Digamos que, por algum motivo, você quer o jQuery de volta. Agora é só fazer:

```
yarn add jquery
```

E, como de costume, adicionar no seu manifest `app/assets/javascripts/application.js`:

```
// app/assets/javascripts/application.js
...
//= require jquery
...
//= require_tree .
```

O tal ["suporte ao Yarn no Rails 5.1"](https://github.com/rails/rails/pull/26836) se resume a alguns wrappers e boilerplate. Você pode rodar `rails yarn:install` para instalar as dependências, mas pode igualmente digitar `yarn` que ele instala tudo o que está declarado no `package.json`, como em qualquer projeto puramente Javascript.

Toda a mágica da integração vem com a inclusão da gem [Webpacker](https://github.com/rails/webpacker). Ela adiciona um monte de configuração de boilerplate para o webpack. E, **dado bônus**: você pode incluí-la hoje mesmo nos seus projetos Rails 4.2+. Comece adicionando a gem ao `Gemfile`:

```
# Gemfile
gem 'webpacker', '~> 3.0'
```

Depois `bundle install` normalmente e rode:

```
bundle exec rake webpacker:install
```

Se não usou a flag `--webpack=react` no `rails new`, pode adicionar depois. Ou adicionar Angular também:

```
bundle exec rake webpacker:install:angular
bundle exec rake webpacker:install:react 
```

Se estiver no Rails 5.1, substitua `bundle exec rake` por `bin/rails`.

Adicionar componentes React de verdade exige um pouco mais do que os comandos acima, mas os detalhes fogem ao escopo deste post.

Andy Barnov tem um [bom post](https://x-team.com/blog/get-in-full-stack-shape-with-rails-5-1-webpacker-and-reactjs/) sobre como seguir a convenção de packs do Rails 5.1 para adicionar seus componentes React no pipeline. Como ele recomenda: não briga com as convenções e você fica tranquilo.

Curiosamente, mesmo tendo usado a flag `--webpack-react` no `rails new`, ainda precisei rodar o seguinte comando para inicializar o suporte a webpack e react:

```
./bin/rails webpacker:install:react
```

Mas uma vez feito isso, você tem um novo lugar para adicionar componentes React: o diretório `app/javascripts/packs`. E nas views, em vez do habitual `javascript_include_tag`, você usa o novíssimo `javascript_pack_tag`. O resto você consegue descobrir a partir do componente de exemplo `hello_react.jsx` que é gerado automaticamente.

## Considerações Finais

Agora você tem muito mais opções para Javascript, já que o Rails 5.1 abraça de vez os padrões atuais.

Houve uma época em que ninguém sabia direito como agilizar um [Asset Pipeline](http://guides.rubyonrails.org/asset_pipeline.html). Era uma bagunça compilar todos os assets num único arquivo com timestamps para cache busting — mas a gem **Sprockets** resolveu isso.

Houve uma época em que o Javascript 5 era uma bagunça monumental. Bibliotecas como o jQuery "consertaram" de fato a situação do DOM nos browsers, e o CoffeeScript normalizou a linguagem de um jeito que a tornava prazerosa. O ES6 veio tomar as rédeas, mas é muito injusto criticar o jQuery e o CoffeeScript: nem o ES6 nem o HTML5 existiam para resolver o problema quase 10 anos atrás. O jQuery e o CoffeeScript estavam lá, e resolveram.

Quando Angular, Ember e React começaram a surgir, já tínhamos uma solução boa o suficiente para sites pesados em Javascript com o [Turbolinks](https://github.com/turbolinks/turbolinks). Ainda é uma ótima solução que você deveria considerar antes de adicionar uma solução React/Redux completa (e às vezes desnecessária) de uma tacada só.

CSS é outro assunto. A comunidade Rails também criou o Sass (que o Twitter depois invejou e copiou como Less para o framework Bootstrap).

É fácil olhar para o cenário atual e simplesmente repetir que CoffeeScript é ruim ou que Sprockets é ruim. Mas nos últimos 10 anos essas ferramentas eram o estado da arte — numa época em que as pessoas não tinham Yarn, Webpack, React e tudo o que surgiu nos últimos 3 anos ou assim.

O Rails 5.1 é um release muito bom para casar o melhor do Rails com o melhor que se estabilizou no cenário caótico do Javascript. Recomendo fortemente que qualquer projeto novo, em campo aberto, comece com o Rails 5.1 em mente.

O que me motivou a escrever este post foi destacar que muita gente faz perguntas que já estão respondidas no [Rails Guides](http://guides.rubyonrails.org/) oficial. Não só sobre como instalar e usar os vários componentes do framework, mas também como fazer upgrade e quais são as novidades de cada release. Vale a pena dar uma olhada mais cuidadosa por lá.
