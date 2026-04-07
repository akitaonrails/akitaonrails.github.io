---
title: "Como Não Zerar sua Cota de Desenvolvimento no Pusher"
date: '2017-10-27T13:43:00-02:00'
slug: como-nao-zerar-sua-cota-de-desenvolvimento-no-pusher
translationKey: how-not-to-zero-pusher
aliases:
- /2017/10/27/how-not-to-zero-out-your-pusher-development-quota/
tags:
- beginner
- rubyonrails
- rails51
- pusher
- rspec
- traduzido
draft: false
---

Se você está desenvolvendo com WebSockets (notificações em tempo real, chat em tempo real, etc), uma das melhores opções SaaS disponíveis ainda é o [**Pusher**](pusher.com). Sempre foi confiável.

Para cada aplicação que você cria, ele oferece ambientes separados de desenvolvimento, staging e produção, com tokens de chave/segredo independentes.

Um problema que encontrei esses dias foi que eu estava zerando rapidamente a cota gratuita de mensagens do ambiente de desenvolvimento (200.000 mensagens por dia). O motivo era que toda a minha equipe usava a mesma chave, e o servidor de Integração Contínua fazia conexões reais sempre que rodava no mesmo ambiente. Isso consome tudo rapidamente e bloqueia tanto o desenvolvimento quanto o CI.

Na verdade, fazer conexões reais a sistemas externos em situações de teste não é boa prática. Os testes podem falhar aleatoriamente por vários motivos, então sempre devemos mockar essas dependências. Mas mockar um sistema complexo (WebSockets e HTTP) como o Pusher não é trivial.

