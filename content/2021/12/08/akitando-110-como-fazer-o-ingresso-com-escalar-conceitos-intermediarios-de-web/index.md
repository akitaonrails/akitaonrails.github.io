---
title: "[Akitando] #110 - Como fazer o Ingresso.com escalar? | Conceitos Intermediários
  de Web"
date: '2021-12-08T11:33:00-03:00'
slug: akitando-110-como-fazer-o-ingresso-com-escalar-conceitos-intermediarios-de-web
tags:
- ingresso
- homem-aranha
- cinema
- escalabilidade
- jobs
- async/await
- waiting room
- cdn
- caching
- akitando
draft: false
---

{{< youtube id="0TMr8rsmU-k" >}}

## DESCRIÇÃO

Por que sites como Ingresso.com baleiaram nas vendas da pré-estréia do Homem Aranha? Hoje finalmente vou responder com técnicas de verdade como se faz pra suportar sites de grandes volumes de acessos e transações.


Vou aproveitar pra explicar rapidamente como cursos e tutoriais levam iniciantes a uma versão correta mas não-escalável, e vou explicar 3 grandes técnicas que sistemas de alta escalabilidade realmente usam no mundo real. Em particular vamos tentar imaginar qual seria a solução pra resolver o problema de escolha de assentos, que é o principal ofensor num site de venda de ingressos.

DISCLAIMER: o autor não tem nada contra o Ingresso.com e este video não é uma tentativa de denegrí-los, meramente usar de exemplo educativo por ser um dos maiores de seu mercado.

## Conteúdo:

* 00:00 - Introdução - Homem Aranha
* 02:02 - Entendendo o ingresso.com
* 04:13 - POS de Cinemas - sistemas porcaria
* 05:21 - Final do Checkout
* 05:43 - Site feito por Iniciantes 1
* 08:18 - Minha definição de "Iniciante"
* 09:00 - Site feito por Iniciantes 2
* 09:58 - Raio X rápido de apps Web
* 12:20 - Tempo hipotético de uma Requisição
* 13:36 - DDoS do Aranha
* 17:45 - 1a técnica: CDNs
* 19:24 - 2a técnica: Caching
* 24:43 - 3a técnica: Jobs em Background
* 28:26 - memória compartilhada
* 30:41 - async/await vs jobs
* 33:51 - O Ofensor: Escolha de Assentos
* 34:57 - Sala de Espera
* 39:57 - Resumo da Solução
* 44:39 - Não faça o que eu falei!
* 45:19 - Otimização sem Métrica: Perda de tempo
* 46:37 - Otimização sem Testes: Tortura
* 47:35 - Conclusão

## Links:

* Thread no Twitter: https://twitter.com/AkitaOnRails/status/1465390018961289217?s=20
* Build a Virtual Waiting Room with Amazon DynamoDB and AWS Lambda at SeatGeek: Build a Virtual Waiting Room with Amazon DynamoDB and AWS Lambda at SeatGeek | AWS Architecture Blog

## SCRIPT

Olá pessoal, Fabio Akita



Alguns dias atrás eu fiquei putaço tentando comprar meus ingressos pro novo filme do Spiderman. Se você tá assistindo esse video muito no futuro, em 29 de Novembro de 2021 os sites de venda de ingresso abriram pra vender ingressos no mundo todo e todos os sites ficaram de joelho frente à demanda de gente querendo comprar. O filme vai estrear dia 16 de Dezembro e o hype ao redor dele é quase comparável ao que foi Avengers Endgame, é absurdo. Se o filme entregar metade do hype, já vai ser épico.






Agora, o que não foi épico, foi como os sites de vendas de ingresso se comportaram, especialmente nas primeiras horas. Se você tentou comprar naquele dia, sabe do que estou falando. Foi horroroso, foi tenebroso. Como sempre, sites de ingressos continuam sendo uma grande merda. Vamos colocar em contexto. Um site como o ingresso.com existe faz mais de década. Não lembro quando lançou de fato, mas o domínio foi registrado no ano 2000. Não é um site novo.






É possível que eu esteja sendo mais arrogante que o normal aqui por causa da experiência frustrante que foi ficar 1 hora tentando comprar sem sucesso, enquanto sala após sala ia ficando cheia e o site continuava me dizendo "verifique sua conexão com a internet", tipo, mensagem de erro genérica do tempo de internet discada. Vai se fuder.






Então vou aproveitar o calor do assunto pra explicar porque eu acho que o site tem tantos problemas em eventos como esse, como um iniciante faria um site desses e como uma empresa desse tamanho e dessa idade já deveria estar em termos de arquitetura em 2021. Hoje o episódio vai ser bem mais prático mas ao mesmo tempo não vou mostrar código particular de nenhuma linguagem, vou explicar conceitos que servem pra todas as linguagens em projetos de verdade. Já aviso desde agora que o episódio de hoje vai ser super denso. Dava pra picotar esse video em meia dúzia, mas preferi falar tudo de uma só vez. Então preparem o bloco de notas e vamos lá.








(...)








Vamos começar do começo. Um site como um ingresso.com é basicamente um e-commerce. O produto do site são assentos em salas de cinema. O estoque é limitado, existem somente uma quantidade X de assentos pra cada filme, em cada sala, em um determinado horário. Uma vez que encheu a sala naquele horário, não tem mais o que vender. Não é muito diferente em conceito a um site de venda de assentos pra vôos, como um decolar.com por exemplo.





Se você é iniciante, provavelmente consegue delinear os principais elementos. Certamente começaria criando tabelas pra cadastrar cada rede de cinema, depois cadastrar cada sala em cada cidade. Daí em cada sala iria registrar cada assento com cada código independente. A sala provavelmente teria uma imagem com o mapa dos assentos. Depois faria o cadastro de cada novo filme, filmes ativos agora, filmes em pré-estréia, daí associar filmes com salas. A página principal é só uma listagem desses filmes, com categorias ou tags como "Em Alta", "Em Cartaz", "Em Breve". Coisas secundárias seriam festivais, promoções e coisas assim que iriam pra outras tabelas, mas de qualquer forma a página principal ia puxar tudo isso dessas tabelas.






Daí quando escolhe um filme, cai na página separada desse filme. Ele vai puxar as salas associadas com esse filme, as datas em que cada sala vai ter o filme disponível. Você deixa o usuário escolher o tipo de sala que quer como IMAX ou VIP, qual dia que quer assistir, e embaixo vai filtrando a lista de salas. Cada sala tem uma tabela que associa o filme e os diferentes horários disponíveis nesse dia. Aliás, não tente levar ao pé da letra o que estou falando, só estou listando de cabeça. Se você procurar 5 minutos no Google provavelmente vai achar vários tutoriais dando exemplo de como criar tabelas pra um site de ingressos desse tipo.







