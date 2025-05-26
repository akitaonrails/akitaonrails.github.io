---
title: RANT - LLMs são LOOT BOXES!
date: '2025-05-02T19:20:00-03:00'
slug: rant-llms-sao-loot-boxes
tags:
- llm
- openai
- microsoft
- google
- meta
- nvidia
- mcp
draft: false
---



Eu sei que vai soar negativo demais, e de novo, vou repetir que eu não sou anti-I.A., anti-LLM nem nada disso, pelo contrário, eu gosto TANTO, mas TANTO, que venho dedicando TODAS as minhas horas em pesquisar a fundo a respeito.

Tem sido muito útil pra mim especialmente pra resumir paper, conciliar pesquisas em vários sites, resumir tópicos e coisas do tipo.

**"MAS .."**

E é um enorme MAS, ele tem sido BEM inútil em programação de verdade. Não vou repetir todos os problemas que já encontrei: eu detalhei bastante nos posts anteriores. Mas minha conclusão é simples: ele pode ajudar em código, em tarefas pequenas, focadas, isoladas, com bastante prompt pra ajudar e você - programador - precisa estar atento em o que escolher usar e o que vai rejeitar (e vai ser a maior parte).

Prompts melhores tem limites. RAGs tem limites. Loras tem limites. Janela de contexto maior tem limite. Usar agentes que devolver stacktrace e pedir pra fazer deep thinking, tem limites. Eu já consegui esbarrar em TODOS os limites e não achei nenhum "workaround" que consiga fazer ele funcionar 100% bem em 100% do tempo - que é a promessa que a propaganda faz.

_"Mas a Microsoft, Google, Meta, NVIDIA já afirmaram que 30% do código deles já é feito com I.A. e ano que vem vai substituir programadores"_

Essa é a grande meia-verdade, meia-mentira (interprete como quiser). 

## "Que 30%??"

Você, que não é programador, sabia que documentação de projetos (que é extenso), arquivos de tradução de línguas (que é extenso, sabe quantas línguas uma Microsoft ou Google suportam globalmente?), páginas HTML que duplicam essa documentação extensa, tudo isso é "considerado" parte do código e fica no mesmo repositório "de código" como GitHub?

Você, que não é programador, sabia que o VOLUME em caracteres/bytes desse material, muitas vezes quase iguala ou até pode superar o volume de bytes do código em si?

Esse é só um pequeno exemplo que me vem à cabeça. Páginas de lançamento de produtos novos, os "hot-sites" que são sites DESCARTÁVEIS e feitos pra jogar fora. Isso também é volume de código. Tem MUITO "código" que não é "O código". Todo programador que trabalha numa grande empresa sabe disso.

O seu projetinho caseiro não tem documentação, não tem testes automatizados, não tem scripts de build, não tem automação de deploy ou empacotamento, não tem arquivos de línguas separado, não tem hot-site, não tem site de produto em múltiplas línguas. É só um "hello.py" e esse é TODO o seu código. Entendo porque você extrapola que projeto grande é a mesma coisa.

PARTE dos "30%" que tanto se fala é isso. Claro que tem algum código de verdade, mas não é nem perto do que você pensa.

### Conflito de Interesses

Eu fico pasmo. Se um "vendedor de entorpecentes" te dá uma amostra grátis e você pergunta "mas é seguro". O que você acha que ele vai responder? 

O dono da Meta tem produtos de I.A. O dono do Google, o dono da Microsoft, ALUGAM GPUs pra I.A.. O dono da NVIDIA VENDE GPUs pros datacenters de I.A. O dono da OpenAI, Anthropic, todos ALUGAM essa infra e te REVENDEM, **CRÉDITOS DE TOKENS**.

Qual você acha que é o incentivo deles? **VENDER USO TOKENS**.

Vocês viram meu relato nos posts anteriores. Em menos de 1 semana de testes eu gastei quase USD 150 de créditos. Seriam mais de 850 BRL, em uma semana, e depois de fazer uma CENTENA de tentativas, eu obtive refatoramentos meraramente "razoáveis" METADE das vezes, e eu obtive bons testes unitários que passam, MENOS DA METADE das vezes (na verdade, quase NENHUMA vez). Mas eu gastei token, MUITOS TOKENS.

Funcionalidades que a propaganda te fala que melhoram como DEEP THINKING/REASONING, só "às vezes" dão respostas de código melhor. Eles de fato são melhores pra compilar papers ou pesquisas de texto. Mas pra código, na MAIORIA das tentativas, eu não vi tanta diferença. Só que demorou MUITO mais e gastou MUITO mais tokens. Sabe o que Deep Thinking faz? Ele adiciona mais passos até a resposta e enche o contexto com tokens. Esses tokens extras: VOCÊ PAGA A MAIS.

Funcionalidades que a propaganda também te fala que melhorar como soluções baseadas em RAG, no fundo é só mais "injeção de prompt" - que sempre gasta contexto e GASTA MAIS TOKENS. Funciona, claro, mas o incentivo é gastar mais tokens.