Felizmente, encontrei o [Pusher Fake](https://github.com/tristandunn/pusher-fake). Ele basicamente implementa todas as APIs e endpoints WebSocket necessários para imitar o Pusher e enganar tanto o servidor quanto o cliente JS para se comunicar com ele.

A ideia é que sua aplicação Rails, em modo de desenvolvimento, faça um fork de um processo separado de servidor para que o cliente Pusher se conecte. Essa gem é ao mesmo tempo um servidor clone do Pusher e uma série de wrappers para carregá-lo no seu setup.

Começando pelo básico.

Na sua aplicação, você terá tanto uma configuração de conexão do cliente Pusher no lado Ruby (para enviar mensagens a um canal no servidor Pusher) quanto uma instância Pusher do lado Javascript, no cliente, principalmente para assinar um canal em uma conexão WebSocket e receber mensagens.

Primeiro, precisamos configurar o lado Ruby. Geralmente fica em um `config/initializers/pusher.rb` assim:

```ruby
Pusher.app_id = ENV['PUSHER_APP']
Pusher.key    = ENV['PUSHER_KEY']
Pusher.secret = ENV['PUSHER_SECRET']
Pusher.cluster = ENV['PUSHER_CLUSTER']
# nunca defina Pusher.host ou Pusher.port aqui
```

Note que estou usando variáveis de ambiente para guardar a configuração. Você deve usar algo como a [gem figaro](https://github.com/laserlemon/figaro) ou a [gem dotenv-rails](https://github.com/bkeepers/dotenv). Por exemplo:

```yaml
PUSHER_APP: "xpto"
PUSHER_KEY: "abcd1234"
PUSHER_SECRET: "abcd1234"
PUSHER_CLUSTER: "us2"
```

No mínimo você precisa de um ID de aplicação, uma chave, um segredo e um nome de cluster. Tudo isso é fornecido pelo Pusher quando você registra uma nova aplicação lá.

Segundo, precisamos configurar a instância Javascript. Geralmente você tem algo no diretório `assets/javascripts` assim:

```javascript
// exemplo .js.erb
window.pusher = new Pusher(<%= ENV['PUSHER_APP] %>, {
  cluster: <%= ENV['PUSHER_KEY'] %>,
  encrypted: <%= ENV['PUSHER_ENCRYPTED'] %>})
```

No Console de Desenvolvimento do Chrome, você pode inspecionar essa instância digitando:

```
Pusher.instances[0]
```

Assim você consegue verificar se está pegando as configurações corretas para a conexão e depurar problemas.

As dependências são a gem pusher no seu `Gemfile` e o cliente javascript.

```ruby
# Gemfile
gem 'pusher'
```

No caso do arquivo javascript, você pode adicioná-lo ao projeto e depender do [Webpacker](http://www.akitaonrails.com/2017/10/24/iniciante-experimentando-o-rails-5-1-x):

```
yarn add pusher
```

Então, no seu arquivo javascript ES6, você faz:

```javascript
const Pusher = require('pusher-js');
```

Ou pode linkar diretamente no seu layout:

```html
<script src="https://js.pusher.com/4.2/pusher.min.js"></script>
```

Para mais informações sobre o cliente pusher-js, leia o [arquivo README](https://github.com/pusher/pusher-js).

## Adicionando o Pusher Fake

Nesse ponto, você já deve conseguir se conectar à conta real do Pusher e ver a mágica do tempo real acontecendo.

E você já está consumindo a cota gratuita disponível no seu ambiente de desenvolvimento no Pusher. Para a maioria das pessoas, isso é suficiente.

Mas o objetivo é NÃO se conectar ao Pusher pela internet e manter tudo local para desenvolvimento e testes. Vamos começar adicionando o [Pusher Fake](https://github.com/tristandunn/pusher-fake) ao nosso `Gemfile`:

```ruby
group :development, :test do
  gem 'pusher-fake'
end
```

Agora é onde a configuração do Pusher Fake pode ficar complicada se você não entender o que está acontecendo. Como disse antes, o PusherFake precisa fazer um fork de um novo processo para carregar um servidor local que imita o Pusher.

Para carregá-lo, você precisa apontar para o servidor local. Lembra do nosso `config/initializers/pusher.rb`? Basta fazer um require de um arquivo simples assim:

```ruby
Pusher.app_id = ENV['PUSHER_APP']
Pusher.key    = ENV['PUSHER_KEY']
Pusher.secret = ENV['PUSHER_SECRET']
Pusher.cluster = ENV['PUSHER_CLUSTER']

if Rails.env.development?
  require "pusher-fake/support/base"
end
```

Só isso já apresenta MUITOS problemas se você não tiver cuidado. Esse `require` vai **fazer um fork** de um novo processo. Se você estiver usando um servidor web de processo único como Webrick ou Thin, tudo bem. Se estiver usando Puma, Unicorn ou Passenger com no máximo um processo, também deve funcionar. Mas se você carregar um servidor web que por si mesmo faz fork de novos processos, vai ter problema.

Na prática, prefiro carregar o servidor Pusher Fake separadamente, em modo standalone. Felizmente ele fornece um comando de linha de comando para iniciá-lo. E é boa prática configurar isso em um arquivo `Procfile.dev` e usar o [foreman](https://github.com/ddollar/foreman) para iniciar tudo. O `Procfile.dev` fica assim:

```
web: bundle exec rails s -p 3000
db: postgres -D /usr/local/var/postgres
redis: redis-server /usr/local/etc/redis.conf
mailcatcher: mailcatcher -f
pusherfake: pusher-fake -i ${PUSHER_APP:-xpto} --socket-host 0.0.0.0 --socket-port ${PUSHER_WS_PORT:-45449} --web-host 0.0.0.0 --web-port ${PUSHER_PORT:-8888} -k ${PUSHER_KEY:-abcd1234} -s ${PUSHER_SECRET:-abcd1234}
```

De bônus, veja como configuro outros serviços como PostgreSQL, Redis, etc.

Se você não sabia, pode usar `${VARIABLE_NAME:-default_value}` para usar uma variável de ambiente ou ter um valor padrão caso ela não exista. Isso significa que suas variáveis de ambiente configuradas com Figaro ou Dotenv precisam ter os mesmos valores.

```yaml
PUSHER_APP: "xpto"
PUSHER_KEY: "abcd1234"
PUSHER_SECRET: "abcd1234"
PUSHER_CLUSTER: "us2"
PUSHER_HOST: "127.0.0.1"
PUSHER_PORT: "8888"
PUSHER_WS_HOST: "127.0.0.1"
PUSHER_WS_PORT: "45449"
```

Agora seu `config/initializers/pusher.rb` deve ficar assim:

```ruby
Pusher.app_id = ENV['PUSHER_APP']
Pusher.key    = ENV['PUSHER_KEY']
Pusher.secret = ENV['PUSHER_SECRET']
Pusher.cluster = ENV['PUSHER_CLUSTER']

if Rails.env.development?
  Pusher.host = ENV['PUSHER_HOST']
  Pusher.port = ENV['PUSHER_PORT']
end
```

E a configuração do Pusher-js em algum lugar do seu diretório `app/assets/javascripts/` vai ficar algo assim:

```javascript
<% if defined?(PusherFake) %>
    <% if Rails.env.test? %>
    var pusher = <%= PusherFake.javascript(cluster: ENV["PUSHER_CLUSTER"]) %>
    <% else %>
    window.pusher = new Pusher(<%= ENV['PUSHER_KEY'] %>, {
      cluster: <%= ENV['PUSHER_CLUSTER'] %>,
      wsHost: <%= ENV['PUSHER_WS_HOST'] %>,
      wsPort: <%= ENV['PUSHER_WS_PORT'] %>,
      encrypted: <%= ENV['PUSHER_ENCRYPTED'] %>})    
    <% end %>
<% else %>
    window.pusher = new Pusher(<%= ENV['PUSHER_KEY'] %>, {
      cluster: <%= ENV['PUSHER_CLUSTER'] %>,
      encrypted: <%= ENV['PUSHER_ENCRYPTED'] %>})
<% end %>
```

Lembre que este é um arquivo Javascript+ERB, então podemos buscar as mesmas variáveis de ambiente para a configuração.

Agora, sempre que você executar `foreman start -f Procfile.dev -p 3000`, ele vai carregar o servidor Pusher Fake com as configurações de desenvolvimento corretas, e tanto o seu servidor ruby quanto o cliente javascript devem se conectar a ele sem nenhum problema.

Note também o trecho `if Rails.env.test?`. Isso é para a sua suite de testes RSpec. No caso do ambiente de testes, não vamos carregar o servidor fake manualmente; em vez disso, vamos criar algo como `spec/support/pusher-fake.rb` com:

```ruby
require "pusher-fake/support/rspec"
```

E é isso. O `PusherFake.javascript` vai definir a configuração padrão de conexão WebSocket, e o `require` acima vai tanto fazer o fork do servidor fake quanto configurar o RSpec para limpar os canais a cada execução de teste (via `PusherFake::Channel.reset`).

Desta forma, seu ambiente de testes também evita se conectar ao servidor Pusher real, externo.

A chave de tudo isso são as variáveis de ambiente. Você precisa garantir que cada peça esteja carregando a mesma configuração — caso contrário, você terá o servidor fake fazendo bind em uma porta diferente da que o Pusher-js está tentando se conectar, e vai ter erros. Depure com cuidado.

O mais importante: se você fez tudo corretamente, agora é independente do servidor Pusher real para os ambientes de desenvolvimento e testes, nunca vai atingir nenhum limite de cota, e sua equipe e seu CI poderão trabalhar de forma ininterrupta, com comportamento determinístico.
