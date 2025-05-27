---
title: "[#IF] ActiveAdmin + Editor HTML 5"
date: '2013-05-13T14:24:00-03:00'
slug: if-activeadmin-editor-html-5
tags:
- learning
- rails
- activeadmin
draft: false
---

Uma das gems que eu mais uso em projetos é o [ActiveAdmin](http://activeadmin.info/documentation.html), de todas as opções de admin para Rails que surgiram até hoje, esta foi a que melhor se adaptou na maioria dos projetos. Longe de ser perfeita, mas o suficiente para atender bem as necessidades de uma simples coleção de CRUDs.

Outra vantagem é que pouco a pouco um pequeno ecossistema surgiu em torno do framework, adicionando funcionalidades como granularidade de permissões com [CanCan](https://github.com/11factory/activeadmin-cancan), e eu já bloguei sobre sua excelente integração com o [Best in Place](http://www.akitaonrails.com/2012/07/23/activeadmin-best-in-place). Desta vez experimentei outra extensão que gostei muito, o [ActiveAdmin-WYSIHTML5](https://github.com/stefanoverna/activeadmin-wysihtml5).

![ActiveAdmin-Dragonfly](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/362/image_screenshot.png)

Essa extensão foi criada pelo italiano [Stefano Verna](https://github.com/stefanoverna) que também fez diversas outras extensões, incluindo um com o [Globalize 3](https://github.com/stefanoverna/activeadmin-globalize3), e um para fazer upload de imagens que utiliza uma outra gem chamada [Dragonfly](https://github.com/markevans/dragonfly). 

Um parêntese, o Dragonfly é um concorrente de [Carrierwave e Paperclip](http://www.akitaonrails.com/2010/06/23/akita-responde-upload-de-arquivos#.UZEeJys6WDQ). Uma vantagem em relação aos anteriores é que ele herda somente de ActiveModel em vez de ActiveRecord, o que o torna naturalmente compatível com MongoMapper para usar com MongoDB.

Se somar com o Best In Place, CanCan, um versionador como o [PaperTrail](https://github.com/airblade/paper_trail), já é possível fazer um CMS (Content Management System) bastante capaz rapidamente e, melhor, com boa qualidade, bons testes, facilidade de adicionar novas funcionalidades.

Num novo projeto podemos criar um model <tt>Page</tt> que terá o HTML:

```
rails g model Page title body:text
```

Agora adicionamos o que precisamos no <tt>Gemfile</tt>:

```ruby
gem 'activeadmin'
gem 'activeadmin-dragonfly', github: 'stefanoverna/activeadmin-dragonfly'
gem 'activeadmin-wysihtml5', github: 'stefanoverna/activeadmin-wysihtml5'
```

Execute o comando <tt>bundle</tt> para instalar. Agora precisamos criar os arquivos de configuração básicos:

```
rails generate active_admin:install
rake activeadmin_wysihtml5:install:migrations 
```

Finalmente, basta criar a configuração normal para o <tt>ActiveAdmin</tt> para expor o model <tt>Page</tt> criando o arquivo <tt>app/admin/page.rb</tt> com o seguinte:

```ruby
ActiveAdmin.register Page do
  form do |f|
    f.inputs do
      f.input :title
      f.input :body, as: :wysihtml5
    end

    f.buttons
  end
end
```

A opção <tt>:wysihtml5</tt> pode ser customizada para definir que tipos de controle o editor vai possuir. Com o Dragonfly ele automaticamente já ganha o modal para galeria de imagem com suporte a uploads (em outro artigo mostro como migrar o Carrierwave para Dragonfly e como configurar para fazer uploads para S3. Dica: leia a documentação e o código fonte do Dragonfly).

Não esqueça de adicionar os assets do ActiveAdmin no seu <tt>config/environments/production.rb</tt> para que a tarefa de pré-compilação do [Asset Pipeline](http://www.akitaonrails.com/2012/07/01/asset-pipeline-para-iniciantes) compile corretamente (muita gente esquece de fazer isso no começo):

```ruby
config.assets.precompile += %w(active_admin.js active_admin.css active_admin/print.css)
```

![ActiveAdmin-WYSIHTML5](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/361/screenshot.png)

Por causa de opções como essas é que provavelmente não temos um CMS "canônico" no mundo Rails. É mais fácil (e muito mais prático e limpo) incorporar funcionalidades de CMS à sua aplicação do que tentar "estuprar" um CMS limitado para fazer mais do que sua função original.

Em particular, a categoria [Rails Admin Interfaces](https://www.ruby-toolbox.com/categories/rails_admin_interfaces) já evoluiu muito nos últimos anos. Uma recomendação: nunca vai existir um Admin que satisfaça tudo e todos. Se tentar fazer algo customizável e dinâmico demais o projeto pode facilmente sair do controle. Já passamos por isso com o ActiveScaffold e mesmo com o atual Rails Admin. O ActiveAdmin é mais "quadrado" nesse sentido mas é mais simples e explícito no que faz. Alguns não gostam porque para customizá-lo você precisa usar [Formtastic](https://github.com/justinfrench/formtastic). Existem facções que gostam, outras que preferem SimpleForms, e outras que preferem não usar nenhum deles, mas novamente é uma questão de preferência já que ambos tem prós e contras.

O objetivo de mostrar esta gem é demonstrar como o ActiveAdmin pode ser estendido para funcionalidades interessantes sem tanto trabalho e/ou necessidade de criar "yet-another-clone" do ActiveAdmin.
