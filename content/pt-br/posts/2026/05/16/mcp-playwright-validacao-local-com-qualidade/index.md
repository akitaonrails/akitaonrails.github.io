---
title: "MCP Playwright: validação local com qualidade real"
date: 2026-05-16T12:00:00-03:00
draft: true
translationKey: mcp-playwright-validacao-local-com-qualidade
category: tecnologia
tags: [mcp, playwright, claude-code, qualidade, testes]
author: pablo-winter
description: "Antes de pedir review humano, o Claude com MCP Playwright já navegou seu app, tirou screenshot e flagou regressão. Local, no seu dev, em segundos."
cover: covers/mcp-playwright-validacao-local-com-qualidade.png
cover_alt: "Symbol Nextside em vermelho sobre fundo creme, ilustração placeholder da capa do post."
cta:
  servico: discovery
  posicao: ambos
  contexto: "Validar tech nova antes de comprar a ideia? A gente faz num Discovery."
canonical: ""
---

Cenário recorrente: você termina uma feature de frontend, dá `git diff`, parece tudo certo, comita. Cinco minutos depois alguém abre PR e diz "o botão sumiu em mobile". Bem-vindo ao buraco da regressão visual. Pergunta: dá pra pegar isso antes do PR? Resposta seca: dá. E o caminho mais barato hoje passa por MCP + Playwright.

Antes de pedir review humano, o Claude com MCP Playwright já abriu seu app, navegou pela página nova, tirou screenshot em mobile e desktop, conferiu console por erro JavaScript, e flagrou se algum elemento sumiu. Tudo local, no seu próprio dev, em segundos. Sem CI. Sem servidor externo. Sem deploy de preview.

E o melhor: você nem programa nada. Só pede.

## O que é MCP, sem o palavreado

MCP — **Model Context Protocol** — é um protocolo aberto criado pela Anthropic pra ligar LLMs a ferramentas externas. Pensa em USB pra IA: padrão único, plug, e qualquer LLM compatível conversa com qualquer "MCP server" do mercado.

Antes de MCP, integrar IA com ferramenta externa era artesanal. Cada cliente (Claude Code, Cursor, Continue) tinha sua própria forma de invocar tools. Cada tool precisava de adaptador específico. Caos.

MCP padroniza isso. Você tem três pedaços:

- **Cliente** — o app onde a IA roda (Claude Code, Claude Desktop, etc.)
- **Servidor MCP** — processo separado que expõe ferramentas via protocolo. Pode rodar local, remoto, em containers, qualquer lugar.
- **Tools/Resources** — o que o servidor expõe. "navegue pra URL X", "leia este arquivo", "execute essa query".

Cliente pergunta ao servidor o que ele oferece. Servidor responde com lista de tools. IA escolhe a tool, manda parâmetros, servidor executa, responde. Simples. Padronizado. Universal.

Tem servidor MCP pra praticamente tudo hoje: GitHub, Linear, Notion, Postgres, browser via Playwright, filesystem, Slack. Você pluga o que precisa. A IA passa a operar essas ferramentas como se fossem extensões do próprio cliente.

## Playwright como MCP server: por que importa

Playwright é a stack de automação de browser do Microsoft. Headless ou não. Cross-browser (Chromium, Firefox, WebKit). API consistente, performante, com excelente DX. O que Selenium queria ser e nunca conseguiu.

Quando alguém empacota Playwright como MCP server, acontece o seguinte: o Claude ganha **olhos no browser**. Literalmente. Ele consegue:

- Abrir página em URL
- Tirar screenshot
- Ler o DOM via accessibility snapshot
- Clicar em elemento
- Preencher formulário
- Esperar elemento aparecer
- Verificar console por errors
- Inspecionar requisição de rede
- Executar JavaScript arbitrário no contexto da página

Tudo isso através de comandos que o LLM escolhe baseado no contexto. Você não precisa escrever spec de teste. Você descreve em linguagem natural — "valide se o card de post abre corretamente em mobile 375px" — e Claude monta a sequência: navegar, redimensionar viewport, clicar, esperar, screenshot, verificar.

Pra quem nunca usou: parece feitiço. Pra quem usou: vira hábito em 3 dias.

> "Mas isso não é só mais um wrapper de Playwright?" — não. Wrapper exige você escrever código. MCP Playwright deixa a IA escolher o passo certo baseado no contexto da tarefa. Diferença não é técnica — é de abstração. Você sai do "como" e fica no "o quê".

## Fluxo real: validar UX de um post antes do commit

Pra ilustrar, fluxo que a gente da Nextside usa nesse próprio blog. Toda vez que um post novo sai do [agent revisor-akita codificado via Claude Code superpowers](/posts/2026/05/16/claude-code-superpowers-plugin-na-pratica/) pronto pro commit, lança um agent dedicado de **UX review** que usa MCP Playwright. Sequência:

