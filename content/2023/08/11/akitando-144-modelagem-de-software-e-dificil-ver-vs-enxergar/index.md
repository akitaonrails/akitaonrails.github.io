---
title: '[Akitando] #144 - Modelagem de Software é Difícil? | "Ver" vs "Enxergar"'
date: '2023-08-11T15:57:00-03:00'
slug: akitando-144-modelagem-de-software-e-dificil-ver-vs-enxergar
tags:
- ddd
- domain driven development
- design patterns
- martin fowler
- bob martin
- uncle bob
- eric evans
- gang of four
- software design
- software modelling
- modelagem
- arquitetura
- magento
- ecommerce
- akitando
draft: false
---

{{< youtube id="SmYQcaP1Jgw" >}}


Um dos assuntos que mais assusta iniciante é esse negócio de "modelagem de software" ou "design de software" ou "arquitetura de software". Vários nomes que parecem ser a mesma coisa e ao mesmo tempo não serem coisa nenhuma. 

Hoje quero "filosofar" um pouco pra dar uma perspectiva diferente de como se deve encarar esses assuntos e talvez uma estratégia de como realmente entender como isso funciona.

## CAPÍTULOS

* 00:00 - Intro
* 02:08 - CAP 1 - Livros de Modelagem e Arquitetura - Devo Estudar Todos?
* 04:14 - CAP 2 - O Problema dos Tutoriais - Modelando Objetos Reais?
* 13:07 - CAP 3 - Modelando o Mundo Real - Um Exemplo
* 16:04 - CAP 4 - A diferença de "VER" e "ENXERGAR" - Michelângelo e Arte
* 21:30 - CAP 5 - Mentoria do Mundo Real - Cuidados
* 24:44 - CAP 6 - Analisando o Mundo Real - Aprendendo Ecommerce
* 33:11 - CAP 7 - Teoria e Prática - A História do Magento
* 41:07 - CAP 8 - Recomendação de Livros - Aprendendo com Especialistas
* 49:17 - Bloopers

## Links

