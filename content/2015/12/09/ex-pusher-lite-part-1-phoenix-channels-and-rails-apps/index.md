---
title: 'Ex Pusher Lite - Parte 1: Phoenix Channels e aplicações Rails'
date: '2015-12-09T18:39:00-02:00'
slug: ex-pusher-lite-parte-1-phoenix-channels-e-aplicacoes-rails
translationKey: ex-pusher-lite-part-1
aliases:
- /2015/12/09/ex-pusher-lite-part-1-phoenix-channels-and-rails-apps/
description: "A Parte 1 substitui o Pusher por um servidor Phoenix com Channels, WebSockets e Basic Auth, mantendo o cliente Rails e o SuckerPunch. O clone funciona sob controle próprio, mas ainda é incompleto."
tags:
- elixir-e-erlang
- rails
- sistemas-distribuidos
draft: false
---

Finalmente, depois de um bom período de exercícios (e muito blog post!) vou começar a implementar a aplicação Elixir que eu queria desde o começo.

Como desenvolvedor Rails, existem algumas coisas que a gente simplesmente não consegue fazer em Rails. Uma delas é lidar com mensageria em tempo real.

O Rails 5 vai trazer o [Action Cable](https://github.com/rails/actioncable), e talvez seja bom o suficiente para a maioria dos casos. Ele usa o [Faye](https://github.com/faye/faye), que por sua vez é baseado em Eventmachine. Você pode implementar uma solução suficientemente boa para Websockets usando Faye na sua aplicação Rails 4.2 agora mesmo.

Outra opção é evitar o trabalho todo e usar um serviço de mensageria. Uma opção que sempre recomendo, sem fricção nenhuma, é o [Pusher.com](https://pusher.com/).

![Chat Example](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/533/big_Screenshot_from_2015-12-09_18_41_22.png)

### O Básico

Você vai querer clonar do meu [repositório de exemplo](https://github.com/akitaonrails/pusher_lite_demo/tree/v0.1), assim:

```
git clone https://github.com/akitaonrails/pusher_lite_demo
cd pusher_lite_demo
git checkout tags/v0.1 -b v0.1
bundle
```

Esta é uma implementação muito, muito simples de um chat em tempo real, baseado em websocket, usando Pusher. A ideia é a seguinte:

Começamos tendo um Form no front-end para enviar mensagens

```html
<!-- app/views/home/index.html.erb -->
<%= form_for @event, url: events_path, remote: true, html: {class: "pure-form pure-form-stacked"} do |f| %>
  <fieldset>
    <legend>Send your message remotely</legend>
    <%= f.text_field :name, placeholder: "Name" %>
    <%= f.text_field :message, placeholder: "Message" %>
    <%= f.submit "Send message", class: "pure-button pure-button-primary" %>
  </fieldset>
<% end %>
```

Ele usa o suporte nativo a jQuery do Rails para fazer o post Ajax do form ao método "EventsController#create":

```ruby
# app/controllers/events_controller.rb
class EventsController < ApplicationController
  def create
    SendEventsJob.perform_later(event_params)
  end

  def event_params
    params.require(:pusher_event).permit(:name, :message)
  end
end
```

Só para anotar o processo, o "routes.rb" fica assim:

```ruby
# config/routes.rb
Rails.application.routes.draw do
  resources :events, only: [:create]

  root 'home#index'
end
```

O layout HTML fica assim:

```ruby
<!-- app/views/layout/application.html.erb -->
<!DOCTYPE html>
<html>
<head>
  <title>Pusher Lite Demo</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="pusher_key" content="<%= Rails.application.secrets.pusher_key %>">
  <meta name="pusher_channel" content="<%= Rails.application.secrets.pusher_channel %>">
  <%= stylesheet_link_tag    'application', media: 'all', 'data-turbolinks-track' => true %>
  <%= javascript_include_tag 'application', 'data-turbolinks-track' => true %>
  <script src="//js.pusher.com/3.0/pusher.min.js"></script>
  <%= csrf_meta_tags %>
</head>
<body>

<div class="pure-menu pure-menu-horizontal">
    <span class="pure-menu-heading">Pusher Client Demo</span>
...
</div>

<div class="pure-g-r">
  <div class="pure-u-1-3 message-form">
    <%= yield %>
  </div>
  
  <div class="pure-u-1-3 message-receiver">
  </div>
</div>

</body>
</html>
```

Esse layout importa o "application.js" padrão, que configura o Pusher, estabelece a conexão Websocket e se inscreve para receber mensagens em um tópico específico com eventos específicos:

```javascript
// app/assets/javascript/application.js
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .

$(document).on("page:change", function(){
  var pusherKey = $("meta[name=pusher_key]").attr("content");
  var pusher = new Pusher(pusherKey, { encrypted: true });

  var pusherChannel = $("meta[name=pusher_channel]").attr("content");
  var channel = pusher.subscribe(pusherChannel);
  
  channel.bind('new_message', function(data) {
    var new_line = "<p><strong>" + data.name + "<strong>: " + data.message + "</p>";
    $(".message-receiver").append(new_line);
  });
});
```

Ele pega os metadados de configuração das meta tags do layout, que por sua vez pegam os valores do "config/secrets.yml":

```yaml
development:
  secret_key_base: ded7c4a2a298c1b620e462b50c9ca6ccb60130e27968357e76cab73de9858f14556a26df885c8aa5004d0a7ca79c0438e618557275bdb28ba67a0ffb0c268056
  pusher_url: <%= ENV['PUSHER_URL'] %>
  pusher_key: <%= ENV['PUSHER_KEY'] %>
  pusher_channel: test_chat_channel

test:
  secret_key_base: f51ff494801ff0f9e1711036ef6f2f6f1e13544b02326adc5629c6833ae90f1a476747fae94b792eba8a444305df8e7a5ad53f05ea4234692ac96cc44f372029
  pusher_url: <%= ENV['PUSHER_URL'] %>
  pusher_key: <%= ENV['PUSHER_KEY'] %>
  pusher_channel: test_chat_channel

# Do not keep production secrets in the repository,
# instead read values from the environment.
production:
  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
  pusher_url: <%= ENV['PUSHER_URL'] %>
  pusher_key: <%= ENV['PUSHER_KEY'] %>
  pusher_channel: <%= ENV['PUSHER_CHANNEL'] %>
```

E como estou usando dotenv-rails, o ".env" fica assim:

```
PUSHER_URL: "https://14e86e5fee3335fa88b0:2b94ff0f07ce9769567f@api.pusherapp.com/apps/159621"
PUSHER_KEY: "14e86e5fee3335fa88b0"
PUSHER_CHANNEL: "test_chat_channel"
```

O Pusher é configurado no lado do servidor através deste initializer:

```ruby
# config/initializers/pusher.rb
require 'pusher'

Pusher.url = Rails.application.secrets.pusher_url
Pusher.logger = Rails.logger
```

Por fim, o "EventsController#create" faz uma chamada assíncrona para um job do [SuckerPunch](https://github.com/brandonhilkert/sucker_punch):

```ruby
class SendEventsJob < ActiveJob::Base
  queue_as :default

  def perform(event_params)
    @event = PusherEvent.new(event_params)
    @event.save
  end
end
```

A propósito, abrindo um parêntese, o [SuckerPunch](https://github.com/brandonhilkert/sucker_punch) é uma solução fantástica para tarefas assíncronas dentro do mesmo processo. É uma ótima opção para começar sem precisar montar um sistema separado com workers do Sidekiq.

Quando você tiver filas maiores ou jobs que demoram demais, aí sim parta para o Sidekiq. Se você usa ActiveJob, a transição é tão simples quanto mudar a seguinte linha de configuração no arquivo "config/application.rb":

```ruby
config.active_job.queue_adapter = :sucker_punch
```

Esse job apenas chama o método "save" no fake-model "PusherEvent":

```ruby
class PusherEvent
  include ActiveModel::Model

  attr_accessor :name, :message
  validates :name, :message, presence: true

  def save
    Pusher.trigger(Rails.application.secrets.pusher_channel, 'new_message', {
      name: name,
      message: message
    })
  end
end
```

Como é bem simples, o Gemfile também fica simples:

```ruby
gem 'pusher'
gem 'dotenv-rails'
gem 'purecss-rails'
gem 'sucker_punch'
```

Então o que ele faz é bem simples:

1. A aplicação carrega o Pusher e a configuração necessária.
2. Quando o usuário acessa "http://localhost:3000" ele recebe o Form de mensagem.
3. Quando o usuário envia a mensagem, ela cai no "EventsController#create", que chama o "SendEventsJob" do SuckerPunch, instancia um novo modelo "PusherEvent" com os params do form recebido e finalmente dispara a mensagem para o servidor do Pusher.
4. A mesma página do form também carrega o cliente javascript do Pusher e se conecta no tópico "test_chat_channel" e escuta o evento "new_message", que é exatamente o que a chamada "Pusher.trigger" envia junto com os params da mensagem do form.
5. O servidor Pusher faz broadcast da mensagem recebida para todos os clientes Websocket inscritos.
6. O cliente javascript do Pusher no navegador do usuário recebe a nova mensagem e simplesmente formata e adiciona ao bloco HTML "message-receiver" na mesma página.

O Pusher tem suporte para usuários autenticados, canais privados e mais coisas, mas isso aí já cobre 80% dos casos de uso. Você pode implementar isso como sistema de chat, sistema de notificação, ou qualquer coisa do tipo.

Sua aplicação Rails monta o HTML/Javascript do front-end para conectar no Pusher, escutando certos tópicos e eventos, e a mesma aplicação Rails dispara o Pusher no lado servidor, postando novas mensagens. O Pusher recebe as mensagens e faz o broadcast para os clientes inscritos nos seus tópicos. É isso.

## Ex Pusher Lite - Parte 1: Substituto inicial baseado em Phoenix

A minha ideia original era fazer um drop-in replacement do servidor Pusher, usando o mesmo cliente Pusher, mas por enquanto isso não foi tão fácil de fazer.

Em vez disso, esta Parte 1 vai focar em implementar um servidor inicial ExPusherLite que também recebe eventos disparados pelo mesmo controller server-side do Rails e faz broadcast para o mesmo componente front-end do Rails através de WebSockets.

Eu segui o tutorial do [Daniel Neighman](https://labs.opendoor.com/phoenix-on-rails-for-client-push-notifications). Tive que fazer alguns ajustes para conseguir rodar (e como ainda é só a Parte 1, ainda não é uma solução completa!)

Você pode clonar a versão inicial do [meu outro repositório no Github](https://github.com/akitaonrails/ex_pusher_lite) assim:

```
git clone https://github.com/akitaonrails/ex_pusher_lite
cd ex_pusher_lite
mix deps.get
```

O tutorial implementou um setup inicial do [Guardian](https://github.com/hassox/guardian) e do [Joken](https://github.com/bryanjos/joken) para JSON Web Tokens. Ainda estou me acostumando com a forma como os [channels](http://www.phoenixframework.org/docs/channels) são implementados no Phoenix.

Ele já vem pré-configurado com um único socket handler que faz multiplex das conexões. Você inicia através da aplicação OTP EndPoint:

```ruby
# lib/ex_pusher_lite/endpoint.ex
defmodule ExPusherLite.Endpoint do
  use Phoenix.Endpoint, otp_app: :ex_pusher_lite

  socket "/socket", ExPusherLite.UserSocket
  ...
```

Essa aplicação é iniciada pelo supervisor principal em "lib/ex_pusher_lite.ex". Ele aponta o endpoint "/socket" para o socket handler "UserSocket":

```ruby
# web/channels/user_socket.ex
defmodule ExPusherLite.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "*", ExPusherLite.RoomChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll
  ...
```

A função "channel" vem comentada, então comecei descomentando ela. Você pode fazer pattern match no nome do tópico tipo "public:*" para diferentes Channel handlers. Para esse teste inicial simples eu estou mandando tudo para o "RoomChannel", que precisei criar:

```ruby
defmodule ExPusherLite.RoomChannel do
  use Phoenix.Channel
  use Guardian.Channel

  # no auth is needed for public topics
  def join("public:" <> _topic_id, _auth_msg, socket) do
    {:ok, socket}
  end

  def join(topic, %{ claims: claims, resource: _resource }, socket) do
    if permitted_topic?(claims[:listen], topic) do
      { :ok, %{ message: "Joined" }, socket }
    else
      { :error, :authentication_required }
    end
  end

  def join(_room, _payload, _socket) do
    { :error, :authentication_required }
  end

  def handle_in("msg", payload, socket = %{ topic: "public:" <> _ }) do
    broadcast socket, "msg", payload
    { :noreply, socket }
  end

  def handle_in("msg", payload, socket) do
    claims = Guardian.Channel.claims(socket)
    if permitted_topic?(claims[:publish], socket.topic) do
      broadcast socket, "msg", payload
      { :noreply, socket }
    else
      { :reply, :error, socket }
    end
  end

  def permitted_topic?(nil, _), do: false
  def permitted_topic?([], _), do: false

  def permitted_topic?(permitted_topics, topic) do
    matches = fn permitted_topic ->
      pattern = String.replace(permitted_topic, ":*", ":.*")
      Regex.match?(~r/\A#{pattern}\z/, topic)
    end
    Enum.any?(permitted_topics, matches)
  end
end
```

Isso tudo veio direto do tutorial original do Daniel. A parte importante para esse exemplo é a primeira função "join". As outras lidam com permissões e autenticação que vêm através de uma claim JWT. Vou tratar disso na Parte 2.

Para fazer isso funcionar, tive que adicionar as dependências em "mix.exs":

```ruby
# mix.exs
defmodule ExPusherLite.Mixfile do
  use Mix.Project
  ...
  defp deps do
    [{:phoenix, "~> 1.0.3"},
     {:phoenix_ecto, "~> 1.1"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.1"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:cowboy, "~> 1.0"},
     {:joken, "~> 1.0.0"},
     {:guardian, "~> 0.7.0"}]
  end
  ...
end
```

E adicionar a configuração em "config.exs":

```ruby
# config/config.exs
...
config :joken, config_module: Guardian.JWT

config :guardian, Guardian,
  issuer: "ExPusherLite",
  ttl: { 30, :days },
  verify_issuer: false,
  serializer: ExPusherLite.GuardianSerializer,
  atoms: [:listen, :publish, :crews, :email, :name, :id]
```

Agora preciso adicionar um endpoint HTTP POST normal, primeiro adicionando ele ao router:

```ruby
# web/router.ex
defmodule ExPusherLite.Router do
  use ExPusherLite.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    #plug :protect_from_forgery
    plug :put_secure_browser_headers
  end
  ...
  scope "/", ExPusherLite do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    post "/events", EventsController, :create
  end
```

Repare que eu desabilitei totalmente a verificação de CSRF token no pipeline porque eu não estou enviando de volta o CSRF token do Phoenix a partir do controller do Rails. Agora, o "EventsController" também é quase todo do tutorial do Daniel:

```ruby
# web/controllers/events_controller.ex
defmodule ExPusherLite.EventsController do
  use ExPusherLite.Web, :controller

  plug :authenticate

  def create(conn, params) do
    topic = params["topic"]
    event = params["event"]
    message = (params["payload"] || "{}") |> Poison.decode!
    ExPusherLite.Endpoint.broadcast! topic, event, message
    json conn, %{}
  end

  defp authenticate(conn, _) do
    secret = Application.get_env(:ex_pusher_lite, :authentication)[:secret]
    "Basic " <> auth_token = hd(get_req_header(conn, "authorization"))
    if Plug.Crypto.secure_compare(auth_token, Base.encode64(secret)) do
      conn
    else
      conn |> send_resp(401, "") |> halt
    end
  end
end
```

Tive que mudar a função authenticate um pouco porque ou eu não entendi a implementação do Daniel ou ela esperava algo diferente. Mas nesta versão eu só estou esperando uma simples Basic HTTP Authentication no header "authorization", que é uma string com o formato "Basic [base64 username:password]". Olha como estou fazendo pattern match na string, removendo o Base64 e fazendo o ["secure compare"](http://codahale.com/a-lesson-in-timing-attacks/) (uma comparação binária em tempo constante para evitar timing attacks, isso já vem embutido no Phoenix).

Essa é uma técnica simples de autenticação para o controller do Rails fazer POST do trigger da mensagem da mesma forma que na versão Pusher.

E é isso, é tudo o que precisa para esse substituto inicial baseado em Phoenix do Pusher.

## Ex Pusher Lite - Parte 2: Mudando a aplicação Rails

Agora que temos uma aplicação Phoenix bem básica que podemos iniciar com "mix phoenix.server" e disponibilizar em "localhost:4000", podemos começar a mudar a aplicação Rails.

Como falei no começo, meu desejo original era usar o mesmo cliente javascript do Pusher só mudando o endpoint, acontece que isso é mais difícil do que eu pensava, então vou começar removendo a seguinte linha do layout da aplicação:

```html
<script src="//js.pusher.com/3.0/pusher.min.js"></script>
```

Podemos nos livrar da gem do Pusher no Gemfile e do initializer "pusher.rb" também.

Agora, um substituto para o "pusher.min.js" é o próprio "phoenix.js" do Phoenix, que vem junto em "deps/phoenix/web/static/js/phoenix.js". O problema é que ele é um source javascript ES6 que o Phoenix passa pelo Brunch para ser transpilado de volta para ES5 em toda aplicação Phoenix.

Mas eu estou copiando esse arquivo direto para o repositório do Rails em "app/assets/javascripts/phoenix.es6". Eu poderia ter convertido ele para ES5, mas resolvi seguir o caminho mais difícil e adicionar suporte ao Babel no Asset Pipeline do Rails usando o [tutorial muito útil do Nando](http://nandovieira.com/using-es6-with-asset-pipeline-on-ruby-on-rails) sobre o assunto.

A essência é assim: primeiro adicionamos as dependências no Gemfile:

```ruby
# Use SCSS for stylesheets
#gem 'sass-rails', '~> 5.0'
gem 'sass-rails', github: 'rails/sass-rails', branch: 'master'
gem 'sprockets-rails', github: 'rails/sprockets-rails', branch: 'master'
gem 'sprockets', github: 'rails/sprockets', branch: 'master'
gem 'babel-transpiler'
...
source 'https://rails-assets.org' do
  gem 'rails-assets-almond'
end
```

O Babel precisa de alguma configuração:

```ruby
# config/initializers/babel.rb
Rails.application.config.assets.configure do |env|
  babel = Sprockets::BabelProcessor.new(
    'modules'    => 'amd',
    'moduleIds'  => true
  )
  env.register_transformer 'application/ecmascript-6', 'application/javascript', babel
end
```

E por algum motivo eu tive que redeclarar manualmente o application.js e o application.css no initializer de assets:

```ruby
# config/initializers/assets.rb
...
Rails.application.config.assets.precompile += %w( application.css application.js )
```

Precisamos do Almond para conseguir importar o módulo Socket do pacote javascript do Phoenix. Agora, mudamos o "application.js":

```javascript
//= require almond
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require phoenix
//= require_tree .

require(['application/boot']);
```

Ele precisa de um arquivo "app/assets/javascripts/application/boot.es6", que vem direto do tutorial do Nando:

```javascript
import $ from 'jquery';

function runner() {
  // All scripts must live in app/assets/javascripts/application/pages/**/*.es6.
  var path = $('body').data('route');

  // Load script for this page.
  // We should use System.import, but it's not worth the trouble, so
  // let's use almond's require instead.
  try {
    require([path], onload, null, true);
  } catch (error) {
    handleError(error);
  }
}

function onload(Page) {
  // Instantiate the page, passing <body> as the root element.
  var page = new Page($(document.body));

  // Set up page and run scripts for it.
  if (page.setup) {
    page.setup();
  }

  page.run();
}

// Handles exception.
function handleError(error) {
  if (error.message.match(/undefined missing/)) {
    console.warn('missing module:', error.message.split(' ').pop());
  } else {
    throw error;
  }
}

$(window)
  .ready(runner)
  .on('page:load', runner);
```

E ele depende de atributos na tag body, então mudamos nosso template de layout:

```html
<!-- app/views/layouts/application.html.erb -->
...
<body data-route="application/pages/<%= controller.controller_name %>/<%= controller.action_name %>">
```

Não mencionei antes, mas eu também tenho um "HomeController" só para servir como root path para a página HTML principal, ele tem um único método "index" e o template "index.html.erb" com o form de mensagem. Então vou precisar de um "application/pages/home/index.es6" dentro do path "app/assets/javascripts":

```javascript
import {Socket} from "phoenix"

export default class Index {
  constructor(root) {
    this.root = root;
  }

  setup() {
    // add event listeners
    console.log('-> Setting up Pusher Lite socket')

    let guardianToken = $("meta[name=guardian-token]").attr("content")
    let csrfToken     = $("meta[name=guardian-csrf]").attr("content")

    let pusherKey     = $("meta[name=pusher_key]").attr("content")
    let pusherChannel = $("meta[name=pusher_channel]").attr("content")

    let socket = new Socket("ws://localhost:4000/socket", {
      params: { guardian_token: guardianToken, csrf_token: csrfToken }
    })
    socket.connect()

    // Now that you are connected, you can join channels with a topic:
    let channel = socket.channel(pusherChannel, {})
    channel.join()
      .receive("ok", resp => { console.log("Joined successfully", resp) })
      .receive("error", resp => { console.log("Unable to join", resp) })

    channel.on("msg", data => {
      let new_line = `<p><strong>${data.name}<strong>: ${data.message}</p>`
      $(".message-receiver").append(new_line)
    })
  }

  run() {
    // trigger initial action (e.g. perform http requests)
    console.log('-> perform initial actions')
  }
}
```

Esse trecho é parecido com o tratamento do javascript do Pusher, mas estamos pegando um pouco mais de informação das meta tags, os tokens "guardian-token" e "guardian-csrf". Como eu estava seguindo o tutorial do Daniel, também mudei o nome do evento de "new_message" para apenas "msg" e os tópicos agora precisam ter um prefixo "public:" para que o handler RoomChannel do Phoenix consiga fazer match no nome do tópico público corretamente.

Cada coisa em seu tempo. Para esse novo javascript ter os tokens corretos eu tive que adicionar o seguinte helper no layout das views:

```html
...
  <%= csrf_meta_tags %>
  <%= guardian_token_tags %>
</head>
...
```

E esse "guardian_token_tags" também vem direto do tutorial do Daniel:

```ruby
module GuardianHelper
  ISSUER = "pl-web-#{Rails.env}"
  DIGEST = OpenSSL::Digest.new('sha256')

  def guardian_token_tags
    token = Base64.urlsafe_encode64(SecureRandom.random_bytes(32))
    [
      "<meta content=\"#{jwt(token)}\" name=\"guardian-csrf\" />",
      "<meta content=\"#{token}\" name=\"guardian-token\" />",
    ].shuffle.join.html_safe
  end

  private

  def jwt(token)
    JWT.encode(jwt_claims(token), Rails.application.secrets.pusher_key, 'HS256')
  end

  def jwt_claims(token)
    {
      aud: :csrf,
      sub: jwt_sub,
      iss: ISSUER,
      iat: Time.now.utc.to_i,
      exp: (Time.now + 30.days).utc.to_i,
      s_csrf: guardian_signed_token(token),
      listen: jwt_listens,
      publish: jwt_publish,
    }
  end

  def jwt_sub
    return {} unless current_human.present?
    {
      id: current_human.id,
      name: current_human.full_name,
      email: current_human.email,
      crews: current_human.crews.map(&:identifier),
    }
  end

  def jwt_listens
    listens = ['deploys:web', 'public:*']
    listens.push('private:*') if current_human.try(:in_crew?, :admins)
    listens
  end

  def jwt_publish
    publish = ['public:*']
    publish.push('private:*') if current_human.try(:in_crew?, :admins)
    publish
  end

  def guardian_signed_token(token)
    key = Rails.application.secrets.pusher_key
    signed_token = OpenSSL::HMAC.digest(DIGEST, key, token)
    Base64.urlsafe_encode64(signed_token).gsub(/={1,}$/, '')
  end
end
```

Tive que ajustar um pouquinho, principalmente para pegar as chaves certas do arquivo "secrets.yml", que agora fica assim:

```yaml
development:
  secret_key_base: ded7c4a2a298c1b620e462b50c9ca6ccb60130e27968357e76cab73de9858f14556a26df885c8aa5004d0a7ca79c0438e618557275bdb28ba67a0ffb0c268056
  pusher_url: http://<%= ENV['PUSHER_KEY'] %>:<%= ENV['PUSHER_SECRET'] %>@<%= ENV['PUSHER_URL'] %>
  pusher_key: <%= ENV['PUSHER_KEY'] %>
  pusher_secret: <%= ENV['PUSHER_SECRET'] %>
  pusher_channel: "public:test_chat_channel"

test:
  secret_key_base: f51ff494801ff0f9e1711036ef6f2f6f1e13544b02326adc5629c6833ae90f1a476747fae94b792eba8a444305df8e7a5ad53f05ea4234692ac96cc44f372029
  pusher_url: http://<%= ENV['PUSHER_KEY'] %>:<%= ENV['PUSHER_SECRET'] %>@<%= ENV['PUSHER_URL'] %>
  pusher_key: <%= ENV['PUSHER_KEY'] %>
  pusher_secret: <%= ENV['PUSHER_SECRET'] %>
  pusher_channel: "public:test_chat_channel"

# Do not keep production secrets in the repository,
# instead read values from the environment.
production:
  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
  pusher_url: http://<%= ENV['PUSHER_KEY'] %>:<%= ENV['PUSHER_SECRET'] %>@<%= ENV['PUSHER_URL'] %>
  pusher_key: <%= ENV['PUSHER_KEY'] %>
  pusher_secret: <%= ENV['PUSHER_SECRET'] %>
  pusher_channel: <%= ENV['PUSHER_CHANNEL'] %>
```

Meu arquivo ".env" local fica assim:

```
PUSHER_URL: "localhost:4000"
PUSHER_KEY: "14e86e5fee3335fa88b0"
PUSHER_SECRET: "2b94ff0f07ce9769567f"
PUSHER_CHANNEL: "public:test_chat_channel" 
```

Esse trecho ainda precisa de mais trabalho, eu sei. Eu só copiei a key e a senha do Pusher como KEY e SECRET. Esse é o pedaço que eu mencionei que ajustei na função authenticate do RoomChannel no lado do Phoenix.

Agora que tenho isso no lugar, preciso mudar o modelo "PusherEvent" para disparar a mensagem do form para o EventsController do Phoenix, assim:

```ruby
# app/models/event.rb
require "net/http"
require "uri"
class PusherEvent
  include ActiveModel::Model

  attr_accessor :name, :message
  validates :name, :message, presence: true

  def save
    uri = URI.parse("#{Rails.application.secrets.pusher_url}/events")
    Net::HTTP.post_form(uri, {
      "topic" => Rails.application.secrets.pusher_channel,
      "event" => "msg",
      "payload" => {"name" => name, "message" => message}.to_json
    })
  end
end
```

Como estou fazendo isso através do SuckerPunch, estou usando o bom e velho "Net::HTTP.post()" para postar a mensagem para o endpoint "/events" do Phoenix. O Phoenix vai autenticar corretamente porque o "pusher_url" está enviando o "PUSHER_KEY:PUSHER_SECRET" como HTTP Basic Auth. Isso vai parar no header "authorization" e o Phoenix vai autenticar corretamente o lado do servidor, depois ele vai fazer broadcast para as conexões WebSocket inscritas no tópico.

O novo javascript vai se inscrever no tópico "public:test_chat_channel" e escutar o evento "msg". Quando receber o payload, ele formata a mensagem e, novamente, adiciona no mesmo lugar dentro da div "message-receiver".

### Conclusão: Trabalho Futuro

Então, com isso temos exatamente o mesmo comportamento da versão com Pusher, só que agora sob meu controle.

A ideia é o app Phoenix ter apps, uma autenticação real para diferentes apps. Aí toda aplicação Rails que eu fizer pode simplesmente conectar nesse mesmo serviço Phoenix.

Os próximos passos incluem implementar direito as partes de Guardian/JWT, depois posso pular para o suporte a canais privados e adicionar APIs HTTP para listar canais nos apps e usuários online nos canais.

Aí vou criar um segundo app Rails companion como dashboard de administração para consumir essas APIs e poder criar ou revogar apps e fazer manutenção e relatórios básicos. Isso deve ser um substituto bom o suficiente para uma solução de mensageria estilo Pusher que seja realmente rápida.
