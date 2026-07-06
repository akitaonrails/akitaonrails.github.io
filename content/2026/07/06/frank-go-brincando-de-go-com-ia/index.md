---
title: "Frank GO: brincando de GO com IA"
slug: "frank-go-brincando-de-go-com-ia"
date: '2026-07-06T12:00:00-03:00'
draft: false
translationKey: frank-go-playing-go-with-ai
tags:
  - go
  - baduk
  - katago
  - sabaki
  - opensource
  - ai
  - vibecoding
---

![Arte oficial do anime Hikaru no Go: o Hikaru no centro estendendo uma pedra de Go pra câmera, com o fantasma Sai de trajes Heian e leque atrás dele, cercados pelo elenco (Akira, Waya, Isumi, Akari e companhia) e pelo logo da Shonen Jump.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/06/frank-go/key-art-hikaru-no-go.webp)

Eu comecei a gostar do milenar jogo de Go por causa do mangá **Hikaru no Go**. Cheguei a escrever sobre isso [em 2008, num post que ainda está no ar](/2008/07/15/off-topic-por-que-programadores-devem-jogar-go/), defendendo por que programadores deveriam jogar Go. De lá pra cá pouca coisa mudou no meu caso de uso: eu tenho um goban físico em casa, mas nunca tive a menor intenção de entrar em grupo de estudo, federação ou competição. Eu só gosto de jogar sozinho, resolver uns tsumego (os quebra-cabeças de vida e morte do Go), e carregar partidas famosas pra estudar, como os lendários jogos do Lee Sedol contra o AlphaGo em 2016.

Pra quem não conhece o mangá: Hikaru no Go (roteiro de Yumi Hotta, arte de Takeshi Obata, o mesmo de Death Note) rodou na Shonen Jump entre 1998 e 2003 e causou um boom de interesse por Go no Japão inteiro. E tem um detalhe que pouca gente sabe: praticamente todas as partidas que aparecem no mangá são baseadas em jogos históricos reais, recriados quadro a quadro. Guarda essa informação, porque ela volta daqui a pouco.

## SGF e o problema do material espalhado

Existem vários programas open source muito bons pra carregar partidas de Go ou até jogar online. Partidas de Go são gravadas num formato chamado **SGF** (Smart Game Format), um formato de texto puro que existe desde o fim dos anos 80: cada jogada vira uma coordenada (`;B[pd]` é uma pedra preta no ponto 4-4), e o formato suporta árvores de variação, comentários e metadados da partida. É o padrão de facto do mundo do Go: todo cliente lê SGF, todo servidor exporta SGF, e existe um acervo gigantesco de partidas históricas e problemas nesse formato acumulado ao longo de décadas.

E aí mora o problema: esse acervo está **espalhado pela internet inteira**. Um site tem as coleções clássicas de tsumego, outro tem as partidas históricas, um repositório do GitHub tem os problemas comentados, outro tem os kifu (registros de partida) profissionais. Eu não estava com o menor humor de baixar tudo manualmente, organizar pasta por pasta e configurar cliente por cliente. Eu queria um app bom o suficiente, bonito o suficiente, com tudo embutido.

## 2008: a era GNU Go

