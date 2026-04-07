---
title: "Sending Emails Without Getting Flagged as Spam | Behind The M.Akita Chronicles"
slug: "sending-emails-without-getting-flagged-as-spam-behind-the-m-akita-chronicles"
date: 2026-02-17T20:59:48+00:00
draft: false
tags:
- themakitachronicles
- vibecode
- rubyonrails
- amazon
- ses
- email
translationKey: sending-emails-without-spam
description: "How to build a reliable newsletter sending pipeline on Amazon SES, covering atomic claiming, terminal states, DKIM/SPF/DMARC, List-Unsubscribe and the silent SES suppression list."
---

This post is part of a series; follow along via the tag [/themakitachronicles](/tags/themakitachronicles). This is part 1.

And make sure to subscribe to my new newsletter [The M.Akita Chronicles](https://themakitachronicles.com/)!

--

Sending emails looks trivial. Call an API, pass the HTML, send it. Done. Until the day you discover you sent the same newsletter twice to 300 people. Or that 50 emails bounced back and Amazon suspended your account. Or that your server restarted in the middle of a send and now you have no idea who got it and who didn't.

Amazon SES is efficient — and brutally unforgiving with anyone who doesn't treat every send as an operation that can fail in five different ways. In this post I'll show the patterns that turn "sending email" into "sending email reliably".

## Why SES and Not Sendgrid/Mailgun/Resend?

Price. Period. SES charges $0.10 per thousand emails. Sendgrid charges $20/month for 50 thousand. For a small newsletter, both are cheap. But SES scales without changing plans — and since I'm already on AWS for S3, I don't need yet another vendor.

The downside? SES is low-level. There's no pretty drag-and-drop interface, no integrated analytics, no dedicated IP on the free plan. You get an API that accepts HTML and returns a `message_id`. The rest is your problem.

And that's exactly where the danger lives.

## The Fundamental Problem: At-Most-Once vs At-Least-Once

When an external service accepts your request, but your process dies before recording the success, you have a dilemma:

1. **Resend**: the subscriber may receive it twice (at-least-once)
2. **Don't resend**: the subscriber may not receive it at all (at-most-once)

For financial transactions, at-least-once with deduplication is the standard. For email, **at-most-once is preferable**. Nobody complains about not receiving a newsletter. Everybody complains about receiving two.

This defines the whole architecture: **when in doubt, don't resend**.

## Pattern 1: One Record Per Recipient

The most common mistake in newsletter systems is iterating over a list of subscribers in a loop:

```ruby
# ERRADO — se o job morrer no email 247, re-execução reenvia 1-246
subscribers.each do |sub|
  SesMailer.send(to: sub.email, body: html)
end
```

The solution is to create a delivery record **before** sending:

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

Each `EmailDelivery` is a state machine: `pending → sending → sent`. If the job dies, the record stays in `sending` — and is **never** automatically resent.

The `unique_by` guarantees idempotency: running this code twice doesn't create duplicate records.

## Pattern 2: Atomic Claiming

Two workers can't send the same email. The claim needs to be atomic:

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

This is an UPDATE with a WHERE — if two workers try at the same time, only one gets the `updated == 1`. The other gets `0` and gives up. No explicit locks, no race conditions.

The `send_attempts` is incremented atomically in the database, not in Ruby. That guarantees the correct count, even under concurrency.

## Pattern 3: The SendSingleEmailJob Flow

Here's the heart of the system. The individual send job follows a deliberate sequence:

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

Pay attention to the `ses_accepted` variable. It's the pivot of all the error logic:

- **SES rejected** (`ses_accepted = false`): safe to retry. The email wasn't accepted; you can try again.
- **SES accepted** (`ses_accepted = true`): ambiguous state. The email was *probably* sent. Mark as `unknown` and **never** retry automatically.

This distinction is what prevents duplication. Most systems treat everything as "failed" and retry — which can result in duplicated emails when SES accepted but your process crashed before recording it.

## Pattern 4: The Immutable Status Guardrail

Look at this line:

```ruby
return if %w[sent unknown bounced].include?(delivery.status)
```

This isn't defensive for no reason. It's a business rule: those three states are **terminal**. Once a delivery reaches `sent`, `unknown` or `bounced`, no code in the system can automatically move it back to `pending`.

The only way to resend an `unknown` email is through manual intervention in the console. And that's how it should be — if you're not sure the email was delivered, the decision to resend belongs to a human, not to the system.

## Pattern 5: Recovering Stuck Deliveries

If the worker crashes with a delivery in `sending`, it stays stuck in that state forever. A periodic job cleans this up:

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

Why `unknown` and not `failed`? Because a delivery that's been in `sending` for 30 minutes may have been accepted by SES but not recorded. Moving it to `failed` would mean retrying — and potentially duplicating. `unknown` is the safe limbo: "I don't know what happened; a human needs to decide".

## Pattern 6: Smart Retry on SES

SES has three categories of errors:

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

The `polynomially_longer` is key: 3s, 18s, 83s, 293s... Polynomial backoff is more aggressive than exponential, which is good for SES — it wants you to slow down fast.

**Never** use `retry_on StandardError`. That retries programming errors (nil pointer, nonexistent method) that will fail forever.

## Pattern 7: SES Tags for Traceability

Every email sent carries tags that let you correlate events later:

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

When SES notifies a bounce or complaint via SNS, the payload includes these tags. The reconciler finds the matching `EmailDelivery` and updates the status:

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

This closes the loop: even if the delivery stayed as `unknown` because the worker crashed, SES eventually notifies whether it delivered or not. The reconciler fixes the state.

## Pattern 8: Configuration Sets for Monitoring

SES has a feature called Configuration Sets that's absurdly underused:

```ruby
params[:configuration_set_name] = ENV["SES_CONFIGURATION_SET"] if configured?
```

Configuration Sets give you:
- **Delivery events**: delivery, bounce, complaint notifications via SNS
- **Reputation dashboard**: real-time bounce and complaint rate
- **Sending statistics**: volume per hour/day

Without a Configuration Set, you're flying blind. With it, you know exactly the state of your sender reputation.

Amazon suspends your account if the bounce rate goes over 5% or complaints pass 0.1%. With the dashboard you can see this happening before it's too late.

## Pattern 9: Deferred Sending Report

It's no use reporting results right after enqueuing. The jobs are still running. The report needs to be **deferred**:

```ruby
# Enfileira relatório 30 minutos depois do envio
SendingReportJob.set(wait: 30.minutes).perform_later(newsletter.id)
```

And the report reschedules itself if many deliveries are still pending:

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

The final report shows sent/failed/pending/unknown/bounced. If `unknown` > 0, the color is red — it needs human attention.

## The Sandbox Trap

A pain everyone goes through and nobody documents: SES starts in sandbox mode. You can only send to verified emails. To leave the sandbox you need a manual request explaining your use case, estimated volume, and how you handle bounces/complaints.

Tips for approval:

1. **Have a verified domain with DKIM** — don't send from `@gmail.com`
2. **Explain double opt-in** — "subscriber confirms email before receiving"
3. **Show bounce handling** — "bounces are automatically processed and removed"
4. **Start small** — ask for 200/day, scale later

Amazon is paranoid about reputation. Show them you respect that.

## DKIM, SPF, and DMARC: The Trilogy That Keeps Your Emails in the Inbox

Without correct DNS authentication, your emails go to spam. Three records are mandatory:

- **SPF**: declares which servers are allowed to send on behalf of your domain
- **DKIM**: cryptographic signature proving the email wasn't altered
- **DMARC**: policy saying what to do with emails that fail SPF/DKIM

SES generates the DKIM records automatically (three CNAMEs). SPF and DMARC you configure manually in DNS.

If you don't do this, even Gmail will mark your emails as suspicious. And worse: providers like Microsoft and Yahoo are getting more and more aggressive with emails without DMARC.

## Pattern 10: List-Unsubscribe — The Header Gmail Demands

Since February 2024, Gmail has a hard rule for bulk senders (anyone sending more than 5,000 emails/day to Gmail addresses): every email needs the `List-Unsubscribe` and `List-Unsubscribe-Post` headers. Without them, Gmail **penalizes the reputation of your entire domain** — not just the bulk emails, but also transactional ones (like signup confirmation, password reset, etc.).

I found this out the hard way: Gmail users weren't receiving the subscription confirmation email. DKIM passing, SPF passing, DMARC passing, SES accepting — all green. But Gmail was silently routing to spam because the newsletter didn't have `List-Unsubscribe`.

The implementation has two parts: the header in the email and the endpoint that processes the unsubscribe.

### The Header

Each email needs two headers — with a URL personalized per subscriber:

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

In SES v2, custom headers go in the `headers` field of the `simple` content:

```ruby
simple = {
  subject: { data: subject, charset: "UTF-8" },
  body: { html: { ... }, text: { ... } },
  headers: headers.map { |name, value| { name: name.to_s, value: value.to_s } }
}
```

**Watch out**: the unsubscribe link in the **body** of the email (the one in the footer) doesn't count. Gmail specifically requires the **HTTP header**. These are different things. You need both.

### The RFC 8058 Endpoint

When the user clicks "Unsubscribe" in Gmail, what happens isn't a GET in the browser. Gmail makes a POST directly to your server with the body `List-Unsubscribe=One-Click`. No cookies, no CSRF token, no redirect.

That means your controller needs to:

1. **Skip CSRF verification** for that kind of request
2. **Return 200 OK** instead of a redirect (email clients don't follow redirects)
3. **Keep working normally** for unsubscribes via browser

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

The `skip_forgery_protection` is conditional — it only triggers when the request contains the `List-Unsubscribe=One-Click` parameter. Regular browser requests still have full CSRF protection.

After implementing this, the domain reputation at Gmail takes 1-2 days to recover. The confirmation emails started arriving in the inbox again.

## Pattern 11: The Silent SES Suppression List

SES has a trap that catches a lot of people: the **account-level suppression list**. When an email hard bounces (nonexistent address) or generates a complaint (marked as spam), SES automatically adds that address to an internal list. From that point on, every time you send to that address, SES **accepts the request, returns a message_id, and silently doesn't deliver**.

Read it again: **SES returns success, but doesn't send**. Your system thinks it was sent. The subscriber never receives it. No error, no bounce, no log.

To see who's on the list:

```bash
aws sesv2 list-suppressed-destinations --output table
```

To remove an address (for example, after fixing a deliverability issue):

```bash
aws sesv2 delete-suppressed-destination --email-address "usuario@gmail.com"
```

**Careful**: don't go removing everything. If the address bounced because of a typo (`usuario@gnail.com` instead of `@gmail.com`), removing it from the suppression list will just generate another bounce — and worsen your bounce rate, exactly what SES monitors to decide whether to suspend your account.

The rule: only remove addresses you have concrete reason to believe are valid. Typos and abandoned addresses stay on the list — SES is protecting you from yourself.

## Encrypting Emails at Rest

A detail many ignore: your subscribers' emails are in the database. If the database leaks, all the emails leak. Rails 8 has native Active Record Encryption:

```ruby
class Subscriber < ApplicationRecord
  encrypts :email, deterministic: true
end
```

The `deterministic: true` is crucial: it lets `find_by(email: "x@y.com")` work normally, because the same input always produces the same ciphertext. The unique index keeps working. From the application's point of view, nothing changes — but in the database, the emails are encrypted.

The keys live in environment variables, not in the database. The database leaked? The emails are unreadable without the keys.

## The Total Cost

For a newsletter with 1,000 subscribers sending 4 editions per month:

| Item | Cost |
|------|------|
| SES (4,000 emails) | $0.40/month |
| Verified domain | $0 |
| Configuration Set | $0 |
| SNS notifications | ~$0 (free tier) |
| **Total** | **$0.40/month** |

Compare that to Mailchimp ($13/month), ConvertKit ($15/month) or Buttondown ($9/month). The difference is that, with SES, you **built** the infrastructure instead of renting it. It's more upfront work, but with zero lock-in and total control.

## Conclusion

Sending reliable email isn't about calling an API. It's about:

- **Per-recipient records** with atomic claiming
- **Terminal states** that are never automatically reverted
- **Explicit distinction** between "SES rejected" and "SES accepted but something broke"
- **Recovery of ambiguous states** always to `unknown`, never to `failed`
- **Deferred reports** that reschedule themselves until they have complete data
- **Webhook reconciliation** that closes the delivery loop
- **Correct DNS** (DKIM/SPF/DMARC) so you don't go to spam
- **`List-Unsubscribe` on every email** — without it, Gmail penalizes your entire domain
- **Awareness of the suppression list** — SES may accept and silently not deliver

The golden rule: **when in doubt, don't resend**. Better for a subscriber to miss one edition than to receive two. Your domain reputation — and your subscribers' patience — depend on it.
