---
title: "[Small-Bites] Em defesa do Asset Pipeline: tudo que você precisa"
date: '2014-12-02T17:26:00-02:00'
slug: small-bites-em-defesa-do-asset-pipeline-tudo-que-voce-precisa
tags:
- learning
- rails
- javascript
- front-end
draft: false
---

No atual caos que são as opções no mundo Javascript para gerenciamento de dependências (CommonJS, AMD, ES6-modules), sistemas de build (Grunt, Gulp, Broccoli), pacotes (NPM, Bower) é fácil sermos contaminados com o velho "F.U.D." (Fear, Uncertainty, Doubt).

Asset Management é um problema praticamente todo resolvido no mundo Rails desde Fevereiro de 2009 (nós basicamente criamos o conceito). Mesmo assim, ainda temos que ouvir afirmações sem sentido como "precisamos consertar ou substituir o Asset Pipeline" e então nascem coisas como "requirejs-rails" ou receitas de como desabilitar o Sprockets e usar outras coisas. Em resumo: não faça isso.

Até eu fico sem paciência para participar dessas discussões porque, no final do dia, o que precisamos é da solução mais simples que funciona e podemos confiar. E sem mais delongas eu elejo a combinação ModuleJS e Rails-Assets como as melhores opções.

Antes de continuar vou assumir que você pelo menos leu (ou já conhece) os seguintes assuntos:

* [Asset Pipeline para Iniciantes](http://www.akitaonrails.com/2012/07/01/asset-pipeline-para-iniciantes)
* [Asset Pipeline para Iniciantes - Parte 2](http://www.akitaonrails.com/2012/07/01/asset-pipeline-para-iniciantes-parte-2)
* [Rails Assets](http://www.akitaonrails.com/2013/12/13/rails-assets)

Para ilustrar a solução vamos direto a um pequeno exemplo. Se for algo pequeno, podemos ficar tentados a colocar tudo no <tt>app/assets/application.js</tt>, como por exemplo:

--- javascript
Foo = {
  hello: function() {
    return "Hello";
  },

  world: function() {
    return "World";
  }
}

Bar = {
  helloWorld: function() {
    return Foo.hello() + " " + Foo.world();
  }
}

$(function() {
  $('body').append('<p>' + Bar.helloWorld() + '</p>');
})
```

Isso vai simplesmente adicionar um parágrafo escrito "Hello World" na página. A idéia é um exemplo bem trivial para que a técnica fique clara, mas obviamente imagine isso em algo mais complicado.

A primeira coisa que gostaríamos de fazer é separar esse código. Talvez quebrar em arquivos como <tt>app/assets/javascripts/foo.js</tt> e <tt>app/assets/javascripts/bar.js</tt>. Então vamos direto ao assunto e adicionar o [ModuleJS](http://larsjung.de/modulejs/) diretamenta à nossa <tt>Gemfile</tt>:

--- ruby
# Gemfile
source 'https://rails-assets.org'
# ...
gem 'rails-assets-modulejs'
```

Depois de instalar com o bom e velho <tt>bundle install</tt>. Modificamos o <tt>app/assets/javascripts/application.js</tt> para carregar a dependência:

--- javascript
//= require jquery
//= require jquery_ujs
//= require modulejs
//= require_tree .
```

Isso foi o que eu já expliquei no meu post mais antigo sobre [Rails Assets](http://www.akitaonrails.com/2013/12/13/rails-assets). Se a biblioteca que você quer tem um pacote Bower, ele pode ser automaticamente encapsulado numa gem de Rails Engine como uma gem feita manualmente. E se não tiver como pacote Bower aí não tem jeito: baixe os arquivos e jogue num diretório em <tt>vendor/assets</tt> para mantê-la estática dentro do projeto, mas o ideal é que você **não** deixe bibliotecas javascript vendorizados.

Para começar a refatoração do javascript acima, vamos começar quebrando os objetos 'Foo' e 'Bar' em dois arquivos:

--- javascript
// app/assets/javascripts/foo.js
modulejs.define( 'foo', function() {
  return {
    hello: function() {
      return "Hello";
    },

    world: function() {
      return "World";
    }
  }
})
```

--- javascript
// app/assets/javascripts/bar.js
modulejs.define( 'bar', [ 'foo' ], function(Foo) {
  return {
    helloWorld: function() {
      return Foo.hello() + " " + Foo.world();
    }
  }
})
```

Veja que não precisamos mais das constantes 'Foo' e 'Bar', apenas devolver o corpo do hash com as funções. No módulo 'bar', declaramos que precisamos do módulo 'foo' (em um array) e passamos como parâmetro do construtor com o nome antigo da constante 'Foo', daí internamente o código se mantém exatamente o mesmo. E já que estamos modularizando, vamos adicionar um módulo que encapsula a chamada principal:

--- javascript
// app/assets/javascripts/main.js
modulejs.define( 'main', ['bar', 'jquery'], function(Bar, $) {
  return {
    start: function() {
      $('body').append('<p>' + Bar.helloWorld() + '</p>');
    }
  }
})
```

Como pode ver acima, o módulo 'main' vai depender do 'bar' (definido em 'bar.js') e também de um 'jquery' que ainda não existe, então vamos criar um genérico <tt>modules.js</tt> para encapsular o jQuery assim:

--- javascript
// app/assets/javascripts/modules.js
modulejs.define( 'jquery', function() {
  return jQuery;
});
```

Veja que podemos fazer a mesma coisa para qualquer outra biblioteca. Damos um nome em string, no caso 'jquery', que o ModuleJS vai conseguir encontrar depois e retornamos a classe principal, só isso.

Para finalizar no arquivo original <tt>application.js</tt> chamamos esse novo 'main' assim:

--- javascript
$(function() {
  var app = modulejs.require('main');
  app.start();
})
```

Pronto! Tudo isolado e com as dependências todas controladas. A grande vantagem de fazer desta forma é que no cabeçalho do <tt>application.js</tt> podemos continuar declarando as dependências com o <tt>require_tree .</tt> pois não importa a ordem dos arquivos, apenas a chamada principal do módulo 'main'.

Pronto, não precisamos de RequireJS, podemos continuar usando o Asset Pipeline que vai gerar os arquivos minificados como o Rails sempre fez e com o mínimo de dependências que podem causar conflitos difíceis de rastrear depois. Vá adicionando seus pacotes preferidos de Bower diretamente na <tt>Gemfile</tt> e continue usando apenas um sistema de gerenciamento de dependência que sabemos que funciona: Bundler.
