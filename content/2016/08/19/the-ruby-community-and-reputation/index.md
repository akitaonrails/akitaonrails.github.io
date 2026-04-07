---
title: A Comunidade Ruby e a Reputação
date: '2016-08-19T11:02:00-03:00'
slug: a-comunidade-ruby-e-a-reputacao
translationKey: ruby-community-reputation
aliases:
- /2016/08/19/the-ruby-community-and-reputation/
tags:
- community
- rails
- ruby
- ranting
- traduzido
draft: false
---

Acabei de ler os posts do [Adam Hawkins](http://hawkins.io/2015/05/the-ruby-community-the-next-version/) e o apoio do [Alan Bradburne](http://www.alanbradburne.com/Rubys-reputation) na Ruby Weekly.

Como disclaimer, eu não conheço esses caras pessoalmente e respeito o ponto de vista deles. A intenção aqui não é começar um flame war, é só pintar um ponto de vista alternativo.

Ambos os artigos representam o ponto de vista de muitos desenvolvedores Ruby veteranos dessa comunidade. Vários deles já partiram para outras tecnologias ou pararam de aparecer publicamente.

Eu já deixei minha posição bem clara em ["Rails has Won: The Elephant in the Room"](http://www.akitaonrails.com/2016/05/23/rails-venceu-o-elefante-na-sala). Mas deixa eu simplificar aqui.

Tem claramente uma facção se formando. Tirando ótimos desenvolvedores como Solnic (dry-rb), Nick (Trailblazer) e Luca (Hanami), a maioria das pessoas está reclamando que o Rails e algumas das peças mais próximas do ecossistema ao redor dele não se encaixam na visão recém-descoberta deles do que seria o "bom".

Na visão de mundo deles, um Rails "melhor" seria muito mais simples, muito mais explícito, composto de bibliotecas super pequenas, com APIs externas super explícitas, e super componibilidade pra desmontar e remontar pra todo lado.

E é aí que mora meu problema: se o DHH cedesse e tomasse esse caminho, isso seria "Ruby OFF the Rails". O ponto inteiro de "Ruby **ON** Rails" existe justamente porque ele é definido como um full stack coerente, opinativo, com bibliotecas grossas (coarse-grained) feitas pra trabalhar juntas em sintonia.

Deixa eu apresentar o verdadeiro Elephant in the Room:

* Discussões como essa são só link baits inflamatórios. Não servem pra nada além de criar uma nuvem de animosidade contra alguma coisa, sem apresentar de fato uma alternativa boa e objetiva. Escrever bullet points é fácil; escrever soluções completas e mantê-las já é outro departamento.

* Existem sim boas alternativas pipocando, como o já mencionado Trailblazer, o Hanami e a coleção de bibliotecas dry-rb, só pra citar algumas. A reclamação é que elas não têm tanta tração agora. Qual a solução? Falar mal do Rails? Escrever artigos chorosos sobre como a vida é injusta? Ou, melhor, escrever mais tutoriais sobre como usar Trailblazer? Gravar screencasts sobre como usar Hanami? Ir a uma conferência e fazer mais palestras sobre como importar dry-rb nos seus projetos?

* O Ruby on Rails foi feito pra programadores cansados de super componibilidade, super configuração, super explicitação, super bibliotecas fine-grained. Foi feito pra programadores Java saindo direto do pesadelo que foi o J2EE 1.x em 2004, lembram disso? E agora a "proposta" é voltar pra aquilo? Desperdiçar quantidades enormes de tempo afinando seu mini-stack feito sob medida? A gente já tem isso. Chama Javascript. E deixa eu te falar: configurar a geração atual de `package.json` me traz memórias muito ruins de `pom.xml`, `hibernate.cfg.xml` e `struts-config.xml`.

* Iniciantes não estão interessados em soluções fine-grained. A maioria das pessoas esquece como era ser iniciante. Na verdade, eu argumentaria que 80% dos desenvolvedores do mundo se beneficiam muito de uma abordagem como a do Rails. Não é coincidência que muitas plataformas se conformaram a uma abordagem opinativa, convention-over-configuration, depois que ela provou seu valor.

O fato das pessoas estarem reclamando contra o Rails dá a sensação de que a culpa, de algum jeito, é do Rails. Na real, isso é só um reflexo da frustração das próprias pessoas que **falharam** (e estão falhando) em vender as alternativas. Todo mundo quer almoço grátis.

Deixa eu contar uma historinha.

Lá em 2005, eu era o único desenvolvedor Rails que eu conhecia no meu país (Brasil). Eu googlei por aí e achei uns meia dúzia de outros hobbyists fazendo Ruby por diversão, e um par já fazia profissionalmente.

As pessoas zoavam a gente em todo lugar que eu olhava porque achavam que a gente era doido. _"Lógico que J2EE é o caminho." "Lógico que todo projeto deveria seguir a abordagem DDD do Eric Evans." "Lógico que todo projeto deveria seguir todos os Design Patterns do Gang of Four, quanto mais melhor." "Lógico que a gente deveria ter pacotes de deploy bem isolados, com fronteiras de API bem explícitas entre eles, não importa o quanto isso derrube a produtividade."_

Já passei por isso antes. Em 2004, eu já tinha mais de dez anos de experiência em programação profissional.

Levei mais dez anos de peregrinação. 9 anos organizando minha própria conferência. Mais de 1.000 posts no blog. Quase 200 palestras, várias delas que paguei do meu próprio bolso pra comprar passagens de ônibus e avião. Botei o dinheiro onde minha boca estava.

A promessa era substituir toda a complexidade e burocracia por uma stack opinativa, na qual a maioria das decisões básicas já estavam tomadas. Ela ficaria fora do nosso caminho pra que pudéssemos focar na parte mais importante: o negócio.

<div class="video-container">
    <video controls>
        <source src="https://s3.us-east-2.amazonaws.com/blip.tv/Java_is_not_evil.mp4" type="video/mp4">
        Seu navegador não suporta a tag video. [Link Direto](https://s3.us-east-2.amazonaws.com/blip.tv/Java_is_not_evil.mp4)
    </video>
</div>

Toda palestra de Rails que eu fiz desde 2006 tinha a seção acima. E com cada pessoa que assistiu qualquer uma das minhas palestras como testemunha, eu sempre disse:

> "Muitos de vocês ouviram que Java é ruim porque é muito complexo e burocrático. E muitos vão tentar vender suas alternativas às custas do Java. Nós não. Nós abraçamos o que Java tem a oferecer. Solr, Elasticsearch e Hadoop são todos feitos em Java. O que vamos fazer? Reescrever tudo em Ruby? Claro que não. Pra Rails Vencer, Java não precisa Perder." (E aí eu colocava fogo na imagem da "edição evil", no palco).

Eu escrevi um artigo em outubro de 2007 chamado ["Para eu ganhar, o outro precisa perder ..."](http://www.akitaonrails.com/2007/10/23/para-eu-ganhar-o-outro-precisa-perder), onde expliquei por que esse jeito de pensar é tão tosco. Também me inspirei na famosa palestra de Steve Jobs na Macworld de 1998, onde ele chamou o Bill Gates pro palco, na tela gigante, pra anunciar a colaboração entre eles. Os fanboys da Apple surtaram, ficaram horrorizados com aquela cena, foi como dormir com Satã.

Quase 20 anos depois, a Apple é uma das empresas mais valiosas do mundo. Porque não importava. Jobs deixou a ideologia pura pra trás e virou pragmático. Eles precisavam do endosso da Microsoft, conseguiram, e provaram seus pontos pelos resultados: passaram os anos 90 se masturbando sobre por que o clássico OS 7 a 9 era melhor que o Windows 3.1 até o NT 4. Mas levou dez anos pra provar o valor do OS X ao longo da primeira década do século XXI. Um passo de cada vez, um release atrás do outro, entregando com frequência, em vez de passar anos trancados nos laboratórios até a solução "perfeita" surgir. Baby steps. Culminou quando eles espremeram o OS X dentro do iOS em 2007.

É assim que se prova um ponto: através de suor e dor, colocando aquilo na rua, vendendo, evangelizando e criando valor real, um pequeno release de cada vez.

E aí aconteceu isto:

![Macbooks por todo lado](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/559/big_mac-school.jpg)

Lembram quando a Apple dominou o mundo? Uma década inteira pra voltar de [sangrar 1 bilhão por ano](http://money.cnn.com/1998/10/14/technology/apple/) até virar a [empresa mais valiosa do mundo](http://fortune.com/2016/02/03/apple-facebook-amazon-google/), cujos efeitos ainda continuam 5 anos depois da morte do Jobs.

Alguns de nós entendemos que engenheiros gostam de se masturbar sobre coisas irrelevantes.

> "- Meu algoritmo roda 0.1 milissegundos mais rápido que o seu".

> "- Ha, mas meu design tem menos pontos de dependência que o seu!"

O Rails fez pelo Ruby o que a Apple fez pelo Unix e o que a Canonical fez pelas distros baseadas em Linux. As pessoas reclamando do Rails me lembram as pessoas tentando argumentar por que o Archlinux é muito superior ao OS X ou ao Ubuntu, mas é só que as pessoas em geral são burras demais pra perceber esse valor.

E pra alguns, talvez não seja exatamente um elogio estar na mesma liga da Apple ou da Canonical, mas os resultados são inegáveis.

Lembram do lendário "blog em 15 minutos"? Por que aquilo nos surpreendeu tanto em 2005? Não era o que o Rails podia fazer; era todo o trabalho que a gente não precisava fazer. E o Rails permaneceu fiel a isso até hoje.

Se você é um programador iniciante, o Rails ainda tem muito o que ensinar, e você pode aprender os detalhes depois.

Se você é o programador mediano, o ecossistema do Rails vai te levar do ponto A ao ponto B muito mais rápido, com produtividade e manutenibilidade melhores.

Por que você está reclamando se você é o programador estrela do tech, financiado por um unicórnio?

Programadores reclamões estão esquecendo um dos nossos próprios ditados favoritos: "Otimização Prematura é a Raiz de Todo Mal". E como o "UNIX way" já dizia:

> A estratégia é, definitivamente:

> Faça funcionar,

> Depois faça do jeito certo,

> e, por fim, faça rápido.

Não tem nada de errado em ter alternativas ao Rails, mas o bashing contra Rails está ficando muito velho muito rápido. Vender alternativas é difícil, eu sei. Gastei muita sola de sapato nos últimos 10 anos evangelizando Ruby, então eu sei mesmo.

Eu nunca acreditei em almoço grátis. Eu acredito em trabalho duro e direcionado, e essa tem sido minha filosofia nos últimos 25 anos de programação.
