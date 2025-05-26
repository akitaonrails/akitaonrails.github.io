---
title: "[Akitando] #7 - A Controvérsia da Lerna vs ICE"
date: '2018-09-04T11:00:00-03:00'
slug: akitando-7-a-controversia-da-lerna-vs-ice
tags:
- lerna
- javascript
- ice
- palantir
- gpl
- agpl
- mit
- bsd
- copyright
- copyleft
- akitando
draft: false
---

Disclaimer: esta série de posts são transcripts diretos dos scripts usados em cada video do canal [Akitando](https://www.youtube.com/channel/UCib793mnUOhWymCh2VJKplQ). O texto tem erros de português mas é porque estou apenas publicando exatamente como foi usado pra gravar o video, perdoem os errinhos.


<iframe width="560" height="315" src="https://www.youtube.com/embed/WObC_2e0kZk" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>


### Descrição no YouTube

Semana passada aconteceu uma pequena controvérsia no mundo Javascript quando um colaborador do Core Team da Lerna decidiu mudar a licença de uso do projeto para proibir colaboradores de empresas como Palantir, Microsoft de usar o projeto.

Vamos entender exatamente o que significa isso.

Seguem os links para este episódio:

* Lerna project (https://lernajs.io/)
* Pull Request 1616: (REVERTED): Add Text to MIT License banning ICE collaborators (https://github.com/lerna/lerna/pull/1616)
* Pull Request 1633: chore: Restore unmodified MIT license (https://github.com/lerna/lerna/pull/1633)
* Eric Raymond: Non-discrimination is a core value of open source (http://esr.ibiblio.org/?p=8106)

* The Cathedral and the Bazaar (http://www.catb.org/esr/writings/cathedral-bazaar/)
* The Open Source Definition (https://opensource.org/osd-annotated)
* Free Software Foundation (https://www.fsf.org/)
* Choose an open source license (https://choosealicense.com/)
* AkitaOnRails: [Off-Topic] Software Livre: Exercício de CAPITALISMO (http://www.akitaonrails.com/2016/04/22/off-topic-software-livre-exercicio-de-capitalismo)
* Eclipse CPL to EPL Transition (https://www.eclipse.org/legal/cpl2epl/cpl2eplfaq.php)

## Script

Olá pessoal, Fabio Akita

Mudando completamente de assunto de blockchains e Coréia, vamos falar um pouco de software, mais precisamente, sobre licenças de software e algumas coisas que talvez vocês ainda não saibam.

Me deu vontade de falar um pouco sobre isso por causa da recente controvérsia do projeto Lerna, que se descreve como uma ferramenta para gerenciar projetos javascript num repositório com múltiplos pacotes, um monorepo.

E o assunto em questão foi a recente tentativa de radicalmente mudar a licença do software pra restringir o uso de empresas como Palantir ou Microsoft, que de alguma forma estão ligados com a controvérsia da ICE, a US Immigration and Customs Enforcement. Eu sempre fui favorável a não existir políticas restritivas e punitivas de fronteiras, especialmente a que está em discussão agora nos Estados Unidos.

(...)


Eu não quero entrar no assunto de política internacional. Deixo isso para quem tem experiência no assunto, eu certamente não tenho.

Mas eu certamente tenho experiência com software e licenças e quero ajudar os desenvolvedores a entender o que significa esse episódio.

O ponto em questão foi a abrupta decisão do contribuidor do core team do Lerna, Jamie Kyle em fazer um pull request que edita a licença MIT que a Lerna usa e adicionar cláusulas restritivas e retroativas, literalmente excluindo o uso pelas empresas Palantir, Microsoft, Amazon, Ernst & Yount, Thomson Reuters, Deloitte, Johns Hopkins University, Dell, Xerox, Canon, Linkedin e algumas outras.

Esse assunto apareceu no canal de chat da minha empresa. A gente discute assuntos assim de vez em quando, o que é bem legal. Nem precisei saber a motivação (se é ICE ou o que for), na hora eu já respondi que isso não rolar. Não precisa ser gênio pra saber isso.

E de fato, no dia seguinte, o pull request foi revertido por outro líder do projeto, Daniel Stockman, e o Jamie Kyle foi banido do projeto, citando episódios anteriores que ele fere o código de conduta do projeto. Ironicamente código de conduta que o próprio Jamie adicionou ao projeto.

E porque eu imediatamente já sabia que isso ia acontecer? Vamos entender.

Se você cria código e libera esse código num repositório público, ele ainda é SEU código. Não só código. Quando você faz um trabalho criativo, o trabalho está automaticamente sob seu copyright. A menos que você inclua uma licença, NINGUÉM pode copiar, distribuir, ou modificar seu trabalho sob o risco de tomar um processo.

Agora, à medida que o trabalho tem outros colaboradores esse NINGUÉM inclui você.

Na prática, se você colocar o seu projeto no GITHUB você já concordou com termos de uso dele, dizendo que seu projeto é automaticamente liberado para visualização por qualquer um e portanto passível de sofrer FORK. Qualquer um no GITHUB pode fazer FORK do seu projeto e modificá-lo a partir desse ponto dependendo da licença.

Copyright é um direito legal que, por um certo período de tempo, lhe dá a autonomia de decidir o que fazer com seu próprio trabalho. Aliás, você é responsável por enforçar esse copyright. Independente do que você quer, você, criador, detém esse direito.

Na prática, se você um dia ver um software sem nenhuma licença, passa longe dele! Você está assumindo um risco desnecessário se usar um software sem licença, especialmente se adicionar seu próprio código em cima disso. Se escolher usar mesmo assim, você foi avisado.

Agora, você pode fazer o que quiser com esse direito, incluindo jogar totalmente fora. Se é isso que você quer, você pode usar um Unlicense, que é basicamente abrir mão do direito e torná-lo public domain. A partir daqui é terra de ninguém, qualquer um pode fazer qualquer coisa.

Normalmente o que se faz é: você retém o direito do copyright, mas adiciona uma licença que permite o uso. A licença define o que se pode fazer com esse software e dá garantias aos usuários sobre o uso, cópia, modificação e distribuição.

Agora, você pode escolher uma licença permissiva, ou seja, que dá total liberdade aos usuários ou uma licença restritiva, ou seja, que restringe as liberdades do usuário.

Licenças como MIT ou BSD são permissivas, e é por isso que muitos usam. Dentre as liberdades, a mais importante é que você pode lançar como um produto comercial sem liberar o código fonte modificado.

Licenças como GPL e AGPL são bem restritivas, e essas as empresas precisam passar longe se não souberem com o que estão lidando. Muitos chamam esse tipo de licença de um vírus porque ele se propaga a toda modificação que você fizer e você é obrigado a liberar o código fonte modificado e não pode distribuí-lo comercialmente sem soltar esse código junto. GPL v3 e AGPL são particularmente nefários nesse aspecto. AGPL é feito para quebrar o truque dos Software as a Service.

Num SaaS você pode usar um software GPL v2 (versão 2) mas não precisa liberar o código fonte porque você não está distribuindo o software. Você está liberando acesso à execução do código modificado através de APIs. Então os seus usuários não usam diretamente o código. Pois bem, o AGPL diz que mesmo nesse caso se alguém usa o seu software GPL modificado através da rede, você precisa liberar o código fonte.

Outra forma de burlar o GPL, no caso o GPL v2 é o que ficou conhecido como Tivoização. Tivo é o avô de hardwares como Apple TV ou Google Chromecast. A Tivo usa Linux e outros softwares que são licenciados com GPL v2. Eles liberam o software conforme a licença, mas o hardware é bloqueado e não deixa rodar outro binário que possa ser verificado via assinatura digital, então na prática você tem o código mas não pode rodar no hardware. O povo do Richard Stallman ficou bravo com isso e foi o que levou ao GPL v3 que permite uso de assinatura digital para propósitos de segurança mas evita cenários como a Tivoização.

Uma das consequências disso é a eterna rixa entre o povo do BSD, mais especificamente o FreeBSD que, apesar de não usar a kernel do Linux, usa outros componentes como o compilador GCC. A filosofia do BSD é ser o mais livre possível e eles nunca gostaram muito do GPL v2 por restringir a liberdade dos usuários. A kernel do Linux permaneceu em GPL v2 mas quando componentes como GCC foram migrados para v3 o povo do FreeBSD resolveu levar a sério sair do gcc e foi quando começaram a usar CLang/LLVM no lugar.

BSD, como vocês sabem é a base do Darwin que é a fundação do MacOS e iOS. É uma das razões de porque a Apple investiu tanto em LLVM. Hoje em dia eles também usam somente Clang/LLVM em vez de GCC, e isso acabou gerando frutos possibilitando uma arquitetura flexível e mais moderna e facilitou a invenção da linguagem Swift. Mas isso é tema pra outro episódio.

Como vocês podem ver, licenças é um assunto bem cabeludo. Mas no coração de tudo isso está a história de Richard Stallman e a Free Software Foundation (FS) e a história da Open Source Initiative (OSI) de Eric Raymond, autor do famoso livro The Cathedral and the Bazaar. Esse é o livro que torna famoso a Lei de Linus que diz “dados olhos suficientes, todos os bugs são superficiais”.

Parece a mesma coisa, mas Free Software não é Open Source Software. Open Source é naturalmente mais difundido hoje porque ele é ironicamente mais Free do que o Free Software Foundation, já que é mais amigável a empresas. A Free Software tem a visão mais "pura" da liberdade do software mas restringindo as liberdades das pessoas. O Free da FSF é manter o software Free, o Free da OSI é garantir as liberdade do uso do software - que incluir a liberdade de fechar o software. Ambos estão certos no abstrato. Eu sempre compartilhei da filosofia da FSF mas eu sei como ela não é tão prática no mundo real comparada à OSI.

Muita gente usa free e open source software. Vocês precisam no mínimo ler os textos que explicam a filosofia GNU no site gnu.org e ler os textos de Eric Raymond.

Free e Open source não deve ter nenhuma conotação política. Política necessariamente define e discrimina grupos. Eric Raymond inclusive criticou sobre o episódio da Lerna dizendo que a Lerna deserdou da comunidade open source e deveria ser evitado por qualquer um que valorize a saúde da comunidade. Ele continua dizendo que a escolha do projeto Lerna destrói uma das normas mais profunda que mantém a comunidade open source funcional: manter política separado do trabalho. Leia o blog post do Eric no link que deixei na descrição do vídeo abaixo.

Na página que define Open Source no site da OSI existe a 5a cláusula: Não discriminação contra pessoas ou grupos. Você jamais pode dizer que é pró-diversidade se você age ativamente para discriminar grupos. E aqui vem o problema: não importa quais grupos, quer você concorde com eles ou não. 

Uma frase erroneamente atribuida a Voltaire mas que na verdade foi da escritora inglesa Evely Beatrice Hall que eu uso no cabeçalho do meu perfil do Facebook diz: “Eu discordo do que você diz, mas eu vou defender com minha vida o seu DIREITO de dizer isso.”

É muito fácil dizer "somos inclusivos". Ser inclusivo só com seus amigos ou grupo próximo é fácil. Você só sabe se é realmente inclusivo se você tolera alguém que você odeia. Se não conseguir isso, você é, por definição, discriminatório. É muito fácil se auto intitular altruísta, o verdadeiro altruísta primeiro não busca reconhecimento e está disposto a ajudar até mesmo aquele que ele sabe que não o ajudaria. Fora disso você não é nem inclusivo e nem altruísta, está apenas trocando uma boa ação por auto promoção.

E tudo bem, não existe nenhuma lei dizendo que você precisa fazer isso. Você tem o direito de se auto promover. E sabendo disso, para trabalhar em grupos numa comunidade ou na sociedade, você precisa aprender a separar sua ideologia fast-food ou política da moda e o seu trabalho. E pior: tentar fazer ativismo em torno de uma causa que parece justa, fazendo uma ação que é injusta, discriminatória e sequer legalmente válida - ou potenticialmente ilegal é ERRADO. Não se corrige um mal fazendo outro mal, NÃO IMPORTA a intenção. Ou você respeita a lei, ou você não é diferente de quem está criticando, é assim simples. Não existe “ah mas ele fez pior”. Um mal grande ou um mal pequeno, ambos são maus.

Free e Open Source NÃO é um movimento político. Ele não foi feito pra ser usado pra ativismo. Ele não foi feito pra ser usado como instrumento político. Ele não tem conotações sociais. Os desenvolvedores, fora do código, fora do projeto, deveriam ter total liberdade para fazerem o que quiserem, se quiserem ser pró-Trump ou anti-Trump, pró-ICE, ou anti-ICE, não é da conta de ninguém. Por isso eu não gosto da forma como códigos de conduta tem sido usados para ligar a vida pessoal de alguém com sua colaboração.

Colaboração no mundo open source é voluntário. É uma troca justa. Você investe seu tempo e conhecimento construindo partes de um software. Quanto mais o software se torna famoso, mais seu investimento tem um retorno. As empresas podem usar o software com menos custos de manutenção do que se eles tivessem que fazer tudo do zero dentro de casa, então investir em open source também tem retorno de investimento. Open source é um exemplo real de livre-mercado em funcionamento. Só porque um projeto se torna open source, isso não garante seu sucesso, tanto quanto abrir uma empresa não garante que você vai ficar rico. É um ambiente de seleção natural e sobrevivência do mais adaptável.

O mundo open source, ao contrário do que a maioria pensa, é um dos melhores exemplos de livre mercado capitalista pra lidar com softwares que são commodities. Acredite: todo software que não é commodity, não tá aberto ao público.

As licenças de software garantem o uso, modificação e distribuição. A propriedade do projeto, é dos colaboradores.

Você pode mudar uma licença. Mas pra isso precisa colher a autorização de todas as pessoas que já colaboraram com seu projeto. E não se trata de conseguir 51%, precisa de 100%, não importa se a pessoa fez só um commit mudando uma única linha. Ou você valoriza a contribuição de todo mundo ou você não valoriza ninguém. Não existe "a maioria decide e a minoria cala a boca". Se fosse assim, open source não existiria como é hoje.

Quando o projeto Eclipse mudou sua licença do CPL para EPL ele levaram mais de um ano pra conseguir todas as aprovações e isso tendo sido bem organizados nesse trabalho.

Achar todas as pessoas pode ser difícil. Conseguir consenso é mais difícil ainda. Talvez você precise remover o código daqueles que não concordaram.

E isso é pra realizar a mudança da licença. Mas mesmo assim, mudanças de licença não são retroativas. Se você deu a licença de uso, você Não pode removê-la no passado. Só pra novos usuários, e só pra novas versões. Senão eu estou retirando direitos que eu dei aos primeiros usuários, se eu fizer isso, qual o propósito de se ter uma licença em primeiro lugar? E que tipo de mal caráter eu estou me tornando se acho que isso é certo? Ah mas a intenção era boa. Não importa. Não é relevante. Você deu uma licença ao usuário que confiou e colaborou no seu software, agora você quer tirar isso dele para comprar a sua consciência frente a um assunto que importância pra você mas pode não ter pra todo mundo. Isso se chama egoísmo. E o assunto em questão eu só vejo de uma forma: criancice e desperdício de talento. Uma pena pois parece que o Jamie costumava ser um bom contribuidor. 

Isso tudo que eu acabei de falar é óbvio. Deveria ser óbvio. Deveria ser ainda mais óbvio se você um contribuidor de um Core Team de algum projeto. Um adulto não pode dizer "eu era ignorante da lei".  Você não pode assaltar um banco e dizer "puts, eu não sabia que não podia assaltar um banco". Ignorância da lei não o torna isento da lei. É SEU direito não se interessar em saber da lei, mas a lei existe independente do que você acha e ela se aplica IGUAL pra todos, independente das suas convicções.
De qualquer forma, o episódio deu uma repercussão mais porque a mídia está toda alvoraçada em torno esse negócio da ICE. O dano foi revertido, mas no frigir dos ovos o projeto e a comunidade ao redor dela foi muito prejudicada por causa de uma ação imatura e impensada. Fica o exemplo. 

O assunto de licença, ética, leis direitos é super longo e daria pra fazer uma série inteira, então vou parar por aqui. Espero que este episódio tenha aberto um pouco mais a cabeça de vocês se ainda não sabiam dos conceitos que eu disse aqui. O principal: de boas intenções o inferno tá cheio. Crianças, fiquem longe de confusão! Não vale a pena!

Coloquei links na descrição do vídeo. Contribuam com feedback na seção de comentários abaixo, se gostaram dêem um joinha, não deixem de assinar o canal e clicar no sininho para não perderem os próximos episódios! A gente se vê na próxima! Até mais!


