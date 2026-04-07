---
title: "A Economia do Desenvolvimento de Software"
date: '2017-06-22T10:56:00-03:00'
slug: a-economia-do-desenvolvimento-de-software
translationKey: economics-software-development
aliases:
- /2017/06/22/the-economics-of-software-development/
tags:
- off-topic
- agile
- lean
- methodologies
- startup
- traduzido
draft: false
---

A comunidade de desenvolvimento de software está efervescente com tantas opções ao mesmo tempo. Temos dezenas de linguagens ativas e muito boas, como Go, [Elixir](/elixir), Clojure. Dezenas de frameworks excelentes, tanto no back-end quanto no front-end, incluindo React e Elm. Dezenas de metodologias sólidas, desde o bom e velho Agile até Continuous Deployment com microsserviços.

Mas você é uma pequena startup de tecnologia ou uma equipe pequena dentro de uma grande corporação. Por onde começar?

A recomendação é simples: faça a menor coisa que funciona primeiro. Sempre. Claro, evite o "rápido e sujo" ao máximo. Mas não seja paranoico nem exagere na engenharia.

Super-engenharia é tão cara quanto fazer as coisas de forma "suja".

### Adicione "Tempo" à sua equação

O erro mais comum que a maioria das pessoas comete é ignorar a variável "Tempo".

Todo mundo vai a conferências de tecnologia, lê posts badalados ou assiste screencasts chamativos. A conclusão errada que tiram é: _"a Netflix usa isso, então deve ser bom pra mim, porque eu quero me tornar a Netflix"_.

O pressuposto falso é que a Netflix — ou o Google, ou o Facebook, ou o Spotify — é um sistema estático e sempre funcionou da forma como eles divulgam hoje.

