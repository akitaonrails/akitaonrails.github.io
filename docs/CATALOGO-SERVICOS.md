# Catálogo de serviços Nextside

Source-of-truth do agent `seo-cta` para decidir qual serviço puxar como CTA
em cada post. Espelho do que o institucional `nextside.tech` oferece.

## Sprint

**O que é:** entrega completa de um produto ou feature em **4 semanas**, com escopo fechado e preço fixo.

**Pra quem:** quem precisa de um MVP funcional rápido, quem cansou de orçamento aberto, quem tem ideia clara mas time pequeno demais pra executar.

**Quando indicar como CTA:**
- Post fala em entregas rápidas, MVP, time-to-market
- Post critica projetos longos / orçamentos abertos / RFP infinito
- Post mostra case de cliente que entregou rápido
- Post fala em escolhas técnicas pragmáticas (vs ideais teóricos)
- Tema genérico de gestão de time / liderança técnica também encaixa

**Frases-CTA prontas (estilo Akita):**
- "Esse problema é típico de um Sprint de 4 semanas."
- "Cansou de gastar 6 meses pra entregar um MVP? A gente entrega em 4."
- "Escopo fechado, preço fixo, time sênior. 4 semanas."
- "Aqui na Nextside a gente resolve isso num Sprint."

**Meta (para `cta_sprint_meta` em i18n):**
"Escopo fechado · Preço fixo · 4 semanas · Time 100% sênior."

**Link:** `https://nextside.tech/#sprint`

## Discovery

**O que é:** validação técnica de produto ou ideia em **2-3 semanas**. Entrega: roadmap acionável + protótipo funcional + decisões de arquitetura documentadas.

**Pra quem:** quem tem ideia mas não sabe se é viável, quem precisa decidir stack antes de investir, quem quer minimizar risco técnico antes de chamar um Sprint.

**Quando indicar como CTA:**
- Post fala em decisão técnica difícil (escolher framework, banco, IA)
- Post mostra prós/contras de stack ou arquitetura
- Post defende validar antes de gastar
- Post fala em risco técnico ou unknowns
- Post sobre IA aplicada (cenário onde Discovery valida uso)

**Frases-CTA prontas:**
- "Vale validar antes de gastar? A gente faz isso."
- "Você não sabe se a ideia presta? Faz um Discovery."
- "Antes de queimar 6 meses, valida em 2 semanas."
- "Quer protótipo + roadmap em 3 semanas? Discovery."

**Meta:** "Validação técnica · 2-3 semanas · Entrega: roadmap + protótipo."

**Link:** `https://nextside.tech/#discovery`

## Auditoria

**O que é:** diagnóstico técnico independente em **1-2 semanas**. Entrega: relatório com riscos, débito técnico, recomendações priorizadas, sem amarras comerciais.

**Pra quem:** quem herdou um codebase, quem desconfia do time atual, quem está sob due diligence técnica, novos CTOs/tech leads em onboarding.

**Quando indicar como CTA:**
- Post fala em legado, refactor, débito técnico
- Post fala em revisão de stack ou arquitetura existente
- Post fala em onboarding de tech lead / CTO novo
- Post crítica de hype quer evidência independente
- Post sobre code review, qualidade de código, dívida técnica

**Frases-CTA prontas:**
- "Quer um diagnóstico técnico sem amarras?"
- "Não confia no time atual? Pede uma Auditoria independente."
- "Sócio novo precisa entender o que herda? Auditoria entrega isso."
- "Due diligence técnica? A gente faz."

**Meta:** "Auditoria independente · 1-2 semanas · Sem amarras comerciais."

**Link:** `https://nextside.tech/#auditoria`

## Mapping tema → serviço (atalho pro agent)

Quando o agent `seo-cta` precisar decidir e o autor deixou `cta.servico` vazio:

| Tema do post | Serviço sugerido |
|---|---|
| entregas-rapidas, MVP, time-to-market | sprint |
| stack, arquitetura, decisão técnica | discovery |
| validar ideia, descobrir riscos | discovery |
| IA aplicada, Claude Code, vibe coding | discovery (validar uso) |
| legado, débito técnico, refactor, herdar código | auditoria |
| code review, qualidade de código | auditoria |
| due diligence, onboarding CTO | auditoria |
| gestão de time, contratação, liderança | sprint (genérico) |
| cases positivos | sprint |
| cases de problema técnico resolvido | auditoria |
| pair programming, processo de dev | sprint (mostra como a gente trabalha) |

**Regra de desempate:** se ainda há dúvida, default vai pra `sprint` (é a oferta-âncora da Nextside).

## Como o agent seo-cta vai usar este doc

1. Lê o post completo (frontmatter + corpo)
2. Identifica tema dominante (via category, tags, e palavras-chave do corpo)
3. Cruza com a tabela acima
4. Se `cta.servico` está vazio: propõe um servico + 2-3 opções de `cta.contexto` (frase curta no tom Akita) tiradas das "Frases-CTA prontas"
5. Pergunta ao autor qual prefere antes de editar o frontmatter

Atualizou a tabela ou as frases? O agent pega na próxima execução.
