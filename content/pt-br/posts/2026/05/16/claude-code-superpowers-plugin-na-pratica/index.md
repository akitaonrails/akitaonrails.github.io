---
title: "Claude Code superpowers: o plugin que muda como o time entrega"
date: 2026-05-16T11:00:00-03:00
draft: true
translationKey: claude-code-superpowers-plugin-na-pratica
category: entregas-rapidas
tags: [claude-code, superpowers, ia, produtividade, skills]
author: pablo-winter
description: "Superpowers do Claude Code não é mais um plugin de IA — é a forma de codificar conhecimento de time num lugar que a máquina lê e executa."
cover: covers/claude-code-superpowers-plugin-na-pratica.png
cover_alt: "Symbol Nextside em vermelho sobre fundo creme, ilustração placeholder da capa do post."
cta:
  servico: sprint
  posicao: ambos
  contexto: "Esse jeito de trabalhar — IA + processo codificado — é exatamente o que cabe num Sprint de 4 semanas."
canonical: ""
---

Pergunta direta: dá pra entregar feature pronta de verdade usando Claude Code? Resposta seca: dá. Mas não com Claude Code puro. Dá com Claude Code + plugin **superpowers** instalado. E essa diferença não é cosmética — muda a forma como o time inteiro entrega.

Eu testei. A gente testou. Esse blog que você está lendo foi construído com Claude Code + superpowers do começo ao fim — design system, layouts Hugo, pipeline de agents, frontmatter, esse próprio post. E o que mais me chamou atenção não foi velocidade. Foi disciplina.

Superpowers não é "mais um plugin de IA". É a forma como a gente codifica conhecimento de time num lugar que a máquina lê — e executa.

## O que é superpowers, sem hype

Superpowers é um plugin pro Claude Code (claude.ai/code, a CLI da Anthropic) que adiciona três coisas concretas:

- **Skills** — markdown files que descrevem "como fazer X". Cada skill tem trigger (quando usar), passos (o que fazer), e regras (o que não esquecer). Claude lê a skill antes de executar a tarefa.
- **Agents/Subagents** — invocações especializadas. Você lança um "subagent de revisão UX" que tem contexto próprio, prompts próprios, e ferramentas próprias. Não polui contexto principal.
- **Slash commands** — atalhos que você digita (`/code-review`, `/ship`, `/init`) e disparam fluxos complexos. Cada um lê o repo, executa passos, e reporta.

Soa parecido com prompts salvos? É. Mas a diferença não é o conteúdo — é o **ritual**. Skill enforced significa que o Claude lê a skill ANTES de começar a trabalhar. Não tem chance de pular o passo de TDD. Não tem chance de pular o checkpoint de brainstorming. A skill é gatilho automático.

E é aí que mora a virada.

## Como muda o fluxo de trabalho real

Sem superpowers, Claude Code é IA generalista boa. Você abre, descreve a tarefa, ele tenta resolver. Se você esquecer de pedir teste, ele não escreve teste. Se você esquecer de pedir brainstorming antes de codar, ele já parte pra implementação. Resultado: muito código gerado, muito código jogado fora.

Com superpowers, o jogo é outro:

- **TDD enforced** — skill `test-driven-development` força Claude a escrever teste falhando ANTES de escrever implementação. Sempre. Pra todo bugfix, pra toda feature. Não negocia.
- **Brainstorming antes de código** — skill `brainstorming` exige que, antes de qualquer trabalho criativo, Claude explore o problema com o usuário. Faz perguntas. Lista alternativas. Só depois propõe solução.
- **Systematic debugging** — encontrou bug? Skill `systematic-debugging` força investigação metódica em vez de chute. Primeira hipótese não é a aposta — é o ponto de partida da árvore de causas.
- **Verification before completion** — Claude não pode dizer "feito" sem rodar verificação. Roda os testes, mostra output, depois afirma. Adeus "deve funcionar".

Notem o padrão: cada skill é uma forma de codificar disciplina de engenharia sênior. O que devs experientes fazem por hábito — TDD, brainstorming antes de código, debug metódico, verificar antes de afirmar — vira regra que a máquina executa.

E aqui mora o ponto: **isso não é sobre dar superpoder pra IA. É sobre dar a IA o conjunto de hábitos do seu melhor dev sênior.**

## Como a Nextside usou pra construir o próprio blog

A gente da Nextside montou esse blog (`blog.nextside.tech`) usando Claude Code + superpowers. Stack: Hugo + tema Hextra, design system próprio em CSS, pipeline editorial de agents, bilíngue pt-BR/EN.

Fluxo típico de uma feature do design system:

