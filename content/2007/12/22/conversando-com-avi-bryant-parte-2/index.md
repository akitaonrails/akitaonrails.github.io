---
title: Conversando com Avi Bryant - Parte 2
date: '2007-12-22T20:13:00-02:00'
slug: conversando-com-avi-bryant-parte-2
tags:
- interview
draft: false
---

**For english-speaking readers, click [here](http://www.akitaonrails.com/2007/12/22/chatting-with-avi-bryant-part-2) for the original version**

Se ainda não leu, dê uma olhada na [Parte 1](/2007/12/15/chatting-with-avi-bryant-part-1) onde conhecemos mais sobre Avi Bryant e seu incrível produto [Dabble DB](http://www.dabbledb.com). Nesta **Parte 2** Avi elabora um pouco mais suas opiniões e pontos de vista acerca de tecnologia. Uma leitura muito inspiradora para todo programador.

Como sempre diso – e Avi é competente em apontar -, Ruby tem seus problemas – muitos sendo melhorados no Ruby 1.9, JRuby e Rubinius. Avi nos dá boas razões de porque Smalltalk é mais uma grande plataforma para se aprender, trazendo décadas de evolução e maturidade. Então, aqui vai, a versão completa da entrevista.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/19/539949594_f012918cd3.jpg)

E fiquem ligados! Espero ter Evan Phoenix, Hal Fulton, Peter Cooper e Adrian Holovaty como meus próximos convidados. Muito material para começar 2008 em grande estilo!


 **AkitaOnRails:** Algumas pessoas tentam fazer o caso a favor de Smalltalk como sendo _“a linguagem OO mais pura_. Mesmo isso sendo um fato, você acha que esse motivo apenas é suficiente para criar um caso com todas as outras linguagens, como Ruby que é meio que uma linguagem multi-paradigma? Espero que você não seja ‘chato’ sobre ‘pureza de linguagem’ :-)

**Avi Bryant:** Na realidade, eu sou chato sobre isso – não de um ponto de vista acadêmica ou estético, mas pragmático. Linguagens ‘puras’ tornam muitas coisas mais fáceis: ferramentas de desenvolvimento, VMs e infraestrutura como sistemas de objetos distribuídos ou persistência transparente, tudo fica mais simples e melhor quando se tem uma linguagem pequena e consistente.

Uma experiência que eu tive, por exemplo, foi ser contratado para portar minha biblioteca cliente para o banco de dados de objetos GOODS de Smalltalk para Python; eu gastei um tempo enorme lidando com casos especiais na semântica Python (isso é uma classe? um tipo? um novo tipo de classe? implementado em python ou em C?) que nunca apareceria em Smalltalk.

Ruby faz muito bem nesse ponto, melhor que a maioria das linguagens de script – eu não chamaria Ruby de “multi-paradigma”, aliás – mas ele poderia fazer ainda melhor.

**AkitaOnRails:** Acho que uma vez você disse que considera uma linguagem “finalizada” quando ela é rápida o suficiente para estender a si mesma. Isso é muito verdade no caso de Smalltalk, Java e outras plataformas. Ruby sem dúvida está devendo na sua posição atual. Foi uma das razões de termos esforços em paralelo como o IronRuby de John Lam, JRuby de Charles e Thomas e o Rubinius de Evan. Um dos pontos mais criticados no Ruby é não ter uma especificação formal para a linguagem ou suas bibliotecas padrão. Você também disse que a Java VM não é boa o suficiente como Strongtalk seria, por exemplo. Isso ainda se mantém hoje, agora que estamos vendo JRuby 1.1 no horizonte?

**Avi Bryant:** Ainda se mantém. O JRuby atualmente parece ter um benchmark no mesmo nível do MRI, e os melhores números de qualquer outra implementação Ruby são talvez 3 vezes mais que o MRI na média. Acho que podemos fazer **25 vezes mais** para funcionalidades básicas da linguagem (envio de mensagens, execução de blocos, etc), que deveria ser o suficiente para tornar possível a implementação das bibliotecas padrão no próprio Ruby. Mesmo que o resultado final seja similar aos números atuais, os benefícios colaterais seriam de extremo valor.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/19/200126067_a2fc0a9fec.jpg)

