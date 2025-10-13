---
title: Omarchy 2.0 - Instale com a ISO do Omarchy
date: "2025-09-12T10:00:00-03:00"
slug: omarchy-2-0-instale-com-a-iso-do-omarchy
tags:
  - omarchy
  - archinstall
  - luks
  - limine
  - snapper
  - sddm
draft: false
---

Pra finalizar a série de [Omarchy](/tags/omarchy) por enquanto, acho que faltou comentar rapidamente sobre a instalação via a ISO do próprio Omarchy.

![ISO](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250912093827_screenshot-2025-09-12_09-38-05.png)

Só ir no [site oficial](https://omarchy.org/) e clicar em "ISO" pra baixar. Usar um Rufus ou Balena Etcher no Windows (ou [Caligula](https://github.com/ifd3f/caligula) em Linux) pra gravar num pen drive e bootar com ele. Dali em diante é seguir o passo-a-passo e em menos de 5 minutos vai ter tudo instalado.

![Omarchy install](https://learn.omacom.io/u/configurator-iGH96F.png)

Como expliquei no [primeiro artigo](https://akitaonrails.com/2025/08/29/new-omarchy-2-0-install/) eu fiz diferente: instalei o [Arch Linux](https://archlinux.org/download/) puro, tipo Desktop, com Hyprland + SDDM. Depois instalei Omarchy usando a linha de comando manual:

```bash
curl -fsSL https://omarchy.org/install | bash
```

Dá pra fazer dos dois jeitos, no segundo tem mais controle, mas depois de ganhar mais experiência e ler os scripts de install, eu recomendo que baixe a ISO do próprio Omarchy, vai ser mais fácil mesmo.

### Limine vs Grub

O motivo de ter instalado da forma mais manual foi porque eu não tinha certeza se o Omarchy tinha suporte a dar rollback de BTRFS via snapshots. Eu tinha ouvido falar que o bootload [Limine](https://codeberg.org/Limine/Limine) não suportava isso. Mas me enganei, o Omarchy instala Limine com suporte a **Snapper** (que é similar ao Timeshift que eu costumo usar). Leia no [ArchWiki seção 6.2](https://wiki.archlinux.org/title/Limine), portanto deve ser uma opção superior à minha instalação de GRUB+Timeshift que falei no primeiro artigo.

Como eu já instalei de forma manual, vou manter como está porque na prática é a mesma coisa. Mas se fosse instalar de novo, agora instalaria com Limine+Snapper pra experimentar.

Significa que existe suporte a snapshot do seu filesystem inteiro com BTRFS antes de um update de pacotes e, se algo der errado, é possível rebootar e dar rollback pra um snapshot anterior. Isso te dá segurança de não perder um dia inteiro tentando consertar alguma coisa, caso algum pacote importante do sistema venha com bugs ou corrompido. É o recurso mais importante.

### SDDM vs UWSM

Outra coisa diferente que notei foi o login manager. No Arch puro, ele instala Hyprland por padrão com [SDDM](https://wiki.archlinux.org/title/SDDM), que é o mesmo que o KDE usa.

Omarchy usa UWSM, que faz login automático com seu usuário no boot. Então não tem tela de login, ele já abre o Hyprland automaticamente.

_"Mas isso não é inseguro??"_

Não, porque a ISO do Omarchy pré-configura seu SSD com LUKS, antes do filesystem.

Pra quem não sabe, [LUKS](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system) é o **Linux Unified Key Setup**, que dá suporte a encriptar seu disco inteiro. A vantagem dele em relação a um BitLocker do Windows, é que ele é **agnóstico a filesystem**. Ou seja, funciona com BTRFS ou EXT4 ou qualquer outro, porque na sequência de boot, depois do bootloader (seja Limine ou Grub), ele carrega **antes** do filesystem. É um encriptador em nível de blocos.

![install luks](https://learn.omacom.io/u/arch-encryption-urjrDm.png)

Portanto, quando você bootar seu sistema, primeiro vai pedir a senha de decriptar seu disco. Daí abre o filesystem e o kernel do Linux pode continuar o boot normal com o disco aberto. Então você é obrigado a **sempre** digitar a senha segura do seu usuário no boot pra decriptar o disco.

Portanto, ter que digitar senha novamente num login manager seria redundante e desnecessário, por isso imagino que escolheram usar UWSM em vez de SDDM.

Especialmente em notebook, ou em casos onde mais gente mora com você, é **essencial** garantir que seu disco esteja encriptado, não importa o sistema operacional. Digamos que saia pra trabalhar ou vá viajar e seu notebook é roubado. Sem encriptação, acabou, não importa se tem um login manager. Ele não protege seus dados. Basta tirar o SSD do seu notebook, plugar em outro computador e pronto, dá pra copiar tudo bootando como Root.

Com encriptação, sem a senha pra decriptar, é impossível acessar seus dados. Impossível mesmo, porque em qualquer computador modernos dos últimos 15 anos, a CPU vem com instruções aceleradas em hardware pra encriptar usando AES 256.

Sendo um pouco mais nerd, a chave de decriptação **não é sua senha**. Durante o processo de instalação vai ser gerada uma nova senha mais forte e segura usando um processo de **derivação de chaves** (KDF - Key Derivation Function), hoje em dia é com Argon2id, antigamente era com PBKDF2. Explico sobre isso neste video:

{{< youtube id="HCHqtpipwu4" >}}

Portanto, quando digita sua senha, na verdade ele decripta essa chave segura, e é com essa chave segura que seu disco está encriptado. Por isso não dá pra decriptar seus dados na força-bruta.

Além disso AES 256 é outro algoritmo de criptografia que é **quantum resistant**. Mesmo se fosse possível um computador quântico (não é), nem ele conseguiria decriptar seu disco. Este é o nível de segurança.

_"Mas não vai ficar mais lento?"_

Não. É praticamente imperceptível, porque AES - como já disse - é acelerado via hardware pela sua CPU, não depende de software do seu sistema operacional. No dia a dia, dificilmente vai notar. A performance é praticamente a mesma. Não existe motivo pra não ativar encriptação, especialmente num notebook.

No meu caso pessoal, onde instalei num PC desktop, que eu mesmo controlo numa rede local segura - porque eu sei implementar segurança em rede, não tem problema. Os dados mais importantes pra mim ficam no meu NAS (que é encriptado), em backups (que são encriptados), eu não tenho dados sensíveis neste PC e o pouco que tenho está em arquivos encriptados pelo [Veracrypt](https://veracrypt.io/en/Downloads.html) num sub-volume separado.

Por isso não habilitei LUKS no meu PC. Daí mantive o SDDM que o Arch puro instalou. Só que ele é **BEM** feio por padrão, então só fica uma pequena dica: instalar ou o tema [sddm-sugar-dark](https://github.com/MarianArlt/sddm-sugar-dark) ou o [dark-arch-sddm](https://github.com/simonesestito/dark-arch-sddm). Eu prefiro esse segundo por ser mais minimalista e fica assim:

![dark arch sddm](https://github.com/simonesestito/dark-arch-sddm/raw/master/base/screenshot.png)

Eu customizei e troquei o logo do Arch pelo do Omarchy e pronto.

### Conclusão

Vou repetir: só depois que instalei manualmente que vi como o Omarchy instala e hoje eu prefiro o jeito do Omarchy. Se fosse instalar do zero, usaria a ISO do Omarchy e deixaria com Limine+Snapper e Hyprland+UWSM com suporte a rollback de snapshot, encriptação total do disco, login automático pro Hyprland.

Dá pra ver que o pessoal fazendo o Omarchy tem experiência e já escolheu componentes que fazem sentido pra funcionar tudo junto da forma mais conveniente e segura possível. Eu tive receio que por ser uma distro nova talvez eles não tivessem se preocupado com isso, mas fico feliz de dizer que eu estava errado.

Usem a ISO oficial do Omarchy.
