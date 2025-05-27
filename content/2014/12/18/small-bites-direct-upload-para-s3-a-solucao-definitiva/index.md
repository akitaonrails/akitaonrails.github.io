---
title: "[Small Bites] Direct Upload para S3: a Solução Definitiva!"
date: '2014-12-18T14:28:00-02:00'
slug: small-bites-direct-upload-para-s3-a-solucao-definitiva
tags:
- learning
- rails
- heroku
draft: false
---

**Atualização Jul/2016:** As recomendações mudaram. Leiam este post mas usem o que explico no post mais recente [Updating my Old Posts on Uploads](http://www.akitaonrails.com/2016/07/28/updating-my-old-posts-on-uploads).

Um problema que nos persegue há muito tempo são uploads. À primeira vista é algo simples:

1. Coloque um form com multipart configura
2. Coloque um campo de input tipo "file"
3. Dê POST, o upload vai iniciar com o web server
4. Quando o upload terminar o web server passa o arquivo pra aplicação, agora é só salvar no disco

Mas esse é o jeito ruim. Funciona muito bem pra coisas pequenas, mas tenha muitos usuários fazendo uploads de dezenas de megabytes (que é o tamanho de qualquer foto tirada em smartphones) e de repente seu servidor fica de joelhos. Tenha muitos usuários fazendo uploads em conexões toscas (3G) e de repente seu web server fica travado à merce de conexões lentas. E no caso do Heroku, com timeout fixo em 30 segundos, tudo é cancelado depois de um tempo.

Daí tem o problema de onde colocar os arquivos: se colocar em arquivos no disco do servidor, a hora que você precisar colocar um segundo servidor em load balancing, vai ter problemas. Ainda tem gente que acha uma boa idéia colocar binários em campos BLOB num banco de dados (NUNCA FAÇA ISSO!!!). A única solução decente é jogar em buckets do S3 ou outros storages em cloud, mas sua aplicação fica mais lenta ainda: primeiro esperando o upload do usuário e depois fazendo o upload pro cloud. Tudo parece piorar o problema!

Pensando nisso fiz um artigo explicando em detalhes o problema, chamado [S3 Direct Upload + Carrierwave + Sidekiq](http://www.akitaonrails.com/2014/03/26/heroku-tips-s3-direct-upload-carrierwave-sidekiq). Não é uma forma simples mas funciona. Porém o criador do Carrierwave, [Jonas Nicklas](https://github.com/jnicklas) parece que se cansou desse e outros problemas mais inerentes ao Carrierwave e resolveu começar do zero. Ele criou e lançou recentemente a excelente gem [REFILE](https://github.com/elabs/refile).

TL;DR: Esqueça Paperclip, Carrierwave ou Dragonfly. Use Refile! Ele tem dezenas de opções como qual storage você quer usar e muito mais, mas neste post vou me limitar ao caso de uso mais comum: Direct Upload para o S3, sem carregar seu servidor/aplicação. Tão fácil que cabe num Small Bites.

Mas repito: leia a documentação e faça provas de conceito, vou reduzir o exemplo da documentação num passo a passo para o cenário de Direct Upload para S3. Assumindo que você tem um model <tt>User</tt> e quer colocar uma imagem de perfil nela. Comece editando a <tt>Gemfile</tt>:

--- ruby
gem "mini_magick"
gem "refile", require: ["refile/rails", "refile/image_processing"]
gem "aws-sdk"
```

Agora vamos criar a configuração do Refile para o AWS-S3, crie o arquivo <tt>config/initializer/refile.rb</tt>:

--- ruby
require "refile/backend/s3"

aws = {
  access_key_id: ENV['S3_ACCESS_KEY'],
  secret_access_key: ENV['S3_SECRET_ACCESS_KEY'],
  bucket: ENV['S3_BUCKET'],
}
Refile.cache = Refile::Backend::S3.new(prefix: "cache", **aws)
Refile.store = Refile::Backend::S3.new(prefix: "store", **aws)
```

Como podem ver estou assumindo que você usa corretamente o [dotenv-rails](http://www.akitaonrails.com/2013/10/19/iniciante-configuracoes-de-ambiente-com-dotenv) para colocar as configurações de S3. Assumindo também que você saber configurar um bucket, incluindo habilitar a configuração de Cross-Origin Resource Sharing (CORS) onde você vai colocar algo parecido com isso:

--- xml
<CORSConfiguration>
    <CORSRule>
        <AllowedOrigin>*</AllowedOrigin>
        <AllowedMethod>GET</AllowedMethod>
        <AllowedMethod>POST</AllowedMethod>
        <MaxAgeSeconds>3000</MaxAgeSeconds>
        <AllowedHeader>Authorization</AllowedHeader>
        <AllowedHeader>Content-Type</AllowedHeader>
    </CORSRule>
</CORSConfiguration>
```

Agora vamos criar o campo na tabela de usuários:

```
rails generate migration add_profile_image_to_users profile_image_id:string
rake db:migrate
```

Adicione o Refile no seu model <tt>config/model/user.rb</tt>:

--- ruby
class User < ActiveRecord::Base
  attachment :profile_image
end
```

E edite a view do formulário de edição que, se você criou via scaffold, provavelmente vai ser algo como <tt>app/views/users/_form.html.erb</tt>:

--- html
<%= form_for(@user) do |f| %>
  ...
  <div class="field">
    <%= f.attachment_field :profile_image, direct: true, presigned: true %>
  </div>
  <div class="actions">
    <%= f.submit %>
  </div>
<% end %>
```

Note a opção de <tt>direct</tt> que indica que será um Direct Upload, ou seja, seu browser vai fazer o upload diretamente para o S3 e trazer a chave de identificação pra montar a URL depois. No caso o Refile primeiro joga numa chave "cache/" e quando você faz o POST do formulário ele manda o S3 copiar para a pasta "store/" que é o que seu model vai usar. Dessa forma, se você escolher o arquivo no browser, fizer o upload mas desistir de dar POST, não vai poluir a pasta final.

Como o controller vai receber campos novos, precisamos permitir que esses parâmetros cheguem no model, então vamos editar o controller responsável que, nesse exemplo, é o <tt>app/controllers/users_controller.rb</tt>:

--- ruby
class UsersController < ApplicationController
  ...
  private
	...

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :profile_image, :profile_image_cache_id)
    end
end
```
 
No trecho acima deixei de exemplo possíveis campos como "name" e "email" mas, claro, configure de acordo com os campos que seu formulário realmente envia, o importante são os parâmetros "profile_*". Com isso a aplicação já recebe tudo que precisa, mas como o Direct Upload acontece no browser significa que precisamos de algum Javascript para controlar a chamada Ajax e os eventos associados então vamos adicionar a dependência do Refile editando o arquivo <tt>app/assets/javascripts/application.js</tt>:

--- javascript
...
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require refile
//= require_tree .
...
```

Esse é um exemplo então, novamente, edite conforme o que você tem na sua aplicação. A documentação explica como lidar com os eventos como "upload:start" ou "upload:progress" para que você tenha a opção de mostrar coisas como uma barra de progresso ou outra notificação ao usuário indicando se ele está fazendo o upload e quando terminar. Para este exemplo vamos fazer algo simples: apenas desabilitar o botão de submit e reabilitar quando o upload terminar. Para isso vamos editar o arquivo <tt>app/assets/javascripts/users.js.coffee</tt>:

--- javascript
$(document).on "upload:start", "form", (e) ->
  $(this).find("input[type=submit]").attr "disabled", true

$(document).on "upload:complete", "form", (e) ->
  $(this).find("input[type=submit]").removeAttr "disabled"  unless $(this).find("input.uploading").length
```

Pronto! Reinicie seu servidor e de agora em diante o upload vai acontecer diretamente do browser para o S3 e quando fizer o POST ele vai guardar a chave de identificação no campo "profile_image_id" e quando for puxar a imagem ele vai passar por um filtro Rack que vai mostrar algo parecido com isso no seu console:

```
Started GET "/attachments/store/fill/300/300/365d81a10ba21f2544177580f12110509f57e086bcd49f5336079ca17ea8/profile_image" for 192.168.47.2 at 2014-12-18 15:53:14 +0000
Refile: GET /store/fill/300/300/365d81a10ba21f2544177580f12110509f57e086bcd49f5336079ca17ea8/profile_image
Refile: serving "365d81a10ba21f2544177580f12110509f57e086bcd49f5336079ca17ea8" from store backend which is of type Refile::Backend::S3
[AWS S3 200 3.345285 0 retries] get_object(:bucket_name=>"testing-bucket-akitaonrails",:key=>"store/365d81a10ba21f2544177580f12110509f57e086bcd49f5336079ca17ea8")
```

Significa que você pode dar override nisso e colocar coisas como autenticação para acessar certos buckets e assim por diante. Com o tempo você pode querer limpar a pasta de cache e isso você pode configurar diretamente no S3 como [ensina a documentação](https://github.com/elabs/refile#cache-expiry).

Finalmente, o correto é sempre configurar o Amazon Cloudfront na frente do storage que estiver usando (no nosso caso, o S3) e [este blog post](http://www.happybearsoftware.com/use-cloudfront-and-the-rails-asset-pipeline-to-speed-up-your-app.html) explica como é simples fazer isso. O conceito é basicamente trocar o domínio e passar a URL para o Cloudfront que, se não tiver a imagem em cache vai pedir pra sua aplicação e a partir daí vai usar do seu próprio cache, deixando a sua aplicação e seu storage mais leves. E para que sua aplicação gere tags de imagens apontando pro CDN, apenas configure o Refile assim:

--- ruby
Refile.host = "//your-dist-url.cloudfront.net"
```

Pronto! A solução definitiva para gerenciar seus assets da **FORMA CORRETA**! Servir assets diretamente da sua aplicação está errado. Fazer sua aplicação fazer o upload para storages está errado. Não usar storages separados da sua aplicação está errado! 
