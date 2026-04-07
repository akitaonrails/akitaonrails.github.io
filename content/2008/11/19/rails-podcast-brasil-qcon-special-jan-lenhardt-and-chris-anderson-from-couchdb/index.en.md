---
title: Rails Podcast Brasil, QCon Special - Jan Lehnardt and Chris Anderson from CouchDB
date: '2008-11-19T22:59:00-02:00'
slug: rails-podcast-brasil-qcon-special-jan-lenhardt-and-chris-anderson-from-couchdb
translationKey: qcon-jan-chris-couchdb
tags:
- qcon2008
- interview
- english
draft: false
---

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/11/20/couchdblogo.png)](http://incubator.apache.org/couchdb/)

Another great day at QCon SF, and this morning I had the pleasure of interviewing both [**Jan Lehnardt**](http://jan.prima.de/) and [**Chris Anderson**](http://jchris.mfdz.com/posts/122), both committers for the extraordinary CouchDB project. And there is another nice twist to this as Chris is also the creator of the [CouchRest](http://jchris.mfdz.com/posts/122) project, the Ruby library to consume CouchDB resources that Geoffrey Grosenbach presents in his [CouchDB screencast](http://peepcode.com/products/couchdb-with-rails).

I've been saying that Functional Programming and Non-Relational Databases will be the way to go into the multi-core, multi-server parallel world. We are seeing this movement already. Sun is investing in different languages, including Clojure. Microsoft has been developing F# and will add functional aspects to C# 4.0. In the Cloud space we see Amazon with SimpleDB, Google with BigTable and Microsoft Azure with SQL Data Services: **none of them are relational**.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/11/20/2711384975_6fd370708a.jpg)

In the Ruby community we've been dabbling around Erlang for a while now, I've seen people trying out CouchDB with Ruby projects, even here in Brazil. So I think Rails/Merb + CouchRest will be a really nice way to have highly scalable applications almost "out of the box".

We've been good at scaling the Web tier. We understand HTTP, we know load balancing techniques, we understand shared-nothing architectures. But there is always the last mile: the database tier. SQL Server implementations such as MySQL scale very poorly. Bi-directional replication is a pain to do, queries are not easily parallelizable. At some point you will have to leave the relational theory behind and start denormalizing like crazy. And at some other point, you might even need to shard your database. All this requires you to change your application code and everything is just one big and nasty nightmare.

Database scalability does not come for free, and one solution may be to leave RDBMS completely. I am not advocating dropping SQL for everything and going CouchDB, but instead that some Use Cases may be more well served with Document-Oriented Databases instead.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/11/19/podcast-icon-180x180.jpg)](/files/jan_chris_couchdb.mp3)

Jan and Chris were really nice to give me the opportunity to interview them on the ins and outs of CouchDB. Bottom line: it's good to prime time right now. New features are coming, but you can take advantage of it today. Again, the audio file will be available in the feed for the [Ruby on Rails Brasil Podcast](http://podcast.rubyonrails.pro.br/) (in English), but you can download directly from [here](/files/jan_chris_couchdb.mp3).
