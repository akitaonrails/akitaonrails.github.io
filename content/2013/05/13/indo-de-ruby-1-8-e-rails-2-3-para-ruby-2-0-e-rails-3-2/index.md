---
title: Indo de Ruby 1.8 e Rails 2.3 para Ruby 2.0 e Rails 3.2
date: '2013-05-13T17:37:00-03:00'
slug: indo-de-ruby-1-8-e-rails-2-3-para-ruby-2-0-e-rails-3-2
tags:
- learning
- rails
draft: false
---

Caso ainda não saiba, o bom e velho Ruby 1.8 desempenhou seu papel muito bem nos últimos anos e chegou a [hora de aposentá-lo](https://blog.engineyard.com/2012/ruby-1-8-7-and-ree-end-of-life). Ele não receberá mais manutenção ou mesmo correções de segurança a partir de Junho deste ano (2013). Significa que seu irmão-gêmeo, o venerado [Ruby Enterprise Edition 1.8.7](http://www.rubyenterpriseedition.com/), que nos apresentou a funcionalidade de [Copy-on-Write](http://www.akitaonrails.com/2008/4/19/o-que-ruby-enterprise-edition#.UZEj0Ss6WDQ) e a possibilidade de refinar os parâmetros do garbage collector, também ser tornará obsoleto em breve.

O que acontece hoje é que existem muitos aplicativos ainda rodando em Ruby MRI ou REE 1.8.7, desenvolvido em Ruby on Rails 2.3, em produção, que ninguém sabe o que deve fazer. A resposta mais comum, caso pergunte aleatoriamente a um desenvolvedor, será "reescrever" em [Ruby 2](http://www.slideshare.net/akitaonrails/o-que-tem-de-novo-no-ruby-20) e Ruby on Rails 3.2 (ou já arriscando para o [Rails 4.0](http://www.slideshare.net/akitaonrails/whats-new-in-rails-4) que sairá em breve).

Minha resposta é diferente: se seu aplicativo está hoje em produção, com usuários acessando, minha primeira opção sempre será explorar a possibilidade de realizar o que chamamos de "migração técnica". Uma migração técnica:

* não envolve mudar funcionalidades ou criar novas;
* no máximo retirar funcionalidades desnecessárias;
* e apenas realizar a atualização para as versões mais recentes de Ruby e Rails. 

Reescrever sempre é mais arriscado e - normalmente - representa um custo/benefício inferior. Isso porque reescrever significa: 

* precisar atingir "paridade de funcionalidades", ou seja, ter no mínimo as mesmas funcionalidades principais do seu aplicativo atual;
* se conseguir fazer isso (e a maioria não consegue), haverá um momento com dois aplicativos rodando em produção onde você precisará tentar uma migração dos dados (com regras de negócio possivelmente diferentes) para uma nova base e "virar a chave";
* haverá um bom período de "estabilização". Um aplicativo reescrito significa retornar à versão 1.0, com muito mais bugs do que o antigo, e até ele se estabilizar - com uma base de usuários ativa - vai demorar;
* durante todo esse período você provavelmente não vai conseguir lançar novas funcionalidades - pois significaria implementar duas vezes, no antigo e no novo - isso pode causar sérios problemas de competitividade de mercado (onde outros menores podem começar a lançar o que você já deveria ter lançado, na sua frente).

Portanto a resposta automática nunca deverá ser reescrever. Analise os impactos que mencionei e diversos outros que dependem do seu negócio. Isso tudo dito, porque a maioria dos desenvolvedores respondem automaticamente "reescrever"?

* porque ninguém gosta de assumir código de outro programador, especialmente código "velho", que não é esteticamente atualizado. Em diferentes níveis, todo programador sofre da síndrome de NIH (Not Invented Here);
* porque o código tem pouco ou nenhum teste automatizado, e portanto o risco de mudar código é alto e poucos programadores se sentem confortáveis em assumir a responsabilidade de um código desconhecido.

Se for resumir, a raíz do problema costuma ser dois sentimentos que se contradizem: Ego e Insegurança. Se contradizem porque Ego pressupõe uma confiança nas próprias habilidades de conseguir fazer melhor que o anterior, e Inssegurança pressupõe falta de confiança nas próprias habilidades de conseguir fazer melhor que o anterior. Se você é programador, reflita sobre isso.

Por outro lado eu considero que um programador que tem pouco Ego e muita Segurança é sempre o que tem mais chances de poder se chamar um sênior de verdade. Afinal o que parece mais "fácil" qualquer um sabe fazer, no mundo do "difícil" existe pouca concorrência, pois poucos sobrevivem.

Muitos já me consultaram sobre o que fazer para atualizar um aplicativo Ruby 1.8 com Rails 2.3 para as versões mais novas. 

Minha resposta é sempre a mesma: 

## "Um Passo de Cada Vez"

O primeiro erro básico que **TODOS** os desenvolvedores de todos os níveis cometem logo de cara é tentar atualizar diretamente do Ruby 1.8 para 1.9 ou 2.0 e do Rails 2.3 para 3.2 ou 4.0. Está errado, isso é um passo maior do que você vai conseguir administrar. 

Eu pessoalmente participei na atualização de uma aplicação antiga exatamente nessas condições e fui bem sucedido. O aplicativo não era super complicado mas estava longe de ser trivial. Ao mesmo tempo que subimos de Ruby 1.8 para Ruby 2.0 e de Rails 2.3 para Rails 3.2; subimos a cobertura de teste de zero para mais de 50% (e isso sem ignorar as diversas configurações de ActiveAdmin no <tt>app/admin</tt> que conta como arquivo Ruby não coberto por teste). 

Além disso, em paralelo, otimizamos a performance da aplicação, da infraestrutura, e conseguimos um ganho de performance ridículo onde as requisições mais pesadas, que antes faziam o usuário esperar até 15 segundos (!!), agora não ultrapassam 400ms (segundos para milissegundos, exatamente isso). E veja que qualquer coisa acima de 200ms eu ainda não considero rápido o suficiente. No mundo perfeito, total abaixo de 100ms por requisição é o ideal. "Tempo total" é o tempo de processamento mais o overhead da infraestrutura e internet.

Isso foi um processo que, não trabalhando tempo integral me custou pouco menos de **3 semanas** de trabalho. Obviamente seu tempo vai variar dependendo da complexidade da sua aplicação e da estratégia da sua empresa (que deve ser levada em consideração o tempo todo). 

Antes de mais nada, se você nunca usou os Rails mais atuais do que 2.3, pelo menos tenha uma noção lendo os **Release Notes** que está no Guia oficial:

* [Ruby on Rails 2.3 Release Notes](http://guides.rubyonrails.org/2_3_release_notes.html)
* [Ruby on Rails 3.0 Release Notes](http://guides.rubyonrails.org/3_0_release_notes.html)
* [Ruby on Rails 3.1 Release Notes](http://guides.rubyonrails.org/3_1_release_notes.html)
* [Ruby on Rails 3.2 Release Notes](http://guides.rubyonrails.org/3_2_release_notes.html)
* [Edge - Ruby on Rails 4.0 Release Notes](http://edgeguides.rubyonrails.org/4_0_release_notes.html)

Todos os Rails, da versão 2.3 até a 3.2  suportam Ruby 1.8.7, portanto você pode escolher mudar o Ruby só no final. Por outro lado se quiser arriscar a série 1.9, até o Rails 3.1 use apenas até o Ruby 1.9.2. Só mude para Ruby 1.9.3 no Rails 3.2.

Em particular, neste momento (Maio de 2013) recomendo ficar no Ruby 1.9.3 com Rails 3.2. Se chegar até esse ponto, você vai, no mínimo, ter uma sobrevida até 2014. Só depois que tiver certeza que está tudo estável nessas versões, mude para Rails 4.0.

## Rails 2.3 para Rails 3.0

Nesta primeira etapa você praticamente não vai precisar alterar nada pois o Rails 3.0 mantém um alto nível de compatibilidade com o anterior. Coisas como as APIs novas de Routing, ActiveRelation, nada disso é obrigatório. O resto é o mesmo: views ERB vai funcionar igual, seus assets no <tt>/public</tt> funcionam normalmente.

O maior impacto para quem nunca foi para a versão 3.0 é aprender a usar o [Bundler](http://gembundler.com/v1.3/rails23.html) que inclusive você já pode adicionar a um projeto 2.3 antes de tentar migrar para 3.0.

Um dica válida para toda atualização significativa de Rails: crie um projeto novo na versão para onde está mudando e compare todos os arquivos da pasta <tt>/config</tt>, todos. Muitos dos erros que aparecem é por falta das novas configurações.

Sobre configurações ainda, antigamente existiam as gems chamadas "mysql" e "postgres", elas devem ser atualizadas para as gems [mysql2](http://rubygems.org/gems/mysql2) e [pg](http://rubygems.org/gems/pg), respectivamente. Elas são o que chamamos de _drop-in replacements_, ou seja, apenas troque e tudo deve continuar funcionando sem que você precise mudar nada.

Para quem não se lembra, o Ruby on Rails 3.0 foi o primeiro (e felizmente bem sucedido) "HUMONGOUS REWRITE" do framework. Isso foi amplamente divulgado, centenas de blog posts foram escritos, muita polêmica foi levantada, quase 2 anos foram gastos nesse assunto. Até o Rails 2.3 foi uma evolução do antigo código que o próprio David Hansson escreveu em 2004. As versões atuais são derivadas da nova arquitetura que nasceu no Rails 3.0. Em resumo, não estaríamos hoje falando de Rails se a versão 3.0 tivesse fracassado. 

Isso justifica porque migrar do Rails 2.3 para o 3.0 exige um volume de esforço não tão grande. Você só terá problemas se escreveu código extremamente mal feito ainda na versão 2.3, fugindo completamente das convenções aceitas até então. Exemplo disso são monkey-patches feitos diretamente sobre o framework. Como no 3.0 as APIs internas mudaram, gambiarras vão necessariamente quebrar. Se você tem consciência que fez muita gambiarra e brigou contra o framework, agora o preço será devidamente cobrado, e com juros.

As principais APIs que você precisará saber que mudou (mas que a versão antiga ainda funciona no 3.0), em ordem do mais simples até o mais complicado de mudar:

* [Novo Mailer](http://lindsaar.net/2010/1/26/new-actionmailer-api-in-rails-3). Na maior parte será apenas um caso de alterar nomes de métodos. Aproveite para adicionar specs. Será uma atualização razoavelmente mecânica de uma API para outra.

* [Novo Router](http://www.railsdispatch.com/posts/rails-routing). Novamente, na maior parte será uma modificação praticamente toda mecânica de uma API para outra. Onde haverá mais complicações será em rotas com _constraints_. Um passo **muito importante** é obrigatoriamente fazer pelo menos um [Routing Spec](https://github.com/rspec/rspec-rails#routing-specs) que cobre suas rotas atuais. Seja cuidadoso, cubra todas as rotas e só depois que tiver essa cobertura comece mudar para a nova API.

* ActiveRecord - esta foi outra parte que mudou muito: as APIs que abstraem o banco de dados. Novamente, a sintaxe antiga continuará funcionando, mas é outra parte que você precisará dedicar muito tempo para entender cada nuance. A regra é a mesma: se seu código seguia as convenções haverá poucos pontos onde a mudança será difícil. Estude todo material sobre [ActiveRelation](http://www.railsdispatch.com/posts/activerelation) que puder.

* Rails RJS - se sua aplicação foi feita com muito Ajax e usando as antigas helpers RJS em vez de usar Javascript não-obtrusivo, certamente essa pode ser a parte onde você terá mais trabalho para migrar. Eu já escrevi um [artigo sobre isso 3 anos atrás](http://www.akitaonrails.com/2010/05/10/rails-3-introducao-a-javascript-nao-obstrusivo-e-responders). Para começar helpers como <tt>link_to_remote</tt> não funcionam mais. Para facilitar a migração neste ponto você ainda pode carregar as seguinte gems antigas no Gemfile:

```ruby
# gem 'jquery'
gem 'prototype'
gem 'prototype-ujs'
gem 'prototype_legacy_helper', :git => 'git://github.com/rails/prototype_legacy_helper.git'
```

Isso vai fazer tudo funcionar como era antes. Mas não se engane, se sua aplicação tiver um volume grande de RJS você terá realmente que reescrever praticamente metade da sua aplicação na parte mais visível para o usuário: as telas. Vale a pena gastar um tempo avaliando esse aspecto.

No geral, o procedimento é o mesmo: crie specs para a parte do código que usa a API 2.3 **ANTES** de migrar o código para a API 3.0. Não faça todas as specs do projeto todo de uma vez só: como eu disse antes, faça um passo de cada vez. Faça uma spec, mude a API, repita o ciclo. Passo a passo será muito mais rápido e o risco será muito menor.

A mudança do Rails 2.3 para 3.0, do ponto de vista técnico, não é complicado. Seu maior trabalho num primeiro momento será começar a entender a nova arquitetura, entender o Bundler, ver se a maioria das dependências externas ainda funcionam. Em particular vasculhe cuidadosamente seu diretório <tt>vendor/plugins</tt>, faça o possível para retirar **TODOS** os plugins e encontrar suas versões em Rubygems para acrescentá-las na <tt>Gemfile</tt>.

Substitua um plugin de cada vez: ache a gem, declare no <tt>Gemfile</tt>, rode o comando <tt>bundle</tt> para ver se nada quebra na instalação, execute a aplicação, veja se o comportamento ainda é o mesmo, e repita. Novamente, adivinhe onde dará problemas? Adivinhou: se alguém alterou o código do plugin depois de adicionar no projeto e você não sabe disso. 

![Upgrading plugins](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/363/Screen_Shot_2013-05-13_at_4.35.18_PM.png)

Uma forma de garantir que o plugin não foi "estuprado" indevidamente: ache o Github do projeto, faça um clone na sua máquina (de preferência dando checkout num commit da época em que o plugin foi instalado no seu projeto). Agora pegue o código do plugin que está no seu projeto e copie os arquivos por cima do clone. Agora use o comando <tt>git status</tt>, <tt>git diff</tt> para ver onde eles diferem.

Na época o pessoal do Peepcode lançou um [eBook e screencast](http://peepcode.com/blog/2010/live-coding-rails-3-upgrade) que ainda vale a pena dar uma olhada.

## Rails 3.0 para 3.1

A imagem a seguir resume esta etapa:

![Asset Pipeline](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/364/Screen_Shot_2013-05-13_at_4.37.53_PM.png)

Relembrando, antigamente todos os seus assets ficavam no diretório <tt>/public</tt>. Era caos. Agora fica tudo em <tt>/app/assets</tt> e passa pelo **Asset Pipeline** que foi inaugurado no Rails 3.1. E até você aprender as nuances desta funcionalidade você irá odiá-la. Confiem em mim: depois da primeira dor (que vocês vão passar), será bem mais fácil.

Lembram o que eu disse sobre RJS na seção anterior? Agora é a hora de começar a trocar os helpers antigos pelos novos. Na prática não é muito complicado, por exemplo:

```ruby
# Rails 2.3
link_to_remote "Delete this post", :update => "posts",
    :url => { :action => "destroy", :id => post.id }

# Rails 3.x
link_to "Delete this post", post_path(post), :method => :destroy, :remote => true
```

Leiam com muito cuidado meu tutorial sobre como usar Asset Pipeline, [Parte 1](http://www.akitaonrails.com/2012/07/01/asset-pipeline-para-iniciantes) e [Parte 2](http://www.akitaonrails.com/2012/07/01/asset-pipeline-para-iniciantes-parte-2). Assumindo que você já leu, praticou e entendeu o básico, os passos são "simples" embora sejam manualmente trabalhosos e exijam atenção e concentração para não se perder:

* mova tudo da pasta <tt>/public</tt> para as respectivas pastas em <tt>/app/assets</tt>;
* crie os arquivos <tt>/app/assets/javascripts/application.js</tt> e <tt>/app/assets/javascripts/application.css</tt> para declarar as dependências - retire tudo que você carregava individualmente no <tt>/app/views/layouts/application.html.erb</tt>;
* garanta que seu <tt>Gemfile</tt> tem as bibliotecas <tt>jquery-rails</tt>. Se por acaso você usava Prototype para mais do que o Ajax padrão do Rails antigo, vai precisar do <tt>protototype-rails</tt>, e nesse caso seu <tt>application.js</tt> deverá ter:

```javascript
//= require prototype
//= require prototype_ujs
//= require effects
//= require dragdrop
//= require controls
//= require menu
```

* agora modifique toda URL que não é gerada por helpers e que tem caminhos como <tt>/images</tt> para <tt>/assets</tt>;
* para facilitar renomeie todos os stylesheets para serem <tt>.css.scss</tt> e agora substitua toda URL para assets como <tt>url("../images/glyphicons.png")</tt> para <tt>image-url("glyphicons.png")</tt> e o SASS fará o resto por você;
* os helpers de ActionView que são blocos precisam explicitamente ter "=" no ERB, troque em todas as views. Ou seja:

```html
<!-- Rails 2.3 -->
<% form_for :contato do |f| %>
...
<!-- Rails 3.x -->
<%= form_for :contato do |f| %>
```

Existem muito mais passos, por isso a recomendação é realmente entender os princípios por atrás do Asset Pipeline. No meu caso ainda tive que retirar do código antigo uma coisa que poderia ser chamado de "primeira tentativa de um Asset Pipeline" que foi o Bundle-fu. No final minha sequência ficou assim:

![Upgrade Asset Pipeline](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/365/Screen_Shot_2013-05-13_at_4.49.15_PM.png)

A boa notícia é que esta será possivelmente a parte mais dolorida da migração, se conseguir passar por esta etapa as próximas tendem a doer menos. E eu digo que vai doer porque tudo que mexe no front-end dói muito pois estamos mexendo em javascript, em helpers, em tudo que pode quebrar drasticamente a usabilidade da sua aplicação. Se não tiver testes automatizados como com Selenium, recomendo colocar uma pessoa responsável por realizar o Q&A (Quality Assurance) da aplicação antes de colocar em produção.

Além disso algumas das gems que você ainda pôde manter até agora precisam ir embora, especialmente se você investigar o repositório no Github e ver que elas não tem atualizações há alguns meses. Eis um exemplo que você talvez tenha:

![Restful Authentication](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/366/Screen_Shot_2013-05-13_at_5.05.02_PM.png)

Isso vai dar um pouco de trabalho, felizmente mudar para Devise não é complicado (embora trabalhoso, mas neste ponto você já deve estar acostumado) só que em particular esta gem não é compatível com Rails 3.1 então precisa ser atualizada já que o projeto original ficou parado. E lembre-se que existem diversas [alternativas de autenticação](https://www.ruby-toolbox.com/categories/rails_authentication). Devise é um dos mais conhecidos mas não é a única opção e dependendo da sua aplicação talvez nem seja a melhor, por isso pelo menos dê uma lida na página dos 5 mais usados.

No seu <tt>Gemfile</tt> você vai precisar das seguintes gems:

```ruby
gem 'devise'
gem 'devise-encryptable'
```

Leia a [documentação do Devise](https://github.com/plataformatec/devise/wiki/How-To:-Migrate-from-restful_authentication-to-Devise) mas além das gems, transportar as views, os mailers, nos controllers você vai trocar as rotas e a API antiga pela nova:

```ruby
# Restful Authentication
before_filter :login_required
# Devise
before_filter :authenticate_user!

# Restful Authentication
before_filter :login_required
# Devise
before_filter :authenticate_user!

# Restful Authentication
if logged_in?
# Devise
if signed_in?

# Restful Authentication
redirect_back_or_default("/")
# Devise
redirect_to root_url

# Restful Authentication
include Authentication
include Authentication::ByPassword
include Authentication::ByCookieToken
# Devise
devise :database_authenticatable, :registerable,
       :recoverable, :rememberable, :confirmable, :validatable, 
       :encryptable, :encryptor => :restful_authentication_sha1
```

Esses são alguns exemplos. A vantagem nessa migração é que o Devise é compatível com o esquema de SHA1 que o Restful Authentication usava e por isso você não vai precisar mudar a senha dos seus usuários. Tecnicamente tudo deve funcionar sem problemas. O que vai mudar são as rotas antigas.

# Rails 3.1 para 3.2

Agora é a hora e realizar o que era opcional na migração técnica para 3.0. Mudar as APIs de mailers, routes e, principalmente, focar na [Query Interface do ActiveRelation](http://m.onkey.org/active-record-query-interface). Aproveite para ver esta [lista dos 10 métodos menos conhecidos, e menos usados, do ActiveRecord::Relation](http://blog.mitchcrowe.com/blog/2012/04/14/10-most-underused-activerecord-relation-methods/).

Se você fez passo a passo, como disse antes, neste ponto o projeto já deve estar bem mais organizado, com gems mais novas, com mais specs cobrindo o que você foi mudando.

Um teste que você pode fazer é trocar para Ruby 1.9.3, executar <tt>bundle</tt> e rodar as specs que criou até agora. Teoricamente, se isso passar você deve estar muito próximo de poder retirar o Ruby 1.8.7. Quando uma gem velha dá problema ou se seu código possui algum trecho incompatível o comando <tt>rake spec</tt> ou mesmo <tt>rails s</tt> para subir o servidor vai falhar imediatamente por erros de sintaxe. Já é um bom sinal se minimamente executar. Caso contrário **LEIA AS MENSAGENS DE ERRO**, elas dizem claramente o que está dando errado.

> Cansei de receber emails e mensagens me perguntando porque alguma coisa estava dando errado. Bastava copiar a mensagem de erro no Google e a resposta sempre aparece. Aprenda: o erro que você está tendo dificilmente é inédito e já existem soluções documentadas. Se você não encontrou a possibilidade mais óbvia é que você não soube procurar direito. Portanto procure antes de perguntar, não tenha preguiça.

Neste ponto você deve estar ainda corrigindo bugs relacionados à migração técnica. Não se preocupe: até você cobrir o aplicativo todo com specs, vai continuar recebendo reclamações de coisas que funcionavam antes e pararam de funcionar. Mas se foi esperto, a cada passo dado até aqui você foi adicionando specs.

Sobre o Rails 3.2 fica uma dica: neste momento (Maio de 2013) use o Rails versão **3.2.12** ou acima da 3.2.13 mas não use a 3.2.13. O post já está longo mas fica o link para entender os [problemas que essa versão causou](http://blog.bugsnag.com/2013/03/20/rails-3-2-13-performance-regressions-major-bugs/).

Se você fez a migração como recomendado para a versão 3.1 agora com a 3.2 terá um bônus. Adicione o seguinte na sua <tt>Gemfile</tt>, no grupo <tt>:assets</tt>:

```ruby
gem 'turbo-sprockets-rails3'
```

Isso vai acelerar muito a pré-compilação dos seus assets (coisa que provavelmente já estava te deixando irritado até agora).

Na versão 3.2 você tem a opção de tornar [Mass Assignment](http://guides.rubyonrails.org/security.html#mass-assignment) mais rígido adicionando o seguinte em todos os arquivos de ambiente em <tt>/config/environments/</tt>:

```ruby
# Raise exception on mass assignment protection for Active Record models
config.active_record.mass_assignment_sanitizer = :strict
```

E apesar de ter sido opcional até agora, você **DEVE** ligar essa restrição e tratar de adicionar <tt>attr_accessible</tt> em todos os seus models. Coloque na lista apenas os campos que efetivamente precisam ser populados via hash no construtor da classe. Caso contrário mantenha escondida. Esse é um erro de segurança muito comum que deve ser consertado o quanto antes.

Se segurança nunca foi sua preocupação, este é o melhor momento para considerar isso. Durante a vida da série 3.2 diversos bugs de segurança foram expostos. Leia o [Guia Oficial de Segurança](http://guides.rubyonrails.org/security.html). Conheça a gem [Brakeman](http://brakemanscanner.org/), conhecido como o Rails Security Scanner, para avaliar seu código por buracos conhecidos de segurança. Lembre-se: se são buracos conhecidos e você não se preocupou com isso, alguém vai eventualmente entrar no seu sistema. Depois disso não importa mais o que fizer, segurança é uma coisa que uma vez estourada não se recupera se forma trivial.

## Para o Futuro: Ruby 2.0 e Rails 4

Se você seguiu até aqui, trocar para Ruby 2.0 não deve ser um problema. Existem várias novas funcionalidades nele que você não precisa implementar agora. Ele é "quase" um drop-in replacement para o Ruby 1.9.3 então não deve dar dores de cabeça. Existem dezenas de artigos na internet sobre Ruby 2.0 mas para uma introdução segue os slides de uma palestra que dei a respeito:

<div class="embed-container">
<iframe src="http://www.slideshare.net/slideshow/embed_code/18406459?rel=0" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC;border-width:1px 1px 0;margin-bottom:5px" allowfullscreen webkitallowfullscreen mozallowfullscreen> </iframe>
</div>

<div style="margin-bottom:5px"> <strong> <a href="http://www.slideshare.net/akitaonrails/o-que-tem-de-novo-no-ruby-20" title="O que tem de novo no Ruby 2.0?" target="_blank">O que tem de novo no Ruby 2.0?</a> </strong> from <strong><a href="http://www.slideshare.net/akitaonrails" target="_blank">Fabio Akita</a></strong> </div>

Já o Rails 4 ainda não é versão final, está em [Release Candidate 1](http://weblog.rubyonrails.org/2013/5/1/Rails-4-0-release-candidate-1/) e isso ainda vai dar dores de cabeça num futuro próximo até que todas as principais gems do ecossistema se atualizem. Muitas já foram como o [Devise](http://blog.plataformatec.com.br/2013/05/devise-and-rails-4/). Ano passado palestrei em Israel sobre o Rails 4, eis os slides:

<div class="embed-container">
<iframe src="http://www.slideshare.net/slideshow/embed_code/14797832?rel=0" frameborder="0" marginwidth="0" marginheight="0" scrolling="no" style="border:1px solid #CCC;border-width:1px 1px 0;margin-bottom:5px" allowfullscreen webkitallowfullscreen mozallowfullscreen> </iframe>
</div>

<div style="margin-bottom:5px"> <strong> <a href="http://www.slideshare.net/akitaonrails/whats-new-in-rails-4" title="What&#39;s new in Rails 4" target="_blank">What&#39;s new in Rails 4</a> </strong> from <strong><a href="http://www.slideshare.net/akitaonrails" target="_blank">Fabio Akita</a></strong> </div>

Agora no Rails 4 preparem-se para o seguinte: tudo aquilo que você veio trazendo do Rails 2.3 porque ainda era compativel se tornará incompatível no Rails 4. Um exemplo são as APIs de rotas ou o ActiveRelation. Nem pense em instalar a nova versão até ter migrado tudo para as APIs novas. Veja as mensagens de "deprecation" que vão aparecer no Rails 3.2 e migre aos poucos.

Meu conselho é simples: se você está perguntando a alguém _"Posso usar Rails 4?"_ então significa que você não deve usar. Mantenha-se no Rails 3.2 com tudo atualizado, adicione mais specs para cobrir a maior parte da sua aplicação. A chave para uma migração tranquila é ter uma boa suíte de specs prontas. Se fizer isso o processo tende a ser razoavelmente indolor, muito menos do que o que resumi neste artigo.
