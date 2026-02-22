---
title: "SQLite + Kamal: Deploy de Rails sem Drama | Bastidores do The M.Akita Chronicles"
slug: "sqlite-kamal-deploy-de-rails-sem-drama-bastidores-do-the-m-akita-chronicles"
date: 2026-02-20T03:18:55+00:00
draft: false
tags:
- sqlite
- kamel
- rubyonrails
- themakitachronicles
---

Este post vai fazer parte de uma série; acompanhe pela tag [/themakitachronicles](/tags/themakitachronicles). Esta é a parte 7.

E não deixe de assinar minha nova newsletter [The M.Akita Chronicles](https://themakitachronicles.com/)!

--

Se eu te dissesse que dá pra rodar uma aplicação Rails completa em produção — com banco de dados, fila de jobs, cache — num único VPS de $12/mês sem instalar PostgreSQL, Redis, ou qualquer outro serviço externo, você acreditaria?

Pois é. Esse é o Rails 8 com SQLite e Kamal.

## SQLite no Rails 8: agora é pra valer

O Rails 8 trouxe o SQLite como opção real de produção, não como brinquedo de desenvolvimento. E quando digo "real", quero dizer que o `rails new` gera tudo pronto: banco principal em SQLite, SolidQueue (jobs) em SQLite, SolidCache (cache) em SQLite, SolidCable (WebSocket) em SQLite.

**Quatro serviços que antes precisavam de PostgreSQL + Redis + Memcached agora são arquivos `.sqlite3` no disco.**

O WAL mode (Write-Ahead Logging) habilita leituras concorrentes enquanto uma escrita acontece. Pra aplicações com dezenas de milhares de requisições por dia — que é a imensa maioria das aplicações Rails no mundo — SQLite é mais que suficiente. E a latência de leitura é medida em **microsegundos**, não milissegundos. É acesso a disco local, não round-trip de rede.

```yaml
# database.yml — produção com SQLite
production:
  primary:
    <<: *default
    database: storage/production.sqlite3
  queue:
    <<: *default
    database: storage/production_queue.sqlite3
    migrations_paths: db/queue_migrate
  cache:
    <<: *default
    database: storage/production_cache.sqlite3
    migrations_paths: db/cache_migrate
```

Três arquivos. Sem conexão TCP. Sem pooling. Sem "o PostgreSQL tá aceitando conexões?". Backup é um `VACUUM INTO` e pronto — um comando SQL que produz uma cópia atômica. Restore? Cola o arquivo de volta. Tenta fazer isso com um dump de PostgreSQL de 2GB.

## Kamal: Docker Deploy Sem Kubernetes

O Kamal é o deployer do Rails 8. Pensa nele como "SSH + Docker, mas inteligente". Sem Kubernetes. Sem Helm charts. Sem YAML de 300 linhas descrevendo um Ingress Controller.

A configuração inteira cabe em um arquivo:

```yaml
# config/deploy.yml
service: minha-app
image: meuregistry/minha-app

servers:
  web:
    hosts:
      - 107.170.70.49
    options:
      network: minha-network
    volumes:
      - minha-app-storage:/rails/storage
      - minha-app-content:/rails/content

proxy:
  ssl: true
  host: app.meudominio.com

builder:
  arch: amd64

env:
  clear:
    RAILS_LOG_LEVEL: info
  secret:
    - RAILS_MASTER_KEY
    - DATABASE_URL
```

O que o Kamal faz quando você roda `kamal deploy`:

1. Builda a imagem Docker localmente (ou em CI)
2. Pusha pro registry
3. SSH no servidor
4. Puxa a nova imagem
5. Roda migrations
6. Reinicia o container com **zero downtime** via kamal-proxy

O kamal-proxy é o segredo: ele funciona como reverse proxy na frente dos seus containers. Quando o deploy acontece, ele sobe o novo container, espera ele ficar healthy, redireciona o tráfego, e depois derruba o antigo. Seus usuários não percebem nada.

## Volumes Docker: O Segredo do SQLite em Produção

O ponto crítico de SQLite em Docker é: **os dados não podem morrer com o container**. Docker volumes resolvem isso:

```yaml
volumes:
  - minha-app-storage:/rails/storage
```

O diretório `storage/` contém todos os bancos SQLite. Com o volume Docker, eles persistem entre deploys. O container é efêmero; os dados são permanentes.

Mas tem um detalhe que pega muita gente: se você roda **dois serviços** diferentes que compartilham dados via arquivos (não banco), precisa de um volume compartilhado:

```yaml
# Serviço A escreve conteúdo
volumes:
  - content-compartilhado:/rails/content

# Serviço B lê conteúdo
volumes:
  - content-compartilhado:/rails/content
```

O mesmo volume Docker montado em dois containers. Simples, funciona, e não precisa de NFS, S3, ou qualquer coisa sofisticada. É um diretório no disco do servidor.

## Múltiplos Serviços no Mesmo VPS

Uma vantagem pouco discutida do Kamal: você pode rodar **múltiplas aplicações** no mesmo servidor. O kamal-proxy roteia por hostname:

```
app.meudominio.com    → container-app
bot.meudominio.com    → container-bot
```

Cada serviço tem seu próprio `deploy.yml`, sua própria imagem Docker, seu próprio ciclo de deploy. Mas todos rodam no mesmo VPS, compartilhando a mesma rede Docker para comunicação interna.

O SSL é automático via Let's Encrypt — o kamal-proxy cuida disso. Cada hostname ganha seu certificado sem você configurar nada.

## Hooks: Automação no Deploy

O Kamal suporta hooks em vários pontos do ciclo de deploy. O mais útil é o `pre-deploy`, que roda **antes** do container novo substituir o antigo:

```ruby
# .kamal/hooks/pre-deploy
#!/bin/sh
# Roda migrations antes do container ficar ativo
ssh root@$KAMAL_HOSTS \
  "docker exec minha-app-web bin/rails db:migrate"
```

Outros hooks úteis:

- `post-deploy` — notificar equipe, limpar cache
- `pre-connect` — verificar saúde do servidor
- `docker-setup` — instalar dependências no host

## O Dockerfile que o Rails Gera

O Rails 8 gera um Dockerfile otimizado de produção. Alguns destaques:

```dockerfile
# Multi-stage build: build stage grande, runtime stage mínima
FROM ruby:3.3-slim AS base

# Instala apenas dependências de runtime
RUN apt-get install -y libsqlite3-0

FROM base AS build
# Aqui instala tudo pra compilar gems nativas
RUN apt-get install -y build-essential libsqlite3-dev

# Copia e instala gems
COPY Gemfile* ./
RUN bundle install --without development test

# Stage final: só o necessário pra rodar
FROM base
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY . .
RUN bundle exec bootsnap precompile --gemfile app/ lib/
```

Multi-stage build significa que a imagem final não tem compiladores, headers de desenvolvimento, ou qualquer coisa desnecessária. A imagem de produção fica enxuta.

## Secrets: Sem .env em Produção

O Kamal tem um sistema de secrets que lê de um arquivo local (`.kamal/secrets`) e injeta como variáveis de ambiente no container. Esse arquivo **nunca** vai pro git:

```bash
# .kamal/secrets (gitignored)
RAILS_MASTER_KEY=abc123...
AWS_ACCESS_KEY_ID=AKIA...
```

No `deploy.yml`, você referencia:

```yaml
env:
  secret:
    - RAILS_MASTER_KEY
    - AWS_ACCESS_KEY_ID
```

O Kamal lê do arquivo local e configura no servidor. Simples, seguro, sem HashiCorp Vault ou AWS Secrets Manager (a menos que você queira — Kamal suporta adaptadores).

## Backup de SQLite: Absurdamente Simples (Se Fizer Certo)

Quer backup? Um comando SQL:

```sql
VACUUM INTO '/tmp/backup/newsletter.sqlite3';
```

O `VACUUM INTO` é **atômico** — produz uma cópia consistente e desfragmentada do banco, mesmo com escritas acontecendo. Roda enquanto a aplicação está servindo requests normalmente. E a cópia resultante é um banco SQLite completo e funcional — abre, consulta, restaura.

**Atenção**: copiar o arquivo `.sqlite3` diretamente (`cp`, `tar`, `rsync`) de um banco em uso **pode corromper o backup**. Se uma escrita estiver em andamento no momento da cópia, você fica com um arquivo meio-escrito. O SQLite tem WAL (Write-Ahead Log) e journaling que protegem o banco ativo — mas a cópia crua não herda essa proteção.

Na prática, automatizei isso com um job Rails que roda a cada hora:

```ruby
class BackupDatabaseJob < ApplicationJob
  def perform
    backup_dir = File.join(Rails.configuration.content_dir, "backups")
    FileUtils.mkdir_p(backup_dir)
    dest = File.join(backup_dir, "newsletter.sqlite3")
    ActiveRecord::Base.connection.execute("VACUUM INTO '#{dest}'")
  end
end
```

O backup vai pro diretório compartilhado de conteúdo — o mesmo que já é sincronizado com `rsync` pra máquina local. Sem agente de backup extra, sem serviço externo, sem snapshot de volume. Um SQL, um arquivo, um `rsync`.

Compara isso com `pg_dump` de um banco PostgreSQL de produção com dezenas de tabelas e constraints. O SQLite backup é **um comando que produz um arquivo funcional**. Restaurar? Copia de volta e reinicia.

## Quando NÃO Usar SQLite

Vou ser honesto: SQLite não é pra tudo.

- **Múltiplos servidores web** escrevendo no mesmo banco? Não. SQLite é single-writer. Se você precisa de horizontal scaling com múltiplos nós, vai de PostgreSQL.
- **Datasets massivos** (centenas de GB)? PostgreSQL tem melhor query planning e paralelismo.
- **Replicação e alta disponibilidade**? PostgreSQL com streaming replication.

Mas a pergunta honesta é: **quantas aplicações realmente precisam disso?** A vasta maioria roda num único servidor e nunca vai precisar de mais. E pra essas, SQLite + Kamal é a combinação mais produtiva que existe hoje.

## O Custo Real

Vamos fazer a conta:

| Componente | Antes | Agora |
|-----------|-------|-------|
| Servidor | VPS $24/mês | VPS $12/mês |
| Banco | RDS PostgreSQL $30/mês | SQLite (incluso) |
| Redis | ElastiCache $15/mês | SolidQueue (incluso) |
| Cache | ElastiCache $15/mês | SolidCache (incluso) |
| Deploy | CI/CD complexo | `kamal deploy` |
| SSL | Certbot + cron | Automático |
| **Total** | **~$84/mês + dor de cabeça** | **$12/mês** |

E o custo cognitivo? Ao invés de debugar "por que o Redis perdeu meus jobs?", "por que o PostgreSQL tá rejeitando conexões?", "por que o cert expirou?", você foca no que importa: **o produto**.

## Conclusão

SQLite + Kamal não é downgrade. É que a maioria das aplicações nunca precisou da complexidade que a gente achava que precisava. O Rails 8 abraçou isso e entregou uma experiência de deploy que é, sem exagero, a mais simples que já existiu no ecossistema Ruby.

Um VPS. Um comando. Zero serviços externos. E uma aplicação que roda tão rápido quanto qualquer setup enterprise com 15 serviços no docker-compose.
