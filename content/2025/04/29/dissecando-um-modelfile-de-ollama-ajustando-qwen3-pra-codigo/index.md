---
title: Dissecando um Modelfile de Ollama - Ajustando Qwen3 pra código
date: '2025-04-29T02:30:00-03:00'
slug: dissecando-um-modelfile-de-ollama-ajustando-qwen3-pra-codigo
tags:
- ollama
- modelfile
- qwen3
- llm
draft: false
---



A notícia quente do dia é o lançamento do novo modelo Qwen3. Eu mesmo [postei a respeito hoje](https://www.akitaonrails.com/2025/04/28/testando-o-recem-lancado-llm-open-source-qwen3-com-aider-e-ollama) E já fiquei bem impressionado. Achei que ia deixar por isso mesmo, mas aí vi este tweet:

![ivan qwen tweaks](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/1jgq3ar5c5l7wfjt9wjfui8l598z?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-29%2001-55-55.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-29%252001-55-55.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001331Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=161e7b40b1e7a54be99e719d69e4938c6e0bb2bb9015077489da9c5889ca7c5b)

Veja o [texto completo neste link](https://x.com/ivanfioravanti/status/1916934241281061156)

Mas ele dá dicas de como "tunar" esse novo modelo, mais pra questões matemáticas e fiquei pensando se tem como tunar pra desenvolvimento de software. Antes que pesquisadores mais avançados me xinguem: essa é minha primeira vez mexendo nos parâmetros de uma LLM, então se quiserem adicionar contexto nos comentários, sejam bem vindos.

Vamos lá. Primeiro, o que são esses TopP, TopK e tudo mais que o Ivan fala no tweet dele? São parâmetros de **KEY SAMPLING** (sorteio de chaves). É um grupo de parâmetros que controlam _COMO_ o modelo seleciona o _PRÓXIMO TOKEN_ e vai completando o texto (dando a "resposta"), a partir do seu vocabulário baseado em distribuição de probabilidade que ele calcula. Os mais comuns são justamente `temperature`, `top_p`, `top_k` e algumas vezes `min_p` ou `repeat_penalty`.

Eu sempre falo: LLM é um gerador de próxima palavra, um completador de texto baseado em probabilidades. Quando a LLM processa seu input (seu contexto, histórico do chat e a próxima pergunta), ele precisa calcular o "score" de probabilidade pra cada palavra ou sub-palavra (token) no seu vocabulário inteiro. Imagina um modelo gigante, ele precisa recalcular pra tudo o tempo todo, pra cada próxima palavra.

Parâmetros de sampling dizem pro modelo "como escolher o próximo token" da lista de probabilidades. Sem esses parâmetros o modelo escolheria um decodificador "greedy" (ambicioso demais). Significa que ele ia só pegar o token com a maior probabilidade toda vez. E isso leva a um resultado repetitivo e que soa pouco natural. Sampling adiciona um tipo de "aleatoriedade controlada" (lembram? eu sempre falo que tem aleatoriedade misturado, nunca a resposta é "certa"), e isso torna a resposta mais "interessante" pra um ser humano (facilmente enganável). Eis alguns dos parâmetros:

### Temperatura

Controla a aleatoriedade, que muitos chamam de "criatividade". Essencialmente torna a distribuição mais quente (mais espalhada e mais plana) ou mais fria (com mais picos ao redor dos mesmos tokens). Quanto maior a temperatura (até 1.0) isso aumenta a probabilidade de escoher tokens que tinham probabilidades calculadas menores. Quanto menor a temperatura (até 0.0) menores as chances dos tokens calculados com menor probabilidade, mais "greedy" vai ser o resultado (menos "humano").

Pra código, deixe muito alto e aí que surgem "alucinações" (que é basicamente aleatoriedade aumentada) e código que não faz sentido. Se for zero, vai ser muito "boilerplate", repetitivo, usando padrões muito comuns e pode potencialmente acabar num loop infinito sem resposta (porque ele não consegue puxar nada diferente).

O tweet sugere 0.6 que é moderado. Mas nos meus testes, temperatura tão alta começou já a me dar uns códigos esquisitos. Do nada ele mudava nome de variável. Do nada aparecia um caracter chinês no meio do código (literalmente). Eu acho que 0 é muito baixo, mas 0.1 é suficiente, talvez 0.2.

Isso você pode mudar no arquivo `~/.aider.model.settings.yaml` antes de carregar o modelo (esses parâmetros podem ser reajustados na inicialização):

```yaml
- name: ollama_chat/qwen3-dev:latest
  extra_params:
    temperature: 0.1
    num_ctx: 40960
```

### top_p (Nucleus Sampling)

Aqui vai complicando. Esse `top_p` serve pra selecionar tokens do menor conjunto de tokens cuja probabilidade cumulativa exceda esse limite "p". O modelo então puxa samples somente desse conjunto reduzido.

Esse modelo ordena todos os tokens por suas probabilidades em ordem descendente (do maior pro menor). Então começa a adicionar suas probabilidades até a soma ser maior ou igual a `top_p`. Todos os tokens incluídos na soma, formam o tal "nucleus" e desse conjunto ele sorteia um próximo token. Então é um sorteio dos tokens com sum(x) maiores probabilidades, mais ou menos. "Escolha um dos vencedores, mas não necessariamente O vencedor (que seria greedy)".

### top_k

Considere somente os "k" tokens mais prováveis. O modelo só sorteia (sample) desse conjunto reduzido dos top K maiores probabilidades de tokens. Isso é realmente dizer "escolha um dentre os Top 10 melhores". Quanto maior o K maior a diversidade, quanto menor mais greedy.

E isso é relativo, top_k e top_p agem em conjunto. Essa configuração ajuda a ancorar a seleção aos tokens "mais prováveis" enquanto ainda permite ao top_p filtrar e tirar os de menor probabilidade. Isso prioriza plausibilidade (top_p) enquanto restringe o número total de tokens sorteados (top_k). Ajuda a manter o resultado focado nas respostas mais possivelmente "certas" (mas de novo, é um sorteio/sampling).

### min_p

Filtra e tira tokens cuja probabilidade são menores que "min_p" vezes a probabilidade do token mais provável. Antes do sorteio, o modelo identifica o token com maior probabilidade (P_max), então remove qualquer token com probabilidade (P_token) que é menor que `P_max * min_p`. O sorteio então acontece a partir da lista que sobra (que vai ser mais filtrada por top_p e top_k). 

Isso previne que o modelo escolha tokens que são "extremamente improváveis" relativo à escolha mais óbvia.

### repeat_penalty

Isso desencoraja o modelo de repetir os mesmos tokens que já apareceram recentemente no histórico da conversa ou texto gerado. 

Antes do sorteio, a pontuação de probabilidade dos tokens que já foram vistos recentemente são reduzidas, dividindo por essa `repeat_penalty` (com valores maiores que 1, já que dividir por 1 é ele mesmo, então mantém a mesma probabilidade).

Se deixa 1.0, pode começar a repetir as mesmas respostas ou os mesmos códigos, até os errados. Se for alto demais, muito acima de 1.0, a resposta pode ser pouco natural, já que às vezes precisa mesmo repetir alguma coisa pra re-explicar. Um valor moderado lá pelo 1.1 a menos de 1.2 pode ser mais adequado pra não punir demais o que já está no histórico.

### num_predict (max tokens pra gerar)

O absoluto máximo de tokens que o modelo vai gerar de resposta. Se passar, vai truncar. Se for um número pequeno demais, especialmente em resposta de código - que pode ser longo - pode truncar demais e deixar resposta incompleta. Se for grande demais vai aumentar muito o processamento e vai exigir muito mais recursos da máquina e mais tempo e pode ser um desperdício.

Um valor de uns 32 mil tokens tem bastante espaço pra tokens. Tem que testar, e varia caso a caso pro tipo de resposta que você espera e o que cada modelo suporta.

### Recomendado

Sabendo tudo isso agora você também consegue ler o tweet do Ivan e entender. Ele  recomenda Temp 0.6, TopP 0.95, TopK 20, MinP 0.

Eu mexi mais um pouco. E eu acho que pra código, Temp tem que ser na faixa de 0.1 ou 0.2. Também acho que vale um "repeat_penalty" de 1.1 pra evitar repetições desnecessárias, especialmente de código. De novo, tem que testar. São números empíricos e não exatos.

Eu criei um [projeto no meu GitHub](https://github.com/akitaonrails/qwen3-dev) com um arquivo completo de modelo que implementa não só esses parâmetros mas já pré-configura um prompt de sistema pra enviesar o modelo a ser um assistente de código primeiro. Eis meu prompt:

```
SYSTEM """
You are a highly functional AI assistant specializing in software development tasks.
Respond to queries about coding, algorithms, debugging, system design,
and programming languages/frameworks.
Provide clear, accurate, step-by-step reasoning and functional code examples.
Always format code snippets using markdown triple backticks (```language ... ```).
Aim for comprehensive and correct technical assistance.
Never suggest changing code unrelated to the question topic at hand.
Restrict yourself to the minimum amount of changes that do resolve the problem at hand.
Avoid renaming functions or variables unless absolutely necessary, 
and in doing so make sure if there's anyone calling the old names, 
for them to be renamed to the new names. Never leave the code in a broken state. 
Pay close attention to correctness, not just answering the quickiest and dirtiest code to solve the problem.
"""
```

Pra fazer esse arquivo, primeiro eu puxei o Modelfile original do Qwen3 com este comando:

```
ollama show qwen3 --modelfile > Modelfile
```

É importante fazer isso porque, pelo que entendi, modelfiles não herdam do anterior. Não é que nem um "FROM" de um Dockerfile, onde você continua uma nova imagem a partir da base anterior.

Depois de editado com meus ajustes - que já está no meu GitHub, é só criar um novo modelo:

```
ollama create qwen3-dev -f qwen3-dev.modelfile
```

E ele vai aparecer no seu ollama local. Veja com `ollama list`:

``` 
❯ ollama list
NAME                                            ID              SIZE      MODIFIED
qwen3-dev:latest                                fe03dfae5484    9.3 GB    About an hour ago
qwen3:32b                                       e1c9f234c6eb    20 GB     2 hours ago
qwen3:14b                                       7d7da67570e2    9.3 GB    8 hours ago
qwen3:latest                                    e4b5fd7f8af0    5.2 GB    8 hours ago
qwen2.5-coder:7b-instruct                       2b0496514337    4.7 GB    25 hours ago
....
```

Viu o `qwen3-dev:latest`? É nosso novo modelo com ajustes de parâmetros. No aider é só usar ele direto:

```
aider --watch-files --model ollama_chat/qwen3-dev:latest
```

Lembrando de ajustar o `.aider.model.settings.yml` como já mostrei acima.

Eu não fiz testes longos ainda, mas resolvi brincar com o modelo 14b como base e esses ajustes. O modelo base já me impressionou e pelo menos meus ajustes não quebraram nada. Fiquei fazendo os mesmos refatoramentos e testes unitários no meu projetinho educativo e subi mais um [pull request](https://github.com/akitaonrails/Tiny-Qwen-CLI/pull/6)

Eu acho que o Gemini 2.5 Pro Exp é um pouco melhor, mas de novo, não por uma margem muito grande. E em alguns casos (como na refatoração), eu acho que prefiro o código gerado pelo Qwen3. Compare com o código que consegui com o Gemini, neste [outro pull request](https://github.com/akitaonrails/Tiny-Qwen-CLI/pull/3)

Com o Gemini eu precisei explicar menos e ele deu menos erros, mas ambos conseguiram fazer o que eu pedi até o fim e sem quebrar o programa principal. Mas o Qwen3 me parece bom o suficiente pra eu querer usar ele. Com a vantagem que mesmo sendo o modelo médio, de 14 bilhões de parâmetros (que roda na minha VRAM de 24GB com sobra), ele ainda dá resultados muito bons e limpos de código. E melhor: roda MUITO, mas MUITO mais rápido que o Qwen2.5 32b.

Pra quem tem GPUs com menos VRAM, digamos, uma 3070 ou 4070 de 16GB, dá pra usar o modelo menor ainda, de 7b. Eu testei o qwen2.5-coder:7b e tive resultados excelentes, então imagino que o Qwen3 de 7b deve ser ainda melhor e muito mais rápido. Velocidade que é comparável ao Claude ou Gemini, que são muito maiores e rodam em máquina muito mais parruda que uma RTX 4070.

Rodando meu qwen3-dev, no meu monitoramento minha CPU ficava maior parte do tempo em idle e a GPU o tempo todo acima de 90%, consumindo mais quase 400W constantemente, mantendo temperatura de 73 graus (o que é bom).

![btop](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/jv8ub1bc6m70u1agm1nyiooav2mk?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-29%2001-44-38.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-29%252001-44-38.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001333Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=53e86310b22e6998c938977f6202be1c59f398de51aab41e333b88a88813a0c5)

Tive até um pequeno incidente onde meu PC desligou do nada, porque a extensão temporária que eu estava usando não aguentou e morreu. Somado com a CPU e meus outros dispositivos ligados na mesma tomada, estava puxando consistentemente 1000W da parede por horas. Brincar de I.A. usa **MUITA** energia, com ar-condicionado ligado porque só pra dissipar tudo isso, meu apartamento fica 1 a 2 graus (que eu chuto) acima do normal. Dá pra sentir mais quentinho mesmo kkkk

Mas é isso, espero que tenham entendido como que as coisas funcionam de verdade por baixo dos panos. Não tem mágica: é geração de próxima palavra, baseada em sorteio semi-aleatório de probabilidades. 

Now you know.
