---
title: "[Akitando] #94 - O que vem DEPOIS do Hello World | Consertando meu C"
date: '2021-03-22T15:12:00-03:00'
slug: akitando-94-o-que-vem-depois-do-hello-world-consertando-meu-c
tags:
- algoritmos
- estruturas de dados
- complexidade
- Big O
- hashtable
- lista ligada
- array
- memória virtual
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/YyWMN_0g3BQ" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## DESCRIÇÃO

Algoritmos e Estruturas de Dados é parte do conhecimento fundamental que todo programador precisa saber ou nunca vai avançar de verdade na profissão. Vamos ver a ponta do iceberg pra vocês terem uma idéia do que isso significa. E vou aproveitar pra consertar alguns erros que cometi no episódio anterior.

Conteúdo:

* 00:00 - Intro
* 01:47 - Consertando meus erros de C
* 04:13 - Segmentos da Memória Virtual
* 11:53 - Arrays de Javascript são "Arrays"?
* 15:56 - Lista Ligada em C
* 21:37 - Hashtable em C
* 39:11 - Algoritmos de Ordenação
* 42:11 - Complexidade e Big O
* 43:30 - Vendedor Viajante e Fatorial
* 47:29 - Mergesort vs Quicksort
* 52:18 - Melhor e pior caso, Bubble vs Quick
* 55:45 - Livros sobre Algoritmos

Links:

## SCRIPT

Olá pessoal, Fabio Akita



No último episódio eu fiz diversos tipos de Hello World em C pra explicar o básico de programação mais de baixo nível, e foi super trabalhoso porque eu não queria quebrar o  conteúdo em vários episódios. 





Eu não programo em C faz muitos anos então muita coisa enferrujou mesmo. Eu nunca fui um bom programador de C e agora então, só o básico. Eu editei aquele script algumas vezes e mudei os exemplos enquanto fui revisando, e tirei muita coisa de cabeça. Nisso acabei deixando passar vários erros que me deixaram bem frustrado porque eu só vi depois. O bom foi que vários de vocês viram e relataram nos comentários. Eu coloquei algumas na erratas daquele vídeo e vou usar o video de hoje pra complementar o que eu acho que faltou falar.







A ideia destes vídeos não é ser um curso de C, nem de longe. É a mesma coisa na faculdade, C ou Pascal era usado só pra não termos que usar alguma pseudo-linguagem pra ensinar os conceitos. Tem várias nomenclaturas e conceitos que aos olhos de quem programa C no dia a dia ficou feio. Muita coisa eu simplifiquei pra explicação ficar mais fácil. Pra aprender C de verdade tem que ver livros com The C Programming Language do Kernighan e Ritchie, os criadores da linguagem e estudar muito código fonte. 








Se você é programador de C, perdeu uma oportunidade. Podia ter feito um video chamado “Vamos consertar o C cagado do Akita”. É um bom tema. Tem muito pouco video sobre C hoje em dia. De qualquer forma, já que ninguém fez, vou fazer eu mesmo. A primeira metade de hoje vai ser uma errata aproveitando pra adicionar mais conteúdo ao que eu já tinha explicado e a segunda metade vai molhar um pouco os dedos em mais coisas de estruturas de dados e algoritmos que não coube no episódio passado. Então vamos lá.




(...)






Vamos começar com alguns erros pequenos. Tem um que se eu não prestar atenção cometo toda hora sem perceber, até eu acho irritante. Provavelmente porque por muitos anos programei em 32-bits, eu confundo quando converto bits em bytes. Mas é simples, só dividir por 8. Endereços de 32-bits são armazenados em 4 bytes. Mas endereços de 64-bits são 8 bytes. Só que minha memória muscular me ferra.








Aos 6 minutos e 6 segundos do video eu falo que se você alocar um inteiro de 64-bits mas não for usar valores maiores que 255, vai estar desperdiçando 7 bytes desses 8. E isso tá correto. Mas durante a edição a memória muscular ficou me falando “32 bits é quatro bytes”, o que tá errado, e achei que eu tinha gravado falando errado. Daí escrevi uma correção na tela de que iria desperdiçar 3 bytes. Ou seja, eu falei certo na gravação e corrigi errado na edição. A mesma coisa aconteceu aos 45 minutos e 20 segundos que eu falo que é 4 bytes, mas são 8.









Outra coisa que vira e mexe me confundo se falar muito rápido foi como aos 40 minutos e 54 segundos eu falo que 255 BYTES é um quarto de 1 megabyte. Tá errado, lógico, é um quarto de KILObyte. 255 vezes quatro são 1024 bytes, ou um kilobyte. Daí aos 6 minutos e 50 segundos eu falei errado o range de inteiros de 8-bits com sinal, o correto é de menos 128 a positivo cento e vinte e sete. Em hexa é mais difícil de errar porque vai de hexa FF até 7F. 








Mais pro fim, depois dos 57 minutos quando faço a `struct` Person e começo a fazer createPerson escrevi errado `nome` em vez de `name` e ficou meio estranho. Foi um typo feinho mas como não chega a estragar o exemplo em si resolvi não regravar só por causa disso. Pior foi quando dei copy e paste do código de inicialização da struct pra dentro da função createPerson e esqueci os valores hardcoded em vez de usar os argumentos. O código ficou desse jeito aqui, mas o correto deveria ter editado pra ficar assim. Por isso a gente tem que tomar cuidado ao ficar dando copy e paste de código.








Além desses erros menores, o erro que me deixou mais irritado foi perto dos 39 minutos quando eu quis explicar sobre stack e passagem de parâmetros por valor. O exemplo original era com inteiros e nesse caso ela teria sido copiada 3 vezes passando da `main` pra `f1` e depois pra `f2`, mas eu substituí pela string “hello world” e na hora nem pensei muito porque eu tava com pressa, só segui o mesmo exemplo como se o string estivesse sendo duplicado na stack. Obviamente que não tá. E pra explicar, preciso complicar a parte que eu não queria. Quando falei de memória virtual pode parecer que ela é dividida só entre stack e heap, mas na verdade tem mais que isso.









Se eu quiser complicar e mostrar mais, vai ficar deste outro jeito. Seguindo pra baixo do heap a gente tem o segmento BSS que é o block starting symbol, ou que alguns chamam de better save space. Toda variável global estática que só foi declarada mas você não atribui nenhum valor fica nesse espaço, automaticamente inicializado como zero ou nulo. É diferente de quando você usa um `malloc` ou `calloc` que vai pegar algum trecho de memória disponível da heap.








Embaixo do BSS tem mais dois segmentos que interessa pra gente hoje, a ROData e a Text. Esse segmento Text, ao contrário do que você pode entender pelo nome, é o espaço de endereços do seu programa executável propriamente dito, é um segmento de código, das instruções em linguagem de máquina. Agora o segmento ROData é mais interessante pra gente.







Quando eu fiz `char hello[] = "Hello World"` eu tinha dito que isso seria alocado na stack, o string inteiro. Tá errado. Que burro, dá zero pra ele. E até podia ser assim mesmo numa outra linguagem, mas no caso de C, o hello vai ser uma referência pra um endereço que fica nesse espaço chamado `ROData`. Quando o compilador GCC passa pelo meu código fonte, ele vê dados como esse `hello` que é fixo e constante e grava dentro desse segmento no binário final. RO é de Read Only, então ROData é um segmento de dados somente de leitura.








Isso não altera a explicação de passagem por valor. Toda vez que eu passo a variável `hello` como argumento das funções `f1` e `f2`, cada uma vai empilhar uma nova cópia no stack, mas não do string inteiro, e sim dos 8 bytes de endereço que apontam pro array "Hello World" que é fixo, constante e tá dentro do segmento `ROData`. 







Pense nesse segmento com uma versão estática do Heap, que é dinâmico. O ROData é pra valores que você tem hardcoded no seu código fonte. Como strings. Mas strings dinâmicas, por exemplo, de valores que vieram num JSON que você puxou via API, de linhas do banco de dados que você puxou da rede, tudo isso vai ser alocado no Heap e, mesma coisa, os ponteiros pra eles vão sendo empilhados na stack durante a execução do programa.








