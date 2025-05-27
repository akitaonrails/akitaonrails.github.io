---
title: Seu Windows pode estar Capado sem Você Saber. Cheque isto!!
date: '2025-05-21T17:15:00-03:00'
slug: seu-windows-pode-estar-capado-sem-voce-saber-cheque-isto
tags:
- windows
- power saver
- hanging event
- slow down
draft: false
---



Eu normalmente não ligo de documentar sobre problemas bobos de Windows, mas este em particular me deixou irritado, então vou relatar a sequência de eventos. Mas já deixo o spoiler do final: abra Control Panel e Power Options no seu Windows e cheque se ele não está em "Power saver" mode. Tire desse lixo, deixe no mínimo em Balanced, mas se for PC Desktop suba pra "High Performance" ou "Ultimate Performance". Depois me agradeça.

Agora senta que lá vem história.

Eu montei um PC até que razoável pra minha namorada: Intel i7 12th Gen de 8 cores, 32GB DDR4-2400, NVIDIA RTX 3090, placa-mãe MSI Edge z790, NVME e até coloquei um NAS Synology DS1621+ em rede 2.5Gbps - porque ela é criadora de conteúdo e tem MUITO video pra editar. Modéstia a parte, ficou bonito:

![pc branco](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/a8c82k3ocnpu1jamxb9w0z1fx2cf)

Tudo funcionou muito bem por bastante tempo, mas eventualmente, sem nenhum motivo aparente, tudo começou a parecer meio lento. Não totalmente lento, mas às vezes páginas web pareciam engasgar pra carregar. Clicava no menu Start do Windows e ele parecia dar umas travadas. Às vezes o Explorer travava e precisava ir no Task Manager e dar restart no processo manualmente. Várias coisas super inconvenientes mas que não dava nenhum "erro" explícito aparente. Só parecia "estranho".

Eu sou usuário de Linux. Meu PC principal é Manjaro Linux. Só uso Windows nos meus mini-PC de games, exclusivamente pra rodar Steam e alguns emuladores. Eu evito ao máximo instalar qualquer coisa neles. Porque sei como é um saco diagnosticar Windows depois que algum programa estranho invade.

Fui olhar os suspeitos de sempre. Ela tinha instalado jogos pra fazer streaming, tipo Valorant, Genshin Impact e coisas assim. Eu sempre suspeito de anti-cheats, as porcarias do Riot Vanguard ou Easy ou VAC. Comecei desinstalando todos os games. Mas eu sempre acho que anti-cheat é que nem malware: uma vez instalado, nunca mais vai sair do sistema. Desinstalei tudo, mas continuou essa sensação de meio travando, meio lento, às vezes, intermitente.

Tentei os próximos suspeitos: software de periféricos, como os da Elgato, Logitech, Razr que instalam um monte de porcaria nas máquinas, e recentemente estava lendo sobre o malware que vinha em todos eles. Assistam este video do GamerNexus pra entender a casa de cartas que é toda a indústria de periféricos com RGB:

<iframe width="560" height="315" src="https://www.youtube.com/embed/H_O5JtBqODA?si=8yEqSzgtyRg7dqTC" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

Mesmo desinstalando todos, ainda mesmo comportamento: meio lento, meio travando, instável.