- **Sobe Hugo local** — `hugo server -D --port 1313`
- **Lança o agent** — descreve a tarefa: "valide o post X em light/dark e em mobile 375px/desktop 1280px"
- **Claude navega via MCP Playwright** — abre `localhost:1313/posts/.../{slug}/`, espera carregar, tira screenshot
- **Inspeciona console** — verifica se tem JS error, warning de fonts, ou aviso de imagem broken
- **Toggle dark mode** — clica no toggle de tema, espera transição, tira screenshot
- **Resize pra mobile** — redimensiona viewport pra 375px, screenshot
- **Reporta** — markdown com prints embedded + checklist (✓ contraste, ✓ tipografia, ⚠ código longo overflow em mobile, ✓ ember glow só no CTA)

Tempo total: 30 a 90 segundos. Custo: zero infra extra. Saída: relatório que eu, humano, leio em 2 minutos e decido se commito ou ajusto.

Compara com o fluxo antigo:
- Abrir manualmente no Chrome: 15s
- Abrir DevTools, simular mobile: 20s
- Ver dark mode: 10s
- Ver console: 10s
- Esquecer de testar uma das combinações pelo menos uma vez por semana: garantido

E aqui mora o ganho real. Não é velocidade — é **consistência**. O Claude não esquece de testar dark mode. Não pula mobile na pressa. Não diz "ah, depois eu vejo o console". Toda vez que roda, roda tudo.

**Disciplina automatizada bate disciplina humana cansada.**

## Cenário concreto: PO escreve, IA valida

Olha como isso vira fluxo real. Quinta de manhã, o PO escreve no Notion um cenário em Gherkin:

```gherkin
Funcionalidade: Checkout com cupom de desconto
  Como cliente
  Quero aplicar um cupom no checkout
  Para pagar menos no pedido

  Cenário: Cupom válido aplica desconto
    Dado que estou na página de checkout
    E meu carrinho tem 2 itens somando R$ 200
    Quando eu insiro o cupom "NEXTSIDE10" no campo de desconto
    E clico em "Aplicar"
    Então o total deve cair para R$ 180
    E uma mensagem "Cupom aplicado: 10% off" deve aparecer
    E o botão "Finalizar pedido" deve continuar habilitado
```

A dev abre o terminal, e em vez de escrever teste E2E no Playwright manualmente (15-30min), passa pra IA:

```
Valida o cenário Gherkin abaixo no app rodando em http://localhost:3000.
Use o MCP Playwright. Reporta cada Then com ✅ ou ❌ + screenshot 
quando algo falhar. Não corrija o código — só audita.

<cola o Gherkin aqui>
```

A IA com MCP Playwright:

1. Abre o browser em `http://localhost:3000/checkout`
2. Valida que está na página de checkout (`networkidle` + `<h1>Checkout</h1>` visível)
3. Lê o DOM e confirma 2 itens no carrinho somando R$ 200
4. Preenche o campo "cupom" com `NEXTSIDE10`
5. Clica no botão "Aplicar"
6. Aguarda mudança no DOM (`expect(total).toContain('180')`)
7. Verifica visibilidade da mensagem "Cupom aplicado: 10% off"
8. Verifica que o botão "Finalizar pedido" continua `enabled`

Reporte de volta:

```
✅ Cenário: Cupom válido aplica desconto
  ✅ Dado: na página de checkout (h1 visível, URL correta)
  ✅ E: 2 itens, total R$ 200 (lido do .cart-total)
  ✅ Quando: cupom NEXTSIDE10 aplicado
  ✅ Então: total atualizou pra R$ 180
  ✅ E: mensagem de sucesso visível
  ❌ E: botão "Finalizar pedido" está DISABLED

Screenshot do estado final: /tmp/checkout-disabled-btn.png
Suspeita: regressão no cupom-success-handler que setou disabled=true 
por engano após aplicar desconto.
```

Tempo total: **35 segundos**. Sem teste E2E escrito, sem stub, sem mock. **Validou contra o app de verdade, no seu localhost, antes do PR ir pra review.**

> "Mas isso não substitui CI/CD com Playwright real?"

Não substitui. CI/CD continua rodando o suite completo no PR. Esse fluxo é o **pre-flight**: antes de você abrir o PR, antes do CI gastar 6min, antes do reviewer humano abrir tab pra ver, você já sabe que o cenário do PO passa ou falha. A regressão acima — botão DISABLED por engano — é exatamente o tipo de bug que aparece em produção 2 sprints depois porque ninguém testou esse path manual.

O Gherkin do PO virou input executável. **A documentação de aceitação virou teste de aceitação rodando.** Sem ninguém escrever código de teste.

## O que muda vs teste E2E tradicional

Aqui um ponto importante pra não confundir. MCP Playwright não substitui sua suíte E2E em CI. ABSOLUTAMENTE NÃO. Os dois resolvem coisas diferentes.

