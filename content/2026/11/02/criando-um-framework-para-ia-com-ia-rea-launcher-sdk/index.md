---
title: "Criando um framework para IA com IA: REA Launcher SDK"
slug: "criando-um-framework-para-ia-com-ia-rea-launcher-sdk"
date: '2026-11-02T21:00:00-03:00'
draft: false
translationKey: criando-um-framework-para-ia-com-ia-rea-launcher-sdk
description: "Depois de fazer sete launchers pra modernizar jogos de corrida antigos com agentes de IA, extraí o que eles tinham em comum num framework, o rea-launcher-sdk. Conto por que framework se extrai de vários projetos e nunca se desenha antes, como a migração dos launchers achou bugs no SDK e neles mesmos, as técnicas embutidas (teste antes da correção, snapshots, testes headless, CI, agentes que rodam o jogo e depuram crash dumps), os números de teste e cobertura de cada projeto, os dois launchers novos feitos direto do SDK, e o passo a passo pra qualquer um criar o launcher do seu jogo favorito com o agente que preferir."
tags:
- agentes-de-codigo
- engenharia-de-software
- arquitetura-de-software
- games
---

No [primeiro artigo da série](/2026/10/29/brincando-de-pc-ports-com-colin-mcrae-1/) eu mostrei o [launcher do Colin McRae Rally](https://github.com/akitaonrails/rea-colin-mcrae) de 1998: uma camada fina em volta do executável original que faz o jogo rodar em 4K, widescreen e 60 fps num PC moderno, com o [REA](/2026/10/13/engenharia-reversa-com-ia-a-adobe-morreu/) fazendo a engenharia reversa. No [segundo](/2026/11/02/consertei-varios-jogos-de-corrida-antigos-usando-ia/), hoje de manhã, eu repeti a receita em mais meia dúzia de jogos de corrida: [Colin McRae 3](https://github.com/akitaonrails/rea-colin-mcrae-3), [04](https://github.com/akitaonrails/rea-colin-mcrae-4) e [DiRT](https://github.com/akitaonrails/rea-dirt), [OutRun 2006](https://github.com/akitaonrails/rea-outrun-2006), [Sega Rally Revo](https://github.com/akitaonrails/rea-sega-rally-revo) e a [trilogia Screamer](https://github.com/akitaonrails/rea-screamer-trilogy).

Depois de fazer esses launchers pra trazer de volta os meus jogos favoritos, eu quis que mais gente pudesse fazer o mesmo com os jogos *deles*. Pra isso, juntei tudo num framework: o [rea-launcher-sdk](https://github.com/akitaonrails/rea-launcher-sdk).

Este artigo conta como ele nasceu, e por que eu fiz na ordem que fiz.

## Primeiro os apps, depois o framework

Muito amador pensa do jeito errado: primeiro você desenha um framework novo e bonito, e depois constrói aplicações em cima dele. Esse é o caminho completamente errado pra fazer biblioteca ou framework.

O caminho certo é o contrário:

1. implementar **vários projetos do mesmo tipo**, cada um resolvendo o seu problema de verdade;
2. avaliar todos eles juntos, comparando o que cada um fez;
3. **normalizar** com refatoração, até todos terem a mesma fundação comum;
4. só então **extrair** as partes comuns pra um framework de verdade.

O Rails nasceu assim, extraído do Basecamp. Framework desenhado antes do primeiro app sempre resolve o problema que o autor *imaginou*, e erra o que aparece na prática.

> Você só sabe o que é comum depois de ver a mesma coisa feita três, quatro, cinco vezes. Antes disso, é chute.

Foi o que eu fiz aqui. A diferença é que dessa vez cada passo foi feito com LLMs.

## Os launchers antes do SDK

Todos os launchers foram feitos com agentes, e eu usei vários: Claude, Codex, Antigravity e outros. O que mais tomou meu tempo foi o primeiro, o do Colin McRae 1. Ele começou em 20 de outubro e hoje tem quase 800 commits, porque foi nele que eu descobri o que um launcher desses precisa ter, junto com o recomp e o pacote de texturas HD.

Pros outros, bastava dizer algo como *"copie tudo do rea-colin-mcrae e adapte pro jogo X"*. Isso acelerou muito os seguintes. O problema é que cada agente copiou e adaptou do seu jeito, e no fim cada launcher estava pra um lado.

![O launcher do Colin McRae Rally, o primeiro da família](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/jogos-corrida-ia/cmr1-launcher.png)

A auditoria que o agente do SDK fez depois mostrou o tamanho da bagunça. Cada bug encontrado existia em uma ou mais cópias, e já estava corrigido em outra:

- o launcher do Colin McRae 3 tinha uma conversão do executável que **nunca rodava**, porque o caminho do programa era passado duas vezes na linha de comando;
- o do Screamer criava a cópia privada com links simbólicos pra pasta original, então o jogo podia escrever na instalação do usuário;
- o do Sega Rally escrevia `"Disable Hidraw"`, com espaço, numa chave que o Wine lê como `DisableHidraw`;
- o do OutRun copiava saves sem checar qual era o mais novo, e o comando de parar matava o shell auxiliar em vez do jogo;
- três launchers montavam um script interpolando o caminho do launcher sem escapar as aspas.

Umas 2 mil linhas de código se repetiam em cada launcher, cada cópia com os seus próprios bugs.

## Extraindo o SDK

Quando eu achei que tinha material suficiente, criei o rea-launcher-sdk e pedi pro Claude fazer exatamente o que eu prego: estudar cinco dos sete launchers que eu tinha até ali (o Colin McRae 1 e o DiRT entraram depois), normalizar, extrair o que era comum e montar um framework de verdade, com as minhas técnicas de engenharia de software embutidas em forma de skills.

O primeiro commit, às 10h50 de hoje, diz *"SDK inicial extraído dos cinco launchers rea"*. Cada peça é a melhor versão entre as cinco cópias, e um documento de auditoria registra de qual launcher veio cada uma. A cópia privada veio de um, a instalação de DLLs de outro, e o hook de fechar janela, que entrou na 0.3.0, veio do Colin McRae 04.

O que ficou no SDK:

- **o núcleo portátil** (`rea-launcher`): cópia privada do jogo, espelho de saves, identificação do executável por SHA-256, patches binários declarativos, a tabela de opções, edição de INI, downloads com hash fixo;
- **a camada Windows** (`rea-launcher-win32`): registro, processos, instância única, mensagens de erro, detecção de GPU e de Wine;
- **a interface** (`rea-launcher-ui`): a janela de configurações em egui, com tema, checagem de contraste e testes da interface sem tela;
- **o hook de fechar** (`rea-launcher-close-hook`): uma DLL que transforma o Alt+F4 ou o botão de fechar no caminho de saída do jogo, configurável sem recompilar;
- **o lado Linux**: uma biblioteca de shell pro script de jogar com gamescope e Wine, e o empacotamento em AppImage;
- **a CI**: workflows reutilizáveis de build, testes, checagem de importações e release, e um workflow semanal que abre um pull request quando sai versão nova do SDK.

O que **não** foi extraído é o conhecimento de cada jogo: qual byte patchear, qual chave de registro escrever, qual community fix usar. Isso continua em cada launcher, e o SDK recebe como dado.

### De 0.1 a 0.3 em umas quatro horas

A primeira versão saiu às 11h07, depois de uma revisão completa do próprio SDK. A 0.3.3 saiu às 15h12. Entre uma e outra, o ciclo foi sempre o mesmo:

1. migrar os launchers pra versão nova do SDK;
2. a migração expõe um bug ou uma lacuna no SDK;
3. o SDK corrige e solta outra versão;
4. os launchers sobem de versão de novo.

Alguns exemplos do que esse ciclo pegou:

- **Flags no formato `--chave=valor`.** A tabela de opções nova parou de aceitar esse formato, que os scripts dos launchers usavam. A 0.3.2 trouxe de volta, com teste.
- **Erros invisíveis no Wine.** Os scripts de Linux, o AppImage e o Proton mandam a saída pra um log, então o SDK achava que tinha terminal e não mostrava o erro pro jogador. A 0.3.2 criou um relatório que decide quem precisa ver a mensagem.
- **DLL reescrita a cada partida.** O Sega Rally reescrevia uns 70 MB de DLLs em toda execução. O SDK passou a pular arquivos idênticos.
- **O Wine ignora `WINEDLLOVERRIDES`.** O teste no jogo real do Sega Rally mostrou que o Wine carregava a DLL embutida dele no lugar da DLL da Microsoft que estava na cópia privada. A 0.3.3 passou a escrever os overrides no registro do Wine, por programa, e cinco launchers adotaram.

E a migração também achou bugs específicos de cada launcher, que só apareceram quando todos foram forçados pro mesmo padrão:

- o linker do GNU binutils 2.47 deixava importações do kernel32 fora da tabela; no Screamer eram 53, e o launcher crashava antes do `main`. Virou regra do SDK linkar com o lld e checar as importações na CI;
- no Colin McRae 3, desmarcar uma opção de imagem apagava a escolha que o jogador tinha feito no menu do jogo;
- no Colin McRae 04, abrir o launcher de novo encontrava a janela do próprio jogo, ou até uma pasta do Explorer com o mesmo nome, e saía em silêncio;
- no Sega Rally, o menu em polonês aparecia em inglês, e os saves vazios que o launcher criava faziam o jogo acusar dados corrompidos.

Teve até bug gerado pelo próprio processo. O snapshot de teste do `--help` incluía o número da versão, então o commit de release mudava a versão e quebrava o build da tag. As releases 0.2.0 do Colin McRae 3, 0.3.0 do 04 e 0.2.0 do OutRun foram marcadas e nunca publicadas, e saíram corrigidas minutos depois.

No fim, os sete launchers estavam no SDK, todos verdes, com releases novas. Além de compartilharem a mesma camada, ficaram mais corretos do que eram antes.

## As técnicas embutidas

O SDK tem um documento de padrões com umas 540 linhas, e a maioria das regras veio de bug real que apareceu nos launchers. As principais:

### Teste antes da correção

Toda correção de bug começa com um teste que falha no código antigo. Depois o agente reverte a correção temporariamente pra confirmar que o teste falha mesmo sem ela, porque vários "testes de regressão" passavam dos dois jeitos.

Outras regras de teste:

- **testar o comportamento**: o bug do xdelta no Colin McRae 3 sobreviveu porque o teste unitário conferia a lista de argumentos errada. Onde existe ferramenta real, testa contra ela;
- **testar a fiação inteira**: opção → `launcher.cfg` → arquivo do jogo, registro e ambiente, de ponta a ponta;
- **testes como história do jogador**: "o jogador restaura um backup antigo de save", "a sessão é morta antes de copiar os saves de volta", "abre o launcher de novo com o jogo rodando";
- **entradas hostis**: caminhos com espaço, apóstrofo e acento (`José/Jogos d'Ação`), arquivo em code page do Windows, CRLF, BOM, arquivo truncado;
- **código de Windows roda com semântica de Windows**: os testes do alvo Windows rodam dentro do Wine, sem tela. Quatro bugs do SDK só apareceram assim.

### Snapshots dourados

Cada launcher guarda snapshots de tudo o que produz: o `--help`, o `launcher.cfg` gerado, e pra cada perfil visual os arquivos de configuração do jogo, os valores de registro, as variáveis de ambiente e os patches que ele aplicaria. Se uma atualização do SDK muda qualquer byte disso, o teste quebra, e a mudança é revisada como código.

### Sem tela por padrão

Testes, sondas e até o jogo real rodam **headless**: o gamescope sem saída de vídeo, um sink de áudio nulo do PipeWire e um prefixo Wine descartável. A evidência vem de log, código de saída, tabela de processos, arquivos escritos e screenshots capturados sem monitor.

Uma janela só abre quando precisa de um humano, como julgar a aparência da interface ou testar um controle. E o agente avisa antes: o que vai abrir, por quê e o que olhar.

### CI que pega o que o humano esquece

A CI de cada launcher roda formatação, lint, os testes do alvo Windows dentro do Wine, a checagem de importações, auditoria de dependências e o empacotamento. A release só sai com a CI verde, gera `SHA256SUMS` e atestado de proveniência, e as notas vêm direto do CHANGELOG.

## Código de IA não precisa ser slop

Tem muita gente que olha código gerado por IA e assume que é "AI slop": funciona no exemplo, quebra no resto, e ninguém sabe por quê. Isso acontece quando a pessoa pede código e aceita o que vier.

Com as técnicas certas, acontece o contrário. Eu diria que o código que eu gero com IA hoje é muito superior ao do desenvolvedor humano médio, que ainda briga contra escrever teste direito por preguiça.

Eu medi. Rodei a suíte de testes e a cobertura de linhas de cada projeto, no Linux:

| Projeto | Testes | Cobertura de linhas | Snapshots |
| --- | ---: | ---: | ---: |
| rea-launcher-sdk | 310 | 95% | |
| Colin McRae Rally | 171 | 89% | 8 |
| Colin McRae Rally 3 | 97 | 96% | 7 |
| Colin McRae Rally 04 | 106 | 98% | 8 |
| Colin McRae: DiRT | 74 | 97% | 8 |
| OutRun 2006 | 94 | 92% | 11 |
| Sega Rally Revo | 126 | 96% | 8 |
| Trilogia Screamer | 89 | 71% | 10 |
| [Colin McRae Rally 2005](https://github.com/akitaonrails/rea-colin-mcrae-2005) | 71 | 96% | 10 |
| [DiRT Rally](https://github.com/akitaonrails/rea-dirt-rally) | 85 | 85% | 13 |

São mais de 1.200 testes, todos passando, e nove dos dez projetos com 85% ou mais de cobertura. Pra cada duas linhas de código de produção, tem mais ou menos uma de teste.

A cobertura é só do que compila no Linux. O código exclusivo de Windows, como a DLL de hooks do Colin McRae 1, fica de fora da conta, e é testado na CI rodando os testes do alvo Windows dentro do Wine. O Screamer é o mais baixo: a configuração, a cópia privada e os hooks dentro do emulador ficam abaixo de 75%.

Os números sozinhos não contam a história. O que conta é o tipo de bug que esses testes pegaram.

### O teste que passava errado

No Colin McRae 3, a conversão do executável pra versão sem DRM **nunca acontecia**, em silêncio. O launcher montava os argumentos do xdelta repetindo o caminho do programa, e o xdelta recebia `xdelta.exe xdelta.exe -f -d -s …`.

O teste unitário passava, porque conferia exatamente essa lista errada. A auditoria do SDK rodou o xdelta3 de verdade e tomou "too many filenames". A correção veio com um teste novo que gera um patch minúsculo com o xdelta3 real, aplica com os argumentos do launcher e compara os bytes.

Daí saiu uma das regras do SDK: testar o comportamento, com a ferramenta real sempre que ela existir.

### A correção "segura" que perdia saves

No Colin McRae 3, depois de um crash, o launcher restaurava o save antigo por cima do novo. A correção foi "o mais novo ganha", e a auditoria achou tão boa que levou pro OutRun e pro Screamer na mesma manhã.

Só que "o mais novo ganha" joga fora o backup antigo que o jogador restaurou de propósito, e os saves trazidos de outro PC com data velha. Em 20 minutos, os três launchers trocaram a regra por um registro do estado da última sincronização. Os testes têm nome de história: `a_restored_older_backup_wins`, `a_session_killed_before_saving_is_recovered`.

Um revisor independente pegou o problema, e foi por causa dele que o SDK passou a exigir testes escritos como histórias do jogador.

### O checklist que marcou FAILED

No Sega Rally, a verificação no jogo real tinha um item: "o `WINEDLLOVERRIDES` chega no jogo". Ele ficou marcado como **FAILED**. O launcher registrava os overrides no log, mas com `WINEDEBUG=+loaddll` dava pra ver o jogo carregando a DLL embutida do Wine.

O `WINEDEBUG=+module` mostrou duas causas. O Wine troca pela versão dele qualquer DLL que se identifique como da Microsoft no recurso de versão, mesmo na pasta do programa, e ignora o `WINEDLLOVERRIDES` colocado só no ambiente do processo filho. A correção foi pro SDK, com um teste que prova o bug (`env_block_overrides_do_not_reach_wine`), e cinco launchers adotaram. Sem a regra de verificar no jogo real, ninguém teria notado: o log dizia que estava tudo certo.

### Duas correções erradas antes da certa

No Screamer, chegar na tela de título não provava nada. Uma execução headless trocando a prévia das pistas reproduziu o crash real: `mipmap cannot span 2 Mbyte boundary`.

A primeira correção tratou um caminho que nunca acontecia. A segunda causou o mesmo erro sozinha e foi revertida. A terceira, depois de ler a desmontagem, achou um `jle` com sinal que deixava passar uma textura terminando exatamente no limite, mais dois caminhos que pulavam a checagem. A correção final troca **um byte** (`jle` vira `jl`) e anula os dois desvios, com um teste que confere os três pontos.

> Errar de primeira é normal, pra humano e pra IA. O que muda é que o agente só faz commit quando o jogo confirma, e o teste garante que o erro não volta.

## Agentes que jogam o jogo

O que mais acelerou tudo isso é que os agentes têm acesso pra **rodar o jogo de verdade**. Eles aplicam o patch, abrem o jogo num gamescope headless, conferem o resultado no log e na captura de tela, e só fazem commit quando tudo está confirmado funcionando.

Isso economiza horas, às vezes dias, de teste manual. Eu não preciso abrir o jogo a cada tentativa de patch, só nos pontos em que o meu olho ou a minha mão no controle fazem diferença.

E quando o jogo crasha, fica um dump. O agente abre no `gdb` ou no `winedbg`, acha a instrução que falhou e chega na causa com uma precisão que eu raramente tinha quando fazia isso na mão, anos atrás. Três exemplos:

- **OutRun 2006**: o launcher crashava logo depois de copiar os saves. O `winedbg` com símbolos colocou a falha numa chamada a `GetModuleHandleW` cujo slot na tabela de importação não pertencia a nenhum descritor, então o loader nunca preencheu. A causa era o linker do binutils 2.47 do meu toolchain, e a correção foi trocar pro lld.
- **Colin McRae Rally 2005**: o jogo crashava na abertura no Wine, num endereço dentro da rotina que mede a largura do texto. Ela lia o cabeçalho da fonte antes de checar se a fonte tinha carregado, e a fonte nunca carregava porque o jogo monta os caminhos a partir de chaves de registro que só o instalador escreve. Existia um [bug no Wine](https://bugs.winehq.org/show_bug.cgi?id=38198) com o mesmo crash, que sumiu reinstalando o jogo e acabou fechado sem explicação.
- **DiRT Rally**: o port de Linux de 2017 crashava logo depois de iniciar o SDL em processadores novos. O jogo mapeia memória só com permissão de execução e depois *lê* dela. Em CPUs com Memory Protection Keys (Ryzen com Zen 3 ou mais novo, Intel a partir da 11ª geração), o kernel torna essa memória realmente só de execução, e a leitura falha. O problema já era conhecido na comunidade, e a correção do launcher é uma bibliotequinha própria em Rust que intercepta o `mmap` e o `mprotect` e adiciona permissão de leitura, sem mexer no jogo.

## Testando o SDK com dois jogos novos

Com tudo verde, chegou a hora de testar o SDK de verdade: dois launchers novos, do zero, o do **Colin McRae Rally 2005** e o do **DiRT Rally**. Dessa vez eu só precisei dizer *"use o rea-launcher-sdk e crie um launcher novo pro jogo X"*.

O agente seguiu o playbook: pesquisa primeiro, depois o scaffold gerado pelo script `new-launcher` do SDK (66 arquivos e quase 11 mil linhas de partida), depois a implementação em passos, a verificação no jogo real e a release.

Claro que cada jogo teve as suas peculiaridades, e precisou de teste manual, prompt extra e intuição minha.

### Colin McRae Rally 2005

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/colin-mcrae-rally-2005/showcase-h264.mp4" poster="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/colin-mcrae-rally-2005/showcase-poster.jpg" >}}

- **o crash da abertura**, explicado acima, resolvido escrevendo as chaves de registro a cada início;
- **o instalador da GOG trava no Wine**, então o launcher desempacota os arquivos do instalador com o innoextract e nunca roda o instalador;
- **com o renderizador do Wine, uma etapa rodava a 20 fps**; com o DXVK, passou de mil;
- **um monitor principal em retrato** fazia o jogo parar com "Adapter has no modes!", e a chave de desktop virtual por programa do Wine é ignorada no Wine 11. A solução foi abrir o jogo num desktop virtual do tamanho do monitor em paisagem;
- **num prefixo Wine novo, a janela do launcher não abria**, porque o Wine só lê a configuração de EGL quando o processo começa. O launcher agora troca pra GLX e reinicia a si mesmo.

Os dois últimos só apareceram quando eu joguei no meu desktop, com o meu monitor em retrato e o meu Hyprland. Nenhum teste headless pegaria isso.

![Colin McRae Rally 2005 numa etapa na Austrália, em 1920x1080 com a visão widescreen](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/rea-launcher-sdk/cmr2005-gameplay.jpg)

### DiRT Rally

{{< html5video src="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/dirt-rally-launcher/showcase-h264.mp4" poster="https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/dirt-rally-launcher/showcase-poster.jpg" >}}

- **o crash de processador novo**, explicado acima;
- **as bibliotecas antigas** que o Linux de hoje não tem mais (OpenSSL 1.0, libidn11, librtmp, OpenLDAP 2.4, GConf) vêm de pacotes fixos do Steam Runtime, e só o jogo enxerga, porque vazar elas pro gamescope derruba o gamescope;
- **a janela de pré-jogo da Feral**: as flags óbvias de preferência não funcionaram. O agente decompilou a decisão com o REA e achou as duas chaves certas. Pular a janela sem escrever a resolução derrubava o jogo, então o launcher escreve as duas coisas;
- **os controles levaram três tentativas.** O meu 8BitDo Ultimate 2 aparecia como joystick genérico. A primeira correção, via variável do SDL, fez o controle *sumir*. A causa real era uma lista própria de controles da Feral, dentro do jogo, e o launcher agora adiciona os controles de layout padrão nela.

O DiRT Rally também expôs a maior premissa escondida do SDK: ele foi feito pra executável de Windows rodando no Wine. O DiRT Rally é um binário nativo de Linux, então faltava janela de erro nativa, trava de instância única no Unix, progresso na cópia de 40 GB e leitura de controle no Linux pra janela do launcher. O agente escreveu tudo isso no próprio launcher primeiro, e depois isso subiu pro SDK.

![Primeiro Play do DiRT Rally: a cópia privada sendo feita, 2,3 de 43,1 GB](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/rea-launcher-sdk/dirt-rally-launcher-copy.jpg)

### Os números

Comparando os commits e as horas de sessão (somando os intervalos entre commits) até cada launcher chegar no padrão do SDK:

| Launcher | Commits | Horas em sessões de commit |
| --- | ---: | ---: |
| Colin McRae Rally (o primeiro) | 789 | ~110 h |
| Trilogia Screamer | 87 | ~17,5 h |
| Colin McRae Rally 3 | 89 | ~11,5 h |
| Colin McRae Rally 04 | 70 | ~10 h |
| OutRun 2006 | 88 | ~9 h |
| Sega Rally Revo | 77 | ~8 h |
| Colin McRae: DiRT | 27 | ~3,5 h |
| **Colin McRae Rally 2005** | **15** | **~4 h** |
| **DiRT Rally** | **18** | **~4 h** |

Os números dos antigos incluem a primeira versão, as correções e a migração pro SDK, e a migração sozinha foi uns 35 a 50 commits de cada um. O DiRT tem pouco commit porque quase todo o trabalho dele foi feito antes do primeiro commit.

O Colin McRae 2005 já nasceu com tudo: testes, snapshots, CI, README no padrão, formulários de issue, releases com hash. O DiRT Rally saiu sem os snapshots dourados, ganhou logo depois da release, e essa falha virou regra no SDK (mais abaixo). Os números de teste e cobertura dele na tabela anterior são de depois da release.

> A maioria dos launchers antigos precisou de 70 a 90 commits e de 8 a 18 horas pra chegar no padrão. Os dois novos chegaram lá na primeira release, ou quase, com menos de 20 commits e umas 4 horas cada, feitos em paralelo na mesma tarde e noite.

Menos commit significa menos ida e volta. O agente acertou mais de primeira porque o SDK já tinha resolvido o que os outros launchers precisaram descobrir apanhando.

## O SDK aprende com os launchers novos

Depois que os dois saíram, eu voltei pro agente do SDK e pedi pra ele avaliar os dois: ajustar o que precisasse neles, e aprender o que desse pra trazer pro framework. É a mesma regra de antes: só vira framework o que já apareceu em projeto real.

O resultado foi a [versão 0.4.0](https://github.com/akitaonrails/rea-launcher-sdk/releases/tag/v0.4.0). O que ela trouxe:

- do DiRT Rally: trava de instância única pra launcher nativo de Linux, janela de erro nativa, cópia com progresso, leitura de controle no Linux;
- do Colin McRae 2005: a troca pra GLX com reinício num prefixo novo, paletas claras com contraste certo, e um modo novo no hook de fechar pra jogos que tomam o teclado em modo exclusivo do DirectInput, onde o Alt+F4 nunca chega;
- de vários: o tamanho do gamescope por perfil visual, que o Colin McRae 1, o 2005, o 04 e o OutRun tinham reimplementado cada um no seu hook;
- do bug das releases: um helper de snapshot que nunca grava o número da versão.

E o que veio dos dois launchers novos já vai beneficiar os antigos também. O OutRun, o Colin McRae 1 e o 04, por exemplo, vão poder apagar o código próprio que dimensionava o gamescope e usar o do SDK, e vários ganham a janela de erro certa, a segunda execução tratada do mesmo jeito e a remoção segura dos overrides de DLL. É o ciclo fechando: o projeto novo ensina o framework, e o framework melhora os projetos velhos.

E veio uma ideia nova: um **verificador de conformidade**, o `launcher-check`, que roda na CI de cada launcher e falha o build quando um launcher repete um erro conhecido. São 33 regras, e cada uma explica por que existe e como corrigir. Um erro que apareceu em um launcher e que dá pra detectar olhando os arquivos vira regra. Por exemplo, "o DiRT Rally saiu sem snapshots" virou uma.

O playbook de launcher novo também ganhou seções de padrões: port nativo de Linux, os ports antigos da Feral, instalador da GOG com innoextract, monitor em retrato com desktop virtual.

Nenhum software está "pronto". Mas eu acredito que o SDK já é bom o suficiente: foi testado em batalha com nove launchers e onze jogos de verdade, e qualquer pessoa pode começar a usar.

## Feito pra ser usado por IA

O SDK foi desenhado **AI-first**. O README diz isso logo no começo: ele foi escrito pra ser dirigido por um agente de código. O agente faz a pesquisa, a engenharia reversa e o código; você entra com o jogo e com as decisões.

E não precisa ser o Claude. A estrutura funciona com o agente que você preferir, seja Claude Code, Codex, opencode ou Cursor:

- **`AGENTS.md`** é a porta de entrada pra qualquer agente: uma tabela de "tarefa → playbook" e as regras fáceis de esquecer. O `CLAUDE.md` só aponta pra ele;
- **os playbooks** são Markdown puro: launcher novo, patch binário, componentes da comunidade, CI e releases, mudanças no SDK, contribuir de volta, e o modelo de README;
- **`docs/STANDARDS.md`** são as regras obrigatórias, e cada launcher recebe uma cópia delas;
- **as skills do Claude** (`rea-new-launcher`, `rea-sdk-change`, `rea-contribute-back`) são só ponteiros finos pros playbooks, pra quem usa Claude Code.

Algumas regras que o agente segue sem você precisar lembrar:

- nunca distribuir arquivos do jogo, e nunca modificar a pasta do jogo;
- identificar cada executável pelo SHA-256 e **nunca** patchear uma versão desconhecida no chute;
- pesquisar os fixes da comunidade antes de escrever código;
- registrar as decisões do dono do projeto, com data;
- não publicar nada, nem push, nem release, nem post em fórum, sem aprovação.

## Como fazer o launcher do seu jogo favorito

Se você tem um jogo antigo que não roda mais direito, o caminho é este.

**1. Prepare as ferramentas.** Clone o SDK e instale o REA no seu agente:

```bash
git clone https://github.com/akitaonrails/rea-launcher-sdk ~/Projects/rea-launcher-sdk
npx rea-agents setup                                  # REA, o MCP de engenharia reversa
~/Projects/rea-launcher-sdk/scripts/install-skills    # só pra Claude Code
```

Você também precisa do toolchain: Rust com os alvos de Windows, MinGW, lld, Wine, gamescope e mais algumas ferramentas que o README lista. O jeito mais fácil é usar um container que já tenha tudo, como o meu [distrobox-gaming](https://github.com/akitaonrails/distrobox-gaming).

**2. Tenha o jogo instalado.** A sua própria cópia, numa pasta que o agente possa ler. Ela nunca é modificada, nem copiada pro repositório.

**3. Peça pro agente.** Abra o agente numa pasta vazia e cole um prompt como este, adaptado do README:

> Crie um novo launcher rea para *Need for Speed: Porsche Unleashed* (PC, 2000) usando o SDK em `~/Projects/rea-launcher-sdk`. Leia o `AGENTS.md`, o `docs/STANDARDS.md` e o `docs/playbooks/new-launcher.md` e siga o playbook fase por fase. O jogo está instalado em `/mnt/games/NFSPU` (só leitura, nunca copie pro repo). Use as ferramentas MCP do REA pra analisar. Pesquise os fixes da comunidade primeiro e me mostre o que encontrou antes de escrever código. Mantenha os testes headless. Não faça push nem publique nada sem me perguntar.

Com o Claude Code e as skills instaladas, *"faça um launcher rea pro jogo X em /caminho"* já basta.

![Aba de imagem do launcher do Colin McRae Rally 2005, gerada a partir da tabela de opções](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/rea-launcher-sdk/cmr2005-launcher-picture.jpg)

**4. Revise nos pontos de checagem.** O playbook para em quatro momentos pra você decidir:

1. o que a pesquisa encontrou;
2. a lista de problemas que o launcher vai resolver;
3. as opções que a janela vai oferecer;
4. o que foi verificado no jogo real, registrado no `docs/RUNTIME_NOTES.md`.

Entre eles, o agente segue as fases: conhecer o jogo com o REA, gerar o scaffold, construir em ordem (edição do jogo, cópia privada, componentes, configuração, patches, perfis visuais, janela, linha de comando, script de Linux, empacotamento), e verificar com os testes e com o jogo real rodando headless.

![Launcher do DiRT Rally ainda sem a pasta do jogo: o Play espera](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/02/rea-launcher-sdk/dirt-rally-launcher-setup.jpg)

**5. Jogue.** Essa parte é sua. É jogando no seu PC, com o seu monitor e o seu controle, que aparecem os bugs que nenhum teste pega.

**6. Publique.** Quando você aprovar, o agente faz o push, e a release sai pela CI com o AppImage pra Linux, o zip pra Windows e os hashes. O playbook ainda tem uma fase de contribuir de volta: rascunhos pro PCGamingWiki e pros projetos da comunidade, que só são postados com a sua aprovação.

## Ferramenta boa nasce de uso real

O rea-launcher-sdk saiu do zero pra versão 0.3.3 em umas quatro horas e meia, mas isso só foi possível porque antes existiam sete launchers funcionando, com quase mil commits somados. O framework é a parte fácil quando você já tem os projetos.

> Não comece pelo framework. Faça o mesmo tipo de projeto várias vezes, deixe as cópias divergirem, e só depois extraia. Com agentes, esse ciclo que levaria meses cabe em poucos dias.

Se o seu jogo favorito está preso no passado, o SDK está aberto. Aponte o seu agente pra ele, aponte pra pasta do jogo, e solte o seu próprio launcher.