Agora vem a parte chata. Uma vez escolhido o horário, quando clica em comprar, ele entra num processo de checkout dividido em 3 partes. A primeira parte é finalmente escolher o produto: o assento exato na sala, horário e dia escolhido. Pra fazer isso eu chuto que o site precisa sair da infraestrutura dele pra acessar um sistema de terceiros que realmente gerencia os assentos da sala, que imagino que é proprietário de cada rede de cinema. Porque precisa ser o mesmo sistema que é usado na frente de caixa quando alguém vai comprar o ingresso pessoalmente direto no cinema.







Se não for o mesmo sistema, o site poderia acabar vendendo um assento online que já tinha sido comprado direto no cinema por outra pessoa e aí dá um monte de problemas. Portanto, temos que assumir que sites como o ingresso.com precisam integrar com esses sistemas, que provavelmente devem ter tecnologia da idade das pedras, lentos pra caramba, totalmente instáveis e mau feitos, relíquias do começo dos anos 2000 ainda usando tecnologias dos anos 90. Pra simplificar imagine que o ingresso.com tem um cadastro de endereços IP de um servidor de cinema, com uma API com funções simples como listar assentos num horário e função pra reservar um assento temporariamente e outro pra reservar um assento permanentemente.







Precisa ter uma reserva temporária, que parece que é de uns 2 minutos, porque online o assento ainda não foi pago. Então você segura a escolha do assento até confirmar o pagamento nas etapas seguintes. Uma vez que o usuário escolheu o assento, agora ele precisa escolher se é ingresso inteira, se é meia - que é outra relíquia que não faz sentido existir. Enfim, daí fazer upselling de coisas como pipoca, refrigerante e o que mais der pra enfiar goela abaixo praquela compra de impulso de última hora.







Finalizado essa segunda etapa, finalmente chegamos na hora de pagar. Agora é escolher o tipo de pagamento que pode ser cartão de crédito direto, ou integrando com meios de pagamento como Google Pay, Apple Pay e assim por diante. Confirmado o pagamento, o site envia a confirmação pra reservar o assento permanentemente, envia o ingresso digital pro e-mail do usuário e todo mundo fica feliz.







Um site feito por um iniciante, sozinho ou seguindo algum tutorial ou curso, teria um banco de dados como um MySQL da vida, com tabelas como eu falei antes: tabela de salas com informações como a cidade, estado, endereço, tipo de sala. Daí uma tabela de filmes, com informações como data de estréia, data de pré-estréia, caminho pras imagens como cartaz. Agora teria uma tabela many-to-many que associa a sala com o filme, chamada horário, por exemplo. E assim por diante.






Daí teria um tabela chamada carrinho ou shopping cart, que associa um usuário com uma escolha de sala, filme, horário e o que voltar da API do cinema com informações do assento, items de upselling como pipoca, tipo de pagamento e um estado que indica se ainda está pendente de pagamento, aguardando confirmação e confirmado ou rejeitado.







O iniciante usaria um framework web comum como Django de Python, Laravel de PHP, Rails de Ruby, Express de Javascript ou algo maior como Spring de Java. Na prática, não importa qual você escolher. Os problemas que eu sofri dia 29 de Novembro tentando comprar Homem Aranha não teriam sido mitigados pela escolha de framework nem de linguagem, então literalmente tanto faz qual você escolher. Eu vou explicar porque já já.






Independente do framework, você começaria criando controllers e views, ou páginas como homepage, página de cada filme, página pra escolha de assento, página pra escolha de pipoca e refrigente, página pra escolher tipo de pagamento, página de confirmação pro ingresso. E claro, tô de propósito pulando um monte de outros itens como página de cadastro, login, recuperar senha, mas a essa altura qualquer framework decente já tem dezenas de bibliotecas pra fazer esses itens em questão de minutos. Se você leva dias pra fazer míseras páginas de cadastro de usuário e login, você é um enorme incompetente que precisa aprender a usar o Google. E eu não tô exagerando. Toda vez que eu vejo um projeto que a página de recuperar senha não funciona, eu já sei que foi feito por um completo amador.









De qualquer forma, o projeto seria feito num frameworks desses, todos os elementos num mesmo projeto, conectando num mesmo banco de dados único. Os elementos de deployment seriam um servidor web como NGINX, o banco de dados MySQL ou Postgres da vida, um diretório com o código fonte do projeto, seja em Javascript, Python ou PHP da vida. Normalmente instalado tudo junto num único servidor e pronto. Acabou. Se você se considera um iniciante em programação web, deve ser capaz de fazer uma versão miniatura de um ingresso.com em questão de poucos dias e todos vão chegar nesse mesmo tipo de projeto. Se tem um curso ou tutorial que implementa um site de venda de ingressos, eles vão parar por aqui também.








Aqui eu faço uma tangente. Eu vi alguns gatos pingados reclamando do meu video de Conhecimento Básico pra Iniciantes dizendo que o que eu listei naquele video é coisa demais pra um iniciante. E eles tem razão. Todo mundo parece que considera iniciante como uma pessoa que não sabe nada e vai começar do zero. Não tá errado, mas eu considero "iniciante", todo mundo que já tem conhecimento suficiente pra entrar no mercado de trabalho, ou seja, sabe o mínimo pra não ser um mala sem alça, um peso morto. Sempre que eu falar iniciante é isso: alguém que já minimamente sabe programar. E sim, pra mim um iniciante deve ser capaz de codificar o que eu acabei de explicar aqui em aproximadamente 1 ou 2 semanas. Não mais que isso.








Um iniciante que não consegue fazer uma versão miniatura do ingresso.com ainda não é iniciante, é um hobista, ou um estudante. A versão que todos vocês vão conseguir fazer vai funcionar pra ir pro ar, suportar algumas dezenas ou com sorte, até centenas de usuários. Mas nunca, jamais, nem de perto conseguiria suportar a pré-estréia do Homem Aranha ou um evento nível Avengers Endgame. Jamais. Eu já disse isso várias vezes antes e vou repetir: a grande maioria dos cursos é feita pra ser simples, didática, e fazer você achar que aprendeu algo útil. Mas eles não ensinam o que vou explicar a partir de agora, simplesmente porque a maioria das pessoas que escrevem esses tutoriais nunca trabalharam em sistemas grandes. E isso faz uma diferença enorme.







Mas não tem nenhum problema. Ninguém em sã consciência usaria o código de um iniciante pra um evento desses. Ou pelo menos não deveria. Agora é hora de eu explicar qual é a diferença de um e-commerce feito por um iniciante e um feito por um sênior com experiência de verdade. Vamos começar do começo.








