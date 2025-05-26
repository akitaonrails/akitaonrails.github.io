---
title: O Resultado do Modelo do Imperial College sobre a COVID-19 pode estar ERRADO
date: '2020-05-07T05:02:00-03:00'
slug: o-modelo-do-imperial-college-sobre-a-covid-19-pode-estar-errado
tags:
- covid-19
- imperial college
draft: false
---

Se você tem assistido os noticiários, todas as decisões tomadas em torno do controle da pandemia da COVID-19 se baseia no resultado das simulações publicadas no famoso ["Report 9"](https://www.ingsa.org/covidtag/academic-papers/imperial-college/) do Imperial College, de autoria do epidemiologista Neil Ferguson, o autor do paper do Imperial College que convenceu todo mundo sobre os lockdowns e que em 07/05/2020 renunciou do governo por ele próprio ter quebrado o lockdown (clique [aqui](https://www.theguardian.com/world/2020/may/06/uk-scientists-being-drawn-into-very-unpleasant-political-situation)).

O [Fernando Ulrich](https://twitter.com/fernandoulrich) compartilhou comigo um artigo publicado hoje, dia 7 de maio de 2020, de autoria da programadora sênior, ex-engenheira do Google, Sue Denin, do blog Lockdown Sceptics. Recomendo fortemente que vocês leiam o relato da própria Sue em seu post:

* [Code Review of Ferguson’s Model](https://lockdownsceptics.org/code-review-of-fergusons-model/)

Se tudo isso for verdade, só tenho uma coisa a dizer: o código da simulação responsável pelos papers publicados pelo Imperial College é lastimável, pra dizer o mínimo.

PORÉM, e é um GRANDE PORÉM, eu não compartilho das opiniões não-técnicas do artigo original e sim das análises técnicas. Tanto o original quanto este não estão discordando do modelo e sim da implementação do código. E refutar uma análise levando em conta a pessoa fazendo a análise é desonestidade. Uma análise tem que independer da pessoa e das circunstâncias, caso contrário é somente enviesamento. Portanto eu não estou traduzindo o artigo da Sue nem citando ela como evidência e sim fazendo minha própria análise em cima do código e da sua execução, pura e simples.

Mas, com o impacto das decisões sendo tomadas por governos ao redor do mundo baseado nos resultados desse papers do Imperial College, é claro que não existe nada mais correto do que 100% desse código de simulação ser lançado ao escrutínio do público. Ele foi lançado faz só 15 dias, o que é too little, too late, e ainda está incompleto (falta os dados de entrada).

Só agora uma *versão* desse código foi publicado num repositório no GitHub, que você mesmo pode baixar aqui:

* [https://github.com/mrc-ide/covid-sim](https://github.com/mrc-ide/covid-sim)


Eu não tenho competência para criticar o modelo propriamente dito publicado nos papers, mas qualquer programador consegue avaliar a qualidade do código que tenta implementar esse modelo, em alguns minutos. Vamos assumir que o modelo em si está correto. Porém é impossível dizer se o código que temos presente é uma implementação correta desse modelo.

Baseado no que o próprio Ferguson twitou e também no que ninguém menos que o lendário John Carmack (ex-CTO da Oculus, fundador da Id Software), o código que temos no repositório linkado acima foi bastante refatorado/retrabalhado por engenheiros da Microsoft e do GitHub.


Segundo Carmack, o código original que Ferguson levou mais de uma década criando - de todas as maneiras mais macarrônicas possíveis - era um único arquivo de C++ de mais de 15 mil linhas.


[![Carmack](https://user-images.githubusercontent.com/194979/80436185-6d26bc00-88b3-11ea-8d1d-c0854972193e.png)](https://user-images.githubusercontent.com/194979/80436185-6d26bc00-88b3-11ea-8d1d-c0854972193e.png)

Precisou da limpeza do Carmack e de engenheiros da Microsoft e do GitHub pra minimamente dividir esse arquivão em mais arquivos menores, refatorar minimamente esse código, criar scripts de execução, e um teste de regressão mínimos.

Mesmo assim, o estado atual desse projeto é problemático. 

Deixemos uma coisa clara: que atire a primeira pedra o programador que nunca fez um código macarrônico, sem testes, com números-mágicos sem documentação, variáveis com nomes impossíveis de entender pra que servem. Eu já fiz isso e eu garanto que qualquer outro programador fez o mesmo.

Também entendo que códigos de pesquisa acadêmica tendem a ter esse nível de qualidade mesmo. Porém, quando chegamos num ponto onde isso dificulta checar que a implementação realmente faz o que diz que faz, isso se torna um problema grave.


Eu convido todo programador a [abrir o repositório](https://github.com/mrc-ide/covid-sim) e explorar alguns dos arquivos. Se você pegar o que conhece como Clean Code e fazer exatamente o inverso, vai ter o código do Ferguson. Pegue qualquer lista de boas práticas, você vai achar o inverso nesse código. A complexidade ciclomática é enorme, cada função tem dezenas de linhas e o principal: não tem testes unitários, só tem um teste de regressão muito simples.


Você vai precisar de `cmake` instalado. Vou assumir que você sabe como instalar as dependências, está documentado no [build.md](https://github.com/mrc-ide/covid-sim/blob/master/docs/build.md) do projeto.

Também precisa ter python instalado. Ele já vem com dados de exemplo (que não são reais nem os que foram usados pra gerar os resultados do Report 9). Você pode executar a simulação assim:

```
data/run_sample.py United_Kingdom
```

O script de Python está meio que servindo como um Makefile e vai compilar o binário `CovidSim` e montar os parâmetros que ele aceita:

```python
cmd.extend([
        "/PP:" + pp_file, # Preparam file
        "/P:" + no_int_file, # Param file
        "/O:" + os.path.join(args.outputdir,
            "{0}_NoInt_R0={1}".format(args.country, r)), # Output
        "/D:" + wpop_file, # Input (this time text) pop density
        "/M:" + wpop_bin, # Where to save binary pop density
        "/S:" + network_bin, # Where to save binary net setup
        "/R:{0}".format(rs),
        "98798150", # These four numbers are RNG seeds
        "729101",
        "17389101",
        "4797132"
        ])
```

No caso do exemplo, todas essas variáveis `pp_file`, `no_int_file`, etc vão configurar de quais arquivos ele vai ler dados como de população e pra que arquivos vai escrever o network binário que parece que serve de "cache" entre rodadas e os arquivos de saída finais.


Mais importante são os 4 últimos parâmetros, que são 2 Setup Seeds e 2 Run Seeds.

Essa simulação executa o modelo, ou cenário, dezenas de vezes variando os diversos parâmetros aleatoriamente. Como a Sue mencionou, é mais ou menos como rodar [Monte Carlo](https://en.wikipedia.org/wiki/Monte_Carlo_method). 

Para leigos e iniciantes vale explicar o que é um "seed". Em computação não existe forma de gerar um número verdadeiramente aleatório. O que conseguimos fazer é criar "Geradores de Números Pseudo-Aleatórios" (RNG). Ou seja é uma função como `random.seed(n)` no Python.

Por exemplo, digamos que queremos gerar uma sequência de 3 números aleatórios no console do Python, podemos fazer assim:

```python
>>> import random
>>> random.seed(1)
>>> random.randint(1,100)
18
>>> random.randint(1,100)
73
>>> random.randint(1,100)
98
```

Nesse exemplo estou pedindo pra gerar números entre 1 a 100, e a cada execução de `random.randint` ele gerou a sequência 18, 73, 98.

Agora digamos que eu quero gerar novamente a mesma sequência. Basta eu reinicializar o gerador mandando o mesmo seed "1" (pode ser qualquer número). Depois disso quando eu rodar `random.randint`, ele vai gerar a mesma sequência exatamente como antes.

```python
>>> random.seed(1)
>>> random.randint(1,100)
18
>>> random.randint(1,100)
73
>>> random.randint(1,100)
98
```

Você pode testar na sua máquina, colocando o seed "1" e vai ter a mesma sequência que a minha acima.

Isso é importante no nosso contexto porque como eu disse, simulações como esta da velocidade de contaminação e mortes da Covid-19 tecnicamente se assemelham a implementar Monte Carlo, que é a execução do cenário centenas ou milhares de vezes, variando o grau de alguns parâmetros aleatoriamente para ver o comportamento médio. 


Porém, se eu inicializar a simulação com os mesmos seeds, como é o caso dos parâmetros Setup Seed e Run Seed do script anterior, os resultados deveriam ser exatamente os mesmos. Quando uma função recebe os mesmos parâmetros de entrada e gera exatamente os mesmos resultados, não importa quantas vezes você rode a função, chamamos isso de **"DETERMINÍSTICO"** e, claro, numa simulação como esta, é obrigatório que o resultado seja sempre determinístico.


Mas como a Sue encontrou primeiro, se você abrir este [ticket de Issue](https://github.com/mrc-ide/covid-sim/issues/116) do repositório no GitHub vai ver que uma equipe da Universidade de Edimburgh reportou um bug dizendo que eles testaram a execução com dados reais múltiplas vezes e os resultados vieram diferentes pros mesmos Seeds (!!) Mais precisamente, eles habilitaram um modo pra rodar mais rápido e descobriram que o resultado variava em torno de 80 mil mortes depois de 80 dias.

[![Não-Deterministico](https://lockdownsceptics.org/wp-content/uploads/2020/05/image.png)](https://github.com/mrc-ide/covid-sim/issues/116)

Ou seja, só habilitando um modo de performance - que não muda nenhum arquivo de entrada e nenhum parâmetro da simulação, os resultados eram drasticamente diferentes em várias ordens de grandeza. E a resposta do Imperial College foi tipo:

_"Ah, eu sei é isso mesmo, isso acontece mas a gente tira a média e é isso aí"_

É como se eu fizesse pra você um programa pra calcular quanto imposto você tem que pagar. Você preenche tudo e manda rodar. Digamos que dá R$ 5 mil. Pronto, mas só pra garantir você roda de novo com os mesmos valores de entrada e a resposta dá diferente, R$ 20 mil! Aí você coça a cabeça e roda de novo, agora dá R$ 500 reais.

O que você faz agora? Quanto paga de imposto? A resposta da Imperial College foi, simplificadamente, o equivalente a dizer:

_"Ah, é isso mesmo, dá diferença, mas relaxa, soma 5 mil com 20 mil com 500 e divide por 3 ... vai dar ... R$ 8.500, pronto, paga isso"_

Eu não sei se rodei da forma correta, mas executando `data/run_sample.py United_Kingdom` eu obtive os seguintes resultados:

```
d2fb079633352adafde041fc70f2948e0df5c9c7ee5780d280494470f1a283cd 
run_1/United_Kingdom_NoInt_R0=3.0.avNE.age.xls
b888b67c10a660ba9184a1c048058dc3e73f5a9623efb7a34980f09a0eaffcc1 
run_1/United_Kingdom_NoInt_R0=3.0.avNE.severity.adunit.xls
39f8adeeaf52d38af6851c4633f33e6484e598e3c8cb52b6b5a620394e11076a 
run_1/United_Kingdom_NoInt_R0=3.0.avNE.severity.xls
40bd33d65520dbcef8ec886fdd2f45bf49a4f07cbbbbf93f7b86c4c14f1261d6 
run_1/United_Kingdom_PC7_CI_HQ_SD_R0=3.0.avNE.age.xls
8c2aaacb033794480b8c5972c36c3cca4a911430e8c1e8ea0345be523254f50c 
run_1/United_Kingdom_PC7_CI_HQ_SD_R0=3.0.avNE.severity.adunit.xls
5e87d7a9b460158902133160137fc92fdb598e1363e50d91458a4dc8e54a15b7 
run_1/United_Kingdom_PC7_CI_HQ_SD_R0=3.0.avNE.severity.xls
```

Esses são os SHA256 dos arquivos Excel (.xls) que ele gera no final. O script rodou em 6 cores na minha máquina virtual, consumindo mais de 9 GB de RAM e levando um tempão pra executar com os dados fake que vem no projeto. Com os dados de verdade, rodando em máquinas mais parrudas, ele vai consumir fácil acima de 20 GB. Dependendo dos dados de qual país, pode chegar a mais de 200 GB de RAM. 


Outra coisa, se alguém está confundindo a natureza de "resultados aleatórios" (dentro de uma pequena margem) por causa de erros de arredondamento de fontos flutuantes ou resultado usando paralelismo por GPU, o código não tem "rounds" que poderiam acumular erros e eu estou rodando tudo em uma máquina virtual sem GPU, só CPU puro (mesmo o projeto tendo um pequeno suporte a OpenMP).


Se eu apagar os arquivos intermediários de network que ele gera como "cache" e rodar tudo de novo, com exatamente os mesmos parâmetros (e note que eu mostrei acima que os Seeds estão hard-coded, portanto os resultados deveriam ser os mesmos), eis os resultados gerados:

```
efd5b1a06abf98ebbba2f59752a7a63e0fe96eb6c2857fdba8b276ac6f338bb2 
run_2/United_Kingdom_NoInt_R0=3.0.avNE.age.xls
c3a20e4860b755553d0857c41c63112da285377b7c81886666efe326a46cc572 
run_2/United_Kingdom_NoInt_R0=3.0.avNE.severity.adunit.xls
660ef8752181bf338db2eca52b9506958bdb8a9b8eec782ad6e53d5b2b7a0f6e 
run_2/United_Kingdom_NoInt_R0=3.0.avNE.severity.xls
ff8459daa5d95d8bd21b64ee1314ed2b5922b45a0bf69394f36bb988d0e24984 `\
run_2/United_Kingdom_PC7_CI_HQ_SD_R0=3.0.avNE.age.xls
a2ff7a91dcd9772de6cf9a4ea3c271af47d93706d2968aaeed36b90522cf34c4 
run_2/United_Kingdom_PC7_CI_HQ_SD_R0=3.0.avNE.severity.adunit.xls
c965db754f3850f59b4f617361cbd12a7a60991e7dbab81defe15022bf3e9741 
run_2/United_Kingdom_PC7_CI_HQ_SD_R0=3.0.avNE.severity.xls
```

Note que todos os SHA256, as impressões digitais dos arquivos, são diferentes. Não me cite afirmando que esse é o erro, pode ser que eu tenha deixado escapar algum parâmetro aleatório, mas não parece.


Pra visualizar o conteúdo dos arquivos gerados, eu usei os scripts de R que estão no mesmo projeto, por exemplo assim:

```R
cd Rscripts
Rscript CompareRuns.R ../run_1 ../run_2
```

O resultado das simulações são arquivos XLS que são processados por scripts de R pra plotar em forma de gráficos, eis alguns exemplos:

[![Death Cumulative Incidence](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/685/Death_Cumulative_Incidence.png)](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/685/Death_Cumulative_Incidence.png)

[![Death Incidence](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/686/Death_Incidence.png)](https://akitaonrails.s3.amazonaws.com/assets/image_asset/image/686/Death_Incidence.png)


Esses são só dois exemplos mas ele gera uma dúzia de outros gráficos. 


Eu fico na dúvida porque o projeto tem um diretório de testes de regressão. Essa é outra parte lamentável aliás, são só 2 míseros scripts de teste de regressão, parecidos com esse `data/run_sample.py` e eles se chamam `tests/regressiontest_UK_100th.py` e `tests/regressiontest_US_based.py`. Eles fazem algo parecido com o que eu acabei de mostrar acima: rodam a simulação inteira, gera os arquivos e compara o hash dos arquivos gerados com o hash hard-coded no teste.


São basicamente testes de integração ou black-box tests só. Por acaso, os testes passam, por isso eu falei pra não afirmar que os meus resultados acima são evidência de bug ainda. Mas pode ser que os dados usados pro teste, que são mais simples, levam a resultados que fazem bater - famoso caso de teste feito pra passar. Se alguém achar o que eu executei errado acima - ou não - não deixe de comentar.


Agora, este ponto dos testes é um absurdo. Um dos projetos de software mais importante da nossa atualidade não tem nenhum teste unitário. É uma mera comparação de hashes dos arquivos de saída.


Como o Carmack notou, tem muito código em C++ que parece que foi uma tradução direta de FORTRAN antigo. Não sei quanto procede, mas você encontra em todo lugar funções bonitas e bem documentadas como esta em [SetupModel.cpp](https://github.com/mrc-ide/covid-sim/blob/master/src/SetupModel.cpp), na linha 1932 ... isso 1932 (olha o TAMANHO desse arquivo!):

```C
for (k = 0; k < P.NC; k++)
{
	i = k % P.nch;
	j = k / P.nch;
	f2 = Cells[k].I; f3 = Cells[k].S;
	if ((i > 0) && (j > 0))
	{
		f2 += Cells[(j - 1) * P.nch + (i - 1)].I; f3 += Cells[(j - 1) * P.nch + (i - 1)].S;
	}
	if (i > 0)
	{
		f2 += Cells[j * P.nch + (i - 1)].I; f3 += Cells[j * P.nch + (i - 1)].S;
	}
	if ((i > 0) && (j < P.ncw - 1))
	{
		f2 += Cells[(j + 1) * P.nch + (i - 1)].I; f3 += Cells[(j + 1) * P.nch + (i - 1)].S;
	}
	if (j > 0)
	{
		f2 += Cells[(j - 1) * P.nch + i].I; f3 += Cells[(j - 1) * P.nch + i].S;
	}
	if (j < P.ncw - 1)
	{
		f2 += Cells[(j + 1) * P.nch + i].I; f3 += Cells[(j + 1) * P.nch + i].S;
	}
	if ((i < P.nch - 1) && (j > 0))
	{
		f2 += Cells[(j - 1) * P.nch + (i + 1)].I; f3 += Cells[(j - 1) * P.nch + (i + 1)].S;
	}
	if (i < P.nch - 1)
	{
		f2 += Cells[j * P.nch + (i + 1)].I; f3 += Cells[j * P.nch + (i + 1)].S;
	}
	if ((i < P.nch - 1) && (j < P.ncw - 1))
	{
		f2 += Cells[(j + 1) * P.nch + (i + 1)].I; f3 += Cells[(j + 1) * P.nch + (i + 1)].S;
	}
	Cells[k].L = f3; Cells[k].R = f2;
}
```

Ou em [Sweep.cpp](https://github.com/mrc-ide/covid-sim/blob/688db07a08a2a2416a37bb1092fde1d07a2b6c39/src/Sweep.cpp) que você uma função como `TreatSweep` que vai da linha 1165 até 1765, ou seja uma única função com nada menos que SEISCENTAS LINHAS. E isso não é exceção, a maioria das funções principais tem de dezenas a centenas de linhas.


É a norma nesse código achar trechos ilegíveis como este:

```C
for (j = 0; j < P.PlaceTypeNum; j++)
	if (j != P.HotelPlaceType)
	{
#pragma omp parallel for private(i,k,d,q,s2,s3,t3,l,m,x,y) schedule(static,1000) reduction(+:t)
		for (i = 0; i < P.N; i++)
		{
			k = Hosts[i].PlaceLinks[j];
			if (k >= 0)
			{
				q = (P.LatentToSymptDelay > Hosts[i].recovery_or_death_time * P.TimeStep) ? Hosts[i].recovery_or_death_time * P.TimeStep : P.LatentToSymptDelay;
				s2 = fabs(Hosts[i].infectiousness) * P.TimeStep * P.PlaceTypeTrans[j];
				x = s2 / P.PlaceTypeGroupSizeParam1[j];
				d = 1.0; l = (int)(q / P.TimeStep);
				for (m = 0; m < l; m++) { y = 1.0 - x * P.infectiousness[m]; d *= ((y < 0) ? 0 : y); }
				s3 = ((double)(Places[j][k].group_size[Hosts[i].PlaceGroupLinks[j]] - 1));
				x *= ((Hosts[i].infectiousness < 0) ? (P.SymptPlaceTypeContactRate[j] * (1 - P.SymptPlaceTypeWithdrawalProp[j])) : 1);
				l = (int)Hosts[i].recovery_or_death_time;
				for (; m < l; m++) { y = 1.0 - x * P.infectiousness[m]; d *= ((y < 0) ? 0 : y); }

				t3 = d;
				x = P.PlaceTypePropBetweenGroupLinks[j] * s2 / ((double)Places[j][k].n);
				d = 1.0; l = (int)(q / P.TimeStep);
				for (m = 0; m < l; m++) { y = 1.0 - x * P.infectiousness[m]; d *= ((y < 0) ? 0 : y); }
				x *= ((Hosts[i].infectiousness < 0) ? (P.SymptPlaceTypeContactRate[j] * (1 - P.SymptPlaceTypeWithdrawalProp[j])) : 1);
				l = (int)Hosts[i].recovery_or_death_time;
				for (; m < l; m++) { y = 1.0 - x * P.infectiousness[m]; d *= ((y < 0) ? 0 : y); }
				t += (1 - t3 * d) * s3 + (1 - d) * (((double)(Places[j][k].n - 1)) - s3);
			}
		}
		fprintf(stderr, "%lg  ", t / ((double)P.N));
	}
```


Relembrando que esta é a versão que já passou por uma MEGA-LIMPEZA de refatoração das mãos de engenheiros da Microsoft e GitHub.

Imaginem o código original do Ferguson como era, o código que gerou os resultados do Report 9.

A única forma de confiar nesse código é refatorar TODAS essas funções de centenas de linhas em funções menores de single-responsability, cobrir uma a uma com testes unitários, trocar todas as variáveis ilegíveis por nomes corretos, remover todos os números mágicos hard coded em tabelas de constantes e assim por diante.


Isso sem contar o [problema reportado pela Universidade de Edinburgh](https://github.com/mrc-ide/covid-sim/issues/116) onde parece estar acontecendo, no mínimo problemas de Race Condition. Todo mundo sabe que programar Threads é difícil, ainda mais em C++ sem usar patterns e bibliotecas adequadas pra isso.

Em simulações desse tipo chamados "estocásticos" é de fato possível que exista uma aleatoriedade por causa dos cálculos envolvidos que envolvem coisas como ponto flutuante (que pode dar pequenas diferenças mesmo). Mas não sei se é esse o caso, especialmente quando os próprios desenvolvedores do código não tem essa certeza. Na Issue que citei acima, quando questionados de porque o resultado dava diferente, a resposta foi que "sim, sabemos que tem problema, mas é porque está rodando em multithreads, tente rodar em 1 thread só"

Porém a universidade respondeu "mas é isso mesmo que estamos fazendo", e a parte preocupante é que o código de fato é tão difícil de entender que nem os programadores envolvidos tem certeza de qual deveria ser o comportamento correto.

Veja o [commit de 3 dias atrás do Ferguson](https://github.com/mrc-ide/covid-sim/commit/6416d017a3a1f10d04314a85cb3eb9e419e4ca45) entitulado "Bugs found - code is stable and seems deterministic again. WIll finish more tests and send pull request". Tipo, se olhar o histórico do Git vê-se de novo, que não se segue boas práticas. Esse commit tem um monte de modificação estética (adiciona espaço, tira espaço) e a mudança importante de verdade são meia dúzia de linhas perdidas no meio de 105 adições e 81 deleções.

Se o comportamento "normal" é mesmo ser não-determinístico, porque existe este commit do próprio Ferguson dizendo "corrigi e agora está determinístico" (e pelo que relatei acima, não parece estar). Ou seja, o problema todo escala pro nível do desenvolvedor não saber qual deveria ser o resultado correto.

Falando em histórico de Git, o [primeiro commit](https://github.com/mrc-ide/covid-sim/commit/bd87d475563cd54978325bf73ce45e80a7c8de65) desse repositório, que data de 15 dias atrás tem o título de "Squash history for public release". 

Sabe quando seu histórico tá uma zona e você não quer mostrar a bagunça? O que você faz? Um squash do histórico todo num único commit. Sabe todo trabalho que os engenheiros da Microsoft e GitHub fizeram? Não está no histórico, foi dado um squash de tudo! Isso é um absurdo pra um projeto público dessa importância.

Claramente o projeto original que era um arquivão de 15 mil linhas jamais passaria pelo escrutínio de nenhum programador, nem precisa ser um especialista ou um Carmack. Se depois da limpeza toda, esse é o resultado e ainda tem bugs, significa que com alta probabilidade, as projeções todas divulgadas pela Imperial College não podem ser confiadas.

Existe uma [Issue aberta](https://github.com/mrc-ide/covid-sim/issues/144) (que pelo menos até agora não foi apagada ainda) que pede a divulgação do histórico de Git completo e do código original. Isso ainda não foi cumprido.

Existe outra [Issue aberta](https://github.com/mrc-ide/covid-sim/issues/165) entitulada "We, the undersigned software engineers, call for any papers based on this codebase to be immediately retracted." que está servindo como um aviso/abaixo-assinado onde diversos programadores que, como eu e a Sue, olhamos essa bagunça, estamos avisando que os resultados gerados por esse código não podem ser confiados.


A única forma de sabermos se os resultados são confiáveis é que os dados originais de entrada, os arquivos de input, sejam divulgados e que diversos programadores e entidades rodem a simulação múltiplas vezes com os mesmos arquivos, usando os mesmos Seeds. Daí os arquivos finais de resultado **OBRIGATORIAMENTE** precisam ser iguais entre si.

Porém, se eles não baterem, só confirmaria a suspeita que o código que veio sendo usado até agora contém bugs sérios, em boa parte devido à todas as más práticas de desenvolvimento de software. E esses bugs tornam esse software NÃO-DETERMINÍSTICO.

O [código fonte está no GitHub](https://github.com/mrc-ide/covid-sim), se você for programador, convido todos a fazerem o mesmo que eu: avaliar o código e se possível escrutinizar ao máximo cada canto obscuro.

Porém, esse código é incompleto. Não sabemos quais resultados publicados foram gerados com qual versão desse software. Sequer sabemos como era o código original que provavelmente foi o mais usado. Também não temos os dados originais de entrada pra repetirmos as simulações e comparar os resultados. 

O corolário é que infelizmente precisamos duvidar de tudo que já foi divulgado sobre esse modelo até agora até que as peças que faltam sejam divulgadas. E este é um exemplo de mau código e mau gerenciamento de lifecycle de software, que não deve servir de modelo pra nenhum projeto de software.

Com o que temos até agora divulgado não é possível concluir com 100% de certeza nem que a implementação está correta e nem que está errada, porque faltam as peças que eu disse. Mas com as divergências que temos visto, e com a qualidade do software que acabei de explicar e que vocês podem ver com os próprios olhos, também não é uma impossibilidade acreditar que os resultados gerados por este software estejam errados em algumas ordens de grandeza.

**Atualização:** tenho visto muitos feedbacks deste post depois que publiquei dizendo coisas do tipo "o mundo acadêmico os códigos são assim mesmo, é normal ser sujo, isso não importa". E de fato, eu sei disso e não teria nenhum problema se a execução desse código fornecesse resultados consistentes todas vezes. Mas a partir do momento que se determina que os resultados não são confiáveis, e não tem como ler no código onde está o erro por causa da sujeira, aí temos um problema.
