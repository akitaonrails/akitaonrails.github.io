---
title: "Coherence e ExAdmin - Devise e ActiveAdmin para Phoenix"
date: '2016-12-06T18:18:00-02:00'
slug: coherence-e-exadmin-devise-e-activeadmin-para-phoenix
translationKey: coherence-exadmin-phoenix
aliases:
- /2016/12/06/coherence-and-exadmin-devise-and-activeadmin-for-phoenix/
tags:
- elixir
- phoenix
- activeadmin
- devise
- traduzido
draft: false
---

Este post é voltado para Rubyistas pesquisando a possibilidade de substituir parte do Ruby e Rails com Elixir e Phoenix.

Indo direto ao ponto: muitos dos meus apps Rails pequenos começam com 2 add-ons bem simples — Devise para autenticação e ActiveAdmin para gerenciamento básico do banco de dados. A partir daí construo o resto.

Tanto Elixir quanto Phoenix são alvos em constante movimento hoje em dia, o que dificulta que um conjunto estável de bibliotecas se solidifique direito. Mas acho que estamos finalmente passando da curva dos early adopters.

Um ponto de atrito considerável sempre foi a autenticação de usuários. Muitos puristas vão argumentar que você precisa construir a sua do zero ou usar bibliotecas de baixo nível como o [Guardian](https://github.com/ueberauth/guardian).

Se você está construindo uma aplicação que só expõe endpoints de API, tudo bem. Mas para um app web completo feito para humanos usarem, essa dificilmente é uma boa escolha. Não vou entrar nessa discussão hoje, pois foge do ponto.

Assumo que você já seguiu os tutoriais tanto do [Elixir](http://elixir-lang.org/getting-started/introduction.html) quanto do [Phoenix](http://www.phoenixframework.org/docs/installation). Se ainda não fez, vá lá e faça — vai levar uns um ou dois dias para aprender o básico se você já é um Rubyista experiente. Depois volta e lê [meus posts sobre Elixir](/elixir) para entender onde ele se destaca em relação ao resto.

Dito isso, vamos começar.

### Coherence (alternativa ao Devise)

Finalmente encontrei este projeto que está em desenvolvimento intenso há 6 meses chamado [Coherence](https://github.com/smpallen99/coherence). Para todos os efeitos práticos, ele imita o Devise em quase todos os aspectos. E isso é muito bom para uma série de cenários.

O [README](https://github.com/smpallen99/coherence/blob/master/README.md) deles é bem explicado, então não vou copiar e colar aqui — é só ler lá para colocar no ar. Mas se você quiser testar todas as funcionalidades, pode ajustar o procedimento com esse conjunto de opções na task de instalação do Mix:

```
mix coherence.install --full --rememberable --invitable --trackable
```

Execute `mix help coherence.install` para ver a descrição de todas as opções.

E se você não for mexer no front-end, pode simplesmente adicionar os links de sign up, sign in e sign out ao layout adicionando o seguinte trecho em `web/templates/layout/app.html.eex`:

```html
<header class="header">
  <nav role="navigation">
    <ul class="nav nav-pills pull-right">
      <%= if Coherence.current_user(@conn) do %>
        <%= if @conn.assigns[:remembered] do %>
          <li style="color: red;">!!</li>
        <% end %>
      <% end %>
      <%= YourApp.Coherence.ViewHelpers.coherence_links(@conn, :layout) %>
      <li><a href="http://www.phoenixframework.org/docs">Get Started</a></li>
    </ul>
  </nav>
  <span class="logo"></span>
</header>
...
```

(A propósito, sempre que você ver `YourApp` nos trechos de código, troque pelo nome do módulo da sua aplicação.)

Se você se perder na documentação deles, pode consultar o repositório [Coherence Demo](https://github.com/smpallen99/coherence_demo) para ver um exemplo de app Phoenix básico com Coherence já configurado e funcionando. Você vai precisar principalmente cuidar do `web/router.ex` para criar um pipeline `:protected` e configurar os escopos adequadamente.

Se fizer corretamente, é isso que você vai ver:

![Coherence Navigation Links](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/572/Screen_Shot_2016-12-06_at_17.45.47.png)

![Coherence Sign In Form](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/573/Screen_Shot_2016-12-06_at_17.45.52.png)

Faz tempo que eu não ficava animado com uma simples página de login!

### Ex Admin (alternativa ao ActiveAdmin)

O próximo passo que costumo dar é adicionar uma interface de administração simples. Para isso encontrei o [Ex Admin](https://github.com/smpallen99/ex_admin), que está em desenvolvimento ativo desde pelo menos maio de 2015. É tão parecido com ActiveAdmin que o tema antigo deles vai te fazer esquecer que não está num app Rails.

De novo, é bem direto configurar — basta seguir as instruções do [README](https://github.com/smpallen99/ex_admin) deles.

Com tudo instalado e configurado, você consegue expor o model User na interface Admin rapidamente assim:

```
mix admin.gen.resource User
```

E podemos editar o `web/admin/user.ex` com o seguinte:

```ruby
defmodule YourApp.ExAdmin.User do
  use ExAdmin.Register

  register_resource YourApp.User do
    index do
      selectable_column

      column :id
      column :name
      column :email
      column :last_sign_in_at
      column :last_sign_in_ip
      column :sign_in_count
    end

    show _user do
      attributes_table do
        row :id
        row :name
        row :email
        row :reset_password_token
        row :reset_password_sent_at
        row :locked_at
        row :unlock_token
        row :sign_in_count
        row :current_sign_in_at
        row :last_sign_in_at
        row :current_sign_in_ip
        row :last_sign_in_ip
      end
    end

    form user do
      inputs do
        input user, :name
        input user, :email
        input user, :password, type: :password
        input user, :password_confirmation, type: :password
      end
    end
  end
end
```

Sim, isso é assustadoramente similar ao DSL do ActiveAdmin. Parabéns para o time responsável — e isso mostra bem como o Elixir é adequado para Domain Specific Languages, se você curte isso.

Se você seguiu as instruções do Coherence, ele pede para adicionar um pipeline `:protected` (um conjunto de plugs) para suas rotas protegidas. Por ora, você pode adicionar a rota `/admin` para passar por esse pipeline. Para os não iniciados, um "plug" é similar em conceito a um app Rack, ou mais especificamente, a um middleware do Rails. Mas no Rails temos apenas um pipeline de middlewares. No Phoenix podemos configurar múltiplos pipelines para diferentes conjuntos de rotas (browser e api, por exemplo).

Então podemos adicionar o seguinte ao `web/router.ex`:

```ruby
...
scope "/admin", ExAdmin do
  pipe_through :protected
  admin_routes
end
...
```

Com essas configurações simples no lugar, você vai terminar com algo assim:

![Ex Admin](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/574/Screen_Shot_2016-12-06_at_17.56.17.png)

E se ainda não estiver convencido, que tal mudar para o tema antigo deles?

![ActiveAdmin knockoff](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/575/Screen_Shot_2016-12-06_at_17.56.25.png)

Caramba! Me sinto em casa, embora eu prefira bastante o tema novo. Mas você poderia substituir seu app baseado em ActiveAdmin por este e seus usuários dificilmente vão notar as pequenas diferenças na interface. O comportamento é basicamente o mesmo.

Se ainda tiver dúvidas sobre como configurar o ExAdmin corretamente, confira o projeto [Contact Demo](https://github.com/smpallen99/contact_demo) deles, onde você encontra um exemplo real.

### Costurando um papel de Admin simples

Obviamente, não queremos que todos os usuários autenticados tenham acesso à seção de Admin.

Podemos adicionar um campo boolean simples na tabela de usuários para indicar se um usuário é admin ou não. Você pode alterar sua migration para ficar assim:

```ruby
...
def change do
  create table(:users, primary_key: false) do

    add :name, :string
    add :email, :string
    ...
    add :admin, :boolean, default: false
    ...
  end
end
...
```

E você pode configurar o arquivo `priv/repos/seeds.exs` para criar 2 usuários, um admin e um guest:

```ruby
YourApp.Repo.delete_all YourApp.User

YourApp.User.changeset(%YourApp.User{}, %{name: "Administrator", email: "admin@example.org", password: "password", password_confirmation: "password", admin: true})
|> YourApp.Repo.insert!

YourApp.User.changeset(%YourApp.User{}, %{name: "Guest", email: "guest@example.org", password: "password", password_confirmation: "password", admin: false})
|> YourApp.Repo.insert!
```

Como é só um exercício, você pode dropar o banco e recriar assim: `mix do ecto.drop, ecto.setup`.

O Coherence cuida da **autenticação**, mas precisamos cuidar da **autorização**. Você vai encontrar muitos exemplos online de algo semelhante ao Pundit do Rails, como o [Bodyguard](https://github.com/schrockwell/bodyguard). Mas neste post vou me limitar a um Plug simples e criar um novo pipeline no Router.

Precisamos criar `lib/your_app/plugs/authorized.ex` com o seguinte conteúdo:

```ruby
defmodule YourApp.Plugs.Authorized do
  @behaviour Plug

  import Plug.Conn
  import Phoenix.Controller

  def init(default), do: default

  def call(%{assigns: %{current_user: current_user}} = conn, _) do
    if current_user.admin do
      conn
    else
      conn
        |> flash_and_redirect
    end
  end

  def call(conn, _) do
    conn
      |> flash_and_redirect
  end

  defp flash_and_redirect(conn) do
    conn
      |> put_flash(:error, "You do not have the proper authorization to do that")
      |> redirect(to: "/")
      |> halt
  end
end
```

Quando um usuário faz login, o Coherence coloca a estrutura do usuário autenticado no `conn` (uma estrutura Plug.Conn), então podemos fazer pattern match a partir daí.

Agora precisamos criar o pipeline do router em `web/router.ex` assim:

```ruby
...
pipeline :protected_admin do
  plug :accepts, ["html"]
  plug :fetch_session
  plug :fetch_flash
  plug :protect_from_forgery
  plug :put_secure_browser_headers
  plug Coherence.Authentication.Session, protected: true
  plug YourApp.Plugs.Authorized
end
...
scope "/" do
  pipe_through :protected_admin
  coherence_routes :protected_admin
end
...
scope "/admin", ExAdmin do
  pipe_through :protected_admin
  admin_routes
end
...
```

O pipeline `:protected_admin` é exatamente igual ao `:protected`, mas adicionamos o plug `YourApp.Plugs.Authorized` recém-criado no final. Depois alteramos o escopo `/admin` para passar por esse novo pipeline.

E é isso. Se você logar com o usuário `guest@example.org`, ele será redirecionado para a homepage com uma mensagem dizendo que não está autorizado. Se logar com `admin@example.org`, terá acesso à interface do ExAdmin em `/admin`.

### Concluindo

Mesmo que agora seja relativamente simples adicionar Authentication, Administration e Authorization básica, não se engane — a curva de aprendizado ainda é íngreme, mesmo que você seja um desenvolvedor Rails experiente.

Por causa do que está por baixo — a arquitetura OTP, os conceitos de Applications, Supervisors, Workers, etc — não é imediatamente simples entender o que está **realmente** acontecendo. Se não tomar cuidado, bibliotecas como Coherence ou ExAdmin vão te fazer achar que é tão simples quanto Rails.

E não é assim. Elixir é uma criatura completamente diferente. E digo isso de forma alguma de maneira negativa — pelo contrário. Ele é feito para sistemas altamente confiáveis e distribuídos, e exige muito mais conhecimento, paciência e treinamento do programador.

Por outro lado, exatamente porque bibliotecas como o Coherence facilitam bastante o começo, você pode se tornar mais motivado a colocar algo em funcionamento e depois investir mais tempo realmente **entendendo** o que está acontecendo por baixo. Por isso a recomendação é: coloque a mão na massa, consiga aquela gratificação instantânea de ver algo rodando, e então vá refinando seu conhecimento. Vai ser muito mais recompensador assim.

Não vejo o Phoenix como um simples substituto do Rails. Isso seria pouco ambicioso. Vejo ele mais como uma peça para tornar o Elixir o conjunto de tecnologias mais adequado para construir **sistemas altamente escaláveis, altamente confiáveis e altamente distribuídos**. Parar em aplicações web simples não faria jus ao potencial do Elixir.