Tudo que um usuário fizer no seu site, listar filmes, procurar salas, comprar pipoca, serão requisições HTTP pra um servidor web, como um NGINX. Esse servidor vai pegar a URL e mandar pra sua aplicação feita em Django ou Express da vida, via proxy reverso. Se você não sabe o que é NGINX ou proxy reverso, vai colocando no seu bloquinho de anotações pra estudar depois. Todo framework vai pegar essa URL, as informações que vieram no cabeçalho HTTP como cookies, a informação de sessão pra saber se é um usuário logado ou um não-logado, passar pra algum tipo de processamento de rota e enviar as informações da requisição pra uma classe de controlador, pra chamar uma função como `index` de uma classe FilmeController, por exemplo, que vai listar todos os filmes.








Esse controlador vai precisar da ajuda de outras classes como repositórios ou modelos, que no fim mapeiam pras tabelas no seu banco de dados. Talvez tenha um modelo chamado Filme, que vai fazer uma pesquisa SQL no banco de dados MySQL. Agora o MySQL precisa processar a pesquisa, e enquanto faz isso, desde a ponta do navegador do usuário, passando pelo NGINX, passando pelo processo do seu framework, tá tudo bloqueado, esperando o MySQL retornar. Isso é muito importante de entender, que tudo fica pendurado esperando o próximo passo terminar.






Quando o MySQL retornar o resultado da pesquisa, agora o modelo vai processar essa informação e transformar numa lista de objetos, e entenda que isso mais que duplica a memória do resultado porque você tem a informação crua que voltou do banco e a transformação disso em objetos, que ocupa mais que o dobro de memória por conter diversos metadados como conversão de dados e tudo mais. Agora essa lista de objetos passa pra processamento de alguma classe de visualização que vai pegar esses objetos, um template de Django, um template Blade de Laravel, enfim um template de HTML que tem espaços em branco pra serem preenchidos pelos objetos que voltaram do MySQL.






Quando o HTML final for gerado, agora o framework devolve isso pro NGINX, que vai devolver pro navegador do usuário que estava esperando até agora. E finalmente o navegador desenha a página na tela pro usuário poder continuar. Do momento que o usuário digitou a URL até receber a página de volta, digamos que demorou 100 milissegundos, que não é muito ruim. Parte desses milissegundos depende mesmo da conexão de internet do usuário que é o caminho do navegador até o servidor. Digamos que foi 10 milissegundos.






Uma vez no servidor, daí tem o tempo do NGINX processar e mandar pra sua aplicação, e isso costuma ser muito rápido, digamos 5 milissegundos. Agora o framework precisa processar a sessão, a rota, carregar o controlador e tudo mais, digamos que isso leve 20 milissegundos. Daí chega na parte que conecta no servidor MySQL e precisa esperar o SQL processar a pesquisa, e isso vai ser mais uns 30 milissegundos. Finalmente, com os dados e o template em mãos, precisa gerar o HTML final, e digamos que isso leve 25 milissegundos. E com isso, os 10 milissegundos restantes é pra devolver o HTML pro navegador.







No geral, a gente fala que a escolha do framework não importa tanto porque dos 100 milissegundos totais nessa requisição de exemplo, você só vai impactar 2/3 do tempo se trocar. O resto do tempo é rede e conexão com serviços externos como o MySQL. 1/3 do tempo foi no banco de dados e isso não vai mudar só escolhendo um framework diferente. Ah sim, daí o iniciante vai logo mandar um "ah, é só trocar o MySQL por MongoDB". Não sua anta. Não faça isso. Agora você escolheu girar um parafuso com um martelo. Num parafuso pequeno parece que funciona porque você bate com o martelo e na força bruta ele entra na madeira, mas isso Não vai continuar funcionando assim por muito tempo. Vou mencionar NoSQL mais pra frente.









Agora, imagine a situação do evento do Homem Aranha nesse site de iniciante. Em questão de segundos seu site estaria efetivamente sofrendo o equivalente a um ataque de Denial of Service. Imagine o seguinte cenário: deu meio dia, todo mundo do Brasil inteiro digita `ingresso.com` nos navegadores pra abrir a homepage do site. Pronto, ninguém vai conseguir. Seu servidor não vai aguentar e vai abrir o bico.







Eu estou usando números hipotéticos neste episódio inteiro porque dependendo de como você programar, em que tipo de servidor instalar e tudo mais, os números variam. Não existe um número absoluto igual pra todo mundo. Mas digamos que, no mínimo, a requisição pra montar a homepage leve esses 100 milissegundos, como expliquei. Agora digamos que você instalou num servidor baratinho de 8 cores que conseguiria processar 600 requisições por segundo. É até bastante coisa. Mas na realidade é menos que isso, porque seu servidor de banco de dados tem um limite de umas 100 conexões de cada vezes. Então vai ser menos de 600 requisições por segundo, porque algumas requisições precisam esperar outras terminarem de pesquisar no banco antes de pode prosseguir, então digamos que isso vai cair pra uns 400 por segundo. Vocês tem que ter em mente que tudo tem limites, velocidade teórica não é a mesma coisa que velocidade na prática.







Mas pra atingir esse pico, precisa de menos de 400 usuários por segundo. Especialmente quando o mesmo usuário tentar abrir vários navegadores e ficar apertando F5 o tempo todo pra carregar. O que acontece no servidor? Até chegar no NGINX não costuma ter problema, o NGINX não precisa processar quase nada, é muito rápido e consegue aguentar milhares de requisições por segundo nessa máquina. O problema é quando atingir sua aplicação.







Sua aplicação talvez consiga ir um pouco acima de 400 requisições por segundo, mas o banco de dados não consegue, não só pelo limite de conexões, mas porque pesquisas custam tempo de processamento. Toda requisição que não conseguir ser atendida porque a CPU já tá em 100% vai começar a entrar numa fila do NGINX. Mas a fila também não é infinita. E como tá tudo na mesma máquina, chega uma hora que o NGINX, sua aplicação e o banco de dados vão estar brigando por tempo de CPU e por memória, que já tá no máximo, e todos vão começar a ficar lentos até chegar num ponto onde o gerenciador de memória do sistema operacional vai chegar num pico. A memória vai acabar e um deles vai crashear. E quando o banco ou sua aplicação crashear, daí toda requisição que tava na fila vai receber uma mensagem de erro 500 de volta.








Daí sua aplicação reinicia, mas aí todo mundo que tava na fila esperando, recebeu mensagem de erro, vai todo mundo tentar dar reload no navegador, em segundos sua fila vai encher de novo, sua aplicação vai crashear de novo, e vai ficar nesse loop infinito de crash até que uma boa parte das pessoas comece a desistir e vai diminuindo a quantidade de requisições até o limite onde o servidor começa a conseguir responder pra algumas pessoas. Entenda, as pessoas vão fazer uma de duas coisas: ou esperar até conseguir comprar ou esperar até a frustração não valer mais a pena. Do jeito que sua aplicação foi feita, você vai forçar a grande maioria das pessoas a desistir por frustração.







