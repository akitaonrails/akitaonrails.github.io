---
title: "[Iniciante] Configurações de ambiente com Dotenv"
date: '2013-10-19T16:14:00-03:00'
slug: iniciante-configuracoes-de-ambiente-com-dotenv
tags:
- learning
- beginner
- rails
draft: false
---

Se você já fez deployments usando Heroku, uma coisa que pode ter parecido estranho no começo e agora já é segunda natureza é colocar configurações específicas de ambiente em variáveis de ambiente ("env").

No caso do Heroku, podemos fazer: 

---
heroku config:add HELLO_WORLD=true
---

E dentro da aplicação podemos pegar esse valor com 

--- ruby
ENV['HELLO_WORLD']
---

O problema: e quando estamos desenvolvendo? #comofaz?

A forma mais desorganizada é fazer algo como:

--- ruby
hello_world = %w(development test).include?(Rails.env) ? "123" : ENV['HELLO_WORLD']
---

A forma que se popularizou atualmente é usar a gem [dotenv-rails](https://github.com/bkeepers/dotenv)

Na sua Gemfile adicione o seguinte ao seu grupo 'development', 'test':

--- ruby
gem 'dotenv-rails', :groups => [:development, :test]
---

Execute o comando 'bundle install' e agora crie um arquivo **.env** na raíz do seu projeto:

---
HELLO_WORLD=true
---

E na sua aplicação faça normalmente:

--- ruby
hello_world = ENV['HELLO_WORLD']
---

Não se esqueça de colocar o '.env' no seu '.gitignore' para não colocá-lo no seu repositório e mantenha um '.env.development' como modelo para que o próximo desenvolvedor saiba o que precisa configurar na sua máquina.

Melhor ainda, como todos já deveriam saber a este ponto, uma configuração que o Rails ainda gera por padrão e acabamos colocando no repositório git é o 'config/initializers/secret_token.rb'.

Será algo assim:

--- ruby
MyApp::Application.config.secret_token = 'bfbb...aadd2'
---

Com o 'dotenv' faça assim:

---
MyApp::Application.config.secret_token = ENV['SECRET_TOKEN']
---

E adicione ao seu novo arquivo '.env' o seguinte:

---
SECRET_TOKEN=bfbb...aadd2
---

Lembrando que você sempre pode criar um novo token com o comando 'rake secret'. E não se esqueça de adicionar também ao seu projeto no Heroku (com um novo token diferente do de desenvolvimento, claro):

---
heroku config:set SECRET_TOKEN=`rake secret`
---