Quando eu falei do formato ELF binário, que é o linguição de bits num formato específico pro Linux executar, a primeira instrução começa no endereço hexa 1000. Mas no mesmo binário ELF existem outros segmentos que você pode inclusive ver usando o comando no shell `objdump -h` e o executável que acabou de compilar. Então, se passarmos esse objdump no nosso hello vão aparecer todos os segmentos. Você vê que o décimo primeiro é o segmento `init` no endereço hexa 1000 que eu falei antes e na décima quinta posição tem o endereço hexa 2000 que é o segmento ROData.









No video anterior, ignorem quando eu falo que o string inteiro é alocado no Stack. Ele tá no ROData e na stack as variáveis `hello` são referências com o endereço pra esse string. É algo assim. As referências ocupam espaço, pouco espaço se comparado a um arrayzão, mas ocupam. E quando são passadas por valor, de função pra função, vão sendo duplicadas na stack. Três vezes no nosso hello world, cada uma com 8 bytes. Mas não é pra você se preocupar com uso de espaço na stack, isso raramente é um problema. Como eu já tinha dito só quando seu programa é pesado em coisas como recursão.







Outra coisa que eu Não falei no episódio anterior quando expliquei ponteiros é que depois de chamar `malloc` pra alocar espaço no heap, quando você termina o que tinha pra fazer, a boa prática é chamar a função `free`, que avisa o gerenciador de memória que aquele segmento não tá mais em uso e ele pode usar pra outra coisa. Eu não fiz `free` pra explicação não ficar extensa mas também porque o programa executa e sai muito rápido. E quando um programa termina, o sistema operacional se encarrega de tornar toda memória que você tava usando disponível de novo pra outra coisa, independente se você deu free antes ou não. 








Programinhas que executam rápido como um hello world não precisam se preocupar. O problema são programas que ficam abertos muito tempo, digamos um navegador, ou um servidor web. Tirando em exercícios como o hello world, em código de verdade, você DEVE se preocupar com a memória sendo usada porque elas vão ficar em uso por tempo indeterminado. Podem ser horas ou dias e se você ficar dando `malloc` e nunca der `free` a memória disponível no heap vai acabar ou chegar perto de acabar, e quando isso acontece mecanismos como o OOM do sistema operacional pode forçar a parada do seu aplicativo. OOM é o sistema que monitora a memória usada por aplicativos, que significa Out of Memory Killer.









Justamente porque gerenciamento de memória é complicado de explicar, eu já tinha feito dois vídeos que recomendo que vocês assistam. Uma das vantagens de linguagens de mais alto nível com Java, C#, Go e todas as interpretadas como Javascript, Ruby, Python, é que elas tem algum garbage collector, cuja responsabilidade é gerenciar o heap no lugar do programador. Porém, a comodidade vem com um custo: todo garbage collector sempre vai usar mais memória do que se você gerenciar manualmente e causar picos de pausa pra limpeza durante o processamento, o que pode ser um problema pra você. Por outro lado tem menos riscos de vazar memória por causa de código mal feito.








As duas linguagens modernas que tem um bom balanço entre comodidade e não desperdiçar muita memória são o Swift e o Rust. Recomendo estudar o ARC do Swift que é uma ajuda do compilador pra gerenciar memória via contador de referências e o sistema de Borrow do Rust que é o mais diferente de todos.







Voltando aos meus erros, outra coisa que eu falei errado no video anterior foi quando disse que o Stack, ou Pilha, tem dois tipos, LIFO e FIFO e logo na sequência falei que tem Queues ou filas. Eu bobeei aqui, uma cadeia onde a gente vai empilhando elementos no topo e desempilhando do topo é last in first out, LIFO que é uma Pilha. Uma cadeia onde a gente vai empilhando elementos no fim mas vai tirando do começo, ou seja, vai tirando por ordem de chegada, é first in first out, FIFO também conhecido como Fila. Então toda pilha é LIFO e toda fila é FIFO.








Pilhas são usadas na execução de quase todo programa. Filas você vê todo dia no supermercado ou banco, ou se é desenvolvedor web. Todo servidor web tem uma fila, as requisições http vão chegando e sendo enfileiradas e vão sendo servidas na ordem de chegada. Todo job em background usa uma fila. Tudo que você precisa segurar porque não dá pra processar tudo de uma vez usa uma fila. Em sistemas distribuídos é particularmente importante pra coordenar e controlar a carga. Não adianta sua linguagem ser rápida em conseguir iniciar um monte de jobs assíncronos e sobrecarregar a máquina. Você precisa controlar quanto processamento paralelo quer ter num determinado momento, e filas é a estrutura básica por baixo desses tipos de mecanismos de controle.







E antes que alguém comente, eu disse que “quase” toda execução de programas coloca frames no stack mas existem linguagens chamadas stackless, que significa “sem stack”, embora isso não seja totalmente verdade. Inclusive existe uma versão de Python stackless. Não é que elas não usam nada do stack, mas elas criam um stack próprio no heap também. É um assunto longo por si só então só quis mencionar pra quem tiver curiosidade, mas pode ser interessante em casos de muita recursão ou concorrência onde você separa a stack de cada thread pra evitar coisas como condições de corrida.







Continuando, ficou outra dúvida nos comentários sobre arrays, porque eu disse que array é uma sequência contínua de elementos de mesmo tamanho, ou mesmo tipo. Tipo, em C, meio que define o tamanho do elemento. Se for um uint8_t é um inteiro sem sinal de 8-bits, portanto o tamanho é de 1 byte. Uma struct como a Person que eu mostrei, tem 3 campos, uma string de 10 chars, depois 2 ints de 8-bits, portanto 12 bytes no mínimo. O tamanho e formato do binário é definido pelo compilador e não vai ser necessariamente na ordem que eu mostro no exemplo.







Mas num Javascript eu posso fazer arrays conterem strings, números, outros arrays e o que eu quiser. Então ele é um array ou não é um array? Sendo honesto nunca parei pra ver o código em C++ que implementa Arrays de Javascript mas se ele for parecido com a forma que outras linguagens como Java ou C# da vida fazem ele provavelmente é um array de ponteiros mesmo.








Se o espaço do Array acaba e você tenta inserir um novo elemento, ele vai alocar um novo array um pouco maior e copiar todos os elementos da antiga pra nova, e no final liberar o espaço do array original. E todos os elementos dentro vão ser ponteiros, endereços pra objetos que pode ser objeto de string, objeto de número, objeto de array. Esses objetos estão alocados em algum lugar no heap, mas nesse array não vai ter o objeto em si, só o endereço que aponta pra esses objetos. E todos os endereços vão ocupar o mesmo tamanho de 8-bytes, portanto são todos elementos de mesmo tamanho, exatamente o requerimento pra um array.









Se uma linguagem suporta coisas como Generics, daí você consegue limitar um array de objetos pra ter elementos só de um determinado tipo, como Strings, e nunca aceitar um objeto de número por exemplo. Por baixo dos panos, no binário, não faz diferença porque tudo vai ser um ponteiro. Mas importa pra linguagem. Tipos em C eu acho mais importante pra determinar o layout binário das coisas. Tipos em linguagens de alto nível como Java é pra determinar a semântica do seu código.







Se você nunca estudou estruturas de dados sempre vai coçar a cabeça de porque um Java da vida tem classes como ArrayList, LinkedList, Vector, ArrayDequeue, HashSet, e tantas outras que herdam das interfaces de Iterable, Collection, Set e List. Sem conhecimento prévio, à primeira vista, tudo parece só um array.  É impossível eu explicar tudo, mas quero tentar explicar dois tipos diferentes de coleções hoje, que são dois dos mais usados pra vocês entenderem porque tem diferença.








Recapitulando, a grande vantagem de um array é rapidamente encontrar os valores de qualquer posição, com a premissa que você sabe que posição quer acessar. Só pegar o endereço do primeiro elemento e multiplicar pela posição e pelo tamanho do elemento, e por isso é importante todo elemento ser do mesmo tamanho. A desvantagem é se esse array precisa crescer o tempo todo e você não sabe o tamanho final. Daí toda vez que chega no final, precisa criar um outro array maior pra poder continuar, copiar todos os elementos do anterior e liberar essa memória, e ficar fazendo isso até conseguir preencher com todos os dados que precisa.









