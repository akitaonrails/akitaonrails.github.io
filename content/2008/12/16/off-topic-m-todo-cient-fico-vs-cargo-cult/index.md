---
title: 'Off-Topic: Método Científico vs Cargo Cult'
date: '2008-12-16T13:51:00-02:00'
slug: off-topic-m-todo-cient-fico-vs-cargo-cult
tags:
- off-topic
- principles
- science
- career
draft: false
---

Depois de vários anos percebo que um grande número de programadores simplesmente não entende o Método Científico. Atualmente discutimos bastante sobre agilidade, sobre como fazer testes, TDD é importante. Em “testes” existe algo que deveria ser **óbvio** mas parece que não é. Existe um passo que considero muito importante que é a **experimentação**.

![](/files/20081216/42-17463681.jpg)

Da mesma forma como muitos usam “falta de tempo” como desculpa para não fazer testes, a mesma desculpa é usada para não testar hipóteses via experimentação (a maioria sequer entende que deveria estar experimentando hipóteses). O que estou falando aqui é sobre criar provas de conceito, “pedaços” do que você quer desenvolver que potencialmente será jogado fora. O “jogar fora” é a parte que deixa os programadores (e os gerentes) arrepiados. _“Mas isso é perda de tempo, trabalho jogado fora! Inaceitável!”_. Esse pensamento faz as pessoas pensarem que toda linha de código escrito necessariamente precisa estar na aplicação.

Novamente, é o errôneo pensamento que precisamos acertar tudo da primeira vez, a cultura de que tentativa-e-erro é errado. Pois bem, estou aqui dizendo que errado é pensar que sempre vamos acertar da primeira vez. Na maioria dos casos vamos errar todas as primeiras vezes.


## Cargo Cult

