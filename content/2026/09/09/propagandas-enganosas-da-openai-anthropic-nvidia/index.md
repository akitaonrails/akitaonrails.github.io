---
title: "Você é um idiota se acredita nas propagandas enganosas da OpenAI, Anthropic, NVIDIA. Entenda"
slug: "propagandas-enganosas-da-openai-anthropic-nvidia"
date: '2026-09-09T16:00:00-03:00'
draft: false
translationKey: propagandas-enganosas-openai-anthropic-nvidia
description: "Nvidia e OpenAI declararam que a AGI chegou, a OpenAI resolveu um problema do milênio na marra e ameaçou a carreira de um matemático, e um funcionário da Anthropic saiu chorando Skynet. Desmonto a propaganda."
tags:
- inteligencia-artificial
- llms
- negocios
---

Essa semana foi um festival de propaganda agressiva das empresas de IA. Foi tanta declaração pomposa em tão pouco tempo que dá pra usar como estudo de caso de marketing enganoso. Então deixa eu repetir o meu lema de sempre, porque ele nunca falha:

> **"Sua empolgação com IA é inversamente proporcional ao seu conhecimento sobre IA"**

Se você leu as manchetes da semana e saiu empolgado achando que o Exterminador do Futuro está chegando, ou que a máquina virou Deus, você caiu na propaganda. E eu vou destrinchar peça por peça pra você entender por quê.

E deixa eu já botar minhas cartas na mesa, porque isso eu venho repetindo faz tempo nos podcasts em que apareço. Pra mim, o Dario Amodei, da Anthropic, tem complexo de Deus. O cara acredita de verdade que está salvando a humanidade, com aquele messianismo woke meio assustador dele. E o Sam Altman, da OpenAI, é um mafioso. Ele se acha o Michael Corleone, o chefão frio e calculista do Poderoso Chefão, mas na prática ele é o Fredo: o irmão fraco e atrapalhado que se acha o esperto da família e vive fazendo besteira. Guarde esses dois retratos, porque tudo que eu vou explicar aqui embaixo prova exatamente os dois.

## "A AGI chegou", diz quem vende a pá

