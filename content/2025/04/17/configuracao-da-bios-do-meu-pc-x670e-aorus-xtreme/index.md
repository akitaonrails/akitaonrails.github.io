---
title: Configuração da BIOS do meu PC - X670E Aorus Xtreme
date: '2025-04-17T18:50:00-03:00'
slug: configuracao-da-bios-do-meu-pc-x670e-aorus-xtreme
tags:
- amd
- performance
- linux
draft: false
translationKey: pc-bios-x670e-aorus
---

Esta é uma anotação pra mim mesmo, pra eu não esquecer e talvez ajude alguém.


Eu sei que toda placa-mãe vem pré-configurada em "defaults" seguros e conservadores, o mais estável e não o mais performático. Então se não entrar na BIOS pra mexer, vai estar deixando performance na mesa.

Eu tenho uma CPU AMD Ryzen 9 7950X3D. O processador é um pacote com um pacote que funciona do dois "dies", não sei se é "chip" um jeito de visualizar. Cada um deles tem 8 cores, totalizando os 16 cores e cada core com 2 threads, então 32 threads possíveis em paralelo.

Mas tem uma diferença, cada die tem caches L3 diferentes. Um dos dies tem só 32MB e o outro tem 96MB, então programas mais pesados se beneficiam se rodarem nos cores do die que tem mais L3, e dá pra configurar isso.

![lstopo](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/gcbhrzj8wuc38z3lonisck0ooeck)

Além disso ele tem clock base acho que de 3Ghz com capacidade de dar turbo boost até 5.7Ghz. Não pode tudo rodar nessa velocidade senão esquenta muito rápido e pode dar "thermal throttle" e aí ele derruba tudo pra baixo de 3Ghz. Por isso que, principalmente em notebooks que não tem capacidade térmica adequada, o melhor não é dar overclocking e sim "undervolting" (cortar a energia pra ir menos rápido). Porque é melhor todo mundo um pouco menos rápido do que todo mundo super rápido mas imediatamente super-aquecer e todo mundo ficar lento. É complexo isso.

Pra complicar mais eu tenho 96GB de RAM DDR5 6000. Capaz do máximo teórico de 6Ghz, mas isso é teórico porque pode dessincronizar tudo e causar instabilidades até crashear um kernel panic. Por isso o default da placa mãe é a velocidade base acho que de 4Ghz e CPU no máximo indo até 4Ghz mais ou menos também.

Mas dá pra subir isso um pouco sem deixar instável. Em resumo eu fiz o seguinte:

## PBO - Precision Boost Overdrive

Os CPUs Ryzen tem PBO pra dar turbo boost no clock dos cores. Ele costuma vir ou desativado ou numa configuração conservadora, então seu CPU de 5.7Ghz pode estar operando só em 4Ghz ou menos e nunca entregando o máximo.

Pra ajustar isso, se quiser ser avançado, precisa ajustar parâmetros como PPT (Package Power Tracking) pra 200W ou mais. TDC (Thermal Design Current) pra 160A ou mais. EDC (Electrical Design Current) pra 200A ou mais. E pode configurar uma otimizador de curva, por core, pra negativo (-10 ou -20) pra reduzir voltagem, o que pode permitir clocks de boost mais altos.

Mas isso é muito avançado, e precisa saber bem mais de elétrica antes de 
tentar na não. Melhor não arriscar e não mexer nisso. A tela a seguir, não deixe em Avançado e sim em Auto mesmo:

![PBO Advanced](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/vxeurat4imakwzdl6artkzuqymmq)

Em vez disso é melhor mexer em PBO Enhancement Presets, que é essa tela abaixo:

![PBO Presets](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/a1vgigv3ka64xs6nclq9z2hh21w7)

