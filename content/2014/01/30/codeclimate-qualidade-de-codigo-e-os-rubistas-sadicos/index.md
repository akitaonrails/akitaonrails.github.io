---
title: CodeClimate, Qualidade de Código e os Rubistas Sádicos
date: '2014-01-30T19:59:00-02:00'
slug: codeclimate-qualidade-de-codigo-e-os-rubistas-sadicos
tags:
- learning
- beginner
- ruby
draft: false
---

Análise estática de qualidade de código executado automaticamente é uma daquelas coisas que quando você se acostuma a usar passa a pensar __"como diabos eu sobrevivia antes sem isso?"__

Se ainda não conhece, trate de experimentar o excelente [Code Climate](http://codeclimate.com) criado por [Bryan Helmkamp](https://github.com/brynary), um rubista muito conhecido na comunidade por contribuições em diversos projetos open source, incluindo o próprio Rails e bibliotecas que já foram muito usadas algum tempo atrás como webrat.

O que o Code Climate faz é muito simples: você cadastra seu projeto público ou privado do Github e ele vai começar a processá-lo até surgir com uma nota que vai de zero a quatro. Eu ainda não vi como é um projeto nota Zero mas considerando que já trabalhamos em alguns projetos de resgate que começou em notas como 2 - e já era lamentável - zero significa __"mude de profissão, você não serve para isso."__ 

Veja um dos meus projetos de cliente (e todo projeto de cliente tem o mesmo nível):

![Nota de todo projeto de cliente no Code Climate](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/393/big_Screen_Shot_2014-01-30_at_7.40.13_PM.png)

Aliás, quando recebo código dos outros pra melhorar, rodar no Code Climate é a primeira coisa que eu faço para mostrar a profundidade do buraco de uma forma numérica que todo cliente consegue entender.

Mas como ele faz isso? Ele analiza todos os arquivos Ruby do projeto calculando itens de Complexidade (quantidade de assignments (mudança de valores de variáveis), branches (ifs, ifs dentro de ifs)), Complexidade por Método, Duplicação de código, quantidade de vezes que o arquivo foi modificado no Git, quantidade de linhas de código.

Além disso ele faz um scan de segurança, buscando por 20 buracos comuns de segurança como SQL Injection, Cross Site Request Forgery, Denial of Service, Session Setting e assim por diante.

E finalmente, ele se integra com o [Travis-CI](http://travis-ci.com/) e checa por cobertura de testes.

Melhor ainda: a cada <tt>git push</tt> que você dá no seu repositório, o Code Climate automaticamente puxa a atualização e processa tudo de novo e rapidamente envia um email a todos da equipe dizendo se a nota subiu ou caiu, incentivando a consertar o que piorou de qualidade imediatamente. É o mesmo conceito de um continuous integration como o Travis-CI que também executa em paralelo e imediatamente diz se um teste quebrou ou se a cobertura de testes diminuiu.

O correto é sempre estar a 100% de qualidade "conhecida" e 100% de segurança "conhecida" e 100% de cobertura de testes. Começando com tudo a 100%, agora é só manter o nível e consertar imediatamente quando ela cair. Não existe forma melhor de desenvolver. O errado é a equipe trabalhar com um código "opaco", uma caixa preta que ninguém tem certeza se tem algum mínimo de qualidade, onde as pessoas "acham" que o código deve estar bom, onde os testes "provavelmente" rodam e passam. Esse é o jeito mais errado de se desenvolver.

E é errado porque a nota do Code Climate não significa que o código está realmente bom, ele apenas indica o que é tão óbvio que é errado que até um processo automatizado é capaz de encontrar. O Code Climate não é um auditor de código, ele meramente detecta alguns dos muitos ["code smells"](http://www.codinghorror.com/blog/2006/05/code-smells.html). Um smell pode ser um falso-positivo, ou seja, não há outra maneira mesmo de se desenvolver de outra forma.

Ou seja, ter nota perto de 4 no Code Climate é o mínimo que todo projeto deve ter. Notas 2 e abaixo disso são projetos vergonhosos, dignos de se jogar fora.

## Rubistas Sádicos

Por coincidência, a primeira palestra/screencast que eu já fiz foi uma tradução literal de outra excelente palestra. Ela se chama ["Machucando Código por Diversão e Lucro"](http://www.akitaonrails.com/2008/06/14/machucando-c-digo-por-divers-o-e-lucro#.UurIonmpy5c) que publiquei em 24 de Junho de 2008.

A palestra original foi apresentado por Ryan Davis, mais conhecido como [@zenspider](http://zenspider.com), um dos rubistas mais antigos e não tão conhecido. Ele criou algumas ferramentas muito importantes junto de um dos melhores grupos de Ruby que já existiu, o [Seattle.rb - Seattle Ruby Brigade](http://www.seattlerb.org) que apresentou ao mundo alguns dos melhores rubistas da primeira geração, incluindo o próprio Ryan Davis, Evan Phoenix (criador do projeto Rubinius), Eric Hodel (mantenedor do Rubygems, RDoc), Geoffrey Grosenbach (do Peepcode), Aaron Petterson (mais conhecido como @tenderlove). Aliás, a [Referência Rápida de Ruby](http://zenspider.com/Languages/Ruby/QuickRef.html) do Seattle.rb contém dicas importantes que muitos ainda ignoram.

O que o Bryan fez no Code Climate foi criar uma camada web de usabilidade Software-as-a-Service por cima de algumas bibliotecas bem antigas. Duas delas do Ryan Davis, o [Flay](http://ruby.sadi.st/Flog.html) e o [Flog](http://ruby.sadi.st/Flay.html), duas das ferramentas de tortura essenciais de um [Rubista Sádico](http://ruby.sadi.st/Ruby_Sadist.html). 

Assista a minha palestra traduzida do Ryan que explica esse assunto em mais detalhes. Mas a nota que o Code Climate gera é baseado nas notas que o Flay e o Flog devolvem ao torturar seu código. Exatamente como descrito no site dos Rubistas Sádicos, o Flog lhe mostra os códigos mais tortuosos que você escreveu, quanto mais doloroso o código, maior a nota. O Flay analiza a estrutura do código Ruby por similaridades estruturais; diferenças de nomes de variáveis, espaços em branco, e estilo de programação são ignorados.

Além do Flay e do Flog, o Bryan adicionou o projeto [Brakeman](http://brakemanscanner.org), que é o scanner de segurança. O Bryan explica como ele calcula a [métrica do Code Climate](https://codeclimate.com/docs#quality-metrics) em seu site.

Uma coisa que todo bom rubista já fez foi executar essas ferramentas manualmente em seus projetos. O Flay, Flog, Heckle, [SimpleCov](https://github.com/colszowka/simplecov), Brakeman, [RubyProf](https://github.com/ruby-prof/ruby-prof) e outros analisam seu código geram relatórios que lhe dão indicativos de como melhorar cada vez mais seus projetos. Você pode inclusive fazer o mesmo que o Bryan: amarrar a execução dessas ferramentas em alguma runner como o Jenkins, por exemplo. Vale o exercício, quem vai criar o primeiro Code Climate open source?

Seja um Rubista Sádico e machuque seu código por diversão e lucro também. Código não revida, quanto mais você machucá-lo, mais vai se divertir. Código que não é massacrado o tempo todo é muito frágil, e merece ser destruído.
