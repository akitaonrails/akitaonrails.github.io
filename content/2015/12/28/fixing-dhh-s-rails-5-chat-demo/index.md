---
title: Consertando o Demo de Chat do DHH no Rails 5
date: '2015-12-28T16:11:00-02:00'
slug: consertando-o-demo-de-chat-do-dhh-no-rails-5
translationKey: fixing-dhh-rails-5-chat
aliases:
- /2015/12/28/fixing-dhh-s-rails-5-chat-demo/
tags:
- pusher
- rails5
- actioncable
- websocket
- traduzido
draft: false
---

Pois é, o Rails 5.0.0 Beta 1 [acabou de ser lançado](http://weblog.rubyonrails.org/2015/12/18/Rails-5-0-beta1/) e a grande novidade é o [Action Cable](https://github.com/rails/rails/tree/master/actioncable).

Basicamente é uma solução completa em cima do Rails padrão para você implementar aplicações baseadas em WebSocket (os famosos chats e notificações em tempo real) com acesso total ao que o Rails te dá (models, view templates, etc). Para apps pequenos e médios, é uma solução excelente que você pode usar no lugar de ter que partir para Node.js.

Resumindo, você controla Cable Channels que recebem mensagens enviadas por uma conexão WebSocket no cliente. O novo gerador de Channel cuida do boilerplate e você só precisa preencher os espaços em branco para definir que tipo de mensagem quer enviar do cliente, o que quer transmitir do servidor, e para quais channels seus clientes estão inscritos.

Para uma introdução mais detalhada, o próprio DHH publicou um [screencast bem básico de Action Cable](https://www.youtube.com/watch?v=n0WUjGkDFS0) que você deveria assistir só para ter uma ideia do porquê de toda essa empolgação. Se você já assistiu e tem alguma experiência em programação, talvez já tenha percebido o problema que menciono no título, então pula direto para a seção ["O Problema"](#the-problem) abaixo para o TL;DR.

No final você acaba com uma base de código como a que reproduzi no meu repositório do Github até a [tag "end_of_dhh"](https://github.com/akitaonrails/rails5-actioncable-demo/tree/end_of_dhh). Você vai ter um chat em tempo real (bem) básico de uma única sala para brincar com os principais componentes.

Vamos só listar os principais componentes aqui. Primeiro, você terá o servidor ActionCable montado no arquivo "routes.rb":

```ruby
# config/routes.rb
Rails.application.routes.draw do
  root to: 'rooms#show'

  # Serve websocket cable requests in-process
  mount ActionCable.server => '/cable'
end
```

Este é o componente principal do servidor, o channel:

```ruby
# app/channels/room_channel.rb
class RoomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)
    Message.create! content: data['message']
  end
end
```

Depois você tem o Javascript boilerplate:

```ruby
# app/assets/javascripts/cable.coffee
#= require action_cable
#= require_self
#= require_tree ./channels
#
@App ||= {}
App.cable = ActionCable.createConsumer()
```

E os principais hooks de Websocket no lado do cliente:

```ruby
# app/assets/javascripts/channels/room.coffee
App.room = App.cable.subscriptions.create "RoomChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    $('#messages').append data['message']

  speak: (message) ->
    @perform 'speak', message: message

$(document).on "keypress", "[data-behavior~=room_speaker]", (event) ->
  if event.keyCode is 13
    App.room.speak event.target.value
    event.target.value = ''
    event.preventDefault()
```

O view template é um HTML básico só para amarrar um formulário simples e uma div para listar as mensagens:

```html
<!-- app/views/rooms/show.html.erb -->
<h1>Chat room</h1>

<div id="messages">
  <%= render @messages %>
</div>

<form>
  <label>Say something:</label><br>
  <input type="text" data-behavior="room_speaker">
</form>
```

<a name="the-problem"></a>

### O Problema

No "RoomChannel", você tem o método "<tt>speak</tt>" que salva uma mensagem no banco de dados. Isso já é um sinal vermelho para uma ação de WebSocket, que deveria ter processamento curto e leve. Salvar no banco é considerado pesado, principalmente sob carga. Se isso for processado dentro do reactor loop do EventMachine, vai travar o loop e impedir que outro processamento concorrente aconteça até o banco soltar o lock.

```ruby
# app/channels/room_channel.rb
class RoomChannel < ApplicationCable::Channel
  ...
  def speak(data)
    Message.create! content: data['message']
  end
end
```

Eu diria que tudo que entra dentro do channel deveria ser assíncrono!

Para piorar a situação, é isso que você tem dentro do próprio model "Message":

```ruby
class Message < ApplicationRecord
  after_create_commit { MessageBroadcastJob.perform_later self }
end
```

Um callback de model (fuja desses como da peste!!) para transmitir a mensagem recebida para os clientes Websocket inscritos como um ActiveJob, que se parece com isso:

```ruby
class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    ActionCable.server.broadcast  'room_channel', message: render_message(message)
  end

  private

  def render_message(message)
    ApplicationController.renderer.render(partial: 'messages/message', locals: { message: message })
  end
end
```

Ele renderiza o trecho de HTML para mandar de volta para os clientes Websocket adicionarem ao DOM dos seus navegadores.

O DHH ainda chega a dizer _"Eu queria mostrar isso porque é assim que a maioria dos apps vai acabar ficando."_

E de fato, o **problema** é justamente que a maioria das pessoas vai seguir esse padrão e cair nessa armadilha. Então, qual a solução então?

### A Solução Correta

Só para os fins de um screencast simples, vamos fazer um conserto rápido.

Antes de tudo, se for possível, você quer que o código do seu channel bloqueie o mínimo possível. Esperar uma operação bloqueante no banco (gravação) definitivamente não é uma dessas operações. O Job está sendo subutilizado, ele deveria ser chamado direto do método "speak" do channel, assim:

```ruby
# app/channels/room_channel.rb
 class RoomChannel < ApplicationCable::Channel
   ...
   def speak(data)
-    Message.create! content: data['message']
+    MessageBroadcastJob.perform_later data['message']
   end
 end
```

Depois, movemos a gravação no model para dentro do próprio Job:

```ruby
# app/jobs/message_broadcast_job.rb
 class MessageBroadcastJob < ApplicationJob
   queue_as :default

-  def perform(message)
-    ActionCable.server.broadcast  'room_channel', message: render_message(message)
+  def perform(data)
+    message = Message.create! content: data
+    ActionCable.server.broadcast 'room_channel', message: render_message(message)
   end
   ...
```

E finalmente, removemos aquele callback horrível do model e deixamos ele limpo de novo:

```ruby
# app/models/message.rb
class Message < ApplicationRecord
end
```

Isso retorna rápido, joga o processamento para um job em background e deveria suportar mais concorrência de saída. A solução anterior, do DHH, tem um gargalo embutido no método speak e vai engasgar assim que o banco virar o gargalo.

Está longe de ser uma solução perfeita ainda, mas é menos terrível para um demo bem rápido e o código fica até mais simples. Você pode conferir esse código no [meu commit no Github](https://github.com/akitaonrails/rails5-actioncable-demo/commit/0aaaaecc46ed14e98086bac5ce087df08d557456).

Posso estar errado na conclusão de que o channel vai bloquear ou se isso é mesmo prejudicial para a concorrência. Não medi as duas soluções, é só uma intuição vinda de feridas antigas. Se você tem mais conhecimento sobre a implementação do Action Cable, deixa um comentário aí embaixo.

Aliás, tenha cuidado antes de pensar em migrar seu app de Rails 4.2 para Rails 5 já. Por causa das dependências hard coded em Faye e Eventmachine, o Rails 5 hoje exclui o Unicorn (até o Thin parece estar tendo problema para subir). Também exclui JRuby e MRI no Windows por causa do Eventmachine.

Se você quer as capacidades do Action Cable sem precisar migrar, pode usar soluções como o ["Pusher.com"](http://developers.planningcenteronline.com/2014/09/23/live-updating-rails-with-react.js-and-pusher.html), ou se quer sua própria solução in-house, acompanhe minha evolução no assunto com o meu [mini clone do Pusher](http://www.akitaonrails.com/pusher) escrito em Elixir.
