---
title: Ex Pusher Lite - Part 2 - First Working Core!
date: '2015-12-14T15:04:00-02:00'
slug: ex-pusher-lite-part-2-first-working-core
tags:
- elixir
- phoenix
- pusher
- expusherlite
- english
draft: false
---

In [Part 1](http://www.akitaonrails.com/2015/12/09/ex-pusher-lite-part-1-phoenix-channels-and-rails-apps) I basically started with [Daniel Neighman's](https://labs.opendoor.com/phoenix-on-rails-for-client-push-notifications) tutorial.

In Part 2 I will add the proper mechanisms to make a minimal core that is actually useful and deploy it to Heroku. In order to do that I need to implement the following:

* a simple Administration authentication (a hardcoded admin_username and admin_password will do for now)
* an admin restricted **"/api/admin/apps"** endpoint to manage new Applications. Each Application should have a randomly generated key and secret.
* the existing "/events" endpoint from Part 1 should be moved to **"/api/apps/:app_id/events"** and have access restricted to the authentication of the key and secret of the Application identified as "app_id".
* for now, the Event will just broadcast to the appropriate topic. We want to be able to broadcast to everyone from an Application as well to specific topics within the Application scope. 

As usual, the code for this section will be tagged as **v0.2** in both the [client demo](https://github.com/akitaonrails/pusher_lite_demo/tree/v0.2) and [server-side](https://github.com/akitaonrails/ex_pusher_lite/tree/v0.2) Github repositories.

### The App Resource

If this project of ours is to behave like Pusher.com, we need a way to create new "Applications". Each client connecting to this service will be bound to this Application. Events should be restricted to the Application boundary. This is how we will isolate different clients connecting to the same server. So you can have one core serving several different web applications.

Once a new application is created, the client/consumer web app will have the pair of key and secret tokens that it will use to connect both the server-side triggers as well as the client-side Websocket listeners.

As a disclaimer, at this stage of development I will not implement any sophisticated authentication system such as OAuth2 or JWT. I will save this for posts to follow. For now I will use the Application's key and secret just as simple username and password in an HTTP Basic Auth. This should be good enough for our purposes for the time being.

So, the very first step is to create such an "Application" resource and we can resort to Phoenix's built-in JSON scaffold generator:

```
mix phoenix.gen.json App apps name:string slug:string key:string secret:string active:boolean
```

Most tutorials will show you the "<tt>phoenix.gen.html</tt>" generator, which behaves like Rails's "scaffold", generating HTML templates for each of the CRUD verbs. This is similar but it skips HTML and assumes this is going to be a JSON CRUD API.

We need to manually update the "<tt>web/router.ex</tt>" file like this:

```ruby
# web/router.ex
scope "/api", ExPusherLite do
  pipe_through :api
  post "/apps/:app_slug/events", EventsController, :create
  scope "/admin" do
    resources "/apps", AppController, except: [:new, :edit]
  end
end
```

The "<tt>EventsController</tt>" is the one we implemented in Part 1 and that we will overhaul during this Part 2.

The generator gave us this new "<tt>AppController</tt>", and similarly to Rails' routes, the DSL is remarkably similar here. If you're a Railer I bet you can instantly recognize the routes this DSL is generating.

The generator also created a proper migration for us:

```ruby
# priv/repo/migrations/20151210131528_create_app.exs
defmodule ExPusherLite.Repo.Migrations.CreateApp do
  use Ecto.Migration

  def change do
    create table(:apps) do
      add :name, :string
      add :slug, :string
      add :key, :string
      add :secret, :string
      add :active, :boolean, default: false

      timestamps
    end
    create index(:apps, [:name], unique: true)
    create index(:apps, [:slug], unique: true)
  end
end
```

Again, remarkably similar to ActiveRecord's Migration DSL. Migrations behave as you expect. You must run:

```
mix ecto.create # if you haven't already
mix ecto.migrate
```

This App resource will need the ability to create slugs out of the names (which we will use as "app_id") and also generate random key and secret values. So we must add these dependencies to the "<tt>mix.exs</tt>" file:

```ruby
# mix.exs
defp deps do
  [...,
   {:secure_random, "~> 0.2.0"},
   {:slugger, "~> 0.0.1"}]
end
```

The [final App model](https://github.com/akitaonrails/ex_pusher_lite/blob/v0.2/web/models/app.ex) is quite long, so I will break it down for you:

```ruby
# web/models/app.ex
defmodule ExPusherLite.App do
  use ExPusherLite.Web, :model
  alias ExPusherLite.Repo

  schema "apps" do
    field :name, :string
    field :slug, :string
    field :key, :string
    field :secret, :string
    field :active, :boolean, default: true

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w()
  ...
```

This block declares the model Schema. Be careful if you generate a migration and then change its fields settings: you must remember to update the schema in the model. In my first attempt I didn't include the "slug" field, so I rolled back the database migration (with "<tt>mix ecto.rollback</tt>"), changed the migration to add the "slug" field and re-ran the "<tt>ecto.migrate</tt>" task.

I was puzzled with the model not picking up the new field; after some time I remembered that Ecto models don't attempt to fetch the real database schema and generate accessors dynamically, instead it relies on the explicitly declared schema block as shown above. After I added the new "slug" field in the schema block, then the model would properly use the new field.

```ruby
# web/models/app.ex
...
def get_by_slug(slug) do
  Repo.get_by!(__MODULE__, slug: slug, active: true)
end
def hashed_secret(model) do
  Base.encode64("#{model.key}:#{model.secret}")
end
...
```

These are just helper functions to use in the AppController. The odd bit might be "__MODULE__" but this is just a shortcut for the atom representation of the current module, which is "<tt>ExPusherLite.App</tt>". This is how you make a simple query to the model, it resembles Rails' "<tt>App.get_by(slug: slug, active: true)</tt>".

In Elixir convention, Ecto has functions with and without bangs ("<tt>get_by!</tt>" and "<tt>get_by</tt>"). If you want to catch an error you use the version without bangs and it will return either a "<tt>{:ok, result}</tt>" tuple or a "<tt>{:error, result}</tt>" and you can pattern match them. Or you can use the bang version and it will raise an exception. Depends on what you want to do.

```ruby
# web/models/app.ex
...
def changeset(model, params \\ :empty) do
  model
  |> cast(params, @required_fields, @optional_fields)
  |> validate_length(:name, min: 5, max: 255)
  |> unique_constraint(:name)
  |> generate_key
  |> generate_secret
  |> slugify
  |> unique_constraint(:slug)
end
...
```

Second only to the Schema block I mentioned above, this "<tt>changeset/2</tt>" function is the most important part of a Model.

In Rails you just have the concept of a "Model" which is considered "Fat" because it deals with database operations, business logic and framework hooks all in the same place. In Phoenix you have to deal with at least 3 different concepts:

* You have a **Repo**, which receives a Changeset and uses it to insert or update the designated rows in the database table. You will see "<tt>Repo.get</tt>" or "<tt>Repo.insert</tt>", not "<tt>App.find</tt>" or "<tt>App.save</tt>".
* Then you have the **Changeset** which are just Elixir Maps (the ones with the syntax "%<tt>{key => value}</tt>"). It's just a Hash, a Dictionary, a collection of key-value pairs. A Repo accepts Maps for its operations.
* Finally, you have the **Model** which actually give meaning and context to the raw Changesets. And the function "<tt>changeset/2</tt>" above is the one responsible for receiving a raw Map, piping it through a validation and transformation chain and return a valid Changeset for the Repo to use.

So, in a controller you will usually find code like this:

```ruby
# web/controllers/app_controller.ex
...
def create(conn, %{"app" => app_params}) do
  changeset = App.changeset(%App{}, app_params)
  
  case Repo.insert(changeset) do
    {:ok, app} ->
      conn
      |> ...
    {:error, changeset} ->
      conn
      |> ...
  end
  ...
```

This is how you create a new, validated, changeset and then pass it to the Repo, treating the results in a pattern match block. Just compare the above changeset line with the beginning of the "changeset/2" function:

```ruby
...
def changeset(model, params \\ :empty) do
  model
  |> cast(params, @required_fields, @optional_fields)
  |> validate_length(:name, min: 5, max: 255)
...
```

It maps the "<tt>%App{}</tt>" empty record to the "model" argument and the "app_params" that comes from the request (a map of the format "<tt>%{name => 'foo', active: => 'true'}</tt>") to the argument "params". Then it pipes the model and params to the "<tt>cast/4</tt>" function which will copy the values from the params map to the model map/changeset. And it keep passing the resulting changeset to the following functions, such as "<tt>validated_length/3</tt>" below, and so on. If the chain ends with no exceptions, you end up with a clean, validated changeset that you can just pass to the Repo to blindly insert to the database.

In the above implementation we are chaining filters to generate the key, secret and slug, and this is the implementation as private functions:

```ruby
# web/models/app.ex
...
  defp generate_key(model) do
    if get_field(model, :key) do
      model
    else
      model
      |> put_change(:key, SecureRandom.uuid)
    end
  end

  defp generate_secret(model) do
    if get_field(model, :secret) do
      model
    else
      model
      |> put_change(:secret, SecureRandom.uuid)
    end
  end

  defp slugify(model) do
    if name = get_change(model, :name) do
      model
      |> put_change(:slug, Slugger.slugify_downcase(name))
    else
      model
    end
  end
end
```

The logic is set so new key/secret are generated only if the fields are empty and a new slug is generated only if the name has changes. And this is it, I told you the model code would be a bit large. You can see how to use the Slugger and SecureRandom libraries we added in the "mix.exs" before.

I also want to add the equivalent of a Rails seed file to create a test application so it's easier for new comers to know what to do. Phoenix has seeds and you can implement it like this:

```ruby
# priv/repo/seeds.exs

alias ExPusherLite.App
alias ExPusherLite.Repo

# not using the App.changeset should just avoid all validations and generations
Repo.insert! %App{ slug: "test-app", name: "Test App", key: "test-app-fake-key", secret: "test-app-fake-secret", active: true }
```

Remember how I detailed the role of the "changeset/2" function in creating a clean and validated changeset, which is just a Map? You can skip that function altogether and hand craft your own final Map and pass it to the Repo. The Repo doesn't care if this is a valid Map or not it will just try to insert it into the database regardless. And in this case the App Model avoids us to hardcode keys and secrets, so this is how we do it in a seed file.

We can just run it directly like this:

```
mix run priv/repo/seeds.exs
```

The AppController just need 2 changes. The first is to search the App through the slug field instead of the default 'id' field. This is simple enough, we just replace all calls to "<tt>app = Repo.get!(App, id)</tt>" to "<tt>app = App.get_by_slug(id)</tt>", which is why we implemented this function in the model above.

The second thing is Authentication.

### Adding Authentication

Now that we have an App model that can generate secure random UUIDs for key and secret, I will add a second level of authentication for administrators to be able to create such Apps.

For that I will just hard-code a secret in the config file of the application itself to serve as a development default. Like this:

```ruby
# config/config.exs
...
config :ex_pusher_lite, :admin_authentication,
  username: "pusher_admin_username",
  password: "pusher_admin_password"
...
import_config "#{Mix.env}.exs"
```

You must add this block before the "<tt>import_config</tt>" function. Then you can override those values in the "config/prod.secret.exs" file, for example, like this:

```ruby
# config/prod.secret.exs
...
config :ex_pusher_lite, :admin_authentication,
  username: "14e86e5fee3335fa88b0",
  password: "2b94ff0f07ce9769567f"
```

Of course, generate your own pair of secure username and password and replace it in the production environment if you intend to actually use this. For Heroku, we will still have to tweak this further, so keep this in mind.

Just to make the process easier, I also added the following helper function:

```ruby
# lib/ex_pusher_lite.ex
...
  # Return this applicaton administration Basic HTTP Auth hash
  def admin_secret do
    admin_username = Application.get_env(:ex_pusher_lite, :admin_authentication)[:username]
    admin_password = Application.get_env(:ex_pusher_lite, :admin_authentication)[:password]
    secret = Base.encode64("#{admin_username}:#{admin_password}")
  end
end
```

This is how you fetch the configuration values. I am generating a simple Base64 encoded string out of the username concatenated with the password with a comma, which is what Basic HTTP Auth requires. I will use this admin hash for the "AppController" and each client must provide the key/secret in its own App instance to be able to trigger the "EventsController".

For both controllers I will create a single Authentication Plug, like this:

```ruby
# lib/ex_pusher_lite/authentication.ex
defmodule ExPusherLite.Authentication do
  import Plug.Conn

  alias ExPusherLite.App

  def init(assigns \\ [admin: false]), do: assigns

  def call(conn, assigns) do
    token =
      if assigns[:admin] do
        ExPusherLite.admin_secret
      else
        params = fetch_query_params(conn).params
        params["app_slug"] |> App.get_by_slug |> App.hashed_secret
      end

    "Basic " <> auth_token = hd(get_req_header(conn, "authorization"))
    if Plug.Crypto.secure_compare(auth_token, token) do
      conn
    else
      conn |> send_resp(401, "") |> halt
    end
  end
end 
```

As I explained in previous articles, a Plug is like a chainable Rails Middleware or even a Rack application. It must have a single "<tt>call/2</tt>" that receives a Plug.Conn structure and returns it back, allowing to form a chain/pipeline of Plugs.

We check if we want to compare with the Admin token or the App token and then retrieve the Basic HTTP authorization token that's in the HTTP request connection structure (we retrive individual header values through the "<tt>get_req_header/2</tt>" function). Finally we make a secure compare between the tokens.

To enable this plug in the controllers we just add it like this:

```ruby
# web/controllers/app_controller.ex
defmodule ExPusherLite.AppController do
  use ExPusherLite.Web, :controller

  alias ExPusherLite.App
  plug ExPusherLite.Authentication, [admin: true]
  ...
```

```ruby
 defmodule ExPusherLite.EventsController do
   use ExPusherLite.Web, :controller

-  plug :authenticate
+  plug ExPusherLite.Authentication
   ...
```

In Part 1 we had a simpler "<tt>plug :authenticate</tt>" in the EventsController. We can remove it and also the "<tt>authenticate/2</tt>" function. We just refactored it into a better function that also serves administration authentication now, but the idea is the same.

This is it: the basics for API authentication. Again, this is not the best solution as the username/password pair goes in the URL and it's open to man-in-the-middle attacks. SSL only encrypts the HTTP body but the URL is still open.

For example, if an administrator wants to create a new application, he must do the following:

```
curl --data "app[name]=foo-app" http://pusher_admin_username:pusher_admin_password@localhost:4000/api/admin/apps
```

And this would be one example of the resulting JSON representation of the new app:

```
{"data":{"slug":"foo-app","secret":"8ef69064-0d7e-c9ef-ac14-b6b1db303e7a","name":"foo-app","key":"9400ad21-eed8-117a-bce5-845262e0a09e","id":5,"active":true}}%
```

With this new key and secret in hand, we can update our client demo to make use of the new app.

### Configuring the Client Demo

We must start by adding the proper Application details in the "<tt>.env</tt>" file:

```
PUSHER_URL: "localhost:4000"
PUSHER_APP_ID: "foo-app"
PUSHER_KEY: "9400ad21-eed8-117a-bce5-845262e0a09e"
PUSHER_SECRET: "8ef69064-0d7e-c9ef-ac14-b6b1db303e7a"
PUSHER_CHANNEL: "foo-topic"
```

We must also tweak the "<tt>config/secrets.yml</tt>" to reflect the new metadata (development, test, and production must follow this):

```
development:
  secret_key_base: ded7c4a2a298c1b620e462b50c9ca6ccb60130e27968357e76cab73de9858f14556a26df885c8aa5004d0a7ca79c0438e618557275bdb28ba67a0ffb0c268056
  pusher_url: <%= ENV['PUSHER_URL'] %>
  pusher_app_id: <%= ENV['PUSHER_APP_ID'] %>
  pusher_key: <%= ENV['PUSHER_KEY'] %>
  pusher_secret: <%= ENV['PUSHER_SECRET'] %>
  pusher_channel: <%= ENV['PUSHER_CHANNEL'] %>
  ...
```

And we can create an initializer to make it easier to use this metadata properly:

```ruby
# config/initializers/pusher_lite.rb
module PusherLite
  def self.uri
    key    = Rails.application.secrets.pusher_key
    secret = Rails.application.secrets.pusher_secret
    app_id = Rails.application.secrets.pusher_app_id
    url    = Rails.application.secrets.pusher_url

    uri = "http://#{key}:#{secret}@#{url}/api/apps/#{app_id}/events"
    URI.parse(uri)
  end
end 
```

Again, the Rails app will trigger the ExPusherLite server using the Basic HTTP Auth. Do not be fooled into thinking this is "secure", it just "feels a bit secure through obscurity". You have been warned, wait for the next articles on this subject. But this is usable in controlled environments.

To finalize the upgrades, we must change the client-side access to the new metadata, first changing the application layout:

```html
<!-- app/views/layouts/application.html.erb -->
...
+  <meta name="pusher_host" content="<%= Rails.application.secrets.pusher_url %>">
-  <meta name="pusher_key" content="<%= Rails.application.secrets.pusher_key %>">
+  <meta name="pusher_app_id" content="<%= Rails.application.secrets.pusher_app_id %>">
   <meta name="pusher_channel" content="<%= Rails.application.secrets.pusher_channel %>">
...
```

The javascript "<tt>index.es6</tt>" fetches from this meta headers, so we must change them there:

```javascript
# app/assets/javascripts/application/pages/home/index.es6
...
     let guardianToken = $("meta[name=guardian-token]").attr("content")
     let csrfToken     = $("meta[name=guardian-csrf]").attr("content")
 
+    let pusherHost    = $("meta[name=pusher_host]").attr("content")
-    let pusherKey     = $("meta[name=pusher_key]").attr("content")
+    let pusherApp     = $("meta[name=pusher_app_id]").attr("content")
     let pusherChannel = $("meta[name=pusher_channel]").attr("content")
 
-    let socket = new Socket("ws://localhost:4000/socket", {
+    let socket = new Socket(`ws://${pusherHost}/socket`, {
       params: { guardian_token: guardianToken, csrf_token: csrfToken }
     })
     socket.connect()
 
     // Now that you are connected, you can join channels with a topic:
-    let channel = socket.channel(pusherChannel, {})
+    let channel = socket.channel(`public:${pusherApp}`, {})
     channel.join()
       .receive("ok", resp => { console.log("Joined successfully", resp) })
       .receive("error", resp => { console.log("Unable to join", resp) })
 
-    channel.on("msg", data => {
+    channel.on(`${pusherChannel}:msg`, data => {
       let new_line = `<p><strong>${data.name}<strong>: ${data.message}</p>`
       $(".message-receiver").append(new_line)
     })
+
+    channel.on("msg", data => {
+      let new_line = `<p><strong>Broadcast to all channels</strong>: ${data.message}</p>`
+      $(".message-receiver").append(new_line)
+    })
   }
```

One important modification from Part 1 is that the WebSocket host was hardcoded to "localhost" and here we are making it configurable through the meta tags. Right now, for localhost tests, we are using the plain "ws://" protocol but when we deploy to Heroku we will change it to "wss://" for SSL. Same thing for the "PusherLite" initializer. Keep that in mind.

Now it's subscribing to a different format of topic/channel. In Part 1 it would be something like: "<tt>public:test_channel</tt>" now we are listening to "<tt>public:foo-app</tt>", so the application is the Websocket subscription "topic".

Then we are changing the socket listener to listen for 2 different events. The first one is in the format "<tt>test_channel:msg</tt>". So this is how we must now send messages to an specific "channel" within an "app/topic".

And last we still listen to the old "msg" event, but this serves as a "broadcast" event for all connected clients subscribed to this particular "foo-app" Application. Now web clients can listen to specific "channels" within the "app" but also receive system wide "broadcast" messages. This is a big improvement and it didn't require much on the Javascript side.

But what more does it take to make this **"channel-only and broadcast"** system work? First, we start changing the web form to allow a user to choose between sending a channel-only message or a broadcast, like this:

```html
<!-- app/views/home/index.html.erb -->
...
     <%= f.text_field :name, placeholder: "Name" %>
     <%= f.text_field :message, placeholder: "Message" %>
+    <%= f.check_box :broadcast %>
     <%= f.submit "Send message", class: "pure-button pure-button-primary" %>
   </fieldset>
...
```

Now the EventsController must accept this new parameter:

```ruby
# app/controllers/events_controller.rb
...
  def event_params
    params.require(:pusher_event).permit(:name, :message, :broadcast)
  end
end
```

Finally, the Model must use this new information before posting to the ExPusherLite server:

```ruby
# app/models/pusher_event.rb
class PusherEvent
  include ActiveModel::Model

  attr_accessor :name, :message, :broadcast
  validates :name, :message, presence: true

  def save
    topic = if broadcast == "1"
              "#general"
            else
              Rails.application.secrets.pusher_channel
            end

    Net::HTTP.post_form(PusherLite.uri, {
      "topic" => topic,
      "event" => "msg",
      "scope" => "public",
      "payload" => {"name" => name, "message" => message}.to_json
    })
  end
end
```

I am just assuming a hard-coded "<tt>#general</tt>" string to serve as the broadcast trigger for the server. Now we must make the server accept this new protocol schema, so let's go back to Elixir.

First we must start with the counterpart for the previous POST trigger, <tt>ExPusherLite.EventsController</tt>:

```ruby
# web/controllers/events_controller.ex
 defmodule ExPusherLite.EventsController do
   use ExPusherLite.Web, :controller
 
-  plug :authenticate
+  plug ExPusherLite.Authentication
 
-  def create(conn, params) do
-    topic = params["topic"]
-    event = params["event"]
+  def create(conn, %{"app_slug" => app_slug, "event" => event, "topic" => topic, "scope" => scope} = params) do
     message = (params["payload"] || "{}") |> Poison.decode!
-    ExPusherLite.Endpoint.broadcast! topic, event, message
+    topic_event =
+      if topic == "#general" do
+        event
+      else
+        "#{topic}:#{event}"
+      end
+    ExPusherLite.Endpoint.broadcast! "#{scope}:#{app_slug}", topic_event, message
     json conn, %{}
   end
   ...
```

The first difference is that I am pattern matching from the arguments directly to the "topic" and "event" variables. This function is also aware of the "<tt>#general</tt>" string the client can send to indicate an app-wide broadcast. And the new topic is the concatenation of "topic" and "event" to allow for "channel-only" messages.

To connect this all to the WebSocket handler, we must make the following changes:

```ruby
# web/channels/room_channel.ex
-  def handle_in("msg", payload, socket = %{ topic: "public:" <> _ }) do
-    broadcast socket, "msg", payload
+  def handle_in(topic_event, payload, socket = %{ topic: "public:" <> _ }) do
+    broadcast socket, topic_event, payload
     { :noreply, socket }
   end
 
-  def handle_in("msg", payload, socket) do
+  def handle_in(topic_event, payload, socket) do
     claims = Guardian.Channel.claims(socket)
     if permitted_topic?(claims[:publish], socket.topic) do
-      broadcast socket, "msg", payload
+      broadcast socket, topic_event, payload
       { :noreply, socket }
   ...
```

Now, the Channel does not pattern match on a specific event, it let it through without further validation, trusting that the EventsController is doing the right thing. I will come back to this piece for improvements in the future, possibly.

### Deploying our first Phoenix app to Heroku!

In this section we will just follow the [official documentation](http://www.phoenixframework.org/docs/heroku), so read it if you want more details. 

Let's get started:

```
heroku apps:create your-expusherlite --buildpack "https://github.com/HashNuke/heroku-buildpack-elixir.git"
heroku buildpacks:add https://github.com/gjaldon/heroku-buildpack-phoenix-static.git
```

I am naming the application "your-expusherlite" but you should change it to your own name, of course. And the rest of the configuration data are all examples that you must change for you own needs.

Heroku relies on environment variables. So we start by erasing "<tt>config/prod.secret.exs</tt>" and change "<tt>config/prod.exs</tt>" to look like this:

```ruby
config :ex_pusher_lite, ExPusherLite.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "your-expusherlite.herokuapp.com", port: 443], force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Configure your database
config :ex_pusher_lite, ExPusherLite.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: 20

config :ex_pusher_lite, :admin_authentication,
  username: System.get_env("PUSHER_ADMIN_USERNAME"),
  password: System.get_env("PUSHER_ADMIN_PASSWORD")

# remove this line:
# import_config "prod.secret.exs"
```

Now we must configure the environment variavles "SECRET_KEY_BASE", "PUSHER_ADMIN_USERNAME" and "PUSHER_ADMIN_PASSWORD". Use the included "<tt>mix phoenix.gen.secret</tt>" to generate those.

```
heroku config:set SECRET_KEY_BASE="`mix phoenix.gen.secret`"
heroku config:set PUSHER_ADMIN_USERNAME="FPO0QUkqbAP6EGjElqBzDQuMs8bhFS3"
heroku config:set PUSHER_ADMIN_PASSWORD="n78DPGmK3DBQy8YAVyshiGqcXjjSXSD"
```

Then it's just a matter of waiting for the good old "<tt>git push heroku master</tt>" to finish compiling everything in the first time. And because this is the first deploy you should not forget to run "<tt>heroku run mix ecto.migrate</tt>" to create the database table.

Now, if I did everything right, as an Administrator that knows the above hardcoded secrets I should be able to create a new Application like this:

```
curl --data "app[name]=shiny-new-app" https://FPO0QUkqbAP6EGjElqBzDQuMs8bhFS3:n78DPGmK3DBQy8YAVyshiGqcXjjSXSD@your-expusherlite.herokuapp.com/api/admin/apps
```

And this is the result I got!

```
{"data":{"slug":"shiny-new-app","secret":"42560373-0fe1-506e-28ca-35ab5221fb3d","name":"shiny-new-app","key":"958c16e7-ab93-dac0-0fc6-6cb864e26358","id":1,"active":true}}
```

Great, now that we have a valid Application key and secret we can configure our Rails Client Demo and deploy it to Heroku as well.

### Deploying the Rails Client to Heroku

This is a simple Rails application, we can just create the app and deploy right away:

```
heroku create your-expusherlite-client
heroku config:set PUSHER_URL=your-expusherlite.herokuapp.com
heroku config:set PUSHER_APP_ID=shiny-new-app
heroku config:set PUSHER_KEY=958c16e7-ab93-dac0-0fc6-6cb864e26358
heroku config:set PUSHER_SECRET=42560373-0fe1-506e-28ca-35ab5221fb3d
heroku config:set PUSHER_CHANNEL=shiny-new-topic
git push heroku master
```

I'm assuming the readers of this post already know how to configure a Rails app properly for Heroku. Just to mention it, I configure this app with the 12 factor and Puma gems and added a proper Procfile. Another very small change was changing the "pusher_lite.rb" initializer to create a URI with "https" because the ExPusherLite we deployed to production requires SSL by default.

There is one more caveat. Being led by experienced web programmers, they made sure that, unlike this bare bone exercise here, the Phoenix framework itself is secure. One such example is to disallow Websocket connections from different hosts.

Out of the box, the "phoenix.js" Socket will fail connection when we try to connect from the "your-expusherlite-client.herokuapp.com" Rails app host to the Phoenix app in "your-expusherlite.herokuapp.com" with the following error:

```
WebSocket connection to 'wss://your-expusherlite.herokuapp.com/socket/websocket?guardian_token=N_YCG6hGK7…iOlsicHVibGljOioiXX0._j6s2LiaKde9rBhnTMxDkm0XV5u89pNh1AdLFY6Rlt8&vsn=1.0.0' failed: Error during WebSocket handshake: Unexpected response code: 403
```

And in the Phoenix log we will see this very helpful message:

```
[error] Could not check origin for Phoenix.Socket transport.

This happens when you are attempting a socket connection to
a different host than the one configured in your config/
files. For example, in development the host is configured
to "localhost" but you may be trying to access it from
"127.0.0.1". To fix this issue, you may either:

  1. update [url: [host: ...]] to your actual host in the
     config file for your current environment (recommended)

  2. pass the :check_origin option when configuring your
     endpoint or when configuring the transport in your
     UserSocket module, explicitly outlining which origins
     are allowed:

        check_origin: ["https://example.com",
                       "//another.com:888", "//other.com"]
```

Unless you know what a [Cross-Site Web Socket Hijacking](https://www.christian-schneider.net/CrossSiteWebSocketHijacking.html) you will prefer to keep the default settings as they are. In a green-field Phoenix app, the Web part will connect to the Web Socket in the same app and, therefore, in the same host, so this is not an issue.

In this case I am making a separated micro-service to mimick Pusher.com behavior so it should be able to accept Web Socket connections from different hosts.

If you control the applications being created, you will likely prefer to make the "<tt>check_origin</tt>" setting read from your database for the exact hosts. As a feature for next time I could add a "host" field in the "App" model and use it to validate connections in the transport configuration. For the time being I will just make it accept any hosts:

```
# web/channels/user_socket.ex
defmodule ExPusherLite.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "*", ExPusherLite.RoomChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket, check_origin: false
  ...
```

And this is it! Now the Rails app should be able to connect and send messages! And you should be able to create any number of new apps and connect all of them to this same service.

![Final Heroku Client](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/534/big_Screenshot_from_2015-12-14_14_58_22.png)

### Conclusion

Right now, we have a functional, albeit bare-bone, Pusher.com clone that will work for any number of use cases where Pusher.com would be used.

As I warned many times before, the security part is still flaky and needs working. I will still extend on what Daniel began with Guardian to authenticate Web Socket users to private channels as well. And the core should also receive auditing and reporting capabilities (to be able to report usage, number of active connections, throughput of events, keep at least a short history of events so new connections can retrieve the last sent messages, and so on).

But from here it's a matter of adding features to an already working core. And this is nothing more than Phoenix out-of-the-box without too much added on top of it! It says a lot of the current state of maturity of this very capable framework.

In terms of performance, for this very simple example, I spinned up 1 free Heroku dyno for each app.

The Rails app is able to respond to the front-end user interface in around 2ms. And the Sucker Punch job - which does the heavy HTTP POST to ExPusherLite - takes in the order of 30ms or less.

The Phoenix server receives the HTTP POST and performs the broadcast in around less than 6ms. Also quite fast. The times will vary a lot because I believe the free dyno is not only slow but also stays in highly shared metal boxes, getting impact from other neighbor apps running in the same box.

Because we already have an administrative API to create and manage apps (create new ones, delete, update, etc) we can already create a separated application in any other framework to make a dashboard for admins or for a self-serving front-end for developers to register new apps and receive key/secret pair to add in their own applications.

Both the ExPusherLite server and the demo client are deployed in Heroku and you can test the client right now [clicking here](https://expusherlite-client.herokuapp.com/). The admin keys are different from what I showed in this post, of course, so you won't be able to create new apps, but you can deploy it yourself to your own environment.
