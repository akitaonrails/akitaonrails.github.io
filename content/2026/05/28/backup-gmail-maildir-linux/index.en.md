---
title: "Backing Up Gmail to Maildir on Linux"
slug: "backing-up-gmail-to-maildir-on-linux"
date: '2026-05-28T16:00:00-03:00'
draft: false
translationKey: backup-gmail-maildir-linux
description: "I replaced manual Thunderbird backups with mbsync in pull mode, Maildir, and a systemd timer. Restic replicates the archive to NAS and off-site storage, keeping emails local, open, and accessible to multiple clients."
tags:
- storage-and-backup
- linux
- automation
---

Most people just trust Google and leave everything there. Anyone who follows this blog knows I don't trust anyone: if it's in the cloud, it's not mine. That's why I keep a NAS at home to back up everything that matters. I don't trust Google Drive, OneDrive, Dropbox, or Gmail.

Email has always been the most annoying piece of this puzzle. My old workflow was to open Thunderbird, let it pull everything from Gmail over IMAP, and back up the `~/.thunderbird` directory. Works, but it's manual, tedious (remembering to open Thunderbird every so often), and locked to Thunderbird itself: if I want to read those emails in another client, they're sitting in some proprietary internal format.

After a while it clicked: Linux has had native email support forever. The modern protocols (IMAP, SMTP) are open standards. And the local storage format, **Maildir**, has been around and working well since the 90s. Thunderbird isn't needed for any of this.

## What is Maildir

Maildir was created by Daniel J. Bernstein (djb) as part of qmail in 1995. The idea was to fix the file-locking pain of the mbox format, where the entire mailbox is a single file and two processes writing at the same time could corrupt the whole thing. In Maildir, **each message becomes a separate file** inside a three-subdirectory structure:

- `tmp/` — where the email is written while being delivered
- `new/` — newly arrived messages, not yet seen
- `cur/` — messages the client has already seen, with flags encoded in the filename (`:2,S` = seen, `:2,F` = flagged, etc.)

Delivery is atomic: the MTA writes the message into `tmp/`, then does a `rename()` into `new/`. `rename()` on a POSIX filesystem is atomic, so there's no corruption window. No locking, no corruption, and every email is just a plain-text file you can read with `cat`, index with `grep`, or version with git if you feel like it.

Thirty years later, it's still the default local format for most Linux email clients. And it's the format I'll use to mirror Gmail.

## The tool: mbsync (isync)

The bridge between Gmail's IMAP and the local Maildir is [`mbsync`](https://isync.sourceforge.io/), the binary in the `isync` package. It reads a simple config (`~/.config/isyncrc`), connects to Gmail's IMAP, and copies the messages to disk. What makes it different from `offlineimap` (the better-known alternative) is that `mbsync` is written in C, it's significantly faster on large mailboxes, and it has fewer weird edge cases with Gmail.

The config is straightforward. Here's a sketch of what my `~/.config/isyncrc` looks like (no password, obviously):

```ini
IMAPAccount my-account
Host imap.gmail.com
User you@example.com
PassCmd "/home/akitaonrails/.config/mbsync/bin/mbsync-password you@example.com"
TLSType IMAPS
CertificateFile /etc/ssl/certs/ca-certificates.crt
AuthMechs LOGIN

IMAPStore my-remote
Account my-account

MaildirStore my-local
SubFolders Verbatim
Path ~/.local/share/mail/mbsync/you.example.com/
Inbox ~/.local/share/mail/mbsync/you.example.com/INBOX

Channel my-backup
Far :my-remote:
Near :my-local:
Patterns * !"[Gmail]/Trash" !"[Gmail]/Spam" !"[Gmail]/Drafts"
Create Near
Sync Pull New Flags
Expunge None
Remove None
```

Three things worth flagging in that config:

1. **`Sync Pull`**: only pulls from the server to local. Nothing I do in the Maildir propagates back to Gmail. That's accident protection (if I delete a file locally, it doesn't disappear from Gmail).
2. **`Expunge None` + `Remove None`**: if a message disappears from Gmail (someone deleted it or Google decided to move it nowhere), it **stays** in my Maildir. The backup accumulates history, it doesn't mirror the current state.
3. **`PassCmd` instead of a plaintext password**: the password goes through a script that does `secret-tool lookup` against the desktop keyring. No password sitting in a config file on disk.

### The password block

The `mbsync-password` script is a tiny wrapper that isolates the secret:

```bash
#!/usr/bin/env bash
set -euo pipefail
account="${1:?usage: mbsync-password ACCOUNT}"
password="$(secret-tool lookup service mbsync account "$account" 2>/dev/null || true)"
[ -z "$password" ] && { echo "missing keyring secret for $account" >&2; exit 1; }
printf '%s' "$password"
```

