---
title: "[Akitando] #145 - 16 Linguagens em 16 Dias: Minha Saga da Rinha de Backend"
date: '2023-09-20T15:35:00-03:00'
slug: akitando-145-16-linguagens-em-16-dias-minha-saga-da-rinha-de-backend
tags:
- rinha
- docker
- gatling
- csharp
- rust
- go lang
- nim lang
- v lang
- bun
- javascript
- php
- swoole
- python
- sanic
- hyperf
- ruby on rails
- ruby
- node.js
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/EifK2a_5K_U?si=bTUpIcss3ZlESl2B" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

A Rinha de Backend que aconteceu em Agosto de 2023 foi muito divertida. Eu só fiquei sabendo quando acabou, mas não quer dizer que não pude me divertir. Hoje quero resumir tudo que eu fiz nos 16 dias seguintes do evento, detalhes sobre os projetos dos participantes, a controvérsia do Ranking de Linguagens, quais os truques por trás dos vencedores, e como você também poderia ser um vencedor!

Finalmente vou demonstrar o que significa "ser promíscuo" com linguagens de programação. Vamos entender porque como de fato ler um ranking. E como podemos fazer TODO MUNDO alcançar o primeiro lugar do Rust!

## Conteúdo

* 00:00:00 - Intro
* 00:01:41 - CAP 01 - As Regras - Requerimentos da Rinha
* 00:09:46 - CAP 02 - Os Participantes - Vencedores da Rinha
* 00:15:25 - CAP 03 - Dia 1: Entrando na Rinha - Minha versão em Ruby on Rails
* 00:21:08 - CAP 04 - MrPowerGamerBR entra em cena - A chegada dos Piratas!
* 00:27:55 - CAP 05 - Tentando com Crystal - Aprendendo Lucky Framework
* 00:34:01 - CAP 06 - Dia 8: Gerenciando Baratie - Fluxo de Restaurante
* 00:38:37 - CAP 07 - Consertando Meu Rails - Aprendendo com Erros
* 00:42:54 - CAP 08 - Aprendendo com Node.js - Muita Refatoração
* 00:49:48 - CAP 09 - Apanhando de Erlang - Segredos de Elixir
* 00:55:51 - CAP 10 - Explorando Go Lang - Essa foi fácil
* 00:57:31 - CAP 11 - Dando Moral pra NATS - C# Vencedor
* 00:58:15 - CAP 12 - Dia 12: Explorando PHP Moderno - De Node a Swoole
* 01:00:12 - CAP 13 - Elevando Python - Pequeno Erro
* 01:02:21 - CAP 14 - "foi lá, E FEZ" - A Saga de Lean4
* 01:06:28 - CAP 15 - Pré-Feriado: Tentando NIM - A decepção
* 01:08:47 - CAP 16 - Diário de Bordo: Resumo - Chegando na Grand Line
* 01:13:05 - CAP 17 - Feriadão! - Encontrando o One Piece??
* 01:19:16 - CAP 18 - Testando o One Piece! Todos ao Primeiro Lugar!
* 01:27:16 - CAP 19 - Conclusão: Por que todo mundo não usa Rust?? - Escala de Mercados
* 01:37:33 - Bloopers



## Links

- Repo Oficial da Rinha: https://github.com/zanfranceschi/rinha-de-backend-2023-q3/tree/main
- MrPowerGamerBR: # Os Resultados da RINHA DE BACKEND estão ERRADOS, e eu posso provar https://www.youtube.com/watch?v=XqYdhlkRlus
- Raciocínio Automatizado com Leonardo de Moura, Pesquisador na Microsoft Research https://dev.to/elixir_utfpr/raciocinio-automatizado-com-leonardo-de-moura-pesquisador-na-microsoft-research-4d1k
- Rinha versão Algebraic https://github.com/meoowers/rinha
  Repositórios da Sofia https://github.com/algebraic-sofia?tab=repositories

## Tweets

* Tweet: Início da minha versão de Rails https://x.com/AkitaOnRails/status/1695526606503022923?s=20
* Tweet: O ranking oficial não é importante, discutir as técnicas, sim https://twitter.com/AkitaOnRails/status/1695913459202838839
* Tweet: 1o resultado com Crystal/Lucky https://x.com/AkitaOnRails/status/1696207752043872433?s=20
* Tweet: Minhas impressões aprendendo framework Lucky, em Crystal https://twitter.com/AkitaOnRails/status/1696220345152176478
* Tweet Leandro: diminuir workers do nginx melhora uso no lado do postgres https://x.com/leandronsp/status/1696292520106299417?s=20
* Tweet: Mais discussão das técnicas de otimização como batch insert https://x.com/AkitaOnRails/status/1696255958328938745?s=20
* Tweet Leandro: experimentando a teoria de diminuir workers e pool na versão de Ruby, conseguindo quase 30k https://x.com/leandronsp/status/1696219396316836331?s=20
* Tweet: contribuindo com o projeto Kiwi e comentando sobre LevelDB https://x.com/AkitaOnRails/status/1697283886156226818?s=20
* Tweet: meu mantra da programação https://x.com/AkitaOnRails/status/1697317688006066432?s=20
* Tweet: 1o resultado positivo com Crystal https://x.com/AkitaOnRails/status/1697651647273427429?s=20
* Tweet: 1o resultado positivo com Rails https://x.com/AkitaOnRails/status/1698475713920119117?s=20
* Tweet: mexendo na versão Node do Lucas Weis https://x.com/AkitaOnRails/status/1698565631560282590?s=20
* Tweet: desafio: todas conseguem bater os 40k https://x.com/AkitaOnRails/status/1698491304366219744?s=20
* Tweet: apanhando da versão Elixir do Gabriel Oliveira https://x.com/AkitaOnRails/status/1698760144924905474?s=20
* Tweet: revisando a versão Elixir https://x.com/AkitaOnRails/status/1698809091055874491?s=20
* Tweet Gabriel: consertando o crash de Elixir no meu PC https://x.com/oliveigah/status/1698866344853151857?s=20
* Tweet: resolvido problema do Elixir https://twitter.com/AkitaOnRails/status/1698888695376437677
* Tweet: mexendo no Go do Luan, 29k https://x.com/AkitaOnRails/status/1698818634397647092?s=20
* Tweet: fuçando a versão finalista de Dotnet https://twitter.com/AkitaOnRails/status/1698851765658013900
* Tweet: 1o resultado da versão PHP do Lauro https://twitter.com/AkitaOnRails/status/1698923556631990453
* Tweet: 1o resultado da versão Python do Ian Cambrea: https://twitter.com/AkitaOnRails/status/1698966472083517931
* Tweet: Primeiro contato com Lean4 https://twitter.com/AkitaOnRails/status/1699064101111218212
* Tweet: Bibliotecas em Lean da Sofia https://twitter.com/AkitaOnRails/status/1699069812079767739
* Tweet: Resumo até agora https://twitter.com/AkitaOnRails/status/1698900197068153027
* Tweet: Resumo das técnicas até agora https://twitter.com/AkitaOnRails/status/1698903125338226739
* Tweet: Tentando versão em Nim (fracasso) https://twitter.com/AkitaOnRails/status/1699533869739856257
* Tweet: versão nova em Java do Junior Leão https://twitter.com/juniorleaoo/status/1699427149831114850
* Tweet: versão desclassificada em V Lang do Carlos Silva https://twitter.com/_insalubre/status/1699498542245544269
* Tweet: Leandro explica a lógica de diminuir vazão do nginx https://twitter.com/leandronsp/status/1699568664859603184
* Tweet: resumo das técnicas até agora: https://twitter.com/AkitaOnRails/status/1698903125338226739
* Tweet: Vinicius Ferraz descobre e publica network_mode: host https://twitter.com/AkitaOnRails/status/1700488994323128673
* Tweet: Reinaldo/Zsantana, atinge Zero knockouts: https://twitter.com/reijsantana/status/1701000310280573287
* Tweet: Chegando de viagem e ajustando todo mundo de novo: https://x.com/AkitaOnRails/status/1701230737922339143?s=20
* Tweet: Rails bate 45k https://x.com/AkitaOnRails/status/1701248237586219416?s=20
* Tweet: Ruby do Leandro bate 47k https://x.com/AkitaOnRails/status/1701423430870954312?s=20
* Tweet: Rails do Lazaro bate 46k https://x.com/AkitaOnRails/status/1701446727910199459?s=20
* Tweet: Node.js bate 46k https://x.com/AkitaOnRails/status/1701295880844775425?s=20
* Tweet: Go do Luan bate 46k https://x.com/AkitaOnRails/status/1701286259459523033?s=20
* Tweet: Bun bate 43k https://x.com/AkitaOnRails/status/1701630742642471420?s=20
* Tweet: Python bate 46k https://x.com/AkitaOnRails/status/1701267343521767606?s=20
* Tweet: V Lang bate 46k https://x.com/AkitaOnRails/status/1701256544904438210?s=20
* Tweet: Consertando Java do Reinaldo, bate 46k https://x.com/AkitaOnRails/status/1701402351913910693?s=20
* Tweet: C++ do Lucas William bate 46k https://x.com/AkitaOnRails/status/1702008261736534294?s=20
* Tweet: Refatorando o Rust do Vinicius https://twitter.com/AkitaOnRails/status/1701816747274260698

## Pull Requests

* PR versão Node.js https://github.com/lukas8219/rinha-be-2023-q3/pull/1
* PR versão Node.js, network mode https://github.com/lukas8219/rinha-be-2023-q3/pull/2
* PR versão Go Lang https://github.com/luanpontes100/rinha-de-backend-2023-q3-golang/pull/1
* PR versão Go Lang, network mode https://github.com/luanpontes100/rinha-de-backend-2023-q3-golang/pull/1
* PR versão PHP/Swoole https://github.com/lauroappelt/rinha-de-backend-2023/pull/1
* PR versão Python/Sanic https://github.com/iancambrea/rinha-python-sanic/pull/1
* PR versão de Lean4 fix de Location: https://github.com/meoowers/rinha/pull/1
* PR versão de Lean4 fix de data: https://github.com/meoowers/rinha/pull/2
* Versão em Nim/Jesper: https://github.com/akitaonrails/rinhabackend-nim-jester-api
* Versão em Java/Quarkus: https://github.com/zsantana/rinha-backend-by-bruno-borges/tree/main
* PR versão de C++: https://github.com/lucaswilliameufrasio/backend-cockfighting-q3-2023/pull/1
* PR versão de C# do Zan: https://github.com/zanfranceschi/rinha-de-backend-2023-q3-csharp/pull/3
* PR versão de Ruby do Leandro: https://github.com/leandronsp/rinha-backend-ruby/pull/4
* PR versão de Bun: https://github.com/Met4tron/rinha-bun/pull/1
* PR versão de Java do Reinaldo, fix de data: https://github.com/zsantana/rinha-backend-sem-cache/pull/1
* PR versão de V Lang, network mode https://github.com/carlosqsilva/rinha-2023-q3/pull/1
* PR versão de Rust do Vinicius, refactoring e fix: https://github.com/viniciusfonseca/rinha-backend-rust/pull/2

## SCRIPT

Olá pessoal, Fabio Akita



Se costuma acompanhar a comunidade de desenvolvimento no Twitter, talvez tenha ouvido falar que em agosto de 2023 aconteceu um mini evento online chamado de Rinha de Backend, organizado pelo Zanfranceschi, desenvolvedor experiente, atualmente trabalhando no Nubank.





Eu não conhecia ele e só fiquei sabendo que esse evento aconteceu quase uma semana depois que já tinha acabado. Mesmo se soubesse antes não teria participado porque nunca fui de competições, hackathons ou algo assim. Mas eu gostei muito do que os participantes fizeram e, sem querer, isso tomou boa parte do meu tempo, incluindo várias noites mau dormidas.






Sem sombra de dúvidas este vai ser o video mais trabalhoso que já fiz na história deste canal. Não só este como o próximo. Hoje vou resumir minha saga de 16 dias do pós-rinha avaliando diversos projetos dos participantes. Neste percurso, aprendi muita coisa nova que não sabia ou que achava que fosse ser diferente. Foi uma longa saga, muitas noites mau dormidas, frustração, ansiedade, crises existenciais, suor e lágrimas. É bastante coisa e só o resumo vai dar um video de mais de 1 hora.






Por isso vou pedir muita paciência de vocês. Vai ter várias técnicas importantes que vou mencionar o nome e os efeitos que causam, mas vai ser bem por cima. Se ficarem confusos com termos que parecem complicados, não se preocupem, vou explicar os detalhes no próximo. Também vai ser no próximo que vou falar detalhes das linguagens que vou mencionar. Então segurem as críticas. Hoje quero só compartilhar como foi minha experiência.







Primeiro vou resumir como foi o evento em si, um pouco sobre os projetos que ganharam e o ranking que gerou alguma controvérsia, pelo que ouvi falar. Daí vou contar o que pensei a respeito e como resolvi começar a abrir os projetos dos participantes com uma missão: fazer todo mundo chegar no primeiro lugar!


(...)





Como disse, eu não participei do evento, nem acompanhei o dia a dia. Acho que o desafio foi lançado primeiro mas ninguém sabia exatamente como seriam os critérios pra definir o vencedor até dias depois. E parte da graça de uma "rinha" como essa não é ser uma competição tecnicamente, perfeitamente justa, tem muito fator sorte e incerteza envolvido, como em qualquer esporte. 







Nem sempre é o melhor atleta técnico que ganha todos os jogos, mas quem aprendeu mais nos jogos anteriores, quem consegue se adaptar rápido e quem teve menos azar. Assim foi esta rinha também, por isso em nenhum momento encarem qualquer coisa que parece uma crítica como uma crítica ao evento e sim como dicas pros próximos. Minha discussão vai ser puramente técnica. A crítica real vai pra quem tentou levar isso a sério demais. Ser torcedor apaixonado de um time é normal, sair xingando e brigando na rua quando vê o cara do outro time é ser um animal irracional imbecil. Vou assumir que estou falando com homo sapiens e não neandertais.








