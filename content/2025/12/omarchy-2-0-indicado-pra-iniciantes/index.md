---
title: Omarchy 2.0 - Indicado pra Iniciantes?
date: "2025-09-12T12:00:00-03:00"
slug: omarchy-2-0-indicado-pra-iniciantes
tags:
  - omarchy
  - distrobox
  - ventoy
  - balena
  - arch
draft: false
---

O video mais importante do meu [canal de YouTube](https://www.youtube.com/@Akitando) é o "Não Terceirize suas Decisões":

{{< youtube id="D3L8IOncLkg" >}}

As perguntas que eu mais recebo, literalmente todos os dias, são no formato: _"Akita, devo fazer faculdade?_, _"Akita, o que você acha que eu devo estudar?"_ e variações dessas.

Velho, eu não te conheço, nunca vou saber nem me interessar em saber quem você é, o que almeja, quais suas aspirações, ambições, gostos, preferência. Nada. Nem eu, nem **NINGUÉM**. Só você sabe o que é melhor pra você. Se não sabe, trate de procurar saber. É isso que **VIVER** significa.

O que você não admite é que quer que alguém que considera mais importante ou relevante aprovando sua escolha e dizendo que está certo.

Nunca espere isso de mim, eu nunca vou te validar.

Sempre vou dizer: **SE VIRA**. Foi assim que eu me tornei quem eu sou. Eu nunca segui ninguém, nunca perguntei pra ninguém o que deveria fazer. Simplesmente ia lá e fazia. Quebrava a cara, caía, levantava, e tentava de novo. É a vida.

Deixa eu mostrar o que me **INCOMODA** mesmo:

![pergunta idiota](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250912124608_screenshot-2025-09-12_12-45-47.png)

Vamos ver no [manual](https://learn.omacom.io/2/the-omarchy-manual/93/security)?

![Manual](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250912124657_screenshot-2025-09-12_12-46-45.png)

O DHH se deu ao trabalho de escrever um manual. Tem uma seção chamada "Security". Se tivesse ido no Google, teria achado. Ou esta outra pérola:

![devops](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250912124836_screenshot-2025-09-12_12-48-24.png)

Como quer ser "DEVOPS" (que tem que saber TUDO de Linux) começando assim. Já começou errado. Senta a bunda na cadeira, arregaça as mangas, e testa um por um, e aprende.

### Linux pra Iniciante?

Isso dito, assista meu video. Mas como tenho falado bastante de [Omarchy](/tags/omarchy) já digo que sim, este é o que eu uso no meu dia a dia e é único que vou recomendar no futuro próximo (depois posso mudar de idéia). Tendo usado distros desde que Linux foi inventado no começo dos anos 90, eu sei que existem dezenas de distros e nem eu tenho paciência pra experimentar todos.

_Por que Omarchy?_

Primeiro porque ele fez a escolha certa da distro base: **Arch Linux**. Considero que é a melhor distro que existe hoje por dois fatores: ele tem pouco "bloat" (não instala um monte de coisas que você nunca vai usar, como um Ubuntu, Fedora, Mint, Deepin ou qualquer outros desses "pra iniciantes").

Segundo, Arch Linux tem o AUR, que é um repositório de pacotes feitos pro usuários que tem basicamente tudo. Não precisa ficar caçando repositórios de terceiros ou ter que instalar manualmente. Com um único comando, o `yay`, instala-se tudo. Não existe isso de `apt-repository add` ou ter que fazer `make install` nem nada disso. O AUR gerencia tudo pra você.

Terceiro, ele instala Hyprland (que eu já usava e gostava), com configurações muito boas, escolha de pacotes muito bons. Tudo que eu mesmo instalaria manualmente. Então é uma opção mil vezes mais fácil pra ter o que eu teria muito mais trabalho pra fazer sozinho. Veja minha [série de posts sobre Omarchy](/tags/omarchy) pra ver essas opções.

### Linux pra Iniciantes?

_Iniciante em que?_

Eu odeio essa pergunta. Se você é um usuário amador mesmo, não programador, talvez seja um contador, talvez seja só um adolescente gamer. A primeira pergunta que faço é: _pra que você quer usar Linux??_

Digamos que seja porque ouviu falar que é mais seguro (de fato é). Então tanto faz, qualquer distro serve. Instale Ubuntu, instale Manjaro, instale Garuda. Não faz diferença, porque você nunca vai lidar com nada por baixo dos panos. Vai abrir o Chrome, vai abrir o Steam, e é só isso. O resto vai ser web-apps.

Digamos que é só pra jogar, então instale [Bazzite](https://bazzite.gg/) no seu mini-PC ou handheld. Ou só instale seus jogos num Windows separado só pra jogos como eu fiz. Tanto faz.

Ou fique no Windows ou MacOS mesmo. Se for totalmente amador, provavelmente vai usar a mesma senha fraca pra tudo, vai sair clicando em links do Whatsapp sem ver de quem é. Literalmente tanto faz qual OS vai usar. Nenhuma segurança de nenhum OS vai proteger seus maus hábitos e ignorância.

Se for iniciante em programação ou tecnologia, aí eu não tenho dó: aprenda Linux direito. Você quer ser um profissional, seja um profissional, aprenda do jeito certo: aprenda a ter 100% de controle sob sua própria máquina. Não tem passo a passo nem tutorial pra isso. É algo que você vai fazer continuamente pro resto da vida. Eu tenho mais de 30 anos na área e continuo aprendendo coisas novas todos os dias.

### Hardware

O **MAIOR** problema que qualquer pessoa vai ter, com QUALQUER distro vai ser suporte a hardware. E eis porque você não deve só seguir o que alguém te recomenda:

**Ninguém tem o mesmo PC que você.**

Qual é seu notebook? Um Lenovo? Um Dell? Um Positivo? De que ano? Qual modelo?

Tudo vai variar: qual é o dispositivo de Wi-fi e bluetooth? qual é a placa gráfica? Qual firmware está rodando? Com que suportes de perfis de energia? Tem necessidade de dispositivos FIDO2 pra coisas como leitor de impressão digital? Hardware keys? Tem TPU na sua máquina? Vai precisar de Secure Boot?

Não sei. Você que tem que saber.

Um exemplo prático, eu tenho um notebook **Asus Zephyrus G14** que uso com Windows porque serve só na minha oficina pra rodar Bambu Studio pra controlar minha Impressora 3D X1C. Ainda não parei pra instalar Omarchy nele, mas digamos que eu queira. Vai funcionar?

Felizmente existe [uma página no ArchWiki](https://wiki.archlinux.org/title/ASUS_ROG_Zephyrus_G16_(2023)_GU603) dedicada a este modelo. Ao que parece, funciona tudo "out-of-the-box". Mas se fosse a [versão do ano anterior](https://wiki.archlinux.org/title/ASUS_ROG_Zephyrus_G14_(2022)_GA402) já teria que checar mais ítens extras. Tem problemas no Wi-fi, por exemplo.

Cada máquina diferente vai ter problemas diferentes.

### Live Env e Ventoy

_"O que eu faço então, me ph0di?_

É por isso que praticamente toda boa distro oferece a ISO de instalação que vem com um ambiente vivo (Live Environment). Já vi que tem muita gente no Windows que tem dificuldade do que fazer com uma ISO. É muito simples.

![Balena Etcher](https://etcher.balena.io/images/Etcher_steps.gif)

O programa mais fácil de usar é o [Balena Etcher](https://etcher.balena.io/) Você baixa o arquivo com extensão `.iso`, seja do Ubuntu, Mint, Elementary, etc (SEMPRE DO SITE OFICIAL!!!!). Abre o Balena e só tem 2 passos: selecione a imagem (o arquivo ISO), selecione o drive (seu pen drive, cuidado pra não escolher seu HD!), e pronto.

Agora é só bootar seu PC e entrar na BIOS pra selecionar o pen drive pra bootar ou usar uma tecla como F12 (varia de BIOS pra BIOS) pro UEFI selecionar seu pen drive.

Isso vai bootar o Live Environment direto do pen drive.

![Try Ubuntu](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250912120806_try-ubuntu-install-ubuntu-800x530.jpeg)

A maioria das distros começa abrindo uma tela de "Bem Vindo" parecida com a de cima. Esse aplicativo de instalação se chama [**Calamares**](https://calamares.io/) e todo mundo com instalação gráfica usa ele. Por isso é parecido em todos. É o mesmo passo a passo. Se instalou uma distro já instalou todas.

Só que você não precisa seguir o Calamares. Pode fechar ele. E agora está já no ambiente gráfico da distro que escolheu pra instalar. **USE ELE.** Tente configurar seu Wi-fi, tente parear seu fone ou mouse Bluetooth, tente ligar a WebCam, coloque um micro-SD card e veja se ele aparece. Tente navegar na web e sinta a performance.

Se nesse ponto conseguir fazer todas as coisas básicas, significa que as chances de tudo funcionar é grande. Se já neste ponto começar a ter problemas, como não conseguir conectar no seu Wi-fi, possivelmente essa distro vai te dar dor de cabeça. Comece indo no Google e veja se alguém já solucionou o problema pro seu modelo de notebook ou PC, **antes** de continuar com o Calamares.

Digamos que você decidiu tirar o dia pra testar várias distros pra ver qual roda melhor na sua máquina. Ótima decisão, mas já deve ter entendido que vai ser um enorme saco ter vários pen drives, um pra cada distro. Ou toda hora ter que voltar pro Windows e usar o Balena pra sobrescrever uma nova distro no seu único pendrive.

Não precisa fazer isso.

Basta baixar e instalar primeiro o [**Ventoy**](https://www.ventoy.net/en/index.html) no seu pendrive. Veja a [documentação](https://www.ventoy.net/en/doc_start.html) no site deles, mas é ridiculamente simples.

![Ventoy Menu](https://www.ventoy.net/static/img/screen/screen_uefi_en.png?v=4)

Depois de instalar no seu pendrive, agora é só copiar **TODAS AS ISOS** que quiser de uma só vez no pendrive. Quando bootar por ele, vai entrar no menu do Ventoy, que vai deixar escolher qualquer uma das ISOs que copiou lá. Se não gostou da distro atual, só rebootar no Ventoy de novo, e escolher outra ISO. É assim simples.

![Ventoy](https://www.ventoy.net/static/img/ventoy2disk_en.png)

### Distrobox

Digamos que você é um programador, ou um devops, ou qualquer profissional na área de tecnologia. Sua preocupação não é tanto a interface gráfica (que dá pra testar com Ventoy), mas sim se a infra do OS vai funcionar com seus requerimentos de desenvolvimento.

Digamos que você use Fedora. Será que se eu for pro Mint, vai ter os pacotes pro K8S do jeito que eu preciso? Será que tem suporte à versão de Java que eu uso? Será que se eu buildar um pacote `.deb` no meu Fedora, vai instalar direitinho no Ubuntu?

Ter que fazer dual boot ou instalar uma VM parece pesado demais, trabalhoso demais, só pra testar 2 linhas de comando, por exemplo.

![Distrobox](https://user-images.githubusercontent.com/598882/144294862-f6684334-ccf4-4e5e-85f8-1d66210a0fff.png)

Pra isso existe [**Distrobox**](https://distrobox.it/). Ele precisa do Docker ou Podman já instalado na sua máquina. Mas depois é só fazer:

```bash
distrobox create -n debian-test --init --image debian:latest --additional-packages "build-essential"
```

Uma vez criado o box é só entrar nele:

```bash
distrobox enter debian-test
```

Acabou, você está dentro do Debian, super rápido. Como é um container docker, tem como mapear diretórios na sua máquina local pra dentro do container, então fica tudo integrado. E o mais importante: carrega super rápido, porque é só um container Docker.

O guia [Quick Start](https://distrobox.it/#quick-start) explica tudo isso e tem este video com um tour pra demonstrar como funciona:

{{< youtube id="Q2PrISAOtbY" >}}

### Conclusão

Sério. Com Distrobox não tem desculpa pra não testar outra distro em 2 minutos. Não fique perdendo tempo mandando DM pra "influencer". Veja você mesmo! Se não é capaz de fazer isso, talvez esteja na profissão errada.

Todo "dev" ou profissional de tecnologia, seja de devops, cybersec, data analyst, bla bla bla, seja lá qual título da moda hoje em dia, **DEVE** ter controle sobre sua própria máquina. **DEVE** saber lidar com segurança (por isso fiz posts sobre Vaultwarden, Cloudflare, SSH, etc).

**É SUA RESPONSABILIDADE!**

Não terceirize sua responsabilidade pros outros. Não procure validação. Seja **promíscuo** e teste quais distros quiser, e faça o que quiser nessas distros: é sua! Não existe "distro pra iniciante", "distro pra dev", "distro pra devops". Distro é Distro. Linux é Linux. É tudo igual, o que varia é **sua habilidade**. Se não tem habilidade: conquiste! Aprenda! Quebre a cabeça! Vare noites tunando configs! Leia as documentações oficiais! Não perca tempo achando que vai aprender em rede social. Não vai.

Eu uso Linux desde o começo dos anos 90 e não fico usando Slackware só porque foi a primeira que aprendi e sinto necessidade de validar minha primeira escolha. Eu uso todas que quiser. Agora mesmo, eu tinha minha própria instalação de Hyprland, resolvi que quero aprender e usar Omarchy. Passei a semana quebrando cabeça, escrevi meia dúzia de posts no blog. E agora eu aprendi. Eu sei Omarchy: mais um pra coleção.
