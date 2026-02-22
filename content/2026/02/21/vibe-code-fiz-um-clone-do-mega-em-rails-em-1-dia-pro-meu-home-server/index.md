---
title: "Vibe Code: Fiz um clone do Mega em Rails em 1 dia pro meu Home Server"
slug: "vibe-code-fiz-um-clone-do-mega-em-rails-em-1-dia-pro-meu-home-server"
date: 2026-02-21T18:48:25+00:00
draft: false
tags: ["rails", "ruby", "docker", "cloudflare", "security", "vibe-coding", "homeserver", "claude"]
---

Faz tempo que eu queria ter um serviço de file sharing privado no meu home server. Sabe quando precisa mandar um arquivo grande pra alguém? "Ah, usa o Google Drive". Não. "WeTransfer?" Também não. Eu quero controle total. Quero saber onde meus arquivos estão, por quanto tempo existem, quem baixou, e não quero depender de serviço de terceiro pra algo tão simples.

Então fiz o que qualquer programador faria: sentei, escrevi um documento de especificação, e com ajuda do Claude Code (Claude Opus 4.6), construí o [**FrankMega**](https://github.com/akitaonrails/FrankMega), um clone simplificado do Mega, self-hosted, em Rails 8, em um único dia de trabalho. 21 commits, 3 horas de desenvolvimento ativo, 210 testes, zero dependência externa além do SQLite.

![frankmega](https://github.com/akitaonrails/FrankMega/raw/master/docs/upload_screen.png)

E antes que apareça o esperto nos comentários: "ah, mas Vibe Coding é só prompt engineering, qualquer um faz" -- calma. Esse post é justamente pra mostrar que **não é**.

## Da Ideia ao Código: o IDEA.md

Todo projeto começa com um documento. O meu foi o [`docs/IDEA.md`](https://github.com/akitaonrails/FrankMega/blob/master/docs/IDEA.md) -- 56 linhas descrevendo o que eu queria:

- Upload de arquivo único, com link compartilhável
- Contador de downloads (padrão 5, configurável)
- Expiração automática em até 24 horas
- Autenticação completa: senha + 2FA + passkeys
- Sem página de registro público -- convites only
- Admin cria convites, gerencia usuários, bane abusadores
- Rate limiting agressivo, IP banning automático
- Deploy via Docker + Cloudflare Tunnel no meu home server
- Stack: Rails 8, SQLite, Tailwind CSS, Hotwire/Stimulus

Eu deliberadamente incluí no final: *"Sugira features importantes que possam ser relevantes pra um serviço assim."* Porque eu sei que um documento de spec nunca cobre tudo. E é aí que começa a parte interessante.

## O Big Bang: Commit #1

O primeiro commit (`e277226`) às 12:17 entregou **207 arquivos, 6.901 linhas de código**. Num único commit. Sim, eu sei que é controverso, mas quando se está construindo do zero com AI, o primeiro commit é necessariamente grande.

O que veio nesse commit inicial:

- Autenticação completa com `has_secure_password` (bcrypt), TOTP via `rotp`, passkeys via `webauthn`
- Sistema de convites com códigos únicos e expiração
- Admin panel completo (Users, Invitations, Files, MIME Types)
- Upload com Active Storage + drag-and-drop via Stimulus
- Links de download com hashes de 24 bytes (`SecureRandom.urlsafe_base64(24)`)
- Rate limiting via Rack::Attack em todos os endpoints públicos
- IP banning automático com modelo `Ban` e job assíncrono
- Tema dark/light com Tailwind CSS inspirado no Mega.nz
- 73 testes (Minitest + FactoryBot)
- Docker configuration com Puma + Thruster
- Solid Queue/Cache/Cable -- zero Redis

Entenderam? **Tudo isso no commit #1**. O IDEA.md virou código funcional numa tacada. Mas o ponto é esse: **o primeiro commit não era production-ready**. Nem de longe.

![tema light](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-21_15-32-29.png)

## A Realidade: 20 Commits de Iteração

Depois do Big Bang vieram 20 commits ao longo de 3 horas. E é aqui que mora a verdade sobre desenvolvimento de software que nenhum tutorial de "Vibe Coding" vai te contar.

### Fase 1: "Funciona na minha máquina" (12:40 - 12:46)

Quatro commits em 6 minutos. Sabe o que aconteceu? Fui buildar o Docker e **quebrou**. Faltava `libssl-dev`. Consertei. Daí o CSP (Content Security Policy) do `secure_headers` conflitava com os inline scripts do importmap do Rails. Consertei. Mudei a porta de 3000 pra 3100 pra não conflitar com outros serviços no meu server.

Olha o commit `389ebe8`:

```ruby
# CSP agora é feito pelo Rails built-in, não pelo secure_headers
# Porque secure_headers não suporta nonces pra importmap inline scripts
config.csp = SecureHeaders::OPT_OUT
```

Esse tipo de incompatibilidade entre gems você só descobre na hora. Nenhum LLM vai te avisar disso de antemão porque é uma combinação específica de versões.

### Fase 2: O Commit de Segurança -- 22 Falhas Corrigidas (13:10)

Esse é o commit mais importante do projeto inteiro: `4a854a6`. 35 arquivos, 612 linhas, 22 issues de segurança corrigidas. Vou detalhar porque é aqui que se separa código de brinquedo de código de produção.

O que o commit inicial fazia de errado:

**CRÍTICO -- Chaves de criptografia com fallback hardcoded:**

```ruby
# ANTES (perigoso):
config.active_record.encryption.primary_key = ENV.fetch("KEY", "test-primary-key")

# DEPOIS (fail-fast):
if Rails.env.production?
  config.active_record.encryption.primary_key = ENV.fetch("ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY")
end
```

Se o ENV var não existisse em produção, a app rodava feliz com a chave hardcoded. Qualquer pessoa que lesse o código-fonte conseguiria decriptar os segredos OTP de todos os usuários. Agora em produção, se faltar a variável, a app **crasheia no boot**. É o comportamento correto.

**CRÍTICO -- Replay Attack no OTP:**

```ruby
# ANTES:
def verify_otp(code)
  totp = ROTP::TOTP.new(otp_secret)
  totp.verify(code, drift_behind: 30, drift_ahead: 30).present?
end

# DEPOIS:
def verify_otp(code)
  totp = ROTP::TOTP.new(otp_secret)
  timestamp = totp.verify(code, drift_behind: 30, drift_ahead: 30)
  return false unless timestamp

  # Previne replay: rejeita se o timestamp desse código já foi usado
  if last_otp_at.present? && Time.at(timestamp) <= last_otp_at
    return false
  end

  update_column(:last_otp_at, Time.at(timestamp))
  true
end
```

Todo tutorial de TOTP que você encontra na internet mostra o `verify(code).present?` e para aí. O problema: um código TOTP é válido por 30 segundos. Se eu interceptar seu código (shoulder surfing, câmera, clipboard), posso usá-lo múltiplas vezes nessa janela. O `last_otp_at` garante one-time use real.

**ALTO -- Race Condition no Download Counter:**

```ruby
# ANTES (race condition):
def increment_download!
  increment!(:download_count)
end

# DEPOIS (atômico):
def increment_download!
  self.class.where(id: id)
      .where("download_count < max_downloads")
      .where("expires_at > ?", Time.current)
      .update_all("download_count = download_count + 1") == 1
end
```

O `increment!` faz: (1) lê o valor, (2) soma 1 em Ruby, (3) escreve de volta. Duas requisições simultâneas podem ler `4`, ambas escreverem `5`, e o usuário ganha dois downloads quando só tinha um. O `UPDATE ... WHERE` atômico no SQL garante que só uma requisição vence. E o `== 1` retorna sucesso/falha numa única operação, sem lock.

Isso é o clássico bug TOCTOU (Time of Check, Time of Use). Você nunca vai ver isso no desenvolvimento local com um browser. Só aparece em produção com requisições concorrentes.

**ALTO -- Open Redirect após login:**

```ruby
# DEPOIS:
def safe_redirect_url?(url)
  uri = URI.parse(url)
  uri.host.nil? || uri.host == request.host
rescue URI::InvalidURIError
  false
end
```

Sem isso, um atacante podia enviar um link tipo `frankmega.com/session?return_to=https://evil.com` e após login o usuário seria redirecionado pro site malicioso.

**MÉDIO -- Nonce do CSP previsível:**

```ruby
# ANTES:
config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }

# DEPOIS:
config.content_security_policy_nonce_generator = ->(_request) { SecureRandom.base64(16) }
```

Session ID não muda entre requests. Se o nonce é previsível, um atacante pode injetar scripts com o nonce correto. Tem que ser aleatório por request.

E mais: IPv6 do Cloudflare adicionado aos trusted proxies, mínimo de 12 caracteres pra senha, MIME detection server-side via Marcel, verificação de file size pelo tempfile (não pelo header do client que pode ser forjado), proteção contra deletar/banir/rebaixar o último admin.

O total de testes pulou de 73 pra 109 com esse único commit.

## Como Rails Facilita Segurança

Rails torna MUITO mais fácil implementar segurança do que fazer do zero. Olha a comparação:

| Feature | Rails | Do zero |
|---------|-------|---------|
| CSRF | Automático no `ActionController::Base` | Implementar tokens por sessão em todos os forms |
| Hash de senha | `has_secure_password` (1 linha) | Escolher algoritmo, salt, implementar verificação |
| Parâmetros filtrados | `config.filter_parameters` | Hook no sistema de logging |
| Strong params | `params.require().permit()` | Middleware de whitelist manual |
| Criptografia de campos | `encrypts :otp_secret` (1 linha) | Envelope encryption, key rotation, decrypt transparente |
| CSP com nonces | Config de 1 bloco | Gerar nonces, injetar nos tags HTML, setar headers |
| Rate limiting (Rails 8) | `rate_limit to: 10, within: 3.minutes` | Storage de contadores, lógica de sliding window |
| SQL injection | Parameterized queries by default | Parametrizar manualmente cada query |

O Rails 8 em particular trouxe o `rate_limit` built-in no controller:

```ruby
class SessionsController < ApplicationController
  rate_limit to: 10, within: 3.minutes, only: :create,
    with: -> { redirect_to new_session_path, alert: t("flash.sessions.create.rate_limit") }
end
```

E a autenticação? Rails 8 agora vem com um **authentication generator** built-in. Não precisa mais do Devise pra coisas básicas. O `app/controllers/concerns/authentication.rb` do FrankMega é baseado nisso e estende com 2FA, passkeys e invitation-only registration.

## File Sharing Não É Só Download

Uma coisa que muita gente não percebe: um serviço de file sharing tem uma superfície de ataque enorme. Não é só "salvar arquivo, gerar link". Olha tudo que precisa ser considerado:

### Sanitização de Filename

```ruby
def sanitize_filename(name, content_type = nil)
  sanitized = File.basename(name.to_s)                          # Strip path traversal
  sanitized = sanitized.encode("UTF-8", invalid: :replace,      # Handle invalid UTF-8
                                undef: :replace, replace: "")
  sanitized = sanitized.gsub(/[\x00-\x1f\x7f\/\\:*?"<>|]/, "") # Control chars + unsafe chars
  sanitized = sanitized.sub(/\A\.+/, "")                        # Leading dots (hidden files)
  sanitized = sanitized.gsub(/\s+/, " ").strip                  # Collapse whitespace

  # Windows reserved device names
  base_without_ext = sanitized.sub(/\.[^.]*\z/, "")
  if base_without_ext.match?(/\A(CON|PRN|AUX|NUL|COM[1-9]|LPT[1-9])\z/i)
    sanitized = "_#{sanitized}"
  end

  sanitized = strip_extension_junk(sanitized, content_type)
  sanitized = truncate_filename(sanitized, 255)
  sanitized.presence || "unnamed_file"
end
```

Cada linha existe por um motivo:
- `File.basename` impede path traversal (`../../etc/passwd` vira `passwd`)
- Strip de control chars impede null byte injection e terminal escape injection
- Nomes reservados do Windows (CON, NUL, AUX, LPT1-9) causam problemas se o storage for acessado de um Windows
- Truncamento pra 255 bytes (não caracteres!) preservando a extensão -- um emoji de 4 bytes conta como 4 pro limite do ext4/NTFS
- `strip_extension_junk` trata nomes que vêm de URLs com parâmetros grudados: `photo.jpg_1280x720+quality=80` vira `photo.jpg`

E isso é server-side. Tem validação client-side também no Stimulus controller pra rejeitar antes do upload:

```javascript
isInvalidFilename(name) {
  if (new Blob([name]).size > 255) return true
  if (/[\x00-\x1f\x7f/:*?"<>|\\]/.test(name)) return true
  return false
}
```

### MIME Type Detection Server-Side

```ruby
@shared_file.content_type = Marcel::MimeType.for(uploaded.tempfile, name: uploaded.original_filename)
@shared_file.file_size = uploaded.tempfile.size
```

Não confia no `Content-Type` que o browser envia. O Marcel inspeciona os magic bytes do arquivo pra determinar o tipo real. E o file size vem do tempfile no disco, não do header `Content-Length` que pode ser forjado.

### Quotas e Disk Usage

![quota](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-21_16-00-52.png)

Cada usuário tem uma quota de disco (5 GB default, admin pode customizar):

```ruby
def can_upload?(file_size)
  grace = Rails.application.config.x.security.disk_quota_grace_bytes
  (storage_used + file_size) <= (disk_quota + grace)
end
```

Sem quota, um único usuário malicioso enche o disco do servidor. Com o grace buffer de 10%, um upload que passa um pouco do limite é aceito pra não frustrar o usuário no edge case.

### Cleanup Automático

```ruby
class CleanupExpiredFilesJob < ApplicationJob
  queue_as :default

  def perform
    SharedFile.inactive.find_each do |shared_file|
      shared_file.file.purge if shared_file.file.attached?
      shared_file.destroy
    end
  end
end
```

Roda a cada 15 minutos via Solid Queue. Se ninguém baixou em 24 horas, sumiu. Se bateu o limite de downloads, sumiu. Sem isso, disco do servidor enche e o serviço morre.

### IP Banning Automático

```ruby
class InvalidHashAccessJob < ApplicationJob
  queue_as :default

  def perform(ip_address)
    security = Rails.application.config.x.security
    return unless security.enable_banning

    cache_key = "invalid_hash:#{ip_address}"
    count = Rails.cache.increment(cache_key, 1, expires_in: 1.hour) || 1

    if count >= security.max_invalid_hash_attempts
      Ban.ban!(ip_address, reason: "Repeated invalid download hash access",
               duration: security.ban_duration)
      Rails.cache.delete(cache_key)
    end
  end
end
```

Tentou 3 hashes inválidos? Banido por 1 hora. Isso impede enumeração de hashes. Com 24 bytes de entropia (192 bits, 2^192 possibilidades), brute force é computacionalmente inviável, mas a proteção extra não custa nada.

### Rate Limiting em Camadas

O Rack::Attack opera na camada de middleware (antes do Rails processar):

```ruby
# Login: 5 tentativas por minuto por IP
Rack::Attack.throttle("logins/ip", limit: 5, period: 1.minute) do |req|
  req.ip if req.path == "/session" && req.post?
end

# Login: 5 tentativas por minuto por email
Rack::Attack.throttle("logins/email", limit: 5, period: 1.minute) do |req|
  if req.path == "/session" && req.post?
    req.params.dig("email_address")&.to_s&.downcase&.strip
  end
end

# Downloads: 60 views e 30 downloads por minuto
Rack::Attack.throttle("downloads_get/ip", limit: 60, period: 1.minute) do |req|
  req.ip if req.path.start_with?("/d/") && req.get?
end

# Geral: 300 requests por 5 minutos (exceto assets)
Rack::Attack.throttle("requests/ip", limit: 300, period: 5.minutes) do |req|
  req.ip unless req.path.start_with?("/assets")
end
```

Sete throttles diferentes pra cenários específicos. Mais o `rate_limit` do Rails 8 nos controllers. IPs banidos nem chegam ao Rails -- são rejeitados na blocklist do middleware com status 403.

E os limites são configuráveis: em produção é 1x, em desenvolvimento é 10x pra não se trancar durante testes. Tudo centralizado no `config/initializers/security.rb`.

## A Saga do Download: 5 Commits em 21 Minutos

![download](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-21_15-31-25.png)

Essa parte é divertida porque mostra debugging real. Entre 14:44 e 15:05, eu fiz **5 commits** tentando fazer o download funcionar com Turbo Drive:

1. `cc3c23d` -- Adicionei `data-turbo=false` no botão de download. **Não funcionou.**
2. `5224ed2` -- Movi `data-turbo=false` pro `<form>`. **Não funcionou.**
3. `98b0d4f` -- Abandonei o `redirect_to rails_blob_path` e usei `send_file` direto. **Parcialmente funcionou.**
4. `1fdf5f9` -- Troquei de POST pra GET link. Funcionou mas... bots podem consumir downloads com GET.
5. `4c74b27` -- Voltei pra POST. Adicionei cleanup de URL artifacts nos filenames.

O root cause: o Turbo Drive intercepta navegação agressivamente, e download de arquivo via `redirect_to` (que gera uma cadeia de 302 redirects do Active Storage) confunde o Turbo. A solução final: `send_file` direto do disco com `disposition: "attachment"` via POST com `data: { turbo: false }` no form.

Esse tipo de problema um LLM não resolve sozinho. Precisa testar no browser real, ver o que acontece, tentar, falhar, ajustar. É desenvolvimento iterativo puro.

## O Gap entre a Ideia e o Produto Final

Olha o que o IDEA.md não mencionava e que emergiu durante o desenvolvimento:

1. Per-user disk quotas -- sem isso um usuário enche o disco do server
2. I18n completo (EN + PT-BR) -- 66 arquivos, ~250 strings extraídas
3. Terms of Service com aceite obrigatório
4. User self-deletion -- requisito de privacidade
5. Blocked downloads de usuários banidos -- seus links retornam 410 Gone
6. Client-side upload validation -- verifica size, quota e filename antes do upload
7. Inline file previews -- imagens, vídeo e áudio no download page sem consumir downloads
8. Styled error pages -- em vez de plain text "Not Found", páginas branded com i18n

O IDEA.md dizia "use activeadmin ou administrate". Na prática construí um admin panel custom com Tailwind porque o `administrate` tinha problemas de compatibilidade com Rails 8.1. O IDEA.md falava em "progress bar se possível". Na prática usei drag-and-drop com preview de arquivo via Stimulus, que é melhor que progress bar.

Ninguém consegue prever todas as features no dia 1. Você descobre requisitos conforme constrói. E cada feature nova traz edge cases que precisam ser tratados.

![pt](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-21_15-32-50.png)

## Os Números

Ao final do projeto:

- 21 commits em uma sessão de ~3 horas
- 210 testes (Minitest + FactoryBot), 513 assertions, zero failures
- ~3.100 linhas de código de aplicação (models, controllers, views, JS, CSS, configs)
- ~1.965 linhas de testes (incluindo testes de segurança dedicados)
- 9 models, 20 controllers, 36 views, 9 Stimulus controllers
- 24 medidas de segurança distintas em 7 camadas
- CI: SimpleCov, RuboCop (zero offenses), Brakeman (zero warnings), bundler-audit (zero vulnerabilities)
- Zero dependências externas além do SQLite. Sem Redis, sem PostgreSQL, sem serviço de fila externo

## O Invitation-Only Server

![invite](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-21_15-31-54.png)

O FrankMega não tem cadastro público. O fluxo é:

1. Na primeira execução, sem nenhum usuário, aparece a tela de setup pra criar o admin
2. A rota `/setup` só existe enquanto `User.count.zero?` -- depois some completamente:

```ruby
constraints(->(request) { User.count.zero? }) do
  get "setup", to: "setup#new"
  post "setup", to: "setup#create"
end
```

3. O admin cria convites no painel admin (com expiração)
4. Cada convite gera um código único de 16 bytes
5. Cada código só pode ser usado uma vez (`with_lock` + transaction pra impedir race condition)
6. Após cadastrar, o convite é marcado como "used"

Isso é perfeito pra um serviço pessoal/familiar. Controle total de quem acessa.

## Deploy: Docker + Cloudflare Tunnel

![share](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-21_15-33-40.png)

Pra fechar, o tutorial de deploy, caso queira rodar no seu próprio Home Server Docker. Não é complicado mas tem detalhes que importam.

### O Dockerfile

Multi-stage build em 3 estágios:

```dockerfile
# Stage 1: Base (runtime)
FROM ruby:3.4.8-slim AS base
RUN apt-get install -y curl libjemalloc2 libvips sqlite3
# jemalloc pra melhor gerenciamento de memória

# Stage 2: Build (throwaway)
FROM base AS build
RUN apt-get install -y build-essential git libssl-dev
# Bundle install + asset precompilation com dummy env vars

# Stage 3: Final
# Copia gems e app, roda como user não-root (rails:rails, UID 1000)
CMD ["./bin/thrust", "./bin/rails", "server"]
```

O `bin/thrust` é o Thruster (do Basecamp) -- um proxy HTTP na frente do Puma que faz: gzip/brotli compression, asset caching, X-Sendfile acceleration. Escuta na porta 80, proxeia pro Puma na 3000.

O entrypoint roda `db:prepare` e `db:seed` automaticamente no boot:

```bash
#!/bin/bash -e
if [ "${@: -2:1}" == "./bin/rails" ] && [ "${@: -1:1}" == "server" ]; then
  ./bin/rails db:prepare
  ./bin/rails db:seed
fi
exec "${@}"
```

### docker-compose.yml

Dois serviços:

```yaml
services:
  web:
    image: akitaonrails/frankmega:latest
    ports:
      - "3100:80"
    volumes:
      - /home/seuuser/frankmega/uploads:/rails/storage/uploads
      - /home/seuuser/frankmega/db:/rails/storage
    environment:
      SECRET_KEY_BASE: ${SECRET_KEY_BASE}
      HOST: ${HOST}
      # ... mais ~15 variáveis
    restart: unless-stopped

  tunnel:
    image: cloudflare/cloudflared:latest
    command: tunnel run
    environment:
      - TUNNEL_TOKEN=${TUNNEL_TOKEN}
    depends_on:
      - web
    restart: unless-stopped
```

O sidecar `cloudflare/cloudflared` cria um túnel outbound pra edge do Cloudflare. Não precisa abrir portas no firewall do home server. O Cloudflare faz SSL termination, DDoS protection, e roteia o tráfego pro container.

### Passo a Passo

**1. Crie o Tunnel no Cloudflare:**
- Cloudflare Zero Trust Dashboard > Networks > Tunnels > Create
- Tipo: Cloudflared
- Copie o `TUNNEL_TOKEN`
- Configure o hostname: `frankmega.seudominio.com` apontando pra `http://web:80`

**2. Gere os segredos:**

```bash
# SECRET_KEY_BASE
openssl rand -hex 64

# Chaves de criptografia (3 valores separados)
openssl rand -hex 32  # PRIMARY_KEY
openssl rand -hex 32  # DETERMINISTIC_KEY
openssl rand -hex 32  # KEY_DERIVATION_SALT
```

**3. Configure o `.env`:**

```env
SECRET_KEY_BASE=<gerado acima>
RAILS_MASTER_KEY=<do config/master.key>
HOST=frankmega.seudominio.com
WEBAUTHN_ORIGIN=https://frankmega.seudominio.com
WEBAUTHN_RP_ID=frankmega.seudominio.com
ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY=<gerado>
ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY=<gerado>
ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT=<gerado>
TUNNEL_TOKEN=<do Cloudflare>
FORCE_SSL=true
APP_LOCALE=pt-BR
```

**4. Suba:**

```bash
docker compose pull
docker compose up -d
```

**5. Acesse** `https://frankmega.seudominio.com`, crie a conta admin, comece a usar.

### Cuidados Importantes

- `FORCE_SSL=false` pra testar localmente em `http://localhost:3100` sem Cloudflare na frente, senão entra em redirect loop
- WebAuthn origin precisa bater exatamente, incluindo o `https://`. Se errar, passkeys silenciosamente não funcionam
- IPs do Cloudflare são hardcoded no initializer (porque o gem `cloudflare-rails` não é compatível com Rails 8.1). Se o Cloudflare mudar os ranges, precisa rebuildar a imagem
- Chaves de criptografia são permanentes. Se trocar depois que usuários configuraram 2FA, os segredos OTP ficam ilegíveis e eles perdem acesso
- Cloudflare free tem limite de 100 MB de upload. Pro plano grátis, arquivos acima disso não passam pelo tunnel. A app permite até 1 GB mas o Cloudflare é o gargalo
- O container roda como UID 1000. Se usar bind mounts ao invés de named volumes, o diretório precisa ser owned pelo UID 1000
- São 4 bancos SQLite separados em produção (app, cache, queue, cable), todos no volume `db_data`. Backup é copiar o volume inteiro

## O Verdadeiro Ponto Sobre "Vibe Coding"

O Claude Code é absurdamente produtivo. Eu não teria feito tudo isso em 3 horas sem ele. Lembra de antigamente que você dava murro em ponta de faca por 1 semana só pra fazer um login funcionar? Pois é.

O commit de I18n sozinho (66 arquivos, ~250 strings extraídas pra dois idiomas) levaria um dia inteiro manualmente.

Mas o ponto que ninguém quer ouvir: **o LLM não tomou as decisões de segurança**. Eu pedi pra ele fazer um audit e ele encontrou os problemas, mas eu precisei saber pedir. E precisei saber quais perguntas fazer. *"Revise a segurança"* é uma instrução vaga. *"Verifique se tem race condition no increment do download counter"* é uma instrução que só quem sabe o que é TOCTOU consegue dar.

Aquelas 56 linhas do IDEA.md carregam décadas de experiência em desenvolvimento web. Eu sabia pedir rate limiting porque já vi serviços derrubados por bots. Sabia pedir IP banning porque já lidei com abuse. Sabia pedir download counter atômico porque entendo concorrência.

Se um iniciante escrevesse o mesmo IDEA.md, provavelmente não teria metade dessas preocupações. E o LLM não iria sugerir espontaneamente. O resultado seria um serviço funcional, bonito, e completamente inseguro.

O valor do programador experiente no Vibe Coding não é escrever código. É saber o que pedir e revisar o que foi gerado. A experiência é o filtro entre "funciona" e "funciona em produção".

Os 210 testes e 24 medidas de segurança não vieram de prompt engineering. Vieram de saber o que testar e por quê.

O código é open source sob AGPL-3.0: [github.com/akitaonrails/frank_mega](https://github.com/akitaonrails/frankmega). Deploy no seu server, fucem o código, aprendam com os commits. E se acharem mais falhas de segurança, me avisem.

Lembrem-se:

> A IA é o espelho da sua própria competência.