O desafio foi divulgado num repositório de GitHub do Zan que vou deixar o link nas descrições abaixo. Aliás, sempre olhem a descrição de todo video. Eu coloco links pra várias coisas extras pra vocês. Além de ter a descrição de todos os capítulos pra ficar mais fácil achar seções de videos longos como este. Enfim, leiam as instruções do desafio mas em resumo, o objetivo era escolher qualquer linguagem de programação, com ou sem frameworks, implementar 4 endpoints de APIs e configurar pra rodar com Docker Compose numa configuração específica de infraestrutura.







Fazer a API em si, em qualquer linguagem, é super simples. É um endpoint POST "/pessoas" que recebe um JSON simples com dados como apelido, nome, data de nascimento e stack de programação, um array com elementos como "php" ou "java". É como se fosse o cadastro de um sisteminha de recrutamento ou algo assim. Tem que validar que apelido tem no máximo 32 letras, nome no máximo 100 letras, data de nascimento tem que ser minimamente válido. Inclusive ele não fala que 31 de fevereiro tem que ser inválido, só fala que o formato tem que ser ano, tracinho, me, tracinho, dia.







A lista de stack tem que ser um array sem elementos nulos e cada elemento não podia ter mais que 32 letras. E finalmente, o ID tinha que ser um UUID, que é um tipo de número aleatório. Isso foi um bom requerimento como vou mostrar mais pra frente. Mas em termos de validação era só isso. Se passar dados inválidos temos que devolver o cabeçalho HTTP 400 de bad request.






Ou se voltar erro no insert do SQL por causa de constraints inválidas como nome não poder ser nulo, apelido já existir ou algo assim, tem que devolver cabeçalho HTTP 422 de erro unprocessable entity. A resposta pra requisição de criação precisa ter o cabeçalho HTTP 201 created e um cabeçalho "Location" com o caminho pra essa pessoa recém criada no formato GET "/pessoa/uuid". Isso é comum numa API restful básica.







Esse endpoint devolvido no Location deve conseguir encontrar a pessoa recém criada e devolver o JSON com os dados. Se passar um UUID que não existe, tem que devolver o cabeçalho HTTP de 404 not found. Depois precisava ter outro endpoint GET "/pessoas" que receba um parâmetro chamado "t" pra ser um "termo de procura", pra pesquisarmos o termo no apelido ou nome ou na stack. Seria tipo fazer um SQL com apelido like "%termo%" OR nome like termo OR stack like termo. Já vou explicar porque esse seria o pior jeito. 







Devolvemos o resultado em JSON com código HTTP 200 ou devolve código 400 de erro se não passar termo nenhum. Não encontrando nada bastava devolver um JSON com array vazio em vez de 404 not found. E finalmente o 4o endpoint era um simples GET "contagem-erro" que deveria fazer um count na tabela e devolver quantas inserções de fato aconteceram. Esse é o único endpoint que não faz parte do stress test e isso pode se tornar um ponto importante pra alguns truques como vou explicar no próximo video.







Como podem ver, são endpoints super triviais. Se você é um programador experiente tenho certeza que já tem de cabeça como faria na sua linguagem mais fluente. Dá pra fazer rapidinho uma versão que funciona em 1 ou 2 horas se estiver um pouco enferrujado. Mesmo se for bem iniciante, seguindo qualquer tutorial de APIs restful no framework que estiver aprendendo, é pra conseguir fazer em 1 dia. Essa é a ordem de grandeza e talvez sirva pra vocês saberem em que pé estão. Vai demorar mais do que isso se quiser experimentar técnicas diferentes. Teve versão que eu levei uns dois dias pra terminar porque resolvei aprender um framework novo do zero, por exemplo.







No próximo video vou demonstrar como dá pra fazer uma versão simples em poucos minutos, por agora só acreditem que dá. Aliás, vamos começar a listar coisas pro próximo episódio. "Mostrar como fazer uma versão simples do zero". Mas agora vem a parte que separa os adultos das crianças: a infraestrutura. Não basta só fazer o código e dizer "roda na minha máquina". Tem que rodar dentro das restrições da rinha. Então não é só subir um banco de dados, subir sua aplicação sozinha e acabou.







Segundo as regras, tem que subir duas instâncias da sua aplicação, pra rodar em paralelo. E ambos precisam ficar embaixo de um balanceador de carga, no caso pediram o Nginx. No mundo real aplicações rodam com várias instâncias em paralelo embaixo de um balanceador de um Kubernetes, Seasaw, HAProxy ou várias outras alternativas. Azure tem o Application Gateway, AWS tem o ELB, o Elastic Load Balancing, tem o Traefik, F5 Big-IP e mais. Mas NGINX é fácil e simples o suficiente pra este desafio. Não é o mais rápido, mas também não é o mais difícil de usar.







E aqui começa a parte realmente difícil: uma instância de NGINX, uma instância de banco de dados, que pode ser postgres, mysql ou mongodb, mais duas instâncias da sua aplicação sendo balanceadas, precisam caber em 1 CPU e meio e no máximo usar 3 gigabytes de RAM e só. Essa é a regra da rinha. Fazer a API não é o desafio. Essa limitação que é. Mas tudo bem, fazer caber é fácil, o problema mesmo é que no final esse sistema tem que aguentar um stress test, um teste de carga.







Stress test é um teste automatizado que simula como pessoas ou sistemas consumiriam o seu sistema, mandando requisições http pros endpoints da API. No caso eles escolheram a ferramenta Gatling, que tem versão aberta e uma paga com mais recursos. A versão gratuita é razoavelmente simples de usar e o script pro cenário de carga está no GitHub da rinha. Vamos anotar aqui pra eu explicar "O Básico de Stress Test" no próximo video.







Lembrando que quando a rinha começou acho que os participantes ainda não tinham acesso a esse script de testes, justamente pra não tentar burlar os critérios. Eu não sei se eles sequer tiveram acesso ao script durante a rinha. Imagino que não, só no final. Vamos assumir que ninguém sabia. Isso que diferencia os participantes da rinha de programadores como eu agora, que tem a oportunidade de avaliar sabendo tudo que eles não sabiam. Não comparem o meu resultado com o deles, isso seria injusto.







Em resumo, você podia escolher linguagem, framework e implementar uma aplicação web que serve 4 endpoints de APIs. Tinha que ser o mais leve possível pra aguentar carregar duas instâncias, mais nginx, mais banco, em 1.5 CPUs e 3GB de RAM, orquestrado por docker compose. 






Eu ainda não fiz um video explicando o que é um framework web, então vamos anotar aqui pra explicar no próximo video. Eu já tinha feito um video sobre Docker, recomendo que assistam depois, mas aí também no próximo vou explicar como usar o Docker Composer pra subir todos os componentes de um sistema web na sua máquina também. 






A idéia é que os participantes deviam empacotar a aplicação numa imagem de Docker, subir no Dockerhub, postar o arquivo de docker compose como pull request no GitHub da rinha e aí os organizadores iam rodar esse docker compose e aplicar algum teste de carga. Quem passasse, ia pro ranking final.






O ranking foi interessante. Teve 90 participantes. Desses, 39 foram desclassificados por diversas razões. Ou o docker compose tinha algum bug e nem carregava, ou algum dos endpoints da API não respondia como deveria, ou deixaram de implementar alguma coisa que tinha nas regras. Sobraram 51 projetos que funcionaram, mais da metade. Um número respeitável. No final, além de implementar os endpoints corretamente, o resultado pro ranking foi baseado na quantidade de inserts que foram feitos no banco de dados.







Ordenando a lista por essa quantidade de inserts, tivemos os Top 10. Quem ganhou a rinha foi o Vinicius Fonseca, com sua implementação usando Rust, com o framework Actix com Tokio. Em segundo lugar ficou o Leo Vargas com sua versão em Go e Fiber, o framework que usa FastHTTP. Em terceiro ficou o André Marra e Albert Kliemke, que fizeram em dupla uma versão em Dotnet 8 com C#. Em quarto ficou a Isadora Souza, que também usou Go com Gin. Em quinto ficou a dupla algebraic, a Sofia e a Gabi, que fizeram em Lean4, a linguagem mais desconhecida da rinha toda. Depois vou falar delas.







Em sexto ficou o Vinicius Santos que também fez em Rust. Em sétimo ficou o Jean Rodrigues que também fez em Go. Em oitavo ficou o Luiz Picanço, com outra versão em Rust. Em nono lugar "e" também em décimo ficou o Rodrigo Navarro, que participou com duas versões de Rust, uma feita com o framework Axum e outra com o mais leve Touche que, por ironia, ficou depois da versão em Axum. Aliás, parece que ele fez pelo menos uma dessas versões numa live no canal dele, pra quem se interessar corre atrás pra assistir.






Portanto, nos Top 10 ficou assim: 5 versões em Rust, 3 versões em Go, 1 em Lean e 1 em dotnet. Aí as redes sociais foram à loucura. Primeiro, ninguém achou estranho já que isso confirma a hegemonia do Rust e do Go como as linguagens mais rápidas da atualidade. Pior ainda: o fato de dar um dotnet nos Top 10 mas não um Java, fez um monte de gente ficar ridicularizando o Java. Sabe o que falei do torcedor de time neandertal? Sim, afinal na cabeça deles, Java é uma linguagem velha e ultrapassada, certo? Vamos ver como os neandertais leram o resto do ranking.







Seguindo pros próximos 10. Em décimo primeiro ficou o Gabriel Oliveira com uma versão em Elixir. Alguns ficaram tipo, "puts, não era o Elixir que se vendia como rápido? Perdeu até pro dotnet?" Em décimo segundo ficou o Lucas William com uma versão em C++. "Ué, C++ não era pra ser o mais rápido? Rust e Go são foda mesmo, muito melhor que C++". Em décimo terceiro ficou o Lucas Weis com uma versão em Node.js com Express. "Pois é, bem que me falaram que Javascript não é tudo isso que falam, né?"







Em décimo quarto ficou o Yuri Gomes que fez uma versão em Bun, antes do lançamento da versão 1.0 alguns dias atrás. E pois é, Bun é só hype mesmo, nem lançou ainda e já é lento. Em décimo quinto ficou o Thales Maciel que fez em Rust também. Coitado, deve ser um júnior que né, não é culpa do Rust. Em décimo sexto ficou um cara de apelido saiintbrisson, que não deixou arquivo de README pra trás com o nome nem links, então nem fui tentar procurar. 







Em décimo sétimo ficou o Lauro Appelt com sua versão em PHP. Finalmente uma linguagem que se associa mais com Web clássica. Quem diria, PHP ainda não morreu, mas tá lá embaixo com um pé na cova né? E só em décimo oitavo ficou o Bruno Borges com a primeira versão em Java da rinha. E só pra piorar a situação do Java, ele ficou encostado no décimo novo que foi o Lázaro Nixon com uma versão em Ruby on Rails e o vigésimo do Leandro Proença que também fez uma versão em Ruby. Peraí, Java tá tão ruim agora que fica encostado em Ruby?? Que fase heim?






Eu queria parar no vigésimo, mas só no vigésimo primeiro lugar tivemos o Ian Cambrea com a primeira versão em Python, usando Sanic, na competição. Pelo visto Python também é só hype né? Não ganhou nem de PHP, nem de Ruby e nem de Java. Espero que vocês que acompanharam não tenham pensado desse jeito, porque seria vergonhoso. 






Dentre os 51 projetos enviados, 8 foram feitos em Go, 7 em javascript, 6 em Rust, 6 em Java. 5 em PHP. 4 em dotnet. 3 em Python, 2 em Ruby, 2 em Elixir, 1 em C++, 1 em Lean, e o último lugar foi 1 feito em Bash pelo Leandro. Teve uns 3 no ranking que o README não dizia em que linguagem foi feito e nem o link pro Github então também não fui atrás pra saber.






O Lean da Sofia e Gabi foi o mais inesperado, ainda mais por ter entrado nos Top 10 e o último de Bash do Leandro foi o mais inusitado porque acho nem ele esperaria ganhar com isso, mas quis representar e mandou super bem. Sim, Bash de terminal que vocês usam no Linux como shell. Tem gente que roda Doom numa calculadora, porque não uma aplicação web em Bash? Mas nesse caso, como esperado, Bash não tinha como competir mesmo.






Alguns participaram com mais de uma implementação, como o Leandro que fez em Ruby e Bash, o Lauro Appelt com duas versões em PHP, o Rodrigo Navarro com duas em Rust. Não sei como foi a divulgação do Zanfranchesci, mas ele mandou muito bem. Foi uma participação bem variada e ao meu ver cumpriu exatamente o que eu imaginaria de uma rinha: galos de diferentes tamanhos e cores. Rust e Go na frente, Javascript e Java pra trás. É o que a platéia gostaria de ver. Foi show de bola.






Tendo visto os resultados, se no topo tivesse sido uma hegemonia absoluta de Rust e Go provavelmente eu teria aceitado como todo mundo: sim, talvez nessas restrições de infra, só eles mesmo pra aguentar a carga. Mas como tinha um dotnet ali na terceira posição, e meus parabéns pro André e Albert por isso, mas isso chamou minha atenção: não vejo porque dotnet consegue estar nos Top 10 e outra linguagem não, seja Java ou seja Javascript.







Com essa pulga atrás da orelha, minha saga começa na sexta feira, dia 25 de agosto, eu abri o editor e comecei a fazer minha versão. Tava um pouco enferrujado, então levei acho que umas 2 horas pra implementar em Ruby on Rails mesmo. Levou mais tempo do que deveria porque pensei: "hum, se é um teste de carga em inserção, talvez o postgres seja o gargalo. Depois do HTTP POST, o teste vai checar se inseriu pelo ID. Não tem como deixar só em memória porque são duas instâncias isoladas. Como tem balanceador de carga, o normal vai ser a inserção cair numa instância e a pesquisa cair na outra instância".







