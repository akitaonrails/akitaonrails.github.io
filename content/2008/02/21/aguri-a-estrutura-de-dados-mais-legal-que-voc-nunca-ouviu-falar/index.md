---
title: 'Aguri: A Estrutura de Dados mais Legal que Você Nunca Ouviu Falar'
date: '2008-02-21T22:03:00-03:00'
slug: aguri-a-estrutura-de-dados-mais-legal-que-voc-nunca-ouviu-falar
tags:
- learning
- algorithm
draft: false
---

Fazia **muito** tempo que eu não via um bom artigo sobre Estruturas de Dados. Na verdade, acho que desde o tempo da faculdade eu não lia um texto tão legal. Este achado veio do blog [matasano chargen](http://www.matasano.com/log/1009/aguri-coolest-data-structure-youve-never-heard-of/) e resolvi traduzir para que todos possam apreciar a idéia. Mas avisando: um mínimo de ciências da computação é necessário para entender este texto.

O tema é **Binary Radix Trie**. Segue a tradução:


# 1

Um pouco de remédio de ciências da computação para os auditores PCIs na minha audiência.

Eu lhe dou um array com números inteiros aleatórios. Como você pode me dizer se o número 3 está nele?

Bem, aqui vai a maneira óbvia: cheque os números sequencialmente até encontrar o “3” ou terminar o array. Procura Linear. Dados 10 números, você precisa assumir que isso pode levar 10 passos; N números, N passos.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/22/Picture_1.png)

Procura linear é ruim. É difícil fazer pior do que linear. Vamos melhorar isso. Ordene o array.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/22/Picture_2.png)

Um array ordenado sugere uma estratégia diferente: pule direto para o meio do array e veja se o valor que está procurando é menor (à esquerda) ou maior (à direita). Repita, cortando o array no meio a cada vez, até encontrar o número.

Procura Binária. Dados 10 números, levará não mais do que 3 passos – log 10 (base 2) – para encontrar um deles num array ordenado. Procuras O(log n) são incríveis. Se tiver 65 mil elementos, levará somente 16 passos para encontrar. Dobre o número de elementos, e levará apenas 17 passos.

Mas arrays ordenados são uma porcaria; ordená-los custa mais caro do que procura binária. Então nós não usamos muito procura binária; em vez disso, usamos árvores binárias.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/22/Picture_3.png)

Para procurar numa árvore binária, você começa pelo topo, e se pergunta _“minha chave é menor (esquerda) ou maior (direita) do que o nó atual”_ e repete até ok, ok, ok você já sabe. Mas essa árvore é bonita, não é?

Procura com uma árvore binária (balanceada) é O(log n), como procura binária, variando com o número de elementos na árvore. Árvores Binárias são incríveis: você consegue navega rapidamente de maneira ordenada, uma coisa que não se consegue de uma tabela Hash. Árvores Binárias são uma implementação default para tabelas melhor do que tabelas Hash.

# 2

