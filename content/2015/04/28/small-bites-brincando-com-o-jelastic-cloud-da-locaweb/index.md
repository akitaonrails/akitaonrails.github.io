---
title: "[Small Bites] Brincando com o Jelastic Cloud da Locaweb"
date: '2015-04-28T12:00:00-03:00'
slug: small-bites-brincando-com-o-jelastic-cloud-da-locaweb
tags:
- locaweb
- cloud-computing
draft: false
---

Se você participou da [Rubyconf Brasil em 2014](https://www.eventials.com/locaweb/groups/rubyconf-brasil-2014-by-locaweb-2/) teve a oportunidade de ver em primeira mão o lançamento do produto Jelastic Cloud, da Locaweb, na época com suporte beta a Ruby.

Ontem brinquei com o Jelastic com a ajuda do camarada [Kemel Zaidan](https://twitter.com/kemelzaidan), evangelista de tecnologia da Locaweb e colocamos o site do Call for Papers para a Rubyconf Brasil deste ano no ar por lá.

Como há alguns truques, resolvi fazer um pequeno post para dar uma idéia do que é possível fazer. Diferente de VPS ou similares, o Jelastic é um Platform as a Service (PaaS) que oferece tanto escalabilidade horizontal (mais servidores embaixo de um balanceador de carga) ou também escalabilidade vertical (mais recursos como memória e CPU mais rápido na mesma máquina). Além disso ele pré-configura quase tudo para que você não tenha que lidar com coisas como configurar o NGINX como proxy reverso para balancear carga ou configurar o PostgreSQL.

Criar uma conta trial é simples, você recebe sua senha por email e pode entrar no dashboard. De lá basta configurar a topologia da sua aplicação que te dá opção de escolher a tecnologia (Java, PHP, Ruby, Node.js, Python, .NET). No caso de Ruby você pode escolher direto a opção do [Raptor Beta](http://www.akitaonrails.com/2014/10/19/the-new-kid-on-the-block-for-ruby-servers-raptor#.VT97cs5Hlp8). Então pode configurar quantos cloudlets quer (pelo que entendi 1 cloudlet é uma unidade de processamento que representa 128Mb e 200Mhz e pode escalar verticalmente até 64 cloudlets ou 8GB e 12.80Ghz) por node. E horizontalmente você pode escolher ter até 18 nodes. Em termos de preço isso pode ir de até **R$15** por mês (lembrando que é pagamento por utilização e não preço fixo) até **R$10.179** na configuração máxima.

![Dashboard](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/488/Screen_Shot_2015-04-28_at_09.21.04.png)

Uma configuração média que deve servir pra grande maioria das aplicações pequenas/médias de 8 reserved cloudlet de 768Mb e 1.2GHZ, 2 nodes sob balanceamento, com 256MB de Memcached, 1Gb e 1.6Ghz de PostgreSQL (sempre deixe seu banco maior que sua máquina Web) dá em torno de R$ 280 por mês, ou o equivalente a USD 96, que eu achei até competitivo com alternativas internacionais (sim, é [controverso](http://meiobit.com/301551/receita-cobranca-impostos-empresas-usam-servicos-datacenters-exterior/) mas levar impostos em consideração).

## Dicas de Configuração

Você pode fazer o deployment diretamente de um repositório Github ou subir de um zip. Depois disso você pode entrar em qualquer das máquinas diretamente via SSH. Esse passo será necessário pois não há outra forma de configurar ambiente (especificamente variáveis de ambiente que é o correto para configurações). Entre via SSH e configure um arquivo <tt>.env</tt> com seus dados de produção usando a gem [<tt>dotenv-rails</tt>](http://www.akitaonrails.com/2013/10/19/iniciante-configuracoes-de-ambiente-com-dotenv#.VT9_ZM5Hlp8).

Uma coisa importante: se usar a configuração normal de banco de dados via <tt>config/database.yml</tt> vai ter problemas no caso do PostgreSQL pois parece que há diferença de versão entre o libpg nos nodes web com o PostgreSQL na máquina separada. Para bypassar isso, configure no arquivo <tt>.env</tt> uma variável chamada <tt>DATABASE_URL</tt> (que por padrão, bypassa o <tt>database.yml</tt> e conecta por TCP em vez de Unix Sockets). O formato dessa variável deve ser assim:

---
DATABASE_URL: 'postgres://[usuario]:[senha]@[host]:5432/[nome do banco]'
---

Ao criar o servidor PostgreSQL você também deve receber um email com um link para o PHPPGAdmin que é uma interface web para configurar o banco, você pode entrar por lá e criar um novo usuário (não use o usuário 'webadmin', obviamente). Outra opção é entrar via SSH direto no servidor de banco e usar comandos normais como <tt>createuser</tt> ou <tt>createdb</tt>. Não esqueça de adicionar sua chave pública de SSH na aba de configurações da aplicação, é simples.

O deployment automaticamente via colocar os arquivos da sua aplicação no lugar correto e já vai executar o <tt>bundle install</tt>. Mas depois do deployment você ainda vai precisar entrar via SSH no node NGINX para executar tasks como <tt>rake db:migrate</tt> e <tt>rake assets:precompile</tt>. Se estiver usando Memcache (com Rack::Cache, por exemplo), às vezes talvez precise entrar via SSH para acessar o <tt>rails console</tt> para poder zerar o cache via <tt>Rails.cache.clear</tt>. No meu caso, mesmo depois do deployment dizer que já rodou o Bundler ainda precisei entrar no diretório da aplicação e rodar <tt>bundle install</tt> manualmente. Nada de mais, mas vale lembrar disso.

Obs: O Kemel me avisou depois que publiquei o post que o Jelastic (que parece que usa a estrutura do OpenShift por trás) suporta um arquivo <tt>rake_deploy</tt> justamente para adicionar configurações pós-deployment que podem ser executados automaticamente sem precisar entrar por SSH toda vez. Veja [esta documentação](http://docs.jelastic.com/ruby-post-deploy-configuration).

Finalmente, se fez tudo certo, você já pode acessar sua aplicação pelo endereço <tt>[nome da app].jelasticlw.com</tt>. Daí você pode configurar a aplicação para aceitar um Custom Domain (domínio que você registrou) e no seu serviço de DNS (seja na própria Locaweb ou serviços como Zerigo, SimpleDNS) configurar o CNAME para apontar para o endereço Jelastic.

Não cheguei a testar mas o Jelastic também oferece opções como adicionar SSL e também Auto Scaling (escalabilidade horizontal), de tal maneira que se sua aplicação ultrapassar certas barreiras de consumo de CPU e/ou de Memória, ele automaticamente pode adicionar e remover nodes (você configura números máximos e mínimos de nodes). Assim você pode ficar despreocupado se seu site tiver picos inesperados de acesso e vai gastar apenas o que realmente precisa.

![Auto Scale](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/489/Screen_Shot_2015-04-28_at_09.48.23.png)

De pontos negativos, comparado ao que um PaaS de Ruby poderia ser, infelizmente ele não tem o conceito de buildpacks abertos, não tem como configurar um pipeline de deployment que já execute corretamente as Rake Tasks do Assets Precompile, Db:Migrate, etc. Não tem suporte a Procfile para subir o servidor de aplicação correto (recomendo já usar o Raptor direto). A escalabilidade vertical não ajuda tanto porque mesmo aumentando a capacidade da máquina, precisaríamos entrar via SSH para configurar a quantidade de worker processes de um Unicorn, por exemplo. E no meu teste, adicionar o balanceador de carga depois que já tinha um node deu problema (acho que precisa já deixar adicionar logo que cria a aplicação e não adicionar depois). Um último ponto importante: não há uma máquina para workers (background jobs), somente nodes web. Mesmo se precisar rodar cronjobs, ele vai rodar em concorrência com seu processo Web, o que é ruim para o tempo de resposta da aplicação web. Ainda não parei para ver se há outra forma (se alguém souber como, não deixe de colocar nos comentários).

De ponto positivo, a aplicação que coloquei no ar [funcionou](http://rubyconfbrcfp.com.br) (Hurray!), teve alguns caveats que mencionei acima, mas o importante é que no final ele realmente funcionou. Ainda é cedo pra dizer o comportamento (foi meu primeiro teste), mas vamos ver o que teremos no futuro. O Jelastic continua em evolução: a própria adição do Raptor é um sinal disso, o que é muito positivo.

## Conclusão

O Jelastic não é para completos iniciantes, para isso são planos de hospedagem compartilhada que já vem pré-configurados se você precisa subir um mero Wordpress ou Magento. Ele é para desenvolvedores com alguma experiência e que não deveriam estar responsabilizados pela infraestrutura do cliente. Configurar VPS não é difícil, mas a manutenção pode ser, especialmente se for necessário atualizar os recursos da máquina ou, principalmente, se for necessário configurar escalabilidade horizontal e recursos mais avançados como auto escalabilidade horizontal.

O custo do Jelastic é definitivamente maior que qualquer hospedagem compartilhada, porém é como comparar maçãs e bananas. Hospedagens compartilhadas são para coisas pequenas, de preferência sites completamente estáticos, que exigem quase nenhum processamento. Qualquer coisa maior que um pequeno blog vai sofrer. O único próximo passo que as hospedagens brasileiras ofereciam eram ou um Cloud Server (VPS) ou diretamente hardware bruto.

O Jelastic é o meio do caminho e da forma como está caminhando pode ser um ótimo meio do caminho que vale a pena ser explorado. O primeiro deployment pode ser meio doloroso até aprender o que é possível fazer, mas depois disso tudo fica menos complicado e definitivamente o custo-benefício entre manter um administrador de sistemas experiente full time na sua folha de pagamentos vai compensar algumas horas do seu desenvolvedor aprendendo a configurar a plataforma.

Num mundo onde ainda parece "normal" fazer deployment via FTP (protip: TOSCO!) e editar arquivos diretamente em produção, um produto como o Jelastic pode começar a ajudar a evangelizar conceitos mais corretos de deployment em produção.

Disclaimer: eu não sou da Locaweb e este post não é um marketing pago ou coisa do tipo. O Jelastic é um produto novo então muitos já devem ter enfrentado dores de cabeça. Se tiver experiências que possam ajudar outros desenvolvedores, não deixem de comentar abaixo.
