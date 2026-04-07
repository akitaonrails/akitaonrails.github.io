---
title: "Ex Pusher Lite - Parte 2 - O Primeiro Core Funcional!"
date: '2015-12-14T15:04:00-02:00'
slug: ex-pusher-lite-parte-2-o-primeiro-core-funcional
translationKey: ex-pusher-lite-part-2
aliases:
- /2015/12/14/ex-pusher-lite-part-2-first-working-core/
tags:
- elixir
- phoenix
- pusher
- expusherlite
- traduzido
draft: false
---

Na [Parte 1](http://www.akitaonrails.com/2015/12/09/ex-pusher-lite-parte-1-phoenix-channels-e-aplicacoes-rails) eu basicamente comecei a partir do tutorial do [Daniel Neighman](https://labs.opendoor.com/phoenix-on-rails-for-client-push-notifications).

Nesta Parte 2 vou adicionar os mecanismos necessários para ter um core mínimo que seja realmente útil e fazer deploy no Heroku. Para isso preciso implementar o seguinte:

* uma autenticação simples de Administração (um admin_username e admin_password hardcoded já resolvem por enquanto)
* um endpoint **"/api/admin/apps"** restrito ao admin para gerenciar novas Aplicações. Cada Aplicação deve ter uma key e um secret gerados aleatoriamente.
* o endpoint "/events" da Parte 1 deve ser movido para **"/api/apps/:app_id/events"** e ter o acesso restrito pela autenticação da key e secret da Aplicação identificada como "app_id".
* por enquanto, o Event vai apenas fazer broadcast no tópico apropriado. Queremos poder fazer broadcast pra todo mundo de uma Aplicação e também pra tópicos específicos dentro do escopo daquela Aplicação.

Como de costume, o código desta seção vai estar marcado com a tag **v0.2** tanto no repositório do [client demo](https://github.com/akitaonrails/pusher_lite_demo/tree/v0.2) quanto no [server-side](https://github.com/akitaonrails/ex_pusher_lite/tree/v0.2) no Github.

### O Resource App

Se este nosso projeto vai se comportar como o Pusher.com, precisamos de uma forma de criar novas "Aplicações". Cada cliente que se conecta a esse serviço vai estar atrelado a essa Aplicação. Os Events ficam restritos à fronteira da Aplicação. É assim que vamos isolar os diferentes clientes que se conectam ao mesmo servidor. Então você pode ter um único core servindo várias aplicações web diferentes.

Quando uma nova aplicação é criada, o web app cliente/consumidor recebe o par de tokens key e secret que vai usar tanto para os triggers do lado servidor quanto para os listeners de Websocket no lado cliente.

Como aviso prévio, neste estágio do desenvolvimento eu não vou implementar nenhum sistema sofisticado de autenticação como OAuth2 ou JWT. Vou deixar isso pra posts futuros. Por enquanto vou usar a key e o secret da Aplicação como simples username e password num HTTP Basic Auth. Por ora isso já basta pros nossos propósitos.

Então, o primeiro passo é criar esse resource "Application" e podemos recorrer ao gerador de scaffold JSON que já vem com o Phoenix:

```
mix phoenix.gen.json App apps name:string slug:string key:string secret:string active:boolean
```

A maioria dos tutoriais mostra o gerador "<tt>phoenix.gen.html</tt>", que se comporta como o "scaffold" do Rails, gerando templates HTML pra cada um dos verbos CRUD. Esse aqui é parecido mas pula o HTML e assume que vai ser uma API CRUD em JSON.

Precisamos atualizar manualmente o arquivo "<tt>web/router.ex</tt>" assim:

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

O "<tt>EventsController</tt>" é aquele que implementamos na Parte 1 e que vamos refazer durante esta Parte 2.

O gerador nos deu esse novo "<tt>AppController</tt>" e, assim como nas rotas do Rails, a DSL aqui é notavelmente parecida. Se você é um Railer aposto que reconhece de cara as rotas que essa DSL está gerando.

O gerador também criou uma migration apropriada pra gente:

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

De novo, notavelmente parecido com a DSL de Migration do ActiveRecord. Migrations se comportam exatamente como você espera. Você precisa rodar:

```
mix ecto.create # se ainda não tiver feito isso
mix ecto.migrate
```

Este resource App vai precisar gerar slugs a partir dos nomes (que vamos usar como "app_id") e também gerar valores aleatórios para key e secret. Então temos que adicionar essas dependências no arquivo "<tt>mix.exs</tt>":

```ruby
# mix.exs
defp deps do
  [...,
   {:secure_random, "~> 0.2.0"},
   {:slugger, "~> 0.0.1"}]
end
```

O [model App final](https://github.com/akitaonrails/ex_pusher_lite/blob/v0.2/web/models/app.ex) é bem grande, então vou destrinchar pra vocês:

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

Esse bloco declara o Schema do model. Cuidado quando você gera uma migration e depois muda as configurações dos campos: você precisa lembrar de atualizar o schema no model. Na minha primeira tentativa eu não incluí o campo "slug", então fiz rollback da migration ("<tt>mix ecto.rollback</tt>"), mudei a migration pra adicionar o campo "slug" e rodei a task "<tt>ecto.migrate</tt>" de novo.

Fiquei intrigado porque o model não estava pegando o novo campo; depois de um tempo lembrei que models do Ecto não tentam buscar o schema real do banco e gerar accessors dinamicamente, mas dependem do bloco de schema declarado explicitamente como mostrado acima. Depois que adicionei o campo "slug" no bloco de schema, o model passou a usar o novo campo direitinho.

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

Essas são apenas funções helper pra usar no AppController. A parte estranha talvez seja "__MODULE__", mas isso é só um atalho pra representação em atom do módulo atual, que é "<tt>ExPusherLite.App</tt>". É assim que se faz uma query simples ao model, lembra muito o "<tt>App.get_by(slug: slug, active: true)</tt>" do Rails.

Por convenção do Elixir, o Ecto tem funções com e sem bang ("<tt>get_by!</tt>" e "<tt>get_by</tt>"). Se você quiser capturar um erro, usa a versão sem bang e ela retorna ou uma tupla "<tt>{:ok, result}</tt>" ou "<tt>{:error, result}</tt>" e você pode fazer pattern match. Ou usa a versão com bang e ela levanta uma exception. Depende do que você quer fazer.

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

Atrás apenas do bloco de Schema que mencionei acima, esta função "<tt>changeset/2</tt>" é a parte mais importante de um Model.

No Rails você tem só o conceito de "Model", que é considerado "Fat" porque cuida de operações de banco, lógica de negócio e hooks do framework tudo no mesmo lugar. No Phoenix você lida com pelo menos 3 conceitos diferentes:

* Você tem um **Repo**, que recebe um Changeset e usa pra inserir ou atualizar as linhas designadas na tabela do banco. Você vai ver "<tt>Repo.get</tt>" ou "<tt>Repo.insert</tt>", e não "<tt>App.find</tt>" ou "<tt>App.save</tt>".
* Aí você tem o **Changeset**, que são apenas Maps do Elixir (aqueles com a sintaxe "%<tt>{key => value}</tt>"). É só um Hash, um Dictionary, uma coleção de pares chave-valor. Um Repo aceita Maps pras suas operações.
* Por fim, você tem o **Model**, que de fato dá significado e contexto aos Changesets crus. E a função "<tt>changeset/2</tt>" acima é a responsável por receber um Map cru, passá-lo por uma cadeia de validação e transformação e devolver um Changeset válido pro Repo usar.

Então, num controller você normalmente vai encontrar código assim:

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

É assim que você cria um changeset novo, validado, e passa pro Repo, tratando os resultados num bloco de pattern match. Compare a linha do changeset acima com o início da função "changeset/2":

```ruby
...
def changeset(model, params \\ :empty) do
  model
  |> cast(params, @required_fields, @optional_fields)
  |> validate_length(:name, min: 5, max: 255)
...
```

Ela mapeia o registro vazio "<tt>%App{}</tt>" pro argumento "model" e o "app_params" que vem do request (um map do formato "<tt>%{name => 'foo', active: => 'true'}</tt>") pro argumento "params". Depois encanou o model e os params na função "<tt>cast/4</tt>", que vai copiar os valores do map de params pro map/changeset do model. E vai passando o changeset resultante pras funções seguintes, como o "<tt>validated_length/3</tt>" abaixo, e assim por diante. Se a cadeia termina sem exceptions, você tem no final um changeset limpo, validado, que é só passar pro Repo enfiar no banco sem pensar.

Na implementação acima estamos encadeando filtros pra gerar key, secret e slug, e essa é a implementação como funções privadas:

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

A lógica é tal que key/secret novos são gerados apenas se os campos estiverem vazios e um slug novo é gerado apenas se o name tiver mudado. E é isso, eu disse que o código do model ia ser meio grande. Dá pra ver como usar as bibliotecas Slugger e SecureRandom que adicionamos no "mix.exs" antes.

Eu também quero adicionar o equivalente de um arquivo de seed do Rails pra criar uma aplicação de teste, assim quem está chegando agora sabe o que fazer. O Phoenix tem seeds e você pode implementar assim:

```ruby
# priv/repo/seeds.exs

alias ExPusherLite.App
alias ExPusherLite.Repo

# não usar o App.changeset pula todas as validações e gerações
Repo.insert! %App{ slug: "test-app", name: "Test App", key: "test-app-fake-key", secret: "test-app-fake-secret", active: true }
```

Lembra como detalhei o papel da função "changeset/2" em criar um changeset limpo e validado, que é só um Map? Você pode pular essa função inteira, montar seu próprio Map final na mão e passar pro Repo. O Repo não liga se o Map é válido ou não, ele simplesmente tenta inserir no banco. E neste caso o Model do App nos impede de hardcodar keys e secrets, então é assim que fazemos num arquivo de seed.

Dá pra rodar diretamente assim:

```
mix run priv/repo/seeds.exs
```

O AppController só precisa de 2 mudanças. A primeira é buscar o App pelo campo slug em vez do campo padrão 'id'. É bem simples, basta substituir todas as chamadas de "<tt>app = Repo.get!(App, id)</tt>" por "<tt>app = App.get_by_slug(id)</tt>", que é justamente por isso que implementamos essa função no model acima.

A segunda coisa é Autenticação.

### Adicionando Autenticação

Agora que temos um model App que consegue gerar UUIDs aleatórios seguros pra key e secret, vou adicionar um segundo nível de autenticação pra administradores conseguirem criar esses Apps.

Pra isso vou simplesmente hardcodar um secret no arquivo de config da aplicação como default de desenvolvimento. Assim:

```ruby
# config/config.exs
...
config :ex_pusher_lite, :admin_authentication,
  username: "pusher_admin_username",
  password: "pusher_admin_password"
...
import_config "#{Mix.env}.exs"
```

Você precisa adicionar esse bloco antes da função "<tt>import_config</tt>". Aí você pode sobrescrever esses valores no arquivo "config/prod.secret.exs", por exemplo, assim:

```ruby
# config/prod.secret.exs
...
config :ex_pusher_lite, :admin_authentication,
  username: "14e86e5fee3335fa88b0",
  password: "2b94ff0f07ce9769567f"
```

Claro, gere o seu próprio par seguro de username e password e substitua no ambiente de produção, se for usar isso pra valer. Pro Heroku ainda vamos ajustar isso um pouco mais, então fique atento.

Pra facilitar o processo, eu também adicionei o seguinte helper:

```ruby
# lib/ex_pusher_lite.ex
...
  # Retorna o hash de Basic HTTP Auth de administração desta aplicação
  def admin_secret do
    admin_username = Application.get_env(:ex_pusher_lite, :admin_authentication)[:username]
    admin_password = Application.get_env(:ex_pusher_lite, :admin_authentication)[:password]
    secret = Base.encode64("#{admin_username}:#{admin_password}")
  end
end
```

É assim que você busca os valores de configuração. Estou gerando uma string Base64 simples a partir do username concatenado com o password com uma vírgula, que é o que o Basic HTTP Auth requer. Vou usar esse hash de admin pro "AppController" e cada cliente vai precisar fornecer a key/secret da sua própria instância de App pra disparar o "EventsController".

Pros dois controllers vou criar um único Plug de Autenticação, assim:

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

Como expliquei em artigos anteriores, um Plug é como um Middleware encadeável do Rails ou até uma aplicação Rack. Ele precisa ter uma única "<tt>call/2</tt>" que recebe uma estrutura Plug.Conn e devolve ela de volta, permitindo formar uma cadeia/pipeline de Plugs.

Verificamos se queremos comparar com o token de Admin ou o token do App e aí pegamos o token de autorização Basic HTTP que está na estrutura de conexão do request HTTP (recuperamos valores individuais do header pela função "<tt>get_req_header/2</tt>"). Por fim, fazemos uma comparação segura entre os tokens.

Pra habilitar esse plug nos controllers basta adicionar assim:

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

Na Parte 1 tínhamos um "<tt>plug :authenticate</tt>" mais simples no EventsController. Podemos remover ele e também a função "<tt>authenticate/2</tt>". Refatoramos tudo pra uma função melhor que agora também serve à autenticação de administração, mas a ideia é a mesma.

É isso: o básico de autenticação de API. De novo, esta não é a melhor solução porque o par username/password vai na URL e fica aberto a ataques de man-in-the-middle. SSL só criptografa o body do HTTP mas a URL fica aberta.

Por exemplo, se um administrador quiser criar uma nova aplicação, precisa fazer assim:

```
curl --data "app[name]=foo-app" http://pusher_admin_username:pusher_admin_password@localhost:4000/api/admin/apps
```

E este seria um exemplo da representação JSON resultante do novo app:

```
{"data":{"slug":"foo-app","secret":"8ef69064-0d7e-c9ef-ac14-b6b1db303e7a","name":"foo-app","key":"9400ad21-eed8-117a-bce5-845262e0a09e","id":5,"active":true}}%
```

Com essa nova key e secret em mãos, podemos atualizar nosso client demo pra usar o novo app.

### Configurando o Client Demo

Vamos começar adicionando os detalhes apropriados da Aplicação no arquivo "<tt>.env</tt>":

```
PUSHER_URL: "localhost:4000"
PUSHER_APP_ID: "foo-app"
PUSHER_KEY: "9400ad21-eed8-117a-bce5-845262e0a09e"
PUSHER_SECRET: "8ef69064-0d7e-c9ef-ac14-b6b1db303e7a"
PUSHER_CHANNEL: "foo-topic"
```

Também temos que ajustar o "<tt>config/secrets.yml</tt>" pra refletir os novos metadados (development, test e production precisam seguir isso):

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

E podemos criar um initializer pra facilitar o uso desses metadados:

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

De novo, o app Rails vai disparar o servidor ExPusherLite usando o Basic HTTP Auth. Não se iluda achando que isso é "seguro", apenas "parece um pouco seguro pela obscuridade". Você foi avisado, espere os próximos artigos sobre o assunto. Mas isso é utilizável em ambientes controlados.

Pra finalizar os upgrades, temos que mudar o acesso do lado cliente aos novos metadados, primeiro mudando o layout da aplicação:

```html
<!-- app/views/layouts/application.html.erb -->
...
+  <meta name="pusher_host" content="<%= Rails.application.secrets.pusher_url %>">
-  <meta name="pusher_key" content="<%= Rails.application.secrets.pusher_key %>">
+  <meta name="pusher_app_id" content="<%= Rails.application.secrets.pusher_app_id %>">
   <meta name="pusher_channel" content="<%= Rails.application.secrets.pusher_channel %>">
...
```

O javascript "<tt>index.es6</tt>" busca esses meta headers, então temos que mudar lá também:

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
 
     // Agora que está conectado, dá pra entrar em canais com um topic:
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

Uma modificação importante em relação à Parte 1 é que o host do WebSocket estava hardcoded em "localhost" e aqui estamos tornando ele configurável via meta tags. No momento, pros testes em localhost, estamos usando o protocolo "ws://" puro, mas quando fizermos deploy no Heroku vamos mudar pra "wss://" pra ter SSL. Mesma coisa pro initializer "PusherLite". Tenha isso em mente.

Agora ele está se inscrevendo num formato diferente de topic/channel. Na Parte 1 era algo como: "<tt>public:test_channel</tt>", e agora estamos escutando em "<tt>public:foo-app</tt>", então a aplicação é o "topic" da inscrição no Websocket.

Aí estamos mudando o socket listener pra escutar 2 events diferentes. O primeiro está no formato "<tt>test_channel:msg</tt>". É assim que agora temos que enviar mensagens pra um "channel" específico dentro de um "app/topic".

E por último ainda escutamos o velho event "msg", mas ele agora serve como um event de "broadcast" pra todos os clientes conectados inscritos nessa Aplicação "foo-app" em particular. Agora os clientes web podem escutar "channels" específicos dentro do "app" mas também receber mensagens de "broadcast" globais. Isso é uma melhoria grande e quase não exigiu coisa do lado do Javascript.

Mas o que mais é preciso pra fazer esse sistema **"channel-only and broadcast"** funcionar? Primeiro, começamos mudando o formulário web pra deixar o usuário escolher entre enviar uma mensagem só de canal ou um broadcast, assim:

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

Agora o EventsController precisa aceitar esse novo parâmetro:

```ruby
# app/controllers/events_controller.rb
...
  def event_params
    params.require(:pusher_event).permit(:name, :message, :broadcast)
  end
end
```

Por fim, o Model precisa usar essa nova informação antes de fazer o post pro servidor ExPusherLite:

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

Estou apenas assumindo uma string hardcoded "<tt>#general</tt>" pra servir de gatilho de broadcast pro servidor. Agora temos que fazer o servidor aceitar esse novo schema de protocolo, então vamos voltar pro Elixir.

Primeiro temos que começar com a contraparte do trigger POST anterior, <tt>ExPusherLite.EventsController</tt>:

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

A primeira diferença é que estou fazendo pattern match direto dos argumentos pras variáveis "topic" e "event". Essa função também sabe da string "<tt>#general</tt>" que o cliente pode enviar pra indicar um broadcast global do app. E o novo topic é a concatenação de "topic" e "event" pra permitir mensagens "channel-only".

Pra ligar tudo isso ao handler de WebSocket, temos que fazer as seguintes mudanças:

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

Agora o Channel já não faz pattern match num event específico, deixa passar sem mais validação, confiando que o EventsController está fazendo a coisa certa. Talvez eu volte nessa parte pra melhorias no futuro.

### Fazendo deploy do nosso primeiro app Phoenix no Heroku!

Nesta seção vamos só seguir a [documentação oficial](http://www.phoenixframework.org/docs/heroku), então leia lá se quiser mais detalhes.

Vamos começar:

```
heroku apps:create your-expusherlite --buildpack "https://github.com/HashNuke/heroku-buildpack-elixir.git"
heroku buildpacks:add https://github.com/gjaldon/heroku-buildpack-phoenix-static.git
```

Estou nomeando a aplicação como "your-expusherlite" mas você deve trocar pelo seu próprio nome, claro. E o resto dos dados de configuração são todos exemplos que você precisa mudar pras suas próprias necessidades.

O Heroku depende de variáveis de ambiente. Então começamos apagando "<tt>config/prod.secret.exs</tt>" e mudando o "<tt>config/prod.exs</tt>" pra ficar assim:

```ruby
config :ex_pusher_lite, ExPusherLite.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [scheme: "https", host: "your-expusherlite.herokuapp.com", port: 443], force_ssl: [rewrite_on: [:x_forwarded_proto]],
  cache_static_manifest: "priv/static/manifest.json",
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Configure seu banco
config :ex_pusher_lite, ExPusherLite.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: System.get_env("DATABASE_URL"),
  pool_size: 20

config :ex_pusher_lite, :admin_authentication,
  username: System.get_env("PUSHER_ADMIN_USERNAME"),
  password: System.get_env("PUSHER_ADMIN_PASSWORD")

# remova esta linha:
# import_config "prod.secret.exs"
```

Agora temos que configurar as variáveis de ambiente "SECRET_KEY_BASE", "PUSHER_ADMIN_USERNAME" e "PUSHER_ADMIN_PASSWORD". Use o "<tt>mix phoenix.gen.secret</tt>" que já vem incluído pra gerar elas.

```
heroku config:set SECRET_KEY_BASE="`mix phoenix.gen.secret`"
heroku config:set PUSHER_ADMIN_USERNAME="FPO0QUkqbAP6EGjElqBzDQuMs8bhFS3"
heroku config:set PUSHER_ADMIN_PASSWORD="n78DPGmK3DBQy8YAVyshiGqcXjjSXSD"
```

Aí é só esperar o velho e bom "<tt>git push heroku master</tt>" terminar de compilar tudo da primeira vez. E como é o primeiro deploy, não esqueça de rodar "<tt>heroku run mix ecto.migrate</tt>" pra criar a tabela do banco.

Agora, se eu fiz tudo direito, como Administrador que conhece os secrets hardcoded acima eu deveria conseguir criar uma nova Aplicação assim:

```
curl --data "app[name]=shiny-new-app" https://FPO0QUkqbAP6EGjElqBzDQuMs8bhFS3:n78DPGmK3DBQy8YAVyshiGqcXjjSXSD@your-expusherlite.herokuapp.com/api/admin/apps
```

E foi este o resultado que eu obtive!

```
{"data":{"slug":"shiny-new-app","secret":"42560373-0fe1-506e-28ca-35ab5221fb3d","name":"shiny-new-app","key":"958c16e7-ab93-dac0-0fc6-6cb864e26358","id":1,"active":true}}
```

Beleza, agora que temos uma key e secret válidos da Aplicação podemos configurar nosso Rails Client Demo e fazer deploy dele no Heroku também.

### Fazendo deploy do Cliente Rails no Heroku

Esta é uma aplicação Rails simples, podemos só criar o app e fazer deploy direto:

```
heroku create your-expusherlite-client
heroku config:set PUSHER_URL=your-expusherlite.herokuapp.com
heroku config:set PUSHER_APP_ID=shiny-new-app
heroku config:set PUSHER_KEY=958c16e7-ab93-dac0-0fc6-6cb864e26358
heroku config:set PUSHER_SECRET=42560373-0fe1-506e-28ca-35ab5221fb3d
heroku config:set PUSHER_CHANNEL=shiny-new-topic
git push heroku master
```

Estou assumindo que os leitores deste post já sabem como configurar uma app Rails apropriadamente pro Heroku. Só pra mencionar, eu configurei essa app com as gems 12 factor e Puma e adicionei um Procfile apropriado. Outra mudança bem pequena foi alterar o initializer "pusher_lite.rb" pra criar uma URI com "https" porque o ExPusherLite que fizemos deploy em produção exige SSL por padrão.

Tem mais um detalhe. Por ser conduzido por programadores web experientes, eles garantiram que, ao contrário deste exercício bem cru aqui, o framework Phoenix em si é seguro. Um exemplo é proibir conexões Websocket vindas de hosts diferentes.

Por padrão, o Socket do "phoenix.js" vai falhar a conexão quando tentarmos conectar do host do app Rails "your-expusherlite-client.herokuapp.com" pro app Phoenix em "your-expusherlite.herokuapp.com" com o seguinte erro:

```
WebSocket connection to 'wss://your-expusherlite.herokuapp.com/socket/websocket?guardian_token=N_YCG6hGK7…iOlsicHVibGljOioiXX0._j6s2LiaKde9rBhnTMxDkm0XV5u89pNh1AdLFY6Rlt8&vsn=1.0.0' failed: Error during WebSocket handshake: Unexpected response code: 403
```

E no log do Phoenix vamos ver esta mensagem bem útil:

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

A menos que você saiba o que é um [Cross-Site Web Socket Hijacking](https://www.christian-schneider.net/CrossSiteWebSocketHijacking.html), é melhor deixar as configurações padrão como estão. Numa app Phoenix novinha, a parte Web vai conectar no Web Socket dentro da mesma app e, portanto, no mesmo host, então isso não é problema.

No nosso caso eu estou fazendo um micro-serviço separado pra mimetizar o comportamento do Pusher.com, então ele precisa aceitar conexões de Web Socket de hosts diferentes.

Se você controla as aplicações que vão ser criadas, provavelmente vai preferir fazer a config "<tt>check_origin</tt>" ler do banco os hosts exatos. Como feature pra próxima vez eu poderia adicionar um campo "host" no model "App" e usar pra validar as conexões na configuração do transport. Por enquanto vou só fazer ele aceitar qualquer host:

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

E é isso! Agora a app Rails deve conseguir conectar e enviar mensagens! E você deve conseguir criar quantos apps quiser e ligar todos eles a este mesmo serviço.

![Final Heroku Client](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/534/big_Screenshot_from_2015-12-14_14_58_22.png)

### Conclusão

Neste momento, temos um clone funcional, embora bem cru, do Pusher.com que serve pra um monte de casos de uso onde o Pusher.com seria usado.

Como avisei várias vezes, a parte de segurança ainda está bamba e precisa de trabalho. Vou ainda estender o que o Daniel começou com o Guardian pra também autenticar usuários do Web Socket em canais privados. E o core também deve receber capacidades de auditoria e relatório (pra reportar uso, número de conexões ativas, throughput de eventos, manter pelo menos um histórico curto de eventos pras conexões novas conseguirem recuperar as últimas mensagens enviadas, e por aí vai).

Mas daqui pra frente é só uma questão de adicionar features a um core que já funciona. E isso é nada mais que Phoenix out-of-the-box sem grande coisa adicionada por cima! Diz muito sobre o atual estado de maturidade desse framework tão capaz.

Em termos de performance, pra este exemplo simplíssimo, eu subi 1 dyno free do Heroku pra cada app.

A app Rails consegue responder à interface front-end em torno de 2ms. E o job do Sucker Punch - que faz o HTTP POST pesado pro ExPusherLite - leva na ordem de 30ms ou menos.

O servidor Phoenix recebe o HTTP POST e faz o broadcast em torno de menos de 6ms. Também bem rápido. Os tempos vão variar bastante porque eu acredito que o dyno free é não só lento mas também fica em metal boxes muito compartilhadas, sofrendo impacto de outras apps vizinhas rodando na mesma máquina.

Como já temos uma API administrativa pra criar e gerenciar apps (criar novas, deletar, atualizar etc.) já dá pra criar uma aplicação separada em qualquer outro framework pra fazer um dashboard pra admins ou uma front-end self-service pros desenvolvedores registrarem novas apps e receberem o par key/secret pra adicionar nas suas próprias aplicações.

Tanto o servidor ExPusherLite quanto o cliente demo estão em deploy no Heroku e você pode testar o cliente agora mesmo [clicando aqui](https://expusherlite-client.herokuapp.com/). As keys de admin são diferentes das que mostrei neste post, claro, então você não vai conseguir criar apps novas, mas pode fazer deploy você mesmo no seu próprio ambiente.
