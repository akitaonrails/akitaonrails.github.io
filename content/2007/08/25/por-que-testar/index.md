---
title: Por que Testar?
date: '2007-08-25T20:04:00-03:00'
slug: por-que-testar
tags:
- principles
- tests
draft: false
---

Pessoalmente eu nunca me vi nem li ninguém fazer uma das perguntas mais óbvias: _“Por que testar?”_.

O que eu normalmente presencio é que programadores tem consciência de que precisam testar. A reflexão que eu esperaria seria algo na seguinte linha: _“Temos super-computadores multi-processados com muitos gigahertz sobrando, porque o computador não é capaz de me dizer se meu programa finaliza ou não?”_

![](http://s3.amazonaws.com/akitaonrails/assets/2007/8/25/Usability_Testing.jpg)

Infelizmente, não se trata de um dogma: ou poderíamos quebrá-lo. De fato, precisamos cobrir nossos programas com a maior quantidade possível de testes de qualidade, e nenhum sistema será capaz de confirmar, com 100% de certeza, em 100% dos casos, se um determinado programa irá funcionar corretamente. É uma limitação matemática que não pode ser contornada. Como sabemos disso?

### Momento Rails: ZenTest

Antes de pular para a resposta (mais abaixo), primeiro vou dar uma dica aos Railers de plantão. Como vou falar de testes, gostaria de recomendar uma ferramenta extremamente útil escrita pro Ryan Davis chamado [ZenTest](http://nubyonrails.com/articles/autotest-rails). Para instalar apenas digite:

```bash
sudo gem install ZenTest y  
sudo gem install redgreen -y  
gem install win32console -y # somente para usuários Windows  
```

--

Baixem [este vídeo](http://topfunky.com/clients/blog/autotest-tm.mov) gratuito de Geoffrey Grosenbach, que demonstra o autotest em funcionamento. Também comprem os screencast [Test-First development for Rails](http://peepcode.com/products/test-first-development), [rSpec Basics](http://peepcode.com/products/rspec-basics) e [rSpec Mocks and Models](http://peepcode.com/products/rspec-mocks-and-models) (amostras grátis, [aqui](http://topfunky.com/clients/peepcode/previews/peepcode-004-testing-tips.mov), [aqui](http://peepcode.com/system/previews/peepcode-011-rspec-i-preview.mov) e [aqui](http://peepcode.com/system/previews/peepcode-013-rspec-ii-preview.mov)) para aprender a fazer bons testes em Rails.

O [ZenTest](http://www.zenspider.com/ZSS/Products/ZenTest/) vem com o utilitário ‘autotest’. A partir da raíz do seu projeto Rails, apenas digite:

* * *

```bash
autotest rails  
```

--

Fazendo isso, os utilitários do pacote ZenTest ficarão monitorando seu projeto: toda vez que você modificar algum código ele irá rodar os testes. Quando estiver modificando os testes, ele rodará apenas o método de teste que você acabou de modificar. A vantagem: você estará constante monitorando se está tudo correndo bem com seu projeto, não precisará o rodar manualmente o ‘rake’ toda hora.

![](http://s3.amazonaws.com/akitaonrails/assets/2007/8/25/autotest_red_green.jpg)

Existem alguns plugins e técnicas para que o autotest chame uma janela de notificação, para ficar ainda mais fácil visualizar os testes. Este [link](http://blog.codefront.net/2007/04/01/get-your-testing-results-via-growl-notifications/) tem receitas para Mac. Eu sei que existe maneira para integrar com Gnome no Linux e no Windows, mas não me recordo da URL (alguém se lembra?)

Observando o seu console constantemente você terá rapidamente e em primeira mão onde sua modificação pode estar quebrando alguma coisa. Claro, partindo do princípio que você cobriu seu sistema suficientemente de testes. E quanto é suficiente? Como eu sei quanto do meu projeto já está coberto?

Para sabe isso, instale também o [rCov](http://eigenclass.org/hiki.rb?rcov) que é o pacote de cobertura de código para Ruby. Basta fazer:

* * *

```bash
gem install rcov  
```

Depois instale o plugin [rails\_rcov](http://blog.codahale.com/2006/05/26/rails-plugin-rails_rcov/) no seu projeto assim:

* * *

```bash
./script/plugin install x <http://svn.codahale.com/rails\_rcov>  
```

--

![](http://s3.amazonaws.com/akitaonrails/assets/2007/8/25/hiki.rb.png)

Com este plugin você ganha os seguintes task rake:

```rake
| doc:plugins:rails_rcov | Create plugin documentation for ‘rails_rcov’ |
| test:functionals:clobber_rcov | Remove Rcov reports for functional tests |
| test:functionals:rcov | Run all functional tests with Rcov to measure coverage |
| test:integration:clobber_rcov | Remove Rcov reports for integration tests |
| test:integration:rcov | Run all integration tests with Rcov to measure coverage |
| test:plugins:all:clobber_rcov | Remove Rcov reports for plugins:all tests |
| test:plugins:all:rcov | Run all plugins:all tests with Rcov to measure coverage |
| test:plugins:clobber_rcov | Remove Rcov reports for plugin tests |
| test:plugins:functionals:clobber_rcov | Remove Rcov reports for plugins:functional tests |
| test:plugins:functionals:rcov | Run all plugins:functional tests with Rcov to measure coverage |
| test:plugins:integration:clobber_rcov | Remove Rcov reports for plugins:integration tests |
| test:plugins:integration:rcov | Run all plugins:integration tests with Rcov to measure coverage |
| test:plugins:rcov | Run all plugin tests with Rcov to measure coverage |
| test:plugins:setup_plugin_fixtures:clobber_rcov | Remove Rcov reports for plugins:setup_plugin_fixture tests |
| test:plugins:setup_plugin_fixtures:rcov | Run all plugins:setup_plugin_fixture tests with Rcov to measure coverage |
| test:plugins:units:clobber_rcov | Remove Rcov reports for plugins:unit tests |
| test:plugins:units:rcov | Run all plugins:unit tests with Rcov to measure coverage |
| test:recent:clobber_rcov | Remove Rcov reports for recent tests |
| test:recent:rcov | Run all recent tests with Rcov to measure coverage |
| test:test:clobber_rcov | Remove Rcov reports for test tests |
| test:test:rcov | Run all test tests with Rcov to measure coverage |
| test:uncommitted:clobber_rcov | Remove Rcov reports for uncommitted tests |
| test:uncommitted:rcov | Run all uncommitted tests with Rcov to measure coverage |
| test:units:clobber_rcov | Remove Rcov reports for unit tests |
| test:units:rcov | Run all unit tests with Rcov to measure coverage |
```

Existem diversas outras ferramentas para ajudá-lo nos testes, como [rSpec](http://rspec.rubyforge.org/documentation/rails/install.html). Mas apenas estas já devem aumentar e muito sua cobertura adequada de testes. Recomendo que todos os Railers leiam a respeito de [Test-Driven Development](http://en.wikipedia.org/wiki/Test-driven_development) (que Rails incentiva) e [Behaviour-Driven Development](http://behaviour-driven.org/) (que rSpec implementa).

Agora voltamos à pergunta: _“Para quê, todo esse trabalho? Por que testar?”_

### Momento Wikipedia – Halting Dilemma

[Turing Machines](http://en.wikipedia.org/wiki/Turing_machine) são dispositivos de manipulação de símbolos abstratos básicos que, apesar de sua simplicidade, podem ser adaptadas para simular lógica de qualquer computador que possivelmente seja construído. Foram descritos em 1936 por [Alan Turing](http://en.wikipedia.org/wiki/Alan_Turing). Todos os nossos micro-processadores são, em essência, Turing Machines.

 ![](http://s3.amazonaws.com/akitaonrails/assets/2007/8/25/church.gif)

Uma Turing Machine que é capaz de simular qualquer outra Turine machine é chamada de [Universal Turing Machine](http://en.wikipedia.org/wiki/Universal_Turing_machine) (UTM, ou simplesmente universal machine). Uma definição mais matemática com uma natureza similarmente “universal” foi apresentada por [Alonzo Church](http://en.wikipedia.org/wiki/Alonzo_Church), cujo trabalho em [lambda calculus](http://en.wikipedia.org/wiki/Lambda_calculus) cruzou com o de Turing em uma teoria formal da computação conhecida como [Tese Church-Turing](http://en.wikipedia.org/wiki/Church-Turing_thesis). Esta tese afirma que Turing machines de fato capturam a noção informal de método efetivo em lógica e matemática, dada uma definição precisa de um [algorítmo](http://en.wikipedia.org/wiki/Algorithm) ou “mecânica procedural”.

Um [algoritmo](http://en.wikipedia.org/wiki/Algorithm) é uma lista finita de instruções para a execução de alguma tarefa que, dada uma condição inicial (parâmetros de uma função, por exemplo), irá [terminar](http://en.wikipedia.org/wiki/Termination) em um estado final definido. Um programa de computador – do tipo que fazemos – é um algoritmo ou um conjunto de algoritmos.

Algoritmos são extremamente úteis. Matemáticos podem definir problemas matemáticos instruindo computadores a executá-los, por exemplo, para determinar a trilionésima casa decimal do Pi, ou o quadrilionésimo número primo. O problema: se o tamanho do processo não é conhecido em antemão, então “tentar” pode não ser conclusivo, porque se o processo continuar infinitamente – então em nenhum momento do tempo seremos capazes de ter certeza de uma “Resposta” (Minsky 1967:105).

Portanto a resposta é: inconclusivo. Nunca saberemos, nem poderemos analisar de antemão pra descobrir. A análise de algoritmos à procura da possibilidade de terminarem é chamada [Análise de Terminação](http://en.wikipedia.org/wiki/Termination_analysis). Mas existe um problema primordial, conhecido como [Halting Problem](http://en.wikipedia.org/wiki/Halting_problem).

O Halting Problem, ou Problema de Finalização começa com este enunciado: _“Dada uma descrição de um programa e parâmetros finitos, decidir se o programa termina de rodar ou se rodará infinitamente.”_

 ![](http://s3.amazonaws.com/akitaonrails/assets/2007/8/25/cope1.jpg)

Alan Turing provou em 1936, em estudo paralelo e independente de Alonzo Church, chegando ambos à conclusão que um algoritmo genérico para resolver o Halting Problem para todos os parâmetros possíveis não pode existir. Nós dizemos que o Halting Problem é inconclusivo em Turing machines.

A prova para isso vocês podem ver nos links acima, existe uma demonstração que segue outros teoremas matemáticos chamados [Gödel’s incompleteness theorems](http://en.wikipedia.org/wiki/Gödel%27s_incompleteness_theorem), onde as provas são similares.

Poderia parecer que [humanos](http://en.wikipedia.org/wiki/Human) poderiam resolver o Halting Problem. Afinal, um programador normalmente consegue olhar para um programa e dizer se ele vai ou não vai terminar. É útil entender **porque isso não é verdade**. Para simplicidade, vamos considerar um programa sem parâmetros de entrada, que também é inconclusivo.

“Resolver” o Halting Problem significa ser capaz de olhar para qualquer programa e dizer se ele termina. Não é suficiente ser capaz de olhar para alguns programas e decidir. Humanos podem não se capazes de resolver halting problems por causa do tamanho da entrada (um programa com milhões de linhas de código). Mesmo para programas curtos, não é claro que humanos possam sempre dizer se um programa termina. Por exemplo, poderíamos nos perguntar se o seguinte programa em Ruby (que é um Turing Machine e é [Turing Complete](http://en.wikipedia.org/wiki/Turing-complete)), vai terminar:

* * *

```ruby
def procurar_por_numero_impar_perfeito  
 n = 1 # inteiro de precisão arbitrária  
 while (true)  
 soma_dos_fatores = 0  
 (1..n-1).each do |fator|  
 soma_dos_fatores += fator if n % fator == 0  
 end  
 break if soma_dos_fatores == n  
 n += 2  
 end  
 n  
end
```

Este programa procura até encontrar um “numéro ímpar perfeito”, e só então terminar (break). Ou seja, ele termina se, e somente se, tal número existe. O problema: sabemos hoje que existem números pares perfeitos. Por exemplo 6 = 1 + 2 + 3. 28 = 1 + 2 + 4 + 7. O próximo número perfeito é 496 e depois é 8218. Porém, ainda não sabemos qual é o primeiro número ímpar perfeito e também não sabemos demonstrar a existência ou ausência de tal número. Portanto: é impossível determinar se o programa acima um dia vai terminar ou se rodará indefinidamente. Mesmo se deixarmos esse programa rodar 100 anos e ele não encontrar um ímpar perfeito, não quer dizer que ela não exista: existem infinitos número, você pode tentar infinitamente sem concluir.

Agora por que tudo isso é importante? Nossos pequenos algoritmos são determinísticos e simples na maior parte dos casos. Bom, pelo menos eles parecem ser. A maioria dos programadores está acostumado a criar um algoritmo e testá-lo para uma ou duas dúzias de casos, se funciona para esses casos eles _assumem_ que funciona para todos os casos. E não é sempre assim.

Um _excessivamente bom_ anti-vírus poderia eventualmente ser capaz de detectar todo e qualquer vírus já feito ou que venha a ser feito, considerando simplificadamente que a definição de um vírus seja _software que se auto-replica_?

É impossível. E como temos certeza? Porque o algoritmo de anti-vírus pode ser reduzido a um Halting Problem. Se fosse possível criar um anti-virus como o que descrevi, significa que, por [redução](http://en.wikipedia.org/wiki/Reduction_%28complexity%29), também seria possível resolver o Halting Problem. Como já foi provado por Church e Turing que nenhum método pode resolver esse problema, já sabemos de ante-mão que o novo problema (anti-virus) também não pode ser resolvido. É uma das técnicas de determinar se um novo algoritmo é ou não inconclusivo.

Isso significa que jamais poderemos dizer se um programa funciona ou não? Cuidado com a semântica, o Halting Problem afirma apenas que é impossível dizer se _todos_ os programas terminam ou entram em loop infinito. Não que _nenhum_ programa possa ser determinístico. Quando fazemos testes unitários de pequenos trechos de código, conseguimos imaginar de cabeça que aquele trecho é determinístico e possivelmente funciona em todos os casos que queremos.

Quando juntamos dezenas de pedaços diferentes – todos os eles unitariamente testados -, colocamos tudo num programa gigantesco, é muito difícil predizer que este novo programa funcionará corretamente, mesmo tendo testado unitariamente cada pedaço. Por isso mesmo temos testes funcionais. E podemos pegar cada conjunto maior anterior e combiná-lo num programa ainda maior. Para isso mesmo temos testes integrados.

Porém, quanto mais avançamos, mais e mais nossos programas chegam perto de um [Turing Machine não-determinístico](http://en.wikipedia.org/wiki/Non-deterministic_Turing_machine) e mais complicado é dizer qual serão os resultados.

A [Ciência da Computação](http://en.wikipedia.org/wiki/Computer_science) (bem como o campo de Física e Matemática) é muito rico, muito amplo. Nós, meros programadores não-acadêmicos, mal começamos a raspar a ponta do iceberg. Quem é interessado em criptografia deve conhece o conceito de [funções de mão-única](http://en.wikipedia.org/wiki/One-way_function) (one-way function), uma função fácil de executar mas custoso para reverter. Elas dão origem à criptografia assimétrica ou ou [Criptografia de Chave Pública](http://en.wikipedia.org/wiki/Public_key_cryptography). O problema: ainda é uma questão em aberto se one-way functions realmente existem! Ou seja, é uma questão matemática ainda não provada ou desprovada.

Para a grande maioria dos programadores nada disso tem a menor importância. Este artigo é destinado às pessoas que tem **curiosidade** e **vontade** para aprender mais sobre o campo onde atuamos e mostrar que existe muito mais do que nossa visão alcança. A única maneira de sair com soluções criativas e inovadoras é conhecer o que já foi estudado, subir no ombro de gigantes como Church e Turing.
