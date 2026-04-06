# Translation Plan — How to Continue the EN Translation Effort

This file is the self-contained playbook for continuing the Portuguese → English translation work on this blog. It exists so a fresh Claude Code session (after context compaction or in a new conversation) can pick up exactly where we left off without losing context. Read this entire file first before starting.

Related files (read these too):
- `todo.md` — translation status tracker (translated, pending, back-references)
- `WRITER.md` — full translation workflow rules and voice guidance
- `CLAUDE.md` — multilingual architecture overview
- `~/.claude/projects/-mnt-data-Projects-akitaonrails-hugo/memory/feedback_voice_affirmative.md` — Akita's voice rules (avoid negative parallels, prefer affirmative)
- `~/.claude/projects/-mnt-data-Projects-akitaonrails-hugo/memory/feedback_blog_writing.md` — general blog writing rules

---

## TL;DR: per-post workflow

For every new translation, do this exact sequence:

1. **Read the original** PT file (`content/YYYY/MM/DD/<slug>/index.md`) in full.
2. **Add `translationKey: <key>`** to the PT frontmatter. Use a short kebab-case key derived from the topic (e.g. `minisforum-ms-s1-max-review`). Make sure both PT and EN files end up with the SAME `translationKey`.
3. **Create `index.en.md`** in the same directory. This sibling file is how Hugo's i18n knows the two are paired. Frontmatter must include:
   - `title:` translated
   - `date:` IDENTICAL to the PT version (don't bump it, don't reformat it)
   - `draft: false`
   - `slug:` translated kebab-case (e.g. `minisforum-ms-s1-max-amd-ai-max-395-review`) — this is what gives English readers a clean URL instead of a Portuguese one
   - `translationKey:` IDENTICAL to the PT version
   - `tags:` translate any Portuguese tag words (`seguranca` → `security`, `homeserver` stays, `ai` stays, etc.)
   - `description:` translated if present
4. **Translate the body faithfully**. Rules in the next section.
5. **Update internal links** (next section).
6. **Update back-references** in OTHER already-translated posts that link to this one (next section).
7. **Update `todo.md`**: move the entry from "Pending" to "Translated" with the EN slug, and remove the back-reference entry if any.
8. **Regenerate the index** so the new post appears on the EN homepage:
   ```bash
   ruby scripts/generate_index.rb
   ```
9. **Build to verify** there are no Hugo errors:
   ```bash
   hugo --renderSegments recent
   ```
10. **Commit** with a descriptive message. Format used so far:
    ```
    EN translation: <Title>

    <1-2 paragraph summary of what's in the post and what was preserved
    or adapted. Always mention any back-references that were updated in
    other already-translated posts.>

    Co-Authored-By: Claude Opus 4.6 (1M context) <noreply@anthropic.com>
    ```

---

## Translation rules (faithful + Akita's voice in English)

### Faithfulness

- **Never cut, summarize, or rephrase** to make the post shorter. Every paragraph in the PT original must have a corresponding paragraph in the EN translation. Every list item, table row, code block, image, link, footnote.
- **Tables**: translate headers and prose cells, leave numeric/code cells as-is.
- **Frontmatter description / title**: translate naturally, keep the punchy tone.
- **External links**: leave URLs alone. If the link text is Portuguese, translate the link text only.

### Voice — assertive Akita with a New Yorker accent

The English voice is: assertive like Akita's pt-BR, but with a New Yorker tone. Think of someone who reads The New Yorker and Hacker News, makes dry jokes, drops NYC idioms when they fit, never explains a metaphor, and absolutely never sounds like a translation.

- **Punchy and direct**, like the original. Short sentences mixed with longer ones. First-person freely. Opinions stated, not hedged.
- **Dry humor** when the original has it, even if the joke needs to be reworked entirely for the new language.
- **NYC-flavored common phrases when they land naturally**: "the whole nine yards", "that's the ballgame", "for crying out loud", "the elephant in the room", "moving the goalposts", "flat out", "no joke". Only when the original Akita is being equally colloquial. Never forced.
- **Never literal**: Portuguese expressions like "pra que cargas d'água", "tô sem net", "boa sorte com isso", "essa coceira não me larga" must be adapted to English idioms ("what on earth for", "my wifi's down", "good luck with that one", "this itch I can't scratch"), not translated word for word. If you find yourself writing something that sounds like Google Translate, stop and rewrite it.
- **Tech terms** stay in English in both languages (RAG, vector DB, embedding, prompt caching, tool calling, etc.).
- **Akita's signature moves** survive translation: parenthetical asides, the calling-out of marketing claims, the personal anecdotes about his own setup, the "olha" interjection, etc. Find the English-language equivalent of those rhythms.

