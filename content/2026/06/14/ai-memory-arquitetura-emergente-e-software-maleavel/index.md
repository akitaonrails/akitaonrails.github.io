---
title: "ai-memory: arquitetura emergente e software maleável"
slug: "ai-memory-arquitetura-emergente-e-software-maleavel"
date: '2026-06-14T14:00:00-03:00'
draft: false
translationKey: ai-memory-emergent-architecture-malleable-software
description: "Em 24 dias, contribuidores levaram o ai-memory de um MVP pessoal a um sistema multiplataforma e multiusuário. A arquitetura nasceu do uso e só depois foi consolidada."
tags:
- ai-memory
- arquitetura-de-software
- agile
---

Há umas três semanas eu publiquei o [post explicando o ai-memory](/2026/05/23/criei-sistema-memoria-agentes-codigo-ai-memory/), meu sistema de memória de longo prazo pra agentes de código. A ideia central, pra quem não leu: dar pro Claude Code, Codex, OpenCode e companhia um cérebro compartilhado que persiste entre sessões, uma wiki versionada em git com busca FTS, handoff entre agentes, e consolidação opcional via LLM. Cada projeto isolado, rodando local ou self-hosted, sem mandar seu contexto pra nuvem de ninguém.

Pois é. Em três semanas esse projetinho cresceu de um jeito que merece um post só sobre o **processo**, porque ele virou um exemplo vivo de uma coisa que eu prego há tempos: software de verdade é cultivado, igual planta. Ninguém monta software bom peça por peça como quem monta um Lego. Vou te mostrar os números, e principalmente a história que eles contam.

## Os números, hoje

O ai-memory tem hoje, em 24 dias de vida (do primeiro commit em 21 de maio até agora):

- **482 commits** no `main`, uma média de 20 por dia.
- **26 pessoas** commitaram no repositório.
- **10 crates** Rust no workspace.
- **~62,7 mil linhas** de Rust de produção, mais **~11 mil linhas** de teste em `tests/`, mais de **1.000 funções de teste** e 90 módulos `#[cfg(test)]` espalhados pelo código.
- **~19,7 mil linhas** de documentação em markdown (`docs/`).
- **70 pull requests**, dos quais **59 mergeados** (84% de aceitação).
- **27 issues**, **100% fechadas**.
- Saímos do `v1.0.0` em 12 de junho e já estamos no `v1.0.6`.

Vinte e quatro dias. Guarda esse número, porque a parte interessante não é o tamanho final, é a forma como ele chegou aqui.

## Como começou: um só de tudo

O ai-memory nasceu pequeno e burro de propósito. Nos dois primeiros dias eu cravei o esqueleto inteiro: bootstrap do workspace, servidor MCP, captura por hooks, handoff entre agentes, versionamento da wiki em git, trait de provider de LLM, embeddings. Tudo isso rodando pra **um usuário, uma máquina, um workspace, uma arquitetura** (Linux, basicamente). Sem multi-usuário, sem permissão, sem escopo, sem suporte a Windows ou macOS. Era o meu cérebro de agente, na minha máquina, pra mim.

