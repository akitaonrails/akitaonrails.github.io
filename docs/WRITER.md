# WRITER.md — playbook do framework de escrita

Guia operacional pra usar o framework Claude Code embutido neste repo.
Não é guia de estilo — pra isso veja `ESTILO-AKITA.md`.

## Pipeline completo de um post

```
/novo-post  →  edição humana  →  revisor-akita  →  seo-cta  →  tradutor-en  →  ux-review  →  commit
```

Cada etapa abaixo tem 1-2 comandos prontos pra copiar.

## Passo 1 — Brainstorm + outline + draft

No terminal, dentro do repo, abra Claude Code e digite:

```
/novo-post
```

O comando vai te guiar por:

1. **Tema** — pergunta o tema do post (uma frase só)
2. **Ângulo** — propõe 3 ângulos provocadores diferentes; você escolhe
3. **Tese** — formula UMA frase-tese que vai no TL;DR
4. **Outline** — monta estrutura no formato Akita (TL;DR cedo, 3-5 H2, frase-martelo, blockquote do crítico, fechamento com aforismo)
5. **Draft** — escreve em pt-BR seguindo `ESTILO-AKITA.md`
6. **Salva** — em `content/pt-br/posts/YYYY/MM/DD/<slug>/index.md` com `draft: true`

**Saída esperada:** um arquivo .md de ~1500-2500 palavras, pronto pra você editar.

## Passo 2 — Edição humana

Abra o arquivo, edite à vontade. **Não corrija miudezas de tom** — `revisor-akita` cuida disso depois. Corrija:

- **Ângulo** — a tese central pegou bem ou ficou genérica?
- **Exemplos** — os exemplos batem? São reais? Têm número?
- **Ordem** — a sequência das seções faz sentido?
- **Cortes** — tem parágrafo que não acrescenta? Mata.

Se a base estiver fraca, peça `/novo-post` de novo com um tema mais afiado.

## Passo 3 — Revisor Akita

Peça:

```
Use o agent revisor-akita pra revisar content/pt-br/posts/2026/MM/DD/<slug>/index.md
```

Ele vai checar contra `docs/ESTILO-AKITA.md` e retornar:

- ✅ O que tá bom
- ⚠️ A melhorar (com sugestão concreta)
- ❌ Bloqueia (corporatês, conclusão genérica, etc.)
- Veredito: `PRONTO PRA SEO-CTA` / `PRECISA REESCRITA` / `PRECISA REESCRITA GRANDE`

Aplique as sugestões que fizerem sentido. Discorde quando achar — o agent erra.

## Passo 4 — SEO + CTA

Peça:

```
Use o agent seo-cta pra revisar o post
```

Vai validar:

- `description` 140-160 chars
- Tags consistentes (kebab-case, sem acento)
- 3+ internal links (1+ pra `nextside.tech`)
- Decidir `cta.servico` se vazio (consultando `docs/CATALOGO-SERVICOS.md`)
- Propor texto do `cta.contexto`
- Confirmar que `cover` existe em `static/covers/`

Se algo faltar, ele edita o frontmatter ou te pergunta antes.

## Passo 5 — Tradução EN

Peça:

```
Use o agent tradutor-en pra gerar versão EN do post
```

Vai gerar `content/en/posts/.../index.md` com mesmo `translationKey`.
Marca como `draft: true`. **Sempre revise manualmente** antes de publicar EN.

## Passo 6 — UX-review (SEMPRE)

```
Use o agent ux-review pra auditar o post antes de eu publicar
```

Sobe `hugo server -D` em background, audita renderização visual:

- Hierarquia H1/H2/H3
- Comprimento de parágrafos
- Contraste em mobile (testa 360px)
- Code blocks legíveis
- CTAs não atrapalham fluxo

Issues priorizadas + screenshots quando possível. **Esta etapa é obrigatória pela regra do time** — confere o `feedback-ux-review-agent` na memória.

## Passo 7 — Commit

Mude `draft: false` em AMBOS os arquivos (pt-BR + EN). Commit:

```bash
git add content/
git commit -m "post: <slug>"
git push origin master
```

Netlify builda e deploya automaticamente em ~1min.

## Quando NÃO usar o pipeline inteiro

- **Edição de typo em post já publicado** → direto, sem agents
- **Update de metadata** (tags, cover) → seo-cta opcional
- **Série de posts** com tom já estabelecido → revisor-akita opcional
- **Tradução de post antigo** → pula só pra Passo 5

## Quando o agent não responde bem

- **Resposta vaga ou genérica** → relê o source-of-truth (`ESTILO-AKITA.md`, `CATALOGO-SERVICOS.md`) e fica explícito sobre o que falta
- **Aplica algo que você não pediu** → diga "reverta isso" e seja específico
- **Trava em loop** → reinicia a sessão e volta com contexto mínimo

## Troubleshooting

| Problema | Solução |
|---|---|
| Draft não aparece no preview | Confira `hugo server -D` (flag `-D` lista drafts) |
| CTA não renderiza | `cta.servico` no frontmatter precisa estar no enum (`sprint` / `discovery` / `auditoria` / `none`) |
| Tradução EN ficou ruim | Revise manualmente, depois rode `revisor-akita` no arquivo EN |
| Merge upstream do Akita conflita | Foca em `layouts/_default/*`, descarta mudanças em `content/` |
| Imagem cover não aparece | Confira `static/covers/<slug>.png` existe e está em 1200×630 |
| Hugo não acha no PATH | `export PATH=/opt/homebrew/bin:$PATH` antes de qualquer `hugo` |

## Estrutura mental — escrevendo posts no estilo Akita

1. Você tem uma **opinião forte** sobre algo
2. Vai abrir o post com a **tese seca** (não suspense)
3. Vai sustentar com **evidência concreta** (números, exemplos, cases)
4. Vai antecipar o **crítico imaginário** e responder (blockquote)
5. Vai quebrar parágrafos longos com **frases-martelo curtas**
6. Vai terminar com **aforismo**, não com CTA
7. CTA Nextside é coisa do **shortcode**, separado do texto

Se isso parece corporatês forçado, o `revisor-akita` vai te dizer.

## Cadência recomendada

- **1 post/semana** é o ritmo realista pra time pequeno (2-3 autores).
- Não force volume — post fraco machuca mais SEO/reputação do que ausência.
- **Cada post tem uma tese**. Se você consegue resumir em 1 frase, escreve. Se não, não tem post ainda.
