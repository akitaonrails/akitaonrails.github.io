---
title: 'Phoenix "15 Minute Blog": comparação com Ruby on Rails'
date: '2015-11-20T17:52:00-02:00'
slug: phoenix-15-minute-blog-comparacao-com-ruby-on-rails
translationKey: phoenix-15-minute-blog-vs-rails
aliases:
- /2015/11/20/phoenix-15-minute-blog-comparison-to-ruby-on-rails/
tags:
- learning
- beginner
- elixir
- phoenix
- traduzido
draft: false
---

*Update 23/11/15:* Chris McCord, criador do Phoenix, acabou de publicar um artigo explicando por que ["Phoenix is not Rails"](https://dockyard.com/blog/2015/11/18/phoenix-is-not-rails). Ele entra em detalhes sobre várias coisas que descrevo neste artigo e recomendo fortemente que você leia também.

Se você anda acompanhando a blogosfera de Elixir, é bem provável que tenha esbarrado na versão do clássico "15 minute blog" do [Brandon Richey](https://medium.com/@diamondgfx). Se ainda não viu, você precisa ler pelo menos a [Parte 1](https://medium.com/@diamondgfx/introduction-fe138ac6079d#.ffl48saew) e a [Parte 2](https://t.co/DjGDek1ZOk). É um tutorial bem detalhado que vai facilitar muito a sua entrada nas delícias do Phoenix.

Este post é destinado a programadores Rails que querem saber como o Phoenix Framework se compara. Não é uma comparação completamente justa, já que se trata apenas do bom e velho exercício "hello world" com nested resources. Isso só arranha a superfície, mas serve como uma boa introdução.

Para o bem ou para o mal, muitos ainda consideram o Ruby on Rails como a melhor DSL para uma aplicação web. O Rails teve sucesso ao criar um vocabulário muito reconhecível para descrever cada componente de um projeto web. E eu vou argumentar que uma das forças do Phoenix está justamente em pegar emprestada essa mesma metáfora com sucesso. Isso definitivamente torna a curva de aprendizado bem mais suave.

Se você só quer clonar os exercícios e pular direto para o código, eu tenho o [Pxblog em Phoenix](https://github.com/akitaonrails/pxblog_phoenix_exercise) original e o equivalente [Pxblog em Rails](https://github.com/akitaonrails/pxblog_rails_exercise) para comparação.

### Começando: linha de comando e estrutura de pastas

Sem mais delongas, vamos começar comparando os comandos básicos do console:

```
rails new pxblog
rails g scaffold Post title:string body:string
rails g scaffold User username:string email:string password_digest:string
rake db:create
rake db:migrate
rails g migration AddUserIdToPosts
rails server
```

```
mix phoenix.new pxblog
mix phoenix.gen.html Post posts title:string body:string
mix phoenix.gen.html User users username:string email:string password_digest:string
mix ecto.create
mix ecto.migrate
mix ecto.gen.migration add_user_id_to_posts
mix phoenix.server
# iex -S mix phoenix.server para iniciar dentro do IEx e poder usar IEx.pry
```

De cara já nos sentimos em casa. No mundo Rails temos o comando <tt>rails</tt> competindo com o tradicional gerenciador de tarefas <tt>rake</tt>. No lado do Phoenix, felizmente concentraram tudo sob o comando <tt>mix</tt> nativo do Elixir. Existem discussões para mover as tarefas do comando Rails para o Rake, onde elas pertencem, mas isso não vai acontecer tão cedo.

Como tudo está sob o domínio do Mix, você pode listar as tarefas relacionadas ao Phoenix assim:

```
$ mix help | grep -i phoenix

mix phoenix.digest      # Digests and compress static files
mix phoenix.gen.channel # Generates a Phoenix channel
mix phoenix.gen.html    # Generates controller, model and views for an HTML based resource
mix phoenix.gen.json    # Generates a controller and model for a JSON based resource
mix phoenix.gen.model   # Generates an Ecto model
mix phoenix.gen.secret  # Generates a secret
mix phoenix.new         # Create a new Phoenix v1.0.3 application
mix phoenix.routes      # Prints all routes
mix phoenix.server      # Starts applications and their servers
```

A estrutura de diretórios que o <tt>phoenix.new</tt> gera é um pouco diferente do Rails:

```
/_build              # binários que o mix compila (ignore)
/config
- config.exs         # pense no /config/application.rb do Rails
- dev.exs            # pense no /config/environments/development.rb do Rails
- prod.exs           # pense no /config/environments/production.rb do Rails
- prod.secret.exs    # pense no /config/secrets.yml do Rails
- test.exs           # pense no /config/environments/test.rb do Rails
/deps                # onde o mix deps.get coloca as dependências
/lib
  /pxblog
    - endpoint.ex    # algo como config.ru e application.rb
    - repo.ex        # configuração do Ecto
  - pxblog.ex        # onde você configura a árvore de supervisão das apps OTP
/node_modules        # Phoenix integra com Node.js
/priv
  /repo
    /migrations      # pense no /db/migrate do Rails
    - seeds.exs      # pense no /db/seeds.rb do Rails
  /static            # pense no /public do Rails
    /css
    /images
    /js
/test                # pense no /test do Rails
  /channels
  /controllers
  /models
  /support
  /views
  - test_helper.exs  # pense no /test/test_helper.rb do Rails
/web                 # pense no /app do Rails
  /channels          # pense nos channels do ActionCable do Rails 5
  /controllers
  /models
  /static            # pense no /app/assets do Rails
    /assets
      /images
      /css
      /js
      /vendor
  /templates         # pense no /app/views do Rails
    /layout
  /views             # pense no /app/helpers do Rails, mas com Presenters
    - layout_view.ex
  - router.ex        # pense no /config/routes.rb do Rails
  - web.ex           # macros para configurar cada componente MVC
- .gitignore
- README.md
- brunch-config.js  # o reload do front-end em dev é controlado pelo Brunch
- mix.exs           # pense no Gemfile do Ruby (com extras)
- package.json      # dependências do Node.js
```

No Rails, o ponto de partida é a aplicação Rackup <tt>config.ru</tt> (já que o Rails virou uma aplicação Rack desde a versão 3.0). Ele então carrega o <tt>config/environment.rb</tt>, depois <tt>config/application.rb</tt>, depois <tt>config/boot.rb</tt> que carrega as gems declaradas no <tt>Gemfile</tt>, junto com <tt>config/initializers/*.rb</tt> e cada arquivo em <tt>config/environments</tt>, configurando o Rails::Application e plugando a configuração, o pipeline de Rack Middlewares.

No Phoenix, o ponto de partida — como em qualquer aplicação Elixir — é o arquivo <tt>mix.exs</tt>. Neste caso ele aponta para a app OTP/Phoenix "Pxblog" definida em <tt>lib/pxblog/pxblog.ex</tt>. Por sua vez ela inicia e supervisiona as apps "Pxblog.Endpoint" e "Pxblog.Repo", definidas em <tt>lib/pxblog/endpoint.ex</tt> e <tt>lib/pxblog/repo.ex</tt>, respectivamente.

Se você criar outras apps OTP, é aqui que você adiciona à Árvore de Supervisão OTP. Eu diria que é algo parecido com uma Rails Engine, embora tecnicamente não seja a mesma coisa, mas talvez essa metáfora ajude.

Um aspecto importante do Rails é como ele divide as configurações de development, test e production em arquivos diferentes. O Phoenix faz o mesmo nos arquivos <tt>dev.exs</tt>, <tt>test.exs</tt> e <tt>prod.exs</tt>. Na verdade, isso é uma [feature do Mix](http://elixir-lang.org/getting-started/mix-otp/introduction-to-mix.html#environments). O Mix é uma versão mais elaborada do Rake, e faz sentido, já que José Valim também tentou empurrar o Thor para substituir o Rake, embora isso nunca tenha pegado tração na comunidade Ruby (o Rake já está enraizado em todo lugar). Frameworks web que não impõem separação de ambientes por padrão, nessa altura do campeonato, são inúteis. O legal é que toda app Elixir gerada pelo Mix herda essa feature útil.

Em vez de ter um <tt>database.yml</tt>, a configuração de banco de dados está espalhada pelos arquivos de configuração de ambiente, e as configurações de produção ficam em um arquivo separado <tt>prod.secret.exs</tt>, que obviamente fica ignorado no <tt>.gitignore</tt>, como o arquivo <tt>secrets.yml</tt> do Rails.

### Estrutura MVC

Você vai notar que cada elemento do MVC do Phoenix começa assim:

```ruby
# web/controllers/page_controller.ex
defmodule Pxblog.PageController do
  use Pxblog.Web, :controller
  ...
end
# web/models/post.ex
defmodule Pxblog.Post do
  use Pxblog.Web, :model
  ...
end
# web/views/post_view.ex
defmodule Pxblog.PostView do
  use Pxblog.Web, :view
end
# web/router.ex
defmodule Pxblog.Router do
  use Pxblog.Web, :router
  ...
end
```

Esse módulo <tt>Pxblog.Web</tt> é definido em <tt>web/web.ex</tt> assim:

```ruby
# web/web.ex
defmodule Pxblog.Web do
  def model do
    quote do
      use Ecto.Model

      import Ecto.Changeset
      import Ecto.Query, only: [from: 1, from: 2]
    end
  end

  def controller do ...

  def view do ...

  def router do ...

  def channel do ...

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
```

Se você ainda não estudou, esse é um bom momento para aprender sobre [Macros do Elixir](http://elixir-lang.org/getting-started/meta/macros.html). Pense no código dentro do bloco <tt>quote</tt> como sendo "injetado" em cada módulo que chama <tt>use Pxblog.Web</tt>. Quando você dá <tt>use</tt> em um módulo, ele chama o macro <tt>__using__</tt>. Pense nisso como um Module Mixin do Ruby chamando o callback <tt>included</tt> e executando um <tt>class_eval</tt>. Como não existe o conceito de Classes e subclasses, incluímos mixins em cada classe para adquirir os comportamentos desejados.

### MVC Router

Diferente do <tt>config/routes.rb</tt> do Rails, que define rotas, o <tt>web/router.ex</tt> define não só as rotas em si, mas também pipelines de transformação e estratégias de roteamento:

```ruby
# web/router.ex
defmodule Pxblog.Router do
  use Pxblog.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Pxblog do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController do
      resources "/posts", PostController
    end
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Pxblog do
  #   pipe_through :api
  # end
end
```

Você tem que ler assim:

O bloco <tt>pipeline</tt> pluga "filtros". Eles são parecidos com os Rack middlewares que definimos em <tt>config/application.rb</tt> no Rails. Isso é muito esperto, porque uma diferença chave entre o Ruby on Rails padrão e o [projeto Rails-API](https://github.com/rails-api/rails-api) é justamente a remoção de Rack middlewares desnecessários que endpoints de API não precisam.

No Phoenix podemos definir um pipeline para navegadores web e outro para clientes de API, e você vê que a diferença é a remoção de Plugs.

Depois definimos os scopes baseados nos paths raiz. Tem um scope "/" que se conecta ao pipeline <tt>:browser</tt> e um scope opcional (comentado) "/api" que passa pelo pipeline <tt>:api</tt>.

Dentro do bloco scope, é muito parecido com a DSL Restful para definir rotas, que de novo é uma boa adaptação das Rotas do Rails. [Leia a documentação](http://www.phoenixframework.org/docs/routing) para saber os detalhes.

Também parecido com as Rotas do Rails, ele gera os URL helpers apropriados que ficam disponíveis nos Controllers, Views e Templates. Vamos começar vendo alguns URL helpers do Rails em código:

```html
<!-- app/views/posts/edit.html.erb -->
<%= link_to 'Show', [@user, post] %>
<%= link_to 'Edit', edit_user_post_path(@user, post) %>
<%= link_to 'Destroy', [@user, post], method: :delete, data: { confirm: 'Are you sure?' } %>
```

E no Phoenix:

```html
<!-- web/templates/post/edit.html.eex -->
<%= link "Show", to: user_post_path(@conn, :show, @user, post) %>
<%= link "Edit", to: user_post_path(@conn, :edit, @user, post) %>
<%= link "Delete", to: user_post_path(@conn, :delete, @user, post), method: :delete, data: [confirm: "Are you sure?"] %>
```

O URL helper principal do Rails consegue receber um Array como <tt>[@user, post]</tt> e executá-lo da mesma forma como se tivéssemos escrito <tt>user_post_path(@user, post)</tt>. Uma diferença em relação ao Rails é que, em vez de criar um helper para cada verbo HTTP, você tem só um helper por recurso que aceita um parâmetro extra para indicar o verbo. Então temos <tt>post_path(@conn, :edit, post)</tt> em vez do jeito Rails <tt>edit_post_path(post)</tt>.

Assim como nos middlewares do Rails, um pipeline recebe a conexão da requisição e a passa por um pipe, transformando seus metadados para que ela fique limpa e usável dentro dos nossos controllers.

### MVC Controller

No Phoenix começamos um controller assim:

```ruby
# web/controllers/post_controller.ex
defmodule Pxblog.PostController do
  use Pxblog.Web, :controller
  
  alias Pxblog.Post
  
  plug :scrub_params, "post" when action in [:create, :update]
  plug :assign_user
  plug :authorize_user when action in [:new, :create, :update, :edit, :delete]
```

É parecido com este setup de controller Rails:

```ruby
# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_action :assign_user
  before_action :authorize_user, only: [:new, :create, :update, :edit, :destroy]
```

Como você deve ter concluído, uma chamada <tt>plug</tt> funciona um pouco como um pipeline de <tt>before_action</tt>. O <tt>scrub_params</tt> eu acredito que seja parecido com o <tt>ActionDispatch::ParamParser</tt> do Rails, mas não tenho certeza; sei que ele limpa valores de string vazios, transformando em nil, para que você não atualize seus modelos desnecessariamente.

Mas, diferente do Rails, onde uma chamada a <tt>redirect_to</tt> interrompe o pipeline, aqui precisamos parar o pipeline explicitamente assim:

```ruby
defp assign_user(conn, _) do
  %{"user_id" => user_id} = conn.params
  if user = Repo.get(Pxblog.User, user_id) do
    assign(conn, :user, user)
  else
    conn
    |> put_flash(:error, "Invalid user!")
    |> redirect(to: page_path(conn, :index))
    |> halt()
  end
end
```

No Phoenix, tudo gira em torno de um pipeline de transformação da conexão de requisição que você começa a configurar nos Plugs do Router, nos Plugs do Controller e nas actions do Controller. Todos eles recebem a conexão do passo anterior e devolvem uma conexão transformada para o próximo passo, até que ela se torne uma resposta HTTP apropriada. Diferente do Rails, esse caminho é muito mais explícito, e você sabe que vai receber essa conexão e deve aplicar transformações nela até renderizar o HTML final ou enviar de volta algum header de erro.

Para ver o quão explícito, vamos começar com uma action típica de controller Rails:

```ruby
def destroy
  @user = User.find(params[:id])
  @user.destroy
  respond_to do |format|
    format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
    format.json { head :no_content }
  end
end
```

Antigamente, definir a mensagem flash e redirecionar eram 2 métodos diferentes; versões mais recentes mesclaram os dois por conveniência. O Rails também tem o conceito de Responders, que o Phoenix ainda não tem (#OpportunityToContribute!).

```ruby
def delete(conn, %{"id" => id}) do
  user = Repo.get!(User, id)
  Repo.delete!(user)
  conn
  |> put_flash(:info, "User deleted successfully.")
  |> redirect(to: user_path(conn, :index))
end
```

Você pode ver que, deixando os Responders de lado, a versão Phoenix é **notavelmente** parecida. E é assim para todas as ações Restful do controller. Mas mais parecido com o falecido Merb, cada action de Controller no Phoenix tem uma assinatura de função apropriada declarando os parâmetros que ela espera receber, em vez de ter um hash global <tt>params</tt> que precisa passar pelos [Strong Parameters](https://github.com/rails/strong_parameters).

Para variações diferentes dos mesmos parâmetros, você pode declarar várias funções com o mesmo nome mas com argumentos diferentes para fazer pattern match, como no exemplo do <tt>SessionController</tt>:

```ruby
# web/controllers/session_controller.ex
defmodule Pxblog.SessionController do
  use Pxblog.Web, :controller
  ...
  def create(conn, %{"user" => %{"username" => username, "password" => password}}) when not is_nil(username) and not is_nil(password) do
    user = Repo.get_by(User, username: username)
    sign_in(user, password, conn)
  end

  def create(conn, _) do
    failed_login(conn)
  end
  ...
end
```

Aqui temos a mesma função <tt>create/2</tt> com pattern matching e guards. A segunda versão recebe qualquer coisa, caso a primeira versão falhe ao fazer pattern match contra os parâmetros recebidos. O Phoenix espera mais ou menos a mesma estrutura de parâmetros que o Rails, então é bem intuitivo de acompanhar.

### MVC Models

Em vez do bom e velho ActiveRecord (ActiveModel), no Phoenix temos que lidar com os [Modelos Ecto](http://www.phoenixframework.org/docs/ecto-models). Ele já suporta Postgresql, MySQL, Sqlite3, MongoDB, então você está coberto em 99% dos casos.

O Ecto separa a Lógica do Modelo do Gerenciamento de Persistência. Em vez de usar o padrão de design Active Record, ele prefere o padrão Data Mapper. Essa é uma discussão antiga entre os Railers. Muita gente reclama que a lógica de persistência fica junto com a lógica de negócio, e da quantidade de mágica e metaprogramação que torna o ActiveRecord muito fácil de começar mas muito difícil de dominar de verdade.

Você deve ler o post do José Valim sobre [Associações no Ecto](http://blog.plataformatec.com.br/2015/08/working-with-ecto-associations-and-embeds/) para começar. Mas por enquanto, vamos comparar modelos simples de Rails e Ecto:

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  has_secure_password

  has_many :posts

  validates :username, presence: true
  validates :email, presence: true
end
```

No Rails temos o [<tt>ActiveSupport#has_secure_password</tt>](http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html), que usa BCrypt por baixo dos panos para gerar um digest de senha apropriado. Se você está construindo autenticação do zero, você **deve** usar essa construção.

O Phoenix ainda não tem essa mesma feature (#OpportunityToContribute!), então a versão dele é um pouco mais verbosa para dar conta da lógica do digest BCrypt usando a biblioteca de hashing de senhas [Comeonin](https://github.com/elixircnx/comeonin). Vamos por partes:

```ruby
# web/models/user.ex
defmodule Pxblog.User do
  use Pxblog.Web, :model
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  schema "users" do
    field :username, :string
    field :email, :string
    field :password_digest, :string

    timestamps

    # Virtual Fields
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    has_many :posts, Pxblog.Post
  end
  ...
end
```

A primeira parte dos Modelos Ecto declara os campos do banco de dados, campos virtuais e associações. O ActiveRecord do Rails prefere a abordagem de pedir ao banco que envie os metadados da tabela e usa metaprogramação para criar todos os campos depois, em runtime. Muita gente não gosta dessa abordagem, e essa é a alternativa: declaração explícita.

Estamos mapeando o módulo <tt>User</tt> com a tabela <tt>'users'</tt> do banco de dados na declaração <tt>schema "users" do</tt>, em vez de recorrer a convenções de pluralização.

A última linha tem nossa conhecida associação <tt>has_many</tt>.

```ruby
defmodule Pxblog.User do
  ...
  @required_fields ~w(username email password password_confirmation)
  @optional_fields ~w()
  ...
end
```

Aqui declaramos os campos obrigatórios; isso é só uma variável com uma lista de campos, e não as validações em si. Isso vai ser usado no próximo passo para fazer algo similar a <tt>validates :username, presence: true</tt>. 

```ruby
defmodule Pxblog.User do
  ...
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> hash_password
  end
  ...
end
```

Em vez de fazer algo como <tt>Post.create(params)</tt>, primeiro criamos um changeset e depois passamos para o Repositório principal do Ecto. O Repositório então fica responsável pela parte da persistência. O Modelo Ecto fica responsável por validar e limpar o changeset que o Repositório recebe.

O <tt>changeset/2</tt> retorna uma [Struct do Elixir](http://elixir-lang.org/getting-started/structs.html) para trabalharmos antes de passar para a aplicação Repositório fazer a persistência.

Nessa função podemos declarar um pipeline de validações, constraints e outras transformações de atributos. Por exemplo, plugamos uma função <tt>hash_password/2</tt> que vai pegar o valor em <tt>password</tt> e usar o <tt>Comeonin.hashpwsalt/1</tt> para transformar a string da senha em um digest bcrypt e armazenar no atributo password_digest:

```ruby
defmodule Pxblog.User do
  ...
  defp hash_password(changeset) do ...
    if password = get_change(changeset, :password) do
      changeset
      |> put_change(:password_digest, hashpwsalt(password))
    else
      changeset
    end
  end
end
```

E retornamos o changeset transformado, para que o pipeline pegue e passe adiante para outros plugs, como validações. Se quiséssemos adicionar mais validações, daria para fazer assim:

```ruby
defmodule Pxblog.User do
  ...
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:password, min: 3, max: 100)
    |> validate_length(:username, min: 5, max: 50)
    |> validate_confirmation(:password)
    |> unique_constraint(:username)
    |> hash_password
  end
  ...
end
```

Pronto. E no controller, a função <tt>update/2</tt>, por exemplo, vai usar o changeset assim:

```ruby
def update(conn, %{"id" => id, "user" => user_params}) do
  user = Repo.get!(User, id)
  changeset = User.changeset(user, user_params)
  case Repo.update(changeset) do
  ...
end
```

Na segunda linha usamos o Repositório para consultar o schema 'users' como declarado no modelo <tt>User</tt>.

Depois, transformamos o struct <tt>user</tt> com o map <tt>user_params</tt> que recebemos do pipeline do Router, como definido na primeira linha.

A transformação retorna um changeset, que vai conter as mensagens de erro. Aí passamos o changeset de novo para o Repositório, para que ele atualize o registro na tabela.

### MVC View e Templates

No caso da função <tt>edit/2</tt>, chamamos a função <tt>render/3</tt> assim:

```ruby
# web/views/user_view.ex
def edit(conn, %{"id" => id}) do
  user = Repo.get!(User, id)
  changeset = User.changeset(user)
  render(conn, "edit.html", user: user, changeset: changeset)
end
```

Isso primeiro chama o <tt>web/views/user.ex</tt>, que importa coisas como helpers, transforma as variáveis <tt>user</tt> e <tt>changeset</tt> em [atributos de módulo](http://elixir-lang.org/getting-started/module-attributes.html) (aqueles que começam com "@", caso você estivesse se perguntando o que são). E a View sabe encontrar o template <tt>edit.html</tt> em <tt>web/templates/user/edit.html.eex</tt> porque está dito assim em <tt>web/web.ex</tt>:

```ruby
# web/web.ex
defmodule Pxblog.Web do
  ...
  def view do
    quote do
      use Phoenix.View, root: "web/templates"

      # Import convenience functions from controllers
      import Phoenix.Controller, only: [get_csrf_token: 0, get_flash: 2, view_module: 1]

      # Use all HTML functionality (forms, tags, etc)
      use Phoenix.HTML

      import Pxblog.Router.Helpers
    end
  end
  ...
end
```

Eu não copiei e colei todos os outros macros em <tt>web/web.ex</tt>, mas dê uma olhada para ver o que models, controllers, router e channel importam em cada módulo que você cria.

No Rails temos o ERB padrão, de "Embedded Ruby", e no Phoenix temos o "EEX", de "Embedded Elixir". É essencialmente a mesma coisa: um template HTML que aceita trechos de código Elixir entre <tt><%= ... %></tt>. Então o template <tt>edit.html.eex</tt> fica assim:

```html
<!-- app/views/users/edit.html.erb -->
<h2>Edit user</h2>

<%= render "form.html", changeset: @changeset,
                        action: user_path(@conn, :update, @user) %>

<%= link 'Back', to: user_path(@conn, :show, @user) %> |
<%= link "Back", to: user_path(@conn, :index) %>
```

Que é muito parecido com o equivalente <tt>edit.html.erb</tt> em Rails:

```html
<!-- web/templates/user/edit.html.eex -->
<h1>Editing User</h1>

<%= render 'form' %>

<%= link_to 'Show', @user %> |
<%= link_to 'Back', users_path %>
```

A versão Phoenix é um pouco mais verbosa, propositalmente para não esconder tanta coisa quanto o Rails esconde. Dá para discutir se mais ou menos mágica torna o framework mais produtivo, mas a versão Phoenix, sendo mais explícita, deixa um rastro de migalhas mais fácil de seguir, especialmente se você está começando. Aqui não temos o conceito de "partials"; qualquer template pode renderizar qualquer outro template, só precisamos passar a variável necessária para o template funcionar. Mas, em vez de passar uma instância de modelo, estamos passando um changeset.

O template "form.html" também é bem parecido. Vamos ver primeiro a versão Phoenix:

```html
<!-- web/templates/user/edit.html.eex -->
<%= form_for @changeset, @action, fn f -> %>
  <%= if @changeset.action do %>
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
    <%= label f, :username, "Username", class: "control-label" %>
    <%= text_input f, :username, class: "form-control" %>
  </div>
  ...
```

E agora a versão ERB do Rails:

```html
<!-- app/views/users/_form.html.erb -->
<%= form_for(@user) do |f| %>
  <% if @user.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(@user.errors.count, "error") %> prohibited this user from being saved:</h2>

      <ul>
      <% @user.errors.full_messages.each do |message| %>
        <li><%= message %></li>
      <% end %>
      </ul>
    </div>
  <% end %>

  <div class="field">
    <%= f.label :username %><br>
    <%= f.text_field :username %>
  </div>
  ...
```

Notavelmente parecidos. Existem coisas específicas de cada linguagem, como ter <tt>label(f, :username)</tt> em vez de <tt>f.label :username</tt>. Como em Elixir os parênteses também são opcionais e como o Phoenix implementa helpers muito parecidos com a versão Rails, como o "form_for", a gente se sente confortável muito rápido.

O Rails tem um layout padrão em <tt>app/views/layouts/application.html.erb</tt> e o Phoenix tem um layout padrão em <tt>web/templates/layout/app.html.eex</tt>. O resto é bem a mesma coisa.

O <tt>mix phoenix.gen.html</tt> cria uma estrutura de templates parecida com a do comando <tt>rails generate scaffold</tt>.

O que o Phoenix chama de "views" é mais parecido com o que o Rails chama de "helpers". Podemos usá-las de forma semelhante; por exemplo, para acessar a sessão do usuário atual, fazemos assim no Phoenix em <tt>web/views/layout_view.ex</tt>:

```ruby
# web/views/layout_view.ex
defmodule Pxblog.LayoutView do
  use Pxblog.Web, :view

  def current_user(conn) do
    Plug.Conn.get_session(conn, :current_user)
  end
end
```

Que é praticamente igual ao <tt>app/helpers/application.rb</tt> do Rails:

```ruby
# app/helpers/application.rb
module ApplicationHelper
  def current_user
    session[:current_user]
  end
end
```

Por fim, o scaffolding padrão do Phoenix já vem com Bootstrap, então fica bem mais bonito que o "scaffold.css" de 10 anos atrás que o Rails gera por padrão. Existem várias gems que fazem essa substituição, claro.

### Testes

A última coisa é o sistema de testes. O Rails usa Minitest, o Elixir usa ExUnit. De novo, os helpers são tão parecidos que você consegue traduzir quase diretamente do Phoenix para o Rails e vice-versa.

Como ressalva, os testes do Rails evoluíram muito na última década. Mesmo sem adicionar features extras como o Factory Girl, as Fixtures padrão ainda não têm equivalente no Phoenix (#OpportunityToContribute!).

Vamos começar vendo um pequeno teste de modelo no Phoenix:

```ruby
# test/models/post_test.ex
defmodule Pxblog.PostTest do
  use Pxblog.ModelCase

  alias Pxblog.Post

  @valid_attrs %{body: "some content", title: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?
  end
end
```

E os mesmos testes unitários em Rails:

```ruby
# test/models/post_test.rb
require 'test_helper'

class PostTest < ActiveSupport::TestCase
  setup do
    @valid_attr = {body: "some content", title: "some content"}
    @invalid_attr = {}
  end

  test "with valid attributes" do
    post = Post.new(@valid_attr)
    assert post.valid?
  end

  test "with invalida attributes" do
    post = Post.new(@invalid_attr)
    refute post.valid?
  end 
end
```

Notavelmente parecidos. Para os dados de teste, no Phoenix estamos usando atributos de módulo simples do Elixir; no Rails colocamos no setup para criar variáveis de instância. Eles não são a mesma coisa, mas o resultado é parecido. De novo, no Rails testamos o modelo, no Phoenix testamos o changeset.

Agora vamos ver um pedaço de um teste de controller. Como falei antes, como o Phoenix não tem uma feature de Fixtures ou Factory disponível (apesar de o pessoal legal da Thoughtbot ter acabado de lançar uma biblioteca estilo Factory Girl para Phoenix chamada [ExMachina](https://robots.thoughtbot.com/announcing-ex-machina)), temos que fazer um pouco mais de setup:

```ruby
# test/controllers/session_controller.ex
defmodule Pxblog.SessionControllerTest do
  use Pxblog.ConnCase
  alias Pxblog.User

  setup do
    User.changeset(%User{}, %{username: "test", password: "test", password_confirmation: "test", email: "test@test.com"})
    |> Repo.insert
    conn = conn()
    {:ok, conn: conn}
  end

  test "shows the login form", %{conn: conn} do
    conn = get conn, session_path(conn, :new)
    assert html_response(conn, 200) =~ "Login"
  end

  test "creates a new user session for a valid user", %{conn: conn} do
    conn = post conn, session_path(conn, :create), user: %{username: "test", password: "test"}
    assert get_session(conn, :current_user)
    assert get_flash(conn, :info) == "Sign in successful!"
    assert redirected_to(conn) == page_path(conn, :index)
  end
  ...
end
```

O teste de controller no Rails está pegando os dados de uma Fixture, por isso o setup é mais curto:

```ruby
# test/controllers/session_controller.rb
require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  setup do
    @user = users(:user_one)
  end

  test "shows the login form" do
    get :new
    assert_response :success
  end

  test "creates a new user session for a valid user" do
    post :create, user: {username: @user.username, password: "password"}
    assert session[:current_user]
    assert flash[:notice] == "Sign in successful!"
    assert_redirected_to user_posts_path(@user)
  end
  ...
```

Mas como falei antes, o Phoenix implementa helpers parecidos, então é bem direto portar de Rails para Phoenix aqui.

Você executa o test runner do Rails com <tt>rake test</tt> e o do Phoenix com <tt>mix test</tt>. Não tem muito o que ver aqui. Os testes carregam muito rápido, eu acredito que rodam em paralelo, e é bem rápido, o que é uma boa diferença em relação a quando você tem uma aplicação Rails grande de verdade, onde a suíte de testes pode levar minutos para terminar.

### Conclusões

Se você chegou até aqui, talvez se interesse em seguir o tutorial do Brandon e depois construir sua própria cópia em Rails, ou pode simplesmente clonar dos meus repositórios no Github. [Este é o exercício Phoenix](https://github.com/akitaonrails/pxblog_phoenix_exercise) e [este é o exercício Rails](https://github.com/akitaonrails/pxblog_rails_exercise).

O que dá para concluir até aqui é que o Phoenix já é um framework web bem completo. E isso sem nem tocar no que eu considero seu maior feito: o suporte notável a Websockets que recentemente foi testado e benchmarkado com máquinas de verdade da Digital Ocean, alcançando um pico de [**2 milhões de conexões concorrentes**](http://www.akitaonrails.com/2015/10/29/phoenix-experiment-holding-2-million-websocket-clients).

Eu acho que esse é o caso de uso real para o Phoenix: microserviços que entreguem a promessa do Erlang OTP de alta confiabilidade e alta concorrência. Para esse objetivo já está pronto para produção, e você pode usá-lo agora mesmo. Ainda há muito a se aprender sobre tuning adequado, monitoramento adequado, troubleshooting adequado em ambiente de produção, e por aí vai, mas está chegando lá.

Como substituto completo do Ruby on Rails, ainda não está no mesmo nível. Mas é injusto dizer isso, porque um framework novo não consegue competir com 10 anos de um ecossistema inteiro criando todo tipo de feature, ferramenta e técnica. O Rails é uma potência e vai continuar sendo.

Neste exemplo simplificado já notamos uma pequena feature que ainda não temos no Phoenix: o equivalente a <tt>ActiveSupport#has_secure_password</tt>. Mas isso não é tudo: ainda não temos os equivalentes para Devise, Simple Forms, Active Admin ou Rails Admin, Refile, Koala, Spree, etc. Mas podemos ter, à medida que o ecossistema for preenchendo as lacunas (#OpportunityToContribute!) desse novo ecossistema Phoenix. E eu encorajo as pessoas a fazerem isso, já que a Thoughtbot já entregou o ExMachina para quem gosta do Factory Girl entrar de cabeça.

Do jeito que está agora, parece a época em que o Rails 1.2 acabou de ser lançado: muitas bibliotecas eram jovens demais, ainda não tínhamos ferramentas maduras. Mas o trunfo do Phoenix e do Elixir é o núcleo Erlang, com décadas de uso e testado em batalha. Isso é algo que ninguém mais tem, e a melhor maneira de capitalizar isso é ir além do que ferramentas como Node.js conseguiram: um ambiente de programação realmente **prazeroso**, com uma linguagem que foi muito bem projetada e que mira na felicidade do programador, e ainda por cima com um núcleo muito maduro.

Programadores não deveriam ter que brigar por coisas pequenas. Gerenciamento de tarefas? Resolvido, use Mix. Gerenciamento de pacotes? Resolvido, use Hex. Promises? Não precisa. Semântica de require? Não precisa. Você entendeu a ideia.

Se você é programador Rails e quer encontrar uma plataforma companheira para incrementar suas soluções Rails existentes com microserviços de alta confiabilidade e alta concorrência, o Phoenix é uma opção pronta para produção agora mesmo. Pula dentro!
