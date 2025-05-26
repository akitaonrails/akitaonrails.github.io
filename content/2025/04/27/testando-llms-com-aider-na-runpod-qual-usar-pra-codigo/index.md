---
title: Testando LLMs com Aider na RunPod - qual usar pra código?
date: '2025-04-27T11:30:00-03:00'
slug: testando-llms-com-aider-na-runpod-qual-usar-pra-codigo
tags:
- runpod
- aider
- gemini
- qwen
- deepseek
- ollama
- llm
draft: false
---

Seguindo meu post [sobre Aider](https://www.akitaonrails.com/2025/04/25/seu-proprio-co-pilot-gratuito-universal-que-funciona-local-aider-ollama-qwen) e agora que você entende como LLMs funcionam pra código, resolvi experimentar rodar alguns modelos na minha própria máquina.


O setup é muito simples. Com Aider e Ollama instalado, primeiro temos que subir o ollama (eu subo manualmente, você pode criar um serviço de systemd pra subir automaticamente):

```
OLLAMA_FLASH_ATTENTION=1 ollama serve
```

Tanto pro Aider quanto o cliente do Ollama enxergarem o servidor, é bom colocar isso no seu `.bashrc` ou similar no seu OS:

```
export OLLAMA_HOST=http://localhost:11434
export OLLAMA_API_BASE=http://localhost:11434
``` 

**ATENÇÃO:** levei um tempo pra descobrir porque o Aider falhava às vezes e foi porque eu não prestei atenção e às vezes eu esquecia uma "/" no final dessa URL. Não pode acabar em "/", tira, senão vai dar pau na hora de montar a URL.

A única opção que experimentei mexer (tem várias, veja documentação), foi forçar ligar Flash Attention (lembram o que expliquei sobre Sliding Window Attention?). Não sei se realmente faz diferença e não necessariamente todo modelo suporta, mas vamos lá. Com o server de pé, podemos fazer download de alguns modelos:

```
ollama pull qwen2.5-coder:14b
```

E feito isso, a partir do diretório de algum projeto de código, podemos ligar o Aider pra ficar monitorando quando você salva algum arquivo (daí ele carrega no contexto do chat, procurar por um comentário com "AI!" e manda pro modelo conseguir fazer o que foi pedido):

```
aider --watch-files --model ollama_chat/qwen2.5-coder:32b --verbos
```

A opção `--verbose` é opcional, mas no começo é bom deixar ligado. Dá pra ver quais prompts exatamente o Aider está mandando. Diferentes modelos reagem um pouco diferente a diferentes prompts. É bom prestar atenção nisso: a mesma pergunta pode ter respostas bem diferentes, em diferentes modelos. I.A. não dá respostas absolutas, ele dá "uma" resposta. E nem sempre é a certa, aliás, **muitas** vezes tá errado. Acostume-se com isso, é um gerador de texto com componente de entropia: ele **NUNCA vai ser "100% certo, 100% do tempo"** , é uma limitação da arquitetura toda, não importa quanta otimização se faça.

### Macs pra LLMs?

Enfim, minha máquina tem uma Ryzen 9 7940X3D com RTX 4090 de 24GB de VRAM. Pensei _"Hm, será que roda o Qwen de 32B parâmetros?"_ e fui testar. No primeiro teste tive este comportamento:

![CPU alto GPU baixo](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBb0VCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--60274d2b5de21b0601441c0e2ee06d26022bc206/Screenshot%20From%202025-04-27%2001-28-34.png?disposition=attachment&locale=en)

Cocei bastante a cabeça com isso: minha CPU ficava constante consumindo 50% o tempo todo, mas a GPU estava em idle maior parte do tempo e dava pequenos picos curtos de uns 20%. O certo seria o oposto. Depois de muito pesquisar e testar, minha conclusão foi a seguinte:

```
OLLAMA_FLASH_ATTENTION=1 OLLAMA_CONTEXT_LENGTH=8192 OLLAMA_KV_CACHE_TYPE=f16 OLAMA_NUM_THREADS=25 OLLAMA_NUM_GPU=60 ollama serve
```

Primeiro, tentei várias configurações no Ollama. Uma delas, o `OLLAMA_RUN_GPU` tenta limitar quantos layers do modelo vão ter offload na VRAM. É mais uma sugestão que um número absoluto. O modelo Qwen de 32B tem 65 layers. O máximo que consegui fazer ele carregar foram uns 48 layers, mexendo nesse parâmetro. Isso subiu o consumo de VRAM da foto de 17GB pra 21GB.

Mesmo assim a CPU estava pesada. E a resposta vem quando olhamos os detalhes do modelo com o comando `ollama show qwen2.5-coder:32b`:

```
❯ ollama show qwen2.5-coder:32b
  Model
    architecture        qwen2
    parameters          32.8B
    context length      32768
    embedding length    5120
    quantization        Q4_K_M
```

Ele suporta um máximo de 32.768 tokens de contexto. Mas no meu `~/.aider.model.settings.yml` eu tinha deixado grande demais:

```
- name: ollama_chat/qwen2.5-coder:32b
  extra_params:
    num_ctx: 65576
```

Esse tamanho todo funciona bem pra modelos como Deepseek, mas o Qwen é no máximo 32k. Mas tem um porém: tem que ter VRAM sobrando pra isso. Em resumo:

- DEFAULT_NUM_CTX=24576 is estimated at 32GB of VRAM.
- DEFAULT_NUM_CTX=12288 is estimated at 26GB of VRAM.
- DEFAULT_NUM_CTX=6144 is estimated at 24GB of VRAM.

Pra rodar com o total de 32k tokens de janela de contexto, precisa de uma GPU com uns 40GB e isso não existe no mundo NVIDIA pra consumidores. Seja minha 4090 ou a nova 5090, que são topo de linha, eles são capados em 24GB. Pra quem não sabia memória é o componente mais caro de todos. E não pense no pente de DDR4 ou DDR5 que você tem no seu PC: eles são **LENTOS**. Estamos falando de GDDR6 ou LPDDR6, memória muito mais rápidas, com latências muito mais baixas, que seu PC não suporta.

Ou seja, o máximo que consegui entuchar na minha 4090 foi 8192, 8k de tokens. É uma janela muito pequena. Qualquer arquivo de código pequeno de 400 linhas já consome uma média de 4k tokens. Então male male, cabe 2 arquivos no contexto. Sem considerar prompts, sem considerar detalhes do que você quer pedir. É muito pouco contexto.

Então eu pensei. No mundo consumidor só tem uma alternativa: Mac Mini.

![Mac Mini](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBb0lCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--b7f12e01d62961d8f64fbd2f2bf94b68df10aece/Screenshot%20From%202025-04-27%2002-28-57.png?disposition=attachment&locale=en)

Um Mac Mini tem máximo de 64GB de RAM. E Apple tem uma vantagem: ele é caro, sim, mas porque de fato usa componentes mais caros. A memória vem soldada e muita gente reclama, mas relaxa: você não ia ter como fazer upgrade de qualquer jeito, porque não existem pentes de memória na velocidade da memória dos Macs: eles são o mesmo tipo de chips de memória de GPU!!

E fica tudo soldado muito perto da CPU e GPU, porque slots são lentos e fisicamente longe. Com latências tão baixas, milímetros a mais de distância fazem diferença. Não tem outra alternativa: **TEM QUE SER SOLDADO**.

A vantagem disso é que a mesma memória é **UNIFICADA** e pode ser usada tanto pra CPU quanto pra GPU. O sistema operacional consegue alocar memória dinamicamente pra um ou pra outro. Então, nesses 64GB de RAM, daria pra alocar os 40GB que precisaria pra dar offload de todos os 65 layers do Qwen2.5 e ainda sobrar espaço pra janela de contexto máxima de 32k tokens.

Se pegar um Mac Studio dá pra ir até 512GB. Então, sim, faz sentido usar Macs pra rodar LLMs. Especialmente se considerar que as outras alternativas fora de consumer, pro mundo de workstations mais profissionais, temos coisas como a RTX 6000 (GPU feita pra 3D, CAD, e sem funcionalidades pra jogos). Ela dá pra ir até 96GB mas ao custo de caríssimos USD 7 mil! Mais caro que um Mac Studio inteiro.

E as Ryzen AI Max com iGPU integrada que compartilha memória? Esquece. Pra modelos leves serve (mas aí não precisa de tanta vram mesmo), pra modelos grandes, a memória unificada é no máximo DDR5: é lenta. É uma iGPU lenta. Não quer dizer que é inútil, mas sim que pro tipo de teste que eu queria, não ia funcionar. Continue vendo pra saber porque.

Então eu vou comprar um Mac Studio? Não, não precisa. Eu não pretendo fazer uso pesado todos os dias, só brincadeira ocasionais. E pra isso é melhor **ALUGAR** mesmo. Além disso, só porque você tem máquina cara, não significa que tudo vai ficar automaticamente rápido. Spoiler: não vai.

### RunPod

Eu já mencionei a RunPod em alguns artigos e posts no X porque eu sempre ouço falar dela em videos no YouTube de tutoriais de LLM. De fato é super simples e relativamente barato. Vamos resumir:

![Storage RunPod](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBb01CIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--e77ff18a1b2499a6b3175db1139c5016aecf4b2b/Screenshot%20From%202025-04-27%2022-39-06.png?disposition=attachment&locale=en)

A primeira coisa é subir um "Network Volume", um armazenamento disponível na rede (como meu NAS). Porque vamos ter que fazer download de modelos pesados (mais de 15GB, média de 20GB) e se eu precisar re-criar máquinas (pods/containers de Docker, na verdade), não quero ter que re-fazer downloads toda hora. USD 7 dólares por mês, por 100 GB, é caro, mas consigo viver com isso.

Se você não tem noção, um NVME de 4TB da Samsung (o mais popular, nem o melhor, nem o pior), custa faixa de USD 250. Por 4 TERABYTES, seria 16 dólares por gigabyte. Alugar custa 14 dólares por gigabyte POR MÊS! Por isso, se possível, é sempre melhor rodar as coisas local do que alugar, se sabe que vai usar por meses. No meu caso, que só vou testar e depois apagar, tá ótimo. Aí já é custo de conveniência (testar hoje em vez de arriscar comprar um Mac Studio e esperar chegar e descobrir que não faz diferença).

Outra dica. Na RunPod já tem vários templates, que são basicamente imagens Docker. Pra Ollama já tem estes aqui:

![templates runpod](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBb1FCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--08b6e3e2006e052910ffc1f171b56feae83fd3cc/Screenshot%20From%202025-04-27%2022-44-15.png?disposition=attachment&locale=en)

Acho que qualquer um desses deve servir, mas pra testar, resolvi criar meu próprio template do zero, usando como base a imagem oficial "ollama/ollama:latest":

![ollama template](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBb1VCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--3659631ea7062481d20a0ff955d2603e2b401567/Screenshot%20From%202025-04-27%2022-45-42.png?disposition=attachment&locale=en)

É com a variável de ambiente `OLLAMA_MODELS` que digo ao ollama pra buscar modelos no volume de rede que criei antes, assim, quando eu derrubar o container, os modelos vão persistir. Quem já deu deploy de containers entende conceito de volumes mapeados, é exatamente isso.

Um detalhe: o que o RunPod chama de "pods" não são mais que meros containers de Docker com a opção "--gpus" pra acessar as GPUs por baixo. Mas a máquina física embaixo, o servidor, não tem mais que meia dúzia de GPUs. Enquanto seu pod estiver rodando, ele "prende" essa GPU. Mas quando desligar o pod, outra pessoa pode pegar e pode acabar as GPUs da máquina. Daí você tem que, ou esperar até alguma GPU liberar, ou apagar seu container e recriar em outra máquina com GPU ativa.

Pra coisas como ferramenta de desenvolvimento, não tem problema. Se fosse um produto que precisa ficar no ar 24/7, aí tem que pesquisar as opções de reserva porque quanto mais longo for a reserva, menor o preço de uso por hora. Dependendo da config da máquina, a diferença é enorme. Por exemplo:

![plan savings](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBb1lCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--a5967a0ab38bc05edefc532d3ee86485624eca64/Screenshot%20From%202025-04-27%2019-55-34.png?disposition=attachment&locale=en)

Se eu usar uma máquina H100 (um dos topos de linha), com a taxa padrão "on-demand" de USD 2.89, e eu ficar com ela ligada por 6 meses, isso daria mais de USD 12k. Com a taxa reduzida de USD 2.49, dá um desconto de uns USD 2k. Tem que fazer as contas aí pra ver se vale a pena. Nessa faixa de máquina talvez vale mais a pena consultar uma Azure ou AWS, varia muito.

![a40](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBb2NCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--eb4db2d46be7818247dfff1eaa9d4f5602af00b3/Screenshot%20From%202025-04-27%2020-05-30.png?disposition=attachment&locale=en)

Enfim, eu fiquei testando na A40, que é geração passada de arquitetura, provavelmente próxima em processamento a uma 3080 da vida, mas com 40GB de VRAM. E como podem ver nessa foto de tela, realmente puxa a GPU e não consome metade da VRAM (o modelo não tem muito mais que 20GB, mas precisa do resto pra janela de contexto e outros cálculos internos).

A grande vantagem é subir com janela de contexto de 32k em vez de só 8k. Mas deixa eu falar: infelizmente não senti muita diferença na qualidade do código.

Se alguém quiser ver o tipo de código que consegui com o Qwen2.5-coder:32b, rodando tanto na minha máquina local limitada, quanto na RunPod, eu subi um [pull request](https://github.com/akitaonrails/Tiny-Qwen-CLI/pull/2) em cima daquele projetinho educacional de [Tiny-Qwen-CLI](https://github.com/akitaonrails/Tiny-Qwen-CLI) do meu outro artigo do blog.

As mudanças que pedi foram simples, do tipo "refatorar dois métodos que estavam complexos e criar um arquivo de teste unitário desses dois métodos". Realmente nada demais. O arquivo principal não tem muito mais que 400 linhas. É realmente nível prova de conceito. E o Qwen sofreu.

Primeiro de tudo, independente de ser na minha 4090 ou na A40, o Qwen é **LENTO**, muito lento, faixa de menos de 8 tokens por segundo às vezes, é sofridamente lento.

![H100](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBb2dCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--635116f4de51814ad5fbb43875abade134a580b7/Screenshot%20From%202025-04-27%2019-54-35.png?disposition=attachment&locale=en)

Mas será que não é porque minha GPU ou a A40 são velhas e lentas? Pra tirar a dúvida subi o topo de linha do supra sumo: a H100 SXM de 80GB de VRAM e num container com 28 vCPUs e 250GB de RAM. E embora ele realmente puxasse a GPU, a velocidade em cima não escalou linearmente. É mais rápido, mas não o suficiente pra justificar a diferença de preços.

O pod barato de A40 são só USD 0.44 por hora, já essa da H100 são quase USD 3 por hora. **3 TRUMPS POR HORA** ou, se deixar ligado o dia todo, são **USD 72 POR DIA**. Você precisa realmente saber o que está fazendo pra gastar esse nível numa brincadeira. Não cometa o erro de testar e esquecer o pod ligado lá!! Em um mês vai consumir mais de USD 2k!!!

A menos que existam configurações específicas de Qwen2.5 que eu não sei - e acredite: eu vasculhei toda issue de github, sub-reddit e o que pude mas não achei nada - esse modelo é pesado e LENTO. E essa lentidão e peso não se traduzem em qualidade superior de código.

Na prática, rodando local ou rodando em cloud, eu tive os mesmos resultados e os mesmos problemas. O código nunca funcionava de primeira, sempre quebrava. Quando mandava consertar, ele não consertava. Mexia em outros lugares e continuava quebrado. Mesmo dando o stacktrace do teste quebrando, ele não conseguia consertar. Teve uma vez que eu mandei ele refatorar e em vez de limpar o código, ele adicionou espaços em brancos, que o linter tinha dito pra tirar!

Usar Qwen2.5-Coder:32b, e também a versão 32b-instruct, foram algumas das sessões mais frustrantes que eu já tive com LLMs. Achei que mais máquina fosse melhorar, mas não, nem com a H100 melhorou.

### Benchmarks Mentem!

E aqui fica um primeiro aviso: em todo blog e video de YouTube que procurar, vai ver todo mundo falando que esse modelo é o supra sumo dos modelos de código. Vai ter vários gráficos de benchmarks dele igualando ou superando Claude, Gemini, ChatGPT. Tudo mentira.

Qual minha teoria: é tudo baseado em **testes sintéticos**, testezinhos muito simples no nível "faça um função que calcule fatorial", "faça uma função que calcule menor caminho entre dois pontos", "faça uma função que re-ordena uma lista de palavras", coisas nível Leet Code no máximo. E sim, isso TODOS os modelos sabem fazer. Está no material de treinamento, já tem cola pronta em dezenas de repos de GitHub. Você certamente já fez um pra treinar.

Agora, dê um código de verdade. Aí a coisa é BEM diferente.

De novo, é possível que tenha alguma configuração que eu não tenha descoberto e que de alguma forma, todo mundo sabe, mas não tem documentado em lugar nenhum. Vai saber. KV Cache? Mexi. Contexto? Mexi. Flash attention? Mexi. Mais VRAM? Já dei. Configuração de offload? Mexi. Temperatura no zero pra tentar evitar alucinações. Mais prompt? Mais contexto? O que mais?

Não use benchmarks pra derivar conclusões. Eles não refletem o uso do dia a dia de ninguém. Teste um por um como eu fiz, em várias configurações. Só assim pra realmente saber como eles funcionam. E meu veredito por enquanto é que Qwen2.5 Coder de 32B, um dos **MAIORES** não deu certo.

### Tamanho Não é Documento

Um preconceito que eu tinha era realmente tamanho. Na minha cabeça "quanto mais parâmetros" deve ser melhor. Então eu fiquei obcecado em testar o mais pesado: **32B**.

Frustrado com os resultados, resolvi dar uma chance pra versão menor: [qwen2.5-coder:7b-instruct](https://ollama.com/library/qwen2.5-coder:7b). Mesma coisa, primeiro, configurar o `~/.aider.model.settings.yml`:

``` 
- name: ollama_chat/qwen2.5-coder:7b-instruct
  extra_params:
    num_ctx: 32768
```

Sendo um modelo mais leve, só 7B parâmetros, pesando menos de 5GB, sobra espaço e sabendo que ele suporta até 32k de tokens, posso pedir pra usar tudo que vai caber até na minha 4090.

``` 
aider --watch-files --model ollama_chat/qwen2.5-coder:7b-instruct
```

Subi o Aider e pedi as mesmas coisas: refatorar dois métodos e fazer um teste unitário pros dois. E o resultado: foi MUITO mais rápido (é mais leve), e foi MUITO MAIS PRECISO. Isso foi uma surpresa!

Pra verem a diferença de código, eis o [pull request](https://github.com/akitaonrails/Tiny-Qwen-CLI/pull/4). Como comentei nesse PR: o principal é que o código que ele fez não quebrou o projeto. Eu testei depois das mudanças e continua rodando como deveria. O teste que ele fez do zero, também falhou na primeira rodada, mas dando a mensagem de erro, ele soube corrigir. O mais importante: eu não precisei brigar com ele pra re-fazer tanto quanto precisei com o 32b. E por ser mais leve e mais veloz, a interatividade foi bem mais natural e bem menos cansativa, mais parecido com usar um Claude da vida.

O código dele ainda não supera do Claude ou Gemini, mas do jeito que está já é bem usável. Mas se parar pra pensar faz sentido:

**Quanto maior o modelo (parâmetros) mais dados ele tem pra ERRAR.**

E foi o que eu já tinha falado antes: modelos mais especialistas tendem a dar melhores resultados. Tamanho não é documento e não há correlação entre "ser maior" e "ser melhor". Sim, vai passar melhor e mais rápido em "benchmarks sintéticos", mas porque no modelo maior vai ter mais resultados pré-prontos que muitos desses testes usam. Mas vai ficar mais pesado e mais complicado pra gerar resultados inéditos.

Um modelo menor, eu imagino, tem menos relacionamentos pra calcular e o que tem - se foi bem treinado - somado ao contexto (meu código atual), já é suficiente pra dar respostas boas. Mais parâmetros atrapalha mais do que ajuda.

Além disso, isso é caso de uso de código. Queremos que ele tenha mais atenção e seja menos "criativo". O código precisa seguir à risca as regras daquele arquivo em especial. Não adianta querer ficar inventando coisas exóticas nele: só vai deixar o código pior.

Ou seja: mesmo numa máquina menor, com uma 3070, 4070, com 16GB de VRAM, dá pra rodar o **Qwen 2.5 Coder 7B Instruct** e ele vai dar resultados apropriados e úteis. Vale a pena testar. Se não tem máquina pra isso, o RunPod de uma 3090 deve ser suficiente e mais barato que uma A40. (na verdade acho que é só 1 centavo por hora mais barato).

### Outros Modelos

Aproveitando, experimentei subir outros modelos pra testar:

```
❯ ollama list
NAME                         ID              SIZE      MODIFIED
qwen2.5-coder:7b-instruct    2b0496514337    4.7 GB    2 hours ago
codegemma:7b                 0c96700aaada    5.0 GB    2 hours ago
codestral:latest             0898a8b286d5    12 GB     3 hours ago
codellama:34b                685be00e1532    19 GB     3 hours ago
deepseek-coder-v2:16b        63fb193b3a9b    8.9 GB    3 hours ago
deepseek-coder:33b           acec7c0b0fd9    18 GB     3 hours ago
qwen2.5-coder:14b            3028237cc8c5    9.0 GB    3 hours ago
qwen2.5-coder:32b            4bd6cbf2d094    19 GB     4 hours ago
```

Infelizmente, Deepseek-Coder, Deepseek-Coder-V2, Code Gemma (do Google). Code Llama (da Meta), Codestral (da Mistral), todos fracassaram miseravelmente. Nenhum conseguiu dar nenhum código usável no mesmo teste que fiz os outros.

**MAS** isso pode ser ainda uma limitação da ferramenta AIDER que estou usando. Ele é muito bem testado nas LLMs comerciais como da OpenAI, Claude ou Gemini, mas é muito pouco testado nas LLMs abertas.

Eu já expliquei como ele funciona: com MUITO prompt de instruções (ligue a opção `--verbose` pra ver). O problema é que LLMs diferentes precisam de prompts em formatos e verbalizados de forma diferente. Eu não li a fundo, mas Deepseek por exemplo, acho que eu li que prompts de comandos pra ele são em formato XML (lembro de ter visto vários tags). E se não der nesse formato, acho que não vai ajudar muito.

Então não é que esses modelos são ruins, mas sim que o AIDER não é bom pra eles. É uma oportunidade pra quem quiser contribuir, pra criar perfis especiais de cada um deles e fazer pull request no Aider. É uma coisa que, se me der vontade, talvez eu tente fazer uma hora, porque depois do Qwen2.5 Coder, **dizem** que o melhor é o DeepSeek Coder V2. Só que não deu pra ver, porque ele estava se recusando a devolver resultados num formato que o Aider espera.

Procurei nas issues abertas no projeto e não achei nada pra gambiarrar temporariamente. 

Me deixa abismado que tem MUITO post de blog falando tando de Qwen quanto Deepseek mas minha conclusão é que NENHUM DELES TENTOU DE VERDADE RODAR! Estão só REPETINDO o que ouviram falar. Eu poderia afirmar que este blog post é o PRIMEIRO que realmente fez testes em códigos um pouco mais parecidos com de verdade, e não brincadeirinhas de leet code. Porque é só usar por 10 minutos: não funciona.

![refactor fake](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBb2tCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--0023102ec4cda35df1c1e70b154dfaef54f5bab7/Screenshot%20From%202025-04-27%2020-07-45.png?disposition=attachment&locale=en)

Sem brincadeira, não lembro com qual modelo foi, mas eu pedi pra refatorar o método e olha essa foto de tela: ele só criou uma nova linha e tirou espaços em branco, mais nada! Era nesse nível. O Codellama se recusava a dar código, só dava explicações. O Codegemma parecido. O Aider ainda não deve saber como tirar proveito deles. Espero que alguém faça PRs pra consertar isso.

### Conclusão

Nesses testes preliminares (super limitados), dos modelos abertos, realmente me impressionou o qwen2.5-coder:7b-instruct, vale a pena testar mais, em coisas mais complexas, pra ver se ele se mantém na mesma qualidade.

Mas dos comerciais, também testei e tanto o **Claude Sonnet 3.7** quanto o **Gemini 2.5 Pro Exp Preview** foram imbatíveis. Minha linha de comando padrão agora deve ser esta:

```
aider --model openrouter/google/gemini-2.5-pro-preview-03-25
```

Eles são consideravelmente mais rápidos, e com resultados consideravelmente mais precisos e com menos erros. Nenhum deles é perfeito, vira e mexe tem que mandar consertar alguma coisa, mas a frequência de erros é BEM menor do que o Qwen e o código final é objetivamente melhor.

Pra comparar, este é o [pull request](https://github.com/akitaonrails/Tiny-Qwen-CLI/pull/3) do mesmo projeto, pedindo as mesmas coisas, pro Gemini. Ele não quebrou o projeto, conseguiu refatorar e conseguiu fazer o teste unitário. Eu não gastei muito tempo tentando fazer ficar do jeito "certo" que eu queria, mas do jeito que ficou já dá pra trabalhar em cima. Literalmente não gastei 10 minutos com o Gemini pra me dar esse resultado. Como Qwen 32b eu passei literalmente HORAS por um resultado medíocre.

Usar uma LLM pra ajudar em código é realmente essencial. Apesar de ter que consertar várias coisas manualmente, onde eu tinha dúvidas ou queria idéias, qualquer das LLMs foi uma mão na roda. Especialmente quando estava de madrugada, meu foco estava disperso, sonolento, e a LLM me ajudou a não cometer erros triviais e pensou em coisas que na hora, não ia sair da minha cabeça.

Em termos de custo: uma A40 custa 44 centavos por hora. Eu gastei menos de 5 dólares pro teste. Na OpenRouter gastei menos de 5 dólares de créditos também (é o melhor jeito de assinar um lugar só e usar Claude, Gemini, OpenAI, etc). Se for só pelo custo, não compensa escolher modelos open source pra função de assistente de programação. Assine o OpenRouter e teste o Gemini e outros, vai ser mais conveniente mesmo. Mas agora você sabe como subir do zero na RunPod e pensar em criar produtos e soluções que usam LLMs.

Recomendo testar o Aider, ele é super simples, setup super baixo, não fica entuchando plugin pesado na sua IDE, e é rápido de usar. Mas leia a documentação que tem muita dica escondida.
