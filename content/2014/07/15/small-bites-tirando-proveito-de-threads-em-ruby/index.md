---
title: "[Small Bites] Tirando Proveito de Threads em Ruby"
date: '2014-07-15T14:03:00-03:00'
slug: small-bites-tirando-proveito-de-threads-em-ruby
tags:
- learning
- ruby
draft: false
---

Diferente dos meus longos posts [TL;DR](http://en.wikipedia.org/wiki/Wikipedia:Too_long;_didn't_read), quero experimentar um tamanho mais 'small bites'.

Vocês devem ter notado que em todo post do meu blog tem uma lista ao final organizando todos os links que eu espalho por todo o texto, assim você pode ir direto até lá se quiser se lembrar de um link, em vez de ter que reler o texto todo.

Para fazer isso eu implementei um simples <tt>before_save</tt> no meu model de <tt>Post</tt> onde eu vasculho o texto para buscar todos os links, desta forma:

--- ruby
html = self.excerpt_html.to_s + self.body_html.to_s
return [] if html.empty?
doc = Nokogiri::HTML.parse(html)
links = doc.css('a').select { |link| link[:href] !~ /^#/ }
links = links.reduce([]) do |result, link|
  result << { :href     => link[:href],
              :title    => link.try(:children).try(:to_s).try(:strip),
              :internal => false }
```

Com isso tenho todos os links dentro da collection <tt>links</tt>, e agora vou de item a item, para puxar o link e buscar o título em seu conteúdo (que é o método <tt>retrieve_title</tt> no trecho abaixo):

--- ruby
links.each do |link|
  retrieve_title(link)
end
```

Dependendo do post, se tiver muitos links (como o gigante recente de [Web Components](http://www.akitaonrails.com/2014/07/06/web-components-e-uma-revolucao)), ele pode demorar até quase 20 segundos!!

```
    user     system      total        real
0.310000   0.290000   0.600000 ( 19.968512)
```

O método <tt>retrieve_title</tt> que fiz, internamente chama outro método para puxar o link da internet e ler o título, usando Nokogiri:

--- ruby
def parse_external_link(href)
  # require 'timeout' # precisa requerer isso antes
  begin
    Timeout::timeout(3) {
      doc = Nokogiri::HTML(open(href,
        ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE,
        allow_redirections: :all))
      return doc.css('title').first.children.to_s.strip
    }
  rescue
    return ""
  end
end
```

E isso vai ser lento mesmo, porque o tempo de espera para fazer a conexão HTTP, esperar baixar os bits - que vai depender da velocidade da sua conexão -, para uma lista grande de links, pode demorar muitos segundos. E quanto mais links, mais vai demorar. No meu exemplo, no pior caso, se tiver 20 links e todos forem lentos, vai levar pelo menos 60 segundos pra terminar o processo (dado que eu coloquei um timeout de 3 segundos, no máximo, por link).

Outra forma é usar Thread. Mas aí a primeira coisa que você pode lembrar é: 

<blockquote>"Mas eu sei que threads não funcionam em Ruby por causa do tal GIL - Global Interpreter Lock."</blockquote>

E isso é uma **meia verdade**. De fato, threads em Ruby não funcionam como em Java, por exemplo. Um único processo Ruby, só vai conseguir saturar um único Core do seu CPU. Mas internamente você pode executar tarefas concorrentemente em múltiplas threads **se, e somente se**, ela não bloquear. E no caso, I/O (chamada de rede, arquivo, sockets, etc) não bloqueia!

Sabendo disso, o trecho anterior eu posso escrever assim:

--- ruby
pool = []
links.each do |link|
  pool << Thread.new {
    retrieve_title(link)
  }
end
pool.each(&:join)
```

Note que adiciono e inicio múltiplas threads e adiciono num array e depois dou join em todos eles, o que significa esperar até todos terminarem para prosseguir, mas neste ponto todos estão executando concorrentemente. E se fizer a mesma medição, com a mesma quantidade de links que antes estava dando mais de 19 segundos:

```
    user     system      total        real
0.200000   0.300000   0.500000 (  1.611597)
```

Apenas **1.6** segundo! Este trecho em particular ficou **12 vezes** mais rápido com quase nenhum esforço!

## Indo Além

[Threads não são triviais, embora simples](http://lucaguidi.com/2014/03/27/thread-safety-with-ruby.html). Como em qualquer linguagem, devemos tomar cuidado para não escrever no mesmo recurso concorrentemente e cair em [condições de corrida](http://blog.carbonfive.com/2011/10/11/a-modern-guide-to-threads/).

Existem outras formas de executar código em paralelo em Ruby. Uma delas é usar o bom e velho [fork](http://www.ruby-doc.org/core-2.1.2/Process.html#method-c-fork). E para abstrair threads e forks, você pode utilizar gems como o [spawnling](https://github.com/tra/spawnling) ou o mais maduro [parallel](https://github.com/grosser/parallel). 

Fork de processos tem a vantagem de ser "thread-safe", já que tudo vai rodar em processos isolados. Mas eles obviamente são muito mais pesados que threads. Somente a antiga versão 1.8.7 Phusion Enterprise Edition e agora a mais atual 2.1.2 tem o recurso de "copy-on-write", onde um fork não duplica a quantidade de memória.

Além de threads e processos, a terceira forma - mais na moda - é usar I/O assíncrono, com modelo de Actors. E para isso o melhor no mundo Ruby é o grande [Celluloid](http://celluloid.io), mas aí já é demais para este 'small bite'.