Vamos fazer de conta que na sua linguagem favorita ele instancia um array de 10 elementos por padrão. Daí você conecta num banco de dados, faz uma pesquisa e começa a vir linhas de dados. Você vai colocando na posição 0 do array, a próxima linha na posição 1, depois na posição 2 e vai indo. Aí preenche as 10 posições mas ainda tem mais linhas vindo do banco de dados. Por baixo dos panos, vai alocar outro array, agora com 20 posições, copiar as 10 da anterior, liberar o espaço dessas 10 antigas e agora você continua preenchendo, posição 10, posição 11 e vai indo.









Digamos que no final vieram 100 linhas da tabela do banco de dados. Pra comportar isso na memória, seu array precisou ser expandido 10 vezes. Ou seja, teve 10 operações de alocar um novo array e copiar o anterior nele. E na última etapa, quando você tinha um array de 90 elementos e acabou espaço, ele precisou alocar um de 100 elementos. Ou seja, num determinado momento você ocupou o dobro de memória, além de ter que fazer operações de alocação e cópia de todos os elementos até 9 vezes. É um desperdício de processamento e de memória. 









Imagina se fosse uma tabela com cem mil linhas. Ou no outro extremo, imagine se você precisasse de 100 arrays que só vão ter 2 elementos cada. Nas no nosso faz de conta, cada array começa com 10 posições pré-alocadas. Agora você tem 800 posições que vão ficar desocupadas, mas ainda assim ocupando espaço na memória. Então a linguagem não pode nem pré-alocar um array grande demais pra pra não ter que processar muitas operações de alocar novo array e copiar tudo e nem pode pré-alocar muito pequeno pra economizar memória. É um dilema, por isso sempre que possível você deve iniciar arrays dizendo pra ele quanto de espaço pretende usar.








Se você está no caso de listas que vão expandir e você não sabe quanto, pode escolher não usar arrays. Vamos começar usando o struct que aprendemos e criar uma chamada `Node` que traduz pra um nó, em português. Dentro vamos criar dois elementos, um valor inteiro pra guardar qualquer número, e eu vou usar número só porque Strings em C puro é mais chatinho e ia complicar o exemplo, mas eu recomendo de lição de casa vocês tentarem fazer o valor do nó ser um String. O próximo elemento é mais importante, vou chamar ele de `previous` pra apontar pro nó que foi criado antes desse. Esse é o truque da lista ligada, é uma lista que liga elementos um atrás do outro ou um na frente do outro, como você preferir.




```
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

struct Node {
	int value;
	struct Node *previous;
};

struct Node* createNode(int value, struct Node *previous) {
	struct Node *node = (struct Node*) malloc(sizeof(struct Node));
	node->value = value;
	if (previous) {
		node->previous = previous;
	}
	return node;
}

void main() {
	struct Node *first = createNode(2020, NULL);
	struct Node *second = createNode(2021, first);
	struct Node *third = createNode(2022, second);


	struct Node *iterator = third;
	while(iterator) {
		printf("%d, ", iterator->value);
		iterator = iterator->previous;
	}
}
```




Pra facilitar, vamos criar uma função que aloca e inicializa um nó, semelhante ao que fizemos no video anterior com a struct Person. Como argumentos ele vai receber um valor inteiro qualquer e o nó que foi criado antes pra ele apontar pra ele. Dentro vamos usar `malloc` pra alocar essa nova struct, depois preenchemos o campo `value` com o que veio como primeiro argumento e checamos se o segundo argumento veio nulo. No caso, o primeiro Node criado não aponta pra ninguém, então deixa ele nulo, senão preenche o campo `previous` pra apontar pro nó que passamos.





Agora no `main` vamos criar 3 nodes bestas, um com valor de 2020 e mandando NULL que é nulo, porque é o primeiro nó. O segundo nó vai ter 2021 e passamos a referência pro `first` que criamos antes. Mesma coisa pro terceiro nó que passamos o valor 2022 e a referência do segundo nó. Agora que a coisa fica interessante.







Vou criar um quarto ponteiro, chamado `iterator` que vai apontar pro mesmo endereço da variável `third`, a última. Assim começamos um loop que vai parar quando a variável `iterator` for nulo. Nulo em C e várias linguagens interpreta pra `false` e quando der isso o loop `while` vai sair. A cada rodada do loop vamos imprimir o valor inteiro do nó na tela separado por vírgula usando nossa conhecida função `printf`. Pra quem não sabia ele formata os valores que passamos pra ele. Então "%d" é de decimal, daí ele formata números. No vídeo anterior eu usei "%x" que formata números como hexadecimais e "%s" é pra interpretar como um string mesmo.








E finalmente, depois de usar o valor do node, fazemos a variável iterator apontar pro endereço que tá no campo `previous`. Como o iterator começou sendo a variável third, e como o previous dela aponta pro endereço que tava na variável second, é isso que ele vai se tornar. Daí o loop volta pro começo, checa que a variável iterator ainda não é nulo e imprime o valor que tá na struct apontada por second. Finalmente fazemos o iterator ser o endereço que tá no campo previous desse second, que vai ser o first, e repetimos o loop.







Como o iterator agora aponta pra mesma struct que a variável first, ela continua não sendo nula. Imprime o valor de first, e o iterator vai ser o que estiver no campo previous dela. Como ela foi a primeira a ser criada e passamos NULL no segundo argumento quando criamos, ela não aponta pra mais ninguém. Agora o iterator vai ser NULL e isso vai parar o loop do `while`, e também vai terminar a função main porque não tem mais nada pra fazer, então o programa acaba e sai.








Um Node ligado a outro Node forma uma lista de Nodes ligados. Por isso falamos em Lista ligada que é outra estrutura de dados importante na computação. Ela tem várias vantagens em cima de um array. Pra começar, é fácil adicionar novos nodes. Só alocar uma struct no Heap e fazer o campo de ponteiro dela apontar pro último nó que foi criado. Assim não precisamos pré-alocar espaço que não vamos precisar. Mais do que isso. Já pensaram como faz pra inserir um elemento novo no meio de um array?







Como o array é sequencial e fixo, você é obrigado a fazer alguma coisa como copiar todos os elementos do meio pro final pra outro lugar, inserir o valor novo no meio, e copiar todos os elementos que guardamos de volta. Vai desperdiçar espaço e processamento. No caso de uma lista ligada basta alocar uma nova struct e mudar os ponteiros dos nodes ao redor da posição onde queremos inserir. Fazemos o elemento seguinte apontar pra ele e a nova struct apontar pro elemento anterior e pronto, inserimos no meio. O custo de inserir um novo elemento no meio é praticamente igual a inserir no fim, e independe do tamanho da lista.








Mas então, porque não usamos listas ligadas pra tudo? Porque ela tem uma grande desvantagem. Repetindo, num array, pra eu pegar o valor do centésimo elemento, basta pegar o endereço do primeiro e multiplicar o tamanho de cada elemento vezes 100 e imediatamente chegamos. Mas numa lista ligada, preciso pegar a primeira struct, e ir seguindo os ponteiros pro próximo elemento 100 vezes. Então quanto maior for a lista ligada, mais lento vai ser achar elementos nela, porque cada struct fica em algum lugar aleatório no heap e não tem como achar só com aritmética de ponteiro.








Arrays e Listas Ligadas, à primeira vista, especialmente se tiver poucos elementos, funcionam praticamente igual. Você nunca vai notar a diferença de operações ou performance porque mexer em listas de 10 elementos, cem elementos, mesmo mil elementos, é muito rápido na sua máquina. Mas quando você conecta num banco de dados, ou precisa processar centenas de arquivos grandes, e precisa alocar listas pra manipular todos esses dados, usar arrays ou listas vai fazer uma grande diferença de performance. E sem saber como elas funcionam, você jamais vai entender o que tá dando errado.








E tem outras estruturas importantes. A próxima que eu quero explicar pra você é um Map, ou HashMap ou Hashtable ou dicionário. Tem vários nomes por diversas particularidades de implementação. Na maioria das linguagens você provavelmente chama só de Hash. É quando você cria uma lista, mas em vez de navegar nela direto por posição, navega usando uma chave. 







