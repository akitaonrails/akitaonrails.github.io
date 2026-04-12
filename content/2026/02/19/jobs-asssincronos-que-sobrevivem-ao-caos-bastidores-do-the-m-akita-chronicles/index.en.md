---
title: "Async Jobs That Survive Chaos | Behind the Scenes of The M.Akita Chronicles"
slug: "async-jobs-that-survive-chaos-behind-the-m-akita-chronicles"
date: 2026-02-19T01:10:08+00:00
draft: false
tags:
- themakitachronicles
- rubyonrails
- activejob
  - AI
translationKey: async-jobs-chaos-survival
description: "Production-grade patterns for Rails 8 ActiveJob and SolidQueue: retries, distributed locks, atomic email claiming, orchestrators, cron safety nets, and status notifications."
---

This post is part of a series; follow along through the tag [/themakitachronicles](/en/tags/themakitachronicles/). This is part 5.

And make sure to subscribe to my new newsletter [The M.Akita Chronicles](https://themakitachronicles.com/)!

--

Let me be blunt: most developers treat background jobs as if they were scripts that run once and that's it. "Ah, throw it in a Sidekiq and we're good." No, **we're not good**. Jobs that handle important things — sending emails, publishing content, calling external APIs — need to be treated as first-class citizens in your architecture.

In this post I'll show how Rails 8 with ActiveJob and SolidQueue changed my perspective on async processing. This is not theory — these are patterns that emerged from a real system running in production every week.

## The Problem: Jobs Are Fragile by Nature

Picture the scenario: you have a job that assembles a newsletter, publishes it on a blog through the GitHub API, waits for a podcast to be ready, and then fires off emails to hundreds of subscribers. Any step can fail. The API can time out. The podcast can take longer than expected. The server can restart in the middle of the delivery.

If you treat this as a linear script, you're going to suffer. The right question is not "how do I make this job run?" — it's **"how do I make this job recover when something goes wrong?"**

## Pattern 1: retry_on With Specific Exceptions

ActiveJob's `retry_on` is absurdly powerful, but most people use it wrong. Look at the classic anti-pattern:

```ruby
class MeuJob < ApplicationJob
  retry_on StandardError, wait: 5.seconds, attempts: 3
end
```

This retries **any** error 3 times and gives up. It's useless for almost anything in the real world. The pattern that actually works is to create specific exceptions for transient states:

```ruby
class PodcastNotReady < StandardError; end

class PublishAndSendJob < ApplicationJob
  retry_on PodcastNotReady, wait: 15.minutes, attempts: 16

  def perform(newsletter_id)
    metadata = check_podcast_metadata(newsletter_id)
    raise PodcastNotReady, "Aguardando podcast" unless metadata
    # keep working...
  end
end
```

See what's happening? The job waits up to **4 hours** (15min × 16) for the podcast to be ready, polling every 15 minutes. This is not an infinite loop — it has a clear limit. And when it hits that limit, you handle the timeout explicitly:

```ruby
rescue PodcastNotReady => e
  if executions >= 16
    # Publish without podcast and notify the team
    publish_without_podcast(newsletter)
    notify_team("Podcast não ficou pronto a tempo")
  else
    raise # re-raise so SolidQueue schedules the next retry
  end
end
```

This is **graceful degradation**. The system doesn't stop because one component failed — it adapts and keeps going.

## Pattern 2: Distributed Locks

When you have multiple paths that can trigger the same job (a safety cron, a manual trigger, an API), you need to make sure only one instance runs at a time.

The concept is simple: a file-based (or database-based) lock that expires automatically:

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

With SQLite, this is trivial — no Redis, no external coordination. The lock has a TTL so it doesn't hang forever if the process dies. And the `ensure` guarantees it releases even if the block raises an exception.

## Pattern 3: Atomic Email Delivery

This is where most newsletter systems fail spectacularly. The scenario: you're sending 500 emails and the server restarts on email 247. What happens when the job re-runs?

If you just iterated a list, you're going to resend the first 247. Your subscribers will love getting the newsletter twice.

The solution is **atomic claiming** per recipient:

```ruby
# Before sending, create a record per subscriber
subscribers.each do |sub|
  EmailDelivery.create!(
    newsletter: newsletter,
    subscriber: sub,
    status: "pending"
  )
end

# At send time, do an atomic claim
delivery = EmailDelivery
  .where(status: ["pending", "failed"])
  .lock
  .first

delivery.update!(status: "sending")
send_email(delivery)
delivery.update!(status: "sent")
```

If the server dies between `sending` and `sent`, the record stays as "sending" — and a recovery job (`RecoverStaleDeliveriesJob`) periodically moves those records to "unknown" after a timeout, so they never get automatically resent. Ambiguous emails are **never** resent automatically. That's the kind of detail that separates a hobby system from a production system.

## Pattern 4: Orchestrator Jobs

A common mistake is cramming too much logic into a single job. The pattern that works is having **orchestrator jobs** that delegate to specialized jobs:

```
PublishAndSendJob (orchestrator)
  ├── Waits for podcast (retry_on PodcastNotReady)
  ├── PublishToBlogJob.publish(newsletter)
  └── SendNewsletterJob.perform_now(newsletter.id)
        └── SendSingleEmailJob (per subscriber)
```

The orchestrator coordinates the sequence. Each specialized job knows how to do exactly one thing and can be re-executed independently. If email sending fails, you can retrigger just the `SendNewsletterJob` without republishing the blog.

## Pattern 5: Safety Nets With Cron

Don't trust a single execution chain. SolidQueue's cron (`config/recurring.yml`) acts as a safety net:

```yaml
send_newsletter:
  class: SendNewsletterJob
  schedule: "0 12 * * 1"  # Monday 9am BRT (UTC-3)
```

If the 7am `PublishAndSendJob` failed catastrophically, the 9am cron fires the `SendNewsletterJob` as a fallback. The job checks whether the newsletter has already been sent and no-ops if so. **Idempotency** is the keyword here — the job can run as many times as you want and the result is always the same.

But watch out for the inverse: a job that reschedules itself infinitely when it finds no work is a ticking time bomb. If the job doesn't find a ready newsletter, it simply returns. The cron handles trying again the next week.

## Pattern 6: Status Notifications

Every long-running job should communicate its progress. A simple concern handles it:

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

Each job includes the concern and calls `notify_start` at the beginning, `notify_done` on success, `notify_error` on rescue. When something goes wrong at 3am, you wake up and see exactly where it stopped — no digging through logs required.

## SolidQueue: The End of Redis Dependency

A note on SolidQueue, which ships as default in Rails 8: using the same SQLite database for jobs and application data **drastically** simplifies operations. No need for a separate Redis running. No need to worry about Redis restarting and losing jobs that were in memory.

Jobs are persisted in the database. If the server restarts, they're there waiting. The retry state is preserved. It's absurdly simpler than the alternative, and for 99% of cases, the performance is more than enough.

## Conclusion

Rails 8 with ActiveJob and SolidQueue didn't invent anything revolutionary. What it did was make it ridiculously easy to implement patterns that used to require heavy infrastructure:

- **retry_on** with specific exceptions and clear limits
- **Distributed locks** with automatic TTL
- **Atomic claiming** for operations that can't duplicate
- **Orchestrator jobs** that delegate and recover
- **Safety crons** as fallback
- **Notifications** for operational visibility

None of these patterns is complicated on its own. Put them together, though, and that's what makes the difference between a system that breaks at the first failure and one that holds up in production — and lets you sleep peacefully on Monday.
