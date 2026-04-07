---
title: Melhorando a Performance de Integração entre Microservices com Memcache e ETAGs
date: '2016-03-23T14:46:00-03:00'
slug: melhorando-performance-integracao-microservices-memcache-etags
translationKey: microservices-memcache-etags
aliases:
- /2016/03/23/improving-your-microservices-integration-performance-with-memcache-and-etags/
tags:
- learning
- rails
- otimization
- performance
- heroku
- memcached
- traduzido
draft: false
---

Todo mundo está embarcando em microservices. Não tem como fugir. No mundo Rails estamos bem equipados para satisfazer a fome de qualquer Framework Javascript da moda por consumo de APIs.

Resumindo, a maioria das pessoas está apenas expondo seu conteúdo via endpoints JSON simples e consumindo eles a partir de outros microservices via simples HTTP GETs. Quanto mais microservices você adiciona na cadeia, mais tempo o último endpoint demora para retornar. Existem várias técnicas para melhorar essa situação, mas eu quero mostrar apenas uma bem simples que resolve muitas situações comuns sem muito trabalho.

Antes de tudo, se você está lidando com cache, nunca tente expirar entradas de cache. A coisa mais importante para aprender sobre caching é como gerar chaves de cache adequadas. Faça isso direito e a maior parte dos problemas com cache desaparecem.

Segundo, se você está usando HTTP, tente usar tudo o que você puder dele, ao invés de reinventar a roda.

A versão "TL;DR" é: faça suas APIs retornarem ETAGs adequados e tratarem corretamente os headers "If-None-Match", retornando o status code 304 ao invés de 200 com o body completo da resposta toda vez. E na ponta consumidora, faça cache do ETAG junto com o body correspondente e use ele do cache quando receber 304s. Você vai economizar pelo menos o tempo caro de renderização na ponta consumida e a banda lenta na ponta consumidora. No final você deve conseguir ficar pelo menos 100% mais rápido, ou mais, com poucos ajustes.

### As Aplicações de Exemplo

Num exemplo bem capenga poderíamos ter um controller de API Rails assim:

```ruby
## 1a aplicação
class Api::ProductsController < ApplicationController
  def index
    @products = Product.page (params[:page] || 1)
    render json: [num_pages: @products.num_pages, products: @products]
  end
  ...
end
```

Para os fins deste exemplo capenga de post, carregamos ele no localhost porta **3001**. Agora, sempre que chamarmos "http://localhost:3001/api/products?page=1" o servidor da API mostra algo assim no log:

```
Started GET "/api/products?page=1" for 127.0.0.1 at 2016-03-23 13:29:34 -0300
Processing by Api::ProductsController#index as */*
  Parameters: {"page"=>"1"}
   (0.3ms)  SELECT COUNT(*) FROM "products"
  Product Load (0.9ms)  SELECT  "products".* FROM "products" LIMIT 100 OFFSET 0
Completed 200 OK in 26ms (Views: 23.0ms | ActiveRecord: 1.2ms)
```

Resumindo, está levando cerca de **26ms** para devolver um JSON com a primeira página de produtos desta aplicação. Nada mal.

Daí podemos criar outra aplicação Rails API que consome essa primeira. Algo também bem capenga e bobo assim:

```ruby
# 2a aplicação
class Api::ProductsController < ApplicationController
  def index
    # nunca, jamais, faça hardcode de hostnames assim, use dotenv-rails ou secrets.yml
    url = "http://localhost:3001/api/products?page=?" % (params[:page] || "1")
    json = Net::HTTP.get_response(URI(url)).body

    response.headers["Content-Type"] = "application/json"
    render plain: json
  end
  ...
```

Carregamos esta outra app no localhost porta **3000** e quando chamamos "http://localhost:3000/api/products?page=1" o servidor mostra o seguinte log:

```
Started GET "/api/products?page=1" for 127.0.0.1 at 2016-03-23 13:31:59 -0300
Processing by Api::ProductsController#index as HTML
  Parameters: {"page"=>"1"}
  Rendered text template (0.0ms)
Completed 200 OK in 51ms (Views: 7.1ms | ActiveRecord: 0.0ms)
```

