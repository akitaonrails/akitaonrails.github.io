---
title: MOD_RAILS LANÇADO!!
date: '2008-04-11T15:59:00-03:00'
slug: mod_rails-lan-ado
tags:
- passenger
draft: false
---



Mais um lançamento **muito** esperado! Um [mod\_rails](http://www.modrails.com/) que parece que funciona mesmo.

O nome do projeto é Phusion Passenger (alguém andou se inspirando em nomenclatura de Ubuntu). Enfim, o code-nome ‘mod\_rails’ deve pegar mais rápido.

Segundo eles prometem, deployment de aplicações simples deve ser tão fácil quanto um mod\_php. E pelo visto, assim como o pessoal do Github, eles foram atrás das ‘celebridades’ do mundo Rails: até o Ryan Bates (do famoso RailsCasts) já fez um screencast. Eis o [link para o torrent](http://www.modrails.com/videos/phusion_passenger_screencast.mov.torrent) do vídeo.

Estava lendo a documentação e outra coisa que eu gostei: um dos problemas antigos de mod\_\* é que ele roda sob as mesmas autorizações do processo do Apache (eu sei, eu sei, estou simplificando). De qualquer forma, o mod\_rails irá subir sua aplicação como o usuário assinalado no arquivo config/environment.rb de sua aplicação, dessa forma diferentes usuários com diferentes aplicações não poderão ver um ao outro. E em nenhum caso será permitido a uma aplicação Rails subir como _root_, o que é excelente para quem precisa de um shared hosting.

Eles inclusive tem um produto ‘Enterprise’ que ainda não tem detalhes onde alegam que conseguem diminuir em até 33% o uso de memória da sua aplicação Rails (!) Vamos ver!!

