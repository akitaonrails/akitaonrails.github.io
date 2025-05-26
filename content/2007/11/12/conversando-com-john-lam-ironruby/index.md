---
title: Conversando com John Lam (IronRuby)
date: '2007-11-12T16:59:00-02:00'
slug: conversando-com-john-lam-ironruby
tags:
- interview
draft: false
---

 **English-version:** [here](/2007/11/12/chatting-with-john-lam-ironruby)

[![](http://s3.amazonaws.com/akitaonrails/assets/2007/11/12/n685772348_7884.jpg)](http://www.iunknown.com/)

Faz algum tempo desde minha última entrevista internacional, e estou de volta com ninguém menos que um dos responsáveis pelo Ruby rodar sobre a plataforma .NET. Isso mesmo, eu tenho coberto muito sobre JRuby e Rubinius mas não podemos negligenciar que uma das maiores plataformas do mercado está recebendo tratamento de Ruby também. Então convidei [John Lam](http://www.iunknown.com/) , que gentilmente respondeu diversas perguntas sobre essa empreitada.

Lembrando que [IronRuby](http://www.ironruby.net/) – nomeado depois de [IronPython](http://www.ironpython.com/), a primeira das principais linguagens dinâmicas construídas sobre o .NET – é um [verdadeiro projeto open source](http://www.opensource.org/node/207), e também tem um add-on de terceiros para Visual Studio.NET, de forma que programadores acostumados ao fluxo de trabalho do VS.NET poderão vir à bordo com uma curva menor de aprendizado.

A despeito de opiniões contrárias à Microsoft apenas com o objetivo de criticar, o fato persiste que Java e .NET representam os maiores mercados de desenvolvimento corporativo hoje. E também é um fato que a influência Ruby está se espalhando depressa. Poder rodar sobre ambos JVM e CLR representa permitir o Ruby em mercados de nicho que ele não alcançaria de outra maneira, e isso é um grande ganho. Eu falei um pouco sobre isso no meu artigo [Para eu ganhar o outro precisa perder](/2007/10/23/para-eu-ganhar-o-outro-precisa-perder). Existem pessoas muito inteligentes na Microsoft, John Lam sendo um deles.


Isso dito, vamos começar:

**AkitaOnRails:** Primeiro de tudo, eu sempre pergunto a meus convidados sobre suas carreiras: qual foi seu caminho até aqui? Quero dizer, como você começou com computação, o que o trouxe até aqui?

**John Lam:** Eu escrevi muito software antes de me formar no colegial, em 1986. Lancei vários softwares comerciais para a ‘plataforma’ Commodore (como PET, VIC-20, C-64/128) lá atrás. Em 1986 decidi que não havia futuro em computação (que mostra porque as pessoas não devem levar minhas opiniões muito a sério :)) e decidi estudar ciência física na universidade. Me graduei em 1995 com um doutorado em Química Orgânica e decidi que não havia futuro em química (que, se vocês olharem como a engenharia reversa da vida hoje é baseada em muita interação entre disciplinas com outros galhos de ciências da vida, mostra porque as pessoas não devem levar minhas opiniões muito a sério :))

Quando decidi trabalhar com computação novamente, eu peguei uma nova e obscura plataforma de desenvolvimento chamada Delphi que lançou a versão 1.0 na época que voltei a esse campo. Gastei bastante tempo trabalhando na integração de Delphi com COM, que é onde eu originalmente suspendi meu chapéu. O lado negro do COM me puxou à sua órbita e tenho trabalhado com coisas relacionadas à Microsoft desde então.

**AkitaOnRails:** Vejo que está na Microsoft desde janeiro de 2007, é isso? Como entrou lá, você foi contratado por causa do projeto IronRuby? Essa é sua tarefa principal hoje?

**John Lam:** Sim, comecei em janeiro. Antes de integrar a empresa, trabalhei em uma ponte open source entre Ruby e o CLR chamado “RubyCLR”. Quando decidi começar a promover esse trabalho nas conferências, cruzei meu caminho com a equipe do DLR da Microsoft. Mahesh Prakriya gentilmente doou metade do seu tempo na Tech Ed em 2006 para que eu pudesse falar sobre o RubyCLR. Depois de muita ansiedade e condicionamento mental acabei aceitando a oferta deles de trabalhar em tempo integral em uma implementação de Ruby sobre o DLR e nós (minha mulher, dois filhos e um cachorro) chegamos em Redmond em janeiro.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/11/12/166261351_2b04ab1086.jpg)

**AkitaOnRails:** Qual foi a motivação para começar IronRuby? Como ele iniciou? Você foi o único desenvolvedor original da implementação de Ruby sobre o .NET?

**John Lam:** Queríamos demonstrar que o DLR é um verdadeiro runtime para múltiplas linguagens dinâmicas, então precisávamos construir várias linguagens sobre ela. Ruby certamente se encaixava nesse critério: dinâmica, forte comunidade de usuários, muita atenção, então fazia sentido implementá-la. IronRuby definitivamente forçou muitas decisões de mudanças no DLR, tornando-a menos “Pythônica” o que é uma coisa boa para outras pessoas interessadas em construir linguagens dinâmicas sobre nossa plataforma.

Definitivamente não sou o único desenvolvedor do IronRuby. Temos dois grandes desenvolvedores trabalhando no projeto: Tomas Matousek e John Messerly, e eles estão fazendo um trabalho incrível. Nossa pessoa de testes, Haibo Luo, está fazendo um grande trabalho para garantir que vamos lançar uma implementação de alta qualidade. O trabalho de Haibo será lançado junto com o IronRuby, o que significa que a comunidade vai se beneficiar desta suíte de testes.

**AkitaOnRails:** Nem todos estão familiarizados com o DLR e Silverlight. Poderia descrever rapidamente para os iniciantes? O que torna o “DLR” diferente do “CLR” além de saltar da letra “C” para “D”? :-)