### Avoid the "It's not A, it's B" pattern

This is Akita's #1 voice rule and it applies to BOTH languages. Do NOT use negative parallels like:

- "memória não é tratada como verdade. É tratada como pista" → "memory is treated as a hint" (drop the "not as truth" setup)
- "isn't context capacity, it's reasoning capacity" → "what separates the two is reasoning capacity"
- "Não é só achismo, é fato" → "Tem fato por trás disso"
- "It's not X, it's Y" / "X é Y, não é Z" → reframe as a direct affirmation of what something IS

Akita is affirmative. If you catch yourself writing one of these patterns, rewrite as a plain affirmation. See `feedback_voice_affirmative.md` in memory for the full rule and rationale.

### Code blocks: only translate `#`/`//` comments

Inside code blocks, only translate the comment lines (the ones starting with `#` for Ruby/bash/Python, or `//` for JS/TS, etc.). Do NOT translate:

- String literals
- Prompt heredocs
- Tool descriptions
- Parameter descriptions
- Error messages
- `puts`/`print`/`echo` strings
- `description`/`desc:` argument values

The reasoning: code is code. An English reader looking at a Ruby example understands the literal strings come from the original program. The intent is documentation/explanation in `#` comments only. The PT examples in past translations preserved Portuguese strings inside code blocks intentionally — keep doing that.

### Internal links

When the original PT post has an internal link to another post on the blog:

1. **If the linked post is already translated** (check the "Translated" table in `todo.md`), rewrite the link to use the EN slug. Example: `/2026/04/06/rag-esta-morto-contexto-longo/` becomes `/en/2026/04/06/rag-is-dead-long-context/`.
2. **If the linked post is NOT translated yet**, leave the link pointing at the PT URL. English readers will land on a Portuguese post (acceptable for now). Don't mark it as broken.
3. After translating, if THIS post was linked to from any other already-translated post (check the "Back-references" section in `todo.md` and the explicit cross-references in the source), open those EN files and update their links to use the new EN slug. Then remove the resolved entry from `todo.md`.

The slug for an EN post is what's in its `slug:` frontmatter field, NOT the directory name. The directory keeps the original Portuguese name on disk, but Hugo's `.RelPermalink` honors the slug override.

### Disqus comments

Each language gets its own Disqus thread automatically because the comments partial uses `{{ $.Page.RelPermalink }}` as the page identifier. Don't change that. PT and EN versions have different URLs, so they get different thread IDs without any extra config.

---

## Hugo + multilingual architecture (so you don't break it)

Don't touch these files unless you understand the multilingual setup:

- `hugo.yaml` — has per-language menus and sidebars in `languages.pt-br` and `languages.en`. The `pt-br` block is the canonical/default. Don't mix them up.
- `layouts/partials/custom/lang-toggle.html` — the PT | EN toggle. Renders on home/archives unconditionally; renders on a single post ONLY if `.IsTranslated` is true (i.e., a sibling `.en.md` exists). Don't touch.
- `layouts/partials/custom/head-end.html` — auto-redirect based on `lang_pref` cookie + browser locale. Don't touch.
- `layouts/_partials/utils/icon.html`, `layouts/_partials/_shortcodes/icon.html`, `layouts/_partials/language-switch.html`, `layouts/_partials/utils/lang-link.html` — local overrides of the vendored Hextra partials that use `hugo.Data` and `hugo.Sites` instead of the deprecated `.Site.Data` and `.Site.Languages`. These exist to silence Hugo 0.156+ deprecation warnings. Don't touch.
- `i18n/pt-br.yaml`, `i18n/en.yaml` — UI strings for menus, footer, 404 page, etc. Add new keys here if a template needs new strings.
- `netlify.toml` — pinned to Hugo 0.159.1 because the icon overrides need `hugo.Data` (added in 0.156). If you bump Hugo locally, update this too.

If `hugo --renderSegments recent` succeeds with no warnings, you're fine.

---

## Where we are right now

As of the last commit on this branch, **9 articles + the about page are translated**. The translated set is listed in `todo.md` under "Translated". It also includes the slug mapping, which is what you use to fix back-references.

### Translation strategy (descending order)

We're working in **descending chronological order** — most recent first — so the front page of `/en/` always has the freshest stuff. The order in `todo.md` "Pending" reflects this. Work top-down through:

1. April 2026 (one post left)
2. March 2026 (in descending date order)
3. February 2026 (descending)
4. January 2026 (descending)

Older years (2006-2025) are out of scope for now. The blog used to be mixed PT/EN in the early years, so some 200x posts are already in English on disk — leave them alone for now.