A conclusão imediata que qualquer um chegaria é: vou colocar um cache compartilhado, talvez memcached. Mas como queria já lidar com o que achei que fosse o gargalo, pensei, "vou jogar jobs em fila de redis pra inserir em background". Então esquece memcache, vou usar redis tanto como cache quanto fila de jobs. Deve caber nas restrições de RAM porque aí o postgres deve trabalhar um pouco menos e eu divido os recursos.






Pelo que avaliei depois, não fui só eu que pensei assim. Várias das versões fizeram a mesma coisa: usaram redis ou nats como cache e fila de jobs assíncronos. É uma coisa que todos nós, que já temos cicatrizes de guerra, fazemos meio sem pensar e isso é um sério problema. Não existem soluções automáticas. Cada caso é um caso e precisa ser medido antes de implementar qualquer truque. Cache ou filas não deixam nada rápido automaticamente em todo caso. Eles também custam recursos. De novo, vamos deixar anotado aqui pra eu explicar no próximo video, como é essa estratégia de usar jobs e filas pra inserir e porque cache não fazia diferença aqui.







Pelo mesmo motivo achei que fosse ver mais gente usando MongoDB, assumindo que muitos imaginam que é mais rápido, mas do total de 90 projetos só 7 tentaram. E mesmo MySQL só 2 tentaram. A maioria esmagadora acreditou no Postgres por padrão. A conclusão: coisas relativamente fáceis, como adicionar caches e filas, todo mundo faz na frente. Coisas mais complicadas, como mudar o paradigma de armazenamento, aí deixamos pra depois. Eu também escolhei ir de Postgres.






Sendo eu criador de conteúdo que, por 20 anos venho evangelizando coisas como uso de Postgres, cache e jobs assíncronos com Redis, me deu uma ponta de dor na consciência. Mesmo aqui no canal já fiz um video chamado "Tornando sua App Web Mais Rápida", onde faço justamente essas recomendações. Eu tento explicar em que casos usar, mas acho que dá pra explicar isso em mais detalhes, por isso deixei anotado pra voltar nesse assunto no próximo video.






Quando terminei minha versão de Rails, com cache, jobs e tudo mais, rodei o stress test. Já imaginava que poderia não ser rápido, mas sempre tem aquela esperança de "vai que" né? E pra minha decepção não deu mais que uns 15 mil inserts, abaixo ainda das versões de Rails do Lazaro e do Leandro. Foi quando comecei a postar tudo que ia descobrindo no Twitter. Esse foi meu primeiro tweet. 






Olha que situação ridícula. Quem gera esses relatórios é a própria ferramenta Gatling, que roda o teste de carga. No próximo video vou mostrar como ele funciona. Nesse gráfico interessa a barrinha verde, olha como tá lá embaixo e a vermelha tá lá em cima. É a quantidade de knockouts ou KOs, de requisições que não conseguiram ser processadas e foram perdidas. Em resumo, só entenda que queremos que verde seja grande e vermelho seja pequeno ou idealmente, zero. Nesse momento eu pensei: "é, talvez essa carga seja muito pesada pra uma linguagem interpretada como Ruby numa infra de docker tão apertada".







Resolvi baixar a versão do Leandro que usa Ruby mas sem framework pesado como o Rails. E os resultados dele foram bem melhores que os meus, mas ainda assim tem uma barra vermelha considerável de knockouts. Eu conseguia 15 mil inserts e a versão dele batia acima de 30 mil inserts, na minha máquina. Na minha cabeça essa discrepância fazia sentido. Imagino que façam na de vocês também, afinal quanto menos coisa tiver, mais rápido deveria ficar.







Só pra testar os limites, tirei a restrição de 1.5 CPU e 3GB de RAM e configurei o docker compose pra usar 24 CPUs e 20GB de RAM, afinal meu PC aguenta muito mais que isso. Assim a barrinha verde de fato sobe, mas olha que ainda tem uma barrinha vermelha. Eu ainda estou perdendo requisições, e pára pra pensar, isso não faz sentido, em nenhuma linguagem. 






Nesse ponto as coisas não estavam fazendo muito sentido. Bacana, eu sei que Rust e Go são rápidos, afinal são compilados e tals, mas se o problema fosse só falta de recurso, na minha máquina, que é absurdamente potente, não deveria estar dando nenhum knockout. Isso foi aumentando a pulga atrás da minha orelha. A conclusão nunca pode ser "a linguagem é uma bosta", a primeira conclusão sempre tem que ser "eu estou fazendo alguma coisa errada" e ir atrás de descobrir o que.







Resolvi tentar uma outra versão, aproveitar o domingo, dia 27 de agosto. Fazia algum tempo que queria desenferrujar meu Crystal e aprender o framework web chamado Lucky. Ótima desculpa. Deixei a documentação do site aberta de um lado, editor do outro e fui fazendo tentativas. Minha premissa é que Crystal, sendo uma linguagem que compila binário nativo, como Go, deveria ser bem mais rápido que minha versão em Rails. No final gastei o domingo inteiro mais a segunda feira seguinte pra fazer, porque nunca tinha usado Lucky antes. 







Vamos anotar isso também pro próximo video: falar um pouco mais das minhas experiências mexendo em linguagens diferentes, mas pra hoje só precisa entender que os criadores do Crystal, o Ary e o Brian, quiseram inventar uma linguagem com sintaxe o mais próximo possível de Ruby, adicionando coisas modernas como inferência de tipos, fibers, channels, mas com perfil de performance similar de Go, e em alguns casos até de Rust.







Foi nesse ponto que fui vendo outros desenvolvedores na comunidade começarem a esmiuçar mais os critérios do ranking, em particular o MrPowerGamerBR. Sendo javeiro ele foi um dos que ficaram sofrendo bullying do povo tirando sarro do Java ter se saído tão mau no ranking. Em vez de só sair dando reply xingando todo mundo, como todo twiteiro faz, ele fez o que um programador de verdade deveria fazer: abrir o código e provar com números.






Ele fez a mesma coisa que eu: começou uma nova versão na linguagem que mais gosta: Kotlin. Pra quem não sabe, Kotlin foi inventado pela JetBrains, a empresa que faz a IDE IntelliJ e o Android Studio. Eu também gosto dela e vou deixar anotado pra comentar a respeito no próximo video. Pra hoje, basta entender que é compatível com Java e tecnicamente oferece a mesma performance.






Dia 28 de agosto ele postou essa versão, que não só melhora a posição de Java, mas iguala na mesma posição Top 1 da versão de Rust do Vinicius Fonseca. Mais do que isso, ele estudou mais a fundo o script de stress test em Gatling e determinou que existe um número máximo de requisições e de inserts possível durante os 3 minutos fixos do teste: 46 mil quinhentos e setenta e seis inserts.






Na verdade vai ser 46 mil quinhentos ou seissentos e alguma coisa porque no script de stress test do Gatling tem essa chamada pra "randomized" que afeta a quantidade de requisições pra criação de registros. Se rodar o teste várias vezes, vai dar números diferentes. Imagino que o Zanfranchesci fez isso de propósito pra adicionar o fator de "sorte" no espírito de uma rinha. Portanto o resultado numérico nunca foi pensado pra ser totalmente justo. E antes que os haters apareçam de novo: eu estou super ok com isso.






Mais do que isso, o MrPowerGamerBR olhou com mais calma a versão de Rust do Vinicius. Sim, ele estava inconformado, e nada é mais motivador do que a força do ódio. Ele notou que surgiam inconsistências esquisitas. Às vezes o total dava 300 a mais do que o máximo. Às vezes dava 500 a mais. Como isso poderia ser possível? Não tem como aparecer requisições do nada. Se existe um máximo e passa do máximo, obviamente existe um bug.






E de fato tem. Não foi de propósito, a gente esquece bugs. Por isso sempre falamos: não é porque uma linguagem compila, não é porque uma linguagem tem checagem de tipos, que não precisa de testes. No código do Vinicius tem uma rotina de aquecimento que insere mais de 500 registros falsos, não sabemos porque, mas depois tem um código que deleta isso. Só que esse código tem uma race condition, uma condição de corrida. Um erro clássico em programação concorrente. Ou seja, às vezes a rotina de limpeza roda antes de terminar de inserir tudo, aí sobra registros e isso polui o total no final.







Não chega a ser um problema, porque mesmo se corrigir esse bug, ainda assim a versão dele atinge o máximo, então sempre seria o primeiro. Mas estudando o stress test, estudando o código do Vinicius e também o do Lucas Weis que fez em Node.js, o MrPowerGamer aprendeu que existem truques que poderiam ser usados que a maioria não pensou. Não foram só eles, mas alguns pensaram além do óbvio e conseguiram resultados melhores.






Em 10 de setembro, o MrPowerGamerBR soltou um video detalhando essas descobertas e recomendo que assistam depois. Eu vou explicar tudo que ele falou e muito mais no próximo video. Uma dessas técnicas foi bulk inserts, a outra técnica foi gerar um índice especial pra pesquisas. Vamos deixar anotado aqui pro próximo video: explicar o que são bulk inserts e explicar como fazer pesquisas fuzzy no postgres e os segredos de ajustes de performance. 






Se consertar o bug de race condition do código do Vinicius e se tirar o fator de aleatoriedade do stress test, o ranking fica bem diferente. Como o MrPowerGamer mostra nos seus tweets, o primeiro lugar seria compartilhado entre a versão de Rust do Vinicius, que continua sendo o primeiro, mas a versão de Go do Leonardo Vargas também sobe pra primeiro assim como o 6o lugar da Isadora e o 9o lugar do Navarro também virariam primeiro lugar.






Por causa disso o terceiro lugar de dotnet do André e Albert pula pro segundo lugar. Eles raspam no máximo mas não ultrapassam por meros sessenta e cinco inserts. O quinto lugar do Luiz Picanço em Rust sobe pro terceiro lugar. O Navarro, que tinha feito duas implementações em Rust, também sobe a outra versão, do 10o pra quarto. O oitavo lugar do Jean Rodrigues, em Go, sobe pra quinto lugar. Todo mundo vai subindo no ranking. 







Mais ainda: sabendo o número máximo de inserts, se alguma versão ultrapassar, sabemos que tem bug nas validações. E isso aconteceu com o quarto lugar em Lean4 da Sofia e da Gabi, e a que ficou em sétimo lugar do Vinicius Santos, em Rust. Ambos ultrapassam os 48 mil e quinhentos e tanto, mas como tinha aquele fator de aleatoriedade no script, na rodada oficial, passaram batido, mas deveriam ter sido desclassificados. E que fique claro que não foi de propósito, que atire a primeira pedra quem nunca deixou um bug pra trás. Como já expliquei, numa rinha tem fator sorte, e está ok.







O problema é que o script de stress test, e o critério de ranking, não tinham sido divulgados desde o começo e nem testam tudo que está nas instruções. Por exemplo, eles deveriam checar as constraints da DDL do SQL que cria a tabela e índices pra garantir que coisas como apelido tem índice de unicidade, que o campo de data de nascimento era realmente de tipo data e coisas assim. Se fizer um campo de nascimento sendo um varchar, um string, e simplesmente inserir o que vier sem checar, no final vai ter mais registros do que deveria. 







Se fosse pra ser mais rígido, deveriam ter implementado uma rotina de testes automatizados em Cypress, por exemplo, uma suite de testes de aceitação que testam todas as regras que estão nas instruções. Assim seria possível ver se a aplicação está devolvendo os códigos de erro quando enviamos dados inválidos. Sem isso, vários bugs passam despercebidos. Fica a dica pra uma próxima rinha. E também pra projetos de verdade: sem testes, tudo compila, tudo roda, mas bugs de validação vão passar despercebidos, em todas as linguagens, compiladas, tipadas, ou não.







Vou repetir: não encarem como uma crítica à rinha, o próprio nome "rinha" é pra ser uma brincadeira. Inclusive, eu acho que se tivesse um teste de aceitação mais rígido assim, teria muito menos participantes e muito mais projetos desclassificados, e meio que perderia a graça. 






Mas o que me motivou a gastar tanto tempo nisso é que só olhando o ranking oficial, sem todo o contexto, eu também estava aceitando que Rails ou Java iam ser lentos mesmo e bola pra frente. Mas à medida que fui explorando o que o Vinicius, o Lucas, o Leandro, o MrPowerGamerBR, fizeram nas versões deles, resolvi copiar na minha versão de Crystal, pra tirar a prova dos nove. Não era pra ser difícil. Na minha cabeça, coisa de poucas horas.







Demorei um tanto pra entender o framework Lucky, o Avram que é o ORM que fala com o banco, tive até que abrir o código fonte deles pra entender. Na dúvida, na falta de documentação ou stackoverflow, nunca penso duas vezes e vou ler direto na fonte. Vantagem de usar projetos de código aberto é que o código é aberto, sacaram? É pra ler. E eu fiquei empolgado em tentar implementar o sistema de cache com job assíncrono pra fazer bulk insert como o Vinicius fez em Rust. Sendo Crystal compilado, era pra ter performance similar, né?







Ledo engano. Assim que terminei e fui testar com o Gatling, a decepção. Lembra a barrinha vermelha? Olha ela aqui firme e forte. Minha implementação nem entraria nos Top 20. Meros 20 mil inserts. Só que diferente do que tava pensando sobre Ruby, que é lento por ser interpretado e não tinha o que fazer, ou Java que come muita RAM e não tinha o que fazer, aqui eu fiquei meio puto. A culpa não podia ser do Crystal, nem do Lucky, tinha que ser minha. Eu estava fazendo alguma coisa muito errada. Será que eu sou uma farsa? Será que eu sou tão ruim assim?







Quando gastamos um tempo tentando descobrir um problema num código e depois de "ver tudo", ou achar que viu tudo, ainda assim não encontrar, eu sempre tenho uma saída que funciona. Olhem neste código de Crystal. Pra passar o stress test, basta devolver HTTP 201 created e um Location válido pra próxima requisição. Até tinha deixado comentado aqui esse código de teste aqui. Posso descomentar essas duas linhas e comentar todas as de baixo. É isso mesmo, na dúvida, tire tudo e faça a resposta mais simples e idiota, devolver uma constante.







