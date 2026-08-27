---
title: 'Off-Topic: Método Científico vs Cargo Cult'
date: '2008-12-16T13:51:00-02:00'
slug: off-topic-m-todo-cient-fico-vs-cargo-cult
translationKey: off-topic-m-todo-cient-fico-vs-cargo-cult
description: "Cargo cult é repetir estruturas sem entender a razão. A saída é testar hipóteses com protótipos descartáveis. Na YellowPages, quatro meses de preparação impediram que quatro de implementação virassem vinte."
tags:
- ciencia
- engenharia-de-software
- off-topic
draft: false
---

Depois de vários anos, percebo que um grande número de programadores simplesmente não entende o Método Científico. Hoje discutimos bastante agilidade e testes, e todo mundo repete que TDD é importante. Dentro de "testes" existe um passo que deveria ser **óbvio** e quase ninguém pratica: a **experimentação**.

![](/files/20081216/42-17463681.jpg)

A desculpa da "falta de tempo" que serve para não escrever testes serve também para não testar hipóteses. A maioria sequer entende que deveria estar experimentando. Falo aqui de criar provas de conceito, pedaços do que você quer desenvolver que potencialmente serão jogados fora.

O "jogar fora" é a parte que arrepia programadores e gerentes. _"Mas isso é perda de tempo, trabalho jogado fora! Inaceitável!"_ Esse pensamento leva as pessoas a achar que toda linha de código escrita precisa obrigatoriamente entrar na aplicação.

É o velho erro de achar que precisamos acertar tudo de primeira, a cultura de que tentativa e erro é coisa errada. Meu ponto é o contrário: o erro é achar que sempre vamos acertar de primeira. Na maioria dos casos, vamos errar todas as primeiras vezes.

## Cargo Cult

