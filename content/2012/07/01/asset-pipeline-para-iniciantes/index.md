---
title: Asset Pipeline para Iniciantes
date: '2012-07-01T05:34:00-03:00'
slug: asset-pipeline-para-iniciantes
tags:
- learning
- beginner
- rails
- tutorial
- front-end
draft: false
---

Este é provavelmente um dos assuntos mais confusos para quem está iniciando com Ruby on Rails. Antigamente, as regras eram simples:

- coloque todos os seus _assets_ (imagens, stylesheets e javascripts) organizados nas pastas <tt>public/images</tt>, <tt>public/stylesheets</tt>, <tt>public/javascripts</tt>;
- utilize _helpers_ como <tt>image_tag</tt>, <tt>stylesheet_link_tag</tt> e <tt>javascript_include_tag</tt>;
- configure seu servidor web (Apache, NGINX) para servir URIs como <tt>/images/rails.png</tt> diretamente de <tt>public/images/rails.png</tt> para não precisar passar pelo Rails;

Pronto, está tudo preparado para funcionar. Porém, existiam e ainda existem muitas situações que essa regra não cobria e diversas técnicas, “boas práticas” e gems externas precisaram ser criadas para resolvê-las. Em particular, temos as seguintes situações cotidianas em desenvolvimento web:

- quando se tem muitos assets, como javascripts, é considerado boa prática “minificá-los”, ou seja, otimizar ao máximo a quantidade de bytes eliminando supérfluos como espaços em branco e quebras de linha, nomes de variáveis e funções longas, etc. E além disso concatenar a maior quantidade de arquivos num único quanto possível. Em desenvolvimento, precisamos ter todos abertos e individuais para facilitar o debugging, mas em produção o correto é “compilá-los”
- cache precisa ser usado o máximo possível e escrever o caminho a um path manualmente, como <tt><img src=“/images/rails.png”/></tt> é ruim, pois se precisarmos mudar o conteúdo dessa imagem, os usuários precisariam limpar seus caches pois o correto é configurarmos os servidores web com diretivas para manter assets no cache local por um longo período de tempo (1 ano ou mais). Helpers como <tt>image_tag</tt> criavam caminhos como <tt><img src=“/images/rails.png?12345678”/></tt>, sendo esse número derivado do timestamp de modificação do asset. Assim, se o asset era atualizado esse número mudava. Mas isso não funciona bem com muitos tipos de caches e proxies, que ignoram o que vem depois do “?”
- quando uma página possui dezenas ou às vezes centenas de pequenas imagens e ícones (setas, botões, logotipos de seção, linhas, bordas, etc), o correto é usar a mesma técnica que usamos com stylesheets e javascripts: concatenar muitas imagens em um único arquivo maior e então utilizar CSS para manipular a posição x e y dentro dessa única imagem grande para posicioná-la corretamente onde precisamos.
- começamos a utilizar vários tipos diferentes de geradores de templates, como LESS e SASS para gerar stylesheets, CoffeeScript para gerar Javascript, além do próprio ERB para adicionar conteúdo dinâmico nos templates.