De novo, não tem nada de errado nisso. É nível iniciante, ninguém espera usar sua aplicação pra um evento desses. Mas é um aviso pra quem contrata juniors pra fazer aplicação nível avançado mas não entende a diferença e acha que pode pagar barato pra ter o mesmo resultado. E não, a culpa não é do iniciante. Um hospital não colocaria um residente pra fazer um transplante de coração. Se colocar e o paciente morrer, a culpa não é do residente, é do hospital que obrigou ele a fazer um procedimento que não era qualificado pra fazer. Mas o ingresso.com de verdade pelo menos não tá no nível totalmente iniciante. Quando eu tava tentando comprar, um comportamento era bem óbvio: o site não baleiava na homepage. Se você tentou comprar naquele dia também, vai lembrar que a página principal e a página do filme carregavam até que rápido, sem nenhum problema.








Existem algumas razões pra isso. Você poderia ter uma aplicação web separada pra páginas de conteúdo e outra aplicação só pra fase de checkout, que são as 3 etapas que eu falei de escolher assento, escolher tipo de ingresso e fazer o pagamento. Sendo aplicações separadas, você tem mais oportunidade de escalar a aplicação de conteúdo que é mais leve e tomar porrada numa infra separada pro checkout. 






Mas eu acho que a solução é mais simples do que isso. Pra começar, ele não roda a aplicação web junto com o NGINX e junto com o banco de dados, no mínimo cada um deles está em servidores físicos separados. Em segundo lugar, provavelmente usa CDNs pra cachear assets e conteúdo estático. Veja o código fonte da página inicial do ingresso.com. Todo lugar que precisa carregar coisas como stylesheets de CSS, scripts javascript, imagens e tudo mais, ele não puxa do domínio ingresso.com e sim do domínio ingresso-a.akamaihd.net. A Akamai, assim como uma AWS Cloudfront, Google Cloud CDN ou Azure CDN, é um Content Delivery Network.







Serviços de CDN tem servidores espelhos espalhados por diversas regiões no mundo. Quando você faz deploy da sua aplicação, também faz upload de todos os assets da sua aplicação pro CDN. Daí o CDN vai começar a espelhar, ou seja, copiar esses assets, ou arquivos, pra dezenas de outros servidores no mundo todo. Quando o usuário tenta abrir a homepage, uma das coisas mais pesadas é baixar todos esses arquivos javascript, imagens, CSS, mas ele não vai bater no seu servidor de aplicação, vai bater nos servidores de CDN mais próximos.






Só de fazer isso, uma porção considerável do peso do seu site é deslocado pra outros servidores e não vai pesar na sua aplicação. Todo framework web que se preza tem suporte a CDNs, de tal forma que na sua máquina de desenvolvimento ele vai puxar javascript, CSS e imagens direto da sua máquina e só em produção vai automaticamente fazer upload do que precisa e converter os templates de HTML pra escrever o domínio do servidor de CDN, como o ingresso.com faz com a Akamai.







Mas não é só isso. Se o ingresso.com estivesse feito da forma ingênua como expliquei, ela não ia conseguir abrir a homepage mesmo com CDNs. Um dos problemas é ter que ir no banco de dados. Toda vez que um processo web faz isso, ela fica bloqueada, esperando o serviço externo retornar. Vai ficando um monte de processos esperando, e se tiver muitos, uma hora vai estourar. Normalmente costuma ter uma configuração de timeout. Ou seja, a aplicação web espera o MySQL retornar ou, se chegar num tempo limite, pára de esperar, corta a conexão e devolve erro 500 pro usuário.






Eu falei que no nosso exemplo, o MySQL demora uns 30 milissegundos pra devolver. Eu posso colocar um timeout de meio segundo. Mas aí aquele monte de gente conectando tentar abrir trocentas conexões pro banco, e todo mundo pendurado por pelo menos meio segundo, enquanto o MySQL tá sofrendo pra conseguir devolver uma resposta, porque não tem CPU sobrando na máquina pra processar tanto SQL. E o banco tem limite de conexões. O NGINX tem limite na fila. Ambos tem timeouts, e vai ser uma cascata de timeout com um tráfego do nível da audiência do Homem Aranha. A grande maioria vai tomar erro 500, que no caso do ingresso.com ele devolve aquela mensagem tosca de “verifique sua conexão com a internet”, que não tem nada a ver.






Existem várias coisas que podem mitigar isso, por exemplo, garantir que suas tabelas tenham índices corretos pra cada tipo de pesquisa. Índices são como tabelas extras pré-compiladas. Quanto mais índices você botar numa tabela, mais rápido vai ser determinadas pesquisas, mas mais lento vai ser pra inserir ou excluir uma linha nessa tabela, porque precisa também atualizar os índices. Então você corta tempo de pesquisa pra aumentar tempo de inserção. Mas como num site como esse você tem um volume muito maior de pesquisas do que de inserções, sempre é uma boa prática colocar índices corretos. A única pessoa que sentiria alguma lentidão extra, se existir, seria o administrador pra cadastrar novos filmes e novas salas, e isso é uma atividade que ele precisa fazer só uma vez por semana, se muito. Mas só adicionar índices vai ajudar mas não vai resolver nosso problema.









A homepage, durante um dia inteiro, é igual o tempo todo, pra todo mundo. Se você carregar a página ao meio dia, que é quando o filme do Homem Aranha ficou ativo, até a meia noite do mesmo dia, eu tenho certeza que nada mudou. Aliás, se a página é sempre igual mesmo se for num período super curto de 5 minutos, tá excelente, porque se você tá tendo 10.000 requisições por minuto, quer dizer que por 5 minutos você só precisa gastar o tempo de processar o HTML da homepage uma vez e servir a mesma página pra todas as 50 mil requisições durante esses 5 minutos. É uma economia monumental.







Isso é o comum na grande maioria de sites de conteúdo, incluindo e-commerces, onde é raro produtos mudarem com muita frequência. O que pode mudar são informações secundárias, como disponibilidade ou estoque do produto. Por exemplo, a página do filme talvez tenha a mesma listagem de salas, mas à medida que as salas forem ficando cheias, precisa desabilitar da tela a opção de conseguir escolher assentos nela. Mas a listagem das salas em si é a mesma. Só se um administrador esqueceu de adicionar uma sala, e cadastra de última hora, que vai mudar alguma coisa. Mas no geral, a página é a mesma.








E de novo, todo framework web que se preza suporta configuração de cache. Eu posso simplesmente dizer que a página de índice do FilmeController, depois que gerar o HTML da primeira vez, na próxima requisição em diante, por 5 minutos, não processa mais nada. Por um período de 5 minutos, ele vai devolver o HTML direto de um cache. Um cache seria basicamente o HTML que foi gerado gravado como um arquivo estático no sistema de arquivos ou guardado em memória mesmo.