Funcionalidades que a propaganda agora tenta te empurrar como MCP, agentes e automação de LLMs, somado com RAGs e tudo mais. Os Devin, n8n, e tudo mais são uma forma mais automatizada de GASTAR MAIS TOKENS. 

Todo o incentivo, de todo mundo, é gastar mais tokens, não menos. E nos meus testes, em muitos modelos (não vou dizer todos), eu obtive respostas melhores de código **DESLIGANDO DEEP THINKING**. Dá pra configurar isso em ferramentas como Aider ou direto na API da OpenAI. Diminuir `thinking_tokens` ou fazer `reasoning_effort` ser "Low" ou melhor, "NONE".

### LOOT BOXES

Também expliquei no [artigo sobre como fazer seu próprio Modelfile de Ollama](https://www.akitaonrails.com/2025/04/29/dissecando-um-modelfile-de-ollama-ajustando-qwen3-pra-codigo) que, essencialmente, o processo de geração de textos (engula, LLMs são geradores de próxima palavra), tem componentes aleatórios. Temperatura, Top_P, Top_K. Mais: o treinamento tem componentes não-lineares (ex. ReLU). Não é determinístico, é um SORTEIO numa distribuição de probabilidades.

Significa que, fundamentalmente, não tem como uma LLM estar 100%, 100% do tempo. É matematicamente impossível. Ele sempre pode estar "quase certo" ou "parecendo que está certo". Mas se você diligentemente rechecar tudo, o tempo todo, vai começar a encontrar pequenos equívocos. No caso de código, é bem mais aparente. Ele está BEM errado, MUITAS vezes.

E o processo todo se assemelha muito a jogos online "gratuitos" com LOOT BOXES ou sistemas de GATCHA, sabe? Tipo Genshin Impact da vida.

![Loot Box](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBcVFCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--c0949f4fec407894c1c5d91082e7a5fb53d96939/tu-genshin-impact-vach-mat-nhung-dieu-bi-an-dang-sau-ti-le-cua-loot-box-va-gacha-01-.0484-4045540040.jpg?disposition=attachment&locale=en)

O quê??? Você é um boomer e não sabe o que são Loot Boxes? ...

EU SOU BOOMER E EU SEI, não tem desculpa. Vai se atualizar (e é a principal razão de porque eu escolho não jogar esse tipo de jogo online).

A economia desses games funciona assim: você não tem a opção de comprar ítens específicos que quer. Em vez disso, você paga, digamos 20 créditos pela chance de participar de um sorteio (que acontece em datas e horas pré-programadas, não o tempo todo). Nesse sorteio você tem a (ALTA) probabilidade de só ganhar um ítem de 10 créditos OU, a **incrível** (BAIXÍSSIMA) probabilidade de ganhar um ítem exclusivo de 1000 créditos!!!!

Parece um negócio da China né??? (LITERALMENTE É!!!)

Você sempre ganha o item mais barato no sorteio. E de vez em quando ele te dá um item MÉDIO pra você não desistir de continuar e achar que tem alguma chance real. Só se você gastar MUITO (e nesse ponto você já gastou mais de 1000 créditos mesmo), só aí talvez ele te dê um item grande, pra te injetar de mais dopamina e aumentar seu **vício**.

É exatamente isso que acontece com LLMs. As respostas deles tem chances parecidas com de Loot Box. Às vezes ele te surpreende com uma excelente respostas, mas na maior parte do tempo, você fica pedindo "cara, você tem certeza dessas resposta?", ou "cara, não tá errada essa segunda linha?", ou "cara, reveja o que eu perguntei e tenta de novo". e assim vai o seu dia inteiro.

Você não fica olhando, mas por baixo dos panos, cada vez que tem que corrigir, ele continua gastando os mesmos créditos. No final do dia, lá se foram USD 50. Parece pouco, mas faça isso todo dia e veja quanto acumula.

Só que seu **VIÉS DE CONFIRMAÇÃO** faz você se lembrar bem de quando ele acertou, mas vai "esquecendo" todas as outras vezes que ele errou. E sua percepção é que _"Sim, ele funciona."_

Pior, sua baixa auto-estima e necessidade de se fazer parte de um grupo, de se **CONFORMAR**. Corroborado com o que lê diariamente nas notícias, como:

- 30% de todo código da Microsoft já é feita por I.A.
- CEO da Anthropic diz que ano que vem programadores serão substituídos por virtual workers
- CEO da NVIDIA diz que não recomendaria seu filho a estudar mais programação

E tudo isso AUMENTA O VIÉS: você acha que eles estão certos, as vezes que você mesmo experimentou a LLM errando _"deve ter sido uma pequena exceção, eu que sou burro mesmo"_ e ACREDITA na MENTIRA.

Quem lembra das minhas palestras de 15 anos atrás onde eu mostrava este video?

<iframe width="560" height="315" src="https://www.youtube.com/embed/iRh5qy09nNw?si=HhQ0Hvg2BNi99ZFT" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

Isso é um fenômeno bem conhecido, hoje em dia mais amplificado pelas redes sociais e a burrice de jornalista, que só repete o que ouve como papagaio e não faz mais perguntas críticas, do tipo: EXISTE CONFLITO DE INTERESSES??

### "OpenAI usa seus chats pra treinar?¨

Aqui vou ter que consertar uma mentira que eu venho contando pra vocês. Eu sempre repeti que não. Sua conversa não é usada pra treinamento, porque iria poluir o material de treinamento com lixo que no final não iria melhorar as respostas.

É meia-verdade. De fato, eu duvido muito e boto minha mão no fogo: nenhum provedor quer se arriscar a alguém encontrar um texto com copyright e levar processo. Isso já acontece, o New York Time processou porque o ChatGPT conseguiu reproduzir um texto publicado por eles. E isso meio que "prova" que fazia parte do material de treinamento.

Tem gente que coloca coisas privadas como condições de saúde, situação financeira, e até mesmo dados críticos como senhas, endereço, coisas que não deveriam mas acabam publicando porque não tem noção sobre cyber-segurança. Todo mundo cai num golpe todo dia por causa disso. A OpenAI ou Meta ou Alibaba não fazem questão de aparecer isso uma hora no chat e viralizar notícia internacional falando como eles foram irresponsáveis.

**MAS**

E é um GRANDE "MAS", eles usam sim seu chat. De todo mundo. Sem copiar nenhum dado seu. Eles só precisam dos METADADOS, os dados que descrevem seu chat.

De cabeça aqui, sendo ingênuo e amador em treinamento, eu vejo pelo menos 2 informações importantes que você dá pra eles: o comprimento do seu chat e o sentimento das suas respostas no chat.

Determinar sentimento a partir de texto é um problema bem resolvido, tem algoritmos com ou sem redes neurais que conseguem determinar se o texto parece feliz, triste, bravo, angustiado ou coisas assim. Eles não precisam do conteúdo do seu texto, só precisam do SENTIMENTO que você teve na hora.

Somado ao COMPRIMENTO do seu Chat e como eu falei [no post anterior](https://www.akitaonrails.com/2025/05/02/rant-llms-sao-loot-boxes), que o incentivo é fazer você gastar MAIS TOKENS (chat MAIS longos). NO PRÓXIMO POST vou ensinar vocês como eles fazer alinhamento, o "fine-tuning" do modelo. Uma OpenAI usa milhares de linhas de pares de prompts/completion pra "forçar" o modelo a responder de uma determinada forma. Pensa um Excel cheio de perguntas e respostas pré-prontas, que segundo seus metadados, sabemos que são as respostas mais POPULARES.

O objetivo não é fazer o modelo responder mais certo, porque às vezes a resposta certa é muito dura ou inconveniente pra algumas pessoas. Eu tenho quase certeza que os dados extraídos dos chats de milhões de pessoas, só isso: sentimento e comprimento. Deve ajudar a criar prompts que forçam o modelo a responder "menos certo" mas "mais agradável", incentivando o usuário a CONTINUAR falando no chat e GASTANDO MAIS TOKENS.

É o comportamento mais antigo do mundo. Todo lojista sabe disso. Todo vendedor sabe disso. Todo mundo que trabalha em serviços sabe disso. Se você for certo e direto, vai soar arrogante e o cliente não volta. É melhor soar menos certo, mas mais convidativo, agradável, prestativo, etc. E o cliente volta, porque é assim que a pessoa média funciona.

Portanto, sim: eu acho que seus dados servem pra re-alinhar o modelo depois de treinado, pra responder mais agradável. Eles nem fazem mais questão de esconder isso. Não viram o próprio Sam Altman quando falou poucos dias trás que fizeram o ChatGPT 4 responder mais amigável, com mais personalidade?

É isso que eu acho que eles estão fazendo. Tornar o modelo mais inteligente está sendo um desafio. Porque - como já venho dizendo faz 1 ano - estamos batendo no teto da curva em S. Pra continuar vendendo tokens, fazendo você voltar e se viciar em falar, não precisa ser mais inteligente, só precisa ser mais agradável. 
### Conclusão

Não existe LLM que vai estar 100% certo, 100% do tempo, a arquitetura fundamental IMPEDE que isso aconteça, não importa quanto mais façamos otimizações. Existe agora e sempre vai continuar existindo um componente de ENTROPIA. É essa aleatoriedade que produz texto que parece um humano falando e não um robô.

Automatizações longas e complexas demais usando essa fundação fŕagil é um ENORME erro. Claro, pra tarefas simples, curtas, focadas, ele tem uma TAXA DE ACERTO mais alta. Pra código de verdade? É SUPER baixo.

Nunca deixe um MCP fazer commits direto no seu repositório Git. Ferramentas como o Aider trazem "autocommit = true" por padrão e isso é uma enorme estupidez! Não faça isso.

Eu avisei.

Mas não tem como melhorar o código de LLMs? Talvez. 100% nunca, mas aumentar a taxa acho que dá. E pra provar que eu não sou anti-LLM nem nada disso, no próximo artigo vou tentar ensinar COMO melhorar uma LLM pra programação (com média probabilidade, não é milagre!).
