---
title: "[Heroku Tips] Problemas iniciais com Rails 4 no Heroku"
date: '2013-09-11T17:25:00-03:00'
slug: heroku-tips-problemas-iniciais-com-rails-4-no-heroku
tags:
- learning
- rails
- heroku
draft: false
---

Se ainda não leu, dê uma olhada sobre o que já postei como [dicas de Heroku](http://www.akitaonrails.com/2012/04/20/heroku-tips-enciclopedia-do-heroku) e [minha opinião sobre o serviço](http://www.akitaonrails.com/2013/05/02/opcoes-de-hospedagem-rails-heroku#.Ui81gWRgZ3Y).

Recentemente tentei subir um projeto Rails 4 bem simples no Heroku e encontrei problemas logo na primeira tentativa de deploy. O problema é o seguinte: a forma mais aceita de configurar uma aplicação é usar variáveis de ambiente ([veja projetos como o dotenv-rails](https://github.com/bkeepers/dotenv)). No primeiro deploy essas variáveis não estão disponíveis, em particular o <tt>DATABASE_URL</tt>. Na task <tt>assets:precompile</tt> não deveria haver nada na inicialização que dependesse de conexão ao banco, mas algumas gems ainda não estão corrigidas dessa forma, em particular duas com esse bug já conhecido são o [active_admin](https://github.com/gregbell/active_admin/issues/2342#issuecomment-23109359) e o acts-as-taggable-on.

No final, a forma mais simples para resolver isso por enquanto é fazer o seguinte antes do primeiro deploy:

```
heroku labs:enable user-env-compile
heroku config:add DATABASE_URL=$(heroku config | awk '/HEROKU_POSTGRESQL.*:/ {print $2}')
```

Leia a documentação dessa funcionalidade [user-env-compile](https://devcenter.heroku.com/articles/labs-user-env-compile) entendendo que ela não é a forma mais correta, é apenas um facilitador enquanto todas as gems não estão da forma correta.

## Rails 12 Factor

Rapidamente para não esquecer, no caso de apps Rails 4 não deixe de acrescentar o seguinte na sua <tt>Gemfile</tt>:

```ruby
gem 'rails_12factor', group: :production
```

Em particular é importante para logging correto e servir assets estáticos, veja no [Github deles](https://github.com/heroku/rails_12factor) para mais informações.

## Migração de MySQL para PostgreSQL

Outro assunto que deve ser constante quando se considera mudar pra Heroku é ter que usar o Heroku Postgres (que é uma ótima opção). Mas muitos projetos, principalmente mais antigos, devem ter começado em MySQL.

A primeira coisa a fazer é verificar se você tem muitos SQL exclusivos de MySQL, funções e coisas do tipo. Se você usar ActiveRecord Relations padrão, não deveria ter nenhum problema.

O segundo problema é migrar os dados de um banco para o outro. Eu procurei várias opções mas a maioria é antiga e não funciona direito, a melhorzinha que achei foi uma task Rake. Ela tinha alguns probleminhas de usar API deprecada mas resolvi neste aqui:

<script src="https://gist.github.com/akitaonrails/6529088.js"></script>

Basta alterar seu <tt>config/database.yml</tt> para ter o seguinte:

```yaml
development:
  adapter: postgresql
  database: legaltorrents_development
  username: fred
  password: password
  host: localhost

production:
  adapter: mysql
  database: legaltorrents_production
  username: fred
  password: password
```

Coloca o script como <tt>lib/tasks/convert.rake</tt> e executa <tt>rake db:convert:prod2dev</tt>.

Depois disso ainda precisa atualizar as sequences de primary key do PostgreSQL desta forma:

```
ALTER SEQUENCE users_id_seq restart with (select max(id)+1 from users) 
```

Isso deve ser feito para cada tabela que você tem. Se precisar atualizar em produção no Heroku, execute <tt>heroku run rails console</tt> e execute assim:

```ruby
ActiveRecord::Base.connection.execute("ALTER SEQUENCE users_id_seq restart with (select max(id)+1 from users) ")
```

Não esqueça que você pode fazer dumps do banco de dados de produção, colocar num banco de dados local para testar e tudo mais e se quiser pode gerar um dump local e restaurar de novo no Heroku. Leia a documentação deles sobre [PG Backups](https://devcenter.heroku.com/articles/heroku-postgres-import-export).

Gerar um dump local é simples:

```
pg_dump -Fc --no-acl --no-owner -h localhost -U vagrant my_db > mydb.dump
```

E restaurar um dump do Heroku no seu banco local também:

```
pg_restore --verbose --clean --no-acl --no-owner -h localhost -U vagrant -d my_db b078.dump
```

Isso deve resolver a maioria dos problemas.
