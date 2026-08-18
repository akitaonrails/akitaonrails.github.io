---
title: "Hot take: Harness, Loop Engineering, Graph Engineering são Bullshit"
slug: hot-take-harness-loop-engineering-graph-engineering-sao-bullshit
date: '2026-08-18T13:00:00-03:00'
draft: false
translationKey: hot-take-harness-loop-engineering-graph-engineering-sao-bullshit
description: "Postei que Harness Engineering, Loop Engineering e Graph Engineering são bullshit pra vender consultoria e curso. Sustento com recibo: mais de 30 repos públicos, uma maratona de IA e um benchmark inteiro — tudo sem nenhuma dessas 'disciplinas'."
tags:
- inteligencia-artificial
- llms
- vibe-coding
---

[![Hot take no X: Harness, Loop Engineering e Graph Engineering são tudo bullshit pra vender mais horas de consultoria e cursos](tweet-hot-take.png)](https://x.com/AkitaOnRails/status/2089734682325794897)

Soltei [este tweet](https://x.com/AkitaOnRails/status/2089734682325794897) hoje de manhã e ele rendeu. O ponto completo: quando a tecnologia em si vira commodity, o dinheiro migra pra taxonomia. Criam cinco nomes novos pra encadear chamada de API e de repente surge uma certificação que expira em seis meses.

Deixa eu sustentar a provocação com calma, porque ela não é implicância gratuita.

Já antecipo o comentário padrão: *"mas comigo funciona"*. Bom pra você — de verdade. Só que "funciona comigo" nunca provou que a cerimônia é o que fez funcionar. O que fez funcionar foi você saber o que queria. A cerimônia só estava no mesmo ambiente.

## O meu recibo

Entre janeiro e maio eu fiz uma [maratona de IA](/2026/05/14/terminando-maratona-ia-sucesso-ou-fracasso/) e publiquei [mais de 30 repositórios públicos](https://github.com/akitaonrails?tab=repositories). Tem ferramenta que eu uso todo dia — [ai-memory](https://github.com/akitaonrails/ai-memory), [ai-usagebar](https://github.com/akitaonrails/ai-usagebar), [ai-jail](https://github.com/akitaonrails/ai-jail) — e tem app pessoal pra coçar a minha própria coceira: [Frank Manga+](https://github.com/akitaonrails/frank_mangaplus), [Frank Scanlation](https://github.com/akitaonrails/frank_scanlation), [Frank Geary](https://github.com/akitaonrails/frank_geary), e por aí vai.

Sabe o que eu nunca senti vontade de fazer nesse meio tempo? Complicar meu setup de IA. Não tenho um [Pi super customizado](/2026/05/25/primeiras-impressoes-usando-oh-my-pi-e-opencode/), não tenho Hermes, não tenho grafo de agentes orquestrado, não tenho pipeline de specs numeradas. Graças ao ai-memory, **eu troco de harness como troco de cueca**: todo dia, sem limitação. Claude Code de manhã, Codex à tarde, Kimi CLI de noite — a memória do projeto vai junto, então o harness vira detalhe.

E detalhe é o ponto. A maioria dos harnesses é otimizada pro LLM da própria casa. Mas "otimizado" não quer dizer "mágico", e eu tenho dados pra isso.

## O que o meu benchmark diz sobre harness

No [meu LLM Coding Benchmark](/2026/08/15/llm-benchmarks-qwen-3-8-glm-5-3-gemini-3-7/) eu rodo os mesmos modelos em harnesses diferentes, em condições controladas. O resultado é o oposto do que o mercado de cursos sugere:

- **Pra modelo fraco, o harness resgata.** O Grok 4.3 não construiu nada no OpenCode pelado (18 pontos) e entregou um app de verdade no grok CLI (55). O Gemini 3.1 Pro saiu de 62 pra 88 no harness do Google — mas o problema ali era um bug de transporte do OpenRouter, não falta de "engenharia de harness".
- **Pra modelo de fronteira, o harness é ruído.** Grok 4.5: 92 no OpenCode, 91 no grok CLI. Grok 4.6: 92 e 93. Diferença de um ponto, dentro da margem. Nenhuma engenharia de harness move um modelo bom.
- **Onde o harness morde de verdade é no bolso.** A rodada do Grok 4.6 saiu por $1,19 no grok CLI contra $6,33 no OpenCode via OpenRouter — **mais de 5x mais barato** pelos mesmos ~11 milhões de tokens, porque o CLI oficial usa o cache nativo da xAI. Mesma história no Codex: o GPT 5.6 Terra custou $6,77 blended porque 21 dos 21,7 milhões de tokens bateram no cache; o Sol, da mesma família e mesma nota, saiu por uns $45.

Ou seja: escolher um harness decente importa — pra custo e pra dar estrutura a modelo fraco. Mas isso é uma tarde lendo documentação e olhando a fatura de tokens, não uma disciplina nova com trilha de aprendizado.

Já que citei o Hermes lá em cima, vale explicar: o [Hermes Agent](https://github.com/NousResearch/hermes-agent) é um framework open source da Nous Research pra você montar o *seu* agente pessoal — você define as tools, escreve os loops, configura roteamento por modelo, fallback local/nuvem, gateways de Telegram e Discord, e ele ainda "aprende skills" com o uso. É o paraíso de quem monta setup.

Também é um segundo emprego: cada peça dessas vira sua responsabilidade de manter, atualizar e depurar, pra sempre. E no fim das contas o motor continua sendo o mesmo Claude, GPT ou Qwen de todo mundo — o chassi customizado não melhora o motor. O que o Hermes resolve de verdade, continuidade de contexto entre sessões e entre ferramentas, um harness decente com um ai-memory da vida já cobre — sem você virar administrador de infraestrutura do próprio assistente.

Se você quer um assistente no seu hardware por hobby ou por privacidade, é ótimo motivo, vai fundo. Como pré-requisito de produtividade, não é.

> **Pra guardar:** harness bom é o que cobra menos e não atrapalha. O resto é o modelo. E modelo bom não precisa de "harness engineering" — no máximo precisa que o transporte não esteja quebrado.

## Loop Engineering, Graph Engineering, Spec-Driven Development

Vamos aos nomes, porque eles descrevem coisas reais — só que minúsculas.

**Loop Engineering** é o nome da vez pra projetar o ciclo que um agente repete: executa, verifica com evidência, itera até uma condição de parada. Os guias listam modos de falha reais — o agente declarar "pronto" cedo demais, o objetivo ir derivando a cada volta. Só que a mitigação recomendada é "um verificador independente conferindo evidência objetiva". Isso tem nome faz cinquenta anos: **teste e revisão**. Um agente num loop com suíte de testes não é uma disciplina nova, é o básico com nome novo.

**Graph Engineering** é desenhar o workflow do agente como um grafo explícito de nós, ramos e junções — a LangChain tem [três anos dessa história](https://www.langchain.com/blog/3-years-of-graph-engineering-with-langgraph). Faz sentido quando o fluxo é genuinamente ramificado. Só que a maioria esmagadora dos projetos não é um grafo: é uma linha reta com um `if` no meio. Modelar isso como grafo é comprar um quadro branco gigante pra desenhar uma seta.

**Spec-Driven Development** é escrever uma especificação detalhada primeiro e tratar o código como artefato gerado a partir dela — a spec vira a "source of truth" e o código, subproduto. Guarda esse, que o argumento forte vem já embaixo.

Repare no padrão: cada nome pega uma prática real e pequena — rodar em loop com verificação, desenhar um fluxo, escrever o que você quer antes de fazer — e infla até virar "disciplina". A inflação é o produto. Nome novo cria curso, curso cria certificação, certificação expira em seis meses e te vende a recertificação.

Pra ser justo: os guias sérios desses temas já trazem a ressalva — o [guia de graph engineering](https://www.aibuilderclub.com/blog/graph-engineering-guide-2026) mais lido diz na cara que "você provavelmente não precisa" e manda dominar o loop antes de abrir um grafo, e a LangChain tem uma seção inteira de "quando não usar grafos". O problema não é o guia; é o funil que joga a ressalva fora e vende o resto como default pra todo mundo.

Os dois que mais vendem curso — orquestração pesada de agentes e spec-driven development — merecem mais que definição. Merecem o argumento.

## O argumento forte contra a super-orquestração

Tem uma matemática simples que os diagramas de agentes orquestrados nunca mostram. Se cada etapa do seu pipeline acerta 90% das vezes — e isso é otimista —, uma cadeia de dez agentes acerta 0,9^10, ou seja, **~35% das vezes**. Cada nó é um ponto novo de falha, e cada aresta é token gasto com agente conversando com agente em vez de trabalhando.

Não precisa acreditar na conta: eu medi isso sem querer no benchmark. O MiniMax M3 rodado debaixo de um orquestrador parecia Tier D, com 24 pontos. O mesmo modelo, limpo, fez 91, Tier A. Uma diferença de até 69 pontos entre condições de harness significa o oposto do que o vendedor de orquestração diz: **quando o plumbing domina o resultado, você parou de medir o modelo e passou a medir o encanamento.** O melhor resultado de todo o benchmark não veio de nenhum enxame orquestrado: veio de um modelo forte, sozinho, num loop simples — Fable 5, 96 pontos, Claude Code, fim.

Faz sentido quando você lembra que coordenação escala mal. Cada agente a mais não adiciona só capacidade; adiciona arestas, contratos de mensagem, estado compartilhado e versões conflitantes da verdade. O roteador que decide "qual agente cuida disso" vira ao mesmo tempo o gargalo e a fábrica de bugs. Um comitê de agentes medianos com regente não bate um agente capaz com boas ferramentas e memória.

Isso eu já testei diretamente. Em abril eu rodei [três rodadas de "modelo forte orquestrando modelo barato"](/2026/04/25/llm-benchmarks-vale-a-pena-misturar-2-modelos/) — planner + executor, delegação forçada, o pacote completo. Resultado: **nenhuma combinação multi-agente bateu o Opus sozinho** num harness maduro. Numa tarefa coesa como construir um app, o planner precisa ler cada output do executor antes de despachar o próximo passo — os dois viram sequenciais, com latência triplicada e uma fila de coordenação no meio. É o comitê de novo: muita conversa, pouco software.

Não é só o meu benchmark. A Cognition, que vende o Devin, publicou o ["Don't Build Multi-Agents"](https://cognition.com/blog/dont-build-multi-agents) com um mecanismo mais afiado que a minha conta de 90%: **toda ação carrega decisões implícitas que os outros agentes não veem** — um subagente desenha o fundo estilo Mario, o outro desenha um pássaro incompatível, e nenhuma confiabilidade individual conserta a divergência.

A própria Anthropic, que tem um sistema multi-agente de pesquisa, [admite no post de engenharia](https://www.anthropic.com/engineering/multi-agent-research-system) que multi-agente gasta **15x mais tokens**, que coding é um domínio ruim pra isso — a maioria das tarefas de código não é paralelizável de verdade — e que 80% da melhoria deles veio de simplesmente gastar mais tokens, não da arquitetura.

Quando Berkeley mediu o que realmente roda em produção, [86 sistemas em 26 domínios](https://arxiv.org/abs/2512.04123): 68% dos agentes em produção executam no máximo 10 passos antes de intervenção humana. O que existe de verdade por aí é loop simples supervisionado — não a constelação de nós coloridos do diagrama do consultor.

Onde a orquestração é legítima: trabalho genuinamente paralelo e independente — varrer dez mil arquivos, rodar dez mil análises descartáveis. Map-reduce existe faz vinte anos e nunca precisou de nome pomposo. E tem um recanto sério além dele: agente rodando de madrugada, sem ninguém olhando, com credencial na mão — aí verificador independente e orçamento duro viram questão de segurança, não de estilo. Mas isso é operação de frota, não o coding do dia a dia que o curso te vende. Fora desses nichos, a maioria das "arquiteturas multi-agente" é o trabalho de um agente só, com YAML extra.

Tem um motivo pra você ouvir tanto sobre isso: orquestração é complexidade **visível**. Tem diagrama, tem nó colorido, tem dashboard. Um agente bem dirigido não tem nada disso — não tem slide, não tem certificação, não tem o que vender.

> **Pra guardar:** cada agente a mais multiplica os modos de falha. Se o resultado do seu sistema muda quando você troca o orquestrador, o seu sistema é o orquestrador — e o modelo era figurino.

## O argumento forte contra spec-driven development

O SDD parece maduro porque soa como "escrever documentação". Mas presta atenção no que ele realmente propõe: a spec vira a fonte da verdade e o código vira artefato gerado. O problema é que **uma spec precisa o bastante pra gerar código correto já é um programa** — só que escrito em prosa, e prosa não compila. Cada ambiguidade da spec é um bug que nenhum compilador pega, num meio sem teste, sem linter, sem feedback. O SDD não remove a parte difícil, que é pensar com precisão; ele move a parte difícil pra um formato onde erro não grita.

> **Pra guardar:** uma spec precisa o bastante pra gerar código correto já é um programa — só que em prosa. E prosa não compila.

Mesmo que você escreva a spec perfeita, ela começa a morrer no primeiro hotfix. O bug aparece em produção, alguém conserta direto no código, e a spec vira mentira. A gente conhece essa lei faz décadas — é por isso que documentação apodrece. Chamar a spec de "fonte da verdade" não muda o incentivo de ninguém.

A gente já fez esse experimento, aliás. UML, MDA, "o código se gera a partir do modelo" — vinte e poucos anos atrás era a mesma promessa com outras siglas. Colapsou sempre pela mesma razão: o modelo nunca era a realidade; o código era. O SDD é o MDA com um LLM pendurado. E [não sou só eu que vejo o Waterfall 2.0 ali](https://www.alexcloudstar.com/blog/spec-driven-development-2026/).

Quem testou as ferramentas com seriedade chegou no mesmo lugar. A Thoughtworks colocou spec-driven development no anel ["Assess" do Technology Radar](https://www.thoughtworks.com/radar/techniques/spec-driven-development) — não "adote", "avalie" — depois de ver as ferramentas inflarem tarefas pequenas em cerimônia, e cravou a frase que resume: estamos talvez *"reaprendendo uma lição amarga: regras detalhadas feitas à mão pra IA simplesmente não escalam"*. É a Bitter Lesson do Rich Sutton batendo na porta de novo — estrutura artesanal perde pra escala, sempre perdeu.

Tem ainda a inversão temporal. A grande lição do agile foi que você descobre o que quer **construindo** — working software over comprehensive documentation. O LLM acabou de deixar a iteração barata como nunca na história. E o que o SDD propõe? Expandir a fase de planejamento, justo agora que iterar ficou barato. Resposta errada, na direção errada, na hora errada.

É a tese que eu venho martelando desde os primeiros posts de [Agile Vibe Coding](/2026/02/23/vibe-code-fiz-um-indexador-inteligente-de-imagens-com-ia-em-2-dias/): **software emerge, não se planeja**. [Escrevi isso em fevereiro, com recibo](/2026/02/20/do-zero-a-pos-producao-em-1-semana-como-usar-ia-em-projetos-de-verdade-bastidores-do-the-m-akita-chronicles/): as features mais importantes do M.Akita Chronicles nasceram de problema que apareceu no meio do caminho — um job que falhou em silêncio, um site que bloqueou a gem, um crash que deixou email em limbo. Nenhum spec do mundo prevê isso. O sistema correto emerge da iteração, não da especificação.

O processo ficou documentado de novo quando o ai-memory cresceu na mão de 26 contribuidores em 24 dias: [software bom é escultura de barro, não torre de Lego](/2026/06/14/ai-memory-arquitetura-emergente-e-software-maleavel/) — maleável, sempre ajustável, nunca pronto. Quem tenta desenhar a arquitetura inteira antes da primeira linha constrói uma camisa de força, não um sistema. Só amador ainda acredita que dá pra especificar o software inteiro antes de codar. Modelagem de verdade não vem de template nem de curso — [falei disso anos atrás no Akitando 144](/2023/08/11/akitando-144-modelagem-de-software-e-dificil-ver-vs-enxergar/): ela nasce de repertório com problema e código reais. Não tem receita pronta; nunca teve.

O SDD tenta ressuscitar a ideia de que dá pra planejar software adiantado — a ideia que a indústria enterrou depois de décadas de projeto entregue atrasado, errado e superfaturado. O LLM não revalidou essa ideia; só deu a ela um PowerPoint novo.

Até quem escreve guia a favor separa as duas coisas: ["spec-as-source é onde mora o hype; spec-anchored é onde está o valor hoje"](https://dev.to/krlz/spec-driven-development-in-2026-what-it-is-the-tooling-and-how-teams-actually-use-it-2fk2). O meu alvo aqui é o primeiro. Onde a spec pesada é legítima: time grande, codebase legado, trabalho assíncrono que atravessa fuso e sprint — o bom e velho documento de design, que sempre existiu e sempre teve valor. O que não cola é vender isso como o novo default pra todo mundo.

O meu prompt de benchmark, pra constar, é uma página de objetivos. A diferença é que eu não confio na prosa: eu valido rodando. Precisão mora em teste, não em parágrafo.

## O que você realmente precisa

Eu já escrevi tudo isso aqui no blog, com recibo de projeto real. Chama [Agile Vibe Coding](/2026/02/23/vibe-code-fiz-um-indexador-inteligente-de-imagens-com-ia-em-2-dias/), e cabe num parágrafo:

É XP (eXtreme Programming, o agile raiz) com LLM: testes, [Clean Code](/2026/04/20/clean-code-para-agentes-de-ia/), CI (integração contínua), pair programming e deploy. Você dirige o agente como dirigiria um pair muito rápido: diz o que quer, acompanha a execução, corrige enquanto o erro é barato. A ideia é 10% do trabalho; os outros 90% são engenharia de software normal, a de sempre. [Não precisa de framework nem de template de três páginas](/2026/04/15/como-falar-com-o-claude-code-efetivamente/) — precisa saber o que você quer, saber o que você não quer, e saber validar quando chega. E precisa de equilíbrio: [nem largar o volante pro agente, nem virar fiscal de vírgula](/2026/04/11/vs-code-e-o-novo-cartao-perfurado/).

Foram mais de 600 horas disso, mais de meio milhão de linhas, dezenas de projetos no ar. Nenhum grafo, nenhuma certificação, nenhum loop com nome em inglês.

> **Pra guardar:** a ideia é 10% do trabalho; os outros 90% são engenharia de software, a de sempre.

## A peça que me deixa trocar de harness: ai-memory

Tem uma ferramenta minha que é o oposto de taxonomia: o [ai-memory](https://github.com/akitaonrails/ai-memory). Ele nasceu de um problema concreto. Todo harness guarda a sessão no formato dele, e quando a conversa fica longa, ele compacta o histórico pra caber na janela — e a compactação joga fora justamente os detalhes que explicam por que cada decisão foi tomada. Aí você troca de ferramenta e começa do zero, com o projeto inteiro pra reexplicar.

O ai-memory resolve isso do lado de fora do harness. Ele lê a sessão nativa sem tocar no arquivo original e guarda tudo num ledger pesquisável: mensagens, chamadas de ferramenta com resultados, resumos de compactação, checkpoint do git — cada evento marcado com a origem (veio do Claude, do Codex, do OpenCode). Quando eu abro outro harness, ele ganha a sessão nativa dele e recebe só o delta que ainda não viu. Quando eu volto pro anterior, o ai-memory retoma no formato daquele cliente e entrega o que aconteceu nos outros enquanto isso.

É por isso que "troco de harness como troco de cueca" não é força de expressão. **O conhecimento do projeto mora no projeto, não na sessão de uma ferramenta.** Se a Anthropic mudar preço, limite ou modelo amanhã — e vai mudar —, eu troco o motor sem jogar fora a viagem. Os detalhes de como isso funciona estão [neste post](/2026/07/20/novidades-no-meu-ai-memory-cada-vez-melhor-pra-usar-com-suas-ias/).

Tem ainda uma inversão aqui que despacha o SDD de brinde. O spec-driven development diz que a fonte da verdade é um documento escrito **antes** do trabalho, tentando prever o futuro, e que o código deve obediência a ele. O ai-memory faz o contrário: a fonte da verdade é uma [wiki destilada do próprio trabalho](/2026/06/16/ai-memory-memoria-longo-prazo-karpathy-wiki-auto-aprendizado-hermes-projetos/) — cada sessão vira evidência, e o que merece sobreviver (decisões, regras, gotchas, tentativas que falharam) é consolidado em páginas Markdown curtas que qualquer agente lê antes de começar.

A spec tenta adivinhar o projeto; a wiki registra o projeto. Documento escrito antes apodrece no primeiro hotfix, porque ninguém é obrigado a atualizá-lo. A wiki é alimentada pelo próprio ato de trabalhar — e quando desatualiza, você percebe na hora, porque os agentes tropeçam nela toda sessão.

Repare que isso é harness engineering de verdade: uma ferramenta, escrita uma vez, resolvendo um problema meu. Nenhum curso, nenhuma sigla, nenhuma certificação.

## Conclusão: pede o recibo

Não gaste tempo nem dinheiro com curso de "harness engineering", "loop engineering" ou qualquer taxonomia da semana. É tentativa descarada de te cobrar por coisas que você já faz se souber engenharia de software básica.

Esse filme a gente já viu, aliás. O [Pedro Arantes lembrou no X](https://x.com/arantespp/status/2089752215380426951): *"Microservices, clean architecture, hexagonal e Domain-Driven Design são tudo bullshit pra vender mais horas de consultoria e cursos."* Mesma história, mesmo roteiro. Cada um deles nasceu de um problema real — e virou default de quem não tinha o problema. Microservice pra time de três pessoas, arquitetura hexagonal pro CRUD (o cadastro cria-lê-atualiza-apaga de sempre), DDD pra nunca mais escrever código. A técnica passa, a taxonomia fica, o curso vende.

Pra ninguém se fazer de desentendido: **nada disso é inútil**. Loop com verificação funciona. Grafo funciona quando o fluxo é um grafo de verdade. Spec pesada salva time grande. Microservices resolveram problemas reais de quem tinha escala de verdade; DDD brilha em domínio complexo de verdade. O problema nunca foi a ferramenta — é vender a ferramenta como **bala de prata**, o martelo universal que você precisa aplicar em tudo. Bala de prata não existe, nunca existiu. Quem te vende uma não está vendendo solução; está vendendo curso.

Entenda o mecanismo psicológico, porque ele é velho e eficiente: esses termos existem pra te dar **FOMO** (Fear of Missing Out — o medo de estar perdendo o bonde). Pra te deixar ansioso, achando que está ficando pra trás, que está deixando produtividade na mesa, que todo mundo já migrou pro novo paradigma e você não. Ansiedade vende. Depois que você está inseguro, eles te cobram pra implementar algo de que você nunca precisou. FOMO é real — e aqui, é o modelo de negócio.

O modelo ainda é recorrente — repare na elegância. Primeiro te vendem a metodologia que **gera** artefatos — specs, grafos, boards, diagramas. Os artefatos se multiplicam, ninguém mais sabe onde está nada, e adivinha quem aparece? A mesma consultoria, agora vendendo a ferramenta que **gerencia** os artefatos, o curso que te ensina a gerenciar a ferramenta e o workshop de governança dos artefatos. É o vendedor de pá te parabenizando pelo buraco que você cavou — e te oferecendo uma pá maior.

A Gartner tem até nome oficial pra isso: ["agent washing"](https://www.gartner.com/en/newsroom/press-releases/2025-06-25-gartner-predicts-over-40-percent-of-agentic-ai-projects-will-be-canceled-by-end-of-2027) — pegar produto existente, pendurar a etiqueta "agentic" e revender. A estimativa deles: só umas **130 das milhares** de empresas que se vendem como "IA agêntica" são reais, e a previsão é de 40% dos projetos do tipo cancelados até o fim de 2027, por custo, valor incerto ou risco mal controlado. Não é implicância minha; é o ciclo, medido.

Da próxima vez que um influencer ou consultor tentar te empurrar esses produtos, faz uma pergunta simples: **onde estão as suas dezenas de projetos open source de alta qualidade que ficaram melhores por causa dessas "técnicas"?**

Eles não têm o que mostrar. Eu tenho — [está tudo público](https://github.com/akitaonrails?tab=repositories), com código, benchmark e processo documentado. Quando a tecnologia vira commodity, o dinheiro migra pra taxonomia. Não seja o cliente dessa migração.
