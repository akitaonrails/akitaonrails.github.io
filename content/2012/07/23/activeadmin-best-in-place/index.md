---
title: ActiveAdmin + Best in Place
date: '2012-07-23T19:36:00-03:00'
slug: activeadmin-best-in-place
tags:
- learning
- rails
- tutorial
- activeadmin
draft: false
---

Vocês devem ter notado que agora as tags de cada post estão listadas e são clicáveis, levando a uma listagem de todas as posts com a mesma tag. Essa funcionalidade já existia nos outros sistemas de blog que usei, mas desde que comecei o blog eu nunca gerenciei as tags corretamente. Só que hoje eu tenho mais de 860 artigos. Eu preciso olhar uma a uma e reeditar as tags. Mas o fluxo normal de:

- abre no admin a listagem de posts;
- navega pela lista paginada;
- encontra um post para editar, clica e abre outra página;
- edita as tags;
- salva, retorna pra listagem;

São muitos passos nos admins antigos. Eu queria navegar pela listagem e editar as tags “in place”, mas sempre tive preguiça de implementar :-)


Mas agora eu estou usando o [ActiveAdmin](http://activeadmin.info/), continuo usando a gem [ActsAsTaggableOn](https://github.com/mbleigh/acts-as-taggable-on/) que, por sua vez, expõe um atributo virtual chamado <tt>tag_list</tt> que retorna as tags na forma de uma string com palavras separadas por vírgulas e eu posso passar um string no mesmo formato para modificar as tags.

Dada esta informação, encontrei esta a gem [BestInPlace](https://github.com/bernat/best_in_place). Mais ainda, ela funciona no ActiveAdmin, e melhor ainda: de forma bem trivial.

## Passo a Passo

Adicione ao seu <tt>Gemfile</tt> e rode <tt>bundle install</tt> depois:

* * *
ruby

gem “best\_in\_place”  
-

Dado que você já tem o ActiveAdmin, edite o seu <tt>app/assets/javascripts/active_admin.js</tt> para ficar assim:

* * *
javascript

//= require jquery  
//= require jquery-ui  
//= require jquery.purr  
//= require best\_in\_place  
//= require active\_admin/base

$(document).ready(function() {  
 jQuery(“.best\_in\_place”).best\_in\_place();  
});  
-

Baixe o [jquery.purr](http://code.google.com/p/jquery-purr/) e copie o <tt>jquery.purr.js</tt> para a mesma pasta <tt>app/assets/javascripts</tt>. Não esqueça de alterar seu <tt>config/application.rb</tt> para declarar os JS e CSS do ActiveAdmin:

* * *
ruby

config.assets.precompile += %w(active\_admin.js active\_admin.css)  
-

Agora, no meu caso eu tenho o model <tt>Post</tt> registrado em <tt>app/assets/admin.rb</tt> modificando meu <tt>index</tt> para ficar assim:

* * *
ruby

ActiveAdmin.register Post do  
 index do  
 column :title do |post|  
 link\_to post.title, post.permalink  
 end  
 column :tag\_list do |post|  
 best\_in\_place post, :tag\_list, type: :input, path: [:admin, post]  
 end  
 column :published\_at do |post|  
 I18n.l post.published\_at, format: :short  
 end  
 default\_actions  
 end  
 …  
end  
-

O helper <tt>best_in_place</tt> funciona quase como qualquer outro Helper de Form do Rails: nome do model, nome do campo, tipo, path (lembrando que o Rails vai converter um Array como se fosse uma rota nomeada com namespace, no caso <tt>[:admin, post]</tt> se torna <tt>admin_post_path(post)</tt>, isso é assim desde o Rails 2 se não me engano).

E pronto! Reiniciando meu servidor, e _presto_!

![](http://s3.amazonaws.com/akitaonrails/assets/image_asset/image/6/big_best_in_place.jpg)

Agora fica o trabalho (muito trabalho!) de navegar pela listagem e ir atualizando as tags, mas com isso o trabalho será uma ordem de grandeza melhor!

