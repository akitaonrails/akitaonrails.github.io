---
title: "[Heroku Tips] Enciclopédia do Heroku"
date: '2012-04-20T15:37:00-03:00'
slug: heroku-tips-enciclopedia-do-heroku
tags:
- learning
- beginner
- rails
- heroku
draft: false
---

 **Atualização Jul/2016:** Sobre uploads e S3, leia meu post mais recente [Updating my Old Posts on Uploads](http://www.akitaonrails.com/2016/07/28/updating-my-old-posts-on-uploads)

**Atualização 11/9:** Fiz alguns ajustes (troquei Unicorn por Passenger) e também escrevi [outro post com mais dicas](http://www.akitaonrails.com/2013/09/11/heroku-tips-problemas-iniciais-com-rails-4-no-heroku#.UjDR-WRgZ3Y).

**Atualização 05/06:** Depois que escrevi este artigo, encontrei um outro muito bom que recomendo a leitura por ter mais detalhes para complementar. O artigo se chama [Heroku isn’t for Idiots](http://rdegges.com/heroku-isnt-for-idiots)

Se você quer lançar uma aplicação Rails rapidamente, não existe melhor solução do que o Heroku. Para quem não conhece, o Heroku é um Paas (Platform as a Service) que roda sobre o Amazon EC2 (que é um IaaS ou Infrastructure as a Service). O Heroku automatiza a criação de uma nova máquina virtual (volátil! isso é importante) e configura todo o ambiente para rodar Ruby.

O Heroku usa uma unidade de máquina virtual chamada “Dyno”, a grosso modo, considere um Dyno como uma máquina virtual “pequena” com 4 cores e até 512Mb de RAM sem swap file e sem suporte a persistência de arquivos (não faça uploads diretamente no diretório <tt>public/uploads</tt> ou algo assim, sempre configure para mandar para a Amazon S3, aprenda como [neste tutorial](https://devcenter.heroku.com/articles/s3)). Configurar um novo ambiente é simples, o próprio Heroku tem uma [boa documentação](https://devcenter.heroku.com/articles/rails3) ensinando como e recomendo ler antes de continuar.

Subir uma única dyno usando um banco de dados compartilhado PostgreSQL é de graça, o que é excelente para testar sua aplicação. Obviamente apenas um único dyno é pouco para qualquer aplicação séria lançada em produção para o público.

O Heroku fornece “stacks” padrão que é o perfil pré-configurado de um dyno para uma determinada plataforma. Para Ruby e Rails a mais atual (na data de publicação deste post) é a [Celadon Cedar](https://devcenter.heroku.com/articles/cedar), a anterior era a [Badious Bamboo](https://devcenter.heroku.com/articles/bamboo) portanto se encontrar um tutorial qualquer de Heroku por aí, cheque sobre qual stack estamos falando, só use se for para Cedar.


## Concorrência num Dyno

A primeira coisa que me chamou a atenção é que a configuração recomendada é executar uma aplicação Ruby usando o servidor [Thin](http://code.macournoyer.com/thin/). Pense no Thin como uma evolução do venerado Mongrel mas que suporta executar Eventmachine internamente. Na prática é um Mongrel melhorado, o que significa que cada Dyno, por padrão, não suporta mais do que 1 única execução concorrente (não confundir com “requisições por segundo”!! Muita gente erra isso. Um único processo com uma única execução concorrente pode executar várias requisições por segundo, basta cada requisição demorar menos de 1 segundo).

Executar múltiplos Thins poderia ser possível mas se queremos mais processos rodando simultaneamente para responder mais requisições ao mesmo tempo, a melhor opção é usar [Phusion Passenger](https://www.phusionpassenger.com/). Leiam a documentação para aprender as peculiaridades do Passenger, na prática pense nele como um controlador de processos Ruby. O melhor tutorial para usar Passenger no Heroku é da própria [Phusion](https://github.com/phusion/passenger-ruby-heroku-demo). Não vou repetir tudo que ele disse, mas as partes importantes são:

Substituir a gem <tt>thin</tt> pela <tt>passenger</tt> na sua Gemfile:

* * *
ruby

group :production, :staging do  
 gem ‘passenger’  
 …  
end  
-

O ideal é entre 3 e 4 processos, dependendo se sua dyno for a padrão [1X ou 2X](https://blog.heroku.com/archives/2013/4/5/2x-dynos-beta). A informação não-oficial que eu tenho é que cada dyno tem até 4 CPUs, o que justifica esse número de processos. Mais do que isso, chequem sempre quanto de memória cada processo consome (ferramentas como [NewRelic](http://newrelic.com/) ajudam nisso) pois a somatória precisa ser menor que 512Mb ou você terá problemas.

Finalmente, a stack Cedar permite configurar perfis de dynos num arquivo chamado <tt>Procfile</tt> que fica na raíz do seu projeto. Para que a dyno levante com Unicorn coloque o seguinte:

* * *
ruby

web: bundle exec passenger start p $PORT —max-pool-size 3  
--

Seu projeto precisa obrigatoriamente estar em Git pois isso vai criar um repositório remoto chamado ‘heroku’ no seu arquivo <tt>.git/config</tt>:

* * *

[core]  
 repositoryformatversion = 0  
 filemode = true  
 bare = false  
 logallrefupdates = true  
 ignorecase = true  
[remote “origin”]  
 fetch = +refs/heads/ **:refs/remotes/origin/**  
 url = git@github.com:Codeminer42/test.git  
[branch “master”]  
 remote = origin  
 merge = refs/heads/master  
[remote “heroku”]  
 url = git@heroku.com:test.git  
 fetch = +refs/heads/ **:refs/remotes/heroku/**  
-

Desta forma você faz o normal <tt>git push origin master</tt> para continuar subindo código para seu repositório de desenvolvimento e faz <tt>git push heroku master</tt> para realizar o deployment no Heroku. Isso reinicia sua Dyno, faz ela atualizar gems com <tt>bundle install</tt> executa a rake <tt>assets:precompile</tt>, caso esteja usando Rails 3.1 ou superior. Enfim, tudo que precisa para sua aplicação iniciar limpa.

## Rodando com Ruby 1.9.3 ou Ruby 2.0.0

Outra peculiaridade da [stack Cedar](https://devcenter.heroku.com/articles/cedar) é que por padrão ele instala Ruby 1.9.2. Muitos novos projetos já usam 1.9.3 e é realmente a melhor versão para utilizar hoje (embora o 2.0.0 para projetos novos já é recomendado e estável o suficiente pra usar em produção). Na prática, ele inicia mais rápido que o 1.9.2, consome muito menos memória e executa mais rápido no geral.

Para escolher basta adicionar a seguinte linha no arquivo Gemfile do seu projeto:

* * *

ruby “1.9.3”  
-

Obviamente, garanta que seu projeto em desenvolvimento e produção estão rodando com as mesmas versões!

## Delegando suas tarefas pesadas para Resque (ou Sidekiq)

Não vou chover no molhado explicando porque coisas como gerar relatórios pesados, enviar emails, consumir APIs externas e outras coisas devem ser separadas em tarefas para rodar em background numa fila. A fila mais simples atualmente para usar num ambiente Rails é o Resque, que utiliza banco de dados NoSQL Redis para organizar as filas.

Como você precisa necessariamente de uma instância de Redis no Heroku, execute o seguinte a partir da raíz do seu projeto:

* * *

heroku addons:add redistogo  
-

Pesquise na página de add-ons do Heroku sobre outras opções e planos para entender quanto o pacote padrão de Redis suporta. Importante além de capacidade (que não precisa ser muito), é a quantidade de conexões simultâneas que é a quantidade de processos Ruby web e processos Ruby Resque Workers que você tem ao mesmo tempo.

Agora, adicione as gems que você precisa no arquivo <tt>Gemfile</tt>:

* * *
ruby
1. mínimo:  
gem ‘resque’, :require =\> ‘resque/server’

1. alguns opcionais  
gem ‘resque-scheduler’, :require =\> ‘resque\_scheduler’  
gem ‘resque-lock’  
gem ‘resque\_mailer’  
-

Rode o Bundler para atualizar, depois vamos configurar as seguinte tasks Rake num arquivo <tt>lib/tasks/resque.rake</tt>:

* * *
ruby

require ‘resque/tasks’  
require ‘resque\_scheduler/tasks’ # opcional se utilizar resque\_scheduler

task “resque:setup” =\> :environment do  
ENV[‘QUEUE’] = ‘\*’ if ENV[‘QUEUE’].blank?

require ‘resque’ require ‘resque\_scheduler’ require ‘resque/scheduler’ Resque.redis = ENV[“REDISTOGO\_URL”] Resque.schedule = YAML.load\_file(‘config/scheduler.yml’) # opcional se utilizar resque\_scheduler Resque::Worker.all.each {|w| w.unregister\_worker}
1. Fix for handling resque jobs on Heroku cedar
2. http://stackoverflow.com/questions/2611747/rails-resque-workers-fail-with-pgerror-server-closed-the-connection-unexpectedly  
 Resque.after\_fork do |job|  
 ActiveRecord::Base.establish\_connection  
 end  
end

desc “EC2 instance name changes every time, so run this before a new deployment”  
task “resque:clean\_workers” =\> :environment do  
 Resque::Worker.all.each {|w| w.unregister\_worker}  
end  
-

O Resque sobe workers realizando fork, cada worker se inicia subindo seu próprio ambiente Rails, incluindo coisas como se conectar com o banco de dados. Mas ao fazer fork, essas conexões precisam ser refeitas, por isso existe o bloco <tt>Resque.after_fork</tt>. Atenção a todo sistema que realiza forks (Passenger é um exemplo).

A gem [resque-heroku](https://github.com/simple10/resque-heroku) faz a mesma coisa, mas no caso como no exemplo onde estou configurando muitas outras coisas, não é necessário adicionar essa gem só por causa dessas 3 linhas.

Agora, nos arquivos <tt>config/environments/development.rb</tt>, <tt>config/environments/test.rb</tt> e outras que não são a de produção para o Heroku, adicione no início do arquivo:

* * *
ruby

ENV[“REDISTOGO\_URL”] = ‘redis://localhost:6379’  
TestApp::Application.configure do  
…  
-

Também crie um arquivo <tt>config/initializers/resque.rb</tt> com:

* * *
ruby

Resque.redis = ENV[“REDISTOGO\_URL”]  
-

Se você sabe usar Resque, certamente tem um Redis instalado localmente na sua máquina de desenvolvimento e essa é a URL padrão. Modifique se precisar.

Finalmente, adicione novas linhas ao arquivo <tt>Procfile</tt>:

* * *

web: bundle exec unicorn p $PORT -c ./config/unicorn.rb  
scheduler: bundle exec rake resque:scheduler  
worker: bundle exec rake resque:workers QUEUE=\* COUNT=2  
--

Estes são exemplos onde estou utilizando a gem [resque-scheduler](https://github.com/bvandenbos/resque-scheduler). Se você precisa de uma funcionalidade semelhante a um “crontab”, esta gem serve para isso. Mas está fora do escopo deste artigo falar sobre ela, então simplesmente ignorem quando menciono o scheduler se não precisar dela.

Novamente, quero aproveitar o máximo cada dyno. O arquivo Procfile determina o que cada perfil de dyno vai fazer. No meu exemplo, as dynos chamadas “web” sobem com 4 processos Unicorn como mostrei anteriormente. A chamada “scheduler” se responsabiliza só pelo processo de criar tarefas no Resque. E finalmente as “worker” sobem processos _trabalhadores_ que ficam “ouvindo” as filas do Resque no Redis e executam as tarefas que aparecem lá. No caso dá para subir um único worker por dyno se usar a task rake <tt>resque:worker</tt> ou múltiplos usando a <tt>resque:workers</tt> como está no exemplo. Novamente suas limitações são: a quantidade de memória consumida por worker e o “peso” de execução de cada tarefa. Se as tarefas forem muito pesadas, melhor ter poucos worker por dyno.

Outra dica importante: especialmente se estiver utilizando o scheduler, que vai adicionando novas tarefas baseado num intervalo de tempo. Imagine uma tarefa que leva 1 minuto para ser executada e que o scheduler recoloca no Redis a cada 2 minutos. Se você tiver múltiplos workers em paralelo, somente um deles vai executar e tudo funciona.

Mas imagine se por qualquer razão a tarefa levar 5 minutos. Significa que nesse tempo o scheduler terá colocado pelo menos 2 tarefas iguais no Redis e haverá dois workers executando a mesma tarefa em paralelo! Você corre o risco de duplicar dados, ou qualquer outro efeito colateral de ter a mesma tarefa executando encavalado ao mesmo tempo.

Para isso serve a gem [resque-lock](https://github.com/defunkt/resque-lock) que declarei como opcional acima. Somente se existir tarefas que não podem ser executadas em paralelo e você tem a possibilidade disso acontecer. Normalmente você terá classes Ruby no PATH, por exemplo, em <tt>app/resque/example.rb</tt>:

* * *
ruby

require ‘resque/plugins/lock’

class Example  
 extend Resque::Plugins::Lock

def self.perform(repo\_id)
1. heavy\_lifting  
 end  
end  
-

É só o que você precisa fazer para garantir que esta tarefa não terá o perigo de ser executada em paralelo por acidente. Cuidado: nem toda tarefa em paralelo é ruim, por isso avalie cada situação. Agora, precisamos iniciar os dynos, para isso faça:

* * *

heroku scale web=4 scheduler=1 worker=2  
-

Neste exemplo, estou subindo 4 dynos perfil “web”, o que significa capacidade para receber até 16 requisições _simultaneamente_ (neste exemplo, se cada requisição leva em média 100ms para responder, esse número de dynos pode responder até 160 requisições simultaneamente, o que é bastante). Em seguida estou subindo uma única instância do controlador de scheduler (novamente, se você não precisa, ignore). E finalmente subindo 2 dynos perfil “worker”, cada um com 2 workers Resque, totalizando 4 trabalhadores escutando a fila do Redis e podendo executar até 4 tarefas em paralelo. Para o Redis, significa que precisamos ter no mínimo capacidade para receber 16 + 1 + 4 = 21 conexões simultâneas. A mesma quantidade de conexões no banco de dados PostgreSQL (lembre-se sempre disso!)

## Assets na Amazon S3

A [própria documentação do Heroku](https://devcenter.heroku.com/s3) explica como você faz seus assets serem servidos por CDNs como CloudFront ou Amazon. Leia atentamente para ter mais detalhes, aqui vou resumir algumas coisas importantes.

Primeiro, obviamente, crie sua conta na [Amazon Web Services](http://aws.amazon.com/), coloque seu cartão de crédito e tenha acesso ao [Dashboard](https://console.aws.amazon.com/console/home) que permite controlar os diversos serviços que quer usar. No caso abra o S3 e configure “Buckets” que é como se fossem “diretórios” para seus assets.

Se quiser, pode criá-los diretamente usando as APIs da Amazon, diretamente num console Ruby como IRB ou Pry, assim:

* * *
ruby

require ‘aws/s3’  
AWS::S3::Base.establish\_connection!(  
 :access\_key\_id =\> ‘…’,  
 :secret\_access\_key =\> ‘…’  
)  
AWS::S3::Bucket.create(‘uploads.mysite’, :access =\> :public\_read)  
AWS::S3::Bucket.create(‘assets.mysite’, :access =\> :public\_read)  
AWS::S3::Bucket.create(‘staging.assets.mysite’, :access =\> :public\_read)  
-

Obviamente, instale primeiro a gem <tt>aws-s3</tt>. E claro, estou criando 3 buckets de exemplo, crie com quaisquer nomes (únicos, [válidos e compatíveis com formato de DNS](http://support.rightscale.com/06-FAQs/FAQ_0094_-_What_are_valid_S3_bucket_names%3F)).

Quando você cria sua conta, também ganha um **Access Key ID** e um **Secret Access Key** que sempre usará para ter permissões nos seus buckets. Mas só isso não basta, você precisa – a partir do Dashboard via web – configurar **policies** para seus buckets. Aprenda como a partir [deste artigo](http://s3browser.com/working-with-amazon-s3-bucket-policies.php#amazon-s3-bucket-policies).

Uma policy tem mais ou menos este formato:

* * *

{  
 “Version”: “2008-10-17”,  
 “Statement”: [  
 {  
 “Sid”: “AllowPublicRead”,  
 “Effect”: “Allow”,  
 “Principal”: {  
 “AWS”: “\*”  
 },  
 “Action”: [  
 “s3:GetObject”  
 ],  
 “Resource”: [  
 “arn:aws:s3:::assets.mysite/\*”  
 ]  
 }  
 ]  
}  
-

Não mude a “Version” e coloque o nome correto da sua bucket em “Resource”. Isso vai garantir que quando qualquer assets gravado nessas buckets possam ser devidamente acessadas.

Isso foi só para configurar a Amazon. Agora você precisa configurar sua aplicação para que contenha os dados corretos.

* * *

1. para versões antigas da gem Heroku:  
heroku plugins:install https://github.com/heroku/heroku-labs.git  
heroku labs:enable user\_env\_compile -a mysite

1. obrigatório  
heroku config:add AWS\_ACCESS\_KEY\_ID=…  
heroku config:add AWS\_SECRET\_ACCESS\_KEY=…  
heroku config:add FOG\_DIRECTORY=assets.mysite  
heroku config:add FOG\_PROVIDER=AWS

1. opcional:  
heroku config:add FOG\_REGION=us-east-1  
heroku config:add ASSET\_SYNC\_GZIP\_COMPRESSION=true  
heroku config:add ASSET\_SYNC\_MANIFEST=false  
heroku config:add ASSET\_SYNC\_EXISTING\_REMOTE\_FILES=keep  
-

Não deve ser difícil entender essas configurações. Agora, precisamos configurar o arquivo <tt>config/production.rb</tt> com o seguinte:

* * *
ruby

config.action\_controller.asset\_host = “http://#{ENV[‘FOG\_DIRECTORY’]}.s3.amazonaws.com”  
-

Aprenda mais sobre o Asset Pipeline no mínimo lendo o [guia oficial](http://guides.rubyonrails.org/asset_pipeline.html). Não me interessa quem gosta ou não gosta do Asset Pipeline (ou que não gosta porque não sabe usar). Mas vou assumir que independente da opinião, todos aqui sabem usar. Por exemplo, sabem que não pode haver tags HTML com a URL da imagem escrita manualmente, mas sim usando helpers como <tt>image_tag</tt> e mesmo no CSS, estar utilizando [SASS](http://sass-lang.com/) para ter acesso a helpers como <tt>image-uri</tt>. Não deve existir URLs do aplicativo, apontando para imagens, stylesheets, javascripts ou qualquer coisa, escritas manualmente sem usar esses helpers. Isso é obrigatório porque em desenvolvimento na sua máquina, ele vai apontar para URLs relativas na sua instância, mas em produção ele vai apontar para URLs externas na Amazon S3.

A grande vantagem é justamente porque quando os navegadores dos seus usuários pedirem imagens, stylesheets, isso vai pro S3 e não vai consumir absolutamente nada nos seus dynos, deixando-os livres para executar exclusivamente tarefas dinâmicas.

Queremos que os assets gerados pelo Asset Pipeline sejam sincronizados nos seus buckets na Amazon S3. Começamos adicionando as seguintes gems no <tt>Gemfile</tt>:

* * *
ruby

group :assets do

1. obrigatório  
 gem ‘sass-rails’  
 gem ‘coffee-rails’  
 gem ‘uglifier’  
 gem ‘asset\_sync’

1. recomendado para Sass  
 gem ‘compass’  
 gem ‘compass-rails’  
end  
-

Lembrando que no Rails 4 não precisa do group “assets”. Continuando, precisamos criar um arquivo de configuração em <tt>config/initializers/asset_sync.rb</tt>:

* * *
ruby

if (Rails.env.production? || Rails.env.staging?) && defined?(AssetSync)  
 AssetSync.configure do |config|  
 config.fog\_provider = ENV[‘FOG\_PROVIDER’]  
 config.aws\_access\_key\_id = ENV[‘AWS\_ACCESS\_KEY\_ID’]  
 config.aws\_secret\_access\_key = ENV[‘AWS\_SECRET\_ACCESS\_KEY’]  
 config.fog\_directory = ENV[‘FOG\_DIRECTORY’]

1. Increase upload performance by configuring your region  
 config.fog\_region = ENV[‘FOG\_REGION’]  
 #
2. Don’t delete files from the store  
 config.existing\_remote\_files = ENV[‘ASSET\_SYNC\_EXISTING\_REMOTE\_FILES’]  
 #
3. Automatically replace files with their equivalent gzip compressed version  
 config.gzip\_compression = ENV[‘ASSET\_SYNC\_GZIP\_COMPRESSION’]  
 #
4. Use the Rails generated ‘manifest.yml’ file to produce the list of files to
5. upload instead of searching the assets directory.
6. config.manifest == ENV[‘ASSET\_SYNC\_MANIFEST’]  
 #
7. Fail silently. Useful for environments such as Heroku  
 config.fail\_silently = true  
 end  
end  
-

Entenda cada configuração e veja qual é a melhor para você, mas esta funciona o suficiente para mim. Não esqueça de configurar o arquivo principal <tt>config/application.rb</tt>:

* * *
ruby

config.assets.initialize\_on\_precompile = false # Rails 4 não precisa disso  
config.assets.precompile += %w(active\_admin.css cross\_browser.css active\_admin.js)  
config.assets.enabled = true

1. if you prefer `.sass` over `.scss`.  
config.sass.preferred\_syntax = :sass  
config.assets.initialize\_on\_precompile = false

1. Version of your assets, change this if you want to expire all your assets  
config.assets.version = ‘1.0’  
config.assets.logger = false  
-

Se você usar o Asset Pipeline direito declarando seus assets nos arquivos de manifesto <tt>app/uploads/stylesheets/application.css.sass</tt> e <tt>app/uploads/javascripts/application.js.erb</tt> tudo corre normalmente, mas arquivos fora desses manifestos que você vai precisar (minimize o uso disso) e declare em <tt>config.assets.precompile</tt>.

Agora, toda vez que a task <tt>assets:precompile</tt> for executada na sua máquina, ela vai se comportar como esperado gerando os arquivos estáticos na pasta local <tt>public/uploads</tt> mas quando for feito deploy com <tt>git push heroku master</tt>, a mesma task vai gerar os assets e realizar upload do que foi modificado no seu bucket na Amazon S3.

### Paperclip e upload de arquivos

Um adendo, é que não basta os assets estáticos da aplicação estarem no S3, também queremos que quaisquer uploads de usuários do site sejam mandados automaticamente para lá. Procurem as documentações oficiais das principais gems como Paperclip ou Carrierwave. Veja a [documentação oficial](https://devcenter.heroku.com/articles/s3#uploading_files_in_rails_with_paperclip) do Heroku sobre Paperclip para aprender mais.

No caso do Carrierwave (eu particular não tenho preferência por nenhum, ambos servem adequadamente para mim), uma classe de uploader seria assim:

* * *
ruby

class UserBackgroundImageUploader \< CarrierWave::Uploader::Base

1. Include RMagick or MiniMagick support:  
 include CarrierWave::RMagick

1. Choose what kind of storage to use for this uploader:  
 storage :fog

1. Override the directory where uploaded files will be stored.
2. This is a sensible default for uploaders that are meant to be mounted:  
 def store\_dir  
 “uploads/#{model.class.to\_s.underscore}/#{mounted\_as}/#{(model.id)}”  
 end  
end  
-

Depois meu model de exemplo <tt>User</tt> contém:

* * *
ruby

class User \< ActiveRecord::Base  
 …  
 mount\_uploader :background\_image, UserBackgroundImageUploader  
 …  
end  
-

E nas views procuro a URL da imagem assim:

* * *
ruby

@user.background\_image\_url  
-

Até aqui, absolutamente nada de novo. A novidade vem criando o arquivo <tt>config/initializer/carrierwave.rb</tt>:

* * *
ruby

CarrierWave.configure do |config|  
 config.fog\_credentials = {  
 :provider =\> ‘AWS’,  
 :aws\_access\_key\_id =\> ENV[‘AWS\_ACCESS\_KEY\_ID’],  
 :aws\_secret\_access\_key =\> ENV[‘AWS\_SECRET\_ACCESS\_KEY’],  
 }  
 config.fog\_directory = ‘uploads.mysite’  
end  
-

Isso utilizará a configuração que você já fez acima, mas mudamos o nome do bucket para não confundir buckets de ‘assets’ de buckets de ‘uploads dos usuários’. Por isso criamos múltiplos buckets de exemplo, lembra? Inclusive, se criar dynos para ambiente de homologação/staging, lembre-se de criar buckets separados e configurá-los corretamente dependendo do ambiente neste arquivo de configuração.

Só isso deve ser suficiente para todos os uploads serem realizados na sua conta do S3 e não mais consumir sua aplicação Rails no Heroku, mesmo porque o Heroku não permite gravar arquivos localmente nos dynos, pois quando eles forem reiniciados, tudo que não estiver no repositório Git (arquivos temporários, uploads), serão perdidos.

## New Relic

Um pequeno truque se por acaso estiver usando Unicorn em vez de Thin ou Passenger, da mesma forma como precisamos reconectar no banco em caso de fork no Resque, entenda que o serviço New Relic precisa de tratamento especial quando o Unicorn realiza um novo fork de processo Ruby.

Não vou re-explicar o que todo mundo já sabe sobre configurar NewRelic, a dica é apenas criar o seguinte arquivo em <tt>config/initializers/new_relic_unicorn.rb</tt>:

* * *
ruby

NewRelic::Agent.after\_fork(:force\_reconnect =\> true) if defined? Unicorn  
-

## Finalmentes

Para ambiente de testes, a versão grátis do Heroku é boa o suficiente, para produção não esqueça de subir múltiplos dynos (suba 3 ou 4 para começar, monitore e suba mais se precisar). Também faça upgrade dos seus serviços como Redis e PostgreSQL de acordo com o tamanho que precisar, por exemplo:

* * *

heroku addons:upgrade redistogo:medium  
heroku addons:add heroku-postgresql:fugu  
-

Quando você cria sua nova aplicação no Heroku, ele te dá um nome arbitrário que você mode mudar no dashboard web do Heroku e ele tem o formato <tt>mysite.herokuapp.com</tt>. No seu provedor de DNS (como Zerigo ou DNSimple) faça seu domínio (ex www.mysiteoficial.com) apontar para a URL ‘mysite.herokuapp.com’ (não há IPs fixos porque o EC2 não é feito para funcionar assim). Daí você pode configurar sua aplicação no Heroku para responder ao novo domínio assim:

* * *

heroku addons:add custom\_domains  
heroku domains:add mysiteoficial.com  
heroku domains:add mysiteoficial.com.br  
heroku domains:add www.mysiteoficial.com  
heroku domains:add www.mysiteoficial.com.br  
-

Registre a maior quantidade de domínios possíveis (dentro e fora do Brasil), nunca esqueça dos subdomínios. Se errar e precisar apagar:

* * *

heroku domains:clear # to stop responding to domains  
-

O Heroku é extremamente eficiente para ambientes onde você ainda não tem como ter um administrador de sistemas sênior (caro e raridade no mercado) e uma equipe 24×7. Você pode começar pequeno e depois criar sua própria infraestrutura customizada em máquinas diretamente na Amazon EC2, Rackspace Cloud ou outro provedor de Cloud Servers. E sua aplicação, diferente de se fosse num Google App Engine, não precisa ser codificada de forma proprietária. A aplicação Rails continua executando normalmente, e sem grandes mudanças além das que você viu neste post, em qualquer outro servidor devidamente configurado.

Uma configuração grande pra maioria dos sites brasileiros com 5 dynos web, 2 dynos workers, mais um PostgreSQL plano “Fugu”, e outros add-ons menores como Memcached, New Relic, etc vai lhe custar cerca de USD 700. Alguém pode dizer _“Nossa, que caro!”_ Claro que não. Só o salário de um bom sys admin vai ser pelo menos 4 ou 5 vezes isso por mês, e não estou contando nem o custo de infraestrutura. Portanto, é **barato**. A menos, claro, que seu negócio seja tão ruim que não valha no mínimo isso por mês e, nesse caso, melhor não perder tempo para construí-lo.

