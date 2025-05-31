---
title: Conversando com Evan Phoenix
date: '2008-02-11T20:43:00-02:00'
slug: conversando-com-evan-phoenix
tags:
- interview
draft: false
---

![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/11/524655980_8e68a871a0.jpg)

**English Readers:** click [here](/2008/2/11/chatting-with-evan-phoenix)

Foi [Avi](/2007/12/15/chatting-with-avi-bryant-part-1) [Bryant](/2007/12/22/chatting-with-avi-bryant-part-2) que evangelizou a idéia de “tartarugas o caminho todo”, querendo dizer que para uma linguagem se considerar ‘completa’ ela deveria ser capaz de estender a si própria. Então, o mundo ideal teria Ruby sendo estendido por Ruby, não em C. JRuby vai tão longe quanto pode construindo um sandbox para código Ruby rodar sobre a JVM. Por mais legal que seja, ainda precisamos de Java para podermos estendê-la.

Entra [Rubinius](http://rubini.us/) e seu autor **Evan Phoenix** , atualmente contratado em tempo integral pela [EngineYard](http://www.engineyard.com/). Rubinius pega pesadamente emprestado dos conceitos de virtual machine de Smalltalk e faz o menos possível em C somente para conseguir o boot inicial e todo o resto é desenvolvido em Ruby puro.

Rubinius responde a várias questões sobre o futuro do Ruby MRI mas também levanta diversas perguntas que espero que possamos responder hoje nesta entrevista com o próprio Evan.

Então, vamos começar.


 **AkitaOnRails:** Já é uma tradição em minhas entrevistas perguntar sobre o histórico do programador. Qual foi seu caminho? Quero dizer, o que o fez entrar no mundo da programação e como entrou em Ruby?

**Evan Phoenix:** Eu comecei a programar no colégio com um amigo meu. Começamos uma pequena empresa de computador fazendo várias coisas e eu realmente entrei nisso de cabeça. Eu entrei em Linux alguns anos atrás, então programação se tornou uma extensão natural no meu uso de Linux.

Quando entrei pra faculdade, apliquei para o curso de Ciências da Computação, e venho fazendo isso desde então eu acho.

Sobre Ruby, eu entrei nisso mais ou menos em 2002, logo que me mudei para Seattle. Um amigo tinha acabado de descobri-la e estava escrevendo coisas legais nela e eu peguei por sugestão dele. Eventualmente, encontrei o grupo seattle.rb e tenho trabalhado em Ruby desde então.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/11/ey_logo.png)](http://www.engineyard.com/)

**AkitaOnRails:** A EngineYard parece ter uma grande fé no futuro do Rubinius. Como esse relacionamento começou? Pode nos dizer quais são as expectativas da EngineYard sobre seu trabalho para eles?

**Evan Phoenix:** O relacionamento começou principalmente com eles se aproximando de mim sobre trabalhar para eles, no Rubinius. Então eles viram promessa no Rubinius por conta própria, das minhas apresentações e tal, e eles se aproximaram.

As expectativas deles é que eu faça Rubinius ser a melhor VM de Ruby que possa existir. Essa é a minha ordem básica deles. Eles são provavelmente os melhores supervisores para esse projeto. Eles me permitem trabalhar no ritmo que quiser, eles entendem os rigores do trabalho que estou fazendo, e me dão muita liberdade.

**AkitaOnRails:** Agora, vamos entrar no Rubinius. Para iniciantes como você definiria Rubinius? Todos sabemos que é uma implementação alternativa de Ruby, então talvez fosse interessante dizer o que o torna diferente do MRI. Quais são os objetivos do projeto?

**Evan Phoenix:** Um dos objetivos primários é ter o máximo possível do sistema escrito no próprio Ruby. No MRI, nenhuma das classes principais são escritas em Ruby, tudo é em C. Então nós queríamos um sistema que fosse fácil de se trabalhar, e portanto escrito no próprio Ruby.

Outra coisa que fizemos é enriquecer o número de coisas que são objetos, o que adiciona poder considerável. Um exemplo simples é a classe CompiledMethod que o Rubinius tem. Ele contém a representação em bytecode de um método e ele pode ser inspecionado, manipulado, etc, como qualquer outro objeto. Isso abre várias portas em relação a como problemas podem ser resolvidos.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/11/Picture_1_1.png)

