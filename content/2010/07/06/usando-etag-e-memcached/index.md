---
title: Usando ETAG e Memcached
date: '2010-07-06T05:43:00-03:00'
slug: usando-etag-e-memcached
tags:
- learning
- beginner
- rails
draft: false
---

 **Atualização 02/07/2010:** Eu esqueci que o máximo de caracteres de uma chave de memcached é 250. Como estava gerando chaves dos posts usando os permalinks, obviamente em muitos casos vai dar mais de 250. Então o que eu fiz foi gerar as chaves normalmente, criar um digest SHA1 e truncar até 250. Isso deve resolver. Descobri isso porque estou usando o plugin [exception_notifier](http://github.com/rails/exception_notification) e hoje comecei a receber dezenas de e-mails com a exception <tt>Memcached::ABadKeyWasProvidedOrCharactersOutOfRange</tt>. Fica a dica :-)

Aproveitando o [episódio](http://www.akitaonrails.com/2010/07/05/rubyconf-latin-america-derruba-akitaonrails-com) de ontem da lentidão do meu site, resolvi fazer um pequeno ajuste adicionando memcached à equação.

Recordando, eu estou usando ETAGs para economizar processamento. Leia meu [artigo sobre ETAG](http://akitaonrails.com/2010/05/25/voce-ja-esta-usando-etags-certo) para entender do que isso se trata. Basicamente a primeira vez ele vai ao banco, busca os dados, abre o template ERB, gera o HTML e envia de volta ao usuário, o caminho padrão. Com ETAG, na segunda vez ele checa que o dado no banco não mudou e devolve apenas um cabeçalho “304 Not Modified”, evitando o processamento do template ERB e transporte do HTML. Só isso dá uma boa acelerada na requisição.

Porém, eu gero o ETAG usando o campo ‘updated_at’, ou seja, eu preciso acabar indo ao banco e buscar essa informação. Algo parecido com isso:

* * *

```ruby
def show  
 @post = Post.find_by_permalink(*([:year, :month, :day, :slug].collect {|x| params[x] } << {:include => [:tags]}))  
 etag = @post.updated_at.to_i  
 fresh_when( :etag => etag, :public => true ) unless Rails.env.development?  
end  
```

O método <tt>find_by_permalink</tt> é específico do meu blog (veja o código do [Enki](http://github.com/xaviershay/enki) para referência). Daí uso o método <tt>fresh_when</tt> para gerar o cabeçalho caso necessário. O ponto é: ele vai executar o <tt>find</tt> ao banco em **todas** as requisições. No caso que aconteceu ontem, com muitas requisições simultâneas, isso pode se tornar um ponto de contenção crítico, mesmo se a query for muito rápida.

## Memcached

A solução mais simples que eu pensei foi em colocar o memcached na frente disso. Num Ubuntu para instalar o daemon basta fazer:

* * *

```bash
sudo apt-get install memcached libsasl2-dev  
```

-

E no Mac, se você estiver usando o [Homebrew](http://github.com/mxcl/homebrew), basta fazer:

* * *

```bash
brew install Memcached
```

Daí precisa instalar a gem:

* * *

```bash
gem install memcached  
```

Agora no <tt>config/environment.rb</tt> coloque:

* * *

```ruby

ruby config.gem ‘memcached’

…  
end  
require ‘digest/sha1’  

```

E no seu <tt>config/environments/production.rb</tt> coloque:

* * *

```ruby

require ‘memcached’  
config.cache_store = :mem_cache_store, Memcached::Rails.new  
```

Isso habilita o cache via Memcached. Em ambiente de desenvolvimento e teste, ele vai armazenar tudo em memória mesmo, e em produção vai usar o Memcached. Desde o Rails 2.3 o sistema de cache foi abstraído e você pode escolher diversos tipos de armazenadores como memória, arquivo, o próprio memcached e outros. Todos são gerenciados através de uma API única, a partir de <tt>Rails.cache</tt>.

Agora, basta fazer algo assim no controller:

* * *

```ruby
def show
 cache_key = Digest::SHA1.hexdigest(“post_#{[:year, :month, :day, :slug].collect {|x| params[x] }.join(‘_’)}”)  
 etag = Rails.cache.read(cache_key)  
 options = { :public => true }  
 if etag  
 fresh_when( :etag => etag, :public => true ) unless Rails.env.development?  
 options = {}  
 end

 unless request.fresh?(response)  
 @post = Post.find_by_permalink(*([:year, :month, :day, :slug].collect {|x| params[x] } << {:include => [:tags]}))  
 etag = @post.updated_at.to_i  
 Rails.cache.write(cache_key, etag, :expires_in => 1.day)  
 fresh_when( options.merge(:etag => etag, :last_modified => @page.updated_at.utc) ) unless Rails.env.development?  
 end  
end  
```

Existem 2 partes nessa lógica. Na primeira, montamos a chave do cache, que tem que ser única para cada elemento – no caso, um post – que você quer gerenciar. Em especial para meu blog eu monto uma chave baseada nos parâmetros que vem na requisição. Ou seja se o usuário mandar a URL “/2010/01/01/foo” ele vai montar a chave “post_2010_01_01_foo”. Daí ele faz um <tt>Rails.cache.read</tt> para ver se já existe um ETAG armazenado no memcached. Se já existir ele vai tentar chamar o <tt>fresh_when</tt> para ver se pode já só enviar o cabeçalho 304.

Na parte 2 ele checa <tt>request.fresh?(response)</tt>. Se voltar falso quer dizer que o navegador do usuário mandou um ETAG diferente do que temos armazenado no memcached, ou seja, provavelmente o post foi atualizado. Então temos que mandar uma versão nova. Daí ele faz a lógica normal de procurar pelo post, gerar o ETAG. Daí ele grava o ETAG novo no cache, pra garantir, e também manda esse novo ETAG no cabeçalho de volta ao navegador. Da próxima vez, o navegador vai mandar o novo ETAG e daí vai receber de volta apenas o cabeçalho 304. Além disso também estou configurando o cabeçalho “Last-Modified” para facilitar o cache da página.

Um pequeno detalhe é a hash <tt>options</tt>. Logo na parte 1 notem que eu faço isto:

* * *

```ruby
options = { :public => true }  
if etag  
 fresh_when( :etag => etag, :public => true ) unless Rails.env.development?  
 options = {}  
end  
```

E mais abaixo eu faço isto:

* * *

```ruby
options.merge(:etag => etag, :last_modified => @page.updated_at.utc)  
```

Isso porque na implementação do método <tt>fresh_when</tt> tem um trecho que é assim:

* * *

```ruby

if options[:public]  
 …  
 cache_control << “public”  
end  
```

Ou seja, se eu chamar o método <tt>fresh_when</tt> múltiplas vezes com a opção <tt>:public => true</tt>, ele vai ficar adicionando na lista <tt>cache_control</tt> e daí no cabeçalho <tt>Cache-Control</tt> vai voltar uma string tipo <tt>public, public</tt>. Então, se o <tt>fresh_when</tt> já foi chamado no começo, na segunda vez eu tomo o cuidado de não passar o <tt>:public</tt> de novo.

Finalmente, no administrador de posts, eu invalido o cache caso eu atualize ou apague um post. Assim:

* * *

```ruby
class Admin::PostsController < Admin::BaseController  
 after_filter :clean_cache, :only => [:create, :update, :destroy]  
 …

protected def clean_cache Rails.cache.delete(Digest::SHA1.hexdigest(“post_#{@post.permalink.gsub(”/", “_”)}")) Rails.cache.delete(“recent_posts_etag”) end

end
```

No caso faço um <tt>after_filter</tt> que vai rodar só depois dos métodos <tt>create</tt>, <tt>update</tt> e <tt>destroy</tt>. No caso ele apaga o ETAG do post (método <tt>show</tt> do controller público) que tem aquele formato “post_2010_01_01_foo” (no caso eu criei um método chamado <tt>permalink</tt> no model <tt>Post</tt> que formata isso) e também deleta o ETAG no caso da página principal (que eu guardo com a chave <tt>recent_posts_etag</tt>), que busca vários posts. Eu assumo que se um post mudar, é melhor recriar a homepage inteira porque não sei se esse post aparece listado lá ou não. Poderia ter uma lógica melhor, mas considerando que eu não fico atualizando ou deletando posts o tempo todo, isso deve bastar.

Meu blog é bem simples, mas se o administrador fosse mais complexo e precisasse invalidar o cache a partir de múltiplos pontos, o melhor é criar um [Observer](http://railsbox.org/2008/8/22/usando-o-observer-no-rails) que centraliza a lógica e invalidação do cache de ETAGs.

## Sumarizando

Não é um processo complicado mas precisa entender direito para que serve um ETAG e como funciona um cache. O uso do cache em si é bem simples, basicamente você lê (<tt>read</tt>) ou grava (<tt>write</tt>) nele a partir do objeto <tt>Rails.cache</tt>. Agora o importante é saber quando você invalida esse cache.

Logo que o servidor sobe, o cache está vazio, então ele precisa ir ao banco o tempo todo para cada requisição nova. Porém, é só a primeira vez porque a partir de agora ele vai armazenar o ETAG gerado no memcached e depois de 1 dia ou menos, a maioria dos meus posts já estarão com suas ETAGs no cache. Então o MySQL vai basicamente ficar sentado sem fazer nada – que é o ideal.

Então, minha otimização fez duas coisas: na primeira versão, que só gerava e processava ETAGs, eu economizei o tempo de processamento do ERB e envio do HTML. Agora estou economizando comunicação com o banco de dados, o tráfego dos dados entre o banco e o Rails e a geração dos ETAGs em si. Ou seja, o Rails está fazendo muito pouco, praticamente só servindo como um roteador mesmo.

Isso baixou o tempo de processamento médio de uma requisição do meu Rails de uns **50ms** , antes, para algo entre **7ms** e **1ms**!. Somado ao upgrade de memória de 512 para 768 MB de RAM e de 512 MB para 1 GB de swap, meu blog deve estar preparado para aguentar algumas ordens de grandeza mais tráfego simultâneo.