1. **Brainstorming session** — eu descrevo "preciso de hover state pro card de post". Claude (via skill brainstorming) faz 3-4 perguntas: "ember glow ou só elevation?", "mobile também ou só desktop?", "comportamento em dark mode?". Só depois disso propõe abordagem.
2. **Plano escrito** — skill `writing-plans` força Claude a escrever plano detalhado antes de codar. Plano vai pra um arquivo de spec. Eu reviso. Aprovo ou peço ajuste.
3. **Execução com TDD** — skill `executing-plans` segue o plano. Cada passo do plano vira checkpoint. Skill TDD força teste antes de código (quando aplicável — em CSS puro, vira verificação visual).
4. **UX review automática** — antes do commit, lança um agent dedicado de revisão UX que abre o site no browser, navega, tira screenshot, e flagra problema.
5. **Commit + push** — só depois de tudo verde.

Notem: zero "vibe coding" desorganizado. Zero "deixa eu tentar uma coisa". Zero "deve funcionar". É um pipeline.

E o resultado vem porque o pipeline é repetível. A próxima feature passa pelos mesmos checkpoints. A skill é a mesma. O agent é o mesmo. Não depende da minha memória de "o que eu pedi da última vez".

Isso é o que muda em time. Quando o conhecimento tá codificado em skill, qualquer dev do time invoca o mesmo Claude e ganha o mesmo padrão. Não tem dev "que sabe usar Claude bem" e dev "que não sabe". O conhecimento mora no plugin.

## O que melhora vs Claude Code puro

Diferença concreta de antes e depois:

- **Velocidade real (não percebida)** — Claude puro entrega rápido demais. Você acha que economizou tempo, mas gastou 2h refazendo. Com superpowers, primeira entrega leva um pouco mais — porque tem brainstorming, plano, TDD — mas é a entrega que fica.
- **Menos slop** — slop é código gerado que parece certo mas tá errado. Sem superpowers, slop aparece direto. Com superpowers, o verification step pega antes do commit.
- **Reprodutibilidade** — outro dev do time invoca o mesmo `/code-review` e ganha review com critérios idênticos aos meus. Não depende do prompt que eu escrevi às 3 da manhã num sábado.
- **Onboarding mais rápido** — dev novo no time não precisa decorar processo. Ele instala superpowers, lê o catálogo de skills e slash commands, e já trabalha como o time trabalha.

A última é a que mais me surpreendeu. Eu sempre achei que "processo de time" era doc no Notion. Vira que não — é skill no Claude. Doc no Notion ninguém lê. Skill no Claude executa toda vez que a tarefa começa.

Isso é importante: **doc de processo é ficção. Skill executada é processo de verdade.**

## Limites honestos (não é mágica)

Calma lá. Superpowers não resolve tudo:

- **Não substitui dev sênior** — substitui o trabalho braçal do dev sênior. As decisões arquiteturais reais ainda exigem humano no loop. Quem escolhe stack, quem decide trade-off de performance vs DX, quem faz call de produto — é gente.
- **Slip pode escapar** — verification step não é onisciente. Se o teste tá errado, o "tudo verde" é falso positivo. Você ainda precisa olhar.
- **Custo de contexto** — skills enchem o contexto inicial. Se você tem 30 skills carregadas e o repo é gigante, performance cai. Tem que curar skill ativa.
- **Aprende mal sozinho** — superpowers não evolui sozinho. Se um padrão do time muda, alguém tem que atualizar a skill. Sem manutenção, ela vira obsoleta — e aí a IA executa processo velho com convicção.

E o ponto crítico: **superpowers é alavanca, não autopilot**. Você ainda precisa pensar. Você precisa revisar o plano que Claude escreveu. Você precisa decidir quando a brainstorming session já durou demais. A skill é régua, mas você é quem segura a régua.

> "Mas se a IA faz tudo, qual é o papel do dev?" — boa pergunta. Resposta: o dev vira **arquiteto + revisor + ditador de gosto**. Não digita mais boilerplate. Decide o quê, revisa o como, e ajusta o tom. É papel mais sênior, não menos.

## O que esse plugin diz sobre o futuro do trabalho

Aqui o ponto que mais importa.

Por anos, processo de time foi documento. ADR no Notion. Checklist no Confluence. Playbook no Google Doc. Tudo passivo. Tudo ignorado depois da segunda semana.

Superpowers muda isso porque transforma processo em **código executável pela IA**. A skill não é doc — é instrução que dispara toda vez que a tarefa começa. Ninguém precisa lembrar de "rodar o playbook". A IA roda sozinha.

Isso tem implicação grande: o conhecimento de engenharia que ficava nas cabeças dos seniores agora cabe num markdown que outro membro do time invoca via slash command. **Conhecimento codificado**, executado por máquina, escalado pra todo time.

Não é mágica. Não substitui senioridade. Mas é a primeira vez que eu vejo "processo de time" sair do papel e virar comportamento real e repetível, sem depender de alguém policiar.

E isso é VALIOSO demais pra ignorar.

Por isso a gente da Nextside roda Claude Code + superpowers em todo Sprint. Não como ferramenta de produtividade. Como **forma de garantir que o jeito Nextside de trabalhar acontece toda vez, sem precisar do humano lembrar**.

Quem documenta processo em PDF tá lutando guerra antiga. Quem codifica processo em skill tá entregando enquanto o outro escreve playbook.
