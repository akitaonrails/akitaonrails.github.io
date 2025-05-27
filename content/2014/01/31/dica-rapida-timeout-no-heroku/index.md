---
title: "[Dica Rápida] Timeout no Heroku"
date: '2014-01-31T21:14:00-02:00'
slug: dica-rapida-timeout-no-heroku
tags:
- learning
- rails
- heroku
draft: false
---

Ano passado, quando um projeto de cliente entrou em produção, ter esquecido disso me custou várias horas de muita tensão. Graças à ajuda rápida e precisa da equipe de suporte e desenvolvimento do [Heroku](http://heroku.com) (thanks [@ped](http://twitter.com/ped)) conseguimos contornar a situação.

O Heroku continua sendo minha recomendação a todos os meus clientes. A menos que você tenha uma situação presente muito particular (e lhes garanto, são casos raros), 99% dos casos cabem como uma luva no Heroku. Portanto, na dúvida, vá de Heroku.

Porém, o Heroku tem algumas peculiaridades que você precisa conhecer. Caso ainda não tenha visto, reveja meu artigo [Enciclopédia do Heroku](http://www.akitaonrails.com/2012/04/20/heroku-tips-enciclopedia-do-heroku) que publiquei em Abril de 2012.

Uma em particular merece atenção especial porque a maioria sempre esquece disso. O Router do Heroku evoluiu bastante desde o começo e também desde a [controvérsia da RapGenius](http://venturebeat.com/2013/03/02/rap-genius-responds/) que estourou no começo de 2013. Mas o artigo não é sobre isso. Alguns já devem ter tentado navegar numa aplicação pesada que colocou no Heroku e receber uma página com um erro genérico roxa do próprio Heroku e não saber o que é. Ou, se você investiu pesado em marketing e começou a receber toneladas de acesso (dezenas ou centenas de requests por minuto), ver seus dynos patinando sem saber porque.

Então aqui vai a dica. Use a gem [rack-timeout](https://github.com/kch/rack-timeout) e configure um timeout baixo, igual ou menor que 15 segundos (que, convenhamos, se uma request demora 15 segundos pra ser processada é porque ela é extremamente mal feita. Culpe seu código antes de culpar o Rails, o Heroku ou qualquer outra coisa).

Para instalar é muito fácil. Adicione à sua <tt>Gemfile</tt>:

```ruby
gem 'rack-timeout'
```

Rode <tt>bundle</tt> pra instalar e crie o arquivo <tt>config/initializers/rack_timeout.rb</tt> com o seguinte:

```ruby
if defined?(Rack::Timeout)
  Rack::Timeout.timeout = Integer( ENV['RACK_TIMEOUT'] || 12 )
end
```

Finalmente, configure sua aplicação no Heroku com o timeout que você quer, por exemplo:

```
heroku config:set RACK_TIMEOUT=10
```

E se você usa Unicorn, configure seu <tt>config/unicorn.rb</tt> com o seguinte:

```
# Based on https://gist.github.com/1401792

worker_processes 2

timeout 25

preload_app true

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info('Disconnected from ActiveRecord')
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
    Rails.logger.info('Connected to ActiveRecord')
  end
end
```

Especial atenção à configuração de timeout. O timeout do Router do Heroku, por padrão, será sempre 30 segundos. Configure o timeout do Unicorn pra ser menor que 30 segundos (como no exemplo, 25 segundos), e configure o Rack Timeout pra ser menor ainda do que isso (no exemplo, 10 segundos).

Leia o [README](https://github.com/kch/rack-timeout/blob/master/README.markdown) do Rack Timeout para mais detalhes, mas feito isso, se algum processamento levar mais do que 10 segundos para finalizar, ele vai estourar uma exception. E é isso que queremos, caso contrário o Router do Heroku vai cortar após os 30 segundos e não vai lhe dizer onde foi o problema, o gargalo que levou a dar um timeout acima dos 30 segundos.

Agora, você precisa de uma forma de ver o stacktrace gerado e para isso use uma opção simples como [Exception Notification](https://github.com/rails/exception_notification) que você configura facilmente primeiro adicionando uma opção de envio de email à sua aplicação no Heroku como Sendgrid ou Mailgun, e então adiciona ao seu arquivo <tt>config/environments/production.rb</tt> algo como:

```ruby
config.middleware.use ExceptionNotification::Rack,
  :email => {
    :email_prefix => "[Exception - MyApp] ",
    :sender_address => %{"no-reply" <no-reply@myapp.com.br>},
    :exception_recipients => [ENV['EXCEPTION_NOTIFICATION_EMAIL']]
  }
```

Ou então adiciona algo mais parrudo como [Honeybadger](https://www.honeybadger.io). O importante é você receber esse stacktrace. Com essa informação você pode otimizar sua aplicação. Talvez seja o caso de otimizar uma query muito lenta, talvez faltem índices nas suas tabelas (veja a gem [Bullet](https://github.com/flyerhzm/bullet)), talvez seja uma questão de adicionar [Caching](http://www.akitaonrails.com/2008/8/21/tutorial-de-rails-caching-parte-1), talvez você devesse mover um processo demorado como uma tarefa assíncrona via [Sidekiq](https://github.com/mperham/sidekiq). Enfim, existem diversas opções para melhorar o tempo de uma requisição para que ela fique dentro do que eu considero como "bom" (abaixo de 1 segundo) ou "ótimo" (abaixo de 100ms).

E falando em otimização de requests, outra excelente opção ao Unicorn para colocar no Heroku é o Phusion Passenger que, com o novo garbage collector e a implementação de [Out-of-Band Garbage Collector](http://blog.phusion.nl/2014/01/31/phusion-passenger-now-supports-the-new-ruby-2-1-out-of-band-gc/), pode diminuir dramaticamente o tempo das suas requests.

O importante deste artigo: você precisa de informação antes de saber como agir. O timeout default do Router do Heroku não vai lhe dizer, mas o Rack Timeout pode ser o que falta para descobrir seu gargalo, então configure o quanto antes.
