---
title: "[Primeiros Passos] Elixir 1.0 + Phoenix Framework 0.13"
date: '2015-06-02T16:14:00-03:00'
slug: primeiros-passos-elixir-1-0-phoenix-framework-0-13
tags:
- learning
- elixir
- erlang
draft: false
---

Ainda estou literalmente nos primeiros passos de aprender Elixir corretamente, mas achei interessante fazer um post demonstrando alguma coisa prática.

Para quem ainda não sabia, existe uma linguagem chamada "Erlang" (para "Ericsson Language"), uma linguagem "quase-funcional" com nada menos que 29 anos de idade (lançada em 1986) cujo núcleo é uma virtual machine muito leve, com grande tolerância a falhas e alta concorrência com processos leves e primitivas simples.

Elixir foi criado por ninguém menos que nosso conhecido Railer e Rubista José Valim para ser uma alternativa moderna de linguagem. A linguagem Erlang não é estranha da comunidade Ruby em geral pois Dave Thomas e Andy Hunt evangelizaram muito ela em 2007 pela Pragmatic Programmers. Mas a sintaxe realmente não é agradável para a maioria de nós. Para isso existe o Elixir: para que possamos usar toda a maturidade da VM do Erlang com uma sintaxe agradável com muitos traços de Ruby (embora não seja uma descendência direta).

Depois de alguns anos em desenvolvimento, o Valim fechou a versão 1.0 oficial em Setembro de 2014, então agora é um bom momento para investir tempo em aprender.

Este post não tem como objetivo ser um artigo altamente detalhado, apenas primeira impressões. Para aprender mais vá diretamente à fonte:

