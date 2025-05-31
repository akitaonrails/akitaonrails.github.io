---
title: 'Entrevista com Yukihiro Matsumoto: parte II'
date: '2006-10-14T15:22:24-03:00'
slug: entrevista-com-yukihiro-matsumoto-parte-ii
tags:
- interview
- matz
- translation
draft: false
---

Continuamos com a segunda parte da entrevista com Matz, pela [Artima](http://www.artima.com/intv/tuesday.html).

### Produtividade Dinâmica com Ruby

> #### Sumário
> 
> Yukihiro Matsumoto, o criador da linguagem de programação Ruby, fala com Bill Venners sobre interfaces mórficas, usar mix-ins e os benefícios da produtividade de ser conciso em Ruby.


#### Mudando Interfaces em Tempo de Execução

**Bill Venners:** Em Ruby, posso adicionar métodos e variáveis a objetos em tempo de execução. Eu certamente adicionei métodos e variáveis a classes, que se tornam objetos em tempo de execução, em outras linguagens. Mas em Java, por exemplo, uma vez que a classe está carregada ou um objeto é instanciado, suas interfaces permanecem as mesmas. Permitir à interface mudar em tempo de execução dá um certo medo para mim. Estou curioso em como posso usar essa funcionalidade em Ruby. Qual o benefício de ser capaz de adicionar métodos em tempo de execução.

**Yukihiro Matsumoto:** Primeiro de tudo, você não precisa usar essa funcionalidade. A mais útil aplicação de funcionalidades dinâmicas, como adicionar métodos a objetos, é meta-programação. Essas funcionalidades lhe permitem criar uma biblioteca que se adapta ao ambiente, mas isso não é para uso casual.

**Bill Venners:** Qual é um exemplo de biblioteca que se adapta ao ambiente?

**Yukihiro Matsumoto:** Um exemplo é um proxy. Em vez de planejar classes de proxy individuais para cada classe particular, em Ruby você pode criar um proxy de multi-utilização que pode se ligar com qualquer objeto. O proxy pode pesquisar dentro do objeto e simplesmente se transformar no proxy para esse objeto. O proxy pode adicionar métodos em si mesmo para ter a mesma interface do objeto encapsulado, e cada um desses métodos pode delegar ao método correspondente no objeto encapsulado. Então um proxy de multi-utilização, que pode ser utilizada para encapsular qualquer objeto, é um exemplo de como uma classe de biblioteca pode se adaptar ao ambiente.

Adicionar métodos a objetos pode também ser usado em Ruby em situações onde programadores Java usam _inner classes_. Por exemplo, se precisa passar um objeto _listener_ a algum método, em Java, você normalmente instancia um _anonymous inner class_ que define os métodos do _listener_ e o passa. Em Ruby, você pode criar um objeto plano simples – uma instância da classe _Object_ – adicionar os métodos do _listener_ necessários dinamicamente, e o passar.

Também, porque você pode substituir um método além de adicionar, pode usar essa funcionalidade para definir callbacks. Por exemplo, toda biblioteca OO de interface gráfica tem um objeto _Button_. Quando alguém clica o botão, o método _click_ do _Button_ é chamado. Na classe básica, claro, a implementação do método _click_ é vazio. Para adicionar comportamento ao botão em outras linguagens, você cria uma subclasse de _Button_ e sobrescreve o método _click_. Mas em Ruby, se quiser, você pode diretamente substituir o método _click_ na classe _Button_.

#### Herança Simples e Mix-ins

**Bill Venners:** Em um artigo, você escreveu, _“Ruby suporta somente herança simples, que eu considero uma funcionalidade”_. Porque herança simples é desejável, e o que são mix-ins?

**Yukihiro Matsumoto:** Herança simples é bom porque toda a estrutura de herança de classe forma uma árvore simples com uma raíz simples, chamada _Object_, e isso é muito simples de entender. Em linguagens com múltipla herança, as classes formam redes, que são difíceis de compreender.

Mas mesmo que herança simples seja bom por causa de sua estrutura de árvore simples, algumas vezes queremos compartilhar funcionalidades ou métodos entre classes fora das linhas de herança simples. Nesse caso, em Java, você pode definir uma interface para compartilhar a assinatura dos métodos, então, às vezes implementar algum tipo de delegação de um objeto para outro. Em Ruby, definimos uma coisa chamada _Module_, que é como uma classe, mas com restrições, como: você não pode criar uma instância de um Module, e esta não pode herdar uma classe. Então, em Ruby, se você definir um Module que tem métodos e plugá-lo a uma classe, então essa classe terá todos os seus métodos, tanto assinaturas quanto implementação. Se depois plugar o mesmo Module em outra classe, teremos duas classes que compartilham a mesma implementação. Isso nos dá muitos dos benefícios de herança múltipla, mas sem destruir o modelo de árvore simples da herança simples.

Essa maneira de plugar Modules é chamada _Mix-ins_. Mix-ins originalmente começaram na cultura LISP como um uso de múltipla herança. De fato, um mix-in é uma maneira restrita de usar múltipla herança. Então em LISP, é um estilo de usar múltipla herança. Em Ruby, forçamos você a usar mix-ins suportando classes e modules.

#### Produtividade, Eficiência e Robustez

**Bill Venners:** Em um artigo, você escreveu _“o foco primário de Ruby é produtividade”_. Como Ruby ajuda a produtividade, e sobre eficiência e robustez? Produtividade, eficiência e robustez são todas coisas boas. Como você negocia uma e outra em Ruby?

**Yukihiro Matsumoto:** No meu ponto de vista, eficiência e produtividade são a mesma coisa, porque focamos em eficiência de programação, não eficiência de tempo de execução. Não me importo com eficiência de tempo de execução. Os computadores ficam cada vez mais rápidos, ano após ano, então não me importo muito sobre performance. Na realidade, eu me preocupo com performance quanto estou implementando o interpretador Ruby, mas não quando estou planejando Ruby. O implementador deveria se preocupar com performance, mas o designer não deveria. Se você se preocupa com performance, focará em máquinas no design em vez de humanos. Então você não deveria forcar em performance no design.

Para ajudar os programadores a serem produtivos, eu foco em fazer programas suscintos em Ruby. Eu tento fazer programas compactos. Eu também foco em prover funcionalidades muito ricas em classes de bibliotecas. Se você tem um método em uma biblioteca para fazer as coisas que você quer fazer, não precisa escrever muito código. Em Ruby, também temos blocos, que são funções sem nome que podem ser passadas a métodos. Então podemos prover em bibliotecas templates de padrões comuns de programação, e você pode prover um bloco para customizar o padrão. Blocos são construídos dentro da linguagem Ruby, então pode usá-los muito facilmente. Então, fornecendo um conjunto rico de funcionalidades nas bibliotecas, podemos ajudar os programas Ruby a serem compactos.

Como um exemplo, programadores Perl tem uma técnica chamada de _Transformada Schwartziana_, nomeada depois de Randall Schwartz, que criou a técnica. Você pode usar a transformada se tiver uma lista que quiser ordenar em uma ordem determinada pelo resultado de passar cada elemento da lista em uma função em particular. Por exemplo, você pode querer ordenar a lista de nomes de usuários em ordem crescente de timestamp. A lista que você quer ordenar são strings de nomes de arquivos, mas a ordem é determinada passando cada string a uma função que retorna um timestamp para esse nome de arquivo. Um usuário Perl saberia que isso é um trabalho para a transformada. Eles pegariam um livro e olhariam para um exemplo da transformada, então aplicariam o código de exemplo para seu caso em particular. Mas esse é um tipo de atividade pesada para seu cérebro. Em Ruby, temos uma função sort_by para onde passar uma lista e uma função. Então para realizar uma transformada Schwartziana em Ruby, você não precisa olhar em uma referência, apenas chamar sort_by. Esse é um exemplo de ser conciso, e é muito mais fácil.

**Bill Venners:** Um dos argumentos feitos por tipadores estáticos em tipos estáticos vs tipos dinâmicos é que checagem de tipos em tempo de compilação ajuda programadores a fazer sistemas robustos. O que é a atitude de Ruby em direção à robustez?

**Yukihiro Matsumoto:** A linguagem Ruby por si só não se preocupa com robustez. Na realidade, a implementação do interpretador, que é escrit em C, deve ser robusta. Nenhum código Ruby deve conseguir derrubar o interpretador. Então eu tento fazer o interpretador ser robusto, mas a linguagem em si em seu design não se preocupa com robustez por duas razões. Primeiro, você precisa testar o sistema de qualquer maneira por robustez. Então nós encorajamos testes unitários usando um framework de teste para ajudar a atingir sistemas robustos. A segunda razão é que programas escritos em linguagens dinâmicas são muito fáceis de rodar e checar. Então para programas rotineiros que não são tão sérios quanto sistemas corporativos, você não precisa ser tão robusto. Não vale o custo de declaração de tipos, por exemplo. E porque existem tanta checagens dinâmicas em linguagens dinâmicas, na maioria dos casos alguma coisa muito terrível normalmente não acontece. Por exemplo, Ruby checa os limites de um array, então você não tem buffer overwrites. Ruby não fornece manipulação direta de endereçamento de memória, então você não pode derrubar o espaço da pilha. Então, em Ruby, eu quero ajudar um programador a ter seu programa pronto para teses em um curto espaço de tempo, fazendo-os produtivos.

