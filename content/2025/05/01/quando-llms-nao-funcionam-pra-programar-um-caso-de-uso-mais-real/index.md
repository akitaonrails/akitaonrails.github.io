---
title: Quando LLMs não Funcionam pra Programar? Um caso de uso mais real.
date: '2025-05-01T17:20:00-03:00'
slug: quando-llms-nao-funcionam-pra-programar-um-caso-de-uso-mais-real
tags:
- zig
- llama.cpp
- aider
- openrouter
- llm
draft: false
---



Como eu disse no meu post anterior de Rant sobre [Desmistificar a I.A. pra programação](https://www.akitaonrails.com/2025/05/01/rant-llms-vao-evoluir-pra-sempre-desmistificando-llms-na-programacao), posso confirmar que muitos benchmarks sintéticos que dizem medir capacidade de programação, são MENTIRAS.

E não digo que é uma tentativa proposital de mentir, mas que quem está fazendo as pesquisas e compilando rankings e leaderboards, não divulgam exatamente os detalhes e só soltam o resultado sem contexto. Este é um exemplo que achei hoje: [LiveBench](https://github.com/LiveBench/LiveBench), que é mais um pacote de benchmark de "programação". Olha  que é testado exatamente:

[![LiveBench scripts](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/pms3gupxalzq81uwsz73t0ip34m8?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-05-01%2011-54-06.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-05-01%252011-54-06.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001334Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=b28cabe2be365238d20e90089d9e2a9ef4238f059d56c9811caabe645c666c3d)](https://github.com/LiveBench/LiveBench/tree/main/livebench/scripts)

São testes idiotas do tipo "carregue estes dois arquivos CSV e compare os valores". É ainda mais idiota que Leet Code. É ainda mais idiota que a maioria dos testes de contratação de programadores estagiários. Enfim, é o conjunto mais idiota de testes que eu já vi. 

Por isso eu disse que meus testes são MUITO SUPERIORES. Não porque eu sou ph0da. Mas porque a régua é extremamente baixa. Meu teste mais real é um projetinho pequeno em Python e eu dou prompts de refatorar código sujo e criar testes unitários. Que é o básico do básico que eu espero de qualquer programador minimamente competente. E escolhi Python (que nem é minha linguagem favorita), pra dar mais chance pras LLMs, imaginando que no material de treinamento deve ter visto muito Python.

E nem assim eles conseguem fazer o que eu pedi. Vocês podem ver com seus próprios olhos nos meus comentários das [pull requests](https://github.com/akitaonrails/Tiny-Qwen-CLI/pulls ) que deixei no repositório, testando cada LLM, múltiplas vezes. É absolutamente decepcionante de ver.

### Projeto Novo: Zig

Agora eu tenho outra teoria: LLMs são boas em "copy e paste", em cuspir código que ele viu repetidas vezes no treinamento. Por isso que se perguntar qualquer coisas simples de Leet Code, ele sabe responder. Nem precisa tentar "pensar", já está embutido no modelo. É que nem fazer uma prova com cola.

Eu acho que o calcanhar de aquiles de LLM pra programação são bibliotecas recém-lançadas, novas versões ou linguagens muito novas. Qualquer coisa que se procurar no Google, você mesmo vai ter dificuldade de achar.

E é exatamente isso. Eu subi [este novo repositório no GitHub: Qwen-CLI-Zig](https://github.com/akitaonrails/qwen-cli-zig)
O objetivo foi tentar fazer, do zero, um mini chat interativo pra conversar com um modelo local, no caso o Qwen3:14b GGUF (quantizado). E pra fazer isso escolhi usar direto a biblioteca em C [llama.cpp](https://github.com/ggml-org/llama.cpp). Eu imagino que toda biblioteca popular de mais alto nível como litellm, vllm, ollama e coisas assim ou usam, ou se inspiram nessa biblioteca. Ela estabelece mais ou menos as convenções de como LLMs funcionam.

O obstáculo: é código em C++. E pra piorar, tem que compilar com o CUDA Toolkit pra ter acesso à minha GPU. E agora começa meu pesadelo.

### Os Problemas

Pra fazer isso, escolhi usar Aider com o Gemini 2.5 Pro Exp Preview 03-25, teoricamente o dito "estado da arte" na programação. "Segundo os benchmarks" ...

De fato, ele não é ruim, mas o importante pra um profissional não é ficar elogiando o que não sabe, e sim saber as limitações pra descobrir como consertar, criar workarounds/gambiarras ou simplesmente saber que tem casos que não dá pra usar a ferramenta. Esse é um desses casos.

Vamos lá:

- O Gemini claramente não teve muito material de Zig pra treinar e o que teve está defasado ou obsoleto. Ele insiste em criar código que não funciona mais. E não sabe como consertar, porque não tem no treinamento.

- A "solução" foi rodar `zig build`, ver o erro, ir na [documentação oficial](https://ziglang.org/documentation/master/#intCast), pra coisas como `ptrCast`, `intCast`, passar a URL pro Aider carregar e pelo menos assim ele conseguia passar por esses erros.

- Coisas que já são bem documentadas, como clonar o repositório do llama.cpp, configurar os flags corretos pra compilar com CUDA, tudo isso num script de bash, isso foi fácil. Ele tirou de letra. Exemplos de scripts de build dessas coisas imagino que teve muito no treinamento.

- Mesmo assim, no Zig, ele precisava carregar o header `llama.h` pra saber que funções existem e que assinaturas pra conseguir fazer `extern "c"` das coisas. Trechos como este:

![extern c](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/3t4nq4879ra3k81b4z2clhfb6axh?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-05-01%2017-01-52.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-05-01%252017-01-52.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001335Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=dffd30a582be93f154b34e5ed7e2ad91f07aeccb33eddb5f0dcf94062678784c)

- Pra fazer isso ele precisa ler de `vendor/llama.cpp/include/llama.h`. Ele sabe disso, mas mandava o path errado o tempo todo, como `vendor/llama.h` ou `vendor/llama.cpp/llama.h`. Se não prestar atenção, ele fica em loop infinito tentando adivinhar porque dá erro sem parar pra pensar no path correto. Eu que tive que manualmente, mais de uma vez, dizer pra ele o path correto e mesmo assim ele esquecia.

- Com o `llama.h` no contexto carregado, mesmo assim ele fazia erro de estag: saía criando `extern` pra funções que nem vai precisar. Ele leu o arquivo e saiu copiando e colando no Zig tudo. Mas além de encher linguiça com mapeamento desnecessário, ele errava MUITO os tipos, errava `c_int` por `int32` (o primeiro é pra mapear com C, o segundo é só pra Zig puro). Isso custou MUITOS erros de compilação e tentativas repetidas em excesso até conseguir consertar.

- Depois de algumas tentativas frustradas, consegui fazer ele criar um script de download do arquivo de modelo do Qwen3 14b GGUF (parece que o llama.cpp, por default, quer GGUF). E finalmente o programa compilou e eu consegui rodar até o ponto onde abria o chat e eu conseguia submeter alguma mensagem.

E na parte final, ele não conseguiu, de jeito nenhum pegar a resposta de volta do modelo. Infelizmente, eu escolhi Zig justamente por ser super novo ainda e eu sei que a sintaxe fica mudando porque não é uma linguagem estável ainda. Por isso não recomendo pra projetos de verdade. É muito experimental. Eu não sei usar Zig direito ainda. Então também não tive paciência pra tentar consertar o erro eu mesmo. (se alguém de Zig se voluntariar, aceito pull requests).

Enfim, gastei umas boas 2 horas só nessa parte. Tentando ler documentação. Eu tentava passar artigos de llama.cpp com exemplos de código e aqui vem outro problema: todo mundo só faz blog post de exemplos de Python (que é a coisa mais fácil, só carregar litellm), mas ninguém se voluntariou pra escrever posts em C++, por exemplo (porque ninguém que escreve posts sabe como, eu incluso).

É ou alguma configuração específica do modelo com llama.cpp que eu não sei (daí o resultado é errado) ou é o código que pega a resposta que tem algum erro. Eu vejo isso:

![llama error](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/wocaykokk9w8wj8udgi3hyfk9emj?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-05-01%2017-14-53.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-05-01%252017-14-53.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001337Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=56a80afc7c1c97a4458ac21fb1c6a6ea6d86156766a8413c735eb2a27c23063f)

O problema: tem pouquíssima documentação a respeito e não achei nada que me ajudasse a resolver. E só na tentativa e erro o Gemini também não conseguiu resolver. Então eu encerrei o teste.

### Custa Caro

Agora o bônus. Eu assinei a [OpenRouter.ai](https://openrouter.ai) pra centralizar os gastos de qualquer LLM num lugar só. Comprei USD 100 de crédito e já tinha gasto bastante nos testes de refatoração de várias LLM. Não sei quanto tinha sobrando, vamos chutar uns USD 20.

Daí fazendo esse novo programinha em Zig, acabou os créditos no meio do caminho. Meu Aider começou a apitar que faltava créditos pro tanto de contexto que o Gemini gera (esse é um problema de modelos "thinking", o pensamento é longo demais e come MUITO crédito de tokens).

Fui na minha conta e enchi mais USD 100. Voltei só nessa parte do `std::bad_alloc`pra tentar consertar - e o problema é que o Gemini não foca. Ele sai mexendo código aleatoriamente e coisas como o procedimento de carga do modelo na GPU, que já estava funcionando, ele ficava frequentemente quebrando. E eu ficava frequentemente mandando ele voltar como tava. E isso gasta MUITO crédito também.

No momento que desisti, é isso que vi no meu saldo na OpenRouter:

![OpenRouter credits](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/pobrdfrwga38utw0jud47no3fhhn?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-05-01%2017-19-06.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-05-01%252017-19-06.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001338Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=c59e17d4b8343810a3ab37cdec79d8ea8453ae6d134fec5ffccba7131a4993a0)

Além dos cerca de USD 20 que eu tinha sobrando, ele gastou quase USD 35. Chutando, ele gastou mais de USD 50 pra não me dar um código que funciona, depois de umas boas 4 ou 5 horas tentando. Pode esperar gastar USD 10 por hora em tentativa e erro. Se você vê que está repetindo muito "What's wrong, fix", é hora de parar e desistir, ele não vai conseguir.

Você tem que ter a intuição correta de quando falta informação e buscar URLs no Google pra dar pra ele. Você tem que ter intuição do que tem no material de treinamento e saber que ele não tem essa informação. Você tem que ter intuição de ler o stacktrace e dizer o que ele deve ignorar e o que ele deve focar pra corrigir. Você tem que saber que é pra pedir uma coisa pequena de cada vez e nunca "corrija tudo" ou "teste tudo". Ele não vai conseguir.

Prompts que tem mais chance de funcionar são sempre coisas bem pequenas. Um pequeno bloco de código de cada vez. Incremental, testando, e mandando não mexer no que já funciona (e ele vai te ignorar e mexer, e quebrar). Ter testes pra checar é fundamental. E não adianta "compilar".

Esse código de Zig "compila" mas ele tem erro de run-time, só aparece quando roda. Mas eu não tive coragem de pedir pra ele fazer um teste unitário. Todos foram incompetentes em fazer testes pra Python. Pra Zig então, eu já acho que é uma impossibilidade. Ele não vai conseguir.

Por que? Porque eu acho que pesquisadores não sabem como programadores trabalham. Pra eles, programação são só pequenos scripts (que é o que eles fazem mesmo: abrir um CSV e mandar agregar dados). É só isso que sabem fazer. E é isso que as LLMs refletem: ele tem MUITA dificuldade de fazer código de verdade. E nunca mais longo que uns 4 arquivos no contexto de cada vez. Mais que isso e ele fica confuso muito rápido e começa a cuspir código MUITO errado.

Aliás, outra dica: evite criar seu projeto com nomes parecidos com de projetos open source populares. Pense assim, digamos que seu projeto se chama "my-react". Fodeu, no treinamento dele certamente teve muito exemplo de React.js de verdade, e ele vai ficar confundindo as duas coisas o tempo todo. De novo, tenha intuição do que já tem no treinamento pra ajudar o modelo a não ficar confuso.

E você vai ter gasto dezenas de dólares, ou mais, se não tomar cuidado. E no final não vai ter código que funciona direito.

Ah sim, tem gambiarras que dá pra fazer: integrar um RAG com código fonte do que você sabe que ele não tem no treinamento, ou treinar LoRas e usar em conjunto. E mesmo assim não é "solução", são tentativas de fazer ele gerar código que faça mais sentido. Mas sozinhos, sem esse tipo de ajuda, neste momento eles ainda não sabem o que fazer.

O que muita gente ignora é que a GRANDE MAIORIA dos principais códigos de verdade do mercado, são todos FECHADOS. A Amazon nunca vai liberar o código do e-commerce deles, nem Alibaba. O iFood ou MercadoLivre idem. Nenhum código de verdade está no modelo. Se estivesse seria um enorme risco de PROCESSO. Eles só podem usar código aberto, de lugares como GitHub ou respostas de Stackoverflow. E lá só tem código BÁSICO E RUIM. Então é só isso que as LLMs conseguem cuspir código BÁSICO E RUIM.

Se a LLM tem conseguido resolver seus problemas, não é porque ele é bom, é porque seu problema é muito simples.
