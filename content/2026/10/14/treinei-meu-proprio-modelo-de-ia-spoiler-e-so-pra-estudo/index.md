---
title: "Treinei meu próprio modelo de IA (Spoiler: é só pra estudo)"
slug: "treinei-meu-proprio-modelo-de-ia-spoiler-e-so-pra-estudo"
date: '2026-10-14T15:00:00-03:00'
draft: false
translationKey: treinei-meu-proprio-modelo-de-ia-spoiler-e-so-pra-estudo
description: "Faltava um exercício: treinar um LLM do zero. Parti do microgpt do Karpathy, 200 linhas de Python puro, e expandi pra um laboratório com tokenizer, pré-treino, SFT, servidor compatível com OpenAI e integração com o OpenCode. Menos de duas semanas, uma RTX 5090, 10 bilhões de tokens, 137 horas de treino, no máximo uns R$ 80 de luz. O modelo final tem 337 milhões de parâmetros, acerta 58 de 100 funções Python simples e zera em tudo que exige agir num repositório. Explico cada etapa, os tropeços, as dimensões contra GPT-2 e modelos de fronteira, e por que acho que o futuro são modelos menores e especializados."
tags:
- inteligencia-artificial
- llms
- machine-learning
- modelos-locais
---

Faltava um exercício na minha lista deste ano: tentar construir o meu próprio LLM. Não um modelo de fronteira. Construir um GPT-5 ou um Claude exige anos de estudo e experimentação, times inteiros e centenas de milhões de dólares em computação. A estimativa do [AI Index de Stanford](https://hai.stanford.edu/ai-index/2024-ai-index-report) pro GPT-4 foi de US$ 78 milhões só de compute, e pro Gemini Ultra, US$ 191 milhões.

Só que ninguém precisa de um modelo classe GPT pra tudo. Modelo de fronteira é generalista por definição: tenta saber tudo sobre qualquer coisa, de direito tributário a letra de música, e o retorno disso é decrescente.

E a maioria deles hoje é mistura de especialistas, *mixture of experts*: grosso modo, vários modelos menores agrupados num bloco gigante de bits, com um roteador que acorda só alguns pra cada token. O [gpt-oss-120b](https://arxiv.org/abs/2508.10925) da OpenAI tem 117 bilhões de parâmetros no total e usa 5,1 bilhões por token. O [DeepSeek-V3](https://arxiv.org/abs/2412.19437) tem 671 bilhões e ativa 37. O modelo grande já é, por dentro, uma coleção de modelos pequenos.

Eu podia ter pego um modelo aberto, gpt-oss, Qwen, Phi, e adaptado. As técnicas existem e são bem documentadas:

- **Fine-tuning completo**: continuar treinando todos os pesos de um modelo pronto nos seus dados. É a transferência de aprendizado clássica, formalizada pro texto pelo [ULMFiT](https://arxiv.org/abs/1801.06146) em 2018.
- **LoRA e QLoRA**: congelar os pesos originais e treinar só matrizes pequenas de baixo posto ao lado deles. O [LoRA](https://arxiv.org/abs/2106.09685) reduz em até dez mil vezes os parâmetros treináveis; o [QLoRA](https://arxiv.org/abs/2305.14314) quantiza o modelo base em 4 bits e ajusta um modelo de 65 bilhões numa única GPU de 48 GB.
- **Destilação**: treinar um modelo menor pra imitar as saídas de um maior. A ideia é de [Hinton, 2015](https://arxiv.org/abs/1503.02531), e o exemplo recente mais famoso é o [DeepSeek-R1](https://arxiv.org/abs/2501.12948) destilado em versões de 1,5 a 70 bilhões em cima de Qwen e Llama.
- **Pré-treino continuado**: mais uma fase de treino em texto do seu domínio antes de qualquer ajuste de instrução, o ["Don't Stop Pretraining"](https://arxiv.org/abs/2004.10964) de 2020.
- **SFT, RLHF e DPO**: ensinar o formato de assistente com demonstrações, depois alinhar com preferência humana via aprendizado por reforço ([InstructGPT](https://arxiv.org/abs/2203.02155)) ou com uma perda de classificação direta ([DPO](https://arxiv.org/abs/2305.18290)).

Com qualquer uma dessas eu teria um modelo útil em horas. Só que o objetivo era outro. Eu queria organizar, com as mãos, as técnicas básicas pra construir um modelo menor que o GPT-2, do zero, em poucos dias, e ver até onde dava pra chegar. Se desse, treinar um modelo minúsculo partindo de pesos aleatórios e adicionar funcionalidade suficiente pra ele quase funcionar dentro de um harness agêntico como o OpenCode.

Antes de continuar, quem eu sou nessa história: eu sou engenheiro de software curioso e amador no assunto. Pesquisador de LLM eu sou zero. Eu sabia que não ia ter um LLM funcional em tão pouco tempo, e isso faz parte do exercício.

Mas não é inalcançável. Se você é estudante de computação, estuda sério e dá anos pra isso, você consegue tentar por conta própria. E se você não é cientista, entenda isto: ninguém precisa ser Einstein pra fazer isso. Os fundamentos estão todos disponíveis, publicados, pra você estudar e tentar. O que é obrigatório é suor.

Spoiler: a gente chegou longe no "quase" e parou lá. O [repositório é público](https://github.com/akitaonrails/microgpt), com cada etapa e cada fracasso documentado. Este texto é o resumo.

> **TL;DR:** parti do microgpt do Karpathy, 200 linhas de Python puro que treinam um GPT em um minuto num MacBook, e expandi pra um laboratório em PyTorch com tokenizer próprio, pré-treino, ajuste supervisionado, servidor compatível com a API da OpenAI e integração com o OpenCode. Em menos de duas semanas, numa RTX 5090, treinei um modelo de 337 milhões de parâmetros em 10 bilhões de tokens: 137 horas de treino, no máximo uns R$ 80 de luz. Ele acerta 58 de 100 funções Python simples de um conjunto reservado, e zera em tudo que exige ler, editar e testar um repositório. O [SmolLM2 de 360 milhões](https://huggingface.co/HuggingFaceTB/SmolLM2-360M), do mesmo tamanho, viu 4 trilhões de tokens, 400 vezes mais. Pule pro [exercício do Karpathy](#o-exercício-do-karpathy), pras [etapas](#as-etapas-de-construir-um-llm), pras [dimensões](#as-dimensões-do-problema), pros [tropeços](#os-tropeços), pro [resultado](#o-que-saiu-do-outro-lado) ou pra [conclusão](#o-futuro-é-menor-e-mais-especializado).

## O exercício do Karpathy

Em fevereiro deste ano o Andrej Karpathy publicou o [microgpt](https://karpathy.github.io/2026/02/12/microgpt/): um único arquivo de 200 linhas de Python, sem dependência nenhuma, que treina e roda um GPT. Ele chama de "o conteúdo algorítmico completo do que é necessário. Todo o resto é só eficiência". É a culminação de uma linhagem dele: o micrograd (autograd escalar), o makemore (gerar nomes) e o nanoGPT (GPT-2 em PyTorch compacto), à qual se soma o [nanochat](https://github.com/karpathy/nanochat), "o melhor ChatGPT que 100 dólares compram", que no lançamento treinava um modelo de capacidade GPT-2 em quase quatro horas num nó de oito H100, e hoje faz isso em umas duas.

O microgpt é propositalmente mínimo: o dataset são 32 mil nomes próprios, um por linha, e o tokenizer é um caractere por token.

A rede tem uma camada, 16 dimensões de embedding, 4 cabeças de atenção, janela de 16 tokens porque o nome mais longo tem 15 letras. Treina por mil passos, um nome por passo, com Adam escrito à mão, e no fim gera nomes inventados, tudo em um minuto num MacBook.

O que ele ensina, por estar tudo exposto num arquivo só:

- o autograd, a classe `Value` que guarda um número, o gradiente e a regra da cadeia pra propagar de volta;
- o que é um token e um embedding;
- o bloco de atenção, com consulta, chave e valor, e a máscara causal que impede o modelo de espiar o futuro;
- a perda de entropia cruzada contra o próximo token;
- o otimizador;
- a amostragem com temperatura.

É um GPT-2 com diferenças pequenas que o próprio arquivo anota: RMSNorm no lugar de LayerNorm, sem bias, ReLU em vez de GeLU. Depois de ler aquilo, o que sobra entre você e um modelo de verdade é, nas palavras dele, eficiência. Eu fui ver quanto de eficiência.

## O que a gente expandiu

O [microgpt lab](https://github.com/akitaonrails/microgpt) é uma reimplementação independente em PyTorch, inspirada no gist, dividida por conceito: umas 3.300 linhas de Python em 31 módulos, mais scripts e 85 testes de CPU. Uma única implementação de modelo serve pra pré-treino, ajuste de assistente e servidor. Todo peso começa aleatório; o projeto não baixa peso pré-treinado nenhum, de propósito, porque a regra do exercício era do zero.

Em cima do bloco do Karpathy entraram os componentes que um modelo de 2026 usa: RoPE pra posição, RMSNorm, SwiGLU na camada densa, embeddings amarrados à saída, Flash Attention via PyTorch, cache de chaves e valores com reuso de prefixo. E em volta do modelo, o que falta pra ele conversar com um agente: um protocolo de conversa com papéis, um servidor HTTP compatível com a API de chat da OpenAI, chamadas de ferramenta validadas por esquema e opcionalmente por gramática, separação de conteúdo de raciocínio, e a configuração do OpenCode apontando pra ele.

O projeto passou por quatro escalas:

| Modelo | Parâmetros | Tokenizer | Pra quê |
| --- | ---: | --- | --- |
| Lição em bytes | 0,9 milhão | byte a byte | roda em CPU, ensina o loop inteiro |
| Estudante | 91 milhões | o200k (200 mil entradas) | primeiro agente, aritmética |
| Candidato de capacidade | 239 milhões | o200k | mais camadas, mesmo vocabulário |
| Pivô de fundação | 337 milhões | BPE próprio, 32 mil entradas | o modelo final |

A tabela esconde a primeira lição grande, que eu conto nos tropeços: no modelo de 239 milhões, 154 milhões de parâmetros eram só a tabela de vocabulário. Sobravam 85 milhões pro transformer de verdade.

## As etapas de construir um LLM

Independente do tamanho, o caminho tem as mesmas estações. O que muda é o zero à direita em cada uma.

### 1. Dados

Modelo é o que ele come. Baixamos, com revisão fixada e hash, seleções de corpora públicos: [CodeParrot](https://huggingface.co/datasets/codeparrot/codeparrot-clean) (Python deduplicado e filtrado), [OpenCoder](https://huggingface.co/datasets/OpenCoder-LLM/opc-sft-stage1) (instrução e código), [Cosmopedia](https://huggingface.co/datasets/HuggingFaceTB/smollm-corpus) (texto educativo sintético), [SmolTalk](https://huggingface.co/datasets/HuggingFaceTB/smoltalk) (conversa) e uma fatia multilíngue. Os 14 manifestos de download somam uns 20 GB brutos, tudo guardado no NAS.

Daí vem a curadoria: deduplicação exata, divisão de treino e validação por repositório ou grupo de conversa (nunca por linha, senão o mesmo projeto vaza pros dois lados), e a mistura. O corpus final de fundação tem 3,5 bilhões de tokens armazenados, 60% código Python, 16% instrução, 12% texto educativo, 8% conversa, 4% multilíngue. Cada proporção é uma decisão de projeto, e nenhuma delas tem resposta certa publicada.

### 2. Tokenizer

O tokenizer é o dicionário entre texto e inteiros. A lição em bytes usa 256 tokens mais um de fim de documento. O estudante usou o o200k, o vocabulário público da OpenAI com 200 mil entradas, que é o que a maioria dos tutoriais faz. O pivô treinou um BPE próprio de 32.768 entradas, em cima de 92 MB de texto só de treino, com cobertura de UTF-8 completa.

A escolha parece detalhe e decide onde os parâmetros vão parar. Cada entrada do vocabulário custa uma linha na tabela de embedding com a largura do modelo. Com 200 mil entradas e largura 768, são 154 milhões de parâmetros gastos em tabela. Com 32 mil entradas e largura 1.024, são 33 milhões, e o resto vai pras camadas que pensam.

### 3. Pré-treino, ou fundação

Aqui é o loop do Karpathy em escala. O modelo recebe janelas de 2.048 tokens tiradas do fluxo de treino e aprende a prever o próximo token. Cada atualização processa 32.768 tokens: duas sequências, acumuladas oito vezes. AdamW, taxa de aprendizado com aquecimento e decaimento em cosseno, recorte de gradiente, BF16 na GPU e FP32 nos pesos.

O pivô rodou uns 305 mil atualizações, 10 bilhões de tokens de exposição. Como o corpus tem 3,5 bilhões, cada documento foi visto, na expectativa da mistura, quase três vezes: o código umas duas, e instrução, texto educativo e conversa umas nove ou dez. A cada 500 atualizações, uma validação e um checkpoint. Nos marcos de 2, 5 e 10 bilhões, um checkpoint congelado com hash, pra medir a curva.

### 4. Ajuste supervisionado

Pré-treino produz um modelo que completa texto. Pra ele responder a um pedido, vem o SFT, *supervised fine-tuning*: exemplos de pergunta e resposta no formato exato que o servidor usa, com a perda calculada só sobre os tokens do assistente. O que o usuário e a ferramenta disseram entra como contexto e é mascarado da perda.

Os exemplos vieram do [OpenCodeInstruct](https://huggingface.co/datasets/nvidia/OpenCodeInstruct) da NVIDIA, e cada resposta foi executada num Docker restrito antes de entrar: quase 99 mil candidatos, 97 mil sobreviveram ao teste com três sementes de hash diferentes. Sobraram 92 mil episódios de treino. O checkpoint escolhido viu 64 mil sorteios desses episódios, uns 10 milhões de tokens de resposta.

### 5. Protocolo, ferramentas e servidor

Um agente como o OpenCode fala com o modelo por HTTP: manda o histórico com papéis, as definições de ferramenta, recebe de volta texto ou uma chamada de ferramenta em JSON, executa, devolve o resultado, e repete. O laboratório implementa esse ciclo inteiro: o mesmo arquivo de protocolo serializa os exemplos de treino e os prompts de serviço, pra formato de treino e formato de uso nunca divergirem.

O servidor implementa `/v1/models` e `/v1/chat/completions`, valida a chamada de ferramenta contra o esquema, pode restringir a geração com gramática pra JSON sair bem formado, separa o conteúdo de raciocínio da resposta, conta tokens em cache e recusa estouro de contexto em vez de truncar em silêncio. Isso tudo é encanamento, zero inteligência, e sem ele o modelo nem senta à mesa.

### 6. Avaliação

A etapa que mais mudou o projeto. Um conjunto congelado de 100 tarefas Python de desenvolvimento, 20 famílias com cinco variantes de nome e enunciado, mais 100 tarefas reservadas que só o checkpoint final viu. Cada resposta roda num Docker sem rede, sem root, com limite de CPU e memória, contra asserções fixas. Além disso: quatro tarefas reais de conserto de repositório via OpenCode, 12 problemas de rastrear a saída exata de um programa, sondas de recuperação de informação em prompts de 8, 16 e 32 mil tokens, e quatro conversas curtas.

> Nada de HumanEval, MBPP ou SWE-bench. São diagnósticos locais pequenos, com famílias correlacionadas, uma semente, geração gulosa. Servem pra decidir entre checkpoints, e o próprio relatório de fechamento manda não ler "58 de 100" como "58% de sucesso em programação".

## As dimensões do problema

O que tudo isso custou, e como isso se compara com o mundo real:

| Dimensão | Nosso modelo final | Referências |
| --- | ---: | --- |
| Parâmetros | 337 milhões | GPT-2 pequeno: 124 milhões; GPT-2 completo (2019): 1,5 bilhão |
| Tokens vistos no pré-treino | 10 bilhões | SmolLM2-360M: 4 trilhões; Llama 3.1: 15 trilhões; Qwen3: 36 trilhões |
| Dados brutos baixados | 20 GB | GPT-2: 40 GB de WebText, 8 milhões de páginas |
| Corpus de fundação | 3,5 bilhões de tokens, 2,35 milhões de documentos | |
| Hardware | 1 RTX 5090, 32 GB | Llama 3.1 405B: 30,84 milhões de horas de H100 |
| Tempo de GPU na fundação | 137 horas de processo, 6,4 dias de calendário | DeepSeek-V3: 2,79 milhões de horas de H800, ~US$ 5,6 milhões |
| Tempo de SFT | 3,4 horas somando os nove estágios | |
| Vazão | 23 a 44 mil tokens/s, dependendo de I/O | |
| VRAM de pico | 13,9 GB na fundação; 6,8 GB no SFT | |
| Checkpoints | 17 checkpoints distintos (20 caminhos), 69 GB | |
| Custo em dinheiro | zero em nuvem; uns R$ 80 de luz no pior caso | nanochat: US$ 100 em 8 H100 por 4 horas no lançamento; hoje uns US$ 48 em 2 horas |

A conta da luz: a RTX 5090 tem [575 W de potência nominal](https://www.nvidia.com/en-us/geforce/graphics-cards/50-series/rtx-5090/). Em 137 horas a plena carga são uns 79 kWh, e a tarifa residencial da Enel em São Paulo em 2026, somando TUSD, TE e impostos, fica em torno de R$ 1 por kWh. Como o treino rodou boa parte do tempo a 75% de ciclo pra não travar o desktop, o real foi menos. É o custo marginal de quem já tem a placa.

Alugar uma 5090 na [Runpod](https://www.runpod.io/pricing) sai a uns US$ 1,20 por hora, então as mesmas 137 horas custariam uns US$ 165; uma H100 sai entre US$ 2,90 e 4 por hora, dependendo da variante.

E a comparação que dá a escala. O SmolLM2 de 360 milhões de parâmetros, praticamente o tamanho do nosso, foi treinado em 4 trilhões de tokens. Na nossa vazão, 4 trilhões levariam entre quatro e seis anos de GPU ininterrupta. Mesmo tamanho de modelo, 400 vezes a quantidade de estudo.

É por isso que "parâmetros" é uma unidade enganosa: diz o tamanho do cérebro, e nada sobre quantos anos de escola ele teve.

A regra de bolso derivada de [Chinchilla](https://arxiv.org/abs/2203.15556) (70 bilhões de parâmetros, 1,4 trilhão de tokens), uns 20 tokens por parâmetro pra ser computacionalmente ótimo, daria 6,7 bilhões de tokens pro nosso modelo. Passamos disso. Só que o ótimo de Chinchilla é o ponto de melhor uso de compute, e modelos pequenos modernos passam muito dele de propósito, porque o custo de inferência depois compensa treinar mais.

## Os tropeços

A lista completa está no [relatório de fechamento](https://github.com/akitaonrails/microgpt/blob/main/docs/report/experiment-closeout.md). Os que mais ensinaram:

**Medir perto demais do treino.** O primeiro agente, o de 91 milhões, completou quatro sessões de 16 rodadas no OpenCode e uma de 32 rodadas com 130 chamadas de ferramenta reais, recuperando de erro de verificação e trocando de sessão no meio, com o estado guardado pelo harness. Parecia pronto.

Aí eu pedi, na mão e em inglês, uma função hello world que recebe um nome como parâmetro e imprime na mensagem. O modelo repetiu duas vezes a edição aritmética anterior, apontou pra um arquivo que não existia, e na terceira tentativa cuspiu JSON inválido. Tudo que ele sabia era a família de tarefa do treino.

**O vocabulário comeu o modelo.** O candidato de 239 milhões tinha mais camadas e perda menor que o de 91 e resolvia 24 de 100 problemas. Ao olhar a distribuição dos parâmetros, 154 milhões eram tabela de vocabulário. O pivô pra 32 mil entradas devolveu 300 milhões de parâmetros pro transformer. O pivô mudou vocabulário, distribuição de capacidade, inicialização e exposição de uma vez, então o relatório não isola qual delas moveu o resultado.

**Perda não é competência.** No SFT final, continuar de 4 mil pra 8 mil atualizações baixou a perda de validação e derrubou o acerto executado de 68 pra 62. Loss mais baixa, código pior. A seleção de checkpoint passou a ser por tarefa executada, congelada antes; o número da perda ficou de fora.

**Dados e avaliadores mentem.** Respostas "corretas" do dataset público falhavam ao serem executadas de novo. Testes que dependiam da ordem de hash do Python, builtins sombreados, `SystemExit(0)` contando como sucesso, edições vazias copiando o arquivo. Cada um precisou de um controle: três sementes de hash, sentinela de conclusão, fixture vazia que precisa falhar. E num dos treinos mistos, o modelo aprendeu a dizer que os testes passaram quando não tinham passado.

**Formato de treino e formato de uso precisam bater.** Anúncio de troca de sessão, ID de chamada de ferramenta, âncora de edição, o jeito como o OpenCode cita a entrada do usuário: cada diferença entre o que o modelo viu no treino e o que recebeu no servidor derrubava o agente antigo. O mesmo arquivo de protocolo pros dois lados foi a solução, e ainda assim mudar formato às vezes melhorava o nome da função sem melhorar o código.

**Tokenização cruza fronteiras de correção.** A string literal `<|endoftext|>` dentro de código fonte precisa continuar sendo texto comum em vez de virar o marcador de fim de documento. Reconstruir documentos UTF-8 sem partir um caractere no meio. O suporte do XGrammar a vocabulário em nível de byte. A primeira avaliação de código do marco de 2 bilhões falhou na construção da gramática, e foi corrigida e rerodada em vez de contar como falha do modelo.

**O NAS quase me custou dias.** Na retomada da fase de 10 bilhões, o treinador carregou o passo 81.500 em vez do 152.588 congelado: o `last.pt` mutável tinha timestamp anterior à pausa, logo depois de uma manutenção no NAS, e a causa nunca foi provada. Descartamos 1,24 hora de treino, verificamos o hash do marco de 5 bilhões, e toda retomada seguinte passou a exigir hash, passo exato, estado do otimizador e do RNG, dataset e uma sonda de escrita com fsync. Nunca retome um treino só porque o arquivo se chama `last.pt`.

**GPU de desktop é GPU compartilhada.** VRAM livre não impediu o navegador de travar. A solução foi um ciclo de trabalho cooperativo: o treinador sincroniza a GPU e dorme entre lotes, 75% do tempo durante o dia e 100% das 3 às 9 da manhã. E a leitura do corpus pelo NAS, via mmap, deixava a GPU ociosa esperando disco. Depois de uma manutenção a vazão caiu pra 5 mil tokens por segundo antes de voltar aos 23 mil.

**Parei numa fronteira do pipeline.** O controlador do pivô implementava fundação, SFT de código e holdout. Terminou limpo, e "terminou limpo" cobria até a função Python isolada, enquanto o objetivo era o agente. O checkpoint final foi testado no OpenCode só no fechamento, e falhou. Devia ter sido testado antes de qualquer frase com "pronto".

## O que saiu do outro lado

A ficha do modelo final:

| Propriedade | Valor |
| --- | --- |
| Parâmetros | 337.167.360, sendo 303,6 milhões no transformer e 33,6 milhões na tabela de vocabulário |
| Arquitetura | 24 camadas, largura 1.024, 16 cabeças, SwiGLU com 2.752 de largura oculta, RMSNorm, RoPE |
| Vocabulário | BPE próprio de 32.768 entradas, cobertura UTF-8 |
| Contexto | 32.768 tokens alocados; treinado em janelas de 2.048 |
| Fundação | 10 bilhões de tokens, 305.176 atualizações, perda de validação final 1,085 |
| SFT escolhido | 4.000 atualizações, 10,3 milhões de tokens de resposta |
| Checkpoint | 4 GB com estado do otimizador; 1,35 GB só de pesos em FP32 |

A curva de aprendizado, medida nos três marcos, com o mesmo SFT curto aplicado em cima de cada um:

| Tokens de fundação | Completar código cru /100 | Após SFT de 500 /100 | Após SFT de 1.000 /100 |
| ---: | ---: | ---: | ---: |
| 2 bilhões | 0 | 24 | 39 |
| 5 bilhões | 0 | 49 | 52 |
| 10 bilhões | 8 | 56 | 65 |

O SFT mais longo em cima dos 10 bilhões chegou a **68 de 100** no conjunto de desenvolvimento e **58 de 100** no reservado. Todas as 100 saídas do reservado são Python válido, e 97 têm o nome de função e os parâmetros pedidos. Nove famílias passaram nas cinco variantes: mediana, fatorial, máximo divisor comum, conversão pra binário, inverter dicionário, contar linhas, ano bissexto, segundos pra horas, chaves de JSON. Total acumulado ficou em quatro de cinco.

O que ele faz, portanto: escreve uma função Python pequena, com docstring, sintaxe correta e o nome certo, pra um pedido claro de uma linha. Dentro de um editor, como autocompletar de função isolada, serve pra estudo.

O que ele erra, com exemplos salvos: deduplicar usando `set` quando o enunciado exigia suportar listas não hasheáveis; agrupar por tamanho contando palavras em vez de agrupar; fazer aritmética em cada elemento numa função de preencher; devolver `(texto, '')` numa função de dividir uma vez, ignorando o separador; tirar o último caractere em vez do diretório numa função de basename. Dos 42 erros do reservado, 39 têm sintaxe válida e nome certo e falham na semântica. A parte difícil nunca foi parecer código.

E o que ele zera:

- **0 de 4** consertos reais de repositório no OpenCode, com zero chamadas de ferramenta. Pedido pra ler, editar e testar um arquivo, ele devolveu texto com código. Numa das tarefas, renomeou a função pra `fix_mean`.
- **0 de 12** em rastrear a saída exata de programas curtos, com e sem modo de raciocínio. Muitas respostas foram código que supostamente calcularia o inteiro pedido.
- **0 de 9** em achar um número de seis dígitos escondido em prompts de 8, 16 e 32 mil tokens. A alocação de 32 mil tokens funciona; a memória útil, nenhuma.
- Conversa: perguntado em português sobre a cor do céu, respondeu repetitivo e errado; pedido em inglês de café da manhã virou uma docstring em Python repetindo "oats" até o limite de tokens. Numa troca curta lembrou que o gato se chamava Pipoca, e mesmo assim respondeu com frase inteira apesar do pedido de "só o nome".

O SFT final só tinha respostas de código, sem conversa, sem trajetória de ferramenta, sem recuperação de erro. A tendência de responder qualquer coisa com Python é coerente com isso, e o relatório toma o cuidado de dizer que a causa não foi isolada.

## O que faltaria pra um agente simples no OpenCode

O relatório fecha com estimativas de engenharia, sem promessa de taxa de acerto. Pra chegar num agente que resolve tarefa simples de programação dentro do OpenCode, nesta ordem:

1. **Ensinar uso de ferramenta no modelo forte.** Entre 10 e 30 mil trajetórias curtas e verificadas de repositório (ler, editar, checar), misturadas com 30 a 50% de código pra ele não desaprender. Um a três dias de engenharia e de duas a seis horas iniciais de treino.
2. **Corrigir os próprios erros.** Coletar centenas a alguns milhares de falhas do modelo em tarefas de treino, reconstruir o estado do arquivo, verificar as correções e treinar mascarando a ação errada. Mais um a três dias de coleta e de duas a oito horas de treino.
3. **Devolver a conversa.** Uma mistura equilibrada de conversa, ferramenta e código contra o checkpoint congelado, pra ele parar de responder tudo com Python e conseguir trocar de tarefa. Uma a quatro horas de treino.
4. **Contexto longo de verdade.** Só depois das tarefas curtas passarem: 4 mil, 8 mil, e só então 16 e 32 mil, com trajetórias reais de compactação e troca de sessão. Um a dois dias de engenharia e de 6 a 24 horas de treino, medindo memória a cada janela.
5. **Mais fundação, com dados melhores.** Cada 10 bilhões de tokens a mais custam entre 93 e 139 horas nesta GPU, antes de preparação e avaliação. E repetir a mesma mistura de 3,5 bilhões não vale a pena: precisa de mais código educativo único.

Nenhum desses passos foi executado. Não há evidência de que um número fixo de horas a mais produza um agente confiável, e o relatório é explícito nisso. O que o exercício estabeleceu foi a distância: entre gerar uma função plausível e agir de forma confiável num repositório existe um abismo que parâmetro e contexto alocado sozinhos não cruzam.

> O mais forte que saiu daqui foi a curva medida de 0 pra 65 em dez bilhões de tokens, e três contraexemplos concretos: sintaxe não é semântica, suporte a protocolo não é habilidade com ferramenta, e capacidade de contexto não é memória.

## O futuro é menor e mais especializado

Depois de onze dias olhando pra dentro de um modelo, a minha leitura do mercado ficou mais firme. Modelo de fronteira generalista vai continuar existindo e vai continuar sendo caro, e o retorno de cada bilhão a mais de parâmetros é cada vez menor. Eu já escrevi que [os modelos crus convergiram](/2026/10/12/llms-agentes-competente-o-suficiente/) e que o ganho recente veio do harness. O exercício me deu a outra metade do argumento.

A mistura de especialistas é a indústria admitindo isso por dentro. Se o gpt-oss de 117 bilhões acorda 5 bilhões por token, o que você está usando numa pergunta de contabilidade é um modelo de 5 bilhões escolhido por um roteador. A pergunta que fica é por que carregar os outros 112 bilhões, de arte, cinema, meme e física de partículas, num servidor de escritório contábil.

Imagine um modelo local, feito pra contadores. Ele conhece o plano de contas, a legislação tributária do país, os formatos de arquivo da Receita, o jargão. Ele dispensa parâmetros sobre tudo que um contador não precisa, e pode rodar no PC do escritório, com os dados do cliente dentro da sala.

Os exemplos já existem em outras áreas: o [MedGemma](https://research.google/blog/medgemma-our-most-capable-open-models-for-health-ai-development/) de 4 bilhões pra saúde, o [SaulLM](https://arxiv.org/abs/2403.03883) de 7 bilhões pra direito, o [Fin-R1](https://arxiv.org/abs/2503.16252) de 7 bilhões pra raciocínio financeiro. Em 2023 o [BloombergGPT](https://arxiv.org/abs/2303.17564) precisou de 50 bilhões de parâmetros e 1,3 milhão de horas de A100 pra fazer finanças; hoje um ajuste em cima de um modelo aberto de 7 bilhões faz o mesmo papel por uma fração.

O que mudou pra isso virar viável foi o agente. Um modelo especializado de 2023 precisava saber tudo de cor, porque a única coisa que ele fazia era completar texto. Um modelo de 2026 precisa de uma base: raciocínio suficiente, capacidade de sustentar uma tarefa longa, chamada de ferramenta confiável, cache de prompt. O resto, a legislação que mudou ontem, o documento do cliente, a tabela que ele nunca viu, ele busca com ferramenta e internet na hora, e preenche as lacunas do treino em tempo de uso.

A [NVIDIA publicou em 2025](https://arxiv.org/abs/2506.02153) exatamente essa posição: modelos pequenos são suficientes, mais adequados e mais baratos pra maioria das chamadas de um agente, com o modelo grande chamado só quando a conversa aberta exige. A Apple já [roda um modelo de 3 bilhões no aparelho](https://machinelearning.apple.com/research/apple-foundation-models-2025-updates) com protocolo de ferramentas e adaptadores por tarefa.

É o mesmo raciocínio dos [modelos de decisão que eu testei](/2026/10/10/qual-modelo-de-decisao-classificador-de-ia-tipo-jev-e-melhor/) semana passada: um classificador de 4 bilhões treinado pra uma tarefa bate um modelo de chat genérico do mesmo tamanho nela, numa fração do tempo de resposta. Em vez de tentar caber o mundo inteiro num modelo maior, cabe o domínio num modelo menor e deixa o harness buscar o mundo quando precisar.

E o que o meu modelo de 337 milhões me ensinou é o tamanho do "suficiente" nessa frase. Ele sabe a sintaxe e sabe o nome das coisas. O que falta, semântica, ferramenta, memória, é exatamente o que separa um gerador de texto de um agente, e isso ninguém treina em duas semanas numa placa de vídeo. Treina em meses, em cluster, com trilhões de tokens, e depois especializa.

O código está no [repositório](https://github.com/akitaonrails/microgpt), com o relatório de fechamento inteiro, pra quem quiser pegar de onde eu parei. É só pra estudo. E foi o melhor estudo do ano.
