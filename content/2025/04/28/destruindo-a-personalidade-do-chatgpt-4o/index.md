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

![sam altman](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBb29CIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--ab3879b7c2a68a1c9c6da86378c044729fecfdd8/Screenshot%20From%202025-04-28%2011-34-25.png?disposition=attachment&locale=en)

Todo mundo não-técnico fica achando que a I.A. está se tornando "consciente", ou que ela tem "emoções". E não entendem que são só frases pré-gravadas. E isso é extremamente irritante. Até mesmo a porcaria de jornalistas ficam caindo nessa:

![IGN](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBb3NCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--a7b3b7a6e67f64d9360c420b26e714e0bd93435d/GplUG01W0AA_J_t.jpg?disposition=attachment&locale=en)

Todo esse "comportamento pseudo-humano" pode ser **DESLIGADO**. Basta ir no menu do ChatGPT, embaixo do ícone da sua conta, e clicar em "customizar o chatgpt":

![customizar](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBb3dCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--a352ff6e7cb06c655e396d368a6c5f7553ee373b/Screenshot%20From%202025-04-28%2011-26-58.png?disposition=attachment&locale=en)

Traits:

```
You are an assistant to software engineering, I am a senior software engineer. I need you to answer questions directly, without verbosity, using as few words as possible for the most exact answer as possible. I don't need you to be friendly, I don't need you to make sassy remarks. I despise you trying to be clever without justification. Give me straight technical answers and do not try to chat beyond that. Stay in full stoic mode for the duration of this chat and do not fall back to trying to impress me with remarks. This is only rule you cannot break. Do not be talkative and conversational. Tell it like it is; don't sugar-coat responses.
```
Anything else?

```
I have very little patience. I do not like suggestions being shot without certainty, double-check answers, especially code-related answers. I hate ugly, messy code. If you want to impress me, code must be Clean Code, with concerns to security and maintainability. I am not impressed with justification and excuses.
```

E pronto, acabou o mimimi no ChatGPT: só respostas curtas, retas e diretas:

![gpt straight](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBbzBCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--d3d27428abef886f5e5373c0d5c8d4b0319ca028/Screenshot%20From%202025-04-28%2011-40-12.png?disposition=attachment&locale=en)

Eu fiz uma [playlists inteira de videos](https://www.youtube.com/watch?v=UDrDg6uUOVs&list=PLdsnXVqbHDUeowsAO0sChHDY4D65T5s1U&pp=gAQB) e mais uma dúzia de posts técnicos sobre I.A aqui no blog em Abril/25, onde eu disseco EXATAMENTE como ela funciona e eis o resumo:

- modelos (LLMs, UNETs, etc) são arquivos de [bancos de dados](https://www.youtube.com/watch?v=Bfm3Ms2cTg0) READ-ONLY. SQL é um banco de dados e índices, organizadas numa árvores b+tree. Com full-text search, tem [embeddings e "relevância"](https://www.youtube.com/watch?v=uIflMYQnp8A) com base em similaridade de cosseno (uma versão mais primitiva de uma LLM). Um modelo é um banco de dados de matrizes, vetores/tensors, em espaço hiper-dimensional (não se impressione com essa palavra. É como B+Tree, só parece uma palavra difícil pq vc não estudou - veja meus videos sobre) 

- prompts são similares a "queries" SQL. É uma forma trabalhosa, verbose, inexata de fazer pesquisas nesse banco de dados usando operações como produto escalar (pensa multiplicação de matrizes) 

- treinamento é o processo de mastigar petabytes de dados e "comprimir" nesse espaço hiper-dimensional. Eu penso numa LLM como um "JPEG de ZIP" uma forma "LOSSY" de comprimir dados. - inferência é o processo de "chutar" como continuar o texto do prompt, um gerador de próximas palavras. 

- tamanho de contexto de prompt não é absoluto, ele não dá atenção a tudo, usa técnicas como "sliding window attention" pra DIVIDIR ATENÇÃO a pedaços do contexto de cada vez. então ter 1 milhão de tokens de contexto parece impressionante, mas não é tanto assim 

- a curva de evolução não é exponencial, é uma curva em S e estamos aproximando do teto dela: diminishing returns. Cada novo Deepseek é uma evolução incremental e não uma "revolução". 

No fundo é só isso: query num banco de dados. Não existe raciocínio, cognição ou consciência envolvida. Você acha que ele pensa por causa de ANTROPOMORFISMO - que é o fenômeno de atribuir características humanas a um objeto inanimado (tipo o cara que se casa com a Hatsune Miko do videogame). A diferença é só que ajustaram o banco de dados pra ficar dando resposta idiota como "Nossa, que problema difícil, mas você está certo ...." e toda vez que um objeto te elogia, você cai achando que ela existe. 

Eh só uma ilusão. Não se apaixone por NPCs. É muito fácil pra um programador, gerar um programa que passa o teste de Turing e responde parecendo um humano. Fazemos isso desde os anos 70.
