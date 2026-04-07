---
title: Ex Pusher Lite - Parte 3 - Uma Solução Completa
date: '2016-12-30T17:38:00-02:00'
slug: ex-pusher-lite-parte-3-uma-solucao-completa
translationKey: ex-pusher-lite-3
aliases:
- /2016/12/30/ex-pusher-lite-part-3-a-complete-solution/
tags:
- expusherlite
- elixir
- phoenix
- websockets
- traduzido
draft: false
---

Já faz mais de um ano desde que escrevi as 2 partes sobre o meu conceito "Ex Pusher Lite". O código de um ano atrás já está obsoleto, pois eu ainda estava aprendendo Elixir e Phoenix na prática.

Este mês publiquei um artigo sobre [ExAdmin e Coherence](http://www.akitaonrails.com/2016/12/06/coherence-and-exadmin-devise-and-activeadmin-for-phoenix) e outro sobre [Deploy de Elixir no DigitalOcean](http://www.akitaonrails.com/2016/12/23/elixir-phoenix-app-deployed-into-a-load-balanced-digitalocean-setup).

A ideia é bem simples: é uma homenagem ao [Pusher](https://pusher.com/). Se você já usou o Pusher, isso é muito parecido (embora com bem menos funcionalidades, claro).

Montei uma solução completa inspirada no Pusher, usando o framework Phoenix, deployada no Digital Ocean — e você já pode testar agora mesmo, é só se cadastrar em [expusherlite.cm42.io](http://expusherlite.cm42.io).

Depois do cadastro, você terá um token secreto (não compartilhe, claro) e estará vinculado a uma Organization. A partir daí pode criar Applications dentro dessa Organization. Cada Application terá um token único para identificá-la.

![dashboard](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/576/expusherlite_cm42_io_registrations.png)

Suponha que você queira criar uma aplicação Rails com uma funcionalidade de Chat. Qualquer versão de Rails serve — não precisa ser 5.0 e nem precisa de ActionCable.

Primeiro, vamos configurar o `config/secrets.yml`:

```
development:
  secret_key_base: b9a1...e7aa
  pusher_host: "expusherlite.cm42.io"
  org_id: acme-inc
  app_key: 0221...f193
  secret_token: 4036...f193
...
production:
  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
  pusher_host: <%= ENV['PUSHER_LITE_HOST'] %>
  org_id: <%= ENV['PUSHER_LITE_ORGANIZATION'] %>
  app_key: <%= ENV["PUSHER_LITE_APP_KEY"] %>
  secret_token: <%= ENV["PUSHER_LITE_SECRET_TOKEN"] %>
```

Substitua `pusher_host`, `org_id`, `app_key` e `secret_token` pelos valores que você criou antes.

Agora quero adicionar um `PageController`:

```ruby
require "net/http"
require "uri"
class PageController < ApplicationController
  def index
    uri = URI.parse("http://#{Rails.application.secrets.pusher_host}/api/sessions")
    response = Net::HTTP.post_form(uri, {"token" => Rails.application.secrets.secret_token})
    @guardian_token = JSON.parse(response.body)["jwt"]
    Rails.logger.info @guardian_token
  end
end
```

(Se você estiver conectando ao meu servidor online, é obrigatório usar SSL — troque a URL acima por "https")

O que esse trecho faz é enviar o token secreto pelo lado do servidor, para o meu serviço, e receber de volta um JSON Web Token (JWT). Aí você passa esse JWT para o front-end para habilitar a autenticação.

No front-end podemos ter essa `app/views/page/index.html.erb` bem simples:

```
<h1>Ex Pusher Lite - Rails Integration Example</h1>

<script type="text/javascript" charset="utf-8">
  window.guardian_token = "<%= @guardian_token %>";
  window.org_id = "<%= Rails.application.secrets.org_id %>"
  window.app_key = "<%= Rails.application.secrets.app_key %>";
  window.pusher_host = "<%= Rails.application.secrets.pusher_host %>";
</script>

<div id="chat" class="fixedContainer">
</div>

<input type="text" name="name" id="name" value="" placeholder="Name"/>
<input type="text" name="message" id="message" value="" placeholder="Message"/>
<input type="checkbox" name="channel" id="channel" value="api"/>
<label for="channel">send through API</label>
```

Bem simples. Podemos ajustar o CSS (`app/assets/stylesheets/application.css`) só para deixar mais apresentável:

```css
...
.fixedContainer {
  height: 250px;
  width: 100%;
  padding:3px;
  border: 1px solid black;
  margin: 5px;
  overflow: auto;
}

body {
  font-family: Helvetica, Arial
}
```

Por último, precisamos carregar o Javascript principal do servidor ExPusherLite. Edite o layout em `app/views/layouts/application.html.erb` e adicione esta linha logo após a tag de fechamento `</body>`:

```html
<script src="http://<%= Rails.application.secrets.pusher_host %>/js/pusher.js"></script>
```

Agora podemos usar esse Javascript no `app/assets/javascripts/application.js` para ligar tudo. Esta é a parte relevante:

```javascript
$(document).ready(function() {
  var PusherLite = require("pusher_lite").default;

  var pusher = new PusherLite(window.app_key, {
    host: window.pusher_host,
    jwt: window.guardian_token,
    uniqueUserId: "robot" })
    // ssl: true - if you're connecting to my online server

  var publicChannel = pusher.subscribe("general")

  publicChannel.bind("new_message", function(payload) {
    var chat = $("#chat")
    chat.append("<p><strong>" + payload.name + "</strong> " + payload.message + "</p>");
    chat.scrollTop(chat.prop("scrollHeight"));
  })

  pusher.joinAll();
```

Podemos continuar no mesmo arquivo com o Javascript que se conecta ao campo de mensagem, ouvindo o evento de tecla "Enter" para enviar as mensagens:

```javascript
  var message_element = $("#message");
  message_element.on('keypress', function(event) {
    if (event.keyCode != 13) { return; }

    var name_element    = $("#name");
    var check_element   = $("#channel");
    var payload = { name: name_element.val(), message: message_element.val() };

    if(!check_element.prop("checked")) {
      sendPusher(payload);
    } else {
      sendAPI(payload)
    }
    message_element.val('');
  });

  window.publicChannel = publicChannel;
})
```

E é assim que enviamos mensagens para o ExPusherLite, seja diretamente via WebSockets full-duplex:

```javascript
function sendPusher(payload) {
  console.log("sending through socket")
  window.publicChannel.trigger('new_message', payload );
}
```

Ou fazendo POST para a API disponível:

```
function sendAPI(payload) {
  console.log("sending through API")
  $.ajax({
    type : 'POST',
    crossDomain: true,
    url : makeURL("new_message"),
    headers : { Authorization : 'Bearer ' + window.guardian_token },
    data : payload,
    success : function(response) {
      console.log(response);
      console.log("sent through API successfully");
    },
    error : function(xhr, status, error) {
      console.log(error);
    }
  });
}

function makeURL(event) {
  return "http://" + window.pusher_host + "/api/organizations/" + window.org_id + "/applications/" + window.app_key + "/event/" + event;
}
```

Vale dizer que você pode enviar mensagens pela API a partir do lado do servidor também. Especialmente de um processo ActiveJob para manter a aplicação web Rails rápida — e aproveitando para salvar a mensagem no banco de dados ou aplicar filtros.

E é isso! Sua aplicação Rails agora tem WebSockets. Dá pra ter o melhor dos dois mundos.

Se quiser ver o exemplo funcionando, publiquei um app de demo [no Heroku](http://ex-pusher-lite-demo.herokuapp.com/). É só uma demo, sem autenticação, sem sanitização contra cross-scripting, sem nada.

[![chat demo](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/577/Screen_Shot_2016-12-30_at_17.42.22.png)](http://ex-pusher-lite-demo.herokuapp.com/)

Resumindo: é uma aplicação Rails (poderia ser Django, Laravel, ASP.NET MVC, tanto faz) se comunicando via WebSocket + APIs com um cluster Phoenix.

### Próximos Passos

Continue acompanhando meu blog (ou meu Twitter em [@akitaonrails](https://twitter.com/akitaonrails)) para os próximos posts.

Ainda estou avaliando se vou abrir o código do ExPusherLite como open source — me avise se tiver interesse.

Também estou pensando em manter os servidores online como um serviço barato. Você pode usar de graça agora para brincar, mas não use em produção ainda. Como estou codificando pesado, vou ficar atualizando os servidores frequentemente, então não há SLA. Me avise se tiver interesse em um serviço assim que mantenha o código aberto para você poder confiar nele.

Ainda faltam recursos importantes, como suporte adequado a SSL, canais criptografados, APIs de Presence melhores e por aí vai — mas o que está disponível agora já cobre a maioria dos casos de uso para WebSockets.

E tem mais: por ser Phoenix, por ser Elixir, por ser Erlang, ganhamos PubSub distribuído "de graça". Como expliquei no meu post de [deploy](http://www.akitaonrails.com/2016/12/23/elixir-phoenix-app-deployed-into-a-load-balanced-digitalocean-setup), é um setup com um servidor em Nova York e outro em Londres, só para demonstrar a natureza distribuída do Erlang.

Foi muito divertido brincar com Elixir nos últimos dias e ver com que rapidez consegui montar uma solução completa como essa. Teve muitos quebra-cabeças que me fizeram coçar a cabeça: como lidar com problemas de cross origin, como fazer os nós se encontrarem pelo deploy via edeliver, descobrir as peças faltantes na transição do exrm para o distillery (que ainda está em andamento na comunidade), etc.

Agora estou bem confortável com o básico, do bootstrap do projeto até o deploy em cenário de cluster. E espero que esse serviço seja útil para mais pessoas.

Como este é possivelmente meu último post do ano: Feliz Ano Novo! E nos vemos em 2017!