**John Lam:** O DLR é uma plataforma que forma uma camada sobre o CLR. Isso significa que podemos rodar em qualquer lugar onde o CLR rodar, o que obviamente inclui Silverlight. Silverlight é nossa plataforma “multi-plataforma” baseada em browsers que roda em Windows, Mac e Linux (através do projeto Moonlight). Nós lançamos uma versão multi-plataforma do CLR o que significa que você será capaz de rodar linguagens baseadas em DLR com um download inicial de apenas 5Mb no seu browser web.

**AkitaOnRails:** Isto é delicado: uma vez eu li Ola Bini e Charles Nutter criticando o “jeito Microsoft”, dizendo que seria extremamente difícil – se não impossível – para você escrever uma implementação 100% completa do Ruby 1.8 sobre o .NET sem poder olhar para seu código-fonte. A razão disso por causa da política da empresa em relação a licenças open source. Foi esse o caso?

**John Lam:** Acho que o IronPython é a prova de existência que você pode construir uma implementação compatível de uma linguagem dinâmica sem olhar para o código-fonte original. Em nosso trabalho com IronRuby, posso lhe dizer que não poder olhar o código-fonte não nos impediu de entender como o Ruby atinge certas funcionalidades – tem tudo a ver com desenvolver os experimentos certos.

**AkitaOnRails:** Também vi que IronRuby será lançado sob uma licença compatível com open source, da Microsoft, fazendo dela o primeiro projeto verdadeiramente open source da Microsoft. O que significa que vocês não apenas permitiriam as pessoas a dar uma olhada no código-fonte mas também de contribuir de volta. Quão longe estamos disso?

**John Lam:** A Microsoft Public License foi oficialmente sancionada pelo OSI no começo de outubro. IronRuby, IronPython e o DLR estão todos sob essa licença.

Nós já aceitamos contribuições de volta da comunidade, e estamos continuando a aceitar mais contribuições.