Vamos tentar ir mais a fundo, pra isso tem que instalar ferramentas como da [Sysinternals Autoruns](https://learn.microsoft.com/en-us/sysinternals/downloads/autoruns) pra ver se tem alguma coisa iniciando (coisas escondidas no Registry por exemplo). Tentei desligar tudo que eu achava suspeito.

Nada. A essa altura também já tinha garantido que firmware de BIOS mais nova da MSI estava instalado. Chequei se nada tinha desligado na BIOS, XMP profile tava ok, nada de fast-boot e coisas assim.

### Será a Internet?

Como o uso maior é internet e ela parecia "lenta", pensei que poderia ser problemas de rede. Roteador da Vivo? Plano? Wifi com interferência?

Ficando sem paciência resolvi ir nuclear na idéia de internet. De fato, abrindo a página da [Cloudflare Speed Test](https://speed.cloudflare.com/) eu via que a velocidade em si estava ok, mas a latência estava MUITO alta, jitter alto e, principalmente PACKET LOSS estava em mais de 15%. Não é normal isso, tem que ser 0%.

Aproveitei que fui pra Miami e já trouxe um roteador TP-LINK BE9300 pra Wi-fi 7, comprei uma placa PCIe de Wi-fi 7 compatível também. Desliguei o roteador de Wi-fi da Vivo e mandei subir o plano pra 800Mbps. E de fato, melhorou muito a internet:

![vivo internet](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/ogesvmtex2ek825hel7d4l0f5i30)

Latência caiu, jitter caiu, packet loss foi pra 0%. 

Mas isso não resolveu o problema. Do nada o navegador dava umas pausas na hora de carregar alguma página. Aquela sensação meio de lento, meio travando. E sim, tentei trocar de Edge pra Chrome, pra Firefox, pra tudo. Nada fazia diferença. A internet ficou mais rápida mesmo, mas o Windows em si não pareceu que melhorou muito e navegando, começava a ficar mais e mais lento. Então o problema não era internet.

Estava ficando sem opções. Tudo que poderia ser manualmente limpo no Windows, eu limpei. Já não tinha quase mais nada pra apagar - e eu apago as coisas sem dó. Mas eu sempre fico na cabeça que é algum malware, alguma coisa que carrega antes do boot, algum "ROOTKIT". Anti-cheats são Rootkits por definição. Eles carregam antes até da kernel e a partir desse ponto, o sistema comprometido não pode ser mais confiado, porque nenhuma ferramenta vai conseguir achar ele.

Assumindo que nesse ponto deve ser um sistema comprometido, resolvi ir na opção nuclear: reinstalar tudo do zero. Fizemos backup dos dados e lá fui eu reinstalar do zero.

### Reinstalar NÃO FUNCIONOU

Agora ficou pior.

Com o Windows 11 Pro, recém-instalado, garantidamente sem nenhum software de terceiros instalado, ainda assim estava com o mesmo comportamento de meio lento, meio travando. O menu de start não me deixava clicar em nada. Precisava abrir o task manager e matar o Explorer manualmente pra fazer ele voltar a funcionar.

Fiquei um tempo olhando pro Task Manager, mas não tinha nenhum processo rodando que eu poderia suspeitar mais: era Windows bare-bones. Eu até tinha rodado um [Debloater](https://github.com/Raphire/Win11Debloat) pra desinstalar os apps desnecessários da Microsoft como Teams.

Mas eis que, de tanto olhar o task manager, eu vi que estava ignorando um dado importante. Veja se acham:

![cpu low](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/pky39kkwcbuyqocwpj15n36i9gai)

A imagem tá meio zoada porque eu tirei foto do monitor com meu celular. O refresh rate conflita com da câmera e fica essa "grade", mas acho que dá pra ler.

Mesmo quando você não tem quase nenhum programa rodando, não é natural a CPU estar com clock tão baixo assim, 0.50Ghz - MEIO GIGAHERTZ. Esse Intel i7 é capaz de ir acima de 4Ghz e o clock-base é de 2Ghz. 

Abri navegadores, abri abas, fiquei monitorando, e nunca subia pra mais de 1.5Ghz. Um ocasional pico de 2Ghz por 1 segundo e depois caía pra abaixo de 1Ghz de novo. Daí pensei: será que o AIO está falhando??

Olhando o Event Viewer dava pra ver quando o menu Start (que faz parte do Explorer.exe) parava de funcionar e travava: ele registra no log como "Hanging Events" código 1002.

![event viewer](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/dtugk013p4decud6zo1dzg3rjhxr)

Tá vendo esse monte de Error? Tudo Hanging Events, e "hanging" é justamente o comportamento: alguma coisa parece "segurar", "travar" e só matando o processo pra ele voltar a funcionar.

E isso acontecia antes e também DEPOIS de resinstalar tudo do zero. Alguma coisa parecia fundamentalmente errada no hardware em si. Com o clock super baixo, esse comportamento começa a fazer sentido: está tão lento que ele não está conseguindo processar coisas básicas. Clique várias vezes no Start Menu (que vai ficar fuçando documentos recentes, atualizando lista de aplicativos, abrindo search bar, etc) e não tem clock pra processar isso enquanto ainda tem Windows Defender em background, abas de navegador processando.

### Será Thermal Throttle??

Como o Windows está zerado, não pode mais ser anti-cheat, não pode ser anti-virus esquisito, não pode ser malware, não é a internet, é alguma coisa FORA, era o que fazia sentido.

Abri o PC e deixei aberto pra poder sentir se o dissipador estava ficando absurdamente quente. Se estiver, iria significar que meu AIO (Watercooler da Coolermaster) começou a falhar.

É normal quando a CPU super-aquece, ele derrubar o clock pra evitar queimar o chip. Isso se chama "THEMAL THROTTLING".

E de novo esquisito: estava FRIO ao toque!!!

Não é possível. Abri a BIOS pra re-checar perfis de ventoinha, mas tudo normal:

![cpu fans](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/yl02sk0dug6zj9d1gen877d22gnw)

Eis que finalmente me ocorreu:

	**DEIXA EU CHECAR CONFIGURAÇÃO DE POWER**


Num PC/notebook normal, deveria aparecer algo parecido com isto:

![Power Settings](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/a5dkm6eag4ebma6ye1i1mnzphy3s)

Por default, Windows sempre sobe em "Balanced Mode".

Mas no PC da minha namorada, **não sei por que**, não tinha opção de Power Mode!!! E eu estou num Windows 11 pro com licença paga!!

Isso é esquisito, mas eu sei que no antigo Control Panel, tem opção de Power Options:

![control panel](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/70ymku67f5ufp0pd76jp0b2hqjx2)

E EIS O PROBLEMA:

Estava em "Power saver"!!!

Como isso aconteceu? Não tenho a mínima idéia. LEMBREM-SE: eu re-instalei o Windows do zero. Isso é logo depois de reinstalar!!

Em notebook faz sentido ter esse perfil, pra economizar bateria quando você não tem tomada. Mas em PC desktop, como é meu caso, não faz nenhum sentido!! Mudei pra "Ultimate Performance" e olha o task manager agora:

![cpu high](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/5hg5d85ivuxv9tw5si21wcb3hm5p)

AGORA SIM!! Acima de 4Ghz!!!

O NORMAL desta CPU é estar na faixa de 4Ghz, com Turbo Boost de 5Ghz. Mas em Power saver mode, ele NUNCA sobe acima de 2Ghz e fica idling em 500Mhz. Ou seja, estava tudo **DEZ VEZES MAIS LENTO**, às vezes tentava dar boost e ficava ainda **CINCO A DUAS VEZES MAIS LENTO**. E é intermitente!!!

Testando instalar apps, navegar, etc, tudo agora está funcionando normalmente, sem travar, sem sensação de lentidão. Start menu não trava mais - porque agora tem CPU suficiente pra processar as porcarias que ele precisa em background.

### Conclusão

CHEQUE POWER OPTIONS NO CONTROL PANEL!!!!

Repetindo: eu tinha ACABADO DE REINSTALAR O WINDOWS. Estava zerado e, por default, ele subiu em Power Saver mode.

Não tenho idéia de porque ele fez isso, não sei se ele sempre faz isso, não sei se ele não reconheceu a placa-mãe da MSI, não sei que combinação de fatores de hardware podem fazer o Windows dar fallback pra isso.

Mas é ALARMANTE que ele faça isso sem avisar. Não tem mensagem de erro. Não tem notificação. Não aparece no Event Viewer. Ou seja, mesmo um Power User como eu eu, precisa aleatoriamente suspeitar "hum, deixa eu ver o perfil de energia".

Muita gente com Windows deve estar sentindo essa lentidão e travamentos e achando "hm, meu PC é porcaria mesmo, preciso juntar dinheiro pra comprar outro", sem saber que talvez ele só esteja capado por esse perfil de energia e na verdade o PC dele é de 2x a 5x, até 10x mais rápido e ele não sabe disso! Não é uma diferença pequena!

POWER SAVER MODE é uma grande porcaria, não tem nenhuma utilidade prática e nem deveria existir.  É uma das coisas legadas que fazem o Windows ter uma péssima experiência - porque ele não avisa.

Lembra os códigos de erros 1002 de hanging events? Se sair procurando no Google, todo fórum vai te dizer pra rodar programas de diagnósticos, desinstalar coisas, ou reinstalar o Windows. Nenhum cita nada sobre perfil de energia.

Espero que isso ajude mais alguém!
