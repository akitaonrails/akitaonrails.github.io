---
title: Internationalização (I18n) Mínima em Rails 3.2 - Parte 1
date: '2012-07-14T22:39:00-03:00'
slug: internationalizacao-i18n-minima-em-rails-3-2-parte-1
tags:
- learning
- rails
- i18n
- tutorial
draft: false
---

 **Aviso:** Não se esqueçam que dias 30 e 31 de Agosto teremos a Rubyconf Brasil 2012! Já garantiu seu ingresso? [Compre agora mesmo!](http://www.rubyconf.com.br/pt-BR)

Este é um artigo que eu queria escrever há muito tempo, finalmente consegui formatá-lo como queria. Um dos assuntos que até hoje ainda é difícil de explicar para iniciantes é como utilizar o suporte de I18n do Rails. Todos sabem que o Rails possui uma excelente infraestrutura para [internacionalização (i18n) e localização](http://en.wikipedia.org/wiki/Internationalization_and_localization "l10n"). Porém, a instalação básica do Rails fornece somente a infraestrutura, ou seja, o desenvolvedor é quem deve escolher quais componentes adicionais instalar sobre essa infraestrutura para retirar o máximo que o Rails pode oferecer.

I18n e L10n vai muito mais do que a simples tarefa de substituir strings de texto. Formatação de dados (data, hora, moeda) variam. Codificação dos dados (o padrão sempre tem que ser UTF8!). URLs sensíveis à localização. Modelos sensíveis à localização. Para começar, não pretendo repetir o que todo desenvolvedor Rails já deveria saber, portanto se ainda não leu o [Guia Oficial sobre a API de Internacionalização do Rails](http://guides.rubyonrails.org/i18n.html) sugiro que faça isso antes de continuar lendo este artigo.


Neste guia vou demonstrar o básico de i18n criando uma aplicação mínima, com Devise. Todo os códigos mostrados aqui estão no [meu repositório](https://github.com/akitaonrails/Rails-3-I18n-Demonstration) no Github. Se quiser, pule diretamente para a seção que mais lhe interessa:

- [Banco de Dados e Codificação de Strings](#bancodados)
- [Iniciando uma aplicação Rails](#iniciando)
- [Devise](#devise)
- [Atributos Traduzidos de ActiveRecord com Globalize 3](#globalize3)
- [Seção Bônus: Friendly Id](#friendlyid)
- [Continuação: Parte 2](http://akitaonrails.com/2012/07/14/internationalizacao-i18n-minima-em-rails-3-2-parte-2)

## Banco de Dados e Codificação de Strings

Não pretendo repetir a antiga discussão sobre encodings, UTF8, e o suporte no Ruby 1.9. Se ainda não leu, recomendo que antes de continuar também leia os seguintes artigos do Yehuda Katz:

- [Ruby 1.9 Encodings: A Primer and the Solution for Rails](http://yehudakatz.com/2010/05/05/ruby-1-9-encodings-a-primer-and-the-solution-for-rails/)
- [Encodings, Unabridged](http://yehudakatz.com/2010/05/17/encodings-unabridged/)

Além disso, uma coisa a se lembrar se você gosta de criar seu banco de dados via linha de comando sem usar o <tt>rake db:create</tt> é adicionar o character set e collate corretos. No MySQL sempre faça:

* * *

CREATE DATABASE dbname   
CHARACTER SET utf8   
COLLATE utf8\_general\_ci;  
-

E no PostgreSQL faça:

* * *

CREATE DATABASE dbname  
WITH OWNER “postgres”  
ENCODING ‘UTF8’  
 LC\_COLLATE = ‘en\_US.UTF-8’  
 LC\_CTYPE = ‘en\_US.UTF-8’;  
-

Obviamente, troque <tt>dbname</tt> e <tt>postgres</tt> de acordo com sua aplicação. Não tem coisa que eu abomine mais do que um banco de dados e uma aplicação web desenvolvida em “Latin1” (iso-8859-1) ou pior ainda, em Windows 1252. Apenas para refrescar a memória, até o Ruby 1.8 todo string de texto era nada mais do que uma cadeia de bytes, como em C (justamente mantendo compatibilidade com C). A partir do Ruby 1.9 foi adicionado um complexo sistema para lidar com todo tipo de linguagem, encoding e com isso o suporte a UTF-8 se tornou bem melhor e deve ser o padrão. Agora um string é uma cadeia de caracteres, que pode se double-byte associado a uma tabela de encoding para garantir que todas as operações de string, incluindo regular expressions, atuem da forma correta sem corromper o texto. O Rails atual também leva isso em consideração e tudo é, por padrão, UTF8. Nunca misture.

Sempre utilize um editor de texto decente que salve arquivos, por padrão, em UTF8. Se estiver em Mac ou Linux isso já é praticamente padrão. Se estiver em Windows, preocupe-se, muitos não gravam em UTF8.

Outra coisa que confunde muitas pessoas, alguns arquivos Ruby recebem um cabeçalho, logo na primeira linha, parecido com as linhas abaixo:

* * *
ruby
1. encoding: UTF-8
2. coding: UTF-8
3. \* coding: UTF-8 \*
4. \* coding: utf-8 \*  
-

Qualquer uma das opções acima tem o mesmo efeito. A regra é simples: se você tiver somente código Ruby, sem nenhuma string internacionalizada (com acentuações de português, ideogramas em chinês, símbolos) isso não é necessário. Se o arquivo conter texto, daí a checagem do Ruby vai exigir que você explicitamente diga que encoding está no string. Porém, use isso como um [code smell](http://en.wikipedia.org/wiki/Code_smell) no caso de uma aplicação web internacionalizada, pois todo texto deveria estar em arquivos de localização (como vamos mostrar). Somente em aplicativos não-internacionalizados, onde o texto às vezes estará misturado ao seu código, isso pode te ajudar.

## Iniciando uma aplicação Rails

Assumindo que estamos usando o Rails 3.2 (3.2.6, para ser mais preciso). Criamos uma aplicação normalmente:

* * *

rails new i18n\_demo  
-

Agora vamos fazer algumas mudanças que você deveria fazer em toda aplicação:

* * *

rm public/index.html  
-

Adicione as seguintes gems no seu <tt>Gemfile</tt>:

* * *
ruby

…  
gem ‘devise’

group :development, :test do  
 gem ‘rspec-rails’  
 gem ‘pry-rails’

gem ‘guard’ gem ‘guard-rspec’ gem ‘growl’

end  
-

Modifique seu <tt>config/application.rb</tt>, aproximadamente na linha 28, para ficar como no trecho a seguinte:

* * *
ruby
1. Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
2. Run “rake -D time” for a list of tasks for finding time zone names. Default is UTC.  
config.time\_zone = ‘Brasilia’

1. The default locale is :en and all translations from config/locales/\*.rb,yml are auto loaded.
2. config.i18n.load\_path += Dir[Rails.root.join(‘my’, ‘locales’, ‘\*.{rb,yml}’).to\_s]  
config.i18n.available\_locales = [:en, :“pt-BR”]  
config.i18n.default\_locale = :“pt-BR”

1. Configure the default encoding used in templates for Ruby 1.9.  
config.encoding = “utf-8”  
-

Neste exemplo considero que estou apenas suportanto Inglês (en) e Português (pt-BR). Por padrão o Rails sempre procurará por arquivos de tradução a partir do diretório <tt>config/locales</tt> e sempre com arquivos no formato <tt>#{locale}.yml</tt> ou <tt>#{locale}rb</tt>, por exemplo, <tt>devise.pt-BR.yml</tt>.

> Dica: nunca coloque tudo num único arquivo <tt>pt-BR.yml</tt>, separe suas traduções em múltiplos arquivos por assunto, como <tt>rails.pt-BR.yml</tt> para traduções relacionadas aos helpers do Rails e <tt>devise.pt-BR.yml</tt> para traduções específicas da gem Devise.

Eu particularmente prefiro utilizar arquivos YAML do que hashes em Ruby. Tecnicamente não faz diferença, mas eu recomendo se manter no YAML.

Um dos rubistas que há mais tempo vem auxiliando no suporte a i18n no Rails é [Sven Fuchs](http://svenfuchs.com), a grande maioria das técnicas, bibliotecas, e tudo mais que temos de I18n veio inicialmente dele, vale a pena conhecê-lo melhor. Além disso o suporte canônico a arquivos de localização está no seu projeto [rails-i18n](https://github.com/svenfuchs/rails-i18n). Você vai encontrar traduções de praticamente todas as linguagens do mundo que importa. No nosso caso, queremos puxar a localização em Português. Faça assim:

* * *

curl https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/pt-BR.yml \> config/locales/rails.pt-BR.yml  
curl https://raw.github.com/svenfuchs/rails-i18n/master/rails/locale/pt-BR.yml \> config/locales/rails.en.yml  
-

Somente isso já lhe vai traduzir a maioria dos helpers do Rails. Para testar, vamos criar uma página simples:

* * *

rails g controller welcome index  
-

Adicione no seu arquivo de rotas:

* * *
ruby

I18nDemo::Application.routes.draw do  
 get “welcome/index”, as: “welcome”  
 root to: ‘welcome#index’  
end  
-

E coloque no seu arquivo <tt>app/views/welcome/index.html.erb</tt>

* * *
<dl>
  <dt>Number to Currency</dt>
  <dd><%= number_to_currency(123.56) %></dd>
  <dt>Number to Human</dt>
  <dd><%= number_to_human(100_555_123.15) %></dd>
  <dt>Date</dt>
  <dd><%=l Time.current, format: :long %></dd>
  <dt>Time</dt>
  <dd><%= distance_of_time_in_words(1.hour + 20.minutes) %></dd>
</dl>
* * *

Se subir o Webrick com <tt>rails s</tt> e consultar <tt>http://localhost:3000</tt> verá uma página com o seguinte:

![](http://s3.amazonaws.com/akitaonrails/assets/2012/7/14/Screen%20Shot%202012-07-14%20at%208.35.30%20PM_original.png?1342308971)

Estará em português porque configuramos a aplicação para que o padrão fosse esse: <tt>config.i18n.default_locale = :“pt-BR”</tt>. Neste momento ainda não temos como mudar a linguagem. Mas não se preocupe, em breve você poderá realizar a mudança. O visual estará diferente da imagem, veremos isso mais para frente.

## Devise

Praticamente todo aplicativo web precisa de autenticação. Não somente login, mas confirmação de inscrição, email para reiniciar senha, etc. Não pense duas vezes: adicione o Devise. Novamente, não vou repetir o que já foi dito, para aprender mais sobre o assunto, assista o screencast que o Ryan Bates lançou recentemente:

- [Episódio 209: Devise](http://railscasts.com/episodes/209-devise-revised "revised")
- [Episódio 210: Customizing Devise](http://railscasts.com/episodes/210-customizing-devise)
- [Episódio 235: Devise and OmniAuth](http://railscasts.com/episodes/235-devise-and-omniauth-revised "revised")

Na prática, dado que já incluímos a gem no <tt>Gemfile</tt> anteriormente e já rodamos <tt>bundle</tt> para instalar as gems, o próximo passo é criar os arquivos que precisamos:

* * *

rails g devise:install  
rails g devise User  
-

Da mesma forma como fizemos antes, vamos baixar as traduções que precisamos. O primeiro lugar a procurar é no [Wiki oficial do Devise](https://github.com/plataformatec/devise/wiki/I18n) que, atualmente, sugere o projeto do [Christopher Dell](http://tigrish.com/) que tenta ser o [repositório centralizado](https://github.com/tigrish/devise-i18n) com todas as traduções em todas as linguagens para o Devise.

* * *

curl https://raw.github.com/tigrish/devise-i18n/master/locales/en-US.yml \> config/locales/devise.en.yml  
curl https://github.com/tigrish/devise-i18n/blob/master/locales/pt-BR.yml \> config/locales/devise.pt-BR.yml  
-

Mas somente isso não é suficiente. Você pode utilizar as views que vem embutidas na Rails Engine do Devise ou pode precisar customizá-las e nesse caso precisa copiar essas views para dentro do seu projeto, desta forma:

* * *

$ rails g devise:views  
 invoke Devise::Generators::SharedViewsGenerator  
 create app/views/devise/shared  
 create app/views/devise/shared/_links.erb  
 invoke form\_for  
 create app/views/devise/confirmations  
 create app/views/devise/confirmations/new.html.erb  
 create app/views/devise/passwords  
 create app/views/devise/passwords/edit.html.erb  
 create app/views/devise/passwords/new.html.erb  
 create app/views/devise/registrations  
 create app/views/devise/registrations/edit.html.erb  
 create app/views/devise/registrations/new.html.erb  
 create app/views/devise/sessions  
 create app/views/devise/sessions/new.html.erb  
 create app/views/devise/unlocks  
 create app/views/devise/unlocks/new.html.erb  
 invoke erb  
 create app/views/devise/mailer  
 create app/views/devise/mailer/confirmation\_instructions.html.erb  
 create app/views/devise/mailer/reset\_password\_instructions.html.erb  
 create app/views/devise/mailer/unlock_ instructions.html.erb  
-

Veja que ele copia muitos arquivos. Vamos abrir um deles:

* * *
html
## Resend confirmation instructions

\<%= form\_for(resource, :as =\> resource\_name, :url =\> confirmation\_path(resource\_name), :html =\> { :method =\> :post }) do |f| \>  
 \<= devise\_error\_messages! %\>

\<%= f.label :email \>  
 \<= f.email\_field :email %\>

\<%= f.submit “Resend confirmation instructions” %\>

\<% end %\>

\<%= render “devise/shared/links” %\>  
-

Note que todos os textos estão embutidos: exatamente o que eu disse que numa aplicação I18n não devemos fazer. Ou seja, para tornar essas views traduzíveis, precisamos extrair uma a uma. Sim, será bastante trabalho. Ou você pode usar o caminho mais fácil e procurar alguém que já tenha feito isso – como eu fiz neste aplicativo de exemplo.

* * *

wget https://raw.github.com/akitaonrails/Rails-3-I18n-Demonstration/master/config/locales/devise.views.en.yml \> config/locales/devise.views.en.yml  
wget https://raw.github.com/akitaonrails/Rails-3-I18n-Demonstration/master/config/locales/devise.views.pt-BR.yml \> config/locales/devise.views.pt-BR.yml  
-

Isso vai copiar as traduções que você vai precisar. Agora faça um clone do meu projeto e copie sobre o seu (caso esteja fazendo este exercício enquanto lê o artigo):

* * *

cd ..  
git clone git://github.com/akitaonrails/Rails-3-I18n-Demonstration.git akitaonrails-i18n-demo  
cd akitaonrails-i18n  
git checkout 0ff207ed9ea58a14a16c14fc11272a3991918dab  
cd i18n\_demo  
cp R ../akitaonrails-i18n\_demo/app/views/devise/\* app/views/devise/  
--

Isso deve sobrescrever as views criadas pelo gerador padrão do Devise pela minha versão já com as strings substituídas. Apenas como dica note que no arquivo de tradução temos trechos como este:

* * *
yaml

pt-BR:  
 devise:  
 confirmations:  
 new:  
 title: Reenviar instruções de confirmação  
 submit: Reenviar instruções de confirmação  
-

E para acesssar a tradução podemos fazer assim:

* * *
ruby
1. I18n.locale = :“pt-BR”  
I18n.t(“devise.confirmations.new.title”)  
I18n.t(:title, scope: [:devise, :confirmations, :new])  
-

Qualquer dessas e outras variações funcionam igual e acham a string correta, mas na view que você baixou do meu projeto, temos o seguinte no arquivo <tt>app/views/devise/confirmations/new.html.erb</tt>:

* * *
html
# \<%= t(“.title”) %\>

…  
-

O Rails automaticamente usa a convenção <tt>{namespace}/{controllers}/{action}</tt> para gerar o escopo (<tt>scope</tt>) e então só precisamos complementar com <tt>.title</tt> para achar a chave que queremos. Isso diminui muito a quantidade de digitação para as chaves de tradução, basta seguir as convenções como sempre.

Outra coisa importante é traduzir os nomes dos modelos e seus atributos. Eles são usados pelos helpers de formulários do Rails. No arquivo <tt>config/locales/rails.pt-BR.yml</tt> adicione ao final do arquivo:

* * *
yaml

activemodel:  
 errors:  
 \<\<: \*errors  
activerecord:  
 errors:  
 \<\<: \*errors  
 models:  
 user: “Usuário”  
 article: “Artigo”  
 attributes:  
 user:  
 email: “E-mail”  
 password: “Senha”  
 password\_confirmation: “Confirmar Senha”  
 current\_password: “Senha Atual”  
 remember\_me: “Lembre-se de mim”  
 article:  
 title: “Título”  
 body: “Conteúdo”  
 body\_html: “Conteúdo em HTML”  
-

O modelo <tt>User</tt> já foi criado pelo Devise. Ainda não criamos o modelo <tt>Article</tt> mas já fica aqui para referência. No arquivo <tt>config/locales/rails.en.yml</tt> podemos simplificar porque quando o Rails não encontra a tradução ele usa o próprio nome dos atributos.

> Sempre desenvolva todas as suas aplicações em inglês, é uma boa recomendação. E que seja português sempre a segunda linguagem. Usando essa convenção você não deve ter grandes problemas. Mas ao mesmo tempo não inclua no arquivo <tt>config/initializers/inflections.rb</tt> as regras de pluralização em português, pois isso vai causar problemas ao Rails para encontrar nomes de tabelas ao pluralizá-los usando a regra errada em português.

* * *
yaml

en:  
 hello: “Hello world”  
 site\_name: “I18n Demonstration”  
 translation:  
 en: English  
 pt-BR: Portuguese  
 admin:  
 title: “Administration”  
 articles:  
 title: “Articles”  
-

## Atributos Traduzidos de ActiveRecord com Globalize 3

O conceito é simples: queremos um suporte que me permita utilizar os mesmos nomes de atributos mas que devolvam valores diferntes dependendo da localização escolhida atualmente. Um código de teste seria assim:

* * *
ruby

require ‘spec\_helper’

describe Article do  
 before(:each) do  
 I18n.locale = :en  
 @article = Article.create title: “Hello World”, body: “ **Test** ”  
 I18n.locale = :“pt-BR”  
 @article.update\_attributes(title: “Ola Mundo”, body: “_Teste_”)  
 end

context “translations” do it “should read the correct translation” do @article = Article.last I18n.locale = :en @article.title.should == “Hello World” @article.body.should == “ **Test** ” I18n.locale = :“pt-BR” @article.title.should == “Ola Mundo” @article.body.should == “_Teste_” end end

end  
-

A opção que escolhi foi novamente um projeto do Sven Fuchs, o [Globalize 3](https://github.com/svenfuchs/globalize3). Esse projeto tem um longo histórico que volta desde, claro, [Globalize 2](https://github.com/joshmh/globalize2) e [Globalize](https://github.com/yannlugrin/globalize). Obviamente, não use as versões antigas, coloquei os links apenas para referência. Como sempre, adicione ao seu <tt>Gemfile</tt> e execute <tt>bundle</tt> em seguida:

* * *
ruby

gem ‘globalize3’  
-

Para demonstrar como funciona, vamos criar um novo model:

* * *

rails g model Article slug title body:text body\_html:text  
-

Preste atenção no arquivo de migration criado por esse generator. Abra no seu editor e modifique para que ele fique da seguinte forma:

* * *
ruby

class CreateArticles \< ActiveRecord::Migration  
 def up  
 create\_table :articles do |t|  
 t.string :slug, null: false  
 t.timestamps  
 end  
 add\_index :articles, :slug, unique: true

Article.create\_translation\_table! :title =\> :string, :body =\> :text end def down drop\_table :articles Article.drop\_translation\_table! end

end  
-

Não use o método <tt>change</tt> da migration. Feita a mudança execute <tt>rake db:migrate</tt> para criar as tabelas. Agora, vamos alterar o arquivo <tt>app/model/article.rb</tt>:

* * *
ruby

class Article \< ActiveRecord::Base  
 attr\_accessible :slug, :title, :body, :body\_html, :locale, :translations\_attributes

translates :title, :body, :body\_html accepts\_nested\_attributes\_for :translations class Translation attr\_accessible :locale, :title, :body, :body\_html end

end  
-

Agora o model vai se comportar exatamente como descrito na spec acima. O truque é que a migration vai criar uma nova tabela <tt>articles</tt> e também <tt>article_translation</tt> e criará implicitamente por causa do método de classe <tt>translates</tt> uma associação parecida com <tt>has_many :translations, class_name: “article_translation”</tt>. Ele vai alterar o model para que os atributos passem a consultar o <tt>I18n.locale</tt> antes de ler ou gravar novos dados. Cada localização se tornar uma linha na tabela escondida de traduções e consultas no model <tt>Article</tt> procuram na tabela implícita usando o <tt>locale</tt> atual.

## Seção Bônus: Friendly Id

Vamos fazer um pequeno desvio que não tem nada a ver com I18n para recomendar mais algumas coisas. A primeira é o problema de IDs e Slugs. Se você utilizar o Rails básico, todo Model terá um ID numérico incremental e toda URL será no formato <tt>/articles/123</tt>. A recomendação é nunca expor o ID único diretamente do banco de dados na sua aplicação. Dependendo do que sua aplicação fizer, o usuário pode começar a experimentar colocar valores numéricos e acabar achando algo que você não queria que ele visse.

Uma das formas de esconder esses IDs numéricos é usar um [slug](http://en.wikipedia.org/wiki/Slug_(web_publishing)) e transformar uma informação específica do seu Modelo – de preferência a segunda coisa depois do ID que seja mais único quanto possível – por exemplo, no caso do nosso modelo <tt>Article</tt>, o candidato seria o atributo <tt>title</tt>. Lembram que quando criamos o modelo já adicionei um campo <tt>slug</tt>? É para usá-lo aqui.

A gem que recomendo para gerenciar slugs é a [Friendly Id](https://github.com/norman/friendly_id/blob/master/lib/friendly_id/slugged.rb) do Norman Clark. A utilização é muito simples: primeiro garanta ter um campo <tt>slug</tt> no seu model, lembrando de adicionar também um índice que garanta sua unicidade no banco. Olhe novamente a migration anterior e vai encontrar esta linha:

* * *
ruby

add\_index :articles, :slug, unique: true  
-

Feito isso adicione a gem no <tt>Gemfile</tt>:

* * *
ruby

gem ‘friendly\_id’  
-

Execute <tt>bundle</tt> para instalar e modifique seu modelo:

* * *
ruby

class Article \< ActiveRecord::Base  
 attr\_accessible :body, :body\_html, :slug, :title, :locale, :translations\_attributes  
 extend FriendlyId  
 friendly\_id :title, use: :slugged  
 …  
 private

def should\_generate\_new\_friendly\_id? new\_record? end
* * *

Se fizer tudo corretamente, o comportamento será de acordo com a seguinte spec:

* * *
ruby

require ‘spec\_helper’

describe Article do  
 before(:each) do  
 I18n.locale = :en  
 @article = Article.create title: “Hello World”, body: “ **Test** ”  
 …  
 end  
 …  
 context “slug” do  
 it “should generate a slug” do  
 @article.slug.should == “hello-world”  
 end  
 end  
end  
-

Não só isso mas helpers como <tt>article_path</tt> e mesmo o método <tt>find</tt> do model passam a aceitar tanto a chave primária numérica como o slug para procurar no banco de dados. Essa gem torna essa utilização transparente e você vai usá-la como se estivesse usando uma chave primária normal.

Um detalhe: note o método <tt>should_generate_new_friendly_id?</tt> que sobrescrevemos. No comportamento padrão, a gem vai atualizar o atributo <tt>slug</tt> sempre que atualizarmos o conteúdo do campo <tt>title</tt>. Mas não queremos que isso aconteça, especialmente porque se adicionarmos o conteúdo localizado do mesmo atributo, o slug vai sempre ficar mudando para cada novo título que acrescentarmos. Além disso, se um conteúdo já foi publicado, não convém mudar sua URL – isso é ruim para [SEO](http://en.wikipedia.org/wiki/Search_engine_optimization). Portanto o gerador de slugs só vai rodar se for um registro novo, não se for uma atualização de um já existente.

## Continua na Parte 2

Continue lendo este artigo na [Parte 2](http://akitaonrails.com/2012/07/14/internationalizacao-i18n-minima-em-rails-3-2-parte-2).

