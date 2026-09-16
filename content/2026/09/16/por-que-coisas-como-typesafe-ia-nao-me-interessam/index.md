---
title: "Por que coisas como TypeSafe IA não me interessam"
slug: "por-que-coisas-como-typesafe-ia-nao-me-interessam"
date: '2026-09-16T13:00:00-03:00'
draft: false
translationKey: por-que-coisas-como-typesafe-ia-nao-me-interessam
description: "Um punhado de gente apareceu nos comentários perguntando 'você já testou o TypeSafe?'. Uso isso como gancho pra explicar minha regra sobre ferramenta de IA nova, investigar o caso de verdade, e explicar por que não perco tempo economizando token."
tags:
- inteligencia-artificial
- agentes-de-codigo
- llms
---

Nos últimos dias apareceu um punhado de gente nos comentários, sempre com a mesma frase: "você já viu o [TypeSafe](https://typesafe.ai)?". Isso liga um alarme automático na minha cabeça. Toda vez que várias pessoas diferentes aparecem recomendando a mesma coisa do nada, com o mesmo tom de "você precisa ver isso", eu **sinto cheiro de bot de propaganda** ou de gente repetindo o que leu em algum grupo sem pensar duas vezes. Tem uma enxurrada de SaaS de IA brigando por atenção nesse mercado agora, e a maioria esmagadora é irrelevante pro que eu realmente faço no dia a dia.

Deixa eu adiantar minha regra antes de entrar no caso específico, porque ela vale mais que o caso em si.

## Minha regra: não uso nada até doer não ter

Depois de mais de meio milhão de linha de código produzida com IA nos últimos meses, dezenas de projeto no ar, um benchmark inteiro rodado do zero três vezes, minha recomendação pra quem programa é direta: **não use nenhuma ferramenta de orquestração ou camada intermediária até você sentir na pele que precisa de ajuda extra**. Use o harness que você já gosta, Codex, opencode, Claude Code, sei lá qual, direto, sem intermediário, e esquece o resto.

Não vale nem a pena gastar tempo coletando pacote de skill de terceiro pra empilhar em cima do seu agente. Constrói, treina, junta experiência pro seu próprio caso de uso. Ninguém mais no mundo tem o seu projeto, o seu contexto, a sua base de código. O pacote de skill de outra pessoa foi desenhado pro problema dela, não pro seu.

Já bati nessa tecla [faz um mês](/2026/08/18/hot-take-harness-loop-engineering-graph-engineering-sao-bullshit/): quando a tecnologia vira commodity, o dinheiro migra pra taxonomia. Cria nome bonito pra encadear chamada de API, e do nada nasce curso, certificação e consultoria em cima do nome. O TypeSafe é só mais um capítulo da mesma história, então virou desculpa boa pra mostrar como eu decido se vale a pena até abrir a aba.

> **Pra guardar:** não use ferramenta de orquestração ou camada intermediária até sentir na pele que precisa dela. Construa experiência pro seu próprio caso de uso, não colecione pacote de skill de outra pessoa.

## O gatilho: TypeSafe

