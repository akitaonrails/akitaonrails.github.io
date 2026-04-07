---
title: Conversando com Hal Fulton
date: '2008-01-09T21:27:00-02:00'
slug: conversando-com-hal-fulton
translationKey: chatting-hal-fulton
tags:
- interview
- traduzido
aliases:
- /2008/01/09/chatting-with-hal-fulton/
draft: false
---

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/1/9/n767352779_362954_175.jpg)

[The Ruby Way](http://rubyhacker.com/) é, sem discussão, o livro obrigatório na estante de qualquer Rubyist. Em vez de ser um livro de referência, ele explica o que é preciso para mergulhar de verdade nas sutilezas e maravilhas do estilo de programação Ruby.

Hoje estou muito feliz em conseguir bater um papo com um dos meus autores favoritos, **Hal Fulton**. Foi uma conversa excelente e tenho certeza que o pessoal vai curtir bastante. Ele é um dos veteranos do Ruby e, com certeza, tem muito a compartilhar. Então, vamos lá:

**AkitaOnRails:** Antes de tudo, é tradição aqui no blog perguntar sobre a trajetória do convidado. Há quanto tempo você está na carreira de programação? Como tudo começou? O que te inspira no mundo da computação?

**Hal Fulton:** Comecei a faculdade no curso de física, mas percebi que estava fazendo disciplinas de computação por prazer. Migrei para ciência da computação e o resto é história.

Ao contrário da maioria dos jovens de hoje, só tive contato com computadores aos dezesseis anos, porque computadores pessoais eram muito menos comuns na minha época. Fiquei viciado imediatamente. Enxerguei o computador como uma "caixa mágica" capaz de fazer qualquer coisa que eu fosse inteligente o suficiente para programar. Honestamente, ainda me sinto assim.

**AkitaOnRails:** Já virou quase um clichê, mas preciso perguntar: você foi um dos Rubyists de "primeira geração". Como você descobriu Ruby e o que foi que "encaixou" pra você na linguagem?

**Hal:** Eu estava em um contrato na IBM em Austin no outono de 99. Numa conversa com um amigo do corredor, me queixei de que nunca estava no início de nenhuma tecnologia nova — sempre era um adotante tardio. Ele disse: _"Bom, então você deveria aprender Ruby."_ E eu respondi: _"O que é isso?"_ Aí entrei na lista de e-mails em inglês e comecei a aprender Ruby (versão 1.4).

Minha experiência anterior era com linguagens muito estáticas. Tinha começado (como muita gente na época) com BASIC, FORTRAN e Pascal. Depois aprendi C, C++, Java e várias outras coisas pelo caminho. Mas nunca me aprofundei em LISP e nunca conheci Smalltalk. Então o conceito inteiro de linguagem dinâmica era um pouco estranho pra mim. Eu sempre soube que queria mais poder, mas não sabia exatamente o quê. Tentei imaginar macros que me dessem a flexibilidade que buscava, mas parecia a solução errada.

Aí aprendi Ruby e senti que não tinha dado um salto, mas três saltos de uma vez. Ficou claro que era muito parecido com o que eu vinha buscando inconscientemente.

**AkitaOnRails:** O Pickaxe é outro livro indispensável, mas cumpre o papel de livro de "referência" completo, enquanto o seu trata das entranhas e fundamentos da linguagem — caramba, você gasta 40 páginas só falando de String, se isso não é detalhado o suficiente eu não sei o que seria. Qual era sua intenção quando escreveu a 1ª edição? Como ela surgiu?

**Hal:** Conheci Dave Thomas e Andy Hunt online naquela lista de e-mails. Na época, o excelente livro deles _The Pragmatic Programmer_ tinha acabado de sair e eles estavam trabalhando no livro de Ruby. Fui um dos revisores — ajudando a corrigir imprecisões e problemas.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/1/9/0672328844.jpg)

Um pouco depois, a Sams Publishing foi em busca de alguém para escrever um livro. Na época, a lista de e-mails em inglês tinha pouquíssimos falantes nativos de inglês, então eu tinha boas chances de ser escolhido. Enviei uma proposta e eles gostaram.

O Pickaxe ainda não estava nas prateleiras, mas eu tinha conhecimento íntimo do seu conteúdo. Então quando montei a proposta do meu livro, me certifiquei de que **não** seria concorrência direta — queria que fosse complementar. Se você olhar a página de elogios da primeira edição, há uma citação minha dizendo "Este é o primeiro livro de Ruby que você deve comprar." Mas em privado eu já pensava: _"E eu sei qual deveria ser o segundo."_