Na realidade não somos o primeiro projeto Open Source na Microsoft a aceitar contribuições de volta da comunidade. Essa honra pertence ao [AJAX control toolkit](http://www.asp.net/ajax/ajaxcontroltoolkit/samples/) do ASP.NET que é um projeto enormemente bem sucedido com mais de 1 milhão de downloads até hoje.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/11/12/166261286_d084c57e46.jpg)

**AkitaOnRails:** O DLR foi originalmente concebido como um jeito experimental de rodar Python sobre .NET. Isso tornou mais fácil para uma implementação Ruby ou você acha que Python e Ruby são diferentes o suficiente para garantir muitos ajustes no DLR para torná-la possível?

**John Lam:** É justo chamar a versão original do DLR como “Python Language Runtime”. Adicionar Ruby à mistura forçou várias mudanças adicionais ao DLR, a mais significante sendo a refatoração do runtime para migrar todos os idiomas específicos de Python (que pensaram ser genéricas mas acabou não sendo o caso) para o IronPython.dll. O que restou é um núcleo que nossas 4 linguagens desenvolvidas pela MSFT (IronRuby, IronPython, Managed JScript and VB) continuam a usar efetivamente hoje.

**AkitaOnRails:** É um objetivo ser 100% compatível com o MRI 1.8? Ou vocês estão na direção de um sub-conjunto da implementação Ruby? Isso tornaria possível escrever programas .NET em Ruby, usando o conjunto completo de bibliotecas .NET e frameworks como ASP.NET, Windows.Forms, LINQ, etc. Ou estão planejando uma implementação totalmente compatível com o MRI, o suficiente para conseguir rodar uma aplicação inteira de Rails?

**John Lam:** Nossa prioridade nr. 1 é ser tão compatível com o MRI 1.8.x quanto possível. A única funcionalidade que não vamos suportar é continuações, o que é consistente com JRuby. Além disso (e na falta de uma especificação de Ruby), a compatibilidade será julgada se podemos rodar aplicações reais de Ruby e suítes de teste desenvolvidos pela comunidade. Obviamente Rails é uma aplicação Ruby extremamente importante, que nós absolutamente vamos rodar sobre o IronRuby.

Interoperabilidae .NET é nossa prioridade nr. 2. Vamos integrar com a plataforma .NET e permitir escrever aplicações Ruby usando o rico conjunto de bibliotecas .NET. Obviamente coisas como Silverlight, WPF, LINQ, WinForms e ASP.NET serão suportadas.

**AkitaOnRails:** Ruby cresceu como um esforço coletivo e discreto que realmente explodiu 3 anos atrás por causa de Rails. É uma das razões porque ninguém nunca se importou em escrever uma especificação formal e uma suíte de testes. Temos Alioth, a suíte de testes do YARV. Você teve dificuldades por causa da falta de uma especificação formal? Você está em contato com pessoas como Charles do JRuby, Koichi Sasada do YARV ou Evan Phoenix do Rubinius? O que acha de todos esses esforços acontecendo em paralelo? Há alguma maneira onde vocês possam contribuir entre vocês?

**John Lam:** Estamos usando a suíte de especificações do Rubinius hoje, e planejamos lançá-lo junto com nossos fontes para garantir que iremos pegar bugs de compatibilidade cedo no processo. Sou culpado de não participar tanto quanto gostaria em falar mais com Charlie, Evan e Koichi sobre colaboração em especificações. Estamos focados em trazer o núcleo da linguagem rodando hoje, e temos vários outros projetos acelerados negligenciando documentar as coisas que temos aprendido. Quando desacelerarmos um pouco, serei capaz de gastar mais tempo me comunicando com os outros implementadores.

**AkitaOnRails:** Ruby tem várias deficiências conhecidas. Koichi está tentando melhorar algumas delas para o Ruby 1.9. Como você está lidando com problemas como a falta de threading nativo, o garbage collector mark and sweep simples, nenhuma máquina virtual e portanto nenhuma compilação em byte-code, problemas de performance, falta de internacionalização nativa (Unicode), várias extensões escritas em C?

**John Lam:** Nós ganhamos muitas coisas de ‘graça’ ao rodar sobre o CLR. Threading nativo é suportado em IronRuby. Nós usamos o garbage collector do CLR, que é um GC de classe mundial. Nós compilamos nativamente para IL, e nosso IL é compatível com o GC também o que é uma ótima coisa para aplicações de servidor que ficam de pé por um longo período. Nós obviamente suportaremos strings do CLR, que são strings Unicode e também suportaremos strings mutáveis do Ruby, que são baseadas em array de bytes. Não vamos suportar extensões baseadas em C, em vez disso estamos portando as bibliotecas baseadas em C, existentes no Ruby Standard Library para C# (ou Ruby).

**AkitaOnRails:** Existe algum benchmark comparando IronRuby ao MRI? Vocês acham que já o ultrapassaram? Existe algum problema hoje sobre a performance do Ruby sobre o DLR? Ou mais interessante: existe alguma comparação entre Ruby no DLR e C# ou VB.NET sobre o CLR?

**John Lam:** Somos mais rápidos que o MRI nos benchmarks do YARV, mas esse número muda diariamente. Uma coisa ótima sobre nossa equipe é que temos uma suíte de testes de regressão de performance que rodamos regularmente por todo nosso código. Isso torna trivial localizar uma compilação que causa uma regressão na performance, mesmo que deixemos para lidar com isso para mais tarde.

Não temos feito nenhuma otimização de performance até agora, estamos apenas usando funcionalidades que existem no DLR hoje, como caches inline polimórficos para caching eficiente de métodos call-site. À medida que nossa implementação amadurece, vamos otimizar IronRuby para performar bem em benchmarks de nível de aplicações (não micro-benchmarks, que são úteis para nós mas não tão interessantes para clientes reais). O DLR (e CLR) está se tornando mais rápido o tempo todo, e qualquer linguagem dinâmica construída sobre ele se beneficiará dessas melhorias.

Obviamente, linguagens como C# e VB.NET são mais rápidos que Ruby hoje. Mas estamos confiantes que podemos diminuir essa diferença significativamente com o tempo.

**AkitaOnRails:** E sobre ferramental? Vi que você mexeu no seu Visual Studio.NET para ter o tema Vibrant Ink que nós – usuários de Textmate – estamos acostumados, e ficou legal. Vi também uma foto de tela de code folding do Ruby dentro do Visual Studio. Como está esse suporte para Ruby?

**John Lam:** Neste momento nossa equipe não está envolvida com integração VS. Entretanto, o pessoal da [Sapphire in Steel](http://www.sapphiresteel.com/IronRuby-Visual-Designer) está fazendo um grande trabalho integrando IronRuby ao VS.

[![](http://s3.amazonaws.com/akitaonrails/assets/2007/11/12/editing_small.gif)](http://www.sapphiresteel.com/IronRuby-Visual-Designer)

**AkitaOnRails:** Você mencionou numa entrevista sobre a possibilidade de Ruby rodando sobre o Silverlight. Quão possível isso é hoje?

**John Lam:** Demonstramos IronRuby rodando sobre o Silverlight na RubyConf. A conversa deve ser publicada logo. Estamos planejando em convergir com o Silverlight a tempo para seu próximo CTP (fim deste ano, começo do ano que vem). Nessa época, vocês serão capazes de codificar Ruby que roda no seu browser.

**AkitaOnRails:** A Microsoft está aprendendo como lidar com as comunidades open source. Você acha que a adoção de tecnologias como Python e Ruby estão ajudando a empresa a entender o jeito open source? O que acha que ainda precisa melhorar? Quero dizer, se pudesse, o que você mudaria?

**John Lam:** A Microsoft é uma empresa grande e estamos trabalhando com muito empenho em colaborar com a comunidade Open Source. IronRuby é um dos projetos open source mais visíveis da empresa, e estamos ajudando a pavimentar o caminho para outras equipes que querem se engajar com a comunidade open source. Mudanças acontecem incrementalmente em grandes empresas e tem sido legal fazer parte dessa mudança!

**AkitaOnRails:** Silverlight foi lançado sobre uma licença open source também, de tal forma que o pessoal do [Mono](http://www.mono-project.com/Main_Page) foi capaz de rodá-lo muito rapidamente sobre o Mono. Você é próximo a Miguel de Icaza? O que pensa sobre o Mono? Um IronRuby rodando sobre ele significa um Ruby multi-plataforma que pode rodar sobre o Linux (com .NET). Se você atingir 100% de compatibilidade com o MRI e Rails, isso significa rodar sobre um Apache+mod\_mono no Linux e sobre o IIS no Windows, tudo desenvolvido sobre Orcas. Existe algum plano para esse tipo de integração e solução ponta-a-ponta?

**John Lam:** Na realidade, o Silverlight não está sob uma licença Open Source. O DLR, IronPython e IronRuby estão todos sob a Microsoft Public License, o que torna possível para Michel e sua equipe lançá-lo sobre sua implementação [Moonlight](http://www.mono-project.com/Moonlight) (que é a versão open source do Silverlight).

Eu adoro quão pragmático o Miguel é. Ele mostrou IronRuby rodando sobre o Mono na RubyConf e isso foi em grande parte por causa da equipe Mono consertar um monte de bugs de última hora para que pudéssemos fazer a demonstração (valeu!). DLR + Iron\* tende a empurrar fortemente o C# e o CLR. Nós encontramos bugs no compilador C# da Microsoft, e também no gmcs do Mono. Mas felizmente, ambas as equipes de C# e Mono têm sido ótimos consertando esses bugs para nos desbloquear.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/11/12/481182714_62e1d07f7c.jpg)

**AkitaOnRails:** Acho que é isso por hoje. Algum comentário para a audiência brasileira?

**John Lam:** Muito obrigado por enviar um grande conjunto de perguntar! Boa sorte com suas aventuras Ruby e espero que tenham uma chance para checar IronRuby no futuro.

