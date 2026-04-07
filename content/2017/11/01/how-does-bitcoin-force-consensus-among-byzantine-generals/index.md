---
title: "Como o Bitcoin Força Consenso entre os Generais Bizantinos?"
date: '2017-11-01T14:02:00-02:00'
slug: como-o-bitcoin-forca-consenso-entre-os-generais-bizantinos
tags:
- ruby
- blockchain
- cryptocurrency
- bitcoin
- traduzido
translationKey: bitcoin-byzantine-consensus
aliases:
- /2017/11/01/how-does-bitcoin-force-consensus-among-byzantine-generals/
draft: false
---

_"Dá pra quebrar o blockchain?"_

É uma pergunta justa. Quem conhece minimamente a arquitetura do blockchain conclui instintivamente que "não", é praticamente improvável que alguém consiga quebrar. Na prática, é basicamente impossível.

O que me espanta é que a maioria dos programadores que conheço tem uma dificuldade enorme de superar o preconceito contra criptomoedas. Não faço ideia de onde vem esse preconceito, mas conheço pessoas muito inteligentes que resolvem os problemas mais difíceis de escalabilidade web e nunca deram uma olhada sequer no paper original de Satoshi Nakamoto — um documento curtíssimo descrevendo o blockchain.

Sério, o paper [Bitcoin: A Peer-to-Peer Electronic Cash System](https://bitcoin.org/bitcoin.pdf) é tão ridiculamente pequeno e fácil de entender que qualquer estudante de ciência da computação consegue acompanhar. Qualquer programador mediano lê e entende em uns 30 minutos.

O modelo mental mais simples é o de uma Lista Ligada, onde cada nó da lista é o que chamamos de Bloco. Cada Bloco é uma struct simples, com os ponteiros de anterior/próximo de sempre, e um corpo em estrutura de árvore (uma [Merkle Tree](https://brilliant.org/wiki/merkle-tree/), para ser preciso).

O detalhe que muda tudo: cada bloco carrega a assinatura hash do bloco anterior, formando uma "cadeia" segura. Daí o nome "block-chain".

Em termos de ciência da computação, estamos falando de estruturas de dados de primeiro ano. Se você entende Lista Ligada e Árvore Binária, mais a coisa mais simples de criptografia — um Digest Hash como SHA256 —, pronto, você entende a espinha dorsal do banco de dados blockchain.

Porque é só um banco de dados. Um banco distribuído, para ser mais exato. Ou melhor: um banco distribuído bastante cru e simples. Não é eficiente, fica atrás de bancos NoSQL distribuídos sérios como Redis ou Cassandra. As capacidades de consulta são praticamente inexistentes além de encontrar um bloco pelo seu identificador.

Claro, o código-fonte do Bitcoin é mais sofisticado do que isso — mas o básico é tão simples que você não precisa de mais de 20 linhas de Ruby para replicar. Veja esta implementação de exemplo do [Gerald Bauer](https://github.com/openblockchains/awesome-blockchains/tree/master/blockchain.rb):

```ruby
require "digest"    # for hash checksum digest function SHA256

class Block

  attr_reader :index
  attr_reader :timestamp
  attr_reader :data
  attr_reader :previous_hash
  attr_reader :hash

  def initialize(index, data, previous_hash)
    @index         = index
    @timestamp     = Time.now
    @data          = data
    @previous_hash = previous_hash
    @hash          = calc_hash
  end

  def calc_hash
    sha = Digest::SHA256.new
    sha.update( @index.to_s + @timestamp.to_s + @data + @previous_hash )
    sha.hexdigest
  end


  def self.first( data="Genesis" )    # create genesis (big bang! first) block
    ## uses index zero (0) and arbitrary previous_hash ("0")
    Block.new( 0, data, "0" )
  end

  def self.next( previous, data="Transaction Data..." )
    Block.new( previous.index+1, data, previous.hash )
  end

end
```

Pois é.

Uma pergunta permanece: como essa estrutura simples vira um banco de dados "distribuído"?

Você precisa de uma "cópia-mestra" centralizada da qual todas as outras cópias replicam — ou precisa de alguma forma de "consenso" entre as cópias diferentes.

Como chegar a consenso entre nós aleatórios e sem controle espalhados pelo globo? Esse é o problema chamado ["Tolerância a Falhas Bizantinas"](http://pmg.csail.mit.edu/papers/osdi99.pdf), explicado e resolvido brilhantemente por Barbara Liskov e Miguel Castro, do MIT, em 1999.

Em resumo: imagine generais bizantinos, cada um com seu próprio exército, cercando uma cidade hostil. A decisão é atacar ou recuar. Mas todos os generais precisam tomar a mesma decisão, em consenso. Como chegar a esse consenso quando não há comunicação direta com todos os generais e, pior, quando alguns podem ser traidores ou agentes duplos?

Esse é exatamente o tipo de problema que temos aqui. Qualquer pessoa na internet pode baixar uma cópia do blockchain e verificar que os blocos são válidos e não adulterados, recomputando os hashes de cada bloco.

Mas como adicionar novos blocos e fazer os outros nós aceitarem o seu bloco?

Foi por isso que Satoshi adicionou o chamado "Proof of Work" à equação. Cada bloco está encadeado ao anterior por conter o hash do bloco anterior — e computar um hash digest é algo trivial hoje em dia.

Em Ruby, por exemplo:

```ruby
Digest::SHA256.hexdigest("abcd")
# => "88d4266fd4e6338d13b845fcf289579d209c897823b9217da3e161936f031589"
Digest::SHA256.hexdigest("123")
# => "a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3"
```

Isso roda em uma **fração de milissegundo**.

Agora, e se eu pedir para você encontrar o hash que começa com uma certa quantidade de "zeros" no início?

Por exemplo:

```ruby
# Quero encontrar 4 zeros ("0000") no hash:
Digest::SHA256.hexdigest("79026" + "123")
# => "0000559fb4a55f135c7db3d83405b86b4b63cd035993873a5b676bae08b64334"
```

Como eu sei que preciso acrescentar "79026" antes? Não sei. Preciso começar do zero e incrementar um a um até encontrar o hash no formato desejado.

Olhando o [exemplo do Gerald](https://github.com/openblockchains/awesome-blockchains/blob/master/blockchain.rb/blockchain_with_proof_of_work.rb#L29-L45), implementaríamos essa busca assim:

```ruby
def compute_hash_with_proof_of_work( difficulty="00" )
  nonce = 0
  loop do
    hash = calc_hash_with_nonce( nonce )
    if hash.start_with?( difficulty )
      return [nonce,hash]    ## bingo! proof of work if hash starts with leading zeros (00)
    else
      nonce += 1             ## keep trying (and trying and trying)
    end
  end
end

def calc_hash_with_nonce( nonce=0 )
  sha = Digest::SHA256.new
  sha.update( nonce.to_s + "123" )
  sha.hexdigest
end
```

Um SHA256 simples leva entre 0.000010 e 0.000020 segundos (lembre: frações de milissegundo). Quanto tempo leva para encontrar aquele "79026" (o que chamamos de "nonce")?

```
> puts Benchmark.measure { compute_hash_with_proof_of_work("0000") }
  0.190000   0.000000   0.190000 (  0.189615)
```

Consideravelmente mais: 0.18 segundos em vez de 0.000020. Podemos aumentar a variável de "dificuldade" para tornar a busca pelo nonce ainda mais trabalhosa. E é exatamente assim que o Bitcoin funciona: cada bloco ajusta a dificuldade de modo que o nó mais rápido leve em torno de 10 minutos para encontrar o hash do próximo bloco.

E isso, meu caro, é o que chamamos de **"MINERAÇÃO"**. O que um minerador faz é executar um loop, incrementando nonces sobre o digest do bloco, até encontrar o nonce correto.

Encontrado o nonce, o minerador adiciona o bloco ao blockchain e o propaga para os outros nós. Os outros nós fazem a verificação (agora de volta ao procedimento de 0.000020 segundos — rapidíssimo).

Quando os nós verificam e confirmam o nonce, todos adicionam o bloco ao topo do blockchain. Conforme outros mineradores continuam empilhando blocos sobre ele, o bloco vai se tornando "solidificado". O bloco mais recente no topo é geralmente instável, mas com mais blocos em cima ele é considerado mais "garantido" — por isso a maioria das exchanges e serviços que aceitam Bitcoin aguarda as famosas "6 confirmações de blocos".

Como a dificuldade é calibrada para que o nó mais rápido leve cerca de "10 minutos" para encontrar o nonce, um bloco é considerado "seguro" quando cerca de 1 hora passa e 6 blocos são adicionados depois dele.

## Dá pra quebrar isso?

Agora você vai entender por que falamos em "hash power" quando o assunto é mineração.

Minerar é assinar e confirmar blocos no blockchain. É um serviço de manutenção — por isso você recompensa os mineradores com "taxas de transação" e alguns "satoshis" (frações de 1 Bitcoin) pelo trabalho. E por isso também o mecanismo se chama "Proof of Work": quando alguém encontra um nonce, sabemos que essa pessoa passou por uma enorme quantidade de computação de hashes para chegar lá.

Daí também falamos em "hash rates" quando nos referimos às CPUs ou GPUs dos mineradores. Você precisa de uma capacidade absurda para minerar Bitcoins hoje em dia. Ninguém usa um PC caseiro para isso. É preciso hardware especializado, como os famosos [AntMiners](https://www.cryptocompare.com/mining/bitmain/antminer-s9-miner/). Um AntMiner S9 de USD 1.500 consegue computar em torno de 14 TH/s.

Cada criptomoeda diferente do Bitcoin calcula hashes de forma distinta, então o hashrate varia de moeda para moeda.

O Hash Power total da rede de consenso do Bitcoin estava chegando próximo a 14 EH (exa-hashes, ou seja, milhões de tera-hashes).

Suponha que eu seja bilionário e queira trollar a comunidade Bitcoin adicionando hash power suficiente para superar o hash power total da rede. Precisaria comprar 1 milhão de AntMiner S9, um investimento de aproximadamente USD 1,5 bilhão! E isso sem contar a energia necessária para ligar e manter todas essas máquinas rodando.

Mesmo assim, sabe o que aconteceria? Lembra da variável de dificuldade que mencionei? Ela se ajusta novamente, garantindo que o próximo bloco continue levando 10 minutos para ser computado!

Então não: mesmo disposto a jogar USD 1,5 bilhão fora, você não vai quebrar. E é assim que o Bitcoin lida com os generais bizantinos nessa rede de consenso.
