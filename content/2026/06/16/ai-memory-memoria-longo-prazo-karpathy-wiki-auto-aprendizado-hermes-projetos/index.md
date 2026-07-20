---
title: "ai-memory: memória de longo prazo (Karpathy Wiki) e auto-aprendizado (Hermes) pros seus projetos"
slug: "ai-memory-memoria-longo-prazo-karpathy-wiki-auto-aprendizado-hermes-projetos"
date: '2026-06-16T10:00:00-03:00'
draft: false
translationKey: ai-memory-long-term-memory-karpathy-wiki-hermes
description: "O ai-memory transforma sessões de agentes em uma wiki Markdown consultável, com hooks, MCP e handoff entre ferramentas. Um loop inspirado no Hermes promove memórias com validação, evidência e revisão opcional."
tags:
- ai-memory
- agentes-de-codigo
- llms
---

Ontem eu publiquei um post sobre como o [ai-memory virou um exemplo vivo de arquitetura emergente](/2026/06/14/ai-memory-arquitetura-emergente-e-software-maleavel/). Aquele post era mais sobre processo: como um projeto pequeno, feito pra mim, foi crescendo com contribuições reais até virar um sistema multiusuário, multiplataforma, com suporte a vários agentes e um monte de aresta que só aparece quando gente de verdade começa a usar.