Em Javascript é o que você chamaria de objeto JSON. Por exemplo, podemos criar uma variável person com os campos name, age e city, preencher com Fabio, 43, Sao Paulo e podemos acessar os valores com a sintaxe de colchetes que nem um array mas passando o nome do campo, como "age" e ele devolve 43. Se você não sabia disso, apesar da sintaxe parecer um array, isso não é um array e por baixo funciona bem diferente.








Existem diversas formas de implementar Hashtables. Quero mostrar uma forma rudimentar em C. Antes vamos ver como se usa. Na função `main` eu quero alocar primeiro uma struct chamada Hash que vamos criar depois. Daí vamos criar uma função chamada `insertNode` que recebe o ponteiro pra esse hash e vamos inserir alguns dados. Primeiro um valor "world" com uma chave "hello". Se fosse javascript seria hash abre colchetes, daí "hello" igual "world". Apesar da sintaxe não ser bonitinha com colchetes, pense no funcionamento como sendo a mesma coisa do equivalente em Javascript.








Vamos fazer mais um `insertNode` pro mesmo hash, mas com chave "Fabio" e valor "Akita". Agora vamos imprimir na tela esses valores procurando pela chave. Se fosse javascript seria o equivalente a um console ponto log entre parênteses hash colchetes com a chave "hello". Mas a gente vai fazer uma função chamada `search` que recebe como parâmetro o ponteiro do mesmo hash e a chave "hello". Daí passamos o valor que ele vai retornar pro `printf` imprimir na tela.



```
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define HASH_SIZE 100

struct Node {
	char *key;
	char *value;
	struct Node* next;
};

struct Hash {
	struct Node *list[HASH_SIZE];
};

unsigned int hashCode(char *key) {
	unsigned long hash = 5381;
	unsigned int c;
	while(c = *key++) {
		hash = ((hash << 5) + hash) + c; // hash * 33 + c
	}
	return hash % HASH_SIZE;
};

struct Node* createNode(char *key, char *value) {
	struct Node *node = (struct Node*) malloc(sizeof(struct Node));
	node->key = key;
	node->value = value;
	return node;
};

void insertNode(struct Hash *hash, char *key, char *value) {
	unsigned int index = hashCode(key);
	struct Node *node = hash->list[index];
	if(node == NULL) {
		hash->list[index] = createNode(key, value);
	} else {
		while(node) {
			if (node->next == NULL) {
				node->next = createNode(key, value);
				break;
			}
			node = node->next;
		}
	}
};

char* search(struct Hash *hash, char *key) {
	unsigned int index = hashCode(key);
	struct Node *node = hash->list[index];
	while(node) {
		if (strcmp(node->key, key) == 0) {
			return node->value;
		}
		node = node->next;
	}
	return "";
}

void main() {
	struct Hash *hash = (struct Hash*) malloc(sizeof(struct Hash));
	insertNode(hash, "hello", "world");
	insertNode(hash, "Fabio", "Akita");

	printf("%s\n", search(hash, "hello"));
	printf("%s\n", search(hash, "Fabio"));
}


```



Agora sabemos que precisamos implementar uma struct chamada Hash e pelo menos duas funções, a `insertNode` e a `search` que é procurar em inglês. Vamos começar pela struct Hash que vai conter uma variável chamada `list` que é um array de ponteiro pra struct chamado `Node`. O hashtable vai ser implementado com um array de tamanho fixo. Na prática nem precisava ser uma struct Hash, eu podia só ter criado direto um array, mas só pra ficar mais fancy.







Só pra ficar menos feio vamos definir essa constante 100 com o nome de HASH_SIZE lá em cima usando o pré-processamento #define, que eu expliquei no episódio anterior. É uma forma de não largar números mágicos por aí. Quando passarmos pelo compilador, imagine que vamos dar copy e paste do número 100 no lugar desse nome HASH_SIZE.









Agora temos que implementar a struct principal, que é a `Node` que vai conter os campos principais de chave e valor que são as strings `key` e `value`. Depois, como na lista ligada, um ponteiro pra `next` que vai ser o próximo Node na cadeia. De propósito antes eu mostrei uma lista ligada que vai apontando pro Node anterior. Aqui vai ser uma lista ligada na direção oposta, apontando pro próximo Node mais novo, só pra mostrar que tanto faz a direção. Dependendo do exemplo que você achar por aí vai ter jeitos diferentes de implementar.








Agora vamos implementar a função mais importante de um hashtable que é a função que converte a chave num identificador numérico. No nosso caso a chave vai ser só strings. Esse número identificador é o que chamamos de hash e eu expliquei mais sobre hashing nos episódios de criptografia, então dêem uma olhada depois. Grosseiramente é como se fosse um gerador de números aleatórios ou random, onde o seed ou semente é o valor da tal chave.









Gostaríamos que essa função de hash devolvesse números o mais aleatório possíveis, ou seja, cuja distribuição estatística seja próxima de uma curva normal ou gaussiana. Se não entendeu isso, coloque na lista estudar estatística básica. A razão disso é simples. A struct Hash que criamos vai conter um ponteiro pra um array de tamanho fixo. Num hashtable podemos inserir mais elementos do que o tamanho do array. A mágica pra isso começa em transformar a chave que é um string num número entre 0 e 99. Uma função de hash pega, por exemplo, a string "hello" e converte num número, por exemplo esse numerozão aqui do lado.









Pra isso vamos fazer uma função chamada `hashCode` que recebe essa chave. Se você é de Java já viu esse nome. Dentro começamos declarando um número mágico, no caso cinco mil trezentos e oitenta e um. Poderia ser qualquer número. Depois declaramos uma variável chamada `c` que a cada rodada do loop vai pegando uma letra da chave. Esse loop vai repetindo até acabar as letras da chave e o `c` ficar nulo e parar o loop.








O cálculo dentro do loop não é importante pra hoje, tem várias outras formas. Em particular neste exemplo começa com o valor inicial da variável hash que é o cinco mil e tantos acima. Daí multiplicamos por 33 que é o mesmo que fazer bitwise shift pra esquerda de 5 bits, somamos ao hash original junto com o endereço da primeira letra. E vamos fazendo isso letra a letra até o loop parar. No final vamos ter um numerozão que identifica essa chave. Esse número pode ser bem maior do que o tamanho do array e a gente gostaria que fossem posições válidas dentro do nosso array.









Sempre que você tem um range ou sequência limitada, no nosso caso que vai de 0 a 99, mas temos um número maior que isso, pra caber, usamos a operação de módulo. E aqui é mais um exemplo de porque matemática importa. Vamos precisar de módulo. Na prática um módulo faz um wrap. Qualquer número módulo 100, vai devolver um número menor que 100. Daí podemos usar isso como um índice ou hash. Toda chave sempre vai chegar no mesmo hash, mas a partir do hash não temos como voltar ao valor original da chave. 







O cálculo do exemplo chamado de djb2. Não é o único e nem é o melhor, mas é fácil pra explicar pra hoje em uma linha só. Lembram quando eu disse que vídeos como esse e qualquer outro tutorial e curso priorizam a facilidade da explicação? Entenda que existem outros algoritmos mais sofisticados do que multiplicar por 33 e ir acumulando. Especialmente algoritmos estatisticamente melhor distribuídos. Mas por agora, o importante é entender que esta é uma das maneiras de converter um string num número e com o módulo, garantidamente devolver uma posição dentro do Array.









Antes de continuar, vamos criar uma função que instancia e popula uma struct Node. Podemos chamar de `createNode` que recebe como argumentos os strings de chave e valor, `key` e `value`. Dentro fazemos `malloc` pra reservar espaço pra essa struct. Em seguida populamos os campos `key` e `value` da struct com os valores que recebemos de argumento. Bem simples. Vamos manter o campo `next` da struct como nulo.





Como aprendemos no episódio anterior, ao usar a notação de setinha que é um traço e sinal de maior, ele acessa o valor do ponteiro de item que é a struct de Item que tá em algum lugar no Heap. Essa sintaxe de setinha é equivalente a fazer asterisco variável entre parênteses e usar a notação de ponto. Mas setinha fica mais bonito.









