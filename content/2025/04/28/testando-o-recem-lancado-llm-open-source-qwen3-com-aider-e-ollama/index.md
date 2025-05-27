---
title: Testando o Recém Lançado LLM Open Source - Qwen3 (com Aider e Ollama)
date: '2025-04-28T20:30:00-03:00'
slug: testando-o-recem-lancado-llm-open-source-qwen3-com-aider-e-ollama
tags:
- qwen3
- ollama
- aider
- llm
draft: false
---



Eu acabei de [postar ontem sobre Qwen2.5-Coder](https://www.akitaonrails.com/2025/04/27/testando-llms-com-aider-na-runpod-qual-usar-pra-codigo) e HOJE (2025-04-28) a Qwen já chega e me lança o **QWEN 3** que, obviamente, eles dizem que super supera o 2.5. E obviamente eu estava com a mão na massa, precisava testar.

[![qwen x](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/e1ipve95x7e6nlnf7qffayzsz0ag?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-28%2020-13-10.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-28%252020-13-10.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001327Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=4b65159ebb8d212238a34fb976f2943cdd0a483ab4f5f2ef244ce3b69dab8189)](https://x.com/AkitaOnRails/status/1916974917872193780)
Se estiver rodando um ollama instalado via pacotes como Pacman ou Apt, é possível que eles ainda não sejam compatíveis. Mas eu vi no X da Ollama que eles já estão suportando:

[![ollama x](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/yrkrg6l6r4nvnmfefiqoaplbf6cw?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-28%2020-17-09.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-28%252020-17-09.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001329Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=2680a9ee2ec08be1dd8c4afd07f670cb3adce184f21c32db61307d713640ceb2)](https://ollama.com/library/qwen3)
Então só tinha uma alternativa: baixar direto o source do repo deles e compilar da branch master:

```
git clone https://github.com/ollama/ollama.git
cd ollama
yay -S cmake
cmake -B build
cmake --build build
```

Pronto, ele vai usar as mesmas variáveis de ambiente apontando pro meu diretório certo de models, então só subir o servidor manualmente assim:

```
OLLAMA_FLASH_ATTENTION=1 go run . serv
```

E de outro terminal baixar o modelo novo:

```
ollama pull qwen3:14
```

A tag `latest`, eu "acho" que é a menor versão, de 4b, porque é bem pequena mesmo. Eu já sei que a 32b é grande demais pra minha RTX 4090 com 24GB, por isso escolhi a 14b:

```
❯ ollama list
NAME                                            ID              SIZE      MODIFIED
qwen3:14b                                       7d7da67570e2    9.3 GB    About an hour ago
qwen3:latest                                    e4b5fd7f8af0    5.2 GB    About an hour ago
qwen2.5-coder:7b-instruct                       2b0496514337    4.7 GB    18 hours ago
...
qwen2.5-coder:14b                               3028237cc8c5    9.0 GB    2 days ago
MHKetbi/Qwen2.5-Coder-32B-Instruct:latest       ac172e3af969    65 GB     2 days ago
qwen2.5-coder:32b-instruct-q4_K_M               4bd6cbf2d094    19 GB     2 days ago
...
```

Veja as diferenças de tamanho. Dependendo da sua GPU/VRAM, tem que escolher tamanhos que caibam **E** sobra espaço pra janela de contexto. Falando nisso, vamos checar o máximo que ele suporta:

```
❯ ollama show qwen3:14b
  Model
    architecture        qwen3
    parameters          14.8B
    context length      40960
    embedding length    5120
    quantization        Q4_K_M
...
```

Já é um bom upgrade: a Qwen2.5 tinha máximo de 32k tokens, o Qwen3 suporta até 40k tokens. Não é nada revolucionário, mas já dá pra carregar um pouco mais de código no contexto. Agora, precisamos atualizar o `~/.aider.model.settings.yml` e adicionar:

```
- name: ollama_chat/qwen3:14b
  extra_params:
    num_ctx: 40960
...
- name: openrouter/qwen/qwen3-235b-a22b-04-28:free
  extra_params:
    num_ctx: 40960
```

Tem 2 entradas: a primeira é pra rodar localmente a versão de 14b, via ollama, com minha RTX 4090. Por isso é a versão 14b. A segunda é conectando remoto na API da OpenRouter e lá posso testar a versão a22b (não li os detalhes, eles começam no maior de 235b e de alguma forma "resumem" num de 22b, eu acho).

Enfim, pra rodar no aider é só usar um dos dois:

```
aider --watch-files --model ollama_chat/qwen3:14b --verbose
```

Se não leu, leia meus posts anteriores sobre Aider e Ollama. Faz muita diferença como cada modelo reage a tipos diferentes de prompts. O Aider (assim como Co-Pilot, Cursor e outros) enviam um tanto de prompts escondidos que você não vê, pra instruir a LLM em como responder de forma estruturada, pra essas ferramentas conseguirem depois capturar o código sugerido e aplicar no seu arquivo de verdade.

O Aider eu não atualizei, não sei se tem alguém já mexendo em ajustes específicos pro Qwen3. Como eu falei no post de ontem, o Aider não consegue falar bem com modelos como Codellama ou Codestral. Porque não tem prompts adequados pra eles. Alguém tem que produzir PRs disso. Não é automático, depende de muito teste e tentativa e erro até acertar.

Isso dito, felizmente com o Qwen3 ele funcionou razoavelmente bem sem nenhuma configuração extra. Com o ollama da branch master, carrega direitinho, ou conectando via OpenRouter.

### O Veredito

Você vai ver um tanto de tweet compartilhando "gráficos" de "benchmarks" e dizendo "uau, olha que incrível"

![exemplo de fakenews](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/pa8p2i7givn9sqeldkx2mfog9wws?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-28%2020-32-42.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-28%252020-32-42.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001330Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=ae0ff782140a014ad7efa94ab80329907a7273287242af763f4d14a7faf79639)

**NÃO ACREDITE EM NENHUM DELES**

Faça seus próprios testes. É literalmente um comando apontando pra OpenRouter, zero setup (ollama master é só se for rodar local). Você pode testar IMEDIATAMENTE na sua própria máquina via essa API.

Esses gráficos não me dizem nada. Eu fiz os mesmos testes que fiz com o Qwen2.5, Deepseek, Gemini, Claude etc. Eis o [pull request com amostras de código do Qwen3](https://github.com/akitaonrails/Tiny-Qwen-CLI/pull/5). Mesma coisa dos outros pedi pra refatorar alguns métodos e fazer um teste unitário.

Assim como Qwen2.5:7b-instruct e Gemini, e contrário ao Qwen2.5:32b, este novo Qwen3 se deu muito bem. Minhas primeiras impressões:

- ele é MUITO mais rápido que o Qwen2.5. Pelo menos na minha máquina local, na versão 14b, senti tokens/seg muito mais veloz. Nessa velocidade, eu acho viável de usar local.
- O reasoning/deep thinking dele é MUITO superior ao do Qwen2.5, se aproximando à linha de raciocínio do Claude ou Deepseek R1. Deu pra ver ele parando pra pensar melhor antes de sair cuspindo código aleatório.
- Resultado dos refactoring: os dois métodos mais "sujos" desse meu projetinho é um "ensure_model_loaded" e o "chat" que é loop principal. O Qwen2.5 não conseguiu refatorar eles direito, o Gemini sim, e agora o Qwen3 também: na **primeira tentativa**.
- Mais do que isso: na primeira tentativa ele não quebrou o código. Eu testei buildando e rodando e continuou funcionando como deveria.
- Os testes ele se bagunçou mais e teve muita dificuldade. Mas metade da culpa é minha: eu não dei o contexto completo (não mostrei os arquivos em "helper_functions/") por exemplo. Sem esse contexto ele não sabia se eram coisas fixas, dinâmicas, ou o que esperar.
- Dando esse contexto, ele conseguiu sair dos erros e conseguiu fazer o teste passar. Não ficou um bom teste, mas como falei, acho que faltou eu explicar melhor o que eu queria. Mas era parte do desafio, eu só mandava um "tenta fazer um teste que passa".

Sendo muito mais veloz que o qwen2.5, não tem tanto problema que eu precisei explicar mais, porque ele devolvia respostas razoavelmente rápidas. Pelo menos nesses testes preliminares, se ninguém tivesse me falado, eu acreditaria que estava conversando com o ChatGPT o4-mini ou com o Sonnet 3.7. De fato o Qwen3 foi um salto muito bom em cima do Qwen2.5. E como falei no post anterior, não precisa ser o modelo 32b: pode ser o menor de 14b. Imagino que o 7b também funcione bem em hardware mais modesto.

Isso se aproxima muito de conseguir ter um assistente de código competente, do calibre de um o4-mini da vida. E no mínimo é mais uma boa alternativa pra usar no lugar do Claude ou ChatGPT, caso eles não estejam dando boas respostas num problema específico.

Eu ainda sinto que o Gemini 2.5 Pro Exp é melhor, mas a margem diminuiu. Onde o Gemini ainda supera, é no algoritmo deles de Sliding Window Attention que permite ter uma janela de contexto muito maior. Mesma coisa com o Deepseek. Mas como também já falei, não significa que dá pra jogar um projeto gigante nele e esperar que ele consiga dar bons resultados: quanto maior o contexto, sempre vai piorando as respostas.

Todo mundo já sentiu que no chat web, quando a conversa vai enrolando sem boas respostas, não adianta insistir: é melhor começar uma nova sessão vazia, que tem mais chances de ter respostas melhores. E esse é o motivo: contexto em excesso prejudica as respostas seguintes. E por isso ainda é impossível subir um projeto inteiro e esperar bons resultados. 1 milhão de tokens parece muito, mas entendendo isso, não é tanto assim.

Enfim. O principal é que sim, o Qwen3 represente um salto muito bom no mundo de LLMs open source. Agora a expaectativa é se o Deepseek R2 vai superar e em quanto.