As pessoas esquecem que toda empresa unicórnio teve um **dia 1**. E no dia 1, elas não usavam microsserviços. Não tinham React.js. Não tinham Go nem Elixir. Algumas nem tinham bons programadores de início. A Netflix começou como um serviço de aluguel de VHS, lembra? O Google começou num quarto de dormitório universitário com componentes de hardware montados num [rack de Lego](http://www.complex.com/pop-culture/2013/02/50-things-you-didnt-know-about-google/lego-server-rack).

Imagine que você é fã de uma celebridade. Essa celebridade tem uma Lamborghini. Você quer ser como essa celebridade um dia. O que você faz? Compra a mesma Lamborghini que ela tem?

Se você fizer isso, a única coisa que vai conseguir é uma DÍVIDA ENORME para pagar.

Pare de invejar a Lamborghini do rico.

### Dívida (Técnica)

Esse não é um termo novo nem um tema novo. Cada decisão que você toma em programação é um **compromisso** entre o que o "futuro ideal" deveria ser e o que você consegue fazer agora. Tomar empréstimo para comprar a Lamborghini equivalente cedo demais, e você vai ter que lidar com uma Dívida (Técnica) impagável. E vai travar, vai parar, e vai fazer NADA além de pagar essa dívida daqui pra frente.

Você quer "codar mais rápido", então pula a escrita de testes automatizados, porque acha que vai te atrasar. E você está certo. O desenvolvimento orientado a testes não é para te deixar rápido de início. É para proteger seu eu futuro do seu eu presente. É para não acumular Dívida Técnica.

De novo: você esqueceu a variável "Tempo".

Você escreve e entrega rápido no primeiro mês. Depois que a primeira versão está em produção, você começa a ser obrigado a pagar a dívida. Sua produtividade cai. Bugs de regressão aparecem. Cada nova funcionalidade que você tenta adicionar quebra algo de forma inesperada. Como não tem testes automatizados, você fica corrigindo as mesmas coisas várias vezes. A dívida vai cobrar, e você vai pagar. De um jeito ou de outro.

Suítes mínimas de testes são como um **Seguro**. Você não precisa dele agora, no dia 1. Mas no dia 100 você vai ficar feliz que tem.

Fazer microsserviços demais no dia 1 é dívida. Parece ótimo estar fazendo aquela coisa bacana que você leu num blog. No dia 100, com sua equipe de 3 pessoas e uma dúzia de microsserviços, você não vai fazer nada além de pagar a dívida acumulada, com **Juros**. Cada novo deploy de microsserviço quebra seu sistema. E claro, você não adicionou monitoramento, não adicionou testes integrados. Então toda vez que você sobe algo, outra coisa quebra de forma inesperada.

Ainda está curtindo a Lamborghini antecipada?

### O Mítico Homem-Mês

Philip Calçado escreve ótimos posts e apresentações sobre microsserviços do jeito certo. Se você leva esse assunto a sério, recomendo fortemente que leia seus textos, como o ["Prerequisites"](http://philcalcado.com/2017/06/11/calcados_microservices_prerequisites.html) ou sua apresentação ["Economics"](https://www.infoq.com/news/2017/05/economics-microservices).

Ele cita corretamente **O Mítico Homem-Mês**, de Fred Brooks. Insisto que os desenvolvedores leiam esse livro pequeno. É impressionante como a indústria inteira ainda repete exatamente os mesmos erros que Brooks relatou em seu livro, de projetos dos anos 60!

Para mim, microsserviços são um subproduto de empresas de tecnologia com programadores em excesso. Quando você ultrapassa a barreira de 5 desenvolvedores, um sistema "monolítico" com organização ruim e poucos testes automatizados pode ficar difícil de lidar. A consequência natural é a vontade de fragmentar. Você cria 2 equipes e 2 microsserviços e tenta coordenar. As equipes começam a se isolar e a praticar o jogo de culpar o outro quando novos bugs aparecem (_"é culpa do microsserviço da outra equipe"_).

É a [Lei de Conway](http://www.melconway.com/Home/Conways_Law.html) aplicada da forma errada:

> Qualquer organização que projeta um sistema (definido de forma ampla) produzirá um design cuja estrutura é uma cópia da estrutura de comunicação da organização.

Também entra em jogo outro capítulo do livro do Brooks: o [Efeito do Segundo Sistema](http://wiki.c2.com/?SecondSystemEffect). Todo desenvolvedor e toda startup precisa assumir que a primeira versão de qualquer coisa não é o melhor design. E o segundo sistema (a primeira grande reescrita) é **o sistema mais perigoso** que você vai construir. Como Brooks descreve:

> O primeiro trabalho de um arquiteto tende a ser enxuto e limpo. Ele sabe que não sabe o que está fazendo, então procede com cuidado e grande contenção.

> Enquanto projeta o primeiro trabalho, adornos e embelezamentos vão ocorrendo a ele. Esses ficam guardados para serem usados "na próxima vez." Cedo ou tarde o primeiro sistema está pronto, e o arquiteto, com confiança firme e maestria demonstrada nessa classe de sistemas, está pronto para construir o segundo.

> Esse segundo é o sistema mais perigoso que um homem já projeta. Quando faz o terceiro e os posteriores, suas experiências anteriores se confirmarão mutuamente quanto às características gerais de tais sistemas, e as diferenças identificarão as partes de sua experiência que são particulares e não generalizáveis.

> A tendência geral é super-projetar o segundo sistema, usando todas as ideias e adornos que foram cautelosamente deixados de lado no primeiro. O resultado, como diz Ovídio, é uma "grande pilha."

O que acontece depois? O CEO, o conselho, os investidores — seja lá quem for — começa a fazer a coisa errada: contratar mais e mais pessoas. Tomar mais e mais empréstimos. Em vez de pagar as dívidas, acumulam mais dívida. Caíram na armadilha que Brooks relatou no primeiro capítulo e que dá nome ao livro: O Mítico Homem-Mês.

> Adicionar mão de obra a um projeto de software atrasado o atrasa ainda mais.

> Projetos de programação complexos não podem ser perfeitamente particionados em tarefas discretas que possam ser executadas sem comunicação entre os trabalhadores e sem estabelecer um conjunto de inter-relações complexas entre as tarefas e os trabalhadores que as executam.

> Portanto, alocar mais programadores a um projeto que está atrasado o atrasará ainda mais. Isso porque o tempo necessário para os novos programadores aprenderem sobre o projeto e a sobrecarga de comunicação aumentada consumirão uma quantidade cada vez maior do tempo disponível no calendário.

De novo: ignorando a variável "Tempo". E confundindo "dívida" com "investimento".

Antes de tudo, faça um favor a si mesmo e [leia o maldito livro](http://amzn.to/2sFbkWq) — duas vezes.

### Faça Agile do jeito certo! E não, não é Kanban!

Se há uma coisa boa que todo o barulho do Lean produziu, é a noção de "Produto Mínimo Viável" ou MVP. Alguns chamam de "protótipo". Outros chamam de "lançar em Beta" ou simplesmente "versão 1.0". Não importa o nome. É o reconhecimento de que você não sabe muita coisa no início, então fazer engenharia excessiva na primeira versão é desperdício de tempo. Lean é sobre controlar o "desperdício": fazemos o mínimo que funciona, medimos os resultados e evoluímos a partir daí.

Os cínicos vão dizer que qualquer protótipo que chega a produção nunca morre. E não estão errados.

O equilíbrio está em não fazer a versão "rápida e suja". É pra isso que existem as técnicas ágeis. Faça o mínimo, organize o mínimo. É pra isso que existem os padrões de design orientado a objetos, do GoF ao DDD. Você não precisa aplicar TODOS os padrões — isso é o que significa "super-engenharia". Mas dá pra fazer o monolito mínimo que vai te permitir evoluir depois.

As pessoas criticam Ruby on Rails por não ser organizado "o suficiente". [Nick Sutterer](https://apotonick.wordpress.com/2015/09/05/the-only-alternative-to-a-rails-monolith-are-micro-services-bullshit/), o criador do [Trailblazer](https://github.com/trailblazer/trailblazer), tem um ponto válido.

Rails feito errado é ruim. Mas a conclusão NÃO deveria ser: _"vamos fazer microsserviços"_. Esse salto de fé é idiota e não faz sentido por todos os motivos que citei acima.

_"Vamos fazer Agile de verdade e orientação a objetos de verdade"_ deveria ser a resposta inicial.

E por "Agile", esqueça os post-its idiotas, esqueça as equações de estimativa baseadas em numerologia (isso dá um post inteiro por si só, porque story points e velocity são úteis, mas adicionar Montecarlo e outras coisas baseadas em distribuição Gaussiana não faz sentido). As únicas coisas "Ágeis" com as quais você deveria se preocupar são as [técnicas de Extreme Programming (XP)](http://www.extremeprogramming.org/), **incluindo** os timeboxes baseados em iterações.

Você **PRECISA** fazer timeboxes. Pare, reavalie, mude de direção, e então continue. O modelo de "Pull" só faz sentido quando sua direção é muito, muito clara, está escrita em pedra e é imutável — como numa linha de produção de fábrica! (Que é exatamente onde o conceito de Pull — e o Lean — nasceu!)

Iterações, como testes automatizados, são como um Seguro. Você nunca consegue evitar todo o desperdício, mas pode minimizá-lo. Você pode se dar ao luxo de jogar fora o trabalho de uma Iteração inteira. Depois da iteração você mede os resultados e descarta se necessário — mudando de direção no processo. Jogar fora o que não serve é tão importante quanto adicionar coisas novas. Se você só acumula, está com um [transtorno de acumulação](https://en.wikipedia.org/wiki/Compulsive_hoarding)!

Na dúvida, faça XP. Sim, parece mais "difícil", e o Kanban é "mais simples" de explicar. Mas isso é motivo suficiente?

### Esqueça Performance Bruta quando você NÃO precisa dela!

Outro problema é escolher linguagens ou frameworks por causa de performance.

Se você está no negócio de desenvolvimento web, isso é um DESPERDÍCIO enorme.

Entenda essa verdade: seus servidores vão ficar OCIOSOS na maior parte do tempo. E se você acha que seu web app está lento, não é por causa da linguagem usada — é por causa da PROGRAMAÇÃO RUIM que você fez. Nenhuma linguagem boa vai salvar um programador ruim. Sempre digo que se performance fosse assim tão importante, todo mundo deveria estar usando C.

A maior parte do que você serve em apps baseados em HTTP — seja conteúdo para o usuário, seja resultado de API GET — pode ser **CACHEADA**! Se você não está usando uma [CDN](http://www.akitaonrails.com/2015/08/25/small-bites-adicionando-um-cdn-ao-seu-site-a-forma-facil), está fazendo errado.

Sim, sim, sim, você acha que está construindo o próximo Spotify. Não está — pelo menos 99% de vocês não estão. E os 1% que fazem engenharia personalizada, com técnicas e stack próprios, com sucesso — vocês são os 1%. Na verdade, são uma fração dos 1%. Não assuma que o que você faz é bom para o resto da população.

90% do que a maioria das pequenas empresas e desenvolvedores web solo precisam é só uma conta no Shopify e uma instalação padrão do WordPress. É isso.

> Você está fazendo desenvolvimento de infraestrutura, como construir componentes customizados para Docker, Kubernetes, Terraform? Ferramentas de linha de comando? Daemons? Então escolha GO.

> Está fazendo bibliotecas embutidas? Talvez a próxima geração do OpenSSL? Drivers? Então escolha RUST.

> Está fazendo desenvolvimento mobile? Não tem muita escolha: Swift para iOS, Kotlin/Java para Android. Ou React Native para apps mais simples.

> Está realmente construindo o próximo Whatsapp? O próximo Waze? O próximo Snap? Tem centenas ou milhares de usuários precisando de conexões de longa duração em redes não confiáveis fazendo broadcast de mensagens? Ou está construindo a próxima evolução de bancos de dados NoSQL distribuídos? Ou qualquer coisa que tenha o sentido real de "Distribuído" em sua definição? Então escolha ELIXIR.

> Está fazendo uma aplicação web baseada em CRUD? Vai de RAILS e não olha pra trás.

> Está fazendo tudo isso ao mesmo tempo? Use todas as alternativas então. E espero que tenha orçamento, porque vai precisar de uma equipe grande.

### Conclusão

A Economia só faz sentido quando você considera o dia 1. Não esqueça a variável "Tempo". Ela faz toda a diferença.

Você sempre vai ter Dívidas a pagar. Então seja inteligente na escolha de qual tipo de dívida você assume. Porque vai ter que pagar de volta eventualmente.

De novo: leia Brooks. Ele disse isso décadas atrás: [NÃO EXISTE BALA DE PRATA](http://worrydream.com/refs/Brooks-NoSilverBullet.pdf). Não se iluda. Uma nova linguagem, um novo framework, uma nova arquitetura. Nada disso vai te salvar.

Em qualquer empreitada tecnológica, código não é a única preocupação. Diria até que numa startup de tecnologia, código é apenas 20% do problema. Uma startup de tecnologia é só uma empresa, como qualquer outra. Se você é o fundador ou CEO, tem que lidar com os 80% restantes: marketing, contabilidade, recursos humanos, questões legais, etc. Já é difícil o suficiente sem que sua equipe técnica te traga uma Dívida Técnica indesejada — a Lamborghini desnecessária — que você não vai conseguir pagar.

Você pode começar humilde no dia 1. Continue evoluindo, continuamente — esse é o núcleo de qualquer processo Agile ou Lean: [KAIZEN](https://www.graphicproducts.com/articles/what-is-kaizen/). Escolha dívidas inteligentes, pague-as aos poucos, continuamente. É o mesmo raciocínio de fazer um empréstimo no banco.

> O dia 7.200 da Netflix NÃO é o seu dia 1.

> O dia 4.800 do Facebook NÃO é o seu dia 1.

> O dia 6.809 do Google NÃO é o seu dia 1.

> Seja humilde. Entregue rápido. Pague suas Dívidas. Continue evoluindo continuamente. Pare de acreditar em contos de fadas e balas de prata.