**AkitaOnRails:** Por mais detalhado e completo que você tente ser, Ruby tem várias sutilezas e nuances difíceis de capturar. Havia algo que você não cobriu na época mas teria gostado de explorar mais?

**Hal:** Certamente existem algumas sutilezas sobre classes e módulos, reflexão, metaprogramação e afins que não foram mencionadas ou não foram suficientemente enfatizadas. Mas, em geral, um programador não deveria tentar ser "esperto demais" no código de qualquer forma.

A omissão mais gritante, na minha opinião, é a ausência de cobertura sobre como escrever extensões em C. Na primeira edição, simplesmente fiquei sem tempo, energia e espaço — não consegui cobrir isso. Na segunda edição, omiti porque achei que a API C passaria por mudanças radicais conforme nos aproximávamos do Ruby 2.0 — mudanças mais radicais do que as classes principais, por exemplo. Isso, no entanto, está se mostrando incorreto.

**AkitaOnRails:** Você provavelmente encontrou muitos estudantes e entusiastas de Ruby aprendendo através do seu livro. Pela sua experiência, o que você acha que mais impressiona as pessoas na linguagem, e quais são os recursos que mordem os iniciantes logo de cara?

**Hal:** Acho que a concisão é um recurso muito atraente. Dê uma olhada nesta única linha de Ruby, que cria dois acessores para uma classe:

* * *
rubyattr_accessor :alpha, :beta—-

Como você faria isso em C++? Você declararia dois atributos; depois escreveria um par de funções "leitoras" e um par de funções "escritoras". Isso é pelo menos sete linhas de código ali. Mas aí, e se você quiser atribuir tipos diferentes a esses atributos? Aí você entra no overloading. Vira um pesadelo rapidinho. Enquanto isso, em Ruby — continua sendo uma única linha de código.

**AkitaOnRails:** O que você mais gosta no Ruby que o diferencia de outras linguagens similares?

**Hal:** Uma das melhores características do Ruby é a tipagem dinâmica. Variáveis não têm tipos; apenas objetos têm tipos (ou devo dizer, classes). A tipagem estática estava tão enraizada em mim que eu **assumia** que era o jeito certo. Mas quando a abandonei, senti como se tivesse removido pesos que nem sabia que estava carregando.

Sua **regularidade** também é um recurso atraente. Por exemplo, uma classe em Ruby é, em certo sentido, algo "especial" — mas muito menos especial do que em C++, por exemplo. Uma classe é "apenas um objeto", então você pode fazer com classes o que faz com outros objetos — passá-las adiante, armazená-las em arrays, testar seus valores, e assim por diante.

**AkitaOnRails:** E o que você melhoraria se fosse o guardião da linguagem?

Primeiro de tudo, fico feliz de não ser o guardião. Matz faz um trabalho excelente e é muito mais inteligente do que eu. Acho que existem alguns problemas com reflexão e programação dinâmica que precisam ser resolvidos — exatamente como, não tenho certeza.

Aguardo ansiosamente uma máquina virtual realmente usável e alguma forma de combinação de métodos (pre, post, wrap). Admito que há pequenas mudanças de sintaxe e de núcleo que gostaria de fazer — na maioria, bem pequenas.

Por exemplo, sempre quis um operador "in" que fosse açúcar sintático para chamar o método include? — por exemplo, _"x in y"_ significaria _"y.include?(x)"_ — esse operador seria essencialmente igual ao operador de pertinência de conjuntos da matemática (em vez de ser o inverso) e às vezes tornaria o código mais legível, inclusive tornando parênteses desnecessários em alguns casos. Uso o operador "in" do Pascal desde os 18 anos; Python tem ele, SQL também em certa medida. Queria que Ruby também tivesse.

Várias vezes senti necessidade de uma estrutura de dados que fosse acessada como um hash, mas que preservasse a ordem especificada no código. Por exemplo, imagine um tipo de "case statement dinâmico" — passamos possíveis correspondências e código para executar (como procs) para cada uma delas. (Teria a vantagem sobre um case statement de podermos controlar o número de ramificações e o código associado em tempo de execução.) Vamos implementá-lo como um método chamado "choose" que chamamos assim:

* * *
rubychoose regex1 =\> proc { handle_case1 }, regex2 =\> proc { handle_case2}—-

Qual é o problema? A sintaxe nos engana a pensar que regex1 de alguma forma precede regex2 — mas quando iteramos sobre um hash, a ordem não é garantida como no código. (Isso é uma propriedade dos hashes, claro, não um bug.) Então não podemos controlar ou prever a ordem em que eles são aplicados. E encontrei vários outros casos onde queria algo assim — um array associativo, um conjunto de tuplas, com sintaxe conveniente para literais e com uma ordem.

