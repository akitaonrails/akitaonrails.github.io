---
title: "[Small Bites] Brincando de Crawlers e algumas Dicas Úteis"
date: '2015-05-15T09:10:00-03:00'
slug: small-bites-brincando-de-crawlers-e-algumas-dicas-uteis
tags:
- learning
- ruby
draft: false
---

Eu queria fazer uma limpeza geral na minha conta do Slack (que já tinha mais do que o suficiente de imagens-memes entupindo o limite de armazenamento), o problema é que ele não tem um "marcar tudo" e "deletar tudo" na interface de administração, mas felizmente ele tem APIs!

Então eu escrevi [este pequeno script em Ruby](https://gist.github.com/akitaonrails/38cbbc2c37a7c646fe27) que tem **4 dicas** que vale a pena compartilhar:

```ruby
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
require 'typhoeus/adapters/faraday'

# documentations:
# https://api.slack.com/methods/files.list
# https://api.slack.com/methods/files.delete

api_token = ENV['SLACK_API_TOKEN'] or abort "no api token"
per_page = 500
uri = "/api/files.list?token=%s&ts_from=0&ts_to=now&types=all&count=%s&page=%s"

conn = Faraday.new(:url => 'https://slack.com/') do |faraday|
  faraday.request  :url_encoded             # form-encode POST params
  faraday.response :logger                  # log requests to STDOUT
  faraday.adapter  :typhoeus
end

response = conn.get( uri % [api_token, per_page, 1] )
json = Oj.load(response.body)
total_pages = json["paging"]["pages"].to_i

responses = []
conn.in_parallel do
  (1..total_pages).each do |page|
    responses << conn.get( uri % [api_token, per_page, page] )
  end
end

files_ids = []
errors = []
Parallel.each(responses, in_threads: 10) do |response|
  begin
    json = Oj.load(response.body)
    Parallel.each(json["files"], in_threads: 10) do |file|
      files_ids << file["id"]
    end
  rescue => e
    errors << e
  end
end

uri_delete = "https://slack.com/api/files.delete?token=%s&file=%s"
conn.in_parallel do
  files_ids.each do |file_id|
    responses << conn.get( uri_delete % [api_token, file_id] )
  end
end

puts responses.map do |response|
  Oj.load(response.body)["ok"]
end
```

### Dica 1

Mesmo em pequenos scripts, use [Bundler](http://bundler.io/bundler_setup.html)! 

### Dica 2

Para acessar páginas Web, use a gem ["Faraday"](https://github.com/lostisland/faraday) junto com a gem ["Typhoeus"](https://github.com/typhoeus/typhoeus).

Por que Faraday?

Porque ela abstrai diversos clientes HTTP. Você pode mudar entre Net::HTTP ou Excon ou Typhoeus com mínimo esforço e pode ser útil para diferenciar cenários de produção com um adapter e testes com outro adapter, por exemplo.

Por que Typhoeus?

Porque ela é capaz de realizar diversas requisições em paralelo e o que mais queremos num crawler é paralelizar o máximo possível (vide linhas 25..29 e 45..48 para exemplos). O único cuidado é não puxar coisa demais e estourar o acumulador de retornos (no exemplo, o array <tt>responses</tt>).

Para evitar estourar memória em vez de acumular internamente num array como no exemplo, já use a gem "Dalli" e vá acumulando num Memcached ou acumule num Redis ou MongoDB ou qualquer outro sistema de armazenamento que suporte inserções assíncronas (não bloqueantes, como um RDBMS normal).

### Dica 3

Se estiver recebendo respostas JSON, use um parser rápido como a gem ["Oj"](https://github.com/ohler55/oj). Em conjunto com a gem ["oj_mimic_json"](https://github.com/ohler55/oj_mimic_json) - que você deve colocar junto na Gemfile se for um projeto Rails - ela substitui a padrão gem JSON que o ActiveSupport usa. A Oj é de 2 a 4 vezes mais rápido do que a gem JSON por isso vale a pena usá-la. Claro, ela é rápida assim porque possui uma extension feita em C, ou seja não funciona com JRuby, apenas com MRI.

### Dica 4

Uma vez que recebemos dezenas de respostas, queremos processá-las o mais rápido possível e fazer um mesmo <tt>responses.each { |response| ... }</tt> é lento porque é linear.

Para resolver isso podemos recorrer à gem ["Parallel"](https://github.com/grosser/parallel) (vide exemplos nas linhas 33..42). Ela vai iterar pela coleção paralelamente usando threads.

Em Ruby MRI, lembrar que temos o Global Interpreter Lock (GIL) que bloqueia a execução paralela porque a mudança de estados em código C sem mutexes e outras proteções poderia corromper a execução. Então não precisamos nos preocupar com estado global compartilhado sendo alterado em paralelo por múltiplas threads mas por outro lado não temos multithreading real o tempo todo.

Mas temos como usar threads em operações bloqueantes, I/O bound, ou que tem muita espera (operações com arquivos ou rede). Nesse caso, quando uma thread bloquear esperando a resposta de algum I/O, outra thread pode de fato executar em paralelo. E daí o valor de usar threads no caso de crawlers ou scripts que façam import/export em banco de dados, etc.

Para o caso de I/O bound, usar threads. Mas se o caso for algo CPU-bound, de processamento de dados, cálculos, mais pesados, threads não vão ajudar. Para isso em vez da opção <tt>:in_threads</tt> você usa a opção <tt>:in_processes</tt> que vai fazer um <tt>fork()</tt> do seu processo e vai rodar realmente em paralelo em processos independentes e isolados, sem estado compartilhado.

Como desde o Ruby 2.0 ele suporta ["Copy on Write"](https://blog.engineyard.com/2013/ruby-2-0-under-the-hood#copy-on-write) (ou "COW") de tal forma que mesmo duplicando um processo Ruby, ele não vai duplicar a memória, eles vão compartilhar a memória que não muda e cada processo isola somente a memória que ele mudar. Isso torna rodar processos em paralelo não tão caros em termos de consumo de memória e muito mais fáceis de escrever (sem precisar se preocupar com mutexes e semáforos, já que tudo rodará garantidamente isolado).

Ou seja, para casos justamente como um crawler ou um ETL, a gem "Parallel" pode ser uma mão na roda. Mas sempre meça para saber se as coisas estão realmente paralelas ou se você não está bloqueando suas threads e caindo no caso de execução linear sem saber.