Lembram dos tempos que eu falei? A requisição total levou 100 millissegundos no nosso exemplo. 10 millissegundos na entrada e 10 millissegundos na saída foram só o tempo de internet mesmo. 5 milissegundos foi o NGINX. Todo o resto foi a aplicação web conectando no banco, esperando processar a pesquisa, montando o HTML final com os templates. Se cachear o HTML final significa que podemos eliminar esse tempo todo. Vamos cortar os 30 milissegundos da pesquisa no banco e 25 segundos pra montar o HTML. Digamos que achar o cache e devolver ele leve só 10 millissegundos. 







Então dos 100 milissegundos originais, os próximos usuário vão esperar só 35 milissegundos pra receber a página. Ou seja, sem mudar framework, sem mudar linguagem, sem mudar banco, dá pra reduzir quase 60% do tempo original. Por isso eu falo que todo mundo que sugere mudar de linguagem ou banco como primeira opção é certamente um iniciante. Porque você consegue diminuir bastante o tempo de resposta só sabendo usar um recurso que seu framework provavelmente já tem e você que não sabe como usar, que é habilitar e configurar o cache.










Gerenciar cache é uma técnica média, nem iniciante e nem avançado. Se você já tentou e ficou preocupado em apagar cache antigo, tá fazendo errado. Cache tem time to live ou TTL, você diz pra durar 5 min, durante esse período devolve o que tá cacheado e quando expirar, daí passa pelos controladores, modelos, views e tudo mais de novo pra renderizar o novo HTML e cachear de novo. E cache é quem faz a maior diferença numa aplicação web. Você pode cachear uma página inteira, só componentes dentro dessa página. Vale a pena aprender os detalhes das diferentes estratégias de cache como entender o que é o status 304 Not Modified do protocolo HTTP cuja estratégia implementada nos frameworks se chama Conditional HTTP Caching.









Vou pular da página principal pra última ponta do checkout que é o pagamento, ainda tem outra coisa que é importante explicar antes de continuar. Na ponta de pagamento tem gente que faz errado e atrela a página de confirmação de pagamento com o pagamento em si. Isso é comum quando você não usa um serviço de pagamento como Stripe, PagSeguro, Paypal ou semelhante, ou seja, quando você precisa integrar manualmente com um integrador de cartão de crédito, por exemplo. Acho que hoje em dia isso não é mais tão comum porque um MercadoPago da vida é bem mais simples de integrar, por outro lado costumam cobrar taxas maiores, daí depende do seu modelo de negócios.







O modelo de pedido ou ordem de compra costuma ser implementado como uma máquina de estado. Ele inicia com um estado como “pendente de pagamento”, daí tem o pagamento em si que transiciona o modelo pra “pendente de confirmação”, daí espera o integrador de pagamento responder, e transiciona pra “confirmado e pendende de entrega” - caso seja um e-commerce de produtos - ou então transiciona pra “rejeitado”, e registra o motivo dado como número de cartão inválido. Dali pode transicionar de volta pra pendente de pagamento, por exemplo. Se você nunca ouviu falar de máquinas de estado, estude sobre isso. É conhecimento básico.








De qualquer forma, se você fizer do jeito ingênuo, vai fazer um controlador ou uma página que recebe os dados de cartão de crédito, daí vai chamar a API do serviço de forma síncrona, ficar esperando a resposta - que você não tem controle porque é um serviço externo. E aí corre o risco dele demorar, dar timeout e estourar o tempo do servidor web, e ter que devolver um erro 500 e ficar com o pedido num estado inconsistente, com ainda pendente, sem saber se o serviço de pagamento foi até o fim ou não. Daí normalmente vai acabar contratando um monte de gente de suporte pra ficar conciliando os pedidos manualmente.







A mesma coisa vale pra atividades pesadas num banco de dados, onde você manda um SQL pesado, fica esperando, dá timeout e não sabe se foi até o fim ou não. Quando você tá sozinho na sua máquina, codando, isso não faz diferença, porque você tem poucos dados, só tem você acessando, então raramente vai cair numa situação que dá timeout e quebra seu fluxo. Mas em produção é o que mais vai ter: com dezenas de usuários simultâneos todos concorrendo pra usar um recurso escasso que são serviços externos como banco de dados ou pagamentos ou qualquer outro serviço de terceiros.







Por isso você deve entender máquinas de estado e entender o que é processamento assíncrono. Alguns devem pensar, “ah eu sei o que é isso, eu sou de Javascript ou C# ou Go ou alguma linguagem que suporta o pattern de async/await”. É só chamar a função demorada com async, daí o processo fica livre pra fazer outra coisa, e quando o serviço retornar, vai voltar no await e continua dali. Quem é de Go vai falar a mesma coisa, só soltar um gofunc. Quem for de Elixir vai falar, ah só soltar um Task async. E assim por diante.








E tá errado. A menos que seja um processamento que se você perder não faça diferença, não faça desse jeito pra tudo. Você precisa ter uma solução separada de controle de fila. Num serviço de fila você vai fazer o seguinte: vai jogar numa tabela no banco chamado Fila ou Jobs, o próximo trabalho, ou Job como chamamos. E vai deixar um outro processo separado, que chamamos de Worker, puxar esse próximo Job da fila e processar separado.








Num framework como Rails temos embutido essa funcionalidade num ActiveJob. Num Node.js temos bibliotecas como o Bull que faz a mesma coisa. Num Django temos o Celery. Em Spring Boot de Java podemos usar o Rqueue. O Laravel já vem com um serviço chamado Queues. Hoje em dia a arquitetura básica é mais ou menos a mesma. Eu falei colocar o job numa tabela no banco, mas na realidade a maioria grava o job no Redis. Se você ainda não estudou sobre Redis, deveria, é o único NoSQL que de fato a maioria dos projetos acaba usando na prática.








Eu falei rapidamente de Redis no episódio sobre NoSQL. Mas pense num Redis como um banco de dados em memória que tem a opção de persistir os dados em storage. Dessa forma se ele crashear, não perde os dados como um Memcached. Memcached e Redis funcionam mais ou menos como uma memória compartilhada. Se você é iniciante esse conceito pode parecer estranho, mas isso é porque você tá acostumado a rodar tudo na mesma máquina, daí não enxerga a necessidade de um serviço pra memória compartilhada.







