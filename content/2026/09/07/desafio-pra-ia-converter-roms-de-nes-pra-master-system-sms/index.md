---
title: "Desafio pra IA: converter ROMs de NES pra Master System/SMS"
slug: "desafio-pra-ia-converter-roms-de-nes-pra-master-system-sms"
date: '2026-09-07T14:00:00-03:00'
draft: false
translationKey: desafio-ia-converter-nes-master-system
description: "Tentei usar LLMs de fronteira pra converter ROMs de NES em jogos de Master System. Explico a arquitetura, por que traduzir 6502 pra Z80 sai lento, o emulador como oráculo de feedback e onde os mappers travam."
tags:
- retrocomputacao
- agentes-de-codigo
- games
- emulacao
---

Durante muitos anos eu tive uma ideia fixa na cabeça, e sempre achei que ela não era prática: converter jogos de NES pra rodar no Master System.

Deixa eu ser preciso. Eu sempre soube que dava pra fazer. Duas máquinas Turing completas conseguem, em tese, rodar o código uma da outra. Você sempre consegue traduzir programa de uma arquitetura pra outra. O problema nunca foi possibilidade, foi custo. O NES roda um 6502, o Master System roda um Z80, e ao longo dos anos eu li em vários cantos que uma tradução direta de 6502 pra Z80 sempre acabava rodando muito mais devagar, por causa das diferenças de arquitetura e de hardware. Devagar o suficiente pra nunca compensar na prática.