Hoje quero falar do outro lado: **pra que isso serve no dia a dia** e como o projeto incorpora uma ideia inspirada no **[Hermes Agent](https://github.com/NousResearch/hermes-agent)**: um loop de auto-aprendizado com validação, trilha de auditoria e uma opção de revisão manual quando você quer mais controle.

Se você caiu de paraquedas, a sequência até aqui foi:

1. Primeiro escrevi sobre [memória de agentes, Karpathy LLM Wiki e agentmemory](/2026/05/18/memoria-agentes-karpathy-llm-wiki-agentmemory/). Ali eu ainda estava avaliando o [`agentmemory`](https://github.com/rohitg00/agentmemory) original.
2. Depois eu publiquei o post principal: [criei um sistema de memória pra agentes de código: ai-memory](/2026/05/23/criei-sistema-memoria-agentes-codigo-ai-memory/). Esse é o texto que explica a base do projeto.
3. No [toolkit de IA](/2026/05/24/dicas-e-toolkit-de-ia-do-akita-ai-jail-ai-memory-ai-usagebar/), eu posicionei o ai-memory junto com `ai-jail` e `ai-usagebar`: ferramentas pequenas pra resolver dores reais de quem usa agentes todo dia.
4. E ontem veio o post de [arquitetura emergente](/2026/06/14/ai-memory-arquitetura-emergente-e-software-maleavel/), mostrando como o projeto evoluiu com contribuidores.

Esse post é a continuação prática. A ideia do ai-memory é transformar sessões longas de desenvolvimento numa **wiki de projeto** que um agente consegue consultar daqui a semanas, sem você virar suporte humano de contexto.

## O problema real: sessão longa vira amnésia longa

Quem usa [Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview), [Codex](https://github.com/openai/codex), [OpenCode](https://opencode.ai/), [Cursor](https://cursor.com/), [Gemini CLI](https://github.com/google-gemini/gemini-cli) ou qualquer agente desses já conhece o ciclo. Você começa uma sessão, explica o projeto, mostra os arquivos importantes, corrige uma alucinação, descobre uma armadilha, decide uma arquitetura, roda teste, falha, corrige, roda de novo. Depois de duas horas, o agente finalmente está "aquecido". Ele sabe o que não deve fazer. Sabe onde estão os buracos. Sabe que aquela função parece errada mas existe por compatibilidade legada. Sabe que o teste só passa se subir o serviço X antes.

Aí a sessão acaba.

No dia seguinte você abre outro agente, ou o mesmo agente em outra janela, ou troca de Claude Code pra Codex porque quer comparar. E começa tudo de novo. "Não, esse projeto usa isso." "Não, já tentamos esse caminho." "Não, essa API não existe." "Não, esse arquivo é gerado." Você vira o cache humano do agente.

Janela de contexto grande ajuda só até certo ponto. Ela pertence à sessão atual, não ao mês inteiro do projeto. E contexto bruto continua sendo contexto bruto. Jogar cem mil tokens de log dentro do prompt é diferente de ter uma página curta dizendo:

- decisão: usamos SQLite como índice derivado, markdown é a fonte da verdade;
- armadilha: no Windows não confie em inode, use índice próprio;
- regra: não editar `content/_index.md` manualmente, rodar o gerador;
- procedimento: pra publicar post novo, escrever PT primeiro, humanizar, validar Hugo, só traduzir depois de aprovação.

Isso é memória útil. Não é transcrição. É síntese.

## O modelo mental: Karpathy Wiki

O nome que eu gosto pra esse padrão é o que o Karpathy chamou de **[LLM Wiki](https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f)**: em vez de depender de histórico bruto, você mantém uma wiki em markdown, versionada, que o agente consegue consultar. Páginas pequenas, com nomes estáveis, separadas por tipo de conhecimento. O agente não precisa lembrar tudo. Ele precisa saber procurar.

<figure>
  <a href="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/06/15/ai-memory-hermes/architecture-overview.svg">
    <img src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/06/15/ai-memory-hermes/architecture-overview.svg" alt="Diagrama da arquitetura do ai-memory: clientes de agente enviam hooks e chamadas MCP para o servidor, que escreve em uma wiki markdown e mantém SQLite como índice derivado." />
  </a>
  <figcaption>Visão geral da arquitetura do ai-memory. A fonte do diagrama está em <a href="https://github.com/akitaonrails/ai-memory/blob/main/docs/architecture-overview.svg">docs/architecture-overview.svg</a>.</figcaption>
</figure>

O ai-memory implementa isso com uma ideia simples: hooks capturam o que aconteceu, o servidor organiza o material numa wiki markdown e os agentes consultam essa wiki quando precisam continuar o trabalho.

Algumas páginas são resumos de sessão. Outras viram decisões, armadilhas, procedimentos ou regras do projeto. O usuário não precisa decorar a taxonomia. O ponto é que o conhecimento deixa de ficar preso na janela do chat e passa a existir como arquivo legível.

Repara nessa última parte: a fonte de verdade é markdown. Você pode abrir no Obsidian, fazer `grep`, versionar, fazer backup com `rsync`, ver diff no git. O banco SQLite ajuda na busca, mas é índice derivado. Se amanhã eu jogar o banco fora, o sistema consegue reconstruir o índice a partir da wiki.

É aqui que eu fico chato. Quero arquivo que eu consigo ler, não uma caixa-preta de embeddings que "talvez" lembre.

## A base: memória que atravessa agentes

Desde cedo, o ai-memory já resolvia a dor principal: **contexto que sobrevive ao agente usado naquele momento**.

Você podia encerrar uma sessão no Claude Code, abrir Codex no mesmo diretório, e o próximo agente receber um resumo curto dizendo onde parou, quais perguntas ficaram abertas e quais próximos passos faziam sentido.

Além disso, o agente podia consultar a wiki antes de responder. Em vez de depender só do que ainda cabe na janela de contexto, ele podia procurar decisões antigas, armadilhas conhecidas, páginas recentes e regras permanentes do projeto.

Na prática, o agente para de responder arquitetura no chute. Ele pode consultar: "o que a gente decidiu sobre autenticação?", "já tentamos usar Redis aqui?", "qual era a armadilha do Docker nesse projeto?". E o resultado não vem como mil eventos crus, vem como página de wiki.

Em projeto de software isso faz diferença porque "qual arquivo existe" é a parte fácil. Isso o agente acha com `grep`. O conhecimento caro é **por que** uma coisa é daquele jeito. Por que deixamos biblioteca X de lado. Por que esse teste é estranho. Por que a configuração de CI tem uma exceção. Por que aquela refatoração foi adiada.

É isso que uma memória de longo prazo precisa preservar.

## O que veio do uso real

Ontem eu citei alguns números e agradeci contribuidores, mas vale reforçar as funcionalidades novas porque elas mudam o perfil do projeto. O ai-memory deixou de ser "meu daemon local" e virou algo que dá pra rodar num homelab ou servidor compartilhado.

O resumo das mudanças é:

- **Dá pra usar sozinho ou em equipe.** O sistema agora entende usuários, projetos e workspaces. Isso permite rodar num homelab ou servidor compartilhado sem misturar clientes, repositórios e sessões.
- **O escopo ficou previsível.** Um arquivo `.ai-memory.toml` pode dizer a qual projeto aquele diretório pertence. Isso ajuda em monorepos, worktrees, consultoria e separação trabalho/pessoal.
- **Mais agentes conseguem participar.** Além de Claude Code, Codex e OpenCode, entraram Cursor, Gemini CLI, [Antigravity CLI](https://antigravity.google/docs/hooks), [Grok Build CLI](https://x.ai/cli), [OpenClaw](https://docs.openclaw.ai/), [Oh My Pi/OMP](https://github.com/can1357/oh-my-pi), [VS Code GitHub Copilot](https://code.visualstudio.com/docs/copilot/overview) e [Claude Desktop](https://claude.ai/download). Alguns têm hooks completos, outros só conseguem consultar via MCP, mas todos podem se beneficiar da mesma wiki.
- **Administração e recuperação ficaram menos frágeis.** Renomear ou mover projetos, restaurar páginas, reconstruir índice, usar a interface web e auditar mudanças são recursos chatos de explicar, mas importantes quando a ferramenta vira parte do fluxo diário.

Não vou entrar em cada detalhe aqui. Pra isso existe a [documentação no GitHub](https://github.com/akitaonrails/ai-memory/tree/main/docs). O importante é entender a mudança de categoria: deixou de ser um daemon local meu e virou uma memória compartilhável de projeto.

Isso veio de uso real. Djalma Júnior, wlech, Pedro de Freitas Jr, Mauro Couto de Paiva, Gustavo Cateim, Lucas Oliveira, Pablo Winter, azevedo-luis, zanlucathiago e outros foram empurrando o projeto pra cenários que eu não tinha previsto. É assim que software cresce sem virar arquitetura de PowerPoint: a necessidade puxa a arquitetura, não o contrário.

## Auto-improve: sessão vira memória

Hoje, o ai-memory já tem um loop de auto-aprendizado seguro: quando há um provedor de LLM configurado, um job de fundo pode revisar sessões novas, separar ruído de aprendizado real e transformar as lições úteis em páginas duráveis da wiki.

Esse é o ponto que importa pro usuário: você não precisa lembrar de abrir um arquivo de notas no fim do dia, nem escrever manualmente "aprendizados da sessão". Se a sessão revelou uma decisão, uma armadilha reproduzível ou um procedimento que vale repetir, o sistema consegue promover isso pra memória de projeto.

Por baixo, ele usa a sessão consolidada, procura sinais fortes, pede pra um LLM sugerir edições pequenas, valida caminhos, evidência, tamanho e confiança, registra a proposta numa trilha de auditoria e aplica a escrita pela trilha normal da wiki.

Se você quiser revisão humana antes da escrita final, basta configurar `[auto_improve] require_approval = true`. Aí as propostas ficam pendentes até alguém revisar, aprovar ou rejeitar.

No diagrama acima ele aparece do lado de manutenção, nas tarefas que dependem de LLM configurado. Não é parte do caminho quente do hook. Isso é de propósito. Hook tem que capturar rápido, devolver 202 ou 429, e sair da frente. Revisão com LLM é outra categoria de trabalho.

O detalhe importante: **isso não entra no caminho quente do agente**.

O usuário continua trabalhando normalmente. Hooks capturam a sessão. A passagem de bastão continua curta e acionável. O auto-improve roda como manutenção: olha pra trás, identifica o que merece sobreviver e transforma aprendizado em memória consultável. A funcionalidade existe pra responder uma pergunta:

> "O que essa sessão ensinou que vale transformar em memória permanente?"

E a resposta vira conhecimento reaproveitável, com rastro de proposta e evidência, não um chute solto dentro do prompt.

Isso parece pequeno, mas é a diferença entre uma memória útil e um agente que polui seu projeto com lixo confiante. Se você deixa um LLM escrever regra automaticamente toda vez que algo dá errado, em uma semana sua wiki vira cemitério de superstição: "nunca use ferramenta X", "sempre rode comando Y", "biblioteca Z está quebrada". Só que muitas dessas coisas eram falhas transitórias: PATH errado, token expirado, rede fora, dependência desatualizada, erro corrigido cinco minutos depois.

Memória ruim é pior que falta de memória. Falta de memória te obriga a perguntar. Memória ruim te dá certeza falsa.

## O que é Hermes Agent

A inspiração veio do **Hermes Agent**, que trata aprendizado como parte do ciclo normal do agente. Depois de trabalhar, ele pode olhar pra trás e perguntar: "isso gerou alguma memória ou skill útil para a próxima vez?"

O ponto que me interessou foi a separação. O agente faz o trabalho primeiro. Depois, em segundo plano, revisa o que aconteceu. Existe também uma manutenção mais lenta, que procura conhecimento velho, duplicado ou pouco útil. Um loop aprende com a sessão; o outro limpa o jardim.

Essa separação evita o erro comum de criar um daemon mágico que muda tudo o tempo todo. Parece poderoso, mas fica impossível de confiar. Se quiser detalhes do estudo, deixei isso na [documentação do loop de auto-improvement](https://github.com/akitaonrails/ai-memory/blob/main/docs/auto-improvement-loop.md).

## Como adaptamos Hermes pro ai-memory

O ai-memory não copia Hermes literalmente. Hermes trabalha com memórias e skills. O ai-memory trabalha com páginas de wiki. Então a adaptação é simples: quando uma sessão ensina algo útil, o sistema tenta transformar isso em uma página pequena, legível e consultável.

O LLM sugere, mas o produto impõe fronteiras. A sugestão precisa ter evidência, caminho válido, tamanho razoável e confiança mínima. Isso evita que uma sessão confusa contamine a wiki inteira.

O desenho atual é esse:

1. A sessão termina e vira `sessions/<id>.md` como já acontecia.
2. Um job de fundo revisa sessões concluídas elegíveis, depois do watermark inicial e da idade mínima configurada.
3. O revisor procura decisões, armadilhas, procedimentos e regras que valem guardar.
4. O sistema valida a sugestão e registra o rastro de auditoria.
5. Por padrão, a memória entra na wiki; se você quiser, pode exigir revisão manual antes disso.

Essa trilha é a peça que faltava entre "o LLM sugeriu" e "isso virou verdade do projeto". Memória de projeto não pode ser uma caixa-preta.

## O tipo de coisa que deve virar memória

Essa parte é mais importante que a ferramenta: nem tudo que acontece numa sessão merece virar memória permanente.

O que vale guardar é o que ajuda o próximo agente a trabalhar melhor: uma decisão que afeta o futuro, uma armadilha reproduzível, um procedimento que vai se repetir, uma preferência explícita do usuário ou um padrão importante do projeto.

O que não vale guardar é ruído: um comando de teste, um erro transitório, uma falha causada pelo ambiente daquele dia ou uma narrativa inteira de sessão que já está preservada em `sessions/`.

Esse filtro é a diferença entre uma wiki que ajuda e uma wiki que atrapalha. O auto-improve não existe pra capturar mais coisa. Existe pra **promover seletivamente** o que merece sair da camada episódica e entrar na memória durável do projeto.

## Hooks, MCP e prompts: a parte que deixa usável

A outra metade do sistema é menos glamourosa, mas é o que faz parecer natural. O usuário trabalha normalmente. Os hooks capturam o ciclo da sessão. O MCP dá ao agente um jeito de consultar a memória. E o bloco de instruções em `CLAUDE.md` ou `AGENTS.md` ensina quando usar tudo isso.

Quando a integração é completa, a experiência fica quase invisível: você encerra uma sessão, abre outra ferramenta, e o próximo agente já tem como se orientar. Quando o cliente só suporta MCP, ele ainda consegue consultar a wiki, mesmo sem capturar todo o ciclo de vida.

O detalhe importante não é o formato específico de hook de cada ferramenta. Isso está na [documentação de instalação](https://github.com/akitaonrails/ai-memory/blob/main/docs/install.md). O importante é que o ai-memory tenta esconder essas diferenças e dar ao agente um comportamento simples: antes de decidir, consulte a memória; quando aprender algo durável, preserve.

## Por que isso deixa sessões de código mais inteligentes

O fluxo que eu quero é esse.

Você abre o OpenCode num projeto antigo. Antes de responder qualquer coisa séria, ele sabe consultar o ai-memory. Descobre que já existe uma decisão sobre banco. Descobre uma armadilha no build. Descobre que o último agente deixou uma passagem de bastão dizendo que o teste falhava em `PaymentImporter`. Você não precisa recontar a novela.

Durante a sessão, hooks registram o que acontece. No final, a sessão vira uma narrativa curta. Se foi uma sessão rica, o job de auto-improve pode transformar as lições em páginas como:

- `gotchas/payment-importer-timezone.md`;
- `decisions/use-ledger-table-for-reconciliation.md`;
- `procedures/run-importer-smoke-test.md`.

No modo padrão, isso entra como memória validada e auditável. No modo manual, você olha o diff, aprova ou rejeita. Na próxima semana, outro agente consulta e não pisa no mesmo buraco.

Esse é o ciclo que eu quero: **trabalho vira conhecimento, conhecimento melhora o próximo trabalho**. Sem virar religião de prompt, sem depender de uma janela infinita, sem confiar em memória opaca.

## Cuidado com a palavra "auto"

Tem uma armadilha de marketing aqui. "Auto-aprendizado" soa como ficção científica: o agente aprende sozinho e fica melhor pra sempre. Não é isso que eu quero vender, porque isso vira mentira rápido.

O que temos hoje é bem mais pé no chão: um job que revisa sessões, sugere memória, valida a sugestão, guarda evidência e aplica pela trilha normal da wiki. Se você preferir, existe modo de revisão manual antes da escrita final. E justamente por ser limitado ele é útil. O prompt ativo e a latência dos hooks ficam protegidos. O sistema observa, filtra, valida e deixa rastro.

Esse é o limite correto pra um sistema desses neste momento. Auto-aprovação só depois de validação estrutural e evidência. Revisão humana quando o projeto pedir. Confiança se ganha com histórico, não com entusiasmo.

## Fechando

O ai-memory começou como uma resposta simples pra uma frustração simples: cansei de reexplicar o mesmo projeto pra agentes diferentes. Em poucas semanas virou uma wiki versionada, com hooks, MCP, passagem de bastão, multiusuário, multi-workspace, arquivo marcador, suporte a vários CLIs, interface web, recuperação e agora um loop de auto-aprendizado inspirado no Hermes Agent, com validação e auditoria em vez de fé cega no LLM.

A filosofia continua a mesma: memória boa organiza conhecimento em páginas pequenas, legíveis, versionadas, citáveis. É transformar sessão longa em decisão, armadilha, procedimento, regra. É deixar o próximo agente começar do ponto onde o anterior parou.

Se você usa agente pra projeto de software de verdade, esse é o gargalo que começa a doer primeiro. Não é só modelo melhor. É continuidade.

O repositório está aqui: [github.com/akitaonrails/ai-memory](https://github.com/akitaonrails/ai-memory). Se você já usa com um provedor de LLM configurado, atualize e deixe o auto-improve trabalhar em segundo plano nas novas sessões concluídas.

Se quiser revisão manual antes de aplicar, configure:

```toml
[auto_improve]
require_approval = true
```

No modo manual, não aceite tudo. Esse é o ponto. Leia, critique, aprove só o que merece virar memória. No modo padrão, acompanhe a trilha de auditoria quando quiser entender o que foi promovido e por quê.
