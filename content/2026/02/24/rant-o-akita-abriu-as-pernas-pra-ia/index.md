---
title: "RANT: o Akita abriu as pernas pra IA??"
slug: "rant-o-akita-abriu-as-pernas-pra-ia"
date: 2026-02-24T11:54:26+00:00
draft: false
tags:
- vibecode
- rant
translationKey: rant-akita-caved-to-ai
---

> **TL;DR**: Eu sempre "abri as pernas" pra IA. Mas se você só assistiu clipes dos podcasts, entendo porque está confuso. Vou explicar.

Alguém lembra deste meu video: ["16 Linguagens em 16 Dias"](/2023/09/20/akitando-145-16-linguagens-em-16-dias-minha-saga-da-rinha-de-backend/)? É do final de 2023 (1 ano depois do lançamento do primeiro ChatGPT) e é sobre a primeira Rinha de Backend. Como vocês acham que eu fiz código em 16 linguagens em 16 dias??

Eu uso IA pra fazer código desde o começo de 2023 (3 anos já). Não comecei agora: eu nunca parei. 🤷‍♂

*"Mas você disse que IA nunca ia ser boa, você odeia IA"*

Isso foi o que você entendeu porque é preguiçoso e só assiste a clipes fora de contexto ou tweets fora de contexto. Se lesse meu blog, eu tenho literalmente dezenas de posts (particularmente de 2 anos pra cá) detalhando cada aspecto da evolução e uso de IAs (seja pra código, seja pra imagens, seja pra 3D modelling).

## "Empolgação?"

E quanto à minha famosa frase:

> **"Sua empolgação com IA é inversamente proporcional ao seu conhecimento sobre IA"** ?