Agora, esta segunda aplicação está levando o dobro do tempo comparada com a primeira. Podemos assumir que parte desses 51ms são os 26ms da primeira aplicação.

Quanto mais APIs adicionarmos uma em cima da outra, mais tempo o fluxo todo vai levar. 26ms para a primeira, mais 25ms para a segunda, e assim por diante.

Tem várias coisas que poderíamos fazer. Mas eu defendo que devemos começar simples: usando de fato um pouco mais do protocolo HTTP.

### Enviando ETAGs adequados e tratando "If-None-Match"

Em poucas palavras, podemos marcar qualquer resposta HTTP com um ETAG, um identificador para o conteúdo da resposta. Se o ETAG é o mesmo, podemos assumir que o conteúdo não mudou. Browsers recebem os ETAGs e mandam eles de volta se escolhermos atualizar o conteúdo, como um header "If-None-Match". Quando um web server recebe esse header, ele compara contra o ETAG da resposta e não devolve nenhum conteúdo, apenas um header HTTP "304 Not Modified", que é muito, muito mais leve e rápido de transportar de volta.

Um ETAG pode ser tão complicado quanto um SHA256 hexdigest do conteúdo inteiro da resposta ou tão simples quanto apenas o timestamp "updated_at" se isso indica que o registro mudou (numa action "show" de controller, por exemplo). Tem que ser um digest que represente o conteúdo e tem que mudar se o conteúdo mudar.

