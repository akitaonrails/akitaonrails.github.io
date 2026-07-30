---
title: "Removendo DRM de ebooks de Kindle em 2026"
slug: "removendo-drm-de-ebooks-de-kindle-em-2026"
date: '2026-07-30T18:00:00-03:00'
draft: false
translationKey: removendo-drm-de-ebooks-de-kindle-em-2026
description: "Usei Calibre, DeDRM 10.0.28, KFX Input e o Kindle da Microsoft Store numa VM do Omarchy para arquivar 106 livros e validar a conversão pra EPUB sob meu controle."
tags:
- armazenamento-e-backup
- linux
- open-source
---

Sou cliente da Amazon há tempo demais. Compro livros no Kindle há muitos anos, tenho vários aparelhos e continuo achando péssima a maneira como a empresa trata conteúdo digital.

Você paga pelo livro, mas só consegue ler onde a Amazon deixa. Não existe um aplicativo nativo decente pra Linux. Mudar pra outro leitor vira um exercício de arqueologia. Comprei um Xteink X4 novo e, claro, minha biblioteca não podia simplesmente ir junto. O arquivo estava "na minha conta", mas não estava sob meu controle.

Durante anos, eu contornei isso pelo caminho oficial. Entrava no site da Amazon, usava **Download & Transfer via USB**, baixava o `.azw` dos livros que comprei e importava tudo no [calibre](https://calibre-ebook.com/about). Com o plugin DeDRM configurado pro serial do meu Kindle, convertia pra EPUB e pronto.

Em **26 de fevereiro de 2025**, a Amazon [desativou essa opção](https://www.vice.com/en/article/amazon-is-killing-your-ability-to-download-kindle-books-next-week/). Sem anúncio decente, sem substituto que entregasse o arquivo e sem qualquer preocupação com quem queria manter um backup local. Desde então, meus livros mais novos ficaram presos no ecossistema deles. Voltei a tentar no ano passado, atualizei plugin, copiei arquivos do meu Kindle Paperwhite, coloquei o serial correto e nada.

Pra ser justo, em **20 de janeiro de 2026** a Amazon passou a permitir que compradores verificados baixem EPUB ou PDF quando o publisher [confirma o livro como DRM-free](https://kdp.amazon.com/pt_BR/help/topic/GDDXGH9VR22ACM8U). Ótimo. Só não resolve os livros protegidos, e a decisão continua nas mãos da editora. Títulos antigos sem DRM também precisam ser confirmados individualmente pelo publisher. Minha biblioteca não ganhou botão de download por causa disso.

Resolvi tentar de novo agora. A versão nova do DeDRM conseguiu lidar com o DRM atual, mas o processo mudou bastante. Dá trabalho, precisa de Windows numa das etapas e envolve uma ferramenta comunitária em pre-release. Funcionou. Recuperei **106 livros comprados**, testei a conversão pra EPUB e agora posso ler no aparelho que eu quiser.

Este é o estado do jogo em **30 de julho de 2026**. A Amazon pode mudar a criptografia ou o aplicativo amanhã. Não conte com tutorial antigo dizendo pra instalar Kindle for PC 1.17, desabilitar update e colocar o serial do aparelho no Calibre. Esse mundo já acabou.

E o óbvio precisa ser dito: estou falando dos livros que **eu comprei**. Não estou falando de baixar Kindle Unlimited, empréstimo de biblioteca ou livro dos outros. Leis sobre circumvention de DRM variam por país. Pesquise a legislação de onde mora e assuma responsabilidade pelo que faz.

## Antes de tudo: não jogue Kindle velho fora

Amazon também não facilita reaproveitar Kindle antigo. O hardware continua bom, a bateria costuma ser substituível, a tela de e-ink dura uma eternidade, mas o software vai ficando cada vez mais fechado e limitado.

Pra quem quer ressuscitar esses aparelhos, recomendo o canal [Dammit Jeff](https://www.youtube.com/@DammitJeff). Ele acompanha jailbreaks, KOReader, lojas alternativas e formas de manter Kindles úteis depois que a Amazon perde o interesse. Este vídeo sobre o [AdBreak e os jailbreaks recentes](https://www.youtube.com/watch?v=l4ZliC82RtA) é um bom começo. Leia também o [guia atualizado do Kindle Modding](https://kindlemodding.org/) antes de fazer qualquer coisa, porque firmware e método compatível mudam o tempo todo.

Jailbreak do aparelho e remoção de DRM do ebook são problemas diferentes. Você não precisa desbloquear o Kindle pra seguir o resto deste artigo. Estou mencionando porque ambos partem da mesma ideia: hardware e mídia que já pagamos deveriam continuar úteis sem pedir bênção eterna ao fabricante.

## Crash course: AZW, EPUB e KFX

DRM e formato de arquivo não são a mesma coisa. O formato diz como texto, imagens, fontes, índice e metadados são empacotados. DRM adiciona uma trava criptográfica por cima e decide qual conta, aplicativo ou aparelho consegue abrir aquilo.

Os três nomes que importam aqui são:

| Formato | O que é | Na prática |
|---|---|---|
| **AZW / AZW3** | Família mais antiga de formatos proprietários do Kindle. AZW3 também é conhecido como Kindle Format 8. | Era o que normalmente vinha pelo antigo download via USB. Ferramentas e leitores alternativos entendem bem depois de remover o DRM. |
| **EPUB** | Padrão aberto da W3C. É um pacote único com conteúdo baseado em HTML, CSS, SVG, fontes e metadados. | É o formato mais portátil pra guardar e ler fora do ecossistema Amazon. É o destino que quero. |
| **KFX** | Formato moderno de entrega da Amazon, usado pra recursos como Enhanced Typesetting e Page Flip. Um livro comprado pode vir dividido entre vários containers, recursos auxiliares e um voucher de DRM. | É o que o aplicativo Kindle atual baixa. Precisamos reunir as partes, remover o DRM e só depois converter. |

A extensão sozinha pode enganar. Parte de um livro KFX pode aparecer como `.azw`, `.azw.res`, `.voucher` e outras variações. O plugin [KFX Input](https://www.mobileread.com/forums/showthread.php?t=291290) existe justamente pra entender esse conjunto.

O EPUB é bem menos misterioso. A [especificação EPUB 3.3](https://www.w3.org/TR/epub-33/) o define como um container de arquivo único pra conteúdo Web estruturado. É basicamente um pequeno site empacotado. Qualquer leitor minimamente decente consegue implementar suporte sem depender de uma chave secreta da Amazon.

## Calibre e os dois plugins

[calibre](https://calibre-ebook.com/) é o canivete suíço de ebooks. É software livre, roda em Linux, macOS e Windows, organiza biblioteca, baixa metadados, edita capas, transfere livros e converte dezenas de formatos. Existe desde 2006 e nasceu justamente porque o primeiro Sony Reader não funcionava direito no Linux.

No Omarchy ou qualquer Arch, basta instalar o pacote:

```bash
sudo pacman -S calibre
```

Em outras distribuições, veja o [download oficial](https://calibre-ebook.com/download). Não invente de instalar um pacote aleatório de site de downloads.

Uma pegadinha específica de ambientes com `mise`: se o Calibre morrer com `ModuleNotFoundError: msgpack` ou `BrokenPipeError`, provavelmente um shim de Python entrou antes de `/usr/bin`. O pacote do Arch precisa do Python do sistema. Inicie assim:

```bash
env PATH="/usr/bin:$PATH" /usr/bin/python3 /usr/bin/calibre
```

Isso não tem relação com DRM nem com os plugins. É só o helper do Calibre chamando o Python errado. No meu desktop deixei um launcher permanente com esse `PATH`.

![Minha biblioteca no Calibre, com um livro já convertido e disponível em AZW3 e EPUB.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/30/kindle-dedrm/calibre-library-epub.webp)

O Calibre sozinho não remove DRM. Precisamos de dois plugins:

1. **DeDRM** reconhece e remove as travas de vários ecossistemas durante a importação. Ele só roda quando o livro entra na biblioteca. Clicar em Convert depois não remove nada.
2. **KFX Input** entende os containers modernos da Amazon, reúne as partes de um livro e permite converter o resultado pra EPUB.

No momento deste artigo, estou usando **DeDRM 10.0.28**, publicado em 14 de julho no [fork mantido por Satsuoni](https://github.com/Satsuoni/DeDRM_tools/releases/tag/v10.0.28). É um pre-release. Baixe o asset chamado `DeDRM_tools.zip`, nunca um executável solto de algum mirror obscuro.

Eu descompactei tudo numa pasta que depois fica compartilhada com a VM Windows:

```bash
mkdir -p ~/Windows/Kindle-DeDRM/v10.0.28
unzip ~/Downloads/DeDRM_tools.zip -d ~/Windows/Kindle-DeDRM/v10.0.28
```

O SHA-256 do `DeDRM_tools.zip` que usei foi:

```text
520cce704edf9ae26e43196efe2871daf9b25d6cb489aa56051626801c362947
```

Confira com `sha256sum`. Isso não transforma um binário comunitário em software magicamente seguro, mas pelo menos garante que está usando o mesmo arquivo que eu testei.

Dentro da pasta existe `DeDRM_plugin.zip`. **Não descompacte esse segundo ZIP.** No Calibre, abra **Preferences → Plugins → Load plugin from file**, escolha `DeDRM_plugin.zip`, aceite o aviso e reinicie o programa.

Depois volte em **Preferences → Plugins → Get new plugins**, procure por **KFX Input** e instale. Meu teste usou a versão **2.33.0**. Reinicie de novo.

![Calibre 9.11 com DeDRM 10.0.28 e KFX Input 2.33.0 instalados.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/30/kindle-dedrm/calibre-plugins-dedrm-kfx.webp)

## Por que copiar do Kindle pelo USB não resolveu

O caminho mais simples ainda seria ligar meu Kindle Paperwhite novo no cabo, copiar o livro e configurar o serial do aparelho no DeDRM. Foi o primeiro teste que fiz.

O arquivo entrou como `KFX-ZIP`, o plugin rodou, mas continuou criptografado. Abri o Calibre em debug e o log mostrou que esse livro usava a estratégia `ACCOUNT_SECRET`. O serial estava certo. O problema é que a chave necessária não vinha mais apenas do aparelho.

É por isso que muita gente segue tutorial antigo, tenta cinco serial numbers diferentes e conclui que o DeDRM está quebrado. Pra livros novos com esse DRM, precisamos do segredo que o aplicativo Kindle atual guarda no Windows. E esse segredo é protegido pelas APIs do TPM.

## Um Windows descartável dentro do Omarchy

Eu não vou manter dual boot só pra baixar ebook. Também não vou fingir que Wine roda tudo. Felizmente, o Omarchy [já vem preparado pra instalar e abrir uma VM Windows](https://learn.omacom.io/books/2/pages/100): ela aparece no próprio menu do sistema, abre por RDP e compartilha `~/Windows` automaticamente com o guest. Não precisei montar essa integração do zero.

Por baixo, ele usa o [dockur/windows](https://github.com/dockur/windows). O dockur empacota QEMU/KVM num container e automatiza a instalação do Windows. Continua sendo uma máquina virtual de verdade, com disco e kernel próprios. O container só organiza a distribuição, configuração e ciclo de vida.

Pra instalar pelo terminal, rode:

```bash
omarchy-windows-vm install
```

Escolha RAM, CPUs e tamanho do disco. O instalador cria `~/.config/windows/docker-compose.yml`, guarda o disco virtual em `~/.windows` e compartilha `~/Windows` com o guest. Dentro do Windows, essa pasta aparece como **Shared**, normalmente em `Z:`, e também fica acessível por `\\host.lan\Data`.

O detalhe que fez diferença no meu caso foi habilitar **TPM 2.0**. Edite o Compose gerado e acrescente `TPM: "Y"` no bloco `environment`:

```yaml
services:
  windows:
    image: dockurr/windows
    environment:
      VERSION: "11"
      TPM: "Y"
```

Depois recrie o container. O disco do Windows continua no volume persistente:

```bash
omarchy-windows-vm stop
omarchy-windows-vm launch -k
```

O `-k` deixa a VM ligada quando você fechar o RDP. Também dá pra acompanhar pelo navegador em `http://127.0.0.1:8006`.

<!-- Screenshot pendente: Windows 11 do dockur aberto pelo Omarchy. -->

## Baixando os livros pelo aplicativo certo

Dentro do Windows, abra a Microsoft Store e instale **[Amazon Kindle: Reading App](https://apps.microsoft.com/detail/9p8jq0jjstll)**, produto `9P8JQ0JJSTLL`.

Preste atenção aqui. O instalador antigo de Kindle for PC encontrado em blogs não é o mesmo aplicativo. A ferramenta que usei procura o pacote `AMZNKindle.AmazonKindleReadingApp` da Microsoft Store. Com o programa legado, ela simplesmente responde `No AmazonKindleReadingApp installation found`.

Entre na sua conta e mande baixar localmente cada livro que quer preservar. Abrir a capa ou ver o título na biblioteca não basta. O conteúdo precisa estar disponível offline dentro do app.

Infelizmente, a parte mais chata continua manual. A Amazon sabe colocar botão de compra com um clique, mas não achou espaço pra um "baixe tudo que eu já paguei".

Eu fiz isso em 106 livros. Sim, foi um saco.

![Aplicativo Kindle da Microsoft Store com os ebooks baixados na biblioteca local.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/30/kindle-dedrm/kindle-store-library.webp)

## Gerando os KFX-ZIP e a chave K4I

O `DeDRM_tools.zip` que descompactamos no Linux já está visível no Windows por causa da pasta compartilhada. Abra PowerShell e entre nela:

```powershell
cd \\host.lan\Data\Kindle-DeDRM\v10.0.28
.\MSIXKFXArchiverMobi1_18632.exe
```

O banner ainda pode mencionar uma build antiga `1.0.15230`. O executável versionado acima procura a Store app `1.0.18632` e foi o que funcionou comigo.

Esse executável localiza o cache da versão atual da Microsoft Store, reúne os componentes de cada livro e gera duas coisas:

- `archived_kfx/`, com um `.kfx-zip` pra cada ebook baixado;
- `oldbooks.k4i`, o keyfile que o DeDRM precisa pra abrir aqueles arquivos.

Na minha máquina, o processo encontrou e arquivou **106 livros**. O SHA-256 do executável que rodei foi:

```text
0c78b45ccea2c36a5fbb01b9f66bdd9e5d5960a68a340ba2ee96e138f5cddf4a
```

Ele é um binário de 32 bits. Se reclamar que falta `MSVCP140.dll`, instale o [Microsoft Visual C++ Redistributable x86 oficial](https://aka.ms/vc14/vc_redist.x86.exe). Não procure DLL avulsa no Google. Esse é um ótimo jeito de transformar backup de livro em backup de malware.

O `oldbooks.k4i` é sensível. Ele deriva do segredo da sua conta naquela instalação do Kindle. Não publique, não mande em issue do GitHub, não tire screenshot do conteúdo e não coloque em repositório aberto.

<!-- Screenshot pendente: PowerShell após o archiver gerar archived_kfx e oldbooks.k4i. -->

## Configurando a chave no DeDRM

De volta ao Linux, abra o Calibre e siga:

**Preferences → Plugins → DeDRM → Customize plugin → Kindle for Mac/PC ebooks → Import Existing Keyfiles**

Selecione:

```text
~/Windows/Kindle-DeDRM/v10.0.28/oldbooks.k4i
```

Use **Import Existing Keyfiles**. Não use o botão genérico **Set Keyfile** da tela principal. Ele grava outro tipo de candidato e não cadastra a chave K4I no lugar certo.

Feche a lista de chaves, clique em **OK** na configuração principal e reinicie o Calibre. Se fechar com Cancel, ele joga a alteração fora sem cerimônia.

![DeDRM com o keyfile `oldbooks` importado na lista de chaves do Kindle for Mac/PC.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/30/kindle-dedrm/calibre-dedrm-key.webp)

## Importando e convertendo pra EPUB

Antes de despejar cem arquivos na biblioteca, teste um.

Escolha um `.kfx-zip` dentro de:

```text
~/Windows/Kindle-DeDRM/v10.0.28/archived_kfx/
```

Use **Add books** no Calibre. A ordem interna é esta:

1. KFX Input reconhece o pacote;
2. DeDRM tenta as chaves K4I durante a importação;
3. KFX Input monta o livro descriptografado como KFX;
4. Calibre passa a conseguir abrir e converter o resultado.

Se o formato continuar aparecendo como `KFX-ZIP`, deu errado. Não adianta apertar Convert dez vezes. Remova aquela entrada da biblioteca, corrija plugin ou chave e importe de novo. DeDRM só atua na **entrada**.

Quando o livro aparecer como `KFX`, abra no viewer e confira algumas páginas. Depois clique em **Convert books**, escolha **EPUB** como saída e teste o arquivo resultante no leitor onde pretende usar. Só depois disso faça a importação em lote.

No meu caso, o KFX abriu, converteu e o EPUB funcionou fora do Kindle. Com isso eu sabia que o caminho inteiro estava funcionando: Microsoft Store, TPM, archiver, K4I, DeDRM 10.0.28 e KFX Input 2.33.0.

<!-- Screenshot pendente: livro importado como KFX no Calibre. -->

![Diálogo de conversão do Calibre com EPUB selecionado como formato de saída.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/30/kindle-dedrm/calibre-convert-epub.webp)

<!-- Screenshot pendente: EPUB final aberto no Xteink X4. -->

## Faça backup do que realmente importa

Depois da conversão, eu preservo três coisas:

- os EPUBs finais, que leio em qualquer aparelho;
- os KFX-ZIP originais, até conferir que todos os EPUBs estão íntegros;
- o `oldbooks.k4i`, criptografado e separado da biblioteca.

Meu keyfile em texto puro fica com permissão `0600`. Também mantenho uma cópia criptografada com SOPS e age, enquanto a chave privada fica em outro backup. Não coloque `oldbooks.k4i` cru no Git só porque o repositório é privado. Repositório privado vaza também.

Os EPUBs entram na mesma estratégia que uso pros outros arquivos importantes: cópia local, NAS e backup off-site. Já expliquei essa paranoia em [Protegendo e Recuperando Dados Perdidos](/2023/10/19/akitando-146-protegendo-e-recuperando-dados-perdidos-git-backup-btrfs/) e mostrei a mesma filosofia aplicada a filmes no meu [Netflix Pessoal](/2024/04/03/meu-netflix-pessoal-com-docker-compose/).

Não apague os arquivos do Kindle ou da VM no minuto em que a conversão termina. Abra os EPUBs, veja capa, índice, imagens, notas e algumas páginas. Backup que nunca foi testado é só torcida organizada.

## Conclusão

Amazon já apagou livros remotamente, editoras atualizam capas e conteúdo, aplicativos antigos param de funcionar e formatos mudam. O próprio fim do download via USB mostrou que uma função disponível por dezoito anos pode desaparecer com uma linha num aviso.

O exemplo clássico continua inacreditável: em 2009 a Amazon apagou `1984` e `Animal Farm`, de George Orwell, dos Kindles de clientes. Depois vieram revisões de Roald Dahl, R.L. Stine e Agatha Christie empurradas pra cópias digitais que já tinham sido compradas. O [artigo da Vice](https://www.vice.com/en/article/amazon-is-killing-your-ability-to-download-kindle-books-next-week/) resume esses casos. O Dammit Jeff também bate muito nessa tecla: até a capa original que você escolheu pode virar pôster feio da adaptação do streaming porque publisher e loja decidiram atualizar sua "compra".

Não importa se a alteração futura é censura, correção legítima, nova capa horrorosa de adaptação da Netflix ou apenas um bug. Eu comprei uma edição. Quero preservar a edição que comprei.

DRM não impede pirataria. Livro popular aparece em torrent no dia do lançamento. DRM só atrapalha o cliente que pagou, dificulta acessibilidade, prende hardware ainda bom e transforma uma compra em aluguel por prazo indefinido.

Calibre, DeDRM, KFX Input e uma VM descartável devolveram minha biblioteca. Agora posso colocar os EPUBs no Xteink, num Kobo, num tablet, no celular ou num leitor que ainda nem existe. Posso trocar de sistema operacional e posso desligar a internet. Os arquivos continuam comigo.

Se não está na sua máquina, não é seu.