No dia 3, quando a [primeira contribuição externa chegou](https://github.com/akitaonrails/ai-memory) (um fix do Lucas Oliveira pra URLs de provider OpenAI-compatível, o PR #6), o projeto tinha **102 commits e cerca de 22,9 mil linhas** de código-fonte. Já eram os mesmos 10 crates de hoje, mas com uma fração da funcionalidade. Era um MVP de um-só-de-tudo que funcionava pra mim e mais ninguém.

E aqui é onde a maioria dos projetos morre, ou pior, onde a maioria dos programadores inexperientes erra a mão.

## A falácia do Lego

Tem uma crença muito difundida, principalmente em quem está começando, de que dá pra desenhar tudo que um software **vai ser** antes de escrever a primeira linha. Você senta, planeja a arquitetura inteira, quebra em pedacinhos bem organizados, com as pastas e as camadas e as interfaces todas previstas, e aí constrói peça por peça. Quando a última peça de Lego se encaixa, o software está pronto. Lindo no papel.

Na prática, é o caminho mais rápido pra deteriorar código. Quanto mais cedo você cristaliza uma estrutura, mais cedo ela vira uma camisa de força. Você previu um sistema de permissões elaborado antes de ter usuários? Parabéns, agora você carrega o peso de manter abstração que ninguém usa, e que quase sempre está errada, porque você a desenhou adivinhando o futuro em vez de responder a uma necessidade real. O programador inexperiente faz engenharia em excesso no começo, e não importa o quanto ele planeje, o resultado começa a apodrecer rápido, porque ele está resolvendo problemas que ainda não existem e errando os que existem.

Eu não acredito em software que termina. Já escrevi sobre isso no ["Software nunca está pronto"](/2026/03/01/software-nunca-esta-pronto-4-projetos-a-vida-pos-deploy-e-por-que-one-shot-prompt-e-mito/), e ele se conecta direto com as metodologias Agile originais, as de verdade, antes de virarem ritual corporativo de post-it. Software bom é uma escultura de barro: maleável, sempre úmida, que você fica ajustando, transformando, e que nunca fica pronta. É argila que você modela enquanto ela é usada. A torre de Lego que uma hora fica pronta e acabou é fantasia.

## O que os contribuidores construíram

E é aí que entra a melhor parte de ter aberto o código. Aquele MVP de um-só-de-tudo virou um sistema multiplataforma e multiusuário porque **muita gente** colocou a mão. Eu quero agradecer nominalmente, porque sem essas pessoas o projeto seria uma fração do que é:

[**Djalma Júnior**](https://github.com/djalmajr) tocou boa parte da arquitetura pesada (multi-usuário, admin, recall cross-project), com 25 PRs mergeados. [**wlech**](https://github.com/wblech) com dezenas de commits. [**Pedro de Freitas Jr**](https://github.com/pedrofjr) em embeddings e correções de web. [**Mauro Couto de Paiva**](https://github.com/mrpaiva) e [**Gustavo Cateim**](https://github.com/CaTeIM) tocaram boa parte do suporte a Windows. [**Pablo Winter**](https://github.com/pablowinck), [**Lucas Oliveira**](https://github.com/lucasliet) (autor do primeiro PR externo) e **Said Rodrigues**, entre vários outros. Valeu demais, gente.

O que essas contribuições adicionaram, em destaque:

- **Suporte real a Windows, macOS e Linux.** O que era Linux-only ganhou compatibilidade com bash 3.2 do macOS, um índice de arquivos NTFS pra rastrear inode no Windows, e comandos de hook nativos por plataforma.
- **Frontend API (`/api/v1`) e UI web customizável.** Deixou de ser só MCP + CLI e ganhou uma superfície HTTP de verdade, com links de wiki clicáveis e busca por caminho de arquivo.
- **Multi-usuário com atribuição.** Tabela de `users`, comandos de writer/reader, e atribuição de autoria na mesma transação SQL da escrita (`pages.author_id` + frontmatter).
- **Multi-workspace e recall cross-project.** Busca global, links entre wikis de projetos diferentes, e isolamento de projeto ativo por sessão e por ator.
- **Mais providers e mais agentes.** Gemini, Copilot via OAuth, OpenAI-compat strict mode; e suporte a Antigravity, Grok e VS Code Copilot além dos originais.
- **Robustez operacional.** Recuperação por checkpoint, `reindex-from-wiki` pra reconstruir o índice a partir do markdown, manifestos `_meta.md` auto-descritivos.

Repara numa coisa: nada disso estava no plano original. Não existia plano original. Cada uma dessas features entrou porque alguém precisou dela, abriu uma issue ou um PR, e a estrutura foi cedendo espaço pra acomodar. O multi-usuário não foi previsto: ele emergiu.

## E só agora a gente parou pra consolidar

Aqui está o ponto central do post. Durante essas três semanas, o código cresceu meio bagunçado de propósito. Quando o suporte a multi-usuário entrou, a lógica de "qual workspace e projeto esse pedido está mirando" foi parar **embutida direto no meio** de vários handlers do servidor MCP, da API web, do admin, espalhada e duplicada. Cada lugar resolvia escopo do seu jeito. Tinha duplicação. Tinha código que não era bonito. E está tudo bem, porque estava funcionando, e funcionando pra muita gente.

Só **depois** que o software já rodava na máquina de dezenas de pessoas, em três sistemas operacionais, com multi-usuário de verdade em produção, é que eu parei e falei: "ok, agora é uma boa hora pra refatorar e repensar a fiação interna". O penúltimo commit grande, o [`refactor: centralize scope auth and wiki consistency`](https://github.com/akitaonrails/ai-memory), fez exatamente isso, com 1.239 linhas adicionadas e 249 removidas, criando um `ScopeResolver` central de 601 linhas e um `ActorContext` consolidado.

Veja o "antes". Esse trecho de resolução de escopo vivia duplicado, com variações, em vários métodos:

```rust
// ANTES: lógica de escopo embutida, repetida em cada handler
let active = self.active_project.get_for(actor);
if let Some(name) = explicit_project.map(str::trim).filter(|s| !s.is_empty()) {
    if let Some((active_ws, _)) = active
        && let Ok(Some(pid)) = self.reader.find_project(active_ws, name.to_string()).await
    {
        return Ok((active_ws, pid));
    }
    if active.map(|(ws, _)| ws) != Some(self.workspace_id)
        && let Ok(Some(pid)) = self
            .reader
            .find_project(self.workspace_id, name.to_string())
            .await
    {
        return Ok((self.workspace_id, pid));
    }
    return Err(McpError::internal_error(
        format!("project '{name}' not found in the active or default workspace"),
        None,
    ));
}
Ok(active.unwrap_or((self.workspace_id, self.project_id)))
```

E o "depois". A mesma resolução, agora delegada pra uma autoridade única no crate de store:

```rust
// DEPOIS: um resolvedor central, uma chamada
fn scope_resolver(&self) -> ScopeResolver<'_> {
    ScopeResolver::new(&self.reader, self.workspace_id, self.project_id)
        .with_writer(&self.writer)
        .with_active_project(&self.active_project)
}

// ... e cada handler vira isto:
self.scope_resolver()
    .resolve_current_or_project(explicit_project, actor)
    .await
    .map(ai_memory_store::ResolvedScope::as_tuple)
    .map_err(Self::scope_error)
```

Três métodos diferentes que antes carregavam 30 linhas de lógica embutida cada um, com `lookup_ids`, fallback de workspace e tratamento de erro próprio, colapsaram em uma chamada cada. Junto vieram os commits irmãos: `harden multi-user admin auth boundaries` e `prevent scoped fallback bleed`. Centralizar permissão, escopo de workspace e usuário, e consistência da wiki, tudo num lugar só, com regra clara.

O detalhe que importa: o `ScopeResolver` não foi inventado no começo do projeto adivinhando que um dia ia ter multi-usuário. Ele foi **extraído** de um código que já existia, já funcionava, e já tinha mostrado, na prática, quais eram os padrões que se repetiam. A abstração veio depois do uso, não antes. Eu deixei a estrutura emergir do código, e só quando ela ficou óbvia eu a consolidei.

## A ordem certa: make it work, make it right, make it fast

Esse é o resumo de tudo. Tem um ditado antigo, atribuído ao Kent Beck, que eu carrego como mantra: **"make it work, make it right, make it fast"**. Faça funcionar, depois faça direito, depois faça rápido. Nessa ordem. A maioria dos programadores inexperientes quer fazer "direito" e "rápido" antes de fazer "funcionar", e aí inventa regra sem ter código pra justificar a regra.

O ai-memory seguiu a ordem certa sem eu nem pensar muito nisso. Primeiro fiz funcionar pra uma pessoa, escopo simples. Depois fiz funcionar uma feature de cada vez, refatorando e endurecendo o código no caminho, mas sem nunca cair na engenharia em excesso e sem nunca reescrever do zero pra encaixar numa estrutura pré-concebida. Eu deixei as estruturas atuais emergirem do código que foi sendo adicionado. Isso significou conviver com alguma duplicação e algum código meia-boca por um tempo, até bater aquele momento de "agora sim é hora de refatorar e repensar a fiação". E só agora, com o software maduro e em uso, é que eu estabeleci padrões e regras melhores pra código novo. Regras lastreadas em código de verdade, não em adivinhação.

KISS, "keep it simple", é sobre não resolver problema que você ainda não tem. Não tem nada a ver com escrever pouco código. É deixar a arquitetura emergir do código, e não o contrário. Você não desenha a escultura e despeja o barro dentro do molde. Você pega o barro, começa a modelar, e a forma aparece conforme suas mãos trabalham. O molde, se um dia precisar de um, você constrói depois, em volta da forma que já existe.

Vinte e quatro dias, 482 commits, 26 pessoas, e nenhum deles seguiu um diagrama desenhado no dia 1. Porque não existia diagrama no dia 1. E é exatamente por isso que funcionou.

O ai-memory é open source e continua mudando toda semana: [github.com/akitaonrails/ai-memory](https://github.com/akitaonrails/ai-memory). Quer ajudar a modelar o próximo pedaço? Tem issue aberta esperando.
