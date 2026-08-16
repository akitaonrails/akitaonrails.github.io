---
title: "O que significa o Paper do Google sobre Vulnerabilidade Quântica"
slug: o-que-significa-o-paper-do-google-sobre-vulnerabilidade-quantica
date: '2026-08-16T10:00:00-03:00'
draft: false
translationKey: o-que-significa-o-paper-do-google-sobre-vulnerabilidade-quantica
description: "Google, Ethereum Foundation e Stanford estimam quebrar a secp256k1 com menos de 500 mil qubits. Comparo com GLM, Kimi e ChatGPT, calibro a chance real de roubo nos próximos anos e o que dá pra fazer hoje."
tags:
- computacao-quantica
- bitcoin-e-criptomoedas
- seguranca
---

Saiu um paper do Google e a manchete previsível veio junto: "computador quântico vai quebrar o Bitcoin". Do outro lado, a turma do "isso é FUD, ignora" respondeu no mesmo volume. As duas reações estão erradas, e o paper em si é bem mais interessante que qualquer um dos dois gritos.

O documento se chama [Securing Elliptic Curve Cryptocurrencies against Quantum Vulnerabilities](https://arxiv.org/abs/2603.28846), e a lista de autores por si só já obriga a levar a sério: é o Google Quantum AI (com Craig Gidney, o mesmo das estimativas recentes pra quebrar RSA), mais a Ethereum Foundation (Justin Drake) e Stanford (Dan Boneh, um dos pais da criptografia de curva elíptica). É gente que constrói computador quântico sentada na mesma mesa que gente que inventou boa parte da criptografia que roda hoje. Peso raro pra um assunto que costuma atrair muito chute de quem nunca leu uma linha do que critica.

Antes de qualquer coisa: **leia o paper direto**. Ele é longo, denso, mas escrito com um cuidado raro, inclusive num esforço explícito de não virar FUD. O que eu faço aqui é minha própria leitura, depois comparo com o que o GLM, o Kimi e o ChatGPT acharam quando pedi pra eles rasgarem o texto, e no fim tento responder a pergunta que interessa pra quem tem meia dúzia de satoshis ou de ether na carteira: qual é, no mundo real, a chance de um computador quântico roubar dinheiro seu nos próximos anos?

Adianto o espírito da coisa: o céu não está caindo. Mas o recado de "comece a se mexer agora" tem fundamento, e a razão é mais sutil do que "o quântico vem aí".

## O que o paper realmente diz, em português de engenheiro

Deixa eu tirar o jargão da frente primeiro. A segurança do Bitcoin, do Ethereum e de quase toda cripto se apoia num problema matemático: dado uma chave pública, é inviável calcular a chave privada correspondente. Todo mundo vê sua chave pública; ninguém consegue voltar dela pra sua chave privada. É essa mão única que faz uma assinatura digital valer alguma coisa.

O algoritmo de Shor, rodando num computador quântico grande o suficiente, quebra exatamente essa mão única. Ele transforma "inviável" em "questão de minutos". Isso não é novidade desde 1994. A novidade do paper é outra, e são cinco pontos.

**Primeiro: o custo despencou.** O time do Google apresenta circuitos novos pra resolver o problema da curva secp256k1 (a curva do Bitcoin e das contas do Ethereum) usando muito menos recurso do que se imaginava. São duas receitas: uma com menos de 1.200 qubits lógicos e 90 milhões de portas Toffoli, outra com menos de 1.450 qubits lógicos e 70 milhões de portas. Em hardware supercondutor, com premissas padrão de correção de erro, isso caberia em **menos de 500 mil qubits físicos** — quase 20 vezes menos que estimativas anteriores — e rodaria em **9 a 12 minutos** a partir de um estado pré-computado. Guarde esse número: 9 minutos. Ele é o que assusta, porque é menor que o intervalo médio de um bloco do Bitcoin.

**Segundo: eles não publicaram o circuito.** Aqui tem uma jogada elegante e polêmica ao mesmo tempo. Pra provar que têm um circuito daquele tamanho sem entregar a arma carregada pra qualquer um, eles publicaram uma **prova de conhecimento zero**: uma prova matemática de que possuem o circuito, sem revelar o circuito. É responsável na intenção. Só que, como eu conto mais pra frente, essa parte foi o ponto mais frágil da história.

**Terceiro: nem todo computador quântico serve pra tudo.** O paper cria uma distinção que é a melhor contribuição prática do texto. Existe o "relógio rápido" (supercondutor, fotônico) e o "relógio lento" (íons aprisionados, átomos neutros), com uma diferença de 100 a 1.000 vezes na velocidade. Dessa velocidade saem três tipos de ataque:

- **Ataque no gasto (on-spend):** o atacante intercepta sua transação no mempool, quebra a chave e injeta uma transação rival antes do seu gasto entrar num bloco. Precisa de relógio rápido, porque é uma corrida contra o relógio do bloco.
- **Ataque em repouso (at-rest):** a chave pública já está exposta na blockchain (carteira parada, chave reusada). O atacante tem dias ou meses pra trabalhar. Serve até relógio lento.
- **Ataque na configuração (on-setup):** uma única computação quântica extrai um segredo de uma cerimônia criptográfica e vira um gabarito reutilizável, que depois roda em computador clássico comum. Esse é o mais insidioso, e ataca coisas como o mecanismo de dados do Ethereum.

**Quarto: o mapa de quem sangra.** No Bitcoin, os alvos em repouso são os scripts antigos P2PK (cerca de 1,7 milhão de BTC, quase tudo da era Satoshi e provavelmente perdido), o Taproot (P2TR, que expõe a chave), e qualquer endereço reusado. Somando tudo, o paper estima cerca de 6,9 milhões de BTC vulneráveis hoje, dos quais uns 2,3 milhões estão dormentes há mais de cinco anos. Os endereços modernos que escondem a chave atrás de um hash e nunca gastaram continuam seguros em repouso. E tem uma boa notícia enterrada aqui: **a mineração do Bitcoin não corre risco**. O algoritmo de Grover, que atacaria a mineração, tem ganho pequeno demais e não paraleliza; o overhead de correção de erro come tudo. O paper enterra esse mito de propósito.

**Quinto: o Ethereum tem uma superfície bem maior.** O modelo de contas expõe a chave pública permanentemente depois da primeira transação, ao contrário do modelo de UTXO do Bitcoin. Some a isso as chaves administrativas de contratos (stablecoins, pontes, oráculos), as assinaturas BLS que seguram o consenso Proof-of-Stake, e os compromissos KZG da camada de dados. É mais coisa exposta, e boa parte não dá pra "trocar de endereço" pra escapar.

E como o paper argumenta tudo isso? Três pernas: as estimativas de recurso (com a prova de conhecimento zero pra dar credibilidade), dados reais da blockchain (as quantidades de BTC e ETH em risco vêm de consultas públicas ao BigQuery), e o enquadramento honesto de que isso é um alerta pra migrar, não um anúncio de que a máquina existe. O paper, aliás, **não dá uma data**. Ele estima recurso, não calendário.

## Onde eu concordo e onde discordo dos outros modelos

Pedi pro GLM 5.3, pro Kimi K3 e pro ChatGPT (GPT 5.6) analisarem e criticarem o paper. O interessante é que os três, e eu, convergimos no essencial e divergimos exatamente nos mesmos pontos. Isso é um bom sinal: quando modelos diferentes batem no mesmo prego, o prego costuma existir.

**No que todo mundo concorda (e eu também):**

- A estimativa de recurso lógico é **crível**. Não é um número solto: segue a trajetória histórica (o custo pra quebrar RSA-2048 caiu de ~1 bilhão de qubits em 2012 pra menos de 1 milhão em 2025) e vem justamente do grupo que produziu as melhores estimativas da área.
- A distinção relógio rápido / relógio lento e o par gasto / repouso é a lente certa pra pensar mitigação.
- A imunidade da mineração é correta e precisava ser dita em voz alta.
- Os assets dormentes são um problema real que nenhum fork de software resolve sozinho, porque ninguém tem a chave privada pra mover as moedas perdidas.

**No que todo mundo cutuca (e eu cutuco mais forte):**

O ChatGPT foi o mais preciso numa distinção que vale ouro: **"valor em risco" não é "perda esperada"**. Quando o paper diz "20,5 milhões de ETH em contas vulneráveis" ou "6,9 milhões de BTC expostos", isso mede dependência de criptografia frágil, não dinheiro que seria roubado. Tem sobreposição, tem multisig, tem chave administrativa que dá pra rotacionar, tem contrato com conselho de emergência que pausa tudo. Empilhar esses números numa manchete de "trilhões em risco" é desonesto com o próprio paper.

O mesmo vale pro famoso **41% de chance de roubo no Bitcoin**. Esse número é só a probabilidade de a computação de 9 minutos terminar antes do próximo bloco aparecer (o bloco chega em média a cada 10 minutos, mas com muita variância). Não é a chance de roubar seu dinheiro. Pra roubar, o atacante ainda precisa propagar a transação rival, convencer um minerador a incluí-la, vencer a corrida de taxa. E o próprio paper assume condições favoráveis ao atacante (rede sem congestionamento, entrega instantânea). Kimi e ChatGPT batem nisso; eu assino embaixo.

O ponto mais importante, e que eu acho que o paper deixa nas entrelinhas de propósito: **os 500 mil qubits físicos e os 9 minutos são um cenário de engenharia condicional, não uma previsão de data.** É um projeto de máquina que *poderia* fazer o ataque, assumindo taxa de erro de 0,1%, ciclos de correção de 1 microssegundo, decodificação de baixa latência, fábricas de estado mágico suficientes, e meio milhão de qubits operando estáveis por minutos a fio. Cada premissa é razoável isolada. A corrente inteira funcionando junta, nessa escala, ninguém demonstrou.

E aqui entra a parte mais suculenta, que o Kimi e o ChatGPT pegaram e eu confirmei buscando fora: **a prova de conhecimento zero furou.** A Trail of Bits [conseguiu forjar uma prova](https://blog.trailofbits.com/2026/04/17/we-beat-googles-zero-knowledge-proof-of-quantum-cryptanalysis/) explorando bugs de memória e de lógica no código Rust do verificador do Google — chegou a produzir uma prova que reportava zero portas Toffoli pra um circuito que nem era reversível. O Google corrigiu o verificador na versão 2, e a alegação científica em si não foi afetada. Mas o episódio mostra que a prova de conhecimento zero só mudou o problema de lugar: em vez de confiar na palavra do Google, você passa a confiar no parser, no compilador e no simulador dele.

O que de fato validou o resultado veio depois, e é a melhor notícia pra quem quer verdade em vez de fé: em junho de 2026, o pesquisador André Schrottenloher [reproduziu os circuitos secretos de forma aberta](https://postquantum.com/security-pqc/google-ecdlp-circuits-reproduced-open/), chegando na mesma região (cerca de 56 milhões de portas Toffoli, com o circuito inteiro publicado e reproduzível). O próprio Gidney reconheceu que a reprodução capturou o avanço essencial. Depois disso, outros já empurraram o número pra baixo de mil qubits lógicos. Ou seja: a estimativa lógica é sólida, e não depende mais de acreditar na palavra de ninguém. Foi a ciência aberta, não a prova de conhecimento zero, que fechou a conta.

Um último ponto que quase ninguém levanta e eu acho que precisa ser dito: **conflito de interesse.** Sete autores são do Google Quantum AI, cujo roteiro de hardware é justamente a arquitetura supercondutora que o paper faz parecer a ameaça mais próxima. E tem um coautor da Ethereum Foundation num paper que classifica o Ethereum como mais exposto e recomenda migração urgente. Os autores declaram posições compradas em cripto e nenhuma vendida, o que é honesto. Isso não invalida nada — a competência técnica do time é a melhor da área — mas pede leitura calibrada, não histérica.

## A pergunta que interessa: qual a chance real, e quando?

Vamos separar o teórico do real, que é onde a maioria das discussões vira sopa.

**No teórico, a resposta é sim, com folga.** Se existir uma máquina grande e estável o suficiente, o algoritmo de Shor quebra a secp256k1. Não é "se" no sentido matemático; é engenharia. A pergunta toda se resume a: *quando essa máquina existe?*

**Na realidade de hoje, estamos longe.** O melhor resultado público de qubits lógicos em 2026 é da Quantinuum, com 12 qubits lógicos operando abaixo do limiar de erro. O paper precisa de mais de 1.200. Isso é um fator de cem em qubits lógicos, e cada qubit lógico custa milhares de qubits físicos com a qualidade e a estabilidade que ainda não temos. Em qubits físicos, o maior sistema anunciado anda na casa dos milhares; o ataque pede quase meio milhão. São várias ordens de grandeza de distância, em várias dimensões ao mesmo tempo. Nada que um ajuste fino resolva.

**No futuro próximo, aí mora a discussão de verdade.** O jeito honesto de falar disso é com estimativa, não com certeza. A referência mais citada é o [Quantum Threat Timeline do Global Risk Institute](https://globalriskinstitute.org/publication/quantum-threat-timeline/), uma pesquisa anual com especialistas da área. A edição de 2025 dá algo como **34% de chance de um computador quântico criptograficamente relevante até ~2030 e ~49% até ~2035**, com a mediana das opiniões caindo entre 2029 e 2032. E essas estimativas são pra um CRQC genérico, tipicamente pensado pra quebrar RSA-2048.

Colando isso na realidade específica da cripto, minha leitura em números redondos, e deixando claro que é estimativa e opinião:

- **Nos próximos 2 a 3 anos (até ~2029):** perto de zero. Sair de 12 pra 1.200 qubits lógicos estáveis nesse prazo não está em nenhum roteiro público sério.
- **No horizonte 2030–2032:** baixo, mas não desprezível. Talvez 10% a 20% de a máquina existir *em princípio*. A chance de roubo de fato é ainda menor, porque os alvos de maior valor (exchanges, carteiras modernas) terão se mexido antes.
- **Lá por 2035:** aí a moeda vira coin flip pra um CRQC genérico, na casa dos 40% a 50% segundo os especialistas. Só que "existe um CRQC" não é o mesmo que "roubaram seu dinheiro". Até lá, a migração já deveria estar bem andada.

O detalhe que decide tudo, e que o Mosca resume num teorema simples: o que importa é **a data da máquina menos o tempo que a sua migração leva**. Se migrar leva anos, e a máquina pode chegar em cinco a dez, você já está no aperto, mesmo com probabilidade baixa no curto prazo. É por isso que "comece agora" faz sentido mesmo com o céu limpo. Gestão de risco assimétrico, com a cabeça fria.

## Por que isso não é "acabou, tá tudo perdido"

Mesmo no cenário de uma máquina pronta e um atacante mal-intencionado, o estrago é cirúrgico, não uma bomba que apaga tudo. E o motivo é lindo de entender.

Seu dinheiro em cripto não mora no seu HD nem no seu Ledger. Ele mora na blockchain pública, à vista de todo mundo, o tempo todo. O dispositivo só guarda a chave privada que autoriza mover aquilo. Qualquer pessoa pode ir num explorador de blocos, digitar um endereço e ver o saldo. O que decide sua exposição ao quântico é uma coisa só: **a sua chave pública já apareceu em algum lugar?**

Nos endereços modernos do Bitcoin (os `bc1q`, que escondem a chave atrás de um hash), enquanto você **nunca gastou** daquele endereço, a chave pública não está exposta. O atacante quântico não tem por onde começar, porque ele quebra a chave pública, e ela não está lá. Esses fundos estão seguros em repouso. A exposição só nasce no momento em que você gasta, e mesmo aí é uma janela de minutos, contra um relógio de bloco, precisando da tal máquina de relógio rápido que ainda não existe.

Por isso o paper fala em cerca de 6,9 milhões de BTC vulneráveis, e não nos quase 20 milhões que existem. A maior fatia disso é chave reusada e os P2PK da era Satoshi, que provavelmente estão perdidos de qualquer jeito. Não é a rede inteira; é um subconjunto de endereços com um comportamento específico: chave exposta. Quem usa endereço novo a cada recebimento e não fica gastando do mesmo lugar já está, na prática, fora da mira em repouso.

## O que você pode fazer hoje

Aqui vem a pergunta que sempre aparece, e a resposta que decepciona quem esperava um botão mágico.

**"Se eu criar uma carteira com uma senha/passphrase mais forte, isso ajuda?"** Não. E entender o porquê ensina o problema inteiro.

Uma passphrase forte protege a sua *seed* — aquelas 12 ou 24 palavras — contra alguém que tente adivinhar ou roubar o backup. É ótimo e você deve fazer, mas contra ataque clássico. O computador quântico não adivinha sua seed. Ele pega a sua chave **pública**, que está na blockchain à vista, e calcula a chave privada correspondente com o Shor. Não importa se a sua chave privada nasceu de uma passphrase de 4 caracteres ou de 40: uma vez que a chave pública apareceu, a força da senha é irrelevante. O quântico ataca a matemática da curva, e essa matemática é a mesma pra todo mundo.

O que de fato move o ponteiro é higiene de exposição de chave:

- **Não reuse endereços.** Um endereço por recebimento. No momento em que você gasta de um endereço, a chave pública dele vai pra blockchain; se você continuar usando aquele endereço, o saldo restante passa a ficar exposto em repouso.
- **Mantenha o grosso em endereços modernos que escondem a chave atrás de um hash** (`bc1q`, P2WPKH) e dos quais você nunca gastou. Evite deixar reserva parada em Taproot (`bc1p`) e em endereços P2PK antigos, que expõem a chave direto.
- **Não espalhe sua chave pública estendida (xpub).** Ferramenta de portfólio, planilha compartilhada, integração de terceiro: cada lugar que recebe seu xpub é mais um ponto de exposição.
- **Quando surgirem carteiras pós-quânticas de verdade, migre.** Esse é o passo definitivo, e ele vai chegar via atualização de software.

E o mais importante pra manter a cabeça no lugar: se você guarda em exchange séria ou usa carteira moderna sem reuso, o seu risco de curto prazo é praticamente zero. A exchange é quem vai ter que migrar por você (com os riscos de custódia que já existem, quânticos ou não). Não precisa sair correndo hoje mover nada em pânico.

## O que a indústria pode fazer, sem radicalismo

Do lado de quem constrói os protocolos, a tentação é o extremo: "larga tudo e vai pra assinatura pós-quântica amanhã". Isso é tão ruim quanto o "ignora que é FUD". A criptografia pós-quântica é mais nova, menos testada em batalha, tem chave e assinatura muito maiores, e trocar às cegas introduz bug novo onde não tinha. O caminho sensato é defesa em profundidade, começando pelo que é barato.

**Medidas intermediárias, mais fáceis que a troca completa:**

- Matar o reuso de chave e minimizar exposição de chave pública no protocolo e nas carteiras por padrão.
- Mempools privados e esquemas de commit-reveal, que fecham a janela do ataque no gasto.
- Rotação de chave de validador no Ethereum, um paliativo simples contra o ataque ao consenso.
- No Bitcoin, propostas como a BIP-360 (o script P2MR), que remove a exposição de chave em repouso do Taproot.

**A ponte de médio prazo:** assinaturas híbridas, que combinam a curva elíptica de hoje com um esquema pós-quântico (baseado em reticulados, por exemplo). Você fica protegido contra os dois mundos ao custo de assinaturas maiores, e não aposta tudo num esquema novo que pode ter fraqueza ainda não descoberta.

**O terreno já está mais maduro do que parece.** O NIST já padronizou esquemas pós-quânticos (ML-DSA, o antigo Dilithium; Falcon; SPHINCS+). O Ethereum discute precompiles pós-quânticos (EIP-7932) e abstração de conta, que reduzem a superfície sem hard fork traumático. Blockchains como Algorand, XRP Ledger e o QRL já experimentam ou nasceram com PQC. O trilho dessa migração já está assentado, longe de ser um salto no escuro.

**E o pedaço que ninguém resolveu:** os assets dormentes. As moedas P2PK perdidas, incluindo o ~1 milhão de BTC atribuído ao Satoshi, não têm dono pra migrá-las. O paper discute opções — não fazer nada, queimar as moedas por soft fork, um "sidechain de recuperação", ou até salvamento regulado por governo, na analogia de tesouro afundado. Aqui eu sou franco: **essa parte é a mais fraca do paper, e é advocacy, não ciência.** Nada na estimativa de qubits diz quem deve ficar com moeda perdida, ou se ficar cinco anos parado extingue direito de propriedade. São escolhas políticas e jurídicas espinhosas, que o paper levanta com honestidade mas está longe de fechar. É bom que a conversa comece; é ruim tratar como se houvesse resposta pronta.

## Onde a gente está, afinal

Resumindo o cenário quântico do futuro próximo em três camadas, com a régua sempre calibrada:

| Camada | Situação | Leitura |
|---|---|---|
| **Teórico** | Shor quebra a secp256k1 se a máquina existir | Certeza matemática; a pergunta é quando a máquina existe |
| **Realidade hoje (2026)** | ~12 qubits lógicos (Quantinuum); ataque pede >1.200 | Fator de ~100 em qubits lógicos, várias ordens de grandeza em físicos. Ninguém rouba nada hoje |
| **Próximos 2–3 anos (~2029)** | Fora de qualquer roteiro público sério | Risco perto de zero |
| **2030–2032** | Máquina capaz *em princípio* começa a ser plausível | Estimativa de ~10–20%; roubo real menor ainda, alvos migram antes |
| **~2035** | Coin flip pra um CRQC genérico (especialistas: ~40–50%) | "Existe máquina" ≠ "roubaram você"; migração deve estar andada |

O paper é sério e a matemática dele está de pé, agora confirmada por reprodução aberta e independente. A ameaça é real o suficiente pra justificar ação, e o motivo tem nome: o teorema do Mosca. Como migrar leva anos, você começa antes de a máquina existir, do mesmo jeito que se troca telhado no verão, e não no meio do temporal.

Mas nada nisso é "vende tudo, o Bitcoin acabou". O ataque é sobre chave exposta, é um subconjunto de endereços, precisa de uma máquina que está a ordens de grandeza de existir, e as defesas que importam agora são higiene chata: não reusar endereço, não deixar reserva em chave exposta, e migrar pra pós-quântico quando a ferramenta amadurecer. A mineração não corre risco, a sua carteira moderna sem reuso não corre risco hoje, e a passphrase mais forte do mundo não muda nada disso.

O jeito de ler o paper do Google é esse: um alerta competente e autoconsciente, feito por quem entende do assunto, dizendo que a janela pra migrar com calma é mais estreita do que a intuição sugere — e ainda assim mais larga do que a manchete faz parecer. [Leia direto na fonte](https://arxiv.org/abs/2603.28846) e tire a sua. Só não caia nem no "acabou" nem no "é tudo mentira". A resposta interessante, como quase sempre, mora no meio.