**AkitaOnRails:** Lembro que você começou o projeto [Smalltalk.rb](http://rubyforge.org/projects/smalltalk/) há algum tempo, e se não estou enganado era um esforço para traduzir Ruby em código equivalente em Smalltalk para que ele pudesse rodar em qualquer das VMs Smalltalk que existem. Esse projeto ainda está andando, você acha que é possível perseguir esse objetivo?

**Avi Bryant:** Ainda acho que é um objetivo que vale a pena e realista. O projeto ainda está andando no sentido que eu ainda estou falando às pessoas sobre como fazer isso acontecer, mas não tenho tempo para escrever código eu mesmo no momento. Tenho motivos para acreditar que esse projeto fará progressos mais concretos no ano que vem, mas vamos ver.

**AkitaOnRails:** Algum tempo atrás eu li um trecho de uma transcrição de chat via IRC entre você, Evan, Chad e até Charles. Você começou falando sobre padronização de primitivas (que são em C no MRI de hoje). Minha aposta é que Rubinius é o projeto destinado a ser a “próxima grande coisa” para a comunidade Ruby. Para mim parece que você e Evan colaboram bastante, é correto dizer isso?

**Avi Bryant:** Eu não diria isso, mas o [Rubinius](http://rubini.us/) é certamente o projeto Ruby que mais perto se alinha com meus próprios interesses e objetivos no momento, e é muito legal ver quanto esforço está sendo posto nele. A Engine Yard merece muitos parabéns por seu suporte financeiro ao projeto.

Tenho grande esperança que o trabalho de Evan e sua equipe serão de grande benefício não apenas para Rubinius mas para todas as implementações Ruby – que foi o motivo de porque eu estava defendendo um conjunto padrão de primitivas.

**AkitaOnRails:** Você conhece muitas pessoas, eu imagino se já conversou com o próprio Koichi Sasada para discutir suas idéias para o projeto YARV, já que ele será a virtual machine Ruby ‘oficial’ daqui alguns meses.

**Avi Bryant:** Não, acho que nunca nos falamos. Eu certamente adoraria encontrá-lo qualquer dia.

**AkitaOnRails:** Então, subimos um nível acima para aplicações. Seu framework Seaside é muito incrível. Você está muito certo sobre [WebObjects](http://developer.apple.com/tools/webobjects/) também. Como um programador Java eu sempre lamentei que ele nunca se tornou popular. Hoje está basicamente relegado a websites relacionados à Apple, enquanto frameworks menores Java tomaram a dianteira. Tapestry e Cayenne tentam chegar às funcionalidades do WebObjects mas parece que ainda estão longe. Você ainda programa em Java? Quais suas opiniões sobre frameworks populares da atualidade como Spring, JSF? Para iniciantes, o que havia em WebObjects que o tornava diferente dos demais?

**Avi Bryant:** Eu não faço mais nenhum trabalho Java (felizmente), então não poderia dar uma opinião de qualidade sobre o estado dos frameworks de agora. Entretanto, a principal coisa que acho que o WebObjects fazia direito era focar no estado e comportamento da aplicação, em vez das mecânicas de URLs e HTML e requisições HTTP.

Então em vez de se preocupar sobre como um campo era nomeado, você apenas diria _“este campo é ligado à esta variável de instância no meu model”_, e em vez de se preocupar sobre qual URL um link iria, você diria _“este link ativa este método no objeto da minha página”_.

Transicionar entre página era feito construindo um novo objeto de página e configurando-o diretamente em Java, em vez de construir uma URL que seria decomposta para construir a página. Essa atitude direta e estilo geral é algo que pesadamente influenciaram Seaside.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/19/504096000_40e4e00b75.jpg)

**AkitaOnRails:** Muitas pessoas podem não entender imediatamente, já que é uma palavra nova a muitos: _“continuações”_. Significa que em vez de manualmente controlar o fluxo entre eventos, com serialização e desserialização manual de objetos, você programa tudo como um fluxo coeso e contínuo. Poderia explicar isso de uma maneira que um novato possa entender? Quais os benefícios e desvantagens dessa técnica?

**Avi Bryant:** Bem, realmente tem tudo a ver com ser capaz de um comportamento model a uma aplicação web. Em uma aplicação desktop, por exemplo, você ocasionalmente poderia ter uma chamada como _“file = chooseFile()”_ ou _“color = pickColor()”_ que abriria um janela dialog modal, pegaria um resultado do usuário, e seguiria dali.

O uso de continuações do Seaside é somente para permitir exatamente esse tipo de interação no contexto da Web. A parte complicada é que por causa do ‘botão-voltar’ dos browsers, o usuário poderia escolher um cor diferente do mesmo dialog depois, e a chamada _“pickColor()”_ teria que retornar uma segunda vez. Isso é confuso de se pensar, mas na maioria dos casos apenas funciona.

Do ponto de vista de implementação, o que estamos fazendo é salvando uma cópia da pilha no momento em que a chamada é feita para que possamos retornar depois, mais de uma vez se for preciso.

**AkitaOnRails:** Você começou esses conceitos em Ruby com IOWA. Há muito tempo havia um framework chamado Borges que também foi descontinuado. Então Koichi mencionou tirar o suporte a continuações do próximo Ruby. Você acha que Ruby estará dando um passo para trás sem suporte a continuações?

**Avi Bryant:** Continuações são uma grande abstração, e permite um monte de experimentações interessantes com semântica de linguagens. Entretanto, eu não consideraria uma tragédia se isso desaparecesse de Ruby; existem coisas mais importantes com o que se preocupar. Da perspectiva de web, eu acho que AJAX está começando a substituir um monte de casos de uso onde ter lógica model server-side costumava ser importante – Dabble DB, por exemplo, **praticamente não usa** as funcionalidades de continuações de Seaside.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/19/106824107_67074eaf0b.jpg)

**AkitaOnRails:** Seu blog tem um nome peculiar, [HREF considered harmful](http://www.cincomsmalltalk.com/userblogs/avi/View.ssp) (HREF consideradas perigosas). Você provavelmente tirou sua inspiração do artigo de Edsger Dijkstra/Niklaus Wirth’s chamado [Goto Statement Considered Harmful](http://en.wikipedia.org/wiki/Considered_Harmful) (GOTO considerado perigoso), onde Edsger tornou famoso seu caso contra o comando GOTO. No nível de assembler é impossível não fazer JMP (salto) o tempo todo (pelo menos não sem alguma ajuda de macros) mas no nível de C você pode evitar totalmente GOTOs. Mesmo Basic tinha tanto GOTO quanto GOSUB e você poderia simplesmente ignorar o primeiro. Estou sendo simplista aqui, mas agora você está meio que dizendo que URLs tem um papel similar pela maneira que interrompem o fluxo normal, indo para trás de maneira imprevisíveis e assim por diante. Por outro lado a Internet talvez não fosse o que é sem URLs. Como lidar com esse dilema?

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/19/461207306_3f23831032.jpg)

**Avi Bryant:** Não acho que seja um dilema. Acho que sua analogia é muito boa: é impossível não fazer JMP o tempo todo, e também é impossível não usar URLs o tempo todo, mas não precisamos ficar alertas o tempo todo sobre nenhuma das duas. Antigamente quando todos escreviam assembler, as pessoas provavelmente era obcecadas sobre ter etiquetas de JMP com significado e “bonitas” da mesma maneira que hoje existe a obcessão em ter URLs bonitas. Acho que precisamos nos permitir a dar o mesmo salto de abstração na web que fizemos com linguagens de programação de alto nível.

Não estou dizendo que **nunca** devemos pensar sobre URLs: qualquer website precisa exportar URLs com significado para serem referenciadas e usadas externamente, assim como qualquer biblioteca C precisa exportar nomes de funções significativas para que possam ser ligadas a outros programas. Mas é o máximo até onde precisamos ir.

**AkitaOnRails:** Componentes foram uma grande coisa no começo dos anos 90, com ferramentas RAD e assim por diante. Hoje parecem que estão se mostrando mais devagar, com iniciativas como JSF e ASP.NET. Rails inicialmente vinha com um suporte bem crú a ‘componentes’ mas foi derrubado logo no começo por ser ruim (por causa da maneira meio gambiarra em que foi implementada). Nada de novo veio substituí-lo o que parece sugerir que não havia muita necessidade disso de qualquer forma no Rails. Por outro lado Seaside é pesado em componentização. Poderia expôr um pouco mais sobre as diferenças nessas técnicas?

**Avi Bryant:** “Componente” é um desses termos como “MVC” ou “aberto” que são usadas para descrever tantas coisas diferentes que é difícil falar seriamente sobre elas. Uma funcionalidade concreta na forma Seaside é que cada peça da interface gráfica é bem independente de outras peças de interface na mesma página.

Não existe um controlador central que é responsável por processamento de requisições, escolhendo um template e assim por diante – todas essas responsabilidades são distribuídas entre muitos pequenos objetos. Também não há chance de conflitos de nomes porque você não nomeia links ou campos de formulários diretamente, então se pode ter muitas cópias do mesmo form/widget/etc na mesma página sem nenhuma confusão.

Isso permite um nível de modularidade que é muito difícil de reproduzir em frameworks mais tradicionais.

**AkitaOnRails:** Outra coisa que pode chocar algumas pessoas é que não existe um sistema tradicional de template no Seaside, sem mistura de código e tags HTML por todos os lados. Em vez disso todo HTML é abstraído em uma hierarquia de objetos que renderiza a si mesmo. Em Rails existem algumas alternativas que tentam algo parecido como HAML, Markaby. O que você acha que são as principais diferenças?

**Avi Bryant:** A API de renderização de HTML é uma peça muito chave no Seaside, e uma boa parte do framework foi desenhada com essa aproximação interna em mente. Acho que a principal diferença quando comparada com HAML ou Markaby, é que elas foram feitas para serem jogadas em outros frameworks.

Uma vez que você se livra de templates e muda para a geração de HTML programático, o espaço de design muda completamente, e você precisa reconsiderar quase toda decisão que faz – esse foi um processo que eu passei com Seaside entre o lançamento inicial, que usava templates e as versões 2.x, que não usavam.

Então acho que precisaremos ver um framework que usar, digamos, Markaby como o ponto de partida e se pergunta “para onde podemos ir daqui” antes de fazer qualquer comparação real.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/19/627957460_48e4181526.jpg)  
com Adrian Holovaty, do Django