Depois da Segunda Guerra, tribos nativas de ilhas do Pacífico Sul construíam réplicas de aviões e pistas de pouso militares na esperança de chamar de volta os "aviões-deuses" que tinham trazido tanta carga maravilhosa durante a guerra. A maioria dos programadores faz exatamente isso: como num ritual, inclui estruturas de programação sem entender direito por quê, apenas porque "deveria". São os que encaixam Design Patterns onde não precisa, enchem de comentários um código que já é autoexplicativo e, mais recentemente, praticamente se ajoelham diante de "Dependency Injection" sem entender a razão. (fonte: [Wikipedia](http://en.wikipedia.org/wiki/Cargo_cult_programming))

Ser modista tem má fama injusta; o que estraga é aplicar as coisas, novas ou velhas, sem entender a **razão**. A função principal da educação deveria ser ensinar a raciocinar, mas numa cultura de decoreba as pessoas aceitam tudo o que decoram sem saber por que decoraram: "alguém superior" disse que aquilo é verdade e, portanto, deve ser aplicado.

![](/files/20081216/1217833732_d7fcaebe17.jpg)

Lembram das discussões sobre por que certificações são nocivas? Este é um dos motivos. Para quem já raciocina, não faz diferença nenhuma. Para a grande massa que não raciocina, o resultado final é cargo cult puro.

A maioria lê tutoriais, alguns livros, assiste a uns workshops e já se acha apta a executar a tarefa. Na prática, executa o bom e velho "copy e paste" mental e cospe na aplicação todo o código que aprendeu. Eu já vi gente escrever assim:

```ruby
if ( a == b ) {  
 return true;  
} else {  
 return false;  
}  
```

Nada de errado nisso, mas é incrível como muita gente se surpreende quando digo que esta linha faz a mesma coisa:

```ruby
return (a == b);  
```

O primeiro código, isolado, é inofensivo. A sutileza é que o programador não sabe por que escreveu aquilo; só sabe que "tem que fazer". Quer um caso pior? Já vi, em várias linguagens, programadores fazerem o seguinte:

```php
$dbname="meu_banco";
$chandle = mysql_connect("localhost", 'root', 'root') or die("Falhou");  
$query1 = "select * from tabela";  
$result = mysql_db_query($dbname, $query1) or die ("Falhou");  
while ($row = mysql_fetch_row($result)) {  
 $field = mysql_fetch_field($result, 1);  
 if ( $field == 'foo' ) {  
 echo "encontrei!";  
 break;  
 }  
}
```

Esse é o típico [What the F*ck!?](http://thedailywtf.com/)

De novo, um código que "executa". Em algumas linguagens, compila sem problema nenhum. Quem não enxergou o problema **gravíssimo** desse código precisa voltar para o primeiro ano da faculdade.

![](/files/20081216/will_code_for_food.jpg)

## Cegueira

_"Repita uma mentira por tempo suficiente e logo ela se torna verdade."_

Existem muitos livros ruins, tutoriais ruins, professores ruins e toda uma corja de maus elementos disseminando más práticas. Mesmo assim, a maior culpa é de quem se deixa enganar. Quem aceita tudo o que ouve, sem o mínimo de ceticismo, é culpado pela própria ignorância.

É por isso que até hoje os jornais imprimem horóscopo em vez de uma coluna de ciência: existe muito mais leitor interessado em se enganar do que em saber coisas chatas, como a realidade.

Em tecnologia é igual:

- Windows deve ser melhor porque é o líder do mercado (ignorando que a Apple, mesmo com "míseros 8%" de mercado, está entre as empresas mais lucrativas da indústria, e que o Firefox já tem uma fatia enorme de usuários no Brasil)

- Java deve ser melhor porque é o líder do mercado, ou PHP deve ser melhor porque grandes sites usam (nem preciso discutir)

- Threads são a melhor maneira de escrever código concorrente (ignorando, por preguiça, as vantagens da programação funcional)

- O melhor jeito de gerenciar dados é com banco de dados relacional (ignorando, de novo por preguiça, toda a gama de bancos não-relacionais que estão ganhando terreno)

- Linguagens estáticas são melhores porque dá para compilar (ignorando, aqui por pura burrice, as enormes vantagens de produtividade das linguagens dinâmicas)

- Programação orientada a objetos é o ápice das técnicas de programação (ignorando que é apenas um entre dezenas de paradigmas, como a programação funcional)

- Rails não escala (sério? quem ainda repete isso prova que é amador)

![](/files/20081216/thestupiditburns.jpg)

Todo mundo carrega centenas de ideias pré-concebidas como essas. Coisas ouvidas de alguém ou lidas em algum lugar, normalmente de reputação duvidosa, que a pessoa passa a repetir sem nenhum argumento que sustente a crença. Ou melhor: ela acha que a fonte duvidosa de onde tirou a ideia já é base suficiente para continuar repetindo.

Em programação ou em qualquer outra área: se você tem **qualquer** crença que não consegue argumentar e sustentar, pesquise melhor. Se ela não se sustenta diante de contra-argumentos, **jogue-a fora**, porque não serve para nada. Todo mundo se acha "mente aberta"; eu discordo, a maioria é bem fechada. Duvida? Repense tudo em que você acredita e argumente contra você mesmo. Feito direito, você vai notar que a maioria das coisas em que acredita não tem fundamento nenhum.

## Método Científico

Uma pessoa cuidadosa pratica o básico do método científico todos os dias. Nosso dia a dia é uma sequência de decisões, algumas pequenas, outras enormes, e decisão tomada com base em ideia pré-concebida é onde o erro mora.

Isso não elimina a intuição. Intuição é uma conclusão rápida baseada em experiência. Se suas experiências diárias foram metodicamente racionais por muito tempo, sua intuição tende a ser sólida. Se foram baseadas em superstição, simpatia, pseudociência, cargo cult e ideias pré-concebidas, sinto dizer: sua intuição é uma droga.

Leia [esta definição da Wikipedia](http://en.wikipedia.org/wiki/Scientific_method). É extensa, completa e pede um bom tempo de reflexão. O que mais me interessa está resumido [aqui](http://web.archive.org/web/20081217012740/http://www.sciencebuddies.org:80/mentoring/project_scientific_method.shtml).

Como todo bom processo, esse também é **iterativo**: prevê retorno de etapas para refinar o conhecimento.

![](/files/20081216/dogma-jesus.jpg)

Os passos são simples e podem ser rápidos ou mais demorados e detalhados. O importante é o seguinte: diante de uma questão, execute esses passos pelo menos mentalmente. É o mínimo do mínimo para uma decisão educada.

- **Faça a pergunta.** Essa fase é importante: pergunta errada leva a resposta errada. Não é de hoje que as pessoas perdem tempo explorando respostas sem relevância porque a pergunta estava errada. Pense na pergunta como uma User Story num backlog ágil: veja se é prioridade, veja se é necessária. Não gaste tempo respondendo pergunta irrelevante.

- **Pesquise.** Antes de mais nada, pesquise o assunto. Não perca dias nisso; às vezes alguns minutos no Google bastam. Para mim, o valor dessa etapa é o "pare, pense, continue". A maioria das pessoas é apressada demais; essa é a hora de parar um segundo e ganhar mais conhecimento antes de seguir.

- **Construa uma hipótese.** Quando você faz uma pergunta, normalmente já tem uma ou mais respostas possíveis. Ao formular a pergunta, não se apegue a ideias pré-concebidas. Considere que o que a maioria das pessoas chama de "verdade" é, na realidade, um conjunto de [hipóteses](http://en.wikipedia.org/wiki/Hypothesis). Uma hipótese é apenas a sugestão de uma explicação.

[![](/files/20081216/overview_scientific_method2.gif)](http://web.archive.org/web/20081217012740/http://www.sciencebuddies.org:80/mentoring/project_scientific_method.shtml)

- **Teste com um experimento.** É a etapa mais importante. Experimentos precisam ser repetíveis e ter critérios muito bem definidos: se duas pessoas fizerem o mesmo experimento, para a hipótese continuar de pé os resultados têm que ser os mesmos. Note que eu disse "de pé", não "verdadeira". Verdade é palavra forte demais; eu raramente me considero perto de qualquer verdade. Na maioria das vezes, aceito apenas que minha hipótese ainda não foi falsificada. A parte crucial, em programação: crie provas de conceito, pedaços de código escritos só para testar a hipótese, que podem ser simplesmente jogados fora depois. Faça isso fora do código do projeto, num ambiente separado. Não misture as coisas.

- **Tire conclusões.** Com tudo o que você fez acima, vai provar ou derrubar sua hipótese. Assuma desde já que você pode muito bem provar que sua própria hipótese era falsa. Nesse caso, volte ao segundo passo, formule uma hipótese nova e tente de novo. Isso é ser mente aberta: provar a si mesmo errado e partir imediatamente para buscar outra resposta.

- **Comunique seus resultados.** A aplicação de que estou falando aqui é informal, o mínimo para você ter algum embasamento, provavelmente não todo, no que está fazendo. Se o assunto for mais complexo, com mais tempo investido e mais detalhes, talvez interesse a mais gente. Divulgue seus resultados, pelo menos entre seus colegas. Se você investiu tanto tempo, a resposta provavelmente é importante, e aí vale dar aos outros a chance de tentar derrubá-la. Pouco importa quantas pessoas chegam à mesma conclusão; quantidade não significa nada. Importa muito mais se alguém conseguir derrubar a sua. Nesse caso, jogue a hipótese fora e comece de novo.

## Pessoas

A maioria das pessoas pode ser descrita assim:

- **Têm ideias pré-concebidas.** Ouviram de outras pessoas que, acham elas, têm credibilidade. Só porque alguém tem uma credencial, é celebridade, fala bonito ou se veste bem, não quer dizer que saiba toda a verdade. Muito pelo contrário: essa pessoa pode estar cheia de ideias pré-concebidas. Ouça, sim, o que elas têm a dizer, mas guarde tudo numa caixinha mental chamada "a verificar" e siga em frente.

- **Não gostam de ser desmentidas.** Ninguém gosta de assumir que está errado: primeiro mata o ego, depois destrói a autoestima. Por isso a pessoa ignorante se agarra à sua mentira particular até as últimas consequências. São pessoas de fundação fraca. Construa sua fundação sobre meias-verdades e, quando uma cair, cai tudo. Esse é o maior risco.

- **Não gostam de perder tempo.** E "perda de tempo" aqui é totalmente relativo. A maioria faz economia porca: testar e experimentar, ou seja, "não fazer nada imediatamente", é tratado como perda de tempo. Eu chamo isso de "economizar o tempo futuro": um pouco mais de cuidado agora para não precisar correr amanhã. É uma questão de balanço. Não faz sentido se preparar por 15 dias num projeto de 20. Mas faça o mínimo: pare um segundo, pense e, se tiver dúvida, experimente antes de prosseguir.

![](/files/20081216/funny-dog-pictures-praying-dogma.jpg)

- **Não gostam de coisas novas.** Existe outro conceito errado de "custo" em jogo. Muita gente acha que, porque investiu tempo estudando um assunto, esse investimento não pode ser perdido e precisa insistir nele. É o que já escrevi uma vez em [A Falácia do Custo Perdido](http://www.akitaonrails.com/2007/08/19/a-falcia-do-custo-perdido). Se o prejuízo já existe, a maior burrice é insistir nele. Muito mais inteligente dar o custo por perdido, mudar de direção e seguir em frente.

- **Fazem só o que mandam fazer.** Se ninguém ordenar testes, ninguém testa. Se ninguém ordenar prova de conceito, ninguém cria. Se ninguém mandar se preocupar com segurança, o código sai cheio de buracos. Se ninguém mandar automatizar testes, ninguém automatiza. A quantidade de Lemmings nos projetos impressiona. Primeiro porque tudo o que deveria ser obrigação fica por fazer; segundo porque, se o chefe mandar atirar no próprio pé, eles atiram. De novo, falta de raciocínio.

- **Fazem o desnecessário.** Parece paradoxo, mas complementa o item anterior. Por causa de ideias fixas pré-concebidas, as pessoas perdem tempo fazendo coisas totalmente desnecessárias porque alguém que elas consideram "de credibilidade" disse que devia ser feito. É um comportamento que eu ainda não entendi, vejo o tempo todo, e que contradiz tudo o que eu disse acima: alguém resolve escolher uma tecnologia idiota por uma razão inexplicável, gasta um tempão fora das prioridades do projeto, não faz prova de conceito nenhuma e sai programando na fé de que vai dar certo. No final, o projeto está atrasado e cheio de código que vai para o lixo porque não serve para nada.

Acho que tudo isso é consequência da falta de prática das pessoas em raciocinar. É um comportamento irracional, complicado demais, cheio de erros básicos, que ninguém percebe como errado.

Lembro de um documentário do bom e velho Richard Dawkins em que ele conta a história de um cientista que passou anos estudando uma teoria, não lembro qual. Um jovem cientista provou que ele estava errado. O mais velho olhou para o rapaz e disse algo como "muito obrigado". Esse é o comportamento racional. Provar algo verdadeiro é muito difícil; provar que é **falso** é bem mais simples. Se alguém provar você errado, agradeça: a pessoa acabou de evitar que você perca tempo no futuro, e isso vale ouro.

E sempre que entrar num projeto novo, não assuma que você sabe o que precisa ser feito, nem que "precisa" saber. Assuma que não sabe. Crie hipóteses, discuta, experimente, ganhe segurança de verdade e só então faça o que precisa ser feito. Não há problema nenhum nisso. O problema é assumir que você sabe o que vai fazer e, depois de desperdiçar o tempo de todo mundo, finalmente ficar evidente que você esteve errado o tempo todo.

Não desperdice o tempo dos outros!

![](/files/20081216/2633591802_8498c58817_o.jpg)

Referências:

- [Scientific method](http://en.wikipedia.org/wiki/Scientific_method)
- [Steps of the Scientific Method](http://web.archive.org/web/20081217012740/http://www.sciencebuddies.org:80/mentoring/project_scientific_method.shtml)
- [Deductive Reasoning](http://en.wikipedia.org/wiki/Deductive_reasoning)
- [Cargo Cult Programming](http://en.wikipedia.org/wiki/Cargo_cult_programming)
- [Cargo Cult Science](http://en.wikipedia.org/wiki/Cargo_cult_science)
- [Fallacy](http://en.wikipedia.org/wiki/Fallacy)
- [Due Diligence](http://en.wikipedia.org/wiki/Due_diligence)
- [Prejudice](http://en.wikipedia.org/wiki/Prejudice)
- [Hypothesis](http://en.wikipedia.org/wiki/Hypothesis)

Eu repito várias vezes que não sei o que é verdade. Respondo "não sei" toda vez que me fazem uma pergunta esperando uma resposta absoluta. _"O Rails vai vingar?"_ Esqueçam esse tipo de pergunta: prever o futuro é difícil. Se alguém lhe dá uma previsão de futuro, ignore. Muito provavelmente a pessoa não tem ideia do que está falando.

Por trás desse tipo de pergunta está o comportamento que descrevi acima: a pessoa acha que precisa acertar sempre e detesta ser provada errada. Na pior das hipóteses, o caminho que você percorreu para se provar errado lhe deu mais conhecimento e experiência. Isso vale mais do que encontrar uma verdade.

Eu já falei sobre Razão em alguns outros posts:

- [Seja Arrogante](http://www.akitaonrails.com/2007/04/14/off-topic-seja-arrogante)
- [Inimigos da Razão](http://www.akitaonrails.com/2007/08/23/off-topic-inimigos-da-razo)
- [100% pure Object-Oriented: The Fallacy](http://www.akitaonrails.com/2007/09/04/100-pure-object-oriented-the-fallacy)

## Conclusões

Meu objetivo neste post é reforçar a importância da experimentação. Eu não sei qual é a verdade; qualquer um pode postar um comentário aqui com dezenas de contra-argumentos. Quem fizer isso vai estar perdendo o foco, e seus "argumentos" serão citações de ideias pré-concebidas. Ficar caçando detalhe no texto para apontar erro é irrelevante. O importante é o profissional entender que idade, anos de estrada, certificações e carteiradas não resolvem problema nenhum. No final somos todos amadores e, como tal, precisamos voltar ao zero e rever nossas hipóteses.

Um exemplo prático. Quando conversei com [John Straw](http://www.akitaonrails.com/2008/11/21/rails-podcast-brasil-especial-qcon-john-straw-yellowpages-com-e-matt-aimonetti-merb) (YellowPages.com) em São Francisco, ele contou uma coisa que nem toda equipe faz: um extenso due diligence. Eles levaram 22 meses para criar o projeto original do YellowPages.com em Java. Resolveram parar por 4 meses para criar protótipos, provas de conceito e testar hipóteses: qual framework usar, Rails, Django ou Seam? Qual arquitetura, SOA, EJBs? Quanto tempo a equipe levaria para se acostumar com a tecnologia nova? Só depois de ganhar segurança no que estavam fazendo começaram a implementar de verdade. E foram apenas mais 4 meses para terminar. Entenderam? Os primeiros 4 meses não foram perda de tempo: foram um seguro, o que impediu que os 4 meses seguintes virassem 20.

Como eu disse no ano passado: "Seja Arrogante, mas mereça ser arrogante!" Seja arrogante consigo mesmo a ponto de se questionar de verdade e ganhar. Você pode enganar os outros; enganar a si mesmo não tem vantagem nenhuma. Não existe inquisidor melhor para você do que você mesmo. Está errado? Excelente: um caminho errado a menos. Procure outro e comece de novo.

Repetindo: não foi com ideias pré-concebidas que chegamos à Lua.

![](/files/20081216/redneck_moon_landing_2.jpg)