E essa memória tem fundamento. Se você for atrás em fórum de retro-dev, tipo o [NESdev](https://forums.nesdev.org/viewtopic.php?t=17339), o consenso é que traduzir instrução por instrução é justamente o pior caminho: "cada instrução do código-fonte vira várias instruções no código objeto, e o programa resultante roda muito mais devagar e ocupa muito mais memória". Não é só a CPU. O 6502 tem a zero page, um modo de endereçamento baratíssimo que o Z80 não tem equivalente, então você troca um acesso barato por uma sequência cara com `IX`/`IY`. E a parte gráfica é pior ainda: o PPU do NES e o VDP do Master System são bichos diferentes, com scroll, sprites e espelhamento de tela que não encaixam um no outro sem gambiarra cara.

Ou seja, todo mundo que já pensou nisso chegou na mesma conclusão: dá pra fazer, mas roda mal demais pra valer a pena.

Só que agora a gente tem LLMs de fronteira. E eu fiquei curioso: será que uma abordagem de força bruta, com uma LLM boa no meio do processo, consegue um resultado melhor do que a tradução ingênua de sempre? Comecei o projeto [nes-to-sms](https://github.com/akitaonrails/nes-to-sms) no fim de maio, uns três meses atrás, pra descobrir.

O primeiro resultado foi exatamente o que a teoria previa: ruim. Uma tradução mais ou menos direta gerou código que roda, mas devagar demais. Eu consegui converter o Super Mario Bros inteiro, com sprites, fases, tudo, mas pra ficar minimamente jogável eu precisava rodar o emulador Mednafen com overclock de 500%. Depois de bater cabeça com Claude, GPT e outros modelos por um tempo, empaquei. Trabalhei firme por junho e julho, e em agosto pausei o projeto pra deixar a poeira baixar.

## Por que Master System, e não NES?

Antes de explicar a parte técnica, preciso explicar a obsessão, porque ela é o motivo de tudo.

Eu sempre achei o Master System um console superior ao NES. Melhor CPU, melhor chip de vídeo, uma paleta de cores bem mais rica. O NES trabalha com 4 cores por tile de fundo e 3 por sprite. O Master System trabalha com paletas de 16 cores. Isso é uma diferença enorme na prática.

O problema é que a Nintendo tinha um monopólio brutal na época e não deixava as third parties lançarem pra outros consoles. Quem quisesse fazer jogo pro NES assinava um contrato de exclusividade. O resultado é que o Master System, tecnicamente melhor, ficou faminto de jogos. Praticamente só a própria Sega lançava, e a biblioteca da Sega nunca teve o peso de um Castlevania, um Mega Man, um Final Fantasy.

Imagina o que a gente perdeu. Dava pra ter tido aqueles mesmos jogos clássicos do NES, só que com a capacidade superior do Master System por baixo. Um Castlevania com mais cor, sprites melhores, som melhor. A gente nunca teve isso, e é exatamente essa frustração histórica que me fez querer converter NES pra SMS em primeiro lugar.

## O port que provou a tese

Enquanto eu estava com o projeto parado, um outro desenvolvedor, o [lackoftrack27](https://github.com/lackoftrack27/Super-Mario-Bros.-SMS), publicou um port de Super Mario Bros pro Master System que é de outro nível. Roda em velocidade cheia, 60fps, e ainda por cima com uma arte de sprite melhorada que aproveita a paleta superior do console. Ficou mais parecido com o remaster do Super Mario All-Stars do Super Nintendo do que com a versão original meio crua do NES. A comunidade retro ficou de queixo caído.

{{< youtube id="igOu1NQL5Ww" >}}

Isso provou, na prática, a minha tese: o Master System é capaz de rodar versões superiores dos jogos de NES. Sempre foi.

Agora, dois pontos honestos sobre esse port, porque eles importam pro resto da história.

Primeiro: o trabalho do lackoftrack27 é uma reimplementação feita à mão, a partir da disassembly do jogo, otimizada especificamente pro Super Mario. Não é uma tradução automática de propósito geral como a que eu tento fazer. Ele resolveu um jogo, lindamente, no braço. Curiosamente, isso reforça o que os fóruns já diziam: o caminho que funciona é reimplementar no braço, não traduzir a máquina.

Segundo: por mais impressionante que seja ver o Super Mario no Master System, é bom lembrar que ele ainda é um jogo de primeira geração, de uns 40kb. Ou seja, é um dos jogos mais simples do NES. Coisas de geração posterior, tipo Super Mario Bros 3 ou Kirby, ninguém tentou converter ainda, e por bons motivos que eu explico mais pra frente.

Mas o mais importante foi o efeito colateral: com o mapa que o port dele me deu, eu finalmente consegui fazer a minha conversão automática rodar direito. Voltei ao projeto no começo de setembro, carreguei o código do lackoftrack27 no Claude Fable e depois no novo GPT Astra, e coloquei os dois pra estudar o que ele fez que eu não estava fazendo.

## A arquitetura da solução

Como esse artigo é pra programador, deixa eu abrir a caixa preta.

A primeira decisão importante é que o `nes-to-sms` não é um emulador, nem um tradutor texto-pra-texto de 6502 pra Z80. Ele é um **recompilador estático**. Ele lê a ROM do NES, levanta o código 6502 pra uma representação intermediária com semântica explícita, e daí gera código Z80 a partir dessa IR. A saída é um projeto em assembly WLA-DX que compila numa ROM `.sms` de verdade. O núcleo é um workspace Rust com treze crates, mais um runtime Z80 escrito à mão que é compartilhado entre os jogos.

O fluxo, de ponta a ponta, é mais ou menos assim:

1. Parsear o cabeçalho da ROM, separar os bancos de código (PRG) e de tiles (CHR) e ler os vetores de reset e interrupção.
2. Carregar um perfil por jogo (um TOML com rótulos, regiões de dados, tabelas de salto, tipo de mapper e substituições).
3. Descobrir as funções, montar o grafo de fluxo e classificar cada byte como código ou dado. Aqui entra um detalhe chave: cada acesso à memória é etiquetado com a região a que pertence (zero page, pilha, RAM, registradores do PPU, DMA de sprite, som, mapper).
4. Levantar cada rotina pra IR, com as flags do 6502 explícitas. Uma escrita no registrador `$2006` do PPU não vira um `mem[]=` qualquer, vira uma primitiva de "escrita no PPU" de primeira classe.
5. Baixar a IR pra Z80. As flags do 6502 são mantidas num byte de status sombra na RAM, e todo acesso a hardware vira uma chamada pro runtime.
6. Emitir os bytes Z80 e também o assembly WLA-DX legível.
7. Converter os assets: os tiles 2bpp do NES viram tiles 4bpp do modo 4 do Master System, a paleta do NES vira a CRAM do SMS, e por aí vai.
8. Escrever o projeto SMS inteiro, com Makefile, runtime e dados, pronto pra compilar.

O mapeamento da CPU é conservador de propósito. O acumulador `A` do 6502 vira o `A` do Z80, os registradores `X` e `Y` ficam em RAM ou em registradores, a zero page vira um bloco fixo na RAM do SMS, e cada operação que mexe em flag chama um helper. É seguro e correto, mas é justamente aqui que mora o custo.

## Onde NES e SMS divergem de verdade

O achado central do projeto é sobre velocidade, e ele é contraintuitivo.

O 6502 do NES roda a 1.79 MHz. O Z80 do Master System roda a 3.58 MHz, o dobro do clock. Você olha isso e pensa "então tem folga de sobra". Só que não. O Z80 gasta em média uns 13 ciclos por instrução, enquanto o 6502 gasta uns 4. Na conta real, um Z80 de 3.5 MHz equivale mais ou menos a um 6502 de 1 MHz pra trabalho genérico. Ou seja, o Z80 do SMS é na verdade **mais lento** que o 6502 do NES pra fazer o mesmo trabalho. A folga é negativa.

Pior: o idioma mais barato do 6502, um `LDA tabela,X`, é um dos mais caros de emular no Z80. Então uma tradução fiel de um jogo que já espremia o NES no talo simplesmente não tem como bater 60fps sem overclock. A culpa é da física do problema, não do meu tradutor.

E o vídeo é outra história. O NES enxerga a memória de vídeo de forma mapeada, com nametables, scroll por hardware e uma tabela de sprites acessada por DMA. O Z80 do SMS não endereça a VRAM como memória: ele seta um latch de endereço e joga bytes por portas do VDP. Então toda escrita de PPU do NES precisa ser capturada, enfileirada num buffer e despejada no VDP durante o vblank. O NES vira sprite de graça, só setando um bit de atributo. O Master System não tem flip de sprite por hardware, então o programa precisa espelhar os dados do tile na VRAM na unha, gastando memória. O split de tela que os jogos de NES fazem no meio do frame, mexendo no scroll a cada scanline, também não tem equivalente direto, porque o VDP trava o scroll vertical no topo do frame.

E ainda tem o teto de VRAM. Os 8 KB de tiles do Super Mario viram 16 KB no formato 4bpp do SMS, que é a VRAM inteira do console. Fundo e sprites não cabem residentes ao mesmo tempo. E o código explode de 3 a 6 vezes de tamanho, por isso a saída SMS já é bancada desde o primeiro jogo, mesmo os mais simples.

## Aproveitando o que o SMS tem de melhor

A sacada pra recuperar velocidade é parar de emular o comportamento do NES e passar a gastar as forças do Master System. O lema do projeto virou "gastar ROM pra comprar CPU".

O SMS aceita cartuchos de vários megabytes. Então em vez de espelhar sprite na unha em tempo de execução, o build já gera variantes pré-espelhadas de cada tile de sprite, e o flip vira uma consulta de tabela. Em vez de emular a tabela de atributos do NES, o assembler já grava a palavra final de nametable do SMS, com os bits de flip, paleta e prioridade embutidos. A tabela de atributos do NES simplesmente deixa de existir no programa. As cópias pro VDP usam blocos de `OUTI` desenrolados, mais rápidos que o loop genérico. E o split da barra de status, que no NES depende do sprite-zero, vira uma interrupção de linha do SMS, que é o jeito nativo de fazer isso.

Nada disso é mágica. A folga negativa da CPU continua lá, então essas otimizações reduzem o custo mas não fazem milagre sozinhas. Mas é a diferença entre injogável e jogável.

## O pulo do gato: fazer a IA rodar o emulador

Aqui está a parte que eu considero mais importante do projeto inteiro, e é o que separou a tentativa fracassada de maio da versão que finalmente anda.

Tradução cega não funciona. O modelo precisa de feedback real pra saber o que está quebrado e o que está lento. Então o coração do projeto está no **oráculo diferencial**, a infraestrutura que roda os emuladores e mede a realidade. O tradutor é só a parte fácil.

Funciona em duas camadas. A primeira compara instrução por instrução: pra cada rotina, o sistema gera estados iniciais aleatórios, roda o 6502 original num interpretador de referência e roda o Z80 gerado, e compara o resultado (acumulador, registradores, flags, RAM tocada). Qualquer divergência acende o alerta. A segunda camada compara frame a frame: ela roda a ROM do NES como verdade absoluta e a build do SMS lado a lado, com o mesmo roteiro de botões, e compara a RAM byte a byte em cada frame. Depois isso foi estendido com um oráculo que confere a VRAM e a paleta do SMS, e com um oráculo visual que compara a saída contra o frame real do NES.

Esse loop de medir é o que destravou os consertos recentes. Não foi chute. Dois exemplos concretos:

No Super Mario, cada passo de otimização foi medido em ciclos por frame, com o emulador rodando de verdade. O orçamento de um frame é 59.736 ciclos. A base parou em uns 370 mil ciclos por frame, algo como 6 vezes acima do orçamento, o que dava uns 10fps e explicava a necessidade daquele overclock brutal de 500%. Medindo passo a passo, cada mudança validada pelo oráculo, a coisa desceu até 118.296 ciclos por frame, ou 1.98 vezes o orçamento. Ou seja, saiu de 6 vezes pra menos de 2 vezes. Agora ele roda em velocidade cheia já no overclock padrão do emulador, e fica confortável ali na casa dos 200 a 300%, contra os 500 a 700% do começo.

No Castlevania, o maior ganho de velocidade veio de um perfil que só o emulador conseguiu revelar: um loop de espera de sprite-zero, no endereço `$F8C7`, estava fazendo 255 leituras de status e saindo por timeout toda vez, consumindo quase 23% de toda a CPU. Sem rodar o emulador e medir, ninguém acharia isso no olho. Com a medição, o conserto foi cirúrgico.

É esse o argumento maior que eu venho batendo faz tempo sobre agentes: um LLM que só gera código no escuro erra feio. Um LLM que consegue rodar o alvo de verdade, coletar dado real e reagir ao que mediu joga em outro nível.

## O que aprendi estudando o port do lackoftrack27

Com esse oráculo no lugar, coloquei o Claude Fable e o GPT Astra pra dissecar o port do lackoftrack27, que é uma reimplementação do mesmo jogo a partir da mesma disassembly que eu traduzo. Isso respondeu de vez uma dúvida que estava me travando: o Super Mario cabe no Master System. O meu estouro de 6 vezes no orçamento era 100% overhead de tradução, não limitação do jogo nem do hardware.

Os ganhos dele, em ordem de impacto, foram mais ou menos esses:

- **A maior de todas: a representação dos dados.** Ele reorganizou os arrays de objetos do jogo em páginas de RAM, uma por slot, com os mesmos offsets de campo. Aí o `X` do 6502 vira o registrador `H` e o nome do campo vira o `L`, e um acesso que no meu tradutor custava umas 70 unidades de tempo passa a custar 14. O detalhe cruel é que isso só funciona porque o programador sabe, de cabeça, que aquele `X` ali é sempre um índice de objeto entre 0 e 6. Um tradutor estático não tem como descobrir esse invariante com segurança. Essa é a otimização mais poderosa, e é justamente a que a tradução automática não consegue provar sozinha. É o resíduo que segura as últimas 2 vezes de velocidade.
- **Flags auditadas, não emuladas.** Ele checou o código e achou só uns 10 lugares que dependem de verdade de alguma peculiaridade do carry do 6502. O resto usa flag nativa do Z80. Isso confirmou uma medição minha: gastar energia emulando flag rende quase nada.
- **Chamadas nativas.** `JSR` virando `CALL` de verdade, sem a contabilidade cara de pilha emulada. Esse foi o maior ganho genérico que eu portei pro meu pipeline.
- **PPU deletado em tempo de build**, não emulado em runtime, exatamente como descrevi na seção de aproveitar o SMS.
- **Frame arquitetado pra estourar com elegância**, transformando um estouro em um frame de lag limpo em vez de corromper a tela.

Adotei o que dava pra generalizar, e o Super Mario despencou de 6 vezes pra menos de 2 vezes o orçamento. Esse é o resultado rodando hoje:

<div class="embed-container">
  <video controls preload="metadata" playsinline style="position:absolute;top:0;left:0;width:100%;height:100%;border:0;background:#000;">
    <source src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260907152243_smb-sms-conversion.mp4" type="video/mp4">
  </video>
</div>

A lição mais honesta desse estudo é dupla. Os ganhos de verdade estão na representação de dados e na convenção de chamada, não no que eu tinha atacado primeiro. E o ganho mais fundo de todos é exatamente o que o tradutor automático não consegue inferir. Isso desenha bem o teto do que dá pra automatizar.

## Castlevania e o problema dos mappers

Com o Super Mario andando, voltei pro meu velho alvo: o primeiro Castlevania. E aqui a gente esbarra na limitação mais séria do NES.

O NES é um console simples, com um monte de limitação. Uma das principais é que ele não suporta jogo maior do que uns 40kb de ROM, porque o 6502 só enxerga uma janela de 32 KB de programa no espaço de endereço dele. A "solução" da época foi genial e meio maluca: partes do console foram sendo turbinadas pelo próprio cartucho.

Muita gente pensa que cartucho é só um chip de ROM com o código do jogo. No caso do NES, não. Os cartuchos vinham com uma variedade de chips extras que aumentavam a capacidade do console, seja um chip de som melhor ou, muito mais comum, os **mappers**. Existem vários mappers diferentes, da própria Nintendo e de third parties como Capcom e Konami. Eles usam uma técnica chamada **bank switching**: como o 6502 não enxerga endereço suficiente, o mapper vai trocando quais pedaços de ROM ficam visíveis naquela janela de 32 KB, conforme o jogo pede. É assim que jogos grandes cabem num console que, no papel, não aguentaria.

Eu já expliquei isso em detalhe num vídeo antigo do canal, o [Akitando #81, sobre aprender computação com o Super Mario do jeito hardcore](/2020/06/18/akitando-81-aprendendo-sobre-computadores-com-super-mario-do-jeito-hardcore/):

{{< youtube id="hYJ3dvHjeOE" >}}

O Castlevania usa um dos mappers mais antigos, o UxROM. E aqui está o problema de escala do meu projeto: se eu quiser conseguir traduzir a maioria dos jogos de NES, eu tenho que mapear todos os mappers, um por um. Hoje o projeto implementa só dois: o NROM, que é o cartucho pelado do Super Mario, e o UxROM do Castlevania. Todos os outros, os MMC1, MMC3 e companhia, estão só planejados. Cada mapper é um trabalho e tanto de implementar, porque não basta entender o bank switching do NES, é preciso traduzir esse comportamento pro mapper próprio do Master System.

A boa notícia é que o Master System também é um sistema bancado, então o mapeamento é "a mesma forma um nível acima". Um banco de PRG do NES vira um conjunto de bancos do SMS, uma escrita de troca de banco do NES vira uma escrita no mapper do SMS através de um shim, e uma chamada que cruza bancos usa a maquinaria de "portão" que já existe. A identidade de uma rotina passa a ser o par (banco, endereço), e uma tabela de despacho resolve isso em tempo de execução. Quando não acha, ele falha fechado, com um trap, em vez de rodar lixo.

É aqui que os jogos maiores vão bater na parede. O bank switching de tiles dos mappers mais avançados, o timing de interrupção por scanline do MMC3 e do MMC5, e o próprio teto de bancos do SMS pra um jogo de NES bem grande, tudo isso ainda está por resolver. Por isso eu ainda não sei dizer se um Super Mario Bros 3 é viável ou não. É bem possível que os jogos maiores morram exatamente nessa etapa.

De qualquer forma, mexi mais um bocado no Castlevania nessa retomada. Consertei uma pilha de coisas usando o oráculo: o loop de sprite-zero que comia CPU, a lógica de armas e projéteis que perdia retornos de chamada, um glitch de scroll na barra de status, a colisão de VRAM entre sprites 8x16 e 8x8, e a coerência entre fundo, paleta, HUD e sprites. Hoje o Castlevania sobe, aceita o start, desenha o primeiro estágio de forma reconhecível, responde ao controle e roda por um bom tempo sem travar. Mas é honesto dizer que ele ainda roda devagar, e o caminho que eu uso pra jogar é o Mednafen com overclock de 500%, e mesmo assim ainda está de 2 a 3 vezes abaixo da própria meta de velocidade. Está longe de ser pixel perfeito e em tempo real.

<div class="embed-container">
  <video controls preload="metadata" playsinline style="position:absolute;top:0;left:0;width:100%;height:100%;border:0;background:#000;">
    <source src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260907152243_castlevania-sms-conversion.mp4" type="video/mp4">
  </video>
</div>

## Conclusão

Depois de tantas semanas e tantas tentativas, eu ainda não sei quanto mais dá pra espremer de uma tradução automática. O teto pode estar perto, porque as otimizações mais fundas são justamente as que uma máquina não consegue inferir sozinha.

Mas tem um caminho que me anima. A tradução automática pode virar uma linha de base. Uma conversão SMS que já roda, correta, ainda que lenta, e que depois pode ser otimizada no braço, jogo a jogo, exatamente como o lackoftrack27 fez com o Super Mario e como tanta gente vem fazendo com decompilações e ports por aí. O oráculo garante que a base está correta, e a mão humana entra pra fazer o que a máquina não consegue.

Portar jogo pra um hardware muito superior, tipo um port pra PC, é relativamente fácil, porque sobra capacidade. O difícil de verdade é encaixar o jogo num console da mesma geração, onde não sobra nada. E é justamente essa dificuldade que torna a ideia de fazer versões melhores de jogos de NES pro Master System tão atraente. É o console que merecia ter tido esses jogos, e nunca teve.

Eu espero que mais gente se anime com essa possibilidade e contribua com o projeto. Está tudo aberto no [nes-to-sms](https://github.com/akitaonrails/nes-to-sms). Se você curte 6502, Z80, VDP e o desafio de espremer ciclo de um hardware de 40 anos atrás, apareça. Tem lugar de sobra.