Mas esta Location não vai existir, porque se não inserir nada, não existe ninguém com ID número 1. Então, no show.cr, também tinha deixado esta linha comentada, que sequer tenta fazer a pesquisa no banco, só devolve outra constante. Descomento e comento o resto. Pro teste de consulta passar certo, basta devolver HTTP 200 de OK. Finalmente, na pesquisa por termos, mesma coisa, descomento esta linha pra devolver código 200 e comento o resto.






Só fazendo isso o teste de carga já passa. Esta vai ser a velocidade máxima  desse app, sem processar nada no banco, manjam? Estou removendo uma das variáveis de incerteza. Rodando o Gatling, só esperar 3 minutos e esse é o resultado. Tudo verde, nenhum vermelho de knockout, e olhem aqui do lado, todos os tempos de resposta da ordem de 1 milissegundo. Na verdade é menos de 1 milissegundo, mas ele arredonda. Esse é o tempo perfeito, porque a aplicação não tá fazendo praticamente nada. Ótimo, isso mostra como o Crystal sozinho é rápido.






Agora posso ir voltando meu código, uma linha de cada vez. Salvo, subo o docker-compose, que vai recompilar a imagem, e rodo o Gatling de novo. Checo e vejo se a diferença no resultado condiz com o código extra que coloquei. Volto, descomento mais uma linha, salvo, reinicio docker-compose, testo de novo, meço. E vou fazendo isso, uma linha de cada vez. E como esperado, nenhuma dessas coisas extras deu nada de estranho.






Até eu chegar nesta linha, a que monta a URL de Location. A única coisa que isso vai fazer é gerar uma linha como esta aqui em cima, um http://localhost etc. Claro, este método faz mais do que só concatenar strings, serve pra montar todo tipo de URL complexa que quiser incluindo encoding de parâmetros e tudo mais. Imagina aquelas URLs gigantes da Amazon. Mas eu nunca esperaria isso causar qualquer diferença significativa.






Na realidade, isso tá até errado. Pensei melhor e Location na realidade só precisa devolver o path, só a parte de "/pessoas/id". Não precisa do protocolo nem domínio a menos que eu queira redirecionar o cliente consumindo a API pra outro domínio diferente, que não é o caso. Substituindo o método .url pra .path e testando de novo, batata, agora o resultado melhorou.






Eu twitei sobre isso, daí uma conta da comunidade Crystal retwitou e um dos desenvolvedores do framework Lucky, o Jeremy, ficou interessado. Ele foi tão legal que abriu uma issue no projeto. Fui lá explicar esses detalhes. Ele já tinha uma suspeita em mente e me pediu pra testar um ajuste. Este foi meu post no ticket aberto. Quando testei sem o patch dele, tava tomando knockouts, mas colocando o patch, caiu de mais de 600 knockouts pra menos de 10, então tinha alguma regressão de performance mesmo. 






Não sei explicar exatamente o motivo ainda. A versão anterior parece que só concatenava strings, e o patch usa tipo um string builder. Concatenar gera duplicatas da string. Um Builder pré-aloca espaço e vai só adicionando as novas partes sem duplicar. É um trade off de CPU por RAM. Eu sei que isso faz alguma diferença, mas não sei ainda explicar porque faria diferença aqui. Mesmo tendo, não deveria ser significativo. Mas de qualquer forma, no número de stress test do Gatling fez muita diferença.






Sem querer, acabei achando um gargalo de performance no framework que levou a um conserto. É assim que a gente acaba contribuindo em projetos open source: sem querer. Mas essa não era a única otimização. Olhando outras versões notei que ninguém tava devolvendo mensagens de erro completas, como "apelido já existe" ou "formato de data inválida". As instruções só falam que precisa devolver código de status 400 ou 422.






Na minha versão, antes, além do código eu devolvia um JSON com o erro. E processar JSON também custa tempo. Tirei todos os métodos de render ou json e usei só o método "head" que, como o nome diz, devolve só o cabeçalho, o código de erro. É uma coisa besta, que em testes individuais não faria diferença, mas o  Gatling manda centena de milhares de requisições. Aí parece que faz diferença.






Mesma coisa logs. O teste não exige logs. No mundo real precisamos ter mensagens de erro gravadas e retornadas pra ficar mais fácil achar bugs e defeitos, mas pra este desafio de performance que só dura 3 minutos, podemos desligar todos os logs e ganhar alguns milissegundos importantes. E fazendo pequenos ajustes assim, o resultado de inserts de Crystal foi subindo. Dos pífios 15 mil inserts, foi pra 30 mil, daí pra quase 40 mil inserts. 







Não bati no máximo mas chegando perto dos 40 mil inserts, já foi um salto muito bom. Quando postei esse resultado já era dia 1o de setembro. Ainda me distraí no processo porque queria uma biblioteca pra auxiliar o caching em Redis mas não tinha nenhuma bem feito. Esbarrei num bem antigo chamado Kiwi que ninguém atualizava fazia tempo, então resolvi arrumar e melhorar o código dela. E essa foi minha segunda pequena contribuição open source.







Enquanto isso, em paralelo, o Leandro e o Lazaro, das versões de Ruby mínimo e de Ruby on Rails, continuaram mexendo nas versões deles. O lázaro que, no ranking oficial da rinha, tinha ficado lá na 19a posição com uma faixa de 24 mil inserts, também saiu ajustando as configurações dele e com muito pouco ajuste já tinha conseguido bater os 40 mil inserts também. O Leandro também. Com esses resultados eles já teriam entrado nos Top 10.







O Leandro experimentou mais com as configurações de postgres e de nginx. Muitos de nós achávamos que esses dois componentes não eram tão importantes. Pior, achávamos que eles não ajudavam em nada, então fizemos outra coisa feia que muitos fazem sem pensar: colocamos nginx pra aceitar o máximo de conexões quanto possível aumentando o número de worker connections lá pra cima de 10 mil. E no caso do Postgres a gente configurava os pools de conexão pra dezenas ou centenas de conexões. E isso é um enorme erro.







Vamos anotar pra explicar no próximo video, mas deixa eu tentar ilustrar aqui. Pra ter uma visão na cabeça vamos imaginar uma lanchonete, com vários caixas tirando pedido e mandando pros cozinheiros atrás. Os caixas são nossa aplicação, feitos em qualquer das nossas linguagens. Os cozinheiros são as conexões do banco de dados que é a cozinha.






O nginx é como o tamanho da porta da lanchonete. Se fizer uma porta que aguenta passar 100 mil pessoas de uma só vez, o que acontece? O stress test começa com poucas pessoas, umas 3, mas ao longo de 3 minutos, dispara 600 simultaneamente. Só que essas 600 não são atendidas ao mesmo tempo. Não tem caixa suficiente, daí vai formar um amontoado de gente desordenado.






Do lado da cozinha, o banco de dados, cada cozinheiro extra exige pelo menos uns 3 MB de RAM de espaço e vai consumir CPU. Mas a cozinha, é limitada. Lembra da regra da rinha? No máximo 1.5 CPU. Não adianta aumentar cozinheiro infinitamente, que a cozinha não aguenta. Se falarmos pros caixas tirarem quantos pedidos conseguirem, rapidamente esses pedidos vão ficar empilhados porque não tem cozinheiro suficiente pra atender.






A vontade é aumentar os cozinheiros, o pool de conexões. Digamos, temos duas instâncias da aplicação, os caixas, e cada um vai poder tirar até 100 pedidos de uma só vez. Então 200 pedidos. Mas não tem como ter 400 cozinheiros. Primeiro porque eles ocupam espaço, 3 mega cada já vai dar no mínimo 1.2 gigabytes de RAM. Mas beleza, o estabelecimento inteiro aguenta 3 gigabytes que é o limite imposto pela rinha lembra? Mas não tem fogão suficiente pra cozinhar, a cozinha tá apertada, temos menos de 1 CPU, cada cozinheiro vai demorar mais e mais tempo pra atender cada pedido. Entenderam?







Então o cenário é assim: a porta do estabelecimento permite entrar todo mundo de uma só vez, mil pessoas, 10 mil pessoas, entra tudo. Só tem 2 caixas, duas instâncias. Mesmo tirando pedidos rápido, fica tudo acumulado esperando. Não adianta contratar mais cozinheiro, porque a cozinha é limitada, e quanto mais cozinheiros tentamos colocar, mais cada cozinheiro demora. E enquanto o pedido não é atendido, a pessoa fica lá pendurada na frente do caixa esperando. E assim, vai acumulando centenas de pessoas na lanchonete esperando, até começarem a perder a paciência e ir embora. São as requisições perdidas ou knockouts.







A solução que o Leandro publicou não é intuitiva. Em vez de fazer o nginx aceitar quantas pessoas puder, fazemos diferente: limitamos o tamanho da porta. Digamos, no máximo 1000 pessoas. O NGINX coloca um sistema de senhas do lado de fora e vai deixando entrar só 1000 de cada vez, de forma mais ordenada. É igual num Poupa Tempo ou no seu banco. Pega a senha, senta e espera ser chamado. Agora os caixas atendem menos pessoas de uma vez, mais ordenado, e tiram menos pedidos de uma só vez, digamos, no máximo 50 em vez de 100 ou 200. Esse é o pool de conexões.






E na cozinha, em vez de precisarmos de 300 ou 400 cozinheiros, agora precisamos só de 100. Mas aí não vai andar mais devagar? Não, porque sobra mais espaço na cozinha e cada cozinheiro consegue cozinhar mais rápido. É melhor 100 cozinheiros terminando os pratos em 1 minuto ou 400 cozinheiros levando 10 minutos cada porque tão disputando fogão? Entenderam?






Eu estava cometendo esse erro também. Tava deixando nginx lá em cima, com portão gigante pra suportar 10 mil conexões e compensando com 200 conexões no pool de cada instância do Rails. E pra piorar ainda estava cometendo um erro no postgres. Eu tinha esta linha no docker-compose:

```
volumes: - ./postgresql.conf:/docker-entrypoint-initdb.d/postgresql.conf
```



Isso diz pro Docker Compose pegar esse arquivo postgresql.conf do meu diretório local e copiar pra dentro do container de postgres. Mas tava faltando modificar o comando de inicialização pra ter "-c" com o nome desse arquivo. É nesse arquivo que digo pro postgres que ele deve suportar, digamos, um máximo de 400 conexões. 







Como não tava carregando o arquivo, subia com o limite padrão de 100 conexões. E isso confunde, porque eu pensava que ia conseguir abrir mais de 100, mas não ia. E não sabia porque. Esse foi o primeiro motivo de porque meus resultados tavam lá na casa dos 15 mil inserts: nesse caso faltava cozinheiro e eu achava que tinha suficiente. Falta de atenção que chama isso. Em vez de consertar no lugar certo, eu ficava tentando compensar em outros lugares, como no NGINX. 






No próximo episódio vou explicar como eu poderia ter evitado essa confusão. Vamos deixar anotado aqui. Depois que descobri isso, e li o tweet do Leandro, reconfigurei o nginx pra faixa de 1000 workers de conexão e depois diminuí o número de cozinheiros no pool de conexões pra uns 40. O problema nem era o máximo de conexões, era a compensação excessiva que tava fazendo no NGINX. Um erro levando a outro erro. 






À medida que ia diminuindo esses dois números, passava a aumentar a quantidade de inserts no final, a quantidade de pessoas atendidas de fato. Eu tava achando que minha versão de Rails, pelo fato de ter exagerado na solução e enfiado Sidekiq pra jobs, Redis pra fila e cache, ia faltar espaço na cozinha, mas não foi isso, foi questão de gerenciar o fluxo de pessoas. 






Limitar a porta e os caixas em vez de escancarar. Lembrem-se disso: atendimento não é tentar atender todo mundo de uma só vez, é atender grupos organizados de cada vez. É uma questão de vazão e fluxo. Isso é essencial em operações. Seja atendimento numa lanchonete, seja numa linha de fábrica, seja num servidor web.






E foi assim que em 3 de setembro, postei o resultado da minha versão de Rails. Faixa de 39 mil inserts, quase batendo os 40 mil que queria. O cenário que descrevi de gerenciar o fluxo de pessoas na lanchonete é um caso clássico, que demonstra que o problema não é a capacidade de atendimento do caixa, ou de cozinhar dos cozinheiros: é de gerenciar o fluxo de requisições, das pessoas ou sessões. É quando sabemos que o problema principal é gerenciar I/O, entrada e saída.







Nós que somos mais experientes já deveríamos ter parado pra pensar nisso primeiro, mas assumimos errado no começo e essa hipótese errada nos fez perder muito tempo. Assumimos que o problema seria a cozinha, o banco de dados. Aí tentamos compensar aumentando número de cozinheiros ou cozinheiros mais rápidos que seriam os caches. Seria o caso se o problema fosse CPU bound, limitação de CPU. Mas na realidade era problema de fluxo, de entrada e saída, no fluxo dos caixas, o problema era I/O bound, como a maioria dos problemas de Web comum.







Uma vez controlado o fluxo, podemos otimizar o caixa pra em vez de só tirar o pedido e ficar esperando de braços cruzados esperando; enquanto o cozinheiro tá ocupado, o caixa pode fazer outras coisas na frente, como receber o pagamento, pegar a bandeja, separar o refrigerante, limpar o balcão. Não precisa esperar o prato chegar pra depois fazer tudo isso, dá pra fazer em paralelo. É pra isso que servem threads ou os async/await de várias linguagens, como Javascript no Node.js.








Nesse ponto eu já tinha visto o MrPowerGamer e outros colaboradores como o Bruno Borges conseguindo subir Kotlin e Java pro mesmo nível do Rust. Já vi o Leandro e o Lazaro subindo Ruby e Rails pra perto do mesmo nível, faixa dos 40 mil inserts. Eu mesmo já tinha conseguido subir Crystal e Rails. Foi quando minha intuição dizia que a maioria dos participantes, se tivessem conhecimento de tudo que a gente descobriu até agora, seriam capazes de chegar perto desses 40 mil inserts ou até bater o máximo dos 46 mil e quinhentos do Rust do Vinicius.







