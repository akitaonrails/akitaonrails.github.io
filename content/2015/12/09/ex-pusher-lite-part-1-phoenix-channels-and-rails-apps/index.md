---
title: 'Ex Pusher Lite - Part 1: Phoenix Channels and Rails apps'
date: '2015-12-09T18:39:00-02:00'
slug: ex-pusher-lite-part-1-phoenix-channels-and-rails-apps
tags:
- elixir
- phoenix
- pusher
- expusherlite
- english
draft: false
---

Finally, after a lengthy exercising period (and plenty of blogging!) I will start implementing the Elixir app I wanted from the very beginning.

As a Rails developer there are a few things we can't do in Rails. One of them is to deal with real-time messaging.

Rails 5 will bring [Action Cable](https://github.com/rails/actioncable), and it might be good enough for most cases. It uses [Faye](https://github.com/faye/faye), which in turn is based on Eventmachine. You can implement a good enough solution for Websockets using Faye in your Rails 4.2 app right now.

Another option is to avoid the trouble altogether and use a messaging service. One option I always recommend for zero friction is to use [Pusher.com](https://pusher.com/).

![Chat Example](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/533/big_Screenshot_from_2015-12-09_18_41_22.png)

### The Basics

You will want to clone from my [example repository](https://github.com/akitaonrails/pusher_lite_demo/tree/v0.1), like this:

---
git clone https://github.com/akitaonrails/pusher_lite_demo
cd pusher_lite_demo
git checkout tags/v0.1 -b v0.1
bundle
---

This is a very very simple implementation of a real-time, websocket-based, chat using Pusher. The idea goes like this:

We start by having a front-end Form to send messages

--- html
<!-- app/views/home/index.html.erb -->
<%= form_for @event, url: events_path, remote: true, html: {class: "pure-form pure-form-stacked"} do |f| %>
  <fieldset>
    <legend>Send your message remotely</legend>
    <%= f.text_field :name, placeholder: "Name" %>
    <%= f.text_field :message, placeholder: "Message" %>
    <%= f.submit "Send message", class: "pure-button pure-button-primary" %>
  </fieldset>
<% end %>
---

It's using Rails built-in jQuery support for Ajax posting the form to the "EventsController#create" method:

--- ruby
# app/controllers/events_controller.rb
class EventsController < ApplicationController
  def create
    SendEventsJob.perform_later(event_params)
  end

  def event_params
    params.require(:pusher_event).permit(:name, :message)
  end
end
---

Just to annotate the process, the "routes.rb" looks like this:

--- ruby
# config/routes.rb
Rails.application.routes.draw do
  resources :events, only: [:create]

  root 'home#index'
end
---

The HTML layout looks like this:

--- ruby
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
---

This layout imports the default "application.js" which configures Pusher, establishes the Websocket connection and subscribes to messages on a specific topic with specific events:

--- javascript
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
---

It gets the configuration metadata from the layout meta tags which grabs the values from "config/secrets.yml":

--- yaml
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
---

And as I'm using dotenv-rails, the ".env" looks like this:

---
PUSHER_URL: "https://14e86e5fee3335fa88b0:2b94ff0f07ce9769567f@api.pusherapp.com/apps/159621"
PUSHER_KEY: "14e86e5fee3335fa88b0"
PUSHER_CHANNEL: "test_chat_channel"
---

Pusher is configured in the server-side through this initializer:

--- ruby
# config/initializers/pusher.rb
require 'pusher'

Pusher.url = Rails.application.secrets.pusher_url
Pusher.logger = Rails.logger
---

Finally, the "EventsController#create" actually do an async call to a [SuckerPunch](https://github.com/brandonhilkert/sucker_punch) job:

--- ruby
class SendEventsJob < ActiveJob::Base
  queue_as :default

  def perform(event_params)
    @event = PusherEvent.new(event_params)
    @event.save
  end
end
---

By the way, as a segway, [SuckerPunch](https://github.com/brandonhilkert/sucker_punch) is a terrific solution for in-process asynchronous tasks. It's a better option to start with it without having to implement a separated system with Sidekiq workers.

Once you have larger job queues or jobs that are taking too long, then go to Sidekiq. If you use ActiveJob, the transition is as simple as changing the following configuration line in the "config/application.rb" file:

--- ruby
config.active_job.queue_adapter = :sucker_punch
---

This job just calls the "save" method in the fake-model "PusherEvent":

--- ruby
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
---

As it's a very simple, the Gemfile is equally simple:

--- ruby
gem 'pusher'
gem 'dotenv-rails'
gem 'purecss-rails'
gem 'sucker_punch'
---

So what it does is very simple:

1. The application loads Pusher and the necessary configuration.
2. When the user goes to "http://localhost:3000" he is presented with the message Form.
3. When the user posts the message, it ends in "EventsController#create", which calls SuckerPunch's "SendEventsJob", instantiates a new "PusherEvent" model with the received form params and finally triggers the message to the Pusher server.
4. The same form page also loads the Pusher javascript client and connects to the "test_chat_channel" topic and listens to the "new_message" event, which is the same thing the "Pusher.trigger" call sends together with the form message params.
5. The Pusher server broadcasts the received trigger message to all subscribed Websocket clients.
6. The Pusher javascript client in the user's browser receives the new message and just formats the message and appends to the "message-receiver" div HTML block in the same page.

Pusher has support for authenticated users, private channels and more, but this is 80% of the usage for most cases. You can implement this as a chat system, a notification system, or anything like that.

Your Rails app sets up the front-end HTML/Javascript to connect to Pusher, listening to certain topics and events and the same Rails app triggers Pusher in the server-side, posting new messages. Pusher receives messages and broadcasts to the clients that subscribes to its topics. That's it.

## Ex Pusher Lite - Part 1: Initial Phoenix-based Pusher replacement

My original idea was to make a drop-in replacement for the Pusher server, using the same Pusher client, but for now it was not easy to do so.

Instead, this Part 1 will focus on implementing an initial server ExPusherLite server that also receives events triggered by the same Rails server-side controller process and broadcasting to the same Rails front-end component through WebSockets.

I followed [Daniel Neighman](https://labs.opendoor.com/phoenix-on-rails-for-client-push-notifications) tutorial. I had to do a few adjustments to have it working (and as this is still Part 1, it's not a complete solution yet!)

You can close the initial version from [my other Github repository](https://github.com/akitaonrails/ex_pusher_lite) like this:

---
git clone https://github.com/akitaonrails/ex_pusher_lite
cd ex_pusher_lite
mix deps.get
---

The tutorial implemented initial setup for [Guardian](https://github.com/hassox/guardian) and [Joken](https://github.com/bryanjos/joken) for JSON Web Tokens. I am still getting used to how [channels](http://www.phoenixframework.org/docs/channels) are implemented in Phoenix.

It already comes pre-configured with a single socket handler that multiplexes connections. You start through the EndPoint OTP application:

--- ruby
# lib/ex_pusher_lite/endpoint.ex
defmodule ExPusherLite.Endpoint do
  use Phoenix.Endpoint, otp_app: :ex_pusher_lite

  socket "/socket", ExPusherLite.UserSocket
  ...
---

This application is started by the main supervisor in "lib/ex_pusher_lite.ex". It points the endpoint "/socket" to the socket handler "UserSocket":

--- ruby
# web/channels/user_socket.ex
defmodule ExPusherLite.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "*", ExPusherLite.RoomChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll
  ...
---

The "channel" function comes commented out, so I started by uncommenting it. You can pattern match the topic name like "public:*" to different Channel handlers. For this simple initial test I am sending everything to the "RoomChannel", which I had to create:

--- ruby
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
---

This is all straight from Daniel's original tutorial, the important bit for this example is the first "join" function, the others deal with permissions and authentication that came through a JWT claim. I will deal with this in Part 2.

To make this work, I had to add the dependencies in "mix.exs":

--- ruby
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
---

And add the configuration at "config.exs":

--- ruby
# config/config.exs
...
config :joken, config_module: Guardian.JWT

config :guardian, Guardian,
  issuer: "ExPusherLite",
  ttl: { 30, :days },
  verify_issuer: false,
  serializer: ExPusherLite.GuardianSerializer,
  atoms: [:listen, :publish, :crews, :email, :name, :id]
---

Now I have to add a normal HTTP POST endpoint, first adding it to the router:

--- ruby
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
---

Notice that I totally disabled CSRF token verification in the pipeline because I am not sending back Phoenix CSRF token from the Rails controller. Now, the "EventsController" is also almost all from Daniel's tutorial:

--- ruby
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
---

I had to change the authenticate function a bit because either I didn't understood Daniel's implementation or it expected something different. But in this version I am just expecting a simple Basic HTTP Authentication "authorization" header which is a string with the format "Basic [base64 username:password]". Look how I am pattern matching the string, removing the Base64 and ["secure comparing"](http://codahale.com/a-lesson-in-timing-attacks/) it (a constant-time binary compare to avoid timing attacks, this comes built-in with Phoenix).

This is a simple authentication technique for the Rails controller to POST the message trigger just the same as in the Pusher version.

And this is it, this is all it takes for this initial Phoenix-based Pusher replacement.

## Ex Pusher Lite - Part 2: Changing the Rails application

Now that we have a bare bone Phoenix app that we can start through "mix phoenix.server" and make it available at "localhost:4000" we can start changing the Rails application.

As I said in the beginning, my original wish was to use the same Pusher javascript client but change the endpoint, turns out it's more difficult than I thought, so I will start by removing the following line from the application layout:

--- html
<script src="//js.pusher.com/3.0/pusher.min.js"></script>
---

We can get rid of the Pusher gem in the Gemfile and the "pusher.rb" initializer as well.

Now, a replacement for the "pusher.min.js" is Phoenix own "phoenix.js" that comes bundled in "deps/phoenix/web/static/js/phoenix.js". The problem is that it is an ES6 javascript source that Phoenix passes through Brunch to be transpiled back to ES5 in every Phoenix application.

But I am copying this file directly to the Rails repository at "app/assets/javascripts/phoenix.es6". I could change it to ES5 but I decided to go the more difficult path and just add Babel support to Rails Asset Pipeline using [Nando's very helpful tutorial](http://nandovieira.com/using-es6-with-asset-pipeline-on-ruby-on-rails) on the subject. 

The gist goes like this, first we add the dependencies in the Gemfile:

--- ruby
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
---

Babel needs some configuration:

--- ruby
# config/initializers/babel.rb
Rails.application.config.assets.configure do |env|
  babel = Sprockets::BabelProcessor.new(
    'modules'    => 'amd',
    'moduleIds'  => true
  )
  env.register_transformer 'application/ecmascript-6', 'application/javascript', babel
end
---

And for some reason I had to manually redeclare application.js and application.css in the assets initializer:

--- ruby
# config/initializers/assets.rb
...
Rails.application.config.assets.precompile += %w( application.css application.js )
---

We need Almond in order to be able to import the Socket module from the Phoenix javascript package. Now, we change the "application.js":

--- javascript
//= require almond
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require phoenix
//= require_tree .

require(['application/boot']);
---

It require an "app/assets/javascripts/application/boot.es6" file, this is straight from Nando's tutorial:

--- javascript
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
---

And it relies on attributes in the body tag, so we change our layout template:

--- html
<!-- app/views/layouts/application.html.erb -->
...
<body data-route="application/pages/<%= controller.controller_name %>/<%= controller.action_name %>">
---

I didn't mention before but I also have a "HomeController" just to be the root path for the main HTML page, it has a single "index" method and "index.html.erb" template with the message form. So I will have the need for an "application/pages/home/index.es6" inside the "app/assets/javascripts" path:

--- javascript
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
---

This bit is similar to the Pusher javascript handling, but we are getting a bit more information from the meta tags, the "guardian-token" and "guardian-csrf" tokens. Because I was following Daniel's tutorial I also changed the name of the event from "new_message" to just "msg" and the topics now need to have a "public:" prefix in order for the Phoenix's RoomChannel handler to match the public topic name correctly.

First things first. In order for this new javascript to have the correct tokens I had to add the following helper in the views layout:

--- html
...
  <%= csrf_meta_tags %>
  <%= guardian_token_tags %>
</head>
...
---

And this "guardian_token_tags" is again straight from Daniel's tutorial:

--- ruby
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
---

I had to tweak it a bit, specially to get the proper keys from the "secrets.yml" file which now looks like this:

--- yaml
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
---

My local ".env" file looks like this:

---
PUSHER_URL: "localhost:4000"
PUSHER_KEY: "14e86e5fee3335fa88b0"
PUSHER_SECRET: "2b94ff0f07ce9769567f"
PUSHER_CHANNEL: "public:test_chat_channel" 
---

This bit needs more working, I know. I just copied Pusher's key and Pusher's password as KEY and SECRET. This is the bit I mentioned I tweaked in the RoomChannel's authenticate function in the Phoenix side.

Now that I have this in place, I have to change the "PusherEvent" model to trigger the message from the form to the Phoenix's EventsController, like this:

--- ruby
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
---

As I am doing this through SuckerPunch, I am using plain old "Net::HTTP.post()" to post the message to the Phoenix "/events" endpoint. Phoenix will properly authenticate because the "pusher_url" is sending the "PUSHER_KEY:PUSHER_SECRET" as HTTP Basic Auth. It will end up in the "authorization" header and Phoenix will properly authenticate the server side, then it will broadcast to the WebSocket connections subscribed to the topic.

The new javascript will subscribe to the "public:test_chat_channel" topic and listen to the "msg" event. Once it receives the payload, it just formats the message and, again, appends to the same place in the "message-receiver" div tag.

### Conclusion: Further Work

So, with this we have exactly the same behavior than the Pusher version, but now it's under my control.

The idea is for the Phoenix app to have apps, a real authentication for different apps. Then every Rails app I do can just connect to this same Phoenix service.

The next steps include properly implementing the Guardian/JWT pieces, then I can jump to private channels support and add HTTP APIs to list channels in apps and users online in channels.

I will then create a second companion Rails app as an administration dashboard to consume those APIs and be able to create or revoke apps and basic maintenance and reporting. This should be a good enough replacement for a Pusher-like messaging solution that is really fast.
