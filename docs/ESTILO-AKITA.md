# Estilo Akita destilado — guia de escrita Nextside

Este é o source-of-truth de tom/voz usado pelo agent `revisor-akita`.
Destilado de https://akitaonrails.com/2026/05/14/terminando-maratona-ia-sucesso-ou-fracasso/
e da home do akitaonrails.com.

A premissa: **direto ao ponto**. Sem corporativês. Primeira pessoa.

## Tom

- **Primeira pessoa, sempre.** "Eu fiz", "Eu acho". Nada de "consideramos" ou "a equipe avaliou".
- **Opinião com evidência.** "Mais de 500 horas, quase meio milhão de linhas de código." Números concretos batem opinião abstrata.
- **Ironia e sarcasmo declarados.** Exemplo Akita: "Todo projeto experimental virou 'Frank'. Sarcasmo, claro."
- **Ceticismo > hype.** Nomeie e zoe o hype: "É meu jeito sarcástico de dizer 'use XP e técnicas normais'."
- **Coloquial.** "Dá ou não dá", "pra começo de conversa", "olhem todos os repos".
- **Antecipa objeção e responde no mesmo parágrafo.** Exemplo:
  > "Por que eu não fiz isso em todos? Simples: não estou sendo pago."

## Estrutura

- **TL;DR no parágrafo 1 ou 2.** Resposta seca primeiro: "Resposta curta: dá."
- Comprimento: 2.000-2.500 palavras para post de opinião / 1.000-1.500 para técnico curto.
- **3-5 H2.** H3 só quando há sub-tier real (subcategoria dentro de uma seção).
- **Listas com bold no item-chave** + 1-2 frases explicando. Sem bullets soltos.
- **Sem "Conclusão" genérica.** Última seção tem título-tese ("O ponto que mais importa", "O que esse ranking diz").

## Faça

### Abertura com fato pessoal + pergunta + resposta seca

> "Acho que finalmente saí do meu hiperfoco em IA. [...] dá ou não dá pra usar [...]? Resposta curta: dá."

### Blockquote para a voz do crítico e responde

> "Todos os 24 projetos são perfeitos?" — **ABSOLUTAMENTE NÃO.**

### Frases-martelo curtas após parágrafo longo

Quebra o ritmo. Marteladas.

> "Software NUNCA acaba."
>
> "Projeto sem usuário está morto."

### CAPS LOCK pontual para ênfase moral

Em 1-3 lugares por post no máximo: "ABSOLUTAMENTE NÃO", "JOGAR FORA", "MUITOS projetos".

### Conectores marca registrada

"Dito isso", "Pra começo de conversa", "Calma lá", "Notem:", "Por isso", "Olha só".

### Parênteses para aparte rápido

"(bump de gem não conta)", "(máximo 10x, com slop junto)".

### Anglicismos quando o termo é o termo

"all-in", "one-off", "hobby", "slop", "vibe coding", "frontier LLMs", "PR", "merge". Não traduza forçado.

### Auto-link para posts antigos como evidência

> "Veja meus vídeos A Dor de Aprender." → [A Dor de Aprender](/posts/...)

### Termine com provocação/aforismo, não com CTA corporativo

Última frase é uma afirmação seca, não "Entre em contato!".

## Não faça

- "Neste artigo vamos explorar..." (corporatês)
- "No mundo de hoje" (clichê)
- "É fundamental ressaltar" (corporatês)
- "Revolucionário", "game-changer", "transformador" (hype de marketing)
- Bullets soltos sem frase explicativa
- Conclusão começando com "Conclusão" ou "Em resumo"
- "Alguns dizem" para esconder opinião (assuma a opinião)
- **Emoji** (zero)
- Tradução forçada de jargão que a comunidade usa em inglês
- "Caro leitor" / "Olá pessoal" / qualquer abertura de tutorial bobo
- Marketing falando "nós, Nextside, acreditamos que..." (vira slide de evento)

## Padrões markdown

- `#` só no frontmatter (`title`). Corpo começa em `##`.
- `**bold**` para nome de projeto/conceito + ênfase moral. Usar bastante.
- `*itálico*` raro — só pra termo estrangeiro novo ou destaque sutil.
- `>` blockquote para citar crítico/leitor imaginário e responder.
- Listas com `-` SEMPRE acompanhadas de bold no item-chave + 1-2 frases.
- Code fences raros em post de opinião — só quando há código de verdade. Sempre com `language hint` (` ```bash`, ` ```python`).
- Links inline `[texto](/url)` para posts próprios. Sem "clique aqui".
- Imagens e embeds YouTube são possíveis, não obrigatórios.

## Exemplos extraídos do Akita (use como gabarito)

### Abertura

> "Acho que finalmente saí do meu hiperfoco em IA. Quando comecei a acelerar em fevereiro [...] o objetivo era responder uma pergunta simples: dá ou não dá pra usar [...]? Resposta curta: dá."

### Martelo no meio

> "Software NUNCA acaba."
>
> "Projeto sem usuário está morto."

### Fechamento

> "O que importa é qual é seu OBJETIVO. [...] Não preciso ganhar dinheiro com nenhum desses projetos. Não assumam coisa que eu nunca falei."

## Adaptação para Nextside

Mantenha 100% do tom Akita — apenas ajuste o contexto institucional:

- **Quando falar da empresa**, prefira "a Nextside" ou "a gente da Nextside" em vez de "we" ou "nós empresa".
- **Cases de cliente**: sempre com permissão explícita, com números reais, sem clichês de "transformação digital".
- **CTAs sempre como shortcode** `{{< cta >}}`, nunca embutidos em texto corrido tipo "fale com a Nextside agora!". O shortcode é separado do fluxo de leitura.
- **Voz coletiva moderada**: alguns posts podem ter voz "nós da Nextside descobrimos que..." quando o conteúdo for de bastidores; mas SEMPRE com posição clara, nunca relatório neutro.
- **Anglicismos técnicos** — mesmo critério: se a comunidade usa em inglês, fica em inglês. "vibe coding", "tech debt", "slop", "frontier LLM".

## Como o revisor-akita vai usar este doc

O agent `revisor-akita` lê este arquivo INTEIRO antes de cada revisão. Para cada post, ele:

1. Faz checklist categórico (TL;DR cedo? Primeira pessoa? Frases-martelo? Blockquote crítico? Fechamento? Corporatês?)
2. Marca ✅ / ⚠️ / ❌ por categoria
3. Cita o trecho problemático + sugere reescrita concreta
4. Veredito: `PRONTO PRA SEO-CTA` / `PRECISA REESCRITA` / `PRECISA REESCRITA GRANDE`

Mudou alguma regra? Atualiza este arquivo — o agent pega na próxima execução.