Alguns não gostaram de ouvir isso, porque agora aquele bullying contra o Java ou a fanboyisse de Rust perderiam valor. E como eu detesto dizer uma coisa sem ter provado antes, resolvi fazer a única coisa racional: demonstrar na prática. Ainda era a mesma segunda-feira, 4 de setembro. Escolhi começar aleatoriamente mexendo na versão em Node.js e Express do Lukas Weis que já tava perto do topo, na faixa de 34 mil inserts, em 13o lugar no ranking oficial. Na minha máquina tava dando abaixo disso, uns 27 mil. 






A versão dele foi uma das que mexi mais. Como foi um código feito pra competição, ele e muitos outros não se preocuparam em seguir boas práticas, clean code, nem nada disso, só cuspiram código até funcionar e publicaram. Não tem absolutamente nada de errado nisso e não considerem esses códigos como representação do que eles conseguem fazer com mais tempo, em projeto de verdade. Isso tem que ser repetido o tempo todo: código pra competição é diferente de código de verdade.






Mas como eu estava com tempo e não era pra participar da competição, aproveitei pra desenferrujar meu Javascript e fui refatorar um pouco o código pra ficar mais organizado e mais legível. Meu objetivo era totalmente diferente da rinha: dar uma limpada e otimizar o suficiente pra bater pelo menos a faixa dos 40 mil inserts, o que elevaria o projeto pros Top 5 oficiais.






Recomendo que leiam meu pull request com calma, deixei o link na descrição do video abaixo, mas em resumo, depois de organizar o código comecei tirando fora a otimização prematura de usar Redis como cache. Como falei antes, o problema não era a velocidade dos cozinheiros, o postgres. Portanto a solução não era tentar achar cozinheiro mais rápido, um Redis. Com a configuração adequada do fluxo de nginx, do pool por postgres, dividindo CPU e RAM melhor no Docker Compose, já resolvia. Arranquei o Redis fora, daí teria mais recursos pro postgres.






Esse cache, além de tudo, não estava sendo efetivo porque o Lucas tentava cachear os resultados do endpoint de pesquisa por termos, só que o stress test manda pesquisas com termos aleatórios, raramente repetidos, então o cache nunca ia ajudar, porque toda pesquisa ia ser nova e não ia ter o resultado no cache. Portanto cache na pesquisa de termos era inútil, só um peso a mais de gravar no cache.






Além disso, no endpoint de criar novo registro, ele deixava o banco de dados criar a chave primária, daí recebia de volta no final e só aí gravava no cache. Isso tem que acontecer um atrás do outro, não dá pra ser assíncrono. Adicionar o valor no cache só aumentava o tempo da requisição. Mais uma vez, era um trabalho extra sem benefício.






No endpoint seguinte, de pesquisar pessoa direto por ID, ele buscava no cache. Mas a pesquisa por chave primária no postgres é igualmente rápido. De novo, o cache não fazia diferença. Só faria sentido se primeiro gerar a chave primária, com uma biblioteca de UUID na aplicação, e mandar o insert pro banco já com essa ID e em paralelo já mandar gravar no cache também com a mesma ID. Como não precisa esperar o banco devolver uma nova ID, não precisamos esperar pra gravar no cache, entenderam? É uma das vantagens de usar um gerador de chaves primárias externo ao banco. Muito iniciante não sabe que não é obrigatório deixar o banco responsável por IDs.







O Lucas também tava devolvendo códigos de erro HTTP junto com mensagens em JSON descrevendo o erro, mas a rinha não se incomodava com isso, então só arranquei fora. O stress test não liga pra mensagem, só quer respostas rápidas. No mundo real, o certo é dar respostas completas, porque sem logs bem descritos depois fica difícil achar bugs e problemas. Novamente, é uma otimização que só serve pra uma competição.






O Node.js tem recurso de cluster, subir forks do processo pra escalar melhor. Mesma coisa que Rails também faz. O Lucas parece que experimentou, mas desistiu. Eu ia tirar fora, mas voltei e passei a usar pra tentar distribuir um pouco mais a carga. Ter um reactor com corrotinas assíncronas e conseguir ter concorrência é diferente de ter paralelismo e o ideal é ter as duas coisas. Eu explico isso no video de concorrência e paralelismo e no próximo video talvez eu tente explicar melhor neste contexto. Vamos deixar anotado.







A parte que possivelmente pesou mais na versão do Lucas foi o endpoint de pesquisa que faz select LIKE na tabela. Muitos erraram nisso: precisa fazer select LIKE nas colunas apelido, nome e stack, então é apelido LIKE termo OR nome LIKE termo OR stack like termo, e esse é o pior jeito de fazer select. O melhor jeito é pré-criar um único campo com as três colunas concatenados durante o insert. Daí fazer um índice usando GIST com a extensão de trigrams. Alguns tentaram GIN, mas pra este desafio o melhor era GIST. Já tínhamos anotado, mas vou explicar isso no próximo video.







A segunda coisa foram as validações. Validar os dados antes de inserir no banco costuma ser mais rápido do que tentar inserir e deixar o banco devolver erro. Por exemplo, que a data de nascimento é inválido, tipo mês 13 ou dia 31 em fevereiro. Podemos só checar se a string tem o formato de ano, tracinho, mês, tracinho dia, no mínimo. Ou tentar converter essa string num objeto válido de data pra garantir. Eu não medi exatamente esse ponto, mas o Lucas usou a biblioteca moment.js, que antigamente já foi bem popular mas acho que é considerada meio obsoleta.








O jeito mais popular hoje é usar outra biblioteca, a date-fns ou simplesmente usar o construtor da classe Date do Javascript nativo. Eu comecei tentando usar o date-fns mas achei mais fácil só checar se o parse da string pra um new Date is not a number (isNaN). Com todas essas mexidas fui mexer no Docker Compose. Ele tava subindo 3 instâncias de Node no Docker, mas como reativei o código de Node Cluster, desci pra 2, cada uma com 1 fork extra, totalizando 4 processos.







Diminuindo a carga do código de cache, que não tava servindo pra nada. Melhorando as pesquisas por termo. Diminuindo a carga do código de validação. Ou seja, fazendo nossos caixas trabalhar menos, em seguida era o problema de diminuir a montanha de gente que o nginx tava deixando entrar tudo de uma só vez. Diminuí a quantidade de workers do nginx dos absurdos 20 mil, pra 10 mil até 1024. Notei que uns 1000 é ideal pra maioria das aplicações. Muitos até menos.






Fazendo isso os caixas trabalham de forma mais organizada e eficiente, precisando de menos cozinheiros, menos conexões de banco no pool. O Lucas tinha configurado com 200, mas agora dava pra descer pra uns 45, talvez até menos. E fazendo tudo isso, essa versão de Node.js saiu da faixa de 27 mil inserts, na minha máquina, ou 34 mil que conseguiu na máquina dos organizadores da rinha, e pulou pra faixa dos 40 mil também. Do meu ponto de vista, foi uma mudança significativa. E cimentou na minha cabeça que dava pra fazer a mesma coisa pra outras versões.






Desculpas ao Lucas por ter pego ele pra Judas, mas não entendam errado. Vários outros, incluindo eu mesmo, cometemos os mesmos erros. Só aproveitei pra explicar mais na versão dele pra não me repetir em todos os próximos. Enfim, ainda no dia 4 de setembro, depois de atingir os 40 mil inserts com o Node.js, resolvi mexer em outro velho conhecido, Elixir. Na minha cabeça não fazia sentido Elixir ter se saído abaixo dos Top 10. Mas eu fiquei surpreso com um problema: essa versão do Gabriel Oliveira se recusava a carregar na minha máquina!






Como chegou a figurar no ranking oficial, significa que o Zan conseguiu rodar pra avaliar. Portanto, se a versão é a mesma (e tem que ser, é a mesma imagem de Docker), por exclusão, tem que ser alguma coisa na minha máquina. Mas toda vez que eu tentava subir o Docker Compose, via as instâncias da app crasheando sem nenhuma mensagem de erro, simplesmente morriam. Puf, zero, nada.






Sem entender o motivo, fiz um teste: mudei o comando do docker compose pra só subir um  "sleep infinity" do Linux. Todo mundo conhece o conceito de sleep, certo? Pausa o processamento pelo tempo que mandar. Linux suporta infinity, daí fica pausado pra sempre, como um loop infinito, while true da vida. Fazendo isso o container fica de pé pra eu poder fuçar. Daí é possível usar o comando docker-compose exec pra abrir um bash dentro do container.






De dentro, tentei executar o binário do app na mão, e de fato, crasheava. Achei isso muito estranho, aí me ocorreu, será que o app é muito pesado? Vou tentar carregar o iex que é só a linha de comando do REPL do Elixir, sem carregar nada da aplicação. E crasheava também. Estranhíssimo. Vamos pular o Elixir e carregar direto só o Erlang, o comando "erl". E crasheava! Bizarro! A sensação que eu fiquei é que os programas pediam mais recurso do que a máquina conseguia entregar e crasheavam, como falta de RAM.






Resolvi editar o arquivo de docker compose pra tirar a limitação da rinha de CPU e RAM. Tentando rodar de novo, aí subia! Por alguma razão tava faltando RAM. Abri o HTOP pra ver quanto de RAM tava usando e era um absurdo, coisa de quase 1 gigabyte e meio! Fiquei bem confuso. Como fazia tempo que não mexia com Elixir fiquei pensando, "ué, será que nos últimos anos eles enfiaram tanta coisa no Elixir que agora precisa de mais memória que uma JVM do Java?". É confuso porque quem já mexeu com web de Java, com Spring e tudo, sabe que 1GB de RAM não é fora do comum. Mas não esperava isso do Elixir.







Eu tava quase jogando a toalha, então resolvi reportar no meu Twitter. Todo mundo achou estranho, mas o próprio Gabriel conseguiu achar a resposta, era o limite máximo de porta que o Erlang detectava no meu sistema. Em Erlang e portanto também em Elixir, portas são usadas pra se conectar com o mundo externo. Por exemplo, pra ler do standard input, STDIN, ou escrever no standard output, STDOUT, são portas. Pra abrir arquivos, pra receber conexões de rede, são portas. 







Erlang pré-aloca no mínimo 1024 portas. Pra determinar o máximo, podemos abrir o shell "erl" e rodar o comando `erlang:system_info(port_limit).` E olha só: meu sistema devolve mais de 1 milhão de portas. Daí tem o detalhe que ainda não entendi: na aplicação em Elixir parece que tenta pré-alocar esse máximo sei lá porque, em vez de ir só alocando se precisar. Daí dá mais de 1 gigabyte de RAM. E se limito dentro das restrições da rinha, iria faltar memória no container, crasheando na inicialização.






Felizmente, com uma simples variável de ambiente `ERL_MAX_PORTS`, podemos colocar um número mais sano, tipo 2048 ou algo assim. Limitando de 1 milhão pra 2 mil, fez uma puta diferença, agora o app sobe, consumindo na faixa de 160 megabytes por instância, que é bem mais razoável e próximo até de versões como Rails ou Node.






Isso é um problema que só aconteceu no meu sistema porque a configuração de Arch Linux é mais agressiva nos limites do que um Debian ou Ubuntu, que são mais conservadores. Sendo mais específico, isso é limite de file descriptors, ulimit do sistema, depois pesquisem sobre isso. De qualquer forma, a versão Elixir do Gabriel eu gostei bastante porque usou características exclusivas de Elixir. Ele fez as duas instâncias rodando em containers diferentes se conectarem num cluster. 






Clusters saem de graça em Erlang, porque a máquina virtual já trás toda a infraestrutura pronta. É fácil de usar. Não serve pra tudo, mas quando precisa é bem útil. Lembram como falei que não valia a pena usar um cache como Redis, primeiro porque o postgres já era rápido o suficiente, mas também porque subir um container de Redis significa dar menos recursos pro postgres? Com o recurso de cluster do Erlang, dá pra ter um cache compartilhado entre as duas instâncias, sem precisar de um Redis entre os dois.






O app em Elixir consegue consultar na memória da primeira instância, e a segunda instância no outro container, consegue pedir pra primeira instância porque estão no mesmo cluster. Assim não precisam de uma memória externa na forma de um Redis da vida. À primeira vista isso parece mais esperto, mas como já disse antes, o problema não é o postgres, e adicionar um sistema de cache só adiciona peso desnecessário.






Mesmo assim esta versão, ajustando só nginx e o pool de conexões, consegue passar dos 41 mil inserts e entra nos Top 5. Mas tem um porém, além do cache, as instâncias faziam chamadas RPC entre eles, ou seja a 1a instância podia pedir pra 2a instância gravar ou pesquisar no banco e vice versa. Isso eu achei desnecessário e adiciona uma comunicação externa via rede pra toda chamada.






Eu não tive tempo de testar, acho que se arrancar fora essas chamadas remotas, o código de cache e dar mais recursos pro postgres, talvez seja possível conseguir um resultado melhor. Mesmo assim eu esperava que Elixir conseguisse um número maior. De todas as versões que eu mexi, essa ainda foi a que performou um pouco pior. Então tem espaço pra simplificar mais o código. Elixir certamente consegue mais. Estão notando o padrão: em vez de adicionar coisa, estou tirando coisas e com isso deixando mais rápido. Por isso sempre repetimos tanto que otimização prematura é a raíz de todo o mal.






Com a versão Elixir do Gabriel batendo acima dos 40 mil inserts, resolvi procurar uma versão em Go Lang. E escolhi um dos que ficou mais embaixo no ranking. A do Luan ficou em 23o lugar com só 21 mil inserts. Assim como Elixir, não tem porque Go ficar lá embaixo e isso já se provou porque pelo menos 3 versões tinham alcançado os Top 10. 






