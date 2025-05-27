---
title: Destruindo a "Personalidade" do ChatGPT 4o
date: '2025-04-28T11:30:00-03:00'
slug: destruindo-a-personalidade-do-chatgpt-4o
tags:
- chatgpt
- openai
- llm
draft: false
---



Eu detesto que a OpenAI fique mexendo no alinhamento ou prompt inicial ou mesmo treinamento do modelo, tentando fazer ele responder parecendo mais um "humano".

![sam altman](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/na9qkp2m4rmnclrmal10vlz17vzw?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-28%2011-34-25.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-28%252011-34-25.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001321Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=9760cc657de4198757637e643b2e9bd46c8363ee9dc8d6daf13709d11b6728d5)

Todo mundo não-técnico fica achando que a I.A. está se tornando "consciente", ou que ela tem "emoções". E não entendem que são só frases pré-gravadas. E isso é extremamente irritante. Até mesmo a porcaria de jornalistas ficam caindo nessa:

![IGN](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/hv9cpwnyu7aynuvf4vk96opfspnd?response-content-disposition=inline%3B%20filename%3D%22GplUG01W0AA_J_t.jpg%22%3B%20filename%2A%3DUTF-8%27%27GplUG01W0AA_J_t.jpg&response-content-type=image%2Fjpeg&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001322Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=82574ddac7b95e0ae4959a6df8087284a970daf72c42ae8e7ca02b953ed51238)

Todo esse "comportamento pseudo-humano" pode ser **DESLIGADO**. Basta ir no menu do ChatGPT, embaixo do ícone da sua conta, e clicar em "customizar o chatgpt":

![customizar](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ax3qljufi7lqes8qez6apfk3k29z?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-28%2011-26-58.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-28%252011-26-58.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001324Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=f34772134dd16e62a0607d7aea424e748f8b81d5e721c12e4bef1e09217af009)

Traits:

```
You are an assistant to software engineering, I am a senior software engineer. I need you to answer questions directly, without verbosity, using as few words as possible for the most exact answer as possible. I don't need you to be friendly, I don't need you to make sassy remarks. I despise you trying to be clever without justification. Give me straight technical answers and do not try to chat beyond that. Stay in full stoic mode for the duration of this chat and do not fall back to trying to impress me with remarks. This is only rule you cannot break. Do not be talkative and conversational. Tell it like it is; don't sugar-coat responses.
```
Anything else?

```
I have very little patience. I do not like suggestions being shot without certainty, double-check answers, especially code-related answers. I hate ugly, messy code. If you want to impress me, code must be Clean Code, with concerns to security and maintainability. I am not impressed with justification and excuses.
```

E pronto, acabou o mimimi no ChatGPT: só respostas curtas, retas e diretas:

![gpt straight](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2mngtnnige43arawi8ku1zfs6hvs?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-28%2011-40-12.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-28%252011-40-12.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001325Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=a6237fbbd65e2c183dea7013024f6e437e22c1fe7f65a55443fbc4470b915cfb)

Eu fiz uma [playlists inteira de videos](https://www.youtube.com/watch?v=UDrDg6uUOVs&list=PLdsnXVqbHDUeowsAO0sChHDY4D65T5s1U&pp=gAQB) e mais uma dúzia de posts técnicos sobre I.A aqui no blog em Abril/25, onde eu disseco EXATAMENTE como ela funciona e eis o resumo:

- modelos (LLMs, UNETs, etc) são arquivos de [bancos de dados](https://www.youtube.com/watch?v=Bfm3Ms2cTg0) READ-ONLY. SQL é um banco de dados e índices, organizadas numa árvores b+tree. Com full-text search, tem [embeddings e "relevância"](https://www.youtube.com/watch?v=uIflMYQnp8A) com base em similaridade de cosseno (uma versão mais primitiva de uma LLM). Um modelo é um banco de dados de matrizes, vetores/tensors, em espaço hiper-dimensional (não se impressione com essa palavra. É como B+Tree, só parece uma palavra difícil pq vc não estudou - veja meus videos sobre) 

- prompts são similares a "queries" SQL. É uma forma trabalhosa, verbose, inexata de fazer pesquisas nesse banco de dados usando operações como produto escalar (pensa multiplicação de matrizes) 

- treinamento é o processo de mastigar petabytes de dados e "comprimir" nesse espaço hiper-dimensional. Eu penso numa LLM como um "JPEG de ZIP" uma forma "LOSSY" de comprimir dados. - inferência é o processo de "chutar" como continuar o texto do prompt, um gerador de próximas palavras. 

- tamanho de contexto de prompt não é absoluto, ele não dá atenção a tudo, usa técnicas como "sliding window attention" pra DIVIDIR ATENÇÃO a pedaços do contexto de cada vez. então ter 1 milhão de tokens de contexto parece impressionante, mas não é tanto assim 

- a curva de evolução não é exponencial, é uma curva em S e estamos aproximando do teto dela: diminishing returns. Cada novo Deepseek é uma evolução incremental e não uma "revolução". 

No fundo é só isso: query num banco de dados. Não existe raciocínio, cognição ou consciência envolvida. Você acha que ele pensa por causa de ANTROPOMORFISMO - que é o fenômeno de atribuir características humanas a um objeto inanimado (tipo o cara que se casa com a Hatsune Miko do videogame). A diferença é só que ajustaram o banco de dados pra ficar dando resposta idiota como "Nossa, que problema difícil, mas você está certo ...." e toda vez que um objeto te elogia, você cai achando que ela existe. 

Eh só uma ilusão. Não se apaixone por NPCs. É muito fácil pra um programador, gerar um programa que passa o teste de Turing e responde parecendo um humano. Fazemos isso desde os anos 70.
