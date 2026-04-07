---
title: "Checklist de Deploy do Rails 5.1 no Heroku"
date: '2017-06-28T15:12:00-03:00'
slug: checklist-de-deploy-do-rails-5-1-no-heroku
translationKey: rails-51-heroku-checklist
aliases:
- /2017/06/28/rails-5-1-heroku-deployment-checklist-for-heroku/
tags:
- learning
- rails
- heroku
- postgresql
- letsencrypt
- cdn
- traduzido
draft: false
---

Lancei [THE CONF](http://www.theconf.club) ontem. Espero que você aproveite a grade da conferência e aproveite o desconto early-bird limitado!

Enfim, o site em si é super simples. Uma página única. Escolhi usar Rails 5.1 como estrutura porque ele cuida de tudo que eu teria que adicionar manualmente em qualquer outro framework. Especialmente agora que traz suporte nativo a Yarn e Webpack, fica fácil de usar para qualquer dev front-end competente.

Mas mesmo com todas as facilidades embutidas, um setup completo de produção ainda exige etapas extras que a maioria dos iniciantes não conhece. Por isso resolvi compilar um pequeno checklist do que você precisa cuidar antes de fazer deploy em produção. Não é uma lista exaustiva para todos os casos de uso, mas deve ser suficiente para a maioria dos projetos menores.

* [Configurando o projeto](#setup)
* [Adicionando CDN e configurando suporte a CORS](#cdn) (para carregar fontes, por exemplo)
* [Adicionando Memcached](#cache)

<a name="setup"></a>

## Configurando o projeto

Uma coisa que a maioria das pessoas esquece, até desenvolvedores experientes, é que o comando `rails new` usado para criar a estrutura inicial do projeto aceita várias flags. Em vez de ter que ajustar arquivos manualmente depois, você pode começar assim:

```
rails new your_project \
--database=postgresql \
--webpack=react \
--skip-action-cable \
--skip-coffee
--skip-turbolinks
```

Se você está construindo com React ou outro framework JavaScript completo, provavelmente vai querer pular o Turbolinks. Caso contrário, se for um site simples, use [Turbolinks](https://sevos.io/2017/02/27/turbolinks-lifecycle-explained.html).

Comece usando Postgresql desde o início, não use Sqlite3.

Pule o Action Cable. Prefira uma solução real como o [Pusher.com](https://pusher.com/). Se você realmente precisar de algo interno, considere algo como minha solução com Elixir, o [Ex Pusher Lite](http://expusherlite.cm42.io/). Leve essa recomendação com cautela, claro — para coisas pequenas o Action Cable é mais que suficiente. Posso escrever outro post elaborando esse ponto se as pessoas indicarem interesse nos comentários.

Enfim, me perdi. Certifique-se de ter 2 arquivos de boot: primeiro o `Procfile` canônico, usado pelo Heroku em produção:

```
web: bin/rails server -p $PORT -b 0.0.0.0
```

Segundo, um `Procfile.dev` para usar apenas no ambiente de desenvolvimento:

```
web: ./bin/rails server
webpacker: ./bin/webpack-dev-server
```

É assim que você sobe o servidor webpack que vai compilar seus assets em tempo real durante o desenvolvimento. Lembre também de rodar esses dois comandos de dependência:

```
yarn install
bundle install
```

Instale dependências JavaScript com `yarn add [pacote]` e pronto! Em produção você não usa o servidor webpack (por isso não o adicionamos ao `Procfile` de produção) — o Heroku detecta automaticamente a gem [webpacker](https://github.com/rails/webpacker), instala o buildpack do nodejs, roda `yarn install` por você, e quando `rails assets:precompile` executa ele também dispara `yarn run`, que pré-compila todos os assets (JavaScript, folhas de estilo, imagens) com fingerprinting correto para cache busting e tudo mais que já estamos acostumados no Asset Pipeline do Rails.

No Heroku, basicamente você não precisa fazer nada. E num servidor de deploy customizado basta lembrar de rodar a task `assets:precompile` e deixar ela cuidar de tudo.

<a name="cdn"></a>

### Adicionando CDN e configurando CORS

Isso é realmente simples. Não há razão para não adicionar uma CDN a qualquer site. Simplesmente faça.

Abra seu AWS Management Console e [abra o CloudFront](https://console.aws.amazon.com/cloudfront/). Clique em "Create Distribution" e siga os padrões do wizard. O requisito é que você DEVE saber o domínio e subdomínio para onde quer apontar (por exemplo, "www.theconf.club") no campo "Origin Domain Name".

A única customização que você DEVE fazer é mudar a opção ["Forward Headers"](http://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/header-caching.html#header-caching-web-cors) para "Whitelist" em "Default Cache Behavior Settings". Depois adicione "Origin", "Access-Control-Request-Headers" e "Access-Control-Request-Method" à Whitelist. Pronto, sua distribuição está habilitada para CORS.

Vai demorar um pouco para criar (precisa configurar vários data centers ao redor do mundo), mas você vai terminar com uma URL representando sua distribuição, algo como `doz7rtw2u3wg4.cloudfront.net`. Recomendo adicioná-la como variável de ambiente no Heroku assim:

```
heroku config:set CDN_URL=doz7rtw2u3wg4.cloudfront.net
```

Agora edite seu `config/environments/production.rb` e adicione:

```ruby
config.action_controller.asset_host = ENV['CDN_URL'] if ENV['CDN_URL']
```

Para usar a CDN de fato, você deve declarar cada asset utilizado nos templates de view usando os Rails View Helpers como `image_tag`, `asset_path`, `javascript_pack_tag`, `stylesheed_pack_tag`, `stylesheet_link_tag`, etc. O bootstrap do Rails já cria o template de layout com esses helpers, basta seguir o padrão.

Quando o webpack rodar, vai gerar todos os assets estáticos, otimizados e pré-compilados em `public/packs` com um arquivo de manifesto declarando a URL completa apontando para a CDN. Por exemplo, se eu buscar `/app/public/packs/manifest.json` diretamente do dyno do Heroku, terei algo assim:

```
{
  "Roboto-Bold.woff": "//doz7rtw2u3wg4.cloudfront.net/packs/Roboto-Bold-eed9aab5449cc9c8430d7d258108f602.woff",
  "Roboto-Bold.woff2": "//doz7rtw2u3wg4.cloudfront.net/packs/Roboto-Bold-c0f1e4a4fdfb8048c72e86aadb2a247d.woff2",
  "Roboto-Light.woff": "//doz7rtw2u3wg4.cloudfront.net/packs/Roboto-Light-ea36cd9a0e9eee97012a67b8a4570d7b.woff",
  "Roboto-Light.woff2": "//doz7rtw2u3wg4.cloudfront.net/packs/Roboto-Light-3c37aa69cd77e6a53a067170fa8fe2e9.woff2",
  "Roboto-Medium.woff": "//doz7rtw2u3wg4.cloudfront.net/packs/Roboto-Medium-cf4d60bc0b1d4b2314085919a00e1724.woff",
  "Roboto-Medium.woff2": "//doz7rtw2u3wg4.cloudfront.net/packs/Roboto-Medium-1561b424aaef2f704bbd89155b3ce514.woff2",
  "Roboto-Regular.woff": "//doz7rtw2u3wg4.cloudfront.net/packs/Roboto-Regular-3cf6adf61054c328b1b0ddcd8f9ce24d.woff",
  "Roboto-Regular.woff2": "//doz7rtw2u3wg4.cloudfront.net/packs/Roboto-Regular-5136cbe62a63604402f2fedb97f246f8.woff2",
  "Roboto-Thin.woff": "//doz7rtw2u3wg4.cloudfront.net/packs/Roboto-Thin-44b78f142603eb69f593ed4002ed7a4a.woff",
  "Roboto-Thin.woff2": "//doz7rtw2u3wg4.cloudfront.net/packs/Roboto-Thin-1f35e6a11d27d2e10d28946d42332dc5.woff2",
  "application.css": "//doz7rtw2u3wg4.cloudfront.net/packs/application-09b53ce9ca3dd595ee99.css",
  "application.css.map": "//doz7rtw2u3wg4.cloudfront.net/packs/application-09b53ce9ca3dd595ee99.css.map",
  "application.js": "//doz7rtw2u3wg4.cloudfront.net/packs/application-799300612ff6d6595198.js",
  "application.js.map": "//doz7rtw2u3wg4.cloudfront.net/packs/application-799300612ff6d6595198.js.map",
  "home_page.js": "//doz7rtw2u3wg4.cloudfront.net/packs/home_page-ff3b49407a1d01592ad5.js",
  "home_page.js.map": "//doz7rtw2u3wg4.cloudfront.net/packs/home_page-ff3b49407a1d01592ad5.js.map"
}
```

Então, se por algum motivo você precisar criar uma nova distribuição CDN, lembre de atualizar a variável `CDN_URL` no Heroku e fazer redeploy da aplicação para que os assets e esse arquivo de manifesto sejam regerados. Ele vai usar essas URLs ao renderizar os HTMLs finais.

Quando um usuário abre seu site, recebe o HTML com URLs apontando para a CDN. Na primeira vez não haverá nenhum asset em cache, então a CDN vai buscar no seu servidor. Seu servidor deve retornar os assets COM os headers CORS corretos para que a CDN os armazene em cache junto com os headers e os repasse ao browser. O browser precisa desses headers porque vai abrir do domínio `www.theconf.club`, por exemplo, mas as fontes estão sendo carregadas de `doz7rtw2u3wg4.cloudfront.net` — o que geraria um aviso de segurança e bloquearia o carregamento das fontes por serem de domínios diferentes. Por isso os headers CORS indicam que é seguro carregá-las.

Para que sua aplicação Rails retorne os headers corretos, adicione a gem `rack-cors` ao Gemfile. Depois crie um arquivo de configuração em `config/initializers/rack-cors.rb` com:

```ruby
if defined? Rack::Cors
  Rails.configuration.middleware.insert_before 0, Rack::Cors do
    allow do
      origins %w[
        https://theconf.club
        http://theconf.club
        https://www.theconf.club
        http://www.theconf.club
        https://theconf.herokuapp.com
        http://theconf.herokuapp.com
      ]
      resource '/assets/*'
    end
  end
end
```

Quando fizer o deploy, você sabe que está funcionando quando faz um curl num asset e ele retorna os headers Access-* assim:

```
$ curl -I -s -X GET -H "Origin: www.theconf.club" http://www.theconf.club/packs/Roboto-Regular-5136cbe62a63604402f2fedb97f246f8.woff2
HTTP/1.1 200 OK
Server: Cowboy
Date: Wed, 28 Jun 2017 17:44:41 GMT
Connection: keep-alive
Access-Control-Allow-Origin: www.theconf.club
Access-Control-Allow-Methods: GET, POST, OPTIONS
Access-Control-Expose-Headers: 
Access-Control-Max-Age: 1728000
Access-Control-Allow-Credentials: true
Last-Modified: Wed, 28 Jun 2017 17:06:03 GMT
Content-Type: application/font-woff2
Cache-Control: public, max-age=2592000
Vary: Origin
Content-Length: 64832
Via: 1.1 vegur
```

E se tudo estiver configurado, você deve ver os headers sendo repassados pela CDN assim:

```
$ curl -I -s -X GET -H "Origin: www.theconf.club" http://doz7rtw2u3wg4.cloudfront.net/packs/Roboto-Regular-5136cbe62a63604402f2fedb97f246f8.woff2
HTTP/1.1 200 OK
Content-Type: application/font-woff2
Content-Length: 64832
Connection: keep-alive
Server: Cowboy
Date: Wed, 28 Jun 2017 17:45:18 GMT
Access-Control-Allow-Origin: www.theconf.club
Access-Control-Allow-Methods: GET, POST, OPTIONS
Access-Control-Expose-Headers: 
Access-Control-Max-Age: 1728000
Access-Control-Allow-Credentials: true
Last-Modified: Wed, 28 Jun 2017 17:06:03 GMT
Cache-Control: public, max-age=2592000
Via: 1.1 vegur, 1.1 86e9abdb4c15b9d3a542f9b93245e87e.cloudfront.net (CloudFront)
Vary: Origin
X-Cache: Miss from cloudfront
X-Amz-Cf-Id: tVkZ41RRr66iBT6atWTO_oeTY_jG0zCBFuXU8bKyClZDQ8kl-hDegA==
```

Uma CDN é o ingrediente secreto que permite a qualquer site baseado em conteúdo escalar muito além do que seu servidor consegue. É uma economia enorme e ainda proporciona uma experiência muito mais suave para seus usuários.

Um último ponto. Os Rails View Helpers como `image_tag` permitem que você informe o nome do arquivo de imagem sem extensão em desenvolvimento e ele encontra a imagem corretamente. Mas no servidor vai falhar ao renderizar o template dessa forma. Como regra geral, **SEMPRE** informe o nome completo do arquivo com extensão, por exemplo `image_tag("logo.png")` em vez de apenas `image_tag("logo")`.

Você pode ver como isso falha abrindo um console no Heroku:

```
$ heroku run rails c                                                                                                                  
Running rails c on ⬢ theconf... up, run.8271 (Hobby)
Loading production environment (Rails 5.1.2)

irb(main):001:0> ActionController::Base.helpers.asset_path("icon-goals")
Sprockets::Rails::Helper::AssetNotFound: The asset "icon-goals" is not present in the asset pipeline.
    from (irb):1

irb(main):002:0> ActionController::Base.helpers.asset_path("icon-goals.png")
=> "//d134ipy19a646x.cloudfront.net/assets/icon-goals-b969b3b7325d33ad85a88dbb5b894832909ed738eea9964b9cf535646b93674b.png"
```

<a name="cache"></a>

### Adicionando Memcached

Falar sobre cache é sempre complicado. É por isso que muita gente nem tenta. Mesmo que você possa se aventurar em configurações bem granulares como o [Russian Doll Caching](http://edgeguides.rubyonrails.org/caching_with_rails.html#russian-doll-caching), adicionar cache em alguns pontos estratégicos já traz um benefício enorme. E é super fácil de configurar.

O primeiro passo é adicionar o [Memcachier](https://devcenter.heroku.com/articles/memcachier) à sua aplicação Heroku. Ele tem um tier gratuito e para a maioria dos apps pequenos é o suficiente.

A configuração também é trivial. Comece adicionando as seguintes gems ao seu `Gemfile`:

```ruby
group :production do
  gem 'rack-cors', require: 'rack/cors'
  gem 'rack-cache'
  gem 'dalli'
  gem 'kgio'
  gem 'memcachier'
end
```

Agora edite seu `config/environments/production.rb` assim:

```ruby
config.cache_store = :dalli_store

client = Dalli::Client.new((ENV["MEMCACHIER_SERVERS"] || "").split(","),
                           :username => ENV["MEMCACHIER_USERNAME"],
                           :password => ENV["MEMCACHIER_PASSWORD"],
                           :failover => true,
                           :socket_timeout => 1.5,
                           :socket_failure_delay => 0.2,
                           :value_max_bytes => 10485760)
config.action_dispatch.rack_cache = {
  :metastore    => client,
  :entitystore  => client
}
```

Digamos que você tenha um bloco no template que requer vários registros do banco de dados, mas você sabe que esses registros mal mudam. O que fazer? Uma alternativa é fazer cache da query ActiveRecord inteira assim:

```ruby
class HomePageController < ApplicationController
  def index
    @selected_proposals = Rails.cache.fetch('selected_proposals', expires_in: 1.day) do
      Proposal.includes(:authors).where(selected: true).to_a
    end
  end
end
```

O `#to_a` é necessário porque queries ActiveRecord são lazy. O `#to_a` força a busca e o resultado fica em cache. Da próxima vez, não vai tocar no banco de dados por um dia inteiro!

Também poderia ter adicionado um bloco `cache do ... end` no próprio template. Há muitas opções. O ponto é que não é tão difícil quanto a maioria das pessoas imagina.

O que torna o cache difícil é a lógica de expiração. E a regra geral é: nunca tente expirar cache manualmente. Mude a chave de busca para outra coisa e deixe os dados antigos morrerem (o memcached cuida de eliminar os dados antigos não utilizados).

Vale muito a pena ler o [Rails Guides on Caching](http://edgeguides.rubyonrails.org/caching_with_rails.html). Realmente não é tão difícil quanto você pensa, e você pode cachear apenas os trechos onde sabe que há sensibilidade de performance, deixando as partes altamente dinâmicas sem cache.

Como é super barato, use agora mesmo.

<a name="ssl"></a>

### Adicionando suporte a SSL

Se você tem qualquer transação sensível à segurança (ex. compras), use SSL. Muita gente evita porque costuma ser difícil até entender como obter um certificado corretamente.

O [Let's Encrypt](https://letsencrypt.org/) tornou o processo super simples. Parabéns a eles! E melhor ainda: é gratuito! Então não há desculpa para não ter SSL.

E no Heroku é [ainda mais fácil](https://devcenter.heroku.com/articles/automated-certificate-management)!

> O ACM (Automated Certificate Management) está habilitado por padrão para todas as aplicações criadas após 21 de março de 2017 rodando em dynos Hobby ou Professional. Os passos a seguir são para aplicações rodando em Free dynos e para aplicações criadas antes dessa data.

Nos Free Tier Dynos, é assim:

```
heroku certs:auto:enable
```

Verifique o status com `heroku certs:auto`.

Pronto, não há passo 2.

Antes tínhamos que usar a complicada gem [letsencrypt-rails-heroku](https://github.com/pixielabs/letsencrypt-rails-heroku), mas agora está simples demais.

### Conclusão

Acredito que isso cobre o básico do que você deve fazer antes de fazer deploy de um app pequeno no Heroku. Para apps maiores há muito mais preocupações que estão além do escopo deste post.

Se você lembrar de mais dicas e truques, compartilhe na seção de comentários abaixo.