Continua correta. É que nem quem falava que Low Code ia substituir todo programador. Não vai. Mesma coisa agora: por melhor que a IA seja, ela não vai substituir todo programador. Só os ruins, como já expliquei [neste outro rant](https://akitaonrails.com/2026/02/08/rant-ia-acabou-com-programadores/).

Programadores como eu não têm nenhum problema: nós somos os tomadores de decisão que conseguem decidir o que IAs não conseguem hoje e nunca vão conseguir (é uma impossibilidade na fundação da computação, já volto nisso).

Os "empolgados" que eu falei, é todo não-programador startupeiro que - com ou sem IA - me lança código porcaria em produção e daí acontecem coisas como o fracasso do app **"Tea"**, lembram?

[![tea leak](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/tea.jpg)](https://www.npr.org/2025/08/02/nx-s1-5483886/tea-app-breach-hacked-whisper-networks)

Não houve nenhuma tentativa de "hacking"; o banco de dados deles já estava aberto ao público em produção: qualquer um podia só baixar. Isso é um cara "empolgado com IA".

Ou os idiotas que já demitiram todos os seus programadores porque acha que o código de IA vai ser muito melhor. Spoiler alert: não vai.

Aí você fica mais confuso. *"Você não gosta de IA, então?"* Não, não, eu gosto. *"Mas se gosta é porque ele já é inteligente?"* Não, não. Veja como sua linha de raciocínio não faz sentido. 

## "Papagaio Estocástico?"

Me lembraram hoje que eu disse também:

> **"IA é só um gerador de textos glorificado"**

Confusos? *"Como ela pode ser boa se é só um gerador de textos??"*

Eu realmente não entendo essa linha de raciocínio. Geradores de texto são objetivamente bons. Eu e você usamos todos os dias o auto-corretor de todo app de e-mail e mensagens. Sejam os do teclado de iPhone ou Android. Seja Grammarly. Nenhum de vocês vai dizer que ela tem "personalidade" ou mesmo "inteligência", mas acho que todos concordamos que ela é muito útil. Mesmo errando, de vez em quando, na maior parte do tempo conserta nossos textos direitinho, não?

GPT ou Claude ou GLM ou Gemini ou DeepSeek, todos eles continuam sendo "papagaios estocásticos" ou "geradores de texto glorificados".

* Papagaio estocástico: algo que repete coisas com método aleatório ou parcialmente aleatório (existe um elemento de entropia)
* Geradores de texto: utilizam cálculo probabilístico (transformers no lado complicado, ou cadeias de Markov, no lado simples) pra tentar descobrir a palavra/token mais provável, dado do texto anterior.

Toda "IA" (mais corretamente "LLM") são exatamente assim desde que foram lançadas em 2022 até hoje: gigabytes de matrizes hiper-dimensionais de pesos e probabilidades onde seu texto/prompt é calculado contra essas matrizes pra definir o "próximo token". Concatena esse novo token no texto original e recalcula tudo de novo nas mesmas matrizes (mais corretamente, tensors), **sorteia** o próximo token de um pequeno grupo de probabilidades, concatena, repete, e segue assim.

Isso é um "gerador de textos". Mas sim, eles são tão bons que "parecem" até ter personalidade nas respostas. E seres humanos são muito facilmente enganados a "antropomorfizar" coisas que não humanos. Não precisa de muita coisa. 

Em 2023, no video ["Entendendo como ChatGPT Funciona"](/2023/06/19/akitando-142-entendendo-como-chatgpt-funciona-rodando-sua-propria-ia/) eu explico sobre o Teste de Turing, um dos primeiros aplicativos "conversacionais" que passam no teste, a ["Eliza"](https://en.wikipedia.org/wiki/ELIZA), que já passava no teste, e sem precisar de IA.

Por isso eu disse que são "glorificados", porque todos que tem pouco conhecimento de IA, pensam nela como o macaco do filme pensa no monolito: como uma divindade que precisa ser glorificada.

![2001 a Space Odyssey](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/2001-a-Space-Odyssey.jpg)

## "Mas e o Flow?"

*"Mas Akita, no Flow você era contra IAs."*

Nope, de novo, você só assistiu clipes. Veja como eu abro a conversa: estou falando da histeria em torno do ["Report AI 2027"](https://ai-2027.com/), estou falando das asneiras do Sam Altman de que eles estavam bem próximos de atingir "AGI" (Inteligência Artificial GERAL, uma inteligência que, igual um humano, raciocina e decide as coisas sozinho e é capaz de evoluir autonomamente). E todas as controvérsias sobre IAs que chegavam num "plano" pra matar o dono (o que eu chamo de "fanfics").

Daí eu passo horas explicando em detalhes a história e exatamente como é feito o "cálculo de próximo token", como também [dei mais detalhes](/2025/04/29/dissecando-um-modelfile-de-ollama-ajustando-qwen3-pra-codigo/) aqui no blog. E sempre dizendo que precisa existir alguma "nova descoberta" (que ainda não aconteceu). Enquanto cada novo GPT ou Claude forem só uma evolução do anterior, existem limites. E eu expliquei os limites.

Não é uma "questão de tempo". Isso não existe. Mesmo nunca tendo ido pra, digamos, Saturno, nós sabemos o que é necessário e o principal: quanto custa. **"COM A TECNOLOGIA ATUAL"** - que é sempre a premissa - não tem como/não faz sentido prático.

Amanhã pode surgir uma "nova descoberta" que mude tudo. Mas enquanto ela não aparece, não podemos "contar com isso". E toda minha explicação é com base nessa premissa. E a conclusão é objetiva e matemática: 

> AGI não é alcançável. Isso não mudou.

Não significa que as IAs atuais sejam **INÚTEIS**. Essa é a contra-conclusão que eu não consigo entender o raciocínio também. Em todos os podcasts, depois do primeiro, eu voltava dizendo: *"Do jeito que eu falo, alguns parecem entender que eu não gosto de IAs, mas é o contrário: eu gosto."*

Cansei de repetir isso nos podcasts, no blog, no X, mas essa é a parte que todo mundo faz de conta que não está lá e **OMITE**. Por isso sempre deixo tudo por escrito aqui no blog e, como falei, vocês podem ver que eu já usava desde 2023 - 3 anos atrás.

> Em resumo: TUDO que eu disse nos últimos videos do meu canal e nos podcasts, **CONTINUAM VALENDO**. A explicação continua correta. O que está errado são SUAS CONCLUSÕES. Reveja e interprete literalmente e não subjetivamente, com a falta de conhecimento que vocês tem. Não ignorem os termos que eu falei que vocês não entendem. O argumento só faz sentido se for completo, e ele custou 4 horas pra eu explicar, em cada video.

## Recado aos "Empolgados"

Eu disse isso no X esses dias:

[![agile vibe code](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-24_12-23-27.jpg)](https://x.com/AkitaOnRails/status/2025649633318555812)

Não importa se quer chamar de "Vibe Code", "Agentic Engineering", "IA Assisted Programming", é tudo **bullshit**.

TUDO agora é "programar com IA".

E só tem dois jeitos de fazer isso: o certo e o errado. O jeito errado é como vocês e o dono do app Tea (provavelmente, supostamente) fazem: deixam a IA fazer o código, não sabem revisar nem criticar esse código, sobem pra produção e deixam usuários usarem, sem saber dos riscos.

O jeito certo: eu passei DOIS MESES escrevendo mais de VINTE POSTS neste blog explicando o jeito certo, que eu chamei de "Agile Vibe Code", mas é basicamente **"Engenharia de Software aplicada à IA"** e adivinhe: precisa ter estudado e experiência pra saber.

Não é 2026 e não vai ser 2027 nem tão cedo quanto você pensa que o Claude ou Codex vão "substituir TODOS os programadores". Não, vão SIM substituir todos os ruins e isso é excelente! Novamente, [leia este rant](https://akitaonrails.com/2026/02/08/rant-ia-acabou-com-programadores/).

Você nunca vai conseguir fazer um "novo Linux" e "substituir o Linus Torvalds" com IA. Vai conseguir "copiar partes", sim. Copiar não é suficiente. Programador ruim já copiava antes, e isso nunca os tornou bons.

## Recados aos "Haters de IA"

Desistam, é um caminho sem volta. Assim como foi mobile, assim como foi a internet, assim como foram micro-computadores, etc. A caixa de pandora já foi aberta, não tem como fechar mais. IAs vieram pra ficar.

> *"Mas você disse que IA é uma bolha que ia estourar!"*

De novo, ou vocês se fazem de bobo ou são bobos.

A Bolha da Internet de 2001 estourou, mas a Internet não desapareceu. Pelo contrário, ela aumentou! Quem sumiu foram as empresas que acharam que iam ganhar dinheiro fácil aproveitando a onda da bolha, e todo mundo que acreditou cegamente. Porém, quem foi **"Hater de Internet"**, perdeu também.

A esta altura, todo argumento contra IA já soa como uma desculpa mal feita. Vamos ver algumas:

*"IA comete vários erros, vira e mexe eu vejo um código meia boca."*

É verdade, e justamente por isso falei pra não se empolgar à toa. Ela comete erros, eu pego todos os dias. Até o ano passado, a taxa de erro vs acertos era alta o suficiente pra eu não conseguir recomendar que qualquer amador usasse no dia a dia. Só quem presta muita atenção e sabe corrigir - como eu.

Porém, em 2026, essa taxa melhorou significativamente. Ela de fato acerta mais do que erra agora, o suficiente pra eu conseguir confiar nela sem "micro-gerenciar" cada passo.

A verdade é que todo programador humano erra, e erra BASTANTE. Quem erra tem viés de confirmação e não acha que erra tanto. Só quem vê de fora - alguém como eu, que já gerencei centenas de programadores em dezenas de projetos - sei que eles erram muito mais do que estão preparados pra admitir.

Eu CANSEI de pedir pra sempre só subir PR com testes unitários: todo mundo ignora.

Eu CANSEI de pedir pra sempre pelo menos rodar uma vez na própria máquina pra ver se está funcionando, do que eu puxar o PR e descobrir que nem executa: todo mundo ignora.

Eu CANSEI de pedir pra não só dar copy e paste do stackoverflow, e pelo menos ajustar a adaptar pro nosso projeto. Todo mundo ignora.

Eu CANSEI de pedir pra não jogar tudo no mesmo arquivão e fazer refactoring de tempos em tempos pra não aumentar débito técnico: todo mundo ignora.

Eu CANSEI de pedir pra não subir mais commits com mensagens de "bug fix", sem explicar o que tem lá exatamente: todo mundo ignora.

Eu CANSEI de pedir pra lembrar de atualizar a documentação quando mudar alguma funcionalidade, pra facilitar quem vai pegar pra testar: todo mundo ignora.

Eu CANSEI de pedir pra cobrir um bug fix com teste de regressão pra não vermos o mesmo erro de novo. O mesmo erro sempre se repetia: todo mundo ignora.

Eu CANSEI de pedir pra seguir as convenções que concordamos no projeto e não fazer código diferente, com outros padrões. Todo mundo ignora.

Eu CANSEI de pedir pra ajustar scripts de deploy, CI ou coisas assim quando ca pedaços que afetam a infra: todo mundo ignora.

Eu CANSEI de pedir pra não acumular um monte de código que não faz sentido junto e não dar `git add .` no final e só escrever "nova feature" e comitar tudo junto. Todo mundo ignora.

Esses são só alguns exemplos. Sabe qual a novidade: o Claude e o Codex não ignoram. Tudo isso que listei, que acontece em TODO projeto com humanos, não importa o tamanho do projeto, não acontece mais pra mim com Claude.

Entendam: isso tudo deveria ser o básico do básico, nível estag. Mas eu CANSEI de pedir pra sênior tomar mais cuidado, pra não dar mau exemplo pros júniors: TODO MUNDO IGNORA.

E agora, todos esses que ME CANSARAM, são justamente os que se tornaram "Haters de IA". Mas é lógico, a IA faz tudo que eles NÃO FAZEM. Olhem no espelho e reflitam se seu código era tão bom assim (Spoiler: não era).

90% de todo código produzido, não é nem de perto alguma coisa como "otimização na solução de memory management do Linux" ou "bug fix de regressão de performance no drivers do file system" ou "melhoria no algoritmo de segurança do firewall" ou "reescrever esta parte antiga de Assembly em C"..

90% da maior parte do código produzido no dia a dia é **MUNDANO**, é consumir uma API, é fazer um front-end, é mais um relatório, mais um CRUD, mais uma validação de e-mail, mais um job de limpeza, mais um script de deploy. Absolutamente NADA realmente "interessante".

O que eu gostei das LLMs? Ela REMOVE de mim todas as tarefas mundanas e me deixa focar nas partes que eu gosto: a pesquisa, a formação de hipóteses, os benchmarks, os testes a/b pra conseguir tomar decisões melhores, os testes de integração que garantem que as diversas partes do meu sistema funcionam mesmo. Tudo que antes não dava pra fazer, porque 90% do meu tempo era ocupado consertando a porcaria do CSS de alguém.

Eu ODEIO mexer em CSS. Já passou da hora de não precisar mais.

Eu ODEIO fazer CRUD. Já passou da hora de não precisar mais.

Eu ODEIO fazer o setup inicial de ambiente de dev pra cada projeto diferente. Já passou da hora de não precisar mais.

Eu ODEIO ter que fazer especificação de coisas idiotas como mapear campos numa API mal feita de fintech/banco. Já passou da hora de não precisar mais.

Eu ODEIO ter quinhentos frameworks mal feitos de front-end pra costurar tudo junto e rezar pra funcionar na tentativa e erro. Já passou da hora de não precisar mais.

Eu ODEIO ter que participar de reunião de sprint, onde o que é pedido vai sendo modificado ao longo do caminho porque ninguém prestou atenção. Já passou da hora de não precisar mais.

Eu ODEIO ter impedimento, ter que ficar esperando, porque outro dev ou outra equipe tá trabalhando em coisa que afeta o meu lado e no final vou gastar dias depois só ajustando conflito na mão. Já passou da hora de não precisar mais.

Quem são os "Haters de IA": justamente todo mundo que me causava impedimento antes, responsáveis por esticar mais do que deveria, e entregar em qualidade ruim, todas as tarefas MUNDANAS, e achar que está fazendo grande coisa.

## O que a História me Ensinou

Computadores entendem instruções de máquina. Elas estão cagando e andando pras nossas "linguagens favoritas". É o que eu gastei horas explicando nos podcasts e nos videos do meu canal.

Foda-se sua linguagem/framework favorito. Foda-se seu design pattern favorito. No final, a máquina só se interessa pelo binário que vai rodar.

Antigamente, era extremamente custoso informar essas instruções pra máquina. Tínhamos que, literalmente, entrar bit a bit com cada instrução, no endereço exato na memória. Seja com FIOS ou com SWICHES, UM BIT DE CADA VEZ:

![eniac](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/7972f02c9ad7fe9bc30d1493b1295188.jpg)

![Altair 8800](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/NV_0103_Driscoll_Large.jpg)

Felizmente, as coisas evoluíram e melhoramos as formas de "INPUTAR" instruções e dados. Seja com papel perfurado ou teletypes (máquinas de escrever elétricas adaptadas como terminais burros):

![cartão perfurado](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/s-l400.jpg)

[![teletype](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-24_12-55-27.jpg)](https://www.youtube.com/watch?v=zeL3mbq1mEg)

Era caro programar, porque era MUITO custoso "consertar" um erro. Não tinha "backspace" fácil. Na hora que ia digitar, você tinha que ter MUITA CERTEZA do que ia digitar, sem errar!

Mesmo no fim dos anos 70, começo dos anos 80, já tinha evoluído muito, mas ter armazenamento permanente era uma coisa OPCIONAL na maioria dos "micro" computadores. Tínhamos que digitar os programas do zero pra rodar e quando a máquina desligava, o que estava em RAM apagava e perdíamos tudo. Gravar era caro, uma das opções mais populares, era gravar em fita cassete:

![c64set](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/c64set.jpg)

Mas pra gravar/ler somente míseros 1 kilobyte de dados, poderia levar MAIS de 20 segundos. Um joguinho de 10 kilobytes (que é bem pouco), levaria quase 4 MINUTOS pra carregar.

Você nem tem ideia do que significam 10 kilobytes. Qualquer ícone PNG ou SVG ou qualquer arquivinho idiota de JS no seu website tem muito mais do que isso.

Tudo isso pra dizer o seguinte:

- computadores rodam instruções de máquina, até hoje
- sempre foi caro informar essas instruções pro computador

Hoje em dia temos SSD NVME que me permitem ler 1 gigabyte hoje (<70ms) mais rápido do que eu lia 10 kilobytes nos anos 80.

Mas pra compensar, nossos programas foram ficando mais e mais complexos e "gordos". Uma vez que memória, armazenamento, barramento de dados, tudo ficou de ordens de grandeza mais rápido, nós humanos, fomos jogando mais e mais dados neles. Um editor de textos hoje, faz a mesma coisa que um editor de textos nos anos 80: edita texto. Mas, lógico, tem muito mais funcionalidades: fontes bonitas, smooth scrolling, auto-correct, auto-format, etc.

Trocamos recursos por conforto, e isso é uma boa coisa.

Falei nos meus videos, nos posts de rant recentes, que foi uma coisa muito ruim a bolha de startups que estourou só em 2022 (e continua repercutindo até hoje). Trocamos eficiência de programação por programadores ruins baratos. Pra que tentar ser mais eficiente se era "barato" só colocar mais "braços" pra resolver o problema? A mesma mentalidade que permitiu o surgimento de fábricas de software baratas nos anos 2000, fazendo software ruim como se amanhã não houvesse.

Eu, pessoalmente, fico muito contente por finalmente termos dado mais um passo para conseguir informar instruções à máquina com mais eficiência. LLMs, nossos papagaios estocásticos, são, de fato, a forma mais eficiente de produzir 90% das instruções que precisamos fornecer pras máquinas computarem o que precisamos. Da mesma forma que eu não sinto falta de cartão perfurado, nem de teletipos, nem de fita cassete, se eu não precisar mais usar uma IDE no meu dia a dia, não vou sentir falta.

> Eu não escolhi me tornar um programador pra virar operador de IDE. Quando eu comecei, nem existia o conceito de IDEs.

Eu escolhi me tornar um programador porque eu gosto da ideia de instruir uma máquina a computar as coisas que eu quero. Seja uma planilha, seja um jogo. COMO essas instruções são inputadas, não é o principal pra mim. Nunca foi. IDEs foram só uma pequena fase dentro de décadas de carreira e não serão as últimas.

> Eu não entendo o raciocínio nem dos empolgados demais nem dos haters demais. Por que você precisa glorificar um martelo? Por que você precisa odiar um martelo? Era só isso que eu precisava dizer 🤷‍♂

## Algumas Desculpas Idiotas

*"Mas a Anthropic (ou OpenAI) são do mal"*

Foda-se. Microsoft também era, passou até por julgamento anti-truste no ano 2000 que quase dividiu a empresa. Mesmo se eu prefiro Mac ou Linux hoje, Windows deixou de ser o sistema operacional mais usado do mundo? Não.

*"Mas IA usa muita energia, e o meio ambiente?"*

Foda-se. Isso nunca foi um consenso (e mais provavelmente nunca vai ser e nem é um problema). O planeta já passou por 5 ou 6 grandes de eventos de extinção antes, o último foi um meteoro que caiu e dizimou os dinossauros. Já passamos por múltiplas Eras do Gelo. O planeta vai continuar bem, não se preocupem.

O problema da última década foi a imbecilidade de não terem investido em mais usinas nucleares - e agora essa opção finalmente voltou pra mesa. Eu disse no Flow que a Alemanha fechando as delas foi uma das decisões mais idiotas de todos os tempos, e reafirmo: foi.

São as duas mais prevalentes de que me lembro hoje. Mas é isso: qualquer coisa é desculpa agora. A caixa de pandora foi aberta, não tem mais volta.