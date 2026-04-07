---
title: Sua aplicação Rails está pronta para Produção?
date: '2016-03-22T15:11:00-03:00'
slug: sua-aplicacao-rails-esta-pronta-para-producao
translationKey: rails-app-ready-for-production
aliases:
- /2016/03/22/is-your-rails-app-ready-for-production/
tags:
- learning
- rails
- heroku
- deployment
- optimization
- security
- performance
- traduzido
draft: false
---

Isto aqui é um checklist. Siga estas instruções se você quiser ter um pouco de paz de espírito depois de colocar uma aplicação em produção. Se você tem experiência, contribua nos comentários abaixo. Mas se você é iniciante, preste muita atenção.

### Onde fazer o Deploy? TL;DR: Heroku

Muita gente vai mirar primeiro nas opções baratas. Normalmente instâncias EC2 micro ou pequenos droplets do Digital Ocean. A menos que você tenha consciência de que **precisa** monitorar e atualizar essas instâncias o tempo todo, **NÃO** faça isso.

Em vez disso, escolha uma solução PaaS como o Heroku. É óbvio. Software em produção é coisa séria e contínua. Só pelo lado da segurança, você não deveria fazer isso sozinho a menos que saiba como hardenizar uma distribuição de SO. Por exemplo, a maioria das pessoas nem sabe o que é o [fail2ban](http://www.fail2ban.org/wiki/index.php/Main_Page). Não assuma que, só porque você usa SSH com par de chaves, está seguro. Você não está.

Por exemplo, você sabia que a gente acabou de passar por uma [crise de segurança da glibc](https://blog.heroku.com/archives/2016/3/21/patching-glibc-security-hole)? Se você não sabia e há tempos não toca nos seus servidores de produção para atualizar todos os componentes, você está aberto, completamente aberto. Tive vários clientes que contrataram freelancers para implementar e fazer deploy das aplicações e depois ficaram sem ninguém olhando aquilo. Todos vocês estão inseguros.

O Heroku também não é garantia, porque as bibliotecas das aplicações ficam velhas, vulnerabilidades são descobertas, e você precisa atualizá-las. O Rails tem um [time de segurança ativo](https://groups.google.com/forum/#!forum/rubyonrails-security) lançando patches o tempo inteiro. Se você não anda atualizando, está inseguro.

Mas suporte 24x7 é caro. Se você tem infraestrutura própria ou usa uma plataforma IaaS como AWS EC2, você precisa de pessoal 24x7, ou seja, no mínimo 2 administradores de sistema/devops em tempo integral cuidando das coisas. A alternativa é usar um PaaS que pelo menos mantém essas higienes básicas em dia, mais um desenvolvedor part-time só para manter as suas aplicações atualizadas.

Se você não fizer isso, está expondo seu negócio a uma responsabilidade enorme. E se você é desenvolvedor, faça a coisa certa: avise seus clientes sobre esse fato e deixe-os tomar uma decisão informada. Eles podem optar por continuar no barato, mas pelo menos sabem o que isso realmente significa.

### Qual web server? TL;DR: Passenger ou Puma

A maioria das aplicações Rails não tem nem as bibliotecas básicas instaladas para funcionar direito.

Já vi gente rodando aplicação em produção simplesmente subindo o <tt>rails server</tt> e mais nada! Isso roda o Webrick, o web server básico, em produção! Você tem que escolher entre Puma, Unicorn ou Passenger. O Unicorn, na verdade, não protege sua aplicação contra clientes lentos, então evite-o se puder.

Se estiver na dúvida, [instale o Passenger](https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/heroku/standalone/oss/deploy_app_main.html) e vá tomar um café.

A escolha mais comum hoje em dia é [usar Puma](https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server). Mas se você está rodando no Heroku ou usando instâncias pequenas, tenha em mente o consumo de RAM. Uma aplicação Rails normal consome no mínimo 150Mb a 200Mb ou mais, dependendo do tamanho do seu app. O menor dyno do Heroku tem só 512Mb de RAM, o que significa que você não deve configurar Puma ou Unicorn com mais que 2 instâncias. Eu recomendaria ir de Dyno 2X (1GB) e ter no máximo 3 instâncias (ou seja, 3 requisições concorrentes possíveis sendo processadas ao mesmo tempo).

É comum sua aplicação ir aumentando o consumo de RAM ao longo do tempo, e a cada par de dias você ver um R14 acontecendo. Aí o dyno reinicia e começa a funcionar melhor por um tempo, até bater no teto de novo.

Se você não sabe por que isso acontece e é algo infrequente, dá para usar temporariamente o [Puma Worker Killer](https://github.com/schneems/puma_worker_killer) - se você estiver usando Puma, claro - para ficar monitorando suas instâncias até que cheguem a um certo teto mais baixo e reciclem automaticamente antes que seus usuários vejam os erros R14.

Você também já deve ter ouvido falar do [Out-of-Band GC](http://tmm1.net/ruby21-oobgc). Mas [fique avisado](https://github.com/puma/puma/issues/450) que o Puma em modo threaded não funciona bem com isso. Se você usa Unicorn, então use sem medo.

### Meça, Meça, Meça. TL;DR: New Relic

![Heroku Metrics](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/535/big_heroku-metrics.png)

Você deve **sempre** monitorar sua aplicação. Seja com software instalado por conta própria como Nagios, Munin, Zabbix, Zenoss, Ganglia etc, ou no mínimo com as métricas que o próprio Heroku fornece, como na imagem acima.

Se suas instâncias estão se comportando de forma estranha, dê uma olhada nos avisos. Um conjunto frequente de erros [R14](https://devcenter.heroku.com/articles/ruby-memory-use) significa que o consumo de memória da sua app está crescendo ao longo do tempo e estourando o limite de RAM disponível na instância (provável vazamento de memória). No mínimo, isso significa que você deve diminuir a concorrência/workers no seu Puma/Unicorn e também aumentar o número de dynos para compensar, se tiver tráfego suficiente para justificar. Mas essa é uma ação orientada a métricas que você pode tomar porque tem informação para uma decisão consciente.

Você também deve estar armazenando e indexando seus logs usando software instalado como Greylog2 ou Logstash, ou uma alternativa SaaS como o [Papertrail](https://elements.heroku.com/addons/papertrail). Existem várias razões pelas quais uma aplicação pode estar vazando, ou pelas quais tudo parece estar bem nas métricas mas você está tendo erros aleatórios. Sempre consulte os logs para ter respostas.

Melhor ainda, [instale o New Relic APM](https://docs.newrelic.com/docs/agents/ruby-agent/miscellaneous/ruby-agent-heroku). Você terá métricas, alertas automatizados, medição de erros e diagnósticos realmente profundos para ver exatamente que linha do seu código fonte é a culpada pela performance ruim, pelos erros frequentes ou pelo comportamento errático. Se estiver em dúvida, instale logo, o plano básico é grátis mesmo.

### Algumas Dependências do Rails

Você **NÃO** deveria estar usando Rails abaixo da versão 4.0 a essa altura. O 3.2 ainda é bastante usado, mas o suporte vai acabar logo. Não use o Rails 5.0 agora a menos que tenha experiência suficiente para saber o que fazer. Qualquer coisa entre 4.0 e 4.2 deve estar ok, mas fique atento aos minor releases que corrigem vulnerabilidades de segurança.

Você **NÃO** deveria estar usando Ruby abaixo da versão 2.2 a essa altura. As atualizações de segurança para o 2.0 acabaram em fevereiro de 2016. O 2.1 não foi um release estável bom, mas o 2.2 e o 2.3 estão muito bons e você deveria estar usando eles.

Então a combinação Ruby 2.3.0 e Rails 4.2.5.2 (a partir de março de 2016) é a escolha ideal para a melhor estabilidade, segurança e suporte do ecossistema.

Você deveria ter, no mínimo, as seguintes dependências instaladas por padrão:

* [Rails 12 Factor gem](https://github.com/heroku/rails_12factor)
* [Rack-Cache middleware](http://rtomayko.github.io/rack-cache/)
    - [Gem Dalli com Memcached ou Memcachier](https://devcenter.heroku.com/articles/memcachier#rails-3-and-4) - mesmo se você não estiver usando fragment caching ou AR caching, isso ainda é útil pelo menos para a [gem Rack-Cache](https://devcenter.heroku.com/articles/rack-cache-memcached-rails31).
* [Rack-Attack](https://github.com/kickstarter/rack-attack) - leia como configurar direito!
* [Rack-Protection](http://www.sinatrarb.com/rack-protection/) - leia como configurar direito e quais proteções você quer ativar, não tudo, mas pelo menos CSRF e XSS.
* [Sprockets 3.3+](http://www.schneems.com/blogs/2016-02-18-speeding-up-sprockets/) - garanta que está usando a versão do Sprockets que corrige a lentidão e deixa as coisas razoavelmente mais rápidas

### Qual Banco de Dados? TL;DR: use Postgresql

**NÃO** escolha MongoDB ou similar a menos que tenha uma razão muito forte e esteja confiante de que é muito bom no que faz e vai ficar por perto para manter o que colocou em produção. Caso contrário, fique no Postgresql e na gem "pg", você não vai se arrepender, nem o seu cliente.

Use instâncias pequenas de Redis (particularmente opções SaaS como o [Heroku Redis](https://elements.heroku.com/addons/heroku-redis)) com o [Sidekiq](https://github.com/mperham/sidekiq/wiki/Deployment). Você pode optar pelo Sucker Punch, mais leve, mas saiba que ele vai aumentar bastante o consumo de RAM das suas instâncias dependendo do tamanho das filas e dos dados serializados de entrada para os workers. Nem sempre é trivial saber quantos workers Sidekiq você deveria ter, mas [esta calculadora](http://manuel.manuelles.nl/sidekiq-heroku-redis-calc/) pode ajudar.

Existem pelo menos 2 grandes erros que a maioria das pessoas comete usando Sidekiq:

* Ter workers pesados batendo no seu banco de dados master. Por exemplo, um grande procedimento de analytics buscando grandes conjuntos de dados enquanto seu site principal também tem uso intenso de usuários escrevendo dados o tempo inteiro. Definitivamente adicione um [banco Follower](https://devcenter.heroku.com/articles/heroku-postgres-follower-databases) e aponte os workers Sidekiq (read-only) para lá, para analytics, relatórios e cargas similares.
* Buscar grandes datasets em memória e estourar seus dynos de worker. Se você fizer qualquer coisa parecida com "YourModel.all.each { |r| ... }", está dando um tiro no próprio pé. O Rails tem formas fáceis de [buscar pequenos conjuntos em batch](http://api.rubyonrails.org/classes/ActiveRecord/Batches.html) para você processar, use-as.

### Você está usando um CDN? TL;DR: simplesmente use

Isso é fácil, use [AWS CloudFront](https://devcenter.heroku.com/articles/using-amazon-cloudfront-cdn) ou [Fastly](https://devcenter.heroku.com/articles/fastly) ou outra coisa, mas **USE** um CDN. É óbvio.

Caso contrário, seus assets vão ser servidos pelas suas instâncias de web dyno, que já são pequenas. E isso é um trabalho pesado que é melhor servido por um CDN muito mais rápido. Seus usuários vão perceber ordens de magnitude em usabilidade só mudando algumas linhas de configuração no seu código.

Se você implementou suas views, templates e stylesheets do Rails usando os helpers "image_tag" e "asset_path", isso é automático. Faça logo.

E já que estamos falando de assets, se você por acaso tem upload de imagens e está usando o jeito simples de postar um formulário multipart direto para a sua aplicação Rails, vai ter problemas, porque o Heroku impõe - corretamente - um timeout máximo de 30 segundos. Se você tem muitos usuários subindo muitas imagens de alta resolução e tamanho pesado, eles vão ver cada vez mais timeouts.

Use a [gem Attachinary](http://cloudinary.com/documentation/rails_additional_topics) para fazer upload direto via Javascript, do navegador para o serviço Cloudinary, contornando completamente sua aplicação Rails, que vai apenas receber o ID quando o upload terminar. De novo, tem um plano grátis bem generoso e é tão simples de implementar que você precisa fazer isso já.

### Você demitiu seu desenvolvedor, e agora? TL;DR: revogue os acessos!

Isso acontece muito: uma empresa pequena precisa cortar custos e demitir desenvolvedores.

Garanta que você revogue os acessos. Na AWS isso é bem mais convoluto se você não conhece bem a ferramenta de autorização IAM deles. Ou pior: se eles têm as chaves privadas (arquivos .pem) para suas instâncias EC2!! Você vai ter que criar novos pares de chaves, desativar as instâncias EC2 antigas e criar novas. Uma puta dor de cabeça.

Você precisa trocar senhas do seu serviço de DNS, da organização no Github/Bitbucket, remover chaves SSH dos arquivos .ssh/authorized_keys em todos os seus servidores etc.

Garanta que sua empresa tem um bom suporte jurídico e faça com que cada colaborador, funcionário ou terceirizado, assine um acordo de confidencialidade, NDA ou non-compete.

Você **PRECISA** ter pelo menos uma pessoa-chave na empresa que tem controle sobre as chaves, senhas e acesso a todo serviço do qual sua empresa depende para funcionar. Caso contrário, não se surpreenda quando sua aplicação ficar fora do ar.

E não se iluda achando que, só porque uma aplicação está online e rodando, vai continuar assim por muito tempo. Vulnerabilidades de segurança estão soltas por aí, é só uma questão de tempo até algum problema derrubar seu serviço, e é melhor você ter alguém para colocá-lo de volta no ar se você mesmo não souber fazer isso.

### Site Grande? Parabéns, e agora?

Se seu negócio está prosperando, florescendo, parabéns. Você está naquela porcentagem muito muito pequena que realmente conseguiu.

Em breve sua aplicação novinha em folha vai virar aquele sistema feio e temido chamado **Legacy**. Pior, provavelmente é um daqueles **monolitos** assustadores ou, pior ainda, você deixou um desenvolvedor hipster criar uma arquitetura espaguete cheia de **microserviços** sem controle. Você está condenado de qualquer jeito.

Essa situação exige que você fique com os pés no chão: bala de prata não existe, é o trabalho de sempre.

Você precisa se manter à frente do jogo, e a parte de monitoramento que mencionei tem um papel grande para guiar você pelas várias direções possíveis. Por exemplo, por um curto período de tempo dá para aumentar os planos dos seus serviços SaaS como bancos de dados, caches, filas, e também adicionar mais web dynos paralelos.

Isso vai segurar a onda por um tempo (suas métricas podem ajudar a estimar por quanto), mas agora você precisa montar um plano para otimizar o que tem. E não, reescrever tudo é a última coisa que você quer fazer, a menos que pretenda não ter vida pelos próximos dois anos.

Confie em Pareto: na vida real, 80% dos principais problemas podem ser resolvidos com 20% do esforço. A grande dica: abra o New Relic - agora carregado com dados reais de produção - e olhe os Top piores performers e comece por aí. O primeiro que você resolver (seja uma feia query N+1 no banco, uma integração lenta com web service), vai te dar muito espaço para respirar.

### Conclusão

O que eu acabei de dizer é só a ponta do iceberg em termos de otimização de performance Rails. E posso te garantir que existe muito espaço para melhorar sem precisar recorrer a reescrever tudo na próxima linguagem da moda. Recomendo que você compre o ["The Complete Guide to Rails Performance"](https://www.railsspeed.com/) do Nate Berkopec para realmente aprender o terreno.

Esta é uma compilação muito rápida que despejei da cabeça, mas tem muito mais coisa que podemos considerar. Mande perguntas na seção de comentários e outros itens importantes que eu posso ter deixado passar.
