---
title: "[Heroku Tips] Usando Followers do Heroku Postgresql"
date: '2014-11-10T19:51:00-02:00'
slug: heroku-tips-usando-followers-do-heroku-postgresql
tags:
- learning
- rails
- heroku
- postgresql
draft: false
---

Uma das grandes vantagens de usar o Heroku é poder rapidamente aumentar o tamanho dos dynos para aumentar a capacidade de requisições simultâneas que sua aplicação pode responder. Porém existe um grande problema: você só vai pode aumentar suas dynos até o limite de conexões do seu banco de dados.

Para isso veja direito os planos de [Postgresql](https://addons.heroku.com/heroku-postgresql). Para aplicações médias, você provavelmente vai querer algo do tamanho do plano Standard 2, com até 400 conexões simultâneas e 3.5Gb de RAM. Na teoria, você poderia tranquilamente subir mais de 400 instâncias de Ruby (web e worker), considerando o pool de conexões. Na prática isso não deve acontecer, e isso depende muito do perfil da sua aplicação. 

Especialmente considerando aplicações que precisam ou fazer queries muito complexas (relatórios, pré-cálculos que envolvam uma tabela inteira e vários joins) ou então uma aplicação onde escritas (inserts e updates) aconteçam em muito volume (uma aplicação como um Google Spreadsheet ou Twitter-like). Sempre acompanhe o dashboard do Heroku Postgresql para ver quais são os comandos mais lentos. Idealmente cada query deve estar na faixa das dezenas de milissegundos. Quando mais lenta for e quanto mais dados ele precisar carregar em memória, menos dessas você pode fazer concorrentemente no mesmo banco de dados.

Em particular, se você tem muitas tarefas pesadas, então já deveria estar usando workers de [Sidekiq](https://github.com/mperham/sidekiq/wiki/Deployment). Porém se lembre que esses workers estarão usando o mesmo banco que os dynos web também vão usar. Nesse caso se você rodar uma query estupidamente pesada num worker, a experiência do usuário na web vai ser prejudicada.

Uma solução para isso é usar o recurso de [followers](https://devcenter.heroku.com/articles/heroku-postgres-follower-databases) que já está bem documentado. Quando você cria uma instância de Heroku Postgresql ele vai criar duas variáveis de ambiente baseado numa cor, por exemplo, HEROKU_POSTGRESQL_RED_URL e DATABASE_URL apontando pro endereço da máquina do Postgresql na Amazon AWS EC2.

Um follower é um banco slave do Postgresql, cujo endereço vai ser apontado numa outra variável de ambiente como, por exemplo, HEROKU_POSTGRESQL_AMBER_URL (digite o comando <tt>heroku config</tt> para ver essas variáveis). Um follower sempre vai estar pelo menos alguns milissegundos atrasado em relação ao banco master. Você sempre precisa se lembrar que nunca deve depender de um dado lido de um follower logo depois de ter feito o comando de Insert/Update.

No conceito básico, toda escrita deve ser feita somente no banco master (e ela sempre será gargalo de escrita, caso você tenha volumes muito estúpidos de escrita - e nesse caso vai ter que cair em outras opções que não é escopo deste post). E as leituras podem ser divididas em múltiplos slaves/followers ("slave" se você for old-school, "follower" se você for politicamente correto).

Porém uma aplicação Rails normal só sabe do banco que está apontado na variável DATABASE_URL, então como fazer para dividir as leituras no follower? Para isso existe a gem [Octopus](https://github.com/tchandy/octopus), criada pelo Thiago Pradi e [bem documentada](https://devcenter.heroku.com/articles/distributing-reads-to-followers-with-octopus) pelo próprio Heroku. Resumindo o que já está documentado, comece adicionando a gem no <tt>Gemfile</tt>:

--- ruby
gem 'ar-octopus', require: 'octopus'
```

Rode o <tt>bundle install</tt> e agora baixe os seguintes arquivos:

```
curl -L -o config/shards.yml https://gist.github.com/catsby/6923840/raw/0aaf94ccc383951118c43b9b794fc62e427c2e51/shards.yml
curl -L -o config/initializers/octopus.rb https://gist.github.com/catsby/6923632/raw/87b5abba2e22c3acf8ed35d06e0ab9ca1bd9f0d0/octopus.rb
```

Com isso feito, em desenvolvimento o master e o follower vão ser o seu banco normal de desenvolvimento. Em produção no Heroku ele vai usar os bancos HEROKU_POSTGRESQL_*_URL que não são o DATABASE_URL como followers.

Abra o arquivo <tt>config/initializers/octopus.rb</tt> e adicione o seguinte método:

--- ruby
module Octopus
  ...
  def self.random_follower
    followers.sample.to_sym
  end
  ...
end
```

O que acontece é o seguinte, você pode simplesmente adicionar o seguinte método a um model que queira dividir a carga entre escrita no master e leitura no follower:

--- ruby
class User
  replicated_model
  ...
end
```

Nunca coloque o método acima em **todos** os models indiscriminadamente. Você quer controlar em quais followers quer ler o que. No caso comum basta dividir entre todos os followers, mas caso tenha queries hiper-pesadas e queira dedicar um follower só pra isso, você também pode.

Um caso de uso comum é pegar workers de Sidekiq que façam muitos pré-cálculos, gerem relatórios ou denormalize tabelas grandes e faça o seguinte:

--- ruby
# query pesada normal:
ModelPesado.includes(:abc, :xyz).scope_pesado.group(:foo).find_each { |m| m.algo_pesado }

# query modificada pra rodar num follower:
ModelPesado.using(Octopus.random_follower).includes(:abc, :xyz).scope_pesado.group(:foo).find_each { |m| m.algo_pesado }
```

Sem o método <tt>Octopus.random_follower</tt> você teria que manualmente digitar o nome do follower que quer usar baseado na cor de sua variável de ambiente, por exemplo o HEROKU_POSTGRESQL_AMBER_URL você faria: <tt>.using(:amber_follower)</tt>. Com o método ele vai devolver o único follower que você tem ou aleatoriamente entre a lista de followers que você tem.

Outra forma é o seguinte:

--- ruby
Octopus.using(Octopus.random_follower) do
  ModelPesado.includes(:abc, :xyz).scope_pesado.group(:foo).find_each { |m| m.algo_pesado }
end
```

Uma coisa que parece necessária, como foi no caso de uma [issue do DelayedJob](https://github.com/tchandy/octopus/issues/241) se por algum motivo você precisar rodar um comando como Update dentro de um <tt>find_by_sql</tt>, lembre-se de explicitamente colocá-la no escopo do banco master:

--- ruby
Octopus.using(:master) do
  Model.find_by_sql("UPDATE ...")
end
```

Como disse antes, isso não é uma solução para que você jogue tudo pro follower. Avalie no próprio dashboard do seu banco de dados quais são as queries pesadas e no New Relic e comece movendo somente essas queries primeiro. Performance não é algo que você codifica sem medir: senão como saber se o que você fez realmente fez alguma diferença? Meça antes e meça depois. E continue nesse ciclo.

A gem Octopus e o recurso de Followers do Heroku Postgresql são excelentes opções para mover queries pesadas e descarregar seu banco master principal, o que vai garantir que sua aplicação possa escalar muito mais com poucas mudanças de código.
