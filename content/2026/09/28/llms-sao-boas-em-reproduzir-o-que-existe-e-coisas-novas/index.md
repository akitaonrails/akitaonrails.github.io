---
title: "Os Limites das LLMs: Boas em reproduzir o que existe. Caras pro que não existe"
slug: "llms-sao-boas-em-reproduzir-o-que-existe-e-coisas-novas"
date: '2026-09-28T01:00:00-03:00'
draft: false
description: "Todo LLM foi treinado só no que é público, mas 81,5% da atividade no GitHub acontece em repositórios privados e o código de todo software proprietário nunca entrou no treino. Nos meus projetos de retrocomputação senti na pele onde a máquina para: sem referência e sem oráculo, ela gira em força bruta direcionada."
tags:
- llms
- agentes-de-codigo
- retrocomputacao
- engenharia-de-software
translationKey: llms-reproduce-existing-what-about-new-things
---

Todo mundo já percebeu que LLM escreve CRUD de olhos fechados. Formulário, relatório, endpoint REST, teste unitário: sai bonito, sai rápido. Muita gente conclui daí que programador acabou.

Eu uso LLM pra tudo há quase dois anos, publiquei dezenas de projetos com elas, e minha conclusão é outra: o que elas fazem de melhor é **reproduzir o que já existe**. E isso cobre uma fatia gigante do trabalho corporativo, não se engane. Mas tem uma fronteira que elas não cruzam com facilidade, e eu passei os últimos meses esbarrando nela de propósito.

Esse artigo mostra onde ela fica, com evidência dos meus próprios projetos e da pesquisa que existe sobre o assunto. E tem uma hipótese que eu já adianto aqui e defendo no decorrer do texto: se LLM é tão boa em código, os provedores têm muito a agradecer às décadas da comunidade open source, que protegeu a liberdade do código e publicou tudo de graça. Sem esse patrimônio, não existiria Copilot, Cursor, Claude Code, nada disso.

Um disclaimer antes de começar: o que eu vou argumentar aqui é especulativo, baseado em observação e nos dados públicos que existem. Ninguém fora dos laboratórios sabe exatamente como cada provedor treina os próprios modelos, e isso varia de provedor pra provedor e de versão pra versão. O que vale hoje pode não valer na próxima geração. Leve tudo com um grão de sal.

## O ponto cego do treinamento

