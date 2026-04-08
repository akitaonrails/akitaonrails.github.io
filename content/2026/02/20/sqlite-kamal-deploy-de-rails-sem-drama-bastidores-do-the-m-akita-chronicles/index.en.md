---
title: "SQLite + Kamal: Rails Deploy Without Drama | Behind The M.Akita Chronicles"
slug: "sqlite-kamal-rails-deploy-without-drama-behind-the-m-akita-chronicles"
date: 2026-02-20T03:18:55+00:00
draft: false
tags:
- sqlite
- kamel
- rubyonrails
- themakitachronicles
  - AI
translationKey: sqlite-kamal-rails-deploy
description: "How Rails 8 with SQLite and Kamal lets you run a full production app on a $12/month VPS with zero external services."
---

This post is part of a series; follow along via the tag [/themakitachronicles](/tags/themakitachronicles). This is part 7.

And make sure to subscribe to my new newsletter [The M.Akita Chronicles](https://themakitachronicles.com/)!

--

If I told you that you can run a full Rails application in production — with database, job queue, cache — on a single $12/month VPS without installing PostgreSQL, Redis, or any other external service, would you believe me?

Well, you can. That's Rails 8 with SQLite and Kamal.

## SQLite on Rails 8: now it's for real

Rails 8 brought SQLite as a real production option, not as a development toy. And when I say "real", I mean `rails new` generates everything ready to go: main database in SQLite, SolidQueue (jobs) in SQLite, SolidCache (cache) in SQLite, SolidCable (WebSocket) in SQLite.

**Four services that used to require PostgreSQL + Redis + Memcached are now `.sqlite3` files on disk.**

WAL mode (Write-Ahead Logging) enables concurrent reads while a write is happening. For applications with tens of thousands of requests per day — which is the vast majority of Rails applications in the world — SQLite is more than enough. And read latency is measured in **microseconds**, not milliseconds. It's local disk access, not a network round-trip.

```yaml
# database.yml — production with SQLite
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

Three files. No TCP connection. No pooling. No "is PostgreSQL accepting connections?". Backup is a `VACUUM INTO` and that's it — a single SQL command that produces an atomic copy. Restore? Paste the file back. Try doing that with a 2GB PostgreSQL dump.

## Kamal: Docker Deploy Without Kubernetes

Kamal is the Rails 8 deployer. Think of it as "SSH + Docker, but smart". No Kubernetes. No Helm charts. No 300-line YAML describing an Ingress Controller.

The entire configuration fits in one file:

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

What Kamal does when you run `kamal deploy`:

1. Builds the Docker image locally (or in CI)
2. Pushes to the registry
3. SSHs into the server
4. Pulls the new image
5. Runs migrations
6. Restarts the container with **zero downtime** via kamal-proxy

The kamal-proxy is the secret: it acts as a reverse proxy in front of your containers. When the deploy happens, it brings up the new container, waits for it to be healthy, redirects traffic, and then tears down the old one. Your users never notice a thing.

## Docker Volumes: The Secret of SQLite in Production

The critical point of SQLite in Docker is: **the data can't die with the container**. Docker volumes solve this:

```yaml
volumes:
  - minha-app-storage:/rails/storage
```

The `storage/` directory contains all the SQLite databases. With the Docker volume, they persist across deploys. The container is ephemeral; the data is permanent.

But there's a detail that trips up a lot of people: if you run **two different services** that share data through files (not database), you need a shared volume:

```yaml
# Service A writes content
volumes:
  - content-compartilhado:/rails/content

# Service B reads content
volumes:
  - content-compartilhado:/rails/content
```

The same Docker volume mounted on two containers. Simple, it works, and you don't need NFS, S3, or anything fancy. It's a directory on the server's disk.

## Multiple Services on the Same VPS

A rarely discussed advantage of Kamal: you can run **multiple applications** on the same server. The kamal-proxy routes by hostname:

```
app.meudominio.com    → container-app
bot.meudominio.com    → container-bot
```

Each service has its own `deploy.yml`, its own Docker image, its own deploy cycle. But they all run on the same VPS, sharing the same Docker network for internal communication.

SSL is automatic via Let's Encrypt — kamal-proxy handles that. Each hostname gets its certificate without you configuring anything.

## Hooks: Deploy Automation

Kamal supports hooks at various points of the deploy cycle. The most useful is `pre-deploy`, which runs **before** the new container replaces the old one:

```ruby
# .kamal/hooks/pre-deploy
#!/bin/sh
# Run migrations before the container goes live
ssh root@$KAMAL_HOSTS \
  "docker exec minha-app-web bin/rails db:migrate"
```

Other useful hooks:

- `post-deploy` — notify the team, clear cache
- `pre-connect` — check server health
- `docker-setup` — install dependencies on the host

## The Dockerfile Rails Generates

Rails 8 generates an optimized production Dockerfile. Some highlights:

```dockerfile
# Multi-stage build: large build stage, minimal runtime stage
FROM ruby:3.3-slim AS base

# Install only runtime dependencies
RUN apt-get install -y libsqlite3-0

FROM base AS build
# Here install everything to compile native gems
RUN apt-get install -y build-essential libsqlite3-dev

# Copy and install gems
COPY Gemfile* ./
RUN bundle install --without development test

# Final stage: only what's needed to run
FROM base
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY . .
RUN bundle exec bootsnap precompile --gemfile app/ lib/
```

Multi-stage build means the final image has no compilers, no development headers, nothing unnecessary. The production image stays lean.

## Secrets: No .env in Production

Kamal has a secrets system that reads from a local file (`.kamal/secrets`) and injects them as environment variables into the container. That file **never** goes to git:

```bash
# .kamal/secrets (gitignored)
RAILS_MASTER_KEY=abc123...
AWS_ACCESS_KEY_ID=AKIA...
```

In `deploy.yml`, you reference:

```yaml
env:
  secret:
    - RAILS_MASTER_KEY
    - AWS_ACCESS_KEY_ID
```

Kamal reads from the local file and configures it on the server. Simple, secure, no HashiCorp Vault or AWS Secrets Manager (unless you want — Kamal supports adapters).

## SQLite Backup: Absurdly Simple (If You Do It Right)

Want a backup? One SQL command:

```sql
VACUUM INTO '/tmp/backup/newsletter.sqlite3';
```

`VACUUM INTO` is **atomic** — it produces a consistent, defragmented copy of the database, even with writes happening. It runs while the application is serving requests normally. And the resulting copy is a complete, functional SQLite database — you can open it, query it, restore it.

**Warning**: copying the `.sqlite3` file directly (`cp`, `tar`, `rsync`) from a database in use **can corrupt the backup**. If a write is in progress at the moment of the copy, you end up with a half-written file. SQLite has WAL (Write-Ahead Log) and journaling that protect the active database — but the raw copy doesn't inherit that protection.

In practice, I automated this with a Rails job that runs every hour:

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

The backup goes to the shared content directory — the same one that's already synced with `rsync` to my local machine. No extra backup agent, no external service, no volume snapshot. One SQL, one file, one `rsync`.

Compare that with `pg_dump` of a production PostgreSQL database with dozens of tables and constraints. The SQLite backup is **one command that produces a working file**. Restore? Copy it back and restart.

## When NOT to Use SQLite

I'll be honest: SQLite isn't for everything.

- **Multiple web servers** writing to the same database? No. SQLite is single-writer. If you need horizontal scaling with multiple nodes, go PostgreSQL.
- **Massive datasets** (hundreds of GB)? PostgreSQL has better query planning and parallelism.
- **Replication and high availability**? PostgreSQL with streaming replication.

But the honest question is: **how many applications really need that?** The vast majority run on a single server and will never need more. And for those, SQLite + Kamal is the most productive combination out there today.

## The Real Cost

Let's do the math:

| Component | Before | Now |
|-----------|-------|-------|
| Server | VPS $24/month | VPS $12/month |
| Database | RDS PostgreSQL $30/month | SQLite (included) |
| Redis | ElastiCache $15/month | SolidQueue (included) |
| Cache | ElastiCache $15/month | SolidCache (included) |
| Deploy | Complex CI/CD | `kamal deploy` |
| SSL | Certbot + cron | Automatic |
| **Total** | **~$84/month + headache** | **$12/month** |

And the cognitive cost? Instead of debugging "why did Redis lose my jobs?", "why is PostgreSQL rejecting connections?", "why did the cert expire?", you focus on what matters: **the product**.

## Conclusion

SQLite + Kamal is not a downgrade. The truth is that most applications never needed the complexity we thought they needed. Rails 8 embraced that and delivered a deploy experience that is, without exaggeration, the simplest that ever existed in the Ruby ecosystem.

One VPS. One command. Zero external services. And an application that runs as fast as any enterprise setup with 15 services in docker-compose.
