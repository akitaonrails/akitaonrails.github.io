---
title: Rant - LLMs vão evoluir pra sempre? Desmistificando LLMs na programação
date: '2025-05-01T02:30:00-03:00'
slug: rant-llms-vao-evoluir-pra-sempre-desmistificando-llms-na-programacao
tags:
- aider
- gpt
- gemini
- claude
- imagenet
- mcp
- benchmark
- llm
draft: false
---



Vamos recaptular meus últimos artigos:

- [Hello World de LLM](https://www.akitaonrails.com/2025/04/25/hello-world-de-llm-criando-seu-proprio-chat-de-i-a-que-roda-local) - neste artigo explico como criar um programinha simples (educativo) de chat carregando um LLM (Qwen2.5) e até como usar prompts pra que ele consiga chamar scripts/agentes e executar algumas tarefas simples como carregar arquivos locais. Eu subi o código no GitHub como [Tiny-Qwen-CLI](https://github.com/akitaonrails/Tiny-Qwen-CLI) e deixei o código "sujo" de propósito pra poder testar como as LLMs conseguem (ou não ajustar esse código). 
- [Seu Próprio Co-Pilot Gratuito](https://www.akitaonrails.com/2025/04/25/seu-proprio-co-pilot-gratuito-universal-que-funciona-local-aider-ollama-qwen) - aqui eu explico mais sobre a ferramenta Aider, que é como se fosse um Co-Pilot ou Cursor, mas gratuito e open-source. Ele não exige plugins nem IDEs. Roda no terminal e é fácil de usar. Também mostro como integrar com Ollama e subir seus próprios LLMs locais.
- [Dissecando um Modelfile de Ollama](https://www.akitaonrails.com/2025/04/29/dissecando-um-modelfile-de-ollama-ajustando-qwen3-pra-codigo) - neste eu desço mais na teoria dos LLMs e explico o que é Key Sampling e os como diversos parâmetros afetam a geração de texto das LLMs, como Temperature ou Top_P. Aqui é pra desmistificar ainda mais que não existe nenhuma "mágica" em como uma LLM consegue gerar textos.

Ao longo dos últimos dias eu vim testando e postando no X minhas impressões sobre os mais diversos modelos comerciais e open source como Claude Sonnet, Gemini 2.5, OpenAI O4, Deepseek-R1, o novo Qwen3 e mais. Tem mais posts no blog além dos que mencionei acima, mas estes são os principais.

Objetivo deste post é desmistificar mais as LLMs e falar mais sobre minha experiência testando a maioria dos LLMs mais populares.

### Desmistificando LLMs - 1. Benchmarks e Rankings

Quem acompanha minhas palestras e videos faz anos está careca de me ouvir falar sobre o livro ["Como Mentir com Estatísticas"](https://www.amazon.com.br/Como-Mentir-Estat%C3%ADstica-Darrell-Huff/dp/858057952X). E o que eu mais vejo nas centenas de posts sobre LLMs é sobre os rankings baseados em benchmarks. Este é um exemplo que viralizou ontem, no lançamento do novo modelo da Alibaba, o Qwen3:

![Qwen3 benchmarks](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/1kflvwk5uq9lkt5yh8knngwxwfi9)

O problema: os rankings não estão errados. Eles querem dizer o seguinte:

**"Qwen 3 supera Qwen 2.5 e também outros famosos como OpenAI o1, DeepSeek-R1, Grok 3 Beta, Gemini 2.5, etc .... NOS BENCHMARKS RODADOS - e APENAS nos benchmarks rodados."**

É apenas isso. Mas 99% dos posts publica assim:

**"Qwen 3 É O MELHOR PRA DESENVOLVER CÓDIGO do que Qwen 2.5 e também outros famosos como OpenAI o1, DeepSeek-R1, Grok 3 Beta, Gemini 2.5, etc"***

Os benchmarks não estão errados, quem está errado é quem interpretou que isso significa ser melhor em tudo. Vamos pra outra analogia:

**"O Aluno Fulano conseguiu 99% de acerto em todos os simulados do vestibular"**

A conclusão das pessoas:

**"O Aluno Fulano é 99% melhor que todo mundo em tudo"**

Espero que isso soe obviamente errado. Ser melhor em 1 coisa não torna ninguém melhor em tudo, mas em I.A. é assim que toda notícia de uma nova versão de LLM é publicado em posts pessoais e veículos jornalísticos. É um óbvio **CLICKBAIT**. E você cai.

E se você está acostumado a ouvir dessa forma, faz parecer que a cada nova versão de LLM - que é "melhor em tudo" - que o anterior, falta muito pouco ou já chegou no ponto onde sim, não precisa mais existir programadores humanos, nem matemáticos, nem engenheiros, nem médicos, afinal, a LLM é "BOA EM TUDO".

E nada poderia ser mais longe da verdade que isso. Essas pesquisas estatísticas de ranking tem uma METODOLOGIA de testes e um pacote de benchmark fixo. Os testes são SIMPLES, pense coisas no nível "faça uma função que calcule fatorial", "faça uma função que ordene uma lista de palavras", "dado uma lista de palavras, encontre um em específico em tempo logarítmico", etc. Coisas que você vê nos cursos introdutórios de ciências da computação ou Leet Code.

Esses testes são rodados MÚLTIPLAS VEZES e os "outliers" (testes onde se errou demais, ou testes onde se acertou demais, ou algo que saia da média) são descartados, é feita uma distribuição estatísticas e compilado um "número" geral genérico como "acertou 99%" ou algo assim.

Ele errou muitas vezes, mas esse ponto de dados é um outlier, e foi removido da conta. É estatisticamente irrelevante dentro da metodologia. Mas é um fato: nenhuma LLM acerta 100% das vezes nem nunca vai acertar. Eu demonstrei isso no meu post sobre Modelfiles onde eu explico que existe um fator aleatório controlado (temperatura, top_p, top_k, min_p, key sampling). E existe também normalizações e fatores aleatórios no treinamento (softmax, relu). E ainda tem fatores de otimização posterior que "arredonda" ou "trunca" as probabilidades como quantização (fp8, Q4, etc). Ou seja, existem diversos fatores de "micro erros" e aleatoriedade embutidos no processo inteiro. Nunca vai ser uma resposta "certa", só "possivelmente uma das mais certas" e esse "possivelmente" pode variar MUITO.

### Dissecando Mitos de I.A. - 2. Evolução Exponencial

Quem chegou só agora e está vendo notícias frequentes sobre lançamentos de novas versões de LLMs como o Qwen3 da Alibaba agora, o novo MiMo da Xiaomi, a versão 2.5 do Gemini, a versão 4.1 do ChatGPT, etc tem a impressão que estamos evoluindo a passos largos.

Mas a verdade é que sim, 2022 foi um marco histórico com o ChatGPT original, principalmente GPT 2. Mas de lá pra cá a evolução desacelerou. Cada nova versão não é mais visivelmente "o dobro melhor" que a anterior, a não ser em certos benchmarks, em certas condições específicas - que não condizem com a realidade. Já vou demonstrar.

Um amigo meu me lembrou sobre a evolução das tecnologias de deep learning em reconhecimento de imagens, anos antes:

- 2012 – AlexNet: Primeira grande vitória no ImageNet com 8 camadas, alcançando 84,7% de top-5 accuracy.​

- 2014 – VGG: Redes com 16–19 camadas, melhorias incrementais, mas com aumento significativo de parâmetros.​

- 2015 – ResNet: Introdução de conexões residuais, permitindo redes com mais de 100 camadas e superando desempenho humano em top-5 accuracy.​

- 2016–2017 – Inception, ResNeXt, SENet: Modelos mais complexos com ganhos marginais.​

- Pós-2018: Acurácia top-1 se estabiliza em torno de 85–88%, com ganhos marginais mesmo em modelos como EfficientNet e NasNet.

I.A. é estudada desde literalmente o início da computação moderna no fim dos anos 1930, com ninguém menos que o próprio Alan Turing ou John Von Neumann. Eu contei sobre eles aqui:

<iframe width="560" height="315" src="https://www.youtube.com/embed/G4MvFT8TGII?si=9Qefl2cU6mNefzqB" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

Pense um "início lento": de 1930 até cerca de 2012 quando ImageNet e coisas como AlphaGo, GANs e coisas assim começaram a ganhar velocidade. Saímos da perna do "S" pro meio a partir dos anos 2010 e viemos acelerando até agora. Eu "chuto" que ou já estamos ou estamos caminhando pro topo do "S", onde a curva estabiliza e desacelera. Foi isso que aconteceu com deep learning de imagens:

![ImageNet](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/lgr7uodnbmqfujjw39h69mnybi8t)

Lembram do AlphaGo? Eu acompanhei ao vivo. Como amador-hobista em Go, eu assisti ao vivo os jogos com me mestres sul-coreanos como Lee Sedol, na época que aconteceu, acho que 2016. Vocês devem ter visto o [documentário na Netflix](https://www.netflix.com/br-en/title/80190844) só agora, mas isso vem acontecendo faz anos. E agora, onde está o AlphaGo evoluindo exponencialmente? Todo mundo já esqueceu, porque o quente da moda são LLMs, que é só mais uma categoria no mundo de I.A.

A grande maioria das otimizações já foram ou já estão sendo feitas. Se fosse resumir só alguns dos milestones mais importantes desta parte da geração seria mais ou menos assim:

![timeline llm](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/z14qvijztqvy6prvbpokk02fqrjt)

Todo engenheiro e cientista sabe disso: quando você não tem nada, qualquer coisa é um salto quântico. Quando você só tem 1 real, 2 reais já é "o dobro". Quando tem 10 reais, 20 já é bastante. Mas quando chega em 20 mil, mais 100 já não adiciona tanto valor assim do que quando você só tinha 1 (ali seria 100x).

Cada nova gota de otimização agora CUSTA MUITO. Mesmo em otimização com perda de precisão (quantização) já saímos de fp32, fomos pra fp16, fp8, já chegamos em 1-bit. Não tem mais pra onde descer depois disso. Estamos no ponto onde estamos trocando precisão por performance.

Dobro de parâmetros não resulta mais em dobro de qualidade de resultado. Precisa dobrar pra ter 5%? Talvez? E não adianta continuar aumentando, o resultado começa a piorar em vez de melhorar. Por isso já pulamos pra coisas como LLMs especialistas, MoE (Mixture of Experts).

Deep thinking/Chain-of-Though/Reasoning foi um grande salto, mas só aumentar mais thnking também já não dá mais tanto resultado, na verdade, em muitos casos piora o resultado com "over-thinking". Pensar demais não é linear também.

Aumentar contexto também não ajuda a melhorar as respostas. Pelo contrário, já vemos que a partir de um certo ponto, mais contexto atrapalha o resultado, porque a arquitetura de atenção (o grande diferencial das LLMs), tem limites. Sim, um Deepseek ou Gemini dizem suportar "1 milhão de tokens". Mas eu já expliquei nos artigos anteriores que se trata de **Sliding Window Attention** como SDPA ou Flash onde a atenção é voltada só a uma PARTE desse grande contexto: ele não consegue dar atenção pra tudo o tempo todo.

Todo lugar onde dava pra colocar coisas óbvias, como caching, seja no treinamento, seja na geração, já foram colocadas. Estamos ficando sem opções aqui. E sim, novas descobertas continuam acontecendo, mas como falei, nenhuma ainda conseguiu ultrapassar os limites que sabemos que existem.

### Desmistificando Mitos de I.A. - 3. Acabar com Programadores

O que eu mais detesto do hype atual são as falsas promessas de "AGI", "Vibe Coding", "trocar funcionários por MCPs". Vou afirmar de novo: é tudo propaganda.

Propaganda mentirosa e falsas promessas de óleo de cobra (coisa que sempre existiu e sempre vai existir na história) DESVALORIZA a realidade as inovações que temos hoje.

_"Mas o CEO da Anthropic e o tio Zuck disseram que vão substituir programadores. Microsoft e Google disseram que 30% do código deles já sai de I.A."_

Como falei antes sobre estatística. Sim: muita coisa VAI ser feita com I.A. mesmo. Não precisa de I.A. pra otimizar trabalho em várias área:

- um pedaço de pau e um bloco de argila são suficientes pra substituir a memória das pessoas. Ninguém lembra de detalhes, especialmente numéricos, permanentemente. Faz milênios que evoluímos em ajudar nossa memória com algum tipo de armazenamento externo. Seja bloco de argila, seja papel, seja post-it, seja um arquivo .txt na sua máquina.

- a primeira câmera fotográfica já removeu a necessidade de contratar um pintor de quadros pra se ter uma "selfie".

- o primeiro computador mais primitivo já eliminou a necessidade de um prédio inteiro de matemáticos fazendo e refazendo cálculos no papel. Mesmo assim, foi desse jeito que os primeiros foguetes foram pro espaço. Já assistiu o filme [Hidden Figures](https://www.netflix.com/title/80123775)? Recomendo

- carros já são montados quase que totalmente por robôs, faz anos. robótica não é novidade na indústria. Hoje em dia, um tablet já substituiu caixas de supermercado e de McDonalds. Tudo isso sem precisar de I.A. URAs e botzinhos já substituíram muito de telemarketing e suporte.

Então sim, na prática, I.A. também vai substituir uma classe inteira de programadores: os de baixo valor agregado. Os que não sabem fazer muito mais que copy e paste ou cuja rotina de trabalho seja repetitivo. Se seu trabalho envolve tarefas repetitivas, é óbvio que é questão de tempo até serem automatizados, seja por I.A. seja por meros scripts. Coisa que já fazemos hoje. 

O trabalho de um programador sempre foi substituir o trabalho dos outros. Você que trabalha fazendo sistema de e-commerce: você ajudou a substituir o trabalho de vendedores, vitrinistas, decoradores de loja, caixas. Você que faz sistemas de tickets e suporte, você já substituiu atendentes humanos. Você que faz sistemas de entregas, já substituiu telefonistas. Você que faz sistemas financeiros, já substituiu bancários, quem constrói agências de banco, etc.

Você, programador, sempre trabalhou substituindo o trabalho dos outros. Era questão de tempo até programadores substituírem trabalho de programadores. Chame isso de **justiça poética**. É só evolução mesmo. Acontece. Nada no mundo é feito pra ser estático e nem garantido.

Aqui vai a boa notícia: como sempre acontece. Ainda existem pintores, mesmo existindo fotógrafos. Ainda existem vendedores, mesmo existindo e-commerce. Ainda existe construção, mesmo não precisando tanto de lojas ou até escritórios (com home office). Ainda existe e vai continuar existindo, médicos, advogados, contadores, várias profissões. A diferença é que antes, uma empresa de contabilidade precisava de um prédio cheio de pessoas que sabiam usar ábacos e escrever planilhas em papel. Hoje um único contador que saiba usar Excel substitui um andar inteiro. Antigamente, uma empresa de publicidade era um prédio inteiro, hoje é uma pessoa que usa Canva, CapCut e Photoshop.

Programador é a mesma coisa. Antes era um prédio inteiro com piscina de bolinha roxa. Amanhã vai ser um, BOM, programador com Cursor e Aider. Quem some nessa brincadeira? Quem fazia o trabalho braçal de baixo valor agregado. 

Eu avisei que isso ia acontecer. Durante 5 anos, antes de existir esta geração de LLMs e I.A. Porque é o rumo natural das coisas. Programador de curso online de fim de semana. Esse é o primeiro que vai desaparecer.

Você sabe cálculo? Sabe Álgebra? Sabe Álgebra Linear? Sabe Estatística de Probabilidade? Sabe o que é uma distribuição estatística? Sabe o que são vetores ou tensors? Sabe o que é um espaço de Hilbert? Não? Eu me precaveria se fosse você. Se todos os artigos que eu publiquei neste mês de Abril/2025 foram muito difíceis, vocês já sabem o que precisam estudar.

### Minha experiência com LLMs

Eu venho usando LLMs faz 2 anos. Todo tipo de pesquisa ou código que faço passa por alguma LLM em alguma capacidade. Eu uso pesado mesmo. Meu histórico de ChatGPT é gigante.

E depois de fazer mais um intensivão pra ter certeza. Sim, o4-mini-high, Sonnet 3.7, Gemini 2.5, Qwen3, Deepseek-R1, etc são todos extremamente úteis e nenhum deles, absolutamente nenhum, consegue me satisfazer.

Vibe Coding é uma enorme bobagem. Ninguém sem conhecimentos de programação consegue fazer mais que software super simples (e cheio de bugs) usando só LLMs e prompts ou MCPs. Isso é um fato.

_"Mas a evolução é exponencial, ano que vem vai ser perfeito."_

Não vai. Eu já argumentei esse ponto acima.

_"Mas os benchmarks dizem que eles já conseguem fazer 99% de código perfeito."_

Também já argumentei esse ponto, sua interpretação está equivocada.

Estamos perto ou já no começo do topo da curva "S". E eu não vejo problema nenhum nisso. Eu entendo como LLMs são feitos, entendo como são otimizados, entendo o que conseguem fazer e, mais importante, entendo o que são incapazes de fazer.

Vejam os [pull requests](https://github.com/akitaonrails/Tiny-Qwen-CLI/pulls) de todas as tentativas que tentei fazer de refatoração de código e testes unitários com as principais LLMs do mercado, abertas e fechadas. O que eu vejo:

- precisa de MUITO prompt e muita instrução pra fazer eles começarem a cuspir código que funciona.
- eles parecem um estagiário, o famoso "na minha máquina funciona". Saem cuspindo, um monte de copy e paste de código, e não re-checam se faz sentido ou se precisava. O tanto de código inútil que eles geram é assustador.
- eles repetem os mesmos erros, mesmo avisando pra não cometer. 
- mesmo com "agentes", "MCP", mesmo rodando o código que foi gerado e dando o stacktrace de erros, eles facilmente desfocam, perdem atenção e não consguem corrigir. Mesmo re-tentando diversas vezes pra corrigir o mesmo erro. Mesmo dando dicas. Mesmo escrevendo longamento o que está errado. Rapidamente eles entram em loop. Especialmente se tiver o tal "thinking" ativado. Eles pensam demais e não resolvem.
- cansei de ver tentativa de sair mexendo aleatoriamente no código, em partes que nem pedi pra mexer, e quebrar mais do que consertar.
- nenhum deles foi capaz de gerar testes unitários que funcionam de primeira. Alguns conseguiram fazer alguns simples, depois de dar o erro e pedir pra consertar. Alguns ficam em loop de pensamento, confusos, e saem mudando sem corrigir. No final fracassam.
- Do nada começam a alucinar. O Qwen 3 mesmo, se eu tentar aumentar só um pouco temperature, de 0.1 pra 0.2 do nada começa a sair caracter chinês no meio do código, assim:

![chinese char](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/j0rnlba6loxmo32pyyjxy8diteor)

- Vira e mexe, mais de uma LLM, conseguiu a proeza de gerar teste unitário que dava erro recursivo. Isso enchia tanto o stacktrace que se eu tentava passar pra ele (mais de 12 mil tokens), isso estourava a janela de contexto e dali ele não conseguia dar atenção pra mais nada:

![recursive error](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/eqh6ytb84mvcpzr92dk7kge2exaj)

- como erram demais, eu fico repetidamente e exaustivamente dando chance pra ele consertar. Eu rodo o código que ele gerou, mando o stacktrace de erro, peço pra consertar. Ele mexe outra parte do código. Rodo de novo, dá erro e repito. Se fizer isso mais que meia dúzia de vezes, o contexto começa a ficar cheio, sliding window faz ele dividir atenção, ele "esquece" o que veio antes, começa a repetir o mesmo erro e fica nisso eternamente.

- não importa se suporta 8 mil tokens, 30 mil tokens, 100 mil tokens ou 1 milhão de tokens no contexto. Isso não influenciou a qualidade do código e nem melhorou essa rotina de repetição de erros. Ele nunca consegue dar atenção pra tudo.

- não adianta tentar tunar o key sampling. seja com temperature 0, 0.1, 0.6. Só faz ele errar um pouco depois ou um pouco antes, mas ele rapidamente erra e rapidamente fica incapaz de corrigir os próprios erros. Ferramentas como Aider pegam o código que ele sugeriu e grava em cima do arquivo de código de verdade. Várias vezes, por encher demais o contexto, ele começa a "esquecer" e apagar trechos do código. Ainda bem que GIT existe, porque várias vezes precisei dar `git checkout` pra voltar pro começo. Se você não checa, cuidado, ele apaga código ou sobrescreve com bobagem, e isso é frequente.

- deep thinking/reasoning/chain-of-thought, seja lá como você prefere chamar, só significa que ele fica pensando em excesso e enchendo o contexto de linguiça, comendo seus tokens. Se sua API comercial, cuidado: você vai acabar com seus créditos muito rápido e o resultado não é significativamente melhor. São casos isolados onde isso ajuda. Eu recomendo deixar desligado por padrão e ligar só em alguns casos especiais.

E veja: meu projeto de exemplo é ridículo: são 5 arquivos. 4 deles tem menos de 100 linhas de código, o maior tem 400 e tantas linhas. Um projeto de verdade, grande, são MILHÕES de linhas de código. Não cabe em nenhum contexto de nenhum Gemini ou Deepseek. E mesmo se coubesse, só deixaria ele mais confuso. A boa prática em qualquer ferramenta é dar o mínimo de arquivos pra ele. E isso restringe os casos de uso a refatorações locais e isoladas, jamais coisas como renomear uma classe ou função que é usada em centenas de arquivos. Pra isso, continue usando seu IntelliJ.

Nenhum modelo que testei é perfeito. Alguns modelos se dão um pouco melhor em alguns casos. Na primeira tentativa que fiz com o Gemini 2.5, ele até que conseguiu executar as tarefas que pedi. Não deu um código maravilhoso, mas pelo menos não quebrou nada.

Na segunda vez, dei `git reset --hard` e re-comecei, com os mesmos arquivos e os mesmos prompts. Dessa vez foi extremamente decepcionante. Ele quebrou o código principal na refatoração e foi incapaz de terminar um teste unitário que funcione mesmo eu forçando ele várias vezes. Desisti pelo cansaço.

Na terceira vez, ele deu resultado diferente, melhorou um pouco o código e ele conseguiu terminar o mesmo teste. Mas também precisou de algumas rodadas de teste quebrado, dar stacktrace e mandar corrigir erros óbvios. E quanto eu digo "óbvio" é ele consertar um mock que ele mesmo colocou sem precisar.

E isso é consistente em todos os outros modelos. Se eu só rodo uma vez, tenho uma impressão. Por exemplo, que Claude é melhor que Qwen3. Mas se eu rodo de novo, o mesmo teste, agora o Claude me decepciona e o Qwen3 passa na frente. Nunca tem um vencedor objetivamente melhor. Estão todos mais ou menos na mesma posição e ficam mudando no ranking dependendo de quantas vezes você repete exatamente o mesmo teste, com o mesmo código e os mesmos prompts.

E quem fica repetindo a mesma coisa? Ninguém. Todo mundo aceita a primeira resposta. E a primeira resposta pode estar BEM errada. Num nível óbvio de errada. Se aceitar automaticamente, vai inserir lixo no repositório. E esse é meu problema com coisas como MCP ou agentes: se deixar tudo no automático e pedir coisas como "pegue todos os arquivos de código deste diretório e corrija todos os bugs". Ele vai, com toda certeza, gerar mais bugs, apagar código, sumir com arquivos e deixar o repositório final num estado pior do que antes.

Vibe Coding puro, com nenhuma interação de um programador, não funciona. Eu testei todos os modelos principais. Nenhum foi capaz de passar testes simples. Nenhum vai ser capaz de passar por testes maiores de verdade. Não sem muita interação de um bom programador pra rejeitar os erros e mandar repetir, ou corrigir manualmente o que saiu errado.

E adivinhem: codificador que só sabe fazer copy e paste do stackoverflow (e agora do ChatGPT), é incapaz de reconhecer muitos desses erros. Então em vez de ajudar, ele pode piorar.

Pra mim, que sei exatamente o que eu quero, os erros são óbvios e eu automaticamente rejeito. E eu rejeito o que toda LLM faz mais do que aceito. Muitas vezes eu só pego um trecho do que ele sugeriu e descarto todo o resto. Esse é o dia a dia de verdade. Todo mundo que diz o contrário não fez código mais complicado do que um Hello World. 

Por que você acham que todo exemplo de _"uau, veja a LLM fazendo código sozinha"_ sempre é fazendo uma função de fatorial? Ou uma página web tosca? Porque é só isso que ele consegue fazer mesmo. Nenhum exemplo de MCP que eu vi até agora me deixou impressionado. Foi tudo fumaça. E você foi enganado pela propaganda.

Agora você sabe.

Como faz pra saber mais e não ser enganado? Comece aprendendo os fundamentos. 1 ano atrás eu fiz vários videos explicando como LLMs funcionam. Você já deveria ter assistido:

[![Playlist I.A.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/7tshjfwbly7wudczbni2pa863f11)](https://www.youtube.com/playlist?list=PLdsnXVqbHDUeowsAO0sChHDY4D65T5s1U)

E pra virar programador que não vai ser substituído pela I.A.? É pra isso que eu fiz [meu canal](https://www.youtube.com/@Akitando). Quando tudo que eu disse virar comum pra você, parabéns, você tem boas chances de sobreviver.