Mas pense agora em produção, onde sua aplicação web pode estar rodando em vários servidores em paralelo, embaixo de um load balancer como o próprio NGINX. O usuário começa a requisição batendo no servidor A, mas à medida que vai navegando, vai bater no servidor C, depois no E, daí volta pro A. E tem que ser tudo transparente, o estado que ele tinha no servidor A tem que ser o mesmo no servidor C. Parte disso é resolvido porque a aplicação vai baixar dados do mesmo banco de dados. Mas parte é porque vai ter coisas num Memcached ou Redis, uma memória compartilhada que todos esses servidores acessam ao mesmo tempo, em particular nossa fila de Jobs.







O Redis ainda tem outra funcionalidade, que chamamos de PubSub ou publisher e subscriber. Quando cadastramos o tal Job no Redis, estamos publicando. E do outro lado pode ter processos em background, os nossos workers que mencionei antes, assinando ou subscrevendo um canal. Quando um novo job é publicado o worker que tá assinando é notificado, daí puxa o job e começa a processar em background.







Então o fluxo é assim: você tem uma operação custosa pra fazer, onde seu processo vai ter que cruzar os braços e ficar esperando e arriscando bater timeout e estourar. Então ele publica o Job numa fila, como num Redis, e vai fazer outra coisa. Daí um processo separado, provavelmente em outro servidor separado, vai puxar esse Job e processar, e nesse worker ele pode levar muito mais tempo porque não tem uma página web ou um usuário esperando pendurado. Mesmo se o worker crashear ou der timeout por algum motivo, você tem o registro do Job na fila que é persistida e pode mandar outro worker reiniciar o Job. A maioria dos sistemas de fila dos frameworks tem telas de admin pra você poder manualmente monitorar as diversas filas. Assim mesmo se tudo crashear, você não perde a informação na fila.







E porque eu não posso só soltar um async/await, que vai ser mais ou menos a mesma coisa só que sem a complexidade de um Redis e workers separados? Simples: porque um servidor web tem que estar preparado pra morrer a qualquer momento. Esse é outro conceito que você precisa ter em mente: servidores web devem poder ser derrubados e reiniciados a qualquer momento. Você não deve gravar arquivos localmente num servidor web e nem confiar em deixar coisas importantes na memória RAM. Esse é o conceito de “shared nothing” ou nada compartilhado, que você precisa aprender o quanto antes. A maioria dos problemas de escalabilidade acontecem quando você não sabe disso.








Se precisa gravar arquivos, você vai jogar num serviço externo, como um AWS S3. Que qualquer um dos seus servidores vai conseguir acessar. No mínimo vai gravar num diretório compartilhado na rede. E se precisar deixar coisas em memória, não vai deixar na RAM, vai deixar ou num serviço separado de Memcached ou Redis ou direto no banco de dados, que vai ser bem mais lento. Mas o conceito é que se o servidor web crashear, quando voltar e o usuário bater nele, vai carregar tudo normalmente, sem corromper nada. 






Se você soltar dezenas de async nesse servidor e ele crashear, perdeu esses asyncs todos e nunca vai voltar o await. Agora os dados podem ter ficado num estado corrompido. O pedido ficou em estado de pendente e você não tem como saber quem foi confirmado, quem foi rejeitado, e aí como que vai fazer agora? Por isso você mantem jobs como de pagamentos numa fila como no Redis. Mesmo se seu servidor web crashear, os workers não tão nem aí. Eles vão continuar processando e atualizando o estado dos pedidos normalmente. Quando o servidor web reiniciar, ele checa o estado atual do pedido e vai estar correto, porque a fila manteve as informações consistentes.









O que eu acabei de falar deve ter deixado pelo menos metade de vocês meio confusos. Lembram o que eu falei mais no começo? A maioria dos cursos e tutoriais que você acha por aí vai fazer uma aplicação web num framework qualquer, daí vai ensinar e instalar tudo junto num servidor como num Linode ou DigitalOcean da vida. E na sua cabeça tudo fica de pé 100% do tempo, e crashear é uma coisa rara. Quando só tem um usuário testando, você raramente vai enxergar gargalos e falta de recursos, por isso que “na sua máquina tudo funciona”.








Mas na verdade em produção de alta escala de verdade, servidores como de banco de dados, Redis e outros serviços tendem a ser mais parrudos e estáveis, e seus containers de web tem que ser voláteis e permitir crashear a qualquer momento. Novos containers web podem aparecer se precisar escalar pra aguentar mais gente. E quando o tráfego for caindo, eu preciso poder derrubar containers web a qualquer momento pra diminuir os custos. Isso que chamamos de servidores elásticos ou Elastic Compute Cloud como a Amazon costuma chamar seus EC2.







Entendam esse conceito: você deve programar sua aplicação web pra poder ser derrubado a qualquer momento. Por isso tudo que depende de estado local, seja em disco, seja na memória, como async/await, deve ser evitado, ou usado muito pouco em situações específicas e nunca em qualquer lugar sem pensar nas consequências. Você nunca deve sair por aí criando centenas de asyncs locais sem controle nenhum. Sempre pense no que pode acontecer num crash e como você recupera o estado das coisas.







Mas agora chegamos ao principal ofensor do ingresso.com, a escolha de assentos que precisa conectar com o tal serviço bosta proprietário de cada cinema. Esse serviço não temos nenhum controle e podemos assumir que é um grande lixo. Digamos que, se muito, ele aguenta uns 10 usuários simultâneos tentando escolher assentos. Se tiver 1000 usuário de uma vez, 990 vão ficar na fila, vai dar timeout porque escolher assentos pode levar de vários segundos a minutos, e todo mundo vai ficar dando reload na página e isso só vai estendendo a fila até ninguém conseguir fazer nada a não ser desistir e tentar mais tarde.








Como você faria pra resolver isso? E aqui, de novo, não adianta vir com solução fácil como trocar de framework ou trocar de linguagem. É independente, porque o serviço externo não tem como reescrever, e você não tem controle. Quando eu tweetei a solução, falei o seguinte: o serviço externo (estou assumindo) de escolher assento deve ser o pior ofensor e não dá pra escalar. Pra isso deveria haver uma fila, onde cada um que entra por ordem de chegada ganha um ID e espera. Daí vai liberando em batches pra não engargalar a escolha de assentos.








Depois que fiz esse tweet alguém me mandou uma DM com um artigo do blog da AWS. Tem gente que fica me perguntando onde procurar novidades, e assinar os diversos blogs das principais plataformas como blog do Google, da Amazon ou da Microsoft. A tradução do título é "Construindo uma Sala de Espera Virtual com Amazon DynamoDB e AWS Lambda na SeatGeek". Eu imagino que SeatGeek seja tipo um ingresso.com lá dos Estados Unidos. E você não precisa usar serviços da AWS pra fazer uma Sala de Espera ou Waiting Room, mas com certeza facilita. Como o blog é da Amazon, obviamente ele vai sugerir usar tudo da AWS, mas entenda que isso é só uma das opções.







