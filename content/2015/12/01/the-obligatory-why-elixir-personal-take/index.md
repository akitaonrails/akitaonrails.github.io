---
title: 'O Obrigatório "Por Que Elixir?" - Visão Pessoal'
date: '2015-12-01T13:26:00-02:00'
slug: o-obrigatorio-por-que-elixir-visao-pessoal
translationKey: obligatory-why-elixir
aliases:
- /2015/12/01/the-obligatory-why-elixir-personal-take/
tags:
- learning
- beginner
- elixir
- traduzido
draft: false
---

Pois é, venho estudando e exercitando bastante com Elixir. O José Valim anunciou recentemente as novidades do futuro [Elixir 1.2](https://twitter.com/josevalim/status/670595716776116224). O design da linguagem já é elegante, enxuto, e continua se polindo aos poucos.

Antes de mais nada, sou Desenvolvedor de Aplicações Web. Lido com aplicações Ruby on Rails e infraestrutura. Portanto, não sou desenvolvedor Desktop, Mobile, de Games ou de Ferramentas. Isso é muito importante deixar claro logo de cara.

E, a propósito, conforme vou focando meus esforços de programação cada vez mais em Elixir, isso não significa que estou "trocando" de Ruby para Elixir. Não preciso fazer escolhas exclusivas, e na minha cabeça, ao menos por um período de tempo, Rails unindo forças com Phoenix vai ser um combo muito difícil de bater para minhas estratégias de desenvolvimento web.

Eu sei, Phoenix é construído como o Rails, então por que não trocar de vez: porque a maior parte dos sites baseados em conteúdo não precisa dos aspectos de concorrência do Phoenix, e eu falei "por um período de tempo" porque o Rails ainda tem um ecossistema gigantesco com gems mais maduras que tornam o desenvolvimento mais fácil e mais rápido. Isso pode mudar no futuro, mas por enquanto o combo faz sentido porque eu posso construir um site normal em Rails como faria normalmente (com Devise, ActiveAdmin, Spree ou o que for) e adicionar Phoenix para coisas como WebSockets (notificações em tempo real, chat em tempo real, background jobs que podem rodar de forma mais eficiente do que o Sidekiq, etc).

Esse artigo vai resumir minha visão pessoal em 2 frentes:

* [Outras Funções de Desenvolvedor além da Web](#developer-roles)
* [Conceitos "Funcionais" que Realmente Importam](#functional-concepts)
    - [Imutabilidade e Passagem de Mensagens Opacas são MUITO importantes](#immutability)
    - [Coroutines e Schedulers](#coroutines)
    - [Tipagem Estática vs Dinâmica ainda é controverso](#static-dynamic)
    - [Tolerância a Falhas: Não tenha medo do seu código](#fault-tolerance)
* [Resumo](#summary)

Como qualquer coisa sobre a qual eu queira argumentar, isso é **longo**, mas não seria legal apenas afirmar algo sem elaborar. Nessa busca por entendimento, eu posso ter confundido uma coisa ou outra, então me avisem na seção de comentários abaixo se houver coisas para corrigir ou explicar com mais detalhes.

Vamos começar.


<a name="developer-roles"></a>

### Outras Funções de Desenvolvedor além da Web

Num ambiente Desktop, você definitivamente vai querer fazer uma combinação de [Node-Webkit](https://github.com/nwjs/nw.js/) com bibliotecas nativas. Se você está em ambientes corporativos específicos, não vai ter outras escolhas além do desenvolvimento .NET baseado em WFC ou Java Swing. Suas opções estão definidas há um bom tempo, e até o Visual Basic.NET ainda tem seu lugar. Toolchains específicas vão ser ditadas pela Microsoft e Oracle/Java Community Process.

Em ambientes Linux você ainda vai usar wrappers em torno de GTK+, Qt ou toolkits similares. Não há muitas saídas aqui.

Se você é um desenvolvedor Mobile-first, você **precisa** aprender o caminho do Swift e Objective-C (até certo ponto) para iOS e o sabor específico de Java para o Dalvik/ART do Android. Mas eu vou argumentar que você tem muito a ganhar no desenvolvimento nativo se usar [**RubyMotion**](http://www.rubymotion.com/). Ou, você pode simplesmente acompanhar o esforço do Facebook com [React Native](https://facebook.github.io/react-native/). Há muita fragmentação nesse ambiente, você pode fazer o mínimo possível com Web Mobile e Phonegap/Cordova, e construir apps interessantes com ferramentas como o Ionic Framework. O único consenso é que se você realmente quer construir o que há de mais avançado da próxima geração, vai querer mergulhar fundo nos frameworks nativos que cada plataforma oferece.

Se você é Desenvolvedor de Games você quer estar o mais próximo possível do metal. É perfeitamente viável escrever jogos mobile jogáveis usando qualquer número de bibliotecas Javascript junto com tecnologias do HTML 5 como Canvas e WebGL. Mas para o blockbuster da próxima geração você vai usar engines maduras como Unity ou Unreal ou até construir a sua própria se estiver realmente investido nesse campo. Isso vai te forçar a saber programar em C/C++. Realmente depende de quão fundo você quer ir na toca do coelho.

Se você é Desenvolvedor de Ferramentas vai ter os benefícios tanto da geração antiga quanto da nova de linguagens. Se você está mais perto do Kernel do Linux vai precisar mesmo de C/C++ na bagagem. Mas para a nova geração de containers leves (LXC), Docker, você pode se beneficiar de **Go**, um ambiente de desenvolvimento de aplicações talhado para tornar a vida mais fácil do que ter que lidar com as idiossincrasias de C/C++. **Rust** é outra excelente escolha nova para tornar mais fácil - entre outras coisas - escrever bibliotecas e ferramentas pequenas livres de vazamentos de memória (estou mencionando isso em particular porque é importante para linguagens como Ruby ou Python conseguirem adicionar performance fazendo binding com bibliotecas nativas em C, e o Rust facilita essa tarefa).

Linguagens diferentes têm times diferentes e objetivos de longo prazo diferentes, por isso comparar linguagens não é como comparar maçãs e laranjas. Go, por exemplo, é mais pesado que Rust, mas ambos são bons para ferramentas de linha de comando, daemons especializados, e no caso de Go, empreitadas pesadas em rede e concorrência.

Aos meus olhos, Go é um Java ou C++ "melhor". E não interpretem mal: Java ainda é uma linguagem e plataforma muito boa. Há pouquíssimas coisas que chegam perto da maturidade da JVM e do extenso ecossistema por trás dela. Eu não pensaria nem por um segundo em tentar reescrever sistemas complexos escritos em Java como a biblioteca Lucene ou as soluções Elasticsearch/SOLR, por exemplo.

Mas o poder do Java padrão é difícil de ser desencadeado sem um aquecimento para o HotSpot pegar embalo. Isso faz dele uma solução ruim para ferramentas de linha de comando. Mas agora você tem um bom meio-termo com Go. Você também não tem uma boa experiência embarcando Java em outras plataformas, e aí você precisaria voltar para C, mas agora você tem outro bom meio-termo com Rust.

Se você quer desencadear modelos diferentes de programação, especialmente os mais adequados a abstrações concorrentes como o modelo de Atores tipo [CSP do Hoare](https://en.wikipedia.org/wiki/Actor_model_and_process_calculi_history), você pode tentar **Scala** com [Akka](http://akka.io/) (que agora é a biblioteca padrão de atores) e o [Pulsar/Quasar](http://blog.paralleluniverse.co/2013/05/02/quasar-pulsar/) do **Clojure**. Akka e Quasar são os que chegam "perto" (mas nunca conseguem igualar) a plataforma OTP nativa do Erlang.

Para a Web no geral, você se vira muito bem com o ecossistema atual (em constante mudança, instável) Node.js, Python (Django, Plone), Ruby (Ruby on Rails, Sinatra), PHP (Zend, Laravel), até Perl tem seu lugar. Combinado com serviços maduros em diferentes plataformas (Elasticsearch em Java, PostgreSQL em C, RabbitMQ em Erlang), qualquer aplicação web grande e complexa pode ser escrita com qualquer combinação das melhores ferramentas que melhor atendam às suas necessidades.

Essa é uma visão injusta e curta, claro. Eu não cobri todos os aspectos da ciência da computação ou da indústria. Existem várias outras linguagens ativas e úteis como Lua, Haskell, Fortran, Ada, Julia, R. A mensagem é: você não precisa escolher uma única linguagem, vai realmente depender do que você vai entregar. E um verdadeiro artesão vai dominar muitas ferramentas para fazer o trabalho da melhor maneira possível.

<a name="functional-concepts"></a>

### Conceitos "Funcionais" que Realmente Importam

[Eu escrevi sobre minhas opiniões](http://www.akitaonrails.com/2015/10/28/personal-thoughts-on-the-current-functional-programming-bandwagon) sobre a atual onda do chamado estilo Funcional de programação. Recomendo que leia antes de continuar.

Há alguns aspectos que são intransponíveis se você realmente quer ir além da pesquisa acadêmica e entrar no mundo real da produtividade.

<a name="immutability"></a>

#### Imutabilidade e Passagem de Mensagens Opacas são MUITO importantes

Para que computação seja rápida, estamos acostumados a compartilhar dados entre rotinas. A gente movimenta ponteiros e altera dados no lugar.

Não é particularmente rápido tornar as coisas imutáveis e não compartilhadas. Quanto mais você torna os dados mutáveis e quanto mais compartilha, mais difícil fica fazer seu código rodar concorrentemente.

É um **trade-off** importante: se você vê dados mutáveis e estado compartilhado, está otimizando para performance.

Não dá para dizer que uma linguagem é essencialmente boa ou ruim por ter dados mutáveis ou imutáveis. Mas, valha o que valer, minha opinião pessoal é que é mais difícil convencer usuários a seguir convenções como _"compartilhe o mínimo possível, mute o mínimo possível"_. A maioria nem vai saber sobre isso se não for built-in e forçado. Eu prefiro ter imutabilidade forçada por padrão.

Em Erlang, dados são **imutáveis**. Similar a Java, ele [passa valores por referência](http://erlang.org/pipermail/erlang-questions/2013-March/072760.html) em chamadas de rotinas (não está copiando valores entre chamadas, como muitos confundem).

E no caso da recursão ele otimiza através do [Tail Call Optimization](http://learnyousomeerlang.com/recursion) para deixar mais rápido. A propósito, essa é uma otimização que a JVM ainda não consegue fazer direito. Clojure precisa de chamadas especiais 'recur' e 'trampoline', por exemplo. Scala consegue reescrever a recursão de cauda para um loop em tempo de compilação, com a anotação '@tailrec'. [Erlang tem suas próprias armadilhas](http://ferd.ca/erlang-s-tail-recursion-is-not-a-silver-bullet.html) também, então não é tão preto no branco no momento.

Em Erlang, como expliquei antes, você roda funções dentro de processos completamente isolados. Se a função recorre ou bloqueia, ela permanece isolada. Processos só conseguem se comunicar enviando mensagens (imutáveis e opacas) uns aos outros. As mensagens são enfileiradas em uma "run queue" ou "mailbox" e a função pode escolher receber e responder a essas mensagens. É isso.

Então, você pode passar valores por referência entre rotinas, ou pode compartilhar dados em um processo terceiro como mediador dos dados. Uma dessas infraestruturas embutidas no Erlang é o **ETS**, o [Erlang Term Storage](http://elixir-lang.org/getting-started/mix-otp/ets.html), que é parte da chamada plataforma OTP. Pense no ETS como um armazenamento chave-valor embutido muito simples e muito rápido como o Memcached. Você usa ele para os mesmos casos de uso de um cache e é tão simples quanto fazer assim:

```ruby
table = :ets.new(:my_fancy_cache, [:set, :protected])
:ets.insert(table, {"some_key", some_value})
:ets.lookup(table, "some_key")
```

Muitos podem argumentar que o **isolamento rígido de processos** do Erlang e a comunicação restrita estritamente à passagem de mensagens opacas é exagero e que dá para passar usando algo parecido com a [MVCC Software Transaction Memory](http://clojure.org/refs) do Clojure, ou STM. Você até tem STM no Erlang, com a outra ferramenta nativa do OTP, construída em cima do ETS, chamada **Mnesia**. Ela oferece o equivalente a transações ACID de banco de dados em memória. Não é um conceito novo, mas STM não está disponível como funcionalidade de linguagem e ainda é incerto se realmente é uma boa escolha tê-lo.

Um resultado inspirado, eu acredito, da escolha do Clojure de ter memória transacional com fila de histórico e isolamento de snapshots é mostrado em sua joia da coroa, [Datomic](http://www.datomic.com/). A ideia não é revolucionária de jeito nenhum, já que você tem muitos outros [trabalhos prévios](http://www.xaprb.com/blog/2013/12/28/immutability-mvcc-and-garbage-collection/) como RethinkDB, CouchDB, e extensões para bancos de dados existentes. Bom para um serviço, ainda assim eu não acho que seja uma boa coisa compartilhar estado, mesmo que você tenha um transactor em volta desse estado. A imutabilidade do Erlang com isolamento rígido de processos ainda não tem páreo.

<a name="coroutines"></a>

#### Coroutines e Schedulers

Você já conhece sub-rotinas, faz isso o tempo todo particionando grandes porções de código em funções ou métodos menores que se chamam. Você talvez já conheça um tipo especializado de Coroutines na forma de [Fibers](http://bit.ly/1lVuLFJ) (como implementado pela primeira vez no Windows por volta de 1997).

Fibers oferecem um jeito da execução da sua função atual "ceder" (yield) de volta ao seu chamador, preservando seu estado atual, e então o chamador pode "retomar" (resume) a Fiber suspensa para continuar sua execução de onde parou da última vez. Isso permite multitasking cooperativo, não preemptivo. Temos Fibers em Python, Ruby e outras linguagens e isso permite a criação de construções como Generators. Até Javascript pode ter algum tipo de Fibers se você adicionar bibliotecas como [node-fibers](https://github.com/laverdet/node-fibers):

```javascript
var Fiber = require('fibers');

function sleep(ms) {
    var fiber = Fiber.current;
    setTimeout(function() {
        fiber.run();
    }, ms);
    Fiber.yield();
}
```

A chamada para 'yield' suspende a execução atual até que a função no 'setTimeout' seja chamada. Aí ela chama 'run', que retoma a função previamente cedida. Isso ainda é "rudimentar" comparado a coroutines: porque a própria função tem que ceder controle para o reactor event loop, no caso de uma aplicação Node.js. Se você não fizer isso, vai bloquear o event loop num processo Node.js single threaded, e portanto bloqueia tudo até a função terminar, derrotando todo o propósito. E essa é uma daquelas "convenções" que "bons" programadores deveriam seguir, mas a maioria vai esquecer.

Fibers são úteis para tornar menos feio programar num ambiente Reactor rudimentar, onde você depende de callbacks chamando callbacks e acaba com o anti-padrão da [pirâmide da perdição de callbacks](https://bjouhier.wordpress.com/2012/03/11/fibers-and-threads-in-node-js-what-for/). Com Fibers você pode programar como faria numa linguagem imperativa síncrona, transformando esse código Javascript feio:

```javascript
function archiveOrders(date, cb) {
  db.connect(function(err, conn) {
    if (err) return cb(err);
    conn.query("selectom orders where date < ?",  
               [date], function(err, orders) {
      if (err) return cb(err);
      helper.each(orders, function(order, next) {
        conn.execute("insert into archivedOrders ...", 
                     [order.id, ...], function(err) {
          if (err) return cb(err);
          conn.execute("delete from orders where id=?", 
                       [order.id], function(err) {
            if (err) return cb(err);
            next();
          });
        });
      }, function() {
        console.log("orders been archived");
        cb();
      });
    });
  });
}
```

Nessa coisa mais gerenciável:

```javascript
var archiveOrders = (function(date) {
  var conn = db.connect().wait();
  conn.query("selectom orders where date < ?",  
             [date]).wait().forEach(function(order) {
    conn.execute("insert into archivedOrders ...", 
                 [order.id, ...]).wait();
    conn.execute("delete from orders where id=?", 
                 [order.id]).wait();
  });
  console.log("orders been archived");
}).future();
```

A confusão toda das [Promises, Futures](https://en.wikipedia.org/wiki/Futures_and_promises) depende em parte de Fibers adequadas. Javascript, sendo um design muito pobre, não vem com nada built-in e daí a proliferação de implementações de Fibers, Deferreds, Promises, Futures que nunca conseguem alcançar nem consenso nem pessoas realmente usando elas em larga escala.

Então, Fibers são ok. Coroutines são melhores porque você tem múltiplos pontos de suspender uma função e mais. E ainda melhor, em Erlang você nem precisa pensar em loops Reactor rudimentares (sim, reactors são uma construção rudimentar para concorrência quando você não tem outra boa escolha): tem **chamadas assíncronas transparentes**. Tudo em Erlang é assíncrono e não-bloqueante, mas você não lida com pirâmides de callback porque tem algo melhor por baixo: o **Scheduler**.

A propósito, eu acho muito frustrante que [as "goroutines" do Go **não são** "coroutines" propriamente ditas](http://stackoverflow.com/questions/18058164/is-golang-goroutine-a-coroutine).

Para cada processo Erlang com suporte SMP (multiprocessamento simétrico) vai existir **uma** thread real por núcleo de CPU disponível no seu sistema, e para cada thread vai existir um único Scheduler para gerenciar as green threads internas (processos) e a run-queue.

Como programador, eu não preciso "lembrar" de ceder controle de volta a um event loop passivo. O scheduler vai cuidar de balancear o tempo de computação para cada processo concorrente. Se um processo estiver demorando demais, o Scheduler pode escolher suspendê-lo e dar tempo para outras rotinas. Erlang define uma ["redução"](http://erlang.org/pipermail/erlang-questions/2001-April/003132.html) e que existem diferentes níveis de prioridade de funções. Se uma função leva mais que 2.000 reduções, o Scheduler pode escolher suspendê-la. Se você tem 8 núcleos de CPU, mas a computação nos processos não é pesada, a VM pode escolher usar apenas 1 ou 2 Schedulers e deixar os outros 6 ociosos para que o hardware possa desligar os núcleos para economizar energia (!!). Isso mesmo, Erlang até é Eco Friendly!

E precisamos repetir isso de novo: porque cada processo é **rigidamente isolado**, com dados imutáveis e sem estado compartilhado, fica mais fácil suspender um processo em execução. No caso da JVM isso geralmente é implementado levantando exceções checadas e fazendo todo mundo implementar alguma interface Suspendable. Pode ser feito usando essa [biblioteca de continuation Java de terceiros](http://www.matthiasmann.de/content/view/24/26/) onde você cede levantando uma Exception (!) Coisa nojenta.

Rust [ainda está implementando](https://github.com/rustcc/coroutine-rs) algo para coroutines também, mas ainda nada tão maduro. Mas de novo, coroutines é apenas parte da história, você precisaria de um sistema mais pesado com schedulers em userland para fazer sentido. Go é um candidato melhor para incorporar tal sistema em seu runtime, mas também fica devendo em conseguir implementar tudo isso. Há o [Suture](http://www.jerf.org/iri/post/2930), uma tentativa de ter parte do OTP em Go, mas não dá para ser feito. Até Akka, o primeiro clone OTP mainstream para Scala, não consegue chegar perto por causa das limitações da JVM. [Clojure com Pulsar/Quasar](http://blog.paralleluniverse.co/2013/05/02/quasar-pulsar/), chega **mais perto**, mas ainda não chegou lá.

Agora, o Scheduler do Erlang não só é capaz de suspender e retomar processos, mas também cuida da passagem de mensagens entre eles. Então cada Scheduler tem sua própria run-queue para enfileirar e despachar mensagens. De novo, porque os dados são imutáveis, você só precisa de alguma forma de locking quando você quer outro Scheduler (em outra thread real) para tomar conta de alguns processos a fim de balancear o processamento entre os núcleos. Erlang suporta SMP [desde o OTP R12B](http://erlang.org/pipermail/erlang-questions/2008-September/038231.html) (estamos no R18 agora, e ainda evoluindo).

A maioria das linguagens ainda depende do modelo preemptivo de threads reais do SO para fazer multitasking. E isso é pesado e lento por causa de toda a troca de contexto envolvida e toda a lógica de locking que a maioria dos programadores vai fazer errado (a melhor prática para concorrência é: não use threads, é provável que você vá errar). De novo, fazemos as suposições corretas primeiro: programadores não conseguem fazer multithreading direito, então deixe um Scheduler fazer isso, quando necessário, e evitando trocas de contexto lentas do SO o máximo possível. Green threads suspendíveis combinadas com um Scheduler em userland coordenando troca cooperativa é uma escolha muito mais rápida e segura.

Se você quer aprender mais sobre coroutines, esse [paper de Lua](http://www.inf.puc-rio.br/~roberto/docs/corosblp.pdf) sobre o assunto explica em mais detalhes o que eu acabei de elaborar:

<blockquote>
Implementar uma aplicação multitasking com coroutines de Lua é direto. Tarefas concorrentes podem ser modeladas por coroutines de Lua. Quando uma nova tarefa é criada, ela é inserida em uma lista de tarefas vivas. Um simples dispatcher de tarefas pode ser implementado por um loop que continuamente itera sobre essa lista, retomando as tarefas vivas e removendo as que terminaram seu trabalho (essa condição pode ser sinalizada por um valor predefinido retornado pela função main da coroutine ao dispatcher). Eventuais problemas de fairness, que são fáceis de identificar, podem ser resolvidos adicionando pedidos de suspensão em tarefas demoradas.
</blockquote>

<a name="static-dynamic"></a>

####  Tipagem Estática vs Dinâmica ainda é controverso

Vimos um movimento mais pesado de sistemas de tipagem estática burocráticos (principalmente Java antes do 6, C# antes do 4, C++) para linguagens puramente dinâmicas como Perl no fim dos anos 80, Python no fim dos 90, Ruby em meados de 2000. Tentamos sair do _"deixar o compilador feliz"_ para o _"deixar os programadores felizes"_, o que faz mais sentido se você me perguntar.

Scala, Groovy, Haskell, Swift trouxeram um meio-termo bem prático com sistemas de **Inferência de Tipos** derivados de [Hindley-Milner](https://en.wikipedia.org/wiki/Hindley%E2%80%93Milner_type_system), de um jeito que podemos codar meio que como em linguagens dinâmicas mas com o compilador fazendo mais trabalho para inferir tipos para nós antes de gerar o bytecode executável final.

Mas tem um **grande** porém: é muito difícil fazer **hot swap** de código dentro do runtime se você tem assinaturas estáticas. Eu não estou dizendo que é impossível, mas é muito mais difícil. Você até consegue recarregar código em Java (um exemplo é o [Spring Loaded](https://github.com/spring-projects/spring-loaded)) ou Haskell (existe um plugin de hotswap e outras alternativas). Você não faz reloads granulares numa linguagem tipada estaticamente porque se quiser mudar a assinatura de um método, precisa mudar o grafo que depende dessa assinatura. É factível, embora chato.

Em Erlang, porque não há essas dependências duras, e de novo por causa das vantagens inerentes de só ter dados imutáveis sem estado compartilhado, e dependências limitadas a passagem de mensagens opacas, você consegue recarregar granularmente um único módulo e mais importante de tudo: você consegue implementar callbacks simples para **transformar o estado antigo de um processo em uma nova estrutura de estado**, porque só recarregar o código é metade da história se você vai ter centenas de processos antigos reiniciando no novo código mas tendo que lidar com estado anterior. Num GenServer Erlang, você só implementa esse único callback:

```ruby
code_change(OldVersion, CurrentState, _Extra) -> {ok, NewState}.
```

Então, embora Inferência de Tipos seja um meio-termo legal, a flexibilidade da Tipagem Dinâmica vai além de ser fácil para programadores usarem. Como com Python, Ruby, Javascript, Perl e outras linguagens dinamicamente tipadas, você vai querer cobrir seu código com suítes de teste adequadas - o que não deveria ser opcional em linguagens fortemente tipadas de qualquer jeito. Não há dúvidas que a análise estática de um compilador ajuda muito, mas é minha visão pessoal que tipagem dinâmica me permite mais flexibilidade.

<a name="fault-tolerance"></a>

### Tolerância a Falhas: Não tenha medo do seu código

Com Tipagem Dinâmica vamos acabar de novo na discussão sem fim de _"programadores nunca fazem certo, precisamos de um compilador para forçar regras estáticas"_. E você está quase certo: programadores erram, mas um compilador não vai te salvar de qualquer jeito, e pior: ele pode te dar uma falsa sensação de segurança. Não há buraco de segurança pior que falsa sensação de segurança. Uma suíte de testes é muito melhor para asseverar implementação adequada, e ainda assim não é garantia firme.

Eu disse que isso é controverso, já que um sistema de tipagem estática mais rígido é mais produtivo do que ter que testar unitariamente todos os tipos de input e output de toda função. Mas se você pensou isso, está pelo menos errado em que isso não é para o que servem os testes unitários: é para testar comportamentos de unidade, independente dos tipos. Testar tipos é o que chamamos de "chicken typing" e é outra forma de programação defensiva. Você deve testar comportamento, não coisas que um compilador checaria. E de novo, ter a tipagem estática trava minha flexibilidade porque agora eu tenho que lutar constantemente contra a tipagem, adicionar mais boilerplate, e em última análise se o comportamento está errado, o código está errado, apesar das checagens de tipo.

Para um sistema ser **"tolerante a código bugado ou falhas não capturadas"** é o oposto de poluir seu código com declarações de proteção como "try/catch" ou "if err == x" ou ter alguma forma de checagem em nível estático com Result monads (que a maioria das pessoas vai só desempacotar de qualquer jeito). Guards só vão até certo ponto. E sim, isso é anedótico já que não há estatísticas de que "todo mundo vai desempacotar" e a maioria dos bons programadores não vai, mas se a experiência me diz uma coisa é que programadores ruins vão cair no "try/catch" tudo quando eles não sabem o que fazer de qualquer maneira.

Você precisa de um sistema que permita que qualquer código bugado falhe e não derrube o ambiente em volta dele, o que o levaria a um estado inconsistente, corrompido.

O problema com código com defeito é que ele deixa o estado numa posição onde não tem para onde ir. E se esse estado for compartilhado, você deixa todo outro pedaço de código numa posição onde eles não conseguem decidir para onde ir em seguida. Você vai precisar desligar tudo e reiniciar a partir do último estado bom conhecido. Quase todos os fluxos de "continuous delivery" são implementados em torno de reiniciar tudo.

Em vez de ter que derrubar tudo caso você esqueça de fazer try/catch em alguma coisa, você pode confiar nos alicerces do Erlang de não compartilhar estado, ter dados imutáveis, e - o mais importante - ter o sistema de processos leves rigidamente isolados para fazer com que o processo que está segurando o código com defeito **desligue e avise seu Supervisor**. Essa é a ideia geral por trás do chamado OTP em Erlang.

A ideia de um Supervisor é ter um processo pequeno que monitora outros processos. O Supervisor tem o mínimo possível de código para raramente (ou nunca) falhar (o melhor tipo de código é "nenhum código"). Uma vez que um processo com defeito quebra por causa de exceção não capturada ou outras razões indeterminísticas, ele envia uma mensagem de notificação para o mailbox da run-queue do Supervisor, e então morre limpo. O Supervisor então escolhe o que fazer baseado em sua estratégia de restart subjacente.

Digamos que você tenha uma lista de URLs que está fazendo scraping. Mas você não antecipou estruturas sujas na sua lógica de parsing. O processo fazendo o scraping quebra e morre. O Supervisor é notificado e escolhe reiniciar o processo, dando ao novo processo o estado anterior - a lista de URLs - e agora que a URL com defeito não está mais ali, o novo processo pode continuar feliz o trabalho com a próxima URL da lista.

Esse é um exemplo simples da dinâmica entre a Erlang VM, o Supervisor e seus workers filhos. Você pode ir mais longe e ter várias Applications, que por sua vez sobem novos Supervisors, que por sua vez sobem processos filhos. E você tem uma Árvore de Supervisores que pode capturar exits e reiniciar bits granulares do seu código de runtime sem trazer o resto do sistema para um estado inconsistente.

Tal é a beleza do conceito de isolamento rígido de processos.

Toda I/O no sistema é embrulhada em [Ports](http://www.erlang.org/doc/tutorial/c_port.html), que obedecem à lógica Async/callback transparentemente sem você ter que criar pirâmides de callbacks. O processo consumindo tais ports apenas é suspenso pelo Scheduler até que a chamada Async retorne e ele possa retomar o trabalho. Sem inferno de pirâmide de callback. Sem necessidade de implementações rudimentares de Fibers para permitir sistemas rudimentares de Promises/Futures. Apenas coroutines dentro de processos que podem ser suspensas e retomadas pelo Scheduler. Menos oportunidades para erros de programador se acumularem.

Então, um programador vai esquecer de codar todo possível ramo de execução e porque ele sabe disso, a **pior coisa** que pode acontecer não é se ele esquecer uma exceção não capturada, mas se ele decidir programar **defensivamente** e adicionar condições gerais para capturar **qualquer** erro e nunca levantá-lo. Você já viu antes, quando encontra código que está preso dentro de blocos try/catch genéricos, tentando evitar todo erro possível. Mas o que realmente acontece é que o sistema pode não quebrar, mas sua lógica e seu processamento estão com defeito no seu cerne. E você não vai descobrir, porque não quebra, portanto ninguém é nunca notificado! Você não vai acabar com menos bugs, vai acabar com uma montanha de bugs lógicos que nunca são percebidos porque são todos engolidos!!

Esse é o cerne da Tolerância a Falhas: não tenha medo do Erlang, tenha medo dos programadores! Em vez disso, devemos fazer o que Joe Armstrong apresentou em seu paper seminal ["Making reliable distributed systems in the presence of software errors"](http://www.erlang.org/download/armstrong_thesis_2003.pdf). Esse é tanto um guia detalhado para Erlang e OTP quanto seus argumentos sobre como escrever sistemas tolerantes a falhas fazendo o programador escrever código tão claramente quanto ele originalmente pretendia, sem a necessidade de ser defensivo, com a confiança de que se ele esquecer alguma coisa, OTP vai estar lá para capturar e não deixar o sistema morrer, mas dar uma chance de consertar e recarregar sem disturbar outras partes boas do sistema.

Esse é o objetivo último da boa programação: não ser defensivo, não colocar try/catch em todo lugar porque você está com medo.

<a name="summary"></a>

### Resumo

Esse curto resumo é a razão pela qual Erlang soa muito atraente para minhas necessidades de Desenvolvimento Web, ou para qualquer sistema complexo escalável, ao menos para mim.

Toda outra linguagem teve que fazer trade-offs. Toda nova linguagem em cima da JVM tem que lidar com limitações inerentes a como a JVM foi originalmente arquitetada. Rust ainda pode construir abstrações melhores, mas o escopo dele é para ferramentas e bibliotecas menores, não sistemas complexos distribuídos. Sim, eventualmente ele pode fazer o que C/C++ pode, e a Mozilla está realmente baseando o núcleo da próxima geração de seu browser core em Rust. Isso vai dar bootstrap a bibliotecas e frameworks de mais alto nível melhores, da mesma forma que a Apple usando Objective-C criou todo o conjunto de Core frameworks que tornam implementar aplicações complexas muito mais fácil.

Go fez uma escolha por manter a familiaridade com sua herança C++. Claro, ele tem toneladas de funcionalidades úteis, em particular as goroutines built-in que tornam o código concorrente muito mais fácil que em linguagens anteriores.

Haskell é muito estrito para a maioria dos programadores (sim, Monads, ainda difícil para o programador médio compreender plenamente) e apesar de opiniões contrárias, para mim ele ainda parece apelar mais a pesquisadores do que a desenvolvedores do dia-a-dia. Outras linguagens dinâmicas como Ruby, Python, podem eventualmente ir pelo caminho de Erlang com Ruby adicionando alguma imutabilidade ([na 2.3](https://bugs.ruby-lang.org/issues/11473) com String imutável por padrão), mas ainda há um longo caminho a percorrer.

Erlang tem tudo, como Joe Armstrong vislumbrou que um sistema tolerante a falhas deveria ser. Começou como um exercício implementado em Prolog em 1986. Migrou do antigo compilador JAM para a atual VM BEAM em 1998. Adicionou SMP por volta de 2008. Tem evoluído gradualmente, polindo suas arestas, sendo realmente testado em batalha em sistemas realmente de missão crítica por décadas. Está pronto para nós, agora mesmo.

Tem Tolerância a Falhas garantida pelos princípios de dados imutáveis, sem estado compartilhado, passagem pura de mensagens opacas, e processos suspendíveis, todos gerenciados por Schedulers. Isso garante que rotinas com defeito podem quebrar um único processo mas não o sistema inteiro e definitivamente não trazer o estado de outros processos a estados inconsistentes, corrompidos.

Aí você pode instrumentar sua máquina virtual e checar que Supervisors estão reiniciando filhos mais do que você quer e decidir consertar o código com bug. E uma vez que conserta, você pode escolher **não** desligar e reiniciar o sistema inteiro para recarregar as correções de código, você pode fazer isso granularmente, on the fly, com processos rodando que vão pegar as correções uma vez que o Supervisor os reinicie. O hot swap granular de código é garantido porque não há hierarquia de tipos com a qual se preocupar.

E porque você tem coroutines adequadas sem hierarquia de dependências de estado compartilhado, você pode ter **exceções assíncronas** que podem forçosamente desligar processos sem criar efeitos colaterais a outros processos rodando. Um Supervisor pode escolher reiniciar toda sua lista de filhos quando um de seus filhos quebra e outro de seus filhos dependia desse processo anterior. Você pode trocar de estratégia de restart "one for one" para "one for all" (como os Mosqueteiros).

Há apenas um problema com Erlang: ele não foi desenhado para "felicidade do programador", um conceito que nos acostumamos a ter como certo por causa do Ruby e linguagens mais novas.

Erlang tem suas raízes em Prolog e isso aparece. Uma vez que você se aprofunda e realmente exercita com a linguagem você possivelmente consegue se acostumar com ele. Mas se você veio de linguagens dinâmicas mais modernas como Ruby, Python, Groovy, com certeza vai sentir falta das construções modernas confortáveis.

Elixir é a peça que faltava, a Pedra Filosofal se você quiser, que pode destrancar todos os 30 anos de refinamentos, maturidade, tecnologias industriais testadas em batalha em larga escala, para o programador médio.

Ele traz muitas construções modernas como tornar macros mais fáceis para permitir Domain Specific Languages, ter comentários testáveis no seu código, adicionar uma biblioteca padrão mais moderna que é facilmente reconhecível do ponto de vista de Ruby ou Clojure, polimorfismo via Protocols, e por aí vai.

Esse é um exemplo de Elixir direto dos testes do código fonte:

```ruby
Code.require_file "../test_helper.exs", __DIR__

defmodule Mix.ArchiveTest do
  use MixTest.Case

  doctest Mix.Archive

  test "archive" do
    in_fixture "archive", fn ->
      File.write ".elixir", "~> 1.0.0"
      Mix.Archive.create(".", "sample.ez")
      archive = 'sample.ez'
      assert File.exists?(archive)
      assert has_zip_file?(archive, 'sample/.elixir')
      assert has_zip_file?(archive, 'sample/priv/not_really_an.so')
      assert has_zip_file?(archive, 'sample/ebin/Elixir.Mix.Tasks.Local.Sample.beam')
      assert has_zip_file?(archive, 'sample/ebin/local_sample.app')
    end
  end

  defp has_zip_file?(archive, name) do
    {:ok, files} = :zip.list_dir(archive)
    Enum.find(files, &match?({:zip_file, ^name, _, _, _, _}, &1))
  end
end
```

Código que pode ser escrito assim automaticamente me faz sorrir.

Essa é a combinação perfeita. De novo, não é sem deficiências. Erlang de jeito nenhum é uma linguagem rápida. É bem mais rápido que Ruby, Python, ou outras linguagens interpretadas. Pode ser feito um pouco mais rápido com compilação nativa através do compilador HIPE, mas ainda assim nem perto das velocidades de Go, Rust, ou qualquer derivado de Java como Scala, Groovy ou Clojure.

Então, se você realmente precisa de poder bruto de computação, vai querer Go ou Java. De novo, eu não estou dizendo que existem só esses 2, mas são as escolhas usuais se você não quer descer para C/C++. Haskell tem performance excelente, mas a curva de aprendizado dele está longe de ser estelar.

Erlang é um sistema inteiro, tem seu próprio sistema de scheduling, controla processos vivos, respirando, cada um com seu próprio garbage collector, controla captura de sinais do sistema e por aí vai. Foi desenhado para ser um servidor completo. É muito menor que um container Java Enterprise Edition completo, tão pequeno que você consegue empacotar ferramentas de linha de comando que sobem rápido o bastante. Mas esse não é o ponto forte. Para esse propósito você se sai melhor com Go ou até Rust.

Pelas mesmas razões ele não foi feito para ser uma linguagem embutível do jeito que Lua é. Não foi feito para criar bibliotecas que possam ser facilmente lincadas via FFI ou exports de função tipo C, do jeito que Rust pode.

Há jeitos de criar aplicações classe-desktop, especialmente com [wxWidgets](http://www.erlang.org/doc/apps/wx/chapter.html) cross-platform, do jeito que a aplicação built-in Observer de instrumentação é feita, mas Erlang não foi construído para ser um toolkit desktop.

Também porque ele prioriza correção, processos rigidamente isolados se comunicando só por mensagens opacas, estados imutáveis e não compartilhados, isso significa que Erlang não é adequado para processamento pesado de ciência de dados. Então duvido que seja a melhor escolha para analytics de Big Data, sequenciamento de DNA e outras coisas pesadas em que ferramentas como Julia, R, Fortran, são escolhas melhores. Não é a mesma coisa que dizer que ele não pode ser um bom núcleo de banco de dados, Riak e CouchDB já provaram isso. Mas queries complexas em cima de altos volumes de dados também não é o ponto forte.

Então, Erlang é bom para sistemas distribuídos, com alta concorrência de troca de mensagens opacas e proxying. O cenário exato em que a Web está. Aplicações Web com carga pesada de throughput que precisam de chats e notificações em tempo real, transações de pagamento pesadas e demoradas, coleta de dados de muitas fontes a fim de reduzi-los a respostas HTML ou JSON consumíveis.

Mas para o desenvolvedor Web médio (e por "médio" eu quero dizer minimamente capaz de arquitetar os tipos de sistemas complexos com que lidamos todo dia em desenvolvimento web, não construção simples de site estático), Erlang era um desafiante real, e agora podemos ter o conforto de uma linguagem moderna real com toques de Ruby e Clojure, sem as complexidades da tipagem forte mas com a segurança das construções built-in de Tolerância a Falhas para entregar aplicações Web modernas, altamente confiáveis e altamente escaláveis.
