---
title: 'Entrevista com Yukihiro Matsumoto: parte III'
date: '2006-11-07T14:03:24-02:00'
slug: entrevista-com-yukihiro-matsumoto-parte-iii
tags:
- interview
- matz
- translation
draft: false
---

Continuamos com a terceira parte da entrevista com Matz, pela [Artima](http://www.artima.com/intv/closures.html).

#### Blocos e Fechamentos em Ruby

> **Sumário**   
> Yukihiro Matsumoto, o criador da linguagem de programação Ruby conversa com Bill Venners sobre dois tipos de funções anônimas em Ruby, blocos e fechamentos.

Yukihiro Matsumoto, ou “Matz”, como é conhecido online, é o criador da linguagem de programação Ruby. Ruby é uma linguagem orientada a objetos que serve para escrever scripts do dia a dia assim como aplicações de escala completa. Matz começou seu trabalho com Rails em 1993, porque ele queria uma linguagem que o tornasse produtivo e ao mesmo tempo fosse divertido de usar. Inicialmente popular no Japão, Ruby tem encontrado seu caminho ao coração dos programadores de todo o mundo.

Em 24 de setembro de 2003, Bill Venners se encontrou com Yukihiro Matsumoto na conferência jAOO em Aarthus, Dinamarca. Nessa entrevista, que está sendo publicada em múltiplas partes na Artima.com, Yukihiro Matsumoto discute a filosofia do design de Ruby, as funcionalidades da linguagem e como se tornar um programador melhor.

- Na [Parte I: A Filosofia de Ruby](http://www.balanceonrails.com.br/articles/2006/10/09/entrevista-com-yukihiro-matsumoto-parte-i), Matz filosofa sobre imperfeições de design e os perigos da ortogonalidade, garantindo liberdade com direção, o princípio da menor surpresa e a importância do ser humano nas conquistas da computação.
- Na [Parte II: Produtividade Dinâmica com Ruby](http://www.balanceonrails.com.br/articles/2006/10/14/entrevista-com-yukihiro-matsumoto-parte-ii), Matz discute interfaces mórficas, usando mix-ins e benefícios de produtividade em ser conciso com Ruby.
- Nessa terceira parte, Matz discute sobre dois tipos de funções anônimas em Ruby, blocos e fechamentos.


#### Abstrações de Loop com Blocos

**Bill Venners** : Ruby suporta blocos e fechamentos. O que são blocos e fechamentos e como são usados?

**Yukihiro Matsumoto** : Blocos são literalmente funções anônimas. Você deve estar familiarizado com _lambda_ de outras linguagens como Lisp ou Python. Basicamente, você pode passar uma função anônima (sem nome) para outra função e então esta pode invocar a função anônima. Por exemplo, uma função poderia executar uma iteração passando um item de cada vez para a função anônima. Esse é um estilo comum, chamado estilo de função de alta ordem, entre linguagens que podem lidar com funções como objetos de primeira classe. Lisp faz isso. Python faz isso. Mesmo C faz isso com ponteiros de função. Muitas outras linguagens têm esse estilo de programação. Em Ruby, a diferença é principalmente um tipo diferente de sintaxe para funções de alta ordem. Em outras linguagens, você precisa especificar explicitamente que uma função pode aceitar outra função como um argumento. Mas em Ruby, qualquer método pode ser chamado com um bloco na forma de um argumento implícito. Dentro do método, você pode chamar esse bloco usando a palavra-chave `yield` com um valor.

**Bill Venners** : Quais os benefícios de Blocos?

**Yukihiro Matsumoto** : Basicamente, blocos são feitos para abstração de loops. O uso mais básico de blocos é para deixar criar seu próprio jeito de iterar sobre ítens.

Por exemplo, se tiver uma lista, seqüência, vetor ou array, você pode iterar para frente usando um método disponibilizado pela biblioteca padrão. Mas se se quiser iterar para trás, do fim para o começo da lista? Em C, precisa configurar quatro coisas: um índice, um valor de começo, um valor comparatório de final e um incremento. Isso não é bom, porque revela detalhes internos da lista. Queremos esconder essa lógica. Usando blocos podemos esconder a lógica do loop dentro de um método ou função. Então, por exemplo, chamando `list.reverse_each` você pode fazer uma iteração reversa sobre a lista sem saber como é implementada por dentro.

**Bill Venners** : Apenas passo um bloco que vai fazer seja lá o que eu quiser com cada elemento, e depende somente da lista saber como ir para trás. Em outras palavras, eu passo como um bloco qualquer código que eu colocaria dentro de um loop `for` em C.

**Yukihiro Matsumoto** : Sim, e isso também significa que você pode definir várias maneiras de iteração. Poderia providenciar uma maneira de iterar para frente, para trás e assim por diante. Depende apenas de você. C# tem um iterador, mas apenas um iterador por classe. Em Ruby você pode ter um número arbitrário de iteradores, se quiser. Se tiver uma classe de árvore, por exemplo, que você imaginaria que as pessoas gostariam de andar nela primeiro na profundidade ou primeiro na largura. Você pode disponibilizar ambas as maneiras através de dois diferentes métodos.

**Bill Venners** : Deixe-me ver se entendo isso. Em Java, eles abstraem iterações com `Iterators`. Um cliente pode pedir uma `Collection` de um `Iterator`, por exemplo. Mas o cliente precisa usar um loop via `for` para andar nela e processar os ítens retornados pelo `Iterator`. Dentro do loop `for`, eu tenho “o código” que quero executar para cada ítem, de forma que o loop `for` sempre mostre o código do cliente. Com blocos, não tenho um método para receber um `Iterator` de volta. Eu chamo um método e passo como um bloco “o código” que quero executar para cada item da iteração. É um benefício da maneira de blocos que ele usa um pouco menos de código em comparação ao loop `for`?

**Yukihiro Matsumoto** : Os detalhes de como iterar deve pertencer à classe que provê serviço. O cliente deve saber o menos possível. Esse foi o propósito original de blocos. De fato, nas versões mais antigas de Ruby, os métodos chamados com blocos eram referidos como iteradores, porque foram concebidas para iterar. Mas durante a história de Ruby, o papel de blocos foi melhorado de abstração de loop para qualquer coisa.

**Bill Venners** : Por exemplo …

**Yukihiro Matsumoto** : Por exemplo, podemos criar um Fechamento a partir de um bloco. Um fechamento é uma função sem nome da maneira como funciona em Lisp. Você pode passar um _objeto_ de uma função anônima, o fechamento, para outro método a fim de customizar seu comportamento. Como outro exemplo, se você tiver um método de ordenação para ordenar um array ou lista, pode passar um bloco para definir como comparar os elementos. Isso não é uma iteração. Isso não é um loop. Mas está usando blocos.

#### Usando Fechamentos

**Bill Venners** : O que torna um bloco um fechamento?

**Yukihiro Matsumoto** : Um objeto de fechamento tem código para rodar, o executável, e estado ao redor do código, o escopo. Então, você captura o ambiente – as variáveis locais – no fechamento. Como resultado, você pode referenciar a variável local a partir do fechamento. Mesmo depois que a função tenha retornado, e seu escopo local tenha sido destruído, as variáveis locais permanecem existindo como parte do objeto de fechamento. Quando ninguém mais referencia esse fechamento ele é coletado como lixo (garbage collected), e as variáveis locais vão embora.

**Bill Venners** : Então as variáveis locais estão basicamente sendo compartilhadas entre o fechamento e o método? Se o fechamento atualizar a variável, o método enxerga isso. E se o método atualiza a variável, o fechamento também enxerga isso.

**Yukihiro Matsumoto** : Sim, variáveis locais são compartilhadas entre o fechamento e o método. É um fechamento real. Não é apenas uma cópia.

**Bill Venners** : Qual é o benefício de um fechamento real? A partir do momento que faço um objeto a partir do bloco, o que posso fazer com ele?

**Yukihiro Matsumoto** : Você pode reconverter um fechamento de volta a um bloco, então ele pode ser usado em qualquer lugar que um bloco pode. Às vezes, fechamentos são usados para armazenar o status de um bloco dentro de uma variável de instância, porque quando você converte um bloco em um fechamento, ele é um objeto que pode ser referenciado por uma variável. E, claro, fechamentos podem ser usados como são usados em outras linguagens, como passar o objeto para customizar o comportamento de métodos. Se você passa algum código para customizar um método, você pode, claro, passar um bloco. Mas se quiser passar o mesmo código para mais de dois métodos – esse é um caso muito raro, mas se realmente quiser fazer isso – você pode converter o bloco em um fechamento e passá-lo para múltiplos métodos.

**Bill Venners** : OK, mas qual é o benefício de se ter um contexto? A distinção que faz do fechamento de Ruby um verdadeiro fechamento é o fato dele capturar contexto, as variáveis locais e assim por diante. Que benefício eu tenho em ter o contexto em adição ao código que eu não recebo por ser apenas capaz de passar um pedaço de código por aí como um objeto?

**Yukihiro Matsumoto** : Na realidade, para dizer a verdade, a primeira razão é para respeitar a história de Lisp. Lisp disponibilizava fechamentos reais e eu quis seguir isso.

**Bill Venners** : Uma diferença que eu consigo ver é que os dados são de fato compartilhados entre objetos de fechamentos e o método. Eu imagino que eu poderia sempre passar quaisquer dados de contexto necessário em um bloco normal, não-fechamento, como parâmetro, mas nesse caso o bloco apenas teria uma cópia do contexto, não a coisa verdadeira. Ele não está compartilhando o contexto. Compartilhar é o que acontece em um fechamento que é diferente do antigo objeto de função.

**Yukihiro Matsumoto** : Sim, e esse compartilhamento lhe permite fazer códigos de demonstração interessante, mas acho que não é tão útil assim no dia-a-dia dos programadores. Não importa tanto assim. A cópia simples, como é feito nos inner classes de Java por exemplo, funciona na maioria dos casos. Mas no caso dos fechamentos de Ruby, eu quis respeitar a cultura Lisp.

