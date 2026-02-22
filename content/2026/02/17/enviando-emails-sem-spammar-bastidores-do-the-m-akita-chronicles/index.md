---
title: "Enviando Emails sem Spammar | Bastidores do The M.Akita Chronicles"
slug: "enviando-emails-sem-spammar-bastidores-do-the-m-akita-chronicles"
date: 2026-02-17T20:59:48+00:00
draft: false
tags:
- themakitachronicles
- vibecode
- rubyonrails
- amazon
- ses
- email
---

Este post vai fazer parte de uma série; acompanhe pela tag [/themakitachronicles](/tags/themakitachronicles). Esta é a parte 1.

E não deixe de assinar minha nova newsletter [The M.Akita Chronicles](https://themakitachronicles.com/)!

--

Enviar emails parece trivial. Chama uma API, passa o HTML, manda. Pronto. Até o dia em que você descobre que enviou a mesma newsletter duas vezes pra 300 pessoas. Ou que 50 e-mails voltaram como bounce e a Amazon suspendeu sua conta. Ou que seu servidor reiniciou no meio do envio e agora você não sabe quem recebeu e quem não recebeu.

O Amazon SES é eficiente — e brutalmente impiedoso com quem não trata cada envio como uma operação que pode falhar em cinco formas. Neste post vou mostrar os padrões que transformam "mandar email" em "mandar email de forma confiável".

## Por Que SES e Não Sendgrid/Mailgun/Resend?

Preço. Ponto. O SES cobra $0.10 por mil e-mails. Sendgrid cobra $20/mês por 50 mil. Pra uma newsletter pequena, os dois são baratos. Mas o SES escala sem mudar de plano — e como já estou na AWS pra S3, não preciso de mais um vendor.

A desvantagem? SES é low-level. Não tem interface bonita de drag-and-drop, não tem analytics integrado, não tem IP dedicado no plano free. Você ganha uma API que aceita HTML e retorna um `message_id`. O resto é problema seu.

E é exatamente aí que mora o perigo.

## O Problema Fundamental: At-Most-Once vs At-Least-Once

Quando um serviço externo aceita sua requisição, mas o seu processo morre antes de registrar o sucesso, você tem um dilema:

1. **Reenviar**: o assinante pode receber duas vezes (at-least-once)
2. **Não reenviar**: o assinante pode não receber (at-most-once)

Pra transações financeiras, at-least-once com deduplicação é o padrão. Pra email, **at-most-once é preferível**. Ninguém reclama de não receber uma newsletter. Todo mundo reclama de receber duas.

Isso define toda a arquitetura: **na dúvida, não reenvie**.

## Padrão 1: Um Registro Por Destinatário

O erro mais comum em sistemas de newsletter é iterar uma lista de assinantes num loop:

```ruby
# ERRADO — se o job morrer no email 247, re-execução reenvia 1-246
subscribers.each do |sub|
  SesMailer.send(to: sub.email, body: html)
end
```

A solução é criar um registro de entrega **antes** de enviar:

```ruby
# Cria registros em batch
rows = subscriber_ids.map do |id|
  { newsletter_id: newsletter.id, subscriber_id: id, status: "pending" }
end
EmailDelivery.insert_all(rows, unique_by: [:newsletter_id, :subscriber_id])

# Enfileira um job individual por registro
EmailDelivery.where(newsletter: newsletter, status: ["pending", "failed"])
             .find_each do |delivery|
  SendSingleEmailJob.perform_later(delivery.id)
end
```

Cada `EmailDelivery` é uma máquina de estados: `pending → sending → sent`. Se o job morrer, o registro fica em `sending` — e **nunca** é automaticamente reenviado.

O `unique_by` garante idempotência: rodar esse código duas vezes não cria registros duplicados.

## Padrão 2: Claiming Atômico

Dois workers não podem enviar o mesmo email. O claim precisa ser atômico:

```ruby
def claim_for_sending!
  updated = self.class
    .where(id: id, status: %w[pending failed])
    .update_all(
      status: "sending",
      sending_started_at: Time.current,
      send_attempts: Arel.sql("COALESCE(send_attempts, 0) + 1")
    )
  updated == 1  # true se ninguém pegou antes
end
```

Isso é um UPDATE com WHERE — se dois workers tentam ao mesmo tempo, só um consegue o `updated == 1`. O outro recebe `0` e desiste. Sem locks explícitos, sem race conditions.

O `send_attempts` é incrementado atomicamente no banco, não em Ruby. Isso garante a contagem correta, mesmo com concorrência.

## Padrão 3: O Fluxo do SendSingleEmailJob

Aqui está o coração do sistema. O job de envio individual segue uma sequência deliberada:

```ruby
class SendSingleEmailJob < ApplicationJob
  queue_as :mailer

  retry_on Aws::SESV2::Errors::TooManyRequestsException,
           wait: :polynomially_longer, attempts: 8

  def perform(delivery_id)
    ses_accepted = false
    delivery = EmailDelivery.find(delivery_id)

    # 1. Validação: assinante ainda ativo?
    unless subscriber_active?(delivery.subscriber)
      delivery.mark_failed!("Subscriber inactive")
      return
    end

    # 2. Guardrail: nunca reenviar o que já foi
    return if %w[sent unknown bounced].include?(delivery.status)

    # 3. Claim atômico
    return unless delivery.claim_for_sending!

    # 4. Renderiza e envia
    html = render_newsletter(delivery)
    message_id = ses_client.send_email(to: email, body: html)
    ses_accepted = true

    # 5. Marca sucesso
    delivery.mark_sent!(message_id)
  rescue Aws::SESV2::Errors::TooManyRequestsException => e
    # SES rejeitou ANTES de aceitar — seguro retentar
    delivery&.mark_failed!("Rate limited: #{e.message}")
    raise  # ActiveJob retry_on cuida do reagendamento
  rescue StandardError => e
    if ses_accepted
      # SES ACEITOU mas algo quebrou depois — estado ambíguo
      delivery&.mark_unknown!("Uncertain: #{e.message}")
    else
      delivery&.mark_failed!(e.message)
    end
  end
end
```

Presta atenção na variável `ses_accepted`. Ela é o pivô de toda a lógica de erro:

- **SES rejeitou** (`ses_accepted = false`): safe to retry. O email não foi aceito; pode tentar de novo.
- **SES aceitou** (`ses_accepted = true`): estado ambíguo. O email *provavelmente* foi enviado. Marcar como `unknown` e **nunca** retentar automaticamente.

Essa distinção é o que impede a duplicação. A maioria dos sistemas trata tudo como "failed" e re-tenta — o que pode resultar em e-mails duplicados quando o SES aceitou, mas o seu processo crashou antes de registrar.

## Padrão 4: O Guardrail dos Status Imutáveis

Observe a linha:

```ruby
return if %w[sent unknown bounced].include?(delivery.status)
```

Isso não é defensivo à toa. É uma regra de negócio: esses três estados são **terminais**. Uma vez que um delivery chega em `sent`, `unknown` ou `bounced`, nenhum código no sistema pode movê-lo automaticamente de volta pra `pending`.

A única forma de reenviar um email `unknown` é por meio de intervenção manual no console. E é assim que deve ser — se você não tem certeza de que o e-mail foi entregue, a decisão de reenviar é humana, não do sistema.

## Padrão 5: Recuperação de Deliveries Travados

Se o worker crashar com um delivery em `sending`, ele fica preso nesse estado pra sempre. Um job periódico limpa isso:

```ruby
class RecoverStaleDeliveriesJob < ApplicationJob
  STALE_AFTER = 30.minutes

  def perform
    stale = EmailDelivery.where(status: "sending")
                         .where("sending_started_at < ?", STALE_AFTER.ago)

    count = stale.update_all(status: "unknown", sending_started_at: nil)
    notify_team("#{count} stale deliveries moved to unknown") if count > 0
  end
end
```

Por que `unknown` e não `failed`? Por que um delivery em `sending` há 30 minutos pode ter sido aceito pelo SES, mas não registrado? Mover pra `failed` significaria retentar — e, potencialmente, duplicar. `unknown` é o limbo seguro: "não sei o que aconteceu; um humano precisa decidir".

## Padrão 6: Retry Inteligente no SES

SES tem três categorias de erro:

```ruby
# Transitório — SES está ocupado, tente depois
retry_on Aws::SESV2::Errors::TooManyRequestsException,
         wait: :polynomially_longer, attempts: 8
retry_on Aws::SESV2::Errors::LimitExceededException,
         wait: :polynomially_longer, attempts: 5

# Permanente — sua conta ou email tem problema
rescue Aws::SESV2::Errors::MessageRejected => e
  delivery.mark_failed!(e.message)
  # NÃO re-tenta. O SES rejeitou esse email especificamente.

rescue Aws::SESV2::Errors::AccountSuspendedException => e
  delivery.mark_failed!(e.message)
  # Sua conta foi suspensa. Não adianta retentar nada.
```

O `polynomially_longer` é chave: 3s, 18s, 83s, 293s... O backoff polinomial é mais agressivo que o exponencial, o que é bom pro SES — ele quer que você desacelere rápido.

**Nunca** use `retry_on StandardError`. Isso re-tenta erros de programação (nil pointer, método inexistente) que vão falhar eternamente.

## Padrão 7: Tags SES para Rastreabilidade

Cada email enviado carrega tags que permitem correlacionar eventos depois:

```ruby
mailer.send_email(
  to: subscriber.email,
  subject: title,
  html_body: html,
  tags: {
    "NewsletterID" => newsletter.id.to_s,
    "DeliveryID"   => delivery.id.to_s
  }
)
```

Quando o SES notifica um bounce ou um complaint via SNS, o payload inclui essas tags. O reconciliador encontra o `EmailDelivery` correspondente e atualiza o status:

```ruby
def reconcile_event(event)
  delivery = find_by_tag(event, "DeliveryID") ||
             find_by_message_id(event)
  return unless delivery

  case event_type(event)
  when "delivery"  then delivery.mark_sent!(message_id)
  when "bounce"    then delivery.mark_bounced!
  when "complaint" then delivery.mark_bounced!
  when "reject"    then delivery.mark_failed!("SES rejected")
  end
end
```

Isso fecha o loop: mesmo que o delivery tenha ficado como `unknown` porque o worker tenha crashado, o SES notifica eventualmente se entregou ou não. O reconciliador corrige o estado.

## Padrão 8: Configuration Sets para Monitoramento

SES tem um recurso chamado Configuration Sets que é absurdamente subutilizado:

```ruby
params[:configuration_set_name] = ENV["SES_CONFIGURATION_SET"] if configured?
```

O Configuration Set te dá:
- **Delivery events**: notificações de entrega, bounce, complaint via SNS
- **Reputation dashboard**: taxa de bounce e complaint em tempo real
- **Sending statistics**: volume por hora/dia

Sem Configuration Set, você está voando cego. Com ele, sabe exatamente o estado da sua reputação como sender.

A Amazon suspende sua conta se a taxa de bounce passar de 5% ou se as complaints passarem de 0,1%. Com o dashboard, você vê isso acontecendo antes que seja tarde demais.

## Padrão 9: Relatório de Envio Diferido

Não adianta reportar resultado imediatamente após enfileirar. Os jobs ainda estão rodando. O relatório precisa ser **diferido**:

```ruby
# Enfileira relatório 30 minutos depois do envio
SendingReportJob.set(wait: 30.minutes).perform_later(newsletter.id)
```

E o relatório se reagenda se muitos deliveries ainda estão pendentes:

```ruby
def perform(newsletter_id, reschedule_count = 0)
  counts = newsletter.email_deliveries.group(:status).count
  pending_ratio = pending_plus_sending / total.to_f

  if pending_ratio > 0.10 && reschedule_count < 3
    # Mais de 10% ainda em andamento — checa de novo em 15min
    self.class.set(wait: 15.minutes)
        .perform_later(newsletter_id, reschedule_count + 1)
    return
  end

  send_report(counts)
end
```

O relatório final mostra sent/failed/pending/unknown/bounced. Se tem `unknown` > 0, a cor é vermelha — precisa de atenção humana.

## O Sandbox Trap

Uma dor que todo mundo passa e ninguém documenta: o SES começa em modo sandbox. Você só pode enviar para e-mails verificados. Pra sair do sandbox, precisa de um request manual explicando seu caso de uso, volume estimado, e como trata bounces/complaints.

Dicas pra aprovação:

1. **Tenha domínio verificado com DKIM** — não mande de `@gmail.com`
2. **Explique o opt-in duplo** — "assinante confirma email antes de receber"
3. **Mostre tratamento de bounce** — "bounces são automaticamente processados e removidos"
4. **Comece pequeno** — peça 200/dia, escale depois

A Amazon é paranoica em relação à reputação. Mostra que você respeita isso.

## DKIM, SPF, e DMARC: A Trilogia que Mantém Seus E-mails na Inbox

Sem autenticação DNS correta, seus e-mails vão pro spam. Três registros são obrigatórios:

- **SPF**: declara quais servidores podem enviar em nome do seu domínio
- **DKIM**: assinatura criptográfica que prova que o email não foi alterado
- **DMARC**: política que diz o que fazer com emails que falham SPF/DKIM

O SES gera os registros DKIM automaticamente (são 3 CNAMEs). SPF e DMARC você configura manualmente no DNS.

Se você não fizer isso, mesmo o Gmail vai marcar seus e-mails como suspeitos. E o pior: provedores como Microsoft e Yahoo estão cada vez mais agressivos com e-mails sem DMARC.

## Padrão 10: List-Unsubscribe — O Header que o Gmail Exige

Desde fevereiro de 2024, o Gmail tem uma regra dura pra bulk senders (quem manda mais de 5.000 emails/dia pra endereços do Gmail): todo email precisa ter os headers `List-Unsubscribe` e `List-Unsubscribe-Post`. Sem eles, o Gmail **penaliza a reputação do domínio inteiro** — não só os e-mails em massa, mas também os transacionais (como confirmação de cadastro, reset de senha, etc.).

Descobri isso da pior forma: usuários do Gmail não recebiam o e-mail de confirmação de inscrição. DKIM passando, SPF passando, DMARC passando, SES aceitando — tudo verde. Mas o Gmail estava silenciosamente encaminhando para o spam porque a newsletter não tinha `List-Unsubscribe`.

A implementação tem duas partes: o header no email e o endpoint que processa o unsubscribe.

### O Header

Cada email precisa de dois headers — com URL personalizada por assinante:

```ruby
mailer.send_email(
  to: subscriber.email,
  subject: title,
  html_body: html,
  headers: {
    "List-Unsubscribe" => "<https://seudominio.com/unsubscribe?token=#{subscriber.unsubscribe_token}>",
    "List-Unsubscribe-Post" => "List-Unsubscribe=One-Click"
  }
)
```

No SES v2, headers customizados vão no campo `headers` do `simple` content:

```ruby
simple = {
  subject: { data: subject, charset: "UTF-8" },
  body: { html: { ... }, text: { ... } },
  headers: headers.map { |name, value| { name: name.to_s, value: value.to_s } }
}
```

**Atenção**: o link de unsubscribe no **corpo** do email (o que está no footer) não conta. O Gmail exige especificamente o **header HTTP**. São coisas diferentes. Você precisa dos dois.

### O Endpoint RFC 8058

Quando o usuário clica em "Cancelar inscrição" no Gmail, o que acontece não é um GET no browser. O Gmail faz um POST direto pro seu servidor com o body `List-Unsubscribe=One-Click`. Sem cookies, sem CSRF token, sem redirect.

Isso significa que seu controller precisa:

1. **Pular verificação CSRF** pra esse tipo de request
2. **Retornar 200 OK** ao invés de redirect (clients de email não seguem redirects)
3. **Continuar funcionando normalmente** pra unsubscribes via browser

```ruby
class UnsubscriptionsController < ApplicationController
  # RFC 8058: email clients POST sem CSRF token
  skip_forgery_protection only: :destroy, if: :one_click_unsubscribe?

  def destroy
    subscriber = Subscriber.find_by(unsubscribe_token: params[:token])
    subscriber&.unsubscribe! unless subscriber&.unsubscribed?

    if one_click_unsubscribe?
      head :ok  # Gmail espera 200, não redirect
    else
      redirect_to unsubscribe_path(token: params[:token])
    end
  end

  private

  def one_click_unsubscribe?
    params["List-Unsubscribe"] == "One-Click"
  end
end
```

O `skip_forgery_protection` é condicional — só dispara quando o request contém o parâmetro `List-Unsubscribe=One-Click`. Requests normais do browser continuam com proteção CSRF total.

Depois de implementar isso, a reputação do domínio no Gmail leva 1-2 dias pra se recuperar. Os emails de confirmação voltaram a chegar na inbox.

## Padrão 11: A Suppression List Silenciosa do SES

O SES tem uma armadilha que pega muita gente: a **account-level suppression list**. Quando um email dá hard bounce (endereço inexistente) ou gera um complaint (marcou como spam), o SES automaticamente adiciona esse endereço a uma lista interna. A partir daí, toda vez que você manda pra esse endereço, o SES **aceita a requisição, retorna um message_id e, silenciosamente, não entrega**.

Leu de novo: **o SES retorna sucesso, mas não manda**. Seu sistema acha que mandou. O assinante nunca recebe. Nenhum erro, nenhum bounce, nenhum log.

Pra ver quem está na lista:

```bash
aws sesv2 list-suppressed-destinations --output table
```

Pra remover um endereço (por exemplo, depois de corrigir um problema de deliverability):

```bash
aws sesv2 delete-suppressed-destination --email-address "usuario@gmail.com"
```

**Cuidado**: não saia removendo tudo. Se o endereço deu bounce por typo (`usuario@gnail.com` em vez de `@gmail.com`), remover da suppression list só vai gerar outro bounce — e piorar sua taxa de bounce, exatamente o que o SES monitora pra decidir se suspende sua conta.

A regra: só remova endereços que você tenha motivo concreto pra acreditar que são válidos. Typos e endereços abandonados ficam na lista — é o SES que te protege de você mesmo.

## Encriptação de Emails em Repouso

Um detalhe que muitos ignoram: os e-mails dos seus assinantes estão no banco. Se o banco vazar, vazam todos os e-mails. O Rails 8 tem Active Record Encryption nativo:

```ruby
class Subscriber < ApplicationRecord
  encrypts :email, deterministic: true
end
```

O `deterministic: true` é crucial: permite que `find_by(email: "x@y.com")` funcione normalmente, pois o mesmo input sempre gera o mesmo ciphertext. O índice unique continua funcionando. Do ponto de vista da aplicação, nada muda — mas, no banco, os e-mails são cifrados.

As chaves vivem em variáveis de ambiente, não no banco de dados. O banco vazou? Os e-mails são ilegíveis sem as chaves.

## O Custo Total

Pra uma newsletter com 1.000 assinantes enviando 4 edições por mês:

| Item | Custo |
|------|-------|
| SES (4.000 emails) | $0.40/mês |
| Domínio verificado | $0 |
| Configuration Set | $0 |
| SNS notifications | ~$0 (free tier) |
| **Total** | **$0.40/mês** |

Compara com o Mailchimp ($13/mês), o ConvertKit ($15/mês) ou o Buttondown ($9/mês). A diferença é que, com SES, você **construiu** a infraestrutura em vez de alugar. É mais trabalho inicial, mas com zero lock-in e controle total.

## Conclusão

Enviar e-mail confiável não é sobre chamar uma API. É sobre:

- **Registros por destinatário** com claiming atômico
- **Estados terminais** que nunca são revertidos automaticamente
- **Distinção explícita** entre "SES rejeitou" e "SES aceitou mas algo quebrou"
- **Recuperação de estados ambíguos** sempre pra `unknown`, nunca pra `failed`
- **Relatórios diferidos** que se reagendam até ter dados completos
- **Reconciliação via webhooks** que fecha o loop de entrega
- **DNS correto** (DKIM/SPF/DMARC) pra não ir pro spam
- **`List-Unsubscribe` em todo email** — sem ele, Gmail penaliza seu domínio inteiro
- **Consciência da suppression list** — SES pode aceitar e silenciosamente não entregar

A regra de ouro: **na dúvida, não reenvie**. É melhor um assinante não receber uma edição do que receber duas. A reputação do seu domínio — e a paciência dos seus assinantes — dependem disso.

