---
title: 'Tradução: Regras de Otimização'
date: '2008-07-21T19:25:00-03:00'
slug: tradu-o-regras-de-otimiza-o
tags:
- career
- translation
draft: false
---

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/7/21/240px-Ward_Cunningham.jpg)](http://www.aboutus.org/Ward_Cunningham)

Estava lendo um artigo do [GC](http://gc.blog.br/) e por acaso esbarrei com um link de um site que não entro faz algum tempo: [Rules of Optimization](http://c2.com/cgi/wiki?RulesOfOptimization). Para colocar em contexto, [C2.com](http://c2.com/) significa **“Cunningham & Cunningham”**.

Estamos falando de ninguém menos que [Ward Cunningham](http://en.wikipedia.org/wiki/Ward_Cunningham). Dentre outras coisas ele inventou o conceito de [Wiki](http://en.wikipedia.org/wiki/WikiWikiWeb). Além disso atualmente é CTO da [AboutUs.org](http://www.aboutus.org/Ward_Cunningham) que, segundo o [Alexa Ranking](http://rails100.pbwiki.com/Alexa+Rankings) é o 7<sup>o</sup> site mais famoso feito em Ruby on Rails. Ele foi recentemente entrevistado pelo Randall Schwartz e Leo Laporte para o podcast [FLOSS Weekly](http://twit.tv/floss27) e recomendo muito que ouçam.

Mas estou divagando, este artigo que vou traduzir, em particular não é autoria dele :-) Enfim, aqui vai a tradução do artigo em questão:


### [Rules of Optimization](http://c2.com/cgi/wiki?RulesOfOptimization)

As “regras” de otimização são dispositivos retóricos feitos com a intenção de desencorajar programadores novatos de encher seus programas com tentativas inúteis de escrever código otimizado. Eles são:

1. Primeira Regra da Otimização: **Não faça**
2. Segunda Regra da Otimização: **Não faça .. ainda**
3. [Meça Antes de Otimizar](/2008/7/21/tradu-o-regras-de-otimiza-o#meca_antes_de_otimizar)

É incerto até o presente momento, se dispositivos simpáticos como esses mudam, ou se algum dia mudarão quaisquer atitudes.

**Fonte:**

[Michael Jackson](http://c2.com/cgi/wiki?MichaelJackson) (não o cantor!) costumava dizer (quando questionado sobre otimização):

1. Não faça
2. Não faça ainda (apenas para especialistas)

Isso foi republicado em [Programming Pearls](http://c2.com/cgi/wiki?ProgrammingPearls) de [Jon Bentley](http://c2.com/cgi/wiki?JonBentley).

E não nos esqueçamos dessas citações famosas:

> _“O melhor é o inimigo do bom.”_ – [Voltaire](http://c2.com/cgi/wiki?MrVoltaire)

> _“Mais pecados de computação são cometidos em nome da eficiência (sem necessariamente atingí-la) do que por qualquer outra razão – incluindo estupidez cega”_ – W.A. Wulf

> _“Não devemos pensar em pequenas eficiência, digamos por 97% do tempo; [Otimização Prematura](http://c2.com/cgi/wiki?PrematureOptimization) é a raíz de todo mal.”_ – [Don Knuth](http://c2.com/cgi/wiki?DonKnuth), que atribui a observação a [Car Hoare](http://c2.com/cgi/wiki?CarHoare)

h3. Meça Antes de Otimizar

Todas as outras coisas sendo iguais, todos querem que seu código rode o mais rápido possível.

Uma tentação que nunca acaba é “otimizar enquanto se vai”, escrevendo coisas a um nível mais baixo do que realmente deveria (ex. acessando diretamente arrays, usando referências a uma variável de instância em um método que pode ser sobrescrito em vez de usar um método getter, etc.) ou adicionando muitos atalhos de execução para casos especiais.

**Isso quase nunca funciona.**

Seres humanos, mesmo programadores experientes, são muito ruins em prever (chutar) onde uma computação vai engasgar.

**Portanto:**

Escreva código de acordo com restrições além de performance (claridade, flexibilidade, brevidade). Então, depois que o código já está escrito:

1. Veja se realmente precisa acelerá-lo
2. Meça o código para checar exatamente onde ele está gastando tempo
3. Foque apenas nas poucas áreas de maior custo e deixe o resto em paz

Existem várias maneiras de melhorar performance uma vez que você sabe onde: usar uma estrutura de dados que melhor se encaixa às suas necessidades (muitas inserções vs. muitas deleções, muito espaço vs. muito tempo, etc.), tornar seu algoritmo mais esperto (cache de resultados, tirar vantagem da ordenação, caminhar somente onde se precisa, etc), mudar para uma linguagem mais baixo nível ou mesmo implementar a área de maior custo em hardware.

Mas se começar de qualquer jeito tentando otimizar antes de saber onde as coisas estão mais lentas, é garantido que estará tornando a eficiência de seu desenvolvimento mais pessimista.

Quando chega a hora de otimizar um pedaço de software, sempre consiga informações métricas antes, de forma que você possa dizer onde precisa gastar seu tempo fazendo melhorias. Sem dados métricos, não existe maneira de saber com certeza se qualquer “melhoria” de fato melhorou o código (muito similar a usar [Testes Unitários](http://c2.com/cgi/wiki?UnitTest)) para determinar quando um projeto acabou).

Normalmente, “medir” significa conseguir medir o tempo gasto em várias rotinas ou sub-sistemas. Isso permite otimizar para velocidade. Otimizar para espaço [de memória], ou erros de cache, ou coisa assim pode ser feito, embora alguns usem um pouco de bruxaria para conseguir um bom perfil de dados.

Otimizações não precisam ser pequenos ajustes, também. Podem ser substituições no atacado de um algoritmo O(N<sup>3</sup>) por um O(N<sup>2</sup>) ou a eliminação total nos casos mais extremos.

Veja o [artigo original](http://c2.com/cgi/wiki?ProfileBeforeOptimizing) para acompanhar a discussão.

### [Otimize Mais Tarde](http://c2.com/cgi/wiki?OptimizeLater)

[Você Não Vai Precisar Disso](http://c2.com/cgi/wiki?YouArentGonnaNeedIt "YAGNI") aplicado a Otimização – [Falk Bruegmann](http://c2.com/cgi/wiki?FalkBruegmann)

Em outras palavras, você provavelmente não saberá logo de cara se uma otimização trará algum benefício real. Apenas escreva o código da maneira mais simples ( **nota do Akita:** não confundir _“maneira mais simples”_ com _“maneira mais suja”_, ninguém disse que rápido **tem** que ser sujo). Se, eventualmente depois de medir você descobrir um gargalo otimize isso.

Leiam também este artigo de duas páginas de Martin Fowler: [Yet Another Optimization Article](http://martinfowler.com/ieeeSoftware/yetOptimization.pdf)

**Codifique e depois Otimize**

Código escrito em Assembler ou C são quase impossíveis de manter. Código escrito em linguagens de script são lentos. Mas se você combinar os dois, e puder medir os scripts lentos para saber onde os gargalos estão.

**Portanto,**

Não codifique para performance. Não use uma linguagem “rápida”. Codifique visando mantenabilidade e use uma linguagem que melhore essa mantenabilidade. Então meça seu código, encontre os gargalos e substitua **apenas** esses pedacinhos com código-performático em linguagens-rápidas. O resultado é que seu código efetivamente executará tão rápido quanto se você tivesse otimizado ele inteirinho, mas ele será amplamente mais fácil de manter. [AlternateHardAndSoftLayers](http://c2.com/cgi/wiki?AlternateHardAndSoftLayers)

- Faça funcionar,  

  
  - faça correto,  

  
    - faça rápido,   

  
      - faça barato.

- (atribuído a) [Alan Kay](http://c2.com/cgi/wiki?AlanKay)