Rails tem suporte para ETAGs há muito tempo na API [ActionController::ConditionalGet](http://api.rubyonrails.org/classes/ActionController/ConditionalGet.html).

No nosso exemplo capenga, a 1a aplicação na porta 3001 busca uma página de objetos ActiveRecord e devolve um array representado em formato JSON. Se escolhermos fazer digest do conteúdo final teríamos que deixar a ActionView fazer seu trabalho, mas essa é de longe a operação mais cara, então queremos evitar.

Uma coisa que poderíamos fazer é apenas verificar os campos "updated_at" de todos os registros e ver se mudaram. Se qualquer um deles mudou, precisaríamos re-renderizar tudo e mandar um novo ETAG e um novo body de resposta. Então o código poderia ser assim:

```ruby
class Api::ProductsController < ApplicationController
  layout false
  def index
    @products = Product.page (params[:page] || 1)

    if stale?(freshness @products)
      render json: [num_pages: @products.num_pages, products: @products]
    end
  end
  ...
  private

  def freshness(collection)
    dates = collection.map(&:updated_at).sort
    etag = dates.map(&:to_i).reduce(&:+)
    {etag: Digest::MD5.hexdigest(etag.to_s), last_modified: dates.last, public: true}
  end
```

Agora, quando tentamos "curl -I http://localhost:3001/api/products\?page\=1" vamos ver os seguintes headers:

```
HTTP/1.1 200 OK 
X-Frame-Options: SAMEORIGIN
X-Xss-Protection: 1; mode=block
X-Content-Type-Options: nosniff
Etag: "ccf372c24cd259d0943fa3dc99830b10"
Last-Modified: Wed, 23 Mar 2016 16:25:53 GMT
Content-Type: application/json; charset=utf-8
Cache-Control: public
X-Request-Id: 601f22bc-72a9-4960-97cb-c30a0b56dbf4
X-Runtime: 0.053529
Server: WEBrick/1.3.1 (Ruby/2.3.0/2015-12-25)
Date: Wed, 23 Mar 2016 17:00:13 GMT
Content-Length: 0
Connection: Keep-Alive
```

Ótimo! Temos um ETAG que representa unicamente esta página de produtos. Agora podemos ir um passo além e adicionar o seguinte:

```ruby
# Gemfile
gem 'dalli'
gem 'rack-cache'

# config/environments/[development|production].rb
...
config.cache_store = :dalli_store
client = Dalli::Client.new
config.action_dispatch.rack_cache = {
  :metastore    => client,
  :entitystore  => client
}
config.static_cache_control = "public, max-age=2592000"
...
```

Esta configuração assume que temos Memcached instalado e rodando na mesma máquina localhost (nosso ambiente de desenvolvimento), mas em produção você pode seguir esta [boa documentação da Heroku](https://devcenter.heroku.com/articles/rack-cache-memcached-rails31).

Agora, nossa 1a aplicação tem um cache HTTP interno, com o mesmo papel de algo mais avançado como o Varnish na frente dela. Ele vai cachear todas as respostas HTTP 200 da aplicação, junto com os ETAGs. Sempre que uma nova chamada vier para a mesma URI, ele vai checar o cache primeiro, e se a aplicação devolver o mesmo ETAG, ele vai mandar o conteúdo de volta direto do cache.

Então se chamarmos o comando "curl" acima múltiplas vezes, vamos ver isso no log do servidor Rails:

```
Started GET "/api/products?page=1" for 127.0.0.1 at 2016-03-23 14:05:16 -0300
Processing by Api::ProductsController#index as */*
  Parameters: {"page"=>"1"}
  Product Load (0.8ms)  SELECT  "products".* FROM "products" LIMIT 100 OFFSET 0
  Couldn't find template for digesting: products/index
   (1.0ms)  SELECT COUNT(*) FROM "products"
Completed 200 OK in 31ms (Views: 16.3ms | ActiveRecord: 1.8ms)
cache: [HEAD /api/products?page=1] miss, store
```

Repare na última linha: ela diz que tentou achar o ETAG retornado no cache e deu "miss", então "store" do novo conteúdo. Agora, se rodarmos o mesmo comando "curl" novamente, vamos ver isso:

```
Started GET "/api/products?page=1" for 127.0.0.1 at 2016-03-23 14:05:59 -0300
Processing by Api::ProductsController#index as */*
  Parameters: {"page"=>"1"}
  Product Load (0.5ms)  SELECT  "products".* FROM "products" LIMIT 100 OFFSET 0
  Couldn't find template for digesting: products/index
Completed 304 Not Modified in 12ms (ActiveRecord: 0.5ms)
cache: [HEAD /api/products?page=1] stale, valid, store
```

O comando curl simples não está mandando o header "If-None-Match", então ele espera receber o body completo da resposta. Mas como temos o Rack Cache ele está adicionando o digest do ETAG do "If-None-Match" do cache à requisição antes de bater na app Rails. A app Rails agora compara o digest "If-None-Match" recebido através do método "stale?" com o ETAG que acabou de computar e como eles batem, ela apenas manda uma resposta com body vazio e status code 304. O Rack Cache recebe o 304 e busca o JSON cacheado do Memcached e altera a resposta HTTP de 304 para um 200 normal com o body completo, que é o que o Curl pode receber.

Como estamos pulando a renderização cara da ActionView, o tempo de resposta caiu dos 26ms anteriores para cerca de 12ms: estamos agora **duas vezes** mais rápidos!

### Consumindo APIs com ETAGs

Mas podemos ir um passo além. Se não mudarmos nada na 2a aplicação, ela vai continuar recebendo apenas HTTP 200 com bodies completos do Rack Cache da 1a aplicação. Vamos ver o código novamente

```ruby
# 2a aplicação
class Api::ProductsController < ApplicationController
  def index
    # nunca, jamais, faça hardcode de hostnames assim, use dotenv-rails ou secrets.yml
    url = "http://localhost:3001/api/products?page=?" % (params[:page] || "1")
    json = Net::HTTP.get_response(URI(url)).body

    response.headers["Content-Type"] = "application/json"
    render plain: json
  end
  ...
```

Podemos fazer melhor. Que tal o seguinte:

```ruby
# 2a aplicação - upgrade!
class Api::ProductsController < ApplicationController
  def index
    page = params[:page] || "1"
    url = "http://localhost:3001/api/products?page=?" % page
    # 1 - busca o ETAG para a URL
    etag = Rails.cache.fetch(url)
    # 2 - busca da API externa ou do cache interno
    json = fetch_with_etag(url, etag)

    response.headers["Content-Type"] = "application/json"
    render plain: json
  end
  ...
  private

  def fetch_with_etag(url, etag)
    uri = URI(url)

    req = Net::HTTP::Get.new(uri)
    # 3 - adiciona o header importante If-None-Match
    req['If-None-Match'] = etag if etag

    res = Net::HTTP.start(uri.hostname, uri.port) {|http|
      http.request(req)
    }

    etag = res['ETAG']
    etag = etag[1..-2] if etag.present?
    if res.is_a?(Net::HTTPNotModified)
      # 4 - se recebeu 304, então já temos o conteúdo no cache interno
      Rails.cache.read(etag)
    elsif res.is_a?(Net::HTTPSuccess)
      # 5 - se recebeu 200 é conteúdo novo para guardar no cache interno antes de retornar
      Rails.cache.write(url, etag)
      Rails.cache.write(etag, res.body)
      res.body
    else
      "{}"
    end
  end
end
```

Eu sei, parece exagerado, mas é bem simples na verdade. Vamos passo a passo:

1. Primeiro vemos se já temos um ETAG associado à URL que queremos buscar (fique atento aos query parameters!)

2. Agora chamamos o método separado "fetch_with_etag"

3. Isso é todo o boilerplate de setup do "Net::HTTP", mas a parte importante é que adicionamos o header "If-None-Match" se encontramos um ETAG para a URL no cache.

4. Depois de fazer a chamada externa podemos ter 2 respostas. A primeira é o "304 Not Modified" bem curtinho, sem body, só header. Neste caso, significa que já temos o conteúdo completo no cache interno e ele ainda é válido, então usamos ele.

5. No caso de recebermos o status code HTTP "200" normal, ou não mandamos nenhum ETAG ou aquele que mandamos foi invalidado e um novo ETAG e body de conteúdo foi retornado, então precisamos atualizar eles no nosso cache interno antes de sair.

Agora, a primeira vez que chamamos "curl http://localhost:3000/api/products\?page\=1" para o endpoint da 2a aplicação vamos ver este log:

```
Started GET "/api/products?page=1" for 127.0.0.1 at 2016-03-23 14:14:05 -0300
Processing by Api::ProductsController#index as */*
  Parameters: {"page"=>"1"}
  Rendered text template (0.0ms)
Completed 200 OK in 62ms (Views: 5.6ms | ActiveRecord: 0.0ms)
```

Caches estão frios, está levando os mesmos "cerca de 50ms" como tínhamos antes, neste caso, mais para 62ms.

Só para recapitular, esta chamada para a 2a aplicação fez ela chamar a API da 1a aplicação, que mostra o seguinte no seu log:

```
Started GET "/api/products?page=?" for 127.0.0.1 at 2016-03-23 14:14:05 -0300
Processing by Api::ProductsController#index as */*
  Parameters: {"page"=>"?"}
/"32b82ebbd99854ea2ca0d49ff4a7c07c
  Product Load (0.9ms)  SELECT  "products".* FROM "products" LIMIT 100 OFFSET 0
  Couldn't find template for digesting: products/index
   (1.2ms)  SELECT COUNT(*) FROM "products"
Completed 200 OK in 37ms (Views: 21.5ms | ActiveRecord: 2.2ms)
cache: [GET /api/products?page=?] miss, store
```

Cache miss, novo conteúdo armazenado!

Agora, chamamos "curl" contra a mesma URL para a 2a aplicação novamente e agora vemos o que queríamos no log:

```
Started GET "/api/products?page=1" for 127.0.0.1 at 2016-03-23 14:14:10 -0300
Processing by Api::ProductsController#index as */*
  Parameters: {"page"=>"1"}
  Rendered text template (0.0ms)
Completed 200 OK in 24ms (Views: 0.3ms | ActiveRecord: 0.0ms)
```

De 62ms para 24ms!! E no log da 1a aplicação vemos:

```
Started GET "/api/products?page=?" for 127.0.0.1 at 2016-03-23 14:14:10 -0300
Processing by Api::ProductsController#index as */*
  Parameters: {"page"=>"?"}
"ccf372c24cd259d0943fa3dc99830b10", ccf372c24cd259d0943fa3dc99830b10
  Product Load (1.2ms)  SELECT  "products".* FROM "products" LIMIT 100 OFFSET 0
  Couldn't find template for digesting: products/index
Completed 304 Not Modified in 12ms (ActiveRecord: 1.2ms)
cache: [GET /api/products?page=?] stale, valid, store
```

Cache hit! Conteúdo está stale e válido, então retorna apenas 304, a 2a aplicação confirma e busca o conteúdo ainda válido do seu próprio cache e devolve para o Curl.

### Conclusão

Se você remover ETAGs da 1a aplicação, a 2a não vai quebrar e vice-versa, porque é opcional. Se headers "ETAG" e "If-None-Match" estão presentes na resposta HTTP recebida, podemos usar eles, caso contrário vão funcionar como antes.

Se a 2a aplicação é ela mesma outra API você deveria adicionar ETAGs para ela também, e assim por diante. Neste exemplo não fizemos, apenas porque eu queria simplificar o cenário. Mas ao invés de ser apenas um simples proxy um-para-um, ela poderia ser uma daquelas APIs "porcelain" que buscam dados de vários outros microservices menores, compilam num único estrutura e retornam. Você deveria criar ETAGs que poderiam ser os ETAGs retornados de todos os outros microservices digeridos juntos num único ETAG, por exemplo. Como você está apenas recebendo headers e buscando conteúdo de um cache interno, é bem barato. Algo como este pseudo-código:

```ruby
def index
  url1 = "http://somehost1.foo/some_endpoint/1"
  url2 = "http://somehost1.foo/some_endpoint/2"
  etag1 = etag_from(url1)
  etag2 = etag_from(url2)
  etag = Digest::MD5.hexdigest(etag1 + etag2)
  if stale?(etag: etag, public: true)
    body1 = JSON.parse fetch_from(url1)
    body2 = JSON.parse fetch_from(url2)
    result = do_some_processing(body1, body2)
    render json: result.to_json
  end
end
```

Outra coisa: você pode adicionar qualquer HTTP Cache vanilla entre seus microservices, para adicionar autorização, segurança, ou apenas cache extra simples, é só HTTP com headers adequados. Mas quanto mais "304" você troca entre seus serviços, menos processamento e menos banda você está gastando. Deve ser notavelmente eficiente na maioria dos casos. Mas de novo, nem sempre é barato ou trivial gerar as cache keys/ETAGs para começar, então este é o ponto onde precisa ter mais cuidado.

E se você está criando apps Javascript pesados que também consomem essas APIs, eu "acredito" que as chamadas Ajax cacheiam adequadamente o conteúdo HTTP e mandam de volta o "If-None-Match" correto e em caso de receber 304s, sua aplicação deve receber os triggers normais de "success". Eu não testei isso quando estava escrevendo este post mas eu acho que é o caso de fato. Então você deveria automaticamente ter melhor performance na sua aplicação front-end de graça se adicionar ETAGs adequados nas suas APIs.

Isso é particularmente útil para APIs que retornam dados que mudam pouco. Se muda a cada segundo, ou a cada minuto, você não vai ver muito ganho. Mas se for algo como este exemplo: listas de produtos que mudam apenas uma vez por dia ou por semana, ou listas de CEP, ou Pedidos Anteriores num e-commerce. Qualquer dado que muda raramente é um bom candidato. E quanto maior o dataset, maiores os benefícios que você vai ver (se for uma listagem de um megabyte, por exemplo). Como sempre, isso também não é Bala de Prata, mas neste caso dá pouco trabalho adicionar ETAGs e tem efeitos colaterais quase nulos, então por que não?

ETAG é só uma das várias outras features HTTP que você deveria estar usando, CORS é outra (Pesquise [Rack Cors](https://github.com/cyu/rack-cors)).

Se você é do Brasil, deveria assistir o curso completo do Nando Vieira sobre o tema amplo de [Rails Caching](http://howtocode.com.br/cursos/rails-caching).

Para ser honesto, eu não tenho certeza de quão efetiva esta técnica realmente pode ser em todos os tipos de cenários, então estou bem interessado em ouvir seu feedback caso você use algo assim nas suas aplicações.