Depois da Segunda Guerra, tribos aborígenes religiosas do sul do Pacífico construíam réplicas de aviões e pistas de pouso militares na esperança de chamar novamente os “aviões-deuses” que lhes trouxeram tantas cargas maravilhosas durante a guerra . É exatamente o que a maioria dos programadores costumam fazer: como que num ritual incluem diversas estruturas de programação sem entender muito bem porque estão fazendo isso, apenas sabem que “deveriam”. São os programadores que tentam encaixar Design Patterns em lugares desnecessários, colocam comentários em código que por si só já é auto-explicativo. Recentemente são os tipos que praticamente se ajoelham perante “Dependency Injection” sem realmente entender porque. (fonte: [Wikipedia](http://en.wikipedia.org/wiki/Cargo_cult_programming))

Ser modista não é algo ruim como muitos pensam, o ruim é simplesmente aplicar as coisas (novas ou velhas) sem entender a **razão**. O que ensinam na escola hoje em dia? A principal função da educação deveria ser o raciocínio, mas numa cultura educacional baseada em decoreba, as pessoas simplesmente aceitam tudo que decoram e não sabem bem sequer porque decoraram, simplesmente que “alguém superior” disse que aquilo é verdade e, “portanto”, deve ser aplicado.

![](/files/20081216/1217833732_d7fcaebe17.jpg)

Lembram das discussões sobre porque certificações são nocivas? Este é um dos motivos. Para os que já são racionais, claro, não faz diferença nenhuma. Mas para uma grande massa de pessoas que não raciocinam, o resultado final é simplesmente cargo culting.

A maioria das pessoas lê tutoriais, alguns livros, assiste alguns workshops e já acham que estão aptos a executar a tarefa. Na maioria dos casos simplesmente executam o bom e velho “copy e paste” mental. Cospem na aplicação todos os códigos que aprenderam. Eu já vi quem escrevesse algo assim:

* * *

if ( a == b ) {  
 return true;  
} else {  
 return false;  
}  
-

Nada de errado nisso, mas é incrível como muitos ficam surpresos quando dizemos que a linha seguinte faz a mesma coisa:

* * *

return (a == b);  
-

Em si, esse pequeno código é inofensivo. Mas perceba a sutileza: o programador não sabe porque está fazendo isso. Apenas sabe que tem que fazer. Quer algo pior? Já vi (em diversas linguagens), programadores que fazem o seguinte:

* * *

$dbname=“meu\_banco”;   
$chandle = mysql\_connect(“localhost”, ‘root’, ‘root’) or die(“Falhou”);  
$query1 = “select \* from tabela”;  
$result = mysql\_db\_query($dbname, $query1) or die (“Falhou”);  
while ($row = mysql\_fetch\_row($result)) {  
 $field = mysql\_fetch\_field($result, 1);  
 if ( $field == ‘foo’ ) {  
 echo “encontrei!”;  
 break;  
 }  
}  
-

Esse é o típico [What the F\*ck!?](http://thedailywtf.com/)

Novamente, um código que “executa”. Em algumas linguagens, esse seria um tipo de código que “compila”, sem problema nenhum. Porém, quem não entendeu o problema **gravíssimo** desse código, precisa retornar ao primeiro ano da faculdade.

![](/files/20081216/will_code_for_food.jpg)

## Cegueira

_“Repita uma mentira por tempo suficiente e logo ela se torna verdade.”_

Existem muitos livros ruins, tutoriais ruins, professores ruins e toda corja de maus elementos que disseminam más práticas. Porém, a maior culpa é de quem se deixa enganar. Pessoas que simplesmente aceitam tudo que lhe dizem, sem o mínimo de ceticismo, são culpadas pela própria ignorância.

É exatamente porque até hoje temos horóscopos impressos nos jornais em vez de uma coluna científica: porque existem muito mais leitores interessados em se enganar do que em saber coisas chatíssimas, como a realidade.

Em tecnologia é a mesma coisa:

- Windows deve ser melhor porque é o líder do mercado (ignorando que a Apple, mesmo com “míseros 8%” fatura tanto quanto a Microsoft, ou mesmo coisas como que 1/3 do Brasil já usa Firefox)

- Java deve ser melhor porque é o líder do mercado ou, PHP deve ser melhor porque grandes sites usam (não preciso nem discutir)

- Threads é a melhor maneira de se criar código concorrente (ignorando – por preguiça – as vantagens da programação funcional)

- O melhor jeito de gerenciar dados é com bancos de dados relacionais (ignorando – novamente por preguiça – toda a gama de bancos não-relacionais que estão ganhando terreno)

- Linguagens estáticas são melhores porque dá para compilar (ignorando – aqui, por pura burrice – as enormes vantagens produtivas de linguagens dinâmicas)

- Programação orientada a objetos é o ápice das técnicas de programação (ignorando que esta é apenas uma das dezenas de paradigmas que existem, como programação funcional)

- Rails não escala (sério? quem ainda repete isso prova que é um amador)

![](/files/20081216/thestupiditburns.jpg)

Todos tem centenas de idéias pré-concebidas como essas. Coisas que ouviram de alguém ou leram em algum lugar (normalmente de reputação duvidosa) e agora simplesmente passam a repetir estupidamente sem absolutamente nenhum argumento que sustente suas crenças. Ou melhor, essas pessoas acham que a fonte de onde tiraram isso (a tal fonte duvidosa) é base suficiente para continuar repetindo.

Em programação ou em qualquer outra área social: se você tem **qualquer** crença que não consegue argumentar (e sustentar o argumento), pesquise melhor. Se sua crença não se sustenta perante argumentos em contrário, **jogue-as fora** , pois não lhe servem de nada. Todo mundo se acha “mente aberta”, eu discordo, a maioria é bastante fechada. Se duvida disso, repense em tudo que acredita e argumente-se contra você mesmo. Se fizer direito vai notar que a maioria das coisas em que acredita simplesmente não tem fundamento.

## Método Científico

Uma pessoa cuidadosa precisa praticar o básico do método científico diariamente. Nosso dia-a-dia é uma sequência de tomadas de decisões, algumas pequenas, outras enormes. Decisões nunca devem ser tomadas por base em idéias pré-concebidas. É onde acontecem os erros.

Não quer dizer que a intuição não deva ser usada. Porém, intuição é uma conclusão rápida baseada em experiência. Se suas experiências diárias foram metodicamente racionais por muito tempo, sua intuição tende a ser mais sólida. Mas se suas experiências diárias são baseadas em superstições, simpatias, pseudo-ciência, cargo culting e idéias pré-concebidas, sinto lhe dizer: sua intuição é uma droga.

Leia [esta definição da Wikipedia](http://en.wikipedia.org/wiki/Scientific_method). É extensa, completa e requer um bom tempo de reflexão. Porém, o que mais me interessa está resumido [aqui](http://www.sciencebuddies.org/mentoring/project_scientific_method.shtml).

Como todo bom processo, esse também é **iterativo** , ou seja, ela prevê um retorno de etapas para refinar o conhecimento.

![](/files/20081216/dogma-jesus.jpg)

Os passos são bem simples e podem ser executadas rapidamente ou podem ser mais demoradas e detalhadas. O importante é: de face a uma questão, execute esses passos pelo menos mentalmente. É o mínimo do mínimo para se tomar uma decisão educada.

- Faça a pergunta – essa fase é importante! Faça a pergunta errada e vai encontrar a resposta errada. Não é de hoje que as pessoas perdem tempo explorando respostas que não tem relevância porque a pergunta não estava correta. Pense na pergunta como uma User Story num Backlog ágil: veja se é prioritário, veja se é necessário. Não perca tempo tentando responder perguntas irrelevantes.

- Faça Pesquisa – antes de mais nada, pesquise o assunto. Não perca dias nisso, às vezes poucos minutos no Google podem ser suficientes. O importante nessa etapa, para mim, é a parte do “pare, pense, continue”. A maioria das pessoas é apressada demais, essa é a etapa para parar por um segundo e ganhar mais conhecimento antes de continuar.

- Construa uma Hipótese – normalmente quando você faz uma pergunta, já deve ter uma ou mais possíveis respostas. O importante na primeira etapa, quando você formulou a pergunta, é não se ater a idéia pré-concebidas. Considere que o que a maioria das pessoas acha que é “verdade” na realidade não passam de [hipóteses](http://en.wikipedia.org/wiki/Hypothesis). Uma hipótese é nada mais, nada menos do que a mera sugestão de uma explicação.

[![](/files/20081216/overview_scientific_method2.gif)](http://www.sciencebuddies.org/mentoring/project_scientific_method.shtml)

- Teste com um Experimento – eis a etapa mais importante. Experimentos precisam ser repetitíveis, ter critérios muito bem definidos. Se duas pessoas realizarem o mesmo experimentos, para que a hipótese seja não-falsa, os resultados tem que ser os mesmos. Note que eu disse não-falso, e não verdadeiro. Verdade é algo muito forte. Eu normalmente não considero que estou perto de qualquer verdade. Às vezes apenas aceito que minha hipótese ainda não foi falsificável. Essa é a parte crucial: em programação, crie provas de conceito, pedaços de código que você escreve apenas para testar sua hipótese mas que pode ser simplesmente jogada fora depois. Nem faça isso no mesmo código do seu projeto: crie um ambiente separado para isso. Não misture as coisas.

- Tire conclusões – baseado em tudo que fez acima, você vai provar ou desprovar sua hipótese. Assuma que você pode certamente provar que sua própria hipótese era falsa. Nesse caso retorne ao segundo passo, reformule uma nova hipótese e tente novamente! Isso é ser mente aberta: quando você mesmo se prova errado e imediatamente parte para buscar uma nova resposta.

- Comunique seus resultados – o tipo de aplicação que estou falando aqui é algo bem informal, apenas o mínimo para que você pelo menos tenha “algum” (provavelmente não todo) embasamento no que está fazendo. Mas se for algo mais complexo, onde você realmente investiu mais tempo e foi mais detalhista, talvez seja um assunto que interesse a mais gente. Divulgue seus resultados entre seus colegas, pelo menos. Se você investiu tanto tempo, provavelmente a resposta deve ser importante, nesse caso também é importante que outras pessoas tenham a chance de tentar desprovar seu resultado. Não é tão importante quem chegue às mesmas conclusões (quantidade de pessoas não significa nada). É muito mais importante se alguém conseguir desprovar sua conclusão. Nesse caso, jogue fora a hipótese. Comece novamente.

## Pessoas

A maioria das pessoas pode ser definida da seguinte forma:

- Tem idéias pré-concebidas – ouviram de outras pessoas (que, acham elas, tem credibilidade). Só porque uma pessoa tem alguma credencial, é alguma celebridade, fala bonito, se veste bem ou seja lá por qual motivo você acha que ela “deve” ser ouvida, não quer dizer que ela saiba toda a verdade. Muito pelo contrário, essa outra pessoa pode ter várias idéias pré-concebidas. Ouça sim o que elas tem a dizer, mas guarde tudo numa caixinha na sua cabeça chamada “a verificar” e siga em frente.

- Não gostam de ser desprovadas – ninguém gosta de assumir que está errado. Em primeiro lugar isso mata o ego, em segundo, destrói a auto-estima. Portanto uma pessoa ignorante tentará se segurar à sua mentira particular até as últimas consequências. São pessoas de fundação fraca. Construa sua fundação sobre diversas meias-verdades, quando uma cair, tudo cai. Esse é o maior risco.

- Não gostam de perder tempo – e aqui “perda de tempo” é absolutamente relativo. A maioria das pessoas fazem “economia-porca”. Testar e experimentar, ou melhor, “não fazer nada imediatamente” é considerado perder tempo. Mas eu chamaria isso de “salvar o tempo futuro”. Somos um pouco mais cuidadosos agora para que amanhã eu não precise correr. É um balanço: não faz sentido se preparar por 15 dias num projeto que só tem 20 dias. Mas faça o mínimo. Pare por um segundo, pense, se tiver dúvidas, experimente, depois prossiga.

![](/files/20081216/funny-dog-pictures-praying-dogma.jpg)

- Não gostam de coisas novas – existe outro conceito muito errado de “custo”. Muitos acham que porque investiram tempo estudando um determinado assunto, esse tempo/dinheiro “investido” não pode ser perdido e portanto precisa insistir no mesmo assunto. É o que já escrevi uma vez sobre [A Falácia do Custo Perdido](http://www.akitaonrails.com/2007/8/19/a-falcia-do-custo-perdido). Se você já tem um prejuízo, a maior burrice é insistir no mesmo prejuízo. É muito mais inteligente considerar esse custo como perdido e simplesmente mudar de direção e seguir em frente.

- Fazem apenas o que lhe dizem para fazer – se ninguém ordenar para testar, não se testa. Se ninguém ordenar para criar uma prova de conceito, não se cria. Se ninguém mandar se preocupar com segurança, o código sai cheio de buracos. Se ninguém mandar automatizar testes, ninguém automatiza. É impressionante a quantidade de Lemmings que temos nos projetos. Primeiro porque tudo que deveria ser obrigação não é feito, segundo porque se o chefe mandar atirar no próprio pé, eles atiram! Novamente, falta de raciocínio.

- Fazem o desnecessário – mesmo parecendo paradoxal, complementando o comportamento acima, de não fazer o que é necessário, por causa de idéias fixas pré-concebidas, as pessoas de fato acabam perdendo tempo fazendo coisas totalmente desnecessárias, porque alguém a quem eles consideram “de credibilidade” disse que deveria ser feito. É um comportamento que eu não entendi ainda, mas que eu vejo o tempo todo e nega tudo que eu disse acima: é o caso quando alguém resolve escolher uma tecnologia totalmente idiota por alguma razão inexplicável. Perde um bom tempo não fazendo o que é realmente prioritário no projeto. Não se faz nenhuma prova de conceito para testar a hipótese e já se sai programando “achando” que vai dar certo. No final, o projeto está atrasado e cheio de código que simplesmente vai ter que se jogado fora porque realmente não serve para nada.

Acho que tudo isso é mesmo consequência da falta de prática das pessoas em raciocinar. É um comportamento irracional, complicado demais, cheio de erros básicos mas que por alguma razão ninguém acha que está errado.

Lembro de um documentário do bom e velho Richard Dawkins onde ele fala sobre um cientista que passou anos estudando uma teoria (não lembro qual). Daí um outro jovem cientista o provou errado. Ele olhou para o jovem e disse algo como “muito obrigado”. Esse é o comportamento racional. É muito difícil provar alguma coisa como verdadeira, é mais simples provar que é **falsa**. Se alguém o provar falso, agradeça, isso está efetivamente evitando que você perca tempo futuro, o que é importantíssimo!

E sempre que entrar num novo projeto, não assuma que você sabe o que precisa fazer, ou mesmo que “precisa” saber o que fazer. Assuma que você não sabe! Crie hipóteses, discuta, experimente, ganhe segurança real e só então faça o que precisa ser feito. Não há nenhum problema nisso. O problema é assumir que você sabe o que vai fazer e depois de desperdiçar o tempo de todo mundo, finalmente ficar evidente que estava errado o tempo todo!

Não desperdice o tempo dos outros!

![](/files/20081216/2633591802_8498c58817_o.jpg)

Referências:

- [Scientific method](http://en.wikipedia.org/wiki/Scientific_method)
- [Steps of the Scientific Method](http://www.sciencebuddies.org/mentoring/project_scientific_method.shtml)
- [Deductive Reasoning](http://en.wikipedia.org/wiki/Deductive_reasoning)
- [Cargo Cult Programming](http://en.wikipedia.org/wiki/Cargo_cult_programming)
- [Cargo Cult Science](http://en.wikipedia.org/wiki/Cargo_cult_science)
- [Fallacy](http://en.wikipedia.org/wiki/Fallacy)
- [Due Diligence](http://en.wikipedia.org/wiki/Due_diligence)
- [Prejudice](http://en.wikipedia.org/wiki/Prejudice)
- [Hypothesis](http://en.wikipedia.org/wiki/Hypothesis)

Eu repito várias vezes que eu não sei o que é verdade. Respondo “não sei” toda vez que me fazem algum tipo de pergunta esperando uma resposta absoluta. _“O Rails vai vingar?”_ Esqueçam esse tipo de pergunta: prever o futuro é difícil. Se alguém lhe dá uma previsão de futuro, ignore! É muito provável que ela não tem nenhuma idéia do que está falando.

Parte desse tipo de pergunta é o comportamento que falei acima de que as pessoas acham que precisam acertar sempre e não gostam de ser provadas erradas. Na pior das hipóteses, o caminho que você tomou para se provar errado lhe deu mais conhecimento e experiência. Isso é mais importante do que encontrar uma verdade.

Eu já falei sobre Razão em alguns outros posts como:

- [Seja Arrogante](http://akitaonrails.com/2007/4/14/off-topic-seja-arrogante)
- [Inimigos da Razão](http://akitaonrails.com/2007/8/23/off-topic-inimigos-da-razo).
- [100% pure Object-Oriented: The Fallacy](http://www.akitaonrails.com/2007/9/4/100-pure-object-oriented-the-fallacy)

## Conclusões

Meu objetivo neste post é tentar aprimorar a importância da experimentação. Eu não sei a verdade, qualquer um pode postar um comentário aqui com dezenas de argumentos em contrário. Essa pessoa estará perdendo o foco aqui (e certamente seus “argumentos” serão apenas citações de idéias pré-concebidas). É irrelevante tentar pegar detalhes no texto e demonstrar erros. O importante aqui é que o profissional precisa entender que idade, quantidade de anos numa área, certificações/carteiradas são completamente irrelevantes na hora de se resolver problemas. No final somos todos amadores e, como tal, precisamos voltar ao zero e rever nossas hipóteses.

Um exemplo prático: quando conversei com [John Straw](http://akitaonrails.com/2008/11/21/rails-podcast-brasil-qcon-special-john-straw-yellowpages-com-and-matt-aimonetti-merb) (YellowPages.com) em São Francisco, uma coisa que eles fizeram que nem toda equipe faz foi um extenso due diligence. Eles levaram 22 meses para criar o projeto original do YellowPages.com em Java. Resolveram parar por 4 meses, criar protótipos, provas de conceito, testar hipóteses (Qual framework usar, Rails, Django ou Seam? Qual arquitetura usar? SOA, EJBs, etc? Quanto tempo leva para a equipe se acostumar à nova tecnologia?) e só depois que ganharam segurança no que estavam fazendo, começaram a implementar de verdade. Daí foram apenas mais 4 meses para terminar. Entenderam? Os primeiros 4 meses não foram perda de tempo: foi um “seguro”, uma maneira dos 4 meses seguintes não se tornarem 20.

Como eu disse ano passado: “Seja Arrogante, mas mereça ser arrogante!”. Seja arrogante para si mesmo a ponto de questionar você mesmo e realmente ganhar! Você pode enganar os outros, mas enganar a si mesmo não tem muita vantagem. Não existe melhor inquisitor para você do que você mesmo. Se estiver errado, excelente! Um caminho errado a menos: procure outro e comece novamente.

Repetindo: não foi com idéias pré-concebidas que chegamos à Lua.

![](/files/20081216/redneck_moon_landing_2.jpg)

