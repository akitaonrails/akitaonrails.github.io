---
title: "[#IF] Rotação de Logs em Apps Rails"
date: '2013-06-28T14:57:00-03:00'
slug: if-rotacao-de-logs-em-apps-rails
tags:
- learning
- rails
draft: false
---



Quem tem aplicações em produção já deve ter passado por isso. Depois de meses com seu servidor de pé de repente ver que seu espaço em disco está acabando rápido. E quando procurar o culpado, encontrá-lo no arquivo <tt>log/production.log</tt>, com algumas centenas de gigabytes ocupados. O que fazer?

No mundo UNIX existe uma solução padrão para isso, o serviço [logrotate](http://syntaxionist.rogerhub.com/rotate-rails-logs-with-logrotate.html). Isso vale não só para Rails mas para qualquer tipo de log.

Porém, no Rails 3 o próprio Logger sabe como se auto-rotacionar, sem precisar depender do logrotate do sistema. Abra seu arquivo <tt>config/environments/production.rb</tt> e adicione a seguinte linha:

--- ruby
config.logger = Logger.new(Rails.root.join("log",Rails.env + ".log"), 5, 100*1024*1024)
---

O construtor aceita 3 parâmetros:

* caminho do arquivo de log - e aqui no caso está genérico para que você possa colocá-lo em ambientes de outros nomes
* quantidade de arquivos de log que quer manter
* tamanho máximo de cada arquivo de log, em bytes

No exemplo você terá no máximo 5 arquivos de 100 megabytes, quando o 6o arquivo se completar, o primeiro mais antigo é apagado e assim por diante, rotacionando sem consumir todo o espaço do seu disco. A partir daí você vai ter arquivos com nomes de <tt>production.log</tt> (o atual), depois <tt>production.log.0</tt>, <tt>production.log.1</tt>, etc.

Não tem todas as funcionalidades do serviço nativo de logrotate (como gzipar os arquivos antigos, rotacionar por período de tempo, etc), mas para a maioria dos casos deve ser mais que suficiente.
