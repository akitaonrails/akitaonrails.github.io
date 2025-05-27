---
title: "[Akitando] #142 - Entendendo COMO ChatGPT Funciona - Rodando sua Própria IA "
date: '2023-06-19T17:47:00-03:00'
slug: akitando-142-entendendo-como-chatgpt-funciona-rodando-sua-propria-ia
tags:
- chatgpt
- openai
- vicuna
- llama
- GPT
- transformers
- pytorch
- tensorflow
- akitando
draft: false
---

{{< youtube id="O68y0yRZL1Y" >}}

Não, AGI não está próximo de acontecer. 

Quais são os limites da atual tecnologia de transformadores generativos pré-treinados, vulgo GPT? 
O que são os tais "modelos" que eles usam? 
O que são os tais "parâmetros". 
Porque as IAs parecem humanas nas respostas? 
IAs vão substituir programadores??
Como é possível conseguir rodar um clone de ChatGPT na sua própria máquina, totalmente offline? 

Vamos responder tudo isso e muito mais.

## Capítulos


* 00:01:07 - CAP 01 - Minha IA PESSOAL e OFFLINE - text-generation-webui
* 00:06:37 - CAP 02 - Introdução a MODELOS - Como IA Aprende?
* 00:10:09 - CAP 03 - Auto-Corretor de Teclado de Celular - Cadeias de Markov
* 00:15:34 - CAP 04 - 170 TRILHÕES de parâmetros - Maior que nosso cérebro?
* 00:20:28 - CAP 05 - De Markov a IA - O que são Tensors?
* 00:30:53 - CAP 06 - A Revolução da Auto-Atenção - O que são Transformers?
* 00:35:24 - CAP 07 - Hardware pra Treinar IA - NVIDIA
* 00:42:09 - CAP 08 - Parâmetros e Sinapses são equivalentes? - Quantização
* 00:49:42 - CAP 09 - Estamos próximos de AGI? IAs são Inteligentes?
* 00:52:10 - CAP 10 - Controlando Criatividade de IAs - Temperatura
* 01:00:27 - CAP 11 - A Avó do ChatGPT - Eliza
* 01:04:29 - CAP 12 - IAs que fazem Imagens - Diffusion
* 01:09:31 - CAP 13 - Discutindo PROMPTs - LangChain
* 01:13:08 - CAP 14 - IAs vão matar programadores? Quais os Limites?
* 01:22:15 - CAP 15 - Virando "Programador 10x" com auxílio de IAs - Copilot
* 01:23:47 - CAP 16 - CONCLUSÃO - O começo da BOLHA
* 01:28:18 - Bloopers

## Links

