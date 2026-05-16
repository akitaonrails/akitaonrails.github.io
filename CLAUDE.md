# CLAUDE.md — Blog Nextside

Este arquivo orienta o Claude Code (claude.ai/code) ao trabalhar neste repo.

## O que é este repo

Blog técnico e editorial da Nextside, hospedado em `blog.nextside.tech`.
Fork do `akitaonrails/akitaonrails.github.io` com upstream tracking — herda
a stack mas tem identidade visual e conteúdo 100% Nextside.

## Stack

- **Hugo extended** (v0.161+) + tema **Hextra** (vendored como Go Module)
- **Netlify** para build e deploy (branch `master` → produção)
- Markdown + frontmatter YAML
- **Bilíngue** pt-BR (canônico) + EN (via `translationKey`)
- Tokens semânticos CSS com `--bg`, `--fg`, `--accent`, etc.
- Auto-mode editorial (light default + dark via toggle + sistema)
- Body em **Source Serif 4** 19px / line-height 1.75
- Sem analytics, sem comentários (MVP)

## Pipeline canônico de um post novo

```
/novo-post  →  edição humana  →  revisor-akita  →  seo-cta  →  tradutor-en  →  ux-review  →  commit
```

1. `/novo-post` — orquestra brainstorm → outline → draft pt-BR
2. Autor humano edita o draft
3. Agent `revisor-akita` — valida tom/estilo contra `docs/ESTILO-AKITA.md`
4. Agent `seo-cta` — valida frontmatter, sugere keywords e CTA
5. Agent `tradutor-en` — gera versão EN
6. Agent `ux-review` — audita layout, contraste, mobile (**SEMPRE roda**)
7. Commit: `post: <slug>`

## Documentos de verdade (em `docs/`)

- `docs/ESTILO-AKITA.md` — bíblia de tom/voz (cheat-sheet do estilo Akita destilado pro Nextside)
- `docs/WRITER.md` — playbook operacional do framework
- `docs/CATALOGO-SERVICOS.md` — descrição dos serviços (Sprint/Discovery/Auditoria) pra CTAs
- `docs/SYNC-ASSETS.md` — como sincronizar com `nextside/institucional`

## Convenções de commit

Conventional Commits, prefixos aceitos:
- `post:` — novo post ou edição de conteúdo
- `chore:` — manutenção (merge upstream, deps, assets)
- `theme:` — mudança visual / layout
- `framework:` — mudança em `.claude/`
- `feat:` `fix:` `docs:` `refactor:` — convencional

## Regras invioláveis

- **Agent `ux-review` sempre roda** antes do commit de qualquer post novo
- Posts nascem com `draft: true` e ficam assim até revisão completa
- Versão EN é obrigatória pra todo post (gerada pelo `tradutor-en`, revisada por humano)
- Frontmatter sempre tem `category` (uma de: `tecnologia | gestao | entregas-rapidas | cases`) e `tags` (3-6, kebab-case sem acento)
- Cover image em `static/covers/{slug}.png` (1200×630) é obrigatória pra cada post

## Estrutura de conteúdo

```
content/
├── pt-br/
│   ├── posts/YYYY/MM/DD/slug/index.md
│   ├── sobre.md
│   └── autores/{slug}.md
└── en/
    ├── posts/YYYY/MM/DD/slug/index.md
    ├── sobre.md  (vira /about/ via url override)
    └── autores/{slug}.md
```

URLs canônicas (sem prefixo `pt-br`) graças a `contentDir` por idioma no `hugo.yaml` + `defaultContentLanguageInSubdir: false`.

## Comandos essenciais

```bash
# Garantir Hugo no PATH (instalado via brew)
export PATH=/opt/homebrew/bin:$PATH

# Dev server
hugo server -D --port 1313

# Build de produção
hugo --gc --minify

# Limpar e rebuildar
rm -rf public/ && hugo --gc --minify
```

## Workflow bilíngue (regras críticas)

**Editando artigos existentes:** se o post tem irmão de idioma (`index.md` ↔ `index.en.md`), aplique a mudança equivalente no irmão na mesma rodada. Typo, conteúdo, frontmatter — sempre. Nunca deixe drifting.

**Escrevendo artigos novos:**
1. Escreva no idioma pedido (geralmente pt-BR)
2. **Pare e aguarde review** — não traduza imediatamente, não commite
3. Só depois do humano aprovar, traduza para o idioma irmão
4. Só commite quando o autor pedir explicitamente

## Identidade visual

- Cores light: bg `#FBF7EE` (creme), fg `#1A1A1A`, accent `#DD2E03` (vermelho Nextside)
- Cores dark: bg `#10131A`, fg `#E8E4D8`, accent `#FA4616`
- Fontes: ABC Favorit Expanded (H1/H2), Source Serif 4 (body), ABC Favorit (UI), JetBrains Mono (code)
- Ember glow restrito a home hero + CTA box (nunca no corpo do post)
- Wordmark via inline SVG com `currentColor` (adapta ao tema)

## Cross-link Nextside

- Footer sempre linka pra `nextside.tech` (institucional)
- `/sobre/` reforça links pro institucional
- CTAs internos usam shortcode `{{< cta servico="sprint|discovery|auditoria" variante="mid|bottom" >}}` com UTM tracking