Finalmente chegamos ao filé mignon da explicação implementando a função `insertNode` que vai de fato armazenar o par de chave e valor dentro do nosso array fixo. Começamos com função `hashCode`, passando a `key` que veio como argumento e achando a posição numérica dentro do array, que vai ser essa variável `index`. Continuamos declarando uma variável node que vai apontar pro primeiro Node na posição index do arrayzão. 






A lógica vai assim: se no array da estrutura de hash, na posição que chamamos de `index`, não existir nada, se for nulo, então criamos um novo Node com a função `createNode`, passando key e valor e armazenamos o endereço desse Node na posição `index` do Array chamado `list` dentro da estrutura que chamamos de hash.








Caso contrário, se na posição `index` já existir um Node, temos duas opções. Se no campo `next` desse Node não existir nada, for nulo, chamamos `createNode` pra criar um Node e associamos seu endereço no campo `next`. Agora temos uma lista ligada de dois elementos. Podemos quebrar o loop e sair fora. Se a lista tiver mais de um elemento já, esse `next` já vai estar apontando pra outro Node. Então fazemos a variável `node` apontar pra esse `next` e repetimos o loop, até achar o último Node cujo `next` é nulo e nele associamos nosso novo Node.







Essa nossa variável `list` na struct Hash não é um array simples como mostramos até agora. É um array onde cada posição vai apontar pra uma lista ligada, ou seja, é tipo uma matriz. O conceito é assim: cada lista ligada pode ter quantos elementos quisermos. Daí nesse array fixo vamos conseguir colocar mais elementos do que o tamanho total de posições só do array. Estamos combinando o melhor do array com o melhor da lista ligada numa estrutura só.








Outro conceito importante é que o número que o `hashCode` devolve identifica uma ou mais chaves. Já disse que ela não é única pra cada chave. Especialmente porque fazemos o módulo do hash pra ter a posição do array. Se múltiplas chaves podem chegar no mesmo número significa que mais cedo ou mais tarde vamos ter uma colisão, ou conflito. Esse é o termo mesmo. Quando acontecer uma colisão, dois Nodes vão competir pela mesma posição no array. 







Vamos dar um exemplo, faz de conta que queremos inserir um valor "bla" com uma chave "abc". E faz de conta que queremos inserir outro valor "foo" com uma chave sendo "xyz" e agora o principal, faz de conta que o cálculo da nossa função `hashCode` devolva o número 42 pra ambos os strings. Vamos simular um caso de colisão. 








Da primeira vez, vamos pra posição 42 do array `list` e apontamos pra uma struct Node com a chave sendo 'abc' e valor sendo 'bla'. Na segunda tentativa o hash da chave 'xyz' devolve o mesmo índice 42, mas na posição 42 do array já tem o Node com chave "abc", então criamos um novo Node e fazemos o primeiro apontar pra ele. Agora temos os dois armazenados na posição 42 do array, entenderam? 






Pra ficar claro, digamos que queremos incluir um terceiro par de valores cuja chave é “foo” e o valor é “bar” e de novo, faz de conta que o hashCode pra essa chave “foo” seja 42 também. Agora já existe uma lista ligada nessa posição do array. Começamos do primeiro Node com chave “abc”. O `next` dela aponta pra outro Node, com a chave “xyz” e agora o `next` é nulo, portanto é o fim da lista. Basta fazer esse `next` apontar pro novo Node com chave “foo” e pronto, adicionamos mais um elemento no hashtable. É isso que acontece num caso de várias chaves colidirem e competirem pela mesma posição no array. 






De volta ao exemplo, na função `main` usamos a função `insertNode` duas vezes, na primeira pra inserir o par com chave `hello` e valor `world` e na segunda vez pra inserir o par com chave `Fabio` e valor `Akita`. A chave `hello` passando pela nossa função hashCode devolve o número 41 e passando a chave `Fabio` devolve o índice 90. Ou seja, a posição 41 do array `list` vai apontar pra uma instância da estrutura Node com o valor "world" e na posição 90 do array `list` vai existir outra instância de Node com o valor `Akita`.









Só pro nosso exemplo ficar mais interessante faz de conta que antes de inserir a chave `hello` já tinha um Node com chave `ano` e valor `2021` e faz de conta que se passarmos a string `ano` pra função hashCode vai dar o número 41. Daí a gente tenta inserir a chave `hello` e valor `world` e passando `hello` em `hashCode` sabemos que volta 41 também. Criamos um novo Node com a chave “hello” e colocamos seu endereço no ponteiro `next` do Node chave `ano`. 






Esse é o mecanismo. O pior caso é quando a função de hashCode dá colisões demais e a maioria dos elementos que tentamos inserir acaba na mesma posição do array, e aí fica desbalanceado, por isso escolher a melhor fórmula vai fazer diferença e por isso eu falei em uma função que tivesse uma distribuição gaussiana, onde na média, cada posição do array vai ter mais ou menos o mesmo número de elementos.









Finalmente, uma vez inserido, e se a gente quiser achar o valor que corresponde à chave `hello`? Vamos criar a função `search` que devolve um ponteiro pra uma String, que vai ser esse valor. E como parâmetro vamos receber a referência pra struct Hash que contém o array `list` e como segundo parâmetro um ponteiro pra string que contém a chave que estamos procurando, no caso "hello".






De novo, começamos calculando o tal hash da chave "hello" que já sabemos que vai ser 41. Daí pegamos o primeiro Node da lista ligada que tá na posição 41 do nosso array `list`. Agora começamos um loop. Enquanto a variável `node` não for nulo, entra no corpo do Loop. Dentro comparamos o valor da chave nesse Node com a chave que recebemos no parâmetro da função usando essa função do C chamada `strcmp` ou string compare, que vai devolver `zero` se as duas strings que passamos tiverem o mesmo valor.








No nosso exemplo vai dar false porque o primeiro Node contém um Item cuja chave é `ano`. Sendo assim, pulamos esse `if` e fazemos a variável `node` apontar pro `next` do atual. Repete o loop, a variável `node` ainda não é vazio. No `if` comparamos de novo o string do campo `key` com a variável `key` do parâmetro. E como esse segundo Node contém a chave `hello`, o `strcmp` vai dar verdadeiro e podemos retornar o campo `value` do Node, que vai ser `world`.








Pronto, em conceito é mais ou menos assim que funciona um hashtable pra inserir e procurar um Node. E é assim que conseguimos inserir centenas ou milhares de itens num array que é limitado em cem posições. Toda vez que tiver uma colisão de chave, anexamos o Node no final da lista ligada nessa posição do array. E quando for procurar a chave, calculamos o hash que dá a posição no array e vamos seguindo a lista ligada que está lá até encontrar o Node com a chave que procuramos.









A essa altura você deve estar pensando, "por que todo esse trabalho"? A vantagem é que se nosso array estivesse todo cheio, e quisermos achar onde tá o Node com a chave “hello”, rapidamente sabemos que tá na posição 41 do array, porque o cálculo do hash independe de quantos elementos existem. Mesmo se a hashtable tiver 200 Nodes já, chegamos na posição 41 com um simples cálculo. Daí só precisamos fazer mais 2 comparações de chaves na lista ligada pra ir de next em next até chegar no Node com chave “hello” e vamos achar o valor “world”.







Se usássemos só um array pra inserir 200 elementos, mas o array começa com 10 elementos pré-alocados, ia precisar expandir e copiar todos os elementos do array 20 vezes. Mas pra achar um valor numa posição específica é rápido. Por outro lado, se usássemos uma lista ligada pra inserir os 200 elementos, a inserção seria super rápida e econômica. Mas pra procurar teríamos, no pior caso, que vascular 200 elementos. Mas juntando o array com a lista ligada, diminuímos consideravelmente tanto o tempo de inserção quanto o tempo de procura.








Mas da forma como implementamos, não só agora eu posso usar uma string como chave em vez de um número, como estamos segmentando, ou seja, dividindo a lista ligada dentro de um array fixo. E isso nos dá o meio do caminho do melhor dos dois mundos entre um array e uma lista ligada. Não vamos desperdiçar memória e processamento tendo que duplicar o array toda vez que chega no fim. E ao mesmo tempo podemos procurar itens razoavelmente rápido porque em vez de vasculhar uma lista ligada inteira, vamos vasculhar só um trecho dela.