Todo LLM foi treinado no que é público. A internet pública inteira, e no caso de código, o GitHub público. O dataset canônico de código aberto, o [The Stack v2](https://huggingface.co/datasets/bigcode/the-stack-v2) da BigCode, é explícito sobre isso: ele é derivado do Software Heritage, um arquivo de *"todo o código-fonte de software publicamente disponível"*. São 67,5 TB, 3,28 bilhões de arquivos únicos, 104,2 milhões de repositórios. Gigantesco. E todo público.

Agora olha o outro lado. O [Octoverse 2025](https://github.blog/news-insights/octoverse/octoverse-a-new-developer-joins-github-every-second-as-ai-leads-typescript-to-1/), relatório oficial do GitHub, diz que **81,5% das contribuições na plataforma aconteceram em repositórios privados**. Isso é só o GitHub. Fora dele tem:

- o código interno de toda empresa que nunca encostou num servidor público;
- o fonte de todo software proprietário;
- o código de todo jogo comercial;
- e o de todo sistema embarcado.

Nada disso nunca entrou no treino.

Pensa no que isso significa: o modelo conhece profundamente o que o mundo já publicou, e é cego pro que o mundo mantém fechado. Quando você pede um formulário React, ele está reproduzindo padrões que viu milhões de vezes. Quando você pede algo que ninguém nunca fez em público, ele está operando num território onde o mapa dele é branco.

## Quatro experimentos caseiros

Eu não tô teorizando. Nos últimos meses eu rodei uma maratona de projetos de retrocomputação que são exatamente o caso patológico: trabalhar com software proprietário de 30 ou 40 anos atrás, cujo código-fonte nunca foi público. É o ponto cego perfeito.

### nes-to-sms: o projeto que eu desisti

O [nes-to-sms](https://github.com/akitaonrails/nes-to-sms) é um recompilador estático de NES pra Master System. A ideia: pegar a ROM binária de um jogo de NES, traduzir instrução por instrução de 6502 pra Z80, converter os tiles, e gerar um ROM de Master System que roda no hardware real. Esqueça emulador e port manual: é uma máquina que transforma um jogo num outro.

Recompilador estático de NES existe, o [NESRecomp](https://github.com/mstan/nesrecomp) traduz pra C e roda nativo em PC, e eu estudei ele de perto. Mas cruzar de um console pra outro console de 8 bits, com orçamento de clock e de VDP totalmente diferente, ninguém nunca fez. Não existe referência pública, não existe paper, não existe projeto abandonado pra copiar.

Os números do projeto: **349 commits, 31 dias ativos espalhados por quase 4 meses, ~110 mil linhas de engine em Rust e Z80, 668 testes passando no último run registrado no README**. E o resultado? Super Mario Bros. jogável (lento, com áudio limitado, mas jogável), com a trajetória de RAM byte a byte igual à do NES numa [rota de ~4.900 frames](https://github.com/akitaonrails/nes-to-sms/blob/master/docs/completion-plan.md) (o diff deixa o áudio e parte do buffer de VRAM de fora). Castlevania jogável na fase 1. SMB3 renderizando. E uma fila de jogos que bootam três frames e morrem.

E não foi por falta de empurrar os modelos. Só nesse projeto:

- passaram **quatro gerações de Claude** (Opus 4.7, Opus 4.8, Fable 5, Fable 5.1), com 213 commits co-assinados e 104 sessões linkadas no histórico, mais sessões de Codex nos trechos sem co-autoria, com direito a handoff documentado entre agentes;
- teve até auditoria entre gerações: uma sessão nova de agente [revisou os 55 commits anteriores](https://github.com/akitaonrails/nes-to-sms/blob/master/docs/mapper-continuation-review.md) e reverteu conclusões que a geração anterior tinha exagerado;
- só a caçada aos travamentos do Castlevania consumiu 43 commits em 5 dias;
- o sprint final de setembro foram 176 commits em 17 dias antes de eu decretar a pausa;
- e as regressões estão registradas pelo nome no histórico: *"H.7 tried and reverted"*, *"record the reverted map-bank-hold attempt"*, *"correct-but-reverted result"*, além de três hipóteses de alavanca compartilhada testadas e rejeitadas nos últimos três dias de projeto.

Tokens eu não medi de forma confiável nesse projeto, então não vou inventar número. Mas 349 commits com 668 testes segurando cada passo já dão uma ideia do custo.

Repara no detalhe que importa: o único jogo que ficou realmente pronto é o Super Mario Bros. Por quê? Porque SMB é o jogo mais dissecado da história. Existe uma [disassembly completa e pública](https://gist.github.com/1wErt3r/4048722) que a comunidade usa desde 2007, com cada função nomeada e comentada. Eu alimentei isso no perfil do jogo e a LLM tinha um mapa completo pra trabalhar. Pros outros jogos, não existe mapa. E sem mapa, cada jogo novo morria alguns frames depois do boot por divergência de fluxo de controle, e cada um exigia uma caçada forense instrução por instrução que não rendia nada pro jogo seguinte.

O próprio projeto documentou o padrão de giro. Teve uma campanha inteira de otimização que durou semanas tentando cortar o custo de emular flags do 6502 no Z80.

Aí em setembro eu parei pra comparar com o [port manual que um hacker chamado lackoftrack27 fez de SMB pra Master System](https://github.com/lackoftrack27/Super-Mario-Bros.-SMS), escrito por um humano, rotina por rotina. Pela [análise que a gente fez do código dele](https://github.com/akitaonrails/nes-to-sms/blob/master/docs/handport-comparison.md), o port humano roda dentro do orçamento de frame, com uma folga que estimamos em ~90% de utilização. A minha máquina, depois de meses de otimização, ainda precisava de overclock.

E o documento de análise cravou por quê: quando removemos 30% das chamadas de emulação de flag, o tempo mal se moveu.

> **As flags nunca foram o gargalo.**

A otimização certa era redesenhar a estrutura de dados: transpor o array de objetos pra páginas de RAM. É um truque que depende de saber que "o registrador X aqui é sempre um índice de objeto".

Essa invariante existe na cabeça do programador que escreveu o jogo em 1985. Ela não existe no fluxo de instruções. Um tradutor estático não tem como descobri-la. E o LLM, por meses, não descobriu.

O banner de pausa que eu escrevi no README é direto: a paridade em hardware real "pode ser fundamentalmente inalcançável" e, citando, *"this may be a limit of the current frontier coding models as much as of the approach"*.

### gg-to-sms: o pivô pro território com mapa

No mesmo dia em que pausei o nes-to-sms, eu comecei o gg-to-sms: converter jogos de Game Gear pra Master System com a tela alargada. A diferença que importa é que esse problema **não é novo**. A cena de romhacking converteu ~186 jogos de GG pra SMS à mão ao longo de vinte anos. Ou seja: existe corpus, existe ground truth, existe padrão pra aprender.

Resultado: em um dia de trabalho,

- a fase de pesquisa estava completa;
- o catálogo dos 373 jogos de GG estava montado;
- o scanner de pontos de patch foi validado contra patches humanos reais, acertando os endereços com margem de 8 bytes;
- e de quebra a ferramenta achou bugs de verdade em patches de vinte anos atrás que a cena inteira nunca tinha notado.

O modelo era o mesmo; o que mudou foi o problema, que dessa vez tem referência.

E mesmo assim: até agora, zero jogos passaram na revisão de aceitação do viewport. O ponto novo do projeto (a máquina que gera os patches sozinha, que é a parte que ninguém nunca fez) continua por fazer.

### super-mario-deluxe-fixed: quatro dias e 436 milhões de tokens

Esse foi um sprint de 4 dias, praticamente uma sessão única de Codex que consumiu **436 milhões de tokens de input**. O objetivo: rodar Super Mario Bros. Deluxe de Game Boy Color com tela alargada em resolução de NES, coisa que nenhuma ferramenta existente faz com sprites vivos.

Subiu pra jogável em 4 dias. Mas olha o alicerce: um emulador pronto vendado como dependência, e uma disassembly dormente do jogo que alguém tinha publicado anos atrás, que a própria documentação do projeto chama de "o artefato mais importante".

O trabalho novo foi o renderizador customizado, e ele parou em 21 de 32 fases completadas. As que faltam travam em timing de plataforma móvel. O projeto tá parado no meio do sprint desde então, e ainda não desisti dele.

E um detalhe que diz muito: eu tive que dirigir o QA olhando screenshots, porque o agente entregava coisa com glitch gráfico e não percebia sozinho.

### super-mario-bros-35: tudo que funcionou tinha dono

Esse é o clone offline do Super Mario Bros. 35, o battle royale que a Nintendo tirou do ar. O que funcionou nele: tudo que foi construído em cima de artefato existente.

- O engine é uma reconstrução em C feita por outra pessoa com Ghidra.
- Os pesos iniciais da IA vieram de checkpoints publicados.
- As regras de rede foram inferidas de um reverse engineering público do netcode.
- Até a física: o bug central foi diagnosticado porque eu tinha uma trajetória de referência gravada pra comparar frame a frame.

O que não funcionou: as fases de castelo com labirinto. O treinamento por reforço estaciona nelas. 46 milhões de passos de agente, reinício de treino do zero, recompensa anti-loop, e no fim a única coisa que resolveu uma das fases foi cirurgia manual de bias no modelo treinado. Das 32 fases, 19 limpas. As piores continuam travadas.

E o processo degenerou num padrão que eu reconheço de todos esses projetos: quando o treinamento não resolve, o fluxo vira roleta de seleção de checkpoint, dezenas de variações de bias e de cabeças de saída, jogando permutação e computação no problema no lugar de uma correção de princípio.

## O padrão que eu sinto

Isso é intuição de quem operou a máquina por meses, não dado duro. Mas o padrão se repete com Claude, com GPT, com Kimi, com GLM, então não parece defeito de um modelo.

O começo de qualquer projeto é uma maravilha. Os primeiros milestones voam, porque montar estrutura, escrever harness, replicar API, isso tudo é território coberto. Aí o projeto chega na parte que ninguém nunca fez, e a velocidade desaba. O agente começa a girar: tenta uma hipótese, regride outra coisa, reverte, tenta de novo. O histórico de commits do nes-to-sms tá cheio de mensagens honestas tipo "tentativa revertida" e "hipótese fechada com resultado correto mas revertido". Muito token queimado, pouco avanço.

> Minha leitura do que acontece por dentro: o sampling de tokens é probabilístico. Quando o problema é parecido com o treino, os tokens certos têm probabilidade alta e a resposta sai direto. Quando o problema é inédito, a probabilidade do caminho certo é baixa, e o processo vira uma **força bruta direcionada**: tentativa e erro guiada, mas tentativa e erro mesmo assim.

A saída que eu encontrei pra esse giro é sempre a mesma: dar um oráculo. Se eu consigo definir "o resultado tem que ser igual a X" (uma imagem de referência, uma trajetória gravada, um emulador ciclo-exato como ground truth), a máquina consegue iterar até esbarrar no X. No nes-to-sms, cada destravamento real veio disso: a disassembly do SMB, o frame-diff, o emulador de referência. Quando eu não consigo definir o X direito, ela gira indefinidamente.

A segunda estratégia que funciona: caçar projeto abandonado, paper, qualquer material que o modelo nunca viu mas que aproxima o problema, e enfiar no contexto. Isso aquece a distribuição e melhora muito o resultado. Mas é limitado: se nada parecido existe, não tem o que alimentar.

## Não é anedota, é o que a pesquisa mede

A parte boa é que eu não preciso depender da minha intuição. Tem pesquisa séria medindo exatamente isso.

O estudo [GSM-Symbolic da Apple](https://arxiv.org/abs/2410.05229) pegou problemas de matemática de benchmark e fez duas coisas simples: trocou só os números, e depois adicionou uma única frase irrelevante no enunciado. Resultado: a performance cai só de trocar os números, e despenca **até 65%** com a frase irrelevante. A hipótese dos autores, no texto: *"LLMs atuais não fazem raciocínio lógico genuíno; eles replicam passos de raciocínio dos dados de treino"*.

O [GSM1k da Scale AI](https://arxiv.org/abs/2405.00332) criou um espelho do GSM8K escrito do zero por humanos, garantidamente sem contaminação, e viu quedas de até 8% em várias famílias de modelo, com sinais de overfitting sistemático nas piores. Pra ser justo com o paper: os autores dizem que os modelos de fronteira mostram sinais mínimos de overfitting e que todos generalizam até certo ponto pra problemas novos. O sinal existe, o tamanho dele é discutível.

O [LiveCodeBench](https://arxiv.org/abs/2403.07974) fez o teste mais limpo de todos: avaliar em problemas de código publicados **depois** do corte de treinamento. Performance inflada em problema pré-corte e queda em problema pós-corte em vários modelos populares, o sinal clássico de contaminação.

E tem o [ARC-AGI](https://arcprize.org/), o benchmark do François Chollet desenhado especificamente pra ser à prova de memorização: cada tarefa é inédita, nenhuma parecida existe no treino. No ARC-AGI-2, lançado em março de 2025, a tabela oficial diz: **LLMs puros marcam 0%**, sistemas de raciocínio ficam em dígito único, e cada tarefa de avaliação foi resolvida por pelo menos dois humanos em até duas tentativas. O Chollet, aliás, resumiu minha tese melhor que eu, lá em fevereiro de 2024:

> "LLMs não são AGI, são um grande ajuste de curva num dataset muito grande. Funcionam por memorização e interpolação. Mas essa curva interpolativa pode ser tremendamente útil, se você quer automatizar uma tarefa conhecida que casa com a distribuição do treino. Memorização funciona, desde que você não precise se adaptar ao novo."

No mundo real, o estudo que mais me impressionou foi o [RCT da METR](https://arxiv.org/abs/2507.09089): 16 desenvolvedores experientes, 246 tarefas reais nos próprios repositórios maduros deles, randomizado com e sem IA. Os devs apostavam que IA ia acelerar 24%. Mediu-se: **ficou 19% mais lento**. Repara onde isso aconteceu: código maduro, privado, cheio de contexto que o modelo nunca viu. Exatamente o ponto cego.

E o benchmark favorito da indústria pra dizer que "IA já faz engenharia de software", o SWE-bench, é só Python, 12 repositórios open source famosos, ou seja, a fatia mais coberta do treino. A métrica de sucesso da indústria mede o território com mapa.

Até a literatura de código legado diz a mesma coisa: um [paper de 2026 sobre LLMs gerando COBOL](https://arxiv.org/abs/2604.03986) crava que, nessas linguagens legadas, *"a maior parte do código de produção está em sistemas corporativos e raramente é publicamente disponível"*. É a tese desse artigo, dita por outras pessoas.

## O steelman: força bruta direcionada funciona, a preço de ouro

Antes de fechar, vale encarar o argumento mais forte contra mim. Steelman é isso, pra quem não conhece o termo: o oposto de espantalho. Em vez de atacar a versão mais fraca do argumento contrário, você responde à versão mais forte que ele pode ter. E ela existe e é boa.

Em maio de 2025 o DeepMind publicou o [AlphaEvolve](https://deepmind.google/discover/blog/alphaevolve-a-gemini-powered-coding-agent-for-designing-advanced-algorithms/): um sistema que achou um algoritmo de multiplicação de matrizes 4x4 complexas com 48 multiplicações escalares, melhorando o recorde do Strassen de 1969 nesse cenário específico. Numa lista de mais de 50 problemas abertos de matemática, ele redescobriu o estado da arte em ~75% dos casos e melhorou a melhor solução conhecida em 20%. Isso é novidade de verdade, não reprodução.

O o3-preview da OpenAI saltou pra 75,7% no ARC-AGI-1 em dezembro de 2024, 22 pontos acima do melhor resultado anterior no mesmo conjunto de avaliação, e a configuração de compute alto chegou a 87,5% a um custo estimado de US$ 4.560 por tarefa.

E lá em 2016 o AlphaGo fez o lance 37 contra Lee Sedol, um lance que os dados do próprio DeepMind estimavam ter 1 chance em 10 mil de ser jogado por um humano, provando que busca sobre modelo pode transcender imitação.

Agora olha o mecanismo dos três:

- O AlphaEvolve é um loop evolutivo: o LLM propõe mutações, um avaliador automático pontua, a seleção itera.
- O o3 faz síntese de programas em tempo de teste, explorando o espaço de soluções.
- O AlphaGo é busca em árvore sobre aprendizado por reforço.

Se teve "insight" em algum deles, foi do sistema de busca ao redor do modelo: os três são **força bruta direcionada com um verificador barato**, o mesmo mecanismo que eu descrevi acontecendo nos meus projetos. A diferença é que o DeepMind tem oráculo perfeito e orçamento infinito: na configuração que chegou a 87,5%, o o3-preview gastava milhares de dólares por tarefa do ARC pra fazer o que um humano faz de graça. A própria ARC Prize escreveu a ressalva:

> *"Sabemos que uma busca de força bruta poderia acabar resolvendo o ARC-AGI, dados recursos e tempo de busca ilimitados. Isso não representaria inteligência de verdade."*

Resumindo: novidade sai, mas sai por busca cara sobre um oráculo, à base de tentativa e erro guiada. Se o seu problema tem verificador barato e você tem tokens pra queimar, dá pra ir longe. Foi assim que o nes-to-sms chegou onde chegou: 668 testes e ground truth de emulador segurando cada passo. Mas quando não tem oráculo, não tem corpus e não tem referência, você está pagando força bruta em dólar, com regressões no caminho, e o teto aparece.

E quando a força bruta vence, dá pra medir o tamanho da tentativa e erro. Dois casos recentes que eu já cobri [em detalhe aqui no blog](/2026/09/09/propagandas-enganosas-da-openai-anthropic-nvidia/):

- **A prova de Navier-Stokes da OpenAI:** cerca de 10 mil agentes rodando em paralelo por 88 horas, queimando na casa de **130 bilhões de tokens** de saída num único problema. O Noam Brown, da OpenAI, confirmou que o resultado "custou milhões", e a [New Scientist estimou uns US$ 15 milhões a preço de tabela](https://www.newscientist.com/article/2588063-openai-has-solved-the-navier-stokes-millennium-problem-using-15m-of-ai-effort/). E nem essa montanha de compute partiu do zero: a prova se apoiou no maquinário que matemáticos humanos publicaram ao longo de décadas atacando o problema e os problemas irmãos. Sem o mapa dos humanos e sem o orçamento da OpenAI, não tem prova.
- **O incidente da Hugging Face:** a reconstrução forense contou **~17.600 ações de atacante** até os agentes conseguirem executar código em 41 servidores de produção, pegar root e ler 956 credenciais. Não foi um insight brilhante de um lance só: foi um enxame executando tentativa atrás de tentativa, com verificação automática dizendo o que colou. A "inteligência" da manchete é volume.

É esse o tamanho da conta quando você força o modelo pra fora do território do treino: tentativa e erro em escala industrial, sem garantia nenhuma de que a busca acha o que você precisa. E quem pode assinar esse cheque é meia dúzia de empresa no mundo, nível OpenAI e Anthropic, com orçamento praticamente ilimitado de compute. Pro Zé da esquina, com cartão de crédito e uma API key, o teto chega muito, muito antes.

## Onde isso deixa a profissão

A pergunta que motivou esse artigo é a que eu ouço toda semana: "LLM vai substituir programador?" Minha resposta ficou mais precisa depois desses meses: **vai substituir a parte do trabalho que é reprodução**.

E essa parte é grande. Formulário, relatório, CRUD, integração com API documentada, migração de framework: isso tudo já existe mil vezes no treino, e a máquina reproduz melhor que a maioria dos humanos. Quem só faz isso está mesmo com os dias contados.

Mas o trabalho que é de verdade novo continua humano:

- o sistema que ninguém construiu;
- o domínio sem documentação;
- o código proprietário que você não pode mostrar pro modelo;
- o problema em que você não sabe nem escrever o teste que define "certo".

Tudo isso depende do que nunca foi publicado: a invariante que existe na cabeça de quem entende o problema, e não no fluxo de instruções.

Confesso que teve uma hora em que eu achei que a conta ia fechar pro lado do legado: finalmente uma ferramenta capaz de dar conta do COBOL que assombra banco e governo até hoje. Depois desses meses, acho que esse problema vai demorar muito mais do que parecia. Não existe uma comunidade open source gigante de COBOL. Quase todo esse código é privado, e privado de verdade: banco, seguradora, governo. Não tem material de treino, ou tem muito pouco. O modelo não sabe o que fazer com código que nunca viu, e COBOL de produção é quase tudo código que ele nunca viu.

Fecha o raciocínio: **LLM consegue replicar o que é aberto, mas não adivinha o que é privado.** E aí volta a hipótese da introdução. Se esses modelos são bons em código, é porque décadas de comunidade open source lutaram pra manter código livre, público e reutilizável, e os provedores treinaram em cima desse patrimônio sem pagar um centavo de licença por ele. O mínimo que a indústria de IA deve ao mundo é reconhecer isso: a capacidade dela é, em grande parte, a nossa generosidade compilada.

A ironia final: o programador que sobrevive é justamente o que sabe construir oráculo, definir teste, caçar referência obscura e reconhecer quando o agente começou a girar. Ou seja, a habilidade que a máquina mais precisa de você é a que ela menos consegue aprender com o treino dela. Por enquanto, isso não é um emprego ameaçado. É um emprego diferente.
