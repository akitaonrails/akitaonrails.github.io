---
title: "URGENTE - Se você guarda Bitcoins em ColdCard: MOVA TUDO"
slug: "urgente-se-voce-guarda-bitcoins-em-coldcard-mova-tudo"
date: '2026-07-31T23:00:00-03:00'
draft: false
translationKey: urgente-se-voce-guarda-bitcoins-em-coldcard-mova-tudo
description: "Uma falha de entropia deixou seeds geradas por firmwares da ColdCard muito abaixo da segurança prometida, com perdas estimadas acima de 1.000 BTC. Entenda o bug e migre sem repetir o erro."
tags:
- bitcoin-e-criptomoedas
- seguranca
- hardware
---

Eu uso ColdCard. Ou melhor, usava aquela ColdCard antiga pra guardar parte dos meus bitcoins. Já movi tudo que estava nela pra uma wallet nova. Se sua seed foi gerada numa ColdCard desde março de 2021 e você não consegue provar que veio de firmware seguro ou de entropia externa suficiente, pare de ler, faça o inventário e se prepare pra mover também.

Não estou exagerando pra fazer título caça-clique. Em 29 de julho apareceram transações varrendo wallets de usuários. Um dos endereços de consolidação [recebeu 594,47723261 BTC em 501 outputs](https://mempool.space/address/bc1qnk4zh9qcnap2mycp56qjrgza3cc8ylrh8fecp0). Isso é dado público na blockchain, não screenshot de Telegram. A edição 416 do [Bitcoin Optech](https://bitcoinops.org/en/newsletters/2026/07/31/#wallets-generated-by-coldcard-at-risk-of-theft), publicada enquanto o caso ainda se desenrolava, já estimava perdas acima de **1.000 BTC**.

O número exato ainda vai mudar. O cluster de 594 BTC é diretamente observável; atribuir cada input à mesma vulnerabilidade e fechar o total global exige análise adicional. Mas a combinação de relatos de vítimas, padrão do sweep, reprodução do bug e admissão da própria Coinkite é forte o bastante. Esperar um relatório forense bonito enquanto uma seed vulnerável continua recebendo fundos é uma péssima estratégia.

> Também não entre em pânico e digite suas 24 palavras no primeiro site que promete "verificar ColdCard". Isso é a outra forma, bem mais fácil, de perder tudo. Seed nunca entra em website, chat, extensão de browser ou computador online. Primeiro entenda se foi afetado. Depois migre com calma, conferindo endereço na tela de um signer confiável.

## Quem precisa agir agora

A vulnerabilidade está na **geração da seed**. O que importa é o modelo e o firmware usados no dia em que aquelas palavras foram criadas, não o firmware instalado hoje nem onde você importou a seed depois.

> **Na prática: se você tem qualquer ColdCard, mova os fundos pra uma wallet derivada de uma seed completamente nova. Melhor pecar pelo excesso de cuidado.** As faixas abaixo dizem onde o bug já foi confirmado; não são motivo pra apostar a poupança da sua vida na hipótese de que todo o resto está perfeito. Atualizar o aparelho não conserta a seed antiga.

Segundo o [advisory da Coinkite](https://blog.coinkite.com/coldcard-mk3-seed-generation-warning/) e a [análise independente da Block](https://engineering.block.xyz/blog/predictable-rng-fallback-and-32-bit-reseed-in-coldcard-firmware), trate como comprometida qualquer seed gerada nestas condições:

| Aparelho | Firmware que gerou a seed | Situação |
|---|---|---|
| Mk2 | 4.0.0 até 4.1.9, segundo a Block | Vulnerável. Migre a seed e aposente o aparelho como gerador. |
| Mk3 | 4.0.1 até 4.1.9 no advisory da Coinkite; a Block inclui 4.0.0 | Vulnerável. Instale 4.2.0 ou superior antes de gerar outra seed. |
| Mk4 / Mk5 Standard | Anterior a 5.6.0 | Afetado. Atualize antes de gerar outra seed. |
| Mk4 / Mk5 Edge | Anterior a 6.6.0X | Afetado. Edge é outra linha de release. |
| Q Standard | Anterior a 1.5.0Q | Afetado. |
| Q Edge | Anterior a 6.6.0QX | Afetado. |

A Block inclui Mk2 com firmware 4.x na mesma regressão do Mk3 e começa a faixa vulnerável dos dois no 4.0.0. A Coinkite concentrou o advisory no Mk3, a partir do 4.0.1, e nos modelos atuais. Eu trataria toda a linha 4.x até 4.1.9 como comprometida nos dois. Se você tem Mk2, não use a ausência dele no título do comunicado como conforto.

Há uma exceção importante: quem acrescentou pelo menos **50 jogadas justas, independentes e privadas de um dado** durante a criação original preservou, em tese, no mínimo 128 bits vindos de fora. A própria Coinkite diz que essas seeds não estão em risco por **este bug isoladamente**. Se você não lembra exatamente quantas jogadas fez, qual fluxo usou ou se aqueles resultados continuaram privados, assuma que não fez.

Seed importada de outro gerador também não nasceu desse RNG defeituoso. Ela pode ter outros problemas, claro, mas não este. E atualizar firmware agora não volta no tempo pra reparar palavra nenhuma. Você precisa criar uma seed nova e transferir os UTXOs pra endereços derivados dela.

Eu faria isso mesmo tendo uma passphrase forte. A passphrase pode ter colocado uma barreira independente na frente do atacante, mas a própria Coinkite recomenda migrar. Depois de uma falha desta proporção, ficar calculando o mínimo teórico aceitável de risco é economizar no lugar errado.

## O bug: `#ifndef` não significa "se for verdadeiro"

O [post-mortem técnico da Coinkite](https://blog.coinkite.com/entropy-technical-backgrounder/) é uma leitura constrangedora.

Em março de 2021, o firmware trocou `ckcc.rng_bytes()` por `ngu.random.bytes()` durante a migração pro libNgU e pro `libsecp256k1` usado pelo Bitcoin Core. A escolha da biblioteca criptográfica era boa. A integração foi desastrosa.

O código de build definia:

```c
#define MICROPY_HW_ENABLE_RNG (0)
```

Só que a guarda no libNgU verificava isto:

```c
#ifndef MICROPY_HW_ENABLE_RNG
#error "get a HW TRNG plz"
#endif
```

`#ifndef` pergunta se o símbolo existe, não se o valor dele é diferente de zero. O símbolo existia. O build passou. Na resolução final, `rng_get()` apontou pro fallback de software do MicroPython, um PRNG determinístico chamado Yasmarang, inicializado com UID do microcontrolador e registradores de tempo. UID identifica chip. Relógio mede tempo. Nenhum dos dois é uma fonte criptográfica de aleatoriedade.

Pior: a implementação correta do TRNG estava dentro do binário. Reviews anteriores olharam pra ela e concluíram que estava tudo certo, mas ninguém verificou o caminho completo entre "gerar nova wallet" e o símbolo que de fato era chamado no executável. Não havia teste de integração que falhasse quando a seed saísse do gerador errado.

No Mk3, a estimativa preliminar da Coinkite é de cerca de **40 bits de entropia efetiva**, em vez dos 128 bits mínimos esperados. Nos Mk4, Q e Mk5, valores dos secure elements entravam como uma segunda camada, e a empresa estima aproximadamente **72 bits**. A análise da Block é ainda mais dura: apenas 32 bits do material dos secure elements chegavam ao estado do PRNG naquele reseed. Os modelos de ameaça e as estimativas não são idênticos. Nenhum deles chega perto do alvo.

Passar a saída ruim por SHA-256 não cria entropia. Se existem apenas `2^40` entradas possíveis, no máximo existirão `2^40` hashes possíveis. Eles ficam bonitos, uniformes e continuam enumeráveis.

Isso ficou no caminho mais importante do produto por mais de cinco anos.

## Como uma reescrita de 120 arquivos chegou aqui

O [Zach Herbert publicou uma timeline](https://x.com/zherbert/status/2082993276324319713) que vale resumir. Ele é cofundador da Foundation, fabricante da Passport e concorrente da Coinkite, portanto leia a interpretação com esse contexto. As datas e commits, porém, são verificáveis.

Em julho de 2020, a Foundation anunciou que sua primeira Passport aproveitaria o firmware GPLv3 da ColdCard. Dois dias depois, NVK reclamou publicamente do "clone" e disse que mudaria a licença. Em novembro, a ColdCard adicionou MIT mais Commons Clause, que deixava o código visível mas restringia produtos comerciais derivados. Em janeiro de 2021, a mudança apareceu formalmente no firmware 3.2.1.

No dia 1 de março veio o commit `First pass w/ libNgU`: 120 arquivos alterados, remoção de bibliotecas derivadas da Trezor sob GPL, troca da stack criptográfica e mudança do código que gerava seeds. Em 17 de março, a versão 4.0.0 anunciou a remoção do último código GPL.

Não dá pra provar quanto da pressa ou do escopo veio da disputa de licença. A própria timeline reconhece outros objetivos legítimos: adotar `libsecp256k1`, acelerar AES/SHA e permitir builds reproduzíveis. O fato concreto é mais simples: o bug entrou no mesmo commit gigantesco e o produto passou cinco anos sem um teste end-to-end do seu caminho mais crítico.

Isso é incompetência de engenharia. Um hardware wallet pode ter secure element, embalagem lacrada, air gap e site cheio de explicações sobre soberania. Se a função que gera a chave chama o RNG errado e ninguém testa isso por cinco anos, o resto virou cenário.

## Isso foi cisne branco, não cisne negro

Já vi gente chamando o caso de "black swan", como se uma conjunção cósmica de eventos imprevisíveis tivesse acertado a Coinkite. Não foi.

O código vulnerável estava visível no repositório desde março de 2021. O commit era enorme, mas não secreto. O fallback determinístico estava num submodule público. A macro definida como zero estava no board config. O `#ifndef` errado estava na integração. Faltava seguir a chamada de geração da seed até o símbolo resolvido no binário e escrever um teste que provasse de onde vinha a entropia.

Um black swan é raro, surpreendente e só parece óbvio depois. Este era um **white swan**: risco conhecido na categoria mais sensível do produto, com causa observável e consequência previsível. Ninguém sabia o dia exato em que alguém ligaria os pontos e varreria as wallets. A bomba, porém, estava montada e fazendo tic-tac em público por cinco anos.

E a Coinkite ajudou a reduzir o número de pessoas dispostas a desarmá-la.

Em 2021, Marko Bencun, da Shift/BitBox, e Hugo Nguyen, da Nunchuk, [reportaram responsavelmente uma falha crítica de multisig](https://blog.bitbox.swiss/en/remote-multisig-theft-attack-on-the-coldcard-hardware-wallet/). A Coinkite corrigiu o código, mas as release notes não avisaram que era vulnerabilidade nem comunicaram urgência. O pedido de bounty de Bencun foi ignorado. A empresa só publicou um alerta mais explícito depois que o pesquisador publicou os detalhes.

A [política atual de responsible disclosure](https://coinkite.com/responsible-disclosure) continua deixando valor, elegibilidade e prazo a critério da empresa. Pesquisadores de concorrentes ou laboratórios bem financiados não recebem bounty. O texto ainda solta um "we are not here to make it easy for you", como se antagonizar quem audita seu cofre fosse uma demonstração de personalidade.

Zach Herbert também [documentou ataques públicos de NVK](https://www.zherbert.com/an-open-letter-to-nvk-and-coldcard/) contra a Foundation depois que ela usou código GPL da ColdCard: "pure clone", "leeches" e "affinity scamming". Herbert é concorrente e tem interesse na disputa, mas os posts e screenshots existem. Minha opinião sobre NVK como CEO ficou péssima. Ele cultivou uma postura hostil justamente com fabricantes e pesquisadores que tinham conhecimento e incentivo técnico pra revisar o produto.

Não preciso afirmar que todo pesquisador abandonou a Coinkite. Basta olhar os incentivos. White hat competente pode passar semanas desmontando firmware. Se a empresa minimiza achado, ignora bounty, trata concorrente como inimigo e reserva pra si a decisão de quando algo merece crédito, esse pesquisador trabalha em outro produto. Código aberto permite auditoria; não obriga ninguém a oferecer auditoria de graça pra quem o trata mal.

Portanto não foi azar de uma chance em um bilhão. Foi profecia autorrealizável. A negligência extrema acumulou risco até alguém explorar. Quando explodiu, não apagou número numa planilha da Coinkite. Levou bitcoins reais que, para algumas vítimas, eram anos de economia ou a poupança de uma vida.

## Não, "IA quebrou o Bitcoin" coisa nenhuma

A Coinkite escreveu que, como o firmware era público, "temos que assumir" que alguém usou IA pra revisar versões antigas e encontrou o bug. Não apresentou evidência. No parágrafo seguinte admite que, semanas antes, usou um dos melhores modelos disponíveis pra revisar o mesmo código e ele não achou nada sério.

Depois da divulgação, pesquisadores reproduziram a falha com ajuda de modelos de fronteira. Ótimo. Isso mostra que IA acelera auditoria e exploração depois que alguém aponta onde cavar. Não significa que uma IA quebrou ECDSA, `secp256k1`, SHA-256, BIP39 ou Bitcoin.

O atacante enumerou um espaço de chaves que um fabricante reduziu de pelo menos 128 bits pra algo na casa de 40. É força bruta contra números previsíveis. O protocolo Bitcoin fez exatamente o que deveria: aceitou assinaturas válidas produzidas pelas chaves privadas corretas.

IA não quebrou Bitcoin. A Coinkite deixou uma regressão básica sem teste no coração do firmware por cinco anos. Jogar a culpa na ferramenta que talvez tenha ajudado alguém a ler o código é uma maneira conveniente de mudar de assunto.

## O que uma wallet realmente guarda

Bitcoin não fica "dentro" da ColdCard, da Ledger ou do arquivo do Sparrow. A blockchain contém UTXOs bloqueados por scripts. Sua wallet guarda o material necessário pra encontrar esses UTXOs e produzir assinaturas que satisfazem os scripts.

Na forma mais básica, uma chave privada é um inteiro escolhido dentro do domínio da curva `secp256k1`. A chave pública é um ponto calculado a partir dela. Esse caminho é fácil de computar pra frente e inviável de reverter com a computação conhecida. Endereços são representações derivadas de chaves públicas e scripts, não cofres onde moedas moram.

Já expliquei essa base com mais calma em [[Akitando #67] Entendendo Conceitos Básicos de Criptografia - Parte 1](/2019/11/21/akitando-67-entendendo-conceitos-basicos-de-criptografia-parte-1-2/) e [[Akitando #68] Entendendo Conceitos Básicos de Criptografia - Parte 2](/2019/11/26/akitando-68-entendendo-conceitos-basicos-de-criptografia-parte-2-2/).

Uma wallet moderna não sorteia uma chave independente pra cada endereço. Ela começa com uma raiz e usa [BIP32](https://github.com/bitcoin/bips/blob/master/bip-0032.mediawiki) pra derivar deterministicamente uma árvore de chaves: contas, endereços de recebimento, troco e assim por diante. Backup da raiz recupera a árvore inteira.

O [BIP39](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki) é a camada que transforma entropia binária em palavras legíveis e depois converte mnemonic mais passphrase numa seed binária de 512 bits usada pelo BIP32. As palavras são uma forma humana de transportar aleatoriedade gerada por computador. A especificação avisa explicitamente que não é um método pra inventar uma frase bonita da própria cabeça.

## Doze ou 24 palavras é a pergunta errada

Uma mnemonic de 12 palavras codifica 128 bits de entropia mais 4 bits de checksum. Uma de 24 codifica 256 bits mais 8 de checksum. Em condições normais, 128 bits já estão fora do alcance de força bruta.

Mas "24 palavras" não garante que existiram 256 bits reais na entrada. O firmware vulnerável podia produzir uma sequência perfeitamente válida de 24 palavras, checksum correto e tudo, a partir de um espaço efetivo de aproximadamente 40 bits. O atacante não precisa experimentar todas as combinações de palavras. Ele reproduz os estados plausíveis do RNG defeituoso e compara os endereços derivados.

É por isso que a briga 12 contra 24 fica ao lado do ponto. Comprimento da representação não salva fonte previsível. Um UUID impresso em letras douradas continua previsível se alguém chamou `rand()` com um timestamp.

## RNG, TRNG e fontes independentes

RNG é o nome genérico do gerador de números aleatórios. Um PRNG pega um estado inicial, a seed, e expande aquilo numa sequência determinística. Um CSPRNG bem construído continua seguro desde que o estado inicial tenha entropia suficiente e o algoritmo não vaze o estado.

TRNG tenta colher aleatoriedade de fenômenos físicos: ruído eletrônico, jitter de oscilador e coisas do tipo. A [Ledger explica seu processo](https://support.ledger.com/article/4415198323089-zd) como um TRNG dentro do Secure Element gerando 256 bits, que o BIP39 traduz nas 24 palavras. A empresa diz que esse gerador é testado por laboratório externo e certificado segundo AIS-31. Isso é bem melhor que timer mais serial number, mas continua sendo uma fonte e uma implementação em que você deposita confiança.

Outros projetos preferem combinar fontes. A [Trezor usa entropia do aparelho e do host](https://trezor.io/guides/trezor-devices/trezor-fundamentals/what-is-entropy-and-how-does-trezor-generate-your-wallet). A [BitBox02 documenta cinco fontes](https://bitbox.swiss/bitbox02/security-features/): TRNG do secure chip, TRNG do microcontrolador, valor individual instalado na fábrica, entropia fornecida pelo host e hash do password do aparelho.

A palavra que interessa aqui é **independência**. Dois PRNGs inicializados pelo mesmo relógio não são duas fontes. Dois valores que saem do mesmo secure element também não compram a independência que o diagrama sugere. Fontes independentes, combinadas por uma construção criptográfica correta, fazem o resultado continuar forte mesmo quando algumas falham.

E "combinadas corretamente" carrega metade da segurança da frase. XOR, hash e extractors têm propriedades específicas. Não invente um mixer próprio em meia hora e coloque patrimônio em cima. Use uma implementação revisada, com test vectors, e verifique que o binário executado realmente chama aquele código. Acho que a razão ficou óbvia.

## Jogar dados não é tão simples

Cada jogada de um D6 ideal entrega `log2(6)`, cerca de 2,585 bits. Por isso aparecem os números **50 jogadas** pra 128 bits e **99 jogadas** pra aproximadamente 256 bits. A [documentação da ColdCard mostra a conta e o SHA-256 aplicado à sequência](https://coldcard.com/docs/verifying-dice-roll-math/). O [SeedSigner](https://github.com/SeedSigner/seedsigner) usa os mesmos patamares: 50 pra 12 palavras ou 99 pra 24.

Essa conta presume dado justo e jogadas independentes. Um dado promocional de plástico barato pode ter bolhas, faces mal cortadas e centro de massa deslocado. Sua mão também pode repetir movimento, a bandeja pode favorecer uma posição e muita gente "rola de novo" quando o dado cai perto da borda. Cada decisão humana depois de olhar o resultado introduz viés.

Se eu fosse gerar uma seed manual hoje, usaria **dados de precisão, do tipo usado em cassino**, de mais de um fabricante ou lote. A própria [BitBox recomenda cinco dados casino-grade](https://blog.bitbox.swiss/en/roll-the-dice-generate-your-own-seed/) no procedimento manual. Eu definiria antes a ordem de leitura, usaria uma bandeja que permita quicar e aceitaria toda jogada válida segundo uma regra escrita antes de começar. Nada de rerrolar porque "não misturou direito".

Mesmo assim, eu não confiaria só nos dados. Misturaria fontes independentes: mais de um conjunto de dados, coin flips, entropia do host offline e um TRNG de hardware, quando o aparelho suporta. Fazer centenas de jogadas é barato. O cuidado é entregar tudo a um mecanismo auditado que faça a combinação criptográfica. Somar números, escolher as palavras "mais aleatórias" ou concatenar pedaços de mnemonics por conta própria é receita pra perder fundos.

Veja o que o seu aparelho realmente implementa. No setup novo documentado pela Ledger, o TRNG do Secure Element gera a entropia. No modo de restore, [as palavras precisam reconstruir exatamente as mesmas chaves](https://www.ledger.com/academy/can-i-recover-my-hot-wallet-on-a-ledger). O TRNG não pode jogar entropia secreta em cima da mnemonic importada, porque isso criaria outra wallet e destruiria a função de backup. Portanto, restaurar uma seed feita com dados transfere pro aparelho a custódia e a assinatura, mas não melhora a aleatoriedade original.

Com hardware wallet comercial, eu escolheria um destes caminhos: gerar uma raiz nova no fluxo oficial de um aparelho atualizado que documenta como combina fontes independentes; ou gerar BIP39 fora dele, num processo auditável e completamente offline, e inserir as palavras somente pela tela e pelos botões do signer. Seed criada em MetaMask, website ou notebook conectado e depois restaurada numa Ledger continua sendo hot seed. A própria Ledger resume bem: [move, don't merge](https://www.ledger.com/academy/can-i-recover-my-hot-wallet-on-a-ledger).

O BTC D00M Guy tem [um tutorial visual em português sobre BIP39, dados e teste de restauração](https://btcdoomguy.substack.com/p/como-gerar-sua-seed-e-fazer-o-backup). É uma boa introdução pra enxergar o processo, mas eu não copiaria literalmente o trecho do celular velho em modo avião pra guardar patrimônio sério. Modo avião não prova que o aparelho estava limpo, não remove fisicamente os rádios e formatar flash depois não me dá uma garantia verificável de apagamento. Pra aprender e ensaiar, tudo bem. Pra gerar a seed da poupança da vida, prefiro hardware sem rádio, sistema efêmero verificado ou signer dedicado.

> As jogadas viram segredo assim que você decide usá-las. Não fotografe, não dite em voz alta, não guarde em nota do celular e não digite num site. A [documentação do SeedSigner](https://github.com/SeedSigner/seedsigner/blob/dev/docs/dice_verification.md) recomenda que qualquer verificação de uma seed real aconteça num sistema efêmero como Tails, completamente offline, abandonado depois do teste.
>
> Mais entropia também não corrige processo ruim. Cem jogadas filmadas por uma câmera conectada à nuvem valem zero contra quem tem o vídeo.

## Passphrase: outra wallet, não outra senha

No BIP39, a mnemonic é a entrada principal de PBKDF2-HMAC-SHA512. O salt é a string `mnemonic` concatenada com a passphrase, e a função roda 2.048 iterações. Toda passphrase produz uma wallet válida. Um caractere errado não mostra "senha incorreta"; abre outra wallet, normalmente vazia.

Uma passphrase longa, aleatória e independente pode proteger uma mnemonic exposta ou fraca. Só que perdê-la é tão definitivo quanto perder as palavras. PIN da hardware wallet não substitui passphrase. PIN protege o aparelho físico; passphrase participa da derivação das chaves.

Não use citação de filme, padrão de teclado nem senha reaproveitada. Guarde separada da mnemonic e teste uma restauração completa antes de depositar valor relevante. Registre também o fingerprint esperado e pelo menos um endereço. Na restauração, eles dizem se você entrou na wallet certa.

> No caso ColdCard, não acrescente uma passphrase agora à seed vulnerável e chame isso de migração. Crie raiz nova. A passphrase pode fazer parte da nova arquitetura, mas os bitcoins precisam sair dos scripts derivados da raiz antiga.

## Sparrow, air gap e PSBT

O [Sparrow](https://sparrowwallet.com/) é o coordenador que uso. Ele conhece descriptors, xpubs, endereços, UTXOs e histórico. Pode montar uma transação, mas numa configuração watch-only não tem chave privada pra assinar.

É aí que entra o [PSBT, padronizado no BIP174](https://github.com/bitcoin/bips/blob/master/bip-0174.mediawiki). O Sparrow cria uma Partially Signed Bitcoin Transaction com inputs, outputs, valores e dados de derivação necessários. O arquivo ou QR vai pro signer offline. O signer confere, adiciona sua assinatura e devolve o PSBT. Em multisig, o mesmo pacote passa pelos signers restantes até atingir o quorum. Sparrow combina, finaliza e transmite.

O fluxo single-sig air-gapped fica assim:

1. Sparrow monta a transação no computador online.
2. Você exporta o PSBT por QR ou microSD.
3. ColdCard, SeedSigner ou outro aparelho mostra destino, valor e fee.
4. Você confere na tela do signer e assina.
5. Sparrow importa o PSBT assinado, finaliza e transmite.

Air gap reduz a superfície de ataque. Não é campo de força. QR e microSD continuam transportando dados, firmware malicioso continua sendo firmware malicioso e um coordinator comprometido pode tentar trocar endereço de destino ou de troco. A tela do signer existe pra você comparar endereço, valor e fee antes de apertar Confirm.

> E air gap não melhora entropia retroativamente. A ColdCard vulnerável podia passar a vida inteira sem cabo USB. A chave já nasceu fraca.

## Multisig 2-de-3: mais seguro e muito mais burocrático

Single-sig concentra tudo numa seed, num backup e numa implementação. Dentro das opções acessíveis hoje, **2-de-3 multisig** com signers realmente independentes é o mais perto de segurança máxima que conheço pra eliminar esse ponto único de falha.

Você cria três seeds independentes em signers de fabricantes e codebases diferentes. Sparrow monta uma policy que exige duas assinaturas. Um aparelho pode quebrar ou uma seed pode vazar sem entregar os fundos imediatamente. Dois signers continuam suficientes pra recuperar.

"Independentes" de novo é a palavra que faz o trabalho. Três hardware wallets alimentadas por três seeds filhas do mesmo BIP85 continuam penduradas numa raiz. Três seeds geradas pela mesma ColdCard vulnerável repetem o risco. Use processos e fontes de entropia separados. Eu misturaria, por exemplo, um signer comercial de outro fabricante, um SeedSigner com dados e um terceiro aparelho com arquitetura diferente.

No Sparrow, o procedimento conceitual é:

1. Crie e faça backup de cada seed separadamente.
2. Exporte de cada signer o fingerprint, derivation path e xpub.
3. Crie uma wallet `Multi Signature`, normalmente Native SegWit, com policy 2-de-3.
4. Importe os três keystores e faça backup do output descriptor da wallet.
5. Registre quais signers correspondem a quais fingerprints.
6. Confira um endereço de recebimento em mais de um signer.
7. Faça um depósito pequeno, restaure/teste os signers e execute uma retirada completa de ensaio.

O descriptor não permite gastar sozinho, mas revela todos os endereços e o histórico. É backup necessário pra reconstruir a policy e também dado sensível de privacidade. Guarde cópias em locais separados das seeds.

Na hora de gastar, Sparrow cria o PSBT; signer A assina; signer B assina; Sparrow combina e transmite. Cada pessoa ou aparelho deve revisar outputs. Multisig com operador que confirma tudo no automático só distribui o mesmo erro em três telas.

Nada disso é mistério pra mim. Mesmo assim, acho burocrático pra cacete: três seeds, três backups, output descriptor, locais separados, dois aparelhos em cada gasto, atualizações de firmware e um plano de recuperação que outra pessoa da família precisa conseguir executar quando você não estiver por perto.

Cada camada reduz um risco técnico e abre outra oportunidade pro operador errar. Usabilidade também faz parte da segurança. Se a arquitetura ficou tão chata que você para de testar os backups, deixa de atualizar os signers ou não consegue documentar a herança, o multisig perfeito do diagrama não vale grande coisa.

> Eu entendo perfeitamente quem prefere continuar com single-sig e uma passphrase forte, independente e bem guardada. É muito mais fácil de operar. Só faça essa escolha sabendo que aceita um risco maior: você ainda depende de uma raiz e de um único caminho de assinatura. Se esse ponto cair, cai a wallet inteira. Passphrase adiciona uma barreira; não adiciona uma segunda assinatura independente.

O [guia de boas práticas do Sparrow](https://sparrowwallet.com/docs/best-practices.html) recomenda 2-de-3 com hardware wallets de fornecedores diferentes e backups em locais distintos.

> Se uma das chaves do seu 2-de-3 veio de ColdCard afetada, o atacante potencialmente já controla essa chave e consegue produzir uma assinatura. Ainda não consegue gastar sozinho, mas seu limiar efetivo caiu: agora basta comprometer mais um signer. Crie uma wallet multisig nova com cosigner novo e mova os fundos. Não existe "trocar uma chave" mantendo os mesmos endereços; a policy mudou, portanto os scripts também mudam.

## Fulcrum resolve privacidade, não chave fraca

Sparrow precisa consultar a blockchain. Num servidor Electrum público, ele pede o histórico dos script hashes derivados dos seus endereços. O servidor pode correlacionar consultas, horário e IP pra agrupar saldo e histórico, mesmo sem receber o xpub bruto. Pra evitar isso, conecto o Sparrow ao meu próprio Bitcoin Core por meio do Fulcrum.

Mostrei a arquitetura e a instalação em [Bitcoin no Home Server: Soberania e Privacidade com ColdCard, Sparrow e Fulcrum](/2026/04/01/bitcoin-no-home-server-soberania-e-privacidade-com-coldcard-sparrow-e-fulcrum/). O artigo continua útil, com uma correção óbvia: não use uma seed gerada pelo firmware afetado da ColdCard.

Seu node valida a blockchain. Fulcrum indexa e responde rápido ao Sparrow. Isso melhora soberania e privacidade da consulta. Nenhum deles impede um atacante de assinar com uma private key que conseguiu reproduzir por causa de entropia ruim.

## Como eu faria a migração hoje

Não transforme uma emergência num segundo acidente. Eu seguiria esta ordem:

1. **Faça o inventário.** Liste modelo, firmware que gerou a seed, contas, passphrases, derivation paths e multisigs onde aquela chave participa. Não publique saldo nem endereço em rede social.
2. **Considere a seed comprometida.** Não a digite em software online e não aceite "checker" de terceiros. Continue assinando no aparelho apenas pelo tempo necessário pra sair.
3. **Escolha a arquitetura nova.** Eu não geraria a nova seed numa ColdCard. Use outro signer novo, comprado diretamente do fabricante, um SeedSigner ou 2-de-3 com implementações diferentes. Se insistir em reutilizar a sua ColdCard, instale antes o firmware corrigido pro modelo e release track corretos.
4. **Gere entropia nova.** Use fontes independentes e um mixer auditado. Pra dados, use material casino-grade, várias fontes e pelo menos 99 jogadas pra uma mnemonic de 24 palavras. Eu faria mais.
5. **Faça backup antes de receber.** Mnemonic, passphrase separada, fingerprints e descriptor no caso de multisig. Nunca fotografe nem armazene em cloud.
6. **Teste restauração.** Recrie a wallet, confira fingerprint e endereços. Em multisig, prove que duas chaves conseguem assinar sem depender da terceira.
7. **Verifique o endereço na tela.** Não confie só no que Sparrow mostra no monitor do computador.
8. **Mande um valor pequeno.** Confirme que a wallet nova recebe e consegue gastar. A Coinkite também recomenda esse teste.
9. **Mova o restante logo depois.** Revise fee e todos os outputs. Procure saldo em outras contas, passphrases e endereços de troco derivados da seed velha.
10. **Mantenha o backup antigo marcado como comprometido.** Guarde até ter certeza de que a migração confirmou e de que nenhum depósito atrasado vai chegar. Nunca reutilize endereço antigo.

> Se o ataque estiver correndo contra você, não passe uma semana desenhando o multisig perfeito. Gere um destino seguro e verificado, faça o teste mínimo e tire os fundos do alcance da chave velha. Depois você pode reorganizar UTXOs e melhorar a arquitetura com tempo.

## Então qual hardware wallet eu recomendo?

Hoje, nenhuma.

Depois de explicar geração de entropia, BIP39, passphrase, PSBT, air gap, descriptors e multisig, deveria estar claro que self-custody completamente offline e feita à mão é **muito difícil**. Não espero que uma pessoa normal domine as implicações matemáticas, audite cada algoritmo e execute cada etapa sem errar. Nem a maioria dos programadores conseguiria. Eu também não vou fingir que consigo revisar sozinho toda a cadeia, do silício ao firmware que roda no aparelho.

É justamente por isso que hardware wallets existem. Elas empacotam criptografia e procedimentos complicados numa interface que uma pessoa consegue operar. Isso transfere parte da responsabilidade pro fabricante; não faz a confiança desaparecer.

Deixar a poupança da vida numa conta de exchange continua sendo o pior default. Você não tem as chaves, depende da solvência da empresa, da política de saque, do sistema jurídico e da segurança da conta. Mas um esquema artesanal que você não entende também pode terminar em perda total. Não adianta eliminar o risco de contraparte e substituí-lo por uma cerimônia impossível de restaurar depois de um incêndio ou da própria morte.

Durante anos, hardware wallet foi tratada como o último porto seguro entre esses extremos. A Coinkite abalou essa confiança na categoria inteira. Não quer dizer que Ledger, Trezor, BitBox, Passport, Jade, SeedSigner e todos os demais estejam quebrados ou sejam equivalentes. Quer dizer que nome forte, secure element, air gap, código visível e anos de mercado não bastam. Eu não consigo mais apontar pra um aparelho e dizer: “compre este e durma tranquilo”. Você vai ter que fazer sua lição de casa.

> **NUNCA compre hardware wallet de segunda mão. Compre nova, diretamente da loja oficial do fabricante.** Não economize frete colocando a poupança da sua vida num aparelho que passou pela mão de um desconhecido. Marketplace, leilão, OLX, eBay, “open box”, recondicionado e aquela oferta imperdível de um amigo estão fora de questão.

Quando o pacote chegar, não rasgue tudo e saia apertando botão. Abra a documentação oficial do modelo e siga a verificação de supply chain. A [ColdCard usa uma embalagem serializada que evidencia abertura](https://coldcard.com/docs/quick/): o número aparece na bolsa, numa aba interna e no próprio aparelho. A [Trezor documenta os selos holográficos](https://trezor.io/support/troubleshooting/device-issues/is-my-device-safe-to-use) de cada modelo. A [BitBox combina embalagem selada com attestation criptográfica](https://support.bitbox.swiss/en_US/orders-shipping/verifying-the-bitbox02-packaging) feita pelo aplicativo.

Confira lacre, cortes, cola, número serial, conteúdo da caixa e o mecanismo de autenticidade exibido pelo aparelho ou software oficial. Qualquer divergência encerra o setup: não conecte a seed, não tente “ver se funciona” e fale com o fabricante. O aparelho precisa chegar sem wallet inicializada e deve gerar palavras novas na sua frente. Seed impressa dentro da caixa é golpe.

E cuidado com a linguagem: isso tudo é **tamper-evident**, não tamper-proof. A própria documentação da ColdCard admite que uma bolsa pode ser atacada; a BitBox diz que embalagem perfeita não garante autenticidade. Lacre intacto é uma camada. Ainda quero attestation ou genuine check, firmware assinado, verificação do hash quando disponível e teste completo com pouco dinheiro.

Eu começaria por estas perguntas:

1. **Qual é o threat model publicado?** O fabricante precisa dizer contra o que protege e, principalmente, o que fica fora do escopo: computador infectado, aparelho roubado, ataque físico com laboratório, supply chain, firmware direcionado, coerção. “Military-grade security” não é threat model.
2. **De onde vem a entropia, exatamente?** Procure as fontes, como elas são combinadas e que testes end-to-end provam que o fluxo `New Wallet` chega ao RNG prometido. Suporte a dados ou entropia externa é útil, mas só se o mecanismo de mistura for documentado e auditado. O caso ColdCard mostrou que ter o TRNG correto dentro do binário não significa que a geração da seed o utiliza.
3. **O código é realmente livre e o binário corresponde a ele?** “Source available” com licença restritiva não é FOSS. Código aberto permite auditoria, mas não prova que alguém auditou. [Build reproduzível](https://reproducible-builds.org/docs/definition/) permite que terceiros reconstruam o firmware e comparem o resultado bit a bit. Procure verificações independentes e atuais no [WalletScrutiny](https://walletscrutiny.com/), não apenas a promessa do fabricante.
4. **Como a empresa trata quem encontra falhas?** Leia a política de disclosure, escopo e valores do bounty. Procure advisories antigos, CVEs, post-mortems e a conversa com pesquisadores. Empresa que publica a falha, explica a causa, corrige rápido e agradece ao pesquisador merece mais confiança que uma com histórico supostamente “perfeito”. Às vezes ninguém encontrou vulnerabilidade porque ninguém competente teve incentivo pra procurar.
5. **O que a tela confiável permite verificar?** Antes de assinar, o aparelho deve mostrar endereço, valor, fee e troco. Deve conferir endereço de recebimento no próprio display, permitir entrada de PIN e passphrase sem entregá-los ao computador e registrar corretamente a policy de multisig. Secure element protege chave; não salva uma interface que faz você assinar sem entender os outputs.
6. **Existe uma rota de saída sem o fabricante?** Eu quero padrões interoperáveis: BIP39/BIP32 quando aplicável, [PSBT](https://bips.dev/174/) e [output descriptors](https://bips.dev/380/). Quero exportar xpub, fingerprint e descriptor, usar Sparrow, conectar meu node e recuperar em outra implementação. Conta obrigatória, cloud proprietária e backup que só abre no aplicativo da empresa são lock-in em cima da chave da sua vida.
7. **Como funcionam hardware, firmware e supply chain?** Secure element, microcontrolador comum e signer stateless fazem trocas diferentes. Descubra o que persiste no aparelho e o que um atacante físico consegue extrair. Releases devem ser assinadas, ter changelog útil, impedir downgrade inseguro e receber manutenção por anos. Pesquise como o aparelho verifica autenticidade, como documenta embalagem e transporte, o que acontece se o servidor de update desaparecer e quais componentes fechados existem. Air gap também não é selo mágico: QR, NFC e microSD são parsers de entrada e continuam sendo superfície de ataque.
8. **Você consegue restaurar sem improviso?** Antes de colocar valor relevante, gere a wallet, faça backup, apague o aparelho e recupere. Confira fingerprint, endereço e uma transação de ida e volta. Em multisig, restaure o descriptor e prove que o quorum funciona sem uma das chaves. Backup nunca testado é esperança, não backup.

Eu também pesquisaria o histórico do repositório, issues de segurança, commits recentes, auditorias independentes e tempo entre vulnerabilidade reportada e correção. Buscaria pelo nome do modelo junto com `vulnerability`, `reproducible build`, `seed entropy`, `multisig` e `responsible disclosure`. Review de influenciador com link de afiliado serve pra conhecer a tela e o tamanho do aparelho, não pra decidir onde guardar patrimônio.

Pra valores pequenos, um signer comercial bem pesquisado pode ser muito menos arriscado que uma invenção manual. Pra patrimônio que muda sua vida, 2-de-3 com fabricantes e codebases diferentes continua sendo a referência, como recomenda o [guia do Sparrow](https://sparrowwallet.com/docs/best-practices.html). Isso limita o estrago de um fornecedor comprometido, mas cobra mais backups, mais testes e uma policy bem documentada. Multisig que você não consegue restaurar é pior que single-sig bem cuidada.

Em alguns serviços de custódia colaborativa, uma empresa segura uma das chaves de um 2-de-3. Ela não deveria conseguir gastar sozinha, mas passa a conhecer dados da sua wallet e pode desaparecer, negar serviço ou complicar uma recuperação. Custodiante profissional também troca risco técnico por risco jurídico e de contraparte. No fim, você escolhe qual risco aceita carregar e qual entrega a terceiros.

O melhor que consigo recomendar não é uma marca. Escolha uma arquitetura proporcional ao valor e descubra quais falhas ela tolera. Antes de colocar dinheiro que faria falta, rode o fluxo inteiro com pouco: receba, gaste, apague um signer, restaure o backup e veja se você consegue voltar sozinho.

## Conclusão

Self-custody tira o custodiante do caminho, mas deixa uma responsabilidade brutal no lugar. A confiança continua espalhada por silício, firmware, compilador, processo de build, wallet coordinator e pela sua própria disciplina. Hardware wallet continua tendo utilidade porque fazer tudo na mão é impraticável pra quase todo mundo. O erro é confundir essa ferramenta com garantia.

Eu não recomendo hoje uma marca específica. Prefiro distribuir o risco e criar maneiras de pegar falhas: fontes independentes de entropia, código livre, builds reproduzíveis verificados por terceiros, restaurações ensaiadas, signers diferentes e multisig quando o valor justifica e você aceita a burocracia. Single-sig com passphrase é uma escolha compreensível. Só não oferece a mesma tolerância a falhas. Faça essa escolha sabendo o que está delegando e o risco que decidiu manter com você.

Este pode acabar sendo **um dos piores episódios da história da autocustódia em Bitcoin**. Não porque alguém deixou moedas numa exchange vagabunda, digitou a seed num site de phishing ou instalou wallet pirata. Muita gente comprou um aparelho dedicado, anotou 24 palavras, guardou o backup em aço, manteve tudo offline e assinou por air gap. Fez exatamente o que a cultura Bitcoin ensinava como o procedimento correto. Mesmo assim foi pega por um bug nojento no instante mais importante de todos: a escolha da raiz.

> Nos casos mais graves, o RNG reduziu o universo pra algo na casa de `2^40`. O atacante não precisa tocar na ColdCard. Ele enumera os estados possíveis, deriva as árvores BIP32 e os endereços mais prováveis, consulta a blockchain pública e encontra quais candidatos têm UTXOs. Quando encontra, também tem as private keys pra assinar. A ColdCard pode estar desligada, sem bateria, sem USB e dentro de um cofre. Não faz diferença. Air gap protege o caminho entre signer e computador; não recupera entropia que nunca existiu.

Não havia alerta visível. A wallet recebia, assinava e restaurava normalmente até o dia em que outra pessoa reproduziu a mesma chave. Por isso 12 contra 24 palavras, air gap contra USB e secure element contra microcontrolador viram discussões secundárias quando ninguém testou se o botão **New Wallet** chamava o RNG correto.

Também mostra por que não aceito chamar negligência de black swan. O source estava aberto, o caminho era auditável e a cultura afastava parte das pessoas mais capazes de apontar problemas. Foi um cisne branco esperando alguém olhar na direção certa.

> A lição não é abandonar self-custody. É parar de terceirizar entendimento. Estude o threat model, procure como a entropia é gerada, confira o histórico do fabricante, ensaie recuperação e saiba quais riscos continuam concentrados. Não confie cegamente em empresa, certificação, influencer, tutorial ou artigo. Nem neste aqui. Verifique.

Eu já movi meus fundos da ColdCard antiga. Na prática, se você tem qualquer ColdCard, faça o mesmo. Não existe prêmio por descobrir tarde demais que seu caso também tinha uma exceção não documentada.

Escolha a nova arquitetura com os critérios acima. Gere uma raiz completamente nova. Misture entropia independente de verdade. Teste o backup. Confira os endereços. Mova tudo.
