---
title: "Engenharia Reversa com IA: a Adobe morreu?"
slug: "engenharia-reversa-com-ia-a-adobe-morreu"
date: '2026-10-13T00:00:00-03:00'
draft: false
translationKey: engenharia-reversa-com-ia-a-adobe-morreu
description: "Na mesma semana, um dev soltou sete clones da Adobe feitos com Claude, o REA passou de 100 mil estrelas prometendo 'engenharia reversa de qualquer coisa', e o retrô ganhou port novo todo dia. A conclusão viral: nenhum binário é sagrado, a Adobe morreu, programador morreu. Explico o que cada coisa dessas faz de verdade: o PhotoCraft é alpha com mais de 800 issues abertas, o REA é uma caixa de ferramentas que exige o binário e o Ghidra, e o retrô anda rápido porque ROM de 8 MB vira 135 mil linhas de C. Reescrever o Bun custou US$ 165 mil com o autor e 64 agentes; o Photoshop nem binário aberto tem nas partes que importam. Engenharia reversa ficou mais fácil. Mágica continua sem existir."
tags:
- inteligencia-artificial
- vibe-coding
- retrocomputacao
- open-source
---

O PhotoCraft existe. O REA existe. Recomp e decomp de jogo antigo saem todo dia. Logo: a Adobe morreu, nenhum binário é sagrado, e programador acabou.

Essa foi a semana no X, e se você só lê manchete, é uma conclusão razoável. Este texto é pra quem quer saber o que cada uma dessas coisas faz de verdade.

Explodiu no dia 9, quando a conta abaixo resumiu o que um desenvolvedor de Atlanta, Brandon Thomas, vinha publicando desde o fim de setembro: sete clones de código aberto dos produtos principais da Adobe, escritos em Rust com ajuda do Claude Opus 5.5. Photoshop, Illustrator, Premiere, Lightroom, After Effects, InDesign, Acrobat. Tudo de graça, tudo feito em "sala limpa", sem uma linha de código da Adobe. A conta que viralizou foi esta:

<blockquote class="twitter-tweet"><p lang="en" dir="ltr">AI is now being used to recreate Adobe's software, a developer has released seven free, open-source apps as clean-room alternatives to Adobe's main tools:<br><br>- PhotoCraft → Photoshop<br>- VectorCraft → Illustrator<br>- FilmCraft → Premiere Pro<br>- LightCraft → Lightroom<br>- EffectCraft → After Effects<br>- DesignCraft → InDesign<br>- PrintCraft → Acrobat Pro<br><br>Built in Rust with help from Claude Opus 5.5, they run on Windows, Linux, and macOS under MIT/Apache licenses without using Adobe's source code.</p>&mdash; Pirat_Nation (@Pirat_Nation) <a href="https://twitter.com/Pirat_Nation/status/2108437553615425881">October 9, 2026</a></blockquote>
<script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Na mesma semana, o [REA](https://github.com/morluto/rea), "Reverse Engineer Anything", passou de 100 mil estrelas no GitHub, ganhando dezenas de milhares por dia. A promessa da página: "viu uma feature num app que você quer no seu produto? Peça pro seu agente investigar com o REA e construir uma versão pro seu projeto".

E quem acompanha retrogaming sabe que 2026 é o ano que não para de dar. Tem uma [planilha comunitária](https://docs.google.com/spreadsheets/d/1MT_xMPlKNbyhANRUMzOH94J3ybeF0b1Ws8F0kb-_598/edit) tentando listar os ports não oficiais pra PC, com uns 100 jogos de Ship of Harkinian a Skate 3, e ela está sempre atrasada. O canal [Video Game Esoterica](https://www.youtube.com/@VideoGameEsoterica) publica port novo quase todo dia: Time Crisis decompilado do arcade, Daytona USA, Bloodborne.

A versão de Xbox One do [Forza Horizon 2](https://almost-there-games.itch.io/azimuth), presa lá desde 2014, roda em Windows. O [AnyPS5](https://github.com/boykopovar/AnyPS5) promete converter executável de PS5 em binário nativo de PC, e emuladores de PS5 como o KytyPS5 e o SharpEmu já [rodam Astro Bot](https://www.invenglobal.com/articles/26860/astro-bot-boots-on-pc-as-ps5-emulation-makes-rapid-progress) com gameplay de verdade. Boa parte disso com IA no meio, alguns abertamente vibe-coded.

Daí o consenso: programar, em geral, acabou. Todo binário é reversível e reutilizável, basta apontar o agente. Minha posição é que ficou muito mais fácil mesmo, que ainda está longe da bala de prata que as pessoas imaginam, e que o motor por trás disso, o LLM, [parou de crescer exponencialmente](/2026/10/12/llms-agentes-competente-o-suficiente/). O resto do texto são os motivos.

> **TL;DR:** engenharia reversa é uma disciplina de 40 anos com ferramenta madura, e a IA acelerou o trabalho braçal dela, com destaque pro retrô, onde o binário está disponível, é minúsculo e o alvo não se move. Os clones da Adobe são alpha com centenas de bugs abertos e print bonito. O REA é uma caixa de ferramentas que exige o binário na mão, Ghidra ou IDA instalados, e muito token. O que vale dinheiro hoje nem binário tem: é SaaS, nuvem, parceria com fabricante e décadas de ciência de cor. Reescrever o Bun, com o autor do projeto e 64 agentes, custou US$ 165 mil. Pule pra [linha do tempo](#engenharia-reversa-não-nasceu-semana-passada), pro [REA](#o-que-o-rea-faz-de-verdade), pros [clones da Adobe](#photocraft-print-bonito-alpha-por-dentro), pro [caso Bun](#o-caso-bun-quanto-custa-reescrever-software-grande), por que [o retrô anda rápido](#por-que-o-retrô-anda-tão-rápido) ou pras [respostas no final](#respondendo-a-lista-do-começo).

## Antes de tudo: eu não gosto da Adobe

Pra ficar claro de onde eu falo. Eu detesto as práticas comerciais da Adobe tanto quanto qualquer um. Fui cliente pagante por anos, usei Photoshop e Premiere extensivamente, mais Lightroom e After Effects, e saí pelos mesmos motivos que todo mundo sai: assinatura compulsória, cancelamento com multa, preço subindo sem contrapartida.

E é exatamente por ter usado a fundo que eu sei o tamanho do que está dentro daquelas caixas. Quem acha que Photoshop é camada, crop e texto nunca precisou de prova de cor pra gráfica, nunca abriu um RAW de câmera cujo perfil de cor a Adobe mantém há vinte anos, nunca fez a conformação de material de cinema, o trabalho de reunir o material bruto da câmera pra finalização. Vou chegar lá, depois do básico.

## Engenharia reversa não nasceu semana passada

Todo emulador que você já usou existe porque alguém abriu hardware, desmontou binário, farejou protocolo e, em alguns casos, quebrou criptografia. A disciplina tem jurisprudência, ferramenta comercial e uma história de décadas. Uma linha do tempo resumida, com os marcos que mais importam:

- **1982 a 1984**: a Compaq reescreve a BIOS do IBM PC por engenharia reversa, e em 1984 a Phoenix vende uma BIOS licenciável feita em sala limpa, com um time que só lia a especificação. Nasce a indústria de PC compatível. [Fonte](https://en.wikipedia.org/wiki/Phoenix_Technologies).
- **1992**: Andrew Tridgell cria o Samba farejando pacotes SMB. No mesmo ano, [Sega v. Accolade](https://www.copyright.gov/fair-use/summaries/segaenters-accolade-9thcir1992.pdf) e [Atari v. Nintendo](https://www.copyright.gov/fair-use/summaries/atari-nintendo-fedcir1992.pdf) firmam nos EUA que desmontar código pra chegar em elementos funcionais é *fair use*, uso justo (a Atari perdeu o caso dela por outro motivo: mentiu pro Copyright Office pra conseguir o fonte).
- **1993**: começa o Wine, que vira a base do Proton e de todo jogo de Windows que roda no Steam Deck hoje.
- **1999**: UltraHLE roda jogos comerciais de N64 em velocidade real; o bleem! emula PS1, a Sony processa e perde as liminares, e o bleem! ainda assim fecha em 2001; o DeCSS quebra a proteção do DVD.
- **2000**: [Sony v. Connectix](https://law.resource.org/pub/us/case/reporter/F3/203/203.F3d.596.99-15852.html) decide que copiar a BIOS do PS1 pra construir um emulador é uso justo.
- **2002 e 2003**: nascem PCSX2 e Dolphin, os dois emuladores que vinte anos depois ainda são referência.
- **2007**: o iPhone é aberto onze dias depois do lançamento. A Comissão Europeia obriga a Microsoft a documentar seus protocolos de rede, e a [equipe do Samba recebe a documentação](https://fsfe.org/news/2007/news-20071220-01.html) por 10 mil euros.
- **2010**: o grupo fail0verflow mostra no 27C3 que a Sony assinou o firmware do PS3 com um nonce fixo, expondo a chave privada (o nonce é o número que deveria ser aleatório em cada assinatura). Dias depois, já em 2011, o geohot publica a chave, a Sony processa e faz acordo em março.
- **2011 e 2013**: nascem RPCS3 (PS3) e Xenia (Xbox 360), os dois emuladores mais difíceis já feitos, por motivos que vou explicar.
- **2019**: a NSA libera o [Ghidra](https://github.com/NationalSecurityAgency/ghidra) como código aberto. A decompilação do Super Mario 64 vaza e vira pública, e no ano seguinte aparece o port pra PC.
- **2021 e 2022**: Ocarina of Time 100% decompilado depois de quase dois anos de trabalho; o Ship of Harkinian vira o port de referência.
- **2024**: Mr-Wiseguy lança o [Zelda 64: Recompiled](https://github.com/Zelda64Recomp/Zelda64Recomp/releases), a primeira vitrine da recompilação estática de N64.
- **2025**: Sonic Unleashed Recompiled traz o mesmo truque pro Xbox 360, convertendo PowerPC pra C++ e shaders pra HLSL.

Repare que a fase atual, decomp e recomp em escala, começa em 2019, bem antes de qualquer agente de código. A IA entrou numa linha de montagem que já existia.

### As ferramentas

O ferramental também é maduro, e boa parte é gratuita:

- [IDA Pro](https://hex-rays.com/ida-pro) (Hex-Rays), o disassembler e decompilador comercial de referência, de mil a quase nove mil euros por ano, com uma versão gratuita limitada a x86.
- [Ghidra](https://github.com/NationalSecurityAgency/ghidra), a resposta aberta da NSA, com decompilador e scripting, Apache 2.0.
- [Binary Ninja](https://binary.ninja/), com uma edição gratuita e licenças de 200 a 3.500 dólares.
- [radare2](https://github.com/radareorg/radare2) e o [Cutter](https://github.com/rizinorg/cutter), interface do rizin, que é um fork do radare2: a linha de comando e a interface abertas.
- [x64dbg](https://github.com/x64dbg/x64dbg) e [WinDbg](https://learn.microsoft.com/en-us/windows-hardware/drivers/debugger/) no Windows, [GDB](https://www.sourceware.org/gdb/) no resto.
- [Frida](https://frida.re/), pra injetar código em processo vivo e observar o que ele faz.
- [JADX](https://github.com/skylot/jadx) pra Android e [ILSpy](https://github.com/icsharpcode/ILSpy) pra .NET.

Guarde essa lista. O REA, que a gente vai ver daqui a pouco, é um embrulho em volta dela.

## Como se desmonta um binário, na prática

Em princípio, todo binário é reversível. O processador precisa conseguir executar aquilo, então as instruções estão lá. O caminho é sempre o mesmo:

1. **Desmontar**: o binário vira assembly, uma instrução de máquina por linha. Isso é mecânico.
2. **Decompilar**: o assembly vira algo parecido com C. Ghidra e IDA fazem isso razoavelmente bem, com muito ruído.
3. **Recuperar o que o compilador jogou fora**: nome de variável, nome de função, tipos, estruturas, comentários. Nada disso sobrevive à compilação. Esse é o trabalho de verdade, e é humano.
4. **Refatorar** até virar código que uma pessoa consegue ler, manter e portar.

Os projetos de decomp de N64 fazem o passo 4 até o fim: o código em C deles, recompilado, gera byte a byte a ROM original. É assim que o Super Mario 64 virou um projeto com 135 mil linhas de C de código de jogo (uns 100 mil de código efetivo, mais meio milhão de linhas de dados de fase e modelo gerados), e o Ocarina of Time passou de 430 mil linhas. A recompilação estática pula parte disso: traduz as instruções do processador original pra C genérico, sem tentar entender, e troca só as partes que falam com o hardware. É mais rápido e o resultado é menos legível.

### "Mas a IA não pode ler o binário direto?"

Alguém sempre pergunta: se é IA, pra que passar por C? Deixa o modelo ler o binário e construir em cima. A resposta curta é que LLM só sabe o que estava no corpus de treino, e corpus de binário pareado com código fonte é escasso, porque nenhum humano escreve assembly de produção há décadas.

A resposta longa é que existe literatura, e ela é instrutiva justamente por ser modesta. A linhagem vai de redes neurais de 2018 a modelos como o [SLaDe](https://arxiv.org/abs/2305.12520) (200 milhões de parâmetros, um por arquitetura e nível de otimização), o [LLM4Decompile](https://arxiv.org/abs/2403.05286) (até 33 bilhões) e o [Nova](https://arxiv.org/abs/2311.13721). A Meta publicou um [LLM Compiler](https://arxiv.org/abs/2407.02524) que traduz assembly pra IR do LLVM. Os melhores resultados, em funções isoladas de benchmark, giram em torno de 60 a 65% de código que roda de novo e dá o mesmo resultado, caindo forte quando o compilador otimizou com -O3.

Dois estudos recentes mostram o estado real. O [DecompileBench](https://arxiv.org/abs/2505.11340), com 23 mil funções reais, achou que decompiladores baseados em LLM produzem código mais legível e com metade da correção funcional dos decompiladores comerciais. E um [trabalho de setembro de 2026](https://arxiv.org/abs/2609.05370) mediu que o refinamento por LLM da saída do Ghidra sobe a taxa de compilação de 75% pra 90% e derruba a fidelidade de comportamento de 74% pra 62%, com até uns 10% das funções com vulnerabilidade conhecida deixando de reproduzir a falha, ou seja, o bug sumiu sem ninguém pedir.

> Resumindo o que existe: modelos pequenos, função por função, quase só x86-64 Linux, e os melhores são camadas de refinamento em cima do Ghidra, o que mantém o decompilador clássico no loop. Nenhum emulador, nenhum jogo, nenhum programa inteiro foi recompilado neuralmente. Enquanto alguém não inventa isso, você trabalha com a realidade, e a realidade inclui a camada intermediária de linguagem de programação e compilador.

Os assistentes de IA que existem pra isso em produção confirmam o desenho: o [aiDAPal](https://plugins.hex-rays.com/aidapal), plugin de IDA da Atredis, o Sidekick do Binary Ninja, os servidores MCP pro Ghidra. Todos são um LLM dando nome a variável e explicando função em cima do que o decompilador tradicional produziu.

## O que o REA faz de verdade

Eu clonei o [REA](https://github.com/morluto/rea) e li o código. Ele é um servidor MCP e uma CLI em TypeScript que embrulha as ferramentas da lista acima e as expõe pro seu agente de código: Ghidra, Hopper, IDA, JADX, Frida, Wakaru pra JavaScript ofuscado, Playwright pra capturar o que um site faz. O agente pede, o REA roda a ferramenta e devolve pseudocódigo, grafo de chamadas, strings e traces de IPC, cada resultado com um registro de evidência e uma lista de limitações.

Esse fluxo eu já tinha feito na mão, meses antes de o REA viralizar. Em julho eu [coloquei o Fable 5 pra analisar o código do TikTok, do Clash of Kings e do gov.br](/2026/07/08/fable-5-analisar-codigo-tiktok-clash-of-kings-govbr-fingerprint/): baixei os APKs, descompactei (APK é um zip), rodei o JADX nos `.dex` e deixei o modelo ler o Java que saiu do outro lado. Deu pra ver os endpoints, as permissões, os SDKs embutidos e como cada app monta o fingerprint do aparelho, aquele identificador persistente que sobrevive a limpar dados e reinstalar. O TikTok saiu como coleta de grau industrial, blindada contra auditoria; o gov.br, como exemplo de como fazer direito.

As três lições daquele post valem pro REA inteiro. Android é fácil demais de descompilar, e mesmo assim o resultado serve só pra análise estática, porque recompilar o app fica fora de alcance: os nomes vêm embaralhados pela ofuscação, faltam recursos e chaves de assinatura. A parte mais sensível mora em código nativo, `.so` em C e C++, que descompila em nada legível, e no TikTok é justamente aí que fica o miolo. E o que saiu daquele trabalho foi um relatório sobre o que o app faz, com ressalvas, e nenhum clone do TikTok. O REA embala esse mesmo fluxo num servidor MCP; as paredes continuam no mesmo lugar.

Quem fornece o julgamento é o LLM que você já paga. O REA fornece o encanamento determinístico e a proveniência. A frase "automatiza as heurísticas de engenharia reversa", que circula por aí, não aparece em lugar nenhum do repositório; a descrição que o próprio projeto usa é engenharia reversa dirigida por agente, com evidência rastreável.

O que ele exige: o artefato na sua máquina (binário nativo, app Electron, assembly .NET, APK, firmware, captura de rede), Node 22.19 ou superior, e as ferramentas pesadas instaladas por sua conta. Ghidra é grátis; IDA, Hopper e JEB o README manda você comprar. Não tem chave de API do REA porque ele roda local, e o custo de token cai inteiro na sua assinatura de agente.

E esse custo é o detalhe que ninguém cita. O catálogo de ferramentas MCP do REA tem 2,3 MB de JSON, que entra no contexto do agente. O próprio projeto publica um [experimento](https://github.com/morluto/rea/tree/main/experiments/analysis-efficiency) em que analisar o SQLite compilado em WASM, no caminho padrão, levou 42 chamadas de ferramenta, cinco minutos e 300 mil tokens de entrada. Um inventário completo de um app Electron como o Obsidian devolve quase 1 MB de JSON.

Tem issue aberta reclamando que inspecionar um app de Mac comum devolve de 80 a 230 mil tokens de uma vez.

O projeto é sério e vai longe: seis meses, 2.600 commits, mil arquivos de teste, versão 6.4 lançada em 11 de outubro. Também é instável: 190 issues abertas, várias mudanças incompatíveis a cada versão menor, subsistemas marcados como experimentais.

Os limites estão escritos no próprio repositório. O CONTRIBUTING exclui quebra de DRM, anticheat, licença e proteção comercial. O DISCLAIMER avisa que decompilação, reconstrução e análise assistida por IA "podem ser incompletas ou incorretas". E até as instruções internas pra gerar as figuras do site dizem, com todas as letras: "nunca implique que o REA clona um programa automaticamente" e "nunca diga reconstrução completa, clone exato ou recuperação automática de código fonte".

> O REA é uma boa caixa de ferramentas pra quem já sabe fazer engenharia reversa e quer um agente segurando o Ghidra. Ele não é o botão "copia esse app pra mim". Quem escreveu o projeto é o primeiro a dizer isso.

## PhotoCraft: print bonito, alpha por dentro

O [repositório do PhotoCraft](https://github.com/storytold/photocraft) foi criado em 30 de setembro. Em duas semanas, 54 mil estrelas, 8 versões lançadas e, no momento em que escrevo, mais de 800 issues abertas. O selo no README diz "early alpha", e o próprio Brandon Thomas, citado pela Gizmodo, disse que não está nem perto de pronto. A imprensa que testou chegou na mesma conclusão: a Gizmodo chamou de "Photoshop cheio de bug, mas real", e o OMG Ubuntu de "fac-símile superficial com falhas pronunciadas".

As issues contam a história técnica:

- Qualquer imagem acima de 8.192 pixels sai do compositor de GPU e cai pra CPU, com pico de 6 GB de memória, porque o limite de textura do egui-wgpu é esse ([issue 49](https://github.com/storytold/photocraft/issues/49), já fechada, e as que vieram depois, [1015](https://github.com/storytold/photocraft/issues/1015) e [4017](https://github.com/storytold/photocraft/issues/4017)).
- Uma foto de 12 megapixels precisa de quase 800 MB só pra abrir, ajustar e exportar pela linha de comando ([issue 1637](https://github.com/storytold/photocraft/issues/1637)).
- O gerenciamento de cor é rudimentar: espaço de trabalho só global, em vez de por documento, e sem transformação de visualização ([issue 321](https://github.com/storytold/photocraft/issues/321)). Dezoito issues mencionam CMYK, quinze mencionam perfil ICC.
- Quase cem issues abertas mencionam PSD. Camadas de matiz e saturação compõem diferente do Photoshop, e salvar por cima sobrescreve a imagem mesclada correta do arquivo original ([issue 4089](https://github.com/storytold/photocraft/issues/4089)).
- Cinquenta issues abertas mencionam "crash".

A interface lembra o Photoshop, então o print é compartilhável, e quem vê o print assume que é cópia carbono. Isso é esperado numa alpha de duas semanas. Com interesse, tempo e contribuição, parte disso vai sendo resolvida. E aí os contribuidores vão descobrir uma coisa que os projetos de N64 nunca enfrentaram.

> O PhotoCraft hoje é aquela réplica de Ferrari montada em cima de um Fusca: a carroceria tem a forma certa, você tira uma foto e a maioria das pessoas diz "uau, uma Ferrari". Aí você liga e sai o motor de Fusca. Se você se empolgou com a foto, o problema foi seu.

## O alvo se move

Decompilar o Zelda de 1998 é mirar num alvo parado. A Nintendo não vai lançar o Ocarina of Time 2026 com formato de arquivo novo. Copiar um produto vivo é outra conversa, e a gente já viu esse filme.

Nos anos 90 e 2000 o alvo era o Microsoft Office. O StarOffice virou OpenOffice em 2000 e LibreOffice em 2010, e todos eles passaram anos correndo atrás de um formato binário, o .doc, que mudava de versão pra versão e só ganhou especificação pública em 2008, quando o jogo já tinha acabado. A parte comprovada dessa história está nos processos: a Comissão Europeia multou a Microsoft em [497 milhões de euros em 2004](https://ec.europa.eu/commission/presscorner/detail/en/ip_04_382) por recusar informação de interoperabilidade, e em [899 milhões em 2008](http://news.bbc.co.uk/2/hi/business/7266629.stm) por descumprir a ordem. O .docx só virou padrão ISO em 2008, numa [votação tão controversa](https://en.wikipedia.org/wiki/Standardization_of_Office_Open_XML) que países protestaram formalmente.

Levou mais de dez anos. E quando o formato finalmente abriu, o Office já não importava do mesmo jeito. O valor mudou de lugar: hoje são [400 milhões de assentos pagos de Office 365](https://office365itpros.com/2024/01/31/office-365-reaches-400-million/), [3 bilhões de usuários de Google Workspace](https://www.googlecloudpresscorner.com/2025-12-04-Google-Workspace-Study-Reveals-More-Than-90-of-Rising-Leaders-Want-AI-With-Personalization) e uns [41 milhões de assinantes de Creative Cloud](https://prodesigntools.com/number-of-creative-cloud-subscribers.html). Ninguém quer instalar aquilo no desktop, e por isso ninguém tem o binário.

> Fazer engenharia reversa do Google Docs é reescrever o produto do zero olhando só pra interface, porque o código que importa nunca sai do servidor. Depois que o mundo migrou pra SaaS, a maior parte do software proprietário virou jardim murado sem binário. Sem binário, não tem o que desmontar.

Dá pra fazer versões disso, claro. O [Immich](https://immich.app/) substitui o Google Photos pra uma pessoa ou uma família: backup do celular, reconhecimento de rosto, busca semântica, tudo no seu servidor. O que ele não replica é a infraestrutura e o corpus de treino que fazem a busca do Google ser a busca do Google. E a Adobe fez a mesma migração, em pedaços.

## Photoshop é muito mais que camada e crop

Aqui entra a parte que eu conheço por ter pagado. As features que vendem assinatura hoje nem rodam no seu computador.

O Generative Fill e o Generative Expand rodam no Firefly, na nuvem, e consomem [créditos generativos](https://helpx.adobe.com/creative-cloud/apps/generative-ai/generative-credits-faq.html). Vários Neural Filters, segundo a [própria documentação](https://helpx.adobe.com/photoshop/using/neural-filters.html), precisam de internet porque o processamento é no servidor da Adobe. A seleção de objeto por IA tem, desde 2020, uma opção de processar na nuvem pra refinar o resultado. Isso tudo é código que não existe na sua máquina pra ninguém desmontar.

Depois vem o que está no binário, mas levou décadas e parceria pra existir. O Camera Raw carrega [perfis de correção de lente](https://helpx.adobe.com/camera-raw/desktop/dng-and-file-formats/supported-lenses.html) e perfis de cor por câmera pra centenas de modelos, construídos ao longo de vinte anos e atualizados a cada lançamento. Clone nenhum adivinha isso. Ou tem o dado, ou não tem.

E tem a ciência de cor. O exemplo que eu sempre lembro é o GIMP e o CMYK.

O GIMP nasceu em 1995. O primeiro suporte nativo a arquivo CMYK chegou em [2022](https://www.gimp.org/news/2022/08/27/gimp-2-99-12-released/), e só de importação e exportação, com o pixel sempre em RGB. O [GIMP 3.0, de 2025](https://www.cgchannel.com/2025/03/gimp-3-0-is-out/), ainda sem modo de edição em CMYK. Está no [roadmap](https://developer.gimp.org/core/roadmap/) como trabalho em andamento.

Trinta anos de projeto aberto, com gente boa e motivada, e a gráfica ainda pede o Photoshop. Isso é o tamanho do buraco da ciência de cor, e nenhum agente de código inventa ciência de cor: ele reproduz o que está no treino.

Por que demorou tanto, se era a feature mais pedida? Porque o núcleo do GIMP nasceu com RGB de 8 bits por canal embutido em cada camada, modo de mesclagem e filtro. Suportar outro modelo de cor exigiu reescrever o motor de pixel inteiro, a migração pro GEGL, que levou a maior parte de uma década e só ficou pronta no [GIMP 2.10, em 2018](https://www.gimp.org/release-notes/gimp-2.10.html). O CMYK só pôde começar depois disso.

E CMYK é uma família de perfis de dispositivo, com quatro tintas, perfil ICC por impressora, limite de tinta e regra de geração de preto, e editar nele significa que toda a cadeia precisa calcular num modelo subtrativo de quatro canais e ir e voltar pelos perfis sem desviar a cor. Um desenvolvedor sozinho, por melhor programador que seja, sem experiência nessa área específica, vai sofrer pra implementar isso, porque o conhecimento está na gráfica e no laboratório de cor, e quase nada dele está em corpus de treino. No GIMP, quem levou a coisa adiante foram contribuidores que entendem de impressão, e mesmo assim foram anos. Ferramenta nova nenhuma atalha esse tipo de conhecimento.

E tem a camada que nem é técnica: licença comercial. Cor de gráfica é Pantone, e Pantone é uma biblioteca proprietária. Projeto aberto nenhum pode embarcar as paletas; os desenvolvedores do Inkscape [chegaram nessa conclusão em 2005](https://lists.inkscape.org/hyperkitty/list/inkscape-devel@lists.inkscape.org/message/DOXDMUAPHORC4HEXPF37LYBQH6SSQ2M5), e a [Linux.com explicou o risco jurídico](https://www.linux.com/news/pantone-and-free-software/) na mesma época. A própria Adobe sentiu isso em 2022: quando a Pantone mudou o modelo de negócio, as bibliotecas [saíram do Photoshop, do Illustrator e do InDesign](https://petapixel.com/2022/10/28/you-have-to-pay-a-subscription-to-use-pantone-colors-in-photoshop-now), arquivos antigos passaram a abrir com as cores Pantone trocadas por preto, e quem precisa delas paga uma assinatura separada de plugin. Se nem a Adobe, pagando, escapou, imagine um clone que vive de boa vontade.

### Vídeo é pior

No Premiere, no After Effects e no DaVinci Resolve, o problema multiplica. Câmera de cinema não entrega vídeo, entrega dado bruto numa curva logarítmica própria: LogC4 da ARRI, IPP2 da RED. Pra transformar aquilo em imagem, você precisa das transformadas do fabricante, e a RED entrega as dela num [SDK](https://community.acescentral.com/t/red-ipp2-color-workflows/1055) que os editores integram e atualizam a cada versão. O ACES, o padrão neutro da indústria, depende de transformadas de entrada fornecidas por cada fabricante.

A Blackmagic dá o Resolve de graça e ele decodifica ARRIRAW e R3D. Faz isso porque paga o SDK e a parceria por você. Um clone feito por agente, "adivinhando" como a imagem da Alexa deve ficar, produz uma imagem que não bate com o monitor de referência, e no cinema isso significa que não serve. Esse conhecimento não está em corpus de treino nenhum: está em contrato.

## O caso Bun: quanto custa reescrever software grande

Pra ter noção de ordem de grandeza, o melhor dado público que existe é o do Bun. Em maio de 2026, Jarred Sumner reescreveu o runtime inteiro de Zig pra Rust usando agentes, e em julho [publicou os números](https://bun.com/blog/bun-in-rust):

- 535 mil linhas de Zig em 1.448 arquivos viraram um diff de um milhão de linhas de Rust, em 11 dias.
- Até 64 instâncias de Claude em paralelo, 24 horas por dia, cada linha revisada por dois agentes adversariais e um corretor.
- 5,9 bilhões de tokens de entrada não cacheados, 690 milhões de saída, 72 bilhões de leituras de cache: **uns US$ 165 mil** a preço de API.
- 16 mil erros de compilador corrigidos por 64 agentes antes do CI ficar verde em seis plataformas.
- A suíte de testes existente, com mais de um milhão de asserções, passou 100% antes do merge.

Lê de novo o que viabilizou isso:

- o autor original do projeto pilotando
- um código fonte completo e funcional como referência
- uma suíte de testes de um milhão de asserções servindo de oráculo
- orçamento ilimitado, porque o Bun pertence à Anthropic desde dezembro de 2025, e uma versão pré-lançamento do Claude Fable 5

O Sumner estima que três engenheiros com contexto total levariam um ano.

Agora tira cada uma dessas vantagens. O PhotoCraft não tem o fonte do Photoshop pra portar, tem que inventar. Não tem suíte de testes que diga "isso aqui bate com o Photoshop". Não tem o autor do Photoshop.

E o Photoshop é um produto de 36 anos, cujos requisitos de disco a Adobe lista entre [10 e 100 GB](https://helpx.adobe.com/photoshop/desktop/get-started/technical-requirements-installation/adobe-photoshop-on-desktop-technical-requirements.html), contra um runtime de JavaScript. Mesmo sem saber o tamanho do código da Adobe, estamos falando de um alvo maior, sem referência, sem oráculo e sem dono. Ordens de grandeza acima de US$ 165 mil, e ainda assim seria uma aproximação.

## Por que o retrô anda tão rápido

Se é tão difícil, por que sai port de jogo antigo todo dia? Porque o retrô acumula todas as vantagens que o resto não tem.

**O binário está disponível e é minúsculo.** Super Mario Bros. do NES: 40 KB. Super Mario 64: 8 MB. Ocarina of Time e Majora's Mask: 32 MB cada. Um CD inteiro de PS1: 650 MB.

Compare com [Baldur's Gate 3](https://store.steampowered.com/app/1086940/Baldurs_Gate_3/), 150 GB, ou com o [Call of Duty mais recente](https://support.activision.com/black-ops-6/articles/pc-system-requirements-for-black-ops-6), acima de 100 GB. São três ou quatro ordens de grandeza, e o escopo encolhe junto: um jogo de 1996 tem um punhado de sistemas, não um motor de física com rede, loja e anticheat.

**A tecnologia é antiga e documentada.** Vinte e cinco anos de comunidade já mapearam o hardware do N64, do PS1 e do SNES instrução por instrução. O agente não descobre nada; ele acelera um trabalho com mapa pronto. É o mesmo padrão que eu [vi nos meus projetos de retrocomputação](/2026/09/28/llms-sao-boas-em-reproduzir-o-que-existe-e-coisas-novas/): onde tem referência e oráculo, a IA voa; onde não tem, ela gira em força bruta.

**O alvo não se move.** Ninguém vai atualizar o Zelda de 1998.

**E o jurídico está resolvido há trinta anos.** Sega v. Accolade e Sony v. Connectix deram o contorno. Os ports exigem que você forneça a sua ROM.

### Console moderno é um PC

A segunda metade da explosão, os ports de PS4, PS5, Xbox One e Switch, tem outra explicação: esses consoles são PCs ou celulares com outro invólucro. O [PS4](https://www.playstation.com/en-us/ps4/tech-specs/) usa um AMD Jaguar x86-64, o [PS5](https://blog.playstation.com/2020/03/18/unveiling-new-details-of-playstation-5-hardware-technical-specs/) um Zen 2, o [Xbox Series](https://news.xbox.com/en-us/2020/03/16/xbox-series-x-tech/) outro Zen 2, o Switch um [Tegra X1](https://www.techinsights.com/blog/nintendo-switch-teardown) ARM da NVIDIA. O processador do seu PC roda aquele código nativamente. Então ninguém precisa emular a CPU.

O trabalho que sobra é traduzir o sistema operacional e a GPU. O [shadPS4](https://github.com/shadps4-emu/shadPS4) reimplementa as bibliotecas do sistema do PS4 e recompila os shaders: os jogos saem da fábrica com código de máquina da GPU AMD, que o emulador decodifica instrução a instrução e converte pra SPIR-V, o formato do Vulkan.

O [Azimuth](https://almost-there-games.itch.io/azimuth), que faz o Forza Horizon 2 rodar no Windows, traduz chamadas WinRT do Xbox pra Win32 e DirectX 11.X pra DirectX 12 desktop, com o código x86 do jogo rodando direto. O AnyPS5 religa o executável: pega o binário do PS5 e gera um binário nativo de Linux ou Windows, ligado a bibliotecas de sistema reimplementadas. Nos três casos, Proton, DXVK, VKD3D e MoltenVK já tinham resolvido a camada de tradução gráfica anos antes.

A prova inversa são os consoles que não eram PC. O PS3 usa o Cell, um PowerPC com sete coprocessadores ativos (os SPEs), cada um com memória local própria e sem cache, e o RPCS3 está nisso [desde 2011](https://rpcs3.net/about), com a emulação dos SPUs sendo gargalo até hoje. O Xbox 360 é PowerPC também, e por isso o Sonic Unleashed precisou do XenonRecomp traduzir PowerPC pra C++. Engenharia reversa é caso a caso, e a arquitetura decide se o caso é fácil.

### A IA está no meio, e já tem briga

Que os ports de 2026 usam IA, boa parte deles diz na cara. O [decomp do Silent Hill](https://github.com/SlickAmogus/silent-hill-decomp) escreve no README que o desenvolvimento é "fortemente assistido por IA (Claude Opus 4.6, 4.7 e o Fable mais novo), e somos abertos sobre isso. Não é tradução automatizada do jogo". O recomp do Pokémon Stadium [lista o Claude como contribuidor](https://retrododo.com/a-pokemon-stadium-recomp-has-finally-arrived-but-lists-claude-as-a-contributor/).

Os devs dos recomps de Zelda e Banjo, que passaram anos fazendo isso à mão, [entraram em guerra](https://kotaku.com/zelda-and-banjo-recompiled-devs-go-to-war-with-ai-vibe-coded-slopcomps-2000739936) com o que chamam de "slopcomps", ports gerados por agente com qualidade de alpha.

E vale separar manchete de estado real também aqui. O AnyPS5 tem uma versão 0.1 de setembro que, segundo quem testou, roda um jogo indie 2D; a alegação viral de que "o PS5 está 80% portado pra PC" é dos fãs, e nenhum jogo 3D roda. Astro Bot roda, só que em emuladores (KytyPS5, SharpEmu), que fazem o caminho tradicional. O Forza Horizon 2 roda, e o Azimuth é um binário fechado de um estúdio que se declara "AI assisted" sem dizer mais nada.

## "Mas daqui a dois anos o token custa nada"

A resposta padrão pra tudo isso é: hoje é difícil, em dois anos é trivial, porque IA cresce exponencialmente. Os números dizem outra coisa.

O preço da ponta mais cara caiu pouco. O GPT-4 de março de 2023 custava US$ 30 e 60 por milhão de tokens de entrada e saída; o Claude 3 Opus de 2024, 15 e 75; os modelos de ponta de hoje, Fable 5.1 e GPT-6 Astra, [custam](https://claude.com/pricing) [10 e 50](https://developers.openai.com/api/docs/pricing). Em três anos e meio, a fronteira ficou entre 1,2 e 3 vezes mais barata, dependendo de qual ponta você olha.

O que caiu de verdade foi o custo de uma qualidade fixa: a Epoch AI mediu quedas [de 9 a 900 vezes por ano](https://epoch.ai/blog/llm-inference-price-trends) dependendo da tarefa, e numa [revisão de 2026](https://epoch.ai/gradient-updates/how-persistent-is-the-inference-cost-burden) resume em "muito grosseiramente 5 a 10 vezes por ano", com o aviso de que pode desacelerar. Isso é real e é ótimo.

Só que aplica a conta no Bun. US$ 165 mil divididos por 10 dá US$ 16 mil. Por 100, US$ 1.650. Isso é pra portar um runtime com fonte, testes e autor na mão.

Pra um amador tentando clonar o Photoshop sem nada disso, a conta começa ordens de grandeza acima e cai na mesma proporção. Barato não é o mesmo que trivial.

E a premissa do "exponencial" morreu em 2024. O Ilya Sutskever disse no NeurIPS que [o pré-treino como conhecemos vai acabar](https://www.globalbankingandfinance.com/ai-with-reasoning-power-will-be-less-predictable-ilya-sutskever-says/), porque só existe uma internet. A Epoch projeta que o escalonamento dos modelos de raciocínio [converge pra taxa geral da fronteira](https://epoch.ai/gradient-updates/how-far-can-reasoning-models-scale) em cerca de um ano.

Eu já escrevi sobre isso três vezes nas últimas semanas: [os limites](/2026/09/28/llms-sao-boas-em-reproduzir-o-que-existe-e-coisas-novas/) do que o modelo reproduz, [a convergência](/2026/10/12/llms-agentes-competente-o-suficiente/) dos modelos crus com o ganho vindo do harness, e [o benchmark de linguagens](/2026/10/11/existem-linguagens-melhores-pra-programar-com-llms/) em que os modelos de fronteira empataram no teto. A ferramenta que temos é a ferramenta que vamos ter por um bom tempo, com melhoria incremental. Planeje com ela.

Vale lembrar o número que abre o texto dos limites: pelo [Octoverse 2025](https://github.blog/news-insights/octoverse/octoverse-a-new-developer-joins-github-every-second-as-ai-leads-typescript-to-1/), relatório oficial do GitHub, 81,5% das contribuições na plataforma aconteceram em repositórios privados. É o código que importa de verdade, o que paga salário, e nenhum LLM viu uma linha dele. O modelo reproduz o que estava no treino, e esse código nunca esteve lá.

Agora estenda isso pra todo produto SaaS e pra cada componente que ele usa. O código da Adobe que realmente vale, o motor de cor, os perfis, os filtros na nuvem, não está disponível em lugar nenhum, nem como binário. Quem quiser reproduzir vai ter que refazer a pesquisa e o desenvolvimento, caro e demorado, pelos mesmos anos que a Adobe levou. E no fim ainda esbarra na propriedade intelectual licenciada de terceiros, Pantone, SDK de câmera, perfil de fabricante, que você nunca vai conseguir ter.

## Respondendo a lista do começo

**O PhotoCraft existe?** Existe, é uma alpha de duas semanas com mais de 800 issues abertas, gerenciamento de cor rudimentar, travando acima de 8K e abrindo PSD errado. Parece Photoshop no print. Pode melhorar muito, e vai descobrir que o alvo se move e que as partes caras do Photoshop estão na nuvem ou em contrato com fabricante.

**O REA existe?** Existe, é bom, e é uma caixa de ferramentas pra quem já sabe usar Ghidra, exige o binário na mão, as ferramentas instaladas e centenas de milhares de tokens por análise. O próprio projeto evita dizer que ele clona programa.

**Recomp e decomp aceleraram?** Sim, de verdade, e a IA tem parte nisso. Aceleraram onde o binário existe, é pequeno, está documentado há 25 anos e não se move. Ou onde o console é um PC disfarçado e o trabalho é tradução de API, resolvida pelo Wine e pelo Vulkan anos antes.

**A Adobe morreu?** A Adobe tem uns 40 milhões de assinantes, pela estimativa mais citada, as features que vendem assinatura rodam no servidor dela, e trinta anos de GIMP ainda deixam a gráfica pedindo Photoshop. Eu queria que fosse diferente. Os dados dizem que o que vai acontecer é o que sempre aconteceu com clone de produto vivo: anos correndo atrás, e quando alcança, o valor já mudou de lugar.

**Programador morreu?** Reescrever o Bun precisou do autor do Bun. Os decomps que funcionam têm gente que conhece o hardware pilotando o agente, e os que não têm viraram "slopcomp" com nome e tudo. A engenharia reversa ficou mais barata e mais acessível, como ficou com o Ghidra em 2019, e continua sendo trabalho de engenheiro. Sem nós, a ferramenta devolve print bonito.

Software proprietário com binário na mão vai sofrer pressão, e deve. A maior parte do software que você usa não tem binário nenhum, e o que tem já depende de serviço na nuvem que não desmonta. Engenharia de software com IA tem um caminho ótimo pela frente. Manchete de "acabou" rende clique e não compila.
