---
title: Phoenix "15 Minute Blog" comparison to Ruby on Rails
date: '2015-11-20T17:52:00-02:00'
slug: phoenix-15-minute-blog-comparison-to-ruby-on-rails
tags:
- learning beginner elixir phoenix english
draft: false
---

*Update 11/23/15:* Chris McCord, Phoenix creator, just posted an article explaining why ["Phoenix is not Rails"](https://dockyard.com/blog/2015/11/18/phoenix-is-not-rails) It goes in detail in many things I described in this article and I highly recommend you read it too.

If you've been following the Elixir blogosphere, chances are that you stumbled upon [Brandon Richey's](https://medium.com/@diamondgfx) take on the classic "15 minute blog". If you didn't you must read at least [Part 1](https://medium.com/@diamondgfx/introduction-fe138ac6079d#.ffl48saew) and [Part 2](https://t.co/DjGDek1ZOk). It's a very detailed tutorial that will make it easier to get your fingers wet with Phoenix goodness.

This post is intended for Rails programmers wanting to know how the Phoenix Framework compare. It's not a completely fair comparison as this is just the good old nested resources "hello world" exercise. This will only scratch the surface but should serve as a good introduction.

For better or for worse, many still consider Ruby on Rails to be the best DSL for a web application. Rails was successful in creating a very recognizable vocabulary to describe each component of a web project. And I will argue that one of Phoenix's strenghts is to successfully borrow the same metaphor. This definitely makes the learning curve much smoother.

If you just want to clone the exercises and jump right into the code itself, I have the original [Pxblog in Phoenix](https://github.com/akitaonrails/pxblog_phoenix_exercise) and the comparison [Pxblog in Rails](https://github.com/akitaonrails/pxblog_rails_exercise).

### Getting Started: command line and folder structure

Without further ado, let's start comparing the basic console commands:

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
# iex -S mix phoenix.server to start within IEx and be able to IEx.pry
```

Right off the bat we feel at home. In the Rails world we have both the <tt>rails</tt> command competing with traditional <tt>rake</tt> task managers. At the Phoenix side, they fortunatelly concentrated everything under the Elixir built-in <tt>mix</tt> command. There seems to be discussions for the Rails command tasks to be moved to Rake where they belong, but it's not coming soon.

As it is all under Mix territory, you can list Phoenix related tasks like this:

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

The directory structure that <tt>phoenix.new</tt> generates is slightly different from Rails though:

```
/_build              # binary stuff mix compiles (ignore)
/config
- config.exs         # think Rails' /config/application.rb
- dev.exs            # think Rails' /config/environments/development.rb
- prod.exs           # think Rails' /config/environments/production.rb
- prod.secret.exs    # think Rails' /config/secrets.yml
- test.exs           # think Rails' /config/environments/test.rb
/deps                # where mix deps.get put dependencies
/lib
  /pxblog
    - endpoint.ex    # a bit like config.ru and application.rb
    - repo.ex        # setup for Ecto
  - pxblog.ex        # where you can setup OTP apps supervision tree 
/node_modules        # Phoenix integrates with Node.js
/priv
  /repo
    /migrations      # think Rails' /db/migrate
    - seeds.exs      # think Rails' /db/seeds.rb
  /static            # think Rails' /public
    /css
    /images
    /js
/test                # think Rails' /test
  /channels
  /controllers
  /models
  /support
  /views
  - test_helper.exs  # think Rails' /test/test_helper.rb
/web                 # think Rails' /app
  /channels          # think Rails 5's ActionCable channels
  /controllers
  /models
  /static            # think Rails' /app/assets
    /assets
      /images
      /css
      /js
      /vendor
  /templates         # think Rails' /app/views
    /layout
  /views             # think Rails' /app/helpers but with Presenters
    - layout_view.ex
  - router.ex        # think Rails' /config/routes.rb
  - web.ex           # macros to configure each MVC component
- .gitignore
- README.md
- brunch-config.js  # front-end dev reloading is controlled with Brunch
- mix.exs           # think Ruby's Gemfile (with extras)
- package.json      # Node.js dependencies
```

In Rails, the starting point is the <tt>config.ru</tt> Rackup application (as Rails became a Rack app since 3.0). It then load the <tt>config/environment.rb</tt>, then <tt>config/application.rb</tt>, then <tt>config/boot.rb</tt> which loads the gems declared in the <tt>Gemfile</tt>, together with <tt>config/initializers/*.rb</tt> and each file in <tt>config/environments</tt> we setup the Rails::Application and plug in configuration, the pipeline of Rack Middlewares.

In Phoenix, the starting point - as in any Elixir app -- is the <tt>mix.exs</tt> file. In this case it points to the "Pxblog" OTP/Phoenix app defined in <tt>lib/pxblog/pxblog.ex</tt>. In turn it starts up and supervises the "Pxblog.Endpoint" and "Pxblog.Repo" apps, which are defined in <tt>lib/pxblog/endpoint.ex</tt> and <tt>lib/pxblog/repo.ex</tt>, respectivelly.

If you build other OTP apps, this is where you can add to the OTP Supervisor Tree. I could say that it could be something akin of a Rails Engine, although technically it is not the same thing, but possibly this metaphor will do.

One main aspect of Rails is how it divides development, test, and production configuration in different files. Phoenix has the same thing at <tt>dev.exs</tt>, <tt>test.exs</tt>, and <tt>prod.exs</tt>. This is actually a [Mix feature](http://elixir-lang.org/getting-started/mix-otp/introduction-to-mix.html#environments). Mix is a more accomplished version of Rake, and it makes sense as José Valim also tried to push Thor to replace Rake, althought it never picked up steam in the Ruby community (Rake being so ingrained everywhere). Web frameworks that don't enforce separation of environments by default, at this day and age, are useless. The cool thing is that every Elixir app generated through Mix get this same useful feature.

Instead of having a <tt>database.yml</tt>, the database configuration is spread through the environment configuration files and the production settings are in a separated <tt>prod.secret.exs</tt> file, which is obviously ignored in <tt>.gitignore</tt>, like Rails' <tt>secrets.yml</tt> file.

### MVC structure

You will see that each element of the MVC app in Phoenix start like this:

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

This <tt>Pxblog.Web</tt> module is defined in the <tt>web/web.ex</tt> like this:

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

If you haven't yet, this is a good time to learn about [Elixir Macros](http://elixir-lang.org/getting-started/meta/macros.html). Think of the code in the <tt>quote</tt> block as being "injected" in each module that calls <tt>use Pxblog.Web</tt>. When you <tt>use</tt> a module it calls the <tt>__using__</tt> macro. Think of it like a Ruby Module Mixin calling the <tt>included</tt> callback and executing a <tt>class_eval</tt>. As there is no concept of Classes and subclasses, we include mixins in each class to acquire the desired behaviours.

### MVC Router

Different from Rails <tt>config/routes.rb</tt> which defines routes, the <tt>web/router.ex</tt> defines not only the routes themselves but also transformation pipelines and routing strategies:

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

You have to read it like this:

The <tt>pipeline</tt> block plugs "filters". They are similar to Rack middlewares that we define in <tt>config/application.rb</tt> in Rails. This is very clever because one key different between vanilla Ruby on Rails and the [Rails-API project](https://github.com/rails-api/rails-api) is the removal of unneeded Rack middlewares that API endpoints don't need.

In Phoenix we can define one pipeline for web browsers and another for API clients, and you see that the difference is the removal of Plugs.

Then we define the scopes based on the root paths. There is one scope "/" which connectes to the <tt>:browser</tt> pipeline and an optional (commented out) scope "/api" which pipes through the <tt>:api</tt> pipeline.

Inside the scope block, it's very similar to the Restful DSL to define routes, which again is a good adaptation from Rails Routes. [Read the documentation](http://www.phoenixframework.org/docs/routing) to know the details.

Also similar to Rails Routes, it generates proper URL helpers that become available in Controllers, Views and Templates. Let's start seeing some Rails URL helpers in code:

```html
<!-- app/views/posts/edit.html.erb -->
<%= link_to 'Show', [@user, post] %>
<%= link_to 'Edit', edit_user_post_path(@user, post) %>
<%= link_to 'Destroy', [@user, post], method: :delete, data: { confirm: 'Are you sure?' } %>
```

And in Phoenix:

```html
<!-- web/templates/post/edit.html.eex -->
<%= link "Show", to: user_post_path(@conn, :show, @user, post) %>
<%= link "Edit", to: user_post_path(@conn, :edit, @user, post) %>
<%= link "Delete", to: user_post_path(@conn, :delete, @user, post), method: :delete, data: [confirm: "Are you sure?"] %>
```

The main URL helper in Rails is able to get an Array such as <tt>[@user, post]</tt> and execute it the same way as if we wrote <tt>user_post_path(@user, post)</tt>. One difference from Rails is that instead of creating one helper for each HTTP verb you have just one helper per resource that accepts an extra parameter to indicate the verb. So we have <tt>post_path(@conn, :edit, post)</tt> instead of the Rails way of <tt>edit_post_path(post)</tt>.

As with Rails middlewares, a pipeline receives the request connection and pipes it through transforming it's metadata so it cleaned up and usable within our controllers.

### MVC Controller

In Phoenix we start a controller like this:

```ruby
# web/controllers/post_controller.ex
defmodule Pxblog.PostController do
  use Pxblog.Web, :controller
  
  alias Pxblog.Post
  
  plug :scrub_params, "post" when action in [:create, :update]
  plug :assign_user
  plug :authorize_user when action in [:new, :create, :update, :edit, :delete]
```

It's similar to this Rails controller setup:

```ruby
# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  before_action :assign_user
  before_action :authorize_user, only: [:new, :create, :update, :edit, :destroy]
```

As you may have concluded, a <tt>plug</tt> call works a bit like a <tt>before_action</tt> pipeline. The <tt>scrub_params</tt> I believe is similar Rails' <tt>ActionDispatch::ParamParser</tt>, but I'm not sure, I know it clears out empty string values into nils so you don't update your models unnecessarily.

But different from Rails where a call to <tt>redirect_to</tt> halts the pipeline, we need to explicitly halt the pipeline like this:

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

In Phoenix, everything revolves around a request connection transformation pipeline that you can start configuring in the Router Plugs, Controller Plugs and Controller actions. All of them receive the connection from the previous step and returns a transformed connection to the next step until it becomes a proper HTTP response. Unlike Rails, this path is much more explicit and you know that you will get this connection and you should pipe transformations through it until you render the final HTML or send back some error header.

To see how explicit, let's start with a normal Rails controller action:

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

Once upon a time, setting the flash notice message and redirecting were 2 different methods, new versions merged them together for convenience. Rails also has the concept of Responders, which Phoenix doesn't have yet (#OpportunityToContribute!).

```ruby
def delete(conn, %{"id" => id}) do
  user = Repo.get!(User, id)
  Repo.delete!(user)
  conn
  |> put_flash(:info, "User deleted successfully.")
  |> redirect(to: user_path(conn, :index))
end
```

You can see that, Responsers aside, the Phoenix version is **remarkably** similar. And it goes like this for all Restful actions of the controller. But more similar to the deceased Merb, each Phoenix Controller action has a proper function signature declaring the parameters it expect to receive instead of having a global <tt>params</tt> hash that needs to go through the [Strong Parameters](https://github.com/rails/strong_parameters).

For different variations of the same parameters, you can declare multiple functions with the same name but different arguments to pattern match, like in the <tt>SessionController</tt> example:

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

Here we have the same <tt>create/2</tt> function with pattern matching and guards. The second version receives anything, in case the first version fails to pattern match against the incoming parameters. Phoenix expects roughly the same structure of parameters as Rails, so it's very intuitive to follow.

### MVC Models

Instead of the good old ActiveRecord (ActiveModel), in Phoenix we have to deal with [Ecto Models](http://www.phoenixframework.org/docs/ecto-models). It already supports Postgresql, MySQL, Sqlite3, MongoDB, so you're good to go for 99% of the cases.

Ecto separates Model Logic from Model Persistence Management. Instead of using the Active Record design pattern, it favors the Data Mapper pattern. This is an old discussion among Railers. Many people dislike that persistence logic is kept together with business logic and the many magic metaprogramming that can make ActiveRecord both very easy to get started but very difficult to properly master.

You should read José Valim's post about [Ecto Associations](http://blog.plataformatec.com.br/2015/08/working-with-ecto-associations-and-embeds/) to get started. But for now, let's compare a simple Rails and Ecto models:

```ruby
# app/models/user.rb
class User < ActiveRecord::Base
  has_secure_password

  has_many :posts

  validates :username, presence: true
  validates :email, presence: true
end
```

In Rails we have the [<tt>ActiveSupport#has_secure_password</tt>](http://api.rubyonrails.org/classes/ActiveModel/SecurePassword/ClassMethods.html) which uses BCrypt underneath to generate a proper password digest. If you're building authentication from scratch you **must** use this construct.

Phoenix does not have the same feature yet (#OpportunityToContribute!) so its version is a bit more verbose to account for the BCrypt digest logic using the [Comeonin](https://github.com/elixircnx/comeonin) password hashing library. Let's go on in small steps:

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

The first part of Ecto Models declare the database fields, virtual fields and associations. Rails ActiveRecord prefer the approach of asking the database to send the table metadata and use metaprogramming to create all the fields later in runtime. Many people dislike this approach and this is the alternative: explicit declaration.

We are mapping the <tt>User</tt> module with the <tt>'users'</tt> database table in the <tt>schema "users" do</tt> statement instead of resorting to pluralization conventions.

The last line has our well known <tt>has_many</tt> association.

```ruby
defmodule Pxblog.User do
  ...
  @required_fields ~w(username email password password_confirmation)
  @optional_fields ~w()
  ...
end
```

Here we have declare required fields, this is just a variable with a list of fields not the validations themselves. This will be used in the next step to accomplish something similar to <tt>validates :username, presence: true</tt>. 

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

Instead of doing something like <tt>Post.create(params)</tt> we first create a changeset and then pass it to the Ecto main Repository. The Repository is then responsible for the persistence part. The Ecto Model is responsible for validating and cleaning up the changeset that the Repository receives.

The <tt>changeset/2</tt> returns an [Elixir Struct](http://elixir-lang.org/getting-started/structs.html) for us to work with before passing it to the Repository application for persistence.

In this function we can declare a pipeline of validations, constraints and other attribute transformations. For example, we plug a <tt>hash_password/2</tt> function that will get the value in <tt>password</tt> and use Comeonin.<tt>hashpwsalt/1</tt> to transform the password string in a bcrypt digest and store it in the password_digest attribute:

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

And we return the transformed changeset so the pipeline can pick it up and pass to other plugs, such as validations. If we wanted to add more validations we could do it like this:

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

There you go. And in the controller, the <tt>update/2</tt> function, for example, will use the changeset like this:

```ruby
def update(conn, %{"id" => id, "user" => user_params}) do
  user = Repo.get!(User, id)
  changeset = User.changeset(user, user_params)
  case Repo.update(changeset) do
  ...
end
```

In the second line we use the Repository to query the 'users' schema as declared in the <tt>User</tt> model.

Then, we transform the <tt>user</tt> struct with the <tt>user_params</tt> map that we received from the Router pipeline, as defined in the first line.

The transformation returns a changeset, which will contain error messages. Then we pass the changeset to the Repository again so it updates the record in the table.

### MVC View and Templates

In the case of the <tt>edit/2</tt> function we call the <tt>render/3</tt> function like this:

```ruby
# web/views/user_view.ex
def edit(conn, %{"id" => id}) do
  user = Repo.get!(User, id)
  changeset = User.changeset(user)
  render(conn, "edit.html", user: user, changeset: changeset)
end
```

This first calls the <tt>web/views/user.ex</tt> which import stuff like helpers, transforms the <tt>user</tt> and <tt>changeset</tt> variables into [module attributes](http://elixir-lang.org/getting-started/module-attributes.html) (the ones starting with "@" if you've been wondering what those are). And the View knows to find the <tt>edit.html</tt> template at <tt>web/templates/user/edit.html.eex</tt> because it says so in <tt>web/web.ex</tt>:

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

I did not copy and paste all the other macros in <tt>web/web.ex</tt> but check them out to see what models, controllers, router, channel import in each module you create.

In Rails we have the default ERB for "Embedded Ruby" and in Phoenix we have "EEX" for "Embedded Elixir", it's essencially the same thing: an HTML template that accepts snippets of Elixir code enclosed between <tt><%= ... %></tt>. So, the <tt>edit.html.eex</tt> template looks like this:

```html
<!-- app/views/users/edit.html.erb -->
<h2>Edit user</h2>

<%= render "form.html", changeset: @changeset,
                        action: user_path(@conn, :update, @user) %>

<%= link 'Back', to: user_path(@conn, :show, @user) %> |
<%= link "Back", to: user_path(@conn, :index) %>
```

Which is very similar to the equivalent <tt>edit.html.erb</tt> in Rails:

```html
<!-- web/templates/user/edit.html.eex -->
<h1>Editing User</h1>

<%= render 'form' %>

<%= link_to 'Show', @user %> |
<%= link_to 'Back', users_path %>
```

The Phoenix version is slightly more verbose in order to not hide too much as Rails does. One can argue if more or less magic makes it more productive or not, but the Phoenix version being more explicit leaves a trail of breadcrumbs that is easier to follow, specially if you're just getting started. Here we have no concept of "partials", every template can render any other template, we just need to pass through the necessary variable for the template to function. But instead of passing a model instance we are passing a changeset.

The "form.html" template is also very similar, let's check out the Phoenix version first:

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

And now the Rails ERB version:

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

Remarkably similar. There are language specific stuff like having <tt>label(f, :username)</tt> instead of <tt>f.label :username</tt>. Because in Elixir the parenthesis are also optional and because Phoenix implements helpers that are very similar to the Rails version, like "form_for", we feel very comfortable very fast.

Rails has a default layout at <tt>app/views/layouts/application.html.erb</tt> and Phoenix has a default layout at <tt>web/templates/layout/app.html.eex</tt>. The rest is pretty much the same.

The <tt>mix phoenix.gen.html</tt> creates a template structure that is similar to <tt>rails generate scaffold</tt> command.

What Phoenix calls "views" is more similar to what Rails calls "helpers". We can use them similarly, for example, to access the current user session, we do like this in Phoenix <tt>web/views/layout_view.ex</tt>:

```ruby
# web/views/layout_view.ex
defmodule Pxblog.LayoutView do
  use Pxblog.Web, :view

  def current_user(conn) do
    Plug.Conn.get_session(conn, :current_user)
  end
end
```

Which is almost the same as <tt>app/helpers/application.rb</tt> in Rails:

```ruby
# app/helpers/application.rb
module ApplicationHelper
  def current_user
    session[:current_user]
  end
end
```

Finally, Phoenix default scaffolding already brings in Bootstrap so it looks much nicer than the 10 years old "scaffold.css" that Rails generates by default. There are many gems that override that though.

### Tests

The last thing is the testing system. Rails uses Minitest, Elixir uses ExUnit. Again, the helpers are so similar that you can translate almost directly from Phoenix to Rails and vice versa.

As a caveat, Rails tests evolved a lot in the past decade. Even without adding extra features such as Factory Girl, the standard Fixtures still don't have equivalent in Phoenix (#OpportunityToContribute!).

Let's start seeing a small model test in Phoenix:

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

And the same unit tests in Rails:

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

Remarkably similar. For the test data, in Phoenix we are using simple Elixir's module attributes, in Rails we put in the setup step to create instance variables. They are not the same thing, but the result is similar. Again, in Rails we test the model, in Phoenix we test the changeset.

Now let's see some bits of a controller test. As I said before, because Phoenix does not have a Fixtures or Factory feature in place (although the nice guys at Thoughtbot just released a Factory Girl-like library for Phoenix called [ExMachina](https://robots.thoughtbot.com/announcing-ex-machina)) we have to do a bit more setup:

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

The Rails controller test is getting the data from a Fixture, that's why the setup is shorter:

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

But as I said before, Phoenix implements similar helpers, so it's very straight forward to port from Rails to Phoenix here.

You execute the test runner in Rails with <tt>rake test</tt> and in Phoenix with <tt>mix test</tt>. Not a lot to see here. Tests load very fast, I believe they run in parallel, and it's very fast, which is a good departure from when you have a really large Rails app where a test suite can take minutes to finish.

### Conclusions

If you came this far, you may be interested in following Brandon's tutorial and then building your own Rails copy or you can just clone from my Github repositories. [This is the Phoenix exercise](https://github.com/akitaonrails/pxblog_phoenix_exercise) and [this is the Rails exercise](https://github.com/akitaonrails/pxblog_rails_exercise).

What you can conclude thus far is that Phoenix is already a very full featured web framework. And this is not even touching on what I think is its crown achievement: its remarkable Websockets support that recently tested and benchmarked with real machines from Digital Ocean and achieve a peak performance of [**2 million concurrent connections**](http://www.akitaonrails.com/2015/10/29/phoenix-experiment-holding-2-million-websocket-clients).

I think this is the real use case for Phoenix: microservices to deliver on Erlang OTP's promise of hiper reliability and hiper concurrency. For that goal it's already production ready and you can use it right now. There is still much to be learned regarging proper tuning, proper monitoring, proper production environment troubleshooting, and so on, but it's getting there.

As a complete Ruby on Rails replacement, it is not on par yet. But it's unfair to say that because a new framework can't compete with 10 years of an entire ecosystem creating all sorts of features, tools and techniques for it. Rails is power house and it will continue to be so.

In this contrived example we already got one small feature we still don't have in Phoenix: the equivalent of <tt>ActiveSupport#has_secure_password</tt>. But this is not all, we still don't have the equivalents for Devise, Simple Forms, Active Admin or Rails Admin, Refile, Koala, Spree, etc. But we can have those, as the ecosystem starts to fill in the blanks (#OpportunityToContribute!) in this brand new Phoenix ecosystem. And I urge people to do so, as Thoughtbot already delivered their ExMachina so those who like Factory Girl can jump right in.

As it stands right now, it feels like the time when Rails 1.2 was just released, many libraries were just too young, we still didn't have mature tools. But the upper hand of Phoenix and Elixir is the decades old and battle tested Erlang core. This is something no one else has and the best way to capitalize it is to go beyond what tools like Node.js had accomplished: a truly **enjoyable** programming environment, with a language that was truly well designed and targets programmer happiness, with a really mature core to boot.

Programmers shouldn't have to be fight for small stuff. Task management? Done, use Mix. Package Management? Done, use Hex. Promises? Don't need. Require semantics? Don't need. You get the gist.

If you're a Rails programmer and you want to find a companion platform to increment your existing Rails solutions with highly reliable and highly concurrent microservices, Phoenix is an option ready to production right now. Jump right into it!
