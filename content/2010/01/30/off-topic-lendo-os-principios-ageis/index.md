---
title: "[Off-Topic] Lendo os Princípios Ágeis"
date: '2010-01-30T19:32:00-02:00'
slug: off-topic-lendo-os-principios-ageis
translationKey: off-topic-lendo-os-principios-ageis
description: "Os 12 princípios ágeis precisam ser lidos em conjunto: entregar valor rapidamente não dispensa qualidade, simplicidade, colaboração e melhoria contínua. Manifesto não é receita pronta."
tags:
- agile
- engenharia-de-software
- off-topic
draft: false
---

O Manifesto Ágil é calcado em [4 valores](http://agilemanifesto.org/). Já repeti isso não sei quantas vezes. Mais do que isso, ele é calcado em [12 princípios](http://agilemanifesto.org/principles.html) importantes, que muita gente trata como os dez mandamentos.

Eu sou contra qualquer coisa dogmatizada. Mas se você prefere dogmatizar o Manifesto, nunca pegue uma frase dele isolada. Se for levar um princípio ao pé da letra, leve todos, senão é o mesmo que dogmatizar os dez mandamentos e dizer _"eu obedeço os dez mandamentos: já cometi adultério, mas não tem importância porque nunca matei ninguém, nunca roubei e não foi com a mulher do vizinho que cometi adultério."_

Alguns dos princípios:

> "Nossa maior prioridade é satisfazer o cliente através da entrega rápida e contínua de software de valor."

Esse único princípio já rendeu anos de discussão. Vale ler [Our Highest Priority](https://www.pavley.com/2009/10/08/our-highest-priority/) e [Why Satisfy the Customer?](http://web.archive.org/web/20100201014014/http://stevebockman.com:80/blog/2010/01/27/why-satisfy-the-customer/).

Eu gosto de pensar como o [Eliyahu Goldratt](http://en.wikipedia.org/wiki/Theory_of_Constraints), que diz, de forma simplificada, que a prioridade de qualquer empresa é _ganhar dinheiro._ Calma, anti-capitalistas e populistas de plantão :-) Ninguém está falando em _"ganhar dinheiro em prejuízo das pessoas, dos clientes e da sociedade"_ ou coisa parecida.

A prioridade é ganhar dinheiro. Criar inovação, criar produtos e gerar empregos são meios para chegar lá, e a gente vive confundindo os **meios** com os **objetivos**.

_"Entregar rápido e continuamente"_ é importante manter na cabeça. Nem sempre é possível, por exemplo, quando você depende de fornecedores ou de fatores externos. Mas deixa eu pegar outros princípios ligados a esse primeiro:

> "Entregue frequentemente software que funciona, de algumas semanas a alguns meses, com preferência para um período curto."

O tempo nunca é fixo, porque todo profissional sabe que não dá para prever o futuro. Entregar valor rápido é um princípio que orienta o trabalho, e ninguém deve tratá-lo como regra rígida. Significa fazer todo o possível para entregar algo que funciona, com qualidade, no menor prazo viável.

Para isso a gente tenta remover impedimentos, melhorar processos, otimizar procedimentos e melhorar a comunicação. É um lembrete para o agilista sempre que as entregas começam a demorar mais que o normal.

> "Software que funciona é a medida primária de progresso."

É a mesma ideia com outras palavras: software que não foi entregue não serve para nada. Um agilista deveria se sentir mal trabalhando meses num software que ninguém usa.

Cada software é diferente. Às vezes leva um dia inteiro para descobrir uma solução de uma linha de código, e às vezes dá para escrever cem linhas em uma hora. É o velho dilema de produtividade que a indústria tentou resolver com técnicas falidas como LOC (linhas de código), Pontos de Função e outras bobagens.

Imagino que o Martin Fowler tenha sido um dos que sugeriram esse princípio, principalmente por causa do artigo dele [Cannot Measure Productivity](https://martinfowler.com/bliki/CannotMeasureProductivity.html). Software se mede por valor. Produtividade pura diz muito pouco, e quem define o valor a ser atingido no desenvolvimento é o cliente ou a empresa.

Se o software entregue não traz valor, o problema está na definição desse valor. O software fez o que pediram. Uma ferramenta, por si só, não tem valor nenhum.

Por isso digo que LOC e pontos de função não servem para nada. Posso ter uma equipe que entrega dez mil pontos de função por sprint, e isso não significa nada se o que foi pedido não traz valor para o cliente.

Essa é uma das funções do Product Owner: garantir que o que entra na fila de desenvolvimento vai trazer valor de verdade, no curto ou no longo prazo, conforme a visão de futuro dele. Um PO sem visão, sem estratégia e sem direção clara colhe exatamente isso: muito software e pouco valor. A culpa aí é da falta de visão do PO e da empresa, e cai no colo deles, nunca da equipe técnica.

E, falando em PO, não dá para deixar de fora os stakeholders em geral, os interessados no valor que o projeto vai gerar:

> "Pessoas de negócio e os desenvolvedores devem trabalhar juntos diariamente durante o projeto."

Pessoalmente, eu detestaria burocratas todos os dias num ambiente de desenvolvimento :-) Cinismo à parte, esse é outro lembrete de que quem está interessado no valor de um projeto é quem deve procurar a equipe e ver se falta alguma coisa. Um stakeholder que nunca se dirige à equipe técnica mostra que não liga para o resultado.

E não estou falando em reunião diária. Bastam cinco ou dez minutos de conversa por dia, sem precisar de nenhum ritual como o Daily Scrum. Um stakeholder interessado levanta da cadeira e vai até as equipes. Um stakeholder desinteressado fica sentado esperando as coisas acontecerem sozinhas.

Adivinhe qual dos dois é mais eficiente? Se o stakeholder, que deveria ser o mais interessado, demonstra desinteresse pelo que está sendo produzido, por que alguém da equipe deveria se interessar?

Equipes são um reflexo da organização da empresa. Se as camadas mais altas são desorganizadas, indecisas, incomunicáveis e irresponsáveis, as equipes vão ser iguais. O que são as equipes senão subsistemas, cópias do sistema complexo adaptativo maior chamado "empresa"?

Uma empresa pode contratar cem Linus Torvalds, cem Guido van Rossum, cem John Resig, e mesmo assim não espere que eles sozinhos apareçam com iPods, iPhones e outros produtos que vendem milhões. A Apple funciona porque, especulo eu, um Steve Jobs levanta da cadeira e se envolve pessoalmente no dia a dia das equipes de pesquisa e desenvolvimento, mesmo sendo o CEO.

Colocado assim, parece que um lado se isenta da responsabilidade do outro. Claro que não. A melhor forma de trabalho é **colaborativa**, mas chegar às melhores soluções tecnológicas, com qualidade técnica e eficiência, é papel da equipe técnica. Os stakeholders, por outro lado, respondem pelos estudos de mercado, pela pesquisa de marketing e pela visão de produto.

Um lado pode e deve colaborar com o outro, mas nem todo mundo consegue fazer tudo igual. Os stakeholders trazem a visão e a equipe técnica faz o possível para cumpri-la. Só que a visão não é autoritária, assim como algumas decisões tecnológicas também não deveriam ser.

A crítica aparece quando as ordens vêm de uma direção só, sem discussão. A equipe técnica pode estar fazendo tudo certo e ainda assim seguir na direção errada, e no fim a crítica volta para ela pelo fracasso de uma visão que ninguém chegou a discutir.

> "A maneira mais eficiente e efetiva de transmitir informação para uma equipe de desenvolvimento é via conversas cara-a-cara."

Para mim, esse é um corolário do princípio anterior. Esqueça sistemas automatizados de comunicação, fluxos de informação e afins. Todo mundo já viu filme dos anos 80 e 90 ridicularizando os "memorandos", aquela técnica de espalhar informação. Até hoje as pessoas tentam algo parecido, só que agora chamam de planilha, e-mail, wiki e por aí vai.

O que importa é sentar ao lado de quem vai te entregar valor, dizer com clareza quais são as expectativas, o que mudou, o que ficou, e sair do caminho. Um stakeholder que não consegue conversar ao vivo com as equipes mostra de novo o desinteresse pelo resultado. E a mensagem fica clara: o que está sendo desenvolvido não tem valor, porque, se tivesse, ele demonstraria interesse.

Enquanto um stakeholder mantiver a mentalidade antiquada de _"esse pessoal que trabalha para mim tem a obrigação de adivinhar o que eu penso e entregar o que quero, quando eu quero"_, ele nunca vai ter valor nenhum, e vai ficar se perguntando _"será que minhas equipes são tão incompetentes assim que não me entregam nada?"_ A conclusão óbvia seria outra: _"talvez, se eu simplesmente 'disser' o que estou pensando, eles consigam me entregar o que quero."_

E não existe nada pior que um stakeholder ausente, que só dá as caras quando algo dá errado, para brigar, ameaçar e aterrorizar. Onde ele estava durante todo o processo que levou a esse acidente, em primeiro lugar?

> "Em intervalos regulares, a equipe reflete sobre como se tornar mais efetiva, então refina e ajusta seu comportamento de acordo."

Toda metodologia ágil tem uma fase de "Retrospectiva", um dos rituais criados para equipes que não estavam acostumadas a conversar. Nenhum processo é bala de prata, e todo processo precisa ser refinado o tempo todo. O ideal é que cada retrospectiva, ao fim de cada sprint, aponte algo para mudar. Cenário perfeito não existe; o que existe é melhoria contínua e ininterrupta. Se nada muda depois de uma retrospectiva, se ninguém sugere ajustes ao fim do sprint, alguma coisa está errada.

Os outros princípios falam por si:

> "Receba mudanças de requerimento, mesmo tarde no desenvolvimento. Processos Ágeis esperam mudanças que tragam mais vantagem competitiva ao cliente."

Mudanças são bem-vindas, desde que tragam vantagem competitiva ao cliente. Mudança aleatória, baseada no humor dos envolvidos, fica de fora.

> "Construa projetos ao redor de pessoas motivadas. Lhes dê o ambiente e suporte que precisam, e confie neles para realizar o trabalho."

De novo, óbvio: ou você confia nas suas equipes, ou não confia. Se não confia, demita. Se confia, pare de microgerenciar e de cobrar relatório o tempo todo. Simples assim. Quem não confia e ainda acha que controla tudo por microgerenciamento é um péssimo gerente, e deveria se demitir primeiro.

Sobre ambiente, lembre da [Pirâmide das Necessidades de Maslow](http://en.wikipedia.org/wiki/Maslow's_hierarchy_of_needs). Se o ambiente é apertado, quente, sujo e desorganizado, não espere equipes motivadas, proativas e organizadas. Ninguém motiva ninguém, mas desmotivar é muito fácil. Não exija o topo da pirâmide enquanto nem a base está satisfeita.

> "Processos Ágeis promovem desenvolvimento sustentado. Os patrocinadores, desenvolvedores e usuários devem ser capazes de manter um ritmo constante indefinidamente."

Significa que todos os princípios acima estão sendo respeitados: existe um bom ambiente, os stakeholders estão envolvidos, a comunicação ao vivo e frequente acontece e as prioridades estão claras. Com isso dá para ter entregas frequentes, em ritmo constante e, melhor ainda, acelerando.

> "Atenção constante à excelência técnica e bom design aumenta a agilidade."

O primeiro princípio, isolado, às vezes passa a falsa impressão de que valor deve ser entregue a qualquer custo, sacrificando qualidade, manutenibilidade e bom design. Isso é falso, e é justamente por isso que insisto em considerar todos os princípios juntos.

Software de valor deve ser entregue o mais rápido possível, mas nunca ao custo de detonar a manutenibilidade futura, justamente quando o Retorno do Investimento começa a acontecer. Cada caso é um caso, e é por isso que stakeholders e equipes precisam conversar com frequência e decidir com base em custo-benefício.

> "Simplicidade – a arte de maximizar a quantidade de trabalho não feito – é essencial."

Junto com o princípio anterior, isso significa não ficar preso ao _"talvez precisem disso no futuro"_ e sair criando software "bloat", gordo, pesado e complexo para tentar deixá-lo _"à prova de futuro"_. Isso é impossível e só leva a um software que demora demais para ser entregue e que chega com valor duvidoso.

De novo, é uma questão de comunicação, de negociação e de custo-benefício, a partir do valor que o stakeholder disse que precisa.

> "As melhores arquiteturas, requerimentos e designs emergem de equipes auto-organizadas."

Esse tópico eu já expliquei dezenas de vezes, de várias formas, mas recomendo ler o meu artigo [Agilidade, Caos, Auto-Organização](/2009/07/08/off-topic-agilidade-caos-auto-organizacao).

Quem não entende Emergência e Auto-Organização não entende de Agilidade. Isso me leva de volta ao meu artigo [Você não Entende nada de Scrum](/2009/12/10/off-topic-voce-nao-entende-nada-de-scrum), que também recomendo ler agora.

Como dá para ver, o mundo da Agilidade se apoia em princípios importantes. Nenhum deles vale isolado: ou você considera todos em conjunto, ou não terá nenhum.

Mas cuidado: muita gente confunde Agilidade, Auto-Organização e Gestão Participativa com [Busca pelo Consenso](http://en.wikipedia.org/wiki/Consensus). Nada poderia estar mais longe disso. Estou demorando mais do que queria para terminar o livro [Systems Thinking](https://www.amazon.com/Systems-Thinking-Second-Complexity-Architecture/dp/0750679735), mas aqui vai um trecho de que gosto:

> "Finalmente, medo de rejeição e uma forte tendência em direção à conformidade entre membros de um sistema social e outros obstáculos a mudanças sociais. Um exemplo é o experimento em uma cidade com lei-seca (que não permite venda de álcool) cujos constituintes deveriam votar sobre a banição contra o álcool. Uma pesquisa pré-votação indicou que 75% dos eleitores eram a favor de abolir o banimento. Entretanto, cada um dos eleitores achavam que a maioria preferia a lei-seca. Quando os resultados foram tabulados, 60% dos eleitores votaram para manter a lei-seca. Não surpreendentemente, depois que a pesquisa foi publicada, a próxima eleição sobre o assunto produziu 65% de maioria em favor da abolição do banimento."

Democracia baseada em [Tirania da Maioria](http://en.wikipedia.org/wiki/Tyranny_of_the_majority) não serve. O assunto é bem mais complicado do que fazer as pessoas votarem nas opções, e não dá para tratar de forma leviana. Cientistas políticos, filósofos e vários pesquisadores estudam isso há tempos, e garanto que existe literatura vasta a respeito.

E esse assunto todo é mais complexo do que simplesmente ler os doze princípios. Um engenheiro, um médico ou um advogado estudam anos e continuam longe de serem mestres na área. Um gerente, por outro lado, estuda pouquíssimo, e por isso decide mais por folclore do que por qualquer outra coisa. É péssimo: nesses casos, quando acerta é por sorte, e quando erra é só o esperado.

<video controls>
<source src="https://s3.us-east-2.amazonaws.com/blip.tv/Akitaonrails-DanPinkMotivao160.mp4">
Your browser does not support the video tag. [Direct Link](https://s3.us-east-2.amazonaws.com/blip.tv/Akitaonrails-DanPinkMotivao160.mp4)
</source></video>