Abri o site e o post de lançamento deles, o [Jev](https://typesafe.ai/blog/introducing-system-one-models-and-jev). Minha primeira impressão, bem superficial e crua: não gostei e não confiei. A home é um festival de jargão de IA empilhado, Kahneman aqui, Jevons ali, glifo decorativo, número de "193x mais rápido" sem o benchmark do lado. Na primeira olhada, nada daquilo faz sentido sozinho.

E tem o detalhe que sempre me deixa em guarda: toda vez que a primeira coisa que alguém diz sobre si mesmo é "eu sou um ex-pesquisador da OpenAI" ou parecido, **eu desconfio primeiro e pergunto depois**. Parece tentativa de colar credencial pra virar credível antes de qualquer prova real. O fundador do TypeSafe fala alto demais de si mesmo logo de cara, e isso por si só já é motivo pra apertar o botão de ceticismo.

Só que desconfiômetro ligado não é conclusão. É o ponto de partida pra investigar de verdade, não pra descartar sem olhar. Essa é a parte que eu quero mostrar aqui: como eu movo a desconfiança inicial pra pesquisa de verdade até descobrir se eu estava certo ou só sendo chato.

## Perguntei pras IAs, não confiei nas IAs

Mandei o mesmo prompt pro Grok e pro Claude: pesquisa isso a fundo, minha impressão inicial é muito cética, ex-OpenAI-researcher cheira a tentativa de colar credencial, o site é jargão pra todo lado, me diz qual é o discurso de venda de verdade, pra que serve na prática, e se a lógica deles, por trás do jargão, sequer faz sentido.

Os dois voltaram com pesquisa longa e detalhada, história parecida em ambos: a credencial do fundador é real, mas inflada; o produto é mais estreito e mais coerente do que a home deixa parecer; e o "não pode alucinar" é uma alegação de schema disfarçada de alegação de verdade.

Só que eu já entreguei minha própria conclusão dentro do prompt pras duas, então a concordância entre elas prova menos do que parece. Duas IAs concordando com a hipótese que eu mesmo escrevi no pedido não é confirmação independente de nada, é eco. Isso não invalida o que elas trouxeram, mas significa que eu não podia parar ali. Eu não ia publicar isso batendo o carimbo em cima do que duas IAs me contaram. Pedi uma nova rodada de pesquisa, agora comigo checando cada afirmação com fonte primária: o paper de verdade, o post de lançamento direto na fonte, os testes independentes de terceiros, e se "RLCD", o nome que eles usam pro método de treino, é um paper de verdade ou só um nome bonito sem verificação nenhuma por trás.

### O que o Jev realmente é

Tirando o marketing, o Jev é um classificador hospedado. Você manda um texto e uma lista de perguntinhas, cada uma com um tipo fixo de resposta:

- escolher uma opção de uma lista;
- dar uma nota numa régua;
- responder sim ou não, com probabilidade.

Ele não escreve nada, não planeja nada, não conversa. Código decide o fluxo; o modelo só responde a perguntinha rápido, em paralelo, sem gerar texto livre.

Como produto, isso é razoável: tem gente que hoje manda um texto pra um LLM de chat só pra ele devolver um rótulo dentro de um JSON, espera oito segundos, e reza pro schema não quebrar. Trocar isso por uma chamada que devolve só o rótulo, rápido, é engenharia legítima. **O problema nunca foi a ideia. É a embalagem em volta dela.**

## Os fatos que eu confirmei

Aqui estão as descobertas que realmente sobreviveram à checagem com fonte primária, não o que a IA me contou de segunda mão.

A credencial do fundador é real, mas a página da própria empresa exagera de um jeito que dá pra provar que é exagero. O [Diogo Almeida](https://typesafe.ai/team) é o quarto de vinte autores do [paper do InstructGPT](https://arxiv.org/abs/2203.02155), publicado e revisado por pares na [NeurIPS 2022](https://neurips.cc/virtual/2022/poster/52886), a conferência de peso da área. Autor de verdade, posição de peso, paper de verdade. Só que a página da equipe do TypeSafe diz isto, ao pé da letra:

> *"Diogo co-inventou o RLHF e o InstructGPT, os métodos que levaram ao ChatGPT e ao GPT-4."*

RLHF é de 2017, [cinco anos antes](https://arxiv.org/abs/1706.03741), assinado por outro time (Christiano, Leike, Amodei e companhia), sem o Diogo em lugar nenhum. Ele ajudou a aplicar RLHF pra treinar o InstructGPT. **Não inventou RLHF.** É a mesma inflação de currículo que eu já desconfiava antes de checar qualquer coisa, só que agora com prova.

O financiamento é real: **$40 milhões de seed** liderado pela [DCVC](https://www.dcvc.com/companies), **valuation de $200 milhões** [confirmado pela Forbes](https://www.forbes.com/sites/the-prompt/2026/09/15/this-200-million-startup-wants-to-fix-ais-overconfidence-problem/) de forma independente, não só pelo press release da própria empresa. Isso é dinheiro sério, não é golpe de um cara sozinho numa garagem.

[O post de lançamento](https://typesafe.ai/blog/introducing-system-one-models-and-jev) admite, com as próprias palavras, exatamente o que eu suspeitava sobre o gráfico de "zero alucinação":

> *"Nosso número não é empírico. Como o casamento com o schema é garantido, podemos colocar 0% no gráfico com confiança."*

Ou seja: o zero não vem de medir nada, vem de garantir que a resposta sempre cabe dentro das opções permitidas. Isso impede o modelo de inventar uma quinta categoria quando só existem quatro. **Não impede o modelo de escolher a categoria errada com confiança de 93%.** É a mesma crítica que [o The Register publicou](https://www.theregister.com/ai-and-ml/2026/09/16/typesafe-ai-debuts-model-for-machines-that-plays-doom/5296711): a comparação não é justa porque a saída não é linguagem, e resposta com tipo válido ainda pode estar simplesmente errada.

O próprio post também admite qual é a régua usada pra medir "precisão": *"usamos a média do GPT-6 Astra e do Fable 5.1 como resposta de referência"*, e completa admitindo que isso *"gera viés a favor dos modelos da OpenAI e da Anthropic"*. Ou seja, o gabarito é a média do que dois outros modelos de outras empresas responderam, com viés admitido pelos próprios autores, não verdade objetiva medida por humano.

O único teste feito por alguém de fora, o da newsletter [Every](https://every.to/also-true-for-humans/mini-vibe-check-typesafe-s-jev-judged-everything-i-ve-written-in-0-7-seconds), achou o Jev cerca de vinte e cinco vezes mais rápido, 0,35 segundo contra 8,83 segundos por passagem, e muito mais barato que o Claude Fable 5.1, só que pegando seis de sete defeitos plantados contra os sete de sete do Fable. **Mais rápido e mais barato, de verdade. Também mais fraco, de verdade.**

E o achado que nem o Grok nem o Claude bateram o martelo total, mas que confirmei sozinho: o nome do método de treino deles, RLCD, já existe. [Tem um paper de verdade, revisado por pares, de 2023](https://arxiv.org/abs/2307.12950), Reinforcement Learning from Contrastive Distillation, de um time completamente diferente, com [código dos próprios autores publicado no GitHub da Facebook Research](https://github.com/facebookresearch/RLCD), já que dois dos cinco autores são da Meta. É uma técnica diferente, sem relação nenhuma com o que o TypeSafe descreve. O RLCD deles não tem paper, não tem arquitetura publicada, não tem nada pra revisar. **É nome emprestado de pesquisa alheia colado num método que, até prova em contrário, é só um parágrafo de blog.**

## Minha desconfiança tinha fundamento?

Tinha. A ideia de produto é legítima e razoavelmente coerente por trás do jargão: decisão fechada e barata em volume alto é um problema real que hoje é resolvido de um jeito lento e caro, gerando texto livre só pra depois extrair um JSON dele. Resolver isso rápido tem valor de verdade.

Mas "alegação exagerada e sem muita diferença prática" também se confirma ponto a ponto:

- o currículo do fundador é inflado de um jeito que dá pra provar com data de publicação;
- o número mais chamativo do lançamento, zero alucinação, é definição de schema, não medição;
- o gabarito de precisão é média de LLM de outra empresa, não verdade objetiva;
- o único teste de fora achou o produto mais fraco que o modelo que ele promete substituir;
- o nome do método de treino mais citado colide com um paper de verdade que não tem nada a ver com eles.

Isso não é motivo pra chamar de golpe. É motivo de sobra pra chamar de "produto pequeno com discurso grande demais pro que ele realmente entrega". E antes de eu confiar meu dado a mais um terceiro que eu não conheço, com API fechada, lista de espera e sem paper publicado de nada que sustente o nome bonito, o cálculo de risco contra benefício não fecha pro meu caso de uso.

> **Pra guardar:** credencial real não é a mesma coisa que credencial honesta. Confira a data de publicação antes de acreditar no currículo, e confira o paper antes de acreditar no nome do método.

## E essa história de economizar token?

O caso do TypeSafe me lembrou de uma implicância separada que eu já queria colocar no papel, e não é sobre eles especificamente: a promessa de economia de token e de custo que praticamente todo produto desse tipo vende. É sobre a categoria inteira de ferramenta que promete "economize X vezes gastando com a gente em vez de gastar direto com seu provedor", não uma acusação a mais contra o TypeSafe.

Toda nova versão de modelo, e toda atualização de harness, muda a conta inteira, às vezes de um jeito violento. Quando eu pulei do [GPT Sol pro Astra](/2026/09/15/novo-llm-benchmark-v4-retestando-todos-llms-parte-2/), vi minha cota semanal de assinatura secar muito mais rápido do que eu esperava, sem eu ter mudado nada no meu jeito de trabalhar. Foi só o modelo novo consumindo diferente. **Isso é a regra desse mercado, não exceção**: OpenAI, Anthropic e companhia vão continuar mexendo em preço, em quantização, em política de cache, e em quanto raciocínio cada modelo gasta por baixo dos panos, com ou sem o meu consentimento.

Construir sua estratégia em cima de "economizar token" é apostar numa fundação que muda de mês em mês, decidida por gente que não te consulta. Uma ferramenta de meio de caminho que promete cortar custo hoje pode ficar irrelevante, ou pior, ficar mais cara que o caminho direto, na próxima atualização de modelo. É o mesmo motivo pelo qual eu não uso orquestrador nem framework de skill: quando o alicerce muda toda hora, complicar a estrutura em cima dele é ficar refém de manutenção sem necessidade.

Eu prefiro gastar token no talo e focar se o resultado que eu tiro daquele gasto vale a pena. Até agora, com minha assinatura, estou satisfeito com o que consigo produzir. Não sinto vontade nenhuma de gastar tempo cortando token, um esforço que sempre carrega o risco de piorar a qualidade da resposta em troca de uma economia que a próxima versão do modelo pode apagar sozinha.

> **Pra guardar:** não construa estratégia em cima de preço e consumo de token, porque isso muda de mês em mês por decisão de gente que não te consulta. Meça se o resultado vale o gasto, não o gasto em si.

E se um dia eu conseguir gastar token o suficiente pra ferver um lago inteiro com o calor do datacenter, eu vou gastar com o maior prazer do mundo. É minha vingança pessoal contra quem me obrigou a usar canudo de papel que desmancha na boca por tantos anos.
