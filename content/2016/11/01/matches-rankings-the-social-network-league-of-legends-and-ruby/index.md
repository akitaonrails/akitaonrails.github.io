---
title: "Partidas, Rankings, A Rede Social, League of Legends e Ruby?"
date: '2016-11-01T10:20:00-02:00'
slug: partidas-rankings-rede-social-league-of-legends-ruby
translationKey: lol-rankings-social-network-ruby
aliases:
- /2016/11/01/matches-rankings-the-social-network-league-of-legends-and-ruby/
tags:
- ranking
- elo
- algoritmo
- traduzido
draft: false
---

Tem um trecho de uma série de palestras que venho apresentando no Brasil há uns 3 anos sobre o qual nunca escrevi no blog. Ontem acabei de [postar sobre a forma correta de ranquear conteúdo por "popularidade"](http://www.akitaonrails.com/2016/10/31/implementacao-ruby-on-rails-sistema-ranking-popularidade-correto) então achei que valia revisitar o tema.

Pra começar, acredito que a essa altura quase todo mundo já assistiu ao filme "A Rede Social". É curioso que ouvi várias pessoas dizerem como esse filme as influenciou a começar suas próprias startups. Aí eu fiquei pensando, "o que esse filme realmente ensina?"

![The Social Network Casting](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/567/pasted-image-765.jpg)

Bom, do filme aprendemos que David Fincher é um diretor fantástico, que Aaron Sorkin escreve diálogos afiadíssimos e envolventes, que Justin Timberlake faz um Sean Parker melhor que o real, que Andrew Garfield faz um Eduardo Saverin razoável, e que Jesse Eisenberg vai ser para sempre o Mark Zuckerberg.

E é só isso, não dá pra aprender mais nada do filme.

Ou dá?

### Facemesh

Uma das minhas cenas favoritas do filme é quando Zuckerberg/Eisenberg fica puto com o término com a Erica Albright e começa a raspar fotos de mulheres dos sites de Harvard, organizando elas num site trollesco chamado "Facemesh", onde coloca as fotos pra competir entre si. As pessoas votam em qual foto preferem e o site as ordena num ranking de popularidade.

Quando Eduardo Saverin/Andrew Garfield aparece, Zuckerberg pergunta:

{{< youtube id="BzZRr4KV59I" >}}

> "Wardo, preciso de você (...) preciso do algoritmo usado para ranquear jogadores de xadrez"

E ele vai lá e escreve o seguinte na janela do dormitório:

![Through the Looking Glass](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/569/pasted-image-759.jpg)

Aqui a maioria das pessoas pensaria:

> "pff, mais uma fórmula sem sentido só pra mostrar que eles são gênios mirins, mas com certeza essa fórmula nem existe"

Só que ela existe. E essa é a única cena do filme que ficou martelando na minha cabeça porque eu já tinha visto isso antes. Pra ajudar, vamos inverter a imagem espelhada:

![The Algorithm](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/568/pasted-image-761.jpg)

E esse é o "algoritmo".

Como falei no artigo anterior, a maioria dos desenvolvedores criaria um site tipo Facemesh adicionando campos inteiros na tabela de competidores com a contagem de upvotes, downvotes e fariam alguma bobagem do tipo:

```ruby
score = upvotes - downvotes
```

Ou algo ainda mais bobo:

```ruby
score = upvotes / (upvotes + downvotes)
```

E não funciona desse jeito, você vai obter rankings completamente errados.

### A Demonstração

Pra mostrar o quão errado, criei um projeto simples de demonstração chamado [elo_demo](https://github.com/akitaonrails/elo_demo) que você pode clonar e rodar.

Ele cria 2.000 partidas aleatórias entre 10 jogadores. Esse vai ser o resultado ordenado se usarmos o método errado de subtrair derrotas das vitórias e ordenar por esse resultado:

```
   Name        Games  Wins  Losses Points (wins - losses)
 1 Kong          217   117    100     17
 2 Samus         211   110    101      9
 3 Wario         197   102     95      7
 4 Luigi         186    95     91      4
 5 Zelda         160    81     79      2
 6 Pikachu       209   105    104      1
 7 Yoshi         223   112    111      1
 8 Mario         203   101    102     -1
 9 Fox           208    95    113    -18
10 Bowser        186    82    104    -22
```

Agora, vamos fazer com que a Samus (2º lugar) vença 10 vezes seguidas o Wario (3º lugar). Esse é o novo ranking:

```
   Name        Games  Wins  Losses Points
 1 Samus         221   120    101     19
 2 Kong          217   117    100     17
 3 Luigi         186    95     91      4
 4 Zelda         160    81     79      2
 5 Pikachu       209   105    104      1
 6 Yoshi         223   112    111      1
 7 Mario         203   101    102     -1
 8 Wario         207   102    105     -3
 9 Fox           208    95    113    -18
10 Bowser        186    82    104    -22
```

Parece justo, Samus pula pro 1º lugar e Wario desce pro 8º.

Agora, e se fizermos o fraquinho Bowser (10º lugar) vencer 10 vezes contra o atual 2º lugar, Kong?

```
   Name        Games  Wins  Losses Points
 1 Samus         221   120    101     19
 2 Kong          227   117    110      7
 3 Luigi         186    95     91      4
 4 Zelda         160    81     79      2
 5 Pikachu       209   105    104      1
 6 Yoshi         223   112    111      1
 7 Mario         203   101    102     -1
 8 Wario         207   102    105     -3
 9 Bowser        196    92    104    -12
10 Fox           208    95    113    -18
```

É aqui que dá pra ver o quão **errado** esse método é. Mesmo perdendo 10 vezes contra o jogador mais fraco, Kong continua reinando absoluto no 2º lugar. E o pobre Bowser, apesar de todo seu esforço e dedicação, sobe apenas 1 mísera posição, do 10º pro 9º.

Isso é muito frustrante e parece injusto porque é injusto mesmo. Esse tipo de cálculo é **errado**.

### Do Xadrez ao League of Legends

Se você já jogou League of Legends, provavelmente está familiarizado com algo chamado "ELO Boost".

![Elo Boost](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/570/Screen_Shot_2016-11-01_at_10.19.42.png)

É uma forma de subir de nível sua conta pagando dinheiro. Recomendo fortemente evitar isso se você pretende competir profissionalmente porque é contra as regras da Riot.

De qualquer forma, você já se perguntou por que se chama "ELO"?

É uma homenagem ao professor austro-húngaro **Arpad Emmerich Elo**. Ele é mais conhecido pelo seu sistema de rating de jogadores de xadrez. Citando a Wikipedia:

> O sistema original de rating de xadrez foi desenvolvido em 1950 por Kenneth Harkness (...). Em 1960, usando os dados desenvolvidos pelo Sistema de Rating de Harkness, Elo desenvolveu sua própria fórmula que tinha uma **base estatística sólida** e constituía uma melhoria sobre o Sistema Harkness. O novo sistema de rating foi aprovado em uma reunião da Federação de Xadrez dos Estados Unidos em St. Louis em 1960.

> Em 1970, a FIDE, a Federação Mundial de Xadrez, concordou em adotar o Sistema de Rating Elo. Daquele momento até meados dos anos 80, o próprio Elo fazia os cálculos de rating. Naquela época, a tarefa computacional era relativamente fácil porque menos de 2000 jogadores eram ranqueados pela FIDE.

O sistema dele foi refinado e evoluiu pra tornar os leaderboards de torneios realmente justos e competitivos. Uma dessas evoluções é o [TrueSkill Ranking System](https://www.microsoft.com/en-us/research/project/trueskill-ranking-system/) da Microsoft, usado em todos os jogos do Xbox Live.

Aquele "algoritmo" que Eduardo Saverin escreve na janela do dormitório de Harvard? É o **Sistema de Rating ELO**!!

Não sei se Zuckerberg de fato implementou as equações do sistema ELO. Se implementou, foi a escolha **correta**. Mas a história toda do Eduardo escrevendo as equações na janela provavelmente não aconteceu desse jeito porque seria muito mais fácil dar um Google :-)

### Demonstração do Sistema de Rating ELO

Meu projetinho de demonstração também calcula esse exato score ELO. Os cálculos são feitos pela rubygem [elo](https://github.com/iain/elo).

A ideia é calcular a probabilidade que um jogador tem de vencer o outro. Então, se um jogador forte joga contra um fraco, espera-se que ele vença, e se esse for o resultado, ele vai pontuar pouco e o perdedor também não vai cair muito. Mas se acontecer o inesperado e o forte perder, espera-se que ele caia bastante e que o jogador "mais fraco" suba bastante.

Isso torna os torneios mais competitivos, motiva os novos jogadores a enfrentar os mais fortes, e força os mais fortes a jogar pesado pra manter suas posições.

Pela documentação da gem elo, é assim que se usa:

```ruby
kong  = Elo::Player.new
bowser = Elo::Player.new(:rating => 1500)

game1 = kong.wins_from(bowser)
game2 = kong.loses_from(bowser)
game3 = kong.plays_draw(bowser)

game4 = kong.versus(bowser)
game4.winner = bowser

game5 = kong.versus(bowser)
game5.loser = bowser

game6 = kong.versus(bowser)
game6.draw

game7 = kong.versus(bowser)
game7.result = 1 # resultado é na perspectiva do kong, então kong vence

game8 = kong.versus(bowser, :result => 0) # bowser vence
```

E é assim que se acessa os resultados:

```ruby
kong.rating       # => 1080
kong.pro?         # => false
kong.starter?     # => true
kong.games_played # => 8
kong.games        # => [ game1, game2, ... game8 ]
```

A gem tem mais ajustes além do algoritmo original, como o K-factor pra recompensar novos jogadores. Esses tipos de ajustes são o que torna as partidas mais competitivas hoje e como você evolui pra níveis de TrueSkill, mas isso foge do escopo deste artigo.

Vamos ver o ranking errado de novo:

```
   Name        Games  Wins  Losses Points (wins - losses)
 1 Kong          217   117    100     17
 2 Samus         211   110    101      9
 3 Wario         197   102     95      7
 4 Luigi         186    95     91      4
 5 Zelda         160    81     79      2
 6 Pikachu       209   105    104      1
 7 Yoshi         223   112    111      1
 8 Mario         203   101    102     -1
 9 Fox           208    95    113    -18
10 Bowser        186    82    104    -22
```

Agora vamos ver como fica o ranking **correto** calculando o score Elo usando exatamente as mesmas 2.000 partidas:

```
   Name        Games  Wins  Losses Points  Elo Rating
 1 Pikachu       209   105    104      1         851
 2 Zelda         160    81     79      2         847
 3 Samus         211   110    101      9         842
 4 Luigi         186    95     91      4         841
 5 Wario         197   102     95      7         824
 6 Mario         203   101    102     -1         820
 7 Yoshi         223   112    111      1         803
 8 Kong          217   117    100     17         802
 9 Bowser        186    82    104    -22         785
10 Fox           208    95    113    -18         754
```

Viu como é diferente? No ranking errado, Kong é considerado o mais forte, mas no ranking Elo ele está apenas em 8º lugar. E a razão é que mesmo sendo quem venceu mais partidas (217), também perdeu pra caramba (117). Alguém com menos vitórias, como a Zelda em 2º lugar (160 vitórias), perdeu muito menos (81), e é por isso que ela está mais alta no ranking.

Agora, se fizermos ela vencer 10 partidas seguidas contra a Samus (3º lugar), esse é o novo ranking:

```
   Name        Games  Wins  Loses  Points  Elo Rating
 1 Zelda         170    91     79     12         904
 2 Pikachu       209   105    104      1         851
 3 Luigi         186    95     91      4         841
 4 Wario         197   102     95      7         824
 5 Mario         203   101    102     -1         820
 6 Yoshi         223   112    111      1         803
 7 Kong          217   117    100     17         802
 8 Bowser        186    82    104    -22         785
 9 Samus         221   110    111     -1         775
10 Fox           208    95    113    -18         754
```

De novo, Zelda pula do 2º pro 1º lugar e Samus cai do 3º pro 9º. Até aqui, tudo certo. Mas e o cenário onde fazemos o forte Pikachu (2º lugar) jogar contra o muito mais fraco Fox McCloud (10º lugar)?

```
   Name        Games  Wins  Loses  Points  Elo Rating
 1 Zelda         170    91     79     12         904
 2 Luigi         186    95     91      4         841
 3 Fox           218   105    113     -8         829
 4 Wario         197   102     95      7         824
 5 Mario         203   101    102     -1         820
 6 Yoshi         223   112    111      1         803
 7 Kong          217   117    100     17         802
 8 Bowser        186    82    104    -22         785
 9 Samus         221   110    111     -1         775
10 Pikachu       219   105    114     -9         766
```

Agora sim, isso é justiça: Pikachu deveria ter vencido, mas perder 10 vezes seguidas contra alguém considerado muito mais fraco faz ele cair do 2º lugar lá pro último. E o novato Fox, tendo vencido 10 vezes contra um oponente muito mais forte, merece pular lá pro 3º lugar.

Esse é o tipo de dinâmica que torna partidas e jogos competitivos, e é exatamente por isso que todo leaderboard online e torneio profissional usa esse tipo de algoritmo.

E tudo começou no xadrez, usando matemática conhecida desde o final dos anos 40!!

> Esse é o ponto deste post e do anterior: **a matemática não é nova**.

Desenvolvedores perdem uma quantidade enorme de tempo em discussões idiotas sobre qual linguagem ou ferramenta é "mais brilhante", mas ignoram a matemática adequada e entregam resultados errados. E essa matemática existe há décadas, em alguns casos há mais de um século já!

Deveríamos lutar pra merecer o título de *Cientistas* da Computação. Falta muita **ciência** na computação hoje em dia. Discussões inflamadas não tornam ninguém um bom programador.