* [Magento 2](https://github.com/magento/magento2)
* [Spree](https://github.com/spree/spree)
* [Agile Web Development with Rails - GitHub](https://github.com/morinoko/agile-dev-rails6)
* [Agile Web Development with Rails](https://pragprog.com/titles/rails7/agile-web-development-with-rails-7/)
* [The Architecture of Open Source Applications](https://aosabook.org/en/)
* [Rails Summit 2009 - Ilya Grigorik]()
* [Chatting with Luke Kanies](https://www.akitaonrails.com/2009/11/18/chatting-with-luke-kaines)
* [RailsConf 09 - Exclusive Audio Interviews | AkitaOnRails.com](https://www.akitaonrails.com/2009/05/08/railsconf-09-exclusive-audio-interviews)


## SCRIPT

Olá pessoal, Fabio Akita

No último video resolvi falar mais sobre bancos de dados. Já tinha feito dois videos antes sobre isso e em todos fui pelo caminho mais fácil: explicar como funcionam por baixo. As engrenagens que possibilitam existir armazéns de dados. Mas explicar implementação não é tão difícil, porque eles já existem e funcionam bem.







O problema que eu venho me esquivando desde o começo do canal é explicar o que a maioria de nós, programadores, considera o problema mais difícil da programação: dar nomes pras coisas. Isso mesmo, não é piada. Em particular, como modelar um problema de negócios em código? O que é um design de software "feito direito"? O que significa "fazer direito"? Significa seguir Domain Driven Development? Significa usar a maioria dos Design Patterns? Significa seguir algum framework? Tem algum livro que se possa ler e aprender o que significa isso de "modelar"?







Durante toda a vida deste canal eu vim flertando com esse assunto, por exemplo quando falei do Livro The Mythical-Man Month, que afirmei ser o mais importante pra se ler. O video de hoje vai ser uma filosofada super longa e provavelmente super frustrante. Frustrante porque eu não vou dar copy e paste de material que já tem online. É só procurar que você acha tudo de patterns, arquitetura, modelagem. O objetivo do video é explicar porque muitos acham "difícil", mesmo tendo todo esse material. E no final vou até recomendar outros materiais, então assistam tudo.






O spoiler é que não existe o "jeito certo" de se fazer software, mas por outro lado, o processo não é aleatório. Existe um balanço fino entre teoria e prática que é onde se encontra nossa profissão. A razão de existir programadores é justamente porque é nossa função decidir o que é "melhor" pra determinada circunstância. 






Lembram do video de Não Terceirize Suas Decisões? O pior programador é aquele que é incapaz de tomar decisões. O melhor programador não é aquele que toma todas ou a maioria das decisões corretas, mas sim aquele que toma decisões possíveis no momento em que precisam ser tomadas, nem antes, e nem depois. E o que vou tentar fazer hoje é ilustrar esses conceitos. Então vamos lá.




(....)





Como primeira opinião controversa do dia, vou afirmar o seguinte. A maioria dos livros de modelagem e design, como o Clean Code do Bob Martin, o Domain Driven Development do Eric Evans, o Design Patterns do Gang of Four, o Patterns of Enterprise Application Architecture do Martin Fowler; todos livros excelentes, mas eu acho que são totalmente inúteis no seu primeiro ano pós faculdade. Entenda: você acabou de se formar, ainda tem pouca ou nenhuma experiência em projetos reais ou em projetos pessoais ou open source. Esses livros são perda de tempo.






Pra ficar muito claro: eu não estou dizendo que os livros são inúteis. Muito pelo contrário, eu acho todos eles excelentes e que precisam ser estudados. Mas todos tem um pré-requisito: que você já tenha quilometragem em código. Tanto em fazer seu próprio código quanto lidar com código dos outros, especialmente código legado. 






A estratégia é assim: nenhum desses livros você deve tentar ler de cabo a rabo de uma só vez. Folheie alguns capítulos, os iniciais. Veja os temas de cada um pelo índice, leia a primeira página de cada capítulo. Guarde. Vá trabalhar ou treinar com projetos open source. Volte daqui um ou dois meses. Folheie de novo, avance um capítulo a mais, pule pra um capítulo no meio que tem assunto que chamou sua atenção porque é compatível com o que está mexendo no momento. Guarde de novo.






Depois do primeiro ano trabalhando tempo integral com programação, retorne. Leia com um pouco mais de esforço. Releia os primeiros capítulos. Repita. É um processo que deveria te custar os primeiros 3, talvez 5 anos iniciais de carreira. Se fizer direito, talvez comece a entender o que esses autores queriam dizer quando estiver lá pelo quarto ano. 






Um dos sinais que você conseguiu mesmo pular de nível junior pra pleno, é quando começa a entender o que os autores queriam dizer, e não está tentando seguir ao pé da letra o que está escrito, sem saber porque. Mas no primeiro ano, esses livros são inúteis. Você ainda não lidou com problemas suficiente pra entender esses porquês. E o importante é o porquê. Agora deixa eu dar uns passos pra trás e explicar porque.






Qualquer um que já tenha tido curso ou lido livro sobre modelagem de objetos já deve ter esbarrado no famoso exemplo dos animais ou veículos. Por exemplo, ambos cachorro e gato são animais. Animal é uma abstração. Portanto, parece óbvio que deveríamos fazer uma classe abstrata chamada Animal, daí podemos derivar sub-classes Cachorro e Gato que herdem de Animal, ou em linguagens mais modernas, que tenham o "trait" ou protocolo de Animal. 






Ou então temos Carro e Caminhão, ambos são veículos, poderia ser essa a classe pai abstrata. Carro e Caminhão herdam de veículo. O problema com todos esses exemplos, primeiro é que eu nunca vi ninguém fazer uma classe realmente chamada Animal. Talvez quem já trabalhou em projetos de biologia ou zoológico. Mesmo se fizer um sistema de uma fábrica ou concessionária de carros, provavelmente vamos ter uma tabela ou classe mais genérica, mais abstrata ainda, como "Produto". 







O problema de sistemas de verdade é que praticamente todos os conceitos mais importantes são abstratos, não concretos. Por exemplo, o caso mais óbvio, que são os usuários de um sistema. Usuários não são pessoas? Acho que é por isso que todo iniciante começa um sistema pela tabela de usuários, porque é a única coisa que consegue se identificar, é familiar. Ou seja, tem alguma experiência. Mesmo um iniciante sabe que um usuário deve ter atributos como nome, email, telefone, endereço, RG ou CPF e coisas assim.







Mas rapidamente isso complica. Estamos falando dos dados de identificação de um usuário? Ou estamos falando dos dados de autenticação, como login? Nesse caso precisamos de atributos como "username" e "password". E já começa o primeiro erro. Já expliquei nos episódios de segurança e criptografia que não gravamos senha numa tabela. Precisamos de atributos abstratos como "salt" e "hash". Mas e two-factor authentication? Precisamos de um seed pro algoritmo de Time-based One-Time Password ou TOTP. Só se você estudou segurança vai saber disso.







Dá pra complicar mais. Enviar link pra redefinir uma nova senha, caso tenha esquecido. O ideal é fazer uma tabela secundária, ou no banco de dados, ou num servidor de cache como Redis. Com um ID único que só pode ser usado uma vez, e aí o ideal é logar o endereço IP da pessoa que clicar no link, pra fazermos auditoria e ver se parece suspeito. Novamente, estratégias de segurança.








Se deixarmos segurança de lado. Usuário é usuário, certo? Tendo nome, email e coisas assim, tá tudo certo? Não. Digamos que o cadastro é pra parte de logística de um ecommerce. Logística precisa de um endereço. Ótimo, basta pedir o endereço. Mas cuidado, uma coisa é endereço de entrega, outra coisa é endereço de cobrança. Pra você, que é iniciante, só deve conhecer o conceito que uma pessoa só tem um endereço, certo?







Mas não. Uma coisa é o endereço de cobrança, pra mandar nota fiscal, outra coisa diferente é o endereço de entrega, pra onde enviar o produto. Eu posso ter endereço residencial, mas posso querer que a entrega seja feita no meu endereço comercial. Mas e se você se mudar de residência? E se você mudar de emprego? Ambos vão mudar. Ou, e se eu quiser comprar e pagar no meu cartão de crédito, mas mandar entregar como presente pros meus pais? Então preciso conseguir cadastrar endereço dos meus pais. Eu deveria criar um usuário separado pros pais? Como faz?







À primeira vista, endereço parecia ser só meia dúzia de campos na tabela usuário. Mas agora deve começar a ficar mais claro que pode ser uma tabela separada de endereços que precisa de uma chave-estrangeira apontando pra chave-primária do usuário. Mas não é só isso. E se meu ecommerce oferece coisas como pontos por fidelidade? Quanto mais eu comprar, mais pontos eu ganho e com isso posso usar como desconto nas compras? Pontos do usuário, ficam na tabela de usuários? Não? Então onde coloca?








Num sistema empresarial maior, usuários podem ter vários perfis, várias visões. Usuário pode ser funcionário da empresa, e aí vai precisar de atributos como número de PIS/PASEP pra coisas como fundo de garantia.  Usuário pode ser um fornecedor ou funcionário de um fornecedor. Fornecedor tem um cadastro separado, CNPJ, número interno de fornecedor. Usuário pode ser consumidor mesmo, daí vai ter pedidos, entregas, suporte. Usuário é um conceito muito mais complicado do que se pensa e num sistema de verdade, raramente é só uma tabela. Vai ser uma coleção de tabelas e classes. Talvez um sub-sistema inteiro separado.







Só pra dar outro exemplo. Falei de carro. Se você é um iniciante fazendo um ecommerce pra uma concessionária ou um concorrente de webmotors da vida, poderia pensar em fazer uma tabela chamada "Carro". Daí coloca atributos como "marca" tipo Volks ou Fiat, modelo tipo Nivus ou Corsa. Ano, combustível, chassi e coisas assim. É o que você conhece vendo o carro dos seus pais. Mas claro, isso tá longe de completo.







E se quiser vender caminhonetes, ou motos, ou vãs? Melhor criar uma tabela mais genérica chamada "Produto" então? Os atributos vão ser mais ou menos os mesmos mas podemos colocar uma coluna de "tipo" pra dizer se é um carro ou moto ou outra coisa. Daí é só ter colunas como preço e já era, certo? Não tá errado, mas não é só isso nem de longe.







Só pra dar um pequeno exemplo: em ecommerces e varejo em geral, existe o conceito de SKUs. Stock Keeping Unit, que é um item distinto de venda, seja de produto ou serviço. É um código alfanumérico. Esse código é importantíssimo pro gerenciamento de inventário, de estoque. Faz de conta, o produto Volks Nivus, tem a versão Comfortline e Highline. A Highline tem 4 cores especiais, 2 cores metálicas, 3 cores sólidas como Preto Ninja ou Branco Cristal ou Cinza Moonstone.







Então o Volks Nivus Highline 2023 Cinza Moonstone tem um SKU único e diferente do Volks Nivus Highline 2023 Preto Ninja. Entende porque? Se você vai na loja, não quer saber se tem o Nivus, quer saber se tem exatamente o Highline 2023 Branco Cristal. Não adianta ter estoque do Preto Ninja, não é ele que você quer. E não adianta ter o Branco do Comfortline, você quer o Highline. O SKU reflete o exato item que você quer.







Mesma coisa com roupa. Ah, tem a camiseta com estampa do Iron Maiden, mas só tem o tamanho M, mas você queria o G. Camiseta Iron Maiden, tamanho M é um SKU e tamanho G é outro SKU diferente. É assim que se modela produtos numa loja. Então, numa tabela de produtos o item que você cadastra não é "Volks Nivus" ou "Camiseta Iron Maiden" e sim "Volks Nivus Comfortline 2023 Vermelho Sunset" ou "Camiseta Iron Maiden tamanho PP".







Mas os problemas só começaram. Porque se você é a Volkswagen, vai ter um sub-sistema separado, a da fábrica, com outro cadastro de Volks Nivus Comfortline 2023 totalmente diferente. Pra manufatura vai ter outros atributos como o BOM ou "Bill of Materials". Precisa de quais peças pra montar uma unidade? Transmissão, injeção, computador de bordo, disco de freio, etc. Cada um desses itens tem estoque, tem fornecedor, tem leilão reverso no setor de compras, tem tempo de entrega pra receber essas peças.







Com tudo isso temos um custo de fabricação. Isso pode, ou não, estar ligado ao sistema de vendas. Primeiro, isso influi no estoque e disponibilidade. E também influi no sistema de precificação. Preço não é um valor único na tabela de produtos, como muitos iniciantes podem pensar. É o resultado de diversos cálculos. Custo de fabricação é só um dos fatores. Tem coisas com impostos. ICMS que é o Imposto sobre Operações relativas à Circulação de Mercadorias e sobre Prestações de Serviços de Transporte Interestadual e Intermunicipal e de Comunicação.







Faz diferença onde o carro é fabricado, pra onde precisa ser transportado, especialmente se atravessa estados. Existem impostos federais, estaduais, municipais. Tem todo um cálculo de impostos que influi no preço final. Por isso costumava ser mais barato comprar carro em Minas Gerais do que em São Paulo, por exemplo, não sei se ainda é, mas lembro que me falaram que por isso muito carro de empresa que aluga, tem placa de Minas. O preço varia por região. Mas não é só isso, tem cálculo de custo de oportunidade, depende da estratégia da empresa. O importante é lembrar que preços não são estáticos, tem diversos fatores.







Beleza, temos o carro fabricado, temos o preço pro consumidor final, a venda foi feita, agora o carro precisa transitar entre a fábrica de São Bernardo Campo até a concessionária em Belo Horizonte. Pra trafegar precisa da nota fiscal. Pra colocar o caminhão na rua, precisa de rotas. De onde eu puxo informação pra rota? Google Maps? Maplink? Sistema proprietário, já que eu sou grande como uma Volks?







E não é só isso. Se queremos implementar sistemas de pagamentos, que lidam com dados sensitivos como números de cartão de crédito e coisas assim, nos Estados Unidos, temos o PCI DSS, Payment Card Industry Data Security Standard que dita como empresas devem proteger esse tipo de informação. E estou falando "Estados Unidos" daí parece que não é seu problema. Mas não se esqueça que hoje empresas são multinacionais. Pode ter empresa que começou no Brasil e agora atua internacionalmente, daí precisa implementar essas normas.







No caso específico de privacidade, segurança de dados de consumidores, na Europa temos o GDPR que é o General Data Protection Regulation da União Européia e no Brasil temos o LGPD, a Lei Geral de Proteção de Dados, que é similar. Enfim, o ponto é que não basta só sair modelando tabelas e jogando em qualquer lugar. Cada indústria tem seus padrões e cada país tem suas regulamentações. Precisa seguir. E pior: não é um checklist simples. Algumas coisas você é obrigado, algumas coisas dá um jeitinho, depende de como lidar com o auditor. Muitas nuances não documentadas.







O mundo real é muito mais complicado do que simplesmente pensar em modelagem de dados da forma acadêmica, onde nos preocupamos com coisas como normalização, se queremos terceira forma normal, ou no caso de DDD se estamos falando de Bounded Context, aggregates, domain events. Ou no caso de Design Patterns, se queremos chain-of-command ou mediator. O que eu falei até agora é parte do que chamamos das tais "regras de negócio" e patterns, arquiteturas, DDD da vida é a "descrição" da implementação dessas regras.







O problema é que se você não entende a regra de negócio, não interessa discutir se vai escolher um Adapter ou um Proxy, se vai organizar na terceira ou quarta forma normal. Se a regra estiver errada, a implementação vai estar errada, independente se seguiu o livro do Eric Evans ou pé da letra. E falando no livro de DDD, logo na introdução ele dá um exemplo interessante de um sisteminha de entrega de mercadorias.






Digamos que temos as entidades Voyage e Cargo, tipo viagem e mercadoria, onde uma viagem tem muitas mercadorias. O Eric descreve um sistema que tem responsabilidade de associar cada mercadoria com uma viagem, gravar e rastrear esse relacionamento. Até aqui tudo bem. Em algum lugar do código vamos ter um método como esse:



```
public int makeBooking(Cargo cargo, Voyage voyage) {
	int confirmation = orderConfirmationSequence.next();
	voyage.addCargo(cargo, confirmation);
	return confirmation;
}
```




Mas porque existem cancelamentos de última hora, uma prática padrão da indústria de entrega é aceitar mais mercadorias do que é possível numa única viagem. É o que se chama de "overbooking". Algumas vezes é usado um percentual simples, como 110% da capacidade, em outros casos tem regras mais complexas.





Isso é uma estratégia básica no domínio de entregas que é conhecido de qualquer empresário dessa indústria, mas normalmente nós, programadores, não sabemos disso. O requerimento que vem pra nós poderia ser algo como "Permitir 10% de overbooking", o diagrama de classes poderia ficar parecido com isto e o código seria atualizado da seguinte forma:



```
public int makeBooking(Cargo cargo, Voyage voyage) {
	double maxBooking = voyage.capacity() * 1.1;
	if ((voyage.bookedCargoSize() + cargo.size()) > maxBooking)
		return -1;
		
	int confirmation = orderConfirmationSequence.next();
	voyage.addCargo(cargo, confirmation);
	return confirmation;
}
```



Ou seja, no código determinamos quanto é o novo máximo com 10% a mais de overbooking e vemos se a mercadoria que queremos adicionar ultrapassa esse máximo. Mas isso cria um problema: agora temos uma regra de negócio escondida, como uma cláusula de guarda, no meio do método da aplicação.





Segundo o Eric, essa regra de overbooking é uma política. Política é outro nome pra um design pattern conhecido como Strategy. Em resumo, esse novo código poderia ser refatorado pra ter uma classe separada de OverbookingPolicy e no método de adicionar a mercadoria na viagem, chamar o método "isAllowed" dessa nova classes, e assim separar a política numa entidade separada, que documenta melhor essa regra em vez de deixar misturada e escondida com o código anterior.



```
public int makeBooking(Cargo cargo, Voyage voyage) {
	if (!overbookingPolicy.isAllowed(cargo, voyage))
		return -1;
	int confirmation = orderConfirmationSequence.next();
	voyage.addCargo(cargo, confirmation);
	return confirmation;
}

class OverbookingPolicy {
	public static double OVERBOOKING = 1.1;
	public boolean isAllowed(Cargo cargo, Voyage voyage) {
		double maxBooking = voyage.capacity() * OVERBOOKING;
		return ((voyage.bookedCargoSize() + cargo.size()) <= maxBooking;
	}
}
```




Agora que eu descrevi dessa forma, deve ter ficado óbvio. "Puts, claro, porque eu não pensei nisso antes". Mas o que quero expor aqui é justamente isso: pra nenhum iniciante é óbvio que isso poderia ser um strategy pattern, provavelmente não era óbvio que isso era uma "Política". Todo mundo ia ter implementado do primeiro jeito e nunca ia pensar nisso. Até o dia que alguém pedisse pra mexer na regra e mudar de 10% pra 5% por exemplo. Daí iam gastar o dia inteiro tentando achar "onde que tá definido isso no código???"






Deixa eu dar outro exemplo pra ilustrar mais esse ponto. Eu gosto de quadrinhos, comics, mangá, até já me arrisquei a desenhar como hobby no passado. Todo mundo que fica empolgado com um One Piece ou Naruto da vida já rascunhou seus personagens preferidos em algum pedaço de papel e, se não for completamente iludido, sabe que saiu uma porcaria. Mas tudo bem, o objetivo era passatempo.






Já percebeu como todo iniciante em arte faz as mesmas coisas? Ou é paisagem de casinha com uma árvore, um sol e uma montanha. Ah sim, com uma chaminé, não pode esquecer a chaminé. Ou é close-up de rosto de anime. Agora, tenta desenhar um quarteirão de uma cidade, com ângulo olhando de cima. Ou tenta desenhar uma personagem de anime mesmo, sentada numa mesa com as pernas cruzadas e tomando um café. Vai sair a coisa mais torta do mundo, se sair.







Desenhar prédios pode parecer fácil, só retângulos, mas tente fazer um. Não vai conseguir. Convivemos a vida toda do lado de prédios, andamos todos os dias na frente de vários, por anos. Mas nunca paramos pra realmente olhar, observar, absorver os detalhes e, mais importante, nunca pensamos porque determinados aspectos de um prédio são tão particulares. Nunca tivemos treinamento formal de urbanismo. Não paramos pra pensar em zoneamento, por exemplo. Certas áreas não podem ter prédios comerciais, certas áreas tem limite na quantidade de andares. Quem mora perto do aeroporto de Congonhas sabe disso.








Por isso quando você tenta desenhar uma cidade, sai parecendo desenho infantil de casinha com sol. Pra ficar realista, precisaríamos ter experiência com urbanismo e arquitetura. Mesma coisa a personagem sentada de pernas cruzadas. A parte que mais chama a atenção de iniciantes são rostos. Por isso perde-se muito tempo só desenhando olhos, e com rostos sempre em posições parecidas, em 3/4.







Pra desenhar um corpo direito precisa estudar anatomia. Todo estudante de medicina no primeiro ano sabe isso, mas pra gente que não é médico, talvez nem fôssemos pensar nisso. Vemos pessoas na nossa frente todos os dias, em todas as posições. Mas quando você parou pra realmente observar uma pessoa? Como o tecido da calça interage com o material da cadeira, como o peso da perna cria dobras, como músculos como o biceps femoral e o soleus se mexem quando dobramos a perna?






Quando falamos de arte, imediatamente pensamos em coisas como a Capela Sistina, o magnum opus de Michelangelo Buonarroti. Contém cenas super detalhadas e difíceis como o Último Julgamento ou a Criação de Adão. É um trabalho de mais de 500 metros quadrados. Sabe quanto tempo levou pra pintar aquele monstro? Quatro anos inteiros, de 1508 a 1512, usando tecnologia do século XVI. 







Entenda, quando Michelangelo começou o projeto da Capela Sistina ele tinha 33 anos. Mas começou a estudar arte desde muito cedo, provavelmente pelos 13 anos de idade e já como discípulo de Domenico Ghirlandaio. Depois estudou escultura sob a tutelagem de Lorenzo de'Medici. Por anos, estudou e produziu pinturas, esculturas e já tinha entregado nada menos que a Pieta e a escultura de David antes da Capela. 







Naquela época, a arte não era estruturada e bem dividida como hoje. A maioria dos grandes nomes como Michelangelo, chamamos de polimatas. Mas eles mesmos não se chamavam de "polimatas", isso é um termo moderno. Só hoje que dividimos que anatomia é mais coisa de médico, lentes e ótica é mais coisa de fotógrafo, urbanismo é mais coisa de arquiteto, pincel é mais coisa de artista. Antigamente não existia essa divisão. Existia o problema e que conhecimentos a pessoa achava que precisava pra resolver o problema. Ponto.







Um artista estudava seja lá o que precisava pra melhorar sua arte. Um bom artista é crítico do seu próprio trabalho. Se ele nota que toda escultura que faz não se parece em nada com uma pessoa de verdade, que escolha ele tem? Vamos lá dissecar corpos de pessoas mortas pra investigar como a pele realmente funciona, como os órgãos influenciam o movimento e assim por diante.






Não existe isso que um artista só precisa estudar cores e pincel. Não existe isso que um programador só precisa estudar algoritmos e código. Um bom profissional estuda o que for necessário pra ser a melhor versão dele mesmo. Pra finalizar. Eu estava refletindo sobre animes outro dia. Já notaram como é muito comum ter várias histórias que se passam no colégio? Romance sempre é romance entre estudantes no colégio. Aventuras sempre são com adolescentes.







Tirando o cinismo de achar que tudo é fetiche, a resposta pode ser  mais simples do que isso. É só um chute, mas a maioria dos desenhistas de mangá começa a trabalhar logo depois do colégio, ou até abandona o colégio. E esses desenhistas fazem tudo: inventam a história e desenham. O que é a única experiência de vida que eles tiveram até esse momento? O colégio.







Você, iniciante que ainda não entrou na faculdade, ou mesmo recém formado, é a mesma coisa. O que você conhece sobre a vida e o mundo? Nada. Sua única experiência foi o colégio, seus únicos amigos foram do colégio, os únicos problemas que teve que resolver eram relacionados ao colégio. Festas, trabalhos, tudo. Aos 20 e poucos anos, seu conhecimento sobre o mundo é minúsculo. 







Parece coisa de boomer dizer isso, mas é verdade: até começar a pagar seus próprios boletos em dia, você ainda é uma criança. Eu já disse isso em outros videos e vou repetir: é impossível ser um empreendedor que vai inovar o ecommerce aos 20 anos. Você nunca trabalhou num ecommerce. É impossível inovar o setor hospilar com 20 anos, você nunca trabalhou como médico. É impossível inovar o setor agrícola com 20 anos, você nunca sequer levantou uma enxada na vida. É impossível inovar qualquer setor com 20 anos, você nunca produziu nada com 20 anos. 







E eu volto a esse ponto porque, pra programadores, temos exatamente esse problema quando discutimos modelagem de bancos de dados, modelagem de orientação a objetos, modelagem de arquiteturas. O que significa modelar? Modelar é representar alguma coisa do mundo real de uma forma abstrata. Mas eis o problema: o que você conhece do mundo real? Quase nada. Não tem como modelar alguma coisa que não se conhece.








Antes que alguém vá nos comentários discordar. Óbvio, eu sei que existem exceções. É por isso que se chamam exceções. Com esse disclaimer feito, vale relembrar porque estou cagando regra nesse assunto. Vamos lá, eu trabalhei em projetos de software de vários tipos de negócios diferentes. Telecomunicações, varejo, manufatura, RH, infraestrutura, agências, grandes corporações, startups. Em 30 anos passei por várias indústrias diferentes e por isso consigo comparar o que cada uma faz de diferente. E mesmo assim não posso dizer que sei tudo. Por isso aviso pra desconfiar de qualquer um que queira ensinar sem nunca ter tido experiências similares.








Professores de faculdade, a maioria, não tiveram essa experiência, mas eles estudaram pra profissão de ensino, fizeram pedagogia, psicologia. Eles foram treinados pra ensinar. Alguns melhores que outros, não importa, mas essa é a carreira. Porém, a grande maioria dos que criam cursos online não tem nem perto da minha experiência e nem perto do treinamento de um professor. Portanto o que tem a oferecer? Quase nada. Eles dependem de caçar material na internet, empacotar como se fossem deles e vender pra você com um discurso que parece convincente e promessas que nunca vão ser cumpridas. 








Veja o exemplo do Michelangelo que falei. Seu primeiro mentor foi Domenico Ghirlandaio. Quem foi ele? Foi um pintor renascentista de terceira geração, especializado em frescos e fez diversos trabalhos importantes, embora não do calibre do seu aluno. Porém, ele reconheceu esse talento e foi ele quem recomendou Michelangelo pra academia de Medici. Parece ter sido um bom professor, que teve ele próprio uma boa carreira, suficiente pra catapultar seu aluno prodígio. 







O ideal é se fosse possível todo aluno ter a possibilidade de ser mentorado por alguém experiente assim. Infelizmente isso não é possível. Não existem mentores suficientes pra todo mundo. Por isso eu digo que o correto, antes de tentar empreender qualquer coisa por conta própria, é iniciar a carreira em empresas de verdade, que tem problemas e soluções de verdade e aprender as outras áreas que não é possível ensinar numa faculdade.







Eu tive vários mentores que nem sabiam que estavam me mentorando. Quando eu tinha que ajudar a resolver um problema de marketing, tive a oportunidade de trabalhar com pessoas treinadas em marketing e entender o básico de como eles pensam. Quando tive que resolver problemas financeiros, tive a oportunidade de trabalhar com pessoas treinadas em contabilidade e finalmente entender coisas cabeludas como impostos. Quando tive que resolver problemas de varejo, tive a oportunidade de trabalhar com pessoas com experiência real em vendas e ver como de fato fechavam negócios. Nenhum curso ensina essas coisas.








O problema de todo programador é que ele assume que a parte mais difícil e mais importante é só a programação, e que todo mundo que não é programador é mais burro que ele. Por isso tem tanta dificuldade de entregar valor. Óbvio, o cliente deveria ter te explicado melhor. Basta o cara do marketing deixar de ser burro e escrever uma especificação melhor que você, o gênio, não precisa perder tempo pensando e pode só escrever seu maravilhoso código em paz.








Falando em ecommerces. Deixa eu dar um exemplo mais concreto. Vou falar de Ruby on Rails porque ainda é a área que eu lembro de mais referências, mas o mesmo exemplo vale pra qualquer outro framework da vida. Um dos primeiros livros que todo mundo que quer aprender Rails usa  é o Agile Web Development with Rails. Originalmente escrito pelo lendário Dave Thomas, mantido atualmente por Sam Ruby. Aliás, excelente nome pro autor de um livro de Rails.







Enfim, o livro é um grande tutorial pra desenvolver um mini-ecommerce à medida que explica como funciona o framework Rails. No fim, temos uma aplicação web que mais ou menos se parece com um ecommerce. Mas lembrem-se, o livro não é sobre como fazer o melhor ecommerce, só em como dá pra usar Rails pra implementar uma versão simples de um. Resolvi procurar no Github e achei o código do que é mostrado no livro, pro Rails versão 6.







Usando a ferramenta Tokei, podemos ver que no final do livro, seu projeto vai ter mais de 100 arquivos de Ruby, quase 2.700 linhas de código. Além de 17 arquivos de javascript que dá mais de 1.300 linhas de código. Fora outras coisas como stylesheets em Sass e um monte de arquivos JSON. Parece bastante coisa né?







Por acaso, no ecossistema Rails existe uma plataforma aberta de ecommerce chamada Spree Commerce. Muito boa por sinal. Eu trabalhei com ela anos atrás e até conheci o autor original Sean Schofield. Na época era um projeto monolítico, mas em anos recentes dividiram em sub-projetos. Inclusive acho que a interface web agora é feita em Next.js e o projeto principal virou mais um servidor de APIs. Vamos ver só esse repositório principal com o Tokei e olha só a diferença: temos mais de 1.300 arquivos de Ruby, mais de 92 mil linhas de código Ruby.








Comparado com o projetinho do livro de Rails, estamos falando de uma diferença de 34 vezes o volume de código Ruby. E isso porque não tem nenhuma lógica de front-end, só a lógica de backend mesmo. Se pegarmos só um arquivo, o da ordem de venda propriamente dita, que ambos chamam de "Order.rb". O do livro é super curto, pouco mais de 50 linhas. No Spree tem mais de 700 linhas e isso porque tem um sub-diretório com outros arquivos que sub-dividem ainda mais a lógica como "address_book.rb" ou "checkout.rb" ou "payments.rb". É ordens de grandeza mais complexo.








Agora vamos fazer uma conta de padeiro. O livro Agile Web Development with Rails tem mais de 600 páginas. Se consideramos que o produto final dele é 34 vezes menos complexo que o backend do Spree. Pra explicar o Spree do zero, o livro talvez tivesse que ter então 20 mil páginas. Tem idéia do que isso significa? Coloca em perspectiva, os 5 livros de A Song of Ice and Fire, que deu origem ao Game of Thrones, male male tem umas 4 mil páginas. Ou seja, precisaria de 5 vezes o volume de Game of Thrones, uns 20 volumes, pra descrever um ecommerce como o Spree do zero.








Deixa eu complicar mais: um Spree é um ecommerce muito bom, mas nem de longe é o mais completo. Um dos mais antigos e populares ecommerces de código aberto é o Magento. Hoje existe o Magento 2. Ele é feito em PHP e rodando a ferramenta tokei, olha só: são 2 MILHÕES de linhas de código PHP. Mais de 200 mil linhas de Javascript. O Magento sozinho, só no javascript, tem o dobro de linhas de código do que Ruby no Spree que, por sua vez, já era 34 vezes maior do que o ecommerce do livro que ensina Rails.







Se em 600 páginas o livro Agile Web Development with Rails conseguiu explicar uma versão simples de ecommerce que dá 2.700 linhas de código de Ruby, sabemos que PHP e Ruby não são equivalentes, mas só por diversão, o Magento, só em PHP é mais de 700 vezes maior. Seriam 700 livros. Seriam 100 coleções de Game of Thrones pra descrever do zero, no mínimo. Conseguem entender porque eu fico tão puto quando alguém me pergunta se tem algum livro que explica tudo? Não tem, é inviável de ter.







E eu vou piorar a vida de vocês. Mesmo um Magento ainda é pequeno se desse pra comparar os repositórios de código de uma Amazon da vida, com todos os seus sub-sistemas internos. O que eu estou dizendo? Entenda essa verdades: você nunca vai saber tudo. É impossível. E isso que eu descrevi é só ecommerce. Vejam meu episódio sobre SAP e seu ERP que tem meia década de idade e roda no coração de toda grande corporação no S&P 500. Lembram? Só no banco de dados são dezenas de milhares de tabelas. Repetindo, dezenas de milhares de tabelas. É impossível saber tudo.







Se alguém ficou desesperado com esses números deixa eu contar o grande segredo: eu, Fabio Akita, nunca li o código do Spree, muito menos do Magento. Já trabalhei em projetos com eles e com outras plataformas proprietárias. Mas nunca li todo o código deles e esse é o ponto: não precisa ler tudo.







Posso estar enganado, mas me dá impressão que muitos iniciantes pensam que quando fazem um curso ou lêem um livro, ou um tutorial, "como fazer seu próprio instagram" ou "como fazer seu próprio Facebook", acham que o código que sai no final já é quase a mesma coisa que o Instagram ou Facebook de verdade, faltando pouquinha coisa. 






Ou, que o ecommerce que fez no fim do curso já é quase o Mercado Livre. Ou seja, muitos tem a noção bem errada que existe um curso ou livro que vai te ensinar 100% do que precisa saber pra fazer um produto de verdade do começo ao fim. Eu estou afirmando que não tem, não existe, e não seria prático ter. Seriam literalmente 700 livros de 600 páginas e nem isso seria tudo. Se você não consegue visualizar 700 livros, se colocados de pé um do lado do outro daria mais de 2 metros. Eu duvido que você vá ler uma fração disso na sua vida inteira. 







Durante todos os videos do canal vim tentando explicar esse conceito. Deixa eu tentar repetir. Quando você faz faculdade de ciências da computação, em nenhum momento vai ter nenhum curso explicando como se faz um ecommerce, ou como se faz um rede social, ou como se faz um aplicativo de fintech, ou de edutech, ou de saúde, nada disso. Você aprende matérias esquisitas, como algoritmos e estruturas de dados, álgebra linear, cálculo, estatística e probabilidade. Mas onde que ensina como fazer um carrinho de compras ou lista de produtos? 







No outro lado do espectro, você pula tudo isso e faz cursos numa Udemy da vida "como fazer seu próprio ecommerce" e sai com uma versão parecida com o do livro Agile Web Development with Rails que eu mostrei. Parece que é melhor, afinal, você fez um carrinho de compras e uma lista de produtos. Só que eu acabei de demonstrar que não é uma fração de projetos de código aberto como Spree ou Magento, na verdade, é de 30 a 100 vezes menor.







Mas eu também disse que ecommerces de verdade, como uma Amazon ou Magazine Luiza da vida, são muito diferentes do que tem num Magento. Então, como faz pra saber? Eis o ponto que eu falei sobre mentoria: você só vai saber como um Magazine Luiza funciona trabalhando dentro do Magazine Luiza. Só tem como saber como um iFood funciona, trabalhando dentro do iFood. Não tem outra forma.






Mas aí não é o problema do ovo e da galinha? Como eu vou conseguir trabalhar num Mercado Livre, se nenhum lugar ensina como eles funcionam? É isso que você também não está entendendo. Quando uma empresa dessas oferece emprego, nenhuma espera que você saiba como elas funcionam. Elas esperam sim, que você tenha um mínimo de ferramentas pra conseguir se adaptar ao sistema deles.







Por isso eu fiz videos analisando os códigos que o Twitter liberou, o código vazado do Twitch ou a arquitetura do Ingresso.com. Se não assistiu, depois assistam. Eu mesmo não trabalhei em nenhuma delas, mas é o tipo de raciocínio que é possível fazer gastando algumas poucas horas, tendo o conhecimento de base. No episódio do Ingresso.com eu falei da arquitetura de filas e salas de espera, que empresas como Amazon e outros utilizam. No episódio do Twitter explico como embeddings de álgebra linear ajudam a resolver o problema de relevância e recomendação de tweets. 








Com a base de estatística e probabilidade, dá pra interpretar dados de monitoramento e chegar em conclusões corretas sobre comportamento dos usuários no site, baseado nos dados de navegação e compra. Com cálculo, dá pra saber como o sistema deveria se comportar, coisas com taxa e velocidade de resposta quando se aumenta o tráfego e quais estruturas de dados podem beneficiar mais certas partes do sistema. Com entendimento de sistemas operacionais e compiladores, dependendo do tamanho da empresa, dá pra trabalhar numa nova linguagem que nem existia, como já aconteceu até em empresas nacionais, como a Totus.








Com essa base, dá pra começar a derivar o resto do conhecimento. Uma vez dentro do sistema é que começa realmente a viver o dia a dia de operações da empresa. A burocracia fiscal, a correria de fulfillment de pedidos nos centros de distribuição, a logística de entrega, o tempo de resposta pra suporte ao cliente, as regulamentações e mudanças em leis que precisam ser refletidas no software. Com o tempo você vai aprender o que em DDD se chama de "domínio". 







O Domain, em Domain Driven Design, só faz sentido se você sabe o que compõe esse domínio. No exemplo que usei no começo do video, saber que SKU faz parte do domínio de inventário, ou saber que checkout faz parte do domínio de pagamento. E isso que eu acabei de falar não é absoluto. Em outra empresa, checkout pode fazer parte de um domínio maior chamado "vendas", ou o checkout é tão complexo que pode ser um domínio por si só. Domínio, as tais "regras de negócio", varia de empresa pra empresa, de projeto pra projeto. Não é uma coisa estática. É uma referência móvel.







Muitos iniciantes se perguntam se deveriam estudar coisas como Design Patterns e DDD logo de cara. E sim, acho que todo mundo deveria ler pelo menos uma vez, por cima, mas com o entendimento que sem experiência real, essa leitura não vai ter muita utilidade. Arquitetura, patterns, domínios, são conhecimentos que emergem naturalmente com experiência. Não é um checklist que dá pra seguir passo a passo em qualquer projeto. Estude uma vez rápido, e mantenha os livros por perto pra consultar pontos específicos, e assuma que seu entendimento inicial vai mudar na terceira vez que ler, na quarta vez que reler.







Se ler só uma vez ou de forma superficial, vai cometer erros que muitos iniciantes cometem. Por exemplo, achar que Bounded Contexts é só microsserviços e resolver tudo com microsserviços. Microsserviço é um estilo de arquitetura, já bounded context é um conceito de design de estratégia em DDD, que delineia as fronteiras onde um model em particular é definido e aplicável. Você pode ter bounded context num monolito simplesmente usando namespaces e módulos, por exemplo.







Ou então achar que DDD é basicamente só Event Sourcing e CQRS ou Command Query Responsability Segregation. Algumas partes do sistema podem realmente se beneficiar de um sistema de eventos imutáveis ou separação de escritas e leituras nos modelos. Em outros lugares vai ser overengineering. Não se aplica tudo de DDD em todos os lugares. Como diria Jack Sparrow, é mais um guideline.







Mesma coisa com Design Patterns ou qualquer outro livro de arquitetura. Não é pra usar tudo que se estudou em todo lugar. Saber onde usar é mais importante do que saber como usar. Uma vez que se descobre onde, o como é fácil. Muito antes de entrar nesse tipo de discussão, comece pelo básico que já falei antes: quantas vezes você já tentou baixar e rodar um Spree ou Magento ou um simples Wordpress?







"Ah, mas eu sou de Python, não mexo com PHP". Então você é só um idiota. Porque fazer um Magento rodar não é só um problema de PHP, é subir banco de dados. Um postgres não é específico de PHP, em Python também precisa. Precisa subir um NGINX ou Apache. Numa aplicação web de Python também. Precisa saber onde e como guardar segredos como credenciais. Precisa saber como subir servidores de cache, como Memcache. Nada disso é específico de PHP. Toda aplicação web, em toda linguagem, usa os mesmos componentes. Porque você está querendo discutir patterns e arquiteturas se sequer consegue subir uma aplicação na sua própria máquina?








Apesar de um Magento da vida não se parecer com um Mercado Livre, os componentes e arquitetura geral é familiar. Não as linhas de código específico, mas os componentes gerais de infraestrutura, os conceitos de protocolos, redes, sistemas operacionais, configuração e tudo mais. Não é perda de tempo fuçar projetos como esses e nem mesmo as versões mais simples de tutoriais ou cursos, o meu ponto é garantir que vocês entendam que nunca vão ensinar tudo, mas como primeiro passo, tá mais que bom.







Outra coisa importante: um Magento tem 2 milhões de linhas de código hoje. Graças ao poder do Git, que mantém o histórico de tudo, posso facilmente voltar ao passado, pra versão 0.1.0 alpha 89, de agosto de 2014, quase 10 anos atrás, com o comando "git checkout -b teste 0.1.0-alpha89". Daí podemos rodar a ferramenta Tokei de novo e olha a diferença, ele tinha mais ou menos a metade do tamanho de hoje, menos de 1 milhão de linhas de código PHP. 







Podemos voltar pros primeiros commits, do final de 2011, começo de 2012. Não conheço toda a história do projeto. Pelo pouco que puxei no Google, parece que o Magento 1 foi criado em 2007. Uns 4 ou 5 anos depois a comunidade começou o Magento 2, por volta de 2011 a 2012. É o que os primeiros commits indicam, e a primeira versão estável só foi sair mesmo em 2015. Pelo que entendi, o Magento 2 foi um esforço homérico pra modernizar a plataforma.








De qualquer forma, o código inicial que serviria de base pro Magento 2 já tinha nada menos que meio milhão de linhas de código PHP. Comparado com hoje, é "só" um quarto do tamanho. Mas é pra dar uma noção. Levou de 2007 a 2012 pra chegar nesse meio milhão e depois quase 10 anos mais pra chegar nos 2 milhões de linhas de código de hoje. O projeto tem milhares de contribuidores. Não é um projeto que você vai varar um fim de semana e fazer igual.







Mas o importante é entender que todo projeto tem um dia 1 com zero linhas de código. Todo projeto de código aberto, todo grande site como uma Amazon ou Mercado Livre. No dia 1, todo projeto realmente se parece mais com o nível de código que mencionei dos tutoriais. Mas eles não ficam parados. Vão sendo testados no mundo real, feedback de usuários de verdade vão chegando, o código vai sendo moldado às necessidades do mundo real, 10 linhas se tornam 1000, que se tornam 1 milhão de linhas, ao longo de mais de uma década. E até hoje, o Magento não "acabou", toda semana tem atualizações, novos commits.








Ao longo desse caminho, o Magento, que foi originalmente criado por uma empresa chamada Varien Inc depois virou uma entidade própria. Por volta de 2011 parece que o eBay entrou em cena e adquiriu uma parte da empresa, com objetivo de integrar com o Paypal. Mas em 2015, eBay e Paypal se tornaram duas entidades separadas e o Magento também foi separado. Daí entra a Adobe em 2018 que adquire a empresa. Hoje ela faz parte do Adobe Experience Cloud e pra contribuir no projeto você precisa assinar um acordo de Licença de Contribuidor. 








Eis outro exemplo de como o software foi sendo adaptado pra responder a essas ações externas. Em 2007, ela não foi planejada pra fazer parte da plataforma da Adobe. O cloud da Adobe nem existia nessa época. Ninguém sabia que no meio do caminho ela iria desviar pra dentro do eBay e Paypal e nem que iria se separar poucos anos depois. O software vai se adaptando a tudo isso. A mesma coisa acontece com a plataforma de toda grande empresa. É assim que aos poucos vai virando um repositório de milhões de linhas de código. Nada disso é planejado com antecedência.








Modelagem é uma das respostas a esse tipo de coisa. Em algum momento, a prioridade talvez tenha sido Paypal. Em outro momento a prioridade passou a ser Adobe Cloud. Prioridades de desenvolvimento também ditam a arquitetura e arquitetura dita a modelagem. Modelagens que faziam sentido em 2011 provavelmente não fazem mais sentido em 2018. Entendam isso: software nunca está "pronto" ou "finalizado". Se ele faz sucesso, é um trabalho constante de adaptação e evolução. Modelagem e arquitetura tem que ser respostas a essas evoluções. Elas emergem do software.








Todo livro, tutorial ou curso, vai simplificar isso. Não é um defeito, é uma limitação do pouco tempo. Como ilustrei até aqui, se tentar documentar tudo, precisaria fácil de centenas de volumes de livros. Ninguém ia conseguir estudar tudo isso. Nenhuma das técnicas de nenhum livro de DDD ou Design Patterns tem as respostas do que fazer em cada um desses grandes episódios. Elas servem de base pra adaptação, mas não tem nenhuma resposta pronta pra nenhum problema de negócios. 








Do meu ponto de vista, eu diria que livros DDD ou qualquer outro de modelagem e arquitetura servem pra nos dar um vocabulário pra tentarmos nos comunicar. Tudo é abstrato em software. Não temos parâmetros físicos que todos conseguem concordar, como peso, volume, ou qualquer coisa assim. Software se chama software porque não é "hard"ware.






Uma simples classe de pagamento pode significar coisas extremamente diferentes pra programadores com experiências diferentes. Então tentamos racionalizar e normalizar esses conhecimentos via um vocabulário de modelagem e arquitetura pra começarmos a dar passos em busca de algum consenso, em algumas partes.







Pra não ficar só na filosofia, agora eu queria falar especificamente de alguns livros que acho que podem ajudar um pouco. Novamente, não são livros pra ler de cabo a rabo de uma só vez, e nem só uma vez. São livros pra se estudar um capitulo que tenha um assunto que te interessa no momento, voltar quando tiver mais experiência nesse assunto, e durante sua vida profissional ou acadêmica, quando esbarrar nos outros assuntos, vá indo um capítulo de cada vez.







Eu mesmo não conhecia esses livros até pouco tempo atrás, quem me recomendou foi meu sócio Talysson, que é responsável pelo programa de mentoria da minha empresa, ele mesmo um excelente programador. O primeiro livro se chama The Architecture of Open Source Applications. Ele é dividido em dois volumes. Cada capítulo é como se fosse um artigo sobre um projeto de código aberto escrito pelo próprio autor ou alguém bem experiente e reconhecido.







Por exemplo, o capítulo 11 do primeiro volume é sobre LLVM, que eu já expliquei em vários videos aqui do canal, como no video da Apple e GPL. E o autor desse capítulo é ninguém menos que Chris Lattner, um dos melhores engenheiros dos últimos 20 anos. LLVM tá por trás de todos os compiladores e transpilers modernos incluindo shaders de GPUs e programação de tensors pra IA. 






O capítulo em si é super introdutório. Se você assistiu meu episódio  e outros como o de compiladores versus interpretadores, a maior parte tá lá. Ele não explica tudo, nem explica em detalhes, mas é um bom capítulo pra quem nunca parou pra ler nada sobre o assunto. A intenção é que cada autor explique porque tomou certas decisões de design do software em que trabalhou. Coisas que hoje achamos óbvio, mas que pra época não era tão óbvio assim.







No volume dois, capítulo 14 temos o projeto NGINX, que eu também já falei várias vezes em episódios como Tornando sua App Web mais Rápida. O autor é Andrey Alexeev, um dos co-fundadores do NGINX. E de novo, é um capítulo bem curto, onde ele fala o óbvio: porque alta concorrência é importante, ou porque não usar Apache. Hoje, é óbvio, mas 20 anos atrás não era e ele explica porque o NGINX foi feito da forma como conhecemos hoje.







No capítulo 18 do volume II encontrei um nome conhecido. Luke Kanies, um dos criadores do Puppet. Hoje em dia, quando falamos de infraestrutura como código, lembramos de Kubernetes, Terraform, ou Ansible, mas Puppet foi um dos precursores, quando codificar infra não era óbvio. Eu entrevistei ele pro meu blog em 2009, vou deixar o link nas descrições. 





Já no capítulo 15 do volume 1, outro nome conhecido, Francesco Cesarini. Todo mundo da comunidade Erlang e Elixir conhece esse nome, um excelente educador e evangelista. E foi num workshop dele que eu tive meu primeiro contato com Erlang, também em 2009. Você também pode ter seu primeiro contato com ele nesse capítulo. Enfim, todos os autores desses livros são excepcionais. Eu seria feliz de ser uma fração de qualquer um deles.







O terceiro livro dessa série é o The Performance of Open Source Applications. É o mesmo formato, cada capítulo com um autor que é reconhecido no assunto, mas focado na parte de performance. Logo no primeiro capítulo temos Ilya Grigorik falando sobre alta performance de rede no Chrome. Ilya é outro conhecido de longa data da comunidade Ruby, que eu trouxe pra RailsConf Brasil 2009. Daí ele foi pro Google, hoje está no Shopify e ensinou nossa comunidade sobre métricas, como medir, as melhores ferramentas, quais as prioridades de otimização, e ajudou a definir muito dessa área de performance junto com a W3C. Todo desenvolvedor web deveria ler alguns dos artigos dele sobre performance.







O quarto e último livro é um pouco mais prático e pode servir pra vocês se exercitarem em linguagens diferentes. Se chama "500 Lines or Less", cujo objetivo é desenvolver uma mini aplicação em 500 linhas ou menos. Por exemplo, no capítulo 19, Audrey Tang nos ensina a fazer uma mini planilha, tipo Excel, com Angular.js. Ou Allison Kaptur que ensina a fazer um mini interpretador de Python, em Python. Se estava procurando exercícios, vale explorar esses capítulos. De novo, nenhum deles é uma aplicação completa de verdade, só os princípios pra quem nunca parou pra pensar "hm, como eu faria um servidor web simples do zero?", esse é o capítulo 22.








Eu não procurei mas acho que nenhum desses livros tem em português. Mas neste site, que vou deixar o link na descrição abaixo, tem tudo gratuito online. Basta abrir seu navegador e começar a explorar. Eu deixaria uma aba permanente só pra ela, pra não se esquecerem de voltar de tempos em tempos. Como disse antes, não é pra ler tudo de uma só vez. Em particular, o "500 Lines or Less", é pra abrir um editor de texto e realmente tentar codificar, senão não vai servir pra nada. Alguns capítulos vão usar linguagens que talvez nunca tenham tentado, como Clojure. É uma boa desculpa pra experimentar. E mesmo se não gostar, outro bom exercício é repetir o mesmo exercício em outra linguagem. 








Todos os livros eu diria que são adequados pro nível junior até pleno. De pleno pra senior, diria que são textos fáceis. E mesmo assim talvez tenha assuntos que vocês não tenham parado pra estudar ainda. Por exemplo, no volume 1 do The Architecture of Open Source Applications, o Russel Bryant fala do lendário Asterisk. Se nunca trabalhou em projetos de voz sobre IP, antes de existir coisas como Zoom ou Google Meet, talvez nunca tenha ouvido falar. Mas muita gente ainda usa. É tipo um PBX digital. Eu mesmo nunca mexi pessoalmente, mas trabalhei próximo de projetos que usavam, então é um pouco familiar pra mim. Só porque uma pessoa é considerada sênior numa coisa, não quer dizer que é sênior em tudo. Em Asterisk eu não sou mais que um junior.









O maior problema no estágio inicial é que você não sabe o que não sabe. Livros como os que recomendei e projetos de código aberto, como um Magento da vida, são ótimas portas de entrada pra molhar os pés e começar a se familiarizar com código mais complexo e mais real do que tutoriais ou cursos. Não tem nenhum problema aprender via cursos, mas não fique obcecado em achar que quantidade de tutoriais ou cursos vai determinar sua qualidade. Porque não vai. Depois de um certo ponto, sem experiência, você vai estagnar ou pior, só ter a ilusão que está aprendendo. E experiência não é só no trabalho. Você nunca vai parar de estudar e nunca vai saber tudo. Essa é a carreira.








Pra saber se aprendeu mesmo, precisa contribuir código em projetos. Primeiro em exercícios sozinho na sua própria máquina, depois, se possível, em projetos de código aberto mais simples, ou já direto em projetos fechados de empresas. Se puder escolher, escolha empresas que tem desenvolvedores sêniors em quem se espelhar, idealmente que podem te mentorar. Mentorar não é professor e aluno, onde você como aluno fica passivo só esperando alguém te ensinar alguma coisa. É se virar pra fazer e alguém te dar orientação e feedback. A melhor coisa é alguém apontar o que você fez de errado quando achava que não tinha nada errado. Ou seja, apontar o que você não sabia que não sabia.








E tire da cabeça que só tem valor conseguir emprego numa empresa de nome grande como Amazon. Não. Qualquer empresa que tenha software é oportunidade de aprendizado. Não importa se o software é "legado", antigo. Você nunca programou nada real. Não importa se é na lojinha da esquina ou no Magazine Luiza. Todo software é software. Basta não ficar 20 anos no mesmo lugar, fazendo a mesma coisa. Mas também, menos de 1 ano não é proveitoso. Tem que ter um período pra aprender tudo que puder aprender, em particular, tudo que você ainda não sabe que não sabe.







Como disse lá no começo, esse episódio poderia ser um pouco frustrante. Porque não tem uma resposta simples pra dizer como aprender a modelar, ou decidir arquiteturas, ou fazer um bom design de software. Sua versão 1.0 de tudo vai ser sempre ruim, e isso não é um defeito, é simples falta de experiência. À medida que se trabalhar em empresas ou participar de projetos de código aberto e se exercitar mais, os gaps de conhecimento vão ficando aparentes. E você vai começar a finalmente entender o que não sabe, pra conseguir ir atrás de saber.








A idéia não era tentar dar uma resposta definitiva, só abrir os conceitos pros iniciantes terem uma noção melhor do que tem pela frente. E o conceito principal é que você nunca vai saber o que é um "bom software" sem antes fazer muito mau software e lidar com mau software dos outros. Não existe um checklist que define todas as características de um bom software. Bom é relativo ao que se espera daquele software. E tudo que chamamos de modelagem ou design, são meros vocabulários pra tentar descrever essa abstração que chamamos de software. Se ficaram com dúvidas, mandem nos comentários abaixo. Se curtiram o video deixem um joinha. Assinem o canal e não deixem de compartilhar o video com seus amigos. A gente se vê, até mais.
