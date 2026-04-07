---
title: Entrevista com Jan Lehnardt e Chris Anderson do CouchDB
date: '2008-11-19T22:59:00-02:00'
slug: entrevista-com-jan-lehnardt-e-chris-anderson-do-couchdb
translationKey: qcon-jan-chris-couchdb
aliases:
- /2008/11/19/rails-podcast-brasil-qcon-special-jan-lenhardt-and-chris-anderson-from-couchdb/
tags:
- qcon2008
- interview
draft: false
---

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/11/20/couchdblogo.png)](http://incubator.apache.org/couchdb/)

Outro grande dia na QCon SF, e esta manhã eu tive o prazer de entrevistar ambos [**Jan Lehnardt**](http://jan.prima.de/) e [**Chris Anderson**](http://jchris.mfdz.com/posts/122), ambos committers do extraordinário projeto CouchDB. E há mais uma coisa, o Chris é também o criador do projeto [CouchRest](http://jchris.mfdz.com/posts/122), a biblioteca Ruby para consumir recursos CouchDB que o Geoffrey Grosenbach apresenta em seu [screencast de CouchDB](http://peepcode.com/products/couchdb-with-rails).

Eu venho dizendo que Programação Funcional e Bancos de Dados não-Relacionais serão a solução para um mundo multi-core, multi-server. Já estamos vendo este movimento. A Sun está investindo em diferentes linguagens, incluindo Clojure. A Microsoft está desenvolvendo F# e adicionará aspectos funcionais ao C# 4.0. No espaço de Cloud temos Amazon com SimpleDB, Google com BigTable e Microsoft Azure com SQL Data Services: **nenhum deles é relacional**.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/11/20/2711384975_6fd370708a.jpg)

Na comunidade Ruby já viemos falando de Erlang por um tempo, tenho visto pessoas testando CouchDB em projetos Ruby, mesmo aqui no Brasil. Então eu acho que Rails/Merb + CouchRest será uma maneira muito legal de ter aplicações altamente escaláveis quase de maneira automática.

Somos bons já em escalar a camada Web. Nós entendemos HTTP, entendemos balanceamento de carga, entendemos arquiteturas shared-nothing. Mas sempre tem a última milha: a camada de banco de dados. Implementações de servidores SQL como MySQL escalam de maneira muito pobre. Replicação bi-direcional é dolorosa, queries não são facilmente paralelizáveis. Em algum ponto você vai precisar deixar a teoria relacional para trás e começar a denormalizar como louco. Em algum outro ponto, você pode até mesmo precisar de sharding. Tudo isso requer que você modifique o código da sua aplicação e tudo se torna um grande e feio pesadelo.

Escalabilidade de banco de dados não vem de graça, e uma solução pode ser deixar os bancos de dados relacionais completamente. Não estou defendendo acabar com SQL para tudo e ir para CouchDB, mas em vez disso existem Casos de Uso que podem ser melhor adequados com bancos de dados orientados a documentos.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/11/19/podcast-icon-180x180.jpg)](/files/jan_chris_couchdb.mp3)

Jan e Chris foram muito legais em me dar a oportunidade de entrevistá-los e falar sobre os detalhes do CouchDB. Em resumo: ele já está bom para uso em produção agora mesmo. Novas funcionalidades estão chegando, mas você pode tirar vantagem dele hoje. Novamente, o arquivo de áudio estará disponível no feed do [Ruby on Rails Brasil Podcast](http://podcast.rubyonrails.pro.br/) (em inglês), mas você pode fazer download diretamente [daqui](/files/jan_chris_couchdb.mp3).
