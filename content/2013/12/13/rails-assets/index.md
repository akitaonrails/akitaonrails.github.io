---
title: Rails Assets
date: '2013-12-13T19:49:00-02:00'
slug: rails-assets
tags:
- learning
- beginner
- rails
- front-end
- javascript
draft: false
---

Ontem o [@Fgrehm](https://twitter.com/fgrehm) mandou no nosso Campfire sobre o projeto [rails-assets.org](https://rails-assets.org). Ele acabou de ser lançado, portanto não pode ser considerado mais que um "beta". Ela pode ser tanto a salvação da lavoura para front-ends em projetos Rails ou não, na prática ainda não sabemos.

O [@jcemer](https://twitter.com/jcemer) publicou hoje um [ótimo post](http://jcemer.com/asset-pipeline-rails-assets-or-let-die.html) explicando isso do ponto de vista de um front-end full-time, colocando em perspectiva.

Em resumo, o Rails trás um mecanismo fantástico chamado Asset Pipeline. Ele tem diversas funções, em particular otimizar os assets dos projetos Rails, compilando fontes de Sass ou Less para CSS. Depois concatenando todos os CSS, JS em um único arquivo. Depois minificando (com Uglify) para diminuir seu tamanho. Em particular com Sass ele ainda pode concatenar sprites em uma única imagem também. Enfim, o pacote completo para otimizar assets ao máximo.

Se você ainda não conhece sobre esse recurso, não deixe de ler meu [tutorial](http://www.akitaonrails.com/2012/07/01/asset-pipeline-para-iniciantes).

Só que à medida que um projeto precisa ter várias bibliotecas CSS, JS, etc o processo pode ficar chato. Principalmente porque em alguns casos precisa manualmente modificar os paths dentro de seus fontes. 

Um dos problemas é que o Asset Pipeline vai juntar todos os arquivos em um único, colocando timestamp no nome. E aí os paths não vão funcionar a menos que usem o helper [asset_path](http://api.rubyonrails.org/classes/ActionView/Helpers/AssetUrlHelper.html#method-i-asset_path) ou [asset_url](http://api.rubyonrails.org/classes/ActionView/Helpers/AssetUrlHelper.html#method-i-asset_url). Por isso acabamos usando rubygems feitas manualmente como o [bootstrap-rails](https://github.com/anjlab/bootstrap-rails).

E isso leva a outro problema: atualizações. Primeiro, os autores originais lançam uma determinada biblioteca Javascript. Podemos manualmente fazer o download dos fontes e "vendorizá-los" no projeto. Ou, se você utilizar o Bower podemos esperar sair esse novo pacote e atualizar com o Bower. Ou, se estivermos usando uma Rubygem, podemos esperar sair a nova gem e atualizar com Bundler.

Então, vamos separar tudo e usar Bower pra gerenciar bibliotecas de front-end e usar Bundler para gerenciar gems de back-end e todo mundo fica feliz? Não é tão fácil assim já que muitas gems - ActiveAdmin como um bom exemplo - já dependem de bibliotecas de front-end encapsuladas em rubygems como temos neste trecho da gemspec:

```ruby
...
s.add_dependency "bourbon"
s.add_dependency "jquery-rails"
s.add_dependency "jquery-ui-rails"
...
```

Já que temos duas comunidades tendo exatamente o mesmo trabalho: no Bower alguém vai atualizar pacotes de jquery; na Rubygems alguém vai ter que atualizar também. Então, porque não otimizar isso e apenas um deles atualizar. Nesse caso vamos aproveitar - e colaborar - para deixar as do Bower sempre atualizadas.

Será que existe uma forma, então, de converter um pacote Bower para um pacote Rubygems? E este é o problema que o Rails Assets se propõe a tentar resolver. Seguindo exatamente o mesmo exemplo do site deles, colocaremos na Gemfile de nossos projetos Rails desta forma:

```ruby
source 'https://rubygems.org'
source 'https://rails-assets.org'

gem 'rails'

group :assets do
  gem 'sass-rails'
  gem 'uglifier'
  gem 'coffee-rails'
  gem 'rails-assets-bootstrap'
  gem 'rails-assets-angular'
  gem 'rails-assets-leaflet'
end
```

A primeira diferença é um novo source. E isso é importante pois não vai poluir o repositório de Rubygems com gems que são meros 'stubs'.

A segunda diferença são as gems prefixadas seguindo o padrão "rails-assets-[nome do pacote Bower]" que, obviamente, foram feitas desta forma para não conflitarem com as que já existem no Rubygems.org. Se isso funcionar significa que a antiga gem "bootstrap-rails" poderá ser descontinuada e passamos a usar a "rails-assets-bootstrap", e assim por diante.

Se uma determinada gem ainda não existir, o processo vai demorar um pouco porque o Rails Assets vai baixar o pacote do Bower, modificá-la, encapsulá-la como uma Rubygem e publicar no seu repositório. Mas quanto mais gente usar com mais bibliotecas, mais rubygems já estarão prontas para baixar imediatamente.

Para o Asset Pipeline continua a mesma coisa. No mesmo arquivo <tt>app/assets/javascripts/application.js</tt> teríamos igual:

```javascript
//= require_self
//= require bootstrap
//= require angular
//= require leaflet
//= require_tree .
//= require_tree shared
```

E no <tt>app/assets/stylesheets/application.css</tt> teríamos também igual:

```css
/*
 *= require_self
 *= require bootstrap
 *= require leaflet
 *= require_tree .
 *= require_tree shared
 */
```

As rubygems que encapsulam bibliotecas front-end não são apenas por causa do Asset Pipeline, além disso elas também podem conter generators para facilitar a criação de alguma estrutura de diretórios ou arquivos de configuração específicos. Mas mesmo nesse caso podemos separar em duas coisas: uma sendo só os fontes originais e uma segunda gem que depende da primeira com ferramentas ou outros extras como generators.

## Conclusão

Para Rubistas a primeira vantagem mais óbvia é o seguinte: não precisamos misturar dois workflows de dependência, uma com Bower (ou manualmente) e outra com Bundler. Podemos continuar apenas com Bundler. Lembrando que se pacotes Bower não forem vendorizados no projeto Rails ainda teríamos que manter esse processo com Bower na integração contínua - adicionando o comando no .travis.yml, por exemplo; e também teríamos que ter no deployment. Idealmente, não deveríamos ter que vendorizar bibliotecas. Isso sem contar que se usar Bower num projeto Rails e usar Heroku, precisa de um outro [buildpack](http://xseignard.github.io/2013/02/18/use-bower-with-heroku/) para funcionar. Ou seja, o Bower adiciona muito mais complexidade do que somente ter que rodar mais um comando "install" em desenvolvimento. Ambientes de teste, produção, tudo fica um pouco mais complicado, e desnecessariamente.

Além disso, quem colaborava mantendo a rubygems de um "bootstrap-rails", por exemplo, pode continuar a dedicar seu tempo atualizando diretamente o pacote equivalente do Bower e deixar essa fonte única sempre atualizada, o que pode ser um reforço ao Bower e aos não-rubistas que a utilizam.

E com isso também não precisamos ter gems de stubs poluindo o Rubygems.org. Ou seja, "se" funcionar será uma situação ganha-ganha para todo mundo. Porém nem tudo são flores. Como uma das idéias do Rails Assets é modificar o fonte para adicionar os asset-paths corretos, quer dizer que podem existir situações onde patterns automáticos não peguem, ou existam ambiguidades que precisem ser resolvidos manualmente. Então, das duas uma: ou colaboramos com o Rails Assets para adicionar os patterns que faltam, se for possível; ou criamos um passo no workflow do Rails Assets que permitam modificações manuais. Ainda não sei, precisamos ver quais são esses cenários e como corrigí-los. Mas isso não elimina os pontos positivos descritos anteriormente.

O melhor a fazer: testar e experimentar. O projeto é open source, você pode [colaborar](https://github.com/rails-assets/rails-assets/) mandando Pull Requests ou mesmo reportando [Issues](https://github.com/rails-assets/rails-assets/issues) e ajudando a evoluir. Se a idéia for furada - o que não me parece - vamos saber rapidamente - e voltamos ao mesmo problema de antes, mas pelo menos esta é uma proposta de solução muito interessante que vale a pena ser explorada mais a fundo.
