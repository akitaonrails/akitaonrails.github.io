---
title: "[Akitando] #24 - Sua Linguagem É Especial? Parte 1 em 2001"
date: '2018-11-06T17:00:00-02:00'
slug: akitando-24-sua-linguagem-e-especial-parte-1-em-2001
tags:
- asp
- asp.net
- web frameworks
- arquitetura web
- akitando
draft: false
---

Disclaimer: esta série de posts são transcripts diretos dos scripts usados em cada video do canal [Akitando](https://www.youtube.com/channel/UCib793mnUOhWymCh2VJKplQ). O texto tem erros de português mas é porque estou apenas publicando exatamente como foi usado pra gravar o video, perdoem os errinhos.


{{< youtube id="NwAvovzHRDU" >}}


### Descrição no YouTube

Muito bem, na série "Sua Linguagem NÃO é especial" expliquei porque tudo que você acha que é diferente e moderno na sua linguagem já existia décadas atrás.

MAS, isso dito, nesta nova série eu quero explorar um pouco o outro lado: ninguém disse que você não pode gostar da sua linguagem e, mais importante, dominá-la até o fim.

Veja o que eu fazia quando estava no começo da minha carreira e compare com o que você faz hoje em dia.

Correção: Colo Colo é do Chile, eu falei errado no vídeo. Sorry.

Links de referência:

* ASP WebForms (https://github.com/akitaonrails/ASP_Classic_WebForm)

## Script

Sua Linguagem É Especial! Parte 1

Se você assistiu meus 2 vídeos intitulados "Sua Linguagem NÃO É Especial" que conta como muitas das funcionalidades que você achava que só sua linguagem tinha e que eram coisas modernas na verdade vem de linguagens de 30, 40 ou 50 anos atrás.

Dependendo de como você assistir talvez alguns me interpretem sendo meio niilista. Pode parecer que eu estou dizendo pra não se importar com as linguagens que você gosta. Ou não gostar de nenhuma linguagem.

Na verdade sua linguagem favorita É especial mesmo ela NÃO sendo especial.

(...)


Se você ficou confuso, lembre de qual era meu ponto nos vídeos anteriores: você não é definido pela sua linguagem.

Muita gente coloca suas linguagens e ferramentas num pedestal e agem até defensivamente, querendo esconder, minimizar ou desconversar até as falhas óbvias da sua linguagem ou ferramenta. “Ah, mas a outra linguagem também é ruim em X ou Y”.

Eu sou promíscuo. Eu Não tenho afiliações, eu não tenho lealdade de marcas - eu não sou patrocinado, porque eu defenderia com unhas e dentes, de graça, uma marca que não é minha? -, eu não devo nada a nenhuma empresa. Elas é que devem pra mim e precisam me convencer a usar. Nada que você usa de graça hoje é de graça, lembre-se, se você Não está pagando, o produto é você. Esse é o conceito de freemium. 

Além disso existe outra verdade fundamental sobre tecnologia: ela se torna obsoleta muito fácil. Tenho pena de quem era evangelista de Blackberry, já pensou? Ou os tempos difíceis de ser um evangelista de Perl hoje? Onde estão os evangelistas de Solaris? Deve ser sofrido tentar defender o Delphi hoje.

Eu não. Meu maior prazer é aprender, mas muito mais dominar, e dissecar todas as coisas que eu gosto. E jogar fora no minuto em que não me servem mais. Porque alguém acharia útil limitar o alcance do próprio conhecimento e experiência?

A melhor coisa que você pode fazer pra sua carreira é não tomar lado, nunca ter uma posição. No minuto que você faz isso, você se torna vulnerável. Mantenha sua opções abertas. Você sabe que está vulnerável quando alguém fala alguma coisa ruim da sua ferramenta favorita e você se sente ofendido. Se sentir ofendido é uma opção. 

Existe uma observação empírica chamada Difusão de Inovação, que é o gráfico de adoção de alguma inovação.

Só vale a pena ser um evangelista se você está entre os Early Adopters e Early Majority. Você não quer ser um evangelista na fase de Late Majority ou Laggard. Defender Delphi hoje é ser um Laggard. Defender iOS em 2007 é Early Adopter. Em 2011 já é Late Majority. Quanto mais no fim dessa curva, menos seu conhecimento tem valor. Entenda que valor de conhecimento é inversamente proporcional à adoção.

Isso dito, deixa eu voltar ao ponto: sua linguagem é especial. Claro que é, como eu mostrei nos vídeos anteriores, é o resultado de uma longa linhagem de linguagens e pesquisas anteriores que culminaram de alguma forma no que você está usando hoje.

O erro é achar que ela vai continuar sendo o estado da arte pra sempre. Claro que não. Em breve seja lá qual linguagem você está usando vai se tornar o próximo Cobol ou Smalltalk.

Neste vídeo e no próximo quero contar duas histórias que aconteceram comigo quando eu tinha 24 anos, pra dar uma perspectiva pra vocês que estão nessa mesma faixa agora. 

Se você está no começo de carreira, digamos que você usou Express, ou Django, ou Laravel, ou Rails. Você já não sentiu vontade de escrever seu próprio framework? Claro que sim, todo mundo já passou por isso.

Em 2001, dentre outras coisas, acho que já tinha uns 2 anos que eu usava ASP. Não o ASP.NET, o ASP clássico mesmo. Eu estava trabalhando numa ponto com, a Panamerican Sports Network, ou PSN. Ela fazia parte do grupo Hicks Muse Tate and Furst. Era dona de diversas equipes esportivas na América Latina como Cruzeiro, Corinthians, Figueirense, Colo colo da Colombia, Tigres e Chivas-Rajadas do Mexico, patrocinava o Alan Prost na Formula 1, tinha contratado o Pelé pra um programa de TV - eu lembro de ter ido na festa de lançamento - e no meu escritório em SP que tinha basicamente jornalistas, eles tinham lá colunistas como Sócrates e o Marcelo Fromer. 
Eu falei, a bolha das ponto coms era absurda em torneira aberta de dinheiro.

Eu trabalhava na construção de todos esses sites com uma equipe que ficava na Flórida e alguns outros espalhados em outros países como Argentina, e acho que Venezuela. Nesse meio do caminho, a Microsoft estava se preparando pra atacar a dominância do Java. Eu estava muito empolgado com o lançamento do .NET na época. Mas ainda era meio beta. E naquela época as coisas não saíam tão rápido quanto saem hoje em dia.

O ASP que hoje chamamos de clássico, na época era o padrão de fato e de direito. Ele não iria embora por alguns anos ainda mesmo com o .NET. O .NET pra web tinha um framework novo, o ASP.NET Web Forms.

Comparado com o que se tinha no ASP clássico, PHP e o JSP da época, era uma evolução significativa. Em resumo, tinha 2 coisas que eu gostei, na época. A primeira era o próprio Web Forms. Em resumo, ele mantinha uma estrutura de dados que representava o estado da página e toda vez que você dava um POST ele mandava esse estado de volta pro servidor. O Estado ficava num campo hidden escondido no form encodado em Base64. Então a gente manipulava o estado nos callbacks como se fossem atributos num objeto que era serializado e desserializado entre o HTML e o C# e o Web Forms renderizava o HTML e conservava o estado escondido.

Isso era um Page Controller que já é um pattern ultrapassado, isso é pré adoção do modelo MVC que tínhamos no Java no framework Struts, lançado só alguns meses antes, e que era muito melhor. Mas pra quem era de ASP puro, o Page Controller já era um patttern bacana.

A segunda coisa era a idéia de manter sessões em banco de dados. O ASP puro mantinha sessões de usuários em memória. O problema é se você queria escalar horizontalmente. Agora se o load balancer mandasse o usuário pra um servidor diferente, ele perdia a sessão. Então você era obrigado a configurar o load balancer pra usar uma coisa chamada session affinity que fazia o mesmo usuário sempre cair no mesmo servidor pra manter a sessão. Isso era bem ruim na verdade.

No ASP.Net você podia escolher StateServer e com isso manter a sessão no banco de dados, daí podia escalar horizontalmente mais fácil. Isso foi antes de inventarmos o termo “arquitetura shared-nothing”.

O que eu resolvi fazer? Um framework em ASP puro que fazia essas duas coisas. Dá uma olhada. (puxa)

Eu basicamente criei classes pra cada elemento de um form pra representar no lado do servidor. Coloquei coisas que o ASP não tinha nativo como MD5 e Base64.

Eu tinha uma classe que representava uma Page (já que o pattern é o Page Controller onde cada página HTML tinha um controller no back end).

Eu fiz uma classe de Session que eu chamei de SessionPlus pra substituir o Session in memory do ASP por um que gravava em banco.

Eu fiz uma classe pra encapsular até o gerenciamento de upload de arquivos. Antes a gente lidava direto com o blob que vinha num form multipart.

Eu já tinha até o conceito de Validators, eu tinha classes ValidatorRequired que é como o validates presence de um ActiveRecord do Rails e até um Validator Regex com patterns pré-configurados pra regex comuns.

Cada classe cuidava da renderização HTML de cada elemento segundo a parametrização e aí no HTML em si eu precisava colocar o mínimo possível pra posicionar os elementos.

Eu até quis fazer um sistema de challenge-response. Em vez de postar a senha do usuário no form, eu carregava um gerador de MD5 no lado do Javascript. \
Daí o framework quando renderizava o HTML do Form também colocava um challenge num campo hidden do form, meio como hoje a gente coloca um meta tag pra evitar cross site request forgery. 
Daí antes de submeter o form eu fazia um md5 do usuário, senha e esse challenge, daí no servidor era só fazer o mesmo md5 e comparar, daí eu não trafegava a senha. Ah sim, era md5 porque na época ainda não sabíamos que md5 tinha defeitos, só depois passamos a usar sha1.

Não era um esquema muito sofisticado nem muito seguro na verdade, mas em 2001 meu conhecimento de segurança só ia até aí. Eu tinha programado jeitos de evitar um pouco o cross site, e também duplo post ou post back.

Tudo foi escrito em VBScript! … é eu sei ... que era uma versão menor do Visual Basic 6. Mas eu fui um pouco além. Em vez de deixar esse código junto com o código da aplicação, eu aprendi que era possível encapsular VBScript num XML em formato WSC que era Windows Script Components. Ele funciona como um componente COM binário e eu podia instalar no servidor de aplicação COM+ Components que vinha carregado em todo Windows Server e expor método públicos como CreateInstance e aí eu podia instanciar os objetos no servidor COM+ e usar de uma página ASP. 

Normalmente você precisaria usar C++ ou Visual Basic 6 pra fazer componentes COM. Não sei porque, parecia que quase ninguém usava VBScript pra fazer componentes. A falta que fazia um site como stackoverflow …. Pensa que não existia o conceito de um NPM ou Nugget o máximo que tínhamos em open source era CPAN pra Perl, mas em Windows, nada. Ah, e não existia Git e nem Subversion, e vou te dizer que CVS era um parto pra usar.

Eu vou dizer que, pra ser 17 anos atrás, até que não tá tão ruim. Em em PHP ou Perl ainda não tinha muito o conceito de um “web framework” como temos hoje. No Java mesmo tava começando isso.

Agora, a parte ruim? Eu gastei um tempão fazendo os sites do jeito “normal” macarrônico em ASP e em paralelo eu ficava tentando fazer esse framework. Mas quando eu terminei ele, a bolha da internet tava crasheando e no final eu acabei não usando esse framework em nada muito útil.

Eu estava usando VBScript e ASP pra fazer coisas que eles não foram feitos pra fazer. A linguagem em si era bastante limitante. Mas o ponto foi pra dizer que eu fiz tudo que era possível fazer e também tentei dobrar a linguagem além do que deveria.

Foram acho que uns 3 anos programando todo tipo de intranet, extranet, website e tudo mais com ASP. Isso foi no ápice já do Late Majority do mundo ASP na curva de adoção.

ASP Clássico ainda iria durar muito tempo, eu reencontraria projetos em ASP em 2003, 2004 até 2008 e 2009. Mas esse framework pra mim serviu pra demonstrar as limitações do ASP e eu sabia que não havia mais muito o que fazer. O que poderia ser feito já havia sido feito. Era hora de abandonar o navio e foi o que eu fui gradativamente fazendo ao longo de 2002 e 2003.

Mesmo ainda haveria mercado pelos próximos 10 anos, mas já eram os Late Majority começando a virar Laggard, pelo simples fato que a Microsoft já deu sinais de abandonar o ASP pra perseguir o ASP.NET e como ASP não era open source, era o fim da linha.. O crash da internet meio que me forçou a mudar de rumo de qualquer jeito e depois disso eu caí no mundo SAP e Java de cabeça, que é tema pra outro episódio.

Porque eu contei essa história? Porque não importa qual linguagem ou plataforma eu pegasse, eu tentava sempre encontrar os limites. Não só seguir os tutoriais, ou os padrões, mas quebrar os padrões. É o que todo programador open source meio que tenta fazer hoje em dia também. O maior problema é que quando você investe 3 ou 4 anos da sua vida estudando e treinando com afinco, quando você conhece cada detalhe da tecnologia, a zona de conforto é muito sedutor. Você já é o senior, o melhor da tecnologia, poucos sabem tanto quanto você sabe.

Eu tive a sorte de recomeçar como junior em outra plataforma e fazer tudo de novo. Os primeiros 15 anos da minha carreira acho que de 1991 até 2006 foram consecutivos reinícios. Eu fui tecnicamente junior a maior parte da minha carreira, porque eu ficava reiniciando em novas plataformas o tempo todo, só depois de 2008 eu comecei a me aceitar como “senior”. E não foi de propósito, eu disse que a bolha da internet foi um momento interessante. O pico e o crash aconteceram de uma só vez, mas os anos que se antecederam pra chegar na bolha já eram acelerado. Não é muito diferente de como é hoje.

Eu não conhecia o conceito ainda de curva de adoção, mas intuitivamente eu tinha a noção. Mas não foi perda de tempo. Todos os conceitos que eu pratiquei em detalhes fazendo o framework deste episódio serviram pra me ajudar a avaliar melhor os frameworks que vieram depois. O ASP clásico e VBScript morreram, mas os conceitos de gerenciamento de sessão, validadores de form, gerenciadores de upload, separação de lógica server-side e client-side, componentização, serialização de objetos, encoders e o básico de criptografia, continuam sendo conhecimentos válidos. E esses conceitos é só o que tem nesse mini-framework, mas no próximo episódio você vai ver uma coisa um pouco maior que eu fiz alguns meses antes desta história, vocês vão gostar.

Meu código de 2001, comparado com os padrões de hoje em dia, é bem ruim. Bem ruim mesmo. Mas se alguém tiver curiosidade, eu subi esse mini-framework no meu Github, coloquei o link na descrição do vídeo. Não deixem de comentar abaixo, conta pra gente você também já fez seu próprio framework? Se curtiram mandem um joinha, assinem o canal e clique no sininho.