* [Introducing LLaMA: A foundational, 65-billion-parameter language model (facebook.com)](https://ai.facebook.com/blog/large-language-model-llama-meta-ai/)
* [NVIDIA/Megatron-LM](https://github.com/NVIDIA/Megatron-LM)
* [oobabooga/text-generation-webui](https://github.com/oobabooga/text-generation-webui)
* [TheBloke/Wizard-Vicuna-30B-Uncensored-GPTQ](https://huggingface.co/TheBloke/Wizard-Vicuna-30B-Uncensored-GPTQ)
* [Neural networks - YouTube](https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi)
* [GPT-4 Will Have 100 Trillion Parameters — 500x the Size of GPT-3 | by Alberto Romero | Towards Data Science](https://towardsdatascience.com/gpt-4-will-have-100-trillion-parameters-500x-the-size-of-gpt-3-582b98d82253)
* [MIT Deep Learning 6.S191 (introtodeeplearning.com)](http://introtodeeplearning.com/)
* [DF Direct Special: Starfield Tech Breakdown - 30FPS, Visuals, Rendering Tech + Game Impressions - YouTube](https://www.youtube.com/watch?v=i9ikne_9iEI&t=1646s)
* [NVIDIA Made a CPU.. I’m Holding It. - YouTube](https://www.youtube.com/watch?v=It9D08W8Z7o&t=102s)
* [(2) Artem Andreenko 🇺🇦 on Twitter: "I've sucefully runned LLaMA 7B model on my 4GB RAM Raspberry Pi 4. It's super slow about 10sec/token. But it looks we can run powerful cognitive pipelines on a cheap hardware. https://t.co/XDbvM2U5GY" / Twitter](https://twitter.com/miolini/status/1634982361757790209)
* [Émile Borel and the Infinite Monkey Problem | SciHi Blog](http://scihi.org/emile-borel-infinite-monkey-problem/)
* [GitHub - codeanticode/eliza: The classic Eliza psychologist program, implemented as a Processing library.](https://github.com/codeanticode/eliza)
* [Stories • Instagram](https://www.instagram.com/stories/highlights/18020038894467644/)
* [TheBloke (Tom Jobbins) (huggingface.co)](https://huggingface.co/TheBloke)
* [Introduction | 🦜️🔗 Langchain](https://python.langchain.com/docs/get_started/introduction.html)

## SCRIPT



Olá pessoal, Fabio Akita

  

Este é um episódio que eu tava tentando evitar fazer. Primeiro porque acho que vai ser um dos temas onde parte do video vai acabar ficando obsoleto meio rápido, já que as tecnologias de IA estão acelerando e mudando bastante ainda. Segundo, porque eu mesmo nunca trabalhei com IA. Maioria das coisas que explico neste canal, já me envolvi em projetos reais de alguma forma, por isso não é só teoria, é experiência. Mas IA, eu brinquei, mas nunca trabalhei nem fiz pesquisa acadêmica, nem nada disso, por isso nunca me senti adequado pra explicar.

  
  
  
  
  

Mas considerando que quase a totalidade de videos feitos sobre o assunto hoje são de pessoas com menos conhecimento ainda, fazendo afirmações cada vez mais absurdas; até eu certamente consigo fazer muito melhor. Pra variar, os oportunistas já saíram lançando cursos e afins. No fim do video vou explicar porque todos são uma droga e você deve evitar. Também vou explicar de novo porque ela não vai substituir programadores. Hoje vou explicar o que de fato é um ChatGPT e onde estamos quando se fala em IA. Então vamos lá.

  
  
  
  

(...)

  
  
  
  
  

Esses dias resolvi brincar de IA, o objetivo era ter o meu próprio ChatGPT, rodando offline, totalmente local, na minha máquina, sem conectar com nenhuma API de terceiros como da OpenAI. Isso ficou fácil porque agora existem diversos esforços da comunidade de código aberto, em particular projetos de Open LLM, ou Large Language Models, que é a categoria de IA onde se encontra um GPT.

  
  
  
  
  
  

Esses esforços ganharam força quando a Meta decidiu abrir seu modelo Llama em fevereiro de 2023. As big tech tem diversos modelos prontos, cada um pra algum uso específico, desde respostas gerais ou mais focados em código e assuntos específicos. Por exemplo, a OpenAI tem os modelos GPT 3.5, GPT 4, Codex. A Microsoft tem o Zero, ou Megatron em conjunto com a NVIDIA. O Google tem modelos como o BERT, Palm, LaMDA, Minerva e outros. 







A Meta, de novo, tem o OPT, Galactica, METALM, LLaMA. Alguns desses modelos são citados em papers mas são fechados, como o novo BARD do Google ou o próprio GPT 4 da OpenAI. Mas o lançamento do LLaMA ao público foi um evento importante e a Meta parece que liberou vários outros como o OPT e Galactica. A primeira parte do video de hoje vai ser entender o que diabos são esses modelos.

  
  
  
  
  
  
  

Isso foi em fevereiro, este video tá saindo em junho, só 4 meses. E de lá pra cá a comunidade usou o LLaMA pra criar derivados mais otimizados e menores pra rodar em computadores menos parrudos. Surgiram diversas variantes como Alpaca, Vicuna, GPT4ALL, Koala, Dolly e dezenas de outros. Literalmente dezenas. O site HuggingFace, que é um repositório de modelos e ferramentas pra inteligência artificial, tem listado uns 200 modelos diferentes.

  
  
  
  
  
  
  

O que dá pra fazer com esses modelos abertos? Deixa eu mostrar. Eu queria um ChatGPT pessoal, offline, que ninguém sabe o que tô conversando com ele, sem filtros, sem controle, sem nada. Só eu e a ferramenta. Existem vários projetos abertos que implementam interface web similar ao ChatGPT, onde posso digitar perguntas, ver as respostas da IA, e ficar conversando com ela, sem precisar estar conectado na internet. Olha só esse exemplo.

  
  

(... screencast text-generator ...)

  
  
  
  

Se assistiram meu episódio sobre games em máquina virtual, sabem que tenho uma máquina que alguns consideram "parruda", um AMD 5950X de 16 cores, 32 threads, rodando a uns 4 gigahertz por core. Mais 64 gigabytes de RAM DDR4. Uma GPU NVIDIA RTX 3090 com 24 gigabytes de memória GDDR5. Fora meu NAS Synology de 60 terabytes, conectado em rede 10 gigabits. Meus testes foram feitos numa máquina virtual QEMU rodando Ubuntu normal, com passthrough de PCI pra ter acesso direto à GPU NVIDIA. Todos os detalhes sobre essa QEMU eu mostrei no video de Games em Máquina Virtual.

  
  
  
  
  
  
  

Sem nenhum motivo em particular, escolhi o projeto aberto "text-generation-webui" que é uma aplicação web escrita em Python. Ela simula a interface web de chat do ChatGPT. Por baixo, carrega bibliotecas como bitsandbytes, pytorch e outros que vou explicar depois. Daí podemos baixar modelos e fazer ele carregar um deles. No caso estou rodando Vicuna 30b quantizado. De novo, já vou explicar o que isso significa. Dizem que tem qualidade parecida com GPT 4 mas pra mim pareceu mais um GPT 3. As respostas que consigo no GPT 4 ainda são mais completas do que nesse Vicuna.

  
  
  
  
  
  

Mas mesmo assim é impressionante. Estão vendo? Estou conversando de boas. E não está conectando com nenhum serviço online de ninguém, nem da Microsoft, nem da OpenAI, nem do Google. Tudo rodando offline, local, dentro da minha máquina virtual. Vou repetir, porque quando postei sobre isso no Instagram, muita gente ficou confusa. Sim: dá pra rodar um programa similar ao serviço de ChatGPT da OpenAI num computador normal. E não se trata de uma demonstração hello world, realmente funciona. Não precisa de um monte de servidores parrudos pra conseguir isso. Ué, mas eu achava que precisava ter o tamanho de uma Microsoft ou Google pra fazer isso, o que mudou?

  
  
  
  
  
  
  

A exigência de hardware depende da complexidade do modelo. Como falei, estou usando Vicuna de 30 bilhões de parâmetros, mas existem modelos menores, como o próprio Vicuna de 7 bilhões de parâmetros, ou a Ada da Microsoft, de só 350 milhões. Se o modelo for pequeno o suficiente, é possível até rodar num bom smartphone Android ou um Raspberry Pi com um upgrade de RAM. O tamanho do modelo é um dos fatores que pode afetar a qualidade das respostas, portanto quanto menor o modelo, mais simples seriam as respostas. Simplifiquei sobre "tamanho", guardem essa informação que já vou explicar mais.

  
  
  
  
  
  
  
  

Deixa recapitular um pouco. O que diabos é isso de modelo? Honestamente, eu mesmo não sei dizer em todos os detalhes, pra isso precisaria ter estudo e treinamento em inteligência artificial, em particular redes neurais. Muita gente aprendeu isso em optativas ou iniciação científica na faculdade de ciências da computação. Não vou tentar dar explicação acadêmica, mas sim dar uma intuição pra maioria de vocês conseguirem ter uma imagem na cabeça. Acadêmicos, sejam compreensivos, e se quiserem complementar, sintam-se a vontade nos comentários abaixo.

  
  
  
  
  
  
  
  

Pense em redes neurais como uma simulação do aprendizado que acontece no nosso cérebro. Sabemos que temos neurônios. Aprendizado e memória acontecem quando temos sinapses, conexões desses neurônios, ou comunicação, ou melhor "ativação de um neurônio", que é como se ele escolhesse um caminho dentre muitos. Um neurônio pode ter milhares de conexões, dizem que umas 7 mil. De novo, explicação grosseira. Mas é mais ou menos isso que temos em redes neurais. Assista os videos do canal 3Blue1Brown sobre redes neurais pra entender em mais detalhes.

  
  
  
  
  
  

No caso específico de texto, poderíamos pensar que a forma de fazer computadores aprenderem a interpretar e gerar texto seria cadastrando regras gramaticais, ortográficas, vocabulário, dicionários, e assim ele conseguiria construir frases gramaticalmente corretas. Mais ou menos como você pensa que é o jeito certo de aprender uma língua nova como inglês ou francês num curso qualquer. Esse parece ser o jeito intuitivo, certo?

  
  
  
  
  
  

Mas se assistiu meu video de Como eu Aprendi Inglês e a minha live com o Matt sobre aprender japonês, já sabemos que não é assim. Não se trata de decorar dúzias de regras. Nem no aprendizado em geral, nem em inteligência artificial. Não existem "regras" como um monte de "ifs". Pense por dois segundos: quando foi a última vez que você escreveu um texto 100% gramaticalmente e formalmente correto? Concorda que um texto assim seria super estranho? Sem gírias, sem maneirismos, sem coloquialismos, com palavras consideradas rebuscadas. Exatamente o que associamos com um robô falando.

  
  
  
  
  
  

Já falei isso nesses outros videos, mas vou repetir: como você aprendeu português? Foi lendo um livro do tamanho da Bíblia, lotado de regras gramaticais? Quando tinha 1 ou 2 anos de idade? Como um bebê que nasceu nos Estados Unidos aprendeu inglês? Como um bebê que nasceu na China aprendeu chinês? Nenhum deles usou nenhum livro, nenhum curso, nenhuma regra.  Simplesmente passaram um tempão ouvindo os pais e pessoas ao redor e começaram a repetir o que ouviam. Bem errado no começo.

  
  
  
  
  
  

Todo mundo vai dando feedback. Quando o bebê tinha uma intenção, sei lá, dizer que está com fome. Ele tentava juntar palavras que já tinha ouvido antes e que parecia descrever o que queria. Se os adultos ao redor dessem comida, é o feedback que o que falou parece que faz sentido. E assim ele vai associando as combinações de palavras com comportamentos. Vai refinando seu aprendizado. Fazendo novas sinapses, novas conexões. Pouco a pouco melhorando a comunicação e se fazendo entender melhor. 

  
  
  
  
  
  
  

A grosso modo é como seria o que chamamos de treinamento supervisionado, no mundo de inteligência artificial. Nós não programamos regras gramaticais nem cadastramos palavras num banco de dados manualmente e ficamos fazendo "ifs" pra montar frases. Em vez disso começamos com um corpo de dados gigante. Por exemplo, todos os artigos da Wikipedia, todos os códigos abertos disponíveis no GitHub, todos os papers acadêmicos disponíveis publicamente, todos os livros digitalizados num Google Books. Bastante texto. Dezenas ou centenas de gigabytes de texto puro.

  
  
  
  
  
  
  

Pra entender isso, deixa eu fazer uma tangente e explicar um conceito relacionado que não é, em si só, inteligência artificial, mas faz parte da matéria. Na faculdade de ciência da computação, se aprende sobre processos estocásticos, que estuda aleatoriedade, probabilidades, ou melhor, a evolução de um sistema ou fenômeno ao longo do tempo de forma probabilística. Ele descreve o comportamento de um sistema ou quantidades que mudam aleatoriamente ao longo do tempo. Em particular quero falar de Cadeias de Markov.

  
  
  
  
  
  
  

Não estou falando que o ChatGPT não é uma Cadeia de Markov, é só pra ilustrar um ponto. Cadeias de Markov é uma das formas de representar e analisar sequências de eventos, ou estados, onde a probabilidade de transicionar de um estado pra outro depende somente do estado atual, é um sistema sem memória ou backtracking, sem considerar a sequência de todos os estados anteriores, só o último. Em resumo é um conjunto de estados e probabilidades de transição. Se pareceu grego, vamos ver um exemplo prático.

  
  
  
  
  
  
  

Digamos que em vez de ter gigabytes de textos como descrevi antes, nosso corpo de treinamento sejam só 3 frases em português: "Eu gosto de comer maçãs.", daí "Ela gosta de jogar tênis." e finalmente "Ele prefere ler livros.". Podemos construir um modelo baseado nessas frases, onde os estados são palavras, ou tokens, e as transições entre estados representam a probabilidade de mover de um token pra outro. Vamos construir esse modelo simplificado.

  
  
  
  
  
  

Os tais estados podem ser só as palavras, tokenizadas ou quebradas a partir dessas frases, daí teríamos essa lista de palavras, "Eu", "gosto", "de" etc. 

    

```
1. Eu
2. gosto
3. de
4. comer
5. maçãs
6. Ela
7. gosta
8. jogar
9. tênis
10. Ele
11. prefere
12. ler
13. livros
```

  
  
    

As transições são as probabilidades. Esses são exemplos, mas digamos que a transição do token, ou estado "Eu" pro estado "gosto" é probabilidade 1, ou seja, 100%. Mas a transição do estado "de" pra "comer" é 0.5 ou 50% porque poderia ser pra "jogar" que é 0.5 também. Pra ficar claro, na primeira frase temos "de comer", mas na segunda frase tempos "de jogar", por isso a partir do token "de" temos duas possibilidades, 50% de chance pra cada. 






Como temos poucas frases de treino, as transições são quase 100% de uma palavra pra outra, porque esse modelo só conhece 3 frases. Num treinamento de verdade com gigabytes de textos, teríamos trilhões de possibilidades diferentes e probabilidades pequenas e fracionadas, como 0.001234 bla bla. 

  
  
  
  
  

Finalmente, digamos que começamos a digitar um texto e queremos que esse modelo continue completando a frase pra gente. Podemos usar o modelo da cadeia de Markov pra prever o que seria a palavra mais provável baseado nas probabilidades de transição que vimos na lista anterior. Por exemplo, começo digitando "Eu" e a probabilidade da próxima palavra ser "gosto" é 100%, então é isso que ele dá de previsão. Se digitar "Ele", a probabilidade segundo a lista é 100% pra "prefere".

  
  
  

```
- De "Eu": gosto (1.0)
- De "gosto": de (1.0)
- De "de": comer (0.5), jogar (0.5)
- De "comer": maçãs (1.0)
- De "maçãs": Eu (1.0)
- De "Ela": gosta (1.0)
- De "gosta": de (1.0)
- De "de": jogar (0.5), ler (0.5)
- De "jogar": tênis (1.0)
- De "tênis": Ela (1.0)
- De "Ele": prefere (1.0)
- De "prefere": ler (1.0)
- De "ler": livros (1.0)
- De "livros": Ele (1.0)
```

  
  
  
  

Por causa de smartphones, todo mundo já viu isso em ação de verdade. É a funcionalidade de auto-correção que tem em todo teclado. Olhe neste exemplo, começo digitando uma palavra e o teclado sozinho vai sugerindo a próxima palavra, e podemos só aceitar a sugestão. E ele vai sozinho completando a frase. Claro, se ficar fazendo só assim, a frase vai ficando meio sem sentido nenhum, mas ele consegue gerar uma frase que mais ou menos parece um humano que escreveu, não acha?

  
  
  
  
  
  
  

Vou repetir: isso é uma explicação simplificada, tem várias outras técnicas em cima de cadeias de Markov, mesmo pra um tecladinho simples de iOS ou Android. Mas em linhas gerais, pense que em vez de 3 frases, o modelo desses teclados foi pré-treinado com milhares de frases. O modelo é essa lista de combinações de palavras e as probabilidade da próxima palavra, dada uma palavra anterior. Essas probabilidades é o que chamamos de "pesos". E mais importante: em nenhum momento usamos quaisquer regras hard-coded de gramática ou ortografia ou ifs ou templates. Ele vai completando a frase puramente usando esses pesos, aprendidos no treinamento, nada mais.

  
  
  
  
  
  
  

Agora vamos voltar pro ChatGPT ou pra minha versão local do text-generation com Vicuna. Vocês nunca acharam estranho que as respostas sempre demoram e ele vai escrevendo uma palavra de cada vez? Alguns poderiam achar que é só uma animação arbitrária pra fazer parecer que o ChatGPT é uma pessoa digitando. Mas deixa eu rodar uma versão fora da interface Web, na linha de comando mesmo. Prestem atenção.

  
  

(... screencast command line fastchat ...)

  
  
  
  

Pra ficar mais claro, vou colocar do lado o monitoramento da minha GPU, a ferramenta da nvidia chamado "nvidia-smi" que faz o monitoramento dos recursos sendo usados na GPU. Notem que durante a composição da resposta, a GPU está em uso constante, processando alguma coisa, sem parar. Não sei porque usa só 50% do processamento disponível, mas de qualquer forma, a resposta não é instantânea. Não é uma animação feita só pra fazer graça, é que ele demora isso mesmo palavra a palavra. Cada palavra nova que vai aparecendo está gastando processamento da GPU. Se levou 5 segundos pra dar a resposta, foi 5 segundos que a minha GPU ficou processando sem parar.

  
  
  
  
  
  
  

Conseguem ver as similaridades entre o auto-corretor do seu tecladinho de celular e o processo de resposta do ChatGPT? Internamente ele está fazendo algo similar a procurar probabilidades na cadeia de Markov. Mas claro, o modelo de GPT, LLaMA, Vicuna, Bard, e outros, é mais complicado que um mero modelo de Markov. Vamos entender.

  
  
  
  
  
  

Quando as primeiras notícias anunciando o ChatGPT saíram, gerou muita confusão, que persiste até hoje. Por exemplo, quando o ChatGPT 4 foi anunciado, eles mencionam, "uau, o ChatGPT 3.5 tinha 175 bilhões de parâmetros mas o ChatGPT 4 tem incríveis 100 a 170 TRILHÕES de parâmetros". A única coisa que os jornalistas e vocês entenderam foi "uau, bilhões pra trilhões de ... whatever ... trilhões é absurdamente maior que bilhões, então o GPT novo é milhões de vezes melhor e o GPT 5 vai ser mais milhões de vezes melhor". E é assim que todo mundo mente e se auto-engana com números, sem saber o que significa.

  
  
  
  
  
  
  
  

Esse meu Vicuna, rodando localmente na minha máquina, tem meros 30 bilhões de parâmetros. Puuuts, quer dizer que ele deve ser pelo menos 5 vezes pior que o ChatGPT antigo, né? Nem chega aos pés do GPT 4. Só que se olhar alguns artigos que descrevem o Vicuna menor, o de 13 bilhões de parâmetros, muitos declaram que rodando diversos testes, os mesmos que a própria OpenAI usa pra avaliar o GPT deles, dizem que o Vicuna 13B chega a 90% do nível de qualidade do GPT 4 ou Google Bard. E o Vicuna, sendo derivado do LLaMA do Facebook, nesses mesmos testes, ultrapassa o LLaMA original. Como pode isso?

  
  
  
  
  
  
  

Antes de mais nada, o que diabos são esses tais parâmetros? No contexto de machine learning, parâmetros se referem aos pesos que o modelo aprende durante o processo de treinamento. De forma simplificada e grosseira, lembra a lista de probabilidades de transição de estados da cadeia de Markov que mostrei no exemplo? Aquilo poderíamos chamar de parâmetros. No nosso treinamento com só 3 frases, gerou um modelo de 16 parâmetros. Pense numa lista como aquela só que bilhões de linhas. 13 bilhões ou 30 bilhões no caso do Vicuna, ou 170 trilhões no caso do ChatGPT 4.

  
  
  
  
  
  
  

E lembra como no exemplo, dado uma palavra, podemos ir na lista de probabilidades e ver qual poderia ser a próxima palavra? A grosso modo, é como GPT ou Vicuna fazem. Só que em vez de considerar só a palavra anterior e procurar a próxima, ele vê quais foram as palavras anteriores e leva todas em consideração pra tentar prever a próxima palavra. Lembra como minha GPU fica processando sem parar enquanto monta a resposta? É isso que  está fazendo: pesquisando no modelo pela próxima palavra, mas  considerando parte ou todo o texto anterior, incluindo as palavras que ele mesmo sugeriu, vai ficando cada vez mais pesado. Por isso demora.

  
  
  
  
  
  
  

Antes que o pessoal acadêmico me crucifique, é melhor eu me corrigir aqui. Eu repeti várias vezes "a grosso modo", "a grosso modo", porque o modelo do GPT não são probabilidades de pares de palavras, daquele jeito bonitinho como no exemplo. Intuitivamente, poderíamos pensar que quando se quebra um texto longo, teríamos conjuntos de "palavras". Mas vamos recordar a metáfora do bebê aprendendo?

  
  
  
  
  
  

Todo mundo já deve ter percebido que um bebê não ouve um adulto falar uma palavra e sai repetindo bonitinho igualzinho, certo? Parte da diversão é justamente ver ele falando errado no começo e ir ajustando. O bebê tenta reproduzir o que ele "acha" que ouviu. Daí você dá o feedback negativo e ele vai tentando de outras formas, até uma hora acertar. No mundo de machine learning e deep learning, podemos usar isso como metáfora. No treinamento ele não isola palavras,  isola "patterns" de funcionalidades, ou features, do material de treinamento. 

  
  
  
  
  
  

Fora de IA, no mundo de full-text search, ou em processamento de linguagem natural, temos ferramentas como Elasticsearch ou Apache Solr, que expliquei no episódio do Twitter. Eles não quebram os textos indexando palavras, mas sim grams. Quem já leu a documentação deve ter visto o termo n-gram, que são sequências de "n" itens ou tokens. Pode ser uma palavra inteira, mas pode ser só parte de uma palavra. Uma sequência de só uma letra seria um unigram, duas letras um bigram, três letras, trigram e assim por diante.

  
  
  
  
  
  
  

Quando indexamos texto, é mais útil indexar n-grams do que palavras inteiras, é o que nos permite fazer coisas como achar palavras "parecidas" ou que "soam" parecido, que tem mesmo sufixo ou mesmo prefixo, como conjugação de verbos. Mesma coisa com o teclado de auto-correção, ele indexa n-grams. Por isso você digita a pesquisa tudo errado num Google, mas ele diz no resultado "você quis dizer X". O mundo de indexação de textos é todo baseado no conceito de n-grams. Vale a pena estudar isso depois.

  
  
  
  
  
  
  

Quer dizer que o tal modelo do GPT são pesos em cima de n-grams? Infelizmente também não é assim fácil. Eu mencionei n-grams só pra explicar como podemos dividir palavras de outras formas não intuitivas. Agora, o problema com sinapses no nosso cérebro ou redes neurais é que os pesos não são aplicados em cima de idéias discretas, como palavras ou letras ou imagens inteiras. De novo, pra entender tecnicamente como redes neurais funcionam, procure material de universidades como do MIT, Stanford ou lugares assim, e de novo, acadêmicos, peguem leve comigo.

  
  
  
  
  
  
  

No fim do dia, um modelo é como se fosse um banco de dados, contendo probabilidades ou pesos de um elemento pra outro elemento. Parecido com o exemplo da auto-correção. Mas o principal é que não são necessariamente palavras, não são também só n-grams, pode ser qualquer tipo de pattern que foi identificado no aprendizado. Pode ser uma letra pra uma palavra. Pode ser um bigram pra um trigram. Pode ser muitas coisas. Por exemplo, poderia ser "ef" pra "yw" probabilidade 0.01234. O que isso significa?

  
  
  
  
  
  
  

Isoladamente não significa absolutamente nada. Ela só vai fazer sentido dentro de uma rede de pesos. A probabilidade final é uma composição de múltiplos passos pelos nós dessa rede. O modelo não é uma lista, provavelmente é mais como um espaço vetorial multi-dimensional, tipo matrizes de matrizes. Eu expliquei espaços vetoriais no episódio do Twitter também. Similaridade de Cosseno, Álgebra Linear, lembram? De novo, pra visualizar, não pense num modelo como sendo uma lista, como um array simples. Pense como um array de arrays, de arrays. Multi-dimensional.

  
  
  
  
  
  
  

Se multi-dimensional não é intuitivo pra vocês, pense num elemento simples, tipo uma variável de tipo inteiro. Isso é o que chamamos de valor escalar, com zero dimensões. Representa um único valor. Agora, um array de escalares, como um array de inteiros. Isso é vetor, uma lista de uma única dimensão. Em seguida, em vez de escalares, se eu fizer um array de arrays, onde cada elemento do array é outro array, e esse array for unidimensional, agora temos uma matriz, que é um retângulo, ou uma grade de valores escalares.

  
  
  
  
  
  
  

Finalmente, e se esse array interno também tiver arrays como elementos? Agora temos um array de arrays de arrays,  tridimensional. E podemos ir adiante, esse último array também pode ter arrays de elementos, que tem arrays de elementos, que tem arrays de elementos, aí temos matrizes multi-dimensionais ou mais corretamente, tensores de alto ordenamento ou tensores n-dimensionais.

  
  
  
  
  
  

Aliás, tudo isso que eu expliquei são tensors, sabe, do tal Tensorflow do Google? Um escalar é um tensor de zero dimensões, um vetor é um tensor de uma dimensão, uma matriz é um tensor de duas dimensões e acima disso é um high-order tensor ou n-dimensional tensor. Então, voltando pro tal modelo do GPT ou Vicuna, não pense como no exemplo simples do auto-corretor, que foi somente um vetor, um array unidimensional de pesos. Pense que esses pesos estão estruturados em tensores n-dimensionais.

  
  
  
  
  
  

Todos esses conceitos que vim explicando não são a ponta do iceberg. São a raspa da ponta do iceberg. Pode parecer que quero dizer que um ChatGPT não é mais que uma cadeia de Markov, só que maior. Não é isso, é só uma metáfora pra explicação. Deixa eu tentar explicar qual foi a tal "revolução" que permitiu o salto de um mero auto-corretor pra um ChatGPT. Mas entenda: redes neurais e deep learning existem faz décadas. A comunidade de ciências da computação vem fazendo descobertas e refinando as tecnologias faz muito tempo. Não foi do nada que isso apareceu.

  
  
  
  
  
  
  

Seguindo o exemplo do auto-corretor, deve ser fácil de perceber um dos problemas: ele só usa a palavra anterior pra tentar descobrir qual a próxima palavra. Por isso muito rapidamente a frase fica sem sentido. Dá impressão que foi um humano que escreveu, mas um humano bem burro. É diferente de um punhado de palavras completamente aleatórias, mas as frases que gera, são bem inúteis. Quanto maior tentar fazer a frase, pior vai ficar.

  
  
  
  
  
  
  
  

Claro, o certo é que a próxima palavra leve em consideração não só a palavra anterior, mas todas as palavras anteriores, pra manter a coerência. É isso que poderíamos chamar de backtracking ou recurrency. Isso tem que ser levado em conta durante o treinamento. Não basta quebrar o texto em palavras e só fazer o peso da palavra seguinte. Tem que ser o peso da palavra seguinte dado as palavras anteriores. É aí que nasce coisas como RNN ou Recurrent Neural Networks.

  
  
  
  
  
  
  

RNNs foram desenhados pra lidar com sequências de tamanhos variados, como sentenças, dados de séries de tempo, sinais de discurso. Eles conseguem processar inputs, como texto, um passo de cada vez e ao mesmo tempo mantendo um estado interno escondido que mantém informações dos passos anteriores. Ou seja, ele mantém memória durante o aprendizado. É como a gente aprende também. 








Uma coisa é aprender, por exemplo, a palavra "foda". Dependendo do contexto pode significar coisas diferentes. Pode ser que signifique "puts, que foda esse macbook novo" ou seja, positivo. Ou pode ser "puts, que trampo foda de difícil", ou seja, negativo, e várias outras variações. Precisamos de contexto, e contexto precisa de memória pra gerar pesos diferentes pra contextos diferentes. Consegue imaginar o trampo de processar pensando dessa forma?

  
  
  
  
  
  
  
  

RNNs usam técnicas como BPTT ou Backpropagation Through Time, literalmente propagação reversa através do tempo, pra computar gradientes e atualizar os parâmetros do modelo. Então não é um processamento que você pega um texto, lê só uma vez do começo ao fim e já gera um modelo, escrito linearmente do começo ao fim. Tem que ficar voltando pra trás no modelo pra ajustar. E já que é pra dificultar, em todo paper de IA por aí vamos esbarrar nesse termo "gradiente". Deixa eu resumir.

  
  
  
  
  
  
  

Gradiente se refere à derivada da loss function, função de perda, ou de custo. Puts Akita, eu nunca vou usar Cálculo na vida, é perda de tempo. Bom, eis um pequeno exemplo. Pra que serve derivada? Ela serve pra medir a taxa de mudança de uma função. Em resumo, a derivada nos diz como o resultado de uma função muda à medida que fazemos pequenas modificações nos valores de entrada. Lembra de física cinemática no colegial? Fórmula pra saber o espaço ao longo do tempo? Fórmula de Velocidade ao longo do tempo? A de velocidade é derivada da fórmula de espaço, porque velocidade é a taxa de mudança da fórmula de espaço ao longo do tempo. Aceleração é a taxa de mudança da fórmula de velocidade. 

  
  
  
  
  
  
  

Em particular, gradientes em cálculo de múltiplas variáveis é um vetor que aponta na direção da ascendente mais íngreme da função. Isso é super importante em otimização de algoritmos, como gradient descent, ou descida de gradiente, que iterativamente atualiza os parâmetros pra encontrar a função de custo mínimo. Dado que gradientes nos ajudam a entender a taxa de mudança de resultados de uma função, podemos usar pra encontrar os pontos de máxima e mínima, pra otimização. E esse conceito é importante em otimização de machine learning.

  
  
  
  
  
  
  

Em Machine Learning tem um troço que chamam de "loss function" também conhecido como função de custo, que é uma função matemática que quantifica a discrepância entre resultados previstos de um modelo com os valores de verdade. Lembrando, uma das formas de treinar é dar um monte de dados de treinamento, daí pedir pro modelo devolver respostas a várias perguntas e ver se as respostas estão corretas. Justamente pra calibrar o aprendizado. Lembra do bebê aprendendo a falar e olhando pra nossa cara pra ver se a gente entendeu? Tipo isso.

  
  
  
  
  
  
  

O objetivo do tal treinamento é ver quão bem um modelo performa determinadas tarefas. A escolha de qual função de custo usar depende do problema que queremos resolver, como regressão, classificação, geração de sequências. Por exemplo, em tarefas de regressão, uma função de custo popular é o MSE ou mean squared error, erro quadrado mediano, ou o MAE que é mean absolute error, erro absoluto mediano. Em tarefas de classificação tem custo de entropia cruzada e assim por diante. O importante é entender que treinamento não é um troço aleatório. Tem funções de métrica e controle pra calibrar e otimizar.

  
  
  
  
  
  

Durante o treinamento, os parâmetros do modelo são ajustados pra minimizar essa função de custo usando algoritmos de otimização como o "gradient descent". Agora vocês entendem uma das formas que cálculo influencia a qualidade do treinamento de um modelo de rede neural. Pra hoje, pense em rede neural como uma caixa preta, que nem uma função que você programa na sua linguagem de programação. Ela tem variáveis de entrada e algum retorno. A entrada seria as tais toneladas de textos pro treinamento. Daí no meio, nessa caixa preta, esses dados são processados de alguma forma, e o retorno vai ser o tal modelo multi-dimensional.

  
  
  
  
  
  
  

Essa etapa no meio é o processamento dos textos e materiais de treinamento que passamos. Processos como tokenização que é quebrar o texto em listas de sequências de palavras. São uma série de transformações pra massagear esses dados em diversas camadas escondidas. Essas transformações envolvem cálculos, por exemplo, soma ponderada. Cada neurônio de uma camada escondida recebe inputs de uma camada anterior. A cada input é assinalado um peso. O neurônio computa a soma ponderada dessas entradas, onde os pesos determinam a significância da contribuição de cada input pra saída do neurônio.

  
  
  
  
  
  
  

Daí a soma ponderada pode ser passada pra uma função de ativação, que introduz não-linearidade e determina a saída da função. Não linearidade e sistemas complexos é um assunto gigantesco, nem vou tentar explicar. Mas pra ter intuição pense assim: você tá acostumado a pensar em sistemas lineares. Por exemplo, se 1 litro de gasolina dá pra andar 15 quilômetros, então 10 litros de gasolina vai dar 150 quilômetros. Mas não-linearidade é que nem tentar prever o tempo. 

  
  
  
  
  

Só porque temos 80% de humidade no ar e no passado vimos que isso indicava uma chuva de, sei lá, 20 milímetros. Não quer dizer que se eu medir hoje 80% vai dar os mesmos 20 milímetros. Pode ser 40. Pode ser zero. Tem uma rede de outras variáveis, algumas mensuráveis, algumas desconhecidas, uma influenciando a outra. Variáveis minúsculas podem amplificar resultados completamente inesperados. 







É o famoso caso da Borboleta de Lorenz. Aquela história que uma borboleta bate as asas no Brasil e tem um tsunami no Japão. Não foi a borboleta que causou o tsunami, não é linear, não tem causalidade direta. Mas quer dizer que essa minúscula contribuição, somado a milhares de outras, "pode" ter causado o tsunami. 

  
  
  
  
  
  
  

Depois parem pra ler sobre Teoria do Caos, é fascinante, e o mundo real é cheio de efeitos não-lineares. E levamos isso em conta em redes neurais. Nosso cérebro tem aprendizado não-linear, e é o que tentamos simular com redes neurais. Agora, Deep Learning, como o próprio nome diz é aprendizado profundo, e profundidade se refere a várias camadas de aprendizado. Aquela função caixa preta que eu mencionei? Imagine várias delas em série, uma chamando a outra, várias camadas de profundidade. Lógico, explicação simplificada, mas só pra dar uma noção.

  
  
  
  
  
  

Enfim, a parte importante é que processar texto em deep learning usando técnicas como RNN e BPTT seria absurdamente caro, pra manter toda a memória e fazer todo esse backtracking na força bruta. É aí que entra o famoso paper do Google, "Attention is All You Need". Literalmente "Atenção é Tudo que Você Precisa", publicado por Vaswani e equipe em 2017. É o paper que introduz a arquitetura de Transformers, os famosos transformadores que permitiram esta geração de LLMs como GPT.

  
  
  
  
  
  

Em pouquíssimas palavras, ele introduz o mecanismo de self-attention, ou auto-atenção, também conhecido como atenção escalada de produto escalar. Eu expliquei produto escalar no contexto de espaços vetoriais no episódio do Twitter. Não vou explicar de novo. Mas esse mecanismo permite o modelo pesar a importância de diferentes posições na sequência de entrada, possibilitando capturar efetivamente as dependências longas. Eu sei, é difícil de entender isso, e também de explicar. Mas lembra como RNN precisa manter um estado em memória pra lembrar o contexto? Self-attention é uma otimização disso.

  
  
  
  
  
  
  

Em vez de ser recurrent neural network, ele passa a poder usar feed forward neural network. Da forma como eu entendo, em vez de um processo onde você dá um passo pra trás antes de poder dar um passo pra frente, agora é só passos pra frente, feed forward. O que possibilita isso é o tal mecanismo de auto-atenção. Elimina a necessidade de recorrência ou convolução. E ainda permite paralelizar o processamento. Antes, como o passo seguinte dependia do passo anterior, tinha que ser feito em série, em sequência linear. Parte da dificuldade de conseguir rodar coisas em paralelo é eliminar as dependências que amarram o passo seguinte com o passo anterior. Isso vale não só pra IA mas qualquer coisa.

  
  
  
  
  
  

Tornando o processo feed forward, evitando convolução, podemos paralelizar o processamento. O que levaria, chutando, um ano pra treinar, poderia ser feito em um mês. O importante é entender que essa arquitetura de transformers é uma otimização massiva. É mais ou menos o tipo de impacto que você vê num desenvolvimento web comum quando coloca um índice numa tabela gigante, ou quando coloca um cache na frente do banco de dados e ganha 5x ou 10x a performance. Independente de como funciona no detalhe, o importante é entender que foi um salto grande. 

  
  
  
  
  
  
  
  

Toda hora eu fico falando que os acadêmicos vão me matar vendo essas minhas explicações grosseiras, mas eu mesmo fico doído de ficar toda hora falando "a grosso modo", "simplificando", "em metáfora", porque cada parágrafo que falei até agora são dúzias de papers e formalidades matemáticas. Estou tentando trazer um pouco desse vocabulário, pra vocês entenderem que não é um chute do nada, mas também reduzir em poucas palavras que ajudem a dar uma intuição. Pra maioria de nós, os detalhezinhos não importam tanto. Tem mais valor ter a noção desse processo, em linhas gerais, pra entender que não é mágica. Principalmente: qual o limite dessa mágica.

  
  
  
  
  
  
  
  

Mas com tudo isso que falei, vamos tentar entender o que é o ChatGPT então. Como é um projeto proprietário, fechado e secreto da OpenAI, temos que acreditar nas informações que eles disponibilizaram. Então sempre leiam isso com vários quilos de sal. Isso dito, parece que o treinamento foi baseado num corpo de aproximadamente 570 gigabytes de texto. Quais textos exatamente? Não sabemos, mas eles mencionam Wikipedia, artigos de pesquisa e papers, websites e outras formas de conteúdo escrito na web, com um limite até 2021. Isso é arbitrário.

  
  
  
  
  
  
  
  

Pessoalmente, achei pouco texto, eu teria chutado mais. Mas 570 gigabytes só de texto puro é bastante coisa na real. Por exemplo, a Wikipedia inteira dá um total de 21 gigabytes, e isso eu acho que é contando com o HTML que monta as páginas. Se filtrar e limpar só os textos puros vai ser bem menos. Mas digamos que seja 21 gigabytes. Precisaria de mais de 30 Wikipedias inteiras pra completar os 570 gigabytes de dados de treino. É um volume respeitável.

  
  
  
  
  
  
  
  

Esse tanto de texto, dizem que deu um total de 300 bilhões de "palavras", entre aspas, mas acho que o jornalista entendeu errado. Um dicionário de inglês, como o Merriam Webster online não tem meio milhão de palavras. Acho que são 300 bilhões de tokens, que incluem palavras, mas também n-grams como falei antes, e seja lá quais outros patterns o deep learning identificou nesse material. Daí passa por semanas fazendo todo o processo que falei de transformação. Esse processo, que levaria meses, agora parece que dura mais ou menos um mês rodando em não sei quantos servidores usando hardwares como os agora famosos NVIDIA Grace-Hopper, os GH100.

  
  
  
  
  
  
  
  

Lembra que falei que, internamente, não estamos lidando com valores escalares e sim com tensores multi-dimensionais? CPUs como um Intel ou AMD que roda no seu PC, mesmo os M1 ou M2 da Apple, são chips com instruções feitas pra cálculos em cima de valores escalares. Uma função de soma pega dois valores inteiros de 64 bits e cospe um resultado inteiro de 64 bits. Eu explico como isso funciona nos episódios de emuladores como o do Super Mario, com processadores de 8-bits, depois dêem uma olhada.

  
  
  
  
  
  
  

CPUs modernas incluem instruções pra lidar com vetores, instruções SIMD, Single Instruction, Multiple Data, literalmente uma instrução pra múltiplos dados. Começou com as instruções MMX dos primeiros Pentium nos anos 90. Hoje temos conjuntos de instruções como SSE4 ou AVX-512. Pra ter a intuição, em vez de uma função que recebe um inteiro, pense numa outra função que recebe dois arrays, soma os dois arrays, e cospe um array resultante, tudo numa única instrução.

  
  
  
  
  
  
  

GPUs, diferente de CPUs, não tem capacidade de rodar qualquer programa genérico. Lembram do meu episódio de Turing Complete? A grosso modo, uma máquina de Turing é basicamente qualquer programa. Em particular, pra ser Turing Complete, pra ser um computador moderno, ele precisa ser capaz de rodar um programa que consegue simular ser um computador. Como exemplo mais óbvio pense uma máquina virtual. Ele nem precisa conseguir rodar na prática, mas tem que ter a capacidade teórica. Num CPU ARM M2 da Apple, é possível simular uma CPU Intel usando o Rosetta. E esse programa de Intel roda achando que tá num PC de verdade. Isso é possível porque um CPU ARM M2 é Turing Complete.

  
  
  
  
  
  
  
  

Já uma GPU não tem essa capacidade. Diferente de CPUs, que são genéricos, e podem simular qualquer coisa, mesmo que lento, uma GPU é um hardware especializado, pra executar um conjunto pequeno de tarefas bem definidas. Uma GPU não consegue rodar um sistema operacional genérico, nem simular ser outra GPU, tipo um AMD Radeon tentar simular ser um NVIDIA RTX. Não funciona assim. Quando existe camada de abstração, quem cuida disso é a CPU. A GPU é boa numa única coisa: fazer cálculos de vetores e matrizes.

  
  
  
  
  
  
  
  

Uma CPU Intel costuma ter sei lá, 8, 16, 32 núcleos com 2 threads cada, rodando a 4 ou 5 gigahertz hoje em dia. Mesmo chips de servidores como um Intel Xeon ou AMD EPIC não tem muito mais que isso de cores. Já uma GPU é diferente. Uma novíssima RTX 4090 tem nada menos que 16 mil núcleos pra shading de CUDA, 128 núcleos pra ray tracing e nada menos que 512 núcleos exclusivos só pra tensors. Uma GPU, diferente de uma CPU, tem milhares de núcleos que rodam em clocks baixos como 1 gigahertz, pra funções altamente especializadas.

  
  
  
  
  
  
  
  
  

O que eu falei que é o resultado do treinamento de deep learning? Um modelo de tensors n-dimensionais. O que foi feito pra calcular tensors multi-dimensionais? GPUs. Processar áudio, processar video, processar polígonos ou voxels tridimensionais, é tudo processamento de matrizes multi-dimensionais. Uma tela de computador ou do seu smartphone, como é representado? Num monitor Full HD, é um array de 1080 colunas, onde cada elemento é um array de 1920 elementos pra cada linha. Se eu quiser escurecer essa imagem inteira? Pode ser uma substração em cada valor desses arrays. Fazemos isso adicionando, ou subtraindo uma matriz por outra matriz, que chamamos de um "filtro" ou kernel.

  
  
  
  
  
  
  
  

Numa CPU, você programaria como um loop nas colunas e outro loop nas linhas pra calcular a nova cor, pixel a pixel, seria 1920 vezes 1080 operações, ou mais de 2 milhões de operações. Numa GPU eu passo a matriz inteira e ele calcula tudo numa única operação. De novo, não vou conseguir entrar em detalhes, mas essa é a diferença fundamental.

  
  
  
  
  
  
  

De curiosidade, um dos maiores problemas dessa arquitetura de CPU controlando GPU é o compatilhamento de memória. Em PCs modernos a CPU tem um conjunto de RAM e a GPU tem um conjunto de VRAM separados. A CPU prepara os dados e tem que mandar pra GPU processar. Daí uma vez calculado, a CPU precisa puxar o resultado de volta pra própria RAM. No frigir dos ovos, essa comunicação é um gargalo. 







Não é raro vermos jogos, por exemplo, que perde frames mesmo a GPU não estando em 100%, mas se olhar a CPU, ela que tá em 100%, então vira um gargalo e a GPU fica um tempo parado esperando. Por isso desde a nona geração de consoles de videogames como PS5 e Xbox Series X se falou tanto em loads instantâneos e tecnologias de melhorar esse gargalo, como o Microsoft DirectStorage.

  
  
  

  
  
  

Também é por isso que a estratégia da Apple com os chips M1 e M2 é ser um SoC ou System on a Chip; um único chip que embute CPU, GPU e RAM tudo junto, pra minimizar ao máximo esse gargalo. Juntar tudo no mesmo lugar garante uso mais eficiente de memória e caminho mais curto de comunicação, ajudando a evitar gargalos. 






Na velocidade que estamos hoje, a distância da sua CPU Intel pros pentes de RAM é gigante se comparado a soldar tudo junto no mesmo chip como a Apple faz. É um saco porque não dá pra aumentar RAM depois, mas a razão não é porque eles são uma corporação querendo arrancar mais dinheiro de vocês, mas sim porque tirar esse gargalo faz muita diferença.

  
  
  
  
  
  

A mesma coisa acontece na solução pra data centers da Nvidia, a tal arquitetura Grace-Hopper que eu falei, começa com um superchip Grace-Grace, tanto Intel quanto ARM, que eles mesmos desenvolveram, num único pacote com NVLink que é um barramento de altíssima velocidade entre eles, e a alternativa Grace-Hopper que é outro superchip que junta uma CPU Grace com uma GPU `H100` Hopper. 







São soluções que juntam todos eses chips junto com meio terabyte de memória RAM LPDDR5 de 32 canais. Estamos falando de 96 núcleos de 3 nanômetros. É um monstro. É esse o produto que tem feito as ações da NVIDIA disparar, porque eles encaixam perfeitamente pra acelerar processamento de transformers. Meu PC não é "parrudo", esse da NVIDIA sim, é a verdadeira definição de "parrudo", o atual estado da arte em 2023.

  
  
  
  
  
  
  

É com servidores desse tipo, não sei quantos, que se pega meio terabyte de dados, quebramos em 300 bilhões de tokens, e no final a OpenAI consegue gerar um modelo de GPT 4.0 com os tais 170 trilhões de parâmetros. Conseguem entender melhor agora essa frase? Daí a mídia e os jornalistas ficam assustados e noticiam como o GPT 4 se iguala ao cérebro humano, que tem 100 trilhões em sinapses. Lembram? Sinapses mais ou menos são os pesos ou parâmetros entre neurônios. Agora que entendemos mais ou menos o que são esses parâmetros, vamos discutir a premissa errada: parâmetros não são equivalentes a sinapses do cérebro humano.

  
  
  
  
  
  

Quando se joga números arbitrários assim no título de uma matéria, todo mundo fica empolgado. Vamos entender o erro. Pra começar, nosso cérebro, em média, tem uns 100 bilhões de neurônios. De novo, eu não sou um neurologista, então já assuma que minha explicação vai ser simplificada e de alto nível. Em pesquisa de IA, tentamos igualar neurônios biológicos com neurônios digitais numa rede neural, e falamos em bits, como num computador. Mas pra começar, neurônios não são exatamente binários assim. Um único neurônio é capaz de lidar com múltiplos sinais e conexões. Em termos de sinapse pode ter até umas 7 mil.

  
  
  
  
  
  
  
  

Isso acho que seria máximo, mas em média o cérebro é capaz de até uns 600 trilhões de sinapses. Não sei porque, dependendo de onde se pesquisa, falam em 100 trilhões, outros falam em 600 trilhões. De novo, precisa pesquisar um pouco mais a literatura de neurologia pra entender o que isso significa. Mas não é um número absoluto. Tem vários fatores. Doenças como Alzeimer, por exemplo, afeta justamente a capacidade de fazer e manter sinapses. 







Em crianças, quando o cérebro ainda é muito mais elástico e não foi limitado pelo crescimento, o potencial é de 1 quadrilhão de sinapses. É um número absurdo, mas mais importante, os 170 trilhões de parâmetros do GPT 4 não se equipara à quantidade de sinapses que nosso cérebro é capaz ainda. Portanto é falso que o GPT 4 já se igualou ao cérebro humano em quantidade de sinapses.

  
  
  
  
  
  
  
  

A outra premissa que errada: um parâmetro de modelo de GPT não é equivalente a uma sinapse do cérebro humano, nem de longe. Usamos vocabulário neurológico pra simplificar a descrição em termos de inteligência artificial, como redes "neurais". É uma metáfora. Em nenhum momento, nenhum cientista da computação vai te dizer que um neurônio de rede neural é idêntico ou sequer próximo de um neurônio biológico. É só uma abstração. 
  
  
  
  
  
  
  
  

E no caso de IA, parâmetros de modelos de transformers, comparado com neurônios do cérebro. Vamos voltar ao meu Vicuna rodando localmente na minha máquina. Lembram da afirmação do povo que fez testes e otimizou esse modelo? Um modelo Vicuna de 13 bilhões de parâmetros, em muitos casos, chega até 90% da qualidade de respostas de um ChatGPT 4.0 de 170 trilhões de parâmetros. Como isso é possível?

  
  
  
  
  
  
  
  

E por isso mencionei não-linearidade e Teoria do Caos. Um único parâmetro isolado, se tentar ler e interpretar, não tem como inferir nada. Só funciona se estiver combinado com vários outros parâmetros, numa rede. O resultado final depende da interação de múltiplos parâmetros, e por isso se gasta processamento da GPU pra gerar uma resposta. Parâmetros são pesos, probabilidades. E tem várias formas de otimizar isso. Por exemplo, probabilidades pra ter o máximo de precisão podem ser valores escalares de tipo float de 32 bits. É isso que se gera num modelo depois do treinamento.

  
  
  
  
  
  
  
  

Porém, pesquisas mostram que podemos truncar esses valores pra float-16 e a qualidade das respostas não cai tão drasticamente. É uma forma de otimização. Simplificando, é parecido com o conceito de música em MP3, que dados das frequências que o ouvido humano não é capaz de detectar são cortados fora. Tecnicamente isso tira qualidade do áudio, mas na prática a maioria dos humanos não sente. Em termos de armazenamento, economizamos 10 vezes o espaço fazendo isso. 








Expliquei no episódio de 25 tera pra 5 gigas, onde pegamos uma imagem bruta em bitmap e reduzimos pra um JPEG. A qualidade cai, mas o olho humano sem treinamento, não nota diferença tão grande assim. Otimizações e compressão são formas de simplificar os dados, diminuir a qualidade, de forma que nossos sentidos, sem treinamento, não sintam diferença significativa. Fazemos isso com modelos de IA também.

  
  
  
  
  
  
  
  

Reduzir os valores de Float 32 pra Float 16 é uma forma de quantização. Existem várias formas de quantização que são otimizações dos modelos, pra exigir menos processamento pra gerar respostas, sem danificar demais a qualidade. Isso ajuda a conseguir fazer um clone de ChatGPT como o Vicuna, rodar numa máquina caseira como a minha. Parece que minha RTX 3090 já é quase topo de linha, mas não. Por isso expliquei sobre a NVIDIA GH100 que é o tipo de hardware necessário pra rodar o ChatGPT de verdade.

  
  
  
  
  
  
  

Mas respondendo como um Vicuna de 13 bilhões de parâmetros consegue competir com um GPT 4 de 170 trilhões é porque além de quantização, os algoritmos de auto-atenção tem evoluído também. Em auto-atenção, que acontece no processo de treinamento, cada token numa sequência precisa ser considerado com todos os outros tokens pra capturar dependências e relacionamentos. Tipicamente, auto-atenção é computado dentro de uma janela de contexto, onde cada token é considerado com tokens vizinhos.

  
  
  
  
  
  

Agora tem uma variante chamada "auto-atenção global" onde cada token é considerado independente de posição ou distância, que permite o modelo capturar dependências num contexto mais global. Na prática é assim: custa mais caro pra treinar, mas os parâmetros resultantes no modelo tem mais qualidade. Então com menos parâmetros conseguimos chegar em respostas de qualidade similar. Entenderam? A qualidade de um parâmetro não é universal nem estático, está mudando à medida que aperfeiçoamos os algoritmos de treinamento e estruturas de dados.

  
  
  
  
  
  
  

Redes neurais, mesmo deep learning com auto-atenção global, ainda são representações rudimentares e grosseiras do nosso cérebro. Pra um GPT ou Vicuna da vida, conseguir escrever um texto com estilo de Shakespeare, precisamos treinar com todos ou quase todos os textos do Shakespeare. Pra conseguir gerar uma música parecida com Mozart, temos que dar o máximo de composições de Mozart quanto possível. O processo de treinamento vai encontrar patterns ou padrões e criar pesos pra eles, registrando no modelo. Mas isso ainda é bem ruim se comparado ao cérebro humano.

  
  
  
  
  
  
  
  

Pense você. Se estiver treinando em literatura ou música. Mesmo não lendo nem perto de todas as obras de Shakespeare, mesmo não estudando nem de perto todas as composições do Mozart, rapidamente consegue começar a copiar o estilo deles. Veja você como programador. Não precisou ler todos os códigos já feitos em React pra começar a escrever códigos. Bastou uns 2 tutoriais. Nosso cérebro consegue aprender muito melhor que um transformer, com muito menos dados, e produzir resultados similares ou melhores dentro de um mesmo determinado assunto. IA hoje em dia ainda depende muito de força bruta.

  
  
  
  
  
  
  

Desde que o LLaMA foi lançado em fevereiro de 2023, estamos só em junho e já temos dezenas de modelos diferentes, com vários níveis de quantidade de parâmetros, caindo desde 65 bilhões até só 7 bilhões, com vários tipos de otimização como GPTQ pra quantização, ou Float 16. E isso permite rodar algo parecido com esse meu Vicuna local, num Android ou até num Raspberry Pi. 








É o que eu acho ideal: um transformer rodando localmente, offline, sem compartilhar nenhum dado pessoal meu, nenhuma conversa, com nenhuma corporação por aí. Quanto menos dados meus eu tiver que dar pra alguém, melhor. Especialmente se esse alguém não me paga por isso. Pelo contrário, pra usar OpenAI eu preciso pagar assinatura. E sabe-se lá o que fazem com minhas conversas.

  
  
  
  
  
  
  
  

Bacana, significa que se o jornaleiro fala que o GPT 4 é próximo já de um ser humano, e os nerdolas das ciências da computação já compactaram e tornaram eficientes até esse ponto do VIcuna. Então já era. Tá fácil fazer a Skynet né? Afinal, GPT 4 já consegue escrever código de programação. Basta eu carregar o código do GPT 4 e mandar ele melhorar o código e gerar o GPT 5. Daí eu pego o novo GPT 5 e faço ele fazer uma versão melhor, o GPT 6, e assim sucessivamente, até eu ter o Gigachad GPT T-1000 Skynet que vai dominar o mundo, certo?

  
  
  
  
  
  
  
  

Errado. No final do dia, um GPT 5, 10, 20, continua não sendo mais que um auto-corretor do seu teclado em versão maior. Tirem da cabeça a noção de que é uma "inteligência". Ela não é inteligente. Tentar definir inteligência é um buraco de coelho profundo demais, vai ter gente masturbando filosofia aqui até o fim dos tempos e ninguém vai chegar numa conclusão. Vamos só assumir que até hoje não temos uma definição exata de "inteligência humana". Na verdade, quando chamamos de "inteligência artificial" só quer dizer que os resultados, pra um ser humano, podem "parecer" com algo inteligente, mas não que de fato "é" inteligente. Entendem a diferença?

  
  
  
  
  
  
  
  
  
  
  
  

Não ter uma definição exata é ruim, porque não temos um plano exato de pra onde ir. Na neurologia de verdade, apesar dos avanços, não temos uma receita exata de como neurônios e sinapses funcionam 100%. Temos uma boa idéia. Muita coisa ainda é especulativo. Mas podemos dar alguns chutes educados baseado em tudo que falei até agora. E aqui vai ser minha opinião pessoal. Se alguém tiver pesquisas que discordam, sintam-se à vontade pra linkar nos comentários abaixo. Opinião por opinião, cada um pode ter a sua. A maioria parece estar pulando rápido demais pra religião do AGI e eu vou ser advogado do diabo e dizer porque isso não está nem perto de acontecer.

  
  
  
  
  
  
  

Vocês entenderam até aqui? Quando vamos na interface Web do ChatGPT ou Vicuna ou qualquer outro derivado e escrevemos o tal do prompt, a pergunta, damos uns segundos, e ele nos trás uma resposta. Mas na realidade não é isso. O que vem na verdade é uma continuação do texto do prompt. Tem uma diferença importante aqui: ele não está tentando te responder. Acontece que com os parâmetros treinados do modelo, a probabilidade maior das próximas palavras é se parecer com uma resposta. Essencialmente o que está acontecendo é similar ao auto-corretor do teclado do seu celular: dado o texto que acabou de digitar, quais palavras tem mais probabilidade de serem continuação?

  
  
  
  
  
  
  
  

Entendam essa sutileza. Por isso falo que não é uma "inteligência". GPT ou Vicuna não são pessoas e nem entidades com cognição tentando se comunicar. É meramente um completador de textos, ou mais tecnicamente, um transformer pré-treinado generativo, um gerador de texto. Uma pergunta, ou prompt, é um texto que se digita na expectativa que o modelo consiga continuar completando. É por isso que o texto da resposta vai aparecendo aos poucos, não é uma animação arbitrária, é igual você ficar clicando na próxima palavra sugerida pelo teclado.

  
  
  
  
  
  
  
  

Um dos parâmetros que afeta essa continuação se chama temperatura. Nós não temos controle da temperatura do ChatGPT pela interface Web, mas no Bing da Microsoft tem esses controles de mais balanceado, mais preciso ou mais criativo. E no meu Vicuna tenho esse campo numérico. Novamente, do jeito que todo mundo escreve, parece que estamos configurando uma pessoa pra ser "mais criativa". Mas isso é só parte do showzinho. Um transformer não é mais ou menos criativo, ele é mais ou menos "aleatório". 

  
  
  
  
  
  

Temperatura controla a aleatoriedade do complemento de texto sendo gerado, o que você chama de "resposta". O modelo assinala probabilidades pra cada possível token, que são candidatos pra ser a próxima palavra na sequência. Alta temperatura, valores maiores do que "1.0", significa que o modelo assinala probabilidades similares a um conjunto maior de tokens. Se vários tokens tem probabilidades parecidas, as respostas podem variar mais quando se repete a mesma pergunta. Quanto maior a temperatura mais você vai "achar" que ele tá sendo mais criativo, mas também aumenta a probabilidade dele começar a dar respostas sem sentido.

  
  
  
  
  
  
  
  

Temperatura média, entre 0.5 a 1.0, é a resposta "balanceada" do Bing. Mesma coisa que alta temperatura mas ele assinala probabilidades similares pra um conjunto menor de tokens, controlando um pouco mais o que se perceberia como "criatividade". Baixa temperatura, que é abaixo de 0.1, faz o modelo assinalar probabilidades similares pra palavras que realmente tinham mais chances de ser o próximo token. Isso faz a resposta parecer mais focada, determinística, previsível.

  
  
  
  
  
  
  

Respostas sem sentido, muitos chamam de alucinação. Eu não gosto desse termo, porque implica que se alucinação é temporária nas respostas, então no resto do tempo ele está sendo sóbrio ou racional. E não está. Todas as partes das respostas foram geradas mediante probabilidades do modelo. Eu só ajusto a quantidade de de aleatoriedade nos candidatos pra próxima palavra. Nada mais, nada menos. Ele nunca alucina, assim como nunca é sóbrio. Ele não é uma entidade consciente pra ser nenhuma das duas, é só um programa obedecendo probabilidades armazenadas num modelo.

  
  
  
  
  
  
  

Entenda, no frigir dos ovos, "criatividade" no mundo de transformers, é só uma métrica de aleatoriedade. Não tem nada a ver com criatividade humana. Assim como inteligência artificial não tem nada a ver com cognição de verdade. Transformers, e todo tipo de machine learning ou deep learning, são meros sacos de probabilidades. Eles não tem de fato cognição pra pensar "huumm, os dados dizem que a probabilidade desse evento é X, mas realmente faz sentido? tem alguma coisa que eu não estou percebendo? Deixa eu parar pra pensar", que seria o que um ser humano inteligente consegue fazer. Transformers não refletem, só cospem exatamente o que as probabilidade do treinamento do modelo dizem pra ele cuspir, e nada mais.

  
  
  
  
  
  
  

Quando um transformer consegue pegar uma equação e achar a resposta, ou pegar até a planilha de balanço de uma empresa e dizer se está indo bem ou mau. Ela não está sendo inteligente. Simplesmente existem probabilidades no modelo que levam à resposta porque materiais que ele usou de treinamento tinham já a resolução de equações parecidas. 






Da mesma forma que eu disse que não existe um monte de "ifs" de regras gramaticais pra conseguir escrever textos, também não tem um monte de "ifs" de regras matemáticas pra fazer contas. Sempre volte à imagem daquela lista de pares de palavras e probabilidades do exemplo do teclado com auto-corretor. Aquilo é tudo que ele tem. Um conjunto gigante de probabilidades. Toda resposta que te dá, por mais inteligente que pareça, não teve nenhum tipo de raciocínio ou lógica ou inferência, nem nada, só probabilidades.
  
  
  
  
  
  
  

Um texto gerado por um transformer às vezes pode parecer "simpático". Se você for uma pessoa carente, vai parecer que o transformer responde se importando com você. Mas nada disso é intencional, é você projetando nele o que gostaria que ele fosse. Todo mundo faz isso com animais de estimação. Isso se chama "antropomorfismo". Você pode atribuir emoções humanas pra animais ou objetos inanimados. Tem gente que jura que uma escultura sorri pra ele quando passa na frente. Obviamente não. 

  
  
  
  
  
  
  
  

Um exemplo simples disso são nuvens no céu. Vira e mexe você olha pro céu e vê claramente uma escultura nas nuvens. Dependendo da sua inclinação ideológica poderia pensar. "Uau, Deus realmente é criativo, olha que obra maravilhosa nos céus que ele está me dando". Ou "Uau, a mãe natureza é especial, mãe Gaia continua a demonstrar sua genialidade criativa até nos céus". Ou "Uau, a droga que eu acabei de tomar é da hora ..." Só esse último pode estar certo.

  
  
  
  
  
  
  

O fato é que a nuvem em si não está em formato de nada. Se passar um avião por cima da mesma nuvem, não vai ver nada, ou vai ver outra imagem. Da posição que você está, na sua cabeça, suas sinapses pré-treinadas sugerem que você está enxergando  a sillhueta de algum objeto ou animal que já viu antes. É um efeito colateral da nossa cognição. Poderíamos chamar de bug. É seu cérebro primitivo. O cérebro rápido, automático e meio burro.

  
  
  
  
  
  
  
  

Ninguém moldou essa nuvem, ela aleatoriamente acabou numa determinada posição, que parece ter um determinado formato. Não houve intenção. Foi aleatório. Eu diria que a IA tá pouco se fodendo pra você, mas isso implicaria que ela tem consciência. Ela nem está se fodendo pra você. Ela não pensou em você. Mesma coisa com um transformer. Ela não tem consciência, ela simples é. Uma mera ferramenta. Uma chave de fenda que sabe cuspir palavras segundo uma matriz de probabilidades. Nada mais, nada menos. Por acaso você está olhando pra chave de fenda e achando que está sorrindo pra você. Não está. Isso diz mais sobre seu estado emocional do que sobre a ferramenta.

  
  
  
  
  
  
  
  

Significa que ela não tem insights, não tem momento "eureka" de descobrimento de coisas novas. Ela só é capaz de sugerir uma palavra, depois das outras palavras que vieram antes, seguindo uma tabela de probabilidades que vieram do treinamento feito com gigabytes de texto. De vez em quando, dá impressão que ela "criou" algo que não existia, mas não é criação, é aleatoriedade, pura sorte. É a nuvem no céu. Não é um processo repetível e ela não sabe refletir algo como "uau, isso que eu inventei é da hora, nunca tinha visto antes". Ela não tem emoções pra conseguir dizer "uau".

  
  
  
  
  
  

Se você der o código de uma IA feita com RNNs como falei antes pro GPT 4 analizar, ela não vai magicamente conseguir chegar no paper de transformers. Se esse paper não estava no material de treinamento, ela não vai concluir sozinha que esse era o próximo passo. Portanto ela é incapaz de conseguir chegar num GPT 5. Novas descobertas precisam ser feitas por humanos, documentadas, alimentadas no treinamento da IA e só aí ela vai saber cuspir o texto desse paper. Ela é incapaz de usar o que aprendeu pra gerar descobertas novas de forma intencional. 

  
  
  
  
  
  
  

Existe uma historinha que é chamado do Teorema dos Macacos Infinitos. O teorema sugere que se tivermos um macaco apertando teclas numa máquina de escrever por uma quantidade infinita de tempo, quase com certeza vai conseguir digitar qualquer tipo de texto, incluindo todas as obras do Shakespeare. Na prática, estamos falando de uma quantidade tão absurda de tempo que seria impossível até de vocês terem noção, estamos falando provavelmente de mais tempo que a idade atual do Universo desde o Big Bang. Mas é um conceito que demonstra que sim, sem nenhuma inteligência, só com aleatoridade, dado um tempo absurdo, uma hora tudo que já produzimos vai aparecer. Sem nenhuma intenção, só via aleatoriedade.

  
  
  
  
  
  
  

É uma história pra dar noção de conceitos como infinito e aleatoriedade. Essa história é creditada ao matemático francês Felix Émile Borel, de 1913. Ou seja, desde o começo do século XX já se tinha essa noção que muitos de vocês, mais de um século depois, ainda estão com dificuldades de entender. GPT e derivados são macacos modernos dessa história. Só que em vez de totalmente aleatório, demos um modelo de probabilidades pra facilitar o trabalho dele, só isso. Mas chamar de macaco é meio ofensivo, pro coitado do macaco, que ainda é mais inteligente que qualquer IA. 

  
  
  
  
  
  

Falando em século passado. Deixa eu aproveitar pra voltar lá atrás na história das inteligências artificiais. O estudo de algoritmos e técnicas que contribuem pra esse campo existe desde os anos 50 pelo menos. Mas nos anos 70 surgiu um programa que até hoje ainda deixa os desavisados meio surpresos. O nome do programa é Eliza. Existem várias versões, inclusive rodando online. Dêem uma olhada.

  
  
  

(... screencast eliza ...)

  
  
  
  
  

Como podem ver, é um chatbot também, que nem o ChatGPT. E parece uma pessoa bem desconfiada, fica dando umas respostas meio grossa. Weebs de anime chamariam ela de "tsudere". Mas se hoje povo fica empolgado com ChatGPT respondendo, imagina isso nos anos 70. Só pra dar contexto, isso é antes da revolução dos microcomputadores de 8-bits como Commodore ou Apple II. Isso é antes da Microsoft ou Apple existirem. Nem internet existia ainda. Quando eu rodei uma versão de Eliza pra DOS lá no começo dos anos 90, lembro que fiquei fascinado e pensando como eu faria a minha própria versão. E aí vocês podem se perguntar, "caraca, mas como era possível ter isso nessa época??"

  
  
  
  
  
  
  

Bom, quem faz ciências da computação ou programa um pouco, já deve ter entendido o funcionamento. O modelo é super simples. É baseado inteiramente em pattern matching. Basicamente encontrar palavras-chave, ver se tem uma resposta pré-programada, e montar essa resposta, na mão. É um sistema de templates. Quando eu digo "na mão", aqui sim, ao contrário de modelos de transformers, é realmente um monte de "ifs". Quem já montou agentes ou robozinhos, tanto de chat de suporte ou email marketing, já fez coisa similar pra respostas automáticas. É um bom exercício de faculdade pra iniciantes.

  
  
  
  
  
  

No GitHub vai achar várias versões. Veja esta, é uma versão feita em Java. E vamos ver o tal "modelo" entre aspas. É uma lista de chaves e valores, e os valores, como podem ver, são frases pré-prontas. Por exemplo, se durante o chat você se desculpa e escreve algo como "I'm sorry", ele quebra essa string, encontra a palavra "sorry" e nesta lista olha só, tem 3 respostas pré-programadas. Ela pode te responder "Por favor, não se desculpe" ou "Desculpas não são necessárias". E vai escolher aleatoriamente, pra não parecer que tá se repetindo.

  
  
  
  
  
  
  
  
  

Só isso já é suficiente pra passar no Teste de Turing, que é um teste feito pra identificar quando uma inteligência artificial consegue enganar um ser humano numa breve conversa. Eliza é a avó espiritual do ChatGPT. Mas o ponto em apresentar a Eliza é pra vocês verem que pra enganar seres humanos, não precisa  muito. Por alguma razão, nós seres humanos, somos muito fáceis de enganar e somos propensos a acreditar em qualquer coisa. Acho que somos animais com fé excessiva. É um ponto forte, mas é um enorme ponto fraco também. Eu pessoalmente sou cético, mas aí me chamam de "do contra", vai entender. Vou continuar não sendo o trouxa, só isso.

  
  
  
  
  
  
  
  

Um ChatGPT, se eu quisesse simplificar bastante, não é muito diferente da Eliza, em conceito. É um programa que usa um modelo, um dicionário de probabilidades, que mostra frases de acordo com o que se digitou antes, roboticamente, automaticamente, pegando palavras cujos valores de probabilidade fazem mais sentido dado as palavras anteriores. Não existe nenhuma emoção envolvida. Não existe simpatia, não existe compaixão, não existe amargura. Nada. Não tem uma linha de código, nem de dados no modelo, que representam qualquer emoção. É apenas uma calculadora, que em vez de devolver números, devolve conjuntos de palavras. Só isso.


  
  
  
  
  

Mas e as IAs que geram imagens inéditas? Vide o próprio Dall-e 2 da OpenAI, vide o Midjourney, vide o Stable Diffusion, vide os novos plugins de geração e ajustes de imagens proprietário da Adobe, que começaram a ser distribuídos no Creative Cloud. Classificação de imagens e geração de novas imagens são campos diferentes dentro de inteligência artificial. Só pra não perder o gancho, deixa eu jogar na mesa mais alguns conceitos.

  
  
  
  
  
  
  

Um campo que existe desde pelo menos os anos 80 é o estudo sobre CNNs. (piada) Não, não, não é esse, é um CNN útil. Convolutional Neural Networks, que é um modelo que dizem que é bom pra processar dados que se parecem com grades, como uma grade de pixels, que é como representamos uma imagem. As tais camadas convolucionais, não sei se é assim que fala em português, aplicam vários filtros ou kernels, aos dados de pixels pra criar um mapa de funcionalidades. 

  
  
  
  
  
  

Em resumo, esses filtros extraem características da imagem. O equivalente a tokenizar um texto e gerar palavras ou n-grams. Mas CNNs ficaram super famosos só depois de 2012 quando saiu a AlexNet de Alex Krizhevsky, Ilya Sutskever e Geoffrey Hinton. (piada) Arregacei os nomes, mas beleza. Era um concurso que todo ano o vencedor ficava um pouco melhor do que o do ano anterior. Mas em 2012, o salto foi uma ordem de grandeza melhor. Não lembro os números, mas faz de conta que todo ano os melhores algoritmos conseguiam identificar 85% das imagens, no ano seguinte, 86%, aí do nada deu um salto pra 99%. Isso gerou um enorme interesse na comunidade de pesquisa em cima de classificação de imagens.

  
  
  
  
  
  
  
  

Em paralelo, em 2014 surgiu o conceito de GANs, Generative Adversarial Networks ou redes generativas adversárias, desenvolvido pelo Ian Goodfellow e seus colegas. Foi um avanço no conceito de geração de imagens. De forma simplificada é como se fossem duas IAs uma competindo com a outra. Um gerador cria imagens e um discriminador avalia. Por exemplo, digamos que quero gerar imagens de gatos, o gerador faz as imagens, e o discriminador tenta identificar se é um gato mesmo. É um sistema que acelera o processo de aprendizado por fornecer feedbacks mais rápidos do que um treinamento supervisionado por humanos.

  
  
  
  
  
  
  
  

CNNs e GANs eu mencionei mais pra vocês saberem alguns nomes importantes. Mas o Dall-e da OpenAI não usa GANs, ele usa um derivado do modelo de transformers do GPT só que aplicado a imagens. Assim como geração de respostas de texto, onde ele vai prevendo uma palavras após a outra, levando o contexto anterior em consideração, o Dall-e também usa uma arquitetura de transformers, criando imagens um pedaço atrás do outro. Ou seja, também usa mecanismos de auto-atenção em vez de camadas recorrentes ou convolucionais tradicionais.

  
  
  
  
  
  
  

Essa não é a única forma de se criar um gerador de imagens. Mais do que o Dall-e, que é fechado, eu gosto mais do Stable Diffusion que, assim como o LLaMA da Meta, também foi liberado publicamente como modelo aberto. Quem me acompanha no Instagram viu quando eu fiquei brincando de usar o Stable Diffusion com outras ferramentas abertas pra fazer remasterização, upscaling de video. Assim eu pegava um video super antigo com qualidade de DVD e conseguia fazer ele redesenhar uma versão 4K. Se não viu isso, veja o destaque "Usando IA" no meu Insta. Enfim, diferente do Dall-e que usa transformers, o Stable Diffusion, como o próprio nome diz, usa um modelo de difusão.

  
  
  
  
  
  

Esse modelo gera imagens simulando um processo aleatório rodando em reverso, ou seja, o processo de geração começa com uma simples distribuição, como um Gaussian noise, literamente um gerador de barulho aleatório mesmo, e vai gradualmente refinando esse barulho, passo a passo, até chegar numa imagem que parece com os dados que o modelo foi treinado. É meio como partir de um punhado de argila, tudo bagunçado, e passo a passo ir esculpindo e refinando, até chegar numa estátua. Esse processo de refinamento é dirigido por uma rede neural que aprende a predizer o próximo passo da difusão. E por isso se chama Stable Diffusion, ou Difusão Estável.

  
  
  
  
  
  
  

Um site que parece que tem ganhado relevância na comunidade de pesquisa e desenvolvimento de ferramentas e modelos de IA, é o HuggingFace. Ele serve como um repositório. É de lá que podemos baixar os modelos do LLaMA, Alpaca, Vicuna em todos os diferentes tamanhos e formatos. Existem modelos específicos pra texto como o Vicuna, específico pra imagens como o do Stable Diffusion, conversor de texto pra áudio como o Speech T5 do Facebook e muitos outros. O ponto é que não existe uma única inteligência unificada que faz tudo, existem modelos isolados e independentes feitos pra tarefas específicas. Um GPT não sabe converter texto em áudio, isso é outro modelo.

  
  
  
  
  
  
  
  

Portanto, quando ver produtos web que parecem uma única inteligência, não é, é um integrador que divide o que você pediu entre diversas inteligências diferentes. O que me leva a outro tema que queria tocar de leve, mesmo porque só comecei a estudar isso recentemente. Eu expliquei como as coisas funcionam, superficialmente, por baixo dos panos. Mas agora precisamos falar do que fica por cima dos panos, o que usuários normais como eu e você enxergam, a interface.

  
  
  
  
  
  
  

Não só interface gráfica web de chat, mas interface de APIs e tudo mais. Surgiu um framework que tem ganhado cada vez mais relevância na comunidade que está investindo pra construir ferramentas integradas com os diversos serviços de IA que mencionei, como GPT, Bard, Stable Diffusion e outros. Esse framework se chama LangChain. A grosso modo, pense um framework como Django, ou Laravel, ou Rails, ou Spring, mas feito pra construir aplicativos que usam IA.

  
  
  
  
  
  
  

Eu gostei particularmente da documentação. Pra um projeto de código aberto novo, tem material suficiente de estudo, incluindo pesquisa de papers acadêmicos sendo publicados agora. Em particular queria tocar no ponto de prompts. A moda dos parasitas sangue-suga agora, é criar cursos online de prompts. Já viram por aí? "Vire um Engenheiro de Prompt". É a coisa mais idiota que já vi. 







Seria o equivalente a você se chamar de "Engenheiro de Pesquisa no Google". Já deixo a dica pra você: não faça nenhum deles. Sem nem olhar, posso garantir que quase todos são pega-trouxa. Lembra aquele ditado? Todo dia um malandro e um otário acordam e vão pra rua, e quando se encontram, rola negócio. Não seja o otário.

  
  
  
  
  
  

Enfim, o LangChain é um framework extenso. Não pense algo simples como um Express de Node.js. Isso tá mais pra um Spring de Java. Tem diversos conceitos, como Models pra interfacear com os diversos serviços de IA, como o ChatGPT. A grosso modo esses Models seriam como um Hibernate, um ORM pra IAs. Mas tem outras abstrações. Tem Agentes. Tem Correntes. Tem Índices, mas uma das partes interessantes é que tem Prompts.

  
  
  
  
  
  

Diferente desses cursinhos idiotas por aí, que ficam mais no esquema "olha só, eu testei uns prompts aqui e vou compartilhar com vocês" ou então povo que fica copiando teorias da conspiração de prompt que surgem no Reddit. De fato existem pesquisas acadêmicas sendo feitas no estudo das melhores formas de se fazer perguntas pra passar pra um transformador generativo como GPT. Lembram o que eu falei? Os transformers só continuam adicionando palavras na frente do prompt que você escreveu. Quanto melhor escrito for o prompt, maiores as probabilidades de se conseguir as respostas que procura. Ele vai conseguir prever melhor as palavras seguintes.

  
  
  
  
  
  
  

O melhor prompt não é escrever um textão aleatório, mas sim conciso e estruturado. Na documentação eles fazem links pros diversos papers acadêmicos com o estudo pra cada tópico. Eu não levaria 100% a sério, nem todos os papers são consenso, muita coisa é só teoremas e hipóteses. Mas é melhor do que chutes do YouTuber. 


  
  
  
  
  
  

Com um LangChain, eu poderia fazer um Model que se integra com o meu Vicuna rodando localmente, daí poderia não depender de serviços de terceiros e também manter a privacidade dos meus dados, já que não preciso compartilhar nada com ninguém. Se alguém tiver interesse de estudar, pesquisar ou até empreender com essa nova geração de transformadores, essas são ferramentas que podem ser muito úteis. Esquece curso idiota que é "duh, olha só como sou inteligente, sei integrar com a API da OpenAI". Sério, isso é o básico do básico do básico, você aprende em 10 minutos num blog post. Não tem absolutamente nada demais. 

  
  
  
  
  
  
  

Aliás, um curso de IA que se preza, tem por obrigação ter tudo que eu falei neste vídeo, só que explicado com 10 vezes mais detalhes. Caso contrário não vale seu dinheiro e muito menos seu tempo. Não perca tempo com esses cursos caça níquel. São todos perda de tempo. Veja os links que deixei na descrição do video e estude um a um que no final você vai aprender muito melhor, e de graça. O hype em torno de IA está fora de proporção. Um prato cheio pros oportunistas de plantão.

  
  
  
  
  
  
  

Pra finalizar, acho que vale a pena voltar na questão que incomoda todo programador iniciante: "mas será que com essa evolução rápida de transformers, não é questão de tempo até ele substituir todos os programadores?". Eu já tinha feito um video só pra responder isso e recomendo que assistam, mas considerando o que expliquei hoje, vou explicar porque, tecnicamente, isso não vai acontecer.

  
  
  
  
  

Primeiro. Um transformer é incapaz de gerar textos sobre assuntos que nunca viu na vida. Isso é importante de entender. Vamos recordar, o que é um modelo, é um banco de dados de tokens retirados dos textos de treinamento e mais importante: as probabilidades de um token pra outro token dentro de uma rede. O modelo não contém o texto original, só pesos.  








Vou repetir porque isso é importante: nenhum texto original aparece na sua forma original, dentro do modelo. Pra ter na cabeça pense assim. Já viram que vários livros no final tem algumas páginas com um "índice remissivo"? São todas as palavras importantes que aparecem no texto do livro e as páginas onde aparecem. É que nem um índice rudimentar de banco de dados.

  
  
  
  
  
  
  

Quando fazemos um prompt e pedimos, sei lá, pra ele citar um trecho da peça King Lear, de Shakespeare. Vai gerar o trecho, se não igual, muito próximo ao trecho do texto original. E isso confunde, pois parece que então, ele tem o texto inteiro guardado em algum lugar. Mas não. Por exemplo, pedi pra ele citar um diálogo entre Albany e Cordelia e corretamente diz que não existe diálogo entre os dois na peça, e sugere outra cena, Ato 4, Cena 2, onde Albany fala com sua esposa Goneril. E segue o trecho exatamente como está na peça. 

  
  
  
  
  
  
  

Novamente, é muito difícil traçar o caminho exato dentro do modelo, indo de probabilidade em probabilidade pra reverter o processo e descobrir como o GPT conseguiu escrever o texto. Mas podemos dar um chute educado: a sequência de palavras do diálogo tem altíssima probabilidade. Primeiro, no meu prompt tem todas as palavras-chave importantes pro contexto como "Shakespeare", "Albany" e tudo mais. 







Quando ele começa digitando o trecho "You are" no contexto to diálogo, a chance maior é da próxima palavra ser "not", depois da palavra ser "worth", depois ser "the" e depois "dust". São as probabilidades mais altas dessa sequência. Ele não tem o texto original, mas tem as probabilidades, que permitem remontar uma boa parte do texto original.

  
  
  
  
  
  
  

Até certo ponto, a grosso modo, o modelo acaba servindo como uma versão comprimida dos textos originais, mas com perdas. Quebramos todos os textos em tokens e gravamos os relacionamentos de forma que é possível recuperar alguns desses textos. Mas não podemos garantir que é possível recuperar tudo, porque a mistura de alguns textos similares vai desajustar as probabilidades. 






No final teríamos no máximo uma versão mesclada de dois ou mais textos. Quanto mais repetidas vezes um determinado texto aparece em diversas fontes no material de treinamento, maiores as chances de conseguir reconstruir depois. Shakespeare, tendo obras que foram analisadas, discutidas e citadas inúmeras vezes em várias fontes, tem maiores chances de ser reconstruído.  

  
  
  
  
  
  
  

Sobre mim, Fabio Akita, já vai ser mais difícil, porque no contexto geral da Web, eu sou extremamente pouco citado. Mesmo assim, o GPT 4 até que consegue fazer uma descrição super genérica sobre mim. Fala coisas certas, por exemplo, que sou brasileiro, que fundei a CodeMiner, que palestrei em eventos e ajudei a divulgar Ruby on Rails. Mas aí fala que também ajudei a divulgar metodologias Ágeis, que não é mentira, mas nunca foi um ponto importante. 







Ele fala que fui "keynote speaker", ou seja, que dei palestra de abertura em muitas conferências, o que não é verdade. Ele já começou a misturar informações de outras pessoas similares. Mas isso não é acidente, é porque comparado a um Shakespeare, não tem quase nada sobre mim na Web, e as probabilidades são muito parecidas com outros palestrantes de tecnologia da mesma área.

  
  
  
  
  
  

Por isso também é difícil pra ele citar fontes exatas, porque cada palavra do texto que gera pode ter vindo de um lugar diferente. Não tem como saber exatamente. Pra ter links pra fontes, como o Bing faz, especulo que precisa de um processo em duas ou mais etapas. Primeiro, gerar o texto da resposta, como um GPT faz. Depois, pegar esse texto e fazer uma pesquisa tradicional no Bing antigo. Daí cruzar as duas informações e ver se os textos minimamente batem, e finalmente apresentar juntas, como se a resposta já tivesse saído pronto com os links pras fontes. 

  
  
  
  
  
  

Não é o transformer que dá os links, é um segundo processo separado. Porque o modelo do transformer, em si, não tem como garantir exatamente qual parte veio de onde. Quanto mais um certo assunto tiver textos pra treinar, mais precisas vão ser as respostas. Por isso é mais fácil conseguir informações sobre celebridades, do que sobre alguém como eu ou vocês. No nosso caso, nossas informações vão ser misturadas com de outras pessoas similares, porque as probabilidades não vão ajudar. 

  
  
  
  
  
  
  

Lembra a temperatura de "criatividade"? Ela garante que, mesmo sem saber a resposta exata, o ChatGPT vai continuar tentando responder baseado nas probabilidades que tem no modelo atual. Mas não tem jeito, toda resposta sobre coisas que não tinha no material original de treinamento, ou tinha muito pouco, vai ser uma alucinação probabilística. Só isso. E vai estar errado. E isso vai acontecer com tudo que for novidade. No dia 1, todo transformer vai ser praticamente inútil. 

  
  
  
  
  
  
  

Outra coisa, mesmo sendo capaz de ler código, explicar código dos outros e gerar códigos, ainda não vai ter a capacidade de gerar um projeto inteiro. Lembra os códigos vazados do Twitch ou o código de ranking do Twitter que eu analisei? Estamos falando de milhares de arquivos, centenas de milhares de linhas de código. Sabe qual é um dos calcanhares de aquiles de toda IA? Backtracking e memória. As respostas costumam ser boa hoje porque ele leva em consideração o texto anterior. Em partes.

  
  
  
  
  
  
  

Existe um limite de quanto consegue voltar atrás no texto anterior. No caso do GPT 3 e 4 atual, ele se limita a enxergar uma janela de contexto de no máximo 2048 tokens. E as respostas também tem um limite. Quanto mais longo for esse limite, mais caro fica pra processar o resultado seguinte do gerador de palavras, maiores as chances dele começar a "esquecer" o contexto e muito maiores as chances de rapidamente perder a coerência de respostas longas. 







Entendam: o GPT atual não tem capacidade de ler mais que 2048 tokens. Então jogar o código inteiro da kernel do Linux pra ele analisar, por exemplo, é impossível. E pedir pra ele escrever um código desse mesmo tamanho, é mais impossível ainda. Lógico, nada é impossível, mas é altamente improvável. No meu Vicuna rodando local, tem essa tela de configuração pra justamente configurar o tamanho da janela de contexto e de resposta. E não é um número muito grande não,

  
  
  
  
  
  
  
  

Num teste não científico, tentei abrir duas janelas do projeto text-generation que é a interface web que estou usando em cima do Vicuna. Não sei se é uma precaução da interface web ou uma limitação do próprio Vicuna por baixo, mas só tem capacidade de responder uma pergunta de cada vez. Se eu abrir outro navegador e tentar fazer outra pergunta, enquanto na outra janela ele ainda não terminou de responder a primeira, vai ignorar e não deixa rodar em paralelo.

  
  
  
  
  
  
  

E mesmo se conseguisse. Só com um único processo de resposta, está consumindo, no mínimo, 50% da minha GPU, consumindo mais de 18 gigabytes de VRAM, e enquanto responde esse consumo continua aumentando. Ou seja, numa máquina como a minha, ele só consegue responder uma pergunta de cada vez. Você está pensando em fazer um serviço online, SaaS, pra vários usuários acessarem? Vai sair super caro, porque só vai possibilitar uma resposta a cada 2 a 5 segundos. Um servidor web pequeno tem capacidade pra responder, sei lá, 1000 requisições por segundo ou mais. Mas um Vicuna está mais pra 0.2 requisições por segundo. É ridiculamente pesado e não escala.

  
  
  
  
  
  
  

Não lembro que artigo que a OpenAi falava que cada dia de operação do ChatGPT custa 1 milhão de dólares. Sim, 1 milhão, por dia. Mais ou menos faz sentido, dado o custo de GPU necessário pra responder todo mundo. Mas claro, novas técnicas de otimização tem aparecido, como o exemplo de quantização que expliquei antes, mas estamos falando que precisa melhorar ainda umas 10 mil vezes pra ficar economicamente viável pra casos como escrever um livro inteiro de 500 páginas, sem perder coerência, ou escrever um projeto de verdade com milhares de arquivos de código. No estágio atual da tecnologia, isso é impossível.

  
  
  
  
  
  

Essas são só algumas das razões de porque um ChatGPT não vai substituir programadores e outras profissões. A partir de um certo ponto fica tão caro que não compensa, especialmente porque como já expliquei, essa ¨inteligência" não é inteligente, só cospe probabilidades. Não tem criatividade, não sabe tomar decisões baseadas em coisas como custo-benefício ou bom senso. Não vai ter coerência em respostas longas, não tem noção se o código sendo cuspido tem segurança, ou escalabilidade. Ela tem memória menor que um peixinho dourado. 2048 tokens. Mesmo se aumentar 10x esse limite, ainda é super pouco. O script deste episódio tem 15 mil palavras. O ChatGPT é incapaz de escrever meus scripts.

  
  
  
  
  
  
  

Mas tudo bem, como uma ferramenta de auxílio, é super boa. Trechos pequenos e repetitivos, ou código trivial que facilmente encontramos num stackoverflow repetidas vezes. O estado atual de transformers é mais que suficiente pra acelerar um bom profissional. Hoje é impossível e vai continuar sendo impossível alguém que não é programador conseguir fazer um projeto complexo inteiro. Qualquer um que diga o contrário não tem a menor noção do que está falando. Considere como os algoritmos funcionam e considere os pontos de máximo e mínimo. Não basta dizer "ah, eu tenho esperança, é só ter fé". Precisamos de números e os números dizem que é extremamente improvável.

  
  
  
  
  
  
  
  

Eu uso o GitHub Copilot faz meses. Em vários videos, toda vez que aparece trechos de código, usei a ajuda do ChatGPT ou Copilot. Ambos tem plugins pra vários editores como NeoVim ou VS Code e funcionam super bem. Tem capacidade de ler o código do arquivo que se está editando. Não consegue usar o projeto inteiro de contexto pelos limites que acabei de explicar, mas só de usar o trecho próximo do que está digitando, já ajuda muito. Ou seja, parte do prompt é o código do arquivo aberto naquele momento. 

  
  
  
  
  
  
  
  

Pra mim, vale cada centavo. E todo desenvolvedor que quiser ter vantagens de produtividade, deveria considerar usar esses plugins. De novo, não vai conseguir fazer tudo pra você, e por causa da aleatoriedade e alto risco de alucinações, você nunca deve aceitar o código que ele sugere sem ler com muita calma antes. Mas pra tarefas bem braçais, tediosas, onde faríamos muito copy e paste, como fazer testes unitários simples, ajuda. Testem.

  
  
  
  
  
  
  

Com tudo isso que expliquei, minha conclusão pessoal é que não estamos nada perto do que o povo chama de AGI, ou Inteligência Artificial Geral. A IA que vai superar todas as IAs. A IA que vai pegar o código inteiro do GPT 4 e sozinho gerar um GPT 5 melhorado. O coitado male male tem capacidade de lembrar de um único arquivo de código, que dirá milhares. Mesmo se conseguisse, ele não estará "analisando". Ele não analisa nada. Ele não sabe analisar. Não sabe as regras de cálculo, as regras de programação. Só sabe juntar pedaços que viu repetidas vezes de muitas fontes, 100% via probabilidades. Quando não sabe, vai pegar as probabilidades mais próximas e cuspir o que der, e vai ser um texto sem sentido nenhum.

  
  
  
  
  
  
  

Vou repetir: transformers não tem inteligência nenhuma de análise e cognição. Ele não sabe porque 2 mais 2 é 4, só leu muitas vezes que é, e as probabilidades fazem ele repetir isso. GPT quer dizer Transformer Generativo Pré-Treinado. Hoje você entendeu o que esses termos significam. E se ficou até aqui, espero que tenha entendido: por mais impressionante que pareçam os textos que gera, é só um gerador de textos, um auto-corretor de teclado de celular glorificado. 






Um gerador de textos nunca vai ser inteligente. Só vai "parecer" inteligente. Assim como o formato de animal que você viu numa nuvem foi totalmente um acidente. Ninguém teve a intenção de desenhar um animal na nuvem, sequer é um animal, é só um formato aleatório. Foi você que escolheu entender assim. 

  
  
  
  
  
  

E foi por isso que no outro episódio de ChatGPT eu afirmei e repito: Seu grau de empolgação com IA é inversamente proporcional ao seu entendimento de IA. Quanto menos entender, mais empolgado vai ficar. Vai acreditar que as ações da NVIDIA estarem a mais de 400 dólares é normal, porque acredita que negócios de IA vão aumentar absurdamente e em breve a ação vai atingir 1000 dólares. Vai investir todo seu dinheiro nisso. Já eu, acho que a ação da NVIDIA está hiper valorizado por puro hype. O preço justo da ação deveria ser abaixo de 300 dólares, e vai voltar pra isso uma hora. Não sei quando vai estourar, mas eu estou precavido.

  
  
  
  
  
  
  

Não tenho dúvidas que transformers são úteis. Várias ferramentas já estão usando. Em particular o Creative Cloud da Adobe tá tirando bom proveito. A Microsoft vai embutir em Office, Windows e tudo mais. Mas no final é isso que vamos ter: um Alexa melhorado. Um template mais inteligente de Excel. Mas não ache que vai substituir seu Diretor Financeiro e que ele vai conseguir tomar decisões inteligentes. Só parece, por sorte e por acidente. Quem apostar em mais do que isso, nas tecnologias atuais, vai perder.

  
  
  
  
  
  
  

Pessoalmente eu acho que as tecnologias de transformers e outras que nem mencionei hoje que compõe o que é o GPT, assim como tudo, segue uma curva em S. Passamos pela parte do S que é o crescimento que parece exponencial, mas a curva tem um teto em cima. Quando pulamos de bilhões de parâmetros pra trilhões de parâmetros, vamos começar a ter retornos diminuídos, diminishing returns. Se amanhã sair um GPT 5 com o dobro de parâmetros, sei lá 300 trilhões, não vai ficar duas vezes melhor. Talvez melhore sei lá, 20%. Cada melhoria custa mais caro do que o retorno. Isso é diminishing returns. 

  
  
  
  
  

Não existe crescimento infinito, e quanto mais rápido você força, só chega mais rápido no teto. Precisa acontecer novas descobertas, novas invenções que ainda não conhecemos, obviamente, pra ter uma nova etapa de evolução significativa. Enquanto isso não acontecer e só insistir no que temos até hoje, não vai ser muito melhor que isso não. Já estamos perto do limite. E AGI não está no horizonte ainda. É a mesma coisa ficar especulando se estamos pertos de conseguir construir uma USS Enterprise. É irrelevante, beira ficção científica.

  
  
  
  
  
  
  

Acho que já me estendi demais. Como falei no começo do video, eu não sou nem de longe um especialista no assunto, sequer tenho experiência prática de trabalhar em projetos relacionados. Meu conhecimento até agora é puramente teóricos. Eu só pesquisei o que existe publicado online. Se eu entendi até aqui em poucos dias, quem dedicar algumas semanas vai acabar sabendo muito mais do que eu, muito rapidamente. Não é tão difícil assim. Espero que tenha dado pra quebrar alguns mitos que tinham na cabeça e finalmente tenham conseguido separar o joio do trigo. Se ficaram com dúvida ou quiserem complementar, fiquem a vontade nos comentários abaixo. Se curtiram o video deixem um joinha, assinem o canal e não deixem de compartilhar o video com seus amigos. A gente se vê, até mais.
