---
title: Conversando com Hongli Lai e Ninh Bui (Phusion)
date: '2008-05-06T21:39:00-03:00'
slug: conversando-com-hongli-lai-e-ninh-bui-phusion
translationKey: chatting-hongli-lai-ninh-bui
tags:
- interview
- traduzido
aliases:
- /2008/05/06/chatting-with-hongli-lai-and-ninh-bui-phusion/
draft: false
---

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/5/7/Picture_4.png)

**Hongli Lai** e **Ninh Bui**, da Phusion, sacudiram o mundo Rails alguns dias atrás. Eles lançaram o Santo Graal do deploy Rails: o **mod_rails**, recebido com muito entusiasmo — e merecidamente.

Eles finalmente resolveram o grande problema que [envergonhava](http://www.rubyinside.com/no-true-mod_ruby-is-damaging-rubys-viability-on-the-web-693.html) os Railers no passado. Isso também vai aliviar dezenas de serviços de hospedagem que não faziam ideia de como resolver essa equação. Agora, esses dois estudantes de ciência da computação estão acima de todos com essa solução inteligente. E ainda têm mais por vir.

Tive a sorte de conseguir entrevistá-los. Acho que esta é a segunda entrevista — a InfoQ furou a notícia com esta outra [entrevista](http://www.infoq.com/news/2008/04/phusion-passenger-mod-rails-gc), que recomendo muito para entender melhor os mecanismos internos do Passenger. Eles são muito tranquilos e foi um prazer conversar com eles.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/5/7/Picture_3.png)

**AkitaOnRails:** Acho que a primeira coisa que gostaria de saber são os seus históricos. O que veio primeiro? [mod_rails](http://www.modrails.com/) ou [Phusion](http://www.phusion.nl)? Ou seja, vocês tinham uma empresa chamada Phusion que acabou desenvolvendo mod_rails, ou foi o mod_rails que motivou a criação do negócio?

**Phusion:** Bem, como você provavelmente já leu, somos ambos estudantes de ciência da computação na [Universidade de Twente](http://www.utwente.nl/en/) e estamos atualmente nas etapas finais para concluir nossos bacharelados. Desde o início, já inferíamos que o estudo não pode te ensinar tudo, então ao longo dos anos também fizemos muito trabalho tanto comercialmente quanto para a comunidade open source.

Depois de nos familiarizarmos com as habilidades, filosofias e traços pessoais um do outro e com base em nossa experiência anterior trabalhando em TI, achamos que seria uma boa ideia combinar nossas forças em uma empresa que pudéssemos chamar de nossa, e assim surgiu a Phusion.

Então a Phusion veio antes do Passenger (mod_rails). Mais especificamente, nossa intenção era criar uma empresa que fornecesse estritamente produtos, ideias e serviços de TI de primeira linha para apoiar os negócios de nossos clientes. Passenger, coincidentemente, acaba sendo nosso primeiro produto, e pelo que temos ouvido tanto da comunidade quanto das empresas, parece estar perfeitamente alinhado com a filosofia da nossa empresa.

Além disso, depois de anos de desenvolvimento (web) em outras linguagens/frameworks como PHP, J2EE, ASP.NET etc., chegamos a realmente apreciar Ruby on Rails. Achamos que é realmente elegante e fácil de usar. Infelizmente o deploy parecia estar fora de linha com o resto da experiência Rails, especialmente a parte de convenção sobre configuração. É por isso que criamos o Passenger: queremos que a experiência de deploy seja igualmente tranquila.

**AkitaOnRails:** Phusion é uma empresa de consultoria ou uma empresa de produto? Agora vocês lançaram um dos projetos mais interessantes do mundo Rails até agora, que é o mod_rails. Agora vocês estão preparando o lançamento do Ruby Enterprise Edition. Algum produto novo no pipeline que possam nos contar?

**Phusion:** Bem, a Phusion é primariamente uma empresa orientada a serviços e achamos que nossa declaração de missão responde melhor a essa pergunta:

_"Fornecer exclusivamente produtos, serviços e ideias de primeira linha, a fim de apoiar os negócios de nossos clientes."_

Se os negócios de nossos clientes exigirem consultoria, também somos capazes de fornecer isso, uma vez que temos alguns anos de experiência nessa linha de negócios específica.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/5/7/Picture_1.png)

Para alcançar essa missão, é crucial para nós sermos bem versados em uma variedade de habilidades e estamos bem cientes do ditado _"pau para toda obra, mestre em nenhuma"_. É por essa razão que nossa equipe é composta apenas de pessoas altamente qualificadas das áreas da indústria que são de particular interesse para os negócios de nossos clientes. O leitor provavelmente notará que isso permite uma configuração dinâmica na organização, além de manter o trabalho desafiador: não acreditamos em [manter pessoas por tempo indefinido sem razões racionais](http://thedailywtf.com/Articles/Up-or-Out-Solving-the-IT-Turnover-Crisis.aspx), então é crucial que nossos funcionários continuem aprendendo dentro da nossa organização (daí o apelido, _"a empresa de ciência da computação"_). Isso não só abre muitas portas no lado da inovação, mas também resulta em pessoas se tornando mestres em várias áreas. Então _"pau para toda obra, mestre em nenhuma"_ pode ser verdade, mas acreditamos que _"mestre em muitas áreas"_ pode ser igualmente verdade. Desnecessário dizer que isso é crucial, pois ciência da computação e TI cobrem uma área tão vasta, e isso é particularmente verdade para os negócios de nossos clientes.

Ruby Enterprise Edition foi na verdade concebido como resultado do Passenger: ele se esforça para reduzir dramaticamente o uso de memória de aplicações Ruby on Rails executadas através do Passenger.

Quanto a novos produtos, atualmente estamos trabalhando em alguns serviços web baseados em assinatura. Nosso amigo David Heinemeier Hansson recentemente deu uma palestra sobre startups que elabora sobre as razões pelas quais alguém gostaria de seguir esse caminho. Recomendamos muito ao leitor [conferir isso](http://www.justin.tv/hackertv/97862/DHH_Talk__Startup_School_2008) e, por razões estratégicas, gostaríamos de deixar por aqui por ora.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2008/5/7/2400947055_2ce7bcf70b.jpg)  
Hongli Lai

**AkitaOnRails:** Por muito tempo toda a comunidade Rails estava um tanto confortável demais com a solução Mongrel. Quando Zed Shaw fez seu rant sobre a comunidade, foi um alerta e a partir daí vimos alternativas surgindo da noite para o dia como Thin e Ebb. O que vocês acharam dessa situação na época?

**Phusion:** Pelo que entendemos, soluções como Mongrel, Thin e Ebb se enquadram na mesma categoria conceitual. Ou seja, para o usuário final, funcionam de maneira similar, mesmo sendo tecnicamente diferentes. Em outras palavras, Thin e Ebb parecem ser como _"Mongrel, mas mais rápido/menor"_.

No entanto, o Passenger adotou uma abordagem de deploy diferente do Mongrel e afins: pretende tornar o deploy o mais simples possível e reduzir ao máximo o overhead de manutenção do sistema. Por exemplo, enquanto o Passenger lida com isso automaticamente, Mongrel, Thin e Ebb exigem que o administrador gerencie clusters. Como você disse, os mais técnicos já se familiarizaram bastante com a última abordagem, mas também é preciso levar em conta os iniciantes. Para eles, é um obstáculo considerável simplesmente fazer o deploy de uma aplicação. Se considerarmos os históricos desses iniciantes, muitos deles provavelmente já estão familiarizados com a forma de deploy do PHP, ou seja, de upload-and-go. Com o Passenger tentamos acomodar essas pessoas, pois achamos que isso é importante para o crescimento do mercado Ruby on Rails. Isso não quer dizer, no entanto, que não levamos em conta questões como robustez, performance e estabilidade.

De fato, testes independentes já mostraram que o Passenger está em paridade ou é mais rápido do que as soluções mencionadas. Outro problema é que os hosts compartilhados já estão rodando Apache como seu principal servidor web, e já vimos que configuração é necessária para colocar um cluster Mongrel funcionando com Apache... Desnecessário dizer que isso é bastante tedioso e propenso a erros, mesmo para muitos técnicos. O Passenger literalmente reduz esse processo para questão de segundos em vez de minutos. Isso não só economizaria muito tempo de uma empresa de hospedagem, mas também manteria seus administradores de servidor sãos (e pela nossa [experiência](http://blog.dreamhost.com/2008/01/07/how-ruby-on-rails-could-be-much-better/), eles são as últimas pessoas que você quer ofender ;-)).

Além disso, configurar um cluster tipo Mongrel requer bastante recursos em um host compartilhado, e é por razões como essas que os custos dos planos de hospedagem compartilhada de Ruby on Rails são geralmente mais altos do que os de hosts PHP. O Passenger, no entanto, aborda esse problema também ao fornecer eficiência melhorada em relação às soluções mencionadas, especialmente em conjunto com o Ruby Enterprise Edition. Testes iniciais já mostraram que isso resultou em uma redução dramática no uso de memória e elaboraremos sobre isso em breve.

Se considerarmos esses fatores, fica evidente que o Passenger (em conjunto com o Ruby Enterprise Edition) tem o potencial de desencadear uma revolução na hospedagem compartilhada. Não só na redução de custos para empresas de hospedagem (e esperançosamente para os consumidores), mas também no aumento da popularidade do Ruby on Rails.

**AkitaOnRails:** mod_ruby parece estar estagnado há muito tempo e precisa de carinho. Dizem que funciona razoavelmente bem para sites pequenos, mas a muita "magia negra" do Rails o torna inadequado para mod_ruby. O que torna mod_rails diferente de mod_ruby, na forma fundamental como operam com frameworks complexos como Rails?

**Phusion:** Na verdade não conseguimos comentar sobre isso, porque não somos intimamente familiarizados com mod_ruby. No entanto, o mod_ruby não é mantido ativamente e há muitos comentários negativos sobre ele em geral (como na wiki do Ruby on Rails). Também parece que ninguém realmente o usa. É por essas razões que nunca realmente experimentamos o mod_ruby.

Do mencionado acima e do que as pessoas costumam esquecer é que entregar apenas um produto (excelente) não é suficiente. Marketing e promoção são realmente importantes para a aceitação de um produto. Não só fizemos muito desenvolvimento, mas também passamos muito tempo promovendo o Passenger. O fato de estarmos tendo esta entrevista agora é provavelmente o resultado de nossa campanha de promoção, então estamos bastante satisfeitos com isso. Nesse sentido, o mod_ruby não parece ser ativamente promovido, e talvez seja uma das razões pelas quais é relativamente desconhecido.

**AkitaOnRails:** Por que vocês acham que demorou tanto para alguém criar uma solução para um módulo Apache que pudesse operar de forma similar ao habitual mod_php ou mod_python? O que vocês acharam que foi o aspecto mais desafiador no desenvolvimento do mod_rails?

**Phusion:** Bem, como você disse, acreditamos que desenvolvedores experientes de Ruby on Rails não consideram o deploy um problema — no máximo chato. Eles automatizaram/padronizaram bastante o processo de deploy com scripts Capistrano. Os iniciantes, no entanto, veem o deploy como um problema intransponível. Consequentemente, acabamos numa situação em que as pessoas que podem resolver o problema ou não o veem como problema ou não estão motivadas o suficiente para corrigi-lo, enquanto as pessoas que veem o problema não conseguem resolvê-lo.

Além disso, por nossas experiências pessoais, os iniciantes geralmente querem ver resultados imediatos. É muito desmotivador para essas pessoas continuar usando Ruby on Rails se tiverem que gerenciar toneladas de configurações e clusters obscuros para _"simplesmente fazer o deploy de uma aplicação com sucesso"_. Isso leva a conclusões muito inteligentes, como "Ruby on Rails é uma porcaria". ;-)

O aspecto mais desafiador é provavelmente o suporte multiplataforma e para elaborar isso em poucas palavras:

- Precisamos suportar uma grande variedade de sistemas baseados em Unix, como Linux, BSD e OS X. O Passenger trabalha em um nível bastante baixo (ou seja, usa recursos avançados do sistema Unix), e diferentes sistemas tendem a se comportar de formas sutilmente diferentes de tal forma que podem quebrar o Passenger se não formos cuidadosos.
- Muitos desafios são criados pelo MacOS X e pelo Apache. Há literalmente toneladas de maneiras diferentes pelas quais o Apache pode ser compilado e instalado, e isso é especialmente verdade no MacOS X. Cada instalação do Apache pode ser ligeiramente diferente, e precisamos suportar todas elas. Tivemos que escrever centenas de linhas de código de auto-detecção do Apache para tornar a instalação o mais tranquila possível. E o suporte para coisas específicas do OS X como binários universais não tornou o desafio mais fácil.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/5/7/134717629_6_Q1hc.jpeg)  
Ninh Bui

**AkitaOnRails:** A abordagem habitual de Shared Hosting com Rails envolve FastCGI; acho que é aí que mod_rails vai causar o maior impacto primeiro. Na arena de VPS, as pessoas geralmente estão mais confortáveis apenas subindo um cluster mongrel, talvez um monit ou god para monitorá-los ou até mesmo usar Swiftply para melhor controlar as instâncias mongrel. Há algum ajuste envolvido em ter interpretadores Ruby permanentes rodando, isso se deve principalmente ao fato de que se em algum momento a VM precisar de mais memória, ela vai alocar o quanto precisar, mas não devolver de volta ao SO. O mod_rails tem algum mecanismo para evitar um sistema de monitoramento como Monit, ou ele ainda é necessário?

**Phusion:** Levamos esse desafio em conta também. Aplicações Rails que ficaram ociosas por um tempo são desligadas, liberando todos os seus recursos para o sistema operacional. Além disso, é possível usar o Passenger em conjunto com ferramentas de monitoramento como Monit. Se o Monit matar um processo Rails, o Passenger automaticamente o (re)iniciará quando necessário, como se nada de ruim tivesse acontecido.

**AkitaOnRails:** Entendo que mod_rails opera mais ou menos como um gerenciador para um pool de VMs Ruby. Você tem um número mínimo e máximo de processos permitidos, mod_rails inicia tantos quanto necessário dependendo da carga e se um processo estiver ocioso, ele o matará após um período de timeout. Na maior parte do tempo, uma quantidade mínima de processos ficará rodando. É assim que funciona?

**Phusion:** É como você descreve, com a exceção de que não existe tal coisa como uma quantidade mínima de processos. O motivo para isso é que, uma vez que uma aplicação para um certo diretório Rails é iniciada, esse processo de aplicação não pode ser reutilizado para um diretório Rails diferente. Isso torna o conceito de uma quantidade mínima bastante inútil, exceto em servidores que hospedam apenas uma única aplicação Rails.

Claro, não ter uma quantidade mínima de processos significa que a primeira requisição após o timeout de ociosidade sofrerá uma penalidade de performance e será lenta. Resolvemos esse problema usando servidores spawner. Os servidores spawner fazem cache do código do framework Ruby on Rails e do código da aplicação, e podem reduzir o tempo de spawn em aproximadamente 50% e 90%, respectivamente. Você pode ter notado esses processos de servidor spawner na saída do 'ps'. O segredo para reduzir o tempo de spawn estaria em alterar os timeouts de ociosidade desses servidores spawner. Atualmente estamos trabalhando em uma série de artigos em que elaboramos sobre os tempos de spawn das aplicações Rails, quais são os papéis exatos dos servidores spawner e como os administradores de sistema podem otimizar as configurações do servidor para reduzir o tempo de spawn.

Boa parte da mágica que reside no Passenger ainda precisa ser revelada e mal começamos, mas isso é principalmente para as pessoas interessadas, ou seja, os mais técnicos. Há um ditado em holandês que resume o pensamento por trás de por que não fizemos isso até agora: _"Goede wijn behoeft geen krans"_, que se traduz aproximadamente como "um bom produto não precisa de elaboração de apoio". Uma publicação científica, por outro lado, precisa desse tipo de elaboração e é também por essa razão que estamos escrevendo esses artigos.

**AkitaOnRails:** Ficando no mesmo espaço de memória que o próprio Apache, você não tem o overhead de uma chamada FastCGI ou HTTP para uma instância mongrel. Essa diferença pesa muito nos seus benchmarks? Geralmente, pela sua experiência, quanto mais rápido é mod_rails agora comparado a um cluster mongrel básico rodando as mesmas aplicações? Os ganhos de velocidade são constantes ou variam o suficiente para não serem realmente mensuráveis?

**Phusion:** Na verdade isso não é verdade: os processos Rails não residem no mesmo espaço de memória do Apache. Em vez disso, são realmente processos separados, cada um podendo ser individualmente desligado sem afetar todos os outros. Não é uma boa ideia embutir um interpretador Ruby no Apache por causa de vários problemas, como estabilidade, fragmentação de heap e inchaço desnecessário do tamanho de VM de um processo. Pelo que entendemos, o mod_ruby adota a abordagem de embutir Ruby dentro do Apache, e suspeitamos que esse seja um dos motivos pelos quais as pessoas relatam tantos problemas com ele.

Nossos próprios testes mostraram que a performance do Passenger é mais rápida do que um cluster Mongrel atrás de Apache+mod_proxy_balancer. Testes independentes mostraram que a performance do Passenger está em paridade ou é ligeiramente mais rápida do que o cluster Mongrel, e isso parece estar perfeitamente alinhado com o que fomos capazes de inferir. Até agora não vimos nenhum teste em que o Passenger seja mais lento que um cluster Mongrel. Os ganhos de velocidade não são constantes: dependem da aplicação específica.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/5/7/2400947461_dfa24d2212.jpg)  
Galera da Phusion no [Fingertips](http://www.fngtps.com)

**AkitaOnRails:** Ruby Enterprise Edition, pelo que entendo, é o resultado daquela série sobre "copy-on-write" da qual falamos. Essencialmente uma forma de patchear a VM Ruby para habilitar um GC modificado que não vai marcar cada objeto, permitindo assim que COW faça seu trabalho e economize uma quantidade considerável de memória. Você citou 33%. Assumiria que é "até 33%", certo? Qual é o intervalo usual de memória economizada que vocês experimentam nos seus testes? O que mais afeta isso em apps Rails típicos, algum gotcha que vale mencionar para desenvolvedores Rails?

**Phusion:** Os 33% mencionados não são um máximo, mas uma média. Testamos com aplicações reais como Typo, e até agora inferimos uma economia média de memória de 33%. A economia real de memória depende da aplicação específica, então os resultados podem variar.

Não há gotchas para desenvolvedores de aplicações. Se sua aplicação funciona com Passenger, então Ruby Enterprise Edition também vai funcionar, sem necessidade de opções complicadas de configuração. Em outras palavras, é um aumento transparente. Em qualquer caso, podemos garantir que o uso de memória não será maior do que quando você usa o Ruby padrão.

**AkitaOnRails:** Entendo que vocês vão falar mais sobre a Enterprise Edition na RailsConf, mas esperava que pudessem revelar um pouco mais sobre ela. Vocês estão terminando a segunda rodada de doações para licenças Enterprise (eu doei! :-). Em primeiro lugar: quando vão lançá-la? Esse produto vai ficar comercial apenas ou vocês pretendem contribuir o patch do GC de volta ao trunk do Ruby algum dia?

**Phusion:** Obrigado por doar, e quanto ao último ponto: sim, é nossa intenção que um dia seja incorporado upstream. O leitor atento provavelmente vai notar que desviamos de uma pergunta como Neo desviou das balas do Agente Smith na Matrix: habilidosamente, exceto pela última bala, que na verdade acertou — mas chega disso por ora ;-).

**AkitaOnRails:** "mod_rails" é na verdade o alias para "Passenger". Algumas pessoas estão perguntando se isso vai continuar sendo apenas para Rails ou se vocês pretendem torná-lo compatível com Rack para que outros frameworks como Merb e Ramaze possam rodar sob seu controle. É possível? Vocês estão considerando?

**Phusion:** Digamos apenas que preferiríamos que você o chamasse de Passenger em vez de apenas mod_rails eventualmente. ;-)

**AkitaOnRails:** Apache é a potência dos servidores web e faz muito sentido para um módulo Apache. Talvez esteja especulando demais, mas vocês acham que é possível refatorá-lo para módulos de outros servidores web como nGinx ou Litespeed? Por causa da falta de um bom mod_rails no passado, a comunidade Rails se afastou para outras alternativas. É razoável esperar módulos não-Apache?

**Phusion:** É tecnicamente possível. Para manter vocês em suspense e continuar especulando sobre essas questões, não vamos nos aprofundar nisso por enquanto. ;-)

![](http://s3.amazonaws.com/akitaonrails/assets/2008/5/7/2401777262_a7fa751c79.jpg)  
Passenger sendo instalado!

**AkitaOnRails:** Do jeito que está agora, parece que mod_rails é um substituto plug-and-play para qualquer estratégia que tínhamos antes usando Apache. Há algum gotcha que vale mencionar para quem planeja migrar? Acho que regras mod_rewrite complicadas seriam a primeira coisa?

**Phusion:** Há um gotcha menor. Por padrão, sobrescrevemos o mod_rewrite da melhor forma possível. Isso ocorre porque projetos Rails vêm com um arquivo .htaccess por padrão, e esse .htaccess contém regras mod_rewrite que resultam em todas as requisições sendo encaminhadas para CGI ou FastCGI.

Isso é trivialmente resolvido deletando o .htaccess padrão e habilitando uma opção de configuração que diz ao Passenger para não sobrescrever o mod_rewrite. Isso permite que o desenvolvedor use regras mod_rewrite arbitrárias a seu gosto.

Além disso, o gotcha restante seria que o deploy de Rails se tornou bem entediante graças ao Passenger, pelo menos é o que as pessoas dizem. ;-)

Por fim, gostaríamos de agradecer a todos vocês pelo amor e suporte (financeiro) ao Passenger. Realmente apreciamos!

Com os melhores cumprimentos, seus amigos da Phusion,

Hongli Lai

Ninh Bui
