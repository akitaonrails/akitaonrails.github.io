---
title: "Por que LLMs vão falhar na Sua Empresa?"
slug: "por-que-llms-vao-falhar-na-sua-empresa"
date: '2026-06-24T12:00:00-03:00'
draft: false
translationKey: why-llms-will-fail-at-your-company
tags:
  - ia
  - llm
  - agentes
  - agile
  - scrum
  - produtividade
  - programacao
  - vibecoding
---

Este post é mais especulação do que tese fechada. Estou pensando alto. Pode estar incompleto, pode estar errado. Se você discordar, melhor ainda: responde nos comentários. Não estou tentando vender metodologia nova. Quero cutucar uma ferida que muita gente finge que não existe.

Nos últimos meses começaram a aparecer histórias de empresas grandes gastando quantidades absurdas de tokens em ferramentas de IA sem conseguir apontar, com clareza, o resultado equivalente em produto. O caso que ficou mais famoso foi a [Uber queimando o orçamento anual de IA em poucos meses](https://www.forbes.com/sites/janakirammsv/2026/05/17/uber-burns-its-2026-ai-budget-in-four-months-on-claude-code/) com uso pesado de ferramentas como Claude Code, e executivos admitindo que ainda não conseguiam traçar uma linha reta entre consumo de tokens e valor entregue. Não é que ninguém tenha usado. Usaram demais. Esse é justamente o problema.

Até aqui, acho que a maioria já entendeu que prompt de uma linha não resolve nada. Aquela fantasia de escrever "faça um clone do Uber" e voltar com um produto pronto morreu rápido. A resposta do mercado foi correr para outro lado: **spec-driven development**.

Em vez de pedir tudo em uma frase, você escreve uma especificação. Define escopo, casos de uso, critérios de aceite, arquitetura desejada, restrições, fluxos, talvez até um PRD inteiro. Depois entrega isso para o agente e espera que ele implemente com menos ambiguidade.

Isso é melhor do que one-shot? Claro. Mas ainda acho que está errado.

## O problema não é falta de especificação

Eu venho martelando essa ideia há anos, antes de LLM virar moda. Dois vídeos meus são importantes pra entender o ponto: [Não Terceirize Suas Decisões](/2019/10/09/akitando-63-nao-terceirize-suas-decisoes-a-licao-mais-importante-da-sua-vida/) e [Esqueça Metodologias Ágeis](/2019/06/18/akitando-51-esqueca-metodologias-ageis-rated-r/).

> O resumo é simples: a maioria dos profissionais foi treinada a não decidir.

Pensa no seu dia a dia. Muita gente não faz nada se não houver backlog pronto. Cruza os braços, culpa gestão, culpa colega, culpa cliente, e espera alguém dizer o que fazer. Quando a tarefa chega, executa. Quando dá errado, a culpa era do requisito. Quando o cliente reclama, a culpa era da prioridade. Quando o produto degrada, a culpa era do processo.

Quase ninguém decide de verdade, banca a decisão até o fim e sofre as consequências. E sem sofrer a consequência, você não aprende a decidir.

Você não aprende quais escolhas levam a quais resultados. Não aprende a priorizar. Não aprende a explicar por que algo precisa existir. Não aprende a escrever uma especificação porque entende o problema; aprende a preencher template para ninguém reclamar.

## O Agile virou burocracia estruturada

Os princípios originais de 2001 foram triturados. O que muita empresa chama de Agile hoje é burocracia estruturada em ciclos menores.

O desenho clássico todo mundo já viu: backlog, sprint planning, sprint, daily, review, retrospective, próximo sprint. A [Scrum Guide](https://scrumguides.org/scrum-guide.html) descreve os eventos formais. Diagramas como o [Scrum process da Wikimedia](https://commons.wikimedia.org/wiki/File:Scrum_process.svg) mostram o círculo bonitinho. Na prática, muita equipe transformou isso em teatro.

Passa-se um dia inteiro debatendo o que entra no backlog. E o backlog final raramente é o que precisa ser feito. É o consenso de menor resistência. Compromisso em cima de compromisso. Pequenas tarefas, pequenos riscos, pequenas vitórias, pequenos fracassos. Tudo desenhado para não gerar conflito demais.

Isso não é apenas medíocre. É pior: é a escolha ativa por decisões fáceis, que não levantam muita crítica contra você.

Depois a equipe passa dias ou semanas implementando aquele backlog morno. O QA entra, encontra problemas, tenta encaixar correções na próxima rodada. Mais alguns dias, talvez mais duas semanas. Um mês depois, talvez dois, a decisão original finalmente começa a mostrar resultado em produção.

Só que o resultado está tão longe da decisão que quase ninguém faz a correlação. A equipe não sente o peso real do que decidiu. O erro não vira aprendizado. O processo não melhora. A parte mais importante de qualquer sistema de melhoria contínua, o **kaizen**, nunca acontece.

> O que acontece é outra coisa: todo mundo aprende a ficar invisível.

Você aprende a agradar gestão, não o produto. Aprende a reduzir atrito, não a resolver o problema. Aprende a sobreviver à reunião, não a entregar valor. E quando os resultados pioram, a resposta da alta gestão é previsível: mais controle, mais regra, mais gate, mais comitê, mais checklist. A engrenagem fica mais pesada. O time fica mais covarde.

## Então chega a IA

Agora entra a LLM.

Até pouco tempo atrás, o maior gargalo de desenvolvimento era escrever e ajustar código. Codar levava dias ou semanas. Por isso tanto esforço era colocado na fase de planejamento. Se o time vai gastar duas semanas implementando, parece fazer sentido gastar um dia discutindo o que entra na sprint.

Mas ferramentas de coding com LLM mudam a posição do gargalo. Elas conseguem fazer uma parte grande do trabalho braçal: gerar estrutura, escrever testes básicos, fazer refactors, adaptar APIs, criar telas, preencher boilerplate, tentar correções. Não é perfeito, mas é rápido o bastante para mudar a economia do processo.

É aquela história da corrente e do elo mais fraco. Você reforça um elo, outro passa a limitar o sistema. Antes, o elo fraco era a velocidade de codificação. Agora, cada vez mais, é a capacidade humana de decidir, explicar, testar e revisar.

> O erro das empresas é colocar LLM dentro do mesmo processo quebrado e esperar ganho multiplicativo.

Você pega pessoas treinadas por anos a não decidir, entrega uma ferramenta que exige clareza de decisão, e se surpreende quando sai lixo mais rápido.

## A LLM reflete o usuário

Um agente de coding precisa que você explique o objetivo, o contexto, as restrições, as prioridades, o que não pode quebrar, quais caminhos são aceitáveis, como medir sucesso. Ele precisa de uma direção objetiva.

Agora vai entrevistar seu time. Pergunta para cada pessoa:

- qual é o objetivo real do que você está fazendo?
- como isso melhora o produto?
- qual métrica deveria mudar?
- que trade-off você está aceitando?
- o que não pode quebrar?
- quais casos tristes precisam ser testados?

Muita gente não sabe responder. Sabe qual ticket pegou. Sabe que precisa fechar algumas tarefas por semana. Sabe que tem daily amanhã. Mas não sabe por que aquilo importa.

E aí você entrega uma LLM para essa pessoa.

O resultado não é mágica. É espelho. Código ruim dez vezes mais rápido. Bug dez vezes mais rápido. Cliente irritado dez vezes mais rápido. Pull request gigante dez vezes mais rápido. O problema não é só a IA. É que a IA amplifica a falta de direção.

Spec-driven development tenta corrigir isso com documentação. Mas se a especificação nasce do mesmo processo covarde, ela só documenta a covardia. Um PRD escrito por quem não entende a decisão continua ruim. Critério de aceite escrito para evitar conflito continua desviando do problema real. O agente só vai executar melhor uma decisão ruim.

## O processo precisa mudar

Minha hipótese é que o processo inteiro precisa ser redesenhado ao redor da nova restrição. De novo: é especulação. Eu não tenho dados suficientes para provar isso. Mas, olhando para o tipo de falha que vejo em empresas e para o tipo de sucesso que vejo em uso individual intenso, minha teoria é essa:

> **jogue fora o ritual de sprint como unidade central de trabalho.**

Não faz sentido manter dias de planning, dias de review e semanas de codificação como se o gargalo ainda fosse o mesmo. Com LLM, o ciclo precisa ficar mais curto. Muito mais curto. Idealmente, dentro do mesmo dia.

No meu desenho ideal, cada programador com LLM deveria parear diretamente com um Product Owner por blocos de trabalho curtos. O papel do PO é fechar a lacuna que o programador normalmente tem: objetivo, prioridade, restrição, contexto de negócio, resultado esperado. Isso precisa entrar no prompt e na conversa com o agente.

Mas como codar deixou de ser o gargalo principal, o PO não precisa esperar duas semanas para ver resultado. Ele pode sentar com o programador durante uma manhã, implementar uma pequena fatia funcional, ajustar na hora, decidir na hora, cortar escopo na hora. Depois roda para outro programador.

Em seguida, entra QA. Não como uma fase distante, mas como pareamento no mesmo ciclo. O QA fecha outra lacuna comum do programador: testar só o caminho feliz, esquecer casos de erro, não automatizar o suficiente, não pensar em regressão de comportamento. A função do QA vira ajudar a transformar a implementação em algo verificável agora, enquanto o contexto ainda está quente.

Depois entra o Tech Lead. Também no mesmo dia, não duas semanas depois. Ele olha para o que mudou e fecha a terceira lacuna: complexidade desnecessária, design ruim, regressão escondida, documentação faltando, vulnerabilidade óbvia, performance piorando, acoplamento que nasceu sem necessidade.

Constrói, checa, ajusta. Tudo em tempo real.

<figure>
  <a href="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/06/24/why-llms-fail/llm-pairing-rotation.svg">
    <img src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/06/24/why-llms-fail/llm-pairing-rotation.svg" alt="Diagrama comparando o fluxo comum de sprint, com decisão distante do resultado, contra um fluxo de pareamento rotativo com LLM envolvendo PO, programador, QA e Tech Lead no mesmo dia." />
  </a>
  <figcaption>O gargalo muda: menos tempo esperando uma sprint terminar, mais ciclos curtos de decisão, implementação, teste e revisão.</figcaption>
</figure>

## O novo papel de cada pessoa

Esse modelo cobra mais responsabilidade, não menos.

O programador deixa de ser a pessoa que só pega ticket. Ele precisa aprender a transformar objetivo em instrução executável. Precisa discutir trade-off. Precisa entender por que está codando. Precisa usar a LLM como ferramenta de execução e investigação, não como desculpa para desligar o cérebro.

O PO deixa de ser fábrica de backlog. Ele precisa decidir com o programador, olhando para o produto vivo. Não é escrever card e sumir. É ver a coisa nascer, ajustar, cortar, priorizar e aceitar consequência.

O QA deixa de ser a pessoa que recebe o pacote no fim e devolve defeito. Ele entra cedo para transformar comportamento esperado em verificação. Se a LLM acelera código, QA precisa acelerar aprendizado sobre risco.

O Tech Lead deixa de ser carimbo de PR atrasado. Ele entra enquanto ainda dá para mudar barato. Ajuda a manter simplicidade, remove complexidade, protege arquitetura, documentação, segurança e performance.

Nada disso funciona se todo mundo continuar usando IA como autocomplete caro dentro do mesmo Scrum burocrático.

## Por que empresas não vão gostar disso

Porque esse processo expõe decisões.

No processo atual, a decisão se dilui. Foi o backlog. Foi o PO. Foi o refinamento. Foi a sprint. Foi o time. Foi a dependência. Foi o cliente que mudou de ideia. Todo mundo consegue se esconder.

Num ciclo curto com LLM, a decisão aparece rápido. Você disse que aquilo era prioridade? Então implementa agora. Você disse que o critério de aceite era esse? Então testa agora. Você disse que esse design era bom? Então revisa agora. Se estiver errado, a consequência aparece no mesmo dia.

Isso é desconfortável. Mas é assim que se aprende.

Sem consequência próxima, decisão vira teatro. Com consequência próxima, decisão vira treino.

## Como implementar isso sem queimar dinheiro

O primeiro passo é aceitar uma coisa que programador profissional costuma odiar: dá para jogar código fora.

> Na verdade, você deveria jogar código fora com muito mais frequência.

Código não é monumento. Código é material de trabalho. Deletar código é tão importante quanto escrever código novo. É por isso que usamos Git. A ideia sempre foi trabalhar em branches, experimentar caminhos, mudar de ideia, comparar alternativas, apagar o que não funcionou e manter só o que sobreviveu ao teste da realidade.

Só que, no processo tradicional, código fica caro demais emocionalmente. Se levou duas semanas para sair, ninguém quer admitir que foi desperdício. O gerente sente que apagar aquilo prova que a decisão anterior foi ruim. O programador defende a implementação porque sofreu para fazê-la. O time empurra o problema para frente porque deletar parece derrota. Não é. Às vezes é higiene.

Com LLM, esse custo muda. **Fica barato errar**. Fica barato prototipar. Fica barato fazer prova de conceito. Fica barato testar dois caminhos e jogar um fora. Fica barato pedir para o agente reescrever uma abordagem inteira numa branch temporária, comparar, documentar o aprendizado e dar `git reset` sem drama.

Então faça mais disso. Mais protótipos. Mais provas de conceito. Mais testes A/B internos. Mais branches descartáveis. Menos apego ao primeiro código que apareceu. LLM é muito boa nesse tipo de trabalho: explorar alternativas rápido, mostrar onde a especificação estava vaga e produzir material que você pode destruir sem culpa.

Mas não espere que todo mundo receba tokens de LLM numa segunda-feira e saiba fazer isso sozinho. Esse é o jeito mais rápido de queimar orçamento e depois dizer que IA não funciona.

Minha sugestão é o contrário: assuma uma ou duas semanas sem entrega planejada. Diga claramente que o objetivo não é produzir feature. É treinar o novo processo. Quebrar o ritual antigo. Deixar o time praticar em ambiente seguro. Se der errado, ótimo: reseta a branch, apaga o protótipo, documenta o que aprendeu e tenta de novo.

Nessa fase, o PO não deveria escrever especificação de vinte páginas. Deveria parear com o programador e construir prompts pequenos, um passo de cada vez, vendo o resultado em tempo real. A cada resposta da LLM, o PO aprende quanto detalhe o código realmente precisa. O programador aprende a perguntar melhor. QA aprende a transformar comportamento em teste cedo. Tech Lead aprende a cortar complexidade enquanto ela ainda é barata.

É assim que se adota LLM com alguma chance de dar certo: como mudança de processo, não como licença cara de autocomplete.

## A conclusão incômoda

> LLMs falham tanto porque elas entram em processos feitos por pessoas que foram treinadas a não decidir.

Não é só falta de prompt melhor. Não é só falta de spec maior. Não é só falta de governança de token. Tudo isso ajuda, mas não toca o centro do problema.

O centro é que muita gente não sabe explicar objetivo mensurável, não sabe priorizar, não sabe assumir trade-off, não sabe conectar decisão com resultado. E uma LLM precisa exatamente disso para ser útil.

Se você coloca IA no processo velho, você acelera o processo velho. Mais backlog medíocre. Mais decisão ruim. Mais bug. Mais custo. Mais rework. Mais relatório tentando provar produtividade que o cliente nunca sentiu.

Se você quer que LLM funcione, precisa redesenhar o processo ao redor dela. Ciclos menores. Pareamento real. Decisão perto da execução. Teste perto da decisão. Revisão perto do código. Resultado perto de quem decidiu.

Essa é a parte que programador precisa encarar: sim, você provavelmente nunca aprendeu a decidir direito. Nunca aprendeu a descrever objetivo de forma objetiva. Nunca aprendeu a medir consequência. O processo te treinou para isso. E agora a IA está revelando a falha.

O lado bom é que também dá para treinar o contrário.

Mas não vai acontecer com mais uma cerimônia, mais uma planilha de prompt, mais uma política de uso de IA, ou mais uma sprint cheia de tickets escritos para ninguém ser criticado.

**Vai acontecer quando você parar de terceirizar decisão.**