### Recommended next batch

After the most recent four "back-reference closing" translations (Minisforum, home server, FrankClaw, 37 days), the descending order resumes. The next obvious batches:

1. **`2026/04/05/transformando-youtube-num-app-de-karaoke-frank-karaoke`** — last remaining April 2026 post.
2. **March 2026 in descending date order**, starting from `2026/03/27/ensinando-a-questionar-noticias-frank-investigator` and working backward.
3. **February 2026 in descending order**, starting with `2026/02/24/rant-o-akita-abriu-as-pernas-pra-ia`.
4. **January 2026 in descending order**, ending with `2026/01/11/ai-agents-comparando-as-principais-llm-no-desafio-de-zig` (which was the very first post we touched chronologically — it has a `translationKey` already added if you peek at the frontmatter, but no EN sibling yet, so the orphan key will need cleanup OR a real EN translation to land).

Look at `todo.md` for the live list. Always re-read it before picking the next post.

### Before each translation: scan for cross-references

Before starting a new translation, search the existing EN versions for any link that points at the post you're about to translate. If you find one, you'll need to update it after the translation lands. Quick check:

```bash
grep -lE "<pt-slug>" content/2026/*/*/*/*.en.md content/about.en.md
```

Where `<pt-slug>` is the directory name of the post you're about to translate. If anything matches, note it down so you remember to update those files at the end.

Also search the post you're translating for links pointing at other 2026 posts — those will need to be either rewritten to EN slugs (if the target is already translated) or left as PT (if it's not yet, and added to `todo.md` "Back-references to fix" so the next session knows to come back).

---

## After every translation: post-flight checklist

- [ ] EN file exists at `<original_dir>/index.en.md`
- [ ] PT file has matching `translationKey:`
- [ ] EN file has `slug:`, `translationKey:`, same `date:`, translated `title:` and `description:`
- [ ] Translated tags
- [ ] All internal links to already-translated posts use EN slugs
- [ ] Back-references in other EN files updated (if any)
- [ ] `todo.md` updated (moved from Pending → Translated)
- [ ] `ruby scripts/generate_index.rb` run
- [ ] `hugo --renderSegments recent` builds with no warnings or errors
- [ ] Single commit with a descriptive message

---

## Common gotchas

- **Don't bump the date.** EN translations keep the exact PT publication timestamp. They're not new posts, they're translations.
- **Don't rename the directory.** The PT directory name stays in Portuguese forever. Only the URL is translated, via the `slug:` override in `index.en.md`.
- **Don't `slug:` the PT file.** The PT file's URL is determined by the directory name (or its existing `slug:` if it had one before). Adding a slug now would change the canonical URL and break old inbound links.
- **Don't translate code identifiers** (class names, method names, gem names, function names, environment variables). Only translate the human-readable comments and the prose around the code.
- **Don't translate frontmatter `tags` that are already in English** like `ai`, `claude-code`, `vibe-coding`, `homeserver`, `docker`, `rust`, `llm`. Only translate Portuguese tags.
- **Don't change `draft:` to `true`.** The PT post is published; the EN translation should be published the moment it's committed.
- **Don't leave Portuguese in a place an English reader will see**, except for proper nouns (people's names, project names, the title of the original PT post when cited from the EN bibliography).
- **The "description" frontmatter field** is what shows up in social sharing previews. Translate it if it exists.
- **Internal links to /tags/** can stay as Portuguese tag URLs (`/tags/vibecoding/`). The tag pages are listed in pt-br but they still resolve, and there's no EN tag system yet.
- **`Open3.capture2` returning `[output, status]`** is correct Ruby syntax — don't "fix" the underscore.

---

## Voice quick-reference

When in doubt about whether the translated prose sounds like Akita-in-English, ask yourself:

1. Would I read this on Hacker News and assume the author is a real person, not a translation?
2. Does it have at least one opinion stated as a fact, not hedged?
3. Did I avoid the "not X, but Y" pattern?
4. Is the rhythm varied (mixing short punchy sentences with longer, looser ones)?
5. Did I keep the parenthetical asides and personal anecdotes?
6. Did I use NYC idioms only where the original was being colloquial in pt-BR?

If all six pass, ship it. If any fails, rewrite that paragraph.

---

## After finishing all 2026 translations

Once `todo.md` "Pending" is empty for 2026, the immediate translation effort is done. Update `todo.md` to reflect that, and consider whether to:

1. Pause and let the user decide what to do next.
2. Start translating posts from earlier years on demand.
3. Add a translation workflow for new PT posts (every time a new PT post is published, translate it the same day).

Don't auto-decide — ask the user first.