Fiz pequenos ajustes no docker compose, pra dar um pouco menos de CPU pras instâncias de app, assumindo que Go sem nenhum framework iria precisar de menos recursos que Elixir. Daí podemos aumentar CPU do postgres. Teve duas modificações de código que quis mexer. Primeiro, fazer erros devolverem só os códigos de erro 400 ou 422 de HTTP sem mensagens de erro. É pouca coisa mas já faz um pouco de diferença.






A segunda coisa é que ele tava usando Regular Expressions pra validar o formato da data de nascimento. Na real, acho que isso é meio besteira, mas como Regex costuma ser mais lento do que dar split na string e checar cada componente, troquei também. Acho que nenhuma dessas duas coisas faz muita diferença no final. O que deu diferença sim foi o que já falei antes. Primeiro, diminuir o tamanho da porta de entrada: diminuir os 10 mil workers de nginx pra 1024. E aumentar o pool de conexões, embora isso também nem tenha sido necessário.





Só de limitar e controlar o fluxo de entrada de requisições, literalmente uma linha, já disparou o resultado da faixa de 29 mil inserts pra 34 mil. Não chegou nos 40 mil que eu queria, mas por hora resolvi subir meu pull request, que também tem link na descrição abaixo, e pular pra outra coisa. Só pra terminar esse dia 4 de setembro, fui dar uma fuçada na tal versão em dotnet do André e Albert que alcançaram terceiro lugar.






Como muitos outros, eles também optaram por fazer uma versão codificada de forma rápida, sem muitas boas práticas, então ficou bem verbose, tudo super longo. A curiosidade é que como muitos,  também optaram por implementar um cache, mas diferente da maioria, em vez de Redis escolheram usar Nats. 






Nats deveria ser mais usado, e parece que povo de Dotnet usa mais. É uma alternativa até mais confiável do que Redis pras funções de cache ou como uma fila de jobs simples. Em cima do nats, usaram os recursos de async do C# com channels pra fazer a implementação de bulk insert. E com isso conseguiram atingir quase o máximo, 44 mil inserts. Esta versão não mexi em nada, só fucei e tweetei a respeito. 






No dia seguinte, dia 5 de setembro, me sugeriram fuçar alguma versão de PHP então puxei pra rodar a versão do Lauro Appelt que ficou em 17o lugar no ranking, com meros 25 mil inserts. Fazia muitos anos que não mexia com PHP, então precisei da ajuda dos universitários.






Pacotes de PHP hoje em dia se instalam com Composer, que é parecido com NPM de Javascript ou Cargo de Rust. Foram-se os dias de baixar zip de sites como Freshmeat ou SourceForge. Mas PHP ainda tem o conceito de extensions, que como o nome diz, carrega junto com o PHP em si, e modificam as estruturas internas da linguagem. 





Antigamente lembro de usar PEAR que eram as extensions em C, mas hoje parece que são PECL. Nesse estágio precisava carregar essa nova extension chamada Swoole, que adiciona funcionalidades de corrotinas e modelo de I/O não-bloqueante, o que transforma o PHP em algo parecido com Node.js. Basta baixar, compilar e instalar a extension e editar o php.ini pra carregar ela na inicialização.






Depois de bater cabeça pra entender isso e instalar os pacotes, pude rodar essa versão do Lauro, que ele implementou com o framework Hyperf. PHP 7 tem uma sintaxe bem mais moderna do que o antigo PHP 3 que eu usava, mais de 20 anos atrás. Mudou bastante coisa, tá bem mais legível, bem mais organizado. E o Lauro foi um dos poucos que deu uma caprichada e deixou tudo fácil de entender e legível. Recomendo darem uma olhada.






Nessa versão também não mexi em nada no código, só parei pra entender, desenferrujar um pouco do meu PHP. A única coisa que ajustei foi o pool de conexões. Aqui, ao contrário da maioria, o Lauro foi super conservador e limitou o pool de conexões com 10 conexões, muito pouco. Resolvi soltar tudo e jogar lá pra cima, em 500, que é exagerado. Mas fazendo isso e rodando o stress test, essa versão também subiu pra quase 40 mil inserts, o que também o colocaria lá pelos Top 5.






Por causa disso já me dei por satisfeito por enquanto, já que queria pular pra ver outras versões. Nesse dia não mexi em muita coisa. Dei uma pausa e a noite resolvi que ia mexer mais no dia seguinte, mas acabei não conseguindo dormir. Levantei e voltei pro PC. Queria mexer em pelo menos mais uma versão, a de Python. Escolhi o 21o lugar do Ian Cambrea, com menos de 24 mil inserts.






Ele não fez em Django, que seria o mais comum pra web em geral, nem em FastAPI que parece ser o mais comum pra APIs. Ele escolheu Sanic, que é um framework que eu não conhecia. A única modificação significativa que eu fiz foi notar que ele também resolveu usar Redis pra cache, mas não implementou um pool de conexões pro Redis. Tava usando uma única conexão pra tudo.






Não consigo afirmar que era só isso, mas testando na minha máquina como os outros, o resultado bateu nos 40 mil inserts também. De curiosidade, essa foi a única versão que eu vi que usou NGINX diferente. Normalmente a gente configura NGINX pra fazer balanceamento de carga usando protocolo HTTP, portanto usando rede TCP por baixo, fazendo proxy reverso pra outro servidor web HTTP atrás, no caso o Sanic.






Mas NGINX, e outros serviços que rodam em Linux, como o próprio Postgres, que também costumamos conectar via TCP na porta 5432, suportam conexões usando UNIX Sockets. Se tudo for rodar na mesma máquina, que não é comum no mundo real, não tem necessidade de usar rede TCP/IP. Tá tudo na mesma máquina. Podemos fazer um processo se comunicar diretamente com outro processo usando IPC ou inter-process communication, e um dos jeitos de fazer isso é via UNIX Sockets. 






De forma resumida, sabe quando fazemos tipo um cat num arquivo, adicionamos um Pipe, e rodamos um grep do outro lado pra filtrar o conteúdo do arquivo? Isso é um jeito do processo grep se comunicar com o processo cat via esse pipe que liga o stdout do cat ao stdin do grep. É mais ou menos isso que acontece com o NGINX usando unix sockets pra falar com as instâncias de Sanic. Basta todos enxergarem os mesmos arquivos .sock. Depois dêem uma olhada no repositório do Ian pra ver como ele fez.






Como a versão de Python também foi fácil e não exigiu nenhum trabalho meu além de ajustes triviais, fui dormir e no dia seguinte resolvi olhar pro topo da lista de novo. Fiquei curioso com isso de Lean4 que a Sofia e a Gabi usaram e alcançaram o Top 4 do ranking. Nunca tinha ouvido falar nessa linguagem, mas o que vi foi impressionante.






Lean4 é uma linguagem experimental ainda, longe de ser 1.0, criada na Microsoft Research pelo brasileiro Leonardo de Moura em 2013. O objetivo dele foi criar uma linguagem pra ser fácil criar provas de teoremas. É uma linguagem mais focada em formalidades matemáticas, inspirada em linguagens funcionais como Haskell ou OCaML. Ele tem um cheiro de dialeto de linguagem da família ML. Se curte linguagens funcionais e formalidade matemática, essa pode ser uma boa alternativa.






Mais impressionante foi a dupla Algebraic, as autoras do projeto da rinha, a Sofia que tem só 21 anos e a Gabi que tem só 17 ou 18 anos. Como falei desde o começo, implementar esses endpoints de API, em si, não é nenhum desafio. Mas neste caso foi. Lean4 é experimental, comunidade pequena, e quase nada pra Web, porque nunca foi o foco. Ela é quase toda focada em teoremas matemáticos e não criar APIs pra Web.






Pra fazer APIs, elas precisavam de um parser de JSON, já que na regra da rinha, o stress test ia mandar milhares de requisições com JSON. Mas não tinha uma biblioteca de JSON, então a Sofia fez um do zero. Quando se recebe as requisições HTTP, algumas contendo esses JSON, precisa conseguir parsear o pacote. Existe já parser de HTTP em C, que todo mundo usa em várias linguagens, mas pra Lean4 não tinha. Então a sofia fez um wrapper em FFI pra integrar. 






Pra implementar a aplicação em si, ela queria usar algum framework web, como em Node você tem Express ou em Java tem Spring. Mas em Lean4 não tinha, então a Sofia fez um pequeno do zero.  Além disso, pra rodar uma aplicação web, duh, precisa de um servidor Web. Sabe? Tipo Node.js, tipo um web2py, ou um Tomcat. E claro, também não tinha. E claro, a Sofia fez um. Ou seja, esse foi aquele caso de "não sabendo que era impossível, foi lá e fez". 






Só esse esforço já merece uma menção honrosa, porque eu acho que ninguém teve metade do trabalho que elas tiveram. Mais foda ainda porque essa versão foi uma das mais performáticas. Também é igualmente impressionante que uma linguagem desconhecida, experimental e que provavelmente ninguém nunca usou pra web, seja tão performática. 






O criador, Leonardo, focou em fazer uma linguagem com objetivo de provar teoremas e verificação formal em vez de performance bruta. Mesmo assim foi bem sucedido em performance. Não deixem de olhar o código da rinha no repositório da Gabi, além das bibliotecas no repositório da Sofia. Links abaixo. 





No video de análise do MrPowerGamerBR, onde ele descobriu os limites do stress test e das regras da rinha, também conseguiu identificar que algumas das versões nos Top 10 tinham bugs, como de validação, que acabaram deixando passar inserts que não deveriam, em particular por falta de validação de data.







Essa versão em Lean4 tinha esse tipo de bug. Elas esqueceram de colocar validação da data de nascimento. Tudo bem, mesmo com a validação, a versão delas ainda ia ficar entre os Top 10, por pouco. Então aproveitei pra tentar molhar meus dedos em Lean4 pela primeira vez e implementei uma validação simples. Foi o código menos intuitivo que eu fiz em muito tempo. Acredito que quem for mais experiente em linguagens como Haskell ou F# devem conseguir entender mais fácil. 







Tinha outro pequeno bugzinho na hora de gerar a URL pro cabeçalho de Location depois de inserir o registro no banco, então corrigi isso também. De qualquer forma, vejam o link dos meus pull requests na seção de links abaixo. No fim desse dia postei um tweet de resumo até este momento com tudo que descobri. Neste estágio da minha saga, já tinha conseguido fazer minha própria versão de Rails e de Crystal bater os 40 mil inserts, ajustei a versão em Node do Lucas, Elixir do Gabriel, Go do Luan, PHP do Lauro, Python do Ian, além dos ajustes no Lean da Sofia e Gabi.







Chegamos no dia 6 de setembro, véspera de feriado prolongado de Independência e que eu tinha planejado viajar... Depois de ter batido cabeça com Lean4, resolvi que queria bater cabeça com outra linguagem que nunca mexi antes. Tentei fuçar Zig, mas achei que tava experimental demais, o ferramental super instável, na verdade, tudo instável. Coisas da versão 0.10.0 quebram na 0.12.0. Pra uma experiência de um dia só, não ia compensar. Eu acho que é uma das linguagens mais promissoras, tanto que foi usada pra fazer o novo Bun, mas vou deixar pra outra ocasião.






Então lembrei que sempre quis tentar a linguagem Nim, outra que é compilada como Go, tem uma sintaxe inspirada em Python, existe já faz alguns anos então assumi que seria mais estável e melhor documentada do que Zig. Provavelmente fácil de chegar numa boa performance, assim como consegui com Crystal. Ledo engano. Apanhei bastante, a começar pela falta de documentação.





Não ajudou nada que a biblioteca assíncrona pra Postgres se chama asyncpg, que é o mesmo nome da de Python. Quando pesquisa no Google, adivinha quem aparece primeiro? Pra piorar, a linguagem e suas bibliotecas usam e abusam de macros, que modificam a sintaxe da linguagem. Sem ter uma boa experiência, foi confuso diferenciar o que era da linguagem e o que eram macros. As mensagens de erro do compilador confundiam mais do que ajudavam. Reclamações de amador, claro, não estou dizendo que é um defeito, mas é uma curva de aprendizado maior pra iniciantes.






Recursos de corrotinas, tipos como Option, pareciam ainda meio experimentais, com hacks pra funcionar certas sintaxes. Escolhi o framework web Jesper ,que parece um Sinatra de Ruby. Apanhei um bocado mas consegui implementar os 4 endpoints numa manhã. Só que contrário às minhas expectativas, o resultado foi pífio, uma verdadeira droga mesmo. 






Já tentei compilar com opção speed, nada. Já tentei compilar com modo multithread, nada. Suspeito que a biblioteca de async pool que estou usando é imatura e vaza conexões. Depois preciso investigar isso melhor. Mesmo aumentando pool pra 100 ou mais, nem chega até o fim do stress test, abre o bico muito antes. Male male insere 2000 inserts. Isso deixaria esta versão lá no fim do ranking oficial, só ganhando da versão de brincadeira feita em Bash do Leandro.






A probabilidade maior é que eu, sendo amador, posso ter feito erros de iniciantes e por isso foi ruim. Mas na maioria das linguagens mais maduras, um iniciante teria dificuldade de deixar tão lento assim, mesmo se fosse num Javascript. Se tiver alguém assistindo que tem experiência com Nim, não deixe de dar uma olhada no meu pull request linkado abaixo pra ver se descobre o problema, mas no estado que tá agora, eu não recomendaria usar Nim pra uma aplicação web, mesmo se fosse bem simples. Se for pra usar uma linguagem imatura com bibliotecas instáveis e mau testadas, é melhor ir direto pra Zig ou V Lang que são mais modernas.






Apesar dessa tentativa frustrada, outros desenvolvedores acompanhando minha saga começaram a se mexer pra fazer versões melhores. Por exemplo, nesse mesmo dia vi o Junior Leão mostrando uma outra versão em Java com Spring Boot, usando Redis pra cache com JDBC direto e também conseguiu alcançar os 40 mil inserts.






Outra tentativa bem sucedida foi do Carlos Silva, conhecido como Insalubre, que tinha participado com uma versão em V Lang, mas tinha algum problema e ele foi desclassificado, então nem entrou no ranking oficial. V Lang é uma nova linguagem com cara de Go. Ele se inspirou nas discussões de técnicas que ficamos fazendo no Twitter, consertou a versão dele, e atingiu os 46 mil inserts.






