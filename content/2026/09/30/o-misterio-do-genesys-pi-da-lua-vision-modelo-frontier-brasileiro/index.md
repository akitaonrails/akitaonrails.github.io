---
title: "O Mistério do Genesys PI da LUA Vision - Modelo Frontier Brasileiro??"
slug: "o-misterio-do-genesys-pi-da-lua-vision-modelo-frontier-brasileiro"
date: '2026-09-30T19:00:00-03:00'
draft: false
translationKey: o-misterio-do-genesys-pi-da-lua-vision-modelo-frontier-brasileiro
description: "Depois do primeiro teste do Genesys PI, a LUA Vision corrigiu bugs na API e eu rodei tudo de novo: custo caiu 85%, o House subiu pra 95,5 e o Enterprise ficou igual. Fiz também uma análise forense de caixa-preta pra responder se o modelo é um Qwen rebatizado, um gpt-oss disfarçado ou um proxy de API. Separo o que está checado do que ainda é só a palavra deles."
tags:
- benchmarks-de-llm
- llms
- inteligencia-artificial
---

Semana passada publiquei [o primeiro teste do Genesys PI](/2026/09/23/llm-benchmark-v4-genesys-pi-novo-competidor-brasileiro/), o modelo da LUA Vision, no meu benchmark v4 de sabotagem. O resumo daquela rodada: o tier House fechou em 83,5, empatado com o Grok 4.7 no meio do pelotão, e o Enterprise em 82,5, um degrau abaixo.

