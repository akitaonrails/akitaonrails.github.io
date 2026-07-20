---
title: "Controvérsia de IA em contribuições de projetos de código aberto - minha opinião"
slug: "controversia-ia-contribuicoes-projetos-codigo-aberto-minha-opiniao"
date: '2026-06-05T11:00:00-03:00'
draft: false
translationKey: controversia-ia-contribuicoes-projetos-codigo-aberto-minha-opiniao
description: "IA em contribuições open source veio para ficar, mesmo trazendo AI slop, regressões e falsos bugs. A saída prática é automatizar triagem e auditoria, sem tirar do humano a decisão final."
tags:
- open-source
- agentes-de-codigo
- engenharia-de-software
---

Nos últimos dias voltou a discussão sobre **AI slop** em projetos de código aberto. Mantenedor reclamando que PR gerado por IA é lixo. Projeto proibindo contribuição assistida por IA. Bug bounty sendo inundado por relatório falso. Usuário irritado porque um release que usou IA quebrou alguma coisa. E, claro, a internet fazendo o que a internet faz melhor: transformar caso específico em guerra santa.

Minha opinião curta: **IA em contribuição open source veio pra ficar**. Vai aumentar, não diminuir. A caixa de Pandora já abriu. Não existe plano realista onde todo mundo volta a programar 100% manualmente e finge que Claude Code, Codex, OpenCode, Cursor, Gemini CLI e o resto nunca existiram.

Isso não quer dizer que todo projeto tem obrigação de aceitar contribuição feita com IA. Longe disso. O mantenedor tem o direito absoluto de tocar o projeto como quiser. Pode aceitar IA, pode banir IA, pode congelar o projeto, pode apagar o repositório e ir plantar tomate. Código aberto não é democracia obrigatória. Quem mantém decide.

Mas também acho que banir IA é só adiar uma briga impossível de ganhar. O volume vai continuar subindo. A qualidade média vai oscilar. Vai ter lixo, vai ter coisa boa, vai ter PR quase certo, vai ter relatório de bug alucinado. A pergunta prática não é “como impedir IA?”. A pergunta prática é: **como adaptar o processo pra sobreviver a isso?**

## Os casos recentes