O Leandro continuou mexendo na sua versão de Ruby e neste dia   reportou que conseguiu bater os 46 mil inserts. Ele foi quem mais testou a hipótese de diminuir a porta de entrada do NGINX e controlar a vazão de requisições. Com só 256 workers do NGINX e 30 conexões totais de Postgres no pool, conseguiu alcançar os 46 mil inserts, demonstrando que nem o nginx e nem o postgres nunca foram os gargalos desta rinha. Veja o fio do tweet dele nos links abaixo pra mais detalhes.






No fim do dia resumi num tweet todas as técnicas que descobrimos até agora. Por exemplo, validação pode consumir  tempo precioso, quanto mais otimizar, melhor. Não precisa devolver mensagens de erro elaboradas, muito menos em JSON, só o cabeçalho HTTP com o código de erro tá otimo e vai ser mais rápido. O postgres não é o gargalo, não com essa quantidade mixuruca de dados. 50 mil inserts não é nem um peido. Por isso não precisa tentar otimizar prematuramente com Redis pra cache.






Linguagens que escalam com threads ou forks precisam de mais conexões com o banco. Um exclusivo pra cada thread. Então tem que dar um pouco mais de RAM pro banco subir essas conexões extras. Cada conexão de Postgres custa caro, uns 2 a 3 megabytes, porque são forks. Então 100 conexões exigem no mínimo 300 megabytes. E ainda tem que sobrar RAM pra processar as queries. Ou seja, menos de 500 megabytes é inviável. Linguagens com suporte a fibers exigem um pouco menos conexões, porque compartilham a mesma conexão na mesma thread. De novo, tá anotado já pra eu explicar isso no próximo episódio.






Uma coisa que eu e o MrPowerGamerBR vimos na implementação vencedora em Rust do Vinicius Fonseca, é que ele entendeu mas nem todo mundo pensou na forma correta de lidar com searches fuzzy do Postgres. Também já anotamos pra eu explicar no próximo episódio. O Vinicius fez certinho. Ao tornar o search mais eficiente, sobra mais CPU pro postgres conseguir lidar com os inserts.





E por fim, o mais importante, é lembrar do conceito de controlar a vazão na entrada, diminuindo quantidade de workers de NGINX. Esse nunca foi o gargalo, com meio CPU e quase nada de RAM,  aguenta todas as requisições do stress test sem reclamar. Alguns não gostam de NGINX porque algo usando FastHTTP de Go é muito mais eficiente, mas nesta rinha o NGINX nem chega perto de ser gargalo. 






Colocando 0.15 CPU e uns 200 megabytes pro NGINX, perto de 0.75 CPU e pelo menos 1.2 GB de RAM pro Postgres, daria pra colocar um pool exagerado de mais de 200 conexões, embora os 100 padrão no total seja suficiente pra maioria.
O que sobrar, dá pra dividir com sua aplicação, ou seja, 0.3 CPU e até 0.8 GB de RAM pra cada instância. 
Depende se sua aplicação for mais pesada que isso, como as versões em Java ou Rails ou mesmo Node, aí precisa ir tirando e testando de 0.05 em 0.05 do postgres, dando pra aplicação e medindo pra ver os limites.






E chegamos no feriadão de 7 de setembro. Apesar de eu estar coçando pra investigar mais códigos da rinha, tive que parar por alguns dias. Eu corri pra tentar desvendar tudo antes do feriado, e apesar de ter conseguido ajustar várias versões pra chegar nos 40 mil inserts, ainda tava coçando a cabeça com o elusivo máximo de 46 mil. Tinha algumas suspeitas pra testar quando voltasse, mas fui viajar com essa pulga atrás da orelha ainda.






Já tinha planejado de levar minha namorada pra conhecer Gramado, no Rio Grande do Sul. Nos divertimos bastante apesar de estar super cheio e com tempo meio duvidoso. Visitamos diversas atrações, como a Super Carros, onde pude fazer test driver de Ferrari e Nissam GT-R! Mas, este video não é de turismo. Quem me acompanhou no Instagram viu as stories em tempo real. Se não acompanhou e ficou curioso, deixei um destaque lá. Procurem o link na descrição abaixo.






Mesmo durante o feriado, vários desenvolvedores continuaram empenhados em desvendar os mistérios da Rinha e na sexta feira, dia 8 de setembro, outro dos participantes, o Vinicius Ferraz, fez umaa descoberta muito importante. Ele twitou assim: "você que participou da rinha, tomou um j.i.IOException: Premature Close? Tunou o banco, sua app, o nginx e não conseguiu resolver 100%? Sabe onde poderia estar o problema? Na rede do docker. Como resolver? network_mode: host em todos os serviços.






Caraca!!! Nas primeiras versões que mexi, na minha em Rails, em Crystal, a de Node, onde gastei mais horas, chegava perto dos 40 mil, 39 mil, o comportamento ficava estranho. Olhando no gráfico não tinha muita explicação. Ficava esse tremido esquisito no fim do gráfico, como se estivesse tentando ultrapassar um teto invisível. 






Mesmo nas versões vencedoras, como o Rust do Vinicius, dava pra ver um tremido menor no fim. Mas ele conseguia ir aguentar até o fim. Independente da versão, mais cedo ou mais tarde, aparecia isso. Eram requisições que começavam a se perder! Não perdia tudo nos inserts, mas principalmente nas pesquisas por termo, até em pesquisas inválidas, o que era mais absurdo, já que  só checa se o parâmetro de termo não existe e devolve cabeçalho de erro. Esse endpoint nunca tinha que dar knockout, porque não processa nada. 






Como teve aquele caso do Elixir do Gabriel, que descobrimos que meu sistema Manjaro baseado em ArchLinux tem ulimit maior e por isso afetava o uso de memória do Erlang, imaginei que tinha alguma coisa na minha infra que também pudesse estar afetando isso. Cheguei a suspeitar do Podman, que eu estava usando no lugar do Docker. Mas não deu tempo pra investigar isso porque chegou o feriadão e fui obrigado a parar.






E era mesmo no Docker, e o mesmo problema acontece no Podman. Explicando. Quando subimos container de Docker, não é uma máquina virtual. Eu expliquei isso em detalhes no meu video de Docker, então assistam lá depois. O processo roda nativo no sistema operacional host. Só que a infra do RunC de Linux, que é a base do Docker e do Podman, nos dá opção de enganar o processo rodando. Uma dessas formas é quando mapeamos volumes. Dizemos que um diretório dentro do container na verdade mapeia pra outro diretório do lado de fora, no host.






O mesmo vale pra rede. Digamos que eu queira subir vários postgres na mesma máquina. Não ia conseguir, porque o primeiro ia subir e dar bind na porta 5432. O segundo ia tentar dar bind na mesma porta, mas como já tá ocupado, ia falhar. Com containers, cada processo consegue dar bind na porta 5432 de uma rede falsa, virtual. Ele acha que tá sozinho na máquina. Daí podemos mapear a porta interna do container pra uma porta na rede de verdade do lado de fora.






Pra isso precisamos de uma ponte de rede, um "bridge", que é o modo de rede ou network mode padrão. Mas podemos escolher fazer bind direto na porta da rede de verdade, do host. É isso que o Vinicius sugeriu: network_mode: host. Ao não usar o modo ponte, estamos retirando o gargalo da tradução de tráfego da rede virtual pra rede de verdade. Isso custa recursos, é mais pesado. Não existe almoço grátis. Tudo custa alguma coisa. O que a gente não sabia é que era pesado a ponto de afetar esse stress test.






Sem querer, esse era o elo perdido da rinha, a última peça que faltava. E só pra me deixar ainda mais ansioso pra voltar do feriadão, no domingo dia 10 o desenvolvedor Reinaldo resolveu fazer uma versão nova em Java usando Quarkus, Reactive e VertX seguindo as dicas do Bruno Borges e Vinicius Ferraz. Depois vejam o repositório dele, o usuário é zsantana. Ele twitou como conseguiu uma versão que atingia mais de 51 mil inserts.






Mas já falamos que o máximo é 46 mil e quinhentos, portanto certamente esta versão tem bug de validações, como eu demonstrei na versão em Lean4 da Sofia. Mais importante, esta versão em Java atingia um critério que a rinha não media mas que pra mim era importante e eu passei os últimos dias tentando entender porque ninguém atingia: Zero Knockouts. Não perder nenhuma requisição. Esse é o ponto onde vencemos o stress test.






Entenderam? Até este momento a noção era que o stress test era tão pesado que nenhuma aplicação conseguia segurar tudo e eventualmente ia perder algumas requisições. Alguns mais, alguns menos. Isso é comum em testes de carga. Mas assim como nginx e postgres nunca foram o gargalo, a carga também nunca foi tão pesada assim. Quando o Zan foi testar os participantes pra encontrar os finalistas, o teste era ainda mais leve. 






Ele dobrou o teste, senão todo mundo ia passar. Mas mesmo dobrando, ainda não é pesado o suficiente. Todos os teste que fiz até agora foi com essa versão já dobrada. É importante ter essas ordens de grandeza em mente. Vamos deixar anotado porque preciso explicar isso pra vocês, o que significa sessões simultâneas, tempo de resposta, throughput.






Faixa de 50 mil linhas numa tabela é super leve pra um banco de dados como Postgres. Só vamos sentir que ele tá pedindo água quando atingirmos faixa de milhões de linhas e isso se estiver sem índices adequados. 600 sessões fazendo requisições, não é pesado. Mesmo com a restrição de menos de 1 CPU no Docker Compose. 1000 sessões simultâneas continua não sendo pesado.






A viagem de volta de Gramado foi cansativa. Varamos noite no domingo pra segunda. Estava de carro alugado e saímos quase 2h da manhã de Gramado pra devolver o carro às 4h em Porto Alegre e pegar o vôo de volta pra Congonhas, em São Paulo às 6h. Pegamos táxi perto das 9h da manhã. Antes das 10h chegamos em casa. Eu só pude cochilar rapidinho no avião e quando cheguei já liguei meu PC.






A primeira versão que queria testar foi a de Crystal com Lucky. Troquei o network mode no docker compose pra host e ... foi! Era isso. Bateu 47 mil inserts. Provavelmente algum bug de validação porque ultrapassou o máximo. Zero knockouts. Sabe a tal tremida nos gráficos que falei? Liso, até o fim, uma linha reta em todos os gráficos. Era isso que eu sabia que Crystal tinha capacidade, e confirmamos, a rede do Docker que não estava deixando!






Próxima versão, mexi no meu Rails overengineered com Sidekiq e tudo mais. Network mode host e bateu acima de 45 mil inserts, faltou pouco pra atingir o máximo dos 46 mil e tantos. Não gastei muito tempo ajustando valores no docker composer, mas mesmo assim deu só 4% de knockouts. Antes dava 20%, 30% ou mais. Mas isso prova meu ponto: o gargalo nunca foi nem falta de CPU e nem falta de RAM, nem postgres e nem nginx, era um problema de I/O e isso é gerenciável em quase qualquer linguagem. Se Crystal e Ruby batem o máximo, qualquer outra deveria conseguir.






Peguei a versão de Lean4 e ainda tem algum bug de validação, mas bate acima dos 47 mil inserts. Mais uma versão que vence o stress test sem suar. Peguei a versão em Node.js do Lucas e também bateu no máximo de 46 mil e tantos. E isso foi se repetindo. A versão em Python e Sanic do Ian Cambrea, a versão em V Lang do Carlos, a versão em Go do Luan, a de PHP com Swoole do Lauro, a outra versão em Rails do Lazaro, todos batem o máximo.






De bônus, resolvi testar a versão em C++ do Lucas William que tinha ficado em 12o lugar com menos de 35 mil inserts, também bate perto do máximo agora, 43 mil inserts. Não bateu por algum bug na validação. Enquanto algumas versões faltava validação e deixava inserir mais que o máximo, nesta versão tem alguma coisa filtrando demais e impedindo de gravar mais. Olhando os gráficos claramente podemos ver que tá sobrando recursos. Zero knockouts, não tá perdendo requisições, então tem recursos sobrando.






Nesta segunda-feira, tava todo mundo só falando do lançamento da versão 1.0 do Bun, a nova alternativa a Node.js e Deno que promete ser mais performático. Ainda é cedo pra dizer e ainda nem é totalmente compatível. Mas o Yuri Gomes tinha participado da rinha com a versão pré-lançamento do Bun, 0.8 e tinha ficado em 14o lugar com menos de 28 mil inserts. Mas com network mode em host, ele também bateu o máximo e com tempos similares da versão de Rust. Neste exemplo com escopo pequeno, seu desempenho foi à altura do hype, o que é bem promissor.






Alguns ficaram me cutucando pra mexer em C# também. Eu não tinha mexido em nenhum até agora porque a versão do André e do Albert já provaram que alcançava o máximo. Mas, nada mais justo do que finalizar essa segunda-feira super corrida pós-feriado, do que avaliar a versão do nosso querido organizador da rinha, Zanfranceschi. Por coincidência ele participou com uma versão de Dotnet.







Não vi ele no ranking oficial. Acho que, como organizador ele se absteve de se colocar na disputa, participou pela diversão mesmo. Mas cometeu o mesmo erro que eu e outros: assumimos que postgres ia ser o gargalo e colocamos cache de Redis antes de realmente medir a necessidade. Mas espero que a esta altura tenha ficado claro que postgres nunca foi o gargalo. Não estou dizendo que nunca é, em outros projetos pode ser, mas neste desafio não era. Por isso é caso a caso, precisa medir.






Por causa disso ele implementou um cache em memória usando um ConcurrentDictionary. Lembra aquelas pesquisas com select LIKE que mencionei antes? No Postgres, se indexarmos com GIST e trigrams, fica bem rápido, mas com uma estrutura rudimentar como um dicionário, um hash, ele é obrigado a percorrer 100% do dicionário o tempo todo, extremamente lento.






