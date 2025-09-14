---
title: Coisas que "Iniciantes" Ignoram sobre PCs
date: "2025-09-14T01:00:00-03:00"
slug: coisas-que-iniciantes-ignoram-sobre-pcs
tags:
  - cpu
  - gpu
  - nvme
  - microSD
  - nvidia
  - amd
  - noctua
  - ryzen
draft: false
---

Faz tempo que eu queria escrever este artigo, mas sempre tive preguiça porque é o tipo de artigo onde algumas partes vão envelhecer logo. Isso porque vou mencionar alguns componentes de 2025, mas daqui 2 ou 5 anos já vai ter mudado, então leiam levando em consideração o ano que estiver lendo, caso esteja no futuro.

Eu recebo dezenas de perguntas iguais quase todos os dias e em resumo todos se parecem com _"qual computador recomenda pra mim?"_ E não existe resposta pra isso. Eu não sei porque alguém pensa que teria uma resposta. Sempre cai no problema de [validação](https://akitaonrails.com/2016/04/20/off-topic-se-voce-precisa-de-validacao-provavelmente-esta-errado/) que eu tanto explico.

Todo mundo tem que saber todo componente que tem num PC e quais as direrenças e como isso afeta ou não afeta pro seu caso de uso específico. No geral a regra é simples: se tiver dinheiro sobrando, compre o modelo mais caro de todos. Preço é quase sempre proporcional à qualidade do que comprou.

Se não tiver dinheiro sobrando e ainda assim precisa de um PC, compre exatamente o que puder gastar e tire o máximo disso.

### CPUs

CPUs basicamente você olha clock base e quantidade de cores. Não vai fugir muito disso. Sempre compre o mais recente, se puder.

Clock base é a velocidade que sua CPU vai performar "normalmente". Boost clock é nas raras vezes que estiver processando algo pesado, como recompilar a kernel do Linux, ou algum jogo pesado.

![Threads](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250913164642_screenshot-2025-09-13_16-46-15.png)

Não confundir cores com threads. Cores ou núcleos são componentes físicos na CPU que permitem executar mais de uma thread ao mesmo tempo. Em cima disso existe funcionalidades como Hyperthread, onde otimizamos usando o conceito que raramente todos os cores estão ocupados o tempo todo, então o OS enxerga um core físico como tendo capacidade pra até 2 threads.

Por isso na imagem acima, estamos vendo meu **Ryzen 9 7850x3D**, que tem 16 cores físicos, aparecendo como se tivesse 32 threads. Mas é impossível usar todas as 32 em 100% de capacidade.

Ter vários aplicativos abertos não significa que cada um vai estar ocupando uma core. O OS move processos entre cores conforme estratégia do **Scheduler**. Assista minha mini-série sobre **Concorrência e Paralismo**, [Parte 1](/2019/03/13/akitando-43-concorrencia-e-paralelismo-parte-1-entendendo-back-end-para-iniciantes-parte-3/) e [Parte 2](2019/03/20/akitando-44-concorrencia-e-paralelismo-parte-2-entendendo-back-end-para-iniciantes-parte-4/). Se for programador, é obrigatório entender isso.

Outras funcionalides que depende da CPU é suporte de **PCI Express** ou **PCIe**. Esse é o bus, ou barramento, de comunicação entre a CPU e diversos dispositivos de alta velocidade, como a GPU ou SSD/NVME - já vou falar deles. Vamos entender:

* **PCIe 4.0** foi lançado no meio de **2017**, então evite comprar CPUs anteriores a isso, vai ser muito mais lento. Ela nasce no AMD Ryzen 3000 e chipset X570. Banda de aproximadamente **2GB/s** (~16 GT/s)

* **PCIe 5.0** foi lançado no meio de **2019**, portanto, se puder, prefira CPUs depois desse ano. Ela nasce no Intel Alder Lake e AMD Ryzen 7000. Banda de aproximadamente **4GB/s** (~32 GT/s), sim é o **dobro** de PCIe 4.0.

Agora dois conceitos importantes. Primeiro **PCI Lanes**:

* Um "lane" (tipo uma "pista") é um par de sinais diferenciais TX/RX, tecnicamente falando.
* CPU/chipsets (chipset significa "conjunto de chips") expõe um número **fixo** de lanes (varia de 20 a 28, mais que isso gera gargalo no chipset).
* PCIe não varia a quantidade de lanes e sim a banda de cada lane.

Exemplos:

* AMD Ryzen 7000 (AM5): 24 PCIe 5.0 lanes do CPU (16 pro GPU, 4 pra NVMe, 4 pro chipset).
* Intel Alder Lake/Raptor Lake: 16 PCIe 5.0 lanes pra GPU + 4 PCIe 4.0 pra storage.

PCI Lanes são importantes pra GPU e pra NVME. "SSDs" são outro barramento: SATA, depois falo disso. Se o plano é comprar uma GPU moderna e poderosa, tipo uma AMD Radeon 9070 XT ou NVIDIA RTX 5090, vai precisar de PCIe 5.0 com o máximo de lanes e banda disponível pra elas (16 lanes). Isso afeta também a escolha de placa-mãe.

Muita gente pensa em comprar CPUs de servidor, como Intel Xeon ou AMD EPIC. Cuidado. A idéia é tentar achar no eBay um que já tenha sido descartado mas ainda funciona. A "vantagem" é que CPUs de servidor costumam ter muito mais cores do que CPUs nível consumidor.

Um Intel Xeon costuma ter **60 cores/120 threads** ou um AMD EPIC costuma ter **96 cores/192 threads**, mesmo modelos velhos como um Xeon Platinum/Gold (era Skylake de 2017) tem de 20 a 28 cores. Um AMD EPIC 7001 de 2017 tem 32 cores. Se conseguir achar usado, barato num eBay, não vale a pena?

Na prática: **NÃO**.

Só pra usos muito específicos. Por exemplo, se for montar um servidor de armazenamento, um NAS, com ZFS, que tira vantagem de múltiplos cores, precisa de **MUITA RAM**, mas a banda pros discos não precisa ser absurdamente grande. Vamos ver as desvantagens:

* esses CPUs velhos que tem preços considerados "acessíveis" vão ser de 2017 pra trás, ou seja, **PCIe 3.0**, banda mais lenta por lane.
* base clock vai ser baixo. Num CPU médio, fica acima de 2Ghz, num antigo vai ser abaixo de 2Ghz. Um com CPU hoje tem base clock de 4Ghz.
* alto TDP (Thermal Design Power). Na prática, vai ser mais lento e ainda assim vai consumir mais energia e dissipar MUITO calor. Ou seja, são altamente ineficientes hoje.
* não basta ter a CPU barata, elas precisam de **placas-mãe** específicas com sockets LGA 3647, SP3, SP5. São caras e não são formato ATX, então não cabem em qualquer gabinete.
* RAM precisa ser ECC RDIMM/LRDIMM. ECC significa Error Correction Code. São RAMs mais caras que garantem que não vai existir bits corrompidos, por isso são obrigatórios em servidores. Nível consumidor não precisa disso. Nas raras vezes que RAM corromper, vai dar uma tela azul e você só reboota. Por isso são mais baratas também.
* Não tem várias funcionalidades comuns em CPUs pra consumidores. Não tem iGPU (GPU integrada), não dá pra fazer nenhum tipo de overclocking, tem suporte mais fraco a AVX 512 (vai ter problemas com video, áudio modernos).

De novo, só vale a pena se você sabe exatamente todos os detalhes e tem uma aplicação MUITO específica em mente que tire vantagem desse tipo de CPU e não vai sentir falta do que ele não tem. Se você é amador, nem tente.

Na prática, eu dou preferência a CPUs AMD. A série Ryzen tem seguidamente sido bem eficiente. A nomenclatura de nomes de CPUs é coisa que marketeiro adora criar confusão, porque quanto mais confusão, mais fácil enganar consumidor. Isso vai ser um tema constante neste artigo, prestem atenção.

Depende de cada nova arquitetura, mas em geral:

**Nomenclaturas AMD**

Formato: Ryzen [3/5/7/9] [####] [sufixo]

* Tier (3 / 5 / 7 / 9): performance class.
 	* Ryzen 3: entry (4–6 cores).
 	* Ryzen 5: midrange (6–8 cores).
 	* Ryzen 7: high-end (8–12 cores).
 	* Ryzen 9: enthusiast (12–16 cores desktop; até 64 cores no Threadripper/EPYC).

* Primeiro Dígito: geração/arquitetura.
 	* 1 = 1st gen (2017, Zen),
 	* 5 = 5th gen (Zen 3),
 	* 7 = 7000 series (Zen 4),
 	* 9 = 9000 series (Zen 5).

* Dígitos do Meio: modelo dentro da geração. Maior = mais rápido (ex., 7600 vs 7900).

* Sufixos:
 	* X = higher TDP, higher clocks.
 	* G = integrated GPU.
 	* X3D = 3D V-Cache (bom pra games).
 	* HS / U / HX (mobile) = laptop power targets (U = ultra-low, HS = balanced, HX = high-performance).

**Nomenclaturas Intel**

* Formato Antigo (pre-2024): Core i3/i5/i7/i9-#### [sufixo]
 	* i3 / i5 / i7 / i9 = entrada → alto nível.
* Dígitos:
 	* Primeiro = geração (e.g. i7-8700 = 8th gen).
 	* Resto = SKU dentro da geração (8700 vs 8700K).
* Sufixos:
 	* K = desbloqueado (overclockable).
 	* F = sem iGPU.
 	* KF = desbloqueado + sem iGPU.
 	* T = baixa energia.
 	* H / HK = laptop alta-performance.
 	* U / Y = ultra-baixa energia.

* Novo Formato (2024+, Meteor Lake / Arrow Lake):
 	* Core Ultra 5 / 7 / 9 (drops “i”).
 	* Mesmos tiers: Ultra 5 = midrange, Ultra 9 = top.
 	* Adiciona sufixos “H/U” pra classe de energia de laptop.

Eu tenho uma "antiga" (ainda muito performática) Ryzen 9 7850X3D que é Zen 4, 16 cores/32 threads, 3D V-Cache que é bom pra jogos. O equivalente mais novo é a **9850X3D**, que é arquitetura mais nova Zen 5 (está pra sair Zen 6).

No mundo notebook, mobile/console/handhelds saiu a linha **Ryzen AI MAX/MAX+** que tem CPU+GPU+NPU integradas na onda de acelerar tarefas de redes neurais, rodar **pequenos** modelos de IA. A Ryzen AI Max+ 395 é Zen 5, integrada com GPU Radeon, até 40 CUs (mais ou menos equivalente da AMD a Nvidia Cuda Cores). A vantagem é ter acesso a mais RAM/VRAM pra carregar modelos mais pesados, mas não vai ser rápido porque CPU desktop ainda é melhor, obviamente. Em notebook você sempre vai estar limitado por solução térmica.

O maior problema de consoles/notebooks/handhelds é que não dá pra fornecer tanta energia (TGP) quanto desktop porque não tem pra onde dissipar tanto calor. Por isso notebook **sempre** vai ser mais limitado do que desktop. Isso dito, se puder pagar, recomendo a Ryzen AI Max, parecem bons chips mesmo.

Se tem dúvidas sobre sua CPU e estiver num Linux, dá pra checar assim:

```bash
❯ lscpu
Architecture:                x86_64
  CPU op-mode(s):            32-bit, 64-bit
  Address sizes:             48 bits physical, 48 bits virtual
  Byte Order:                Little Endian
CPU(s):                      32
  On-line CPU(s) list:       0-31
Vendor ID:                   AuthenticAMD
  Model name:                AMD Ryzen 9 7950X3D 16-Core Processor
    CPU family:              25
    Model:                   97
    Thread(s) per core:      2
    Core(s) per socket:      16
    Socket(s):               1
    Stepping:                2
    Frequency boost:         enabled
...
```

De curiosidade, já expliquei isso [neste video](https://akitaonrails.com/2021/05/13/akitando-97-so-precisamos-de-640-kb-de-memoria-16-bits-ate-64-bits/) mas, apesar da arquitetura ser 64-bits, note como endereços de memória são **48 bits**, porque nem existe forma em hardware de conseguir ter tanta RAM pra precisar de 64-bits. Então é mais eficiente economizar transistor e usar um endereço menor.

Também expliquei as nuances de se ter muitos cores e como Cache L3 influencia seu funcionamento no artigo de [GPU Passthrough](https://akitaonrails.com/2023/02/01/akitando-137-games-em-maquina-virtual-com-gpu-passthrough-entendendo-qemu-kvm-libvirt/)

### Placas-mãe

Esse é outro buraco de coelho desgraçado. Eu mesmo tenho dificuldades de escolher. Cada modelo de CPU tem diversas opções de placa-mãe. Você tem que escolher uma que é compatível com sua CPU (que tem socket que encaixa, na prática) e, de preferência, quando sair a próxima versão de CPU, seja possível fazer upgrade.

Isso depende do ano em que está comprando. Se estiver no começo de um ciclo de arquitetura de CPU, ainda deve vir novas CPUs da mesma arquitetura por alguns anos. Se estiver no fim de um ciclo, arrisca comprar uma CPU e placa-mãe que vai ficar obsoleta no ano que vem. Quando quiser dar upgrade, vai ter que trocar os dois. Isso não tem guia, você tem que procurar o **roadmap** da Intel e AMD pra checar.

Por exemplo, ano que vem a Intel vai lançar a nova arquitetura [Nova Lake](https://www.tomshardware.com/pc-components/cpus/intel-confirms-arrow-lake-refresh-set-for-2026-nova-lake-later-that-year-company-admits-there-are-holes-to-fill-on-the-desktop-front-says-it-is-confident-in-the-roadmap) pra substituir o Arrow Lake. Possivelmente não vai funcionar em placas-mãe atuais, não sei ainda.

Notebooks você não tem esse problema porque não existe upgrade de CPU. Quando sair um novo, se troca o notebook inteiro mesmo.

Placas-mãe você começa escolhendo o **FORMATO**. O mais comum pra gabinetes de torre, aqueles que se vê no Instagram de gamers com RGB pra lá e pra cá costumam ser o tamanho grande, que é **ATX**.

![moba form-factor](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250913172430_Motherboard-Form-Factor-Size-Comparison.webp)

Mas existem outros formatos. Tem um maior que é "Extended ATX", tem um menor que é "Micro-ATX", tem menor ainda que é "micro-ITX". Eu nunca vi mas parece que ainda tem uma maior de todas que é "XL-ATX". Mini-PCs que vem tudo integrado tem placas-mãe proprietárias de cada fabricante, como Minisforum ou Beelink, que vou falar na última seção mais pra baixo.

Quanto menor a placa-mãe, menos funcionalidades vai ter, em resumo costuma ser: menos slots de PCIe (acaba sobrando só uma pra GPU, normalmente). Menos slots de RAM.

Daí vai depender de que gabinete vai escolher, que espaço tem em cima ou embaixo da sua mesa. Na prática, se não entende nada disso, compre ATX. Vai dar menos dor de cabeça. Boas marcas de gabinete costumam ser Lian Li ou Fractal, mas tem dezenas por aí, tem que prestar muita atenção na montagem, encaixes, funcionalides, etc. Tamanho de radiador de AIO, coolers, tamanho da placa-gráfica, etc.

**Mini-ITX** é só pra quem sabe o que está fazendo. Eis um exemplo da Fractal:

[![fractal mini-itx case](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250913173009_QMNn4zsBtHPm5DRCMibZcE.jpg)](https://www.pcgamer.com/best-mini-itx-case/)
Tem três problemas principais: não cabe qualquer placa-gráfica. não cabe qualquer fonte (power supply/PSU), precisa de muito mais ventilação/solução térmica (porque não tem espaço pra dissipar o calor dentro).

Alguém vai chegar e comentar _"ah, só colocar resfriamento com água"_. Não é tão simples assim.

Resfriamento a água (AIO) precisa de manutenção, usar bons líquidos de resfriamento (não necessariamente água, tem dissipadores melhores hoje). E depende do modelo, porque tem tanque de líquido, tem canos por onde esse líquido passa, portanto **OCUPA MUITO MAIS ESPAÇO**. Em um gabinete ATX funciona, em ITX raramente.

Além disso, veja o tamanho de uma RTX 5090:

[![RTX 5090](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250913173748_960x0.jpg)](https://www.forbes.com/sites/antonyleather/2025/01/07/nvidias-rtx-5090-is-so-small-its-compatible-with-tiny-pc-cases/)
Essa é da **MSI**. Mas tem outros integradores como Gigabyte, Gamerock, Zotac, a Founders Edition da própria NVIDIA e outros. Cada um vai ter um formato e tamanho **diferentes**, precisa pesquisar exatamente o modelo, de qual fabricante, com qual gabinete que vai caber. Mesmo em gabinetes ATX, nem sempre cabe na horizontal. Além de ocupar o espaço de 2 slots (série 40) ou 3 slots (série 50) na vertical.

Além disso tem que pensar: você quer uma workstation de trabalho pra coisas como edição de video? Precisa ver se sua placa-mãe já vem com pelo menos Ethernet 2.5 Gbps, idealmente 10 Gbps. A maioria dos populares ainda está com o obsoleto 1 Gbps.

Pra maioria das pessoas, que só tem plano de internet abaixo de 1Gbps, não tem problema, nem vai saturar a banda. Mas quem trabalha com video precisa ter streaming de video PESADO, estou falando acima de **100 GB por hora de video**, múltiplos videos na timeline, tocando ao mesmo tempo. Menos em 2.5 Gbps fica difícil editar em tempo real de playback.

Se acabar comprando uma placa-mãe velha com 1 Gbps de Ethernet, vai precisa comprar uma placa de rede PCIe separada. Só que se estiver usando um formato mini-ITX, **não vai ter espaço** ou nem vai ter slot extra pra plugar isso. Por isso tem que planejar o uso com antecedência.

A minha é velha, é uma **X670E AORUS XTREME**:

![X670E](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250913174531_D_NQ_NP_858736-MLU74688986203_022024-O.webp)

É formato ATX e tem quase todas as funcionalidades que preciso, incluindo porta Ethernet 2.5Gbps. Mas como eu quis colocar um roteador 10Gbps e também coloquei upgrade de 10Gbps no meu NAS **Synology DS1821+**, resolvi adicionar uma placa PCIe de Ethernet 10Gbps. Como é formato ATX, mesmo com minha RTX 4090 ocupando espaço de 2 slots na vertical, ainda sobra espaço embaixo.

Tem dúvida de qual é sua placa-mãe? Se estiver num Linux tem este comando:

```bash
❯ sudo dmidecode -t baseboard
# dmidecode 3.6
Getting SMBIOS data from sysfs.
SMBIOS 3.7.0 present.

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
 Manufacturer: Gigabyte Technology Co., Ltd.
 Product Name: X670E AORUS XTREME
 Version: x.x
 Serial Number: Default string
 Asset Tag: Default string
 Features:
  Board is a hosting board
  Board is replaceable
 Location In Chassis: Default string
 Chassis Handle: 0x0003
 Type: Motherboard
 Contained Object Handles: 0
...
```

Acho que `sudo dmidecode -t system` faz a mesma coisa.

Tem as pequenas coisas também: Windows 11 costuma exigir a existência de um chip **TPU 2.0** que também costuma ser opcional na maioria dos modelos de placa-mãe. É bom ter, ou compre uma que já vem, ou compre separado e encaixe.

Alguns modelos não suportam overclocking. Se você for um entusiasta de tuning, tem que checar quais modelos suportam. Coisas como **Secure Boot**, é bom ter. Isso qualquer bom modelo tem, mas se estiver querendo escolher uma velha, pra economizar, cheque se tem.

O ideal é ter portas como Thunderbolt 4.0, USB 4.0, mas se tiver pelo menos USB 3 Gen 2, já ajuda. Nem toda USB 3 é igual!! Tem gerações diferentes! Só porque tem porta azul não quer dizer que é veloz. Vou falar disso depois.

Ideal ter Wi-fi embutido também, pra evitar ter que comprar uma placa ou USB separado. Mas cuidado, a maioria ainda oferece só o obsoleto Wi-Fi 5. Já estamos em **Wi-fi 7**, um Samsung Galaxy moderno já suporta, por exemplo. Mas como sempre, se está acostuma às baixas velocidades dos planos de internet que tem por aí, de fato, até Wi-fi 5 funciona. Mas se quiser transferir grandes arquivos entre seus computadores e celulares, vai querer um Wi-fi 7 mais moderno, no mínimo Wi-fi 6.

Também não adianta nada ter Wi-Fi 7 no seu PC mas continuar usando roteador que a Vivo, Claro, te deram. Essas porcarias que eles dão pra você são totalmente obsoletos, Wi-fi 5 no máximo. Eu mesmo uso um **TP-Link BE9000 Wi-fi 7** e desligo o roteador Wi-Fi da Vivo.

![TP-Link](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250914031547_TP-Link-BE9300-Archer-BE550-Wi-Fi-7-Router-771x1024.webp)

### RAM DDR 5

Outra coisa importante pra ver na sua CPU e sua placa-mãe é qual tipo de RAM eles suportam. Como já falei antes, se quiser uma workstation de ponta, vai querer uma que suporte RAM ECC. Na prática, pra maioria de nós, não precisa de ECC. Só é mais caro, pras raras vezes que um raio cósmico conseguir flipar um bit e crashear seu sistema (é muito, muito raro).

Mais importante é escolher DDR 5. Mas tanto DDR 5 ou DDR 4 tem variações, só pra continuar complicando sua vida. Memória também tem **clock**!

Acho que a DDR 4 o mais veloz é 3200Mhz, o mais comum ainda é 2666Mhz. PCs mais velhos que 2014 vão ser DDR 3!! Cuidado!

Já DDR 5 começa em 4800Mhz e vai até uns 6000Mhz.

Se estiver num Linux dá pra saber as informações da sua assim:

```bash
# dmidecode 3.6
Getting SMBIOS data from sysfs.
SMBIOS 3.7.0 present.

Handle 0x0011, DMI type 16, 23 bytes
Physical Memory Array
 Location: System Board Or Motherboard
 Use: System Memory
 Error Correction Type: None
 Maximum Capacity: 128 GB
 Error Information Handle: 0x0010
 Number Of Devices: 4
...
Handle 0x0016, DMI type 17, 100 bytes
Memory Device
 Array Handle: 0x0011
 Error Information Handle: 0x0015
 Total Width: 64 bits
 Data Width: 64 bits
 Size: 48 GB
 Form Factor: DIMM
 Set: None
 Locator: DIMM 1
 Bank Locator: P0 CHANNEL A
 Type: DDR5
 Type Detail: Synchronous Unbuffered (Unregistered)
 Speed: 6000 MT/s
 Manufacturer: CORSAIR
...
```

Isso vai listar informações de cada pente de memória conectado ao barramento da placa-mãe. Com esse output (que está cortado pra não ficar longo demais) dá pra concluir que eu tenho 2 pentes de memória, cada um com **48 GB** e **6000 MT/s** de velocidade.

Eles são **Corsair Vengeance**, não-ECC, dando um total de **96 GB** de RAM DDR 5. Eu poderia colocar 128 GB ou mais, mas até hoje nunca consegui saturar esse tanto de memória, então vai aguentar assim por muito tempo ainda.

![vengeance](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250914022843_corsair-vengeance-rgb-ddr5-32gb-2x16gb-ddr5-6000-cl36-36-36-76-135v-amd-expo-intel-xmp-grey.webp)

Tem até RGB 🤣.

Pra maioria das pessoas eu diria que 16 GB é o novo mínimo e 32 GB é o "sweet-spot". Pra programadores que precisa subir muitos containers Docker pesados, só aí iria pra 64 GB.

## "Transfers" != "bytes"

Um detalhe. Quando falamos em DDR 4 3200 ou DDR 5 6000, não é 6000 **MB/s** e sim 6000 **MT/s**.

Eu odeio essa unidade, mas isso são "**Mega Transfers** por segundo". Quando falei de PCI Lanes, também é uma pegadinha. PCIe 5.0 diz ter 32 GT/s (32 **Giga TRANSFER**/segundo). Vamos traduzir.

> "Transfers" se refere a quantos símbolos crús (que não equivale a 1 byte) dá pra transmitir por segundo. No caso de PCIe lanes, eles são seriais, então 1 transfer é 1 símbolo pelo fio físico. Mas 1 transfer não é 1 byte!

No caso de PCIe Lanes:

* PCIe 3.0 - 8 GT/s aproximadamente 985 MB/s por lane
* PCIe 4.0 - 16 GT/s aproximadamente 1.9 GB/s por lane
* PCIe 5.0 - 32 GT/s aproximadamente 3.9 GB/s por lane

Pra começar DDR significa **Double-Data-Rate**, onde dados são transferidos nas duas bordas de cada clock. Portanto:

* 6000 MT/s é 3000 Mhz
* DDR 5 6000 é 3000 Mhz
* DDR 4 3200 é 1600 Mhz

Por que diabos se fala nessa unidade idiota de "mega-transfers" ou "giga-transfer"? Única e exclusivamente pra **marketing**, porque é o número maior. E consumidor é burro, ele escolhe o número maior.

### "GIBI-bytes" != "GIGA-bytes"

O marketing não acaba em "transfers". Já notou que você compra um SSD de **1 TERABYTE** mas quando pluga no Windows ele te fala que tem só uns "**931 GB**"?? Onde foram parar os outros 69 GB??

No mundo normal de computação, nós medimos dados na base 2. Portanto 2^10 = 1024. Se a unidade básica for "byte" então 1024 bytes é 1 KILO-byte. 2^100 é 1 MEGA-byte e 2^1000 é 1 GIGA-byte.

Qualquer programador iniciante entende isso. Mas a população em geral não, então todo fabricante de HDs, SSD, NVME e qualquer tipo de "storage" resolveu mudar tudo e dizer o seguinte:

* 1 KB = 1000 bytes
* 1 MB = 1000^2 = 1.000.000 bytes
* 1 GB = 1000^3 = 1.000.000.000 bytes

E a unidade correta, que seria KILOBYTE ou MEGABYTE eles renomearam pra essa coisa **HORRENDA** que é "KIBI-BYTE" ou "MIBI-BYTE" ou "GIBI-BYTE". E eu só tenho a dizer:

> "KIBI" de cú é rola!!!

Mas o marketing vai te dizer:

* 1 KiB = 1024 bytes
* 1 MiB =1024^2 = 1.048.576 bytes
* 1 GiB = 1024^3 = 1.073.741.824 bytes

Por isso que você compra um HD de 1 TB e o Windows (corretamente) diz 931 GiB. Pelo menos RAM e velocidade de rede tendem a ser as unidades binárias reais, então quando você compra um pente de "16 GB", na linguagem do marketing você comprou "16 GiB" mesmo. E quando falamos rede de 1 Gbps estamos falando de 1 GiB/s. Só armazenamento que é essa putaria.

### HDs vs SSDs vs NVME

Falando em armazenamento, precisa entender o seguinte:

* HDs mecânicos ainda existem, tem bom custo benefício, são confiáveis e razoavelmente velozes. Os melhores HDs são pau a pau com um SSD médio, porque no final ambos vão saturar o mesmo barramento, que é SATA.
* Se quiser realmente alta-performance, você vai usar NVMEs, que se ligam diretamente ao barramento PCIe 4.0 ou 5.0 da sua placa-mãe. Mas são bem mais caros.

Vamos lá:

* HDs mecânico é uma tecnologia que começou lá nos anos 50, quando poucos kilobytes precisavam de um rack inteiro do tamanho de um servidor inteiro de hoje. Como os Phoenix que você pode ver no canal do Usagi Electric.

[![Phoenix](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250913183146_screenshot-2025-09-13_18-31-35.png)](https://www.youtube.com/watch?v=IsgRKPPOMZI)

* Os HDs mais velozes de hoje são de **7200 RPM** (rotações dos discos por minuto) e velocidades que variam de 150 a 200 MB/s, com latência de 1 a 2 ms. A vantagem é que eles oferecem grandes volumes a preços atrativos (eu tenho vários de 20 TB no meu NAS). Mas a velocidade realmente não é mais moderno.

![HD Ironwolf](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250913184838_st20000nt001-seagate-hd-interno-sata-20tb-7200-rpm-ironwolf-pro-7dcb4490-jxvnesfrs7.webp)

* SSDs nasceram no fim dos anos 2000, Solid-State Drives porque não tem partes móveis, são como chips de RAM persistentes. Elas se conectam ao mesmo tipo de barramento que HDs mecânicos: **SATA III** (Serial ATA) e oferecem velocidade na faixa de 500 a 550 MB/s sequencial. O dobro de HDs mecânicos. E tem a vantagem de facilmente poder substituir um HD mecânico no mesmo barramento e ser compatível. Mas é isso: o teto é 550 MB/s.

![SSD Samsung](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250913184704_20-147-798-V01.webp)

* NVMEs SSD muitos confundem porque também podem ser chamados de "SSDs", afinal são "solid-state" mas de tecnologias diferentes. O correto seria dizer "SSD SATA" e "SSD NVME". NVME significa **Non-Volatile Memory Express**, que pra maioria das pessoas não quer dizer nada mesmo.

* NVMEs se ligam ao barramento PCIe, portanto o teto é a velocidade dos lanes de PCIe como falei antes. Em PCIe 3.0 o teto vai ser 3.5 GB/s (que já é 6x mais veloz que o mais veloz SSD SATA III). Em PCIe 5.0 o máximo teórico é 13 a 14 GB/s (muito difícil atingir tudo isso, a maioria fica na faixa dos 5GB/s mesmo). A latência cai de "ms" pra "µs" (milissegundo vs MICROssegundo).

![NVME](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250913184737_Samsung_980_PRO_PCIe_4.0_NVMe_SSD_1TB-top_PNr°0915.webp)

Ou seja SATA III está preso na faixa das centenas de MEGAbytes por segundo, já NVME sobe pra quase dezena de GIGAbyte por segundo. É uma ordem de grandeza de **70x**.

Vamos entender mais na prática:

* **PCIe 3.0 x4** (2015-2020) ~3.0 a ~3.5 GB/s (Samsung 970 EVO Plus, WD Black SN750)
* **PCIe 4.0 x4** (2020-2023) ~6 a 7.5 GB/s (Samsung 980 PRO, WD SN850X, Crucial P5 Plus)
* **PCIe 5.0 x4** (a partir de 2023) ~10 a 12GB/s em _pico_, não média (Crucial T700, Corsair MP700, Gigabyte Aorus Gen5 10000)

Entenda que essas velocidades são pra leitura **sequencial** de arquivos grandes e não pra leituras ou escritas **aleatórias** de arquivos pequenos. A velocidade diminui DRAMATICAMENTE em uso do dia a dia de verdade com arquivos pequenos.

Mesmo em 2025 ainda não é comum NVMEs PCI 5.0, todo mundo ainda usa **NVMEs PCIe 4.0**, portanto a velocidade máxima que se encontra hoje é na faixa dos 7 GB/s, mais comum perto dos 5 GB/s, que são os Samsung 980 PRO / 990 PRO, WD Black SN850X, Crucial P5 Plus / P3 Plus ou similares.

Mesmo com uma CPU e placa-mãe que suporte PCIe 5.0, você ainda vai plugar NVME PCIe 4.0 (não tem problema, porque são retro-compativeis). Mas não espere conseguir essa faixa acima de 10 GB/s sem pagar MUITO CARO. Simplesmente não compensa.

Muita gente ainda usa SSD: **fique longe dos genéricos** sem marca e baratos demais da AliExpress. É super comum ser só um adaptador de microSD card. E também não gosto de Kingston, essa marca já me deu muita dor de cabeça. Fique com marcas confiáveis como Samsung, Sandisk, Crucial, Western Digital e coisas assim.

![SSD SCAM](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250913185340_8tb-ssd-scam1-f849be8d05152279ce7ebb06c7b4a84c.webp)

Eu mesmo comprei um desses só pra demonstrar esse **GOLPE**, pelo Mercado Livre e postei stories no meu Instagram na época. É fácil de identificar: **são excessivamente baratos**. Acho que depois disso o MercadoLivre tentou ser mais esperto pra não vender isso, mas no AliExpress sempre tem.

Tem mais: NVMEs tem **diferentes tamanhos**:

![NVME sizes](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250913184910_m2-ssd-sizes.webp)

NVMEs se conectam no tal **slot M2** na placa-mãe. É um slot que dá acesso direto ao barramento PCIe, normalmente x4 (4 lanes).

O modelo mais comum é o **2280**. É o que a maioria dos PCs suporta. Mas dependendo do notebook, ou se for um handheld como o primeiro **Asus Rog Ally** e acho que também o Steam Deck, vai precisar de tamanhos menores como os modelos **2242** ou **2230**.

É um trade-off de tamanho físico por capacidade. **2242** se não me engano, tem capacidade máxima de 2 TB. Eu gosto de 4 TB ou 8 TB então precisa ser pelo menos um **2280**.

Tem mais problemas: marcas "baratas" são baratas porque tiram alguns componentes como **DRAM**. Pra funcionar rápido, precisa existir uma memória RAM pra servir e buffer e cache. Além disso, modelos baratos tem controladores porcaria. E isso diminui não só a velocidade, como a vida útil dos chips.

Não use modelos baratos, eles são proporcionalmente piores e vão ou corromper seus dados ou morrer cedo. Não existe almoço grátis. Novamente, fique com marcas conhecidas como Samsung. Samsung sempre é confiável.

### MicroSD Cards

Mesma coisa: **todo microSD sem marca ou barato é golpe**. Ele não tem a capacidade que anuncia, quando bate num teto começa a sobrescrever os dados do começo. Não confie.

Só compro Samsung. Mas não é tão simples assim. Lembra os caras do **marketing** dos TIBI-BYTES?? Pois é, eles atacam pra valer em microSD. Existem 3 diferenças: classes (capacidade), velocidade do barramento (BUS), notas de velocidade (Speed), confiabilidade! Sim! Vamos entender:

1. **Classes de Capacidade**

* **SDSC** (Standard Capacity): up to 2 GB (**obsoleto**).
* **SDHC** (High Capacity): 2–32 GB.
* **SDXC** (Extended Capacity): 32 GB–2 TB.
* **SDUC** (Ultra Capacity): up to 128 TB (**não comum ainda**).

2. **Bus Interface**

* **UHS-I**: up to 104 MB/s.
* **UHS-II**: up to 312 MB/s (linha extra de pinos).
* **UHS-III**: up to 624 MB/s (raro).
* **SD Express** (PCIe/NVMe): teórico ~985 MB/s+ (ainda nicho).

3. **Speed Ratings**

* Speed Class (**C**): C2 (2 MB/s), C4, C6, C10.
* UHS Speed Class (**U**): U1 (10 MB/s), U3 (30 MB/s).
* Video Speed Class (**V**): V6 → V90 (6–90 MB/s, sustentado).

4. **Application Class (A)**

* **A1**: ≥1500 IOPS read, ≥500 IOPS write, 10 MB/s sustentado.
* **A2**: ≥4000 IOPS read, ≥2000 IOPS write, 10 MB/s sustentado.

1. **Níveis de Confiança**

* Consumer grade: pra câmera e fones (o mais comum).
* High Endurance: pra escrita contínua (dashcams, câmeras de segurança).
* Industrial grade: suporta range maior de temperatura, desgasta menos, muito mais caro.

Na prática, procure sempre **SDXC**, **UHS-II** (ou UHS-I que é mais comum), **V90** (mais comum é abaixo de V30 mesmo). É isso que significa esse malditos códigos escritos num microSD:

![samsung microsd](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250913190622_microsd.jpeg)

Esse da foto da Samsung tem capacidade de 512GB, classe SDXC, barramento UHS-I (até 90 MB/s), velocidade U3 (30MB/s) (é esse ícone de um 3 dentro do U na imagem). Feito pra funcionar bem em câmeras ou fones ou handhelds da vida. Menos que isso é **ruim**.

Outro exemplo:

![comparison microsd](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250913190951_88555428f12eca2dab1110cac7de0a7079-micro-sd.rsquare.w400.webp)

Agora você consegue ler. O Samsung EVO Select de 512GB, SDXC, U3, A2, V30 e o da direita SanDisk Ultra 128GB SDXC, U1, A1, C10. Agora você sabe o que procurar e o que isso significa.

Mais importante é Speed Rating, muitos são classe C como C10 acima. Mas se o uso for pra gravar video em boa qualidade, sem engasgar, procure classe V como V90!

### USB vs Thunderbolt

Pra piorar a confusão de marketagem ainda tem USB e Thunderbolt. Vamos entender: primeiro de tudo ter conector USB-C não significa nada. USB-C é padrão do conector físico do cabo, só isso. Os dados que trafegam nela usam protocolos, e existem vários.

No caso de plug USB-A, que é o retangulo que tem lado certo pra encaixar e é o mais comum na parte de trás de um PC, alguns vem com cores diferentes:

* Preto → USB 2.0 (480 Mb/s).
* Azul → USB 3.0 / 3.1 Gen 1 / 3.2 Gen 1 (5 Gb/s).
* Verde-azulado / Turquesa → USB 3.1 Gen 2 / 3.2 Gen 2 (10 Gb/s).
* Vermelho → porta de alta energia (quase sempre USB 3.2 Gen 2, algumas vezes “always-on charging”).
* Amarelo / Laranja → Também porta “charging”, depende do fabricante.
* Branco → Legado / BIOS flashback (quase sempre USB 2.0).

![usb ports](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250914024147_11166Image10_zoom.jpg)

**Confusão de Nomenclatura**

* USB 3.0 (2010) → depois renomeado pra USB 3.1 Gen 1 → daí pra USB 3.2 Gen 1 (5 Gb/s).
* USB 3.1 (2013) → agora USB 3.2 Gen 2 (10 Gb/s).
* USB 3.2 (2017) → USB 3.2 Gen 2×2 (20 Gb/s).
* USB4 (2019) → 20–40 Gb/s, mesmo conector físico de USB-C, Thunderbolt-like.
* USB4 v2 (2022) → até 80–120 Gb/s, ainda sendo espalhado durante 2025.

**Portar mais populares em placas-mãe (2025)**

* USB 2.0 (preto/branco) → ainda presente pra mouse e teclado, BIOS flashback.
* USB 3.2 Gen 1 (azul) → 5 Gb/s, muito comum.
* USB 3.2 Gen 2 (verde-azulado/vermelho) → 10 Gb/s, comum em placas de médio ou alto custo.
* USB 3.2 Gen 2×2 (Type-C, algumas vezes vermelho/verde-azulado) → 20 Gb/s, placas mais caras.
* USB4 / Thunderbolt 4 (Type-C) → 40 Gb/s, placas premium, workstations.

Fora isso, não é tão comum em PCs mas é bem comum em Macs, são as portas **Thunderbolt**.

![thunderbolt](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250914024235_7e05-mobo2.jpg)

* **Thunderbolt 1** (2011)
 	* Baseado em PCIe 2.0 ×4 + DisplayPort 1.1a.
 	* Conector: Mini DisplayPort.
 	* Banda: 10 Gb/s (bi-directional).
 	* Maior parte é Apple + algumas placas Intel.

* **Thunderbolt 2** (2013)
 	* Conector: Mini DisplayPort.
 	* Canais agregados → 20 Gb/s.
 	* Ainda PCIe 2.0, DisplayPort 1.2.
 	* Usado na era do MacBook Pro / Mac Pro.

* **Thunderbolt 3** (2015)
 	* Conector: USB-C (primeiro Thunderbolt a usar).
 	* Banda: 40 Gb/s (PCIe 3.0 ×4 + DP 1.2).
 	* Suporte completo a USB 3.1/3.2.
 	* Largamente adotado em laptops, docks, eGPUs.
 	* Requer certificação; nem toda porta USB-C = Thunderbolt 3.

* **Thunderbolt 4** (2020)
 	* Conector: USB-C.
 	* Ainda máximo de 40 Gb/s (como TB3), mas menos requerimentos mínimos:
  		* Mínima banda de PCIe 3.0 ×4 garantida.
  		* Suporte pra monitors duplos 4K ou um 8K.
  		* Carregamento mandatório + suporte a "wake from sleep".
 	* Mais consistente entre diversos dispositivos.
 	* Suporte nativo no Intel Tiger Lake+, AMD Ryzen 7000+ (alguns).

* **Thunderbolt 5** (anúncio em 2023, entregue em 2024/25)
 	* Conector: USB-C.
 	* Banda: 80 Gb/s bi-direcional, 120 Gb/s modo assimétrico (pra monitores).
 	* Usa tunelamento de PCIe 4.0.
 	* DisplayPort 2.1, suporta dual 8K ou triplo 4K.
 	* Ideal pra external GPUs, docks de alta-banda, monitores de workstation.

* Como Thunderbolt se relaciona com USB / USB4
 	* Thunderbolt 3 → formou a base pro USB4.
 	* USB4 = padrão aberto, 20–40 Gb/s, compartilha muito do protocolo Thunderbolt.
 	* USB4 v2 (especificação de 2022, saindo em 2025) = até 80–120 Gb/s, efetivamente equivalente a Thunderbolt 5.
 	* Muitas novas portas são “compatíveis com USB4 / Thunderbolt,” mas nem todos garantem todas as funcionalidades de TB a menos que seja certificado.

Conector Thunderbolt, a partir do 3 se não me engano é igual USB-C mas tem o símbolo de "raio" nele pra diferenciar.

![thunderbolt connector](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250914024546_screen_shot_2022-11-30_at_2.02.19_pm.webp)

Como podemos ver, não basta ter uma porta azul ou porta USB-C. Tem que ler a especificação no manual da placa-mãe que escolher. No geral, a maioria das placas-mãe modernas tem pelo menos USB 3.2 Gen 2 ou até USB 4. Pra Thunderbolt o buraco é mais embaixo, a maioria não tem.

Thunderbolt é importante se quiser eGPU ou storage externo pra coisas como edição de video (DAS), como CalDigit TS5 Plus, Sonnet Echo 13 ou então ligar múltiplos monitores 4K.

![thunderbolt storage](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250914024434_Best-Thunderbolt-USB-C-Docks-Docking-Stations-MacBook-Mac.webp)

### GPUs

Primeiro: GPU é o que chamamos o chip principal dentro de uma "placa-gráfica" que é o produto completo que tem a GPU, VRAM, cooler, placa-mãe e outros componentes.

![GPU](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250913232051_gpu.jpeg)

Todo mundo chama tudo só de "GPU" então meio que tanto faz, mas via de regra você está procurando uma "placa-gráfica". Vamos resumir a história recente, caso esteja interessado em usados primeiro.

**AMD (Radeon)**

![rx 7900 xtx](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250913233552_RX7900XTX-O24G-B_0.jpg)

* Série:
 	* RX 5000 (Navi, 2019) – lançamento de PCIe 4.0, midrange (RX 5700 XT).
 	* RX 6000 (RDNA2, 2020) – ray tracing, Infinity Cache, competitivo com RTX 3000.
 	* RX 7000 (RDNA3, 2022) – design de "chiplet", alta performance por /watt, RX 7900 XTX vs RTX 4080.
* Nomenclatura: RX [Series][Model]. quanto maior o número = mais novo, mais rápido. XT = variante mais rápida.
* Vantagens: bom custo-benefício, mais VRAM que NVIDIA na mesma classe, drivers abertos no Linux.
* Desvantagens: ray tracing mais lento que NVIDIA, mais fraco pra AI/compute.

**Intel (Arc)**

![Arc a770](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250913233641_placa-de-video-intel-arc-a770-phantom-gaming-asrock-16gb-gddr6-rgb-polychrome-sync-90-ga4kzz-00uanf_1696943713_gg.webp)

* Série:
 	* Arc A300/A500/A700 (Alchemist, 2022) – primeira geração.
 	* A380 = entrada, A770 = midrange pra um pouco mais alto.
* Futuro: Battlemage (2025), depois Celestial.
* Vantagens: competitivo em preço, boa engine de mídia (encode/decode AV1), drivers melhorando.
* Desvantagens: drivers imaturos(especialmente em Linux), opções high-end limitadas, sem CUDA/AI.

**NVIDIA (GeForce / RTX)**

![RTX 4090](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250913233742_251313_1-17459188343668033.jpeg)

* Série (recente):
 	* GTX 10 (Pascal, 2016) – enorme salto de eficiência (GTX 1080).
 	* RTX 20 (Turing, 2018) – introduziu ray tracing (RTX 2080 Ti).
 	* RTX 30 (Ampere, 2020) – grande salto, popular (RTX 3080, 3090).
 	* RTX 40 (Ada Lovelace, 2022) – melhor em ray tracing, DLSS 3 frame generation, RTX 4090 é o topo de linha.
* Naming: GTX/RTX + series + model (higher = better). Ti/SUPER = faster variant.
* Strengths: best ray tracing, DLSS, CUDA/AI support, most mature ecosystem.
* Weaknesses: high cost, VRAM sometimes lower than AMD at same tier.

Eu sou enviesado pra opinar sobre gráficos porque sou time verde faz anos. Eu tive a GTX 1080, RTX 3090, RTX 4060 e RTX 4090. Esses últimos dois ainda uso hoje. A 4060 pra games é mais que suficiente até 1440p na maioria e até 4K e em muitos menos pesados.

Editei a maioria dos videos do meu canal com GTX 1080 (enquanto eu filmava em 1080p) e depois migrei pra RTX 3090 quando passei a gravar em 4K com minha câmera **Sony A7S III**. Ela seria mais que suficiente ainda hoje, mas resolvi migrar pra RTX 4090.

A RTX 4090 uso pra render 3D (Blender) ou IA (LLMs com Ollama, LM Studio, Aider, etc). Não me vejo precisando de uma 5090 ainda (não tem mais VRAM que a minha, que é a única coisa que seria relevante pra LLMs).

Pro dia a dia, gerenciador de janelas, navegar na web e tudo mais, eu dou output pela iGPU (GPU integrada) que já vem na Ryzen 9. A RTX fica como GPU secundária pra render offload.

Vamos ver as GPUs mais modernas:

**NVIDIA — GeForce RTX 50 (Blackwell, 2025)**

* Key: PCIe 5.0, GDDR7, DLSS 4 / Multi-Frame Generation, DisplayPort 2.1b (UHBR20).
* RTX 5090: 32 GB GDDR7, 512-bit bus, arquitetura Blackwell.
* RTX 5080: Blackwell + GDDR7 + DLSS 4.

![RTX 5090](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250913234020_gv-n5090aorus-m-ice-32gd9.jpg)

**AMD — Radeon RX 9000 (RDNA 4, 2025)**

![RX 9070 XT](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250913234057_81OO5-B1DVL.jpg)

* Foco: mid/high-range, RT melhorado + novos aceleradores de IA.

**Intel — Arc B-series (Battlemage, 2024/2025)**

![B570](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250913234137_placa-de-video-asrock-intel-arc-b570-challenger-oc-10gb-gddr6-xess-ray-tracing-b570-cl-10go_222549.jpg)

* B580/B570); foco no valor, AV1 ainda forte, drivers melhorando.

**Pontos Importantes**

* VRAM eu não recomendo menos que 12GB. Se for fazer coisas mais profissionais como editar videos e criação de conteúdo, pelo menos 16GB. Dá pra rodar LLMs menores com menos VRAM, mas pra rodar as maiores, no mínimo 24GB (como minha 4090) ou 32GB (5090).
* Se estiver procurando a performance pra games de 4K com 240hz, garanta que tem **Display Port 2.1**. (RTX série 50 ou RX 9000).
* Ecossistema: depende da tecnologia precisa. CUDA só tem em NVIDIA. DLSS 4 (super resolution, frame generation) só tem em NVIDIA. O equivalente em AMD é FSR/HYPR-RX. Intel não tem nada disso.
* Performance também depende da banda, então PCIe 4 vs PCIe 5 como já expliquei antes. RTX série 50 tira vantagem de PCIe 5.

Não adianta comprar uma RTX série 50 e colocar com uma placa-mãe e CPU que só suporta PCIe 4.0. Vai funcionar, mas não vai tirar proveito de uma placa gráfica tão cara. É desperdício, melhor ficar numa RTX 2080 ou RTX 3080, por exemplo.

Custo-benefício e suporte em Linux é melhor em AMD. Se tiver dinheiro, RX série 9000, ou pelo menos série 7000. Procure pela versão XT/XTX que são as de mais performance. Mas não vai ter suporte a CUDA. O equivalente de API na AMD é o **ROCm** mas nem todo software suporta ele ainda.

Em games, interessa muito **DLSS** (Deep Learning Super Sampling) que são modelos de IA especializados em tratar frames de games.

* RTX 20-series (Turing, 2018)
 	* Suporta DLSS 1.0 (primeira geração, neural net por jogo - que vem nas atualizações de drivers, qualidade de imagem mais ou menos).
 	* Depois ganhou DLSS 2 via atualização de driver.
* RTX 30-series (Ampere, 2020)
 	* Suporta DLSS 2 completo (reconstrução de imagem mais nítida, estabilidade temporal).
 	* Suporta DLSS 3 Frame Generation (frames interpolados por IA), mas somente na série 40 tem Optical Flow Accelerator v2, então série 30 não consegue frame generation.
* RTX 40-series (Ada Lovelace, 2022)
 	* Suporta DLSS 2.
 	* Suporta DLSS 3 Frame Generation (insere frames de IA → maior FPShigher FPS, pequeno custo em latência).
 	* Adiciona DLSS 3.5 Ray Reconstruction (IA substitui denoiser → melhor qualidade de ray tracing).
* RTX 50-series (Blackwell, 2025)
 	* Suporta DLSS 4 (Multi-Frame Generation).
 	* Melhor interpolação de frame com redução de artefatos de latência comparado a DLSS 3.
 	* Constrói em cima de DLSS 3.5 (Ray Reconstruction ainda incluso).

* DLSS 1 → Prova de conceito, qualidade inconsistente, obsoleto.
* DLSS 2 → Per-pixel temporal upscaling, imagem nítida, artefatos mínimos, muito usado ainda hoje.
* DLSS 3 → Frame Generation → interpola frames inteiros, boost de FPS em cenários limitados pela GPU; requer série 40 pra cima.
* DLSS 3.5 → Ray Reconstruction → melhora luzes/reflexões de ray tracing, mais detalhes, menos "noise" (barulho). Funciona em todas as RTX.
* DLSS 4 → Multi-Frame Generation (RTX 50+) → movimentos mais suaves, redução de latência de artefatos.

AMD tem o equivalente a DLSS na forma de FSR, **FidelityFX Super Resolution**. Em Resumo:

* FSR 1.0 (2021)
 	* Spatial upscaler (per-frame, sem motion vectors).
 	* Suporte a várias GPUs (funciona em NVIDIA, Intel, consoles).
 	* Vantagem: simples, universal.
 	* Desvantagem: imagem soft, shimmering.

* FSR 2.0 (2022)
 	* Temporal upscaler (usa motion vectors + histórico).
 	* Mais perto de DLSS 2 em qualidade.
 	* Suportado em AMD + NVIDIA + Intel GPUs.
 	* Mais pesado, mas leve comparado com DLSS.

* FSR 3.0 (2023)
 	* Adiciona Frame Generation (interpolação sem IA).
 	* Roda em AMD e NVIDIA.
 	* Vantagem: mais FPS mesmo em GPUs mais velhas.
 	* Desvantagem: mais latência de input do que Optical Flow + Reflex combo de DLSS 3.

* FSR 3.1 (2024)
 	* Separa Frame Gen de Upscaling → pode usar FG com outros upscalers (DLSS/XeSS).
 	* Lida melhor com artefatos (ghosting, shimmering).

Intel tem XeSS mas é bem mais pobre que FSR (que parece que é open source, por isso também suporta outras GPUs) e DLSS (que é proprietário e só funciona em NVIDIA RTX).

NVIDIA série GTX pra trás não suporta nada disso e são considerados obsoletos já. Se quiser algo mais antigo pra economizar não iria mais pra trás do que RTX série 20, como uma 2060 ou 2080.

GPU de Notebook é outra coisa que a marketagem fode. Por exemplo, você vai encontrar notebooks que dizem ter "RTX 4060", porém tem menos CUDA cores, tem menos clock (limitação térmica, não tem como resfriar dentro de um notebook), TGP que é o total de energia consumida que vai ser faixa de 35W a no máximo 140W, mas sempre fica mais baixo. Em desktop uma 4060 iria de 115 a 160W. Vai ter menos VRAM (8GB ou menos). Performance geral vai ser de 30% a 50% mais lento que modelo desktop de mesmo nome.

Então uma **RTX 4060 mobile** vai ser mais equivalente a uma **RTX 3050 Ti** ou **RTX 3060**.

Vamos comparar alguns modelos da NVIDIA (as duas que eu tenho e a mais nova de todas):

**RTX 4060 (Ada Lovelace, 2023)**

* Architecture: AD107
* CUDA cores: 3,072
* Base / Boost: 1.83 / 2.46 GHz
* VRAM: 8 GB GDDR6, 128-bit bus
* Bandwidth: 272 GB/s (with 24 MB L2 cache)
* TGP: 115 W

**RTX 4090 (Ada Lovelace, 2022)**

* Architecture: AD102
* CUDA cores: 16,384
* Base / Boost: 2.23 / 2.52 GHz
* VRAM: 24 GB GDDR6X, 384-bit bus
* Bandwidth: 1,008 GB/s
* TGP: 450 W

**RTX 5090 (Blackwell, 2025)**

* Architecture: GB202 (Blackwell)
* CUDA cores: ~24,576
* Base / Boost: ~2.5+ GHz
* VRAM: 32 GB GDDR7, 512-bit bus
* Bandwidth: ~1.5–1.6 TB/s
* TGP: ~450–500 W (varies)

Notem como TGP varia drasticamente de um modelo 60 pra 90, de 115W pra absurdos 450 a 500W! E realmente consome isso se começa a puxar modelos LLM ou jogos AAA pesados. Também note a diferença gritante de CUDA cores. De novo: a 4060 roda meus jogos da Steam (muitos AAA) super de boa, seja tem 1440p max settings ou 4K medium settings, 60 fps a 100fps. Graças a DLSS, dá pra ter boa resolução e bom FPS.

Modelos 90 é se realmente for renderizar coisa pesada, editar video pesado ou rodar muita IA.

### Power Supply (PSU)

Toda hora estou falando sobre TGP, TDP, solução térmica e tem que falar de PSUs, as "fontes". Qualidade aqui faz diferença, como sempre, nunca compre sem marca, marca genérica ou coisa barata do AliExpress. Um PSU porcaria pode diminuir vida útil dos seus componentes ou destruir mesmo seu PC.

Marcas boas são: Seasonic, Corsair, Cooler Master, Be Quiet, EVGA. Queremos certificações como 80 PLUS Gold, Platinum, Titanium (e cuidado, marcas xing-ling vem com essas etiquetas).

Sobre a capacidade, o que realmente vai fazer diferença na conta é o consumo e CPU e GPU, veja as especificações dos modelos que escolher, mas em linhas gerais:

* setup velho, com uma i5 ou Ryzen 5, GPU média como uma RTX 4060 vai ser faixa de consumo de 200W a 300W (varia entre "idle", que é parado e pico, onde dá turbo boost ou está usando todos os cores, recompilando kernel, rodando LLMs, etc). Considerando outros componentes no PC é melhor pelo menos uma PSU de **550 a 650W**.

* setup médio, com uma RTX 4070 ou RX 7800 vai consumir faixa de 300W a 450W então escolha uma PSU de **750 a 850W**.

* setup de ponta, com uma RTX 4080 pra cima, puxando muito processamento de IA. Vai consumir faixa de 500 a 800W. Então é bom já considerar uma PSU **1000W** ou **1600W** se colocar 2 GPUs em paralelo.

A que eu uso no meu PC é uma **Corsair RM1000x Shift**

![Corsair RX1000x](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250914002607_fonte-atx-1000w-corsair-rm1000x-shift.jpg)

Lembram que falei sobre tamanhos de placa-mãe e gabinetes? ATX, mini-ITX? A PSU RM1000x que falei agora não cabe nelas. Pra isso precisa de uma fonte low profile ou **SFF** (Small Form Factor).

Digamos que queira colocar uma RTX 4070 num gabinete mini-ITX. Vai precisar de uma SFX ou SFX-L, pelo menos de 650 ou 750W. Exemplos são:

* Corsair SF750 / SF600 Platinum (SFX)
* SilverStone SX700 / SX750 (SFX)
* Seasonic Focus SGX-650 / SGX-750 (SFX)
* Lian Li SP series (SFX / SFX-L)

![Seasonic Focus](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250914002949_FOCUS-SGX-750-PSU-box-scaled.webp)

**CUIDADO**

Os cabos que vem **junto** com a PSU são específicas pra PSUs da **mesma marca**.

> **Não misture cabos diferentes com marcas diferentes!!!!**

Embora os encaixes pareçam o mesmo, elas podem danificar seus componentes!! Não existe um padrão de cabos pra PSU!!! Não misture seus cabos Corsair com PSUs Seasonic ou, pior, não compre cabos genéricos xing-ling no AliExpress e misture com sua PSU!! **Você foi avisado!!**

![cabos](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250914003312_which_psu_cables_go_where.width-1500.format-webp.webp)

### Coolers

Se estiver gastando bastante pra pegar os topos de linha de CPU, GPU, placa-mãe, PSU, não pode economizar em coolers.

Sabia que a **maior parte** da energia que seu PC consome é dissipado em forma de calor? Virtualmente tudo. O PC que falei que consome de 750 a 850W? Vai tudo pro ar em forma de calor. Somente uma **pequena fração** é convertida em outras formas como luz (LEDs), som (speakers), energia cinética (ventoinhas).

O princípio é baseado na **lei de conservação de energia**, que diz que energia não pode ser criada ou destruída, só transformada. O processo de computação por si não consome energia de uma forma que previne sua conversão em calor. O processo de processamento de informação envolve movimento de eléctrons através de circuitos, que geram calor por causa da resistência elétrica.

Portanto, quanto mais potente forem os componentes, mais energia consome e mais calor precisa ser dissipado rápido!

De cara, se dinheiro não for problema, escolha o melhor. O melhor é sempre **Noctua**. Eu nunca tive problema, são ultra silenciosos, confiáveis e nunca deixam na mão. E prefira **air cooler**, que tem a menor quantidade de peças móveis e que podem dar defeito ou precisar de manutenção. Liga uma vez e deixa pra sempre.

Se for uma CPU mais pesada como a minha Ryzen 9 7850X3D ou a mais nova 9850X3D tem que ser a **NH-D15 G2**.

![NH-D15 G2](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250914003832_232317-800-auto.webp)

Eu tenho a G1 e funciona sem problemas já faz uns 3 anos.

Poderia usar **Water Cooler (AIO)**? Poderia, mas tem que ser um AIO com radiador de 280mm a **360mm** (lembram quando falei sobre medir a dimensão dos componentes com o gabinete que vai comprar??). Um AIO funciona assim: em vez de ter uma ventoinha diretamente no dissipador de metal que fica grudado na CPU, passa um tubo onde circula líquido que vem de um tanque com uma bomba.

A água fria passa pelo dissipador, vai capturando calor, e levando pra um radiador. O radiador precisa de ventoinhas, pra dissipar o calor dele pro ar. Ou seja: vai ter ventoinhas de qualquer forma. Por isso eu não vejo vantagem. Veja um exemplo:

![Corsair Nautilus](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250914004612_71rD5Q7LtLL.webp)

Tem várias opções como a **Corsair Nautilus 360 RS Liquid CPU Cooler** ou uma **NZXT Kraken 240 RGB AIO**.

Por que se vê tanto AIO por aí? Porque os marketeiros descobriram do que as pessoas gostam: **luzes RGB**. Essa é a única razão. Em vez de uma única ventoinha eficiente Noctua, bege, sem graça, porque não **três** ventoinhas coloridas no radiador?? 🤣

Honestamente, tirando essa única razão, não existe motivos pra não ir direto pra Noctua NH-D15. Eu acho AIOs uma enorme perda de tempo.

Isso tudo dito, comprou a melhor CPU, a melhor Noctua, agora falta uma coisa entre as duas: **Pasta Térmica**. Normalmente, quando se compra o dissipador+ventoinha, como essa Noctua, já vem pasta térmica junto. No exemplo, deve vir a Noctua NT-H2, que é boa e suficiente.

Eu, pessoalmente, sempre confiei na **Thermal Grizzly**. Sempre usei a Kryonaut. Mas se dinheiro não for problema, porque não já ter uma **Thermal Grizzly Duronaut**?

![thermal grizzly](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250914005118_3393159-n1.webp)

Outras boas opções são a **Arctic MX-6**, **Corsair XTM60 Performance**, **Thermalright TF7 12.8 W/mK**, **Cooler Master Cryofuze 5** ou **ID-Cooling Frost X45**. Qualquer uma delas vai ser boa.

Passe na CPU, espalhe com uma espátula de plástico pela área toda e é isso. Esquece as mandingas de colocar pasta em "X" ou qualquer outro formato. Só espalha igualmente e pronto, talvez um pouquinho mais no meio.

E sim, existe a opção de **Metal Líquido**, como vem nos Playstation 5. Mas você não vai querer usar.

Metal Líquido é **CONDUTOR ELÉTRICO**, diferente de pasta térmica. Pra usar precisa SABER como usar. E você não vai saber. Vai vazar pelos lados e vai dar curto e você vai fritar sua CPU. Nem cogite. É pra usos específicos de quem sabe o que está fazendo.

Na dúvida, compre Thermal Grizzly, Duronaut ou Kryonaut. Acabou.

### Undervolting

Um pequeno adendo sobre notebooks, especialmente os mais velhos de mais de 5 anos pra trás. Eles não tem como colocar coolers grandes como um NH-D15 ou um AIO. E a geração Intel de mais de 5 anos atrás dissipava MUITO calor. Não era incomum a CPU chegar a 100 graus!!

Uma CPU normal opera em clock base, digamos 2 ou 3Ghz, e quando precisa de mais performance numa tarefa pesada, ele pode dar Turbo Boost pra 4Ghz ou mais. Só que isso aumenta consumo de energia (bateria vai embora mais rápido) e o pior: **esquenta**.

Se esquentar demais vai acontecer o temido **THERMAL THROTTLE**, ou seja, a CPU - pra se proteger, e não morrer - vai derrubar o block **abaixo** do base clock, digamos pra menos de 1 Ghz.

Não adianta nada dar Boost de 4Ghz por alguns minutos e depois passar um tempão capado em 1 Ghz até a temperatura baixar.

Por isso muita gente recomenda fazer **undervolting** com uma ferramenta como [Throttlestop](https://www.maketecheasier.com/reduce-cpu-temperature-undervolting/) no Windows ou [VoltageShift](https://github.com/sicreative/VoltageShift) no Mac ou intel-undervolt e amdctl no Linux (leia o [ArchWiki de Undelvolt](https://wiki.archlinux.org/title/Undervolting_CPU))

![Throttlestop](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250914015934_2021-06-07-113438.webp)

A idéia é diminuir a voltagem que vai pra CPU/GPU, evitar que ele bata no teto de temperatura e evitar thermal throttle. É melhor que rode um pouco menos rápido no geral, do que rebaixar lento demais num throttle.

É um processo de tentativa e erro, depende do firmware, modelo da CPU, etc. Mas se você sente esse problema no seu notebook antigo, essa é uma solução.

Eu precisei usar muito isso na época dos Macbook Intel ou Dell XPS da era de 2016. Cuidado com notebooks com reputação de não ter boa solução térmica (que esquenta demais).

### Mini-PCs

Se achou tudo isso complicado, e acha notebooks muito caros, existe uma outra boa alternativa: **Mini-PCs**.

Muita gente fala dos **Beelink** e eu concordo, são muito bons. Se conseguir achar uma boa configuração num preço que cabe no seu bolso, pode comprar. Hoje em dia funcionam muito bem.

Eu mesmo uso um **Intel NUC 13 Pro Slim**, que vem com uma Intel Core i7-1360P de 13a geração, com 16GB e eu dei upgrade pra 32 GB (DDR4), tem PCIe 4.0 pra NVME, acho que vem com 512GB mas dei upgrade pra 1TB, Wi-fi 6E e Bluetooth 5.3, iGPU Intel Irix Xe (4K 60hz, não presta pra jogos mas pra produtividade é de bom tamanho), Ethernet 2.5Gbps (excepcional pra um Mini-PC), saídas HDMI e DP, e ainda tem Thunderbolt 4 e USB 3 Gen 2.

Não é barato, mas também não é absurdo. No Mercado Livre tá na faixa de **BRL 6.000**, o que é super aceitável pra essa configuração e zero trabalho. Eu uso ela como meu [home server](/tags/homeserver), como já mostrei em vários posts anteriores no blog.

![Grafana cAdvisor](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250914010051_screenshot-2025-09-14_01-00-40.png)

Tenho dezenas de containers Docker rodando coisas como Plex, Sonarr, Radarr, Grafana, Cloudflare, etc e não usa quase nada da minha CPU. Eu coloquei 32GB mas poderia ter deixado com os 16 GB que veio porque male-male está usando 4GB de RAM no total.

Esse mini-PC é suficiente pra um programador médio. Vai durar muito tempo. Só conectar um monitor, teclado, mouse e é isso.

Eu tenho um segundo mini-PC, o **Minisforum EliteMini UM780 XTX**:

![Minisforum](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250914010312_Minisforum-EliteMini-UM780-XTX-Mini-PC-connectivity-1200x610.webp)

Esse é mais potente, tem **AMD Ryzen 7 8840U** (categoria similar a um **Rog Ally X** de primeira geração, o de segunda é Z1 Extreme), 32GB, 1TB NVME PCIe 4.0, tem USB 4 (não tem Thunderbolt porque é exclusividade da Intel, Apple licencia). Mas pra mim o mais importante é que é um dos poucos PCs que tem saída **OCulink**.

OCulink é uma porta que conecta direto no barramento PCIe. Diferente de USB ou Thunderbolt que tem overhead do protocolo, OCulink é como se eu estivesse espetando uma placa direto no slot da placa-mãe.

Quando saiu o **SteamDeck** talvez vocês já tenham visto videos de pessoas fazendo mod e conseguindo conectar uma GPU externa nele. Pra fazer isso a GPU precisa se conectar direto na PCIe e a **gambiarra** foi usar o slot de NVME pra isso. Porque NVME também é um slot M2 que é PCIe, como já expliquei lá em cima.

![SteamDeck GPU](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250914010609_external-gpu-cooled-deck-v0-814qfkk5y4cb1.webp)

Pois bem, com OCulink não precisa fazer essa gambiarra. A Minisforum vende o **DEG1 OCulink EGPU**:

![DEG1](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250914010830_Minisforum-DEG1-Oculink-eGPU-with-AMD-Radeon-W7700-GPU-5-800x487.webp)

Lembram que eu falei que tenho uma RTX 4090 no meu PC e também uma RTX 4060 pra games? Eu ligo nesse deck de egpu, conecto uma PSU só pra GPU e o DEG1 conecta na porta OCulink da UM780, e ela se liga na minha TV OLED 80", e pronto! Game 4K na sala.

Vai ter menos lanes de PCIe do que num PC de verdade, mas vai ser mais rápido do que um EGPU com Thunderbolt 4. Pro sistema operacional, seja Windows, seja Linux, ele não nota diferença de estar dentro ou fora do gabinete. Pra ele é uma GPU normal conectado num slot PCIe 4.0 diretamente. Não recomendo EGPUs via Thunderbolt, só com OCulink.

E não adianta ligar minha 4090 porque não tem lanes de PCIe suficientes. OCulink é PCIe x4. Quando se lê "x4" significa **4 Lanes PCIe**, no caso 4x PCIe 4.0 então uma banda máxima de **64Gbps**.

Uma RTX 4090 foi desenvolvida pra **PCIe 5.0 x16**. Então eu estaria desperdiçando 3/4 da banda que ele é capaz de trafegar. Por isso disse que seria um desperdício. Um RTX 4060 foi desenhado pra **PCIe 4.0 x4** que é exatamente o máximo da OCulink, então esse é o teto pra uma EGPU.

Portanto uma RTX 4060 via OCulink vai performar quase que totalmente, sem overhead se fosse eGPU via Thunderbolt (que perderia uns 20% da banda). Mas potente que isso, vai desperdiçar a GPU.

Voltando pra mini-PC, como falei, **Beelink** é uma marca bem popular. E se quiser o seu topo de linha, é a **Beelink SER9 Pro**:

![SER9](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250914011539_ser9.webp)

Pela bagatela de **BRL 8.000** no Mercado Livre, ela vem com AMD Ryzen AI 9 HX370 (12 cores/24 threads, até 5.1Ghz boost, 80 TOPS de AI), 32 GB de LPDDR5 (bem melhor que DDR4), 1 TB NVME PCIe 4.0, iGPU Radeon 890M (que é boa pra jogos também! muito melhor que um SteamDeck), Ethernet 2.5Gbps (excelente), e o básico: USB 4, HDMI, DisplayPort, USB 3.2, etc.

Pela configuração, eu acho que o preço condiz bem. Um notebook de configuração similar seria um **ASUS ROG Flow Z13** que tá na faixa de **BRL 13.000**. Se considerar que é portátil, vem com uma tela excelente, teclado, touchpad, bateria, não é um preço tão ruim.

![Asus Rog Flow](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250914012100_rog%20flow%20z13.jpg)

Ou se quiser algo ainda mais **Premium**, seria um **Razer Blade 16** que tem o mesmo Ryzen AI Max mas uma tela 16", super fino e tals, mas com a Taxa Brasil, vai sair salgados **BRL 40.000**. Não dá pra justificar.

![Blade 16](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250914012231_814PVSAztPL.webp)

Se não quiser gastar tanto, ainda tem a **Beelink SER8** que tem AMD Ryzen 7 8845HS, que ainda é razoavelmente suficiente pra programar, com 8 cores/16 threads, iGPU Radeon 780M (que serve pra jogos não tão pesados), 32 GB DDR5 5600 (que é bom), 1 TB PCIe 4.0 que dá pra subir até 4 TB como já expliquei. Vem com Wi-Fi 6, Bluetooth 5.2, Ethernet 2.5 Gbps também, suporta HDMI 2.1, DP 1.4, USB 4.

E num Mercado Livre ainda se acha por uma faixa de **BRL 5.000**, similar ao meu Intel NUC. Acho que esse é o "sweet-spot" entre preço e performance. Pra mim, pessoalmente, acho fraco, mas não quer dizer que seja inútil. De novo, depende de quanto você pode gastar. O melhor PC é aquele que você pode comprar.

![Beelink SER8](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250914012714_ser8.webp)

Se instalar [Omarchy](/tags/omarchy) nesse Beelink, fica redondo! Recomendo!

### Conclusão

Acho que isso é tudo que eu queria compartilhar sobre escolher componentes de PCs. Nos videos do meu canal eu explico vários conceitos que complementam isso como [Introdução a Redes](https://www.youtube.com/watch?v=0TndL-Nh6Ok&list=PLdsnXVqbHDUcTGjNZuRYCVj3AZtdt6oG7&pp=gAQB) ou [Entendendo Armazenamento](https://www.youtube.com/watch?v=lxjBgxmDZAI&list=PLdsnXVqbHDUcM0LTAxqrVrTy6Q7jQprjt&pp=gAQB) ou mais "escovação de bits" em [Como Computadores Funcionam](https://www.youtube.com/watch?v=8G80nuEyDN4&list=PLdsnXVqbHDUcQIuiH9b-i9A85H3A2ZW5W&pp=gAQB) e até coisas mais nerds como [Saga dos Teclados](https://www.youtube.com/watch?v=tEXX1jdpZN8&list=PLdsnXVqbHDUfTsz27oFYUaQD-1n9PXoyy&pp=gAQB) ou, pra programadores, [Como Containers Funcionam](https://www.youtube.com/watch?v=bwO8EZf0gLI&list=PLdsnXVqbHDUdjNjfekBoCBfGtJ6kNRef-&pp=gAQB) e [Sistemas Operacionais](https://www.youtube.com/watch?v=suSvMnNwV-8&list=PLdsnXVqbHDUd17xLINVEXhJ32RxbzCEWV&pp=gAQB), tudo organizado em playlists. Só assistir.

Pra se manter atualizado, recomendo alguns canais que eu gosto:

* [Linus Tech Tips](https://www.youtube.com/@LinusTechTips)
* [Gamers Nexus](https://www.youtube.com/@GamersNexus)
* [ETA Prime](https://www.youtube.com/@ETAPRIME)
* [CoreTeks](https://www.youtube.com/@Coreteks)
* [Digital Foundry](https://www.youtube.com/@DigitalFoundry) (pra entender efeitos de funcionalidades de GPUs em games)
* [Hardware Canucks](https://www.youtube.com/@HardwareCanucks)
* [Matthew Moniz](https://www.youtube.com/@MatthewMoniz)
* [Dave2D](https://www.youtube.com/@Dave2D)

O que não falta no YouTube são "Tech Reviewers" e a GRANDE maioria são extremamente ruins. Não recomendo a maioria. Tirando os da minha lista acima, não sobra muitos não. Tem alguns mais ou menos como Austin Evans, mas é mais entretenimento que review técnico, então também não recomendo.

Achou tudo isso demais? Isso foi só a ponta do iceberg. Não se preocupe em acertar de primeira. Você nunca vai ter só 1 PC. O importante é que preste atenção onde errou pra acertar na próxima. Mas se não se importar em pesquisar esses componentes todos e ficar só ouvindo YouTuber, vai fazer igual gente que consulta astrólogo pra saber como vencer na vida: não vai.

> **Vou repetir: o melhor PC é aquele que você pode comprar!**

Meu primeiro PC foi um 286 de 1MB de RAM no fim dos anos 80. Desde então passei por **vários** PCs. Numa era antes da Internet, eu cansei de ler classificados nos jornais pra pesquisar preços, eu ia bater perna na rua Santa Ifigênia, em São Paulo, que era a meca dos componentes eletrônicos. No começo da Internet eu cansei de fuçar ecomerces mais ou menos, componentes da Ásia via ums LikSang da vida.

Tive vários PCs, vários notebooks. Por isso eu tenho uma boa noção hoje, com quase 50 anos e como podem ver, eu continuo atuali