O caso mais barulhento agora foi o do [rsync 3.4.3](https://linuxiac.com/rsync-3-4-3-regressions-trigger-debate-over-ai-assisted-code/). A versão saiu em 20 de maio como update de segurança, corrigindo seis CVEs. Logo depois, usuários reportaram regressões, em especial em fluxos de backup com daemon mode e opções de transferência incremental. Rsync não é brinquedo. É ferramenta de backup, deploy, mirror, sysadmin. Quebrar compatibilidade ali dói.

Andrew Tridgell, criador do Samba e co-criador do rsync, respondeu no post [rsync and outrage](https://medium.com/@tridge60/rsync-and-outrage-d9849599e5a0). Ele confirmou que usou Claude, com cross-check de Codex e Gemini, pra ajudar a reescrever parte da suíte de testes em Python. Mas também disse o óbvio que muita gente não quer ouvir: ele não mandou “converte tudo aí” e foi dormir. Ele desenhou a suíte, revisou o trabalho, queimou muito tempo de CI, e assumiu que as regressões aconteceram em casos válidos, mas incomuns, que não estavam cobertos nem pelos testes existentes nem pelos testes manuais dele.

Esse é o ponto interessante: a regressão virou discussão sobre IA, mas regressão não nasceu com IA. Regressão nasceu junto com software.

Do outro lado temos o Zig. O [Code of Conduct do Zig](https://ziglang.org/code-of-conduct/) hoje tem uma política explícita: **Strict No LLM / No AI Policy**. Nada de conteúdo gerado por LLM, nem código, nem prosa, nem revisão gramatical, nem tradução, nem brainstorming. Andrew Kelley explicou em entrevista, resumida pela [DevClass](https://www.devclass.com/devops/2026/06/01/zig-creator-seeks-uncompromising-perfection-before-blessing-10/5248219), que a equipe considera contribuições de IA invariavelmente ruins, consumidoras de tempo de review, não ensináveis, não determinísticas. A frase que resume a postura dele é boa: o padrão que ele quer não é “funciona surpreendentemente bem”, é “perfeição sem compromisso”.

Eu discordo da generalização, mas respeito a decisão. É o projeto dele. Se ele quer manter aquele espaço sem LLM, é direito dele. Ponto.

Na mesma vizinhança apareceu a discussão do Bun. O [post oficial do Bun entrando na Anthropic](https://bun.sh/blog/bun-joins-anthropic) diz que Bun foi adquirido porque Claude Code e outros produtos de coding da Anthropic dependem dele. “Se Bun quebra, Claude Code quebra”, nas palavras do próprio post. Já a matéria da [Cosmic sobre a reescrita em Rust](https://www.cosmicjs.com/blog/bun-rust-rewrite-javascript-runtime) aponta motivos como acessibilidade de contribuidores, manutenção em escala e estabilidade de longo prazo. Eu vi gente ligando isso à política anti-IA do Zig, mas a fonte que consegui verificar não crava essa causalidade. O que dá pra dizer com segurança é: Bun, um projeto nascido em Zig, está migrando partes importantes pra Rust, e uma das razões citadas é a base maior de contribuidores.

E tem o caso do curl. Segundo a [Hackaday](https://hackaday.com/2026/01/26/the-curl-project-drops-bug-bounties-due-to-ai-slop/), Daniel Stenberg suspendeu o programa de bug bounty do curl a partir de 1º de fevereiro de 2026 porque o projeto foi inundado por relatórios de vulnerabilidade gerados por LLM. Relatórios compridos, intimidadores, com cara de exploit sério, mas que quando um mantenedor experiente lê, não são vulnerabilidades. O PR que remove o bounty está no GitHub como [curl/curl#20312](https://github.com/curl/curl/pull/20312).

Esse caso é diferente de PR de código. É pior. Um patch ruim você testa, compila, lê. Um relatório de segurança falso obriga alguém experiente a gastar tempo provando que não existe bug. É o tipo de trabalho ingrato que esgota mantenedor.

Então sim: o problema é real. AI slop existe. Está enchendo issue tracker, PR, bug bounty, comentário, tudo.

Agora a parte que ninguém gosta: isso não vai parar.

## Não existe “voltar ao normal”

Eu já falei disso no post [VS Code é o novo cartão perfurado](/2026/04/11/vs-code-e-o-novo-cartao-perfurado/). A interface mudou. Antes você precisava digitar instrução binária. Depois precisava organizar cartão perfurado. Depois precisava convencer o compilador. Depois precisava operar editor, terminal, framework, CI, container, cloud e YAML. Agora você precisa orquestrar agente.

Isso não elimina engenharia. Só muda onde o trabalho manual termina.

Tem gente tratando IA como se fosse moda passageira, igual “metaverso” ou NFT. Não é. IA pra programação já passou do ponto de demonstração de conferência. Está dentro do fluxo de trabalho real. O rsync usou. Bun está cheio de bot de Claude Code abrindo PR. Meus projetos usam. Seus contribuidores vão usar, mesmo que você proíba. Se você acha que consegue detectar com 100% de certeza que um patch foi escrito com ou sem IA, boa sorte com isso.

O mantenedor ainda pode impor regra. Pode dizer “se eu descobrir que usou IA, bloqueio”. Pode fazer sentido em comunidades pequenas, com cultura própria, como Zig. Mas no open source geral, principalmente projeto grande, com usuário no mundo inteiro, isso vira teatro de compliance. O sujeito usa IA, reescreve, não declara, e pronto. Você vai fazer o quê? Detector de IA em código? Pelo amor.

## O erro é achar que você precisa revisar tudo sozinho

A reclamação mais justa dos mantenedores é simples: já falta gente pra revisar contribuição humana. IA aumenta o volume. Mais PR, mais issue, mais bug report. O mantenedor já estava cansado, agora está afogado.

Eu entendo. Só acho que a solução não é tentar processar o novo volume com o processo velho.

Você combate IA com IA.

A primeira triagem tem que ser feita com LLM. Não pra aprovar automaticamente. Pra filtrar. Pra resumir. Pra comparar diff com objetivo declarado. Pra apontar cheiro ruim. Pra dizer “isso toca schema, precisa migração”. Pra dizer “isso altera comportamento público, precisa teste de compatibilidade”. Pra dizer “essa descrição do PR não bate com o código”. Só essa camada já elimina 80% do trabalho braçal.

O erro é deixar o agente decidir sozinho. O acerto é mandar o agente fazer o trabalho chato de investigação, e você decide.

É assim que eu faço.

## Meu fluxo real com PRs

Quem acompanhou minha [maratona de IA](/2026/05/14/terminando-maratona-ia-sucesso-ou-fracasso/) sabe que eu não cheguei aqui depois de assistir dois vídeos no YouTube. Passei semanas usando agente todo dia, em projeto real, quebrando coisa real, corrigindo coisa real. O que estou descrevendo aqui é o fluxo que sobrou depois disso, não teoria de LinkedIn.

Propaganda descarada: estou feliz que meus três projetos principais relacionados a IA estão recebendo contribuição quase todo dia:

- [ai-jail](https://github.com/akitaonrails/ai-jail), que já expliquei no post [ai-jail: Sandbox para Agentes de IA](/2026/03/01/ai-jail-sandbox-para-agentes-de-ia-de-shell-script-a-ferramenta-real/).
- [ai-memory](https://github.com/akitaonrails/ai-memory), que expliquei em [Criei um Sistema de Memória pra Agentes de Código: ai-memory](/2026/05/23/criei-sistema-memoria-agentes-codigo-ai-memory/).
- [ai-usagebar](https://github.com/akitaonrails/ai-usagebar), do post [Criei um Widget de Waybar pra Omarchy pra Monitorar Uso de Planos de LLM: ai-usagebar](/2026/05/24/criei-widget-waybar-omarchy-monitorar-uso-llms-ai-usagebar/).

O ai-memory em particular virou um experimento vivo. No momento em que escrevo, o GitHub mostra **55 PRs fechados** no projeto; pela API do `gh`, 46 foram mergeados e 9 foram fechados sem merge. Obrigado a todo mundo que contribuiu. Sério. Djalma, mrpaiva, pedrofjr, CaTeIM, azevedo-luis, brunoomariano, rikelmyso7, abnersajr e vários outros. É trabalho de muita gente.

![Tela de Pull Requests fechados do ai-memory no GitHub, mostrando 55 PRs fechados e vários PRs recentes de contribuidores.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/06/05/ia-open-source-contribuicoes/screenshot-ai-projects.png)

Também é óbvio, olhando o estilo, que a maioria desses PRs foi feita com ajuda de IA. E isso não é problema. Seria até hipócrita reclamar: **o ai-memory inteiro foi escrito por IA**. Eu não abri editor de código uma única vez pra escrever aquilo na mão.

Mas quase nenhum PR chega imediatamente mergeável. Esse é o ponto que muita gente ainda não entendeu. “Feito com IA” não significa “merge cego”. Significa “começa a auditoria”.

Meu prompt pra revisar PR é mais ou menos assim:

> checa o último PR aberto como de costume: não confie no autor, audita o código inteiro a fundo, garante que ele cumpre o objetivo.
>
> Vê se precisamos ajustar ou corrigir antes de mergear: não aceite regressão, não aceite queda de qualidade de código, confere se a cobertura de teste está correta.
>
> Se mexe em build ou suporte de OS, confere GitHub Actions, CI, build limpo, wiring correto e documentação.
>
> Resume o que o PR faz, o que você encontrou, e me pede aprovação antes de seguir.

Repara em duas coisas. Primeiro: “não confie no autor”. Não é grosseria. É engenharia. A descrição do PR é uma hipótese. O diff é a evidência. Segundo: “me pede aprovação”. O agente investiga, eu decido.

Quando recebo vários PRs no mesmo dia, faço isso pra todos. Depois que todos entram, mando outro prompt:

> checa os commits de hoje.
>
> Mexemos em muito código, então preciso de uma auditoria completa no código tocado pra garantir que não adicionamos regressão, duplicação desnecessária, código morto ou magic values que deveriam virar constantes documentadas.
>
> Segue princípios de clean code, confirma cobertura de testes e refatora o que precisar.

Se o projeto já está em uso, adiciono a parte que muita gente esquece:

> este projeto já está sendo usado. Não quebre compatibilidade.
>
> Se mexemos em schema de banco ou estrutura de arquivos do usuário, precisa ter migração limpa no upgrade.
>
> Upgrade não pode corromper dados.

Isso não garante nada. Mas evita erro óbvio.

No ai-memory dá pra ver esse padrão no histórico. Depois de uma leva grande de PRs, tem commits meus de endurecimento. Um exemplo é [`65682dc`](https://github.com/akitaonrails/ai-memory/commit/65682dc), “fix(audit): address 5 BLOCKING audit findings from today's review”, mexendo em OAuth OpenAI, admin API, admission hooks e servidor MCP. Outro é a sequência de PRs [`#65`](https://github.com/akitaonrails/ai-memory/pull/65), [`#68`](https://github.com/akitaonrails/ai-memory/pull/68), [`#70`](https://github.com/akitaonrails/ai-memory/pull/70), seguida de commits de hardening em base path, wikilinks e strict mode. PR entra, depois vem auditoria, depois vem ajuste. Esse segundo passo é onde mora a diferença.

No [`#77`](https://github.com/akitaonrails/ai-memory/pull/77), de auto-scope por sessão/ator, o merge mexeu em muita coisa: `active_project`, router de hooks, servidor MCP, testes de stress e multiusuário. Mais de 3.800 linhas adicionadas. Eu não vou fingir que alguém lê isso manualmente linha por linha com a mesma consistência depois da quinta hora. O agente ajuda a mapear risco. Eu uso meu julgamento pra decidir o que precisa endurecer.

## Regressão acontece com ou sem IA

O caso do rsync é útil porque expõe uma fantasia: a ideia de que código humano era seguro e código de IA é perigoso.

Não. Código é perigoso.

Rust é considerado linguagem segura. E Rust tem bug. Vai no issue tracker do Rust e olha. Zig quer perfeição e tem bug. Curl tem bug. Rsync tem bug. Linux tem bug. SQLite tem bug. Meu código tem bug. Seu código tem bug. Não existe linguagem mágica que produz software sem bug. Nunca vai existir.

Isso não é pessimismo. É limite fundamental. Em computação, a gente sabe há muito tempo que não existe verificador geral perfeito pra propriedades semânticas não triviais de programas. Halting problem, Rice's theorem, esse tipo de coisa. Você pode provar muito em domínios restritos. Pode usar type system melhor. Pode usar Rust pra eliminar classe inteira de memory safety. Pode usar teste, fuzzing, model checking, static analysis. Ótimo. Use tudo.

Mas “software arbitrário sem bug” é fantasia.

Humano erra por contexto incompleto, suposição errada, pressão, cansaço, falta de teste, falta de uso real. IA erra pelos mesmos motivos práticos: contexto incompleto, suposição errada, treino em código ruim, objetivo mal especificado, validação fraca. A diferença é escala. IA consegue produzir mais lixo por minuto. Também consegue produzir mais correção por minuto se você montar o processo direito.

## Eu uso porque eu uso

Outro ponto que aprendi na prática: é muito difícil manter bem projeto que você mesmo não usa.

Eu uso ai-memory todo dia. Uso ai-jail todo dia. Uso ai-usagebar todo dia. Usei a extensão [Prettify Manga Reader](https://github.com/akitaonrails/prettify-manga) na minha leitura real. Por isso pego bug que teste automatizado não pega.

No Prettify, por exemplo, os commits contam a história. [`66c6728`](https://github.com/akitaonrails/prettify-manga/commit/66c6728) adicionou filtro noturno. Depois veio [`b5bcb4d`](https://github.com/akitaonrails/prettify-manga/commit/b5bcb4d), release 0.2.2, com suporte a Kindle Web Reader, toolbar, shortcuts e screenshot. Logo depois veio [`0e6b7ee`](https://github.com/akitaonrails/prettify-manga/commit/0e6b7ee), release 0.2.3, corrigindo o pareamento de spreads pra manter leitura direita-pra-esquerda sem bagunçar a ordem cronológica. Isso nasceu de uso real. Eu estava lendo, achei comportamento estranho, pedi pro LLM corrigir, testei, fiz release.

Esse é o loop saudável: usar, sentir dor, corrigir, testar de novo.

Em ai-jail, algumas contribuições vieram de uso que eu não teria priorizado sozinho. O [`#56`](https://github.com/akitaonrails/ai-jail/pull/56) corrigiu PKGBUILD no AUR. O [`#55`](https://github.com/akitaonrails/ai-jail/pull/55) encaminhou OSC 52 clipboard writes pelo proxy PTY de alt-screen. O [`#51`](https://github.com/akitaonrails/ai-jail/pull/51) reconheceu Grok como agente conhecido e documentou máscara de privacidade de machine-id. São detalhes que aparecem quando outras pessoas usam a ferramenta em setups diferentes do meu.

Em ai-usagebar, isso fica mais claro ainda. O [`#4`](https://github.com/akitaonrails/ai-usagebar/pull/4) adicionou fallback de macOS Keychain pras credenciais da Anthropic. Eu estou em Linux/Omarchy, não em macOS. Eu não ia achar esse bug no meu uso diário. O [`#7`](https://github.com/akitaonrails/ai-usagebar/pull/7) corrigiu leitura de `credentials_path` customizado no widget. Também é caso de usuário com configuração diferente da minha. É aí que open source brilha: outra pessoa coça a própria coceira e melhora o projeto pra todo mundo.

Mas repare: quando eu não consigo testar manualmente, como macOS e Windows, eu dependo mais de CI. GitHub Actions roda macOS, roda Windows, roda Linux. Não substitui uso real, mas reduz risco. E quando alguém que usa aquele ambiente abre issue ou PR, isso vale ouro.

Manual testing ainda é a última linha de defesa. Se você abre mão dela, você está introduzindo bug por definição. Teste automatizado pega o que você lembrou de especificar. Uso real pega o que você nem sabia que precisava especificar.

Depois de mergear um conjunto grande, meu fluxo final costuma ser:

> agora roda `bin/deploy` no meu home server e testa online.
>
> Confere health, confere se ainda funciona como antes.

De novo: não garante nada. Mas evita quebrar o óbvio.

## Não existe bala de prata

Eu não acho que todo projeto deve aceitar PR de IA. Também não acho que todo projeto deve banir. Não existe regra universal.

Se você é mantenedor solo de uma biblioteca crítica, sem tempo, sem CI decente, sem energia pra lidar com avalanche de PR ruim, banir AI-assisted contribution pode ser a decisão certa por enquanto. Melhor isso do que aceitar lixo e quebrar usuário.

Se você mantém comunidade pequena e quer ensinar contribuidores humanos, como o Zig argumenta, uma política anti-IA faz sentido dentro daquela cultura. Você está otimizando por formação de contributor, não por throughput de patch.

Mas se você mantém projeto que já recebe volume alto, que já tem CI, que já tem teste, que já tem usuário, eu acho que a adaptação é inevitável. Você vai precisar de triagem automatizada. Vai precisar de agente revisando PR. Vai precisar de bot resumindo issue. Vai precisar de ferramenta que diga “isso parece relatório de vulnerabilidade alucinado”.

Não porque IA é perfeita. Justamente porque IA é imperfeita e escala rápido.

## Minha conclusão

AI slop é real. Vai piorar antes de melhorar. Vai ter PR porcaria. Vai ter relatório de segurança falso. Vai ter regressão atribuída a IA que teria acontecido com humano também. Vai ter mantenedor puto. Vai ter usuário gritando. Normal.

Mas a direção não muda.

Código assistido por IA veio pra ficar. A porcentagem de código tocado por agente vai subir sem parar. Proibir pode funcionar localmente, por um tempo, em uma comunidade específica. No macro, é guerra perdida.

O caminho pragmático é fazer a IA trabalhar **a nosso favor**. Usar IA pra triagem. Usar IA pra auditoria. Usar IA pra comparar diffs. Usar IA pra achar regressão. Usar IA pra escrever teste que falha antes e passa depois. Usar IA pra fazer o trabalho chato que cansa humano.

E manter a decisão humana onde ela importa.

Eu já disse isso várias vezes e vou repetir: **IA é um espelho**.

Se você é relaxado, ela acelera sua relaxação. Seu código vira AI slop industrializado.

Se você é engenheiro de verdade, ela amplifica sua engenharia. Você continua exigindo teste, CI, compatibilidade, migração, revisão, clean code, deploy, teste manual. Só que agora faz isso 10 vezes mais rápido.

E pras empresas: se você está pensando “ótimo, agora economizo porque não preciso contratar tantos programadores”, até dá pra entender. Até certo ponto. Mas se vai colocar IA no fluxo, então precisa reforçar QA. Mais teste, mais revisão, mais processo de validação, mais gente boa pensando em qualidade. Se não fizer isso, está ferrado. Vai trocar custo de desenvolvimento por custo de bug em produção, retrabalho, incidente e cliente irritado.

Não existe volta ao mundo 100% manual. Melhor parar de gastar energia tentando fechar a caixa de Pandora e começar a construir processo decente em volta do que saiu dela.
