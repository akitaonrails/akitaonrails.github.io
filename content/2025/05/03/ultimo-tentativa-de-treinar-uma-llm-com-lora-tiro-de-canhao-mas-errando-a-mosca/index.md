---
title: Último Tentativa de Treinar uma LLM com LoRa. Tiro de canhão, mas errando a
  mosca.
date: '2025-05-03T21:15:00-03:00'
slug: ultimo-tentativa-de-treinar-uma-llm-com-lora-tiro-de-canhao-mas-errando-a-mosca
tags:
- qwen3
- vllm
- runpod
- llm
draft: false
translationKey: last-lora-training-attempt
---



Ok, eu sou insistente. no [post anterior](https://www.akitaonrails.com/2025/05/03/ensinando-zig-mais-recente-pra-sua-llm-treinando-loras-quase) expliquei tudo que eu sabia sobre tentar fazer fine-tuning de um modelo com LoRa. Mas é um processo tedioso, demorado, e limitado à "pobreza" da minha RTX 4090. Em 24GB de VRAM tem que caber o modelo, coisas como KV cache, dataset de treinamento e espaço pra processar tudo. Apertando, cabe o modelo Qwen3-8B e 1MB de dataset e já era. Vai usar 21GB constantemente durante mais de 1 hora e o resultado final, apesar do modelo conseguir responser "sim, eu sei Zig 0.14", não é bom - porque o modelo base de só 8B já não era grande coisa.

A saída: migrar meu treinamento pra uma máquina maior. Comecei tentando uma A40, pra ver se 40GB era suficiente pra caber o modelo Qwen3-32B pra esse treinamento. E não, não coube.

"Ph0da-se", pensei. Aluguei a maior configuração que tem na RunPod:

![H100](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/9m5uitxvhhbpotu5lkbrw0znd276)

Essa H100 já é "obsoleta", nos datacenters mais modernos já existe H200 Blackwell e outras coisas maiores. Mas no mundo mais de "mortais", uma H100 ao custo de USD 3 por HORA, vai ter que servir. O bom: tem 80GB de VRAM. E o que eu não esperava: até isso é pouco!

E aqui a vantagem de ter feito tudo organizado e subir neste [repo no GitHub](https://github.com/akitaonrails/qwen3-zig-lora-training). O setup foi trivial: foi só escolher subir um pod com image de PyTorch 2.8 com Python 3.10 e Cuda 12.8, que são as versões estáveis mais recentes. Baixar meu projeto, rodar um `pip install -r requirements.txt` e já podia rodar meu `./train-lora.py`.

Eu ia adicionar de volta aqueles 15MB de código-fonte da Standard Library do Zig mais novo, mas mesmo na H100, não coube! O treinamento só com o 1MB original que eu usei ontem também, já fez a máquina ficar entuchada quase no máximo:

![74GB](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/iahqr9hzs2aaku3fup7u3cw9navk)

Olha que absurdo: ficou o tempo todo do treinamento ocupando quase 75GB dos 80GB que tem de VRAM. Literalmente não dá pra fazer treinamento com muito mais material que isso. Ou precisa descer pra um modelo menor, como o Qwen3-14B. Eu ainda não sei se 32B com menos material ou 14B com mais material, qual seria a melhor combinação. Eu já sei que 8B não presta pra programar nada complicado. 14B já tive um pouco mais de sucesso em testes, mas também não faz nada muito complicado. 32B não é garantia que faz muito melhor: o Qwen2.5-32B não se saiu melhor que o 14B, mas o novo Qwen3-32B tem "cara" que é mais estável. É isso que estou querendo testar, com o LoRa.

Isso foi na hora de almoço. Estou escrevendo este post na hora da janta. Esta foi a previsão do treinamento:

![6h](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/lzrfdl97n96qesnhde33lugidr3i)

Essa estimativa fica variando, mas eu acho que levou em torno de 5 a 6 horas mesmo.

![lora size](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/stoakih27g3o9c1e1d07y14szrf0)

E no final dessas quase 6 horas, foi isso que gerou: um LoRa de 5.1GB (contra os 3GB de ontem). Tamanho não é documento. Não significa que maior é melhor. Vamos ver.

### Depois do Treino

Agora que acabou o treinamento, posso usar o mesmo pod com a H100 pra também servir esse modelo com o Lora, e precisaria ser ele de qualquer forma. Pra rodar é assim:

```bash
vllm serve Qwen/Qwen3-32B \
    --enable-lora \
    --lora-modules ziglora=./qwen3-zig-lora \
    --max-model-len 10000
```

E precisa limitar ainda o tamanho do contexto. Por default o vLLM tenta subir com contexto de 40k tokens e, mesmo na H100, com 80GB, ele falha a inicialização com este erro:

![KV Cache error](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ykusgib7o6wybhi5rs4zvx2yrp8j)

Não sobra espaço pra subir o KV Cache (em resumo, no processo de geração de próxima palavra, vai adicionando uma nova linha e uma nova coluna na matrix, mas não precisa recalcular as linhas/colunas anteriores, é o mesmo resultado. Daí tem esse cache).

Um comportamento estranho tanto na minha máquina quanto na H100. Não sei se isso acontece sempre que carrega um Lora, ou se meu Lora tem defeito, ou se tem alguma configuração que eu não estou vendo. Mas carregando com Lora, a inicialização é EXTREMAMENTE LENTA. Subir o vLLM, que normalmente leva 1 minuto, agora leva 5 minutos, ou mais. Não sei o que causa isso, mas não é um tipo de servidor que pode ser facilmente desligado e religado. Faz eu ter saudade de subir um servidor J2EE ... 

Falando sério, parece que não sou só eu. Esta [Issue](https://github.com/vllm-project/vllm/issues/6876) não teve solução. "Pode" ser algum bug no vLLM, "pode" ser uma combinação de fatores que ninguém sabe. Mas nem a GPU e nem a CPU estão processando nada. CPU não sai de 10% de uso, GPU parece que está só esperando. Realmente, à primeira vista parece algum problema de I/O. Talvez o processo de checar os shards de checkpoints, puxando de um network volume, seja lento. Mas como vou rodar só hoje, não me preocupei em debugar isso.

![slow load](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/mluc626od3h1q0swnv8kepe1aji5)

Olha isso. 8 MINUTOS nessa parte de carregar checkpoints. E depois ainda continua outras fases que também demora mais um pouco. Vou deixar essa foto aqui, caso alguém já tenha visto e saiba o que pode ser.

Só pra tirar a dúvida, experimentei subir o vLLM só com o Qwen3 e tirando a LoRa completamente e, pra minha surpresa:

![sem lora](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2hzvcqrk087i5ov4otx0rxa8erdf)

Também levou quase 8 minutos. Então o problema não é a LoRa. Ou é alguma coisa do vLLM que dá pra configurar - mas eu não sei como - ou é uma limitação do próprio modelo Qwen3-32B que é lento assim mesmo pra carregar. 

Enfim, com Lora, tentei diminuir pra 16k tokens: não sobe. Tentei subir com 10k tokens. E nesse ponto eu diria que esse teste já fracassou. Um Qwen3-32 teoricamente tem capacidade de suportar janelas de até 40k tokens. Não é grande, mas dá pra trabalhar um pouco nesse contexto.

Mas abaixo de 15k tokens já não dá pra usar com ferramentas como Aider, que precisa mandar system prompts longos pra instruir a LLM como se comportar pra cuspir código que ele consegue capturar. Então é isso: um Qwen3-32b + Lora, numa H100 SXM de 80GB de VRAM, não é usável de verdade.

E eu até ficaria triste ou frustrado caso um modelo de 32B fosse realmente, ordens de grandeza melhor que um 14B da vida, mas nos meus testes empíricos: não é. Ele faz tanto erro quanto, e não é tão melhor assim que compense pagar tão caro por uma infra própria topo de linha. Todos eles male male só conseguem fazer códigos simples, e mesmo assim com erros.

No final, com 10k o server subiu, consumindo absurdos 63GB na inicialização, sem nem começar a processar:

![63GB](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/uetjwlzlgy7bpd4itn1qxczl3mhs)


E ...

### Primeiros Testes

Depois de 10 minutos esperando, tive que dar Ctrl+C e começar tudo de novo. Porque eu fui burro. A RunPod é pra realmente rodar coisas experimentais, não sei se confio pra produção. Ela é mais um VPS do que uma AWS. E eu estou gambiarrando subindo um pod que espera ter mapeado só a porta 8888 pra subir um server de Jupyter Notebook (que eu não estou subindo).

![runpod connect](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/h4pzcdxydfiou5iulc7m67zctb9a)

MInha idéia é usar essa porta pra mapear o vLLM. Mas por default ele sobe na porta 8000. Eu esqueci de colocar `--port 8888`:

```
vllm serve Qwen/Qwen3-32b --enable-lora --lora-modules ziglora=./qwen3-zig-lora --max_model_len 10000 --port 8888
```

E lá vamos nós de novo, esperar mais 10 minutos ... ... e finalmente subiu na porta certa e agora podemos testar. Primeiro, os teste de curl:

![curl hello](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/p8d3ogzwd7lzpu05o7lkm50f8k4h)

E antes que alguém comente: não tem problema estar aparecendo a URL do meu pod na foto. Eu vou apagar esse pod antes de publicar este post.

Aliás, se subir um modelo remoto, como eu fiz, depois é só pegar a URL e colocar na variável `OPENAI_API_BASE` e qualquer coisa em `OPENAI_API_KEY` e ferramentas como Aider vão funcionar igual. A API do vLLM e Ollama são compatíveis com da OpenAI.

Como podem ver, a primeira pergunta respondeu parecido com meu teste local com o Qwen3-8B. Nada demais, isso já sabia que funcionava. Vamos pedir pra explicar uma funcionalidade nova do Zig 0.14.

Aliás, além de lento pra iniciar, também fica mais lento pra gerar texto, BEM mais lento. Eu devo ter feito algo errado no treino, mas eu senti a mesma coisa no Lora local ou na H100. Fica notavelmente mais lento. Ele fez mais um "think" longo, mas a resposta desta vez é mais condizente com o release note (cortei só o trecho que interessa):

```
In Zig 0.14.0, the `@splat` function has been extended to support arrays, making it easier to initialize fixed-length arrays with a single repeated value. This replaces more verbose or unsafe initialization patterns and is type-safe, with the array's length inferred from the destination type. Here's a concise explanation and code example:


...

### **@splat for Arrays**  
`@splat(value: T) [N]T` creates an array of length `N` where every element is `value`. The array's length and element type are determined by the context in which `@splat` is used.  

### **Code Example**  

const Point = struct { x: i32, y: i32 };  

pub fn main() void {  
    // Initialize an array of 5 integers with 42  
    const numbers: [5]i32 = @splat(42);  

    // Initialize an array of 10 booleans with true  
    const flags: [10]bool = @splat(true);  

    // Initialize an array of 7 points with (0, 0)  
    const origin_points: [7]Point = @splat(Point{ .x = 0, .y = 0 });  
}  
....
```

O código de exemplo também faz um pouco mais de sentido. Comparado com a versão 8B, pelo menos a explicação foi melhor. Mas pode ter afetado que eu fiz uma pequena modificação no dataset: eu dupliquei o release notes, pra tentar um pouco mais de ênfase nas funcionalidades novas. Provavelmente isso também fez efeito.

Agora vamos ver se ele consegue fazer algum código que funciona. Meu prompt foi este:

```
"Can you give me a Zig 0.14 code example of a simple program that acts like an interactive chat, so the user can input messages. then the message is parsed to see if there are commands such as '/list', which will list the files in the current directory, or '/cat' which will read the file asked, or '/quit' to exit the chat?"
```

E isto aconteceu:

![abort](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/4n3bzm5g0gt46jfmqv55qy0x9tlu)

Lembra como eu tive que ir diminuindo contexto pra conseguir subir? E lembram como eu falo que "thinking" desperdiça muitos tokens? Pois é. O modelo se auto-crasheou pensando demais. Tentei algumas vezes e ele crasheia. Pra tentar evitar isso, tentei fazer o `curl` mandando `enable_thinking=false` assim:

```bash
❯ curl https://d8zck5aw8eimij-8888.proxy.runpod.net/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
        "model": "ziglora", "temperature": "0.1", "enable_thinking": "false", "skip_special_tokens": true,
        "messages": [{"role": "user", "content": "..."}]
      }'
```

Temperatura, pra código, eu acho que não dá pra ser muito maior que 0.1. Pra bate-papo, coisas menos exatas, o padrão de 0.6 que todo mundo usa é ok. Mas pra código, eu realmente não preciso que ele fique sendo "criativo" (aleatório, na verdade), eu quero respostas o mais exatas quanto possível.

Enfim, mesmo tentando desligar o thinking, alguma coisa está errada. Possivelmente o LoRa que eu adicionei está fazendo ele "pensar em círculos" e nunca conseguindo retornar, estourando o contexto. Tentei várias vezes, mas ele está sendo incapaz de responder código.

### Final: Desisto por enquanto

Sim, eu quebrei a LLM, ao que parece kkkkk 😅

Tentei várias vezes e ele realmente não consegue me devolver nenhum código. E eu sei que ele está tentando, porque se eu mando `stream=true`, eu consigo ver devolvendo tokens, mas em algum momento acaba espaço em algum lugar (com certeza o contexto, que é pequeno) e crasheia.

A sensação é que meu LoRa provavelmente "grudou" demais e desbalanceou parâmetros demais. Agora o modelo começa a escrever o texto e começa a entrar em pensamento circular, sem nunca parar de gerar mais texto. 

Isso com certeza é efeito do Lora e de algum erro no treinamento. Se eu tiver que chutar, é porque eu enfiei textos super longos no treinamento, sem indicações manuais de aonde acaba cada parte com um `<|im_end|>` da vida. Sem isso, talvez ele ache que o texto inteiro é uma resposta e ele tem que responder longo assim. Pelo que entendi, no caso desse treinamento de Zig, eu teria que decompor a documentação, o release notes e tudo mais em pedaços menores, assim:

```
<|im_start|>system
You are a helpful assistant.<|im_end|>
<|im_start|>user
What is Zig?<|im_end|>
<|im_start|>assistant
Zig is a compiled programming language...<|im_end|>
``` 

E fazer isso pra todas as 200 mil caracteres de documentação. Imagina o trabalho pra fazer isso. E evitar enviar textos super longos em contexto de começa e onde acaba cada parte.

Pelo menos, esse é meu chute. O problema: mesmo se eu gastar tempo formatando assim, daí são mais 6 horas processando, pra só depois saber se fez alguma diferença. Provavemente não vai fazer, preciso pensar outra hipóteses, e cada vez são 6 a 12 horas entre setup e processamento.

A partir deste ponto é um trampo que eu não tenho motivação pra fazer. Estou deixando anotado aqui pra ver se isso chega na mão de pesquisadores de verdade. Talvez seja algo que um pesquisador de I.A. ache super óbvio. Mas este é o ponto: essa informação não existe fácil publicamente em lugar nenhum. Todo exemplo que se acha online são muito simples. Só falam _"nesta linha de python você carrega o dataset, e nesta próxima linha começa o treinamento"_ - mas cadê as instruções de COMO fazer um dataset e COMO determinar se ela é adequada? Não tem.

Se alguém tiver dicas de como melhorar o treinamento ou quiser um problema de pesquisa na área, [este é o GitHub](https://github.com/akitaonrails/qwen3-zig-lora-training) com todos os códigos e material de treinamento que eu fiz. Está faltando pesquisadores olharem pra esse tipo de coisa e divulgar melhor o que sabem. Eu sei que alguém sabe, mas só sair fuçando no Google não me levou a lugar algum.
