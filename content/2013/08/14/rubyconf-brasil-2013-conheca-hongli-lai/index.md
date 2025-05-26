---
title: 'Rubyconf Brasil 2013: Conheça Hongli Lai'
date: '2013-08-14T17:39:00-03:00'
slug: rubyconf-brasil-2013-conheca-hongli-lai
tags:
- rubyconfbr2013
draft: false
---

![Hongli Lai](http://www.rubyconf.com.br/assets/speakers/hongli_lai-2cfc23d129a2a1f001d84df45863071a.jpg)

Se você ainda não se inscreveu, não perca a oportunidade. Vá ao [site oficial](http://www.rubyconf.com.br) para se cadastrar agora mesmo! A conferência inicia no dia 29 de Agosto.

Este é o 6o ano consecutivo onde a Locaweb e eu organizamos mais uma grande Rubyconf no Brasil. Muitas empresas estabelecidas e startups de tecnologia estão apoiando a conferência enviando grandes desenvolvedores.

Conheça a [Phusion](http://www.phusion.nl/) o grupo de cientistas da computação da Holanda que primeiro tornaram fazer deployments de aplicações Ruby on Rails realmente simples. Muitos provavelmente não vão se lembrar mas antes de 2007 era bem doloroso instalar uma aplicação Rails em produção. Zed Shaw nos trouxe o Mongrel. Mas não foi até Phusion lançar o Passenger que nós começamos a acelerar até o ponto onde instalar Ruby em produção se tornou o padrão de ouro.

Hongli Lai está vindo pela segunda vez, ele já esteve na primeira Rails Summit Latin America 2008 junto com seu sócio Nihn Bui. Desde então ele tem evoluído a tecnologia Passenger, fazendo funcionar no Apache, NGINX e em diversas customizações e cenários.

Não perca sua palestra de fechamento precisamente às 16:45 do primeiro dia do evento. Vamos conhecer um pouco mais sobre ele:

"Sua palestra será o Phusion Passenger 4 que está chegando. Se alguém está apenas começando com Ruby, poderia explicar quais são os requerimentos que ele deve entender o que você vai apresentar?"

**Hongli:** Para entender esta palestra, você deve ter entendimento básico de como fazer deployment de uma aplicação Rails. Por exemplo, experiência anterior usando Phusion Passenger, Unicorn, Puma ou Thin será muito útil. Você não precisa entender tudo em detalhes, porque a palestra será fácil de seguir mesmo para iniciantes. Uma parte da palestra, especilamente a parte de otimização e customização, será mais avançada, mas vou estruturar de maneira que iniciantes também possam seguir.

"Muitos desenvolvedores adorariam se tornar tão experientes e fluentes rm Ruby como você. Quais foram as dificuldades que teve que ultrapassar para se tornar um grande desenvolvedor? Algumas dicas para iniciantes em Ruby?"

**Hongli:** Eu acredito que a melhor maneira de se tornar bom é com muita prática. Eu não acredito em talento, mas acredito em trabalho duro. Eu acho que cheguei onde estou porque venho desenvolvendo software por mais de uma década. Nos primeiros anos meu código era uma droga e eu não entendia bem o que estava acontecendo. Foi somente depois de anos de experiência que comecei a produzir código bom.

No começo, eu era autodidata. Aprender sozinho só te leva até certo ponto, mas existe uma certa fundação matemática e formal que é melhor ensinada numa universidade. Nesse sentido, minha educação em ciência da computação me ajudou muito, embora eu nunca teria chegado no meu nível atual sem muita experiência prática também.

Finalmente, é uma boa idéia ser curioso sobre o trabalho de outras pessoas. Você vai aprender muito estudando o design e código dos outros, tanto sobre o que fazer e o que não fazer. Também é uma boa idéia permanecer de mente aberta, e não pular em conclusões muito rapidamente. O que a princípio parece um código mal escrito por outra pessoa pode ter razões legítimas para ser daquele jeito. É importante entender as razões.

"Existem tantas tecnologias, boas práticas e tudo mais que são lançados o tempo todo. Na sua opinião pessoal, e talvez relacionado ao seu trabalho atual, quais são as tendências em tecnologia que acha que devemos prestar atenção no futuro próximo?"

**Hongli:** Eu não acredito em prestar muita atenção em tendências. Tendências vem e vão, e muitas das atuais tendências são apenas modificações de tendências passadas. Mais do que isso, nem todas as tendência são úteis em sua forma crua. Em vez de seguir tendências, você deve entender as razões principais por trás das tendências, e adotá-las em vez disso.

Isso dito, existem diversas tendências que eu acredito serem boas tendências para seguir e que acredito não terem data de expiração:

* Testes automatizados. Você deve definitivamente ter testes automatizados, o que me salvou muitas e muitas vezes no passado. Ter uma boa suíte de testes lhe dá a confiança e reduz ansiedade de desenvolvedor (medo de quebrar alguma coisa), o que permite um velocidade maior. Existem diversos estilos nessa área, por exemplo TDD e BDD. Não pertenço a nenhuma, mas eu pego idéias de todas e aplico onde faz sentido.

* Integração contínua. Em vez de ter longos ciclos de desenvolvimento, e integrar branches de desenvolvimento depois de um longo tempo, ou lançar software para staging depois de um longo tempo, você deve fazer isso em intervalos curtos. Isso lhe dará mais confiança, reduzirá ansiedade de desenvolvedor e permitirá lançar em produção com menos trabalho. Integração contínua implica testes automatizados. Uma ferramnta de CI como [Travis](https://travis-ci.org/) ou [Apachai Hopachai](https://github.com/phusion/apachai-hopachai) são indispensáveis.

* Automação operacional. Se uma tarefa tem muitos passos, ou se é muito mentalmente pesada (o que torna fácil introduzir erros humanos), considere automatizar essa tarefa o máximo possível para que seja necessário digitar apenas um comando e pronto. Existem duas tendências que são fortemente relacionadas a essa idéia principal:

* O movimento devops. Comparado a sysops tradicional, que performa muitas tarefas manualmente, o movimento devops procura automatizar o máximo possível. Você descreve seu cluster de configuração em código, e uma ferramentas como Chef, Puppet ou Ansible constrói esse cluster para você. O jogo muda muito quando você pode digitar um único comando e reconstruir seu cluster de servidores inteiro, em vez de manualmente instalar e configurar o software toda vez.

* Virtualização do ambiente de desenvolvimento. Isso é como devops para ambiente de desenvolvimento. Em vez de deixar seu desenvolvedor construir seus ambientes manualmente (instalando compilador, instalando git, instalando mysql, editando suas configuraçõas, etc) você descreve esse ambiente em código e deixa uma ferramenta como Vagrant (em combinação com Chef, Puppet ou Ansible) construir para você. Todos os desenvolvedores terão um ambiente consistente e eles podem configurar uma nova rapidamente toda vez que mudarem de máquina. Quando feito da forma correta, nenhum erro humano é possível.