O conceito é simples: ninguém entra direto na página de escolha de assentos, que é a parte mais lenta, o pior gargalo, e você não tem controle nem como deixar mais rápido. Então todo mundo entra primeiro numa página de Sala de Espera. Assim como quando você vai nos Correios ou no Cartório, você ganha um código. Quando seu código for chamado, daí você entra na Zona Protegida, que é a escolha de assentos.






A situação de gargalo é quando não tem essa senha. Imagina lá no cartório você chega e fica toda hora perguntando pro atendente, “é minha vez? É minha vez?” Daí o atendente nem consegue terminar a pessoa que já tá atendendo e vai ficando mais lento à medida que chega mais gente. Por isso eles usam o sistema de senhas. Aqui eu vou resumir super resumido pra não complicar o conceito, mas lembre-se que não importa que linguagem ou framework estiver usando. Dá pra implementar em qualquer uma com resultados idênticos. O fluxo é mais ou menos assim:






Primeiro você tem um serviço que gera tokens de acesso únicos, a tal senha de espera. Cada usuário que chega na Sala de Espera ganha um token único associado à sua sessão web. Mesmo se o usuário perder a paciência ficar dando reload na página, vai dar reload numa página cacheada da Sala de Espera, e o token continua sendo o mesmo. Isso evita jogar tráfego desnecessário na página lenta de escolha de assentos. A página de espera em si você coloca um contador em Javascript e usa técnicas como já falei acima de cache, CDN e tudo mais, então você consegue controlar a carga nela e escalar horizontalmente se precisar.








A quantidade de tokens disponíveis vai ser o mesmo número de assentos da sala. Se acabar os tokens, você já de cara diz pros próximos usuários que acabou os lugares nessa sala e manda ele escolher outra sala, que tenha tokens ainda disponíveis. Aqui você vai refinando esse número ao longo do tempo, tipo, já sabe que 10% dos usuários desiste na sala de espera, então da próxima vez distribui 10% a mais de tokens e faz um overbooking, que é o que companhias aéreas fazem também, de reservar mais assentos do que tem no avião porque eles sabem que uma certa porcentagem sempre desiste em cima da hora.








A página do usuário nesse ponto vai ser um timer ou contador que fica falando "daqui X minutos mais ou menos, você vai ser atendido". Isso é uma estimativa que você consegue fazer baseado no tempo médio que um usuário costuma levar pra escolher lugares e quantidade de gente na sala de espera. Não é difícil.






A amarração de usuário e token pode ficar armazenado num Redis, como eu vim falando até agora ou, no caso desse blog post, ele sugere deixar no DynamoDB que é outro tipo de NoSQL. Aqui depende da sua aplicação e nenhuma das opções é necessariamente melhor ou pior. Você precisa estudar os detalhes de ambas pra decidir qual é melhor pra você. Eu não recomendo usar Dynamo se você não sabe como ele funciona, as vantagens e desvantagens em cima de outros bancos mais convencionais.






Pra controlar a zona protegida, que é a página de escolha de assentos, você cria um serviço ou um worker que o blog post chama de Bouncer. Se você não sabe, Bouncer é o leão de chácara, o cara grandão na entrada da balada que mantém a ordem. O Bouncer é quem vai ficar monitorando quem já escolheu lugar e deixar outra pessoa entrar pra escolher. Pode ser um de cada vez, pode ser de 10 em 10 pessoas de cada vez. O blog post sugere usar um AWS Lambda, que funciona como o conceito de worker que eu falei acima. 






E o AWS API Gateway como a API pra gerenciar os tokens. De novo, é opcional usar esses serviços. Você pode usar o Celery do DJango se estiver fazendo em Python em vez de usar o Lambda. O Lambda vai ser mais conveniente de escalar e instalar, o Celery vai ser um pouco mais barato e mais fácil de programar da primeira vez, mas aí você precisa controlar o deployment e escalabilidade na mão. De novo, depende da sua solução. Você tem que estudar todas as opções antes de sair escolhendo automaticamente só porque um blog post falou.






No final, o importante é que se sua aplicação estiver usando caches como eu falei, CDNs pros assets, evitar ficar batendo em serviços externos como o banco de dados, e implementar uma sala de espera, mesmo com um serviço bosta de escolha de assentos dos cinemas, é possível segurar a multidão do Homem Aranha sem brigas nem empurra empurra. Basta todo mundo ficar na sala de espera e ser corretamente notificado que não adianta esperar porque já tem mais gente esperando do que assentos disponíveis na sala. Daí notifica sugerindo outras salas próximas do mesmo tipo ou outra data mais pra frente.







Fazendo isso não só você controla a carga no serviço bosta e consegue fazer todo mundo pegar o assento que quer de forma ordenada, e consegue dividir o tráfego pra outras salas que as pessoas não escolheriam primeiro. Assim, todo mundo consegue os ingressos que quer, pra data que quer, sem sobrecarregar os serviços. Porque a regra é tornar escalável o que você mesmo fez e controlar o acesso do que você não tem propriedade.








Se subir a aplicação num Heroku ou usando ferramentas como a AWS Elastic Beanstalk ou CloudFormation, ou se for uma plataforma realmente grande usar um Kubernetes da vida, você deve ter servidores web voláteis, que pode escalar pra cima ou pra baixo, ou seja, iniciar novos processos da sua aplicação ou derrubar esses processos, sem perder informações das sessões dos usuários. Os processamentos mais pesados como pagamentos estão sendo controlados por Jobs, seja num Bull de Node.js em outro servidor, seja num AWS Lambda. E as partes mais sensíveis como a escolha de assentos está numa zona protegida por um serviço de Bouncer e seus usuários estão todos em salas de espera que é uma página leve que, mesmo que todo mundo fique dando reload, não vai pesar quase nada, porque a maior parte tá cacheado.







Daí, na frente disso tudo, como o blog post sugere, você ainda pode adicionar um AWS Shield que é um serviço de proteção de Denial of Service e o AWS WAF que é Web Application Firewall. Isso pra mitigar o caso de scalpers, que são robôs de cambistas que ficam tentando comprar ingressos de forma automatizada pra revender mais caro depois num eBay da vida. Outra opção é o Cloudflare, que eu particularmente gosto, pra evitar isso DDoS e cambistas também. Cambista tem que morrer, raça desgraçada.








Eu nem mencionei, mas é claro que coisas como o banco de dados MySQL ou Postgres, que eu prefiro, o Redis, tudo isso hoje em dia você não instala mais na mão e muito menos no mesmo servidor físico que sua aplicação Web. No caso da Amazon vai usar os serviços RDS que é banco de dados como serviço e o ElasticCache que é Redis ou Memcache como serviço. E eles se viram pra aguentar o tráfego que você der pra eles. Tem facilidades como gerar instâncias replicadas e também pra arquivar dados velhos que não usa mais num serviço como Glacier ou RedShift.







