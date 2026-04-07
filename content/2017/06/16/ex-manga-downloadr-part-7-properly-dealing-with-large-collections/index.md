---
title: 'Ex Manga Downloadr - Parte 7: Lidando Corretamente com Grandes Coleções'
date: '2017-06-16T15:10:00-03:00'
slug: ex-manga-downloadr-parte-7-lidando-com-grandes-colecoes
translationKey: ex-manga-downloadr-7
aliases:
- /2017/06/16/ex-manga-downloadr-part-7-properly-dealing-with-large-collections/
tags:
- beginner
- learning
- elixir
- exmangadownloadr
- traduzido
draft: false
---

No [post anterior](http://www.akitaonrails.com/2017/06/13/ex-manga-downloadr-part-6-the-rise-of-flow) consegui simplificar bastante o código original usando [Flow](https://github.com/elixir-lang/flow). Só que o lado negativo foi que o tempo de execução aumentou consideravelmente.

José Valim gentilmente apareceu e deixou um [comentário valioso](http://www.akitaonrails.com/2017/06/13/ex-manga-downloadr-part-6-the-rise-of-flow#comment-3360301947), que vou reproduzir aqui:

> Você tentou reduzir o `@max_demand`? O `@max_demand` é o quanto de dados você troca entre os estágios. Se você colocar 60, isso significa que está mandando 60 itens para um estágio, 60 para outro e assim por diante. Isso gera um balanceamento ruim para coleções pequenas, porque há chance de todos os itens acabarem no mesmo estágio. Na verdade você quer reduzir o `max_demand` para 1 ou 2, para que cada estágio receba lotes pequenos e precise pedir mais. Outro parâmetro que costuma ser ajustado é a opção `stages: ...` — você deveria definir como a quantidade de conexões que tinha no poolboy antes.

> No entanto, acredito que você não precisa usar Flow de jeito nenhum. O Elixir v1.4 tem algo chamado [`Task.async_stream`](https://hexdocs.pm/elixir/Task.html#async_stream/5), que é uma mistura de poolboy + task async, e definitivamente é um substituto melhor para o que você tinha. Adicionamos isso ao Elixir depois de implementar o Flow, quando percebemos que dá pra extrair muito valor do `Task.async_stream` sem precisar partir para uma solução completa como o Flow. Usando `Task.async_stream`, a opção `max_concurrency` controla o tamanho do pool.

E, obviamente, ele está certo. Eu tinha entendido errado como o Flow funciona. Ele foi feito para quando você tem uma quantidade absurda de itens para processar em paralelo — especialmente unidades de processamento que podem ter alta variância e, por isso, muita back-pressure, não só pela quantidade de itens, mas porque os tempos de execução podem variar dramaticamente. Então é um daqueles casos de ter um canhão na mão quando só tem uma mosca para matar.

O que eu não sabia era da existência do `Task.async_stream` e seu companheiro [`Task.Supervisor.async_stream`](https://hexdocs.pm/elixir/Task.Supervisor.html#async_stream/4) para quando preciso de mais controle.

Vamos dar um passo atrás.

### Lidando com coleções em Elixir

Erlang é uma fera. Ele fornece todos os blocos de construção de um sistema operacional de tempo real e altamente concorrente! Sério, o que ele entrega out-of-the-box é muito mais do que qualquer outra linguagem/plataforma/máquina virtual, em qualquer época. Em Java, .NET ou qualquer outra coisa, você não tem isso de graça. Precisa montar as peças na mão, gastar centenas de horas ajustando e ainda torcer muito para que tudo funcione de forma integrada.

Então, tem sistemas distribuídos para construir? Não tem outra opção de verdade. Faça Erlang, ou sofra.

Aí o Elixir eleva isso um nível acima, criando uma biblioteca padrão bastante razoável e simples de usar, que torna a parte de escrever código genuinamente agradável. É uma combinação matadora. Precisa fazer o próximo WhatsApp? O próximo Waze? Reconstruir o Cassandra do zero? Criar algo como o Apache Spark? Faça Elixir.

Em Erlang, você resolve tudo usando GenServer. É uma abstração elegante do OTP. Você [precisa entender OTP](http://www.akitaonrails.com/en/2015/11/22/observing-processes-in-elixir-the-little-elixir-otp-guidebook/) de forma íntima. Não tem atalho. Não existe Erlang sem OTP.

Dito isso, dá para começar simples e escalar sem tanto esforço.

Geralmente tudo começa com Coleções, ou mais corretamente, com algum tipo de [Enumeração](https://hexdocs.pm/elixir/Enum.html#content).

Assim como minha função simples `Workflow.pages/1`, que itera por uma lista de links de capítulos, busca cada link, faz o parse do HTML retornado e extrai a coleção de links de páginas dentro daquele capítulo, reduzindo as sublistas em uma lista completa de links de páginas.

Se eu sei que a coleção é pequena (menos de 100 itens, por exemplo), simplesmente faria assim:

```ruby
def pages({chapter_list, source}) do
   pages_list = chapter_list
     |> Enum.map(&Worker.chapter_page([&1, source]))
     |> Enum.reduce([], fn {:ok, list}, acc -> acc ++ list end)
   {pages_list, source}
end
```

Simples assim. É linear. Vai processar um link por vez sequencialmente. Quanto mais links de capítulos, mais tempo demora. Normalmente eu quero processar isso em paralelo. Mas não posso disparar um processo paralelo para cada link de capítulo, porque se receber 1.000 links e disparar todos de uma vez, vira um ataque de negação de serviço e certamente recebo centenas de timeouts.

Dá para esbarrar em 2 problemas principais quando precisa iterar por uma coleção grande.

* Se a coleção for enorme (imagine um arquivo de texto de um gigabyte que você precisa iterar linha por linha). Para isso usa-se [`Stream`](https://hexdocs.pm/elixir/Stream.html#content) em vez de `Enum`. Todas as funções parecem quase idênticas, mas você não precisará carregar a coleção inteira na memória nem ficará duplicando-a.

* Se a unidade de processamento demora muito. Agora que você resolveu não explodir o uso de memória, e se você tiver jobs lentos enquanto itera por cada item da coleção? É exatamente o nosso caso, onde a coleção é bem pequena, mas o tempo de processamento é longo porque está buscando de uma fonte externa na internet. Pode levar milissegundos, pode levar alguns segundos.

Uma forma de controlar isso é usando "batches", algo assim:

```ruby
def pages({chapter_list, source}) do
  pages_list = chapter_list
	|> Enum.chunk(60)
	|> Enum.map(&pages_download(&1, source))
	|> Enum.concat
  {pages_list, source}
end

def pages_download(chapter_list, source)
   results = chapter_list
     |> Enum.map(&Task.async(fn -> Worker.chapter_page([&1, source]) end))
     |> Enum.map(&Task.await/1)
     |> Enum.reduce([], fn {:ok, list}, acc -> acc ++ list end)
   {pages_list, source}, results	
end
```

Isso é só para exemplo, não compilei esse trecho para verificar se funciona, mas dá para entender a ideia de dividir a lista grande em chunks e processar cada chunk via `Task.async` e `Task.await`.

De novo, para listas pequenas isso está ok (milhares de itens) desde que cada item não demore muito para processar.

O problema é que isso não é lá muito bom. Porque cada chunk precisa terminar antes do próximo começar. É por isso que a solução ideal é manter uma quantidade constante de jobs rodando a qualquer momento. Para isso, precisamos de um Pool, como expliquei na [Parte 2: Poolboy ao resgate!](http://www.akitaonrails.com/en/2015/11/19/ex-manga-downloadr-part-2-poolboy-to-the-rescue/).

Mas implementar do jeito correto para manter o pool sempre cheio exige um malabarismo chato entre transações do Poolboy e `Task.Supervisor.async`. Foi por isso que fiquei interessado no novo uso do `Flow`.

O código até fica limpo, mas como já expliquei antes, esse não é o caso de uso adequado para o Flow. É melhor quando você precisa iterar por dezenas de milhares de itens ou até infinitos (quando você tem um fluxo de entrada de requisições que precisam de processamento paralelo, por exemplo).

Então, finalmente, existe um meio-termo. A solução entre o simples `Task.async` e o `Flow` é o `Task.async_stream`, que funciona como uma implementação de pool, mantendo uma quantidade `max_concurrency` de jobs rodando em stream. O código final fica muito mais elegante assim:

```ruby
def pages({chapter_list, source}) do
  pages_list = chapter_list
    |> Task.async_stream(MangaWrapper, :chapter_page, [source], max_concurrency: @max_demand)
    |> Enum.to_list()
    |> Enum.reduce([], fn {:ok, {:ok, list}}, acc -> acc ++ list end)
  {pages_list, source}
end
```

E esse é o [commit final](https://github.com/akitaonrails/ex_manga_downloadr/commit/517183261e998ab40f6e5bc793b4db9adcf899e3) com as mudanças mencionadas.

### Conclusão

A implementação com `Task.async_stream` é super simples e os tempos finalmente voltaram ao que eram antes.

```
84,16s user 20,80s system 138% cpu 1:15,94 total
```

Muito melhor do que os mais de 3 minutos que estava demorando com Flow. E não é porque o Flow é lento — é porque eu não estava usando corretamente, provavelmente jogando um chunk grande em um único GenStage e criando um gargalo. De novo: só use Flow se tiver itens suficientes para colocar centenas deles em vários GenStages em paralelo. Estamos falando de coleções com dezenas de milhares de itens, não da minha mísera lista de páginas.

Tem um pequeno ajuste, porém. Para buscar todos os links de capítulos e páginas estou usando `max_concurrency` de 100. O timeout padrão é 5000 (5 segundos). Isso funciona porque o HTML retornado não é tão grande e dá para paralelizar tanto assim numa conexão de alta largura de banda.

Mas no procedimento de download de imagens em `Workflow.process_downloads` tive que cortar o `max_concurrency` pela metade e aumentar o `timeout` para 30 segundos para garantir que não travasse.

Como é uma implementação simples, não há recuperação de falhas nem rotina de retry. Teria que substituir essa implementação por `Task.Supervisor.async_stream` para retomar algum controle. Minha implementação original era mais trabalhosa, mas eu tinha onde adicionar mecanismos de retry. Então, de novo, é sempre uma troca entre facilidade de uso e controle. Quanto mais controle, pior fica o código.

Esse é um exercício simples, então vou deixar assim por enquanto.