Há duas respostas usuais para meu desejo de um "hash ordenado". Alguns dizem que estou louco, que hash não é ordenado e pronto. Outros dizem que posso sempre criar minha própria classe que se comportasse assim — o que é verdade, exceto que não teria a conveniência de representá-lo como "cidadão de primeira classe" na sintaxe Ruby. Afinal, um hash "poderia" ser representado como cidadão de segunda classe também — eu poderia escrever:

* * *
rubyHash["a",2,"b",4,"c",6]—-

em vez de:

* * *
ruby{"a" =\> 2, "b" =\> 4, "c" =\> 6}—-

Mas sou grato pela expressividade desta última sintaxe.

**AkitaOnRails:** Sua segunda edição cobre Ruby 1.8. Você já está pesquisando sobre Ruby 1.9 (YARV)? Sendo um veterano de Ruby, o que você acha das direções que Matz e Koichi vêm escolhendo para a próxima versão? Te satisfaz? Para você, quais são o bom, o ruim e o feio sobre Ruby agora e na próxima versão?

**Hal:** Houve pontos menores onde discordei de Matz de vez em quando. Mas como eu disse, fico feliz que ele esteja no comando. Gosto do YARV pelo que vi até agora. Estou ansioso para que fique 100% estável para que eu possa realmente ter uma noção de como funciona.

**AkitaOnRails:** Seu livro está na segunda edição e é um livro enorme, cobrindo não só a linguagem em si mas alguns componentes de terceiros como o pdf_writer. Você está trabalhando em uma 3ª edição? Talvez teremos _"The YARV Way"_?

**Hal:** Não estou trabalhando em uma terceira edição e acho que seria muito difícil escrever uma. A segunda foi mais difícil do que eu esperava — embora muito conteúdo tenha sido reaproveitado, ainda precisou ser reexaminado linha por linha — e mais de 50 erros ainda se infiltraram nessas 800+ páginas.

Uma vez brinquei que se houvesse uma 3ª edição, talvez precisaria ser dois volumes. Mas na verdade, não seria uma má ideia — conceitos básicos e classes principais em um volume, bibliotecas padrão e de terceiros no segundo. Mas isso é especulação. **Há** uma espécie de complemento para o livro sendo planejado — mas não vou mencionar isso até sabermos mais detalhes. Me pergunte daqui a alguns meses.

Quanto ao YARV — acho que Ruby sempre será Ruby. Podemos mudar o interior, mas o nome permanecerá o mesmo pelo futuro previsível.

**AkitaOnRails:** Por volta de 2002 Ruby não era amplamente adotado e apenas um punhado de hobbyistas e entusiastas o usavam e ajudavam a melhorar a linguagem. Você mesmo, David Black, Nathaniel Talbott, e muitos outros pesados do que chamo de "primeira geração Ruby". Mas em 2004 surgiu esse framework web completo chamado Rails que tornou Ruby publicamente conhecido e reconhecido, atraindo muitas mentes brilhantes mas também muitos trolls e amadores. Ouço dizer que alguns da primeira geração lamentam isso, porque o que era uma comunidade tranquila e perspicaz ficou muito barulhenta. O que você acha desse status de celebridade repentino que Ruby ganhou e seus efeitos colaterais?

**Hal:** Bem, Ruby não é um clube privado. Será que os japoneses se sentiram ofendidos quando europeus e outros começaram a se interessar por ela? Acho que certamente perdemos um pouco dos velhos tempos, mas não perco tempo pensando nisso. Também ganhamos bastante. E é interessante que a "amizade" da comunidade escalou melhor do que muitos de nós esperávamos. Ruby ainda é Ruby e Rubyists ainda são Rubyists. Apenas há mais de nós agora — também mais projetos, mais atividade, mais oportunidades. Só pode ser algo bom.

**AkitaOnRails:** Você trabalha com desenvolvimento de sistemas em Ruby puro ou usa Ruby on Rails para desenvolvimento web hoje? Qual é sua ocupação ou trabalho principal?

**Hal:** Fiz um pouco de trabalho com Rails aqui e ali, mas sou mais um generalista antiquado. Não sou um cara de web. Muitos programadores mais jovens, claro, parecem não perceber que existe qualquer outro tipo de programação a ser feita. Mas se você estivesse escrevendo um compilador ou interpretador, um servidor web customizado, qualquer tipo de daemon ou aplicação de rede em background… você pegaria seu livro de Rails? Claro que não.