Mas Árvored Binárias não é o único mecanismo de procura em estrutura de árvore. ‘Binary Radix [Tries](http://en.wikipedia.org/wiki/Trie)’, também chamados árvores PATRICIA, trabalham como árvores binárias com uma diferença fundamental. Em vez de comparar maior/menor em cada nó, você checa para ver se um bit está configurado, indo para a direita se estiver, ou para a esquerda se não estiver.

![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/22/Picture_4.png)

Estou deixando fora muita coisa sobre como binary radix tries trabalham. É uma vergonha, porque radix tries são notoriamente mal documentadas – [Sedgewick](http://en.wikipedia.org/wiki/Robert_Sedgewick_%28computer_scientist%29) os destruiu em “Algorithms”, e a [página na Wikipedia](http://en.wikipedia.org/wiki/Radix_tree) também é uma droga. As pessoas ainda argumentam sobre como chamá-los! Em vez de uma explicação de backlinks e cantos etiquetados com posição de bits, [aqui vai uma pequena implementação em Ruby](http://www.matasano.com/log/basic-uncommented-crappy-binary-radix-trie/)

Eis porque radix tries são legais:

- A performance de procura varia com o _tamanho da chave_, não o número de elementos na árvore. Com chaves de 16-bits, você garantidamente tem 16 passos independente do número de elementos na árvore, sem balanceamento.

- Mais importante, radix tries lhe dá _igualdade lexicográfica_, que é uma maneira de dizer “procura com wildcards” ou “procura parecida com auto-complete de linha de comando”. Em um radix tree, você pode rapidamente procurar por “ro\*” e conseguir “rome” e “romulous” e “roswell”.

# 3

Eu o perdi.

Vamos colocar isso em contexto. Tries são uma estrutura de dados crucial para roteamento de Internet. O problema de roteamento é mais ou menos assim:

- Você tem uma tabela de roteamento com entradas para “10.0.1.20/32 → a” e “10.0.0.0/16 → b”

- Você precisa que pacotes para 10.0.1.20 vão para “a”

- Você precisa que pacotes para 10.0.1.21 vão para “b”

Esse é um problema difícil de resolver com uma árvore binária básica, mas com uma radix trie, você está apenas perguntando por “1010.0000.0000.0000.0000.0001.0100” (para 10.0.1.20) e “1010”. (para 10.0.0.0). Procura Lexicográfica lhe dá o “melhor acerto” para roteamento. Você pode tentar no código Ruby acima; adicione \*"10.0.0.0".to\_ip na trie, e procure por “10.0.0.1”.to\_ip.

A correspondência entre roteamento e radix tries é tão forte que a mais popular biblioteca de uso geral de radix trie (aquele da CPAN) é na realidade roubado da GateD. É uma bagunça, aliás, não use isso.

Se você entende como um trie funciona, você entende como regular expressions trabalham. Tries são um caso especial de autômato finito determinístico (DFAs), onde galhos são baseados exclusivamente em comparações de bits e sempre se divide para frente. Um bom engine de regex apenas manipula DFAs com mais “funcionalidades”. Se minha figura faz sentido para você, as imagens nesse [excelente artigo](http://swtch.com/~rsc/regexp/regexp1.html) sobre o algoritmo de redução NFA-DFA de Thompson também vai, e esse artigo o fará mais esperto.

# 4

Você é um operador de rede no backbone de um provedor. Seu mundo consiste em boa parte de “prefixos” – pares de IPs de rede/netmasks. Os netmasks nesses prefixos são muito importantes para você. Por exemplo, 121/8 [pertence à Coréia](http://www.okean.com/koreacidr.txt); 121.128/10 pertence à Korea Telecom, 121.128.10/24 pertence à um cliente da KT, e 121.128.10.53 é um computador desse cliente. Se estive rastreando um botnet ou uma operação de spam or propagação de worm, o número de netmask é bem importante para você.

Infelizmente, mesmo sendo importantes, em nenhum lugar no pacote IP está estampado um “netmask” – netmasks são completamente um detalhe de configuração. Então, quando você está olhando tráfego, você essencialmente tem esss dados para trabalhar:

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/22/ips.png)](http://www.matasano.com/data.html)

Surpreendentemente, dados pacotes o suficiente para olhar, isso é informação suficiente para adivinhar netmasks. Quando trabalhava na Sony, [Kenjiro Cho](http://www.sonycsl.co.jp/~kjc/) veio com uma maneira realmente elegante para isso, baseado em tries. Eis como:

Pegue uma binary radix trie básica, como os usados por roteadores em software. Mas fixe o número de nós na árvore, digamos, 10 mil. Em um link de backbone, gravando endereços de cabeçalhos de IP, você vai encher 10 mil nós em um instante.

Armazene a lista de nós em uma lista, ordenada em ordem LRU. Em outras palavras, quando bater um endereço IP com um nó, “toque” o nó, colocando-o no topo da lista. Gradualmente, frequentemente vendo endereços borbulhando para o topo, e infrequentemente vendo nós afundando para baixo.

[![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/22/Picture_6.png)](http://www.matasano.com/log/wp-content/uploads/2008/01/Picture_8.png)

Agora o truque. Quando acabarem os nós e precisar de uma nova, reclame de baixo da lista. Mas quando fizer isso, role os dados do nó para cima passando pelo seu pai, desta maneira:

![](http://s3.amazonaws.com/akitaonrails/assets/2008/2/22/Picture_5.png)

10.0.1.2 e 10.0.1.3 são irmãos /32s, as duas metades de 10.0.1.2/31. Para reclamá-los, misture-os em 10.0.1.2/31. Se precisar reclamar 10.0.1.2/31, você pode misturá-la com 10.0.1.0/31 para formar 10.0.1.0/30.

Faça isso por, digamos, um minuto, e as fontes mais fortes vão defender suas posições na árvore ficando no topo da lista LRU, enquanto barulhos ambientes /32 borbulham para /0. Para a lista crua de IP’s acima, com 100 nós, você tem [isso](http://www.matasano.com/data.aguri.txt)

Cho chama essa heurística de Aguri.

# 5

Aguri tem licença BSD. Você [pode fazer download dele](http://www.sonycsl.co.jp/~kjc/software.html) e um programa driver que observa pacotes via pcap, da antiga homepage de Cho.

# 6

Eu vou a algum lugar com isso, mas estou com mais de 1.300 palavras nesse post agora, e se você for uma pessoa de algoritmos, já deve estar cansado de mim agora, e se não for, já deve estar cansado de mim agora. Então, deixe o Aguri afundar, e eu lhe darei alguma coisa legal e inútil para fazer com isso na semana que vem.