**AkitaOnRails:** Não é tão óbvio para a audiência brasileira falar sobre “Squeak”, “Garnet”. Smalltalk é provavelmente menos conhecido por aqui do que Ruby (estou chutando). O que quero dizer é que é bem sabido que você se inspirou na maneira como Squeak é implementado. Isso levou a funcionalidades como “Cuby”. Pode nos explicar o que é tão legal sobre a maneira como Squeak é implementado e como isso o ajuda no projeto Rubinius?

**Evan Phoenix:** Bem, estamos atualmente no processo de desenvolvimento do Garnet/Cuby, então essas ferramentas ainda não estão em uso. Mas quase toda a arquitetura do sistema do Rubinius é modelado a partir da Virtual Machine Smalltalk-80 original. Ele definia coisas como CompiledMethod, etc, que eu copiei nome por nome no Rubinius.

Além disso, o modelo de execução do Rubinius é quase idêntico ao Squeak. Um bom exemplo é a maneira como o sistema chama métodos e entende como rastrear o retorno de controle ou quando uma chamada de método retorna. Toda essa informação é mantida em objetos de primeira classe chamadas MethodContexts. Em uma linguagem como C, essa informação é armazenada na pilha de memória dos processos. Mantendo os dados em objetos de primeira classe, somos capazes de consultá-los diretamente para encontrar informações sobre o sistema em execução. Isso também largamente simplifica como o garbage collector funciona.

**AkitaOnRails:** Hoje vocês tem o Shotgun. Li em algum lugar que você considera isso ‘trapaça’ porque não é um interpretador para Ruby escrito em Ruby, e isso nos levaria a Cuby. É mais um tipo de facilidade para o desenvolvimento. Qual o estado atual do shotgun, podemos usá-lo fora de seu propósito de desenvolvimento do Rubinius?

**Evan Phoenix:** Shotgun é uma virtual machine escrita em C que fornece instruções e operações primitivas para rodar uma linguagem parecida com Ruby. O Shotgun por si próprio não tem conhecimento sobre parsing, compilação, etc. Ele tem uma maneira muito simples de carregar código nele, e uma maneira de executá-la. Você poderia facilmente desenvolver uma linguagem para o shotgun, de fato, [Ola Bini](/2007/6/21/chatting-with-ola-bini-jruby-core-team-member) e eu falamos algumas vezes sobre escrever uma linguagem simples no estilo de Lisp que rodaria diretamente no shotgun.

As operações primitivas que ele fornece são meio parecidas com syscalls em um sistema unix. Ele fornece operações bem de baixo nível. Por exemplo, existe uma primitiva de adição que adiciona objetos Fixnum juntos e coloca o resultado na pilha.

**AkitaOnRails:** Isso é apenas uma curiosidade pessoal. O MRI hoje usa um simples garbage collector (GC) mark and sweep enquanto o Java usa um altamente customizável GC de geração. O que você escolheu como gerenciamento de memória na VM do Rubinius?

**Evan Phoenix:** Rubinius usa um GC de geração, combinando um copy collector para objetos jovens, com um coletor mark and sweep para a geração velha. Isso de provou funcionar bem para nós. O truque tem sido otimizar quanto tempo um objeto existe antes de promovê-lo para o espaço de objetos velhos. Otimizamos apenas um pouco. Há muito mais trabalho que poderia ser feito no GC, e ele é arquitetado para apenas interagir com o resto do sistema em alguns poucos pontos, então sua lógica é completamente substituível se for preciso sem atrapalhar nada de fora.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/11/421875792_79acde1fba.jpg)

**AkitaOnRails:** Temos partidos que favorecem green threads, outros que são pró-threads nativas. Como está lidando com o assunto de threads no Rubinius? Ainda vamos ter o mesmo tipo de trava global que o MRI tem hoje?

