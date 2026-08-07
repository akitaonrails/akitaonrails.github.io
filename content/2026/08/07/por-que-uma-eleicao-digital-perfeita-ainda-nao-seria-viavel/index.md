---
title: "Por que uma eleição digital perfeita ainda não seria viável?"
slug: "por-que-uma-eleicao-digital-perfeita-ainda-nao-seria-viavel"
date: '2026-08-07T10:00:00-03:00'
draft: false
translationKey: por-que-uma-eleicao-digital-perfeita-ainda-nao-seria-viavel
description: "Um exercício de ciência da computação: como montar uma eleição digital com verificabilidade ponta a ponta usando compromissos, Merkle trees e provas de conhecimento zero, e por que mesmo esse sistema 'perfeito' não serviria na prática."
tags:
- politica
- seguranca
- tutoriais
---

Toda eleição no Brasil vira a mesma novela: metade do país não confia no resultado. E, diferente da maioria dos países, aqui não tem o que recontar. O Brasil é um dos poucos países do mundo com eleição **100% digital**: sem recibo de papel, sem cédula física, sem possibilidade de recontagem independente. O voto entra numa urna eletrônica, vira um número dentro de um software fechado e sai um boletim. Ou você confia no TSE, ou não tem o que fazer.

Recentemente o TSE fez um teatrinho: ["abriu a urna"](https://www.tse.jus.br/comunicacao/noticias/2026/Junho/eleicoes-2026-tse-abre-urna-eletronica-para-tecnicos-da-sociedade-brasileira-de-computacao) pra técnicos da Sociedade Brasileira de Computação verem os componentes. Isso é obviamente inútil. Mostrar placa-mãe, processador e memória não prova que não existe malware. Hardware é só o palco; a peça acontece no software. E auditar o software é justamente o que é difícil, restrito, cheio de ritual e janela curta — o que derrota completamente o propósito de transparência pública. Uma auditoria que só meia dúzia de credenciados consegue fazer, sob supervisão, por alguns dias, não é transparência. É encenação.

E pra deixar claro: eu não defendo o sistema atual, nem tenho expectativa nenhuma nele. Como resumi [neste tweet](https://x.com/AkitaOnRails/status/2084669984555331706): a urna é só uma caixa, um PC velho. Mesmo que o software fosse perfeito, não faria diferença — os processos ao redor continuam secretos, feitos debaixo dos panos. A urna é cortina de fumaça. Com ou sem alternativa, eu não ligo pra ela.

Muita gente conclui daí que o certo seria ter eleição digital, mas com um sistema diferente. Esse artigo é um exercício de ciência da computação: como seria um sistema hipoteticamente perfeito? E, mais importante, a conclusão final: **por que mesmo esse sistema perfeito não seria uma opção viável.**

Uma coisa que vale enfatizar antes de começar: o sistema que vou descrever não exigiria **nenhum** segredo do governo. Nenhum componente secreto, nenhum processo secreto, nenhuma sala trancada com credenciado vigiando. Tudo — o código, os dados, a estrutura inteira — poderia ser 100% aberto, acessível pra qualquer pessoa, sem restrição nenhuma. E ainda assim seria possível provar, matematicamente, que fraudar é impossível. É exatamente o oposto do modelo atual, em que a confiança nasce do sigilo.

> Sem paciência pra código e matemática no meio do caminho? [Pule direto pra parte em que explico por que isso não funcionaria](#e-por-que-isso-nunca-funcionaria).

## "A urna é segura porque não está na internet"

Todo defensor do sistema atual saca esse argumento mais cedo ou mais tarde: a urna não está conectada à internet, logo não pode ser hackeada de fora. Tecnicamente é verdade. E é completamente irrelevante.

Primeiro, porque isolamento não diz nada sobre o que o software faz. Uma urna offline pode trocar votos do mesmo jeito — você só não tem como assistir ela fazendo isso. E malware não precisa de rede pra chegar: pode vir de fábrica, numa atualização, na cadeia de suprimentos, de um técnico com acesso físico. O Stuxnet, o worm mais famoso da história, atravessou o air gap das centrífugas iranianas via pendrive. Air gap é obstáculo, não é prova de honestidade. E repare: o dado da urna precisa sair dela de algum jeito no fim do dia, em mídia física transportada ou transmissão posterior. "Não está na internet" é uma meia-verdade logística.

Segundo, e mais importante: esse argumento revela o modelo mental errado. A segurança do sistema atual nasce de **custódia física** — lacres, salas trancadas, credenciados, rituais. Ou seja, mais uma vez, de confiar em gente e em processo que você não vê.

No sistema que vou descrever, a urna poderia estar **ligada direto na internet**, publicando cada voto na árvore pública em tempo real, e ainda assim seria impossível fraudar. Não porque a rede seja segura, mas porque ninguém precisa confiar na urna:

- O que ela publica são compromissos opacos: mesmo transmitindo tudo ao vivo, não existe voto pra vazar nos dados publicados.
- Cada compromisso carrega uma prova matemática de validade: a urna não consegue inventar voto inválido.
- A árvore é pública e replicada por observadores independentes: nada do que foi publicado pode ser alterado depois sem quebrar os hashes.
- E se a urna trocar seu voto na hora, o desafio de Benaloh pega (é a Peça 4, mais adiante): ela não sabe se você vai confirmar ou auditar.

Estar ou não na internet deixa de ser a questão. A segurança não mora na ausência de rede; mora na verificação pública. "Confie, a máquina está trancada numa sala" vira "não confie em nada, confira a matemática". Essa inversão é a única coisa que o modelo atual não consegue oferecer.

## O tweet que começou isso

Recentemente eu postei [este tweet](https://x.com/AkitaOnRails/status/2085550756837335483) sobre verificabilidade ponta a ponta (E2E-V, *end-to-end verifiability*). O resumo da ideia:

1. Cada eleitor recebe um recibo em papel com um identificador único — um hash — que **não identifica a pessoa nem o voto**.
2. Os votos de cada urna entram numa estrutura pública onde só se acrescenta, nunca se apaga (*append-only*): uma Merkle tree (o mesmo princípio de uma blockchain).
3. Essa árvore é publicada na íntegra. Qualquer cidadão baixa e verifica.
4. **Verificabilidade individual:** cada eleitor checa se o seu hash está lá, sem intermediário.
5. **Verificabilidade universal:** qualquer um refaz a conta da árvore e confere se ela produz o total anunciado.

Eu deixei explícito no tweet: isso **não** é uma solução, é uma ideia de guardanapo. O conceito existe, é matematicamente sólido e não é novidade pra ninguém de ciência da computação. Mas a reação foi interessante.

## O problema do voto de cabresto

Boa parte dos comentários travou no mesmo ponto: o voto de cabresto. No Brasil isso é prática histórica: o coronel compra o voto do eleitor pobre e exige prova de que ele votou "direito". Antigamente era a cédula pré-marcada; hoje seria a foto da tela da urna (por isso celular é proibido na cabine).

E aí surge a aparente contradição:

- Se o recibo que o eleitor leva pra casa **revela** pra quem ele votou, ele pode ser coagido ou vendido.
- Se o recibo **não revela** pra quem ele votou, como o eleitor confere que o voto dele foi pro candidato certo?

Recentemente postei a resposta, ainda que só de passagem: **prova de conhecimento zero** (zero-knowledge proof, ZK). O mesmo princípio por trás de criptomoedas verdadeiramente anônimas como Monero e Zcash.

O fluxo seria assim: o eleitor escolhe o candidato na tela; a urna gera um número aleatório secreto, computa `ciphertext = Enc(chave_publica_da_eleicao, voto; aleatorio)`, gera uma prova ZK de que esse ciphertext contém um voto válido, e publica tudo numa Merkle tree pública. O eleitor leva pra casa só um número de série. O serial **não contém o voto**, mas permite provar que o voto existe na árvore e não foi adulterado.

Agora vamos destrinchar isso pra programador, passo a passo, com valores reais — e no final eu explico por que isso, mesmo funcionando perfeitamente, não resolveria nada.

## Peça 1: hash como compromisso

A fundação de tudo é a função de hash. Uma função como SHA-256 pega qualquer entrada e produz 32 bytes aparentemente aleatórios. Três propriedades importam aqui:

- **Determinística:** mesma entrada, mesma saída. Sempre.
- **Unidirecional:** dado o hash, não dá pra voltar à entrada.
- **Avalanche:** mudar um bit da entrada muda o hash inteiro.

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

Olhe com atenção. O primeiro e o segundo hash escondem **o mesmo voto** — o que muda é o `nonce`, um número aleatório que serve de "embalagem". O primeiro e o terceiro têm o mesmo nonce, mas votos diferentes. Os três hashes não têm nenhuma semelhança visível entre si.

Isso é um **compromisso** (*commitment*): eu publico o hash hoje, e amanhã posso revelar `(voto, nonce)` e qualquer um confere que o hash bate. Eu não consigo mudar o voto depois de publicado (propriedade *binding*), e ninguém consegue descobrir o voto antes da revelação (propriedade *hiding*).

Só que tem um problema pra nossa eleição: se o eleitor leva pra casa o voto e o nonce, ele pode **mostrar os dois pro coagidor**, que verifica o hash e confirma o voto. Cabresto de volta. Precisamos de algo melhor.

## Peça 2: compromissos Pedersen — esconder de verdade

O compromisso de Pedersen resolve isso com aritmética modular. Vou usar números de brinquedo pra você poder conferir na mão; sistemas reais usam primos de 2048 bits ou curvas elípticas, mas a matemática é idêntica.

Pegue um primo `p = 23` e dois geradores `g = 4` e `h = 8` (ambos geram um subgrupo de ordem 11 módulo 23 — confira: `4^11 mod 23 = 1` e `8^11 mod 23 = 1`). O compromisso de um voto `v` com nonce `n` é:

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

Mesmo voto, nonces diferentes, compromissos completamente diferentes. O Pedersen tem uma propriedade chamada **ocultação perfeita** (*perfectly hiding*): para qualquer compromisso `C`, **existe** um nonce que abre `C` como voto 0, e **existe** um nonce que abre `C` como voto 1. Com nosso primo de brinquedo dá pra provar por força bruta:

```python
C = 1  # o compromisso de cima, C(voto=1, n=3)

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

Leia de novo, porque este é o coração do artigo. O compromisso `C = 1` é compatível com **as duas histórias**. Quem vê só o `C` não tem como saber qual é a verdadeira — nem por força bruta, nem com computador quântico, porque ambas as aberturas existem matematicamente. O valor `C` simplesmente não contém a informação do voto.

"Mas espera", você diz, "então o eleitor pode trocar de voto depois?". Não, e essa é a outra metade da propriedade: o compromisso é **computacionalmente vinculante** (*computationally binding*). Quem gerou o compromisso com `(voto=1, n=3)` só consegue revelar a outra abertura (`voto=0, n=0`) se conseguir calcular logaritmo discreto — ou seja, descobrir `x` tal que `g^x = h mod p`. Com `p = 23` é trivial; com 2048 bits, é computacionalmente impossível. Resumo:

- **Quem olha de fora** não descobre o voto (ocultação).
- **Quem gerou** não consegue mudar o voto depois (vinculação).

E o detalhe final que mata o cabresto: **quem gera o nonce é a urna, não o eleitor.** O eleitor vê seu voto na tela, a urna faz o compromisso internamente, descarta o nonce e imprime só o `C` — o serial. O eleitor sai da cabine sem ter como abrir o próprio compromisso, nem que queira.

## Peça 3: a Merkle tree — a urna que qualquer um audita

Onde ficam esses compromissos? Numa estrutura pública que qualquer pessoa pode baixar e verificar: uma Merkle tree. Se você assistiu meu vídeo sobre [criptografia na prática — certificados, BitTorrent, Git, Bitcoin](/2023/11/10/akitando-147-criptografia-na-pratica-certificados-bittorrent-git-bitcoin/), já viu essa estrutura em ação: é a mesma que escala o BitTorrent, organiza os commits do Git e as transações de um bloco de Bitcoin.

A construção é simples: cada folha é o hash de um voto (o compromisso `C` de um eleitor), e cada nó interno é o hash da concatenação dos dois filhos, até sobrar um único hash no topo: a **raiz**.

```python
def H(x):
    return hashlib.sha256(x.encode()).hexdigest()

eleitores = [(1, 3), (0, 7), (1, 2), (1, 10), (0, 5), (1, 1), (0, 8), (1, 4)]
leaves = [H(f"{i}:{pedersen(v, n)}") for i, (v, n) in enumerate(eleitores)]
```

Com os 8 votos de exemplo, as folhas ficam assim (hashes abreviados):

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

(Os votos e nonces da tabela aparecem abertos só pra você conferir a conta; na árvore pública existem apenas as folhas — hashes opacos.)

A raiz é o "resumo" da eleição inteira: 32 bytes que representam todos os votos. Se **um único bit** de um único voto mudar, a raiz muda completamente. Publica-se a raiz e a árvore inteira. Qualquer cidadão, em casa, com código aberto, refaz a árvore e confere se a raiz publicada bate. Isso é a **verificabilidade universal**.

Pra verificação individual, suponha que você é o eleitor 4. Seu recibo é o serial — a folha `fd6df9e3530cb74f1f0795b751a43454cab281a431d0558b413e33bba83a4100`, que é o hash do seu compromisso `C = 16` na posição 4 da árvore. Pra provar que ele está na árvore, você não precisa baixar e conferir todos os 8 votos — precisa de apenas `log2(8) = 3` hashes, o caminho dos "irmãos" até a raiz:

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

Você pega seu serial, concatena com os 3 hashes da prova na ordem certa, hasheia três vezes e confere se chegou na raiz pública. Se chegou, **é matematicamente impossível** que seu voto não esteja na árvore — porque produzir uma prova falsa exigiria encontrar uma colisão no SHA-256, e ninguém no planeta sabe fazer isso. Se alguém trocar seu voto depois, sua prova deixa de funcionar e você tem a evidência da fraude na mão. Numa eleição real com 150 milhões de votos, a prova teria uns 28 hashes — cabe num recibo de papel ou num QR code.

Repare no que acabou de acontecer: você provou que **uma informação está na árvore pública** e que **ninguém mexeu nela**, carregando pra casa apenas um número de 32 bytes que, sozinho, não diz absolutamente nada sobre o conteúdo. É isso que as pessoas querem dizer com "zero knowledge" nesse contexto: a verificação acontece sem que o conhecimento (o voto) precise circular.

## Peça 4: o desafio de Benaloh — conferindo a urna na hora

Sobrou um ponto cego. A urna mostra na tela "voto registrado" e imprime seu serial `C`. Em casa, você confere que `C` está na árvore. Tudo certo? Nem tanto. E se a urna tiver **mentido** e comprometido outro voto? Na tela ela mostra o candidato que você escolheu, mas por dentro calcula o compromisso de outro. Você jamais perceberia, porque o compromisso é opaco por design. É a propriedade de ocultação trabalhando contra você.

A solução clássica é do criptógrafo Josh Benaloh, e ficou conhecida como **desafio de Benaloh** (ou *cast-or-challenge*). A ideia: depois que a urna mostra o compromisso `C` na tela, mas **antes** de você confirmar, existem duas opções:

- **Confirmar**: o voto vale, entra na árvore e o nonce é descartado pra sempre.
- **Desafiar**: você declara aquela cédula um **voto de teste**. A urna é obrigada a revelar o nonce e o voto que ela pôs dentro do compromisso, e você refaz a conta na hora — num app independente, no seu próprio celular, não no software da urna:

```python
# a urna mostrou na tela: C = 1
# você desafiou; a urna revela: voto=1, nonce=3
pedersen(1, 3) == 1   # True -> a urna comprometeu exatamente o que você escolheu
```

Se bate, a urna foi honesta **naquela cédula**. A cédula de teste é anulada, não entra na apuração — o nonce revelado a tornaria legível — e você vota de novo, agora pra valer.

Agora suponha uma urna adulterada, que troca uma fração dos votos. Você escolhe `voto=1`; ela registra por dentro `voto=0` e mostra `C = 12` na tela (`pedersen(0, 7) = 12`). Se você **confirmar**, a fraude passa batida. Mas se você **desafiar**, a urna está encurralada: precisa revelar um par `(voto, nonce)` que abra `C = 12`. O único que ela conhece é `(0, 7)` — e revelar isso expõe a troca na sua frente: "eu votei 1!". Abrir como `voto=1` exigiria achar um nonce `n` com `pedersen(1, n) = 12`, que é o problema do logaritmo discreto de novo. Com nosso primo de brinquedo dá pra achar por força bruta (existe: `n = 10`), mas com primos de 2048 bits a urna trapaceira simplesmente não consegue produzir a resposta.

E o que fecha a armadilha: a urna **não sabe de antemão** se você vai confirmar ou desafiar. A decisão é sua, tomada depois que o compromisso já foi mostrado. Se uma parcela dos eleitores testa algumas cédulas antes de votar pra valer, uma urna que adultera votos em escala é pega com probabilidade esmagadora. Sistemas reais de votação verificável, como o Helios e o ElectionGuard, usam exatamente esse mecanismo.

E note que isso não fere o sigilo de nada: o nonce revelado é de uma cédula **anulada**, que não conta. O voto que vale continua com o nonce descartado e o compromisso impenetrável.

## Peça 5: prova de conhecimento zero de verdade — Schnorr

Falta uma última peça. Quem garante que cada compromisso na árvore contém um **voto válido** — e não, digamos, `voto = 500`, que inflaria o resultado? A urna precisa provar que o compromisso abre pra um valor legítimo **sem abrir o compromisso**. Isso é uma prova de conhecimento zero no sentido estrito.

O exemplo canônico, e que dá pra demonstrar com números pequenos, é o protocolo de **Schnorr**: provar que você conhece um segredo `s` tal que `y = g^s mod p`, sem revelar `s`. A intuição antes da matemática: é a caverna de Ali Babá. A caverna tem duas passagens que se encontram numa porta trancada. Você prova que tem a chave entrando por um lado e saindo pelo que o verificador pedir — sem nunca mostrar a chave. Se não tivesse a chave, você só acertaria o pedido por sorte, 50% das vezes; depois de 20 rodadas, a chance de enganar é menor que uma em um milhão.

A versão matemática, com nossos números de brinquedo (`p = 23`, `g = 4`, ordem `q = 11`):

```python
segredo = 7
y = pow(g, segredo, p)   # y = 4^7 mod 23 = 8  (valor público)

# 1. compromisso: o provador escolhe r aleatório e envia t
r = 3
t = pow(g, r, p)          # t = 4^3 mod 23 = 18

# 2. desafio: o verificador escolhe c aleatório
c = 5

# 3. resposta: o provador calcula z
z = (r + c * segredo) % q  # z = (3 + 5*7) mod 11 = 5

# verificação: g^z == t * y^c (mod p)
esq = pow(g, z, p)                 # 4^5 mod 23 = 12
dir = (t * pow(y, c, p)) % p       # 18 * 8^5 mod 23 = 12
print(esq == dir)                  # True
```

Funciona porque `g^z = g^(r + c·s) = g^r · (g^s)^c = t · y^c`. A álgebra fecha. Agora observe o que o verificador viu: os números `t`, `c`, `z` e a conferência final. Em nenhum momento o segredo `s = 7` apareceu. E um impostor que não sabe `s` não consegue responder a um desafio arbitrário: se ele chutar `z = 2`, o verificador calcula `g^2 = 16 ≠ 12` e a fraude aparece.

E por que o verificador aprende **nada** sobre `s`, e não apenas "pouco"? Porque a conversa inteira poderia ter sido fabricada por alguém que **não sabe o segredo**, nesta ordem invertida:

```python
# simulador: escolhe c e z PRIMEIRO, depois calcula t que fecha a equação
c_sim, z_sim = 5, 9
t_sim = (pow(g, z_sim, p) * pow(y, -c_sim % q, p)) % p  # t = 8

# conferência do transcrito forjado:
pow(g, z_sim, p)              # 4^9 mod 23 = 13
(t_sim * pow(y, c_sim, p)) % p  # 8 * 8^5 mod 23 = 13  -> bate!
```

O transcrito forjado `(t=8, c=5, z=9)` passa na verificação e é **indistinguível** de um transcrito real. Se qualquer um consegue fabricar uma conversa válida sem saber o segredo, então a conversa real não pode conter informação nenhuma sobre o segredo. É isso que "conhecimento zero" significa formalmente. (Pra usar fora de um laboratório, o desafio `c` é derivado por hash do compromisso — a transformação Fiat-Shamir — e a prova vira um objeto único, não-interativo, que qualquer um verifica offline.)

Na nossa eleição hipotética, a urna publica junto com cada voto uma prova desse tipo — na prática, uma variante em disjunção ("o voto é 0 **ou** é 1", sem dizer qual) — e qualquer auditor verifica que todo voto na árvore é válido, sem nunca ver voto nenhum.

## Juntando tudo: o protocolo completo

A eleição hipoteticamente perfeita ficaria assim:

1. **Preparação.** Um grupo de autoridades independentes (TSE, OAB, partidos, sociedade civil) gera em conjunto a chave pública da eleição. A chave privada correspondente fica fragmentada: nenhuma autoridade sozinha consegue decriptar nada; só uma maioria agindo junta.
2. **Votação.** O eleitor escolhe o candidato na tela. A urna gera um nonce aleatório, calcula o compromisso Pedersen (ou um ciphertext ElGamal equivalente), produz a prova ZK de validade e mostra o compromisso na tela. O eleitor então decide: confirma, e o nonce é descartado — ou desafia, e a urna revela o nonce pra conferência imediata, a cédula é anulada e ele vota de novo.
3. **Publicação.** O compromisso entra numa Merkle tree pública, replicada e assinada por múltiplos observadores independentes.
4. **Recibo.** O eleitor leva pra casa um papel com o serial. Ele **não consegue** provar pra ninguém em quem votou — nem que queira, porque não tem o nonce.
5. **Verificação individual.** Em casa, o eleitor baixa a árvore (ou usa qualquer site independente) e confere que seu serial está lá, com a prova de inclusão. Se não estiver, ele tem prova material da fraude.
6. **Verificação universal.** Qualquer cidadão, universidade ou partido refaz a árvore inteira, confere a raiz e valida todas as provas ZK.
7. **Apuração.** No fim, os votos encriptados passam por um mix-net (são re-embaralhados e re-encriptados, cortando o vínculo com a posição original) e as autoridades decriptam em conjunto, provando cada passo. O total bate com a raiz pública ou a fraude é evidente.

Repare no que mudou em relação ao sistema atual: **não é mais preciso confiar no TSE, na urna, nem em auditor nenhum.** Cada propriedade é verificável individualmente por qualquer pessoa com um computador. É o mesmo princípio que faz o Bitcoin funcionar sem banco central: don't trust, verify.

Antes que alguém anime demais: isso é uma simplificação. Um sistema real precisa ainda resolver autenticação de eleitor sem permitir vincular a identidade ao voto, registro de quem já votou sem revelar pra quem, disponibilidade da árvore, e uma porção de detalhes operacionais. O ponto aqui é o mecanismo central, não o projeto completo.

## E por que isso nunca funcionaria

Agora a parte que quase ninguém que propõe esses sistemas quer ouvir.

Volta pro começo do artigo e repara no que eu precisei explicar pra chegar até aqui: funções de hash, compromissos, aritmética modular, logaritmo discreto, árvores de Merkle, o desafio de Benaloh, provas de conhecimento zero, simuladores. Com código, com números, com exemplos passo a passo. E mesmo assim eu aposto que uma parcela boa dos leitores — inclusive programadores — chegou até aqui sem ter certeza de que entendeu de verdade por que o esquema é seguro.

E não é por falta de inteligência. É porque a confiança nesse sistema exige entender matemática que a imensa maioria da população nunca vai entender. O único ser humano que pode ter **100% de certeza** de que esse sistema é correto é aquele que consegue verificar as demonstrações matemáticas por conta própria. Todo o resto — 99,9% da população — não estaria *verificando* coisa nenhuma. Estaria **acreditando** no matemático que diz que funciona.

E aí chegamos na contradição fatal: se um sistema eleitoral exige que o cidadão comum acredite cegamente num especialista que ele não consegue auditar, ele é **exatamente tão opaco quanto o sistema atual do TSE**. A opacidade só trocou de endereço: em vez de confiar no burocrata do tribunal, você confia no criptógrafo. Pra dona Maria, que vende pastel na feira, tanto faz — os dois são "um monte de letrinha que eu não entendo". E um sistema que a população não consegue entender é um sistema cuja legitimidade ela nunca vai aceitar. O cético de hoje que diz "não confio na urna" viraria o cético de amanhã dizendo "não confio nessa álgebra".

Uma eleição não é só um problema de engenharia; é um problema de **confiança social**. O padrão-ouro de transparência não é o sistema mais sofisticado — é o sistema que **qualquer pessoa consegue fiscalizar com os próprios olhos**: cédula de papel, urna de vidro, contagem pública na seção, ata na porta. Qualquer um entende papel sendo contado em público. Ninguém precisa acreditar em ninguém.

É por isso que países muito mais ricos e tecnológicos que o Brasil — Alemanha, Holanda, França, a maior parte dos EUA — continuam com papel ou exigem trilha de papel auditável. Não é atraso. É a constatação de que verificabilidade que só especialista entende não é verificabilidade pública.

## Parêntese: o que as criptomoedas provam todos os dias

Antes de concluir, vale um desvio pra responder à pergunta que sempre aparece: "mas isso funciona de verdade ou é teoria de guardanapo?". Funciona. E a prova está rodando há quase duas décadas, movimentando bilhões de dólares, sob ataque constante: as blockchains.

Primeiro, desfazendo um mal-entendido: **blockchain não é sinônimo de criptomoeda.** Como o próprio nome diz, é só uma cadeia de blocos. Cada bloco carrega uma Merkle tree de registros e o hash do bloco anterior. No Bitcoin, o cabeçalho do bloco guarda a raiz da árvore de transações, o hash do bloco anterior, um carimbo de tempo e um nonce — aqui, um contador de mineração — que os mineradores variam até o hash do bloco inteiro cair abaixo do alvo de dificuldade — a tal prova de trabalho. É a Peça 3 deste artigo, estendida no tempo: não uma árvore, mas uma cadeia de árvores, cada uma selando a anterior.

O resultado prático é a garantia que interessa aqui: mexa em **uma transação** de um bloco antigo e a raiz da árvore muda, o hash do bloco muda, o elo com o bloco seguinte quebra, e pra esconder isso você precisaria refazer a prova de trabalho de todos os blocos até hoje — enquanto milhares de nós honestos continuam alongando a cadeia verdadeira. Depois que tudo está assinado e selado por hash, adulterar o passado é computacionalmente impossível. É exatamente por isso que o Bitcoin pode ser 100% público: a exposição funciona como proteção, não como risco. Todo mundo tem cópia de tudo, então ninguém reescreve a história.

**Mas público não significa anônimo.** Essa é a parte que a maioria confunde. No Bitcoin, toda transação fica visível pra sempre: quais endereços alimentaram, quais receberam, quanto foi. Endereços são pseudônimos — apelidos, não anonimato. E existe uma indústria inteira de análise de cadeia (Chainalysis, Elliptic, TRM) que vive de grudar identidade nesses apelidos:

- **Heurística dos inputs comuns:** se uma transação gasta moedas de vários endereços, quase certamente todos pertencem à mesma carteira. Agrupe-os num cluster.
- **Detecção de troco:** o output que volta pra um endereço novo costuma ser do próprio pagador.
- **Ponte com o mundo real:** quando um endereço do cluster encosta numa exchange com KYC, o nome e o CPF se ligam ao cluster inteiro — e ao histórico completo dele, retroativamente.

Foi assim que o FBI recuperou parte do resgate do oleoduto Colonial, foi assim que as moedas da Silk Road foram rastreadas anos depois, e é assim que os ~1.128 BTC roubados das ColdCards continuam parados em endereços conhecidos que meio mundo vigia — eu detalhei isso no [artigo sobre o RNG da Coinkite](/2026/08/01/explorando-o-problema-escandaloso-do-rng-da-coinkite/). Se o ladrão mover um satoshi pra uma exchange com KYC, ele se identifica. A cadeia garante integridade, não sigilo.

Pra ter anonimato de verdade, não basta a cadeia: precisa de prova de conhecimento zero. O Monero, por exemplo, combina três técnicas:

1. **Assinaturas de anel** (*ring signatures*): cada gasto é assinado em nome de um grupo de chaves possíveis. A assinatura prova que **uma delas** autorizou, sem revelar qual.
2. **Endereços furtivos** (*stealth addresses*): o endereço do destinatário nunca aparece na cadeia; cada pagamento cria um endereço descartável, derivado de um segredo compartilhado.
3. **RingCT** (*confidential transactions*): os valores ficam escondidos em **compromissos Pedersen** — sim, exatamente a Peça 2 deste artigo — e uma prova de alcance em ZK garante que ninguém criou moeda do nada, sem revelar quantia nenhuma.

O Zcash segue a mesma filosofia com zk-SNARKs: você prova "eu sou dono de uma nota válida e ainda não gasta" sem revelar qual nota. A rede verifica a prova, aceita a transação e não aprende remetente, destinatário nem valor.

E aqui o círculo se fecha. Olhe o que o esquema eleitoral deste artigo usa: uma estrutura pública e imutável que qualquer um verifica (a Merkle tree, primo mais simples da blockchain), compromissos Pedersen pra esconder o conteúdo (a mesma primitiva do Monero) e provas ZK pra garantir validade sem revelação (a mesma família do Monero e do Zcash). Nada disso é conjectura de laboratório: são sistemas em produção, auditados, atacados diariamente, protegendo dinheiro de verdade. Uma eleição é, se muito, um problema mais simples — janela curta, um publicador só, verificação offline.

Por isso eu disse lá no começo que a ideia é matematicamente sólida: ela não inventa nada, só compõe peças que já provaram aguentar o mundo real. Sabemos que um sistema de eleição digital verificável ponta a ponta **poderia** ser construído, porque todos os componentes dele já estão construídos e funcionando. O que nos leva de volta ao problema que não é técnico.

## Conclusão

Deixo claro mais uma vez, como deixei nos tweets: **isso não é uma proposta, é um exercício.** Eu não sei qual é a solução pro problema da confiança eleitoral no Brasil. Se soubesse, estaria publicando paper, não post de blog.

Mas o exercício vale por duas razões. Primeiro, porque mostra que a tecnologia pra ter verificabilidade individual e universal **existe** — quem diz "eleição digital é inerentemente inauditável" está errado. Segundo, porque mostra o limite real: a fronteira não é técnica, é epistemológica. Um sistema perfeito que ninguém entende falha no mesmo ponto que um sistema imperfeito que ninguém pode auditar.

Se você entendeu cada linha deste artigo, parabéns: você faz parte de uma minoria pequena demais pra carregar uma democracia nas costas.
