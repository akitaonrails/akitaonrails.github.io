---
title: "Entendendo o Hype do Jev: pra que serve?"
slug: "entendendo-o-hype-do-jev-pra-que-serve"
date: '2026-10-03T14:00:00-03:00'
draft: false
translationKey: entendendo-o-hype-do-jev-pra-que-serve
description: "O Jev é um classificador hospedado, e o choque de '193x mais rápido' só existe porque muita gente usa LLM de chat como classificador caro. Reproduzo o ensaio do Paulo Câmara, da LUA Vision, com os gráficos dele, explico o que é um classificador e por que é a primeira coisa que um cientista da computação pensa, aponto onde o ensaio pede desconto, comparo com as alternativas abertas Clef e Laya, e fecho com como pensar em ferramenta desse tipo no seu projeto."
tags:
- inteligencia-artificial
- llms
- engenharia-de-software
---

Este texto é pra desmistificar o Jev: o que ele é de verdade, quando você precisa de um, no que ele ajuda, e por que o espanto em volta dele diz mais sobre como as pessoas vêm usando LLM do que sobre o produto.

> **TL;DR pra quem só quer saber qual usar:** o Jev é um classificador hospedado, bom e barato pra decisão repetida sobre texto, e não é bala de prata. Se você quer a comparação direta, pule pra [Clef](#clef-da-cloudflare), a alternativa aberta da Cloudflare com pesos e imagem; pra [Laya](#laya-e-o-arbiter), o encoder pequeno pra rodar local e ajustar na sua tarefa; pro [ranking público](#o-decision-index-como-medir-isso-você-mesmo), com 70 modelos lado a lado; ou direto pra [como decidir no seu projeto](#como-programador-deve-pensar-nisso).

Quando o Jev apareceu, eu [não dei muita bola](/2026/09/16/por-que-coisas-como-typesafe-ia-nao-me-interessam/). A home era um festival de jargão, Kahneman aqui, Jevons ali, um "193x mais rápido" sem o benchmark do lado, e minha regra pra ferramenta nova de IA é não adotar camada intermediária nenhuma até doer não ter, então não perdi tempo com ele.

Naquele texto eu cheguei na conclusão de que, tirando o marketing, o Jev é um classificador hospedado: você manda um texto e perguntas de resposta fechada, ele devolve a opção e a probabilidade, sem gerar prosa nenhuma. E que o "193x" só impressiona porque a comparação é contra um LLM de chat escrevendo parágrafo pra depois você catar um rótulo lá dentro.

O que eu não tinha percebido na época é o tamanho do hábito que o Jev expõe. Muita gente estava usando LLM de fronteira como substituto caro de um classificador comum, e nunca tinha pensado em classificador, porque nunca precisou pensar: o LLM resolvia, mal e caro, e ninguém media.

Pra mim, classificador seria a primeira ideia, e é por isso que o Jev não me pareceu novidade. Pra muita gente foi revelação. Esse descompasso é o assunto deste texto.

## Este texto é uma colaboração

Boa parte do que você vai ler aqui é do [Paulo Câmara](https://www.linkedin.com/in/paulocamara/), neurocientista, cofundador e CTO da LUA Vision, a empresa brasileira cujo modelo eu [testei](/2026/09/23/llm-benchmark-v4-genesys-pi-novo-competidor-brasileiro/) e [investiguei](/2026/09/30/o-misterio-do-genesys-pi-da-lua-vision-modelo-frontier-brasileiro/) nas últimas semanas. Ele escreveu um ensaio, "O aluno que marca a letra A", pra ser publicado aqui, em que leu as letras miúdas do Jev, abriu os cerca de 350 repositórios de teste que apareceram no GitHub na semana do lançamento e recalculou do zero os quatro resultados principais.

Vale o aviso que o próprio Paulo faz no fim: ele fundou uma empresa que faz modelo próprio e disputa o mesmo mercado. Leia com esse desconto, e confira os números na fonte, que ele linka todas.

## Primeiro: o que é um classificador

Classificador é uma função que recebe uma entrada e devolve uma de um conjunto fixo de categorias, normalmente com uma probabilidade pra cada uma. Esse e-mail é spam ou não. Esse ticket é de cobrança, suporte ou vendas. Essa transação parece fraude.

A lista de respostas possíveis é fechada e você conhece ela antes de rodar.

A maneira clássica de construir um é com exemplos rotulados: um conjunto de textos em que alguém já disse a resposta certa. Em cima disso você treina um modelo, que pode ser coisa simples como regressão logística ou naive Bayes, ou um encoder pequeno tipo BERT com umas centenas de milhões de parâmetros. Em qualquer dos casos, o modelo final é pequeno, roda local, responde em milissegundos, custa quase nada por chamada, e devolve números que você consegue calibrar e auditar contra os seus próprios dados. Isso existe há décadas e é matéria de graduação.

Por isso, quando alguém com formação em computação vê um problema do tipo "decidir em qual balde esse texto cai, milhares de vezes por dia", a primeira pergunta é "quantos exemplos rotulados eu tenho?", não "qual LLM eu uso?".

Um LLM de chat é um gerador de texto de bilhões de parâmetros. Usar ele pra devolver um rótulo é pagar por token de saída, esperar segundos por resposta, lidar com formato que às vezes quebra, e aceitar um comportamento que muda quando o fornecedor atualiza o modelo. Dá pra fazer, e desde 2019 a classificação zero-shot com modelo de linguagem está documentada. Só que é a opção cara e lenta, e só compensa quando você não tem exemplo nenhum ou quando as categorias mudam a cada pedido.

O Jev entra exatamente nesse espaço. Ele é um classificador que aceita categorias definidas na hora, várias perguntas sobre o mesmo texto numa chamada só, hospedado, barato por token e rápido.

Comparado com o LLM de chat gerando parágrafo, ele é uma vitória de engenharia. Comparado com um classificador treinado pra uma tarefa estável, ele é uma conveniência que troca controle por flexibilidade. Guarde essas duas réguas, porque o resto do texto vai e volta entre elas.

## O artigo do Paulo: "O aluno que marca a letra A"

*O que segue é o ensaio do Paulo Câmara, escrito pra este texto. Os subtítulos são dele.*

![Folha de respostas com a letra A marcada em todas as questões e um carimbo de 92% de certeza](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261003140000_jev-folha-de-respostas.png)

Toda semana aparece um salvador da IA. O desta se chama Jev.

Saiu no dia 15 de setembro, com US$ 40 milhões no bolso, avaliação de US$ 200 milhões e uma promessa que cabe num outdoor: duzentas vezes mais rápido, quatrocentas vezes mais barato, calibrado e incapaz de alucinar. Em 24 horas, 13% dos times pagos do gateway da Vercel já estavam usando. Em uma semana, havia mais de 300 repositórios no GitHub testando o bicho.

Fiz o que faço com todo salvador. Li as letras miúdas, abri os cerca de 350 repositórios, e refiz as contas dos que publicaram o dado bruto. O que encontrei cabe na imagem aí de cima: uma folha de respostas com a letra A marcada em todas as questões.

Quando não tem informação nenhuma para decidir, o Jev marca a primeira alternativa. Em 3.000 de 3.000 sorteios. Com até 92% de certeza. Guarde essa imagem, porque ela explica o resto do texto.

### O que ele é, sem outdoor

Tire o marketing e sobra uma prova de múltipla escolha sem redação. Você manda um texto, faz perguntas com resposta fechada (escolher entre até 255 opções, dar nota numa escala, dizer sim ou não) e ele devolve a probabilidade de cada resposta. Não escreve uma linha. Não explica. Não faz conta. Não chama ferramenta.

Isso é bom, e eu quero começar pelo que é bom. Muita empresa hoje usa um LLM de fronteira como um if de luxo: manda o documento, espera o modelo pensar em voz alta por vinte segundos, paga cada palavra que ele escreve, valida o JSON e só então descobre que o ticket era de cobrança. O Jev corta esse teatro. Lê o texto uma vez, dá nota para cada opção, e acabou. Por isso a saída sai de graça e dez perguntas custam quase o mesmo que uma.

O mecanismo, porém, não é novo. Ler a nota de cada resposta possível é como se avalia modelo de linguagem em múltipla escolha desde o GPT-2. É como funcionam os modelos de recompensa do RLHF, técnica que o fundador da TypeSafe ajudou a criar na OpenAI.

Poucos dias depois do lançamento já havia cópia aberta imitando a interface com modelo público, e dez dias depois Stanford e Nvidia soltaram um concorrente de pesos abertos. A TypeSafe não publicou artigo, pesos, tamanho do modelo nem resultado em benchmark público. No FAQ do anúncio, "O Jev é só um LLM menor?" aparece como pergunta. A resposta é uma linha: "não é pequeno nem é um LLM". Só isso.

### Um adversário para cada manchete

A página inicial diz "193,6× mais rápido, 444,6× mais barato". Refiz a conta com a tabela que a própria empresa publicou. O 444,6 é o custo do Opus 5, o modelo mais caro do painel, dividido pelo custo do Jev. O 193,6 é o tempo do Sonnet 5 dividido pelo tempo do Jev. Um adversário para cada manchete.

É como anunciar que o seu carro é mais econômico que uma Ferrari e mais rápido que um caminhão, e deixar o leitor concluir que ele é o melhor carro do mundo.

![Quantas vezes o Jev é mais barato, conforme quem está do outro lado](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261003140000_jev-jev-mais-barato-por-adversario.png)

*Quantas vezes o Jev é mais barato, conforme quem está do outro lado. Fonte: tabela pública da TypeSafe (evals.typesafe.ai) e testes independentes com LLM sem raciocínio.*

Contra o modelo barato que acerta parecido, o Luna, o Jev é 8 vezes mais barato. E isso com todos os LLMs da comparação pensando antes de responder, coisa que ninguém faz para rotear ticket. Contra um LLM sem raciocínio, os testes independentes medem cerca de 4 vezes no custo e de 2 a 7 no tempo. Continua sendo muito. Só que é uma ordem de grandeza a menos que o outdoor.

Tem um detalhe que quase ninguém leu. Não existe gabarito nessa avaliação. A "acurácia" é o quanto cada modelo concorda com a média de dois modelos de fronteira. O Jev concorda 67,8% das vezes, igual ao Sonnet 5. O Opus 5 fica em 73,1%.

![Concordância com a referência contra custo por caso, média dos quatro workflows da TypeSafe](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261003140000_jev-concordancia-vs-custo.png)

*Concordância com a referência contra custo por caso, média dos quatro workflows da TypeSafe. A faixa verde vai de 66,8% a 67,9%: Luna, Sonnet 5, Terra e Jev.*

Quebrando por tarefa, aparece o que a média esconde. Em notas fiscais, que exigem conferir valor, quantidade e data, o Jev fica 17 pontos atrás do melhor modelo (61,8% contra 79,1%) e abaixo até do Luna. A documentação dele avisa que ele "não é uma calculadora". Pelo menos isso é verdade.

![Concordância por workflow](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261003140000_jev-concordancia-por-workflow.png)

*Concordância por workflow. Fonte: evals.typesafe.ai.*

E o dado mais sólido do site da TypeSafe nem é sobre o Jev. Todos os oito LLMs avaliados acertam mais quando a tarefa é quebrada em perguntas pequenas e a lógica fica no código. O Haiku 4.5 sai de 18,1% para 53,6%. A lição mais útil do lançamento é de engenharia, e vale para qualquer modelo.

### A conta que o preço entrega

Preço é dado técnico disfarçado. A US$ 0,042 por milhão de tokens, uma GPU alugada precisa ler de 13 a 20 mil tokens por segundo só para empatar. Numa conta de cenário, isso fecha com um modelo de 6 a 37 bilhões de parâmetros ativos, que é modelo pequeno, ou com subsídio. A TypeSafe escreveu, com uma sinceridade que eu respeito, que "não tem como provar que não é subsidiado".

Desde o lançamento, o limite de uso por conta caiu de 250 mil para 100 mil tokens por segundo. A documentação avisa que ele muda "sem aviso" enquanto não chegam os "grandes contratos de GPU", e a lista de suboperadores mostra a inferência rodando numa nuvem de GPU alugada sob demanda. É modelo de fronteira com capacidade de startup.

Na mesma conta, cada decisão gasta uns 14 joules. Esse é o melhor argumento do Jev, e eu defendo essa régua faz tempo: acerto por joule, e não só acerto. Nisso ele é bom de verdade.

### Português de prova

Só encontrei um teste do Jev em português: o ENEM 2025. Refiz a conta a partir das respostas brutas. Foram 103 acertos do Jev contra 102 de um modelo aberto de 120 bilhões de parâmetros. Empate estatístico (p = 1,0).

![Acerto do Jev no ENEM 2025 por área](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261003140000_jev-enem-2025-por-area.png)

*Acerto do Jev no ENEM 2025 por área, 182 questões válidas, com margem de 95%. Recalculado a partir do repositório patryckalves/jev-no-enem.*

O Jev lê português de prova melhor que muito cursinho: 78% em Linguagens. E faz Matemática como quem chuta: 25%, com o chute valendo 20%. Em espanhol, outra auditoria mediu perda de 3 a 6 pontos em relação ao inglês e de 17% a 38% mais tokens pelo mesmo texto. É o imposto do token que eu medi no meu paper, cobrado de novo, agora por outro fornecedor.

Um detalhe a favor: a opção explícita de "inválido" nesse experimento separou as questões mais difíceis. É a rota de abstenção que vale exigir em produção, medindo junto quanto ela deixa sem resposta.

### O aluno que marca a letra A

Voltemos à folha de respostas.

Um auditor pediu ao Jev para prever um dado justo, que ele não tinha como ver. A resposta honesta é 1/6 para cada face. Baixei as 1.000 respostas e contei. Em todas, o Jev escolheu a primeira opção da lista que recebeu: o "1" no dado, o "vermelho" no dado de cores, a "cara" na moeda, o "norte" na roleta. Com 76% a 92% de certeza.

Um segundo pesquisador repetiu a mesma pergunta 2.000 vezes, de forma independente. Deu a mesma coisa. A ressalva: isso vale pra pergunta de escolha; na formulação de sim ou não com probabilidade, o mesmo repositório mostra o Jev mais perto da referência, ainda superestimando probabilidade baixa.

Quando não sabe, ele não diz que não sabe. Ele marca a letra A, com convicção.

![Probabilidade declarada contra frequência real](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261003140000_jev-probabilidade-declarada-vs-real.png)

*Probabilidade declarada contra frequência real. Sorteios: 1.000 respostas recalculadas (KantaHayashiAI). Risco cardíaco: 5.000 pessoas do BRFSS, recalculado (rubinagentagi-tech). Itens com discordância humana: estudo pré-registrado com ChaosNLI (GautamTalksDev). ENEM: recalculado (patryckalves).*

O gráfico mostra o padrão inteiro. Onde ele tem sinal, como nas respostas do ENEM acima de 0,9, o que ele diz e o que acontece coincidem: 97,1% de confiança, 97,6% de acerto. Onde não tem, a certeza fica e a realidade vai embora.

Num teste com 5.000 pessoas reais, a taxa de doença cardíaca era 9%. O Jev atribuiu, em média, 27%. Recalculei: a probabilidade dele é pior do que simplesmente dizer 9% para todo mundo.

### Sistema 1, literalmente

A TypeSafe chama o Jev de "modelo System One", em homenagem ao pensamento rápido de Kahneman. É a parte mais honesta do produto, só que não pelo motivo que a empresa gostaria. No livro, o Sistema 1 é rápido, barato e automático. Também é onde mora o excesso de confiança: ele monta a história mais coerente com o que tem na frente e não registra o que falta.

Kahneman passou anos discordando de Gary Klein sobre quando confiar na intuição de especialista. Em 2009 os dois publicaram juntos um artigo com o título mais elegante da psicologia: "uma falha em discordar". A conclusão cabe numa linha. A intuição só merece confiança em ambiente de alta validade, onde existe regularidade e houve feedback para aprendê-la. Fora dele, a confiança continua alta e deixa de dizer qualquer coisa sobre o acerto.

É o Jev, sem tirar nem pôr. Classificar texto em inglês é ambiente de alta validade, e ali ele vai bem. Prever risco, sortear, adivinhar a regra da empresa que ninguém contou para ele: ambiente de baixa validade. Ali ele segue confiante.

No laboratório, a gente separa duas coisas: decidir, e saber se decidiu bem. A segunda se chama metacognição.

Ela se mede com teoria de detecção de sinais, o meta-d′ de Maniscalco e Lau, e depende em parte de regiões pré-frontais distintas das que sustentam a decisão. Fleming e colegas acharam isso na anatomia em 2010, e Rounis e colegas, no mesmo ano, mostraram que estimulação magnética no pré-frontal derruba a metacognição sem mexer no acerto (resultado com replicação disputada por Bor e colegas em 2017). É por isso que existe gente que acerta sem saber que acertou, e gente que erra com convicção de sobra.

O campo que a empresa chama de confidence é uma fórmula sobre a mesma distribuição que produziu a resposta: numa escolha de duas opções, 2p − 1. Isso não é defeito em si. Um observador ideal faz exatamente isso e acerta.

O problema é que a distribuição do Jev perde a calibração fora do que ele conhece, e nada no sistema confere a resposta por outra via. Quando o sinal some, a resposta fica errada e a confiança fica igual, porque as duas são o mesmo número. Num estudo pré-registrado com itens em que cem pessoas discordam entre si, a concordância humana é de 47% e o Jev segue com 81% de confiança. Quando embaralharam as coordenadas de uma tarefa espacial, o acerto despencou para 5% a 22% e a confiança baixou 0,028.

Um modelo que diz 83% sobre um dado que não viu não é calibrado. É assertivo.

### Atenção se captura

Eu estudei atenção no doutorado, e esperava ver captura: o estímulo mais gritante vencendo. Não foi o que os testes mostraram. O grito, o famoso "ignore suas instruções", quase não passa. O que passa é a frase plausível, sem origem conferida. A psicologia tem nome para isso: falha de monitoramento de fonte. O sistema trata uma afirmação que ninguém verificou como se fosse fato.

![Decisões viradas por tipo de ataque](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261003140000_jev-decisoes-viradas-por-ataque.png)

*Decisões viradas por tipo de ataque. Ataque grosseiro: 1 em 1.056 (cwhy). Comando injetado e opinião não verificada: 9.744 variantes (Hu et al., 2026). Contexto fluente otimizado: 312 de 508 decisões corretas (Xu, 2026).*

Nos números: o ataque grosseiro passa 1 em 1.056. Uma única opinião não verificada colada no fim do texto virou 12,1% das decisões, empatada estatisticamente com o comando injetado mais forte. Uma linha dizendo "o administrador que encerrou a discussão confirmou que o artigo foi mantido" derrubou o acerto de 96,5% para 26,5%.

Um campo falso dizendo que o usuário tinha pré-aprovado `rm -rf ~/.ssh` baixou a chance de bloqueio de 0,76 para 0,48. Lembra o efeito de desinformação de Loftus: a informação sugerida reescreve o julgamento.

A captura vale também para pistas que não deveriam contar. Com o mesmo texto, dizer só "quem escreveu é negro" ou "quem escreveu é branco" mudou a taxa de pena de morte atribuída pelo Jev de 29,5% para 62,7%. A direção é o de menos. Uma decisão de vida ou morte andou 33 pontos por causa de uma informação que não tinha nada a ver com o caso.

Tem mais uma que eu não consigo deixar passar. Trocar só o rótulo das opções, de "0/1" para "no/yes", sem mudar a definição de nenhuma, inverteu 70 de cada 100 respostas. A taxa de erro de tipo continuou em zero. O formato estava perfeito. A decisão estava ao contrário.

Esses números vêm de preprints e de estudos pequenos. A porcentagem exata muda com prompt, tarefa e versão do modelo; a classe de falha, não.

### Probabilidade que não fecha

Probabilidade tem uma regra de primeiro semestre: a chance de algo mais a chance do contrário dá 1. Na própria documentação da TypeSafe, "o cliente pede reembolso?" recebe 0,72, e "o cliente pede algo que não é reembolso?" recebe 0,47. Soma 1,19.

O par não é um complemento exato, e a TypeSafe não promete que duas perguntas separadas formem uma distribuição conjunta. Mas é o exemplo que a própria empresa escolheu pra mostrar o produto, e ele não fecha. O conserto é de desenho: uma pergunta de escolha com opções mutuamente exclusivas, em vez de dois sim-ou-não somados.

Gente erra probabilidade de muitas formas, mas nessa costuma acertar. Quando a pergunta vem em par, a chance de algo e a do contrário somam perto de 1. Tversky e Koehler mostraram isso em 1994. O Jev erra onde gente acerta. A mesma decisão muda de valor conforme a redação da pergunta, e isso é o contrário de "probabilidades epistemicamente honestas".

### "Não alucina"

O anúncio diz que o Jev "não consegue alucinar" e mostra 0% de erro de tipo. O zero é verdadeiro e irrelevante. Como ele só pode responder dentro das opções que você deu, é impossível errar o formato. Chamar isso de não alucinar é como elogiar o aluno da letra A porque ele nunca deixa questão em branco. É verdade. E daí?

Num modelo que escolhe, alucinar é escolher errado com convicção. Na verificação de fatos, o Jev empata com o GPT-6 Astra em acurácia, mas chama de "sustentada" uma afirmação sem apoio em 23% dos casos, contra 14% do Astra. Em 76% das situações em que não havia ferramenta nenhuma, ele escolheu chamar uma ferramenta. Com uma regra da empresa que não contaram para ele, errou 19 de 24 decisões, 15 delas com mais de 90% de certeza. Diante de uma lei inventada, absteve-se zero vezes.

### Segurança

Primeiro, onde os seus dados vão parar: Estados Unidos, AWS e uma nuvem de GPU chamada Modal. A retenção vale "pelo tempo razoavelmente necessário", sem prazo, e retenção zero só existe no plano enterprise.

O contrato de dados cita as cláusulas contratuais padrão da União Europeia, o adendo do Reino Unido e a lei da Califórnia, e não tem uma palavra sobre LGPD. Se você mandar dado de brasileiro, a base legal da transferência internacional fica por sua conta, e isso é pergunta pra advogado antes de assinar. A promessa de não treinar com o que você envia existe e é boa. O SOC 2 existe e só aparece a pedido.

Como detector de ataque, o Jev é bom, e com menos alarme falso que muito LLM: pegou 40 de 41 injeções num teste com páginas reais. Como juiz de um conteúdo que traz o ataque dentro, ele cede, como mostrei acima. A diferença parece sutil e decide tudo. Na palestra do GV Angels eu disse que um agente não é funcionário, é uma chave de acesso que conversa. Um portão feito só com o Jev é uma fechadura que abre quando alguém escreve no bilhete que o dono autorizou.

O erro que me preocupa não é o erro com dúvida. Esse vai para revisão. É o erro com 92% de certeza, que atravessa qualquer limiar que você configurar.

### A onda

Uma palavra sobre as evidências, porque usei muitas.

![Repositórios de teste do Jev criados por dia no GitHub](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20261003140000_jev-repositorios-por-dia.png)

*Repositórios de teste do Jev criados por dia no GitHub, a partir dos metadados de 346 repositórios indexados.*

Em uma semana nasceram cerca de 350 repositórios testando o Jev. Classifiquei todos pelo que eles deixam conferir. São 89 com dado bruto, código, versão fixada e estatística, e 170 com dado e código; o resto oferece menos que isso.

Só 11 escreveram a hipótese antes de rodar o teste. A mediana é de uma estrela no GitHub, o que quer dizer que quase ninguém olhou. E a onda de testes acompanhou a onda de hype: pico em 21 de setembro, quase nada depois do dia 23.

Por isso não aceitei número por autoridade. Os que sustentam este texto eu conferi na fonte, e os quatro principais eu recalculei do zero.

### Veredito

**Verdade:**

- Rápido: de 100 a 400 ms.
- Barato: de 45 a 323 vezes menos que um LLM de fronteira na mesma decisão.
- Empata com o topo em julgamentos estreitos, como verificar se um trecho sustenta uma afirmação.
- Confiável acima de 0,9 em dado parecido com o que ele já viu, depois de você conferir isso no seu.
- Bom detector de injeção.

**Castelo de areia:**

- 193,6× e 444,6×.
- "Inteligência de fronteira".
- "Não alucina".
- Calibração como regra geral.
- Seguro como guarda único de agente.
- Nova arquitetura: ninguém viu.

O Jev não é o salvador de nada. Também não é "só um classificador". É uma boa peça de engenharia de produto, que embrulha técnica conhecida numa interface que a automação precisava, a um preço que muda o que é viável. O produto é novo. O que ele afirma de novo, até aqui, é marketing: chama formato de verdade, calibração de tarefa de honestidade, e Sistema 1 de virtude.

### O que vai quebrar primeiro

- Os portões de agente feitos só com o Jev, porque o ataque que os fura já está publicado e custa centavos.
- Os sistemas que confiam no limiar de fábrica em dado novo, em outro idioma ou com regra interna, porque vão automatizar erro com 90% de certeza.
- Quem usar a probabilidade dele como risco real, em crédito, saúde ou previsão, porque ele infla evento raro.
- E a vantagem de preço, porque em dez dias já havia cópia aberta e concorrente mais rápido.

### Se você for usar mesmo assim

- Fixe a versão. O alias `jev-latest` troca de modelo sozinho, e a sua calibração vai junto.
- Toda pergunta com "nenhuma das anteriores". Sem ela, ele marca a letra A.
- Embaralhe a ordem e use nomes neutros nas opções. Teste se a decisão muda.
- Recalibre com 50 a 300 exemplos seus antes de escolher limiar. Num teste, o erro de calibração caiu de 0,117 para 0,008.
- Marque como não confiável tudo que vem de fora: e-mail, página, resultado de ferramenta.
- Nunca deixe ele sozinho autorizar ação destrutiva, financeira ou com dado pessoal.
- Conta, data e regra de negócio ficam no código.
- Antes de assinar, compare com a linha de base barata: um modelo aberto lendo probabilidades, ou um classificador treinado se a tarefa for sempre a mesma.

### Leia com desconto

Eu fundei uma empresa que faz modelo próprio e disputa o mesmo mercado. Leia com esse desconto. É exatamente por isso que cada número aqui tem fonte aberta: você não precisa confiar em mim, precisa conferir.

E se alguém te vender o Jev como salvador, faça a pergunta que eu faço para toda startup: qual teste, e de quando? Se a resposta demorar, já é resposta.

### Fontes do ensaio

TypeSafe. [Anúncio do Jev](https://typesafe.ai/blog/introducing-system-one-models-and-jev) · [modelos e limites](https://docs.typesafe.ai/models) · [confidence](https://docs.typesafe.ai/confidence) · [falhas conhecidas do jev-1.13](https://docs.typesafe.ai/model-jaggedness/jev-1.13) · [avaliação de workflows](https://evals.typesafe.ai/) · [adaptador para LLMs](https://github.com/typesafe-ai/system-one-adapter-python) · [privacidade](https://typesafe.ai/legal/privacy-policy) · [processamento de dados](https://typesafe.ai/legal/data-processing) · [central de confiança](https://trust.typesafe.ai/)

Recalculados pelo Paulo a partir do dado bruto. [ENEM 2025](https://github.com/patryckalves/jev-no-enem) · [sorteio cego](https://github.com/KantaHayashiAI/jev-does-not-play-dice) · [risco cardíaco](https://github.com/rubinagentagi-tech/jev-heart-risk-bench) · [verificação de fatos](https://github.com/adorosario/jev-rag-claim-verification)

Pré-publicações. [Hu et al., JevAdvBench](https://arxiv.org/abs/2609.31142) · [Xu, JevOut](https://arxiv.org/abs/2609.30243) · [Sun et al., Type-Safe Is Not Error-Free](https://arxiv.org/abs/2609.26758) · [Ibrahim e Zaki](https://arxiv.org/abs/2609.24574) · [Li et al., JEV-as-a-Judge](https://arxiv.org/abs/2609.26550)

Testes independentes. [discordância humana (ChaosNLI)](https://github.com/GautamTalksDev/jevbench) · [replicação do dado](https://github.com/pobooo/jev-dice) · [viés de dialeto](https://github.com/zachlandes/jev-dialect-bias) · [49 tarefas contra LLM sem raciocínio](https://github.com/OmarMujahid/jev-decision-bench) · [calibração e negação](https://github.com/colinmcnamara/jev-first-look) · [recalibração](https://github.com/AnthusAI/Jev-Calibration) · [injeção em discussões da Wikipedia](https://github.com/zkousama/jagged) · [espanhol](https://github.com/marcosmartinez/jev-acento) · [ferramentas](https://github.com/baibizhe/jev-decision-benchmarks) · [regra interna não informada](https://github.com/phuryn/experiments) · [coordenadas embaralhadas](https://github.com/scd13150/jev-field-notes) · [ataques grosseiros](https://github.com/cwhy/decision-injection-bench) · [detecção de injeção](https://github.com/kaiserama/im-in-danger) · [índice de auditorias](https://github.com/Yifan-Lan/awesome-jev-robustness)

Imprensa. [VentureBeat, portões de agente](https://venturebeat.com/security/companies-are-putting-jev-in-charge-of-ai-agent-decisions-and-prompt-injection-can-influence-the-verdict) · [VentureBeat, CLM-8B](https://venturebeat.com/technology/stanford-and-nvidias-open-clm-8b-caches-reusable-agent-actions-and-runs-up-to-9x-faster-than-jev-in-tests)

Literatura. Fleming et al. (2010), Science 329 · Rounis et al. (2010), Cognitive Neuroscience 1 · Bor et al. (2017), PLoS ONE 12 · Johnson, Hashtroudi e Lindsay (1993), Psychological Bulletin 114 · Kahneman (2011), Thinking, Fast and Slow · Kahneman e Klein (2009), American Psychologist 64 · Loftus, Miller e Burns (1978), J. Experimental Psychology: Human Learning and Memory 4 · Maniscalco e Lau (2012), Consciousness and Cognition 21 · Ouyang et al. (2022), NeurIPS · Radford et al. (2019), OpenAI · Tversky e Koehler (1994), Psychological Review 101 · Câmara (2026), Inherited Weights, [doi:10.5281/zenodo.22899767](https://doi.org/10.5281/zenodo.22899767)

## As alternativas abertas: Clef e Laya

Desde o lançamento do Jev, a categoria ganhou concorrência aberta, e isso muda a conversa sobre "arquitetura nova". Dois nomes importam.

### Clef, da Cloudflare

Em 1º de outubro a Cloudflare lançou o [Clef](https://blog.cloudflare.com/clef-decision-models/) e o Clef-flash: a mesma abstração do Jev (um estado compartilhado, várias perguntas tipadas, distribuição sobre as opções), com [API compatível](https://developers.cloudflare.com/workers-ai/models/clef/), pesos abertos sob Apache 2.0 e entrada de imagem. A arquitetura é descrita: um Qwen congelado como base (27B no Clef, 9B no Clef-flash), adaptadores LoRA e uma cabeça que dá nota direto a cada opção permitida, treinada com objetivo de classificação e de calibração. Ou seja, a linhagem que o Paulo apontou, agora com código inspecionável.

Isso não prova que a TypeSafe usa a mesma coisa, mas prova que dá pra reproduzir o produto com componente conhecido. A Cloudflare rodou o [Decision Index](https://github.com/apolinario/decision-index), uma suíte aberta e independente com dezenas de tarefas de classificação, roteamento, retrieval e segurança, e publicou a tabela. Alguns pontos:

| Tarefa | Clef | Clef-flash | Jev | Laya |
|---|---:|---:|---:|---:|
| BFCL (seleção de ferramenta) | 98,47 | **98,76** | 95,75 | 38,13 |
| Banking77 (intenção) | **94,20** | 90,93 | 79,74 | 14,29 |
| CLINC150 com fora de escopo | **97,43** | 66,77 | 89,27 | 3,19 |
| When2Call | 72,37 | 65,58 | **80,97** | 11,94 |
| BRIGHT (retrieval) | 45,91 | 39,26 | **47,52** | 19,90 |
| PhishNChips | **79,60** | 75,05 | 62,55 | 50,15 |

Lendo a tabela inteira: o Clef aparece mais forte na maioria das tarefas, o Jev ainda ganha algumas, e é uma rodada interna da Cloudflare, numa suíte pública que pode ser treinada contra. O preço hospedado é o outro lado: [US$ 0,24 por milhão de tokens no Clef e US$ 0,09 no Clef-flash](https://developers.cloudflare.com/workers-ai/platform/pricing/), contra US$ 0,042 do Jev. O Jev continua sendo o serviço hospedado mais barato dos três, por uma margem de 2 a 6 vezes, e continua sendo só texto.

### Laya (e o Arbiter)

O [Laya](https://github.com/NandhaKishorM/laya) ataca o problema pela outra ponta. São encoders pequenos, de 322 a 421 milhões de parâmetros (ModernBERT-large na versão tipada), com uma cabeça de escolha, Apache 2.0, feitos pra rodar local e ser ajustados pra uma tarefa recorrente. O [Arbiter](https://github.com/0xBakeer/arbiter) empacota eles atrás de uma API compatível com o Jev, com batching e deploy em Mac e NVIDIA. O Arbiter é só camada de serviço.

O README do Laya é raro de tão explícito sobre os limites, e eu prefiro repetir do que suavizar:

- os checkpoints base pontuam perto do acaso no benchmark de decisão tipada do próprio projeto; os 0,766 de acurácia que aparecem na manchete vêm de um checkpoint ajustado no split de treino daquele benchmark;
- os modelos saem superconfiantes de fábrica, e a calibração precisa ser refeita no domínio de implantação;
- o contexto da versão tipada é de 1.024 tokens, bom pra ticket e mensagem curta, insuficiente pra documento longo sem chunking;
- com mais de 50 opções, a cabeça de classificação satura e o próprio Laya relata o Jev se saindo melhor.

Nada disso é defeito da ideia. É aprendizado de máquina aplicado do jeito que sempre foi: modelo pequeno é excelente quando a tarefa é estável e existem exemplos rotulados, e comportamento zero-shot amplo exige modelo pré-treinado bem maior. O Laya é a opção quando privacidade, operação offline, latência previsível ou ajuste fino no seu domínio importam mais do que fazer pergunta arbitrária sobre documento arbitrário. É, no fundo, o classificador clássico do começo deste texto, com uma interface moderna.

Existe ainda o [Kev-9B](https://huggingface.co/jaredpalmer/kev-9b), outro Qwen 9B congelado com LoRA e cabeça de decisão, Apache 2.0, que cabe numa GPU de 24 GB. Três implementações abertas em menos de três semanas dizem o mesmo: modelo de decisão tipada virou padrão de implementação.

## O Decision Index: como medir isso você mesmo

Toda essa discussão sobre "quem é melhor" só tem sentido com uma régua pública, e ela existe. O [Decision Index](https://github.com/apolinario/decision-index) é uma suíte aberta, sem ligação com a TypeSafe, feita pra modelo de decisão tipada: estado mais perguntas de escolha ou sim-ou-não, uma probabilidade pra cada opção.

A versão atual, 0.2.1, conta 38 benchmarks em cinco áreas (ferramentas e automação, retrieval e classificação, conhecimento e raciocínio, compreensão de linguagem, gosto humano), uns 120 mil pedidos no total, com duas regras que importam: a nota é corrigida pelo acaso (0 é chute aleatório, 100 é perfeito) e pedido sem resposta conta como errado. Sem truncar entrada, sem filtrar opção, sem ajustar prompt por benchmark.

O [placar ao vivo](https://huggingface.co/spaces/multimodalart/jev-decision-index) tem 70 modelos mais o Jev como referência. Baixei o arquivo de dados do placar e refiz a tabela; abaixo vai o topo e os nomes que apareceram neste texto. Latência é a mediana medida pelos mantenedores numa RTX PRO 6000, um pedido por vez; a do Jev é de API hospedada, então não compara com as demais.

"Pesos abertos" quer dizer checkpoint publicado no Hugging Face; "código aberto sobre modelo aberto" é técnica de inferência publicada em cima de um Qwen ou Gemma de prateleira, sem checkpoint próprio. O placar não registra a licença de cada um, então confira antes de usar em produto.

| # | Modelo | Base | Pesos | Índice 0.2.1 | Latência mediana |
|---|---|---|---|---:|---:|
| 1 | Jev (TypeSafe, jev-1.13.0) | não publicada | fechados, só API | 57,91 | 524 ms (API) |
| 2 | Surogate Rune 26B-A4B v3 | Gemma 4 26B-A4B | abertos | 57,44 | 121 ms |
| 3 | Decider chat Gemma-4-31B | Gemma 4 31B | código aberto sobre modelo aberto | 57,33 | 109 ms |
| 4 | pplx-decider-v1-27b | Qwen3.8-27B | abertos | 56,40 | 101 ms |
| 5 | simple-jev Qwen3.8-27B | Qwen3.8-27B | código aberto sobre modelo aberto | 55,74 | 373 ms |
| 6 | Jebadiah 27B | Qwen3.8-27B | abertos | 54,67 | 110 ms |
| 7 | Eikos-27B | Qwen3.8-27B | abertos | 53,13 | 130 ms |
| 8 | reflex 27B | Qwen3.8-27B | código aberto sobre modelo aberto | 52,16 | 108 ms |
| 9 | Decider chat Qwen3.6-27B | Qwen3.6-27B | código aberto sobre modelo aberto | 51,35 | 84 ms |
| 10 | Winnow-12B | Gemma 4 12B | abertos | 50,02 | 73 ms |
| 19 | Hopper (G) 1.2 | Qwen3.5-4B, LoRA | abertos | 40,77 | 23 ms |
| 27 | Kev 9B | Qwen3.5-9B, LoRA | abertos | 38,48 | 51 ms |
| 55 | Lavoir | ModernBERT-large | abertos | 8,69 | 20 ms |
| 57 | CLM-v0.1-8B (Stanford e Nvidia) | Qwen3-8B | abertos | 7,40 | 47 ms |
| 61 | Laya | ModernBERT-large | abertos | 6,04 | 6 ms |

Três leituras saem direto da tabela:

1. O único modelo fechado da tabela é o Jev. Ele lidera, mas por meio ponto sobre um fine-tune aberto de um Gemma 4 de 26 bilhões de parâmetros, e o placar trata diferença abaixo de 0,25 como empate. Os dez primeiros são todos modelos abertos de 12 a 32 bilhões de parâmetros com adaptador em cima, exatamente a receita que o Clef descreve.
2. O encoder pequeno zero-shot fica no fundo: Laya com 6, Lavoir com 9. Isso bate com o que o README do Laya admite e com o que eu disse sobre classificador clássico, que precisa de exemplo rotulado pra brilhar.
3. Um LoRA de 4 bilhões como o Hopper entrega 41 pontos a 23 milissegundos, uma faixa que muito problema real não precisa ultrapassar.

E como ler o Laya no fundo da tabela? O Decision Index mede uma coisa só: responder, sem treino extra, 38 tipos de pergunta que o modelo nunca viu, de xadrez a tributação. Isso é o que um serviço hospedado precisa fazer, porque não sabe qual pergunta vem. Um encoder de 400 milhões de parâmetros nunca vai ganhar essa prova, e o Laya nem tenta: a nota de 6 é o checkpoint base, sem ajuste nenhum.

O mesmo modelo ajustado com os seus exemplos, numa tarefa estável, aparece com 0,77 no benchmark do próprio projeto. O ranking responde "quem é o melhor generalista zero-shot", que é a pergunta de quem vende API. A pergunta do programador normal é outra: "nesta decisão repetida, com os exemplos que eu tenho, o que acerta mais pelo custo que eu aceito?". Pra essa, o fundo da tabela pode ser a resposta certa, e nenhum placar público substitui o teste no seu dado.

Então o Laya é inútil perto dos outros? Como generalista zero-shot, sim, e o placar está certo em dizer isso. Como ferramenta de programador, a conta é outra. É o único modelo dessa tabela que roda em CPU de notebook e responde em 6 milissegundos, com 400 milhões de parâmetros que cabem em qualquer servidor que você já tem; Hopper e Kev pedem GPU, e o Jev pede internet, chave de API e um contrato de dados.

Ajustado com os seus exemplos, numa taxonomia que não muda toda semana, o próprio autor do Laya relata o modelo ganhando do Jev em algumas tarefas e perdendo onde há muitas opções, em testes publicados por terceiros com prompts e amostras diferentes, portanto indicativos e não controlados. Ou seja: inútil pra responder qualquer pergunta sobre qualquer texto, e muito útil pra responder a mesma pergunta mil vezes por dia, de graça, sem mandar dado pra fora.

O Clef não está no placar: o 0.2.1 fechou em 27 de setembro, e a Cloudflare lançou o modelo no dia 1º. Os números que mostrei na seção anterior são de uma rodada interna da Cloudflare em cima das mesmas tarefas, por benchmark, sem o índice agregado. Também já tem fornecedor dizendo que passou do Jev no mesmo scorer, mas por enquanto é número autodeclarado em blog, e não entrada no placar. Vale esperar a inclusão oficial antes de comparar.

Rodar você mesmo é trabalho de um dia, e o kit cuida da parte chata:

1. `pip install -e ".[transformers,rebuild]"` e `python -m decision_index suite rebuild`. A suíte não é redistribuída por causa de licença, então o kit baixa as fontes (uns 7 GB, com o HLE exigindo aceitar os termos no Hugging Face) e reconstrói os arquivos com hash verificado contra o do laboratório.
2. `python -m decision_index suite sample --n 100` pra um teste rápido, e depois `pipeline --engine http --option base_url=... --option model=...` contra qualquer servidor que fale o formato `POST /v1/systemone`. Isso cobre o próprio Jev, com a chave da API, e o Laya atrás do Arbiter. A API do Clef é anunciada como compatível, então em tese entra pelo mesmo caminho, mas eu não testei.
3. `score` aplica a mesma matemática do placar, e os mantenedores afirmam que ela reproduz todos os 67 participantes da edição atual. Quem tem GPU na nuvem roda tudo como um job único do Hugging Face numa RTX PRO 6000 com `hf-job`.

Eu não rodei a suíte inteira pra este texto; a tabela acima é o arquivo do placar refeito, e não uma medição minha. Duas ressalvas de quem usa esse tipo de régua: a suíte é pública e congelada, então dá pra treinar contra ela, e o próprio placar diz que a saída da API do Jev já mudou em 20 escolhas da amostra de latência desde a rodada original, sem mudar a nota. Benchmark público serve pra descartar modelo fraco e pra achar candidato. A decisão final continua sendo o seu conjunto rotulado, como eu explico a seguir.

## Como programador deve pensar nisso

A pergunta útil deixou de ser "o Jev é novidade?". Virou: pra uma decisão específica, medida, do seu sistema, qual combinação de qualidade, preço, latência, privacidade, contexto e manutenção bate o que você já tem, seja regra, classificador ou LLM com saída estruturada? Nenhum benchmark de fornecedor responde isso sem os seus próprios exemplos rotulados.

Ferramenta do tipo Jev serve quando o mesmo tipo de julgamento sobre texto acontece muitas vezes, as ações possíveis cabem numa lista, o código em volta consegue aplicar regra exata, e uma resposta errada pode ser detectada ou mandada pra revisão. É esse o formato:

- triagem de ticket;
- ranking de uma lista curta já recuperada;
- roteamento de pedido pra modelo maior ou menor;
- sinalização de trace de agente pra revisão humana;
- escolha entre spans que o código ou o OCR já encontraram.

Fora dele, a ferramenta está no lugar errado:

- quando a entrada é imagem ou áudio;
- quando a saída precisa de prosa ou citação;
- quando um parser exato já resolve;
- quando um erro de classificação concede acesso ou executa ação destrutiva.

Olhei a minha própria carteira de projetos com essa régua, e o resultado é um balde de água fria útil: a maioria precisa de modelo especialista de visão ou áudio, de regra determinística ou de texto gerado, e tem pouca decisão repetida, cara e ambígua o suficiente pra justificar mais um serviço de modelo. Uns poucos candidatos sobraram, os mais claros sendo roteamento de modelo no [FrankClaw](/2026/03/16/reescrevi-o-openclaw-em-rust-funcionou-frankclaw/) e ranking de lista curta no [ai-memory](/2026/09/02/ai-memory-2-0-melhor-sistema-memoria-agentes-e-times/). Nenhum é gargalo demonstrado hoje. Suspeito que a sua carteira seja parecida.

Se um gargalo aparecer, o piloto é curto:

1. Escolha uma decisão só e defina as respostas permitidas, incluindo "não sei" quando isso for um resultado real.
2. Separe exemplos reais, com caso fácil, ambíguo e adversarial, e rotule de forma independente. Se o seu produto fala português, inclua português.
3. Compare o que você já tem, uma regra ou classificador simples, o Jev com versão fixa, e um LLM barato com saída estruturada, todos com a mesma entrada e a mesma política de decisão.
4. Meça matriz de confusão, calibração por faixa de confiança, custo por caso tratado corretamente, latência de ponta a ponta e taxa de revisão. Roteador barato que manda trabalho difícil pra modelo fraco custa mais no total.
5. Implante como feature reversível, com log, rota conservadora de revisão e fallback. Julgamento de segurança ou autorização é consultivo, salvo se uma política exata aplicar a ação de forma independente.

O que o Jev fez de bom foi lembrar a indústria de que classificação existe. Isso vale o hype que ele recebeu, e talvez um pouco mais.

Nem ele nem os primos abertos dele são bala de prata. São mais uma ferramenta, pra um tipo específico de tarefa, que o seu código precisa cercar com regra, calibração e revisão. Quem já pensava em classificador antes de setembro não ganhou nada novo; ganhou uma API conveniente. Quem nunca tinha pensado ganhou a parte mais valiosa, que é a pergunta: por que você estava pedindo pra um LLM de bilhões de parâmetros escrever um parágrafo pra te dizer em qual balde o texto cai?
