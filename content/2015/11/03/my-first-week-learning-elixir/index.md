---
title: "Minha primeira semana aprendendo Elixir"
date: '2015-11-03T11:07:00-02:00'
slug: minha-primeira-semana-aprendendo-elixir
translationKey: my-first-week-elixir
aliases:
- /2015/11/03/my-first-week-learning-elixir/
tags:
- beginner
- learning
- elixir
- traduzido
draft: false
---

Resolvi me dedicar a aprender Elixir o suficiente para me sentir confortável em encarar alguns projetos pequenos. Depois de uma semana inteira estudando perto de 6 horas por dia (umas 42 horas no total), ainda não estou totalmente confortável, mas acho que os conceitos principais já assentaram e consigo apreciar plenamente o que Elixir tem a oferecer.

Não é a primeira vez que mexo com Erlang, na verdade. Tive a sorte de participar de um pequeno workshop no QCon San Francisco 2009 com ninguém menos que [Francesco Cesarini](http://www.oreilly.com/pub/au/3373). Graças a ele, consegui entender um pouco da sintaxe peculiar de Erlang, o conceito correto de processos Erlang, como imutabilidade e pattern matching governam o fluxo de programação. Foi muito esclarecedor. Infelizmente, eu não me via fazendo Erlang em tempo integral. Eu só torcia para que aqueles mecanismos estivessem disponíveis em uma linguagem como Ruby...

Entre 2007 e 2009, Erlang teve uma nova renascença entre os aficionados por linguagens por causa do livro ["Programming Erlang"](https://pragprog.com/book/jaerlang/programming-erlang) lançado pela The Pragmatic Programmers, escrito por ninguém menos que o próprio Joe Armstrong, criador do Erlang. Dave Thomas [tentou empurrar Erlang](http://pragdave.me/blog/2007/04/15/a-first-erlang-program/) com força em 2007, mas nem ele conseguiu vender o motor poderoso de Erlang por causa da apresentação estranha da sintaxe.

Depois de 2009, José Valim teve uma longa jornada para liberar o controverso big rewrite do Rails 3.0 (que felizmente foi um sucesso) e decidiu dar um tempo e tentar algo diferente. A pesquisa dele acabou levando até Erlang pelos motivos que mencionei acima, mas ele decidiu que poderia resolver o problema da "sintaxe esquisita". Você pode ver algumas das primeiras palestras dele sobre Elixir nas gravações do Rubyconf Brasil [2012](https://www.eventials.com/locaweb/jose-valim-vamos-falar-sobre-concorrencia/) e [2013](https://www.eventials.com/locaweb/elixir-uma-aproximacao-pragmatica-e-concorrente-a-programacao/). O beta inicial saiu em 2012 e ele finalmente lançou a 1.0 estável em 2015. Chris McCord conseguiu lançar o Phoenix estável logo em seguida.

Quando ouvi falar disso pela primeira vez, Elixir entrou no meu radar. Mas eu não pulei de cabeça, entre 2009 e 2015 tivemos uma onda de interesse em "programação funcional" por causa da renascença do Javascript, do lançamento de Scala, Go Lang, Clojure, da promessa de Rust e por aí vai. Então esperei, acompanhando cada um deles com cuidado.

Aí veio 2014 e de repente todo mundo descobriu Erlang, com sua infraestrutura espartana que permitiu que o Whatsapp servisse meio bilhão de usuários com custos absurdamente baixos e fez o Facebook comprá-los por uns gordos USD 19 bilhões! Todo mundo já sabia do caso Whatsapp pelo menos desde 2011, mas só em 2014 que todo mundo se ligou. Mesmo assim, isso ainda não foi suficiente para colocar Erlang nos holofotes.

Quando o Elixir estável foi lançado neste ano, seguido do Phoenix estável, eu sabia que estava na hora de investir um tempo de qualidade nele. O núcleo de Erlang se vende sozinho: todo mundo está fazendo concorrência por meio de imutabilidade e threads leves (ou green threads, estratégia NxM entre green threads e threads reais). Hoje em dia é trivial estourar uma máquina só disparando milhões de processos leves. O difícil mesmo é criar um sistema com potencial de chegar a [99,9999999% de confiabilidade](http://stackoverflow.com/questions/8426897/erlangs-99-9999999-nine-nines-reliability). Disparar processos é fácil, como você coordena eles na mesma máquina? Como você coordena eles entre máquinas diferentes? Como você atualiza um sistema rodando sem derrubar ele? Como você lida com falhas? Como você supervisiona tudo?

Essas são as perguntas que Erlang resolveu décadas atrás ([20 anos atrás](http://www.erlang.org/download/armstrong_thesis_2003.pdf)) com a hoje famosa OTP, Open Telecom Platform da Ericsson. Algo criado para atender às necessidades de performance e confiabilidade das telecomunicações em larga escala. Quando a gente fala assim, parece que vai ser uma dor de cabeça monumental aprender, algo como o JEE (Java Enterprise Edition), só que pior.

E posso garantir que aprender OTP o suficiente para ser produtivo é, na verdade, **muito** fácil (você não vai conquistar a lendária confiabilidade de 99,9999999% do nada, mas vai conseguir construir algo confiável o bastante). Pense nisso como uma coleção de meia dúzia de módulos, com algumas interfaces de função para implementar, algumas linhas de configuração e basicamente acabou. É tão fácil e leve que muitas bibliotecas pequenas são escritas pensando em OTP e dá para fazer "plug and play" tranquilamente. Não é uma coisa pesada só de servidor.

Para domar esse poder você precisa aprender Elixir, extraoficialmente uma linguagem com uma semelhança incrível com Ruby, feita para cuspir bytecode Erlang para sua máquina virtual BEAM. Não tem combinação melhor.

### Uma Semana

Dito tudo isso, vamos ao que interessa. Você definitivamente quer se familiarizar com os conceitos de Programação Funcional como imutabilidade, higher order functions, pattern matching. Fiz uma lista de links para esses conceitos no [meu post anterior](http://www.akitaonrails.com/2015/10/28/personal-thoughts-on-the-current-functional-programming-bandwagon), recomendo a leitura.

Assumindo que você já é programador em uma linguagem dinâmica (Ruby, Python, Javascript, etc) e quer o crash course rápido. Comece comprando ["Programming Elixir"](https://pragprog.com/book/elixir/programming-elixir) do Dave Thomas e faça cada pedaço de código e cada exercício na ordem. É um livro tão fácil de ler que você consegue terminar em menos de uma semana. Eu fiz em 3 dias. O site oficial do Elixir-Lang tem uma [documentação muito boa](http://elixir-lang.org/getting-started/introduction.html) também e eles linkam vários [bons livros](http://elixir-lang.org/learning.html) que você vai querer ler depois.

Depois assine o [Elixir Sips](http://elixirsips.com) do Josh Adams. Se você é Rubyista, é como assistir aos Railscasts do Ryan Bates desde o começo de novo. Embora seja mais parecido com o show RubyTapas do Avdi Grimm, com episódios bem curtos só para você ter sua dose semanal de Elixir.

Você pode assistir alguns episódios de graça em baixa resolução, mas recomendo fortemente que você assine e assista as versões em HD. Vale muito a pena. Sobre os episódios, são mais de 200. Eu assisti mais de 130 em 12 horas :-) Então calculo mais 2 dias para assistir tudo.

Você definitivamente deve assistir tudo se conseguir, mas se não conseguir, deixa eu listar os que considero essenciais. Antes de mais nada, lembre-se que o Josh faz isso há um tempão, quando ele começou Elixir estava na versão 0.13 ou abaixo e Erlang na versão 17 ou abaixo.

Por exemplo, o episódio [171 - Erlang 18 and time](https://elixirsips.dpdcart.com/subscriber/post?id=815) destaca a nova API de Time. Você precisa saber disso. O episódio [056 - Migrating Records to Maps](https://elixirsips.dpdcart.com/subscriber/post?id=460) mostra um recurso novo do Erlang 17 e Elixir onde Maps passam a ser preferíveis aos antigos Records. Maps são explicados nos episódios [054](https://elixirsips.dpdcart.com/subscriber/post?id=453) e [055](https://elixirsips.dpdcart.com/subscriber/post?id=454). Se você for aprender o framework web Phoenix, ele usa o ORM Ecto por baixo e os models do Ecto são Maps, então você precisa saber disso.

Isso significa que os primeiros 180 episódios, no mínimo, estão usando versões anteriores de Erlang, Elixir, Phoenix, etc, e você precisa ter em mente que versões novas terão APIs diferentes. Esse foi um dos motivos pelos quais esperei pelos releases estáveis, porque era natural que os projetos evoluíssem e levassem tempo para ter APIs estáveis, e correr atrás de vários alvos móveis é realmente difícil para iniciantes.

Dito isso, assista a esta lista primeiro:

* 001 - Introduction and Installing Elixir.mp4
* 002 - Basic Elixir.mp4
* 003 - Pattern Matching.mp4
* 004 - Functions.mp4
* 005 - Mix and Modules.mp4
* 006 - Unit Testing.mp4
* 010 - List Comprehensions.mp4
* 011 - Records.mp4
* 012 - Processes.mp4
* 013 - Processes, Part 2.mp4
* 014 - OTP Part 1_ Servers.mp4
* 015 - OTP Part 2_ Finite State Machines.mp4
* 016 - Pipe Operator.mp4
* 017 - Enum, Part 1.mp4
* 018 - Enum, Part 2.mp4
* 019 - Enum, Part 3.mp4
* 020 - OTP, Part 3 - GenEvent.mp4
* 022 - OTP, Part 4_ Supervisors.mp4
* 023 - OTP, Part 5_ Supervisors and Persistent State.mp4
* 024 - Ecto, Part 1.mp4
* 025 - Ecto, Part 2_ Dwitter.mp4
* 026 - Dict, Part 1.mp4
* 027 - Dict, Part 2.mp4
* 028 - Parsing XML.mp4
* 031 - TCP Servers.mp4
* 032 - Command Line Scripts.mp4
* 033 - Pry.mp4
* 041 - File, Part 1.mp4
* 042 - File, Part 2.mp4
* 044 - Distribution
* 045 - Distribution, Part 2
* 054 - Maps, Part 1.mp4
* 055 - Maps, Part 2_ Structs.mp4
* 056 - Migrating Records To Maps.mp4
* 059 - Custom Mix Tasks.mp4
* 060 - New Style Comprehensions.mp4
* 061 - Plug.mp4
* 063 - Tracing.mp4
* 065 - SSH.mp4
* 066 - Plug.Static.mp4
* 067 - Deploying to Heroku.mp4
* 068 - Port.mp4
* 069 - Observer.mp4
* 070 - Hex.mp4
* 073 - Process Dictionaries.mp4
* 074 - ETS.mp4
* 075 - DETS.mp4
* 076 - Streams.mp4
* 077 - Exceptions and Errors.mp4
* 078 - Agents.mp4
* 079 - Tasks.mp4
* 081 - EEx.mp4
* 082 - Protocols.mp4
* 083 - pg2.mp4
* 086 - put_in and get_in.mp4
* 090 - Websockets Terminal.mp4
* 091 - Test Coverage.mp4
* 106 - Text Parsing.mp4
* 109 - Socket.mp4
* 112 - Benchfella.mp4
* 113 - Monitoring Network Traffic.mp4
* 124 - Typespecs.mp4
* 125 - Dialyzer.mp4
* 126 - Piping Into Elixir.mp4
* 127 - SSH Client Commands.mp4
* 131 - ExProf.mp4
* 132 - Randomness in the Erlang VM.mp4
* 135 - Benchwarmer.mp4
* 138 - Monitors and Links.mp4
* 139 - hexdocs.mp4
* 141 - Set.mp4
* 142 - escript.mp4
* 144 - Erlang's `calendar` module.mp4
* 145 - good_times.mp4
* 153 - Phoenix APIs and CORS.mp4
* 155 - OAuth2_ Code Spelunking.mp4
* 156 - Interacting with Amazon's APIs with erlcloud.mp4
* 157 - Playing with the Code Module Part 1 - eval_string.mp4
* 159 - Simple One for One Supervisors.mp4
* 160 - MultiDef.mp4
* 171 - Erlang 18 and Time.mp4
* 172 - Arc File Uploads.mp4
* 174 - ElixirFriends_ Saving Tweets with Streams and Filters.mp4
* 175 - Pagination with Ecto and Phoenix using Scrivener.mp4
* 176 - Prettying Up ElixirFriends.mp4
* 178 - Memory Leaks.mp4
* 179 - Rules Engine.mp4
* 180 - Collectable.mp4
* 182 - Phoenix API.mp4
* 183 - React with Phoenix.mp4
* 184 - React with Phoenix Channels.mp4
* 185 - Mix Archives.mp4
* 186 - Automatically Connecting Nodes.mp4
* 187 - Compiling a Custom AST Into Elixir Functions.mp4
* 190 - Testing Phoenix Channels.mp4
* 193 - Linting with Dogma.mp4
* 194 - Interoperability_ Ports.mp4
* 196 - Crashing the BEAM.mp4
* 200 - Custom Types in Ecto.mp4
* 201 - Tracing and Debugging with erlyberly.mp4
* 202 - Exception Monitoring with Honeybadger.io.mp4
* 203 - plug_auth.mp4
* 204 - Behaviours.mp4

Isso é mais ou menos metade do que tem disponível no Elixir Sips. Todos os outros episódios também são interessantes, mas se você está só começando, essa lista deve ser suficiente para molhar os pés na linguagem.

Quem vem do Rails vai curtir Phoenix e o ecossistema que está crescendo em volta dele. Você já consegue autenticar via [OAuth2](https://github.com/scrogson/oauth2), fazer paginação no estilo will_paginate com [Scrivener](https://github.com/drewolson/scrivener), upload de arquivos no estilo carrierwave com [Arc](https://github.com/stavro/arc), deploy no [Heroku](http://wsmoak.net/2015/07/05/phoenix-on-heroku.html).

Para mais exercícios, você pode conectar facilmente em endpoints HTTP usando [HTTPoison](https://github.com/edgurgel/httpoison), parsear HTML com [Floki](https://github.com/philss/floki), parsear JSON com [Poison](https://github.com/devinus/poison). Para mais bibliotecas, você pode acompanhar a página no Github chamada [Awesome Elixir](https://github.com/h4cc/awesome-elixir) que lista vários pacotes Elixir novos que você pode usar. Mas garanta que você vai passar pelos conceitos básicos primeiro. Elixir tem um sistema de gerenciamento de tarefas estilo Rake embutido com o Mix, você pode adicionar dependências em um arquivo estilo Gemfile chamado Mix.exs, que todo projeto tem. Você pode adicionar dependências por URLs do Github ou via [Hex.pm](https://hex.pm), que é como o Rubygems.org.

Nesse processo de aprendizado, os conceitos que considero mais importantes para aprender primeiro são:

* Sintaxe e conceitos básicos de Elixir (pattern matching, loops via recursão, estado imutável, tipos primitivos incluindo Maps, o pipe operator)
* O conceito de processos, nós e a intercomunicação entre processos e nós, incluindo Monitors e Links.
* Básico de OTP, aprenda o que são GenServer, GenEvent, GenFSM.

Depois de aprender isso, você consegue descobrir como construir aplicações OTP e fazer algo prático para a Web usando Phoenix, em particular você vai querer aprender tudo sobre os Channels do Phoenix, a infraestrutura para WebSockets robustos, rápidos e [altamente concorrentes](http://www.akitaonrails.com/2015/10/29/phoenix-experiment-holding-2-million-websocket-clients).

É isso. Essa foi a minha primeira semana aprendendo Elixir, e meu próximo passo é me treinar fazendo mais exercícios e também aprendendo mais sobre Phoenix. Mesmo Phoenix sendo inspirado em Rails, ele não é um clone, tem seu próprio conjunto único de conceitos para aprender e isso definitivamente vai ser uma viagem muito interessante.

Se você tiver mais dicas e truques para iniciantes, fique à vontade para comentar abaixo.
