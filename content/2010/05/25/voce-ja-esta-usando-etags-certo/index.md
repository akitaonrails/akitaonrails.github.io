---
title: Você já está usando ETAGs, certo?
date: '2010-05-25T10:15:00-03:00'
slug: voce-ja-esta-usando-etags-certo
tags:
- learning
- beginner
- rails
draft: false
---

 **Atualizado 26/05:** Ajustei o artigo de acordo com os comentários do Tapajós :-)

Essa dica é meio velha, mas como muita gente ainda desconhece vamos falar dela. Um recurso que surgiu no [Rails 2.2](http://guides.rubyonrails.org/2_2_release_notes.html#better-integration-with-http--out-of-the-box-etag-support) é o suporte a ETAG. Se você ainda não usa, deveria. Isso porque é super simples, vai melhorar a performance do seu site para seus usuário e sai praticamente de graça, sem efeitos colaterais.

Para entender, vamos ver a estrutura de uma action comum de ActionController:

* * *

```ruby
def index  
 @posts = Post.all  
 respond_to do |format|  
 format.html # index.html.erb  
 end  
end  
```

Toda vez que você requisitar esta action, o Rails vai buscar os dados no banco, renderizar o template ERB e enviar tudo pro cliente, todas as vezes. Você pode colocar uma regra de expires para que o browser do usuário não peça a mesma página por X tempos, mas isso não é eficiente se você efetivamente quer que o conteúdo novo seja enviado assim que for atualizado. Agora veja esta outra forma:

* * *

```ruby
def index  
`posts = Post.all
  if stale?(:etag => etag(`posts), :public => true)  
 respond_to do |format|  
 format.html # index.html.erb  
 end  
 end  
end

private  
 def etag(collection)  
 collection.inject(0) { |etag, item| etag += item.updated_at.to\_i }  
 end  
```

É só isso. Acontece o seguinte, um ETAG é um identificador único de um determinado recurso. Pense como um Hash. No caso você pode passar qualquer número ao método “stale?”. Como eu sei que toda vez que um Post é atualizado o campo “updated\_at” também muda, significa que basta um Post mudar para que a soma dos “updated\_at” gerado no método “etag” que eu criei vai mudar. Agora, para que serve esse número?

Quando o Rails terminar de renderizar o template ERB, ele vai adicionar o seguinte cabeçalho na resposta ao navegador do usuário:

* * *

```
ETAG: e2b62c2507dd32e23af8e89f305cd864  
```

-

Isso juntamente com o código de status “200 OK”. Porém, se o usuário pedir a mesma página outra vez, o navegador vai enviar junto com a requisição o seguinte cabeçalho:

* * *

```
HTTP_IF_NONE_MATCH: e2b62c2507dd32e23af8e89f305cd864  
```

Ou seja, ele vai dizer ao servidor: _“não me mande nada se o ETAG do recurso que estou pedindo ainda for o mesmo”_. Daí quando isso chegar no Rails, ele vai buscar os posts no banco e quando cair no método “stale?” ele vai notar que o navegador enviou um ETAG e vai comparar com o ETAG que ele acabou de computar. Se nenhum post mudou os ETAGs serão iguais. Nesse caso o Rails não vai processar o ERB e em vez disso vai enviar uma resposta vazia apenas com o código de status “304 Not Modified”, que o navegador saberá interpretar como _“beleza, nada mudou, então mantém a mesma página que já tenho”_

Existe uma variação que é assim:

* * *

```ruby
def show  
 @post = Post.find(params[:id])  
 fresh_when(:etag => @post.updated_at.to_i, :public => true)  
end
```

-

O método [fresh_when](http://apidock.com/rails/ActionController/Base/fresh_when) é chamado por baixo pelo “stale?”. Você usar o fresh_when quando não precisa customizar nada como o “render”. Já com o “stale?”, se vier o “If-None-Match” no cabeçalho HTTP, ele não vai executar nada que estiver dentro do bloco “if stale?”, daí vem os ganhos de processamento, não só da renderização do template mas de quaisquer outros processamentos. Por exemplo:

* * *

```ruby
def show  
 @post = Post.find(params[:id])  
 if stale?(:etag => @post.updated_at.to_i, :public => true)  
 @comments = Post.comments.all(:order => “updated_at DESC”, :conditions => { :spam => false })  
 @tags = Post.tags.all  
 respond_to do |format|  
 format.html  
 format.xml  
 end  
 end  
end  
```

Neste exemplo, se vier o ETAG no “If-None-Match”, vamos economizar buscar os comentários e os tags do Post. Além de evitar gerar o mesmo HTML de novo também evita mais queries no banco de dados.

Outra coisa é que se você usar o método “fresh\_when” precisa tomar cuidado para não cair em exceção de “Double Render Error”. Numa action Rails você não pode ter duas chamadas a “render” ou chamar “render” e “redirect\_to” junto, por motivos óbvios. Por isso, esse código abaixo dará problemas:

* * *

```ruby

def show  
 @post = Post.find(params[:id])  
 fresh_when(:etag => @post.updated_at.to_i, :public => true)  
 render :action => “post”  
end  
```

É necessário fazer uma checagem antes de chamar o “render” do exemplo acima:

* * *

```ruby
def show  
 @post = Post.find(params[:id])  
 fresh_when(:etag => @post.updated_at.to_i, :public => true)  
 if response.status == 200  
 render :action => “post”  
 end  
end  
```

O “if” acima resolve porque se o “fresh\_when” detectou um ETAG ele já configurou o “response.status” para ser igual a “304” que é o código de “Not Modified” no cabeçalho de resposta.

E qual é o ganho? Nesse exemplo – ultra-simples – em modo desenvolvimento, no meu notebook, uma requisição normal com meros 5 registros devolveu em 9ms. Com a adição do ETAG isso caiu para 5ms, um ganho de cerca e **40%** de performance. Claro isso vai variar bastante, mas é claro que o tempo gasto em não processar o template ERB e em não enviar algumas dezenas de kilobytes do HTML gerado é uma boa economia tanto de processamento quanto de banda.

Um fator a se lembrar é que neste caso o banco de dados ainda é acessado, para poder computar o ETAG. E dependendo do método que computa esse valor, o processamento do ETAG em si pode ser custoso. Obviamente você não vai devolver listas com centenas de registros numa homepage, portanto valem as mesmas boas práticas.

Como exemplo temos este blog mesmo. Antigamente eu utilizava [Page Caching](/2008/08/21/tutorial-de-rails-caching-parte-1) no meu blog, ou seja, gerava o HTML estático para economizar processamento. Mas o controle disso pode ser complicado dependendo do seu site. O [Marcos Tapajós](http://twitter.com/tapajos) sugeriu usar ETAG e ele tinha razão: meu servidor não ficou muito mais pesado do que antes e isso economizou muito código extra pra lidar com expiração dos meus caches estáticos.

## Clientes de Web Services

Agora um conceito que é igualmente importante: clientes de web services deveriam se comportar da mesma forma na presença de cabeçalhos como “If-Modified-Since”, “If-None-Match”, “Last Modified” e assim por diante. Ou seja, seu servidor, ao enviar o XML, JSON, Atom, etc deve enviar de volta informações como ETAG, Cache-Control e os clientes que consomem essa informação deveriam ser educados (como o [Guilherme Silveira](http://twitter.com/guilhermesilveira)) e respeitá-las. Ou seja, devolver o “If-None-Match” na presença de ETAG e usar seu cache local caso o servidor tenha enviado informações de expiração.

Resolvi testar o próprio ActiveResource do Rails, que dá uma forma simples de criar clientes de web services _REST-like_ como o que o Rails implementa. Porém parece que ele não respeita essas informações. Não tenho 100% de certeza ainda, mas no meu teste eu envio de volta um ETAG e o cliente ActiveResource não envia o “If-None-Match”, forçando meu servidor a reprocessar a informação.

Se você lida com clientes de web services, lembre-se de implementar essas e outras regras que o HTTP especifica e torne-se um bom cidadão da internet.
