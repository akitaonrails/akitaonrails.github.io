---
title: Coherence and ExAdmin - Devise and ActiveAdmin for Phoenix
date: '2016-12-06T18:18:00-02:00'
slug: coherence-and-exadmin-devise-and-activeadmin-for-phoenix
tags:
- elixir
- phoenix
- activeadmin
- devise
draft: false
---

This is intended for Rubyists researching the possibility of replacing some of Ruby and Rails with Elixir and Phoenix.

Cutting straight to the chase, many small Rails apps that I build start with 2 very simple add-ons: Devise for authentication and ActiveAdmin for basic database management. Then I build up from there.

Both Elixir and Phoenix are fast moving targets right now, which makes it difficult for a stable set of libraries to solidify properly, but I think that we're finally getting past the early adopters curve already.

One big point of contention has been user authentication. Many purists will argue that you need to build your own from scratch or by using low level libraries such as [Guardian](https://github.com/ueberauth/guardian).

If you're building an application that just exposes API endpoints, that's probably fine. But for a full-featured web app meant for humans to use, this is hardly a good choice. I will not entertain the discussion today, as it's beyond the point.

I am assuming that you at least followed both [Elixir](http://elixir-lang.org/getting-started/introduction.html) and [Phoenix](http://www.phoenixframework.org/docs/installation) tutorials by now. If you didn't go ahead and do it, it will take you one or two days to learn the very basics if you're already an experienced rubyist. Then come back and read [my posts on Elixir](/elixir) to understand where it stands out compared to everything else.

That being said, let's get started.

### Coherence (Devise alternative)

Finally, I found this project that's been under heavy development for the past 6 months called [Coherence](https://github.com/smpallen99/coherence). For all intents and purposes, it successfully mimics Devise in almost every way. And this is a very good thing for a lot of scenarios.

Their [README](https://github.com/smpallen99/coherence/blob/master/README.md) is well explained enough so I will not copy and paste it here, just read it there to get up and running. But if you want to try out all of their features you can tweak their procedure with this set of options in the installation Mix task:

```
mix coherence.install --full --rememberable --invitable --trackable
```

Run `mix help coherence.install` to see a description for all the options.

And if you're not tweaking the front-end, you can just add the proper sign up, sign in, sign out links by adding the following snippet to the `web/templates/layout/app.html.eex`:

--- html
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

(By the way, whenever you see `YourApp` in the code snippets, you must change for your app's module name.)

If you get lost in their documentation you can check out their [Coherence Demo](https://github.com/smpallen99/coherence_demo) repository for an example of a basic Phoenix app with Coherence already configured and working. You will mostly have to take care of `web/router.ex` to create a `:protected` pipeline and set the scopes accordingly.

If you do it correctly, this is what you will see:

![Coherence Navigation Links](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/572/Screen_Shot_2016-12-06_at_17.45.47.png)

![Coherence Sign In Form](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/573/Screen_Shot_2016-12-06_at_17.45.52.png)

It's been a long while since I got excited by a simple sign in page!

### Ex Admin (ActiveAdmin alternative)

Then, the next step I usually like to do is to add a simple Administration interface. To that end I found the [Ex Admin](https://github.com/smpallen99/ex_admin), that's been under heavy development since at least May of 2015. It's so damn close to ActiveAdmin that it's old theme will make you forget you're not in a Rails application.

Again, it's pretty straightforward to set it up by just following their [README](https://github.com/smpallen99/ex_admin) instructions.

Once you have it installed and configure, you can very quickly expose the User model into the Admin interface like this:

```
mix admin.gen.resource User
```

And we can edit the `web/admin/user.ex` with the following:

--- ruby
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

Yes, this is eerily similar to the ActiveAdmin DSL. Thumbs up for the team responsible, and it really shows how Elixir is well suited for Domain Specific Languages, if you're into that.

If you followed the Coherence instructions, it asks you to add a `:protected` pipeline (a set of plugs) for your protected routes. For now you can add the `/admin` route to go through that pipeline. And for the uninitiated, a "plug" is similar in concept to a Rack app, or more specifically, a Rails middleware. But in Rails we only have one pipeline of middlewares. In Phoenix we can configure multiple pipelines for different set of routes (browser and api, for example).

So we can add the following to `web/router.ex`:

--- ruby
...
scope "/admin", ExAdmin do
  pipe_through :protected
  admin_routes
end
...
```

With those simple contraptions in place, you will end up with something like this:

![Ex Admin](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/574/Screen_Shot_2016-12-06_at_17.56.17.png)

And if you're still not conviced, how about changing to their old theme?

![ActiveAdmin knockoff](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/575/Screen_Shot_2016-12-06_at_17.56.25.png)

Hell yeah! Makes me feel right at home, although I really prefer the new theme. But you could replace your ActiveAdmin-based app for this one and your users would hardly notice the small differences in the interface. The behavior is basically the same.

If you still have questions on how to properly configure ExAdmin, check out their [Contact Demo](https://github.com/smpallen99/contact_demo) project, where you can find a real example.

### Stitching a simple Admin role

Obviously, we don't want to let all authenticated user to access the Admin section.

So we can add a simple boolean field in the users table to indicate whether a user is an admin or not. You can change your migration to resemble this:

--- ruby
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

And you can configure the `priv/repos/seeds.exs` file to create 2 users, one admin and one guest:

--- ruby
YourApp.Repo.delete_all YourApp.User

YourApp.User.changeset(%YourApp.User{}, %{name: "Administrator", email: "admin@example.org", password: "password", password_confirmation: "password", admin: true})
|> YourApp.Repo.insert!

YourApp.User.changeset(%YourApp.User{}, %{name: "Guest", email: "guest@example.org", password: "password", password_confirmation: "password", admin: false})
|> YourApp.Repo.insert!
```

As this is just an exercise, you can drop the database and recreate it, like this: `mix do ecto.drop, ecto.setup`.

Coherence takes care of **authentication**, but we need to take care of **authorization**. You will find many examples online to something that resembles Rails' Pundit, such as [Bodyguard](https://github.com/schrockwell/bodyguard). But for this post I will stick to a simple Plug and create a new Router pipeline.

We need to create `lib/your_app/plugs/authorized.ex` and add the following:

--- ruby
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

Once a user signs in, Coherence puts the structure of the authenticated user into the `conn` (a Plug.Conn structure), so we can pattern match from it.

Now we need to create the router pipeline in the `web/router.ex` like this:

--- ruby
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

The `:protected_admin` pipeline is exactly the same as `:protected` but we add the newly created `YourApp.Plugs.Authorized` plug at the end. And then we change the `/admin` scope to go through this new pipeline.

And that's it. If you log in with the `guest@example.org` user, it will be kicked out to the homepage with a message saying that it's not authorized. If you log in with the `admin@example.org` it will be able to access the ExAdmin interface in `/admin`.

### Wrapping Up

Even though it's now super simple to add Authentication, Administration and basic Authorization, don't be fooled, the learning curve is still steep, even if you've been a Rails developer for a while.

Because of what's underneath, the OTP architecture, the concepts of Applications, Supervisors, Workers, etc, it's not immediatelly simple to wrap your head around what's **really** going on. If you're not careful, libraries such as Coherence or ExAdmin will make you feel like it's just as simple as Rails.

And it's not like that. Elixir is a completely different beast. And I mean it in a bad way, on the contrary. It's meant for highly reliable and distributed systems and it demands way more knowledge, patience and training from the programmer.

On the other hand, exactly because libraries such as Coherence makes it a lot easier to get started, you may become more motivated to put something up and running and then investing more time really **understanding** what's going on underneath. So the recommendation is: get your hands dirty, get some quick instant gratification of seeing something running, and then go on and refine your knowledge. It will be way more rewarding if you do so.

I don't see Phoenix meant to just be a Rails replacement. This would be too easy. I see it more as another piece to make Elixir the best suited set of technologies to build **highly scalable, highly reliable, highly distributed systems**. Stopping at simple web applications would not fulfill Elixir's potential.