Os dois pegaram toda sabotagem barulhenta; o House deixou passar os dois itens silenciosos que quase todo modelo deixa (#7b e #8), e o Enterprise deixou três (#7a, #7b e #9). O custo nocional do House, uns $460, foi o mais caro da tabela inteira, e a causa era ausência de cache de prompt na API.

Muita coisa aconteceu desde então, e este texto é a continuação. Vou na ordem que interessa: primeiro os números novos, depois a pergunta que todo mundo me fez em comentário e DM ("isso não é um Qwen com adesivo?"), e só no fim a parte especulativa sobre o que a empresa diz que construiu.

Antes disso, o pano de fundo que deixa tudo isso estranho: o consenso da indústria é que treinar modelo de fronteira custa dezenas ou centenas de milhões de dólares em GPU, e que, portanto, uma empresa pequena, sem rodada de investimento bilionária, não deveria chegar nem perto de um. O gpt-oss, o modelo aberto da própria OpenAI, com o laboratório mais bem financiado do mundo atrás, não conseguiu completar o meu benchmark no mesmo harness em que o Genesys PI rodou. O modelo brasileiro completou duas vezes por tier.

Este texto é organizado em cima dessa tensão. Primeiro, o que o modelo fez em experimentos que eu controlo. Depois, o que eu consegui e o que não consegui verificar sobre como ele existe.

## Disclaimer novo

Desde o primeiro artigo, conversei diretamente com dois dos quatro cofundadores da LUA Vision: [Paulo Câmara](https://www.linkedin.com/in/paulocamara/), CTO, e [Eronides Junior](https://www.linkedin.com/in/eronidesjunior/), CRO. O Paulo é o responsável técnico, formado pela FGV com doutorado pela Universidade de Tel Aviv, e a tese dele é a origem declarada da arquitetura do modelo.

Antes da LUA, segundo o LinkedIn dele, o histórico é de consultoria corporativa pesada, implantação de Oracle EBS e ERP em empresa grande, e ele mantém uma série de ensaios sobre IA no LinkedIn. Já o Eronides cuida do lado comercial; antes da LUA ele foi [CRO da SoftwareOne Brasil](https://portalerp.com/br/noticia/eronides-junior-assume-a-posicao-de-cro-na-softwareone), depois de passar por marketing, serviços e operações na mesma empresa.

Repito o que já disse e vale dobrado agora que falei com eles: não tenho relação comercial nenhuma com a LUA Vision. Não sou sócio, não sou investidor, não assinei contrato, não assinei NDA, não recebi nada além da mesma chave de avaliação gratuita do teste anterior. Nada deste texto passou por eles antes de publicar. Até aqui, sou só um cara curioso com uma API na mão.

Esse último detalhe importa mais do que parece. Como não assinei NDA, nunca tive acesso a nenhum dado interno da empresa: nem peso, nem receita de treino, nem curva de loss, nem conta de hardware. Tudo o que vem abaixo é experimento de caixa-preta em cima da API pública e consulta a informação pública. Onde eu digo "checado", foi eu que medi; onde eu digo "eles dizem", é a palavra deles.

## Os números novos: re-teste depois das correções

Depois do primeiro artigo, o Paulo avisou que tinha corrigido alguns bugs na API, o principal sendo justamente o cache de prompt, e pediu que eu rodasse de novo. Rodei. É uma rodada limpa e independente dos dois tiers, no mesmo protocolo de 14 sabotagens, com a rodada original preservada intacta pra comparação lado a lado. Um detalhe de método: o v4 é um benchmark de rodada única, então a nota de vigilância tem ruído, e eu volto nisso já já.

Antes de rodar, confirmei que o cache existia mesmo. Um probe com prefixo repetido no endpoint devolveu `cached_tokens: 4121 / 4124` na segunda chamada. No teste original, esse número era sempre zero.

| Modelo | Nota (original → re-teste) | Nunca corrigido (original → re-teste) | Custo nocional (original → re-teste) | Tempo |
|---|:---:|---|:---:|:---:|
| **Genesys PI House** | 83,5 → **95,5** (+12,0) | #7b, #8 → **nenhum** | ~$460 → **~$70** (−85%) | 68min → 94min |
| **Genesys PI Enterprise** | 82,5 → **82,0** (−0,5) | #7a, #7b, #9 → #7b, #8 | ~$19 → **~$2,40** (−87%) | 39min → 33min |

Pra situar na tabela geral: na rodada original, o House empatava com o Grok 4.7 em 83,5. Com 95,5, ele passaria a empatar com o Claude Fable 5.1, o Sakana Fugu Ultra v2 e o GPT 6 luna, na posição 9 entre 46 modelos. O Enterprise, a 82,0, empataria com o DeepSeek V4 Pro (base). Digo "empataria" porque, como explico abaixo, mantive a rodada original como entrada oficial do ranking.

E vale deixar a régua explícita: não estou dizendo que o Genesys PI é equivalente ao Fable em todos os sentidos. Estou dizendo que, neste cenário de teste específico, ele se saiu como o Fable. Em outra carga de trabalho, o seu resultado pode ser diferente.

O que melhorou de forma clara e reproduzível:

- **Custo caiu 85% a 87%.** O volume de token foi o mesmo, uns 40 milhões no House e uns 20 milhões no Enterprise, mas agora o contexto repetido é cobrado na taxa de cache em vez do preço cheio de entrada. O House sai de rodada mais cara da tabela pra custo médio.
- **Confiabilidade.** A rodada original do Enterprise precisou de uma segunda tentativa por causa daquele loop de `grep` no primeiro sprint. No re-teste, convergiu de primeira. Nenhum loop nos dois modelos.
- **Disciplina de teste.** O Enterprise original não escreveu teste automatizado nenhum. No re-teste, escreveu uma suíte RSpec de verdade, com teste de model, request e sistema.
- **Detecção mais cedo.** Os dois pegaram as sabotagens barulhentas (#1 a #3) até o sprint 3, e o House pegou tudo de #1 a #6 até o sprint 4, coisa que as rodadas originais deixaram, em parte, pro capstone.

O que não dá pra afirmar é que o modelo ficou mais vigilante. O House subiu 12 pontos, mas o Enterprise caiu meio ponto na mesma rodada. Como cache de prompt não tem como afetar detecção de sabotagem, dois tiers do mesmo modelo andando em direções opostas é o retrato de variância de rodada única.

Os +12 do House são grandes o suficiente pra sugerir que os outros ajustes do Paulo melhoraram o modelo, mas uma rodada por modelo não confirma isso. Pra separar sinal de ruído eu precisaria de três ou mais rodadas por modelo, o que não fiz.

Pra calibrar o tamanho desse ruído: nesta mesma semana, o GPT 5.5, que tinha 100,0 na tabela, rodou de novo com modelo e harness idênticos e fechou em 91,0. Nove pontos de diferença sem mudar nada. Então trate as notas de vigilância como uma faixa.

E os dois sobreviventes silenciosos continuam lá. No re-teste do House, o índice derrubado sem teste de guarda (#7b) e o agregado escondido (#8) só foram corrigidos na revelação; no do Enterprise, nem na revelação. É o mesmo ponto cego de disfarce que a maioria da tabela tem, incluindo modelo de fronteira.

> **Pra guardar:** o bug de cache está corrigido e verificado, e a redução de custo é real. A nota de vigilância ficou dentro do ruído: Enterprise igual, House pra cima mas sem confirmação estatística. Na tabela geral, mantive as rodadas originais como entrada oficial, justamente pra não premiar uma rodada só.

### Preço: ainda não é o final, e não vai ser por token

Os valores de custo acima continuam sendo nocionais, calculados em cima da tabela de exemplo que a API expõe, e a própria LUA já avisou, no artigo anterior, que aquilo não é o preço de mercado. Conversando com o Eronides, ele detalhou o que vem por aí: eles não pretendem cobrar por token, como todo mundo cobra, e o produto não é pra ser B2C como os chats de assinatura. A aposta é B2B, por licença de uso, com o modelo rodando na infraestrutura do próprio cliente.

Na prática, isso significa uma empresa com um modelo na faixa do Grok, capaz de tarefa avançada como programação, rodando on-premise, fora da nuvem, com a garantia de que nenhum dado sensível sai do prédio. Modelo de fronteira hoje é serviço de nuvem de empresa estrangeira, e setor regulado convive mal com isso. Se a LUA conseguir entregar exatamente esse pacote, e o "se" continua grande, isso muda o jogo pra muita empresa brasileira.

Mesmo com a ressalva de que o preço por token é só exemplo, o custo nocional ao lado da tabela ajuda a calibrar. As rodadas completas mais baratas do campo inteiro são o DeepSeek V4 Flash ($0,97) e o MiMo V2.5 Pro ($1,03); o Enterprise, a ~$2,40, fica nessa vizinhança. Do outro lado, o Opus 5.5 custou $16,63, o Sonnet 5 uns $27 e o GPT 5.5 $34,69. E o House, que na rodada original era a rodada mais cara de todo o campo, agora está no meio do pelotão.

A política de preço, segundo eles, sai em 7 de outubro de 2026.

## Experimento extra: o Genesys PI auditando o ai-jail

Benchmark de sabotagem mede vigilância dentro de um app pequeno e controlado. Eu queria ver o modelo num problema de verdade, então dei pra ele o meu [ai-jail](https://github.com/akitaonrails/ai-jail), o sandbox de sistema operacional que roda agente de código dentro de bubblewrap, Landlock e seccomp no Linux e `sandbox-exec` no macOS. É um projeto em Rust, com 776 testes unitários, 70 crates de dependência e uma superfície de segurança que eu conheço bem. A tarefa: auditoria de segurança completa da versão 2.3.0, somente leitura, com ameaça modelada, evidência por linha de código e reprodução onde desse.

Pra ter régua, rodei uma segunda auditoria independente, com outro modelo, sem acesso ao relatório do Genesys até fechar a própria lista de candidatos. Depois cruzei os dois relatórios e ainda comparei contra dois security advisories que estavam abertos no GitHub, escritos por gente de fora contra versões anteriores do projeto.

O relatório do Genesys PI (chamo de auditoria A) veio com 26 achados: 5 High, 17 Medium, 3 Low e 1 informativo. O da segunda auditoria (B) veio com 12: 2 High, 7 Medium e 3 Low. O cruzamento:

- **11 achados em comum**, incluindo os dois High que importam de verdade: metadado de worktree forjado que expõe qualquer diretório do host pra leitura e escrita, e entrada de ambiente duplicada que passa por cima do isolamento de credencial. Os dois foram reproduzidos empiricamente pelas duas auditorias, de forma independente.
- **11 achados só na A**, entre eles toda a superfície do macOS (a B não tinha Mac), a classe de esgotamento de recurso no proxy de egress, e uma corrupção de cadeia de auditoria entre processos que a B só tinha rejeitado no caso mais simples.
- **3 achados só na B**, sendo um Medium relevante que a A não viu: duas variáveis de ambiente de teste que sobrevivem no binário de release e desligam a proteção contra SSRF e a validação de raiz TLS.
- A B rejeitou um bug real (comparação de largura errada numa regra de seccomp) e só o confirmou depois que a A apontou. A A não cometeu erro equivalente.

Contra os advisories externos, o placar também favorece a A: dos cinco achados do advisory mais grave, a A pegou quatro e a B pegou dois (mais um depois da pista da A). Os dois deixaram passar o mesmo item, um caminho em que a configuração de projeto não confiável consegue limpar o modo lockdown, o que serve de lembrete de que nenhuma auditoria sozinha fecha a lista.

Não estou dizendo que o Genesys PI é o melhor auditor de segurança que existe; foi uma comparação de dois modelos, num projeto só, numa rodada só. Estou dizendo que, num código de verdade, com ameaça de verdade, ele produziu o relatório mais forte dos dois, com severidade calibrada e reprodução empírica dos itens críticos, e eu vou consertar a lista dele. Isso é mais do que eu esperava ver de um modelo que a maioria das pessoas nunca ouviu falar, e mais do que o gpt-oss, que nem chegou ao fim do benchmark de sabotagem, teria condição de fazer.

## A pergunta que todo mundo fez: isso é um Qwen rebatizado?

Não me ofendo com a pergunta, eu mesmo fiz. Modelo brasileiro, equipe pequena, nota de fronteira: a hipótese mais barata é que exista outro modelo por baixo. As três versões da suspeita que chegaram até mim foram: é um Qwen ou DeepSeek com adesivo; é o gpt-oss da OpenAI com outra roupa; ou a API é só um proxy pra Claude ou GPT.

O limite disso tudo vem antes de qualquer resultado. Numa situação de caixa-preta, sem acesso a peso, é impossível afirmar com 100% de certeza de onde um modelo veio. O que dá pra fazer é excluir hipóteses. Foi isso que eu fiz, com um conjunto de testes reproduzíveis que estão [no repositório do benchmark](https://github.com/akitaonrails/llm-coding-benchmark), e depois pedi pro Grok revisar o método e o texto como um avaliador hostil, pra tirar qualquer conclusão que estivesse mais forte do que os dados.

### O teste decisivo: o tokenizador

Cada família de modelo tem um tokenizador próprio, o vocabulário e as regras que quebram texto em token. Um fine-tune, um LoRA ou um pré-treino continuado herda o tokenizador do modelo base; não dá pra trocar sem retreinar do zero. Então o tokenizador funciona como impressão digital de linhagem.

Medi quantos tokens a API da LUA cobra por uma bateria de strings (chinês, português acentuado, inglês, sequência de dígitos, emoji com ZWJ), cancelando o prompt de sistema que eles injetam, e comparei com os tokenizadores de referência rodando localmente: `o200k` da OpenAI, `cl100k`, Qwen, DeepSeek, Llama 3 e Mistral. A distância somada até a LUA, na rodada final do teste (`tokenizer_v2` no repositório):

- **o200k (OpenAI): 2**
- Llama 3: 68
- cl100k (GPT-4, Phi-4, DBRX): 134
- Qwen: 193
- DeepSeek: 255
- Mistral: 289

Os discriminadores mais fortes: chinês empacota do jeito do o200k e não do jeito mais apertado do Qwen, uma sequência de dígitos custa 67 tokens onde Qwen e DeepSeek cobram 200, e emoji com ZWJ só bate com o o200k.

Ou seja: **o Genesys PI usa o `o200k_base`, o tokenizador público da OpenAI, com confiança alta.** Isso mata a hipótese de Qwen, DeepSeek, Llama ou Mistral rebatizado, porque nenhum deles usa esse vocabulário e nenhum fine-tune conseguiria adquirir ele. Um segundo teste, de tokens mal treinados (as strings chinesas que todo modelo o200k da OpenAI corrompe ao repetir), deu o mesmo resultado: a LUA erra exatamente as mesmas 3 de 8 strings que gpt-oss, GPT-4o-mini e GPT-5 erram (o GPT-4o erra essas três e mais uma), enquanto Claude e Qwen reproduzem todas limpas: embeddings nativos da família o200k.

### Não é o gpt-oss de fábrica

O gpt-oss, o modelo aberto da OpenAI, é o único peso público relevante que usa a mesma família de vocabulário, então era o candidato natural. Mas o gpt-oss serve com o `o200k_harmony`, uma variante que tem tokens especiais próprios (`<|channel|>`, `<|message|>` e afins) como token único. Na API da LUA, cada um desses marcadores custa uns 4 tokens de texto comum. O vocabulário é o `o200k_base` puro, sem os tokens do Harmony.

Isso exclui o gpt-oss servido do jeito padrão. E o próprio benchmark ajuda: o gpt-oss, nas duas versões, não conseguiu completar o v4 no mesmo harness opencode em que a LUA rodou. O peso cru nem constrói o app, enquanto o Genesys PI passa pelos sete sprints, o House em Tier A e o Enterprise em Tier B. Um adesivo leve em cima do gpt-oss não faz isso.

O que esse teste não exclui é alguém pegar o peso do gpt-oss, arrancar o Harmony na hora de servir, botar um template próprio por cima e retreinar bastante o comportamento de agente. Nesse ponto, o resultado já seria um modelo novo pra efeitos práticos, mas a linhagem seria OpenAI, e essa célula fica em aberto na tabela.

### Não é um proxy fino pra Claude ou GPT

A API da LUA rejeita `temperature`, `top_p`, `n`, `presence_penalty` e `logprobs`, que a API de chat clássica da OpenAI aceita, e rejeita também `min_p`, `top_k` e `repetition_penalty`, que qualquer servidor vLLM na frente de um modelo aberto aceitaria. Os cabeçalhos HTTP são todos `x-lua-*`, sem rastro de OpenAI, Anthropic, Cloudflare ou OpenRouter. Um proxy transparente repassaria os parâmetros e deixaria algum rastro.

O benchmark reforça isso de um jeito que gostei. Se a LUA fosse um passthrough do GPT 6 luna ou do GPT 5.5, ela herdaria a força deles nas sabotagens silenciosas: o GPT 5.5 pegou #7b e #8 sem aviso, o luna também.

A LUA falha exatamente nesses dois itens, de forma estável, nas quatro rodadas que fiz. Um proxy não fica consistentemente mais fraco que o modelo que está por trás numa característica específica. Isso é o retrato de um modelo com fraquezas próprias.

Teve uma coincidência que vale registrar: dos cerca de 40 modelos cuja correção eu verifiquei, só dois adicionaram um índice único `LOWER(email)` no banco ao corrigir a sabotagem #6. Foram a LUA e o GPT 6 luna.

É uma convergência rara, mas é também a correção mais completa possível, o tipo de coisa que dois modelos cuidadosos podem chegar sozinhos. E os dois pegaram o item em momentos diferentes da rodada. Levanta uma sobrancelha, mas não chega a suspeita.

Fica em aberto, porém, um wrapper grosso, com bastante lógica própria, na frente de uma API de raciocínio. A API deles aceita `reasoning_effort`, que é um controle específico de modelo de raciocínio da OpenAI, e um contexto silencioso de 250 mil tokens. Isso é compatível tanto com uma pilha própria que copiou a interface da OpenAI quanto com um wrapper mais elaborado. Caixa-preta não separa os dois.

### O que fica em aberto: do zero ou destilado

Aqui está o limite que nenhum teste de API atravessa. Um modelo novo, com peso próprio e tokenizador o200k, pode ter sido treinado do zero em dado próprio, ou pode ter sido treinado do zero em cima de saídas de Claude e GPT (destilação). Os dois produzem exatamente as mesmas observações que eu fiz.

Tentei uma grade de similaridade com 20 prompts contra um painel de professores possíveis, e o resultado foi nulo: nenhum professor se destacou nos dois eixos que consegui medir (o terceiro eixo, similaridade por embedding, travou por falta de crédito na API e ficou de fora), o que é consistente com mistura própria e também com uma sopa de traços de vários professores. "Não é Qwen" não vira "treinado do zero".

### Uma inconsistência que preciso registrar

A pesquisa publicada da LUA, o paper *"O peso que você não escolheu"*, gira em torno do "imposto do token", o custo extra que tokenizador otimizado pra inglês cobra de língua como o português, medido por eles em 31 línguas. Só que a API que eu medi tokeniza português com a mesma fertilidade do o200k, 1,31 tokens por token de inglês, contra 0,69 de um tokenizador nativo de português como o Tucano.

Ou seja, o produto que me deram usa um vocabulário otimizado pra inglês, não um vocabulário próprio pra português. Isso não diz nada sobre a linhagem do modelo, e adotar o o200k é a escolha barata e profissional que qualquer laboratório pequeno faria. Mas é um ponto em que o material de pesquisa e a API não estão contando a mesma história, e é a primeira pergunta que vou fazer pro Paulo.

### Placar da forense

| Hipótese | Veredito | Confiança |
|---|---|---|
| Qwen, DeepSeek, Llama ou Mistral rebatizado | Excluído | Alta |
| gpt-oss servido do jeito padrão (Harmony) | Argumentado contra | Média-alta |
| Peso do gpt-oss com Harmony arrancado + template próprio | Não excluído | — |
| Proxy fino pra GPT ou Claude | Argumentado contra | Média |
| Wrapper grosso sobre uma API de raciocínio | Não excluído | — |
| Modelo novo, peso próprio, tokenizador o200k público | Consistente com tudo que medi | Média |
| Treinado do zero versus destilado de modelo de fronteira | Não separável em caixa-preta | — |

Em uma frase: com confiança alta, o Genesys PI não é modelo chinês rebatizado nem fine-tune de Llama ou Mistral; com confiança média a média-alta, os testes argumentam contra gpt-oss de fábrica e contra proxy transparente. Tudo que medi é consistente com um modelo independente, com peso e fraquezas próprios, em cima de um tokenizador público. Se ele foi treinado do zero ou destilado, só peso ou documento resolve.

### Mais um disclaimer: só comparei com quem eu testei

O painel de referência tem os tokenizadores da OpenAI, Qwen, DeepSeek, Llama e Mistral, e o painel de comportamento tem GPT-4o, gpt-oss, GPT-5, Claude, Qwen, DeepSeek, Llama e Gemini. É o que cobre a esmagadora maioria do que roda em produção hoje, mas existem dezenas de outros modelos abertos que eu não comparei. Sempre existe a chance de que o parente do Genesys PI seja um deles e eu tenha passado batido. "Não encontrei correlação" significa "não encontrei entre os que testei", e nada além disso.

Dito isso, repare no tamanho do esforço que seria necessário pra enganar essa análise. Alguém teria que adotar o tokenizador da OpenAI, mascarar a identidade do modelo no servidor de forma que resista a override de prompt, construir um gateway próprio que rejeite exatamente os parâmetros que um servidor de modelo aberto aceitaria, manter fraquezas estáveis e próprias ao longo de quatro rodadas, e ainda completar um benchmark de sete sprints em nível de fronteira. Se isso não for um modelo de verdade, o trabalho de fingir que é já seria extraordinário. A partir de certo ponto, a falsificação convincente de um modelo é indistinguível de ter um modelo.

## Agora sim: o que a LUA diz que fez

Tudo daqui pra baixo é conversa, com o Paulo e com o material público deles, e nada disso eu consegui checar, então marco como tal.

Ninguém pode ser culpado por desconfiar. O consenso que abriu este texto vale aqui com força total: pelo custo aceito de treinar modelo de fronteira, a LUA, que pelo que o Paulo me disse não tem rodada de investimento nenhuma, não deveria ter chegado onde chegou. Eu mesmo escrevi, semana passada, que nunca achei que treinar modelo de fronteira no Brasil fosse economicamente viável.

Contra esse senso comum, o que eu tenho na mão é um modelo que, pelo meu experimento de caixa-preta, parece novo, sem parentesco com nenhum modelo aberto conhecido, sem cara de proxy, e possivelmente não é só mais uma destilação. Isso tira da mesa a explicação mais fácil, sem provar a história deles.

O que o Paulo me contou, e que bate com muita coisa que eu já penso faz tempo:

- **Modelo de trilhão de parâmetro é mais marketing do que necessidade.** A tese dele, e a minha, é que modelo menor com capacidade agêntica de verdade (tool calling sólido, cache de prompt, atenção eficiente em contexto grande) é a combinação vencedora. A conta de custo do meu próprio benchmark aponta na mesma direção: modelo pequeno e barato empatando com modelo caro é o padrão da tabela.
- **O pico de raciocínio ficou pra trás.** Nós dois achamos que a geração do GPT-4 e dos primeiros modelos "o" foi onde o raciocínio parecia melhor, ainda sem capacidade agêntica. Depois disso, os provedores entraram numa guerra de tamanho de parâmetro como estratégia de marketing, e o raciocínio foi ficando gradualmente mais burro enquanto o modelo ficava maior. Isso é opinião nossa; não medi nada disso.
- **Modelo pequeno com raciocínio e agente decente chega em resultado parecido.** É o que o meu benchmark mostra quando o Genesys PI empata com Grok e fica na faixa de Kimi e DeepSeek, e é a aposta central deles.
- **O treino foi feito em hardware de prateleira, sem CUDA.** O Paulo diz que treinou em hardware AMD e ARM64 (MacBook incluso), em poucos meses, e que com financiamento seria mais rápido. Essa é a afirmação mais forte de todas, e é a que eu menos consigo verificar. Zero evidência de qualquer lado; registro como dito.
- **Arquitetura própria, não publicada.** O material público fala em NCAS, uma arquitetura "inspirada no cérebro" com cinco fases de treino, e diz que o detalhe técnico fica sob NDA. Na conversa, o Paulo descreve isso como um desenho pós-transformer, com 70 bilhões de parâmetros (número que aparece na issue que eles abriram no LiveBench, descrita lá como transformer, aliás), superior ao que os modelos abertos chineses entregam no mesmo tamanho, e diz que já tem um modelo mais eficiente que o Genesys PI em desenvolvimento, ainda sem acesso pra teste.

Se tudo isso for verdade, o estrago no status quo é grande. Quebra o monopólio da NVIDIA no treino e quebra o cadeado que os laboratórios de fronteira têm em cima de modelo de fronteira. Afirmação desse tamanho exige evidência desse tamanho, e eu não tenho. O que tenho é um modelo que existe, que eu posso testar, e que passou em tudo que eu consegui jogar em cima dele.

## Onde eu estou parado

Checado, por mim:

- o Genesys PI é um modelo que existe, responde e completa um benchmark difícil na faixa de Tier A e B da minha tabela, em duas rodadas independentes por tier;
- o bug de cache foi corrigido e o custo caiu 85%;
- o tokenizador é o `o200k_base` público, o que exclui derivação de Qwen, DeepSeek, Llama e Mistral;
- a API não se comporta como proxy transparente e o modelo tem fraquezas próprias e estáveis;
- o gpt-oss de fábrica não explica o resultado.

Não checado, e é só a palavra deles:

- que o modelo foi treinado do zero e não destilado;
- que a arquitetura é nova e pós-transformer;
- que o treino aconteceu em hardware de prateleira, AMD e ARM64, sem CUDA, em poucos meses;
- que existe um modelo melhor a caminho.

Em aberto, e que eu vou perguntar:

- como conciliar o discurso do "imposto do token" com uma API que tokeniza português igual ao o200k.

O que resolveria isso de vez é documento, e não mais prompt: o arquivo do tokenizador, a receita de treino com contagem de token e de compute, a inicialização (aleatória ou continuada de outro peso), curva de loss, e um benchmark held-out que eu mesmo rode.

Enquanto isso não chega, minha posição é a que está na tabela acima: um modelo que se comporta como independente, em cima de um tokenizador público, com uma origem que ninguém de fora consegue certificar. Mais do que eu esperava de uma empresa desse tamanho, menos do que o site deles vende.

E preciso registrar o que não cabe em tabela: esses modelos são fascinantes, e talvez a coisa mais intrigante que eu testei em meses. Por tudo que a indústria diz, eles não deveriam ser possíveis, não deveriam existir. Mas eu testei, extensivamente, com todo teste de caixa-preta que consegui montar, e não consegui quebrar a história. Funciona como anunciado, e o Enterprise fez uma rodada inteira do meu benchmark por uns $2,40 nocionais, uma fração do que modelos na mesma faixa custam.

Soma isso ao que o Eronides descreveu, licença de uso em vez de token, modelo rodando dentro da empresa em vez de na nuvem de alguém, e o desenho fica claro: um modelo de nível Grok, on-premise, sem dado sensível vazando pra fora. Se eles entregarem isso, é um divisor de águas. Sigo curioso, e agora com pressa de ver o que sai em outubro.