**70/80/90** se refere à temperatura máxima que permitimos os cores de chegarem. Isso vai depender se você tem uma boa solução de resfriamento. Seja um AIO com resfriamento líquido ou um [**Noctua NH-D15 G2**](https://noctua.at/en/nh-d15-g2) que é o que eu uso. Ventoinhas da Noctua são hiper silenciosas, eu quase nunca ouço e tem menos manutenção e possibilidade de falhas do que refriamento líquido. Eu prefiro menos peças móveis pra garantir.

[![Noctua NH-D15 G2](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/4d10atf2k9rb5pntb9eec5uzqk7u)

Agora esses **Level 1 a 5** são as tunagens de PPT/TDC/EDC que eu falei, mas já pré-definidas e testadas pelo fabricante. 1 é menos agressivo, o mais estável já 5 é o mais agressivo, pode ser instável. O certo é começar em **90 level 5** e ir diminuindo até achar o mais estável pro seu sistema. Isso vai variar, por exemplo, quando mais RAM tiver, menos agressivo parece que pode ser, especialmente quanto mais rápido essa RAM for.

No meu caso, logo no boot do meu Manjaro Linux, já deu kernel panic, que se parece com algo assim:

![kernel panic](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/f25kqct9urmereleunhurknw40d4)

Então voltei pra BIOS e fui testando diferentes níveis e, pra minha configuração, consegui chegar só até **90 Level 2**. Esse tem sido estável e até agora não tive nenhum crash aleatório.

Além disso, recentemente (começo de 2025) fabricantes de placa-mãe soltaram atualizações de firmware que abriram acesso a uma funcionalidade chamada **X3D Turbo Mode**. Se você ver isso, não pense que é mais performance grátis. Na realidade, a menos que use a máquina mais pra games, vai sentir até que ela ficou mais lenta.

Como expliquei antes, Ryzen 9 tem 1 CCD (core complex), que é o die com 96MB de cache L3 (V-Cache). Turbo mode tenta forçar mais programas pro CCD que **NÃO** tem V-Cache (o de 32MB), e que por isso consegue ter um boost maior de clock mas tem mais latência. Isso é bom pra games - que normalmente não se beneficiam de ter mais cache e sim mais clock.

Mas ao mesmo tempo, programas que precisam do V-Cache vão acabar caindo mais vezes no Core com **MENOS** cache L3 e aí vão performar pior que antes. Exemplos disso são programas de modelagem 3D como Blender, justamente o que eu quero usar mais agora. Por isso teste, mas em princípio pode deixar desligado.

Essa opção no meu firmware se chama "X3D Turbo Mode" mas em outros lugares pode ser "3D V-Cache Performance Optimizer", é a mesma coisa.

## XMP/EXPO RAM

Agora, a RAM DDR5 boota no clock base de uns 4.8Ghz. Mas dependendo do modelo da RAM ela pode ir muito mais, no meu caso pra 6Ghz. Toda memória moderna também tem diversas configurações como a frequência, latência, voltagem e mais. De novo, não vale a pena tentar parametrizar isso na mão. É melhor usar perfis pré-definidos (profiles). A Intel chama esse suporte de **XMP** e a AMD chama de **EXPO**.

Esqueci de tirar foto da minha BIOS, mas essa foto do Google Images um pouco mais antiga é a mesma coisa. XMP/EXPO vem desligado (conservador) mas é só escolher o profile que já existe:

![XMP/EXPO Profile](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ypwo0rsbr1bmu6w6ujm7b1qyjlof)

Note que logo embaixo tem coisas como **Low Latency Support** e **High Bandwidth Support**. Teoricamente pra diminuir a latência e aumentar a banda de transferência. Tudo que soa muito bom, mas no meu caso não funciona. Se eu tento ligar esses dois, meu sistema não dá boot. Fui obrigado a limpar a CMOS pra reiniciar a BIOS sem isso.

O problema: possivelmente muita memória (96GB). Talvez se você tiver menos, 32GB, por aí, isso funcione, mas parece que quanto mais se tem, mais instável fica se tenta ir rápido demais.

Outro problema, em DDR5, quanto mais memória, mais lento é o Cold Boot, o boot inicial quando o PC estava desligado. A BIOS precisa fazer uma checagem nas memórias pra garantir esses parâmetros, tempo de resposta e tudo mais. E isso acontece em **TODO** boot. Pode levar alguns minutos e alguns podem achar até que a máquina travou, mas é só essa checagem.

Na BIOS tem uma opção chamada **Memory Context Restore** onde ele usa os parâmetros que gravou da última vez que fez essa checagem. Mas não recomendo, pra mim inclusive nem boota mais depois de habilitar isso. Teoricamente ele iria cortar o tempo de checagem e reusar dados antigos, mas esses dados podem não bater (os valores podem flutuar) e isso torna o sistema todo instável. Melhor esperar um minuto a mais no boot do que ficar com o sistema instável.

Em configurações avançadas de memória tem mais uma coisa que devemos mexer: **DF C-States**, que precisa estar **DESABILITADO**. Em teoria essa funcionalidade é pra reduzir a latência entre CPU e memória. Mas em sistemas com muita RAM (96GB ou mais como a minha) isso também pode causar instabilidade a custo de não muito ganho notável. Prefiro ficar estável nesse caso.

Outra configuração pra mudar é **Power Supply Idle Control** tem que mudar pra "Typical Current Idle", e até agora (pode surgir um update de correção da firmware), é mandatório pra processadores Ryzen (mesmo AM5). isso previne estado de dormir "Deep Power State", o que pode causar kernel panics aleatórios.

Mesma coisa pra **Global C-State Control** que também precisa desabilitar pelo mesmo motivo: evitar "deep sleep states" (C6/C10) quando a CPU fica em "idle" (sem fazer nada) por muito tempo. Essas funcionalidades existem pra economizar energia, mas parece que AMD tem bugs quando a CPU é forçada a esse estado e quando acorda, volta instável ou crasheando. Então ele vai consumir mais energia quando não tá fazendo nada (por volta de menos de 20W, em vez de perto de zero), mas pelo menos não vai ficar instável. Se quiser economizar energia, melhor é dar shut-down e desligar a força mesmo, quando não estiver usando.

## Resumo da BIOS (pra mim)

+ PBO Enhancement: **90 Level 2** (clock boost um pouco mais agressivo que o default)
+ Power Supply Idle Control: **Typical Current Idle** (prevenir o bug de crash em idle)
+ Global C-State Control: **Desabilitado** (evita dormir profundo, causando instabilidade)
+ DF C-States: **Desabilitado** (também evita dormir, melhorando latência da Infinity Fabric)
+ XMP/EXPO: **Profile XMP1** se tiver (aumenta clock da memória)

Tem 2 coisas importantes, especialmente se estiver usando GPUs discretas:

* Above 4G Decoding e Re-Size Bar Support. No meu caso ambas estão ligadas por padrão, se na sua estiver desligada, ligue.

No Linux, dá pra checar se está ligada. Rode o seguinte:

`sudo lspci -vv | grep -A 15 VGA`

Tem que aparecer "Resizable BAR" assim:

`Capabilities: [XX] PCI Express, ... Resizable BAR: Supported (Enabled)`

Se não aparecer, vá pra BIOS e procure pra habilitar. Sem isso você não está usando o máximo da sua placa de video. Acho que em iGPUs (que são GPUs que já vem embutida junto com a CPU) aí não tem essa opção mesmo.

## Kernel Linux-Zen

Em sempre estive usando a kernel padrão LTS mais estável, agora era Linux66, se não me engano. Mas lembrei que posso usar a kernel Zen, que é a mesma kernel padrão do Arch com tunings de performance pra melhorar latência, especialmente em multi-thread. Ele muda pro scheduler CFS com melhorias. Teoricamente, melhora a responsividade geral do sistema. Acho que vale a pena usar. No Arch/Manjaro é assim:

`yay -S linux-zen-versioned-bin linux-zen-versioned-headers-bin`

Isso vai desinstalar a kernel antiga e, se estiver usando GPUs NVIDIA, também vai desinstalar o pacote de drivers. Por isso precisa instalar o seguinte pacote também:

`yay -S nvidia-dkms`

E depois, com tudo instalado, rodar o seguinte comando:

`sudo dkms autoinstall`

Isso vai instalar de novo os binários dos drivers da nvidia pro novo kernel Zen. No caso do Manjaro, não precisa mexer no GRUB porque no meu caso ele está configurado pra `GRUB_DEFAULT=saved` em `/etc/default/grub`. Isso significa que quando reboota, ele vai gravar qual kernel eu escolhi por último, e no próximo reboot, se eu não escolher nada, vai carregar de novo o último kernel que eu escolhi. Prefiro assim do que deixar "hard-coded" qual kernel é o padrão.

Feito isso, no próximo boot só checar:

```
❯ uname -r
6.14.2-zen1-1-zen
```

Outra coisa é checar se **CPPC** está ativo. Isso é **Collaborative Processor Performance Control** que é uma funcionalidade que expõe pra kernel do OS um ranking de cores (qual tem boost mais alto, quem tem mais cache, etc). Lembra o X3D Turbo Mode que falei antes? Mesmo conceito: pra facilitar o OS escolher pra qual core mandar qual programa pra rodar melhor.

Nem todo firmware de placa-mãe expõe isso como uma opção, no caso do meu X670E da Gigabyte, ele não existe. Significa que provavelmente já vem ligado por padrão. Pra checar se está ligado, basta ir no terminal do Linux e rodar:

```
cat /sys/devices/system/cpu/cpu*/cpufreq/amd_pstate_highest_perf
```

Se voltar algum resultado, é porque está ligado e o firmware está informando pra kernel sobre as características de cada core, assim o scheduler tem mais informação pra gerenciar pra onde mandar cada thread.

Outra forma de checar:

```
ls /sys/devices/system/cpu/cpu0/cpufreq/
```

Precisa retornar uma lista contendo nomes como estes:

```
amd_pstate_highest_perf
amd_pstate_nominal_perf
amd_pstate_preferred_core
```

Que, novamente, é sinal que o Linux está reconhecendo CPPC direito.

O próprio Manjaro, além das kernels estáveis, tem as versões "linux-rt" que é pra sistemas real-time. Tecnicamente, não só é pra ter latência mais baixa, mas sim latências estáveis e mais previsíveis. **NÃO USE ESSE TIPO DE KERNEL**. Isso é pra sistemas de fábrica ou coisas assim que precisam de determinismo do processamento e não tem tolerância pra latência aleatória. Não significa que vai rodar mais responsivo, pode até ser que rode mais lento, mas o importante é ser um lento previsível.

Outros podem falar da kernel **Linux Liquorix**, que muitos comparam com a Zen. Mas enquanto a Zen é baseada no próprio kernel que o Arch usa, o do Liquorix é baseada na versão de Debian/Ubuntu. Então não é recomendado usar no Arch/Manjaro. Além disso ele é mais experimental e teoricamente menos estável também. Use se estiver num Ubuntu ou derivados da vida. Em Arch, melhor ficar no Zen.
## check_ryzen_perf.sh

Se tiver um sistema Ryzen, copie o seguinte script e rode na sua máquina:

```bash
#!/bin/bash

echo "🔍 Verifying Ryzen 7950X3D Tuning on Linux"

echo -n "✅ CPU Driver: "
grep . /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver

echo -n "✅ EPP Mode: "
cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference

echo -n "✅ CPPC Detected: "
if [ -f /sys/devices/system/cpu/cpu0/cpufreq/amd_pstate_highest_perf ]; then
  echo "Yes"
else
  echo "No"
fi

echo -n "✅ Preferred Core Ranking: "
if [ -f /sys/devices/system/cpu/cpu0/cpufreq/amd_pstate_prefcore_ranking ]; then
  echo "Yes"
else
  echo "No"
fi

echo -n "✅ Running Kernel: "
uname -r

echo -e "\n✅ All key Linux-side Ryzen tuning options appear active.\n"
```

Na minha máquina ele agora dá este resultado:

```
🔍 Verifying Ryzen 7950X3D Tuning on Linux
✅ CPU Driver: amd-pstate-epp
✅ EPP Mode: performance
✅ CPPC Detected: Yes
✅ Preferred Core Ranking: Yes
✅ Running Kernel: 6.14.2-zen1-1-zen

✅ All key Linux-side Ryzen tuning options appear active.
```

Dizendo que, teoricamente, tudo de performance parece estar ativo e funcionando. Caso um deles não esteja, pergunte ao ChatGPT o que fazer pra sua configuração.

## Checar versão da BIOS

Muitos fabricantes de placa-mãe oferecem software, pra Windows, pra automaticamente baixar e atualizar o firmware. Mas no caso da Gigabyte, não tem suporte pra Linux. Pra checar que versão está instalada agora, sem precisar entrar na BIOS, no Linux tem este comando:

`sudo dmidecode -s bios-version`

No meu caso, agora volta F33 (versão de março de 2025). Agora, pra comparar se essa é a versão mais nova, só indo manualmente na porcaria do site da Gigabyte que, no meu caso, é [este link](https://www.gigabyte.com/Motherboard/X670E-AORUS-XTREME-rev-10/support). Pro seu modelo específico, e fabricante, lógico, esse link vai variar.

[![x670e support page](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/72l1if05q22u1ogowfzws9rtz95j)](https://www.gigabyte.com/Motherboard/X670E-AORUS-XTREME-rev-1x/support#support-dl)

Pra piorar, parece que o conteúdo é carregado assincronamente por javascript, então se tentar usar `wget`ou `curl` pela linha de comando, não vai ter carregado o conteúdo ainda.

Resolvi fazer um script idiota pra resolver isso. Primeiro, caso não use `mise` como eu (veja meu projeto no Github [Omakub-MJ](https://github.com/akitaonrails/omakub-mj) pra ter um setup igual o meu), instale Node manualmente assim:

`sudo pacman -S nodejs npm`

Crie algum diretório pro projeto e de lá faça:

```
npm init -y
npm install -g playwright
npx playwright install
```

Crie um arquivo `check_bios_playwright.js` com este conteúdo:

```js
const { chromium } = require('playwright');

(async () => {
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage();

  // Load support page
  await page.goto('https://www.gigabyte.com/Motherboard/X670E-AORUS-XTREME-rev-10/support', { waitUntil: 'domcontentloaded' });

  // Click the BIOS tab manually (it triggers JS to fetch content)
  await page.click('id=bios-count');

  // Wait for BIOS version element to load
  await page.waitForSelector('.div-table-body-BIOS .download-version', { timeout: 60000 });

  // Grab the first BIOS version listed
  const biosVersion = await page.$eval('.div-table-body-BIOS .download-version', el => el.innerText.trim());

  console.log('🌐 Latest BIOS Version on Gigabyte site:', biosVersion);

  await browser.close();
})();
```

Agora crie um script bash `check_bios_update.sh` com este conteúdo:

```bash
#!/bin/bash

# Get directory of this script (absolute path)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get current BIOS version
CURRENT=$(sudo dmidecode -s bios-version | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')

# Run the Playwright JS script in the same directory
LATEST=$(node "$SCRIPT_DIR/check_bios_playwright.js" | grep -o 'F[0-9]\+')

# Output
echo "🖥  Current BIOS: $CURRENT"
echo "🌐 Latest BIOS:  $LATEST"

if [[ "$CURRENT" == "$LATEST" ]]; then
  echo "✅ You are up to date."
else
  echo "⬆  BIOS update available!"
fi
```

Faça um `chmod +x` pra tornar executável e, se tudo der certo, terá uma resposta como esta:

```
[sudo] password for akitaonrails:
🖥  Current BIOS: F33
🌐 Latest BIOS:  F33
✅ You are up to date.
```

É um tiro de canhão pra matar uma mosca, mas isso vai usar o Chromium headless pra puxar a página, carregar o javascript e aí usar seletores de CSS pra achar a versão da BIOS, comparar com o da sua máquina e ver se está atualizado.

Caso não esteja, não tem jeito, tem que ir manualmente no site, baixar o arquivo ZIP, extrair num pen drive e bootar na BIOS pra atualizar manualmente. Mas pelo menos consigo checar rapidamente de tempos em tempos só com uma linha de comando agora.

## Checagem automática de versão de BIOS

Resolvi que não quero lembrar rodar esse script manualmente, então a melhor coisa é criar um serviço systemd de usuário, e checar automaticamente toda semana. Se tiver versão nova, criar uma notificação ao GNOME pra eu poder ver visualmente e automaticamente mandar abrir a página de download pra mim.

Primeiro, preciso fazer meu usuário ter acesso ao comando dmidecode pra checar a versão atual da minha BIOS sem precisar digitar senha com `sudo`, pra isso vamos criar uma nova regra de sudoers assim:

```
sudo visudo -f /etc/sudoers.d/bios-check
```

Vai abrir um arquivo vazio onde preencho assim:

```
sudo /usr/sbin/dmidecode -s bios-version
```

E não esquecer de colocar a permissão correta nesse arquivo:

```
sudo chmod 0440 /etc/sudoers.d/bios-check
```

Com isso não vai mais pedir senha pra rodar esse comando, já que vamos colocar num serviço em background rodando automaticamente. Obviamente não é seguro permitir rodar `sudo` sem senha, por isso limitamos exclusivamente pra permitir isso somente nesse binário específico e nada mais.

No mesmo diretórios dos outros arquivos com playwright instalado e tudo mais, crio um `bios-update-check.sh` com este conteúdo:

```bash
#!/bin/bash

# Path to your Playwright BIOS scraper script
JS_CHECKER="$HOME/bios-check/check_bios_playwright.js"
NODE_BIN="$(which node)"

# URL of your motherboard's BIOS support page
URL="https://www.gigabyte.com/Motherboard/X670E-AORUS-XTREME-rev-10/support#support-dl-bios"

# Get current BIOS version
CURRENT=$(sudo dmidecode -s bios-version | tr -d '[:space:]' | tr '[:lower:]' '[:upper:]')

# Get latest BIOS version from Gigabyte site
LATEST=$($NODE_BIN "$JS_CHECKER" | grep -o 'F[0-9]\+' | head -1)

if [[ -z "$LATEST" ]]; then
  notify-send "BIOS Check" "⚠️ Failed to fetch latest BIOS version from Gigabyte"
  exit 1
fi

if [[ "$CURRENT" != "$LATEST" ]]; then
  notify-send -u normal "🔔 BIOS Update Available!" "Current: $CURRENT → Latest: $LATEST

Opening the download page..." --app-name="BIOS Checker"
  xdg-open "$URL"
fi
```

É a mesma coisa do script anterior mas agora usando `notify-send` pra mandar mensagens pro Gnome (em KDE é diferente) e usando `xdg-open` pra abrir a URL no navegador default do sistema. Configure diferente pro seu sistema. Não esquecer de tornar executável e testar:

```
chmod +x ~/.local/bin/bios-update-check.sh
```

Agora é criar o serviço systemd pro meu usuário (diferente de criar um pra sistema que roda com mais permissões. Só preciso disso rodando no nível do meu usuário), então crio o arquivo `~/.config/systemd/user/bios-check.service` com o seguinte conteúdo:

```
[Unit]
Description=Weekly BIOS version checker

[Service]
Type=oneshot
ExecStart=/home/akitaonrails/.local/bin/bios-check/bios-update-check.sh
```

Agora o serviço de timer pra rodar toda semana chamado `~/.config/systemd/user/bios-check.timer`:

```
[Unit]
Description=Run BIOS version check weekly

[Timer]
OnCalendar=weekly
Persistent=true

[Install]
WantedBy=default.target
```

E habilitar o timer:

```
systemctl --user daemon-reexec
systemctl --user daemon-reload
systemctl --user enable --now bios-check.timer
```

Por convenção no Systemd, um timer [blabla].timer vai executar o serviço com mesmo nome [blabla].service. Por isso precisa dos dois. Se você habilitar o serviço direto, ele vai rodar só uma vez e sair. Pra saber se tá ativado certo faça o seguinte:

```
✦ ❯ systemctl --user list-timers

NEXT                          LEFT LAST PASSED UNIT             ACTIVATES
Mon 2025-04-21 00:00:00 -03 2 days -         - bios-check.timer bios-check.service

1 timers listed.
Pass --all to see loaded but inactive timers, too.
```

E é assim que você pode automatizar algumas coisas no seu sistema e aproveitar seu Gnome melhor.

## Conclusão

Só comecei essa jornada desta vez porque me ocorreu que fazia meses que eu não atualizava o firmware da placa-mãe e aí aproveitei pra tunar algumas coisas que não tinha feito antes. Coisas como PBO estava no automático (então eu estava deixando performance pra trás, lembro que da última vez tinha ficado instável mas eu não fui atrás pra saber porque), coisas como XMP/EXPO já tava ligado. Mas agora eu acho que realmente liguei tudo que podia.

Também fazia anos que eu não experimentava a kernel Linux-Zen, então já aproveitei pra testar agora. E como falei, por enquanto tá estável. Como comecei a aprender Blender e puxar mais CPU e memória, achei que valia a pena gastar um tempo tentando extrair o máximo da minha máquina. Modelagem 3D é totalmente CPU/RAM, mais que GPU. 

Ah sim, falando em Blender, uma última coisa. Lembra que meu Ryzen tem 1 CCD, que é aquele 1 die com 96MB de cache L3. Melhor coisa a fazer é criar afinidade do Blender com esse die e evitar que ele caia no core com só 32MB de cache L3.

No Linux, pra fazer isso, é esta linha de comando:

`taskset -c 0-15 blender-4.3 &`

O comando taskset vai dar dica pro scheduler que o blender deve ficar nas threads de 0 a 15 (onde tem V-Cache) e não de 16 a 31 (que só tem 32MB). Dessa forma, em teoria, estou dando as maiores chances ao Blender de funcionar na melhor performance possível nesta máquina. Programas pouco importantes como o navegador, terminal, se cair no core de 32MB, não tem problema.

Eu faço a mesma coisa no libvirt/qemu quando rodo Windows emulado: eu configuro o libvirt pra subir a VM atrelado ao CCD de 96MB e deixo o outro core pro Linux host. Aliás, falando em BIOS, pra rodar VMs tem que habilitar SVM e IOMMU, que costumam vir desligados porque suporte a máquinas virtuais rouba um pouco da performance da CPU. Máxima performance é com eles **desligados**. Se você não vai usar VMs, deixe desligado.

E se alguém notou que estou rodando explicitamente o Blender 4.3 em vez do mais novo Blender 4.4 é porque alguns addons ainda não funcionam na versão mais nova, então é melhor ficar uma versão pra trás pra ter mais compatibilidade com addons que não atualizam rápido.
