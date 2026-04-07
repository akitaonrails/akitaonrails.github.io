---
title: "Atualizando Meus Posts Antigos Sobre Uploads"
date: '2016-07-28T11:56:00-03:00'
slug: atualizando-meus-posts-antigos-sobre-uploads
translationKey: updating-old-posts-on-uploads
aliases:
- /2016/07/28/updating-my-old-posts-on-uploads/
tags:
- uploads
- carrierwave
- cdn
- cloudfront
- cloudinary
- heroku
- traduzido
draft: false
---

Felizmente as coisas costumam mudar para melhor, e práticas que "funcionavam ok" no passado podem estar obsoletas hoje.

Isso acontece com posts antigos de blog, incluindo os meus, já que venho postando há vários anos.

Neste post vou corrigir o que escrevi antes:

* [Direct Upload para S3: a Solução Definitiva!](http://www.akitaonrails.com/2014/12/18/small-bites-direct-upload-para-s3-a-solucao-definitiva)
* [S3 Direct Upload + Carrierwave + Sidekiq](http://www.akitaonrails.com/2014/03/26/heroku-tips-s3-direct-upload-carrierwave-sidekiq)
* [Upload de Arquivos](http://www.akitaonrails.com/2010/06/23/akita-responde-upload-de-arquivos)
* [Enciclopédia do Heroku](http://www.akitaonrails.com/2012/04/20/heroku-tips-enciclopedia-do-heroku)

Eles ainda são bons posts para entender a mecânica do que vou propor aqui, então vale a pena ler se você tem interesse em como as coisas funcionam por baixo.

**TL;DR**: use Cloudinary (com Attachinary) e instale um CDN (Cloudfront) agora mesmo, porque é trivial demais de fazer.

> Upload de arquivos é uma tarefa que merece atenção séria. É um daqueles assuntos onde você não pode achar que "funciona" só porque funcionou na sua máquina de desenvolvimento, com meia dúzia de uploads triviais. O comportamento em produção muda drasticamente e pode derrubar seu projeto inteiro, dependendo do quanto ele depende de conteúdo gerado por usuário.

São muitas peças móveis para entender. Mas nas soluções mais básicas você simplesmente cria um form HTML multipart com um campo de arquivo e submete direto para algum endpoint do controller. O controller recebe o blob binário e você salva em algum diretório local no servidor.

Essa é a **pior solução possível** e, infelizmente, é a que você mais encontra pela web.

Existem vários problemas para lidar com essa implementação ingênua:

* Estamos na era das câmeras de 12+ megapixels. Esses arquivos têm vários megabytes. Cada upload demora bastante, principalmente se o usuário está tentando subir o arquivo por uma rede sem fio lenta ou instável.

Quando o navegador do usuário se conecta à aplicação web, ele segura aquela conexão e bloqueia o processo inteiro durante todo o ciclo de request-response. Para deixar simples: se você só tem 1 processo no servidor, ele fica incapaz de responder a qualquer outra requisição até o upload terminar.

Felizmente a maioria dos deploys usa NGINX na frente da aplicação web - como deveriam -, então esse efeito é minimizado, porque o NGINX recebe o blob inteiro antes de passar para o processo da aplicação por baixo, o que torna a coisa menos problemática na maioria dos casos.

Mas se você está no Heroku, a camada de router tem um limite de **timeout de 30 segundos**. Se o upload demorar mais que isso (o que é comum com usuários em redes ruins) essa camada vai cortar a conexão antes do upload terminar. Os usuários vão tentar de novo e isso pode fazer suas filas de requisição crescerem muito rápido.

Evite fazer upload de qualquer coisa diretamente para o Heroku. Eu considero isso uma **feature**, porque força aplicações deployadas no Heroku a usarem **boas práticas**, como vou explicar abaixo.

* Você também NÃO deve salvar arquivos no filesystem local se quer escalar horizontalmente, porque um servidor não vai conseguir enxergar o que está no outro, a menos que você esteja na AWS EC2 ou outro IaaS, com volumes montados compartilhados, por exemplo. No Heroku você não pode confiar em nada que esteja no filesystem, porque as máquinas são voláteis e sempre que um dyno reinicia ele perde tudo o que não estava lá no momento do deploy.

Então você precisa subir o que recebeu para um storage externo, como o AWS S3, e isso também é lento se você recebe muitos uploads. Você pode contar com o NGINX ou com a camada de router do Heroku para receber os arquivos, mas o ciclo de request-response vai ficar lentíssimo se você processar e subir os arquivos para o S3 de forma síncrona.

A próxima opção que vem à cabeça é adicionar Sidekiq ou outro mecanismo de Async Job para fazer esse trabalho pesado. Agora você precisa criar placeholders no front-end para mostrar para os usuários enquanto o background job ainda não terminou de mandar os arquivos para o S3.

A última opção, se você cavar mais fundo, é o **direct upload** do navegador direto para o S3, postando só as URLs para sua aplicação web. Essa é a solução ideal, mas não é fácil de implementar na sua stack.

* Depois de acertar tudo isso, você ainda comete o erro de jogar as URLs do S3 direto nas tags IMG do seu HTML, o que não é recomendado pela própria Amazon, já que o S3 é recomendado apenas para fins de "storage". Essa é a parte fácil de corrigir, mas a maioria dos projetos esquece dela.

### Cloudinary ou Carrierwave Direct

Nos meus posts anteriores eu expliquei cada um dos problemas acima em mais detalhe e ofereci algumas soluções (complicadas), como usar o projeto Refile. Naquela época os plugins do Carrierwave para Direct Upload ainda não estavam prontos.

Hoje em dia a solução é absurdamente fácil e é o que eu recomendo: vá direto para o [Cloudinary](http://cloudinary.com/documentation/rails_integration). É uma solução Software as a Service para direct upload de verdade e processamento dinâmico de imagens. Vale muito explorar a gem [Attachinary](https://github.com/assembler/attachinary) para facilitar o processo.

Se você tem legado em Carrierwave, Paperclip, Shrine, Dragonfly, Refile ou qualquer outro, uma alternativa meio gambiarra - mas razoável - é simplesmente adicionar o Attachinary junto.

Digamos que você tem um uploader antigo `user.avatar`. Você pode simplesmente criar um novo `user.new_avatar` com Attachinary/Cloudinary. No upload do form HTML você passa a usar só os helpers do Attachinary. E no HTML onde você mostra a imagem em si, você pode criar um helper que checa por `@user.new_avatar?` e mostra usando `cl_image_tag(@user.avatar.path)`, caso contrário mostra as URLs antigas.

Você não precisa migrar tudo de uma vez para o Cloudinary. Basta deixar os assets antigos onde estão e começar a colocar os novos assets na configuração do Cloudinary. Ele tem um Free Tier que comporta até 75 mil imagens e permite tráfego de até 5GB. E com apenas USD 44 por mês você tem 10 vezes isso. Então é bem barato, se sua aplicação leva upload de arquivos a sério.

Se você ainda não quer se comprometer com um serviço externo, e está usando Carrierwave, outra opção que vale considerar é testar o [CarrierwaveDirect](https://github.com/dwilkie/carrierwave_direct) para experimentar direct upload do browser para o S3. Isso pelo menos vai te livrar das complexidades de configurar uploads assíncronos da aplicação web para o S3.

Update: o [Janko Marohnić](https://github.com/janko-m) postou um comentário muito bom que vale citar diretamente:

> Great writeup, I wholeheartedly agree that we probably don't "just want something simple", especially concerning synchronous uploads and CDNs.

> Shrine actually has a [Cloudinary integration](https://github.com/janko-m/shrine-cloudinary), and it's pretty advanced too; it supports direct uploads, setting upload options, storing Cloudinary metadata (hello [responsive breakpoints](http://cloudinary.com/blog/introducing_intelligent_responsive_image_breakpoints_solutions)) etc :). Also, the Cloudinary gem ships with a CarrierWave integration. I think it's beneficial to use Shrine or CarrierWave with Cloudinary, because then you get to keep your file attachments library, and just change the underlying storage service.

> As for CarrierwaveDirect, I don't think it's actually very useful, because backgrounding you need to do all by yourself anyway, so basically all it gives you is the ability to generate a direct-upload form to S3. But generating request parameters and URL to S3 is something that's already built in into the official [aws-sdk](https://github.com/aws/aws-sdk-ruby) gem, CarrierwaveDirect just seems to be reimplementing that logic. And the advantage of generating this through aws-sdk is that it's not HTML-specific, so you could setup an endpoint which returns this information as JSON, and now you have your multiple file uploads directly to S3 :)

Como disclaimer: eu mesmo não testei o CarrierwaveDirect e lembro que ele estava bem quebrado uns 2 anos atrás. E ouvi coisas boas sobre o Shrine ao longo do caminho, mas nunca fiz um teste decente. Recomendo experimentar se você quer migrar para longe do Carrierwave.

### Não sirva assets do S3, use um CDN, qualquer CDN

Se você vai continuar fazendo upload para o S3, pelo menos evite servir esses arquivos a partir do S3. No meu post da "Enciclopédia do Heroku" eu recomendava usar o "S3 Assets Sync". NÃO FAÇA ISSO: use um CDN no lugar, é mais rápido, mais fácil e é a solução correta.

A primeira coisa a fazer é se cadastrar no serviço de CDN da AWS, o Cloudfront. Use sempre um CDN para todos os seus assets, não apenas os [internos da sua aplicação web](http://www.algonauti.com/posts/speed-up-ugc-with-cloudfront), mas também todo conteúdo que o usuário sobe. É [super simples](https://devcenter.heroku.com/articles/using-amazon-cloudfront-cdn) criar um novo endpoint de CDN apontando para o seu bucket S3.

O Carrierwave por padrão usa o host do bucket S3, mas uma vez que você tem o endpoint do Cloudfront, dá para [trocar facilmente](https://dzone.com/articles/carrierwave-heroku-cloudfront) todas as URLs dos arquivos enviados assim:

```ruby
# ./config/initializers/carrierwave.rb
CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider => "AWS",
    :aws_access_key_id => ENV['AWS_ACCESS_KEY_ID'],
    :aws_secret_access_key => ENV['AWS_SECRET_ACCESS_KEY'],
  }
  config.fog_directory = ENV['S3_BUCKET']

  # use apenas uma das 2 configurações abaixo
  # config.fog_host = "http://#{ENV['S3_BUCKET']}.s3.amazonaws.com"
  config.fog_host = ENV['S3_CDN'] # para cloudfront
end
```

Você obviamente precisa configurar a variável de ambiente `S3_CDN` para apontar para o endpoint do Cloudfront específico do bucket S3 que está usando.

A parte importante é: sirva TODOS OS ASSETS de um CDN, não importa o quê. Nunca direto da sua aplicação web, evite servir direto do S3. É quase trivial de implementar e, se você não gosta da AWS por qualquer motivo, dá para escolher Fastly, Cloudflare e vários outros.

Todos funcionam da mesma forma. NÃO existe desculpa para não usar um CDN, não importa o tamanho da sua aplicação.