Então, toda vez que você fizer um hash em Javascript ou outras linguagens que suportam essa sintaxe de colchetes, por baixo dos panos é algo parecido com isso que tá acontecendo. Nessa nossa implementação rudimentar, esse `search` passando o `hash` e argumento `hello` seria o equivalente no Javascript a escrever `hash` colchetes e `hello` dentro.







Falando em Javascript, muitos que estão iniciando os estudos agora talvez já tenham visto exercícios implementando coisas como listas ligadas ou hashtables em Python, Javascript ou outra linguagem de alto nível. E de fato, eu poderia implementar exatamente esse hashtable que fiz em C só que em vez de usar structs eu poderia usar classes. Daí você poderia ter a péssima idéia de usar esse hashtable que escreveu em vez de usar a que já vem por padrão na linguagem.








Isso é uma má idéia porque nenhuma versão de hashtable que você escrever em Python puro vai ser mais rápido do que a que já vem nela. A explicação é simples. Vamos ver como o Python implementa o hashtable, que ele chama de `dict`. O Python mais usado é o CPython, e esse nome é porque o Python é escrito em C. E se a gente for no GitHub e vasculhar o código fonte do CPython vamos achar o arquivo `dictobject.c` que, chan chan chan chan, é escrito em C. Esse em particular tem mais de 5 mil linhas de C. Por isso eu repito, o exemplo que eu dei antes é uma simplificação rudimentar pra ser didático de explicar. Pra ver o de verdade, você precisa ver esse do Python.









A mesma coisa vale pra todas as estruturas de dados a algoritmos básicos de ordenação, procura e coisas mais avançadas como criptografia que o Python te dá. Arrays, listas ligadas, sets que são conjuntos e muito mais. E a mesma coisa acontece em todas as outras linguagens de alto nível como Ruby, como Javascript. Eu disse no episódio anterior que elas são ótimas linguagens pra colar estruturas feitas em C ou C++ com uma sintaxe de mais alto nível e mais fácil de usar. É isso que eu quero dizer.








Se você estudou ou for estudar a matéria de estruturas de dados e algoritmos, vai aprender a operar essas estruturas. Até agora eu só mostrei a coisa mais trivial que é inicializar e popular as estruturas. Mas e se quisermos procurar elementos num array gigante? Ou se quisermos ordenar em ordem alfabética? Daí você começa a aprender sobre algoritmos. Sem ter estudado nada, pense, como você ordenaria um array?








Ordenação é um dos tópicos da matéria e normalmente o primeiro algoritmo que você aprende é o famigerado bubblesort. Pra acelerar o código é este aqui do lado. Mas só ver o código talvez não ajude muito. Se você procurar no Google por sorting algorithms animation vai achar vários sites que mostram uma versão animada de como cada uma funciona. Vamos ver um bubble sort em ação. Conseguem ver como ele vai comparando pares de números e fazendo os números maiores irem pra direita? Compara um par, se o da esquerda for maior que o da direita, faz um swap e troca eles de lugar e vai fazendo isso até o fim da lista, e repete, até tudo estar ordenado.



```
#include <stdio.h>

void main() {
	int total = 15;
	int array[] = { 40, 55, 11, 32, 67, 5, 74, 89, 38, 66, 27, 36, 79, 99, 2 };

	int i, j, swap;

	for(i = 0; i < total - 1; i++) {
		for(j = 0; j < total - i - 1; j++) {
			if(array[j] > array[j+1]) {
				swap = array[j];
				array[j] = array[j+1];
				array[j+1] = swap;
			}
		}
	}
	printf("Ordenado: ");
	for(i = 0; i < total - 1; i++) {
		printf("%d, ", array[i]);
	}
	printf("%d\n", array[i]);
}
```




No exemplo em C é assim. Começamos declarando uma variável total como sendo um número hardcoded 15 e em seguida criamos um array de 15 números fora de ordem qualquer. Daí precisamos de 3 variáveis inteiros pra ajudar, um chamado `i`, outro `j` e um chamado `swap`. Começamos um loop fazendo o `i` ir de 0 até o total menos um que é 14. Lembrando que arrays em C começam de 0 e vai até o total menos 1. Então um array de 15 elementos vai ter posições de 0 até 14.








Dentro tem outro loop, fazendo `j` ir de 0 também até o total menos `i`. Isso porque dentro comparamos o elemento na posição `j` com o seguinte que é `j` mais um, então não pode ir até o último senão vamos tentar pegar um décimo sexto elemento que não existe e vai dar pau. Daí comparamos entre o elemento na posição `j` com o de `j` mais um e se o de `j` for maior, fazemos o swap. Swap nesse caso é guardar o elemento de j mais um, copiar o elemento de j pra j mais um, e na posição j gravar o que tava na variável swap. Em outras linguagens tem como fazer swaps assim com uma operação só, mas por baixo dos panos sempre vai ter uma variável intermediária.








Se achou complicado depois tente você mesmo executar esse código em C com diferentes arrays, usando `printf` em cada etapa pra ver o que tem nas variáveis `i` ou `j` e o que tem no array nesses posições pra entender o que tá acontecendo. Mas o importante é entender o seguinte. Temos um loop dentro de outro loop percorrendo todos os elementos do array. Na primeira passada tem 14 comparações. Na próxima passada, o `i` vai ser 1 então total menos 1 menos 1 são 13 comparações. Na passada seguinte o `i` vai ser 2 então total menos 2 menos 1 são 12 comparações e vamos assim até o `i` ser igual a `14` e acabar.








Ou seja, vamos ter 14 mais 13 mais 12 mais 11 e assim por diante, que vai dar 105 comparações. Se colocarmos um contador no começo do código e ir incrementando dentro do segundo loop, no final podemos imprimir e ver que vai dar 105. Pra somar todos os número de 0 até N precisamos da matemática de análise combinatória. A fórmula é n vezes n menos 1 dividido por dois. Então 15 vezes 14 dividido por 2 é exatamente 105. Sendo essa fórmula da ordem de grandeza de N vezes N ou seja N ao quadrado, também dizemos que esse algoritmo tem complexidade quadrática.










Complexidade de tempo de um algoritmo é uma das coisas que você mais vai ver quando se compara algoritmos que fazem a mesma coisa. Por exemplo, no caso de ordenação de arrays, temos esse simples que é o Bubblesort e na média tem complexidade quadrático que escrevemos na notação big-O como sendo O n ao quadrado. Outros algoritmos melhores como o Mergesort ou Quicksort, na média tem complexidade O n vezes log de n ou logarítmico. E aqui eu vou falar de complexidade sem ser formal, então se você é matemático perdoe minha nomenclatura mais solta.








Complexidade é outro aspecto da matéria que vocês precisam entender. E pra resumir bem curto existem gráficos como este que compara os principais tipos. Se não me engano o pior tipo seria fatorial, que nem aparece aqui. No caso do nosso exemplo de 15 elementos, se nosso algoritmo fosse extremamente mal feito onde a ordem de grandeza fosse o fatorial de 15, o número de operações seria de 15 vezes 14 vezes 13 vezes 12 etc e isso dá mais de 1.3 trilhão de operações. Comparado com as 105 do bubblesort, que já é ruim, seria totalmente inviável.









Um exemplo de um algoritmo fatorial? É o próprio código da forma recursiva ingênua que calcula o resultado de um fatorial, que você encontra de exemplo em tudo que é lugar. Outro problema famoso que você aprende na faculdade é o do vendedor viajante, “the travelling salesman” resolvido usando força bruta. Tem até de fato um algoritmo de ordenação que de propósito foi feito pra demonstrar um caso fatorial, que é o snailsort, que pra cada elemento ele faz uma permutação de todos os outros elementos. Tudo que envolve permutações que são combinações de todos os elementos com todos os elementos, têm chances de ser fatorial.









Aliás, o algoritmo do vendedor viajante é o problema do sistema de logística de qualquer Amazon da vida. O caminho mais curto pra passar entre diversos endereços ou cidades diferentes. O jeito mais ingênuo de fazer isso, via força bruta, tem complexidade fatorial, ou seja, é absurdamente caro de processar porque a força bruta seria fazer a permutação de todas as possibilidades de rotas entre todos os pontos de destino e no final comparar pra achar a mais curta. E um algoritmo um pouco melhor vai cair de complexidade fatorial pra exponencial, que continua sendo lento. 









