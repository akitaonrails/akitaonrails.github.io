---
title: Conversando com Adam Jacob
date: '2009-11-18T11:46:00-02:00'
slug: conversando-com-adam-jacob
translationKey: chatting-adam-jacob
tags:
- interview
- traduzido
aliases:
- /2009/11/18/chatting-with-adam-jacob/
draft: false
---

![](http://s3.amazonaws.com/akitaonrails/assets/2009/11/18/Opscode_logo_final_full_aspect_medium_original.png)

Gerenciamento de Configuração é um assunto complicado. Para quem não está familiarizado: quando você é um desenvolvedor com poucos servidores para cuidar, geralmente dá para se virar gerenciando-os manualmente. As pessoas provavelmente estão acostumadas a colocar um CD, dar duplo clique no programa "instalar" e clicar "avançar", "avançar" até o fim, depois entrar manualmente para fazer backup (quando se lembra), e às vezes até aplicar atualizações de segurança quando se lembra delas.

Mas quando você tem mais de uma dúzia de máquinas, as coisas começam a ficar feias. Você acaba cometendo mais erros, esquecendo etapas importantes, e de repente gerenciar máquinas vira um pesadelo. Você acaba sendo acordado no meio da noite porque esqueceu de instalar algum componente crucial, e por aí vai.

Da mesma forma que você precisa de testes e ferramentas de integração contínua como desenvolvedor, você também precisa de ferramentas automatizadas, confiáveis e flexíveis para o papel de administrador de sistemas. É aí que ferramentas como o **Chef** entram para ajudar.

Da [Opscode Inc.](http://opscode.com/), temos [Adam Jacob](http://twitter.com/adamhjk) (CTO) e [Jesse Robbins](http://twitter.com/jesserobbins) (CEO) para falar sobre o novo concorrente no campo de administração de sistemas automatizada, o [Chef](http://www.opscode.com/chef/), já em uso em muitas empresas que se esforçam na vanguarda para manter seus datacenters.


**AkitaOnRails:** Para começar esta entrevista, seria ótimo ter mais informações de background sobre vocês. Como vocês chegaram ao espaço de gerenciamento de configuração?

![](http://s3.amazonaws.com/akitaonrails/assets/2009/11/18/adam_jacob_original_original.png)

**Adam:** Sou administrador de sistemas há 13 anos e, na maior parte desse tempo, trabalhei em empresas que faziam muitas fusões e aquisições. A cada dois meses adquiríamos uma nova empresa e era minha função ajudar a descobrir como absorver essas empresas no todo. Fiquei muito bom em analisar uma aplicação com a qual não tinha nada a ver com a criação e descobrir o que precisava ser feito para escalá-la (ou pelo menos fazê-la funcionar).

Uma coisa que não podíamos fazer era dizer às pessoas que construíram as aplicações que elas precisavam ser radicalmente alteradas — em muitos casos, elas nem estavam mais lá. O que isso significava na prática era que precisávamos de uma arquitetura subjacente muito flexível e modular — tudo que fazíamos tinha que servir à aplicação, e não o contrário. Por necessidade, isso significou me tornar um desenvolvedor de ferramentas — se não tivéssemos as ferramentas de que precisávamos, nunca conseguiríamos fazer o trabalho diante de nós.

Eventualmente cofundei uma empresa de consultoria chamada HJK Solutions. Construímos infraestrutura totalmente automatizada para startups — desde a instalação do SO até o deployment de aplicações, tudo totalmente automatizado (incluindo Gerenciamento de Identidade, Monitoramento e Tendências, etc.). Ao longo dos dois anos seguintes, construímos infraestrutura para 12 startups diferentes, cujos produtos iam de gerenciamento de frotas de carros elétricos a namoro online.

Então chego ao gerenciamento de configuração pelas trincheiras — como administrador de sistemas de linha tentando facilitar minha vida, como consultor ajudando outros a colher os benefícios, e agora como construtor de ferramentas tentando avançar o estado da arte.

![](http://s3.amazonaws.com/akitaonrails/assets/2009/11/18/Jesse_Robbins_original_original.png)

**Jesse:** Jesse Robbins é CEO da Opscode (criadores do Chef) e um especialista reconhecido em Infraestrutura, Operações Web e Gerenciamento de Emergências. Atua como co-presidente da Velocity Web Performance & Operations Conference e contribui para o O'Reilly Radar. Antes de cofundar a Opscode, trabalhou na Amazon.com com o título de "Master of Disaster" onde era responsável pela disponibilidade do site para todas as propriedades com a marca Amazon. Jesse é bombeiro voluntário/técnico de emergências médicas e gerente de emergências, e liderou uma força-tarefa implantada na Operação Furacão Katrina. Suas experiências no serviço de bombeiros influenciam profundamente seus esforços em tecnologia, e ele se esforça para destilar seu conhecimento desses dois mundos e aplicá-lo em serviço de ambos.

**AkitaOnRails:** Qual é a história por trás da Opscode, qual é sua missão e qual é a história da criação do Chef?

**Opscode:** A história por trás da Opscode realmente começa quando conhecemos Jesse. Ele havia escrito um artigo para o O'Reilly Radar sobre [Operações sendo o novo molho secreto](http://radar.oreilly.com/2007/10/operations-is-a-competitive-ad.html) para startups. Ele e eu tomamos um café, nos tornamos amigos e ficamos em contato. Jesse entende a cultura de operações de forma visceral, e está muito bem conectado a uma enorme comunidade de pessoas com mentalidade semelhante que eu nem sabia que existia.

À medida que nossa empresa de consultoria crescia, chegamos a uma encruzilhada — claramente tínhamos um bom negócio, e não era difícil encontrar mais trabalho. O que era difícil era encontrar pessoas com as habilidades para de fato fazer o deploy de uma nova infraestrutura e adaptar a stack que desenvolvemos para uma nova aplicação. Não podíamos evitar o fato de que havia algumas semanas de trabalho muito intenso necessário para colocar toda a infraestrutura funcionando para um novo cliente.

Tentamos recrutar Jesse durante esse período, já que ele era um daquelas pessoas raras que podiam fazer esse engajamento inicial intenso. Ele recusou — principalmente porque via o que fazíamos: poderíamos construir uma empresa de consultoria enorme, mas ainda seria nas trincheiras todos os dias. A menos que conseguíssemos superar esse obstáculo, provavelmente havia formas menos estressantes de ganhar a vida. :)

Então começamos a analisar o que nos impedia de conseguir essa parte inicial do engajamento o mais rapidamente possível. O que nos impedia de literalmente fazer um cliente preencher um questionário e deixar esses dados orientar 95% das decisões sobre a infraestrutura?

A resposta, em uma palavra, era "tudo". Toda a stack de ferramentas open source que estávamos usando havia sido construída em uma era diferente e via o mundo por uma lente muito diferente. Precisávamos que tudo tivesse uma API, precisávamos que tudo fosse mais aberto com seus dados e precisávamos que tudo fosse flexível o suficiente para lidar com a próxima evolução das arquiteturas de aplicações (seja lá o que isso fosse ser).

Com essa revelação, o próximo passo foi descobrir como seria uma "nova stack" de verdade. Se pudéssemos começar do zero, o que levaríamos e o que deixaríamos para trás? A Amazon havia feito um trabalho tão bom mostrando como uma API sobre o processo de bootstrapping poderia parecer, e os benefícios que poderiam ser obtidos com essa abordagem. Supondo que algo assim existisse para bootstrapping, e a próxima camada da stack (configuração)?

Começamos a experimentar com o Chef durante esse período de questionamentos. Começamos a trabalhar no Chef com o objetivo de nos colocar fora dos negócios — tornando a barreira de entrada para ter uma infraestrutura totalmente automatizada tão baixa que qualquer desenvolvedor ou administrador de sistemas pudesse simplesmente fazê-lo. Construímos um protótipo, mostramos para Jesse e ele concordou em se juntar ao time.

A Opscode nasceu então, e nossa missão surgiu desses experimentos: estamos levando a Automação de Infraestrutura para as Massas. Queremos derrubar as barreiras de entrada que impedem as pessoas de ter uma infraestrutura realmente ótima, repetível e automatizada. Nosso papel é trazer aos desenvolvedores e administradores de sistemas as melhores ferramentas possíveis para que possam construir os sistemas que sempre quiseram.

Captamos 2,5 milhões da DFJ em janeiro de 2009 com essa visão e desde então temos trabalhado nisso.

**AkitaOnRails:** Gostaria de dizer que apenas sysadmins amadores fazem tudo manualmente, mas acho que a maioria das corporações pequenas e médias ainda faz tudo manualmente ou com scripts aleatórios espalhados por todo lugar. A noção de "gerenciamento de configuração" ainda é nova para muita gente. Você poderia explicar brevemente o que é e por que é importante?

**Opscode:** Para mim, "Gerenciamento de Configuração" em sua essência é tudo que você precisa fazer para levar um sistema de "rodando um sistema operacional" para "fazendo seu trabalho". Quando um administrador de sistemas configura um sistema manualmente e posta suas notas em um Wiki, ele está praticando a forma mais primitiva de Gerenciamento de Configuração.

Ter essas notas é melhor que nada — quando ela precisar fazer aquela tarefa de novo, pode pelo menos voltar e lê-las para se lembrar do que fez da última vez. Mas ainda precisa fazer tudo de novo — e a repetição cansa. Então ela começa a escrever scripts que encapsulam esse conhecimento em código, de modo que agora só precisa executar uma série de comandos menores.

O tempo passa, porém, e a entropia entra em ação. Os sistemas começam a derivar de onde estavam quando o administrador escreveu os scripts. Logo os scripts não rodam mais, ou se rodam, a configuração que constroem está errada. Nossa destemida admin começa então a editar os scripts ou criar novos para lidar com o sistema nesse novo estado. Isso é o estágio que chamamos de "tool sprawl" — você tem uma ferramenta para cada fase diferente do ciclo de vida observável de um sistema.

As ferramentas modernas de gerenciamento de configuração resolvem esse problema fornecendo um framework para descrever o estado final em que um sistema deve estar, em vez dos passos discretos que devemos seguir para chegar lá em qualquer momento. Em vez de escrever um script que lista os comandos para instalar o Apache, escrever o arquivo de configuração e iniciar o serviço, você descreveria que "apache deve estar instalado", o arquivo de configuração "deve ter esta aparência" e o serviço "deve estar rodando".

Quando o sistema de gerenciamento de configuração roda, ele analisa cada uma dessas descrições individualmente e garante que estejam no estado adequado. Não nos importa mais qual é o estado inicial do sistema — o sistema de gerenciamento de configuração só tomará ação em cada etapa se o sistema não estiver no estado que você descreveu. Se você rodar novamente e nada tiver mudado, o sistema não toma nenhuma ação. (Os geeks de gerenciamento de configuração chamam essa propriedade de [idempotência](http://en.wikipedia.org/wiki/Idempotence))

Isso significa que você pode descrever seus sistemas uma vez em código e, à medida que mudam com o tempo, simplesmente atualizar esse código para refletir o estado desejado. O impacto desse modelo no dia a dia de um administrador de sistemas não pode ser subestimado — torna tudo mais fácil.

Também tem impactos enormes fora do mundo dos administradores de sistemas. Você agora tem um documento vivo que descreve como todos os seus servidores estão configurados — pode compartilhá-lo, colocá-lo em controle de versão, imprimi-lo para um auditor. Processos de negócios que antes exigiam intervenção manual frequentemente podem ser reduzidos a mudanças discretas. Quanto mais você trabalha dessa forma, mais os impactos se espalham pela organização.

**AkitaOnRails:** Embora a comunidade Ruby provavelmente compare Chef com Puppet, acho que um dos sistemas mais amplamente utilizados é o CFEngine2. Como o Chef se compara ao CFEngine2?

**Opscode:** O Cfengine 2 é onde quase todo mundo no mundo do gerenciamento de configuração aprendeu. Mark Burgess é responsável pelos artigos acadêmicos que delinearam a ideia de que cada parte do sistema deve ser idempotente, e seu trabalho estudando como sistemas do mundo real podem ser gerenciados em escala fez mais para impactar a evolução do gerenciamento de configuração do que qualquer outro indivíduo.

Além da ideia de recursos idempotentes, Burgess introduziu o conceito maior de "convergência". A ideia básica aqui é que se você tem a descrição de como cada recurso finito deve ser configurado, dado tempo suficiente, esses recursos trarão o sistema para um estado compatível. A ordem em que os recursos rodam fundamentalmente não importa — eventualmente, todos chegarão ao lugar certo.

Embora esse modelo funcione em um nível fundamental, tem algumas ineficiências bastante dramáticas. O Cfengine aplica recursos com base em seu tipo — todos os arquivos são gerenciados de uma vez, depois todos os serviços, depois todos os pacotes. Você pode controlar a ordem em que são executados com o 'actionsequence', mas cada sistema tem apenas uma ordem. Então se você precisa copiar um arquivo, instalar um pacote e reiniciar um serviço, é fácil o suficiente de modelar. Quando você começa a entrar em configurações mais complexas, porém, fica cada vez mais difícil montar um actionsequence que permite configurar todo o seu sistema em uma única execução.

Isso não é um bug no Cfengine — é por design. A convergência é a resposta — não tem problema precisar rodar mais de uma vez; eventualmente chegará lá. Se você está pensando demais sobre a ordem em que as coisas devem acontecer, provavelmente não está pensando em descrições idempotentes.

Na minha experiência, porém, isso era frustrante em escala. Significava que o tempo necessário para configurar um sistema aumentava à medida que a configuração ficava mais complicada, e sua capacidade de modelar interações complexas no sistema tornava-se cada vez mais opaca.

Para a era em que foi escrito, esse problema importava muito menos. Se leva de 6 a 8 semanas para pedir um servidor, depois mais uma semana para instalá-lo no rack e instalar o SO, o fato de que o Cfengine precisa rodar 3 vezes para configurá-lo não importa muito. (Você tem problemas muito maiores!) Em um mundo onde muitos de nós podemos ir de bare-metal a um sistema operacional rodando em 5 minutos, seja por nossos próprios sistemas de instalação ou por uma chamada de API à AWS, isso começa a importar muito.

O Chef adota uma abordagem diferente. Começamos com a ideia de um "recurso" idempotente — um pacote, um serviço, etc. Adicionamos a ideia de "ações" — todos os diferentes estados que você pode querer solicitar que um recurso esteja. Depois você coloca esses recursos em "recipes", que são avaliadas na ordem em que são escritas. Você pode então fazer com que recipes dependam de outras recipes que tenham sido concluídas antes de serem executadas, dando-lhe a capacidade de dizer "certifique-se de que o Apache está instalado antes de configurar minha Aplicação Web".

O objetivo é que, com Chef, você sempre possa trazer o sistema ao estado adequado com uma única execução do Chef. Ele vê a convergência como uma resposta a um bug — um sistema que está 1/2 configurado está, de fato, quebrado. Se a causa do bug for ambiental — um serviço de rede não está disponível, por exemplo — então rodar o Chef novamente provavelmente corrigirá as coisas. Se o problema é que você não especificou a ordem em que quer que os recursos sejam configurados, então é um bug em suas recipes. Se você não consegue escrever uma recipe para configurar seu sistema em uma única execução do Chef, é um bug no Chef.

Isso também tem efeitos colaterais para raciocinar sobre o sistema em escala. Dada a mesma configuração e atributos, o Chef sempre se comportará da mesma forma, em todos os sistemas. À medida que você adiciona mais e mais coisas ao sistema, ainda é fácil raciocinar sobre quando e como elas serão configuradas.

Curiosamente, o Cfengine 3 implementa um sistema muito similar ao Chef. Em vez de uma actionsequence global única, usa um 'bundlesequence', onde bundles são aproximadamente análogos ao conceito de recipe do Chef.

Outra diferença importante é que o Chef permite que você 'olhe para cima' em toda a sua infraestrutura ao configurar um sistema. Essa capacidade é útil quando você quer fazer coisas como configurar um sistema de monitoramento ou um load balancer. Você pode fazer perguntas ao Chef como "quais são todos os servidores rodando minha aplicação em produção" e usar a resposta para configurar seu sistema. (Você pode ver um exemplo disso no [nosso blog](http://www.opscode.com/blog/2009/10/07/preview-chef-0-8-and-the-opscode-platform/))

Do ponto de vista de arquitetura de sistemas, Chef e Cfengine são na verdade bastante similares. Ambos empurram a maior parte do trabalho difícil de configurar um sistema para os próprios sistemas. Isso é muito vantajoso em escala — os servidores do Chef e do Cfengine são na verdade sistemas glorificados de transferência de arquivos.

Diferimos bastante em nossa abordagem sobre como deve ser uma linguagem para gerenciamento de configuração, mas falarei mais sobre isso numa pergunta posterior.

O Cfengine está em uso em alguns dos maiores datacenters da indústria e alterou fundamentalmente o panorama do gerenciamento de sistemas. Embora não seja mais a ferramenta que quero, não se pode subestimar o impacto que teve no design de todas as ferramentas de gerenciamento de configuração que vieram depois — incluindo o Chef.

**AkitaOnRails:** O Chef tem muitos componentes. Você pode descrever brevemente todos os principais componentes que trabalham juntos? O lado do cliente, o lado do servidor, os cookbooks?

**Opscode:** Claro! A parte mais importante do Chef são os cookbooks — é onde você realmente descreve sua configuração. Eles coletam recipes e todos os assets necessários para a recipe rodar (arquivos, templates, etc.). [Cookbooks](http://cookbooks.opscode.com) são muito frequentemente compartilháveis e já existem muitos deles.

O Chef pode executar seus cookbooks em dois modos — um modo cliente/servidor (chef-client) ou um modo standalone (chef-solo). Quando você executa chef-solo, passa uma URL para um tarball cheio dos cookbooks que você quer rodar. Não há mais infraestrutura do que isso — coloque seus tarballs em algum lugar onde possa baixá-los e se divirta.

No modo cliente/servidor, cada cliente Chef é configurado para se comunicar com um Chef Server. O servidor armazena informações sobre cada cliente (muitas delas — coisas como endereços IP, módulos de kernel carregados e mais) e distribui os cookbooks de que precisam para se configurar. Ele também fornece uma API REST e uma interface Web interativa, para que você possa alterar facilmente a configuração de seus sistemas de forma centralizada. Por fim, todos os dados que o servidor coleta são indexados e pesquisáveis — você pode usar isso em suas recipes para configurar serviços que requerem configuração complexa e dinâmica. (Alguns exemplos seriam descobrir dinamicamente um servidor MySQL master ou encontrar todos os servidores memcached em um cluster)

**AkitaOnRails:** O que você diria sobre a maturidade do Chef? O CFEngine tem mais de uma década de uso, o que é difícil de superar. Você diria que é "maduro o suficiente"? Ou seja, já está em produção em empresas de muitos tamanhos, suas APIs não mudam muito e meus cookbooks provavelmente funcionarão se eu atualizar para uma versão mais nova do Chef?

**Opscode:** O Chef tem pouco mais de um ano — foi lançado ao público em 15 de janeiro de 2009. Desde então, 42 desenvolvedores diferentes contribuíram para o [projeto](https://www.ohloh.net/p/opscode-chef/factoids/2025809), sendo que cerca de 5 trabalham para a Opscode. Está em uso em produção no Engine Yard Cloud desde o dia do lançamento. Desde então, foi adotado por empresas e universidades de todos os tamanhos, de pequenas startups a grandes empresas com requisitos de compliance muito pesados.

Então definitivamente é "maduro o suficiente" para uso no mundo real — muitas pessoas o usam e dependem dele todos os dias. Equilibrar esse conhecimento com a realidade de que o projeto está em rápida evolução é importante, e tentamos fazer isso de várias formas:

1. A sintaxe de recipe é considerada basicamente "completa". Se fizermos mudanças, elas são retrocompatíveis com lançamentos anteriores do Chef. Salvo algo verdadeiramente incrível que altere radicalmente a forma do universo, isso permanecerá verdadeiro.
2. Testamos muito. O Chef tem mais de 2000 unit tests e functional tests que cobrem toda a API REST e muitos dos recursos individuais (visamos 100% de cobertura de testes de features). Há mais linhas de código testando o Chef do que linhas de código no próprio Chef.
3. Se de fato quebrarmos compatibilidade retroativa, tentamos fazer isso apenas quando incrementamos a revisão minor. Se você tem uma versão 0.7.x do Chef instalada, ela deve sempre funcionar com outras versões do Chef no mesmo ciclo de lançamento.

A maior parte do trabalho no Chef atualmente é sobre adicionar mais funcionalidades, não em mudar a forma como as funcionalidades existentes funcionam. É seguro usar o Chef hoje — no futuro, você continuará recebendo mais ingredientes para adicionar ao mix, em vez de ter que refatorar profundamente a forma como você faz as coisas.

Por fim, a Comunidade Chef é verdadeiramente épica — temos muitas pessoas que dedicam quantidades significativas do seu tempo ao Chef. Mesmo que não estejam contribuindo código, estão respondendo perguntas, escrevendo documentação, ficando no IRC e oferecendo cupcakes. É um grupo de pessoas focadas em resolver problemas do mundo real e ajudar umas às outras a fazer o mesmo. É de longe o que mais me orgulha e acho que tem um impacto significativo em se o Chef está pronto para o prime time. O banco é realmente muito profundo.

**AkitaOnRails:** O Chef usa Ruby diretamente, o que alguns diriam ser uma bênção e uma maldição. Provavelmente é perfeito para Rubistas, mas sinto que a maioria dos sysadmins está acostumada com Bash, Python e não é muito flexível a mudanças. Por que você escolheu usar Ruby em vez de uma linguagem mais simples?

**Opscode:** A resposta para a pergunta de por que usamos Ruby diretamente para a linguagem de configuração tem duas partes: por que estendemos uma linguagem 3GL em vez de construir uma DSL declarativa ou uma linguagem de modelagem completa, e por que escolhemos Ruby como essa 3GL.

Primeiro, por que estendemos uma 3GL. Ferramentas como Cfengine e Puppet constroem uma DSL declarativa para gerenciamento de configuração — uma linguagem customizada que fornece um modelo dentro do qual administradores de sistemas ou desenvolvedores de software podem trabalhar para automatizar seu sistema. Outras ferramentas como o EDML e ECML da Elastra, o DCML da OpsWare ou o Bcfg2 dão a você um schema XML para descrever como o sistema deve se comportar.

O problema com essas abordagens é que, por definição, elas devem construir uma abstração para cada tarefa que o usuário final pode querer realizar: uma façanha impossível. O nível de complexidade inerente à automação, aliado à incapacidade de recorrer a construções de linguagem 3GL quando necessário, resulta em um sistema que só pode lidar com um subconjunto da complexidade total, em vez de permitir que os usuários encontrem soluções inovadoras para seus problemas específicos. Ao aproveitar o Ruby, adicionar suporte para outros casos de uso é uma questão de adicionar novos conjuntos de classes base mantendo consistência e acessibilidade no design de sua interface, porque o escopo completo da linguagem está disponível.

Nosso objetivo com o Chef era manter a simplicidade que vem de ter o foco na declaração de recursos idempotentes, enquanto dá a você a flexibilidade de uma 3GL completa. Em termos práticos, tudo que você pode fazer com Ruby, você pode fazer com Chef — e como Ruby é uma 3GL, isso equivale a essencialmente qualquer coisa.

Larry Wall, o criador do Perl, tem uma citação que adoro:

> "Para a maioria das pessoas, a utilidade percebida de uma linguagem de computador é inversamente proporcional ao número de eixos teóricos que a linguagem pretende afiar."

Como queríamos que o Chef tivesse a máxima utilidade, ativamente tentamos remover o maior número possível de eixos teóricos — a crença de que podemos imaginar a amplitude total do espaço do problema sendo um deles. Há mais de uma forma de fazer isso com Chef, e o único critério válido para avaliar o sucesso do seu projeto de automação é se ele resolve seus problemas de forma confiável.

Na prática, você precisa saber muito pouco de Ruby para usar o Chef. Aqui está um exemplo de instalação do programa "screen":

* * *
ruby

package "screen" do   
 action :install  
end  
-

O mesmo em Puppet:

* * *

package { "screen":   
 ensure =\> present   
}  
-

E em Cfengine 2:

* * *

packages:  
 screen action=install  
-

Embora todos esses sistemas exijam aprender a sintaxe, em um nível base não há muita diferença entre eles em termos de aprendizado bruto necessário. A diferença é que quando você atinge uma limitação no Chef, você tem a capacidade de inovar facilmente, e quando atinge as mesmas limitações em outras ferramentas, você não tem.

Escolhemos Ruby por sua capacidade bastante única de criar nova sintaxe facilmente. Ferramentas como Rspec são bons exemplos de formas como você pode manipular Ruby de forma útil e que são muito difíceis de replicar em outras ferramentas. Queríamos garantir que, mesmo estando "em" uma 3GL, você não precisasse passar por obstáculos adicionais para fazer as coisas simples funcionarem. Ruby era a linguagem em que eu me sentia suficientemente confortável e que eu sabia ter a capacidade de tornar isso realidade.

Dito isso, um de nossos objetivos é estender a capacidade de escrever recipes Chef para outras 3GLs. Já temos um exemplo disso com Perl — e não fizemos nenhuma mudança no código fonte do Chef para isso. Você pode ver o [demo aqui no CPAN](http://search.cpan.org/~holoway/Chef-0.01/lib/Chef.pm). Funciona usando a API JSON do Chef para enviar os recursos compilados para a biblioteca Ruby para execução, e ao longo do tempo estaremos estendendo essas interfaces. Você poderá ter recipes escritas em Python interoperando com recipes escritas em Ruby e Perl.

**AkitaOnRails:** O Chef tem (ou precisa de) algo como o Augeas, que o Puppet está tentando suportar?

**Opscode:** O Augeas é interessante. O Chef não tem suporte ao Augeas hoje, e a razão é que ninguém precisou tanto a ponto de escrever a integração. Uma razão é que, com o Chef, é bastante fácil adicionar dinamicamente a um recurso (como, por exemplo, um template) ou pesquisar sistemas específicos que correspondam a um critério. Isso significa que o caso de uso do Augeas (que edita arquivos in-place) é menos necessário — você muitas vezes pode obter os dados necessários para renderizar um template, em vez de precisar construí-lo ao longo do tempo com edições incrementais.

Achamos que isso é uma prática melhor em geral, pois garante que todos os sistemas que você está gerenciando sempre possam ser restaurados a um estado funcional a partir apenas do repositório de cookbooks. Se você usa o Augeas para permitir mudanças idempotentes de linhas individuais de um arquivo de configuração, ele incentiva o comportamento de administradores individuais editando arquivos in-place, o que é um anti-padrão de gerenciamento de configuração.

**AkitaOnRails:** Sysadmins acostumados ao CFEngine reclamam das dependências do Ruby e do peso geral. Porque para o Chef rodar você precisa do Ruby instalado. Nem todas as distros têm Ruby na mesma versão (embora a maioria já tenha migrado para 1.8.7). Depois há o problema do peso. Não estou familiarizado com o Chef, mas o Puppet pode chegar a centenas de megabytes. O que não querem é ter clusters de máquinas Chef (que, por si só, também precisam de manutenção, adicionando à complexidade geral). Como vocês lidam com datacenters com milhares de servidores? Sei que é difícil medir com precisão, mas qual seria uma proporção razoável entre servidores Chef x servidores gerenciados?

**Opscode:** Ao avaliar a escalabilidade de sistemas de gerenciamento de configuração, você quer analisar dois eixos diferentes. O horizontal, que é o número de sistemas que podem ser gerenciados por um único servidor de gerenciamento de configuração a uma taxa específica de mudança, e o vertical, que é quanto da sua infraestrutura pode ser automatizada pela ferramenta.

No eixo vertical, acho que o Chef é o claro vencedor, por razões que acho bem resumidas pela minha resposta à pergunta 7. Colocaria o Puppet em segundo lugar e o Cfengine por último.

No eixo horizontal, o Cfengine é o claro vencedor. É escrito em C e tem o componente de servidor mais fino possível — basicamente não faz nada além de autenticar clientes e servir arquivos. Conheço em primeira mão datacenters que estão rodando enormes quantidades de servidores com um único servidor cfengine.

Uma métrica importante a ter em mente ao discutir a escalabilidade horizontal de uma solução de gerenciamento de configuração é que a métrica mais importante é a **taxa de mudança**. Todas as ferramentas sobre as quais estamos falando são baseadas em 'pull' — os clientes fazem check-in em um 'intervalo' com o servidor e aplicam um _'splay'_ para garantir que nem todos os sistemas façam check-in de uma vez. Uma configuração out-of-the-box comum é um intervalo de 30 minutos com um splay de 15 minutos. (Isso significa que um servidor faz check-in a cada 30-45 minutos, dependendo.) Se você se sentir confortável em aumentar esse intervalo, obterá mais escalabilidade com menos recursos (reduzindo a quantidade de concorrência).

Então, quando alguém disser "tenho 10 mil servidores em um único servidor de gerenciamento de configuração", pergunte "a que intervalo?".

O Chef escala como uma aplicação web. O próprio servidor é bastante leve e é responsável por autenticar clientes, transferir arquivos, armazenar o estado dos nós e fornecer uma interface de busca. Ele escala horizontalmente adicionando novos Servidores Chef conforme necessário. A API é RESTful e não há estado de sessão entre os clientes e o servidor (pelo menos não no Chef 0.8+). Quando você encontra problemas de escalabilidade com o Chef, as ferramentas que você aplica são as mesmas que você aplica a qualquer aplicação web bem projetada.

Você perguntou especificamente sobre utilização de memória — o Chef se sai muito bem nesse aspecto. Os processos de servidor individuais geralmente têm entre 14-50MB residente. O próprio cliente, rodando em modo daemon, geralmente fica em torno de 28MB residente.

Em nossos testes, o gargalo atual em um servidor Chef é CPU. O Chef é inteligente sobre como lida com transferências de arquivos — transferimos apenas arquivos que mudaram no servidor. Para suportar isso, calculamos um checksum para cada arquivo solicitado e atualmente não armazenamos os resultados em cache. Planejamos corrigir isso para o próximo lançamento principal do Chef (0.8.0), o que deve mudar o gargalo para a RAM.

Com o Chef 0.7, você deve ser capaz de suportar milhares de clientes a um intervalo de meia hora e splay de quinze minutos em hardware commodity razoável. As mudanças no Chef 0.8 devem elevar esse número dramaticamente — voltarei com alguns benchmarks assim que os patches estiverem prontos. :)

**AkitaOnRails:** Provavelmente relacionado à pergunta anterior: parece que especialmente após a Sarbanes-Oxley houve um interesse crescente em coisas como ITIL e CoBit. Você já viu implementações bem-sucedidas desses em infraestrutura no estilo Web? Quero dizer, posso vê-los funcionando em Bancos, Aeroespacial e Defesa, etc., mas não consigo ver funcionando conforme anunciado em um ambiente muito dinâmico como hospedagem de serviços Web. Quais são suas experiências com essa questão?

**Opscode:** Bem, acho que você pode pensar em ITIL da mesma forma que pensa no modelo clássico 'Waterfall' de desenvolvimento de software. Para alguns tipos de projetos e empresas, é essencial — é difícil imaginar trabalhar de outra forma. Na maioria das vezes, são empresas com grandes preocupações de fabricação ou controle de qualidade — saúde médica, aeroespacial, bancário e financeiro, etc.

O mesmo se aplica ao ITIL — quanto maior a organização, mais rigorosos os requisitos e maior o prazo de entrega, mais os processos que descrevem começam a fazer sentido. Como todos os grandes processos, porém, tendem a diminuir o elemento humano — as pessoas têm papéis a desempenhar e formulários a preencher. :)

Na cultura de Web Ops, as coisas são diferentes. Nunca vi um casamento bem-sucedido entre ITIL e Web Ops, e a razão é que os domínios são muito diferentes. Se há um bug no site, é melhor enviar a correção agora do que esperar por um processo de gestão de lançamento para garantir que o site não terá mais problemas com base na sua correção, por exemplo. Também é um ajuste cultural ruim — nas melhores equipes de Web Ops, o foco é intenso em comunicação, agilidade e respeito, em vez de processo, formalismo e ferramentas. A mudança que você começa a ver nas grandes empresas de Web Ops é que seu pessoal de operações se torna habilitador da organização, em vez de bloqueadores de linha final de mudanças (para manter a estabilidade alta).

Em geral, acho que os 4 passos descritos no visible ops para gestão de emergências não são ruins, mas o diabo está sempre nos detalhes. A pessoa que você deveria realmente perguntar sobre isso é Jesse — ele é em grande parte responsável pela cultura operacional da Amazon e sabe o que significa começar a hackear esse tipo de coisa de dentro de grandes organizações.

**AkitaOnRails:** Incrível, acho que é isso. Muito obrigado por esta entrevista!