Aqui vale o contexto histórico, porque ele é a parte divertida. Em 2008, quando escrevi aquele post, a única "IA" de Go acessível era o [GNU Go](https://www.gnu.org/software/gnugo/). E olha, a gente nem pode chamar aquilo de IA: era um monte de heurísticas empilhadas. E era terrível. Até um amador como eu conseguia ver que ele fazia jogadas sem fluxo nenhum, sem sentido de direção, pedras soltas que não conversavam entre si. Ganhava de iniciante por pura tática local e só.

O que aconteceu nos 18 anos seguintes é uma das histórias mais bonitas da computação. Primeiro vieram os métodos de Monte Carlo Tree Search, que já melhoraram bastante o nível.

Aí em março de 2016 o **AlphaGo** do DeepMind venceu Lee Sedol, um dos maiores jogadores da história, por 4 a 1. Foi a série da famosa jogada 37 da partida 2 (o "ombro" que nenhum humano jogaria) e da resposta à altura do Lee Sedol: a jogada 78 da partida 4, a "mão de Deus" que lhe deu sua única vitória. Se você nunca viu, existe um [documentário excelente sobre essa série na Netflix](https://www.netflix.com/title/80190844), que vale a pena até pra quem não sabe nada de Go.

E depois que o DeepMind publicou os papers, a comunidade open source correu atrás: primeiro o Leela Zero reimplementando o AlphaZero, e depois o KataGo indo além. Hoje qualquer um tem um jogador sobre-humano de Go rodando de graça no próprio computador. Eu queria ver de perto o quanto essas IAs amadureceram em 20 anos.

Foi dessa vontade que nasceu meu novo projeto de brinquedo: o **[Frank GO](https://github.com/akitaonrails/frank_go)**.

## Sabaki + KataGo

Pedi pro Claude Code pesquisar os apps e engines open source de Go mais populares (a pesquisa inteira está documentada [no próprio repositório](https://github.com/akitaonrails/frank_go/tree/main/docs/research), como manda o figurino). No fim escolhi dois projetos como base:

O **[Sabaki](https://sabaki.yichuanshen.de/)**, do Yichuan Shen, é o front-end. É provavelmente o editor de SGF e tabuleiro de Go open source mais bonito e bem cuidado que existe, feito em Electron, com suporte a árvores de variação, análise e engines via protocolo GTP. Elegante e minimalista.

O **[KataGo](https://github.com/lightvector/KataGo)**, do David Wu, é a IA. É o motor open source mais forte do mundo, sobre-humano, herdeiro da linhagem do AlphaZero mas com uma diferença que importa demais pro meu caso: além da taxa de vitória, o KataGo estima **pontuação e domínio de território ponto a ponto**. Ele responde "quem está ganhando, por quantos pontos, e quais áreas do tabuleiro pertencem a quem". É exatamente o tipo de informação que um iniciante precisa e que os engines antigos escondiam.

O Frank GO é um fork do Sabaki que amarra o KataGo pra sessões de jogo solo, e embute tudo aquilo que eu queria ter num lugar só:

- **Mais de 4.700 tsumego** das coleções clássicas (a Enciclopédia do Cho Chikun, o Gokyo Shumyo, o Xuanxuan Qijing), transcritas pelo Vít Brunner no [tsumego.tasuki.org](https://tsumego.tasuki.org/) e convertidas pra SGF pelo projeto [tasuki2sgf](https://github.com/Seon82/tasuki2sgf), mais os 420 problemas comentados do [go-problems do Go Game Guru](https://github.com/gogameguru/go-problems) (do An Younggil, profissional 8-dan), organizados em 10 níveis de dificuldade. Resolve 5 seguidos e sobe de nível. Um seletor de foco filtra por vida e morte, tesuji, ko ou semeai (corrida de capturas).
- **Os puzzles revidam**: com o KataGo instalado, ele responde suas jogadas dentro do problema, e quando ele desiste da área o app julga o resultado e marca o problema como resolvido automaticamente.
- **Partidas históricas famosas pra estudar**, do Jogo da Orelha Vermelha (1846, do lendário Honinbo Shusaku) até AlphaGo vs Lee Sedol, curadas do [banco de partidas do Andries Brouwer no CWI](https://homepages.cwi.nl/~aeb/go/games/), cada uma com a história por trás, e as do AlphaGo com comentário jogada a jogada. Dá pra assistir em auto-play ou ligar o modo "adivinhe a jogada" e tentar achar o lance do profissional.
- **As partidas do Hikaru no Go**: lembra que os jogos do mangá são reais? Pois é, 15 deles estão embutidos com referência de capítulo e curiosidades, usando o [mapeamento capítulo-a-partida que a comunidade compilou na Sensei's Library](https://senseis.xmp.net/?HikaruNoGoGames). A partida de internet do Sai contra o Toya Meijin, por exemplo, é um jogo real decidido por meio ponto.
- **Dicionário de joseki** (o [Kogo's Joseki Dictionary](https://waterfire.us/joseki.htm), referência clássica de aberturas de canto), drills de escada, drill de "quem está ganhando?", e um teste de rank de dez problemas que estima seu nível e te larga direto na prática certa.

Lembra do problema do material espalhado? Essas coleções aí de cima são exatamente ele: cada uma vivia num canto da internet. A procedência e o licenciamento de cada conjunto estão documentados no [data/SOURCES.md](https://github.com/akitaonrails/frank_go/blob/main/data/SOURCES.md) do repositório, porque acervo dos outros se usa dando o devido crédito.

![Prática de tsumego no Frank GO: um problema de canto no tabuleiro com o overlay de pintura de área ligado, e o painel lateral mostrando nível 1, foco, e o aviso de que o KataGo responde as jogadas.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/06/frank-go/tsumego-practice.jpg)

## Overlays pra quem está começando

A parte em que eu mais mexi no Sabaki foi criar sobreposições visuais amigáveis pra iniciante. A principal é a **pintura de área**: um overlay que pinta a influência de cada jogador como um gradiente suave e o território consolidado em cor sólida, então você literalmente **vê** o que as pedras estão fazendo, quais áreas estão mortas e quais estão em disputa.

Junto vem o **placar em tempo real** considerando o komi (a compensação de pontos do branco por jogar em segundo), que avisa quando você está irremediavelmente atrás ou quando o jogo já está decidido. E passando o mouse no tabuleiro aparecem os nomes das jogadas ("Hane", "One-Point Jump"), o vocabulário que os livros usam e que iniciante demora a absorver.

![Modo de estudo do Frank GO: a partida de aposentadoria do Honinbo Shusai (1938) carregada no tabuleiro, com a pintura de área escurecendo as pedras mortas e o painel lateral contando a história do jogo imortalizado no romance "O Mestre de Go" do Kawabata.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/06/frank-go/study-mode.jpg)

Esse era o meu problema com todo software de Go que já testei: são ferramentas feitas por jogadores fortes pra jogadores fortes. Winrate em porcentagem não diz nada pra quem está aprendendo. "Você está 12 pontos atrás e o canto inferior esquerdo morreu" diz tudo. O KataGo sempre soube calcular isso; faltava alguém colocar na tela de um jeito que iniciante entende.

![Painel de prática do Frank GO dando boas-vindas e sugerindo o teste de rank de dez problemas pra encontrar seu nível.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/06/frank-go/practice-panel.jpg)

A ideia é ser um balcão único, sem configuração nenhuma, pra iniciante e estudante aprender Go no próprio ritmo. E tem build pra todo lugar. No Arch Linux é `yay -S frank-go` via AUR. No **Windows** tem instalador e versão portátil nos [Releases](https://github.com/akitaonrails/frank_go/releases); o instalador não tem assinatura digital, então o SmartScreen reclama na primeira execução, é só clicar em "Mais informações → Executar assim mesmo" ([eu explico por que não assino build de Windows no post de boas práticas](/2026/05/30/boas-praticas-projetos-codigo-aberto-llm-o-minimo/)). No **macOS** é `brew install --cask akitaonrails/tap/frank-go`, ou o `.dmg` pra Apple Silicon e Intel; esse build é assinado com Developer ID e notarizado pela Apple, abre sem drama nenhum. E em qualquer plataforma dá pra rodar do fonte com `npm install`.

Em todos os casos o app baixa um engine de CPU pequeno com um clique, sem GPU, sem conta, sem servidor, totalmente offline. A exceção é o macOS, onde o KataGo não tem binário oficial: um `brew install katago` destrava o jogo contra a IA, e todo o resto (tsumego, estudo, drills, pintura de área) funciona sem ele. O progresso fica na sua máquina.

![Menu de estudo e drills do Frank GO: estudar partida famosa, partidas do Hikaru no Go, dicionário de joseki, drill de quem está ganhando, drill de escada e teste de rank.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/06/frank-go/study-and-drills.jpg)

## E quando você quiser jogar contra gente

O Frank GO é deliberadamente um app de estudo solo. Quando você aprender e quiser jogar contra humanos, o caminho natural são os servidores online, e aí os apps mais avançados servem melhor. O [OGS (Online Go Server)](https://online-go.com/) é o mais amigável hoje, roda direto no navegador. O [KGS](https://www.gokgs.com/) e o [Pandanet IGS](https://www.pandanet-igs.com/) (o Internet Go Server original, no ar desde o começo dos anos 90) são os veteranos, e os servidores asiáticos como Fox e Tygem concentram os jogadores mais fortes. O mundo do Go organizado gira em torno da [IGF (International Go Federation)](https://www.intergofed.org/) e das associações nacionais, com rankings e torneios pra quem quiser levar a sério.

Eu não quero. E esse é o ponto do projeto inteiro: como eu disse lá em cima, não tenho nenhuma vontade de competir. Eu queria, há literalmente anos, um jeito de jogar e me divertir com Go no meu ritmo, com material de estudo decente num lugar só, contra uma IA que joga bonito em vez de cuspir pedras sem sentido como o GNU Go de 2008. Acho que finalmente consegui.

O código é MIT, o repositório é [github.com/akitaonrails/frank_go](https://github.com/akitaonrails/frank_go), e contribuições são bem-vindas. Tem inclusive uma [issue aberta pedindo retratos dos personagens](https://github.com/akitaonrails/frank_go/issues/6) pro modo Hikaru no Go, se alguém quiser desenhar. O Sai agradece.
