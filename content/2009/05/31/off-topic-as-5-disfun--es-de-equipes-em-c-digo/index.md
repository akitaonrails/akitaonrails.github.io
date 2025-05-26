---
title: "[Off-Topic] As 5 disfunções de equipes em código"
date: '2009-05-31T16:10:00-03:00'
slug: off-topic-as-5-disfun--es-de-equipes-em-c-digo
tags:
- off-topic
- management
- carreira
draft: false
---

Eu costumo repetir a todas as equipes que eu gerencio, que 99% dos problemas de qualquer projeto são especialmente devidos à “comunicação”. Estresses que duram dias e poderiam ser resolvidos numa conversa de corredor de 30 seg. Eu uso “comunicação” mas é um pouco mais do que isso, é falta de respeito, falta de confiança, falta de [empatia](http://pt.wikipedia.org/wiki/Empatia) (não “simpatia”, “Empatia”). Vamos à **tradução** do artigo de [Mark Needham](http://www.markhneedham.com/blog/2009/05/28/the-5-dysfunctions-of-teams-in-code/)

Eu recentemente esbarrei em um [post interessante do meu colega Pat Kua](http://www.thekua.com/atwork/2009/05/evidence-in-favour-of-conways-law/) onde ele fala sobre alguns padrões que ele notou em código poderiam ser ligados à [lei de Conway](http://en.wikipedia.org/wiki/Conway%27s_Law), que sugere que as estruturas de sistemas desenvolvidos em organizações vão refletir a estrutura de comunicação dessa organização. (AkitaOnRails: leiam também o [The Mythical Man-Month](http://en.wikipedia.org/wiki/The_Mythical_Man-Month), onde o assunto de Conway também é explorado e entendam [Cross Functional Teams](http://www.infoq.com/articles/scaling-lean-agile-feature-teams) para entender uma das soluções.)

Também recentemente li um livro chamado [As Cinco Disfunções de Equipes](http://www.markhneedham.com/blog/2009/04/22/the-five-dysfunctions-of-a-team-book-review/) que descreve alguns comportamentos em equipes que não funcionam de maneira efetiva.

Jogando como o advogado do diabo eu fiquei intrigado se existia algum tipo de ligação entre essas disfunções e se elas se manifestam em nosso código como anti-padrões.

As 5 disfunções são:

1. Inexistência de Confiança – membros da equipe não querem ser vulneráveis dentro do grupo
2. Medo de Conflito – equipe não consegue engajar debates honestos de idéias
3. Falta de Comprometimento – membros da equipe raramente se comprometem em decisões
4. Evitar Responsabilidade – membros da equipe não chamam a atenção de seus pares a respeito de ações/comportamentos que prejudicam a equipe
5. Falta de Atenção a Resultados – membros da equipe que colocam suas necessidades individuais antes daquelas da equipe


## Inexistência de Confiança

Acho que ter **checagens por null por todo o código** é o indicador mais óbvio que as pessoas não confiam no código com que estão trabalhando.

Se a pessoa escrevendo o código tivesse fé em seus colegas que escreveram o código que ele precisa agora, acho que seria mais provável que ele confiaria que o código fará a coisa certa e não se sentiria na necessidade de [ser tão defensivo](http://www.thekua.com/atwork/2008/08/defensive-programming-depends-on-context/).

## Medo do Conflito

Medo do conflito em uma equipe parece se manifestar da maneira mais óbvia em código quando temos **muitas duplicações acontecendo** (síndrome do “copy & paste”) – existem diversas razões para duplicações mas acho que uma delas é quando as pessoas não estão engajadas em discussões quando eles não concordam com alguma coisa que um colega escreveu e por isso acabam escrevendo suas próprias versões de alguma coisa que já foi feita.

Isso provavelmente se manifesta de maneira ainda mais óbvia quando você acaba com múltiplos diferentes frameworks na mesma base de código e todos fazendo as mesmas coisas só porque as pessoas não querem engajar em conversações para escolher qual a equipe toda vai usar.

## Falta de Comprometimento

Esse é um que parece cruzar muito com os dois anteriores, embora uma maneira específica que este se manifesta em código quando vemos **erros básicos ou falta de cuidado demonstrado em código** (síndrome de “fazer nas coxas”) – um exemplo disso pode ser mudar o nome da classe e então não garantir que todos os lugares onde o nome antigo era usado tenham sido atualizados.

Isso deixa o código numa situação meia-boca e torna muito difícil para as outras pessoas trabalharem e eles precisam ficar limpando as coisa antes de conseguir efetivamente fazer algum trabalho.

## Evitar Responsabilidade

O anti-padrão de código que mais salta aos meus olhos é **quando nós permitimos que as pessoas escrevam código sem testes** e colocamos no repositório de código.

Pela minha experiência até agora isso nunca funcionou bem e eu acho que isso demonstra falta de respeito pelo resto da equipe já que não temos uma maneira simples de verificar se o código efetivamente funciona e as outras pessoas não podem usar isso em outro lugar com nenhum grau de segurança.

## Falta de Atenção a Resultados

Membros da equipe colocando suas necessidades individuais antes da equipe se manifesta no código quando acabamos com **código que foi escrito de tal maneira que apenas quem escreveu o código é capaz de entendê-lo.**

Acho que isso se manifesta em “código esperto” que não tem problema se o projeto for só seu, mas no contexto de uma equipe é muito detrimental à medida que você se torna o gargalo quando outras pessoas querem fazer mudanças nessa área do código e não podem porque não conseguem entender o que está acontecendo.

Outra coisa que cai nesta mesma situação é **quando existem convenções a serem seguidas mas decidimos sair por fora e fazer do nosso jeito**. Tudo bem, algumas vezes não tem problema se estamos trabalhando para tornar o código realmente melhor e o resto da equipe sabe e concorda com isso. Caso contrário, não é algo inteligente de se fazer.

## Em Resumo

Acho intrigante que em minha mente, pelo menos, alguns dos problemas que vemos em código parecem ter alguma correlação aos problemas que vemos nas equipes.

Uma coisa que eu me lembro ao ler [Os Segredos de Consultoria](http://www.amazon.com/Secrets-Consulting-Giving-Getting-Successfully/dp/0932633013/ref=sr_1_1?ie=UTF8&s=books&qid=1243452602&sr=1-1), de Gerald Weinberg é sua afirmação de que [não importa qual seja o problema, sempre é um problemas de pessoas](http://www.codinghorror.com/blog/archives/001033.html) – se de fato isso for verdade então, em teoria, problemas que vemos em código devem ser indicativos de problemas com pessoas, que eu acho que até certo ponto realmente é verdade.

Eu acho certamente que nem todo problema de código está ligado às disfunções de equipes – certamente alguns anti-padrões entram no seu código devido à inexperiência de membros da equipe, mas de qualquer forma isso também demonstraria a falta de sêniors na equipe trabalhando de forma mais próxima com seus colegas!

Talvez possamos identificar maneiras de como melhorar nossas equipes começando dando uma olhada no seu código.

## Ranting

**por AkitaOnRails:** de fato, estou muito convencido que problemas que acontecem no código são apenas sintomas de problemas estruturais das equipes e das organizações.

Começa pela falta de respeito: quando membros da equipe vêem seu chefe (não usem “líderes” para designar chefes hierárquicos. Eles nunca são “líderes” de verdade) usando de “carteirada” para conseguir as coisas com outras equipes, entre desenvolvedores também fica uma briga de braço do tipo: _“eu fiz minha parte, se o outro reclamar mando meu chefe falar com eles e pronto.”_ Na minha experiência, quase todos os problemas de equipes ineficientes e problemáticas é o gerente.

Gerentes que exercitam _“comando-e-controle”_ são exatamente os tipos que devem ser execrados de uma organização. Gerentes que não confiam na equipe, que gritam, que usam de força do cargo, que insistem em ser o gargalo da comunicação, que insistem que tudo tem que passar por eles, que não tem conhecimento real – o que é notório na sua falta de capacidade de argumentação. Gerentes que não sabem dar feedback honesto e diário, pelo bem ou pelo mal, e deixam para jogar tudo na cara dos outros meses depois – que, para mim, é a maior demonstração de **covardia** em alguém que deveria ser um _“líder”_.

O Gerente que gosta de _“micro-gerenciar”_ quando bem lhe convém, mas não explica quais são suas expectativas e cujo feedback é positivo ou negativo não de acordo com o trabalho feito, mas de acordo com seu humor em geral, o que torna as coisas muito cômodas para ele, óbvio. Os gerentes que, para parecerem que não são tão ruins, gastam seu tempo tentando fazer as outras equipes parecerem ruins: os famosos caçadores de pelo em ovo, aqueles que vão procurar os motivos triviais como horário, vestimenta, pequenas conversas, e coisas desse tipo como desculpas para falar mal, em vez de resultados reais como lucro, custo, etc.

Se você está realmente preocupado em porque suas equipes não estão performando como deveriam, olhe para a camada de gerentes. Especialmente, ou principalmente, aqueles que estão **há muitos anos** na mesma organização. Viciados, que já conhecem todos os _“jeitinhos”_ da organização. Eles são perigosos: sorriem para todo mundo, parecem confiantes, parecem eficientes, a maioria dos seus subordinados o elogiam (porque estão sob efeito de coerção, obviamente).

A equipe reflete o sistema e a estrutura que lhes é colocado sobre eles. Tire-lhes a autonomia, trate-os como crianças, deixe-os confusos e com medo e é exatamente esse o resultado que você vai ter: trabalho mal feito, de má qualidade, que dá defeitos o tempo todo, que custa caro. Alguns acham que isso é exagero, especialmente diretoria alheia e pouco participativa (qualquer coisa diferente de ‘todos os dias’ não é participação) ao que acontece no chão de fábrica, eles ficam surpresos ao ver que seus funcionários se tornaram não somente estagnados, incompetentes, obsoletos mas também distantes e despreocupados com o futuro da organização. A única coisa que os preocupa nesse momento, são seus empregos.

Enquanto isso, os tais “gerentes”, continuam em situações confortáveis: quando as coisas – por sorte, e apenas sorte – dão certo, recebem os louros. Quando as coisas dão errado a culpa é de membros da equipe que eles já iam dar um jeito mesmo, ou a culpa é de outras equipes, a culpa é da organização inteira que não o ajudou, a culpa é das decisões históricas que agora não tem mais jeito. Mas a culpa nunca é dele mesmo. Lembrem-se: anos de casa não pode significar imunidade. Anos de casa deve ser irrelevante se a intenção da organização é ser eficiente. E não se preocupe em mandar um gerente desses embora com o medo _“mas só ele sabe como fazer as coisas”_; as “coisas” não vão desandar, confie nas equipes, devolva-lhes a autonomia, elas saberão o que fazer.

Portanto, sim, a grande maioria das disfunções de uma equipe é resultado direto das disfunções de sua organização. Não adianta tentar aplicar técnicas localizadas como pregar pair programming, test driven development, refactoring, etc se a organização permanece a mesma. Quer mudar? Mude tudo. Ou nem se dê ao trabalho.