* [Getting Started](http://elixir-lang.org/getting-started/introduction.html) - tutorial oficial
* [Learning Resources](http://elixir-lang.org/learning.html) - livros já publicados

Felizmente, [instalar o Elixir](http://elixir-lang.org/install.html) hoje é quase tão simples como fazer um simples <tt>brew install elixir</tt> ou <tt>sudo apt-get install elixir</tt>. Veja a documentação oficial para ver  como instalar em seu sistema operacional de preferência.

De cara a primeira coisa que você precisa conhecer é a ferramenta [Mix](http://elixir-lang.org/docs/v1.0/mix/). Para rubistas ela é como se fosse uma mistura do nosso Rake com Bundler (já o equivalente Rubygems é o [Hex](https://hex.pm)). Ele é responsável por executar tarefas, dentre as quais gerenciar dependências (você vai encontrar um arquivo "<tt>mix.lock</tt>" que é semelhante ao nosso <tt>Gemfile.lock</tt>). Por exemplo, depois de instalar se fizer <tt>mix new phoenix_crud</tt> ele vai criar uma estrutura de diretórios e arquivos padrão com sub-diretórios "config", "lib", "test" (veja o padrão das coisas serem testadas, como na comunidade Ruby), um arquivo "README.md" (veja a preferência por markdown, que é uma tendência), e um arquivo "<tt>mix.exs</tt>" que funciona como uma mistura de um arquivo <tt>Gemfile</tt> e um arquivo Gemspec.

Mas para sermos mais práticos, vamos direto ao assunto: usar o [web framework Phoenix](http://www.phoenixframework.org). Em resumo, o Phoenix parece um Ruby on Rails mais simples. "Mais simples" porque ainda não houve tempo de maturação para ter mais, então cuidado, usar o Phoenix se parece um pouco com usar o Edge Rails (que é o Rails em desenvolvimento atualmente).

Até o momento deste post, o mais "adequado" talvez seja usar diretamente o que está no master do projeto, clonando e rodando diretamente do seu diretório:

---
git clone git@github.com:phoenixframework/phoenix.git
cd phoenix/installer
mix phoenix.new /diretorio_de_projetos/phoenix_crud
cd /diretorio_de_projetos/phoenix_crud
---

Veja o uso do comando <tt>mix</tt> com a tarefa <tt>phoenix.new</tt> que é como se existisse no Ruby algo como <tt>rake rails.new</tt> em vez do que fazemos hoje que é <tt>rails new</tt>. No mundo Rails o comando <tt>rails</tt> se sobressaiu ao uso do <tt>rake</tt> mas no mundo Elixir a idéia é manter consistente no comando <tt>mix</tt>.

O resto do artigo assume que você tem PostgreSQL instalado e entende minimamente como configurar roles, e que estamos já dentro do diretório do projeto Phoenix recém-criado.

Veja a estrutura inicial de um projeto Phoenix ("~" significa "semelhante a"):

---
/_build            - provavelmente onde fica os binários compilados
/config            - ~ /config do Rails
  /config.exs      - ~ /config/application.rb
  /dev.exs         - ~ /config/environments/development.rb
  /prod.exs        - ~ /config/environments/production.rb
  /prod.secret.exs - ~ /config/secrets.yml
  /test.exs        - ~ /config/environments/test.rb
/deps              - meio como um RVM gemset e /vendor
/lib
  /phoenix_crud
    /endpoint.ex   - meio como um /config/application.rb
    /repo.ex       - onde configura repositório do Ecto (mais abaixo)
  phoenix_crud.ex  - meio como o /config.ru e /config/boot.rb
/node_modules      - ele vendoriza dependência do Node
/priv
  /repo
    /migration     - incrivelmente igual a /db/migrate
  /static          - quase o mesmo que /public/assets (depois de compilado)
    /css
    /images
    /js
/test              - muito próximo ao nosso /test ou /spec
  /channels
  /controllers
  /models
  /support
  /views
  test_helper.exs  - praticamente o /test/test_helper.rb
/web                        - quase o /app
  /channels                 - para coisas de Web Sockets (futuro equivalente a Action Cable no Rails 5)
  /controllers
    page_controller.ex      
  /models
  /static                   - quase o /app/assets
    /css
      app.scss
    /js
      app.js
    /vendor
      phoenix.js
  /templates
    /layout                 - ~ /app/views/layouts
      application.html.eex
    /page                   - ~ /app/views/pages
      index.html.eex
  /views                    - não é equivalente a /app/views
    error_view.ex           - "acho" que é o que abre acesso a contexto dentro dos templates
    layout_view.ex
    page_view.ex
  router.ex                 - ~ /config/routes.rb
  web.ex                    - cria acesso a contexto dentro de cada classe anterior
brunch-config.js            - Brunch em vez de Sprockets para Asset Pipeline
mix.exs                     - ~ Gemfile
mix.lock                    - ~ Gemfile.lock
package.json                - não existe equivalente ao nosso rails-assets.org
README.md
---

Como podem ver é incrivelmente próximo ao Rails e fica mais próximo ainda no código. Para começar, precisamos configurar o acesso ao PostgreSQL no arquivo <tt>config/dev.exs</tt> no trecho final:

--- ruby
# Configure your database
config :phoenix_crud, PhoenixCrud.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "phoenix_crud_dev",
  size: 10 # The amount of database connections in the pool
---

Se você já configurou um <tt>config/database.yml</tt>, é a mesma coisa. E já que somos meros iniciantes, nada como um bom e velho Scaffold! Como fazer?

---
mix phoenix.gen.html User users name:string email:string bio:string age:integer
---

Obs: neste instance, o projeto não é compilável. Falta alterar manualmente o arquivo <tt>/web/router.ex</tt>, que vamos fazer mais pra frente.

De qualquer forma, o comando anterior vai criar arquivos como:

--- ruby
# priv/repo/migrations/20150601195745_create_user.exs
defmodule PhoenixCrud.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :age, :integer

      timestamps
    end

  end
end
---

Sem palavras! É praticamente a mesma DSL de migrations do Rails, o equivalente em Rails seria:

--- ruby
class CreateUser < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :age

      t.timestamps
    end
  end
end
---

Um model, por outro lado, é um pouco diferente do ActiveRecord:

--- ruby
defmodule PhoenixCrud.User do
  use PhoenixCrud.Web, :model

  schema "users" do
    field :name, :string
    field :email, :string
    field :bio, :string
    field :number_of_pets, :integer

    timestamps
  end

  @required_fields ~w(name email bio number_of_pets)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
---

Diretivas como o <tt>@required_fields</tt> funciona mais ou menos como declarar um <tt>validates :field, presence: true</tt>. A diferença maior é com o <tt>changeset/2</tt> (essa notação quer mais ou menos dizer: função com arity 2, ou seja, aceita 2 argumentos).

E de cara batemos com uma das funcionalidades que chamou mais atenção no Elixir, o operador "pipe" que é o <tt>|></tt>.

--- ruby
model |> cast(params, @required_fields, @optional_fields)
---

Esse trecho é a mesma coisa que:

--- ruby
cast(model, params, @required_fields, @optional_fields)
---

É para os casos onde faríamos:

--- ruby
foo(bar(baz), options)
---

Se entendi direito, faríamos o seguinte com pipes:

---
baz |> bar() |> foo(options)
---

E voltando ao <tt>changeset</tt>, segundo a [documentação no site do Phoenix](http://www.phoenixframework.org/v0.13.1/docs/ecto-models) usaríamos desta forma:

--- ruby
params = %{name: "Joe Example", email: "joe@example.com", age: 15}
changeset = User.changeset(%User{}, params)
changeset.valid?
---

Em Rails, seria mais ou menos o equivalente a:

--- ruby
params = {name: "Joe Example", email: "joe@example.com", age: 15}
user = User.new(params)
user.valid?
---

E para realmente adicionar validações como no ActiveRecord, adicionamos quaisquer transformações ou validações ao pipeline do changeset, o que faz muito sentido:

--- ruby
def changeset(model, params \\ nil) do
  model
  |> cast(params, @required_fields, @optional_fields)
  |> validate_length(:age, min: 18)
  |> validate_length(:age, max: 80)
  |> validate_format(:email, ~r/@/)
end
---

Com isso em mente, vejamos o próximo código que foi gerado automaticamente nesse scaffold, o controller:

--- ruby
# web/controllers/user_controller.ex
defmodule PhoenixCrud.UserController do
  use PhoenixCrud.Web, :controller

  alias PhoenixCrud.User

  plug :scrub_params, "user" when action in [:create, :update]
  plug :action

  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.html", users: users)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    if changeset.valid? do
      Repo.insert(changeset)

      conn
      |> put_flash(:info, "User created successfully.")
      |> redirect(to: user_path(conn, :index))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    render(conn, "show.html", user: user)
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    changeset = User.changeset(user)
    render(conn, "edit.html", user: user, changeset: changeset)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get(User, id)
    changeset = User.changeset(user, user_params)

    if changeset.valid? do
      Repo.update(changeset)

      conn
      |> put_flash(:info, "User updated successfully.")
      |> redirect(to: user_path(conn, :index))
    else
      render(conn, "edit.html", user: user, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get(User, id)
    Repo.delete(user)

    conn
    |> put_flash(:info, "User deleted successfully.")
    |> redirect(to: user_path(conn, :index))
  end
end
---

Novamente, de bater o olho é uma estrutura muito semelhante ao nosso conhecido controller restful do Rails. Actions com os mesmos nomes e mesmo o código é muito semelhante. Se tentar ler provavelmente vai entender rapidamente as diferenças em sintaxe.

Dentre as diferenças, imagino que <tt>alias PhoenixCrud.User</tt> é para que possamos usar diretamente dentro dos métodos assim: <tt>user = Repo.get(User, id)</tt> que, se você já entendeu, percebeu que é o equivalente ao nosso conhecido <tt>user = User.find(id)</tt>. A biblioteca Ecto organiza usando o pattern de Repository pelo jeito, que obviamente é diferente do pattern ActiveRecord. Programadores Java vão se sentir mais à vontade, mas não é nada difícil (e não, não comecem um flame se é ["Repository do DDD ou mero DAO"](http://stackoverflow.com/questions/8550124/what-is-the-difference-between-dao-and-repository-patterns)!!)

Antes de falar de "plug" vamos mexer no arquivo <tt>router.ex</tt>:

--- ruby
defmodule PhoenixCrud.Router do
  use PhoenixCrud.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PhoenixCrud do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
  end

  # Other scopes may use custom stacks.
  # scope "/api", PhoenixCrud do
  #   pipe_through :api
  # end
end
---

O que eu disse quando executamos o scaffold sobre não compilar é porque precisamos adicionar a seguinte linha ao arquivo anterior:

--- ruby
resources "/users", UserController
---

Novamente: parecido com Rails! Mas aqui tem uma coisa que poderia ter no Rails (e eu não ficaria surpreso de ver isso no Rails 5): escopo de middlewares. Plugs são mais ou menos como nossos Rack Middlewares. Um Pipeline de Middlewares ou Plugs funciona encadeando um filtro de request/response atrás do outro. No nosso caso é encadear Racks (por isso o nome "Rack" aliás, literalmente, prateleiras uma em cima ou embaixo da outra).

Lembram do projeto [Rails-API](https://github.com/rails-api/rails-api)? Hoje sabemos que ele vai ser incorporado ao Rails 5 mas o Rails-API começa com o próprio Rails 4.2 e desabilitando a maioria das middlewares que não necessárias numa API. Por exemplo, tecnicamente não precisamos processar session ou mensagens flash (mesmo conceito no Phoenix como no Rails) numa API, então a requisição não precisa passar por esses plugs/middlewares.

E de fato, no <tt>router.ex</tt> definimos pipelines separados como escopos, um para <tt>:browser</tt> e outro para <tt>:api</tt> e colocamos nossas rotas específicas para navegação de browser dentro do escopo adequado. Por isso declaramos explicitamente o <tt>resources "/users", UserController</tt> como <tt>pipe_through :browser</tt>. E em particular temos o <tt>plug :scrub_params</tt> no controller definido pras actions "create" e "update" que é onde são necessários. Esperto!

Sem esticar demais este artigo vejamos agora como é uma view. Em vez de ERB (Embedded RuBy) temos EEX (Embedded EliXir). Em particular vamos ver o arquivo gerado automaticamente no scaffold, <tt>web/templates/user/form.html.eex</tt>:

--- html
<%= form_for @changeset, @action, fn f -> %>
  <%= if f.errors != [] do %>
    <div class="alert alert-danger">
      <p>Oops, something went wrong! Please check the errors below:</p>
      <ul>
        <%= for {attr, message} <- f.errors do %>
          <li><%= humanize(attr) %> <%= message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>

  <div class="form-group">
    <label>Name</label>
    <%= text_input f, :name, class: "form-control" %>
  </div>
  ...
  <div class="form-group">
    <%= submit "Submit", class: "btn btn-primary" %>
  </div>
<% end %>
---

Praticamente igual, incluindo o padrão de messages por flash. Correndo o risco de ficar repetitivo: se você já gerou scaffold no Rails algumas vezes, vai notar que é muito parecido mesmo. DSL inspirado fortemente no ActionView com helpers como <tt>form_for</tt>, <tt>humanize</tt>, <tt>text_input</tt>, etc. Ou seja, para desenvolvedores front-end de Rails, estamos praticamente em casa, principalmente porque a idéia é usar diretamente pacotes para Brunch.

Por último, algo que pode ser diferente é o conteúdo do diretório <tt>web/views</tt>, como o arquivo <tt>web/views/user_view.ex</tt>:

--- ruby
defmodule PhoenixCrud.UserView do
  use PhoenixCrud.Web, :view
end
---

Pelo que entendi, ele dá aos templates em EEX o contexto da aplicação, como variáveis criadas no controller. No Rails se definimos um <tt>@users = User.all</tt> a view pode usar como <tt>for user in @users</tt>. No Phoenix explicitamente declaramos isso pela diretiva <tt>use PhoenixCrud.Web, :view</tt>. Esse ":view" está definido no arquivo <tt>web/web.ex</tt> neste trecho:

--- ruby
defmodule PhoenixCrud.Web do
  ...
  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Import URL helpers from the router
      import PhoenixCrud.Router.Helpers

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML
    end
  end
  ...
end
---

Por isso entendemos que ele declara onde ficam os templates, o contexto do controller, os helpers e funcionalidades de HTML como forms.

Então, com esse código todo, o que podemos fazer?

Primeiro, gostaríamos de ter o equivalente aos nossos <tt>rake db:create</tt> e <tt>rake db:migrate</tt> e de fato:

---
mix ecto.create
mix ecto.migrate
---

E para rodar a aplicação web? Qual o equivalente ao nosso <tt>rails server</tt>?

---
mix phoenix.server
---

Isso vai subir o servidor Cowboy (o equivalente Puma) na porta 4000 em vez de 3000. Daí teremos telas como estas:

![welcome](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/494/big_Screen_Shot_2015-06-02_at_15.26.26.png)

![form](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/495/big_Screen_Shot_2015-06-02_at_15.26.34.png)

Uma única coisa que faz sentido para um scaffold é que ele já vem pré-configurado para usar Bootstrap. Mas eu recomendo usar com cuidado (sem muito flame, prefira usar algo como um Bourbon com Compass e Susy).

E como está definido em <tt>lib/phoenix_crud/endpoint.ex</tt> sabemos que ele tem suporte a servir arquivos estáticos, live reloading de código, fora o básico como logger, parser, etc. Veja:

--- ruby
defmodule PhoenixCrud.Endpoint do
  use Phoenix.Endpoint, otp_app: :phoenix_crud

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phoenix.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/", from: :phoenix_crud, gzip: false,
    only: ~w(css images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
  end

  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_phoenix_crud_key",
    signing_salt: "JFgnoLpe"

  plug :router, PhoenixCrud.Router
end
---

## Conclusão

Ainda é cedo para dizer como melhor usar o Phoenix mas de cara vejo uma grande oportunidade para desenvolvedores Ruby conseguirem rapidamente criar "microsserviços" para servir APIs puxando dados de um PostgreSQL. Não cheguei a brincar nem comentar aqui mas na estrutura que mostrei acima existe o diretório <tt>web/channels</tt> para o server-side para Web Sockets e o arquivo vendorizado <tt>web/static/vendor/phoenix.js</tt> que é o client-side Javascript para se conectar nesses channels.

Então para casos de uso como Chats, Push-Notifications ou outras coisas real-time e APIs simples de alta concorrência, talvez seja mais uma excelente opção.

Mas lembrando que embora o Elixir tenha atingido a versão 1.0, o framework Phoenix ainda é bastante jovem (em sua versão 0.13 até o momento deste artigo). Já vi alguns posts de blogs com tutoriais para o Phoenix que mostram código um pouco diferente do que listei neste post e quando forem tentar, talvez já tenha acontecido mais modificações, por isso eu disse que é como acompanhar o Edge Rails.

Não recomendo, claro, fazer uma aplicação para colocar em produção sem ter em mente o comprometimento de que deve precisar fazer manutenções frequentes, para corrigir bugs tanto de funcionamento quanto segurança, que ainda não sabemos se tem ou não (não há nada equivalente a um Brakeman, por exemplo). Mas de qualquer forma, já é possível testar um deployment ao Heroku porque alguém já fez um [buildpack](https://github.com/HashNuke/heroku-buildpack-elixir) pra isso.

Apesar das semelhanças com Ruby até aqui, ele não é nem de longe igual aos paradigmas de Ruby. Então a sintaxe serve de incentivo a rubistas para entender mais sobre os paradigmas específicos de Erlang e patterns do OTP. Mas usar o Phoenix como incentivo para aprender mais da linguagem deve servir o mesmo propósito de usar Rails para aprender mais de Ruby.
