---
title: "Frontend Sem Framework | Bastidores do The M.Akita Chronicles"
slug: "frontend-sem-framework-bastidores-do-the-m-akita-chronicles"
date: 2026-02-19T01:08:23+00:00
draft: false
tags:
- themakitachronicles
- tailwind
- hugo
---

Este post vai fazer parte de uma série; acompanhe pela tag [/themakitachronicles](/tags/themakitachronicles). Esta é a parte 4.

E não deixe de assinar minha nova newsletter [The M.Akita Chronicles](https://themakitachronicles.com/)!

--

Existe uma obsessão no mercado de que frontend = React. Ou Vue. Ou Svelte. Ou o framework da semana. E se eu te disser que é possível ter um frontend moderno, responsivo, com dark mode, email-compatible, multi-plataforma — sem uma única linha de JavaScript framework?

Não estou falando de sites estáticos dos anos 2000. Estou falando de Tailwind CSS v4 no Rails, Hugo com tema Hextra pro blog, e templates de email que funcionam do Gmail ao Outlook 2016. Tudo no mesmo projeto, com um desenvolvedor.

## Tailwind CSS v4: O Fim do CSS Artesanal

Eu tenho uma confissão: CSS sempre foi minha kryptonita. Não porque é difícil — mas porque é **imprevisível**. Você muda um `margin-top` e quebra o layout de uma página que nem tocou. Cascata, especificidade, herança — é um campo minado.

Tailwind resolve isso da forma mais pragmática possível: classes utilitárias direto no HTML.

```html
<div class="flex items-center gap-4 p-6 bg-white dark:bg-gray-800
            rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
  <img class="w-12 h-12 rounded-full" src="/images/avatar.jpg">
  <div>
    <h3 class="font-semibold text-gray-900 dark:text-gray-100">Título</h3>
    <p class="text-sm text-gray-500 dark:text-gray-400">Descrição</p>
  </div>
</div>
```

"Mas isso é inline style com passos extras!" — Não, não é. É um sistema de design com constraints. Você não escolhe "margin: 17px" — você escolhe `m-4` (16px) ou `m-5` (20px). Esse constraint force consistência visual sem precisar de um design system documentado em 40 páginas.

E o Tailwind v4, que veio com o Rails via `tailwindcss-rails`, tem uma mudança fundamental: **CSS-first configuration**. Acabou o `tailwind.config.js`. Tudo é CSS:

```css
@import "tailwindcss";

@theme {
  --color-brand: #8b5cf6;
  --font-sans: "Inter", system-ui, sans-serif;
}
```

Menos um arquivo de config. Menos um passo de build. Mais simples.

## Dark Mode: Respeite Seu Usuário

![change theme](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-20_01-05-42.jpg)

Uma coisa que me irrita profundamente é site que ignora preferência de tema do sistema operacional. O usuário configurou dark mode no OS — respeita.

Com Tailwind, dark mode é trivial:

```html
<body class="bg-white dark:bg-gray-900 text-gray-900 dark:text-gray-100">
```

O `dark:` prefixo aplica o estilo quando o sistema operacional está em dark mode (via `prefers-color-scheme: dark`). Não precisa de JavaScript. Não precisa de toggle. Não precisa de cookie. Funciona.

Mas "funciona" é o mínimo. O desafio real é manter **consistência** entre dezenas de componentes. Toda cor que você usar precisa de uma variante `dark:`. Todo background, todo texto, toda borda.

O truque: crie convenções e siga. Background principal? `bg-white dark:bg-gray-900`. Texto primário? `text-gray-900 dark:text-gray-100`. Texto secundário? `text-gray-500 dark:text-gray-400`. Bordas? `border-gray-200 dark:border-gray-700`. Com 4-5 pares definidos, 90% dos componentes ficam cobertos.

## Hugo + Hextra: Blog Sem Banco de Dados

O blog do projeto roda Hugo com o tema Hextra. Hugo é um gerador de sites estáticos escrito em Go — absurdamente rápido. Rebuild completo em <500ms mesmo com dezenas de páginas.

O que torna o Hextra especial é que ele é um tema de **documentação** adaptado pra blog. Sidebar de navegação, search integrado, table of contents — tudo pronto. E customizável via layouts parciais:

```
layouts/
├── _partials/
│   ├── custom/
│   │   └── head-end.html          # Injeta analytics, fonts, CSS customizado
│   └── section-box.html           # Partial compartilhado (DRY, veja abaixo)
├── blog/
│   └── home.html                  # Homepage customizada
├── newsletters/
│   └── single.html                # Template de newsletter individual
├── podcast-transcripts/
│   └── list.html                  # Listagem de episódios
└── shortcodes/                    # 17 shortcodes — componentes sem JS
    ├── podcast-turn.html          # Balão de fala no transcript
    ├── akita-comment.html         # Comentário do Akita
    ├── marvin-comment.html        # Comentário do Marvin
    ├── history-timeline.html      # Timeline de eventos históricos
    ├── market-ticker.html         # Tabela de tickers financeiros
    ├── market-map.html            # Mapa FinViz S&P 500
    ├── subscribe-cta.html         # Call-to-action de inscrição
    ├── score.html                 # Badge de relevância (high/medium/low)
    ├── holidays.html              # Feriados e datas comemorativas
    ├── ref-stories.html           # Links de referência
    ├── book-downloads.html        # Links de download do livro
    ├── hacker-news.html           # ┐
    ├── anime-ranking.html         # │ Section boxes — delegam para
    ├── youtube-digest.html        # │ section-box.html (ver abaixo)
    ├── world-events.html          # │
    ├── market-news.html           # │
    └── qa.html                    # ┘
```

Cada tipo de conteúdo tem seu template. Newsletters têm sidebar de navegação e seções visuais. Transcrições de podcast têm player embutido e formatação de diálogo. O mesmo conteúdo Markdown é renderizado de formas diferentes dependendo do `type` no frontmatter.

## Shortcodes: Componentes Sem JavaScript

Hugo shortcodes são o equivalente a componentes React, mas sem build step:

```html
<!-- layouts/shortcodes/podcast-turn.html -->
{{ $speaker := .Get "speaker" }}
{{ $isAkita := eq $speaker "akita" }}

<div class="podcast-turn" style="display: flex; {{ if $isAkita }}flex-direction: row{{ else }}flex-direction: row-reverse{{ end }};">
  <img src="/images/{{ $speaker }}.jpg"
       style="width: 40px; height: 40px; border-radius: 50%;">
  <div class="bubble {{ if $isAkita }}akita-bubble{{ else }}marvin-bubble{{ end }}">
    {{ .Inner | markdownify }}
  </div>
</div>
```

No Markdown, o autor escreve:

```
{{</* podcast-turn speaker="akita" */>}}
Então, vamos falar sobre o que aconteceu essa semana no mundo tech...
{{</* /podcast-turn */>}}
```

![baloon](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-20_01-06-23.jpg)

E o Hugo renderiza um balão de chat estilizado, com avatar, alinhamento correto, e markdown processado. Zero JavaScript. Zero framework. HTML + CSS + template logic.

### DRY com Partial Compartilhado

Com 17 shortcodes, duplicação vira problema rápido. Sete deles — os "section boxes" que envolvem seções da newsletter (Hacker News, Anime, YouTube, etc.) — têm a mesma estrutura visual: ícone, título, borda colorida, conteúdo Markdown. Só mudam a cor e o label.

A solução é um partial compartilhado que recebe parâmetros:

```html
<!-- layouts/partials/section-box.html -->
<div class="section-box {{ .class }}">
  <div class="section-box-header">
    <span>{{ .icon }}</span> {{ .label }}
  </div>
  <div class="section-box-content">{{ .content | markdownify }}</div>
</div>
```

E cada shortcode vira uma linha:

```html
<!-- layouts/shortcodes/hacker-news.html -->
{{ partial "section-box" (dict "class" "hacker-news" "icon" "&#128274;" "label" "The Hacker News" "content" .Inner) }}
```

![hacker news](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-20_01-07-02.jpg)

É o equivalente Hugo de herança de componentes: um partial polimórfico parametrizado por `dict`. O CSS em `custom.css` define cores por classe (`.hacker-news`, `.anime-ranking`, etc.) com variantes light/dark. Resultado: 7 shortcodes que antes tinham HTML duplicado agora são 7 linhas + 1 partial + CSS.

Mas tem um pegadinho crucial: **shortcodes são exclusivos do Hugo**. O mesmo conteúdo que vai pro blog também vai por email. E email não entende shortcodes.

## O Desafio: Mesmo Conteúdo, Dois Renders

Aqui está o problema central de frontend nesse tipo de projeto: o mesmo arquivo Markdown precisa funcionar em dois contextos completamente diferentes.

**No blog (Hugo):**

- Shortcodes funcionam (`\{\{< subscribe-cta >\}\}`)
- CSS com classes (Tailwind, Hextra)
- Dark mode via `prefers-color-scheme`
- Imagens responsive
- Layout flexível

**No email (Rails → Amazon SES):**

- Shortcodes são texto morto — precisam ser removidos
- CSS deve ser **inline** (muitos clientes de email ignoram `<style>`)
- Dark mode? Esqueça pra 80% dos clientes
- Imagens com URLs absolutas e tamanho fixo
- Layout com `<table>` (sim, em 2026)

A solução: dois pipelines de renderização independentes. O conteúdo Markdown é a source of truth. O Hugo transforma pra web. O Rails transforma pra email. Cada um com suas regras.

No lado do Rails, o serviço `MarkdownToHtml` precisa:

1. Processar Markdown padrão
2. Converter `\{\{< shortcode >\}\}` em HTML equivalente ou removê-los — via um hash de `SHORTCODE_PATTERNS` que mapeia cada shortcode a uma regex + template inline com CSS
3. Aplicar tema (light/dark baseado na preferência do assinante)
4. Injetar CSS inline pra compatibilidade de email clients
5. Reescrever URLs de imagem pra absolutas

É mais trabalho que parece. Cada shortcode precisa de um equivalente email-safe. Avatares de comentário precisam de URLs absolutas. Seções com background colorido precisam de `<td style="background-color:...">` ao invés de classes CSS.

## Email HTML: O Pior Frontend do Mundo

Se você acha que cross-browser compatibility é difícil, tente cross-email-client compatibility. O Outlook 2016 renderiza HTML usando o **engine do Microsoft Word**. Sim, Word. Não é piada.

As regras de sobrevivência:

1. **Layout com `<table>`**. `display: flex`? `grid`? Não existem no Outlook.
2. **CSS inline em todo elemento**. `<style>` tags são ignoradas por vários clients.
3. **Sem `margin` em imagens**. Use `padding` na `<td>` pai.
4. **Fonts web não funcionam**. Use font stack: `font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;`
5. **Temas são preferência do assinante**, não detecção automática — muitos email clients não suportam `prefers-color-scheme`.

O template de email do projeto é um ERB que recebe variáveis de tema:

```erb
<td style="padding: 8px 28px; color: <%= @theme[:text] %>;
           background: <%= @theme[:card_bg] %>;">
  <%= raw @content %>
</td>
```

O tema define todas as cores:

```ruby
THEMES = {
  light: {
    text: "#1a1a1a",
    card_bg: "#ffffff",
    link_color: "#7c3aed",
    # ...
  },
  dark: {
    text: "#e6edf3",
    card_bg: "#161b22",
    link_color: "#a78bfa",
    # ...
  }
}
```

Cada assinante escolhe seu tema na hora de se inscrever. O email é renderizado com as cores corretas pra aquela pessoa. Sem media queries, sem detecção automática — **porque email clients não suportam de forma confiável**. É mais simples dar a escolha pro usuário.

## Paleta de Cores: HSL e a Ciência por Trás das Escolhas

"Mas como vocês escolheram essas cores?" — Não foi no olhômetro. Existe uma ciência por trás, e ela se chama **HSL** (Hue, Saturation, Lightness).

A maioria dos desenvolvedores pensa em cor como hex (`#e8eef8`) ou RGB (`rgb(232, 238, 248)`). São formatos de máquina — úteis pra renderizar, inúteis pra **projetar**. Quando você olha `#3b50a2` e `#c93030` lado a lado, não tem como saber intuitivamente se vão funcionar juntas. São só números.

HSL resolve isso. Em vez de misturar canais de luz (Red, Green, Blue), você descreve cor em termos humanos:

- **Hue** (matiz): a posição no círculo cromático, de 0° a 360°. Vermelho = 0°, verde = 120°, azul = 240°.
- **Saturation** (saturação): quão "viva" é a cor. 0% = cinza, 100% = cor pura.
- **Lightness** (luminosidade): quão clara ou escura. 0% = preto, 100% = branco.

Com HSL, você controla cada dimensão independentemente. E é aí que entra a construção da paleta.

### Passo 1: Distribuir Matizes no Círculo Cromático

![color wheel](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-20_01-09-47.jpg)

A newsletter tem 8 tipos de seção, cada uma com cor própria. Pra que todas "pertençam" visualmente ao mesmo projeto, os matizes são distribuídos uniformemente no círculo de 360°:

| Seção | Matiz | Graus |
|-------|-------|-------|
| YouTube | Vermelho | 0° |
| História | Sépia | 35° |
| Mundo | Âmbar | 45° |
| Livro/Downloads | Verde | 140° |
| Feriados | Teal | 180° |
| Anime/Q&A | Azul | 210° |
| Market News | Royal | 225° |
| Hacker News | Roxo | 270° |

Oito matizes espaçados ao redor do círculo. Não é aleatório — é a mesma lógica de uma **paleta policromática** em teoria das cores. Quando os matizes são equidistantes, o olho humano percebe harmonia mesmo com cores completamente diferentes. É o mesmo princípio que artistas usam com um círculo cromático de 12 cores desde o século XVIII.

### Passo 2: Fixar Saturação e Luminosidade por Camada

![saturation luminosity](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/HSV_color_solid_cylinder_saturation_gray.jpg)

Aqui está o truque que faz tudo funcionar junto. Cada "camada" visual (background, texto, borda) tem saturação e luminosidade **fixas** — só o matiz muda:

**Tema claro:**

- **Backgrounds**: ~92-95% luminosidade, saturação moderada. Com luminosidade tão alta, mesmo saturações diferentes resultam em cores pastel com peso visual parecido — nenhuma seção "grita" mais que outra.
- **Texto**: ~15-20% luminosidade. Escuro o suficiente pra garantir **ratio de contraste >7:1** contra o background claro (acima do mínimo WCAG AAA de 7:1).
- **Bordas**: ~45-55% luminosidade. O acento cromático — visível mas não dominante.

**Tema escuro:**

- **Backgrounds**: ~10-12% luminosidade. Profundidade uniforme — todas as seções têm a mesma "escuridão".
- **Texto**: ~80-85% luminosidade. Claro o suficiente pra **ratio de contraste >6:1** no fundo escuro.
- **Bordas**: mesma faixa de luminosidade que no tema claro — funcionam como acento nos dois contextos.

Na prática, isso significa que gerar a variante dark de qualquer cor é mecânico: mantém o matiz, inverte a luminosidade. Background que era 94% vira 11%. Texto que era 18% vira 83%. Não é design — é aritmética.

### Passo 3: Verificar Contraste (WCAG)

[![Why Colour Contrast Accessibility Matters More Than Ever](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/Why-Colour-Contrast-Accessibility-Matters-More-Than-Ever.jpg)](https://accessibilityassistant.com/blog/accessibility-insights/wcag-2-colour-contrast-accessibility-guidelines/)

Cores bonitas que ninguém consegue ler não servem pra nada. O padrão WCAG (Web Content Accessibility Guidelines) define ratios mínimos:

- **AA**: 4.5:1 pra texto normal, 3:1 pra texto grande
- **AAA**: 7:1 pra texto normal, 4.5:1 pra texto grande

Os backgrounds claros com ~95% luminosidade contra texto com ~20% luminosidade dão ratio >7:1 — WCAG AAA. Os backgrounds escuros (~11%) contra texto claro (~82%) dão >6:1 — confortavelmente WCAG AA, próximo de AAA.

Isso não é por altruísmo. Email com baixo contraste é mais difícil de ler, gera menos engajamento, e em casos extremos é sinalizado por filtros de acessibilidade de email clients.

### O Resultado

![example colors](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-20_01-07-50.jpg)

Quando você abre a newsletter e vê a seção do Hacker News (roxa), seguida pelo YouTube (vermelha), seguida pelo Anime (azul) — elas parecem "do mesmo projeto" apesar de cores completamente diferentes. Isso é o HSL trabalhando: matizes diferentes, mesma saturação, mesma luminosidade. O olho percebe coerência sem saber explicar por quê.

E a melhor parte: adicionar uma seção nova é trivial. Escolhe um matiz que não está ocupado no círculo, aplica as mesmas regras de saturação/luminosidade por camada, e a nova seção automaticamente "pertence" ao design existente.

```ruby
# O comentário no código resume as regras:
# - Hues evenly spaced: blue 210, green 140, sepia 35, amber 45, royal 225, purple 270, red 0, teal 180
# - Light backgrounds: ~95% lightness, ~25% saturation
# - Light text: ~20% lightness (>7:1 contrast ratio on light bg)
# - Dark backgrounds: ~10-12% lightness
# - Dark text: ~80-85% lightness (>6:1 contrast ratio on dark bg)
# - Borders: ~45-55% lightness
```

Seis regras. Oito matizes. Dois temas. 100% determinístico. Nenhuma decisão subjetiva de "acho que esse azul fica bonito" — é sistema de design derivado de propriedades geométricas do espaço de cor HSL.

## HTML Bem Formado: O Filtro de Spam que Ninguém Te Conta

Tudo que descrevi acima — tables, CSS inline, font stacks — resolve o problema de **renderização**. Mas tem um segundo motivo pra seguir essas regras que a maioria dos desenvolvedores ignora: **provedores de email analisam a qualidade do seu HTML pra decidir se é spam**.

Gmail, Outlook, Yahoo — todos passam o HTML do seu email por heurísticas antes de mostrar pro usuário. HTML malformado é um dos sinais clássicos de spam. Faz sentido: spammers não testam templates. Eles cospem HTML quebrado gerado por ferramentas de mass-mailing baratas. Se seu email parece output de spammer, vai ser tratado como spam.

Os sinais que disparam filtros:

1. **Tags não fechadas ou mal aninhadas**. Um `<div>` que abre e nunca fecha, ou um `</td>` antes do `</tr>`, é flag imediata. Provedores esperam HTML que parse sem erros — não HTML "que o browser conserta".
2. **Ratio imagem/texto desbalanceado**. Email que é basicamente uma imagem gigante com pouco texto? Spam clássico. Provedores querem ver texto real — não texto dentro de imagens. A regra de ouro é manter pelo menos 60% texto, 40% imagem.
3. **Atributo `alt` ausente em imagens**. Além de acessibilidade, `alt` vazio ou ausente é sinal de descuido — e descuido correlaciona com spam. Toda `<img>` precisa de `alt` descritivo.
4. **CSS que esconde conteúdo**. `display: none`, `visibility: hidden`, `font-size: 0`, texto da mesma cor que o background — são técnicas clássicas de keyword stuffing. Mesmo que você use legitimamente pra responsive email, o filtro não sabe a diferença.
5. **HTML excessivamente pesado**. Email com 500KB de HTML levanta suspeita. Mantenha leve — o conteúdo real raramente precisa de mais de 100KB de HTML.
6. **Links com texto que não corresponde ao href**. `<a href="https://site-real.com">https://site-falso.com</a>` é phishing textbook. Mesmo discrepâncias sutis (domínio no texto diferente do domínio no link) são penalizadas.

O ponto que conecta tudo: **as mesmas práticas que fazem email renderizar corretamente no Outlook são as que mantêm seus emails fora do spam**. Tables com estrutura limpa? HTML bem formado. CSS inline em cada elemento ao invés de hacks com `<style>`? Sem CSS escondido. Imagens com dimensões explícitas e `alt` text? Conteúdo legítimo.

Não é coincidência. Provedores de email calibraram seus filtros observando o que spammers fazem — e spammers fazem exatamente o oposto de HTML email bem construído. Quando você segue as melhores práticas de compatibilidade, **de graça** você também está sinalizando legitimidade pros filtros de spam.

A lição prática: trate o HTML do seu email como se fosse um documento XML. Valide, teste, e garanta que todo tag abre e fecha na ordem certa. Use ferramentas como [Email on Acid](https://www.emailonacid.com/) ou [Litmus](https://www.litmus.com/) pra testar em múltiplos clients — eles também reportam problemas de spam scoring. E resista à tentação de copiar templates prontos da internet sem validar — muitos são um desastre de HTML malformado que passa despercebido no Gmail mas faz o Outlook ter um ataque cardíaco e faz o filtro de spam do Yahoo te marcar como suspeito.

## RSS Feeds: O Frontend Esquecido

![RSS](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-20_01-12-48.jpg)

Um detalhe que desenvolvedores web ignoram: RSS é um frontend. Podcasts no Spotify e Apple Podcasts são consumidos via RSS. O feed precisa de:

- XML válido (parsers de podcast são rígidos)
- Metadata completa (título, descrição, duração, tamanho do arquivo)
- URLs de imagem que **realmente funcionam** (Spotify valida)
- Cover art com dimensões mínimas (1400×1400 pra Spotify)
- GUIDs únicos por episódio

Hugo gera RSS automaticamente, mas o template padrão não tem os campos que plataformas de podcast exigem. Um template customizado com tags iTunes é necessário:

```xml
<itunes:duration>{{ .Params.duration_seconds }}</itunes:duration>
<itunes:image href="{{ .Params.cover_image | absURL }}"/>
<enclosure url="{{ .Params.audio_url }}"
           length="{{ .Params.file_size }}"
           type="audio/mpeg"/>
```

## A Filosofia: Conteúdo Primeiro, Framework Nunca

O padrão que emerge de todo esse setup é: **o conteúdo é soberano**. Markdown com frontmatter YAML é o formato universal. Cada frontend (blog, email, RSS, podcast player) consome o mesmo conteúdo e renderiza do seu jeito.

Não existe "componente React que busca dados de uma API". Existe um arquivo Markdown que é lido por quem precisar. Isso é radicalmente simples — e radicalmente poderoso. Trocar o blog engine de Hugo pra outro? Muda os templates, o conteúdo fica igual. Trocar o provedor de email de SES pra Sendgrid? Muda o mailer, os templates ficam iguais.

É o Unix philosophy aplicado a frontend: cada ferramenta faz uma coisa bem feita, conectadas por um formato universal (Markdown + YAML).

## Conclusão

Você não precisa de React pra ter frontend moderno. Tailwind v4 te dá design system com constraints, dark mode nativo, e zero JavaScript. Hugo te dá um blog absurdamente rápido com templates flexíveis. ERB com CSS inline te dá emails que funcionam em qualquer client.

O investimento está em **entender as restrições de cada plataforma** e construir pipelines de renderização específicos. Não em aprender o framework da moda que vai ser substituído em 18 meses.

Se tem algo que aprendi com esse projeto: a melhor abstração de frontend é nenhuma. HTML, CSS, e conteúdo em Markdown. Simples, debugável, e vai funcionar daqui a 10 anos.