Já fiz trabalho em nível de sistema no passado, mas não consigo imaginar Ruby sendo adequado para os tipos de coisas que eu fazia naquela época. Para essas coisas, usávamos C (o assembly universal). No meu trabalho principal, estou feliz codando Ruby todos os dias — trabalhando remotamente para uma empresa de Dallas chamada [Personifi](http://www.personifi.com). Descreveria meu trabalho como aplicações e ferramentas internas — muita análise de texto e indexação, um pouco de crunching de números e muito crunching de palavras.

**AkitaOnRails:** Aqui no Brasil temos muita gente que foi inicialmente atraída pela máquina de hype do Rails e agora está se batendo para aprender a linguagem Ruby. Metaprogramação, Closures, Mixins deixam o pessoal maluco. Você tem recomendações para os iniciantes?

**Hal:** Qual seria um bom jeito de começar a experimentar com a linguagem? Bem, você pode manter uma cópia de _The Ruby Way_ por perto. :-)

Na verdade, tenho apenas três recomendações. Primeiro de tudo, a lista de e-mails ou newsgroup é uma poderosa fonte de informação e ainda há pessoas simpáticas e conhecedoras lá que responderão suas perguntas. Segundo, há milhões de linhas de código Ruby lá fora. Estude e aprenda com eles. Terceiro, e mais importante: Apenas brinque! Você não aprende realmente uma linguagem lendo sobre ela, mas usando-a.

**AkitaOnRails:** A propósito, você já está escrevendo uma nova edição? :-)

**Hal:** Não estou e não consigo enxergar tão longe. Mas espere seis ou sete meses, e espero ter uma pequena surpresa para você…

![](http://s3.amazonaws.com/akitaonrails/assets/2008/1/9/p4250004_1.jpg)

**AkitaOnRails:** À luz do episódio atual do Zed, ele disse muita coisa especificamente contra o Pickaxe. Uma das coisas é a alegação dele de que o Pickaxe não mencionou claramente toda a questão de metaprogramação. Depois fui conversar com 'arton' — um autor de livros Ruby do Japão — e ele me lembrou: americanos e japoneses parecem fazer Ruby de jeitos diferentes. Ele disse que eles normalmente não fazem toda aquela metaprogramação no nível que o Rails faz, por exemplo. Como você disse, eles não tentam ser "espertos demais".

Agora, não quero ser apologético porque não acho que Dave precisa disso, mas isso explica bastante considerando que o Pickaxe tinha apenas fontes japonesas como referência lá em 2001. Pessoalmente aprendi boa parte do meu Ruby lendo o código-fonte do Rails no início (e livros como o seu depois). O que você acha disso? (quero dizer, sobre o episódio do Zed em geral, e sobre os estilos de programação americano/japonês diferentes?)

**Hal:** Quanto ao Zed, não vou tomar partido nessa discussão. Zed pode dizer o que quiser, e normalmente faz. Tenho certeza que há alguma verdade dos dois lados em qualquer controvérsia.

Quanto à metaprogramação — bem, acho que essas capacidades estão no Ruby por um motivo. Foram pensadas para serem usadas. Mas qualquer ferramenta tem usos adequados e inadequados. É impossível generalizar e dizer "isso é sempre ruim", mas certamente a metaprogramação pode ser mal utilizada.

Quanto ao Rails em si, não tenho dúvida de que há código bom e ruim nele. Suspeito que os desenvolvedores que trabalham nele admitiriam isso. É possível que tenham usado "magia demais" aqui e ali, embora eu não possa dizer especificamente onde. Mas o Rails poderia existir sem recursos de metaprogramação? No seu sentido atual — em qualquer sentido significativo, diria que não.

**AkitaOnRails:** Entrevistei Avi Bryant, famoso pelo Seaside, e um dos seus lemas é que "uma linguagem não está terminada até poder se estender" ou "tartarugas até o fim" como ele diz. Significa que Ruby ainda depende muito de extensões C até hoje. Claro, as motivações iniciais para Ruby são diferentes das do Smalltalk. Por outro lado, pessoas como Evan Phoenix estão perseguindo exatamente esse objetivo: tornar Ruby extensível usando Ruby puro. O que você acha dessa nova direção?

**Hal:** Gosto da ideia de "Ruby em Ruby" em geral, embora Matz não goste. E estou impressionado com o que vi do Rubinius até agora — acho que é um projeto importante e vai crescer em importância.

Se for possível caminhar para a eliminação de extensões C sem sacrificar velocidade, suponho que seja algo bom. Não tenho certeza se é possível. Poderíamos pelo menos criar um "Ruby em Ruby" que não dependa diretamente do MRI (Matz's Ruby Interpreter). Mas não espero ver o "Ruby original" ser substituído tão cedo.

**AkitaOnRails:** Foi uma conversa muito esclarecedora, obrigado!