**Evan Phoenix:** No momento, Rubinius tem somente green threads, construídos sobre os objetos MethodContext de primeira classe. Isso atualmente usa libevent para permitir threads esperar objetos de IO rapidamente.

O plano (provavelmente para 2.0) é suportar threads nativas também em paralelo às green threads. Você será capaz de alocar um pool de threads nativas que as green threads podem compartilhar. Então talvez você tenha 100 green threads, e poderia alocar 10 threads nativas para elas dividirem o tempo entre elas. Por causa da arquitetura, é trivial migrar entre green threads e threads nativas.

Sobre a trava global em threads nativas, não, não consideramos uma trava global uma solução para usar threads nativas. Se existir uma trava, não há razão para usá-las em vez de green threads. Como muito do Rubinius é escrito em Ruby, temos mais facilidade de entender como travar coisas apropriadamente para manter todos os objetos no sistema seguros. Na realidade ainda nem começamos esse trabalho, mas têm se falado bastante sobre isso.

**AkitaOnRails:** O objetivo atual é provavelmente fazer o Rubinius o mais compatível com o MRI 1.8 quanto possível. Já começaram algum trabalho em direção à compatibilidade com YARV? E falando em YARV, ela é a virtual machine e compilador de bytecodes oficial para a próxima versão do Ruby. Existe alguma chance de fazer Rubinius e YARV terem bytecodes compatíveis ou isso não é um objetivo de curto prazo?

**Evan Phoenix:** Estamos ativamente trabalhando em direção à compatibilidade com 1.8.6. Esse é um grande objetivo porque existe muita funcionalidade lá. Faremos um lançamento 1.0 do Rubinius quando ele for capaz de rodas todas as especificações do 1.8.6 e rodar Rails apropriadamente, que é um bom benchmark.

Não, não fizemos nenhum trabalho em direção a compatibilidade com YARV, mas da forma como as coisas foram arquitetadas, talvez sejamos capazes de simplesmente criar um flag —yarv que você passará ao Rubinius para que ele use coisas compatíveis com YARV.

Não estamos atualmente trabalhando em direção a um bytecode comum entre Rubinius e YARV, principalmente porque não há nada a se ganhar fazendo isso. Da última vez que olhei, o bytecode do YARV é uma coisa interna do YARV somente, e você não poderia facilmente salvá-la para um arquivo. O Rubinius primariamente trabalhar sobre arquivos .rbc, que contém um CompileMethod serializado, e portanto contém os bytecodes. Isso dito, eles são similares e poderiam ser unificados se virmos necessidade disso.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/11/2211693208_bf14710240.jpg)

**AkitaOnRails:** Performance é sempre assunto para muita discussão e ainda é prematuro falar sobre performance no Rubinius, já que ainda é um trabalho em andamento. Mas eu li no seu blog que ele está ficando rápido depressa, mesmo ultrapassando o MRI em muitos testes. Como a performance está evoluindo?

**Evan Phoenix:** Atualmente, a performance está evoluindo devagar. Isso principalmente porque não é uma prioridade para as pessoas escrevendo o kernel do Rubinius (a maior parte do código Ruby que a constrói). À medida que formos chegando mais próximos da compatibilidade, começaremos a otimizar as coisas. Isso dito, eu realmente escrevo código para tornar Rubinius mais rápido aqui e ali. Fomos adiante e implementamos operações matemáticas rápidas para acelerar a matemática mais comum que as pessoas fazem. Temos um profiler simples que pode ser facilmente ligado para dar feedback aos desenvolvedores sobre como seu código está rodando.

**AkitaOnRails:** Um dos principais problemas para qualquer implementação alternativa do Ruby é que ele tem um monte de extensões em C, incluindo um monte de bibliotecas principais. Então, se quiser se manter “Ruby-puro” tem que reimplementar todas elas em Ruby. O pessoal do JRuby teve que passar por algo assim. Existe alguma colaboração entre projetos sobre esse assunto?

**Evan Phoenix:** Na realidade, isso não é bem verdade. Também vimos que Ruby inclui muitas extensões em C. Para tornar a migração para o Rubinius mais rápida, escrevemos uma camada no Rubinius que permite que todas essas extensões C rodem (quase) sem modificação, somente requerendo uma recompilação. Funciona de tal maneira que coisas como ImageScience, RMagick, bindings de postgres, etc possam ser usadas sobre Rubinius sem ter que ser reescritas.

