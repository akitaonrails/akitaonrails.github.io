---
title: Internationalização (I18n) Mínima em Rails 3.2 - Parte 2
date: '2012-07-14T22:44:00-03:00'
slug: internationalizacao-i18n-minima-em-rails-3-2-parte-2
tags:
- learning
- rails
- i18n
- tutorial
draft: false
---

Este artigo inicia na [Parte 1](http://akitaonrails.com/2012/07/14/internationalizacao-i18n-minima-em-rails-3-2-parte-1). Leia primeiro antes de continuar.

![](http://s3.amazonaws.com/akitaonrails/assets/2012/7/14/Screen%20Shot%202012-07-14%20at%209.46.44%20PM_original.png?1342313242)

Se quiser ver como essa aplicação se comporta de verdade, eu subi uma versão numa conta free do Heroku, então [clique aqui](http://i18n-demo.herokuapp.com) e veja.

Nesta Parte 2 vamos continuar com as seguinte seções:

- [Seção Bônus: Markdown](#markdown)
- [Seção Bônus: Twitter Bootstrap](#twitterbootstrap)
- [ActiveAdmin e Globalize 3](#activeadminglobalize)
- [Rotas Internacionalizadas](#routes)
- [Conclusão](#conclusao)

## Seção Bônus: Markdown

Outra coisa que quero demonstrar no caso de um aplicativo “estilo” gerenciador de conteúdo (CMS) é o cache do HTML que queremos gerar. Neste exemplo defini que o atributo <tt>Article#body</tt> terá texto no formato [Markdown](http://daringfireball.net/projects/markdown/). Poderia ser qualquer outro formato como Textile, Creole, MediaWiki ou o qualquer outro que gere HTML. É uma forma de simplificar o processo de edição do conteúdo sem precisar de um editor [WYSIWYG](http://pt.wikipedia.org/wiki/WYSIWYG) mais complicado como um [bootstrap wysihtml5](http://jhollingworth.github.com/bootstrap-wysihtml5/).

Uma boa engine para converter Markdown em HTML é o [RDiscount](https://github.com/rtomayko/rdiscount/) (olhe também a gem [Tilt](https://github.com/rtomayko/tilt), ambos do Ryan Tomayko). Novamente, apenas adicione a seguinte gem no <tt>Gemfile</tt>:

* * *

```ruby
gem ‘rdiscount’
```

Usá-lo é muito simples:

* * *

```ruby

RDiscount.new(“texto em **markdown**.”).to_html #=> **markdown**
```

O erro mais comum é adicionar essa lógica no controller, algo como isso:

* * *

```ruby
class ArticleController < ApplicationController  
 def show  
    article = Article.find(params[:id])
    @html = RDiscount.new(`article.body).to_html  
 end  
end
```

Isso acarreta um processamento de conversão para **cada requisição de cada usuários à mesma página**. É exatamente o tipo de cenário que queremos otimizar o quanto antes. A melhor forma, nesse tipo de cenário de conversão, é gravar a versão convertida junto com a original. Por isso na migration do model <tt>Article</tt> já criamos com a coluna <tt>body</tt> e também <tt>body_html</tt>. Então só precisamos adicionar um simples callback no model:

* * *

```ruby
class Article < ActiveRecord::Base  
 attr_accessible :body, :body_html, :slug, :title, :locale, :translations_attributes  
 …  
 before_save :generate_html  
 …  
 def translations_attributes=(attributes)  
 new_translations = attributes.values.reduce({}) do |new_values, translation|  
 translation.merge!(“body_html” => RDiscount.new(translation[“body”] || "").to_html )  
 new_values.merge! translation.delete(“locale”) => translation  
 end  
 set_translations new_translations  
 end  
private  
 …  
 def generate_html  
 self.body_html = RDiscount.new(self.body).to_html  
 end  
end  
```

Isso foi simples. Agora não precisa adicionar nada no controller e na view basta chamar diretamente o conteúdo cacheado:

* * *

```html
<%= raw @article.body_html %\>  
```

Observe também o método <tt>raw</tt>: como estamos adicionando HTML vinda de model na view, o Rails, por padrão, vai considerar esse conteúdo “perigoso” e irá escapá-lo. Não é o que queremos, queremos mesmo que o HTML seja mesclado, para isso precisamos expôr nossa intenção explicitamente dizendo que queremos o HTML “crú” (raw). Leia mais sobre essa funcionalidade no [Guia Oficial](http://guides.rubyonrails.org/active_support_core_extensions.html#output-safety).

Em particular o método <tt>translations_attributes=</tt> merece atenção. Por causa da forma como o Globalize3 lida com a associação de traduções, ao tentarmos simplesmente adicionar massivamente múltiplas traduções, ele não executa corretamente os <tt>before_filter</tt> para cada linguagem, acaba apagando items que não são a localização configurada atualmente e grava somente um ítem em vez de gravar massivamente múltiplos. Isso particularmente quebra a funcionalidade de ActiveAdmin que vamos discutir mais abaixo.

Para consertar isso, sobrescrevemos o método de assinalação em massa forçando o uso do método <tt>set_translations</tt> do Globalize3. Além disso também já criamos a versão HTML do campo <tt>body</tt> e gravamos de uma vez, isso porque a versão de cache do HTML no fundo é uma “tradução” e por isso não vai na tabela principal <tt>articles</tt> mas sim na implícita <tt>article_translations</tt>.

## Seção Bônus: Twitter Bootstrap

Essa é completamente fora do escopo deste artigo, mas como meu código no Github está utilizando, vou apenas listar como instalei. Para quem não conhece, o Twitter Bootstrap é um conjunto de stylesheets e javascripts para estilizar rapidamente seu site, justamente para casos como este, onde o design não é importante, é basicamente um protótipo e eu queria algo menos feio do que não colocar nada. Existem diversas gems derivadas que utilizam o bootstrap, mas para o básico podemos começar adicionando as seguintes gems no <tt>Gemfile</tt>:

* * *

```ruby
group :assets do  
 …

# See <https://github.com/sstephenson/execjs#readme> for more supported runtimes  
 gem ‘therubyracer’, :platforms => :ruby  
 gem ‘less-rails’  
 gem ‘twitter-bootstrap-rails’  
end  
```

Agora podemos começar a instalar os arquivos estáticos para a aplicação:

* * *

```bash
rails g bootstrap:install application fluid  
```

E depois podemos adicionar as views estilizadas para cada recurso da sua aplicação:

* * *

```bash
rails g bootstrap:themed Articles  
```

Neste ponto, ele vai criar vários arquivos desnecessários que podemos apagar e precisamos customizar bastante. Não vou copiar todo o fonte das views no arquivo, então faça o clone [deste projeto no Github](http://github.com/akitaonrails/Rails-3-I18n-Demonstration/) e aprenda lendo o código que está em <tt>app/uploads</tt> e <tt>app/views</tt>. Compare com os arquivos gerados pelo geradores acima e o que foi modificado.

Um dos pontos importantes a lembrar quando lidamos com plugins de javascript, arquivos CSS, é não deixar sobrando <tt>require_tree .</tt> sem que você saiba para que serve. Leia meu artigo sobre [Assets Pipeline para Iniciantes](http://akitaonrails.com/2012/07/01/asset-pipeline-para-iniciantes).

No caso do layout principal note que adicionei bloco de <tt>.navbar</tt> para o menu principal no topo. Adicionei o <tt>yield</tt> onde os outros conteúdos vão se encaixar dentro de um <tt>.container</tt> e temos uma área de botões no rodapé num bloco <tt>.form-actions</tt>. Um cuidado sobre esta gem é que no arquivo que ele cria em <tt>app/uploads/stylesheets/bootstrap_and_overrides.css.less</tt> ele define margens no elemento <tt>body</tt> que são desnecessários, apenas remove essas definições logo no começo do arquivo.

Note também que no meu Github todas as views de Devise que mencionamos anteriormente já estão estilizadas com o bootstrap (por isso que na seção que mencionamos sobre Devise eu faço um <tt>git checkout 0ff207…</tt> para fazer download das views traduzidas mas que ainda não tinham sido estilizadas). Agora você pode voltar ao diretório do meu projeto, fazer <tt>git checkout master</tt> e realizar a mesma cópia dos arquvos para pegar as views estilizadas.

Um lembrete para menus é criar itens que saibam em que controller/action estamos e desabilitar o link da página atual, um exemplo é o que fiz de exemplo nesta aplicação. No arquivo <tt>app/helpers/application_helper.rb</tt> temos:

* * *

```ruby

module ApplicationHelper  
 …  
 def navigation_links  
 links = []  
 options = params[:controller] == “welcome” ? { class: “active” } : {}  
 links << content_tag(:li, link_to(t(“hello”), welcome_path), options).html_safe

options = params[:controller] == “articles” ? { class: “active” } : {} 
links << content_tag(:li, link_to(t(“articles.title”), articles_path), options).html_safe 
links << content_tag(:li, link_to(t(“admin.title”), admin_dashboard_path)).html_safe content_tag(:ul, links.join(“\n”).html_safe, class: “nav”) 
end

end  
```

E no layout em <tt>app/views/layouts/application.html.erb</tt> colocamos:

* * *

```html
<%= t(“site_name”) %\>](#)\<%= navigation_links %\>
```

* * *

## ActiveAdmin e Globalize 3

O ActiveAdmin é um excelente projeto para termos rapidamente um módulo simples de administração que consegue expôr as operações de CRUD de um model, incluindo suas validações e até elementos como upload de imagens (caso esteja usando CarrierWave, por exemplo). Por usar por baixo formtastic, customizar seus formulários também não é complicado. Instalar é simples, coloque na <tt>Gemfile</tt>:

* * *

```ruby
…  
group :assets do  
 gem ‘jquery-ui-rails’  
 …  
end  
…  
gem ‘jquery-rails’  
gem ‘activeadmin’  
gem ‘ActiveAdmin-Globalize3-inputs’  
…  
```

Execute o comando:

* * *

```bash
rails g active_admin:install  
```

Uma dica para que o Assets Pipeline não falhe em produção. Precisamos declarar explicitamente os assets do ActiveAdmin. Adicione no <tt>config/application.rb</tt>:

* * *

```ruby
config.assets.precompile += %w(active_admin.js active_admin.css)  
```

Agora adicione em <tt>app/admin</tt> quaisquer models que precise expor. Leia a [documentação](http://activeadmin.info/documentation.html) do ActiveAdmin no site deles mas como exemplo, para customizar a tabela de listagem do model <tt>Article</tt> (<tt>index</tt>) e também a página visualização de um único artigo (<tt>show</tt>), podemos escrever em <tt>app/admin/articles.rb</tt>:

* * *

```ruby
ActiveAdmin.register Article do  
 index do  
 column :id  
 column :slug  
 column :title

default_actions end 
  show do |article| attributes_table do 
    row :slug I18n.available_locales.each do 
      |locale| h3 I18n.t(locale, scope: [“translation”]) div do 
        h4 article.translations.where(locale: locale).first.title 
        end 
      div do 
        article.translations.where(locale: locale).first.body_html.html_safe 
      end 
    end 
  end 
  active_admin_comments 
end
```

O bloco <tt>show</tt> é o mais interessante. Aqui estamos usando diretamente a associação <tt>translations</tt> que o Globalize 3 adicionou ao nosso model para buscar explicitamente o conteúdo de uma localização, em vez de puxar o que o model nos der automaticamente baseado na localização. Assim colocamos ambos os conteúdo uma embaixo do outro de uma só vez.

![](http://s3.amazonaws.com/akitaonrails/assets/2012/7/14/Screen%20Shot%202012-07-14%20at%208.28.56%20PM_original.png?1342308888)

Mas e para editar os conteúdos de ambas as localizações? Para isso colocamos além do ActiveAdmin o [ActiveAdmin-Globalize3-inputs](https://github.com/mimimi/ActiveAdmin-Globalize3-inputs) e as gems de JQuery (porque vamos precisar do elemento de “Tabs”).

Esse módulo vai utilizar as funcionalidades do ActiveRecord de [accepts_nested_attributes_for](http://api.rubyonrails.org/classes/ActiveRecord/NestedAttributes/ClassMethods.html#method-i-accepts_nested_attributes_for) para receber no mesmo formulário HTML os atributos das associações. Para isso garanta que seu modelo <tt>app/models/article.rb</tt> tem o seguinte:

* * *

```ruby
class Article < ActiveRecord::Base  
 attr_accessible :body, :body_html, :slug, :title, :locale, :translations_attributes  
 …  
 translates :title, :body, :body_html  
 accepts_nested_attributes_for :translations  
 …  
 class Translation  
 attr_accessible :locale, :title, :body, :body_html  
 end

def translations_attributes=(attributes) 
    new_translations = attributes.values.reduce({}) do 
      |new_values, translation| translation.merge!(“body_html” => RDiscount.new(translation[“body”] || "").to_html ) 
      new_values.merge! translation.delete(“locale”) => translation end 
      set_translations new_translations end …
end
```

Isso faz o modelo aceitar [mass assignment](http://guides.rubyonrails.org/security.html#mass-assignment) do atributo <tt>translations_attributes</tt>, usamos o <tt>accepts_nested_attributes_for</tt> para que os helpers de formulário saibam como gerar os elementos para os atributos da associação. Uma coisa estranha pode ser o fato de estarmos sobrescrevendo a classe <tt>Article::Translation</tt>. Acredito que é um bug do Globalize 3, e sem essa modificação o _mass assignment_ iria falhar.

Precisamos também adicionar o JQuery UI para o ActiveAdmin. Basta alterar o arquivo <tt>app/uploads/stylesheets/active_admin.css</tt>:

* * *

```css
// Active Admin CSS Styles  
@import “active_admin/mixins”;  
@import “active_admin/base”;  
@import “jquery.ui.tabs”;  
```

E também o arquivo <tt>app/uploads/javascripts/active_admin.js</tt>:

* * *

```javascript
//= require active_admin/base  
//= require jquery.ui.tabs  
```

Finalmente, precisamos alterar novamente o arquivo de configuração <tt>app/admin/articles.rb</tt> para adicionar o seguinte:

* * *

```ruby
ActiveAdmin.register Article do  
 …  
 form do |f|  
 f.input :slug  
 f.globalize_inputs :translations do |lf|  
 lf.inputs do  
 lf.input :title  
 lf.input :body

lf.input :locale, :as => :hidden end end f.buttons end

end  
```

Atributos não internacionalizados como <tt>slug</tt> ficam fora, mas o resto vai dentro do bloco <tt>globalize_inputs</tt> passando o nome da associação, nesse caso <tt>translations</tt>. E dentro de cada sub-formulário precisamos de um campo escondido com a localização desse sub-formulário em particular, para isso temos o campo <tt>locale</tt> como <tt>hidden</tt>.

![](http://s3.amazonaws.com/akitaonrails/assets/2012/7/14/Screen%20Shot%202012-07-14%20at%208.28.41%20PM_original.png?1342308896)

Vale lembrar que o ActiveAdmin suporta internacionalização também. Neste aplicativo escolhi não adicionar esse suporte. É o cenário onde um único administrador controla ambas as linguagens. Mas se você tiver a situação onde cada equipe em cada país cuida da sua própria linguagem, talvez queira adicionar este suporte.

Finalmente, como explicamos na seção sobre Markdown, para que o ActiveAdmin consiga dar POST de várias traduções ao mesmo tempo, no mesmo formulário, usando a capacidade de assinalamento em massa e <tt>accepts_nested_attributes_for</tt>, temos que sobrescrever o método <tt>translations_attributes=</tt> pois simplesmente inserir os novos registros de tradução na associação não vai funcionar, o Globalize3 vai filtrar essa lista e só vai gravar o registro da localização atual. Mas forçando o uso to método interno do Globalize3, <tt>set_translations</tt>, conseguimos gravar múltiplas traduções ao mesmo tempo.

## Rotas Internacionalizadas

Deixei por último uma das coisas mais interessantes nesta aplicação. Para efeitos de SEO também queremos que as URLs sejam traduzidas. Ou seja, queremos que as seguintes URLs todas apontem para o mesmo lugar:

* * *

```
/users/sign_in  
/en/users/sign_in  
/pt-BR/usuarios/login  
```

Existem algumas gems que fazem isso, a primeira que esbarrei se chama “i18n_routing”, mas não consegui fazê-la funcionar, acredito que tenha bugs ainda. Se procurar mais vai acabar encontrando a [translate_routes](https://github.com/raul/translate_routes) mas ela está obsoleta e dois outros forks passaram a atualizá-la. Uma é a [route_translator](https://github.com/enriclluelles/route_translator), que eu não testei porque parecia ter pouca atividade. A que escolhi usar se chama [rails-translate-routes](https://github.com/francesc/rails-translate-routes). Para adicionar ao projeto, edite seu <tt>Gemfile</tt>:

* * *

```ruby

gem ‘rails-translate-routes’  
```

Depois de executar o comando <tt>bundle</tt> precisamos editar o arquivo <tt>config/routes.rb</tt> que controla todas as rotas. Neste estágio, ele deve ter o seguinte conteúdo:

* * *

```ruby

I18nDemo::Application.routes.draw do

#1. rotas para active admin  
 ActiveAdmin.routes(self)  
 devise_for :admin_users, ActiveAdmin::Devise.config

#1. rotas de autenticação do Devise  
 devise_for :users

#1. rotas pra artigos  
 resources :articles

  #1. pagina principal  
 get “welcome/index”, as: “welcome”  
 root to: ‘welcome#index’  
end  
```

O que queremos agora é traduzir todas as rotas públicas, incluindo as do Devise. Porém, como explicado antes, no caso do ActiveAdmin estamos no cenário onde não precisamos de telas de administração traduzidas. Então devemos modificar o arquivo para ficar assim:

* * *

```ruby
I18nDemo::Application.routes.draw do  
 devise_for :users  
 resources :articles  
 get “welcome/index”, as: “welcome”  
 root to: ‘welcome#index’  
end

ActionDispatch::Routing::Translator.translate_from_file(  
 ‘config/locales/routes.yml’, {  
 prefix_on_default_locale: true,  
 keep_untranslated_routes: true })

I18nDemo::Application.routes.draw do  
 ActiveAdmin.routes(self)  
 devise_for :admin_users, ActiveAdmin::Devise.config  
end  
```

Uma dica é que o bloco de rotas depois do método <tt>#draw</tt> pode ser dividido. Isso é importante porque as rotas definidas antes do método <tt>#translate_from_file</tt> serão traduzidas, e as definidas no bloco abaixo (onde colocamos o ActiveAdmin), não serão.

Este código diz que vamos colocar as traduções no arquivo <tt>config/locales/routes.yml</tt>. Então criamos esse arquivo com o seguinte conteúdo:

* * *

```yaml

en:  
 routes:  
pt-BR:  
 routes:  
 welcome: bemvindo  
 new: novo  
 edit: editar  
 destroy: destruir  
 password: senha  
 sign_in: login  
 users: usuarios  
 cancel: cancelar  
 article: artigo  
 articles: artigos  
```

O bloco <tt>en.routes</tt> fica vazio porque como nossa aplicação está toda em inglês, por padrão, as rotas são em inglês. Agora no bloco <tt>pt-BR.routes</tt> basta colocarmos as palavras que queremos traduzir, seja ela nome de controller, de action, de resource, e a gem fará o resto. Se executarmos o comando <tt>rake routes</tt> depois de termos isso configurado, teremos:

* * *

```ruby
…  
article_pt_br GET /pt-BR/artigos/:id(.:format) articles#show {:locale=>"pt-BR"}  
 article_en GET /en/articles/:id(.:format) articles#show {:locale=>"en"}  
GET /articles/:id(.:format) articles#show  
PUT /pt-BR/artigos/:id(.:format) articles#update {:locale=>"pt-BR"}  
PUT /en/articles/:id(.:format) articles#update {:locale=>"en"}  
PUT /articles/:id(.:format) articles#update  
DELETE /pt-BR/artigos/:id(.:format) articles#destroy {:locale=>"pt-BR"}  
DELETE /en/articles/:id(.:format) articles#destroy {:locale=>"en"}  
DELETE /articles/:id(.:format) articles#destroy  
welcome_pt_br GET /pt-BR/bemvindo/index(.:format) welcome#index {:locale=>"pt-BR"}  
 welcome_en GET /en/welcome/index(.:format) welcome#index {:locale=>"en"}  
GET /welcome/index(.:format) welcome#index  
 root_pt_br /pt-BR welcome#index {:locale=>"pt-BR"}  
 root_en /en welcome#index {:locale=>"en"}  
```

Já se perguntou sobre a necessidade de usar rotas nomeadas como <tt>new_article_path</tt> em vez de digitar direto <tt>/articles/New</tt>? Este é um motivo, a mesma rota nomeada vai levar em consideração o parâmetro implícito de localização e nos dar a URI traduzida correta sem que você precise alterar mais nada em nenhuma parte da aplicação! Win-win.

Precisamos que a aplicação reconheça o parâmetro <tt>locale</tt> que virá dentro do hash <tt>params</tt> que já conhemos. Vamos colocar um <tt>before_filter</tt> no <tt>/app/controllers/application_controller.rb</tt>:

* * *

```ruby
class ApplicationController < ActionController::Base  
 protect_from_forgery

before_filter :set_locale before_filter :set_locale_from_url 

private 

def set_locale 
  if lang = request.env[‘HTTP_ACCEPT_LANGUAGE’] 
      lang = lang[/^[a-z]{2}/] 
      lang = :“pt-BR” 
  if lang == “pt” end 
    I18n.locale = params[:locale] || lang || I18n.default_locale end
end  
```

Agora podemos ir em <tt>http://localhost:3000/en/articles</tt> ou <tt>http://localhost:3000/pt-BR/artigos</tt> e vamos chegar no mesmo local. Basta colocarmos na aplicação links para podemos trocar de linguagem em qualquer página que estivermos. Para isso usaremos o helper <tt>url_for</tt> que usará os parâmetros correntes para gerar o link correto da página atual. Precisamos adicionar em <tt>app/helpers/application_helper.rb</tt>:

* * *

```ruby
module ApplicationHelper  
 def language_links  
 links = []  
 I18n.available_locales.each do |locale|  
 locale_key = “translation.#{locale}”  
 if locale == I18n.locale  
 links << link_to(I18n.t(locale_key), “#”, class: “btn disabled”)  
 else  
 links << link_to(I18n.t(locale_key), url_for(locale: locale.to_s), class: “btn”)  
 end  
 end  
 links.join(“\n”).html_safe  
 end  
 …  
end  
```

E podemos colocar, neste exemplo, na área de rodapé da aplicação. Então adicionamos ao <tt>app/views/layouts/application.html.erb</tt>:

* * *

```html
…

<%= language_links %\>
```