Para resolver essas e outras situações é que foi criado o chamado [Asset Pipeline](http://guides.rubyonrails.org/asset_pipeline.html), que é um conjunto de bibliotecas e convenções para resolver o problema de assets da melhor forma possível. O Asset Pipeline sozinho não resolve tudo, ele é um framework para que seja possível integrar diferentes soluções de forma organizada.

Tudo que será explicado neste artigo vale para o Rails 3.2 e superior, existem diferenças importantes nas versões anteriores que não serão tratadas aqui. Leia o Rails Guides, especialmente os Release Notes de cada versão.


## Iniciando um projeto Rails

Quando iniciamos um novo projeto com o comando <tt>rails new novo_projeto</tt>, o primeiro arquivo que você vai querer mexer é o <tt>Gemfile</tt>:

* * *
ruby
1. Original  
group :assets do  
 gem ‘sass-rails’, ‘~\> 3.2.3’  
 gem ‘coffee-rails’, ‘~\> 3.2.1’

1. See https://github.com/sstephenson/execjs#readme for more supported runtimes
2. gem ‘therubyracer’, :platforms =\> :ruby

gem ‘uglifier’, ‘\>= 1.0.3’

end

1. Recomendado para iniciar  
group :assets do  
 gem ‘sass-rails’  
 gem ‘compass-rails’

1. See https://github.com/sstephenson/execjs#readme for more supported runtimes  
 gem ‘therubyracer’, :platforms =\> :ruby

gem ‘uglifier’

end  
-

Não vamos entrar na [controvérsia agora sobre CoffeeScript](http://akitaonrails.com/2011/04/16/a-controversia-coffeescript). Se você está iniciando, esqueça CoffeeScript por enquanto para não complicar ainda mais. Por outro lado, usar o [Compass](http://compass-style.org) e particularmente o [Compass Rails](https://github.com/Compass/compass-rails/) é algo que nem precisamos discutir já que o Compass provê diversos mixins de Sass muito úteis.

Aliás, se você ainda não conhece [SASS](http://sass-lang.com), faça a você mesmo um favor e aprenda. Se você entende CSS, não vai ter problemas entendendo Sass, em particular a versão “SCSS” ou “Sassy CSS” que não é mais do que um conjunto acima do CSS3. Lembrando que mesmo escolhendo usar SASS podemos misturar arquivos <tt>.css.scss</tt> e arquivos convencionais <tt>.css</tt> no mesmo projeto.

Ao modificar o arquivo <tt>Gemfile</tt>, lembre-se de executar os seguintes comandos no terminal:

* * *

bundle  
-

Para exercitar, vamos criar um simples controller com uma única página dinâmica para entender o que podemos fazer com isso. De volta ao terminal faça o seguinte:

* * *

rm public/index.html  
bundle exec rails g controller home index  
-

O resultado será:

* * *
create app/controllers/home\_controller.rb route get “home/index” invoke erb create app/views/home create app/views/home/index.html.erb invoke test\_unit create test/functional/home\_controller\_test.rb invoke helper create app/helpers/home\_helper.rb invoke test\_unit create test/unit/helpers/home\_helper\_test.rb invoke assets invoke js create app/uploads/javascripts/home.js invoke scss create app/uploads/stylesheets/home.css.scss
* * *

E para combinar, já que estamos recomendando SCSS, vamos apagar o arquivo <tt>app/stylesheets/application.css</tt> e criar um novo:

* * *

rm app/stylesheets/application.css  
touch app/stylesheets/application.css.scss  
-

E nesse novo arquivo podemos colocar somente:

* * *
css

@import “compass”  
-

Outra boa prática é ignorar o diretório <tt>public/uploads</tt> do repositório Git (você utilizar [Git](/2012/04/09/screencasts-liberados-gratuitamente), correto?). Faça o seguinte:

* * *

echo “public/uploads” \>\> .gitignore  
-

E agora já podemos iniciar o servidor local de Rails e examinar o que temos até agora:

* * *

bundle exec rails s  
-

## Processo de Pré-Compilação

Resumidamente, em termos de assets temos os seguintes principais elementos e estrutura:

* * *

app  
 assets  
 images  
 rails.png  
 javascripts  
 application.js  
 home.js  
 stylesheets  
 application.css.scss  
 home.css.scss  
 views  
 home  
 index.html.erb  
 layouts  
 application.html.erb  
config  
 application.rb  
public  
 assets  
Gemfile  
Gemfile.lock  
-

O código fonte do layout <tt>app/views/layouts/application.html.erb</tt> contém o seguinte:

* * *
html

\<!DOCTYPE html\>

  
<title>NovoProjeto</title>
  
 \<%= stylesheet\_link\_tag “application”, :media =\> “all” \>  
 \<= javascript\_include\_tag “application” \>  
 \<= csrf\_meta\_tags %\>

\<%= yield %\>

* * *

Se você já tinha visto até o Rails 2.x, um layout padrão ERB não é tão diferente. Com o servidor de pé, em ambiente de desenvolvimento, vejamos o HTML gerado ao abrir <tt>http://localhost:3000/home/index</tt>:

* * *
html

\<!DOCTYPE html\>

  
<title>NovoProjeto</title>
  
<link href="/uploads/application.css" media="all" rel="stylesheet" type="text/css">
  
<script src="/uploads/jquery.js?body=1" type="text/javascript"></script>  
<script src="/uploads/jquery_ujs.js?body=1" type="text/javascript"></script>  
<script src="/uploads/home.js?body=1" type="text/javascript"></script>  
<script src="/uploads/application.js?body=1" type="text/javascript"></script>  
<meta content="authenticity_token" name="csrf-param">
  
<meta content="OFmZwwtshevVgcs1DUg56WVIQ8NcJZsri/nUubhEJCk=" name="csrf-token">
# Home#index

Find me in app/views/home/index.html.erb

* * *

No HTML gerado, note que os links para os assets apontam todos para <tt>/uploads</tt>. Além disso note que a chamada <tt>javascript_include_tag(“application”)</tt> expandiu para 4 javascripts diferentes. Para entender isso, precisamos examinar mais de perto o arquivo <tt>app/uploads/javascripts/application.js</tt>:

* * *
javascript

…  
//= require jquery  
//= require jquery\_ujs  
//= require\_tree .  
-

Sobre o detalhe do jQuery, todo novo projeto Rails tem declarado <tt>gem ‘jquery-rails’</tt> no <tt>Gemfile</tt>.

Os arquivos <tt>application.∗</tt> podendo “∗” ser “js”, “js.coffee”, “css”, “css.scss”, “css.sass”, “js.erb”, “css.erb”, etc. Eles são conhecidos como “Manifestos”. São arquivos “guarda-chuva” que declaram todos os outros arquivos que eles dependem, em ordem, para serem concatenados em um único arquivo ao serem compilados.

No exemplo padrão, no <tt>application.js</tt> a primeira e segunda linha com <tt>require</tt> declaram o <tt>jquery.js</tt> e depois o <tt>jquery_ujs.js</tt> e a terceira linha com <tt>require_tree .</tt> manda carregar todos os outros arquivos javascripts no mesmo diretório que, por acaso, tem o <tt>home.js</tt> criado pelo gerador de controller que usamos antes. Agora vejam novamente o HTML gerado e verá que são exatamente os javascripts carregados na ordem que expliquei, sendo o quarto o próprio conteúdo do arquivo <tt>application.js</tt>.

Normalmente usar o <tt>require_tree .</tt> não é exatamente ruim se os javascripts não dependem da ordem de carregamento, mas você provavelmente vai querer declarar explicitamente coisas como plugins de jQuery para garantir que eles estão carregados antes de poder usá-los.

Para explicar como tudo isso funciona é importante pararmos o servidor Rails que subimos antes e reexecutá-lo em modo produçao:

* * *

bundle exec rails s e production  
--

Agora, se tentarmos carregar a mesma URL <tt>http://localhost:3000/home/index</tt> no browser, receberemos um erro 500 com o seguinte backtrace:

* * *

Started GET “/home/index” for 127.0.0.1 at 2012-07-01 03:31:55 -0300  
Connecting to database specified by database.yml  
Processing by HomeController#index as HTML  
 Rendered home/index.html.erb within layouts/application (12.0ms)  
Completed 500 Internal Server Error in 155ms

ActionView::Template::Error (application.css isn’t precompiled):  
 2:   
 3:

  
 4: <title>NovoProjeto</title>
  
 5: \<%= stylesheet\_link\_tag “application”, :media =\> “all” \>  
 6: \<= javascript\_include\_tag “application” \>  
 7: \<= csrf\_meta\_tags %\>  
 8:   
 app/views/layouts/application.html.erb:5:in `\_app\_views\_layouts\_application\_html\_erb\_\_408740569075721590\_70099961775620’  
-

Este é o sinal que não realizamos um passo importante que deve ser executado toda vez que você realizar uma atualização em produção: pré-compilar os assets. É o processo que lê os arquivos manifesto e realiza a concatenação dos arquivos declarados e sua minificação (utilizando a gem [Uglifier](https://github.com/lautis/uglifier)). Portanto, precisamos executar o seguinte:

* * *

bundle exec rake assets:precompile  
-

Lembrando que antes disso o diretório <tt>public/uploads</tt> estava originalmente vazio (e em desenvolvimento, você deve garantir que esse diretório esteja sempre vazio, já explicamos porque). Após executar a a pré-compilação, esse diretório terá os seguintes arquivos:

* * *

application-363316399c9b02b9eb98cd1b13517abd.js  
application-363316399c9b02b9eb98cd1b13517abd.js.gz  
application-7270767b2a9e9fff880aa5de378ca791.css  
application-7270767b2a9e9fff880aa5de378ca791.css.gz  
application.css  
application.css.gz  
application.js  
application.js.gz  
manifest.yml  
rails-be8732dac73d845ac5b142c8fb5f9fb0.png  
rails.png  
-

E para entender vejamos o código-fonte do HTML gerado em produção:

* * *
html

\<!DOCTYPE html\>

  
<title>NovoProjeto</title>
  
<link href="/uploads/application-7270767b2a9e9fff880aa5de378ca791.css" media="all" rel="stylesheet" type="text/css">
  
<script src="/uploads/application-363316399c9b02b9eb98cd1b13517abd.js" type="text/javascript"></script>  
<meta content="authenticity_token" name="csrf-param">
  
<meta content="OFmZwwtshevVgcs1DUg56WVIQ8NcJZsri/nUubhEJCk=" name="csrf-token">
# Home#index

Find me in app/views/home/index.html.erb

* * *

Compare este HTML com o anterior que analisamos gerado em ambiente de desenvolvimento. Em vez de 1 arquivo CSS e 4 Javascripts, temos apenas 1 CSS e 1 Javascript.

Para entendermos melhor, vejamos o que tem no arquivo <tt>public/uploads/manifest.yml</tt>:

* * *

rails.png: rails-be8732dac73d845ac5b142c8fb5f9fb0.png  
application.js: application-363316399c9b02b9eb98cd1b13517abd.js  
application.css: application-7270767b2a9e9fff880aa5de378ca791.css  
-

Ou seja, o arquivo <tt>application.js</tt> é idêntico ao <tt>application-363316399c9b02b9eb98cd1b13517abd.js</tt>. Se algum dos arquivos declarados no manifesto <tt>app/uploads/javascripts/application.js</tt> mudar, esse número sufixo irá mudar e o HTML apontará para o novo. Olhando novamente nossa lista de situações que precisam ser solucionadas, que apresentamos no início do arquivo, temos já até aqui a solução de 3 dos pontos:

- o ponto 1 explica o problema que é sempre melhor ter apenas um único arquivo de CSS ou JS do que dezenas deles separados, pois o navegador só precisa ter o peso de pedir um único arquivo (quanto mais arquivos, independente do tamanho, mais tempo vai demorar para a página renderizar). Além disso, graças ao Uglifier teremos esses arquivos “minificados”, ou seja, reescritos de forma a minimizar seu tamanho em bytes sem modificar a lógica da programação. Além disso, o pipeline vai um passo além e tem as versões de todos esses arquivos com extensão “.gz” que significa “gzip”. Se o browser fizer uma requisição dizendo que aceita conteúdo compactado em formato zip, se o web server disser que entende zip, ele pode diretamente enviar a versão do arquivo com extensão “.gz”. No exemplo acima, isso significa enviar um JS de 34kb em vez dos 98kb descomprimidos.
- o ponto 2 explica o problema de quanto assets mudam mas o browser guarda em cache baseado na URL que ele carregou. Se ele pedisse <tt>http://localhost:3000/uploads/application.js</tt>, mesmo se o JS fosse modificado, o browser não pediria novamente porque a boa prática diz que o web server deveria enviar cabeçalho dizendo para esse tipo de arquivo ficar em cache por 1 ano. Mas como o HTML na realidade pede por <tt>http://localhost:3000/uploads/application-363316399c9b02b9eb98cd1b13517abd.js</tt>, e se o JS mudar, esse número vai mudar também, não importa mais que esses assets fiquem indefinidamente em cache, pois da próxima vez que precisar dar versão mais nova, o nome do arquivo será completamente diferente do que estava no cache.
- finalmente, o ponto 4 explica sobre os diferente geradores de assets. Implicitamente já podemos ver isso no caso do SASS, onde arquivos com extensão “.css.scss” são convertidos em “.css”.

Para reforçar o ponto 2, vamos adicionar a seguinte função no arquivo <tt>app/uploads/javascripts/application.js</tt>:

* * *
javascript

function helloWorld() {  
 console.log(“Hello World”);  
}  
-

Agora executamos a pré-compilação novamente:

* * *

bundle exec rake assets:precompile  
-

O que temos no diretório <tt>public/uploads</tt> será:

* * *

application-363316399c9b02b9eb98cd1b13517abd.js  
application-363316399c9b02b9eb98cd1b13517abd.js.gz  
application-4fee97e9e402a9816ab9b3edf7a4c08b.js  
application-4fee97e9e402a9816ab9b3edf7a4c08b.js.gz  
application-7270767b2a9e9fff880aa5de378ca791.css  
application-7270767b2a9e9fff880aa5de378ca791.css.gz  
application.css  
application.css.gz  
application.js  
application.js.gz  
manifest.yml  
rails-be8732dac73d845ac5b142c8fb5f9fb0.png  
rails.png  
-

Como não limpamos o diretório antes, temos a versão antiga e a recente. Compare, a anterior se chamava <tt>application-363316399c9b02b9eb98cd1b13517abd.js</tt> e a nova com a função de demonstração se chama <tt>application-4fee97e9e402a9816ab9b3edf7a4c08b.js</tt>. Reiniciando o servidor Rails no ambiente de produção e vendo o novo HTML gerado, verá este trecho:

* * *
html<script src="/uploads/application-4fee97e9e402a9816ab9b3edf7a4c08b.js" type="text/javascript"></script>
* * *

Espero que esse detalhamente deixe bem claro o objetivo do pipeline de pré-compilação e as convenções de nomenclatura e quais problemas ele soluciona. Num artigo que escrevi recentemente chamado [Enciclopédia do Heroku](http://akitaonrails.com/2012/04/20/heroku-tips-enciclopedia-do-heroku) explico como mover esses assets pré-compilados para uma conta na Amazon S3, com o objetivo de descarregar processamento do seu servidor de aplicação, servindo a partir de um [CDN](http://pt.wikipedia.org/wiki/Content_Delivery_Network), o que deve melhorar a experiência do usuário final ao carregar assets de um servidor mais próximo.

## Parte 2

O artigo ficou longo, por isso vamos continuar na [Parte 2](http://akitaonrails.com/2012/07/02/asset-pipeline-para-iniciantes-parte-2)