Esse em particular é da categoria de problemas considerados NP Hard. Problemas ao redor de NP ou “tempo não polinomial” é uma coisa que eu mesmo tenho intuição mas não tenho bagagem matemática pra discutir formalmente. Só entenda que existem diversos problemas matemáticos que não tem uma fórmula simples. Pior, custam complexidade fatorial pra resolver. 






Existem problemas P, NP, NP Complete, NP Hard. Problemas P podem ser resolvidos tem tempo polinomial, problemas NP são não-determinísticos cujos resultados podem ser verificados em tempo polinomial. Não se preocupe muito com isso no começo, basta saber que isso existe.







Mas voltando ao que nos interessa, acessar uma posição num array é complexidade constante, ou seja, não importa se o array tem 10 elementos ou 10 mil elementos, sabendo a posição, recuperar um valor custa sempre o mesmo tempo. Agora, procurar um elemento numa posição de uma lista ligada é complexidade linear, depende do tamanho da lista. Como não dá pra fazer aritmética de endereço, porque os elementos não são sequenciais um atrás do outro, a gente precisa ir de Node em Node seguindo o endereço pro próximo. Então pra achar o décimo Node de uma Lista Ligada onde só temos o endereço do primeiro Node, precisamos fazer a operação de seguir pro próximo ponteiro 9 vezes. 










Pra achar o vigésimo elemento precisamos seguir ponteiros 19 vezes no pior caso, e assim por diante, ou seja, o tempo que vai custar depende da quantidade de elementos, por isso a ordem de grandeza é chamado de linear, que no gráfico de comparação é a linha que cresce igual nos eixos x e eixo y. Imagina carregar um arquivo com palavras, quebrar num array, e procurar uma palavra. Sem saber coisas como busca binária ou qualquer tipo de indexação via hashing ou algo assim, você vai primeiro fazer um loop e vasculhar elemento a elemento até achar o que procura. Isso é mais ou menos linear, lógico depende do que mais você processa, mas estou falando de ordem de grandeza do caso simples.










Agora, na categoria de logarítmico, estão coisas como busca binária, que eu não expliquei e não pretendo detalhar hoje pra não alongar. Mas pensa assim. Em vez de procurar um a um linearmente, você pode usar a estratégia de segmentar a procura quebrando sua lista primeiro ao meio, e recursivamente ir procurando em listas da metade do tamanho e cada pedaço. É meio que a estratégia de dividir pra conquistar. Imagina uma função chamada `pesquisa`. E dentro dela você quebra a lista em duas e passa cada metade pra mesma função `pesquisa`, e vai fazendo isso recursivamente. É a base da idéia de busca binária.








Então numa lista de 100 elementos, você quebra em 2. Agora tem a lista de 50. Quebra de novo em 2. Vai ter 25. Quebra de novo. 12. De novo. 6. De novo 3. De novo 1. Se o que procura estiver na primeira metade, talvez você ache em 6 operações em vez de 50. Essa mesma idéia tá por trás de algoritmos como mergesort ou quicksort que são mais rápidos que bubblesort que é complexidade quadrática. Se voltarmos na nossa animação de algoritmos de ordenação, vou mostrar tanto o merge quanto o quick um embaixo do outro. 









Viram como eles segmentam a lista? Logaritmo é a operação inversa da exponencial, se uma complexidade exponencial seria 15 ao quadrado que seria ordem de 225 operações, a logaritmica seria o log de 15 na base 2, que daria menos de 4 operações. Complexidade exponencial fica mais caro mais rápido que linear. São opostos no nosso gráfico e você gostaria de escrever código mais próximo da logarítmica do que da exponencial. Mas não é sempre que você tem a sorte de achar algoritmos logaritmicos, mais comum eu acho que é achar loglineares que é linear vezes logaritmico ou O n vezes log n.









Algoritmos loglineares são por exemplo os mergesort e quicksort que mostrei, que embora sejam bem melhores que quadrático ou exponencial, ainda ficam caros mais rápido que puramente linear. Pra memorizar, veja que a notação O n vezes log n é como se fosse a complexidade linear que é O n vezes a complexidade logaritmica que é O log n. 








Essa notação de O alguma coisa ou Big O provavelmente porque usamos uma letra `O` maiúscula é pra você ter noção da ordem de grandeza do tempo de processamento e/ou do uso de recursos de um algoritmo. Algoritmos podem ser qualquer código que você faz. Tudo que recebe algum dado de input e faz algum processamento pra resultar em alguma coisa. A notação é pra dar uma ideia da complexidade, no pior caso. Por exemplo, o quicksort na média é loglinear que é O n vezes log de n, mas no seu pior caso pode virar quadrático.










Por exemplo, pra acessar o valor de um array, eu repeti dezenas de vezes que é só pegar o endereço do primeiro elemento e somar pelo número da posição vezes o tamanho de bits de cada elemento. Num array de inteiros 64-bits de 100 posições, pra pegar o valor na nonagésima posição basta pegar o endereço da posição 0 e somar por oitenta e nove vezes 8 bytes que é o comprimento de inteiros de 64-bits. Pra qualquer outra posição é o mesmo cálculo.








Independente se o array tiver 10 elementos, 100 elementos ou 100 milhões de elementos, pra pegar o valor em qualquer posição o tempo gasto vai ser exatamente o mesmo, porque esse cálculo de endereço inicial mais a soma da multiplicação entre o número da posição e o tamanho de cada elemento independe do tamanho total do array. É o que em notação de Big O a gente chamaria de O 1, ou seja, tempo constante. Esse é o ideal, e todo algoritmo que chega perto disso pode ser considerado muito bom. Você vê no gráfico que à medida que o tempo corre pra direita no eixo x, a complexidade permanece constante no eixo vertical y, constante.











A Lista Ligada que implementamos tem complexidade O 1, constante, pra operações de inserir novos Nodes ou apagar existentes, porque independe do tamanho total da lista. Mesma coisa pro Array enquanto ele tem espaço sobrando no fim. Mas procurar elementos na Lista Ligada é da ordem de grandeza de O n, linear. No melhor caso, o elemento que queremos é o primeiro, daí só com uma comparação e achamos, no pior caso é o último elemento da lista, daí precisa navegar Node a Node até o fim. 








Por isso existe a opção de Lista Duplamente Ligada, onde cada Node aponta pro próximo elemento e pro anterior ao mesmo tempo, assim dá pra começar uma procura do começo da lista ou do fim da lista. Mesmo assim, a complexidade, a ordem de grandeza, continua sendo linear, dependente da quantidade de elementos na lista, sendo o pior caso se o elemento que procuramos estiver no meio da lista, porque se começar a procurar do começo ou do fim, o meio é o ponto mais longe agora.








No hashtable que implementamos a complexidade depende do algoritmo de hashing. Se o hashing for bom, ou seja, resulta em números com pouca colisão, o tempo de inserção no melhor caso seria O 1 constante, porque por baixo é literalmente inserir num array. O pior caso é se o hashing der sempre o mesmo número pra toda chave. Por exemplo, digamos que queremos inserir 3 palavras quaisquer e o hashing de todas dá o número 10, agora todos vão estar na posição 10 do array. E a gente implementou cada elemento pra ser uma lista ligada. O tempo de inserção vira linear, porque tem que chegar até o fim da lista pra adicionar o Node novo.










Mas a pesquisa, que num array seria tempo constante, no hashtable vai ser linear, igual da lista ligada, O n, linear. Outra coisa importante, só porque dois algoritmos tem complexidade Big O iguais, digamos, O n, linear, não quer dizer que elas têm exatamente a mesma performance. Só significa que vão ficando mais lentas linearmente em proporção à quantidade de elementos pra processar. Ambos array e lista ligada tem complexidade O 1 constante pra inserir novos elementos, mas inserir num array é mais rápido porque já tem o espaço reservado pro elemento ao contrário da lista ligada que precisa chamar `malloc` pra reservar um espaço no heap pra cada elemento. Mas proporcionalmente o tempo de cada um é constante, independente de quantos elementos cada um tenha, entenderam?









