---
title: Páginas Estáticas no Rails
date: '2011-11-11T01:38:00-02:00'
slug: paginas-estaticas-no-rails
tags:
- learning
- beginner
- rails
draft: false
---

Faz tempo que não posto uma dica técnica, vou retornando aos poucos. Hoje uma dica bem simples mas que muitos ainda desconhecem.

Muitos aplicativos Rails tem seções com páginas estáticas, páginas de conteúdo como institucional, instruções, etc. Digamos que para organizar isso você tenha criado um controller chamado “Page”, assim:

* * *

```bash
bundle exec rails g controller Page
```

O problema é que eu sempre vejo algo parecido com isto no <tt>config/routes.rb</tt>

* * *

```ruby
match “page/hello” => “page#hello” 
match “page/help” => “page#help”
```

* * *

Daí no <tt>app/controllers/page_controller.rb</tt> encontro:

* * *

```ruby
def hello end 
def help end 
…
```

* * *

Actions vazias de _placeholder_ somente para renderizar páginas estáticas como <tt>app/views/page/hello.html.erb</tt>. E este exemplo tem apenas duas páginas, agora escale isso para algumas dezenas e você verá logo o _code smell_ de um clássico _efeito shotgun_: múltiplos <tt>match</tt> redundantes no <tt>routes.rb</tt> e múltiplos métodos vazios no controller.

Em vez disso, uma das muitas formas de resolver esse problema é fazer simplesmente isto no arquivo <tt>config/routes.rb</tt>:

* * *

```ruby
get “page/:id” => “page#index”, :as => :page
```

* * *

E no controller “Page” ter uma única action:

* * *

```ruby
def index 
  render params[:id] 
end
```

* * *
Agora você pode colocar quantas views quiser em <tt>app/views/page</tt> e quando chamar <tt>http://localhost:3000/page/hello</tt> ele irá automaticamente mapear para <tt>app/views/page/hello.html.erb</tt>.

Eu disse “páginas estáticas” mas na verdade seriam “semi-estáticas” já que normalmente faríamos desta forma porque queremos que a página herde o layout principal e tudo mais. Se for para ser uma página realmente estática, fora do layout padrão do site, etc, você pode simplesmente colocar um html no diretório <tt>public</tt>.

Dá para melhorar mais isso, fazendo algumas checagens óbvias como validar se o template da página existe:

* * *

```ruby
def index 
  if params[:id] && template_exists?(params[:id], [“page”]) 
    render params[:id] 
  else redirect_to ‘/404.html’, :status => 404 end 
end
```

* * *

A dica é a mesma de sempre: se está parecendo um amontoado de copy & paste em todas as camadas, alguma coisa está definitivamente errada. Como eu disse antes, existem múltiplas maneiras para resolver essa funcionalidade, se tiverem outras melhores, não deixem de comentar.