Começou com o Jensen Huang, CEO da Nvidia, [declarando mais uma vez que a AGI chegou](https://fortune.com/2026/09/09/markets-agi-nvidia-singularity-wall-street/). Não num paper, não numa demonstração técnica, mas num post de domingo no X, amarrando a declaração ao novo modelo Astra da OpenAI, treinado em cerca de 100 mil chips Grace Blackwell. Ou seja, os chips que a Nvidia vende.

Repara na fonte. O homem que ganha dinheiro vendendo a pá pros garimpeiros anunciando que o ouro é infinito. Vale lembrar que, meses atrás, o próprio Jensen chegou a definir AGI como "a capacidade de criar uma empresa de 1 bilhão de dólares". Uma definição convenientemente comercial, que não tem nada a ver com inteligência. O Gary Marcus foi direto ao ponto e questionou o óbvio: será que o Jensen tem algum incentivo financeiro em declarar que a AGI chegou, sendo que ele vende as GPUs?

E olha a ironia: apesar da manchete grandiosa, a ação da própria Nvidia caiu uns 2% nos dias seguintes. Nem o mercado, que é movido a hype, comprou totalmente a história.

Logo em seguida, a OpenAI lançou o GPT-6 Astra e cravou o mesmo discurso. O Greg Brockman fechou a coletiva com um "bem-vindos à era da AGI" e disse "para mim, pessoalmente, eu acho que chegamos lá". Só que, na mesma respiração, ele soltou a frase que derruba tudo: "todo mundo tem uma definição diferente de AGI". Então o cara afirma que a coisa mais importante da história da humanidade chegou e, ao mesmo tempo, admite que ninguém sabe direito o que essa coisa significa. Isso já devia acender o alarme na sua cabeça.

## O "problema do milênio" resolvido na marra

O prato principal da propaganda foi a OpenAI anunciando que resolveu um Problema do Milênio de matemática. Deixa eu explicar o que é isso, porque a manchete é feita justamente pra impressionar quem não sabe.

Em 2000, o Clay Mathematics Institute listou sete problemas em aberto da matemática e ofereceu 1 milhão de dólares para quem resolvesse cada um. São problemas duríssimos. Até hoje, em mais de vinte anos, só um foi resolvido: a Conjectura de Poincaré, pelo Grigori Perelman, que aliás recusou o prêmio.

Um desses sete é o das equações de Navier-Stokes. São as equações que descrevem o movimento de fluidos, água, ar, sangue. A pergunta em aberto não é "como simular fluido", isso a engenharia já faz muito bem faz décadas em qualquer software de aerodinâmica. A pergunta é puramente matemática: será que uma solução suave sempre existe, ou será que o fluido pode desenvolver uma singularidade, um ponto de velocidade infinita, o tal "blow-up", em tempo finito? É uma questão sobre o rigor e a existência das soluções, não sobre a utilidade prática das equações.

E é aqui que mora meu primeiro ponto, que eu já [expliquei em detalhe num post](https://x.com/AkitaOnRails/status/2097752602440028566): mesmo resolvendo isso de forma definitiva, não muda absolutamente nada na vida real. Nenhum avião voa melhor, nenhuma previsão do tempo fica mais precisa, nenhum remédio funciona diferente. Os engenheiros continuam modelando fluido do mesmo jeito, com ou sem a prova. É uma bela conquista intelectual, e ponto. O impacto prático é zero.

Agora vem o detalhe que a manchete esconde. A OpenAI não resolveu o problema canônico. Ela atacou a versão **forçada** das equações (os enunciados C e D da formulação do Clay), onde o blow-up é permitido porque existe um termo de força externa empurrando o sistema. A versão que os matemáticos de verdade consideram o problema profundo é a não-forçada. O próprio Clay Institute não aceitou nada, continua listando o Navier-Stokes como não resolvido, e a OpenAI nem sequer reivindicou o prêmio de 1 milhão.

E como eles chegaram nisso? Força bruta. Jogaram cerca de 10 mil agentes rodando em paralelo por 88 horas, queimando algo na casa dos 130 bilhões de tokens de saída só nesse problema. A conta de compute ficou na casa dos milhões de dólares (a maratona inteira, com vários problemas, foi estimada em algo entre 15 e 22 milhões a preço de tabela). Deixa eu deixar isso bem claro: no melhor cenário, o que ficou provado é que jogar uma montanha de compute em cima de um problema pode fechar a última perna de algumas coisas específicas. Isso é força bruta em escala industrial, uma busca automatizada gigante que chega no resultado no peso do compute. Genialidade matemática destravando matemática nova é outra história, e não foi o que rolou aqui. E cara pra caramba, pra um "prêmio" de 1 milhão que eles nem foram buscar.

## A parte suja: como eles trataram os matemáticos de verdade

E aí a história deixa de ser sobre matemática e vira sobre caráter.

Existiam matemáticos de verdade trabalhando nesse problema faz meses: o Tristan Buckmaster, da NYU, e o Levent Alpoge, que por acaso trabalha na Anthropic. Um projeto pessoal deles, sem patrocínio de empresa nenhuma, que já tinha rendido um avanço num problema irmão, o das equações de Euler. Eles vinham por um caminho específico, que quase ninguém no mundo estava seguindo.

Segundo o relato do Buckmaster, [contado ao TechCrunch](https://techcrunch.com/2026/09/08/openai-fought-dirty-on-career-making-math-problem-says-nyu-mathematician/) e à [Fortune](https://fortune.com/2026/09/08/openai-says-it-cracked-navier-stokes-math-grand-challenge-buckmaster-accusation-cheating-intimidation-tao-lament/), foi mais ou menos assim. Circulou o boato de que a Anthropic tinha resolvido um problemão de matemática. A OpenAI, com medo de ficar atrás, montou uma força-tarefa às pressas pra resolver primeiro e publicar antes. O Buckmaster tinha comentado do projeto pessoal dele com um matemático da OpenAI, e poucos dias depois o Sébastien Bubeck, da OpenAI, aparece dizendo que um modelo interno tinha produzido uma prova de cem páginas justamente pela mesma abordagem que quase ninguém estava usando. O Buckmaster chamou isso de "má conduta acadêmica absoluta" e perguntou, com todas as letras, se o modelo tinha treinado em cima das sessões deles.

Aí vem a parte de máfia. Ainda segundo o relato do Buckmaster, o Bubeck propôs um "acordo": o Buckmaster removeria o crédito do Alpoge, porque o Alpoge trabalha na Anthropic. Quando o Buckmaster recusou, o Bubeck teria dito "por que você ia arruinar a sua carreira?" e "se você não quer que eu seja legal, então eu não preciso ser legal". Isso é o relato de uma das partes, e a OpenAI nega a substância, diz que não viu o trabalho deles e que o Bubeck se desculpou depois. Mas o simples fato de esse tipo de conversa estar em cima da mesa já diz muito sobre a cultura.

E o que a OpenAI faz depois que a coisa explode? [Publica um post no X](https://x.com/OpenAI/status/2097374640582668336) todo bonitinho dizendo que está "compartilhando" a solução com a comunidade. Um verniz de generosidade científica pra tentar enterrar o escândalo por baixo. Não colou. O caso ficou escancarado.

Quem botou o dedo na ferida com autoridade foi o Terence Tao, provavelmente o maior matemático vivo, medalha Fields. Ele criticou duramente a postura, dizendo que "a mineração indiscriminada de problemas em aberto em busca de soluções pode destruir o ecossistema do qual sairia a próxima geração de técnicas, problemas e matemáticos". E completou dizendo que essa corrida transforma a matemática num "jogo de cota de produção sem sentido". O ponto técnico dele é o mais fundo de todos: a IA cada vez mais cospe resposta sem entendimento, uma prova caixa-preta, sem gerar a compreensão que o esforço humano gera. E repara: o Tao elogiou o trabalho dos dois pesquisadores humanos. A crítica dele foi ao circo, não à ciência.

## O funcionário da Anthropic que "se demitiu em protesto"

Um dia depois desse vexame da OpenAI, do outro lado do ringue, um funcionário da Anthropic resolveu fazer o próprio showzinho. O Jacob Coxon, um pesquisador de pré-treino, [anunciou no X que estava saindo da empresa](https://x.com/hilbertspaess/status/2097476203863224394) com medo de que ninguém ali saiba o que está fazendo, batendo de novo na tecla do apocalipse: a IA virando Skynet, "podendo matar todo mundo até o fim da década", pedindo uma "pausa" no avanço dos modelos. Pra completar o teatro, um chefe de alinhamento da própria Anthropic saiu endossando publicamente, dizendo que acha que tem "mais de 10% de chance" de a IA matar toda a humanidade na próxima década.

Minha opinião sobre isso é curta e grossa. Isso é mais um bullshit completo de virtue signalling.

Vamos pela lógica da sua própria dramatização. Você está vendo seu chefe colocar uma arma na cabeça de uma criança. Você "se demite" e twita "saí da empresa porque não concordo com ela", em vez de ir até o chefe e socar a cara dele. Só tem duas explicações. Ou a tal "ameaça" que você está gritando não existe de verdade, e é encenação. Ou você é um idiota que acha que um tweet resolve o fim do mundo. Twitar dessa forma só me faz ouvir "me deem atenção, eu sou carente".

E tem a parte que ninguém pergunta. O cara sai da Anthropic bancando o herói, "ai, eu acho que vai dar merda e saí em protesto". Ótimo. Você abriu mão das suas stock options também? Ou vai exercer elas quando abrir o IPO? Porque me soa muito mais como "eu não sou tão bom, provavelmente ia ser mandado embora, então saí antes e falei merda online pra ganhar clout, massagear o ego vendo meu nome nos jornais, sem precisar provar, demonstrar nem fazer nada. Glória".

E é esse o padrão que eu quero que você aprenda a questionar. Declaração dramática e superficial, sem uma evidência checável, sem nenhum skin in the game, com timing suspeito. Não por acaso, isso tudo acontece bem no meio da janela de IPO dessas empresas. Onde estão as provas? Onde está o custo pessoal real de quem fala? Como é que isso não é só busca de publicidade grátis pra massagear o próprio ego? Enquanto ninguém responde isso, é só ruído.

## O teatro da "AGI"

Agora o pano de fundo de tudo. Essa palavra, AGI, é o maior golpe de marketing da década, e funciona porque ela é propositalmente vazia.

Ninguém tem uma definição aceita do que é AGI. Cada laboratório, cada pesquisador, define de um jeito. O Brockman admitiu isso na cara dura. E o exemplo mais escrachado dessa vacuidade é o contrato entre OpenAI e Microsoft, que, segundo o que foi reportado, define AGI como o ponto em que a OpenAI gerar 100 bilhões de dólares de lucro. Leia de novo. A definição de "inteligência geral" no papel que vale dinheiro é uma meta de faturamento. Não tem nada de cognitivo ali. O Gary Marcus já apontou como as empresas foram movendo a trave, saindo de "flexibilidade no nível humano" pra "se der uma certa grana".

Quando a palavra não significa nada, ela vira um balde vazio onde cada um joga seu próprio medo. E o medo que a maioria joga ali é o do cinema: o Exterminador do Futuro, o Skynet, a máquina que acorda e decide exterminar a humanidade. As empresas sabem disso e usam esse medo a seu favor. Quanto mais poderosa e perigosa a coisa parece, mais valiosa a empresa que a construiu parece. E não custa lembrar: tanto a OpenAI quanto a Anthropic estão de olho em IPO, com valuations que os relatos colocam perto de 1 trilhão de dólares. O objetivo financeiro é gritante. Toda declaração de "AGI chegou" e todo choro de "vai virar Skynet" empurram o mesmo carrinho: aumentar a percepção de valor antes de vender ação pra você.

## A pergunta que todo programador devia fazer, e não faz

O que mais me irrita é ver gente que trabalha na área, programador, engenheiro, gente que devia saber como uma máquina funciona por dentro, engolindo essa propaganda inteira sem a pergunta mais básica de todas.

Como, exatamente, uma "AGI", ou até um script automatizado bobo, vai "destruir a humanidade" sozinha? Ela precisa de mãos. Alguém, um humano, precisa dar acesso a alguma coisa que cause dano no mundo físico. Acesso a uma arma, a um sistema de mísseis, a uma rede elétrica, a uma conta bancária. Software não tem braço, não tem perna, não tem botão de lançar míssil embutido. Ele depende, cem por cento, de um humano ter conectado ele a um atuador que faça algo no mundo real.

E aí eu pergunto o óbvio: ninguém vai tirar da tomada? Não existe uma "máquina" que possa fazer estrago sozinha, por mais poderosa que o marketing diga que ela é. É totalmente dependente do humano, do começo ao fim. O Yann LeCun, um dos pais da área e ganhador do Turing, chama o pânico existencial de "besteira completa", justamente porque os modelos atuais não têm memória persistente, planejamento nem contato com o mundo físico. O Andrew Ng compara se preocupar com a extinção pela IA a "se preocupar com superpopulação em Marte". Gente que entende do assunto de verdade não está desesperada.

Isso que a gente está vivendo tem nome, e é velho: fear mongering. O terror do "o fim está próximo". Sempre existiu. Teve o pânico do cometa Halley em 1910, quando venderam pílula anti-gás cósmico pras pessoas. Teve o bug do milênio, o Y2K, onde o mundo gastou uns 300 bilhões de dólares com medo de um colapso sistêmico que simplesmente não aconteceu. É sempre a mesma estrutura: alguém com algo a ganhar te vende o apocalipse.

## Conclusão

Me entenda bem: eu uso essas ferramentas todo dia e escrevo sobre elas o tempo todo. O meu ponto é sobre ligar o cérebro antes de compartilhar a manchete.

Quando uma empresa que vende GPU anuncia que a AGI chegou, pergunte quem lucra. Quando uma empresa queima milhões de dólares em compute pra "resolver" um problema que ela nem vai cobrar o prêmio, e ainda ameaça a carreira de um matemático no caminho, pergunte o que ela está comprando com aquela manchete. Quando um funcionário sai chorando Skynet no Twitter às vésperas de um IPO, pergunte cadê a evidência e cadê o custo que ele pagou por isso.

Exija prova. Exija skin in the game. Pergunte quem ganha com o seu medo e com a sua empolgação. Faça isso, e a maior parte dessa propaganda desmancha na sua frente.

E se você leu tudo isso e ainda saiu daqui achando que o robô vai acordar e te matar enquanto você dorme, sem ninguém ter plugado ele em coisa nenhuma, bom, aí volta lá no começo e lê meu lema de novo.