O importante é lembrar que tudo que você codifica é um algoritmo (ou mais corretamente, pode ser uma heurística, mas vamos deixar isso pra outro dia). Todo algoritmo tem uma complexidade. Ela tem melhor caso, pior caso e tempo médio. No melhor caso, todas são parecidas. Se você testar um bubblesort, quicksort ou mergesort ou outros como insertion sort ou timsort, num array com 10 elementos, meio que não faz diferença nenhuma. 







Você só vai sentir diferença quando começar a passar mil elementos, cem mil, 1 milhão, daí a diferença de tempo começa a ser mensurável e significativa. Isso é pra lembrar que só porque o código rodou na sua máquina, testando com pouca coisa, nem sempre vai funcionar pra todos os casos. Mas sem entender sobre complexidade, só vai entender como seu código é ruim quando estiver rodando em produção com dados reais, e vai ficar coçando a cabeça sem entender porque e vai ficar botando a culpa na linguagem ou no framework.







Seu código roda em tempos diferentes dependendo dos dados que você passar. Por exemplo, o melhor caso de um bubblesort é tentar ordenar uma lista que já tá ordenada. Ele não vai fazer swap de nenhum elemento e ao terminar de comparar com o último elemento, termina. Então vai rodar como se fosse O n, linear. Mas ironicamente, num quicksort, o pior caso é justamente passar uma lista que já tá ordenada, porque ele vai tentar ordenar e rodar em tempo quadrático em vez de loglinear. Ou seja, só porque no tempo médio o quicksort é bom, não quer dizer que é sempre bom.









Por isso mesmo, em linguagens como Java, Javascript, Python e outros, quando você dá `sort` não necessariamente vai ser um quicksort por baixo. No caso de Python se usa o algoritmo Timsort que é meio inspirado no mergesort com insertion sort que eu não expliquei. É mais estável e com pior caso melhor do que o quicksort. Vale a pena pesquisar. Mas o recado é que nem sempre o algoritmo mais rápido vai ser o melhor sempre, porque se o pior caso derrubar seu sistema, é melhor um algoritmo um pouco mais devagar mas que lide melhor com o pior caso.









Finalmente, antes que alguém jogue nos comentários que eu não mencionei, notação Big O é pode ficar controverso porque povo diz "ah, algoritmo X é quadrático então é ruim, algoritmo Y é linear então é bom" mas não entende que não é pra comparar só pelo Big O, especialmente sem levar em conta coisas como melhor ou pior caso, e sem levar em conta coisas como Big Omega e Big Theta. Na prática, Big O é uma notação de complexidade do limite superior, não necessariamente do pior caso. Big Omega é notação pro limite inferior, não necessariamente do melhor caso. E Big Theta é notação pro tempo entre Big O e Big Omega. 








Se pareceu complicado é porque é um pouco mesmo, na prática Big Omega e Big Theta é mais interessante pro povo acadêmico, mais matemático da ciência da computação. Big O serve pra dar uma noção da ordem de grandeza do tempo de execução de um código ou algoritmo qualquer. Um programador não se preocupa muito com a notação formal matemática, basta entender que existe, e que algoritmos diferentes tem complexidades diferentes. Todo código é diferente, só porque códigos diferentes chegam no mesmo resultado não significa que são equivalentes. Certamente suas complexidades são diferentes. E certamente sua primeira tentativa vai ter complexidade quadrática, então toma cuidado.








Por agora vou encerrar essa introdução à algoritmos e estruturas de dados. E esses dois episódios foram de fato só o topo do iceberg. Mas pros próximos episódios eu precisava que pelo menos todo mundo estivesse na mesma página da existência desses conceitos e uma pequena noção do básico pra eu poder falar de outras coisas. Lembrem-se, o que eu mostrei nesses dois episódios não é um tutorial, nem um curso, pra isso tem material bem melhor. A ideia foi só mostrar que essas coisas existem pra vocês estudarem em mais detalhes.




Eu mesmo não sou acadêmico então me falta a matemática formal. Mas as noções principais incluem que todo algoritmo tem características diferentes. Tem o caso médio, tem os extremos, tem casos excepcionais e cada caso vai rodar com qualidades diferentes de performance e uso de recursos e por isso a gente fala que pra escolher um algoritmo, uma biblioteca, ou mesmo um framework ou arquitetura depende do problema que queremos resolver, como vai ser usado, porque aí uma solução que é boa pra um projeto pode não ser tão bom pra outro. Como já disse no episódio do livro The Mythical Man Month, não existe bala de prata e boa parte do trabalho de um programador é saber como escolher entre diferentes opções.









Quando eu tava na faculdade estudei essa matéria usando o livro de algoritmos do Nicolau Wirth, criador de linguagens como Modula e Pascal, então eu aprendi usando Pascal. Ela é bem simples de ler de cabo a rabo mas eu acho que pra hoje em dia tá defasado. De longe a melhor coleção é o The Art of Computer Programming, escrito por um dos maiores mitos da ciência da computação, Donald Knuth. Ele começou a escrever em 1968 um conjunto que era pra ser de 7 livros. Pausou no fim da década de 70 porque acho que tava trabalhando em outro projeto que tornou ele famoso, o sistema TeX que você deve conhecer como Latex se já escreveu algum artigo científico pra faculdade.










Ainda faltam 3 volumes e os 4 que já existem são bem difíceis de ler e entender sem ter uma base matemática forte. Eu mesmo não tenho paciência e só li trechos específicos. Talvez uma hora faça um episódio de alguns assuntos dele que me interessam. No geral, eu não recomendo esses livros. Pra começar são bem caros. A coleção dos 4 livros na Amazon custa 200 dólares, que convertendo hoje vai pra mais de mil reais. Qualquer livro que você achar que seja de estruturas de dados e algoritmos é suficiente. Veja a bibliografia de qualquer universidade pra ter referências.







Um que não é tão barato, melhor do que eu usei na faculdade, mas tá longe de ser o monstro que é o do Knuth, procure pelo Introduction to Algorithms do Cormen, Leiserson, Rivest e Stein. Diferente do que eu fiz neste vídeo, o livro do Cormen vai começar ensinando o Insertion Sort, no capítulo seguinte vai falar sobre notação assintótica que foi o que eu pulei quando falei sobre notação Big O e na sequência vai explicar o que é a estratégia de dividir pra conquistar e depois um pouco sobre análise probabilística.








Isso é só a introdução. Depois disso ele vai falar de algoritmos de ordenação como Heap Sort e Quicksort, depois estruturas de dados, grafos e só no final vai falar sobre NP Completeness. Eu também não li esse livro de cabo a rabo, mas se você puder, vai cobrir bastante coisa importante. Mesmo não estando no mesmo nível do Knuth, continua sendo um pouco mais pesado na parte matemática mas também com assuntos mais modernos como multithreading. 








Mas como eu disse, não importa muito qual livro, contanto que estude pelo menos um que cubra esses tópicos principais de algoritmos, complexidade, estruturas de dados e entenda o que são algoritmos de tempo polinomial versus de tempo não polinomial. Isso é o que em vários vídeos eu venho falando que é parte da base fundamental da programação. Enquanto você não souber esse básico vai ter dificuldade de pular pra tópicos mais avançados e sempre vai ter dúvida se o que tá codando é o melhor jeito pro problema que tem que resolver, ou porque escolher biblioteca X em vez da Y ou porque certa boa prática funciona em alguns casos mas não em outros.






O estudo da ciência da computação é bem divertido quando você começa a sentir que tá dominando a ferramenta e não a ferramenta te dominando, e conquistar esse nível de controle vai exigir centenas de horas de esforço, estudo e exercícios. E esse estudo precisa dessa base. Espero que estes vídeos tenham dado um pouco de luz e vocês se motivem a procurar o resto sozinhos. Se ficaram com dúvidas mande nos comentários, quem já estudou tudo isso ajudem os colegas também, se curtiram o video deixem um joinha, assinem o canal, não deixem de clicar no sininho pra não perder os próximos episódios e continuem compartilhando com seus amigos pra ajudar o canal. A gente se vê, até mais.