**AkitaOnRails:** Ainda sobre código C, sei que é difícil entregar bytecode de virtual machine e ainda ser dependente de código C não-gerenciado. Java tem coisas como JNA, .NET tem pinvoke. Você planeja algo similar para Rubinius de tal forma que ele possa mais ou menos facilmente falar com bibliotecas em C?

**Evan Phoenix:** De fato nós suportamos diretamente um mecanismo chamado de FFI (Foreign Function Interface), que permite a um desenvolvedor ligar funções C diretamente como chamadas de métodos. Aqui vai um exemplo simples:

* * *
rubymodule LibC attach_function nil, :puts, [:string], :void

end

LibC.puts “hello!”—-

Essa linha de attach_function é a interface primária para o FFI. Você simplesmente indica em qual biblioteca a função está (nesse caso, nil é usado porque está dentro do próprio processo), o nome da função (puts), os tipos dos argumentos que ele leva (apenas 1, um string) e, finalmente, o tipo do retorno (void, ou seja, nada).

Usando isso, você pode ligar diretamente a funções C sem ter que escrever um wrapper em C.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/11/Picture_2.png)](http://rubini.us/)

**AkitaOnRails:** Você está muito certo quando diz que especificações formais de linguagem muito cedo podem dificultar como a linguagem evolui. Ruby tem crescido nos últimos 10 anos já, e parece que este é o momento certo de começarmos a pensar em alguma coisa desse tipo, de tal forma que tenhamos uma base a partir de onde qualquer outra implementação alternativa possa começar. Você vê esforços para isso?

**Evan Phoenix:** Nós temos ativamente trabalhado no desenvolvimento de um conjunto de especificações (em formato [rSpec](http://rspec.info/)) para o 1.8. Isso forma o mecanismo principal como qual testamos como o Rubinius está indo. Essas especificações estão sendo ativamente utilizadas pelo JRuby e IronRuby para testar seus respectivos ambientes Ruby. Estamos atualmente no processo de mover essas especificações em um projeto genérico de especificações Ruby para tentar a começar a mover as coisas para um padrão mais formal.

**AkitaOnRails:** Outra pergunta recorrente é sobre Rails, claro. Qualquer nova implementação de Ruby hoje terá que encarar a pergunta inevitável: ele já roda Ruby? :-) Rails está servindo meio que como uma ‘mini suite de testes’ e uma base para a maioria das implementações. Como Rubinius está nesse sentido?

**Evan Phoenix:** Quando rodarmos Rails, saberemos que estamos próximos o 1.0 :-)

**AkitaOnRails:** Você tem uma proposta interessante em relação a gerenciamento de projeto open source: todos que lhe enviam bons patches ganham acesso de commit ao repositório. Como isso está funcionando para você? Não é um pouco confuso ou as pessoas tendem a seguir sua liderança e sua lista de prioridades?

**Evan Phoenix:** De fato está funcionando muito bem até agora. Por ser orientado a especificações/testes, as novas pessoas tem um lugar por onde começar, seja escrevendo especificações que estão faltando ou fazendo as existentes passar. Isso se tornou uma grande introdução a todo o sistema para eles. Então eles começam a explorar um pouco mais e normalmente encontrar mais e mais do que gostar a ajudar. Como temos um monte de trabalho a fazer em várias diferentes partes, as pessoas não tem que se preocupar com minha lista de prioridades, já que ela envolve coisas que os outros não precisam ficar ativamente preocupados a respeito.

Realmente o que eu disse não é suficiente para descrever como as pessoas tem contribuído. A barreira de um patch provou funcionar muito bem porque embora tenhamos mais de 60 committers, nenhuma vez precisei revogar esse acesso de alguém. Claro, as pessoas erram, mas em todos os casos, a pessoa corrigiu o comportamento e/ou código.

**AkitaOnRails:** Um sub-produto nesse esquema de acesso de commit é a integração com o rSpec no projeto Rubinius de tal forma que você tem uma ótima ferramenta de requerimentos e uma suíte de testes. Você pratica Behavior Driven Development? Ou isso está cobrindo apenas um pequeno sub-conjunto do projeto?

**Evan Phoenix:** Eu sou ainda um amador em testes, simplesmente seguindo guias feitos pelo Brian Ford, o principal mantenedor de especificações do projeto. Isso se provou ser uma grande ferramenta para ver como o projeto está progredindo.

**AkitaOnRails:** Assim como muitos projetos Ruby, Rubinius também é gerenciado sobre GIT. Tem havido muito barulho sobre Git e Ruby ultimamente. Você acha que é uma nova tendência? Por que decidiu ir com Git?

**Evan Phoenix:** Sim, acho que Git está pegando como uma tendência, por causa das funcionalidades que ele oferece sobre o subversion, principalmente.

A grande razão para nós foi seu conjunto de funcionalidades. Uma grande que eu adoro são branches locais, permitindo a uma pessoa gerenciar várias mudanças grandes sem atropelar os outros.

Ainda não fizemos, mas planejamos exercitar as grandes capacidades de merge e branches públicas.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/11/504590792_2819a866a8.jpg)

