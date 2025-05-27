---
title: How does Bitcoin force consensus among Byzantine generals?
date: '2017-11-01T14:02:00-02:00'
slug: how-does-bitcoin-force-consensus-among-byzantine-generals
tags:
- ruby
- blockchain
- cryptocurrency
- bitcoin
draft: false
---

_"Is it possible to break the blockchain?"_

Now, this is a fair question. If you know anything about the blockchain architecture, you instinctively conclude that "no", it's quite improbable that anyone will break it. In practice, it's basically impossible.

It's quite amazing that most of my peer programmers have a very difficult time overcoming the prejudice against cryptocurrencies. I have no idea where this prejudice comes from, but I know very smart people that can solve the most difficult web scalability problems, but that never once glanced over Satoshi Nakamoto extremely short original paper describing the blockchain.

Seriously, the [Bitcoin: A Peer-to-Peer Electronic Cash System](https://bitcoin.org/bitcoin.pdf) paper is so ridiculously small and easy to understand that most computer science students should be able to understand it. So all the smart programmers I know should be able to grasp it in a coffee break. Any average programmer should be able to read and understand this paper in 30 minutes or so.

You can simplify a mental model of it as a Linked List, each node of the List is what we call a Block. Each Block is a stupid struct with the usual previous/next pointers and a body comprised of a tree-like structure (a [Merkle Tree](https://brilliant.org/wiki/merkle-tree/), to be more exact).

The catch is that each block has the hash signature of the previous block, thus creating a secure "chain". Hence "block-chain".

Yes, in computer science terms, we're dealing with undergraduate levels of data structures here. If you understand a Linked List and a stupid Binary Tree, plus the easiest crypto thing to understand, a stupid Digest Hash such as SHA256, and boom, you understand the basic backbone of the blockchain database.

Yes, it is just a database. A distributed-database to be more exact. Or a very crude and simple distributed database for that matter. It is not very efficient, and it pales in comparison to more serious NoSQL distributed databases such as Redis or Cassandra. So the query-abilities are basically non-existent beyond finding a block by its identity.

Of course, the Bitcoin source-code is more sophisticated than that but the basics are really so ridiculous that you don't need more than 20 lines of Ruby code to replicate it. Check out this example implementation from [Gerald Bauer](https://github.com/openblockchains/awesome-blockchains/tree/master/blockchain.rb).

--- ruby
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

I know, right!?

One question remains: how does this stupid structure become a "distributed" database.

Now, either you need to have a centralized "master-copy" out of which all other copies replicate from. Or you need some form of "consensus" between the different copies.

How do you reach consensus between rogue, random node spread across the globe? This is the problem that is called ["Byzantine Fault Tolerance"](http://pmg.csail.mit.edu/papers/osdi99.pdf), masterfully explained and solved by Barbara Liskov and Miguel Castro, from MIT, in 1999.

In a nutshell, imagine that you have Byzantine generals, each with their own armies, surrounding a hostile city. Now, you can either attack or retreat. But all generals must either do one or the other, in consensus. How do you reach consensus when you don't have direct communication with all the generals and, worse, when some of the generals may be traitors or double-agents?

That's the kind of problem we face here. Anyone on the internet can download a copy of the blockchain, and they can check that the blocks are valid and unadulterated by recomputing the digest hashes for each block.

But how do you add new blocks and make the other nodes accept your new block?

That's why Satoshi added the so-called "Proof of Work" to the equation. Remember that I said that each block is chained together to the previous by containing the hash of the previous block? Computing a digest hash is quite trivial these days.

In Ruby if you do:

--- ruby
Digest::SHA256.hexdigest("abcd")
# => "88d4266fd4e6338d13b845fcf289579d209c897823b9217da3e161936f031589"
Digest::SHA256.hexdigest("123")
# => "a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3"
```

It takes a **fraction of millisecond** to run.

Now, what if I ask you to find the hash that starts with a certain amount of "zeroes" in the beginning of the hash?

For example:

--- ruby
# I want to find 4 zeros ("0000") in the hash:
Digest::SHA256.hexdigest("79026" + "123")
# => "0000559fb4a55f135c7db3d83405b86b4b63cd035993873a5b676bae08b64334"
```

How do I know that I had to prepend "79026"? I don't, I have to start from 0 and incrementing one by one until I find the hash with the format I want.

If we check from [Gerald' example](https://github.com/openblockchains/awesome-blockchains/blob/master/blockchain.rb/blockchain_with_proof_of_work.rb#L29-L45) we would implement this lookup like this:

--- ruby
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

Just a simple SHA256 takes somewhere between 0.000010 to 0.000020 seconds (remember: fractions of milliseconds). Now how long does it take to find that "79026" (which we call a "nonce")?

```
> puts Benchmark.measure { compute_hash_with_proof_of_work("0000") }
  0.190000   0.000000   0.190000 (  0.189615)
```

Yep, considerably more, now it takes 0.18 seconds instead of 0.000020. We can increase the "difficult" variable to make it even more laborious to find the nonce. And that's exactly how Bitcoin is implemented: each block adjusts the difficult so the fastest one can take to find the hash for the next block is around 10 minutes.

And this, my friends, is what we call **"MINING"**. What a miner does is compute a loop, incrementing nonces, over the block digest to find the correct nonce.

Once a nonce is found, the miner can add the block to the blockchain and broadcast it to other nodes. The other nodes can then double-check (and now it's just the 0.000020 seconds procedure again, super fast).

When the nodes double-check and confirm the nonce, they all add the block to the top of the blockchain. And usually, when the other miners keep adding other blocks on top of that, that block becomes "solidified". The most recent block on the top of the blockchain is usually unstable, but once you have more blocks on top of it, it is said to be more "guaranteed". Which is why most exchanges and other services that accept bitcoin wait for the so-called "6 blocks" confirmation.

And because the difficulty is such that the fastest node takes around "10 minutes" to find that nonce, a block is said to be "secure" when around 1-hour passes and 6 blocks are added after it.

## Can we break this?

Now, you will understand why we talk about "hash power" when we talk about mining.

Mining is the act of signing and confirming blocks to the blockchain. It's a maintenance service, which is why you reward miners with "transaction fees" and a couple of "satoshis" (fractions of 1 Bitcoin), for their work. And also why you call this "Proof of Work" because when someone finds a nonce, we know it had to go through a lot of hash computation to reach it.

And also why we talk about CPUs or GPUs that miners use to have "hash rates". You need to have an absurd capacity to be able to mine Bitcoins nowadays. No one will use a home-built rig to do it. One must build special hardware, such as the famous [AntMiners](https://www.cryptocompare.com/mining/bitmain/antminer-s9-miner/). A USD 1,500 AntMiner S9 is able to compute around 14 TH.

Each crypto-currency different from Bitcoin calculates hashes differently so the hashrate differs from coin to coin.

The current Hash Power of the entire Bitcoin consensus network is almost reaching 14 EH (exa-hashes or millions of tera-hashes).

So, let's say that I am a billionaire and I want to troll the Bitcoin community by adding enough hash power to surpass the entire hash power of the network. I'd have to buy 1 million AntMiner s9, or an investment of around USD 1.5 billion! And this is without adding the energy required to boot and run those machines, of course.

But even then, do you know what happens? Remember that difficult variable I mentioned above? It will adjust again, to make sure the next block takes 10 minutes to compute again!

Then, no, even if you're willing to put USD 1.5 billion to waste, you won't break it. And that's how Bitcoin deals with Byzantine generals in this consensus network.
