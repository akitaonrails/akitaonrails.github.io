---
title: 'Rubyconf Brasil 2013: Conheça Carlos (Chester) Nascimento'
date: '2013-08-12T15:00:00-03:00'
slug: rubyconf-brasil-2013-conheca-carlos-chester-nascimento
tags:
- rubyconfbr2013
draft: false
---

![Carlos Nascimento](http://www.rubyconf.com.br/assets/speakers/Chester-e848b56e230bf0e7a1b89ce1eb2794eb.jpg)

Se você ainda não se inscreveu, não perca a oportunidade. Vá ao [site oficial](http://www.rubyconf.com.br) para se cadastrar agora mesmo! A conferência inicia no dia 29 de Agosto.

Este é o 6o ano consecutivo onde a Locaweb e eu organizamos mais uma grande Rubyconf no Brasil. Muitas empresas estabelecidas e startups de tecnologia estão apoiando a conferência enviando grandes desenvolvedores.

Conheça a [Uken Games](http://www.uken.com/) uma excelente produtora de games cross platform do Canadá, com jogos como Age of Legends, Force of War e muito mais.

Carlos Nascimento, também conhecido como "Chester", é um reconhecido programador brasileiro com experiência de 20 anos na área, tendo trabalhado em empresas como iG, Apontador, MIH/NASPERS, Abril, Globo e Secretaria de Educação do Estado de São Paulo. Ele se mudou há pouco tempo para o Canadá para trabalhar desenvolvendo jogos com a Uken. Agora estará vindo ao Brasil para compartilhar suas experiências.

Não perca sua palestra precisamente às 13:15 do primeiro dia do evento. Vamos conhecer um pouco mais sobre ele:

"Sua palestra será sobre emulação de jogos Atari com Ruby, algo que não se espera normalmente no mundo Ruby. Se alguém está apenas começando com Ruby, poderia explicar quais são os requerimentos que ele deve entender o que você vai apresentar?"

**Chester:** Emulação não é o assunto mais trivial do mundo, mas não é preciso ter medo: não vai ser preciso conhecer linguagem de máquina, nem ter experiência com programação de jogos para consoles antigos. O que eu quero mostrar (além, claro, do emulador em si, cujo código será publicado por ocasião da [Rubyconf Brasil](http://www.rubyconf.com.br)) é justamente introduzir o funcionamento dessas coisas e o que a gente precisa para simular o funcionamento de um.

Claro que vou falar um pouco sobre "escovação de bits", números hexadecimais e afins, então ajuda você estar familiarizado com isso. Mas não é fundamental - o indispensável *mesmo* é o interesse no assunto, que eu acredito fugir um pouco do cotidiano da maioria dos programadores Ruby (muito embora eu tenha me surpreendido com quanto ferramentas como RSpec e disciplinas como TDD se adaptaram bem a uma área tradicionalmente mais "selvagem" como a emulação...)

"Muitos desenvolvedores adorariam se tornar tão experientes e fluentes rm Ruby como você. Quais foram as dificuldades que teve que ultrapassar para se tornar um grande desenvolvedor? Algumas dicas para iniciantes em Ruby?"

**Chester:** Se a pessoa *gosta* de escrever código, meus parabéns - está com meio caminho andado. Só não se esqueça da outra metade: *ler* código - seja este código bom ou ruim, é sempre um aprendizado! Joel Spolsky [alertava](http://www.joelonsoftware.com/articles/fog0000000069.html) já em 2000 que _"é mais difícil ler código do que escrever código"_, e mais recentemente Fabio Akita (não sei se você conhece) [desfez alguns mitos](http://www.akitaonrails.com/2012/08/15/off-topic-o-mito-do-legado) ao mostrar que o real desafio está no código existente e não no "greenfield", no escrito do zero. Eu escuto muito esses caras, e recomendo aos iniciantes fazer o mesmo.

Além disso, vale mencionar dois vícios que enfraquecem o aprendizado, a produtividade e a carreira de muita gente: um é passar a vida toda fazendo a mesma coisa, evitando ou minimizando qualquer novidade; o outro é não dedicar um mínimo de tempo ou estudo a uma tecnologia antes de pular para o próximo sabor da moda. Ambos parecem diametralmente opostos, mas acomodação e falta de foco são, no fundo, sintomas de uma coisa só: preguiça mental. O caminho, a meu ver, é buscar o equilíbrio: diligência naquilo que você está usando agora, e antena ligada no que está por vir.

"Existem tantas tecnologias, boas práticas e tudo mais que são lançados o tempo todo. Na sua opinião pessoal, e talvez relacionado ao seu trabalho atual, quais são as tendências em tecnologia que acha que devemos prestar atenção no futuro próximo?"

**Chester:** O desafio atual do meu trabalho é lidar com volumes de dados cada vez maiores, em níveis de complexidade igualmente assustadores. E é muito tentador culpar a tecnologia em uso (o famoso "Rails não escala") ou buscar soluções mágicas ("muda pra Node/Go/<insira o sabor da moda aqui> que resolve").

A verdade é que quando você precisa de ganhos de escala, nada substitui o cuidado com a arquitetura do sistema - e para isso é importante ter um olho no passado (estudar com carinho os fundamentos da computação e do processamento de dados em geral) e outro no futuro (evitando a tentação oposta, que é se agarrar na tecnologia com a qual se está confortável).

Um exemplo disto são os bancos de dados não-relacionais (ou "NoSQL", como preferem alguns). Eu recomendo olhar para eles com muito carinho, mesmo que a natureza dos dados com que você lida seja 100% atendida por um SGBD tradicional. E quem usa Ruby tem a vantagem de uma comunidade fantástica: independente do sistema de dados que o desenvolvedor queira avaliar, ele pode contar com um driver ou biblioteca de acesso ao alcance de um gem install.

É verdade que muitos early adopters estão atingindo estágios variados do [vale da desilusão](http://en.wikipedia.org/wiki/Hype_cycle), confrontando os ganhos de escala com problemas técnicos diversos, mas isso se deve mais ao fato de as implementações serem bastante novas do que a um problema inerente na tecnologia.

Isso é um fator para considerar no presente, mas não condena a tecnologia. Eu lembro de quando nenhuma empresa "séria" considerava trocar o Oracle/DB2/SQL Server por um banco open-source como MySQL ou PostgreSQL - eram "imaturos", "instáveis"... e hoje estão [ombro a ombro](http://db-engines.com/en/ranking) com os proprietários.

Então meu conselho é: Fiquem de olho nos SGBDs não-relacionais, porque a história se repete!