E2E tradicional (Playwright spec rodando em CI):
- **Roda automático em todo PR** — bloqueia merge se quebrar
- **Especificado em código** — assertion explícita, versionada, revisada
- **Cobre regression suite inteira** — não depende de você lembrar
- **Lento** — minutos por execução, exige infra de CI

MCP Playwright no Claude local:
- **Roda quando você pede** — não bloqueia nada por padrão
- **Especificado em linguagem natural** — flexível mas não versionado
- **Cobre o que você descreve na hora** — depende da instrução
- **Rápido** — segundos por execução, zero infra

Caso de uso ideal: **MCP Playwright é pra a primeira camada de validação, ANTES de você pedir review humano**. É o sanity check que você faria com as mãos, automatizado. Não é a rede de segurança da CI. É o pré-voo.

Suíte E2E real continua sendo necessária pra:
- Regression bloqueante em PR
- Cobertura crítica de fluxos de pagamento, auth, etc.
- Documentação executável do comportamento esperado

MCP Playwright é necessário pra:
- Sanity check rápido durante desenvolvimento
- Validação visual de feature em mudança ativa
- "Será que quebrou algo?" antes de pedir review

São complementares, não rivais. Quem trocar suíte E2E por MCP Playwright vai sentir saudade quando der refactor grande e nada quebrar no CI mas tudo quebrar em produção.

## Limites e armadilhas

Calma lá. Tem armadilha:

- **Não é determinístico como teste em código** — você descreve "valide o card", Claude interpreta. Duas execuções podem checar coisas levemente diferentes. Pra sanity check é OK. Pra regression bloqueante, não.
- **Custo de tokens** — cada screenshot consumido pelo Claude vira input. Em sessão longa, isso pesa. Cure o que você manda inspecionar.
- **Falhas silenciosas** — se Claude não enxergou algo, ele não reporta. Falso negativo. Você precisa instruir bem o que olhar.
- **Setup do servidor MCP** — instalar o MCP server local, configurar no Claude Code, garantir que browser tá disponível. Primeira vez leva tempo. Depois esquece.
- **Local-only** — MCP Playwright no Claude Code roda na sua máquina. Não é solução pra QA em ambiente compartilhado. Pra isso, ainda é Playwright tradicional em CI.

E tem uma armadilha de cultura: **dev vira preguiçoso em escrever teste real porque "Claude testa pra mim"**. Isso é cilada. MCP Playwright complementa teste, não substitui. Quem usar como substituto vai aprender da pior maneira — quando a feature crítica quebrar em produção sem teste cobrindo.

> "Mas se MCP Playwright é tão bom, pra quê CI?" — porque CI bloqueia o que humano esquece. MCP Playwright só roda se você pedir. CI roda sempre. O CI é o seguro, o MCP é o pré-voo. Tira o seguro, e na primeira batida você lembra.

## O que isso diz sobre o futuro do QA local

Aqui o ponto que importa.

Por muito tempo, validação local de frontend foi ruim. Você abria browser, abria DevTools, lembrava (ou não) de testar mobile, lembrava (ou não) de testar dark mode, lembrava (ou não) de checar console. Toda vez. Manualmente. Cansando.

Resultado: bug visual virava bug de produção. Não porque o dev é ruim — porque o cérebro humano não é máquina de checklist confiável depois de 4 horas de pair programming.

MCP Playwright muda esse jogo porque deixa o **checklist virar código** que outra entidade — a IA — executa por você. Você nunca mais esquece de testar dark mode. Você nunca mais comita sem ver o console. Não porque você ficou melhor — porque o processo agora roda sozinho. É a mesma lógica que aplicamos pra [documentar decisão técnica em ADRs no Notion](/posts/2026/05/16/adrs-decisao-no-notion-sem-burocracia/): tira da memória humana, bota num formato que sobrevive ao cansaço.

Isso é o que mais me empolga em MCP de modo geral: é a primeira vez que vejo automação de tarefas chatas com IA dando resultado REAL, não promessa. Playwright é só o exemplo mais maduro. Vai ter MCP server pra tudo que você odeia fazer mas precisa fazer. E quando dá pra avaliar tech nova em 2 semanas em vez de comprar a ideia inteira, [Discovery é o formato certo](https://nextside.tech/#discovery) — não precisa apostar 6 meses pra saber se MCP cabe no seu pipeline.

E o time que adotar primeiro vai ganhar consistência que time que não adotar nunca vai conseguir replicar com força de vontade.

Por isso a gente da Nextside roda MCP Playwright em todo agent de UX review. Não como gimmick de IA. Como **forma de garantir que o checklist boring acontece toda vez, sem depender de eu lembrar às 23h de sexta**.

A IA cansa menos que você. Use isso a seu favor.
