---
title: Ex Pusher Lite - Part 3 - A Complete Solution
date: '2016-12-30T17:38:00-02:00'
slug: ex-pusher-lite-part-3-a-complete-solution
tags:
- expusherlite
- elixir
- phoenix
- websockets
draft: false
---

It's been over a year since I wrote the 2 pieces about my "Ex Pusher Lite" concept. The code from a year ago is already obsolete as I was still just learning my way through both Elixir and Phoenix.

I've published an article about [ExAdmin and Coherence](http://www.akitaonrails.com/2016/12/06/coherence-and-exadmin-devise-and-activeadmin-for-phoenix) and another on [Deploying Elixir to DigitalOcean](http://www.akitaonrails.com/2016/12/23/elixir-phoenix-app-deployed-into-a-load-balanced-digitalocean-setup) this month.

The idea is very simple, it is a homage to [Pusher](https://pusher.com/). If you used Pusher before, this is very similar (albeit way less feature complete, of course).

I built an entire solution inspired by Pusher, using the Phoenix framework, deployed to Digital Ocean and you can test it out right now, just sign up at [expusherlite.cm42.io](http://expusherlite.cm42.io).

Once you sign up, you will have a secret token (don't disclose that, of course) and you will be below an Organization. Then you can go on and create Applications within that Organization. Each Application will have a unique token to identify it.

![dashboard](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/576/expusherlite_cm42_io_registrations.png)

Now, let's say you want to create a Rails application with a Chat feature. Any version of Rails, you don't need 5.0 and you don't need ActionCable.

First off, let's configure `config/secrets.yml`:

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

Replace the `pusher_host`, `org_id`, `app_key`, and `secret_token` for the ones you created before.

Now I want to add a `PageController`:

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

(If you're connecting to my online server, you must use SSL, so change the URL above for "https")

What this piece does is submit the secret token in the server-side, to my service, to get a JSON Web Token (JWT) back. Now you can pass this JWT to the front-end to enable authentication.

In the front-end we can have this simple `app/views/page/index.html.erb`:

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

Super simple, we can tweak the CSS (`app/assets/stylesheets/application.css`) just to make it look nicer:

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

Finally, we need to load the main Javascript from the ExPusherLite server, so edit the layout at `app/views/layouts/application.html.erb` and add this line right after the closing `</body>` tag:

```html
<script src="http://<%= Rails.application.secrets.pusher_host %>/js/pusher.js"></script>
```

And we can now use this Javascript in the `app/assets/javascripts/application.js` to hook everything up. This is the relevant bit:

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

We can now continue in the same file with the Javascript that binds to the message input field, listening to the "Enter" key press event to send the messages:

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

And this is how we send messages to ExPusherLite, either directly through the full-duplex WebSockets:

```javascript
function sendPusher(payload) {
  console.log("sending through socket")
  window.publicChannel.trigger('new_message', payload );
}
```

Or Posting to the available API:

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

By the way, you can send messages using the API from the server-side if you want. Specifically from an ActiveJob process so you can keep your Rails web application fast, and you can use the opportunity to store the message in your database, or apply any filters.

And this is it! You now have a Rails application with WebSockets. You can have your lunch and eat it too.

If you want to see this example working, I published a demo app [over at Heroku](http://ex-pusher-lite-demo.herokuapp.com/). It's just a demo, it has no authentication, no cross-sripting sanitization, no nothing.

[![chat demo](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/577/Screen_Shot_2016-12-30_at_17.42.22.png)](http://ex-pusher-lite-demo.herokuapp.com/)

In summary: this is a Rails app (you could do it in Django, Laravel, ASP.NET MVC, it doesn't matter) talking through WebSocket + APIs to a Phoenix cluster.

### Next Steps

Keep following my blog (or my Twitter at [@akitaonrails](https://twitter.com/akitaonrails) ) for more posts to come.

I am still considering if I will open the ExPusherLite code as open source, so let me know if you're interested.

I am also considering if I will keep the current servers online as a cheap service. You can use it for free right now to play with it, but don't use for production-level apps yet. As I am still heavily coding it, I will keep updating the servers, so there is no SLA. Let me know if you're interested in such a service that keeps the code open source so you can trust it better.

There are important features still missing, such as proper SSL support, encrypted channels, better Presence tracking APIs and so on, but what's available right now already covers most use cases for WebSockets.

And better: because this is Phoenix, because this is Elixir, and because this is Erlang, we get distributed PubSub for "free". As I explained in my [deployment](http://www.akitaonrails.com/2016/12/23/elixir-phoenix-app-deployed-into-a-load-balanced-digitalocean-setup) post, this is a setup with a server in New York and another in London, just to showcase the distributed nature of Erlang.

It's been very fun to play with Elixir for the past few days and how fast I was able to put together a full-featured solution like this. There were many puzzles that made me scratch my head, figuring out how to deal with cross origin issues, how to make the nodes find each other through the edeliver deployment, figuring out the missing bits in replacing exrm for distillery (which is a transition still taking place in the community), etc.

Now I am quite comfortable with the basics, from bootstrapping a project all the way to deploying in a cluster scenario. And I hope this service proves useful to more people.

As this is possibly my last post of the year: Happy New Year! And I will see you again in 2017!