Tem muita gente que fica ainda com essa idéia de bala de prata e solução mágica e acha que a solução é só jogar tudo pra um NoSQL como um Dynamo da vida. Mas isso tá errado. Você vai querer extrair relatórios depois, e não tem nada mais prático pra extrair relatórios, fazer auditoria e tudo mais do que um SQL de verdade. Você sempre deve escolher SQL por padrão e pra usar um NoSQL no lugar dele, precisa ter uma justificativa muito forte e muito bem embasada em números. Se for só no chute, não escolha um NoSQL. Caso sua aplicação seja algo com características de alto volume de dados como um FitBit da vida, que fica mandando dados de batimento cardíaco de cada pessoa o dia inteiro, daí vai gerar volumes gigantes de dados que na maioria dos casos é inútil. Você vai compilando agregados desses dados por período de tempo, daí um banco de dados de Time Series pode ser mais adequado que um SQL, mas no final você ainda vai carregar o agregado por período em SQL pra gerar relatórios por exemplo. É caso a caso.







Além disso, tanto num Heroku ou AWS RDS da vida, você tem fácil a opção de fazer replicação dos dados. Ou seja, pode criar uma instância principal e várias instâncias seguidoras que vão receber uma cópia das modificações. Assim você pode extrair relatórios de uma instância que sua aplicação web não acessa, daí não fica concorrendo com seus usuários quando precisar tirar um relatório super pesado, por exemplo, que é outro erro muito comum que iniciantes fazem.







Aliás, se você entendeu o que expliquei até aqui, não só faria SQL pesados de relatórios numa instância replicada separada como jogaria processamento de relatórios pra um Job, pra um worker processar e entregar o arquivo de Excel depois. Se outro administrador pedir o mesmo relatório, já vai ter o cache desse arquivo, daí não precisa processar tudo de novo, toda hora. Sacou? O iniciante ia mandar processar o relatório na mesma instância principal do banco de dados que sua aplicação usa. Nessa hora um monte de tabelas ia ficar bloqueada e sua aplicação web ia engargalar esperando. E se outros administradores pedissem o mesmo relatório, ia mandar processar tudo de novo, deixando tudo lento. Mas usando filas e cache, você minimiza isso.








Filas e cache sozinhos resolvem 80% dos problemas de escalabilidade e isso são conceitos que independem da linguagem ou framework que você tá usando. Um site feito por um iniciante, onde uma página pode levar 100 milissegundos, dá pra baixar pra 30 milissegundos, sem trocar de linguagem nem nada drástico desse tipo. Você consegue aumentar de 1000 usuários simultâneos pra 100 mil usuários simultâneos, sem trocar nada, só fazendo a arquitetura correta como falei.







No tamanho de um ingresso.com, com mais de 10 anos de idade, já era pra ter implementado o que falei, uma parte de cada vez, ao longo dos anos. Ninguém deveria fazer o que eu falei no dia um, porque não se justifica a complexidade da quantidade de peças móveis. Mas a essa altura do campeonato já é injustificável não ser assim. Nada do que eu falei hoje é considerado avançado. São técnicas que existem faz anos, mais de década, todo grande site com as características de ter que acessar serviços lentos como escolha de assentos sabe o que é uma porcaria de uma Sala de Espera. Porra, até a porcaria de cartórios físicos usa esse conceito. O conceito precede a existência da internet.








Outra coisa importante. Eu usei números e métricas inventadas só pra dar de exemplo. Como eu disse, depende do seu sistema, onde você instalou e quantos usuários acessam seu sistema de uma só vez. Pra saber os números reais da sua aplicação, antes de tentar implementar qualquer coisa que falei, você deve ter métricas reais pra comparar antes e depois. Todo framework que se preza tem bibliotecas de profiling e métricas que você deve instalar e rodar em produção. Ou usar serviços como o New Relic, que vai instalar um plugin na sua aplicação web e registrar todos os tempos de tudo da sua aplicação, assim você vai encontrar gargalos muito fácil.








A coisa mais errada que existe é começar a otimizar código sem ter métricas. Você vai gastar dias otimizando uma parte do sistema que achava que era gargalo, mas na real, nenhum usuário nem acessa muito. Otimizar sem métricas é uma enorme perda de tempo. Normalmente tem no máximo meia dúzia de gargalos de performance que se você resolver eles primeiro, 80% dos problemas de performance são resolvidos. Você instala o New Relic, deixa rodando alguns dias, e volta pra ver quem são os Top 3 principais ofensores e vai resolver eles primeiro. De cara, vai descobrir que o principal ofensor é uma tabela grande que você esqueceu de colocar um índice. E fazendo isso metade da lentidão vai embora, sem modificar uma linha de código.








Agora, você instalou o New Relic e vai começar a otimizar, fazer uma fila, transformar um pedaço de código síncrono ou com async num job assíncrono de verdade com workers. Só que ao fazer isso, necessariamente vai introduzir bugs inesperados. Não é uma questão de "se", é literalmente uma questão de "quando". Não importa se você é um iniciante ou um sênior, você vai introduzir bugs. Especialmente se for a primeira vez fazendo uma arquitetura assim.






Antes de otimizar performance ou mudar arquitetura você precisa criar uma suite mínima de testes. E precisa ir adicionando novos testes e dando manutenção nos antigos, à medida que for implementando a solução nova. Você precisa ter confiança que o que tá fazendo está de fato funcionando. Senão vai ver no New Relic que sim, melhorou a performance, mas só porque você introduziu um bug que tá pulando o código que precisava executar. Daí tudo ficou mais rápido não porque você otimizou certo, mas porque apagou o pedaço que era lento e agora não roda mais. Parece louco isso, mas acontece.







Então antes de falar em fazer Salas de Espera, tokens de acesso, CDNs, Redis e tudo mais, você precisa aprender a instalar e monitorar métricas pra identificar objetivamente os gargalos e erros do seu sistema e precisa aprender pra ontem como fazer testes unitários, testes de aceitação e tudo mais. Só DEPOIS disso que você pensa em adicionar caches e filas e jobs assíncronos. Ficou claro? E espero que com o que expliquei até agora tenha dado uma luz sobre a diferença de sistema feito depois que você só assistiu um curso ou seguiu um tutorial e um sistema de verdade. Tem muito mais coisas além disso. Como eu falei, nunca tive acesso ao código do ingresso.com então estou supondo muita coisa a partir do comportamento que eu experimentei e odiei. Pode ter vários outros gargalos que eu não pensei hoje. Mas é isso aí, se você ficou com dúvidas vai jogando nos comentários, e nada de spoilers do Homem Aranha heim! Se curtiu deixa um like, não deixe de assinar o canal e compartilhar com seus amigos. A gente se vê, até mais!