**AkitaOnRails:** Você também discute a respeito do dilema ‘shared-nothing’ vs ‘share-all’ (não compartilha nada vs compartilha tudo). E você obviamente tem um caso forte porque isso não é apenas baboseira tecnológica mas você tem um produto de sucesso rodando sobre essa visão. Ainda acha que vale a pena sacrificar um pouco de performance por código mais limpo e produtividade? De certa forma é meio o que o próprio DHH disse sobre Rails quando as pessoas disseram que ele é mais lento que PHP ou Perl. De fato isso tem a ver com sua conversa sobre ser ‘herético’ no sentido que está fazendo coisas de maneira diferente do que todos nós agora. Poderia elaborar sobre isso?

**Avi Bryant:** _“Share nothing”_ é um grande conselho para tirar o máximo uso dos recursos do seu servidor. Para sites como yahoo.com ou Facebook, isso é claramente muito importante porque seu modelo de negócio é servir milhões de usuários todos os dias.

_“Share everything”_ é realmente pesado nos seus servidores, mas ele faz máximo uso dos recursos de seus desenvolvedores. Para uma startup como Dabble DB, onde temos 4 desenvolvedores, isso é realmente importante. E já que nosso modelo de faturamento somente requer servir milhares de usuários todos os dias, não milhões, está tudo bem gastar um pouco mais por usuário em hardware de servidor. Tem sido uma troca muito vantajosa para nós.