Isso limitou o resultado a 40 mil inserts. Eu tentei fazer os mesmos ajustes de todo mundo: limitar vazão do nginx, mexer no pool de conexões, dividir melhor recursos do docker composer, colocar em network mode host, mesmo assim não dava. Minha suspeita é que esse ConcurrentDictionary matou esta versão, se alguém quiser tentar tirar e retestar, vá no repositório dele nos links abaixo.






De qualquer forma, com a ajuda de todo mundo, do Leandro, do MrPowerGamer, do Gabriel Oliveira, do Vinicius Ferraz e outros, conseguimos atingir o objetivo não oficial que eu estabeleci pra rinha: vencer o stress test e colocar todas as linguagens no mesmo 1o lugar ou dentro dos Top 3. Fizemos isso com 3 versões de Ruby, Node.js, PHP, Python, Java e Kotlin, Bun, V Lang, Go Lang, Crystal, C++, todo mundo bateu os máximos.






As duas exceções que não bateram foi a de C# do Zan e a de Elixir do Gabriel. Em ambos os casos, acho que a lógica de cache engargalou. Que é lição aprendida: não faça otimização prematura. Em vez de ficar mais rápido, pode ficar mais lento. Se tirar esse cache, provavelmente bateriam os Top 3. E falando em Top 1, agora que consegui cumprir minha missão nesta rinha, só faltava uma última coisa que queria fazer: desenferrujar meu Rust mexendo na versão do ganhador oficial, o Vinicius Fonseca. Finalmente chegamos no 16o dia da minha saga, dia 13 de setembro.






Assim como a versão em C++ do Lucas, ou em Node do outro Lucas, que colocaram tudo num arquivo só. O Vinicius fez a mesma coisa em Rust. Repetindo: é uma rinha, o critério não era o código durar pra sempre, era só aguentar o stress test. Beleza do código, mantenabilidade, legibilidade, segurança, nada disso eram critérios. Eu que fui narigudo e fiquei fuçando e mexendo no código dos outros sem ninguém pedir. Meu objetivo era só desenferrujar meus skills. Uma boa forma de fazer isso era pegar o código dos outros e sair reorganizando.






Essa foi a primeira coisa que fiz no código do Vinicius: refatorar. Rust já não é uma linguagem muito fácil de bater o olho. Cheio de anotações, um monte de .clone() e .unwraps() e tipos e generics pra lá e pra cá. E tudo amontoado. Dividindo em módulos fica mais fácil de bater o olho. Mas eu queria corrigir o bug que o MrPowerGamerBR identificou na análise dele: a condição de corrida que acabava deixando sobrar mais linhas na tabela do que o máximo possível.






Isso acontece porque o Vinicius manda inserir mais de 500 linhas na inicialização pra algum tipo de aquecimento. Que eu saiba o Rust não tem e nem precisa de um just in time compiler, um JIT, já que é pré-compilado em binário. Aquecimento faz mais sentido pra Java, que tem JIT. Enfim, ele deixa essa rotina rodando numa corrotina da biblioteca Tokio, a mais famosa que dá suporte à semântica de Futures, o equivalente a Promises de Node.js.





Na sequência, inicia um segundo Future assíncrono. Essa rotina tem um timer, um sleep de 2 segundos. Quando passa 2 segundos  manda um comando de SQL pra deletar as linhas de aquecimento. É aqui que acontece a condição de corrida. Nada garante que 2 segundos é suficiente pra inserir essas 500 linhas. Muitas vezes o delete acontece antes. Daí sobra linhas na tabela.





Não havia necessidade do delete estar num future separado. Bastava disparar o delete depois do último insert. Ou uma gambiarra seria aumentar esse timer de 2 pra mais segundos. Eu fiz isso. E pra garantir, alterei o último endpoint, o de contagem final da tabela, pra filtrar os registros de aquecimento. Com isso batemos os mesmos 46 mil e tantos inserts, como todo mundo. Depois dêem uma olhada no meu pull request pra conseguir entender melhor essa versão de Rust.






Eu não curto competições de código. Não porque sou contra. Cada um com seu entretenimento. Não tem nada de errado em competir com código. Só não pode achar que código de competição é a mesma coisa que código pra projeto de verdade. As técnicas são diferentes. Os requerimentos são diferentes. Muitos truques que mencionei, não devem ser usadas sem critério, vai dar errado. E nenhuma comparação generalizada deve ser feita entre as diferentes tecnologias usadas.






Uma competição no estilo dessa rinha serve pra mostrar quem foi mais esperto, quem teve mais sorte, quem foi mais cuidadoso. O Zan teve bastante trabalho pra organizar e pra avaliar um a um. Cada rodada do stress test do Gatling custa 3 minutos. 50 projetos que passaram significa que ele gastou quase 3 horas só esperando os testes rodarem, sem contar os outros projetos participantes que tinham bugs. Agora que passou é fácil dizer "ah, poderia ter feito X melhor, poderia ter feito Y melhor", mas a posteriori tudo é fácil.






Eu gastei mais de 2 semanas avaliando 18 repositórios em 16 linguagens diferentes. Eu tive a sorte de contar com a contribuição de diversos outros desenvolvedores que se animaram pra investigar junto. Acho que conseguimos desvendar todos os truques possíveis desta rinha, incluindo vencer o stress test do Gatling. Mas isso não é competição, é análise técnica. Não é divertido pra todo mundo, só pra nós mais nerds.






Mesmo se você for torcedor de um Neymar, Messi, Cristiano Ronaldo, seja lá quem acha que é o melhor jogador do mundo, se no dia do jogo eles torcerem o tornozelo e não participarem, o resultado vai ser o que der no dia. Quando perdem, não significa que são ruins no geral. Só significa que perderam aquele jogo, ponto final. É o conjunto da obra que determina os melhores e não um jogo individual. Sorte faz parte do jogo. Mesma coisa nesta rinha. Só porque um Java ou um PHP não apareceram no topo, desta vez, não tem nenhuma correlação com a qualidade deles em outros jogos.






Amador desbocado é quem faz mais barulho nas redes sociais, então meu objetivo foi educacional: demonstrar porque estão errados e fazer todos entenderem que sim: com mais tempo, experiência, skill, qualquer uma das linguagens tinha capacidade de alcançar resultados semelhantes, alguns com mais trabalho, alguns com menos trabalho, alguns gastando mais recursos, alguns menos, não importa. Sua linguagem não te define.






Assistiram meus videos de Sua Linguagem Não é Especial? O que eu falei lá? Um bom desenvolvedor é promíscuo com linguagens. Eu mexo em qualquer uma, a qualquer hora, quando quiser e como quiser. O que eu falei em videos como Aprendendo a Aprender ou Aprendizado na Beira do Caos? Várias das linguagens que mexi nesta saga, ou nunca tinha mexido, como Nim, Lean4, V Lang, ou tava enferrujado fazia anos, como C++, C#, Rust, Go, PHP, Crystal. Mesmo linguagens que tenho um pouco mais de intimidade, como Ruby, Javascript, Python, tive que quebrar a cabeça.






O que eu fiz? Instalei uma a uma e fui fuçar código dos outros. Quebrei elas várias vezes. Consertei, refatorei, reorganizei, fiquei em muita tentativa e erro, reimplementei técnicas diferentes, apliquei técnicas de uma linguagem em outra, li muito código fonte. Mesmo sem nunca ter mexido num framework como Lucky, mesmo Bun que acabou de lançar, não levou mais que algumas horas pra me acostumar. Essa é a diferença: as primeiras linguagens que aprender vai levar meses, anos pra dominar. 







As próximas vão ficando exponencialmente mais rápido de pegar, o suficiente pra conseguir fazer o básico. Novamente, demonstrei este ponto na prática. Em um dia já dá pra fazer alguma coisa, se me der poucos dias, consigo me virar em qualquer uma. Em poucas semanas já vou saber truques avançados de cada uma. Eu consigo me tornar produtivo numa linguagem nova em 1 mês. Onde vou levar mais tempo? Em linguagens que tem paradigmas muito diferentes, como Haskell, Ocaml, F#, Clojure ou o Lean4 que vimos hoje.






Com todos esses disclaimers e avisos feitos, ouçam até o final antes de sair comentando. Sim, Rust e Go aparecem no topo do ranking oficial porque, se não cometer erros graves, o tempo de resposta individual de cada requisição vai ser na faixa abaixo de 1 milissegundo, de microssegundos. Frameworks como Rails ou um Laravel da vida vão responder na faixa de milissegundos. Quanto menor o tempo de resposta, mais requisições dá pra responder no mesmo período de tempo. Rust ou Go realmente tem mais velocidade bruta e conseguiram bater a barreira acima dos 40 mil inserts, mesmo com docker em modo ponte, e chegar no máximo durante o evento.






Porque todo mundo não passa a adotar Rust, Go, V Lang, Zig, de uma vez? Tudo compilado em binário nativo super rápido? Vamos colocar assim: não existe um único motivo. Não pensem que as pessoas ou empresas são burras e não sabem que são rápidos. C e C++ existem muito antes da maioria de vocês nascerem e sempre foram rápido. Todo mundo sabe disso.





No caso de um V Lang ou Zig é fácil explicar: é porque são novos demais e instáveis demais, tem suporte baixo, tem ferramental imaturo, mudando o tempo todo e quebrando compatibilidade, falta documentação na forma de livros, cursos justamente porque ainda estão mudando muito. Esses não tem como ser adotados em larga escala. Só early adopters muito dedicados. Só empresas menores e com maior margem de assumir riscos, com um co-fundador ou diretor técnico muito bom pra liderar. 






Mas tudo é uma questão econômica. Não me xinguem, eu sou só mensageiro, mas a realidade é que a enorme maioria dos programadores não tem capacidade de aprender a usar linguagens de baixo nível, no nível que seria necessário pra serem produtivos e produzir código bem feito. O fato da maioria das empresas não estar desesperadamente procurando esse perfil é a evidência. Sempre existem exceções, não comece com "ah, mas eu conheço fulano ou ciclano". Exceção não define a regra. 







Fica a dica: se tornar um programador avançado nas tecnologias mais difíceis, te torna uma mosca branca, que vale muito mais
que os outros. O que eu sempre falo? Tudo que é fácil pra você aprender, também é fácil pra qualquer outro. Quanto mais gente tiver fazendo a mesma coisa, mais barato todos vão ser. O valor está em ser bom naquilo que poucos tem capacidade de conseguir. Onde a barreira é mais alta. E isso vai ser Rust, Go, C++, pra resolver problemas muito mais complicados do que fazer Cruds ou APIs. 






Reflitam sobre vocês mesmos, porque estão estudando Java ou C# ou Javascript? Porque são as posições que tem mais vagas. Rust não se vê vagas todos os dias. Estão vendo? É o problema do ovo e da galinha. Você não quer investir tempo pra aprender Rust porque não vê vagas todo dia. E as empresas não oferecem vagas porque não vêem trocentos cursos e estudantes aprendendo. Por isso que esse tipo de movimento, ou começa em startups arrojadas ou dentro de gigantes como uma Microsoft. As vagas existem, bem pouco, e pagam bem, só que são bem mais exigentes. Mas ninguém gosta de vagas difíceis, só querem as que acham fácil. 






Não é prático nem realista manter aplicações web complexas e gigantes em linguagens assim. Imagine um Shopify, GitHub, MercadoLivre, Amazon ou iFood da vida, 100% em linguagens de baixo nível. Partes do sistema, que são mais sensíveis a performance, já adotam coisas como Go, mas é a menor parte. Pro uso do dia a dia, dashboard, relatórios, cruds e coisas assim, não compensam. Seria um enorme desperdício dar tarefas consideras commodity como fazer relatórios, pra um tipo de programador raro e caro, com de Go ou Rust. 






Adotar uma tecnologia só porque é mais rápida, não é um bom argumento. Hoje em dia todas são rápidas o suficiente. Mesmo linguagens que um programador de Rust chamaria de lentas, como Javascript ou Python, conseguimos atingir patamares similares com um custo um pouco maior de máquina. Como demonstrei aqui, na maioria dos casos, é possível dobrar a performance, triplicar, tendo o conhecimento adequado, sem quase modificar código, nem precisar jogar tudo fora e reescrever tudo em Rust. É isso que programadores como eu fazemos. 






No fim dia, dado a escassez de programadores de Rust ou Go e a dificuldade de achar talentos que consigam ser treinados nisso, em pouco tempo, sai bem mais barato compensar com servidores mais parrudos. Alguns pensam que pra dobrar a performance da sua aplicação em PHP, em Java, Dotnet, Python, Node, precisa jogar tudo fora e reescrever em Go. Tá errado. 






Só vai garantir que os erros por ignorância que foram cometidos com um PHP, vão se repetir em Go. Programador ruim, vai fazer código ruim em PHP ou em Go. Não existe nenhuma garantia que vai ficar mais rápido se você continua não sabendo porque o anterior tava lento. Por outro lado, por experiência, já melhorei muito sistema de verdade mexendo nos 20% de problemas que dão 80% de retorno. É sempre assim, às vezes são besteiras de pouquíssimas linhas, como as que mostrei durante este video.






Como falei antes, são vários motivos, custo-benefício sendo o principal. No geral o maior problema é que é muito difícil formar bons programadores que consigam tirar vantagem dessas tecnologias. O custo-benefício não compensa. Não significa que essas linguagens não tem chance, significa que esse mercado sempre vai ser de nicho. Mas pra quem tem o talento e a capacidade, é um nicho que paga muito melhor. É só ser bom.







Enfim, hoje eu só quis resumir minha saga de como explorei 16 linguagens, claro que superficialmente, em 16 dias. Não deu pra detalhar cada truque, mas deixamos tudo anotado, e no próximo video vou explicar o truque por trás da mágica: como tudo isso funciona, por que funciona e, mais importante, quando usar e quando não usar. Se ficaram com dúvidas mande nos comentários abaixo, se curtiram o video deixem um joinha, assinem o canal e não deixem de compartilhar o video com seus amigos. A gente se vê, até mais!
