---
title: "Jobs Assíncronos que sobrevivem ao Caos | Bastidores do The M.Akita Chronicles"
slug: "jobs-asssincronos-que-sobrevivem-ao-caos-bastidores-do-the-m-akita-chronicles"
date: 2026-02-19T01:10:08+00:00
draft: false
tags:
- themakitachronicles
- rubyonrails
- activejob
---

Este post vai fazer parte de uma série; acompanhe pela tag [/themakitachronicles](/tags/themakitachronicles). Esta é a parte 5.

E não deixe de assinar minha nova newsletter [The M.Akita Chronicles](https://themakitachronicles.com/)!

--

Vou ser direto: a maioria dos desenvolvedores trata background jobs como se fossem scripts que rodam uma vez e pronto. "Ah, coloca num Sidekiq e tá bom." Não, **não tá bom**. Jobs que processam coisas importantes — enviar emails, publicar conteúdo, chamar APIs externas — precisam ser tratados como cidadãos de primeira classe na sua arquitetura.

Neste post vou mostrar como o Rails 8 com ActiveJob e SolidQueue mudou minha perspectiva sobre processamento assíncrono. Não é teoria — são padrões que emergiram de um sistema real rodando em produção toda semana.

## O Problema: Jobs São Frágeis por Natureza

Pense no cenário: você tem um job que monta uma newsletter, publica num blog via API do GitHub, espera um podcast ficar pronto, e depois dispara emails para centenas de assinantes. Qualquer passo pode falhar. A API pode dar timeout. O podcast pode demorar mais que o esperado. O servidor pode reiniciar no meio do envio.

Se você tratar isso como um script linear, vai sofrer. A pergunta certa não é "como faço esse job rodar?" — é **"como faço esse job se recuperar quando algo der errado?"**

## Padrão 1: retry_on Com Exceções Específicas

O `retry_on` do ActiveJob é absurdamente poderoso, mas a maioria usa errado. Olha o anti-padrão clássico:

```ruby
class MeuJob < ApplicationJob
  retry_on StandardError, wait: 5.seconds, attempts: 3
end
```

Isso re-tenta **qualquer** erro 3 vezes e desiste. Serve pra quase nada no mundo real. O padrão que funciona é criar exceções específicas para estados transitórios:

```ruby
class PodcastNotReady < StandardError; end

class PublishAndSendJob < ApplicationJob
  retry_on PodcastNotReady, wait: 15.minutes, attempts: 16

  def perform(newsletter_id)
    metadata = check_podcast_metadata(newsletter_id)
    raise PodcastNotReady, "Aguardando podcast" unless metadata
    # continua o trabalho...
  end
end
```

Percebe o que está acontecendo? O job espera até **4 horas** (15min × 16) pelo podcast ficar pronto, fazendo polling a cada 15 minutos. Não é um loop infinito — tem um limite claro. E quando estoura esse limite, você trata o timeout explicitamente:

```ruby
rescue PodcastNotReady => e
  if executions >= 16
    # Publica sem podcast e avisa a equipe
    publish_without_podcast(newsletter)
    notify_team("Podcast não ficou pronto a tempo")
  else
    raise # re-raise pra SolidQueue agendar o próximo retry
  end
end
```

Isso é **degradação graciosa**. O sistema não para porque um componente falhou — ele se adapta e continua.

## Padrão 2: Locks Distribuídos

Quando você tem múltiplos caminhos que podem disparar o mesmo job (um cron de segurança, um trigger manual, uma API), precisa garantir que só uma instância roda por vez.

O conceito é simples: um lock baseado em arquivo (ou banco) que expira automaticamente:

```ruby
class DeployLock
  LOCK_DIR = Rails.root.join("tmp/locks")
  DEFAULT_TTL = 30.minutes

  def self.with_lock(name, ttl: DEFAULT_TTL)
    acquire!(name, ttl: ttl)
    yield
  ensure
    release(name)
  end
end
```

Com SQLite, isso é trivial — sem Redis, sem coordenação externa. O lock tem TTL pra não travar se o processo morrer. E o `ensure` garante que libera mesmo se o bloco levantar exceção.

## Padrão 3: Envio Atômico de Emails

Aqui é onde a maioria dos sistemas de newsletter falha espetacularmente. O cenário: você está enviando 500 emails e o servidor reinicia no email 247. O que acontece quando o job re-executa?

Se você só iterou uma lista, vai reenviar os primeiros 247. Seus assinantes vão adorar receber a newsletter duas vezes.

A solução é **claiming atômico** por destinatário:

```ruby
# Antes de enviar, cria um registro por assinante
subscribers.each do |sub|
  EmailDelivery.create!(
    newsletter: newsletter,
    subscriber: sub,
    status: "pending"
  )
end

# Na hora de enviar, faz claim atômico
delivery = EmailDelivery
  .where(status: ["pending", "failed"])
  .lock
  .first

delivery.update!(status: "sending")
send_email(delivery)
delivery.update!(status: "sent")
```

Se o servidor morrer entre `sending` e `sent`, o registro fica como "sending" — e um job de recuperação (`RecoverStaleDeliveriesJob`) periodicamente move esses registros para "unknown" depois de um timeout, pra que nunca sejam automaticamente reenviados. Emails ambíguos **nunca** são reenviados automaticamente. Esse é o tipo de detalhe que separa um sistema hobby de um sistema de produção.

## Padrão 4: Jobs Orquestradores

Um erro comum é colocar lógica demais num único job. O padrão que funciona é ter **jobs orquestradores** que delegam para jobs especializados:

```
PublishAndSendJob (orquestrador)
  ├── Espera podcast (retry_on PodcastNotReady)
  ├── PublishToBlogJob.publish(newsletter)
  └── SendNewsletterJob.perform_now(newsletter.id)
        └── SendSingleEmailJob (por assinante)
```

O orquestrador coordena a sequência. Cada job especializado sabe fazer exatamente uma coisa e pode ser re-executado independentemente. Se o envio de emails falhar, você pode re-disparar só o `SendNewsletterJob` sem republicar o blog.

## Padrão 5: Safety Nets com Cron

Não confie em uma única cadeia de execução. O cron do SolidQueue (`config/recurring.yml`) serve como rede de segurança:

```yaml
send_newsletter:
  class: SendNewsletterJob
  schedule: "0 12 * * 1"  # Segunda 9h BRT (UTC-3)
```

Se o `PublishAndSendJob` das 7h falhou catastroficamente, o cron das 9h dispara o `SendNewsletterJob` como fallback. O job verifica se a newsletter já foi enviada e faz no-op se sim. **Idempotência** é a palavra-chave aqui — o job pode rodar quantas vezes quiser e o resultado é sempre o mesmo.

Mas cuidado com o inverso: um job que se reagenda infinitamente quando não encontra trabalho é uma bomba-relógio. Se o job não encontra newsletter pronta, ele simplesmente retorna. O cron cuida de tentar de novo na próxima semana.

## Padrão 6: Notificações de Status

Todo job de longa duração deve comunicar seu progresso. Um concern simples resolve:

```ruby
module DiscordStatus
  extend ActiveSupport::Concern

  def notify_start(message)
    DiscordNotifier.send(channel: status_channel, text: "▶️ #{message}")
  end

  def notify_done(message)
    DiscordNotifier.send(channel: status_channel, text: "✅ #{message}")
  end

  def notify_error(message)
    DiscordNotifier.send(channel: status_channel, text: "❌ #{message}")
  end
end
```

Cada job inclui o concern e chama `notify_start` no início, `notify_done` no sucesso, `notify_error` no rescue. Quando algo dá errado às 3 da manhã, você acorda e vê exatamente onde parou — sem precisar cavar logs.

## SolidQueue: O Fim da Dependência de Redis

Uma nota sobre SolidQueue, que veio como padrão no Rails 8: usar o mesmo banco SQLite para jobs e dados da aplicação simplifica **drasticamente** a operação. Não precisa de Redis rodando separado. Não precisa se preocupar com o Redis reiniciar e perder jobs que estavam na memória.

Os jobs ficam persistidos no banco. Se o servidor reiniciar, eles estão lá esperando. O retry state é preservado. É absurdamente mais simples que a alternativa, e pra 99% dos casos, a performance é mais que suficiente.

## Conclusão

O Rails 8 com ActiveJob e SolidQueue não inventou nada revolucionário. O que ele fez foi deixar ridiculamente fácil de implementar padrões que antes precisavam de infraestrutura pesada:

- **retry_on** com exceções específicas e limites claros
- **Locks distribuídos** com TTL automático
- **Claiming atômico** pra operações que não podem duplicar
- **Jobs orquestradores** que delegam e se recuperam
- **Crons de segurança** como fallback
- **Notificações** pra visibilidade operacional

Nenhum desses padrões é complicado sozinho. Mas juntos, é o que faz a diferença entre um sistema que quebra na primeira falha e um que aguenta o tranco em produção — e te deixa dormir tranquilo na segunda-feira.