**AkitaOnRails:** E falando de DHH, vocês provavelmente se encontraram em várias ocasiões. Ambos são pessoas de muita opinião com visões antagônicas. Smalltalk vs Ruby. Seaside vs Rails. Share-all vs Share-nothing. Alguém poderia ser tentado a desenhá-los numa disputa como Super Homen vs Batman. Embora eu saiba que pessoas inteligentes não brigam sobre mesquinharias. O que acha dele e suas idéias, como acha que ambas as comunidades poderiam cooperar, se houver alguma chance disso?

**Avi Bryant:** Tenho um grande respeito por David. A única ocasião onde me senti antagônico a ele foi no verão passado na Foo Camp. Estávamos jogando [Werewolf](http://en.wikipedia.org/wiki/Mafia_(game)), eu era o Werewolf e ele era um camponês. Agora, como werewolf a melhor coisa que você pode fazer é fazer a pessoa mais próxima a confiar em você, e aconteceu de ser o DHH. E isso funcionou – Kevin Rose estava totalmente sobre mim mas David conseguiu persuadí-lo a não me linchar, e eu comi os dois e ganhei o jogo! :-)

Enfim, provavelmente existe uma lição nisso em algum lugar. Também, em uma disputa entre mim e DHH, [Neal Stephenson](http://en.wikipedia.org/wiki/Neal_Stephenson) ganharia.

**AkitaOnRails:** Finalmente, o Brasil ainda tem uma comunidade jovem e em crescimento. Algum comentário final para nossa audiência?

**Avi Bryant:** Olá e boa sorte! Me disseram que o Rio é ainda mais bonito que minha cidade de Vancouver, e espero visitá-los algum dia.

[![](http://s3.amazonaws.com/akitaonrails/assets/2007/12/19/1057077803_3bd0155620.jpg)](http://twit.tv/floss21)   
_Não perca a entrevista no podcast TWiT com Avi!_