The password gets stored once with `secret-tool store --label="mbsync gmail" service mbsync account you@example.com`. Modern Gmail requires a specific **app password** (16 characters, generated at [myaccount.google.com/apppasswords](https://myaccount.google.com/apppasswords)) because it no longer accepts plain basic auth — you don't paste your Google password there, you paste a key generated exclusively for the app, revocable any time without touching the rest of your account.

### Automation with a systemd user timer

To avoid running mbsync by hand, I set up two systemd user units. First the service, which is just a call to the wrapper script:

```ini
# ~/.config/systemd/user/mbsync-backup.service
[Unit]
Description=Mirror Gmail accounts locally with mbsync
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=%h/.config/mbsync/bin/mbsync-run
```

And the timer that fires the service periodically:

```ini
# ~/.config/systemd/user/mbsync-backup.timer
[Unit]
Description=Run mbsync periodically

[Timer]
OnBootSec=10m
OnUnitActiveSec=30m
Persistent=true
Unit=mbsync-backup.service

[Install]
WantedBy=timers.target
```

`OnBootSec=10m` waits 10 minutes after boot before the first run (avoids fighting with `network-online` early in the session). `OnUnitActiveSec=30m` refires 30 minutes after each run completes. `Persistent=true` makes the timer catch up: if the machine was off when it would've fired, it runs at the next boot instead of skipping. The wrapper itself grabs `flock` so two mbsync runs never overlap, so if a sync ever takes longer than 30 minutes the next one just waits. Everything logs to `~/.local/state/mbsync/mbsync.log`.

To manage the timer, the basic commands:

```bash
# Re-read the unit files after creating/editing
systemctl --user daemon-reload

# Start now + enable for the next boot
systemctl --user enable --now mbsync-backup.timer

# Check whether the timer is active and when it fires next
systemctl --user status mbsync-backup.timer
systemctl --user list-timers mbsync-backup.timer

# Trigger an immediate sync without waiting for the interval
systemctl --user start mbsync-backup.service

# Tail the logs in real time
journalctl --user -u mbsync-backup.service -f

# Inspect the status of the last service run
systemctl --user status mbsync-backup.service

# To shut the whole thing down
systemctl --user disable --now mbsync-backup.timer
```

For the timer to keep running when you're not logged in (handy on a desktop that stays up 24/7), enable linger once: `sudo loginctl enable-linger $USER`. Without that, user units only run while you have an active session.

Enable it, check the status once to make sure it's green, and forget it exists.

## Backing up the Maildir with restic

Now that Gmail is mirrored under `~/.local/share/mail/`, it rides into the same backup pipeline as the rest of my home directory. I use [restic](https://restic.net/) to push encrypted snapshots to the NAS. Restic is incremental via content-addressable storage, so adding 100MB of email to today's snapshot costs basically the delta, not the full 100MB every time. For the off-site copy, my Synology NAS already has the Glacier Backup package built in, which handles pushing encrypted snapshots to AWS Glacier without me having to configure anything beyond the bucket and the key. The Maildir rides along on the same plan, so the off-site backup is essentially free in terms of extra configuration.

Maildir is friendly to incremental backup by construction: every email is an immutable file (the filename doesn't even change after download, except for the seen/flagged flag bit). Restic dedups perfectly. A 5GB mailbox snapshot has near-zero marginal cost after the first one.

## The open-format upside: many clients

Here's the part that sealed it for me. Maildir is an open standard, so **any client that speaks Maildir reads the same backup**. I can:

- Open it in [mutt](http://www.mutt.org/) or [neomutt](https://neomutt.org/) when I want something quick in the terminal.
- Open it in [aerc](https://aerc-mail.org/) when I want a more modern TUI.
- Point Thunderbird or [Claws Mail](https://www.claws-mail.org/) at `~/.local/share/mail/...` when I want a GUI.
- Migrate to a different client down the road without an export/import dance.

The emails are mine. They live on my disk. In a plain text format, readable by anything.

## Bonus: scripts and bots read directly

A less obvious consequence: if I want to build a filter, a bot, a classifier, or anything that touches the emails, I **don't need to go through Gmail OAuth, create a Google Cloud project, manage refresh tokens, deal with quotas** — none of it. I just read the Maildir.

Python has native Maildir support in the standard library's `mailbox` module. A trivial example to list subjects from the inbox:

```python
import mailbox
from email.header import decode_header

inbox = mailbox.Maildir("/home/akitaonrails/.local/share/mail/mbsync/you.example.com/INBOX")

for key, msg in inbox.iteritems():
    subject = msg.get("Subject", "")
    sender = msg.get("From", "")
    # decode_header handles Subject in UTF-8 / latin-1 / etc
    decoded = "".join(
        part.decode(enc or "utf-8") if isinstance(part, bytes) else part
        for part, enc in decode_header(subject)
    )
    print(f"{sender[:40]:<40}  {decoded[:60]}")
```

Runs in milliseconds, consumes zero API quota, has no rate limit, never needs a credential refresh. It's just file reads. If you want to build something more serious (attachment parsing, LLM-based classification, automated rules), the same principle holds.

## Summary

The combination that finally let me relax about this:

- **mbsync** (isync) pulls from Gmail's IMAP into a local Maildir, automatically via a systemd timer.
- **Maildir** keeps the open format, one file per email, pull-only protects against accidental deletion.
- **restic** snapshots the Maildir to the NAS with ridiculous deduplication, and Synology's Glacier Backup carries that off-site as an encrypted copy.
- **Free choice of mail client** — mutt, neomutt, aerc, Thunderbird, Claws, anything reads it.
- **Light automation** — bot or script reads straight off disk, no OAuth, no API.

Gmail becomes just a convenient web interface for reading and replying. The real ownership of the emails sits on my disk, replicated to the NAS, replicated to an encrypted off-site backup. If Google shuts my account down tomorrow (it's happened to people), I lose the interface but keep the entire history. For me, this is the definitive way to handle it. Recommended.
