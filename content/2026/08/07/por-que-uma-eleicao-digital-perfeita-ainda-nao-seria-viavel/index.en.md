---
title: "Why a Perfect Digital Election Still Wouldn't Be Viable?"
slug: "why-a-perfect-digital-election-still-wouldnt-be-viable"
date: '2026-08-07T10:00:00-03:00'
draft: false
translationKey: por-que-uma-eleicao-digital-perfeita-ainda-nao-seria-viavel
description: "A computer science exercise: how to build a digital election with end-to-end verifiability using commitments, Merkle trees, and zero-knowledge proofs, and why even that 'perfect' system still would not be viable in practice."
tags:
- politics
- security
- tutorials
---

Every election in Brazil turns into the same soap opera: half the country doesn't trust the result. And unlike most countries, there is nothing to recount. Brazil is one of the few countries in the world with a **100% digital** election: no paper receipt, no physical ballot, no possibility of an independent recount. Your vote goes into an electronic voting machine, becomes a number inside closed software, and out comes a tally. Either you trust the TSE (the Superior Electoral Court), or there's nothing you can do.

Recently the TSE put on a little theater show: it ["opened up the voting machine"](https://www.tse.jus.br/comunicacao/noticias/2026/Junho/eleicoes-2026-tse-abre-urna-eletronica-para-tecnicos-da-sociedade-brasileira-de-computacao) so technicians from the Brazilian Computer Society could look at the components. That's obviously useless. Showing a motherboard, a processor, and some memory chips proves there's no malware the way looking at a car's engine proves the driver is sober. Hardware is just the stage; the play happens in the software. And auditing the software is precisely what's hard, restricted, full of ritual and short windows — which completely defeats the purpose of public transparency. An audit that only a handful of credentialed people can perform, under supervision, for a few days, is not transparency. It's a performance.

And for the record: I'm not defending the current system, and I have zero expectations for it. As I summed up in [this tweet](https://x.com/AkitaOnRails/status/2084669984555331706): the voting machine is just a box, an old PC. Even if the software were perfect, it wouldn't matter — the processes around it stay secret, done behind closed doors. The machine is a smokescreen. With or without an alternative, I don't care about it.

Many people conclude from this that the answer is digital elections, but with a different system. This article is a computer science exercise: what would a hypothetically perfect system look like? And, more importantly, the final conclusion: **why even that perfect system would not be a viable option.**

One thing worth emphasizing before we start: the system I'm about to describe would require **no** secrecy from the government. No secret components, no secret processes, no locked rooms with credentialed people standing guard. Everything — the code, the data, the whole structure — could be 100% open, accessible to anyone, no restrictions whatsoever. And it would still be possible to prove, mathematically, that fraud is impossible. It's the exact opposite of the current model, where trust is born out of secrecy.

> No patience for code and math along the way? [Skip straight to the part where I explain why this wouldn't work](#why-this-would-never-work).

## "The machine is safe because it's not on the internet"

Sooner or later, every defender of the current system plays this card: the voting machine isn't connected to the internet, so it can't be hacked from the outside. Technically true. And completely beside the point.

First, because isolation says nothing about what the software does. An offline machine can flip votes just the same — you simply get no way to watch it happen. And malware doesn't need a network to get in: it can come from the factory, from an update, from the supply chain, from a technician with physical access. Stuxnet, the most famous worm in history, crossed the air gap into Iran's centrifuges on a USB stick. An air gap is an obstacle, not proof of honesty. And notice: the machine's data has to leave it somehow at the end of the day, on physical media carried around or through later transmission. "Not on the internet" is a logistical half-truth.

Second, and more important: that argument exposes the wrong mental model. The current system's security comes from **physical custody** — seals, locked rooms, accredited observers, rituals. In other words, once again, from trusting people and processes you cannot see.

In the system I'm about to describe, the machine could be **plugged straight into the internet**, publishing every vote to the public tree in real time, and fraud would still be impossible. Not because the network is safe, but because nobody needs to trust the machine:

- What it publishes are opaque commitments: even broadcasting everything live, there is no vote to leak in the published data.
- Every commitment carries a mathematical validity proof: the machine cannot mint an invalid vote.
- The tree is public and replicated by independent observers: nothing published can be altered later without breaking the hashes.
- And if the machine flips your vote at the booth, the Benaloh challenge catches it (that's Building block 4, further down): it cannot know whether you'll cast or audit.

Being online or not stops being the question. Security doesn't live in the absence of a network; it lives in public verification. "Trust us, the machine is locked in a room" becomes "don't trust anything, check the math." That inversion is the one thing the current model cannot offer.

## The tweet that started this

I recently posted [this tweet](https://x.com/AkitaOnRails/status/2085550756837335483) about end-to-end verifiability (E2E-V). The gist of the idea:

1. Every voter gets a paper receipt with a unique identifier — a hash — that **identifies neither the person nor the vote**.
2. Each precinct's votes go into a public structure you can only append to, never delete from (*append-only*): a Merkle tree (the same principle as a blockchain).
3. That tree is published in full. Any citizen downloads and verifies it.
4. **Individual verifiability:** each voter checks that their hash is there, no middleman.
5. **Universal verifiability:** anyone recomputes the tree and checks that it produces the announced total.

I made it explicit in the tweet: this is **not** a solution, it's a napkin sketch. The concept exists, it's mathematically solid, and it's old news to anyone in computer science. But the reaction was interesting.

## The voto de cabresto problem

A lot of the comments got stuck on the same point: the *voto de cabresto* — the "halter vote". It's a historical practice in Brazil: the local political boss buys a poor voter's vote and demands proof they voted "the right way". Back in the day it was the pre-marked ballot; today it would be a photo of the voting machine's screen (which is why phones are banned inside the booth).

And that raises an apparent contradiction:

- If the receipt the voter takes home **reveals** who they voted for, the vote can be coerced or sold.
- If the receipt **doesn't reveal** who they voted for, how does the voter check that their vote went to the right candidate?

I recently posted the answer, albeit only in passing: **zero-knowledge proofs** (ZK). The same principle behind truly anonymous cryptocurrencies like Monero and Zcash.

The flow would go like this: the voter picks the candidate on the screen; the machine generates a secret random number, computes `ciphertext = Enc(election_public_key, vote; random)`, produces a ZK proof that this ciphertext contains a valid vote, and publishes everything to a public Merkle tree. The voter takes home only a serial number. The serial **does not contain the vote**, but it lets you prove the vote exists in the tree and was not tampered with.

Here's what this looks like for programmers, step by step, with real values. And at the end I'll explain why, even working perfectly, this would fix nothing.

## Building block 1: hash as commitment

The foundation of everything is the hash function. A function like SHA-256 takes any input and produces 32 seemingly random bytes. Three properties matter here:

- **Deterministic:** same input, same output. Always.
- **One-way:** given the hash, there's no going back to the input.
- **Avalanche:** flip one bit of the input and the whole hash changes.

```python
import hashlib

def commit(voto, nonce):
    return hashlib.sha256(f"{voto}:{nonce}".encode()).hexdigest()
```

```text
commit('Candidato A', 987654321) = 337051f1dbc6a8ef412ecc14067c263d6a0dc83dada6939b51d74b6651727b69
commit('Candidato A', 123456789) = 55512bcd60924abf68d162f1a130023635089974db08ea9cff691e1f209898ab
commit('Candidato B', 987654321) = faf54e90eb84ba4c0446701c3779a382e48d02847bd2301f3836f673c54f9693
```

Look closely. The first and second hashes hide **the same vote** — what changes is the `nonce`, a random number that acts as "wrapping". The first and third share the same nonce, but different votes. The three hashes have no visible resemblance to one another.

This is a **commitment**: I publish the hash today, and tomorrow I can reveal `(vote, nonce)` and anyone can check the hash matches. I can't change my vote after publishing (the *binding* property), and nobody can figure out the vote before the reveal (the *hiding* property).

Except there's a problem for our election: if the voter takes home both the vote and the nonce, they can **show both to the coercer**, who verifies the hash and confirms the vote. The halter is back. We need something better.

## Building block 2: Pedersen commitments — hiding for real

The Pedersen commitment solves this with modular arithmetic. I'll use toy numbers so you can check the math by hand; real systems use 2048-bit primes or elliptic curves, but the math is identical.

Take a prime `p = 23` and two generators `g = 4` and `h = 8` (both generate a subgroup of order 11 modulo 23 — check it: `4^11 mod 23 = 1` and `8^11 mod 23 = 1`). The commitment to a vote `v` with nonce `n` is:

```text
C = g^v * h^n  (mod p)
```

```python
p, q, g, h = 23, 11, 4, 8

def pedersen(v, n):
    return (pow(g, v, p) * pow(h, n, p)) % p
```

```text
C(voto=1, n=3)  = 1
C(voto=1, n=9)  = 13
C(voto=0, n=3)  = 6
```

Same vote, different nonces, completely different commitments. Now the part that matters. Pedersen has a property called **perfect hiding**: for any commitment `C`, there **exists** a nonce that opens `C` as vote 0, and there **exists** a nonce that opens `C` as vote 1. With our toy prime we can prove it by brute force:

```python
C = 1  # the commitment from above, C(vote=1, n=3)

for n in range(11):
    if pedersen(0, n) == C:
        print(f"C abre como voto=0 com nonce {n}")
    if pedersen(1, n) == C:
        print(f"C abre como voto=1 com nonce {n}")
```

```text
C=1 abre como voto=0 com nonce 0
C=1 abre como voto=1 com nonce 3
```

Read that again, because this is the heart of the article. The commitment `C = 1` is consistent with **both stories**. Anyone who sees only `C` has no way to know which one is true — not by brute force, not with a quantum computer, because both openings exist mathematically. The value `C` simply does not contain the vote's information.

"Hold on," you say, "so the voter can change their vote afterwards?" No, and that's the other half of the property: the commitment is **computationally binding**. Whoever generated the commitment with `(vote=1, n=3)` can only reveal the other opening (`vote=0, n=0`) if they can compute a discrete logarithm — that is, find `x` such that `g^x = h mod p`. With `p = 23` that's trivial; with 2048 bits, it's computationally impossible. To sum up:

- **Outsiders** can't discover the vote (hiding).
- **Whoever committed** can't change the vote afterwards (binding).

And the final detail that kills the halter vote: **the machine generates the nonce, not the voter.** The voter sees their choice on the screen, the machine makes the commitment internally, discards the nonce, and prints only the `C` — the serial. The voter leaves the booth with no way to open their own commitment, even if they want to.

## Building block 3: the Merkle tree — a ballot box anyone can audit

Where do these commitments live? In a public structure anyone can download and verify: a Merkle tree. If you watched my video on [cryptography in practice — certificates, BitTorrent, Git, Bitcoin](/2023/11/10/akitando-147-criptografia-na-pratica-certificados-bittorrent-git-bitcoin/), you've seen this structure in action: it's the same one that scales BitTorrent, organizes Git commits, and packs the transactions of a Bitcoin block.

The construction is simple: each leaf is the hash of a vote (one voter's commitment `C`), and each internal node is the hash of the concatenation of its two children, until a single hash remains at the top: the **root**.

```python
def H(x):
    return hashlib.sha256(x.encode()).hexdigest()

eleitores = [(1, 3), (0, 7), (1, 2), (1, 10), (0, 5), (1, 1), (0, 8), (1, 4)]
leaves = [H(f"{i}:{pedersen(v, n)}") for i, (v, n) in enumerate(eleitores)]
```

With the 8 example votes, the leaves look like this (hashes abbreviated):

```text
eleitor 0: voto=1 nonce=3  -> C=1  -> folha=ef134f2a180ba05d...
eleitor 1: voto=0 nonce=7  -> C=12 -> folha=ce356d2f943ea5af...
eleitor 2: voto=1 nonce=2  -> C=3  -> folha=8e0375adfc1f4563...
eleitor 3: voto=1 nonce=10 -> C=12 -> folha=df284a49f837c454...
eleitor 4: voto=0 nonce=5  -> C=16 -> folha=fd6df9e3530cb74f...
eleitor 5: voto=1 nonce=1  -> C=9  -> folha=e0e9d38f9ccb7a41...
eleitor 6: voto=0 nonce=8  -> C=4  -> folha=e719f7fde83fafda...
eleitor 7: voto=1 nonce=4  -> C=8  -> folha=1393ac80e69a8991...

RAIZ PUBLICA: 48826b6481b574e37156f85e34d877105bc55073fb5a5b981239572a8e7c4b61
```

(The votes and nonces in the table are shown in the clear only so you can check the math; the public tree holds only the leaves — opaque hashes.)

The root is the "summary" of the whole election: 32 bytes representing every vote. If **a single bit** of a single vote changes, the root changes completely. The root and the entire tree get published. Any citizen, at home, with open-source code, rebuilds the tree and checks whether the published root matches. That's **universal verifiability**.

Now the individual part. Suppose you're voter 4. Your receipt is the serial — the leaf `fd6df9e3530cb74f1f0795b751a43454cab281a431d0558b413e33bba83a4100`, which is the hash of your commitment `C = 16` at position 4 in the tree. To prove it's in the tree, you don't need to download and check all 8 votes — you need only `log2(8) = 3` hashes, the path of "siblings" up to the root:

```python
def merkle_verify(leaf, proof, root):
    cur = leaf
    for h_, side in proof:
        cur = H(h_ + cur) if side == "esq" else H(cur + h_)
    return cur == root
```

```text
prova do eleitor 4:
  (dir) e0e9d38f9ccb7a41...  (irmão: folha do eleitor 5)
  (dir) 3149c3bf17d98fbc...  (irmão: nó dos eleitores 6-7)
  (esq) 3b902c849a40619b...  (irmão: nó dos eleitores 0-3)

verificação local: True
tentando folha adulterada: False
```

You take your serial, concatenate it with the 3 proof hashes in the right order, hash three times, and check whether you land on the public root. If you do, it's **mathematically impossible** for your vote not to be in the tree — because producing a fake proof would require finding a SHA-256 collision, and nobody on the planet knows how to do that. If someone swaps your vote afterwards, your proof stops working and you hold evidence of the fraud in your hand. In a real election with 150 million votes, the proof would be about 28 hashes — fits on a paper receipt or a QR code.

Notice what just happened: you proved that **a piece of information is in the public tree** and that **nobody messed with it**, carrying home only a 32-byte number that, by itself, says absolutely nothing about the content. That's what people mean by "zero knowledge" in this context: the verification happens without the knowledge (the vote) ever having to travel.

## Building block 4: the Benaloh challenge — checking the machine on the spot

There's one blind spot left. The machine shows "vote recorded" on the screen and prints your serial `C`. At home, you confirm that `C` sits in the tree. All good? Not quite. What if the machine **lied** and committed a different vote? The screen shows the candidate you picked, but under the hood it computed the commitment for another one. You would never notice, because the commitment is opaque by design. That's the hiding property working against you.

The classic fix comes from cryptographer Josh Benaloh, and it goes by **Benaloh challenge** (or *cast-or-challenge*). The idea: after the machine shows the commitment `C` on screen, but **before** you confirm, you get two options:

- **Cast**: the vote counts, enters the tree, and the nonce is destroyed forever.
- **Challenge**: you declare that ballot a **test vote**. The machine must reveal the nonce and the vote it put inside the commitment, and you redo the math on the spot — in an independent app, on your own phone, not on the machine's software:

```python
# the machine showed on screen: C = 1
# you challenged; the machine reveals: vote=1, nonce=3
pedersen(1, 3) == 1   # True -> the machine committed exactly what you picked
```

If it matches, the machine was honest **on that ballot**. The test ballot is spoiled and never enters the tally — the revealed nonce would make it readable — and you vote again, for real this time.

Now suppose a rigged machine that flips a fraction of the votes. You pick `vote=1`; it internally records `vote=0` and shows `C = 12` on screen (`pedersen(0, 7) = 12`). If you **cast**, the fraud sails through. But if you **challenge**, the machine is cornered: it has to reveal a `(vote, nonce)` pair that opens `C = 12`. The only one it knows is `(0, 7)` — and revealing that exposes the swap right in front of you: "I voted 1!". Opening it as `vote=1` would require finding a nonce `n` with `pedersen(1, n) = 12`, which is the discrete log problem all over again. With our toy prime a brute force search finds one (`n = 10` exists), but with 2048-bit primes a cheating machine flat out cannot produce the answer.

And what springs the trap: the machine **cannot know in advance** whether you'll cast or challenge. The decision is yours, made after the commitment is already on screen. If a slice of the electorate tests a few ballots before voting for real, a machine that flips votes at scale gets caught with overwhelming probability. Real verifiable voting systems like Helios and ElectionGuard use exactly this mechanism.

And notice this breaks nobody's secrecy: the revealed nonce belongs to a **spoiled** ballot that doesn't count. The vote that counts keeps its nonce destroyed and its commitment impenetrable.

## Building block 5: a real zero-knowledge proof — Schnorr

One last piece is missing. What guarantees that each commitment in the tree contains a **valid vote** — and not, say, `vote = 500`, which would inflate the result? The machine must prove the commitment opens to a legitimate value **without opening the commitment**. That's a zero-knowledge proof in the strict sense.

The canonical example, and one you can demonstrate with small numbers, is the **Schnorr** protocol: proving you know a secret `s` such that `y = g^s mod p`, without revealing `s`. The intuition before the math: it's Ali Baba's cave. The cave has two passages that meet at a locked door. You prove you have the key by walking in one side and coming out whichever side the verifier calls — without ever showing the key. Without the key, you'd only guess the call right by luck, 50% of the time; after 20 rounds, the odds of fooling anyone are below one in a million.

The mathematical version, with our toy numbers (`p = 23`, `g = 4`, order `q = 11`):

```python
segredo = 7
y = pow(g, segredo, p)   # y = 4^7 mod 23 = 8  (public value)

# 1. commitment: the prover picks a random r and sends t
r = 3
t = pow(g, r, p)          # t = 4^3 mod 23 = 18

# 2. challenge: the verifier picks a random c
c = 5

# 3. response: the prover computes z
z = (r + c * segredo) % q  # z = (3 + 5*7) mod 11 = 5

# verification: g^z == t * y^c (mod p)
esq = pow(g, z, p)                 # 4^5 mod 23 = 12
dir = (t * pow(y, c, p)) % p       # 18 * 8^5 mod 23 = 12
print(esq == dir)                  # True
```

It works because `g^z = g^(r + c·s) = g^r · (g^s)^c = t · y^c`. The algebra checks out. Now observe what the verifier saw: the numbers `t`, `c`, `z`, and the final check. At no point did the secret `s = 7` show up. And an impostor who doesn't know `s` can't answer an arbitrary challenge: if they guess `z = 2`, the verifier computes `g^2 = 16 ≠ 12` and the fraud is exposed.

And why does the verifier learn **nothing** about `s`, rather than just "not much"? Because the whole conversation could have been fabricated by someone who **doesn't know the secret**, in this inverted order:

```python
# simulator: pick c and z FIRST, then compute the t that closes the equation
c_sim, z_sim = 5, 9
t_sim = (pow(g, z_sim, p) * pow(y, -c_sim % q, p)) % p  # t = 8

# checking the forged transcript:
pow(g, z_sim, p)              # 4^9 mod 23 = 13
(t_sim * pow(y, c_sim, p)) % p  # 8 * 8^5 mod 23 = 13  -> it matches!
```

The forged transcript `(t=8, c=5, z=9)` passes verification and is **indistinguishable** from a real one. If anyone can fabricate a valid conversation without knowing the secret, then the real conversation cannot contain any information about the secret. That's what "zero knowledge" formally means. (For use outside a lab, the challenge `c` is derived by hashing the commitment — the Fiat-Shamir transform — and the proof becomes a single, non-interactive object that anyone verifies offline.)

In our hypothetical election, the machine publishes, alongside each vote, a proof of this kind — in practice, an OR-variant ("the vote is 0 **or** it is 1", without saying which) — and any auditor verifies that every vote in the tree is valid, without ever seeing a single one.

## Putting it all together: the full protocol

The hypothetically perfect election would go like this:

1. **Setup.** A group of independent authorities (the electoral court, the bar association, parties, civil society) jointly generates the election's public key. The corresponding private key stays fragmented: no single authority can decrypt anything; only a majority acting together can.
2. **Voting.** The voter picks the candidate on the screen. The machine generates a random nonce, computes the Pedersen commitment (or an equivalent ElGamal ciphertext), produces the ZK validity proof, and shows the commitment on screen. The voter then decides: cast, and the nonce is destroyed — or challenge, and the machine reveals the nonce for an on-the-spot check, the ballot is spoiled, and they vote again.
3. **Publication.** The commitment goes into a public Merkle tree, replicated and signed by multiple independent observers.
4. **Receipt.** The voter takes home a slip of paper with the serial. They **cannot** prove to anyone who they voted for — even if they want to, because they don't have the nonce.
5. **Individual verification.** At home, the voter downloads the tree (or uses any independent website) and checks their serial is there, with the inclusion proof. If it isn't, they hold material proof of fraud.
6. **Universal verification.** Any citizen, university, or party rebuilds the entire tree, checks the root, and validates every ZK proof.
7. **Tallying.** In the end, the encrypted votes go through a mix-net (they get re-shuffled and re-encrypted, severing the link to their original positions) and the authorities decrypt jointly, proving each step. The total matches the public root, or the fraud is evident.

Notice what changed relative to the current system: **you no longer need to trust the electoral court, the voting machine, or any auditor.** Every property is individually verifiable by anyone with a computer. It's the same principle that lets Bitcoin work without a central bank: don't trust, verify.

Before anyone gets too excited: this is a simplification. A real system still has to solve voter authentication without allowing identity-to-vote linkage, recording who already voted without revealing for whom, tree availability, and a pile of operational details. The point here is not the complete design; it's the core mechanism.

## Why this would never work

Now for the part almost nobody proposing these systems wants to hear.

Scroll back to the beginning of this article and notice what I had to explain to get here: hash functions, commitments, modular arithmetic, discrete logarithms, Merkle trees, the Benaloh challenge, zero-knowledge proofs, simulators. With code, with numbers, with step-by-step examples. And even so, I'd bet a good share of readers — programmers included — made it here without full certainty that they truly understand why the scheme is secure.

And that's not for lack of intelligence. It's because trusting this system requires understanding math that the vast majority of the population will never understand. The only human being who can be **100% certain** this system is correct is the one who can verify the mathematical proofs on their own. Everyone else — 99.9% of the population — wouldn't be *verifying* anything. They'd be **believing** the mathematician who says it works.

And here we hit the fatal contradiction: if an electoral system requires the ordinary citizen to blindly believe a specialist they can't audit, it is **exactly as opaque as the TSE's current system**. The opacity just moved address: instead of trusting the court bureaucrat, you trust the cryptographer. For dona Maria, who sells pastel at the street market, it's all the same — both are "a bunch of mumbo-jumbo I don't understand". And a system the population cannot understand is a system whose legitimacy it will never accept. Today's skeptic saying "I don't trust the voting machine" would become tomorrow's skeptic saying "I don't trust this algebra".

An election is not only an engineering problem; it's a **social trust** problem. The gold standard of transparency is the system **anyone can watch with their own eyes**: paper ballot, glass ballot box, public counting at the precinct, the tally posted on the door. Anyone understands paper being counted in public. Nobody has to believe anybody.

That's why countries far richer and more technological than Brazil — Germany, the Netherlands, France, most of the US — stick with paper or demand an auditable paper trail. That's not backwardness. It's the recognition that verifiability only specialists understand is not public verifiability.

## Sidebar: what cryptocurrencies prove every day

Before wrapping up, a detour to answer the question that always comes up: "but does this actually work, or is it napkin theory?" It works. And the proof has been running for almost two decades, moving billions of dollars, under constant attack: blockchains.

First, clearing up a misunderstanding: **blockchain is not synonymous with cryptocurrency.** As the name says, it's just a chain of blocks. Each block carries a Merkle tree of records and the previous block's hash. In Bitcoin, the block header holds the transaction tree's root, the previous block's hash, a timestamp, and a nonce — here, a mining counter — that miners vary until the hash of the entire block falls below the difficulty target: the famous proof of work. It's Building block 3 of this article, extended through time: not one tree, but a chain of trees, each sealing the one before.

The practical result is the guarantee that matters here: tamper with **one transaction** in an old block and the tree's root changes, the block's hash changes, the link to the next block breaks, and to hide that you'd need to redo the proof of work of every block up to today — while thousands of honest nodes keep extending the true chain. Once everything is signed and sealed by hash, rewriting the past is computationally impossible. That's exactly why Bitcoin can be 100% public: the exposure itself is the protection. Everyone has a copy of everything, so nobody rewrites history.

**But public does not mean anonymous.** That's the part most people get wrong. In Bitcoin, every transaction stays visible forever: which addresses fed it, which received, how much moved. Addresses are pseudonyms — pen names, not anonymity. And there's an entire chain-analysis industry (Chainalysis, Elliptic, TRM) making a living gluing identities to those pen names:

- **Common-input heuristic:** if a transaction spends coins from several addresses, they almost certainly belong to the same wallet. Group them into a cluster.
- **Change detection:** the output that returns to a fresh address usually belongs to the payer.
- **Bridge to the real world:** when a cluster's address touches a KYC exchange, a name and a tax ID attach to the whole cluster — and to its complete history, retroactively.

That's how the FBI recovered part of the Colonial Pipeline ransom, that's how the Silk Road coins were traced years later, and that's how the ~1,128 BTC stolen from ColdCards are still sitting in known addresses half the world is watching — I detailed it in the [article about Coinkite's RNG](/en/2026/08/01/exploiting-coinkites-rng-egregious-problem/). If the thief moves a single satoshi to a KYC exchange, they identify themselves. The chain guarantees integrity, not secrecy.

For real anonymity, the chain alone doesn't cut it: you need zero-knowledge proofs. Monero, for instance, combines three techniques:

1. **Ring signatures:** each spend is signed on behalf of a group of possible keys. The signature proves **one of them** authorized it, without revealing which.
2. **Stealth addresses:** the recipient's address never appears on the chain; each payment creates a disposable address derived from a shared secret.
3. **RingCT** (*confidential transactions*): amounts stay hidden inside **Pedersen commitments** — yes, the exact same Building block 2 from this article — and a ZK range proof guarantees nobody minted coins out of thin air, without revealing any amount.

Zcash follows the same philosophy with zk-SNARKs: you prove "I own a valid, unspent note" without revealing which note. The network verifies the proof, accepts the transaction, and learns neither sender, recipient, nor value.

And here the circle closes. Look at what this article's electoral scheme uses: a public, immutable structure anyone can verify (the Merkle tree, the blockchain's simpler cousin), Pedersen commitments to hide content (the same primitive as Monero), and ZK proofs to guarantee validity without revelation (the same family as Monero and Zcash). None of this is lab conjecture: these are production systems, audited, attacked daily, protecting real money. An election is, if anything, a simpler problem — short window, a single publisher, offline verification.

That's why I said at the beginning that the idea is mathematically solid: it invents nothing, it just composes pieces that already proved they can survive the real world. We know an end-to-end verifiable digital election **could** be built, because every one of its components is already built and running. Which brings us back to the problem that isn't technical.

## Conclusion

Let me make it clear once more, as I did in the tweets: **this is not a proposal, it's an exercise.** I don't know the solution to Brazil's electoral trust problem. If I did, I'd be publishing a paper, not a blog post.

But the exercise is worth it for two reasons. First, because it shows the technology for individual and universal verifiability **exists** — anyone who says "digital elections are inherently unauditable" is wrong. Second, because it shows the real limit: the frontier isn't technical, it's epistemological. A perfect system nobody understands fails at the same point as an imperfect system nobody can audit.

If you understood every line of this article, congratulations: you're part of a minority far too small to carry a democracy on its back.
