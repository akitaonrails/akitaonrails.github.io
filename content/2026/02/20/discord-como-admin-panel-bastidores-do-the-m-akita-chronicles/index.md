---
title: "Discord como Admin Panel | Bastidores do The M.Akita Chronicles"
slug: "discord-como-admin-panel-bastidores-do-the-m-akita-chronicles"
date: 2026-02-20T03:18:24+00:00
draft: false
tags:
- themakitachronicles
- rubyonrails
- discord
---

Este post vai fazer parte de uma série; acompanhe pela tag [/themakitachronicles](/tags/themakitachronicles). Esta é a parte 6.

E não deixe de assinar minha nova newsletter [The M.Akita Chronicles](https://themakitachronicles.com/)!

--

Todo projeto Rails começa igual: você cria um admin panel. Active Admin, Administrate ou um CRUD caseiro. Tabelas, formulários, botões. E a cada semana, você usa 5% das telas que construiu.

Agora imagine que seu admin panel é uma conversa. Você cola um link; o sistema processa. Digita `/week` e vê o resumo. `/approve` e a newsletter está agendada. `/ask akita como funciona o pipeline de podcast?` e uma IA te explica a arquitetura do seu próprio sistema.

![/ask akita](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-20_00-40-53.jpg)

Esse é o Discord como interface operacional. Não é gambiarra — é **a melhor interface CRUD que existe pra um time de uma pessoa**.

## Por Que Discord e Não Um Web Admin?

Vamos ser honestos sobre o que um admin panel exige:

1. **Autenticação**: login, sessão, CSRF, password reset
2. **Autorização**: roles, permissions, who can do what
3. **UI**: tabelas, paginação, formulários, validação client-side
4. **Deployment**: outra rota, outro controller, outro set de testes
5. **Mobile**: responsive? App? PWA?

E o que o Discord já te dá de graça:

1. **Auth**: Discord cuida. Você verifica o `author_id`
2. **Autorização**: uma lista de admin IDs e pronto
3. **UI**: embeds com cores, campos, thumbnails, reações como status
4. **Deployment**: zero. Usa o que já está deployado
5. **Mobile**: app nativo no iOS e Android, push notifications

O trade-off? Não serve pra tudo. Um CRUD complexo com formulários de 20 campos? Melhor um web admin. Mas pra operações de comando/resposta — que são 90% do que você faz no dia a dia — Discord é imbatível.

## discordrb: A Gem Que Funciona

A gem [`discordrb`](https://github.com/shardlab/discordrb) (fork do shardlab, versão 3.7.2) é a mais madura pra Ruby. Não é perfeita — tem idiossincrasias. Mas funciona de verdade em produção.

O setup mínimo:

```ruby
bot = Discordrb::Bot.new(
  token: token,
  intents: Discordrb::INTENTS[:server_messages] |
           Discordrb::INTENTS[:direct_messages] |
           (1 << 15)  # message_content intent
)

bot.message do |event|
  # Toda mensagem passa por aqui
end

bot.run
```

Aquele `(1 << 15)` é o *Message Content Intent*. Sem ele, seu bot recebe eventos mas o `event.content` vem vazio. Precisa habilitar no Discord Developer Portal > Bot > Privileged Gateway Intents. É a primeira armadilha que pega todo mundo.

[![discord dashboard](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-20_00-58-46.jpg)](https://discord.com/developers/)

Não vou detalhar como configurar um bot no Discord, tem [vários tutoriais](https://www.ionos.com/digitalguide/server/know-how/creating-discord-bot/) pra isso já, você acha fácil online. Vou focar só no meu caso de uso como exemplo.

## Padrão 1: Parser + Dispatcher

Misturar parsing de comandos com lógica de negócio é receita pra espaguete. Separa em três camadas:

```
Discord Event → Parser → Dispatcher → Job/Service
```

O runner (que conversa com a API do Discord) é burro de propósito:

```ruby
bot.message do |event|
  next if event.author.bot_account?

  parsed = SlashCommandParser.parse(event.content, attachments: urls)

  case parsed
  when SlashCommandParser::Command
    CommandDispatcher.dispatch(parsed, channel_id: channel_id)
    event.message.react("\u{2705}")  # checkmark
  when SlashCommandParser::Submission
    ProcessMessageJob.perform_later(url: parsed.url, tags: parsed.tags)
    event.message.react("\u{1F916}")  # robot
  end
rescue StandardError => e
  event.message.react("\u{274C}")  # red X
end
```

Três resultados visuais instantâneos: checkmark (comando aceito), robô (URL sendo processada), X vermelho (erro). O usuário sabe o que aconteceu sem esperar nenhuma resposta textual.

O parser retorna objetos tipados, não strings. O dispatcher faz um `case` gigante mas cada handler é um método isolado. Cada handler chama um job ou service. **Nada de lógica de negócio no runner.**

### Evolução: Discord Application Commands

A versão inicial parseava texto puro — o usuário digitava `/week` e o parser interpretava. Funciona, mas tem limitações: sem autocomplete, sem validação de argumentos, sem documentação inline.

![help](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-20_00-56-15.jpg)

O Discord tem um sistema nativo de **Application Commands** — slash commands registrados na API que aparecem com autocomplete, descrição, e tipagem de parâmetros. Quando o usuário digita `/`, o Discord mostra todos os comandos disponíveis com descrição.

```ruby
bot.register_application_command(:week, "List this week's stories", server_id: guild_id)
bot.register_application_command(:approve, "Approve newsletter for sending", server_id: guild_id)
bot.register_application_command(:ask, "Ask AI a question", server_id: guild_id) do |cmd|
  cmd.string("question", "Your question", required: true)
  cmd.string("personality", "AI personality", choices: { "Akita" => "akita", "Marvin" => "marvin" })
end
```

O handler usa `bot.application_command` ao invés de parsear texto:

```ruby
bot.application_command(:week) do |event|
  CommandDispatcher.dispatch_week(channel_id: event.channel.id)
  event.respond(content: "Listing stories...")
end
```

Os dois sistemas coexistem: Application Commands pra quem prefere autocomplete, texto puro pra quem prefere digitar rápido. O dispatcher é o mesmo — a diferença é só como o comando chega.

## Padrão 2: Reações Como Status

![reactions](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-20_00-43-55.jpg)

A feature mais subestimada do Discord pra bots é reações. Elas são feedback visual instantâneo que não polui o canal com mensagens:

- **Checkmark** = comando recebido e enfileirado
- **Robô** = processamento assíncrono iniciado
- **X vermelho** = erro (detalhes no embed que segue)

O usuário cola um link. Vê o robô aparecer. 30 segundos depois, um embed rico aparece com título, resumo, imagem e comentário da IA. Se algo falhar, aparece um embed vermelho com a mensagem de erro.

Isso é melhor que qualquer spinner de loading numa web UI.

## Padrão 3: Embeds Ricos Como Dashboard

![new story](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-20_00-44-36.jpg)

Discord embeds são surpreendentemente poderosos:

```ruby
embed = {
  title: "Story Preview",
  url: source_url,
  color: 0xFF4500,           # vermelho-alaranjado pra high priority
  description: summary,
  thumbnail: { url: image },  # imagem do artigo
  fields: [
    { name: "M.Akita diz", value: akita_comment, inline: false },
    { name: "M.Arvin diz", value: marvin_comment, inline: false },
    { name: "File", value: "`stories/2026-02-16-titulo.md`", inline: false }
  ],
  footer: { text: "fire high | tech_news | verified" }
}

Discordrb::API::Channel.create_message(token, channel_id, "", false, [embed])
```

Cores indicam prioridade (vermelho = high, âmbar = medium, verde = low). O footer mostra score, seção e status de fact-check tudo numa linha. Você bate o olho e sabe o estado da coisa.

![week list](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-20_00-45-11.jpg)

Para relatórios, múltiplos embeds lado a lado (Discord aceita até 10 por mensagem) funcionam como um mini-dashboard. O comando `/week` lista todas as histórias com ações inline — `/load @a3f2b1` pra ver detalhes, `/delete @a3f2b1` pra remover. O hash é estável (baseado no path do arquivo), então não muda quando você deleta outra história.

## Padrão 4: Context Per Channel

![load](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-20_00-46-29.jpg)

Quando o usuário digita `/load #3`, o #3 se refere à listagem mais recente. Mas e se dois canais estão sendo usados simultaneamente?

```ruby
class ChannelContext < ApplicationRecord
  EXPIRY_DURATION = 2.hours

  def self.for_channel(channel_id)
    find_or_create_by!(channel_id: channel_id.to_s)
  end

  def set_week_stories!(hash)
    update!(week_stories_json: hash.to_json, expires_at: EXPIRY_DURATION.from_now)
  end

  def resolve_story_reference(ref)
    if ref.match?(/\A@[a-f0-9]+\z/i)
      # Hash reference (stable across re-listings)
      hash = ref.delete("@").downcase
      week_stories.values.find { |path| md5_prefix(path) == hash }
    elsif ref.match?(/\A#?\d+\z/)
      week_stories[ref.delete("#")]
    end
  end
end
```

Cada canal tem seu próprio contexto com expiração de 2 horas. O `/week` armazena o mapeamento número→arquivo. Depois, `/load #3` consulta esse contexto. Se expirou, o bot diz "run `/week` first".

E o detalhe mais útil: referências por hash (`@a3f2b1`) ao invés de número. Quando você deleta a história #2, a #3 vira #2 — mas o hash `@a3f2b1` continua apontando pro mesmo arquivo. Isso evita o clássico "deletei a errada porque a lista mudou".

## Padrão 5: Admin Check Simples

Nada de RBAC complexo. Uma lista de IDs:

```ruby
ADMIN_COMMANDS = %i[delete update_score approve newsletter publish_blog].freeze

def self.dispatch(command, channel_id:, author_id:)
  if ADMIN_COMMANDS.include?(command.type) && !admin?(author_id)
    send_error(channel_id, "Permission denied. Admin privileges required.")
    return
  end
  # ...
end

def self.admin?(author_id)
  admin_ids = ENV["DISCORD_ADMIN_USER_IDS"].to_s.split(",")
  return true if admin_ids.empty?  # dev: sem IDs = tudo permitido
  admin_ids.include?(author_id)
end
```

Em dev, sem `DISCORD_ADMIN_USER_IDS` configurado, tudo é permitido. Em produção, é uma lista de Discord user IDs. Sem banco, sem roles table, sem middleware. Dez linhas resolvem autorização.

## Padrão 6: Operações Assíncronas com Feedback

Operações lentas (gerar imagem, processar artigo, chamar IA) vão pra background jobs. O feedback visual é em três tempos:

```ruby
def self.handle_ask(personality, question, attachments, channel_id)
  # 1. Feedback imediato: "estou pensando"
  thinking_id = DiscordNotifier.send_message(channel_id, content: "Thinking...")

  # 2. Job faz o trabalho pesado em background
  AskJob.perform_later(
    question,
    channel_id: channel_id,
    thinking_message_id: thinking_id
  )
end

# No AskJob:
def perform(question, channel_id:, thinking_message_id: nil)
  result = AiChat.ask_multimodal(question, tools: [GenerateImageTool])

  # 3. Remove "Thinking..." e mostra resultado
  DiscordNotifier.delete_message(channel_id, thinking_message_id)
  DiscordNotifier.send_message(channel_id, content: "**Marvin:** #{result[:text]}")
end
```

![thinking](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-20_00-47-26.jpg)

O "Thinking..." aparece instantaneamente, o job roda em background, e quando termina, a mensagem temporária some e o resultado real aparece. Se o job falhar, o "Thinking..." some e um embed de erro aparece.

Sem isso, o usuário manda uma pergunta e fica olhando pra tela sem saber se o bot ouviu. UX terrível.

## Padrão 7: RubyLLM + Tool Calling No Discord

A parte mais poderosa: dar ferramentas pro LLM. O `/ask` tem três tools disponíveis: `GenerateImageTool` (gera imagens via Gemini), `WebSearchTool` (busca na web via Brave Search), e `WebFetchTool` (busca e resume páginas web). O LLM decide sozinho qual usar baseado na pergunta. Quando o usuário pede "gera uma imagem de um gato programando", o LLM escolhe o tool certo:

```ruby
class GenerateImageTool < RubyLLM::Tool
  description "Generate an image using Gemini. Use when the user asks to create or draw."
  param :prompt, desc: "Image description"
  param :aspect_ratio, desc: "1:1 or 16:9", required: false

  def execute(prompt:, aspect_ratio: "1:1")
    image_data = ImageGenerator.generate(prompt: prompt)
    return "Failed to generate image" unless image_data

    path = save_temp_file(image_data)
    Thread.current[:generated_images] << path

    "Image generated successfully. Tell the user it's ready."
  end
end
```

O `Thread.current[:generated_images]` é o truque pra passar dados de volta do tool pro job. O LLM chama o tool durante `chat.ask`, o tool salva o arquivo e registra o path. Depois que `chat.ask` retorna, o job pega os paths e manda pro Discord como file uploads.

Por que thread-local e não retorno direto? Porque o LLM pode chamar múltiplos tools numa única resposta, e o retorno do tool volta pro LLM (não pro seu código) — é ele que decide o que responder ao usuário. O thread-local é o side channel pra seu código saber o que aconteceu.

## Padrão 8: Notificações de Status Em Produção

Todo job de geração de conteúdo notifica um canal dedicado:

```ruby
module DiscordStatus
  def notify_start(label)
    DiscordNotifier.send_to_status_channel("Starting #{label}...")
  end

  def notify_done(label)
    DiscordNotifier.send_to_status_channel("#{label} complete.")
  end

  def notify_error(label, error)
    DiscordNotifier.send_to_status_channel("#{label} FAILED: #{error}")
  end
end
```

O canal de status é separado do canal de operação. Quando os 8 jobs de geração de conteúdo rodam no domingo às 17h, o canal de status vira um log em tempo real:

```
Starting Anime Ranking...
Starting Hacker News...
Starting YouTube Digest...
Anime Ranking complete.
YouTube Digest complete.
Hacker News complete.
Starting Market Recap...  (wave 2, after world events)
...
```

De manhã, se algo deu errado, você abre o Discord no celular e sabe exatamente o quê — sem SSH no servidor, sem grep em logs.

E quando o bot reinicia após um deploy:

```ruby
bot.ready do |_event|
  status_channel = ENV["DISCORD_STATUS_CHANNEL_ID"]
  DiscordNotifier.send_message(status_channel, content: "Bot reconnected and ready.")
end
```

![log](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-20_00-48-20.jpg)

Simples, mas você sabe que o deploy funcionou sem checar nada.

## Padrão 9: Cross-App Communication

O sistema tem dois apps Rails que precisam se falar. A newsletter precisa notificar o Discord quando termina de montar uma edição. Mas a newsletter não tem conexão Discord — quem tem é o marvin-bot.

Solução: HTTP relay.

```ruby
# Na newsletter — manda pro marvin-bot
class DiscordRelayClient
  def self.send_embed(title:, description:, color:)
    post("/api/discord_notify",
      type: "embed",
      payload: { title: title, description: description, color: color }
    )
  end
end

# No marvin-bot — recebe e repassa pro Discord
class Api::DiscordNotifyController < ApplicationController
  def create
    case params[:type]
    when "embed"
      DiscordNotifier.send_embed(status_channel, params[:payload])
    when "message"
      DiscordNotifier.send_message(status_channel, content: params[:payload][:content])
    end
  end
end
```

A newsletter fala HTTP. O marvin-bot traduz pra Discord. Um `ADMIN_TOKEN` compartilhado autentica. Todos os métodos resgatam erros e retornam nil — se o Discord estiver fora, a newsletter não trava. Fire and forget.

Mas tem um segundo fluxo cross-app mais interessante: o trigger de podcast. Quando a newsletter é aprovada, ela precisa avisar o marvin-bot pra gerar o podcast:

```ruby
# Na newsletter — dispara geração de podcast no marvin-bot
class MarvinBotClient
  def self.trigger_podcast(date:)
    post("/api/trigger/podcast", date: date.to_s)
  end
end
```

Isso inicia um pipeline inteiro no marvin-bot: script LLM de duas passadas → TTS por turno na GPU → assembly com loudnorm → upload S3. E o `PublishAndSendJob` da newsletter fica esperando (via `retry_on PodcastNotReady`) até o podcast ficar pronto. Dois apps, duas linguagens de backend (Ruby e Python), conectados por HTTP fire-and-forget com polling de resultado. Não é elegante — mas funciona toda semana sem intervenção.

## Padrão 10: Cost Tracking Integrado

Cada chamada de IA é rastreada com tokens e custo estimado:

```ruby
def self.create_chat(caller:, model:, provider:)
  chat = RubyLLM.chat(model: model, provider: provider)
  chat.on_end_message do |message|
    ApiUsage.create!(
      caller_name: caller,
      input_tokens: message.input_tokens,
      output_tokens: message.output_tokens,
      cost_usd: estimate_cost(model, message)
    )
  end
  chat
end
```

E no Discord: `/cost` mostra o gasto por mês, ano, e por provider. Sem dashboard separado, sem Grafana, sem nada. Um comando e a informação que importa.

![cost](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-20_00-49-05.jpg)

## Padrão 11: Nunca Falhe Silenciosamente

Esse é o padrão que eu devia ter implementado desde o começo, mas só aprendi da pior maneira — em produção.

![daily](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-20_00-50-46.jpg)

O projeto tem ~10 daily jobs que buscam dados de fontes externas (Hacker News, GitHub Trending, Morningstar, etc.) e postam embeds no Discord. Cada client segue um padrão "defensivo":

```ruby
# O padrão que PARECE correto:
class DailyDevClient
  def self.fetch_popular(limit: 10)
    response = HTTParty.get(API_URL, headers: { "Authorization" => "Bearer #{token}" })
    return [] unless response.success?
    parse(response.body)
  rescue StandardError => e
    Rails.logger.warn("DailyDevClient failed: #{e.message}")
    []
  end
end

# E no job:
class DailyDailyDevJob < ApplicationJob
  def perform
    posts = DailyDevClient.fetch_popular(limit: 10)
    return if posts.empty?  # ← O PROBLEMA
    # ... posta embed no Discord
  end
end
```

Esse código nunca crasheia. Nunca levanta exceção. Nunca enche o log de erros. É o código mais "robusto" possível.

É também completamente **inútil pra diagnóstico**. Quando deployei e rodei os daily jobs manualmente, só um dos dez funcionou. Mas não havia **nenhum** erro nos logs. Nenhum. O `return [] unless response.success?` engolia o HTTP 401 sem logar. O `return if posts.empty?` descartava o resultado sem avisar ninguém. Tudo verde, tudo silencioso, zero dados.

A correção tem duas partes:

**Parte 1: Clients logam o código HTTP:**

```ruby
unless response.success?
  Rails.logger.warn("DailyDevClient: API returned HTTP #{response.code}")
  return []
end
```

Parece óbvio, mas é fácil esquecer quando você escreve `return []` como reflexo defensivo. O `response.code` é a informação que diferencia "token expirado" (401) de "rate limited" (429) de "API fora do ar" (503). Sem ele, tudo parece igual: array vazio.

**Parte 2: Jobs avisam no Discord quando não têm dados:**

```ruby
module DailyDiscordEmbed
  def report_empty(title)
    Rails.logger.warn("#{self.class.name}: #{title} returned no results")
    channel_id = Rails.application.config.discord.channel_ids.first
    return unless channel_id.present?

    embed = {
      title: "⚠️ #{title}",
      description: "#{self.class.name} returned no results. Check logs.",
      color: 0xFFA500,  # laranja = warning, não vermelho = error
      timestamp: Time.current.iso8601
    }
    DiscordNotifier.send_embed(channel_id, embed)
  rescue StandardError => e
    Rails.logger.error("#{self.class.name} empty report failed: #{e.message}")
  end
end
```

Agora quando um daily job não traz dados:

```ruby
def perform
  posts = DailyDevClient.fetch_popular(limit: 10)
  if posts.empty?
    report_empty("daily.dev Popular")
    return
  end
  # ...
end
```

![no results](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-20_00-50-02.jpg)

Um embed laranja aparece no Discord. De manhã, abro o canal e vejo: "⚠️ daily.dev Popular returned no results". Vou nos logs e descubro: "DailyDevClient: API returned HTTP 401". Token expirado. Corrigido em 2 minutos.

Sem esse padrão, eu teria descoberto semanas depois — quando alguém perguntasse "por que nunca tem posts do daily.dev?".

A lição: **`rescue => []` não é error handling. É error hiding.** Cada ponto de falha precisa de dois sinais: um log com o detalhe técnico (HTTP code, mensagem de exceção) e uma notificação visual no canal onde você já está olhando (Discord). Se o bot É sua interface operacional, falhas do bot precisam aparecer NA interface.

## Padrão 12: Conversas Com Memória (`/ask` Multi-Turn)

A primeira versão do `/ask` criava um `RubyLLM::Chat` novo a cada invocação. Funcionava, mas era como conversar com alguém que tem amnésia:

```
/ask o que é Ruby?
→ Ruby é uma linguagem de programação criada por Matz em 1995...

/ask compare com Python
→ Comparar o quê com Python? Poderia ser mais específico?
```

O ruby_llm já mantém histórico internamente — cada `chat.ask()` appende à lista de mensagens e manda o contexto completo pro modelo. O que faltava era persistir o objeto `Chat` entre invocações.

A solução é um store in-memory com três safeguards:

```ruby
class AskSessionStore
  MAX_SESSIONS = 100       # total across all users
  SESSION_TTL = 2.hours    # inactivity timeout
  MAX_MESSAGES = 50        # ~25 exchanges, then auto-reset

  Session = Struct.new(:chat, :last_used, keyword_init: true)

  def get_or_create(author_id, personality, system_prompt:, tools:)
    synchronize do
      cleanup_expired
      key = [author_id, personality]

      if (session = @sessions[key])
        session.last_used = Time.current
        if session.chat.messages.length > MAX_MESSAGES
          @sessions.delete(key)
          return create_session(key, system_prompt: system_prompt, tools: tools)
        end
        session.chat
      else
        evict_oldest if @sessions.size >= MAX_SESSIONS
        create_session(key, system_prompt: system_prompt, tools: tools)
      end
    end
  end
end
```

![ask memory](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-20_00-54-32.jpg)

A chave vai ser `(author_id, personality)` — cada usuário tem sessões separadas pro Marvin e pro Akita. Volátil de propósito: reiniciou o servidor, perdeu o histórico. Sem banco, sem serialização, sem complexidade. É memória de trabalho, não persistência.

O `/ask clear` reseta a sessão. Sem isso, não tem como "começar de novo" quando a conversa fica confusa.

Agora:

```
/ask o que é Ruby?
→ Ruby é uma linguagem de programação criada por Matz em 1995...

/ask compare com Python
→ Ruby e Python têm filosofias parecidas — ambas priorizam felicidade do
  programador — mas Ruby abraça blocos e metaprogramação enquanto Python
  prefere explicitness...
```

O LLM sabe que "compare" se refere a Ruby porque o histórico da sessão inclui a pergunta anterior. É a diferença entre um chatbot e um assistente.

## Padrão 13: Registrando Application Commands (Autocomplete Nativo)

A seção sobre Application Commands acima mostrou o conceito simplificado. Na prática, registrar 18 comandos com subcommands, parâmetros tipados e choices exige uma estrutura dedicada. Veja como o projeto resolve isso.

![auto complete](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-20_00-43-18.jpg)

### O Problema Com Texto Puro

Quando o bot só parseia texto, o usuário precisa decorar a sintaxe:

```
/update score #1 #2 #3 high       ← funciona
/update score #1 #2 #3 alta       ← falha silenciosamente
/update scoree #1 high             ← ignorado
```

Sem autocomplete, sem validação de parâmetros, sem documentação inline. O usuário digita `/` e não sabe o que está disponível.

### O Módulo `DiscordCommands`

Toda a definição de comandos vive num módulo separado com dois métodos públicos: `register!` (cadastra os comandos na API do Discord) e `setup_handlers!` (conecta os handlers ao bot):

```ruby
module DiscordCommands
  SCORE_CHOICES  = { "High" => "high", "Medium" => "medium", "Low" => "low" }.freeze
  SECTION_CHOICES = {
    "Tech" => "tech", "Global" => "global", "Financial" => "financial",
    "Q&A" => "qa", "Entertainment" => "entertainment", "Open Source" => "opensource",
    "Product" => "product", "Book" => "book"
  }.freeze
  PERSONALITY_CHOICES = { "Marvin (default)" => "marvin", "Akita" => "akita" }.freeze

  def self.register!(bot)
    server_id = Rails.application.config.discord.server_id
    sid = server_id.present? ? server_id.to_i : nil

    register_week(bot, sid)
    register_add(bot, sid)
    register_update(bot, sid)
    register_ask(bot, sid)
    # ... mais 14 comandos
  end

  def self.setup_handlers!(bot)
    setup_week_handlers(bot)
    setup_add_handler(bot)
    setup_update_handlers(bot)
    setup_ask_handlers(bot)
    # ... mais 14 handlers
  end
end
```

### Guild vs Global

O `server_id` (ou `sid`) controla o escopo do registro. Com `server_id`, o comando aparece instantaneamente no servidor especificado. Sem, o comando é global — disponível em todos os servidores, mas pode levar até uma hora pra propagar.

Para um bot privado de operações internas, sempre use guild-scoped. O env var `DISCORD_SERVER_ID` é configurado no deploy:

```ruby
sid = server_id.present? ? server_id.to_i : nil
bot.register_application_command(:week, "Story list and weekly report", server_id: sid)
```

Se `sid` for nil, o discordrb registra globalmente. Em dev, é conveniente; em produção, guild-scoped é mais rápido e permite comandos diferentes por servidor.

### Anatomia De Um Comando

O método mais simples — sem parâmetros:

```ruby
def self.register_count(bot, sid)
  bot.register_application_command(:count, "Show story count for this week", server_id: sid)
end
```

Com parâmetros tipados:

```ruby
def self.register_add(bot, sid)
  bot.register_application_command(:add, "Submit a URL for the newsletter", server_id: sid) do |cmd|
    cmd.string(:url, "The URL to submit", required: true)
    cmd.string(:tags, "Tags (e.g. #tech #high)")
    cmd.string(:comment, "Optional comment about this link")
  end
end
```

O Discord mostra isso como um formulário inline: campo `url` obrigatório, `tags` e `comment` opcionais. O usuário vê a descrição de cada parâmetro enquanto preenche.

### Subcommands: Agrupando Ações

Comandos complexos usam subcommands. `/update` sozinho não faz nada — o usuário precisa escolher o que atualizar:

```ruby
def self.register_update(bot, sid)
  bot.register_application_command(:update, "Update story properties", server_id: sid) do |cmd|
    cmd.subcommand(:score, "Update story priority score") do |sub|
      sub.string(:stories, "Story numbers (e.g. #1 #2 #3 or 1,2,3)", required: true)
      sub.string(:level, "Priority level", required: true, choices: SCORE_CHOICES)
    end
    cmd.subcommand(:tag, "Update story section tag") do |sub|
      sub.string(:stories, "Story numbers (e.g. #1 #2 #3 or 1,2,3)", required: true)
      sub.string(:section, "Section tag", required: true, choices: SECTION_CHOICES)
    end
    cmd.subcommand(:image, "Update story image") do |sub|
      sub.string(:stories, "Story numbers (e.g. #1 #2 #3 or 1,2,3)", required: true)
      sub.attachment(:file, "Image file (omit for AI generation)")
    end
    # ... mais subcommands: title, description, comment, source
  end
end
```

Quando o usuário digita `/update`, o Discord mostra uma lista de subcommands: score, tag, title, description, comment, image, source. Ao escolher `score`, aparece o campo `stories` (texto livre) e `level` (dropdown com High/Medium/Low). Impossível errar a sintaxe.

### Choices: Dropdowns Nativos

O hash `SCORE_CHOICES` vira um dropdown no Discord. A chave é o label visível ("High"), o valor é o que chega no handler ("high"):

```ruby
SCORE_CHOICES = { "High" => "high", "Medium" => "medium", "Low" => "low" }.freeze

# No registro:
sub.string(:level, "Priority level", required: true, choices: SCORE_CHOICES)
```

O usuário não precisa lembrar se é "high", "HIGH", "alta", ou "3". Seleciona no dropdown e pronto. Isso elimina uma categoria inteira de erros de input.

### Attachments: Upload de Arquivos

O Discord suporta parâmetros do tipo attachment — o usuário pode arrastar um arquivo direto no comando:

```ruby
cmd.subcommand(:image, "Update story image") do |sub|
  sub.string(:stories, "Story numbers (e.g. #1 #2 #3 or 1,2,3)", required: true)
  sub.attachment(:file, "Image file (omit for AI generation)")
end
```

No handler, os attachments resolvidos vêm como URLs do CDN do Discord:

```ruby
def self.resolve_attachments(event)
  return [] unless event.resolved&.attachments&.any?
  event.resolved.attachments.values.map(&:url)
end
```

### Lifecycle: Onde Registrar, Onde Conectar Handlers

Esse é o ponto que mais confunde. Os **handlers** precisam ser registrados **antes** do `bot.run`. O **registro na API do Discord** pode acontecer no `bot.ready` (que dispara após a conexão WebSocket):

```ruby
class MarvinBotRunner
  def self.run!
    bot = Discordrb::Bot.new(token: token, intents: ...)

    # 1. Handlers ANTES do bot.run (senão o bot não sabe como responder)
    DiscordCommands.setup_handlers!(bot)

    bot.ready do |_event|
      # 2. Registro na API DEPOIS da conexão (idempotente, safe on reconnect)
      DiscordCommands.register!(bot)
    end

    bot.run
  end
end
```

Por que no `bot.ready`? Porque o bot pode reconectar (Discord fecha WebSockets periodicamente). O `register!` é idempotente — registrar o mesmo comando duas vezes não duplica, só atualiza. Colocar no `ready` garante que os comandos existem mesmo após um reconnect.

### Bridge: Application Command → CommandDispatcher

O ponto mais elegante da arquitetura: o handler de Application Command não tem lógica de negócio. Ele traduz os parâmetros do Discord pro formato que o `CommandDispatcher` já espera:

```ruby
def self.dispatch_interaction(event, type, match: [nil], attachments: [])
  event.respond(content: "\u{2705}", ephemeral: true)  # checkmark só visível pro autor
  command = SlashCommandParser::Command.new(
    type: type,
    args: { match: match, attachments: attachments }
  )
  CommandDispatcher.dispatch(command,
    channel_id: event.channel.id.to_s,
    message_id: nil,
    author_id: event.user.id.to_s
  )
rescue StandardError => e
  Rails.logger.error("Discord interaction error (#{type}): #{e.message}")
end
```

Cada handler de subcommand é um one-liner que monta os argumentos e chama `dispatch_interaction`:

```ruby
bot.application_command(:update).subcommand(:score) do |event|
  stories = event.options["stories"]
  level = event.options["level"]
  dispatch_interaction(event, :update_score, match: [nil, stories, nil, level])
end
```

O `CommandDispatcher` não sabe se o comando veio de texto puro ou de Application Command. A mesma lógica, a mesma autorização, os mesmos jobs. Nenhum código duplicado.

### O Resultado

O projeto registra 18 Application Commands com combinações de subcommands, parâmetros tipados, dropdowns e upload de arquivos. O usuário digita `/` e vê tudo disponível com descrição. Escolhe um comando e o Discord guia o preenchimento campo a campo. Erros de sintaxe são impossíveis — o Discord valida antes de enviar.

E os dois sistemas coexistem: quem prefere autocomplete usa Application Commands, quem prefere digitar rápido usa texto puro. O `CommandDispatcher` recebe os dois da mesma forma. Adicionar um novo comando é adicionar um `register_*`, um `setup_*_handler`, e um método no dispatcher — sem mexer no runner.

## As Armadilhas do discordrb

Nem tudo são flores. Algumas dores reais:

**Gateway disconnects**: O WebSocket com o Discord cai de vez em quando. O discordrb reconecta automaticamente, mas seus handlers `bot.ready` e `bot.message` precisam ser resilientes a reconexões.

**Message Content Intent**: Desde 2022, bots em mais de 75 servidores precisam de aprovação pra ler conteúdo de mensagens. Pra bots privados (que é o caso de operação interna), isso não é problema. Mas se você planeja distribuir o bot, prepare o paperwork.

**API Rate Limits**: O Discord rate-limita por rota. Mandar 10 embeds de uma vez pro mesmo canal? Vai bater no limite. O discordrb faz rate limit handling internamente, mas chamadas rápidas demais causam delays visíveis.

**Embed Limits**: Título máximo 256 chars. Description 4096. Field value 1024. Excedeu? Erro silencioso. Sempre trunca antes de enviar.

**File Uploads**: Limit de 25MB no plano gratuito, 50MB com Nitro. Pra imagens de IA geradas isso nunca é problema, mas se for mandar PDFs ou áudio, cuidado.

## Quando NÃO Usar Discord Como Admin

- **Formulários complexos**: editar 15 campos de um registro? Tela web
- **Bulk operations**: importar CSV com 1000 registros? Script
- **Visualização de dados**: gráficos, dashboards analíticos? Grafana/Metabase
- **Aprovação multi-step**: workflows com 5 etapas de aprovação? Precisa de estado persistido

Mas pra o dia a dia operacional — curar conteúdo, aprovar newsletters, monitorar jobs, checar custos, conversar com IA — Discord é a interface mais produtiva que já usei. E o melhor: os assinantes nunca vão saber que a newsletter semanal deles foi curada por um cara digitando comandos no Discord do celular enquanto toma café.

## Conclusão

![hello](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-20_00-57-11.jpg)

O Discord como admin panel não é preguiça. É reconhecer que a melhor interface é a que você já usa o dia inteiro. Auth, push notifications, mobile, rich formatting, file sharing — tudo grátis. O que você constrói é a lógica de negócio, não a infraestrutura de UI.

A gem [`ruby_llm`](https://rubyllm.com/) com tool calling transforma o bot de "executor de comandos" em "assistente que pensa". Com memória de sessão, vira um assistente que pensa **e lembra**. Quando o LLM pode gerar imagens, buscar na web, manter contexto entre perguntas, e responder sobre a arquitetura do seu próprio sistema, o bot deixa de ser um CRUD e vira um co-piloto.

E o padrão Parser → Dispatcher → Job mantém tudo testável. O parser não sabe nada de Discord. O dispatcher não sabe nada de IA. Os jobs não sabem nada de interface. Cada camada faz uma coisa, e trocar qualquer uma delas não afeta as outras.

Se tem algo que aprendi com esse projeto: a melhor admin UI é a que não precisa de deploy separado. O melhor assistente de IA é o que vive onde você já trabalha. E o pior bug é o que falha silenciosamente — se o seu bot é sua interface operacional, as falhas do bot precisam aparecer **na** interface, não escondidas num log que ninguém lê.

