---
title: "ADRs no Notion, sem burocracia"
date: 2026-05-16T10:00:00-03:00
draft: true
translationKey: adrs-decisao-no-notion-sem-burocracia
category: gestao
tags: [adr, decisao-tecnica, notion, processo, time-pequeno]
author: pablo-winter
description: "ADR não é cerimônia corporativa — é a forma mais barata de não repetir burrice em time pequeno. Como a gente da Nextside faz no Notion."
cover: covers/adrs-decisao-no-notion-sem-burocracia.png
cover_alt: "Symbol Nextside em vermelho sobre fundo creme, ilustração placeholder da capa do post."
cta:
  servico: discovery
  posicao: ambos
  contexto: "Antes de queimar 6 meses, valida em 2 semanas — e documenta as decisões num ADR."
canonical: ""
---

Toda vez que alguém fala "ADR" numa reunião, metade do time pensa em planilha do Sharepoint, comitê de arquitetura e documento de 14 páginas que ninguém lê. Eu também pensava. E aí qual é a pergunta real: ADR vale a pena pra time pequeno? Resposta curta: vale, mas não do jeito que o livro diz.

ADR — **Architecture Decision Record** — é registro de decisão técnica. Curto. Datado. Imutável. Você decide algo importante hoje, escreve por que decidiu, e daqui a 6 meses quando alguém perguntar "por que diabos a gente escolheu Postgres em vez de Mongo?", a resposta tá lá. Sem ter que reconvocar a reunião perdida no calendário de fevereiro.

O ponto não é o template. O ponto é não perder história.

## Por que a maioria dos times falha em ADR

A maioria dos times que tenta adotar ADR copia o template do Michael Nygard (ou o do AWS prescriptive guidance, ou o do ThoughtWorks) na primeira semana, escreve 3 ADRs em 4 dias, e abandona no quinto. Eu já fiz isso. Time pequeno tem zero paciência pra ritual.

O problema é simples: o template tradicional tem 6 seções (Context, Decision, Status, Consequences, Alternatives Considered, Stakeholders). Em time de 4 pessoas com prazo apertado, ninguém escreve "Alternatives Considered" com bullet points. Ninguém. Você abre o doc, olha pra 6 headers vazios, fecha o doc, e volta pro código.

Resultado: o ADR vira piada. "Cara, lembra quando a gente ia documentar decisões? Bons tempos."

> "Mas se vocês não documentam direito, como mantêm histórico?" — pergunta justa. Resposta: a gente documenta SIM, só que num formato que cabe em time pequeno. Não no formato que cabe num livro de arquitetura corporativa.

E é aí que mora a diferença. ADR de time pequeno não é "Architecture Decision Record" no sentido pomposo. É **bilhete pro seu eu do futuro**. Você está escrevendo pra você daqui a 4 meses, que esqueceu por que escolheu Redis em vez de Memcached. Isso é tudo.

## Como a gente da Nextside faz no Notion

Não tem repo separado pra ADRs. Não tem `docs/adr/0001-use-postgres.md`. Tem uma database no Notion chamada `Decisões`. Schema bobo:

- **Title** — frase declarativa curta: "Usar Postgres como banco principal", "Adotar Hugo em vez de Next pro blog"
- **Status** — Proposta / Aceita / Substituída / Descartada
- **Data** — quando foi decidida
- **Tags** — área (backend, frontend, infra, processo)
- **Body** — 3 seções: **Contexto** (1-3 parágrafos), **Decisão** (1 parágrafo seco), **Consequências** (bullets curtos: o que ganhamos, o que perdemos)

E só.

Notem o que NÃO tem: "Stakeholders", "Voting", "Alternatives Considered" formalizado. Se as alternativas importam, viram parágrafo no Contexto. Se não importam, não viram nada. O critério é simples: **o ADR existe pra alguém entender a decisão daqui a 6 meses, não pra defender em auditoria**.

A regra de ouro que a gente segue: **se você decidiu algo que vai ser caro reverter, escreve um ADR**. Se vai dar pra reverter num PR de 50 linhas, não escreve nada. Documentar tudo é o mesmo que documentar nada — vira ruído.

## Exemplo concreto (decisão real-ish)

Cenário típico: time precisa decidir entre dois ORMs num projeto Node novo. Prisma vs Drizzle. Discussão dura 40 minutos no Slack. Alguém abre o Notion e escreve:

> **Título:** Usar Drizzle como ORM no projeto X
>
> **Status:** Aceita
>
> **Data:** 2026-04-12
>
> **Contexto:** Projeto X precisa de ORM com bom suporte a TypeScript, migrations versionadas e performance previsível em query analytics. Avaliamos Prisma (mais maduro, melhor DX, mas runtime engine em Rust pesa cold-start em serverless) e Drizzle (mais novo, zero-cost abstraction, SQL-first). Time já tem familiaridade com SQL puro.
>
> **Decisão:** Adotar Drizzle. SQL-first encaixa no perfil do time, cold-start em serverless é problema concreto pra esse projeto, e a curva de aprendizado é menor que o ganho de DX do Prisma.
>
> **Consequências:**
> - Ganhamos cold-start mais rápido em Vercel/AWS Lambda
> - Perdemos algumas features avançadas que Prisma tem out-of-the-box (Prisma Studio, melhor introspection)
> - Migrations ficam mais manuais — exige disciplina maior do time
> - Se ferrar, dá pra migrar pra Prisma — Drizzle é fininho, sem lock-in pesado

Pronto. 180 palavras. 4 minutos pra escrever. Daqui a 6 meses, quando um dev novo chegar e perguntar "por que Drizzle?", a resposta tá ali, datada, com contexto.

Isso é todo o segredo. Não tem mágica.

## O que acontece quando você NÃO faz isso

O que acontece é o que eu chamo de **history losing**. Decisão tomada, ninguém anotou, 6 meses depois o time inteiro esqueceu. Aí surge a tentação de revisitar a decisão. "Cara, será que a gente devia ter usado Prisma?" Discussão de 40 minutos. De novo. As mesmas 4 pessoas. Com mais ou menos os mesmos argumentos. Conclusão idêntica.

Você acabou de pagar o preço da decisão DUAS VEZES.

Pior: às vezes a conclusão é diferente — porque alguém esqueceu o argumento crítico que pesou da primeira vez. Aí o time muda de Drizzle pra Prisma, refatora tudo, e 3 meses depois bate no mesmo problema de cold-start que motivou Drizzle originalmente. Voltamos pra Drizzle. Mais 3 meses queimados.

Isso é a pior coisa que pode acontecer em time pequeno: **repetir burrice porque ninguém anotou a burrice anterior**. Empresa grande aguenta. Time de 4 pessoas, não.

Frase-martelo: **memória institucional num time pequeno não é Confluence. É hábito.**

ADR não substitui conversa. Não substitui pair programming. Não substitui RFC pra coisa grande. Mas substitui o "espera, deixa eu lembrar por que a gente decidiu isso..." — e esse "espera, deixa eu lembrar" custa mais caro do que parece. Custa contexto interrompido, custa retrabalho, e custa confiança no histórico do time.

> "Mas ninguém vai voltar ler ADR depois!" — vão sim. Eu volto. Toda vez que entro num projeto antigo e me pergunto "por quê?". O ADR é o atalho pro porquê. Sem ele, atalho some.

## Como começar amanhã (sem virar processo pesado)

Se você nunca teve ADR no time e quer começar, três passos:

- **Cria uma database no Notion (ou Linear, ou Trello, ou um diretório `docs/decisoes/` no monorepo)** — Não importa a ferramenta. Importa ter UM lugar.
- **Define a regra de gatilho** — qualquer decisão que custaria 1+ dia pra reverter merece ADR. Decisão de framework, banco, padrão de auth, escolha de fila, padrão de erro. Decisão de naming de variável NÃO precisa.
- **Bota gatilho no PR template** — pergunta opcional no template: "Essa PR introduz decisão arquitetural? Se sim, link do ADR". Soft enforcement. Sem isso, o hábito morre na segunda semana.

Em 3 meses, o time tem 10-15 ADRs. Em 1 ano, 30-40. Não é volume. É **densidade de contexto**. Cada ADR é um sinal claro de "aqui tomamos uma decisão que importava".

E aqui mora o detalhe que ninguém fala: o valor real do ADR não tá no documento. Tá no **ato de escrever**. Quando você senta pra explicar a decisão em 3 parágrafos, você descobre que metade da decisão tava implícita e mal formada. O ADR força clareza. É o pair-programming da decisão técnica.

Por isso eu nem ligo se ninguém ler depois. Já valeu pelo ato de escrever.

## O que o ADR realmente protege

O ADR não protege você de tomar decisão errada. ABSOLUTAMENTE NÃO. Você vai tomar decisão errada de qualquer jeito — todo time toma. O ADR protege você de tomar a MESMA decisão errada duas vezes. Que é coisa diferente.

Time bom não é o time que acerta sempre. É o time que erra menos a cada iteração. ADR é o registro que permite saber qual erro você cometeu e por quê — pra não cometer outra vez na próxima decisão parecida.

Em time pequeno, a margem pra repetir burrice é zero. Cada semana queimada em decisão refeita é semana que você não tinha. Discovery, MVP, refatoração — não tem folga.

Por isso a gente da Nextside escreve ADR no Notion. Curto. Datado. Honesto. Sem template gigante. Sem cerimônia. Sem reunião extra.

ADR não é para impressionar auditor. É para o time. E o time é pequeno. E o tempo é curto.

Quem não anota a história, repete a história. E repetir burrice é o luxo que time pequeno não pode pagar.