**AkitaOnRails:** Ouvimos do Ezra [numa entrevista recente](http://podcast.rubyonrails.org/programs/1/episodes/ezra-zygmuntowicz) sobre seu novo experimento sobre multi-VM. Isso seria uma bênção para deployment sem ter que lidar com diversos processos em um cluster mongrel. Poderia nos descrever essa funcionalidade e apontar suas vantagens?

**Evan Phoenix:** Atualmente é bastante experimental, mas ele vai se estabilizar com o tempo. A idéia é que você pode subir uma nova VM no processo atual. Essa nova VM é completamente separada das outras VMs, vivendo em sua própria thread nativa e tendo seu próprio garbage collector, etc.

Existe um mecanismo para as VMs se comunicarem entre si, e isso permite que elas coordenem tarefas. Isso poderia significar que uma thread primária poderia aceitar novas conexões, então passá-las a uma nova VM para realmente processar. Isso lhe permite processar conexões realmente em paralelo, e além disso, como as VMs estão completamente separadas, isso funciona até mesmo para aplicações que não são thread-safe como Rails.

**AkitaOnRails:** Ezra também mencionou sobre um possível mod_rubinius no forno. Como isso está indo? Isso definitivamente torna o pacote Rubinius ainda mais forte. Junto com Merb, Rubinius mais capacidades de multi-VM mais mod_rubinius seriam um pacote de deployment matador.

**Evan Phoenix:** Sim, um projeto mod_rubinius está apenas começando. O código de multi-VM e do mod_rubinius se sobrepõe um pouco, então você será capaz de ter pools de VMs para sites, todas gerenciadas através do Apache. Esperamos que mod_rubinius possa realmente simplificar o cenário de deployment Rails/Ruby. Ele operará de maneira similar ao mod_python, permitindo a uma VM permanecer rodando entre requisições, e talvez até rodando tarefas em background.

**AkitaOnRails:** Quanto tempo acha que estamos de um lançamento totalmente compatível com o MRI 1.8?

**Evan Phoenix:** Ainda não temos uma data firme, principalmente porque o que é ser compatível com MRI 1.8 ainda é incerto. Ainda estamos adicionando especificações, trabalhando para definir apropriadamente o 1.8. Isso dito, estamos realmente atingindo um ponto decisivo e avançando rapidamente. Estamos muito próximos de rodar apropriadamente o Rubygems. Ezra recentemente foi capaz de rodar o Merb sobre Rubinius, rodando sobre Webrick.

Estarei lançando uma versão 0.9 esta semana, porque fizemos muito progresso desde a 0.8. Minha grande esperança é que até a RailsConf, em maio, seremos capazes de rodar Rails. Mas não me comprometa. Isso é um projeto open source afinal de contas. :-)

**AkitaOnRails:** Obrigado! Acho que isso é tudo.

**Evan Phoenix:** Muito obrigado pela paciência.

