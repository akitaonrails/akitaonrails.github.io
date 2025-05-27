---
title: "[Akitando #139] - Entendendo Como Containers Funcionam"
date: '2023-03-02T09:00:00-03:00'
slug: akitando-139-entendendo-como-containers-funcionam
tags:
- container
- docker
- runc
- podman
- kubernetes
- terraform
- akitando
draft: false
---

{{< youtube id="85k8se4Zo70" >}}

Finalmente vou pagar promessa. Este é o video sobre containers e Docker que venho falando faz vários videos atrás, que ia fazer. Mas eu precisava explicar a instalação, como Linux boota, como funciona virtualização, pra finalmente chegar em containers. Então este episódio vai amarrar tudo que vocês aprenderam nos videos de Linux, de armazenamento, etc e finalmente vão entender containers do jeito certo.

## Erratas

5:12 - tá errado, isso é em outros comandos, como top eu acho, que mostraria 400% se tivesse usando 4 CPU. Do jeito que eu falei ficou parecendo que naquele quadrado vermelho mostraria isso, mas ali é POR cpu/thread, por isso vai só até 100%. Só em linhas de comando que mostra num número só quanto que tá se usando que apareceria, por exemplo, 400%.

## Conteúdo

* 00:00 - Intro: qual a diferença de VMs e Containers?
* 01:49 - CAP 1 - Limitando Processos - cgroups
* 07:43 - CAP 2 - Enganando Processos - namespaces
* 14:45 - CAP 3 - Recapitulando Containers - LXC, Docker, OCI
* 17:34 - CAP 4 - A Base de Containers - RunC
* 22:29 - CAP 5 - Hello World de Docker - O que tem dentro?
* 33:20 - CAP 6 - Restringindo Processos Ainda Mais - Capabilities
* 37:18 - CAP 7 - Orquestrando Containers - Docker Compose
* 41:26 - CAP 8 - Bônus do Episódio "Tornando sua App Web mais Rápida"  - Load Balancer com Docker
* 43:25 - CAP 9 - Orquestra de Gente Grande - K8S e Terraform
* 47:17 - CAP 10 - Outros Usos de Containers - Apps em Containers?
* 51:28 - Bloopers


## Links

* https://github.com/akitaonrails/episode0139
* https://www.zsiegel.com/2022/01/17/load-balancing-in-docker-with-nginx
* https://www.mo4tech.com/unshare-command-details-and-examples.html
* https://ericchiang.github.io/post/containers-from-scratch/
* https://wiki.archlinux.org/title/cgroups
* https://nodejs.org/en/docs/guides/nodejs-docker-webapp/
* https://docs.docker.com/compose/gettingstarted/
* https://flast101.github.io/docker-privesc/
* https://blog.alexellis.io/runc-in-30-seconds/
* https://man7.org/linux/man-pages/man7/capabilities.7.html
* https://blog.container-solutions.com/linux-capabilities-in-practice
* https://github.com/containers/bubblewrap

## SCRIPT

Olá pessoal, Fabio Akita

O penúltimo video sobre o setup do meu PC foi pesado em configuração mas se conseguiu chegar até o fim, deve ter entendido um pouco mais sobre como virtualização funciona, em particular usando o emulador QEMU acelerado com KVM. Aquilo é virtualização: criar uma máquina virtual que roda outro sistema operacional, outra kernel, por cima.





Hora de pagar a promessa que vim fazendo em diversos videos. Finalmente falar um pouco sobre os tais "containers" que até hoje muita gente confunde com virtualização. As duas coisas "parece" que é rodar um programa dentro de uma máquina virtual. Mas containers são completamente diferentes de máquinas virtuais. Vamos lá.




(...)






Se fosse fazer um TLDR, uma única frase que resume a diferença, é até simples: uma máquina virtual roda um novo kernel, possivelmente numa outra arquitetura, como x86 em cima de ARM, já um container reaproveita o mesmo kernel, necessariamente na mesma arquitetura de hardware. É essa a diferença. Agora vamos ver na prática.






Vou começar falando só de containers de Linux. BSD, Windows, MacOS tem infraestrutura diferente pra containers. Windows tem como rodar container pra rodar apps de Windows. Isso é leve. Mas quando Windows ou MacOS precisam rodar apps de Linux, na prática o que acontece é que eles de fato sobem uma máquina virtual de Linux primeiro, como o WSL que já fiz dois videos a respeito. Portanto envolve sim virtualização. E é dentro dessa máquina que um Docker Desktop cria containers de Linux. Só em Linux nativo que containers são realmente "leves". 






Em Linux precisamos entender dois componentes fundamentais: cgroups e namespaces. Cgroups já mencionei no episódio anterior quando mostrei como isolar threads da CPU só pra máquina virtual e só pro host. Cgroups ou control groups é um mecanismo da kernel pra agrupar processos e limitar recursos como cpu e memória. 







Existem várias formas de listar cgroups. A mais simples acho que é só dar `ls /sys/fs/cgroup`. Lembra o script chamado "suspend" que fiz pra limitar AllowedCPUs pro host? Usei o systemd pra limitar esse parâmetro pros cgroups init.scope, system.slice e user.slice. Vejam na listagem que todos são diretórios. Se listar um deles, vem vários arquivos como "cpu.weight" ou "memory.pressure". É como se parametriza os recursos pra esses cgroups.






É tudo organizado como uma árvore, pra variar olha só árvores de novo, onde um cgroup herda configurações de outro cgroup. Honestamente, não sei os detalhes de como é configurado cada um que já vem de cada distro e imagino que cada um configura essa árvore de formas um pouco diferente. Essa listagem é no meu Manjaro. Num Ubuntu é semelhante, tem a maioria dos mesmos slices. 






Se listarmos o que tem em system.slice, tem novos subdiretórios, um pra cada daemon que o systemd inicia, e também cgroups pra cada um dos aplicativos instalados via Snap, que vou falar um pouco mais pra frente. Pra enxergamos isso melhor podemos rodar o comando `systemctl status`. Agora temos a hierarquia toda de cgroups.  Como falei antes, olha aqui o system.slice e os sub-grupos de cada daemon. E mais pra baixo temos o user.slice onde os programas que estamos rodando como navegador, terminal e tudo mais ficam em seus próprios sub-grupos também. Todos os processos rodando estão organizados em cgroups. Você nem sabia disso, mas toda vez que executa um programa, ele vai estar atrelado a pelo menos um cgroup.







Lembra que quando usamos comandos com `ps` ou programas como `htop` eles pesquisam os metadados no sistema de arquivos virtual `/proc`? Por exemplo, vamos pegar o PID do meu navegador Edge. Tem vários processos, todo navegador separa cada aba num processo diferente pra isolar, ter mais segurança, e se uma aba crashear, não derrubar todas as outras junto. Podemos fazer `cat /proc/PID/group` e aqui vamos em qual sub-grupo de cgroup esse process está. No escopo do edge, dentro de app.slice, dentro de user service, dentro de user.slice.







Existem várias formas de controlar cgroups. Uma delas é usando o sistema de arquivos virtual disponível no diretório `/sys/fs/cgroups`. Isso é um ponto de montagem. Se fizermos `mount | grep cgroup` olha como aparece que o tipo do sistema de arquivos é "cgroup2". É como se fosse um dispositivo virtual montado. Lembra que já expliquei nos episódios de Linux, como nos de Slackware, Gentoo e no que explico como funciona o boot, que existem diversos pontos de montagem especiais como "/proc" ou "/dev"? 







Pra mostrar na prática pra que diabos saporra serve, deixa criar um script idiota em Ruby. Podia ser em Python, podia ser em Java, faça no que quiser. É só um loop infinito printando ponto pra sempre. Vamos rodar e em outro terminal abro o "htop". Veja aqui no topo que meu script tá usando 100% de 1 CPU. Se eu tivesse feito suportar múltiplas threads, cada 100% seria uma CPU. Um programa que usa 4 threads inteiras ia aparecer aqui como 400%.







No topo do programa lista todas as threads independentes e veja que tem uma de 100% que é meu script. Mas se esperar um pouquinho vai ver que ele muda de lugar. Um programa não fica sempre fixo no mesmo thread. Pra isso serve o scheduler da kernel. Expliquei sobre scheduler no episódio de concorrência e paralelismo e é a razão de porque no episódio anterior tive o trabalho de mostrar como mandei a máquina virtual usar as threads de 16 a 31 e limitei o host a usar só de 8 a 15. Lembra deste script aqui usando systemd e configurando o parâmetro AllowedCPUs em todos os diretórios raíz de slices?


```sh
command=$2

if [ "$command" = "started" ]; then
    systemctl set-property --runtime -- system.slice AllowedCPUs=0-15
    systemctl set-property --runtime -- user.slice AllowedCPUs=0-15
    systemctl set-property --runtime -- init.scope AllowedCPUs=0-15
elif [ "$command" = "release" ]; then
    systemctl set-property --runtime -- system.slice AllowedCPUs=0-31
    systemctl set-property --runtime -- user.slice AllowedCPUs=0-31
    systemctl set-property --runtime -- init.scope AllowedCPUs=0-31
fi
```


Ctrl-C pra parar o loop infinito e agora podemos criar sub-diretórios e arquivos usando comandos normais como "mkdir", "echo" ou podemos continuar usar o SystemD pra facilitar, que é o que vou fazer agora. Vou criar um slice pra mim chamado "akita.slice" em "/etc/systemd/system/akita.slice". Só abrir com qualquer editor de textos usando "sudo" e no caso quero limitar o uso de CPU em só 30% pra processos neste cgroup. Pra isso coloco este conteúdo:

```
[Slice]
CPUQuota=30%
```


Posso configurar outros limites, como memória, mas pra esse exemplo, só isso já funciona. Agora vou abrir um shell dentro desse cgroup com este comando `systemd-run --slice=akita.slice --uid=akitaonrails --shell` e nessa linha de comando que abriu, vou repetir o mesmo comando `ruby loop.rb`. 







Olha o htop. Tá vendo aqui no topo da lista? Antes o script consumia 100% de uma thread, mas como agora reiniciei a partir do meu novo cgroup,que só permiti usar 30% da CPU, a kernel obriga a usar no máximo 30% da CPU. E com isso conseguimos controlar granuladamente o que cada processo no sistema pode ou não consumir.







E por que eu iria querer limitar um programa forçado assim? No Wiki do site do ArchLinux tem um exemplo no fim. Ele menciona o Matlab, que é um programa de cálculo numérico e, dependendo da complexidade do cálculo, pode consumir toda a RAM e toda CPU do sistema. Se um programa usar todos os recursos, vai faltar CPU e RAM até pra kernel e o sistema inteiro vai ficar lento ou crashear. É um tipo de ataque de DoS. DoS ou Denial of Service é um programa saturar todos os recursos da máquina até tudo parar de funcionar. Mas se colocar o Matlab num cgroup onde limito CPU e RAM pra, digamos, deixar sobrar uns 10%, a kernel vai ter a possibilidade de tentar se corrigir.








Depois leia mais sobre cgroups no Wiki do Arch. Mas o importante foi pra explicar que existe esse recurso em todo Linux moderno. Agora vou pular pro segundo grande recurso pra limitar o que processos podem fazer, que se chama "Namespaces". Quando listo o que tem em "/proc" consigo enxergar todos os PIDs de todos os processos rodando no sistema. Se rodar o comando "mount" consigo ver todos os pontos de montagem ativos no sistema. E existem comandos ou locais onde posso listar a stack de rede, IPC que é comunicação inter-processos, IDs de usuários e grupos. 








Mas é possível esconder todos esses detalhes de um processo. Pra isso existe o comando `unshare`, literalmente "descompartilhar". Num terminal normal, se executarmos o comando `ps aux` isso vai nos devolver uma lista com todos os processos ativos neste momento, e costuma ser uma lista grande num desktop normal. Vamos abrir um novo shell, mas fazendo `sudo unshare --fork --pid --mount-proc /bin/bash`. Parece nada demais né? Mas se executarmos `ps aux` olha só, cadê todos os meus processos? Sumiu? O bash agora tem PID 1.








É isso que se chama namespace, é um espaço separado de nomes, no caso de PIDs. Se abrir outro terminal e executar `ps aux` tá tudo aqui bonitinho e lá no final olha o comando unshare e a instância de bash rodando com um PID alto. A diferença é que o bash que acabamos de abrir não enxerga mais o mesmo "/proc" global. Ele tem um "/proc" local só pra ele, isolado e separado que começa do 1 de novo. De dentro daquele bash, vamos listar o que tem em "/proc", só os dois PIDs que listou. No outro terminal normal se listar "/proc" tem todos os PIDs. 







Entenderam? Namespace faz o processo puxar a informação de outro lugar. Estamos mentindo, mas ele continua executando no mesmo sistema, igual qualquer outro programa, tanto que tem um PID de verdade. Pra quem é de Javascript, uma analogia é a diferença de criar uma variável com o antigo "var" pra cair no escopo global da função ou usar "let" e manter a variável no escopo local do bloco, manja? Não é exatamente a mesma coisa, mas é parecido.







Com o recurso de namespaces podemos mentir pros processos pra não enxergar mais o resto do sistema do lado de fora e assim limitar o que podem fazer. Por padrão, todos os recursos do sistema operacional são globais, todo processo tem acesso a praticamente tudo que outro processo tem, salvo permissões de leitura e execução por usuário, que você tá mais acostumado a pensar, tipo, root tem acesso a tudo. Mas com `unshare` inclusive note que ele engana meu processo fazendo achar que é root. Se executarmos o comando `id` olha, sou o usuário zero.







Como executamos unshare com sudo, esse root tem o mesmo nível de privilégio do root de verdade, o que não é muito seguro. Vamos dar exit e executar a mesma linha de comando mas com a opção "--user" e pronto. Se executarmos "id" agora sou nobody, literalmente um zé ninguém. Mais útil vai ser rodar como root, só que não tendo acesso ao sistema de arquivos todo. Vamos consertar isso.







Se assistiu meus episódios de Linux, viu minha explicação sobre chroot. Um container de verdade não usa chroot, mas pra demonstração dos conceitos vai servir. Teve um palestrante que já demonstrou isso anos atrás e deixou alguns arquivos que vamos precisar. Vou deixar o link na descrição abaixo, vamos baixar o tarball "rootfs.tar.gz".


`wget https://github.com/ericchiang/containers-from-scratch/releases/download/v0.1.0/rootfs.tar.gz`




Pronto, baixei lá no "/tmp" mesmo porque é só pra demonstração. Agora é só descomprimir com `tar xvfz`, esperar um segundo ... e tá lá. Se listarmos o que tem, parece com a raíz do seu HD, não? É uma mini-distribuição do que chamamos de "userland". Se listar o "rootfs/boot" não tem a kernel nem a initram que deveria. E o que fazemos com isso? É como na instalação do Gentoo, fazemos `sudo chroot rootfs /bin/bash`. Ele vai fazer "change root", mudar a raíz, pra esse diretório rootfs e executar o bash dentro do sub-diretório "rootfs/bin" e não o meu de verdade.







`ls` dá pau agora. Isso porque esse shell não carregou perfil nenhum, então não tem nenhuma variável de ambiente configurado. Vamos exportar o path de novo com `export PATH=/sbin:/bin:/usr/bin` e agora sim temos acesso às ferramentas nesses diretórios. É assim que sua distro Linux faz, só que isso já vem configurado automático pra você, mas na mão é assim que fazemos. 







Essa variável provavelmente está no seu arquivo "/etc/profile" ou .bashrc ou .zshrc da vida. Executando `ls /` parece que não aconteceu nada, mas faz `ls /boot`, viu? Vazio. Estamos dentro do diretório "rootfs" que está sendo mascarado pra gente como se fosse a nova raíz. Esse shell não tem mais acesso ao meu sistema de arquivos de verdade.







Agora tentamos executar `ps` e dá pau. Isso porque não existe nenhum mount de diretórios especiais, como o "/proc" que é onde comandos como "ps" pesquisam processos. Veja o erro, ele manda justamente dar mount nisso. Mas agora é que vamos juntar esse comando de chroot com o unshare. Então damos exit e executamos o comando `sudo unshare -p -f --mount-proc=/tmp/rootfs/proc chroot rootfs /bin/bash`






A opção "-p" é o jeito mais curto pra "--pid" e "-f" é pra "--fork". Daí montamos o proc e damos chroot via unshare. Não podemos esquecer de exportar o PATH de novo. Pronto. Se fizermos `ls /boot` tá vazio. Se fizermos `ls /home`, tá vazio. Ou seja, esse não é seu sistema, ele está enxergando a raíz a partir do diretório "/tmp/rootfs". Mas agora se rodarmos `ps aux`, sucesso! Só enxergamos os processos dentro do novo namespace. Não só escondemos os PIDs de todo o sistema como escondemos o sistema de arquivos e você pensa que está num sistema completamente diferente.







Esse é o ponto que confunde todo mundo. O comportamento dentro desse shell faz parecer que estou dentro de uma máquina virtual. Mas isso não é uma máquina virtual, não tem um hypervisor como KVM com um emulador como QEMU simulando uma máquina nova do zero e fazendo boot de um novo kernel. Por isso estou reforçando que o diretório falso "/boot" tá vazio, não tem outra kernel. Isso não é uma máquina virtual. E se voltarmos pra outro terminal e executarmos `ps aux` esse bash que abrimos dentro do chroot tá aqui, aparecendo normalmente como se fosse qualquer outro processo. 









Se não ficou claro. Alt-tab pro shell dentro do chroot. Executando `ls /usr/bin` vamos abrir um programa que tem aqui. Olha só, veio um python naquele tarball, vamos executar. Esse é o REPL de python que vocês já devem ter visto. Alt-tab pro terminal normal e `ps aux` de novo. Olha só aparecendo aqui python. Se fosse uma máquina virtual, teria um  único processo, por exemplo de QEMU e só, eu não estaria vendo os processos dentro da máquina virtual misturado com os do meu sistema. E isso porque esses processos ESTÃO rodando no meu sistema normalmente, sem emulação, nem nada disso, é nativo.







Se não fosse assim, chamaríamos tudo de máquina virtual. Mas por isso inventamos esse termo novo chamado "container" justamente pra ser distinto. O processo está só sendo enganado, achando que está num outro sistema porque cortamos os olhos dele, as mãos dele, o nariz dele. E só apontamos tudo pra outros namespaces É isso que unshare e chroot fizeram com o shell do bash: isolaram num jarro, num container. Tudo que executa com unshare está na Matrix.








Nessa demonstração simples só escondemos os PIDs, o diretório "/proc" e o sistema de arquivos, mas dá pra mudar a rede, dá pra mudar todos os outros mounts como "/dev" ou "/sys", dá pra fazer ele enxergar outros cgroups, outro clock do sistema, outros usuários e grupos, outro hostname e domainname, ou seja, o processo realmente vai achar que está em outra máquina, sem realmente estar. Ele pára de ter acesso ao resto do sistema e efetivamente roda "isolado", que é todo o objetivo.







Namespaces são super flexíveis. Por exemplo, se isolar o container numa rede virtual, é assim que o processo num container consegue dar bind, digamos na porta 80, e um outro processo em outro container também consegue subir na porta 80, cada um numa rede isolada que daí configuro pra expor um pra fora como porta 4001 e outra como 4002. Mas também posso adicionar esses dois containers ambos no mesmo namespace de rede e assim crio uma rede virtual só entre os dois, sacaram? Pra isso serve o comando `nsenter` que é literalmente "entrar num namespace", depois pesquisem.







Pesquisem no Google por "container from scratch" ou "container do zero" e vão esbarrar em artigos como do site da RedHat e diversos outros artigos explicando sobre `unshare`. Mas pra hoje esses exemplos que dei já servem pra continuar a explicação. As coisas começam a ficar confusas porque existem várias ferramentas que funcionam em cima dessa infraestrutura de cgroups e namespaces que expliquei. No começo, no mundo Linux surgiu Linux Containers ou LXC e depois Docker. 








Em 2015 a empresa do Docker criou a Open Container Initiative ou OCI, um grupo com várias outras empresas pra padronizar e tornar mais portável todos os componentes que fazem containers funcionar, em particular o formato de imagens que é o formato OCI image, é o que você baixa do site dockerio.com. Os padrões estão todos na opencontainers.org e no mundo Linux a implementação desse padrão é a tecnologia "runC". Vamos ver como funciona.





O runC precisa de um arquivo "config.json" que define as características do container. E vamos aproveitar aquele diretório "rootfs" ainda. O próprio comando runc gera esse arquivo executando `runc spec` dentro do diretório rootfs mesmo. 


```json
{
	"ociVersion": "1.0.2-dev",
	"process": {
		"terminal": true,
		"user": {
			"uid": 0,
			"gid": 0
		},
		"args": [
			"/bin/bash"
		],
		"env": [
			"PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
			"TERM=xterm"
		],
		"cwd": "/",
		"capabilities": {
			"bounding": [
				"CAP_AUDIT_WRITE",
				"CAP_KILL",
				"CAP_NET_BIND_SERVICE"
			],
			"effective": [
				"CAP_AUDIT_WRITE",
				"CAP_KILL",
				"CAP_NET_BIND_SERVICE"
			],
			"permitted": [
				"CAP_AUDIT_WRITE",
				"CAP_KILL",
				"CAP_NET_BIND_SERVICE"
			],
			"ambient": [
				"CAP_AUDIT_WRITE",
				"CAP_KILL",
				"CAP_NET_BIND_SERVICE"
			]
		},
		"rlimits": [
			{
				"type": "RLIMIT_NOFILE",
				"hard": 1024,
				"soft": 1024
			}
		],
		"noNewPrivileges": true
	},
	"root": {
		"path": "/tmp/rootfs",
		"readonly": true
	},
	"hostname": "runc",
	"mounts": [
		{
			"destination": "/proc",
			"type": "proc",
			"source": "proc"
		},
		{
			"destination": "/dev",
			"type": "tmpfs",
			"source": "tmpfs",
			"options": [
				"nosuid",
				"strictatime",
				"mode=755",
				"size=65536k"
			]
		},
		{
			"destination": "/dev/pts",
			"type": "devpts",
			"source": "devpts",
			"options": [
				"nosuid",
				"noexec",
				"newinstance",
				"ptmxmode=0666",
				"mode=0620",
				"gid=5"
			]
		},
		{
			"destination": "/dev/shm",
			"type": "tmpfs",
			"source": "shm",
			"options": [
				"nosuid",
				"noexec",
				"nodev",
				"mode=1777",
				"size=65536k"
			]
		},
		{
			"destination": "/dev/mqueue",
			"type": "mqueue",
			"source": "mqueue",
			"options": [
				"nosuid",
				"noexec",
				"nodev"
			]
		},
		{
			"destination": "/sys",
			"type": "sysfs",
			"source": "sysfs",
			"options": [
				"nosuid",
				"noexec",
				"nodev",
				"ro"
			]
		},
		{
			"destination": "/sys/fs/cgroup",
			"type": "cgroup",
			"source": "cgroup",
			"options": [
				"nosuid",
				"noexec",
				"nodev",
				"relatime",
				"ro"
			]
		}
	],
	"linux": {
		"resources": {
			"devices": [
				{
					"allow": false,
					"access": "rwm"
				}
			]
		},
		"namespaces": [
			{
				"type": "pid"
			},
			{
				"type": "network"
			},
			{
				"type": "ipc"
			},
			{
				"type": "uts"
			},
			{
				"type": "mount"
			},
			{
				"type": "cgroup"
			}
		],
		"maskedPaths": [
			"/proc/acpi",
			"/proc/asound",
			"/proc/kcore",
			"/proc/keys",
			"/proc/latency_stats",
			"/proc/timer_list",
			"/proc/timer_stats",
			"/proc/sched_debug",
			"/sys/firmware",
			"/proc/scsi"
		],
		"readonlyPaths": [
			"/proc/bus",
			"/proc/fs",
			"/proc/irq",
			"/proc/sys",
			"/proc/sysrq-trigger"
		]
	}
}
```


Agora que vocês viram a demonstração com unshare, esse arquivo não deveria parecer muito alienígena. Inclusive foi por isso que fiz videos explicando Linux antes, porque precisa entender o sistema operacional pra entender como containers são configurados. Esse arquivo começa declarando a versão do padrão OCI, daí qual processo vamos rodar, que é o bash, e com qual usuário e grupo, no caso zero quer dizer root.  Olha como já configura o PATH pra mim. "CWD" é Current Working Directory que é o diretório onde o programa vai abrir. 





Capabilities pula que vou explicar depois. Daí "root" quer dizer a raíz do sistema de arquivos, que vai ser dentro daquele /tmp/rootfs onde fizemos chroot. Hostname é o nome da máquina, que é definido pelo namespace UTS, assim o container pode ter um nome de máquina diferente do nome da máquina de verdade.






No atributo de mounts aparece a mesma coisa que fizemos com a opção "--mount-proc" do comando unshare, onde mandamos dar mount no sistema de arquivos especial de processos. Assim, dentro do container não vai mais enxergar os pids de verdade do lado de fora. Mas aqui tá mais completo porque vai dar mount pra "/dev", pros pseudo terminais em "/dev/pts", pra memória compartilhada que é "/dev/shm", as filas de mensagem pra comunicação entre processos em "/dev/mqueue", o "/sys" que espelha funcionalidades e informações da kernel e finalmente o mount de cgroup que mostrei no começo do video. Tudo isolado dos de verdade do lado de fora do container. Estamos deixando esse jarro o mais realista possível pro processo dentro.






E por fim quais namespaces vou isolar também que são os mesmos do unshare. Pid sabemos que esconde os processos, mas temos network pra rede virtual, ipc que é a fila pra comunicação interprocessos, uts que permite mudar o hostname interno e mount que permite criar mounts diferentes do seu sistema.







Com tudo configurado, podemos executar, a partir de rootfs, `sudo runc start hello`. Hello você pode substituir por um nome qualquer pra esse container, contanto que seja um nome único, daí podemos criar quantos containers quisermos. Como aconteceu antes quando rodamos unshare com chroot, caímos no bash dentro do jarro, com todos os seus sentidos sequestrados. RunC está mentindo pro bash, vamos ver?







Se digitarmos `id` estamos como root. Se executarmos `ls /boot`, tá vazio, estamos dentro do diretório rootfs como nova raíz de arquivos. Melhor ainda, se digitarmos `mount`, temos só os pontos de montagem que definimos no `config.json`. Ele não enxerga nenhum dos pontos de montagem de verdade do meu sistema. E se digitarmos `ps aux`, como antes, só enxergamos o bash que está rodando. É como se fosse uma máquina de verdade vazia. Estamos dentro da Matrix, mas repetindo, isso não é uma máquina virtual. Container, na prática é outro nome dado a um processo em execução com menos acessos que um processo normal, mas no fundo é só isso: a execução de um processo.







O que eu falei no começo do episódio? Vou repetir: Se fosse fazer um TLDR, uma única frase que resume a diferença, é até simples: uma máquina virtual roda um novo kernel em qualquer arquitetura, um container reaproveita o mesmo kernel, nas mesma arquitetura. É essa a diferença. Mas agora vamos ver na prática. Estou repetindo o tempo todo que "/boot" está vazio. Não tem outra kernel, estamos compartilhando a mesma kernel. Hypervisors compartilham o hardware de verdade, como CPU, GPU e dispositivos pra máquinas virtuais que rodam qualquer outro sistema operacional, qualquer nova kernel isolados um dos outros. Posso rodar Windows do lado de BSD. Mas um container compartilha o mesmo kernel que existe já carregado. Ele não pode rodar sistemas operacionais diferentes, só outra distro Linux.









Vamos voltar pro que eu disse no começo: como Windows e MacOS fazem pra ter containers de Docker de Linux? Eles sim, primeiro precisam usar o hypervisor deles, o Hyper-V ou o Hypervisor.framework pra bootar um Linux de verdade e em cima desse Linux rodar o RunC pra conseguir ter containers de Linux. Por isso Docker é sempre mais pesado em cima de Windows do que direto num Linux. Numa distro Linux não tem a necessidade de rodar um hypervisor antes. Entenderam essa diferença? É muito importante, porque sua performance e uso de recursos como RAM sempre vai ser pior no Docker pra Windows ou pra Mac. Sempre, não tem exceção.






Mas eu falei Docker e fiquei mostrando RunC, qualé? É porque depois que a OCI foi formada, o Docker, Podman, Kubernetes, todos que usam containers, provavelmente usam RunC por baixo, que é a infraestrutura que usa cgroups, unshare e outras coisas que vem em todo Linux. Mas se tem RunC então pra que precisamos de Docker? 






A parte importante do Docker não é mais a capacidade de executar containers. Hoje em dia isso vem nativo na kernel do Linux através do RunC que mostrei. O grande lance de Docker é o ecossistema de imagens, o DockerHub. Como é o tutorial de hello world de Docker logo depois que instala? `docker run hello-world`, vamos executar no terminal. Ele imprime esse texto e termina. O que aconteceu?







A ferramenta começa checando no registry local se tem uma imagem com nome "hello-world". Como não tinha, deu "pull", como se fosse o comando `git clone` ou mais especificamente, `git pull`. Já explico porquê, mas na prática baixou o binário do site hub.docker.com. Podemos ir no site deles e ver o registro dessa imagem lá, tão vendo? Na dúvida ele baixa da tag "latest". É o equivalente à branch "main" ou a antiga "master". 







Essa imagem baixada é que nem aquele nosso diretório "/tmp/rootfs" que eu tinha baixado o tarball, onde demos chroot. Com essa imagem o runC sobe um container. Pra ver o container que executou basta rodar o comando `docker container ls --all`. Sem essa opção a lista seria vazia porque o container executa e termina. Com essa opção "all" ele mostra mesmo os terminados. Lembra no comando "runc" que dei o nome de "hello" pro container? No comando de `docker run` poderia passar a opção "--name" mas como não fiz isso ele deu um nome aleatório pro container.







Agora uma coisa que a maioria que já usou Docker nunca deve ter feito. Vamos executar o comando `docker export NOME_CONTAINER > rootfs.tar`. Sacaram? Podemos criar um diretório novo "mkdir -p /tmp/rootfs2" e fazer `tar xvf rootfs.tar --directory /tmp/rootfs2`. Agora damos "cd" pra dentro e não tem quase nada lá, alguns diretórios pra fazer mount de procs e outras coisas e esse executável "hello" que podemos executar diretamente com "./hello" e olha só, a mesma saída que vimos antes. É isso que o `docker run` executou e é assim que podemos pegar o conteúdo de uma imagem de Docker. Uma imagem de Docker não é muito diferente de um mero tarball.








Vamos entender melhor essa tal imagem. Pra começar, de volta no site do DockerHub vamos escolher a imagem do banco de dados Postgres. Agora vamos abrir do lado outro navegador com o arquivo Dockerfile no Github do repositório docker-library. Se clicarmos na tag "latest" podemos ver o que ele chama de layers. Sem ir linha a linha, só de bater o olho, conseguem ver onde um lado bate com o outro? Por exemplo, no Dockerfile tem esse comando "ENV GOSU_VERSION". O comando ENV de Dockerfile serve pra configurar uma variável de ambiente, equivalente ao comando `export` num Bash. Todos esses "/bin/sh" são esses comandos RUN e assim por diante.








O que é um Dockerfile? É como se fosse um script de comandos que diz passo a passo como montar a tal imagem de Postgres. Voltando pra primeira linha, começa com o comando FROM. Não precisamos começar uma imagem do zero, podemos começar com uma que já existe e construir por cima. É como se fizéssemos `git clone` de um projeto e começássemos a adicionar coisas e ir fazendo `git commit`.






A grosso modo, cada comando do Dockerfile, esses em letra maiúscula no começo da linha, vão gerar um dos layers que vemos aqui no site do DockerHub. Com exceção de layers de configurar variável de ambiente, que é irrisório, a maioria dos comandos modifica ou baixa arquivos e por isso ocupa espaço. É que nem commit de Git. Por isso é comum num Dockerfile ter comandos RUN que executam vários comandos de shell concatenados, que nem logo no começo que fazemos `apt update; apt-get install ...; rm -Rf`. Por que?






Se o `rm -Rf` estivesse separado em outro comando RUN embaixo, o comando do `apt-get install` ia baixar e instalar pacotes, como em qualquer Debian ou Ubuntu que você usa. Digamos que instalou 50 megabytes, tô chutando. Mas vem um lixo opcional que não preciso, daí no comando seguinte rodo `rm` e apaga 10 megabytes. Mas a imagem vai ter um layer com 50 megabytes. Porque o `rm` ficou num layer separado.






Em vez disso eu baixo os 50 mega, na sequência já apago, e aí fecho a camada com 40 megabytes. Por isso fica tudo dentro do mesmo comando RUN, como se fosse num mesmo commit, entenderam? Quanto menos comando RUN no Dockerfile, melhor. Olha esse outro comando RUN embaixo, um monte de linhas um atrás do outro, e o resultado final de executar tudo é que vai no layer da imagem.







Essa é a importância da OCI que o Docker fundou. Ela define esse formato chamado imagem OCI. Dentro dessa imagem, que é um binariozão parecido com um zipão, tem alguns arquivos e diretórios obrigatórios. Como um `index.json` que tem o nome, ID, tamanho, lista de layers e histórico. Tem o `oci-config.json` que é o equivalente ao `config.json` do RunC que mostrei antes e, o mais importante, o diretório "blobs" que é parecido com diretório ".git/objects" de um repositório Git.







Ah, vocês não assistiram meu video de Git né? Lá eu expliquei que o importante é só o que tem no diretório ".git", todo o resto pode jogar fora porque dá pra recriar tudo com o que tem aqui. Se listarmos `ls .git/objects` vem esse monte de subdiretórios. Vamos listar um deles e encontramos um arquivo com nome que é um SHA1. Esse é o SHA1 do commit de git. Os blobs da imagem de Docker é similar só que otimizados pra layers binários numa árvore, enquanto Git é otimizado pra árvore de commits de texto.







Lembram do formato QCOW2 que mostrei no episódio anterior? O QEMU Copy-on-Write versão 2 que é a imagem de HD virtual que o QEMU usa e onde instalamos o Windows virtualizado? É similar. O formato de imagem OCI também suporta copy-on-write. Que é o mesmo recurso que tem disponível em sistemas de arquivos modernos como o BTRFS. Um snapshot de BTRFS é similar com snapshot de QCOW2 que é parecido com layers de imagem OCI. COW permite criar layers só realmente com a diferença dos blocos que mudaram num arquivo.







Sabe diff que fazemos em Git e ele grava no commit só as linhas que foram adicionadas e as que foram removidas e não o arquivo todo? COW é como se fosse diff de arquivo binário. E lembra que eu venho repetindo em todos os videos da mini-série de armazenamento como arquivos são nada mais do que um conjunto de blocos binários organizados numa árvore? Se um arquivo tem 100 megabytes, divididos em 100 blocos de 1 megabyte, digamos que só 10 blocos desse arquivos foram alterados. Na próxima camada, ou commit, não precisa repetir os 100 megabytes inteiros do arquivo, só os 10 blocos modificados ocupando 10 megabytes. É por isso que imagens de Docker não são pesados.








Pra construir uma imagem nova só precisamos ter o arquivo Dockerfile como esse do Postgres e rodar o comando `docker build`. Se resolvermos mudar o Dockerfile a partir da metade, e repetirmos o comando `docker build`. Todas as camadas geradas pela primeira metade de comandos do arquivo permanecem as mesmas, jogamos fora as últimas camadas e ele executa os comandos a partir da metade. Por isso que quanto mais pro começo de um Dockerfile você mexer, mais o `docker build` vai ter que trabalhar. Se mexer só na última linha, só ela que vai ter que rodar.







Então uma imagem de OCI ou Docker é um conjunto de camadas binárias, como commits de um git. Pra montar dentro do container o Docker usa um sistema de arquivos chamado overlay2 que é um Union Filesystem. Union significa que unifica as diversas camadas num sistema de arquivos único. O container em si não sabe que tem essas camadas todas por baixo. Isso só importa pra construção da imagem, não pra rodar. 






Eu menti agora pouco pra vocês. RunC é a infraestrutura de containers no Linux que sistemas como Kubernetes e Podman usam, mas o Docker propriamente dito na verdade usa outra coisa, que é o "containerd". Pense assim, RunC tem menos funcionalidades, é mais simples, mais leve e pode rodar em userland, ou "rootless", sem permissões de root ou daemons. Já containerd tem mais funcionalidades e foi feito pra funcionar com um daemon que sobe como root. 






Por isso que quando se instala Docker, todo tutorial vai te falar pra executar "systemctl start docker" e habilitar o serviço pra subir no boot com "systemctl enable docker". E isso pode se tornar um problema de segurança. Se sair pesquisando sobre buracos no Docker, vai achar várias formas de exploit dependendo de como o container foi configurado pra subir. O caso mais besta é subir um container com um comando como esse: `docker run -tid -v /:/mnt/ alpine`. Estão enxergando o erro?







O problema é essa opção "-v" que é pra mapear volumes. Lembra que quando estamos dentro da imagem o processo dentro não enxerga nada do sistema de arquivos fora? Pois bem, no mundo real o container é mais útil se ele tem "algum" acesso ao mundo externo. É melhor ser o Neo, saber que o mundo real existe, e ter superpoderes dentro da Matrix e um deles é conseguir enxergar arquivos do sistema de verdade.






Essa opção "-v" monta um diretório do lado de fora pra um diretório do lado de dentro, no caso do exemplo vai montar a raíz de verdade do meu HD pra um diretório "/mnt" no container. Mas isso é uma burrice, nunca faça um ponto de montagem tão amplo. Como o daemon que roda o container, o containerd que o Docker usa, sobe como root, ele tem permissão pra editar qualquer arquivo do sistema de verdade a partir desse ponto de montagem.







Daí é game-over, posso fazer o que quiser, inclusive editar o arquivo "/etc/passwd" pra injetar um novo usuário com permissão de root na máquina de verdade e invadir ela. Eu acho que ninguém em sã consciência jamais subiria um container de Docker num servidor de produção apontando pra raíz do HD do servidor. Só um sem noção faria isso. Seria certificado de estupidez. 








É uma das razões de porque muitos de nós preferimos usar Podman em vez de Docker. Podman foi feito pra ter todos os mesmos comandos, mesmas opções e mesma sintaxe de Docker. Então comandos como `docker build` ou `docker run -it bla bla` posso rodar com `podman build` ou `podman run bla bla`. Se quiser posso fazer um alias no shell chamado docker que aponta pro podman e tudo vai funcionar praticamente igual. Podman usa o mesmo arquivo Dockerfile com a mesma sintaxe, a única diferença é aquele comando FROM no começo do arquivo.







Por exemplo, no caso do postgres começa com "FROM debian". Pro Podman suportar precisa reescrever como "FROM docker.io/debian". Só especificar o site da imagem porque ele suporta outros repositórios em vez de só o dockerhub. Outra diferença é que Docker é construído em cima do containerd, mas Podman usa o RunC como mostrei antes. Diferente do containerd não precisa ter um daemon rodando como root. Na verdade RunC, e por consequência o Podman, tem modo "rootless". Ou seja, nem preciso iniciar com "sudo". Portanto o container consegue rodar sem privilégio nenhum e por padrão é mais seguro. Veja documentação deles de como funciona esse modo porque não vou detalhar hoje.








E falando em segurança e permissões, pra concluir, faltou falar daquele bloco no arquivo do `config.json` que falei pra pular, lembram? Capacidade ou Linux Capabilities. Toda vez que se fala em permissões em Linux, automaticamente pensamos em coisas como os comandos "chown" pra mudar a propriedade de algum arquivo ou "chmod" pra mudar um arquivo pra ser só de leitura por exemplo. Ou, usar ou não usar "sudo" pra executar alguma coisa. E é isso, acabou.







Só que não. De cara vocês já aprenderam sobre cgroups e como eles limitam os recursos do processo, ou namespaces e como o sistema mente pros processos, independente se tem permissão de root ou não. E tem muito mais em cima. Linux capabilities é a habilidade da kernel de dar ou remover capacidades com o comando `setcap`. 






Vou tentar não descer em detalhe desnecessário demais, mas num terminal o primeiro comando pra entender capabilities é o `capsh`. Execute num terminal e vemos dois campos no começo: Current e Bounding Set. Current vazio significa que um usuário normal começa sem nenhuma capacidade por default, mas tem várias capacidades que podem ser habilitadas, que é essa lista enorme chamada de Bounding Set.







Existem dois tipos de capacidades em Linux: capacidades efetivas e capacidades permitidas. Capacidades efetivas determinam quais operações um processo pode performar, e capacidades permitidas são quais podem ser habilitadas ou desabilitadas. Bounding Set é um sub-conjunto de capacidades permitidas. E quem controla esse set é o comando `prctl`, depois pesquise porque não quero entrar em detalhes sobre granularidade de segurança de Linux hoje.







Próximo comando vai ser `grep Cap /proc/$BASHPID/status`. Essa variável BASHPID é o pid do bash. Aí aparece essa lista bizarra, mas é fácil. O primeiro são inherited capabilities, ou capacidades herdadas no caso zero. Segundo são capacidades permitidas que eu falei, zero. Terceiro capacidades efetivas que também expliquei, zero. Finalmente capacidades bounding set.






Com o comando `capsh --decode=` esse hexadecimal e a lista é, obviamente, a mesma que vimos no comando `capsh --print` antes. Isso fica guardado no objeto proc do processo. E esse hexadecimal é um bit set. Um conjunto de bits. Se você não conhece a técnica de guardar propriedade num bit dentro de um inteiro e pegar os valores com uma máscara binária, um bit mask, pesquise. É essencial pra economizar bits em coisas como protocolos de rede.






De qualquer forma veja de novo aquele bloco de capabilities em `config.json`, agora você sabe o que é efetivo ou permitido. Esses cap_ alguma coisa tem que ler no manual de capabilities. Só digitar `man capabilities` no terminal. Pronto, cap_audit_write é capacidade de escrever no log do sistema, cap_kill é capacidade de enviar sinais tipo SIGTERM ou SIGKILL e cap_net_bind_service é pra conseguir dar bind em portas privilegiadas abaixo de 1024, como a porta 80 sem precisar fazer sudo.






Com isso vocês tem pelo menos noção agora do que são containers do ponto de vista da kernel do Linux. Eles não são máquinas virtuais. É simplesmente um jarro que a kernel cria ao redor de um processo que roda nativamente pra restringir o que ele pode ver ou acessar, fazendo esse processo acreditar que está sozinho em outra máquina. A kernel usa cgroups e capabilities pra limitar os recursos e capacidades que esse processo tem acesso e usa namespaces pra limitar os sentidos desse processo, fazendo enxergar coisas como pids, mounts, rede, e tudo mais que são falsos, dentro da Matrix.







Docker é implementado em cima de containerd que é um serviço que precisa rodar como root. Podman e Kubernetes são implementados em cima de RunC que é mais leve e sem necessidade de um daemon auxiliar. Falando nisso, pode ser que Kubernetes ou Terraform confundam pra quem nunca mexeu. Qual a diferença disso pra Docker ou Docker Compose?







Vamos lá. Dockerfile vocês já entenderam, servem pra construir imagens OCI. Docker Compose é hiper útil, tem o Podman Compose que é exatamente a mesma coisa pra quem escolher usar Podman. Ambos começam com um arquivo `docker-compose.yml`. Deixa eu dar um exemplo besta aqui. Digamos que está trabalhando num projeto em Node. Comece criando um Dockerfile que constrói a imagem do seu projeto Node com seguinte conteúdo:


```docker
# Use the latest LTS (long-term support) version of Node.js as the base image
FROM docker.io/node:lts

# Set the working directory to the project root
WORKDIR /app

# Copy the package.json and package-lock.json files to the working directory
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the rest of the project files to the working directory
COPY . .

# Expose the app's port
EXPOSE 3000

# Run the app when the container is started
CMD [ "npm", "start" ]
```


Começamos a partir da imagem do Node versão lts em vez do mais novo que é latest, lembram? Projetos em produção precisam de estabilidade e não da versão mais nova que pode ser a mais bugada. Sempre use a mesma versão de tudo na sua máquina de desenvolvimento e nos servidores de produção e isso começa pela image de docker. 






Dentro do container, o código fonte do seu projeto vai ficar nesse WORKDIR, em /app.  Daí copiamos o arquivo package.json pra dentro do container e rodamos `npm install` pra criar o `node_modules` e baixar todas as dependências. Terminamos de copiar todos o códigos fonte do projeto com esse comando COPY. Além disso esse container vai expôr pra fora a porta 3000 que é onde o servidor de node vai dar bind quando rodar o comando que está em CMD, no caso `npm start`.







Não esquecer de também criar um arquivo `.dockerignore` praquele comando COPY não copiar o `node_modules` que está no seu ambiente de desenvolvimento. Dentro do container já rodamos `npm install` então não precisa copiar tudo de novo. É importante entender onde ficam os arquivos em cada ambiente.


```
node_modules
*.log
```


Só com isso já dá pra fazer `docker build . -t seuusuario/seuprojeto` E já dá pra rodar com `docker run -p 3000:3000 seuusuario/seuprojeto`. Digamos que seu projeto precisa ter Redis e Postgres instalado. Isso costuma ser um problema, porque se você for um programador bem ocupado e experiente, na sua máquina deve ter diversos projetos. E alguns mais antigos podem depender de Postgres mais antigo, outros de Postgres mais novo. Mas se instalar na sua máquina via o gerenciador de pacotes da sua distro, sempre vai estar com a versão mais nova só.







Pra ter várias versões de node, muita gente usa o NVM ou o meu favorito que é o ASDF, mas e pra ter várias versões de postgres, de redis, de mysql, de kafka e todos esses outros componentes? E é pra isso que entra o Docker Compose. Este é um exemplo de arquivo `docker-compose.yml` que também ficaria na raíz do seu projeto:


```yaml
version: "3"

services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      - DATABASE_HOST=db
      - DATABASE_USER=app_user
      - DATABASE_PASSWORD=app_password
      - REDIS_HOST=redis
    depends_on:
      - db
      - redis

  db:
    image: docker.io/postgres:latest
    environment:
      - POSTGRES_USER=app_user
      - POSTGRES_PASSWORD=app_password

  redis:
    image: docker.io/redis:latest
```


Docker Compose orquestra e sobe vários containers Docker que ele chama de services. O primeiro é sua aplicação.  Ele começa com o atributo build sendo ponto, que é o diretório atual. Vai subir a imagem que seria construída com o Dockerfile que tá no seu projeto nesse diretório. Daí configuramos o projeto com variáveis de ambiente, por exemplo dizemos que DATABASE_HOST se chama "db". Normalmente você colocaria "localhost", mas cada serviço é como se estivesse rodando numa máquina separada graças ao Namespace UTS que permite que cada um tenha seu hostname separado, por isso o service de Postgres vai se chamar "db".






Logo embaixo começa o bloco "db" onde dizemos que é pra baixar a imagem `docker.io/postgres:latest` e configuramos o usuário e senha, que é o mesmo que o serviço de node da sua aplicação vai usar. Mesma coisa no terceiro service que chamamos de "redis" e baixa imagem docker.io/redis. Latest é a versão mais nova, mas num projeto de verdade é bom fixar uma versão em específico pra não confundir.





Veja também que o serviço app, que é sua aplicação, tem um bloco dizendo "depends_on", ou seja, o docker compose só vai subir sua aplicação depois que os serviços de postgres e redis carregarem. E pronto. Mesmo que você seja um programador que acabou de entrar no projeto, depois de fazer `git clone` do repositório, é só rodar `docker compose up` e pronto! Vai subir todos os serviços e ao final pode ir no navegador a apontar pra localhost:3000 e que vai estar tudo de pé e funcionando. O ideal é manter essa configuração atualizada, porque o que mais acontece é ficar ajustando só na sua máquina e não subir a atualização pro repositório, daí pessoas novas entram na equipe e baixam uma configuração desatualizada e dá vários problemas. Mantenha tudo atualizado.






De bônus, lembra do video de otimização web onde explico sobre coisas como NGINX? Podemos simular o que eu falei naquele video com docker compose. Não é uma coisa que faríamos num projeto de verdade mas só pra ilustrar como aquele diagrama conceitual viraria código de Docker Compose:


```yaml
version: "3"

services:
  app_1:
    build: .
    ports:
      - "3000"
    environment:
      - DATABASE_HOST=db
      - DATABASE_USER=app_user
      - DATABASE_PASSWORD=app_password
      - REDIS_HOST=redis
    depends_on:
      - db
      - redis

  app_2:
    build: .
    ports:
      - "3000"
    environment:
      - DATABASE_HOST=db
      - DATABASE_USER=app_user
      - DATABASE_PASSWORD=app_password
      - REDIS_HOST=redis
    depends_on:
      - db
      - redis

  db:
    image: docker.io/postgres:latest
    environment:
      - POSTGRES_USER=app_user
      - POSTGRES_PASSWORD=app_password

  redis:
    image: docker.io/redis:latest

  load_balancer:
    image: docker.io/nginx:latest
    ports:
      - "8080:80"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
    depends_on:
      - app_1
      - app_2
```

Os serviços app, redis e postgres são iguaizinhos o do exemplo anterior mas agora adicionei um "load balancer" que puxa a imagem do nginx. Lembram que expliquei naquele video que ele é quem realmente responde na porta 80? E pro nginx funcionar precisa ter um arquivo `nginx.conf` no seu projeto que instruímos o docker compose copiar pra dentro do container de nginx. Esse arquivo diz o seguinte:

```
user                 nginx;
worker_processes     auto;

events {
    worker_connections  65535;
    multi_accept        on;
}

http {
    charset              utf-8;
    sendfile             on;
    tcp_nopush           on;
    tcp_nodelay          on;
    client_max_body_size 4m;

    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    map $remote_addr $proxy_forwarded_elem {

        # IPv4 addresses can be sent as-is
        ~^[0-9.]+$        "for=$remote_addr";

        # IPv6 addresses need to be bracketed and quoted
        ~^[0-9A-Fa-f:.]+$ "for=\"[$remote_addr]\"";

        # Unix domain socket names cannot be represented in RFC 7239 syntax
        default           "for=unknown";
    }

    map $http_forwarded $proxy_add_forwarded {

        # If the incoming Forwarded header is syntactically valid, append to it
        "~^(,[ \\t]*)*([!#$%&'*+.^_`|~0-9A-Za-z-]+=([!#$%&'*+.^_`|~0-9A-Za-z-]+|\"([\\t \\x21\\x23-\\x5B\\x5D-\\x7E\\x80-\\xFF]|\\\\[\\t \\x21-\\x7E\\x80-\\xFF])*\"))?(;([!#$%&'*+.^_`|~0-9A-Za-z-]+=([!#$%&'*+.^_`|~0-9A-Za-z-]+|\"([\\t \\x21\\x23-\\x5B\\x5D-\\x7E\\x80-\\xFF]|\\\\[\\t \\x21-\\x7E\\x80-\\xFF])*\"))?)*([ \\t]*,([ \\t]*([!#$%&'*+.^_`|~0-9A-Za-z-]+=([!#$%&'*+.^_`|~0-9A-Za-z-]+|\"([\\t \\x21\\x23-\\x5B\\x5D-\\x7E\\x80-\\xFF]|\\\\[\\t \\x21-\\x7E\\x80-\\xFF])*\"))?(;([!#$%&'*+.^_`|~0-9A-Za-z-]+=([!#$%&'*+.^_`|~0-9A-Za-z-]+|\"([\\t \\x21\\x23-\\x5B\\x5D-\\x7E\\x80-\\xFF]|\\\\[\\t \\x21-\\x7E\\x80-\\xFF])*\"))?)*)?)*$" "$http_forwarded, $proxy_forwarded_elem";

        # Otherwise, replace it
        default "$proxy_forwarded_elem";
    }

    upstream www {
        least_conn;
        server app_1:3000;
        server app_2:3000;
    }
    
    server {
    
        listen 80;
    
        location / {
            proxy_pass http://www;

            proxy_http_version                 1.1;
            proxy_cache_bypass                 $http_upgrade;
            
            # Proxy headers
            proxy_set_header Upgrade           $http_upgrade;
            #proxy_set_header Connection        $connection_upgrade;
            proxy_set_header Host              $host;
            proxy_set_header X-Real-IP         $remote_addr;
            proxy_set_header Forwarded         $proxy_add_forwarded;
            proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
            proxy_set_header X-Forwarded-Host  $host;
            proxy_set_header X-Forwarded-Port  $server_port;
        }
    
    }
}
```


O bloco server, tem a configuração do servidor que vai escutar na porta 80 e fazer o tal proxy reverso pra http://app e app está configurado acima, são os hostnames app_1 e app_2 na porta 3000 de cada container. Lembrem que containers tem rede virtual separada, namespace de portas separado. Então cada um, quando carregar, se penduram na porta 3000 e o nginx vai fazer round robin entre esses dois servidores.






app_1 e app_2 herdam do serviço app que é sua aplicação em Node. Aqui estamos subindo duas instâncias pra ter balanceamento de carga entre os dois. Note que o serviço load_balancer depende desse app_1 e app_2 estarem de pé, e esses dois, por herdarem de app, dependem de redis e postgres estarem de pé e é assim que o docker compose sabe quem tem que subir primeiro pra tudo estar funcionando. E pronto! Isso é uma pequena demonstração de uma aplicação node com dois processos sendo balanceados por um nginx.







Docker Compose foi feito pra infraestrutura bem simples, em particular pra rodar na sua máquina de desenvolvimento e facilitar a vida de programadores. Ele até serve pra fazer deploy em servidores pequenos, tipo numa Digital Ocean da vida. Antigamente tinha um projeto chamado Docker Machine que servia pra conversar com provedores de servidores, mas acho que ninguém usa mais.







Veja como nesse arquivo, pra subir duas instâncias da aplicação, precisou manualmente digitar app_1, app_2, colocar eles no depends_on do load_balancer. Imagina se precisasse subir 10 instâncias. Ou se precisasse configurar replica de Postgres. Ou se precisasse configurar uma fila e vários servidores separados de jobs assíncronos como falei no video do ChatGPT. Esse arquivo não escala, ia ficar complicado ainda mais porque também não sabe só aumentar ou diminuir só os containers de web. Ele não tem noção do que está rodando nos servidores já e só dar manutenção.







É pra isso que entra Kubernetes e Terraform. Kubernetes é um conjunto de tecnologias de infraestrutura elástica. A parte que se aproxima de Docker é o que ele chama de pods, que são containers que rodam com RunC. Mas o Kubernetes faz bem mais, configura VPC que são redes privadas virtuais. Eu posso criar uma rede isolada só pros containers web, outra rede isolada separada só pra servidores de jobs, por exemplo. Sabe lidar com balanceador de carga, o Ingress, adicionar e remover pods dinamicamente, e sabe que está ou na AWS ou no Google Cloud ou na Azure e com isso consigo adicionar serviços exclusivos como o RDS da AWS como banco de dados ou o Cloud SQL do Google Cloud. É bem mais flexível e, por isso, mais complicado.







Entenda, um IaaS ou Infraestrutura como Serviço, como a AWS, me fornece os componentes básicos de infraestrutura. O Kubernetes é melhor pra lidar mais com os pods, os containers, depois que já tem a infra de máquinas e rede pronta. Pra subir essa infra inicial, podemos ou fazer na mão via interface web, o que não recomendamos, ou orquestrar com Terraform.





Por exemplo, máquinas virtuais que o AWS chama de EC2. Esses servidores tem tamanhos diferentes, por exemplo t2.nano que só tem 1 vcpu ou t2.xlarge de 4 vcpus ou a1.metal com 16 cpus, ou m4.16xlarge de 64 vcpus, cada um com um preço diferente por hora. Tem planos diferentes pra S3, pra RDS, pra SQS, e assim vai. E isso só na AWS. Pra organizar tudo, usamos Terraform. Deixa mostrar só alguns trechos de um exemplo de arquivo de configuração, que pode ficar super comprido.

```
# Set up the provider for the desired cloud provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC to host the resources
resource "aws_vpc" "app_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create a public subnet in the VPC
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.app_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

# Create an Internet Gateway and attach it to the VPC
resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id
}

# Create a route table and a route for the public subnet
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.app_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }
}

# Associate the public subnet with the route table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id
}

# Create an EC2 instance to host the Node.js application
resource "aws_instance" "app_server" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
  vpc_id        = aws_vpc.app_vpc.id
  subnet_id     = aws_subnet.public_subnet.id
  key_name      = "app-key"
  user_data     = "${file("user_data.sh")}"
}

# Create a security group for the EC2 instance
resource "aws_security_group" "app_server_sg" {
  name        = "app_server_sg"
  description = "Security group for the application server"
  vpc_id      = aws_vpc.app_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an RDS instance for Postgres
resource "aws_db_instance" "app_db" {
  engine               = "postgres"
  engine_version       = "11.5"
  instance_class       = "db.t2.micro"
  name                 = "app_db"
  username             = "app_user"
  password             = "app_password"
  vpc_security_group_ids = [aws_security_group.app_db_sg.id]
  vpc_id               = aws_vpc.app_vpc.id
  subnet_group_name    = "app_db_subnet_group"
}

# Create a security group for the RDS instance
resource "aws_security_group" "app_db_sg" {
  name        = "app_db_sg"
  description = "Security group for the application database"
  vpc_id      = aws_vpc.app_vpc.id
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }
}

# Create a security group for Redis
resource "aws_security_group" "app_redis_sg" {
  name        = "app_redis_sg"
  description = "Security group for Redis"
  vpc_id      = aws_vpc.app_vpc.id
  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }
}

# Create an Elasticache cluster for Redis
resource "aws_elasticache_cluster" "app_redis" {
  engine            = "redis"
  cluster_id        = "app_redis"
  node_type         = "cache.t2.micro"
  num_cache_nodes   = 1
  security_group_ids = [aws_security_group.app_redis_sg.id]
  vpc_id            = aws_vpc.app_vpc.id
}

# Create an Nginx load balancer
resource "aws_lb" "app_lb" {
  name            = "app_lb"
  internal        = false
  security_groups = [aws_security_group.app_lb_sg.id]
  subnets         = [aws_subnet.public_subnet.id]
  load_balancer_type         = "application"
  idle_timeout               = 60
  enable_deletion_protection = false
}

# Create a security group for the Nginx load balancer
resource "aws_security_group" "app_lb_sg" {
  name        = "app_lb_sg"
  description = "Security group for the application load balancer"
  vpc_id      = aws_vpc.app_vpc.id
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a target group for the Nginx load balancer
resource "aws_lb_target_group" "app_tg" {
  name     = "app_tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.app_vpc.id
  target_type = "instance"
}

# Register the EC2 instance with the target group
resource "aws_lb_target_group_attachment" "app_tg_attachment" {
  target_group_arn = aws_lb_target_group.app_tg.arn
  target_id        = aws_instance.app_server.id
  port             = 80
}

# Create a listener for the Nginx load balancer
resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
```

Veja, o Terraform sabe que o provedor é AWS, e em qual região geográfica, no caso leste dos Estados Unidos, tipo Nova Iorque. Veja configuração de rede privada, subnets, gateway, tabela de rotas, e mais.



Daí contrato um servidor EC2, tamanho t2.micro, e configuro pra rede que tinha declarado antes. Embaixo configuramos grupo de segurança. Depois tenho configuração de banco de dados, depois de Redis que é o serviço que a AWS chama de Elasticache, depois tem o load balancer. E esse arquivo de exemplo é bem simplório e incompleto. Entre Kubernetes e Terraform, tem bastante detalhe pra realmente deployar uma aplicação em produção que esteja configurado de forma eficiente e com segurança.





Numa configuração de verdade, se tudo estiver direitinho declarado, seria só digitar `terraform init`  pra fazer download e instalar os plugins necessários. Daí `terraform plan` pra criar o plano do deployment pra esse provedor e a gente checar se tá tudo realmente certo. Coisa que já tá instalada ele não vai instalar de novo, vai só reconfigurar e instalar o que falta.  E no final fazer `terraform apply` pra realmente contratar os serviços, configurar e colocar nos lugares certos na infra.







Video de hoje não é sobre devops mas já que estou falando de containers e serviços, achei legal só mostrar um exemplo pra quem nunca viu. Mas o ponto é: compare uma configuração longa de Terraform com um simples Docker Compose. Nem chega perto, porque o objetivo das duas ferramentas é diferente. Um é pra orquestrar uma infra de verdade, a outra é pra rodar só na sua máquina pra facilitar desenvolvimento. Pra configurar uma AWS use Kubernetes e Terraform. Pra configurar serviços na sua máquina de desenvolvimento, use Docker Compose. Todo bom projeto deveria ter isso. 









Pra finalizar, não vou mostrar mas queria só explicar outras tecnologias de containers que existem. Expliquei sobre imagens OCI de Docker, mas tem outro projeto que recomendo que pesquisem chamado OSTree. Lembra que falei que uma imagem meio que parece montado com commits binários de um Git? Existe de fato um projeto que é um Git de sistema de arquivos, o OSTree. A idéia é a seguinte: imagina que você tem 100 servidores numa AWS da vida, coisa grande. Imagina se sai atualização do Ubuntu Server que roda lá, o que você vai fazer? Mandar rodar `apt update; apt upgrade -y` e rezar pra não dar pau?







Na verdade não, vai montar imagens com ostree. O sistema de arquivos de todo servidor vai ser como um Git gigante. Daí sai atualização, você atualiza só em uma imagem. O OSTree nos servidores vai baixar a nova imagem e trocar a imagem antiga pela imagem nova. É tipo dar um git pull e trocar pro branch mais novo com um git checkout manja? É uma explicação grosseira, mas é bom saber que isso existe.







Outra coisa é sobre capacidades. Além de Linux capabilities que expliquei antes existem outra formas de limitar acesso a recursos da máquina, especialmente no contexto de segurança. Sabe em aplicativo Android ou iOS hoje em dia que pergunta se você quer dar acesso da camera pra um app ou acesso à sua localização e coisas assim? No mundo Linux isso é responsabilidade de componentes como Seccomp de Secure Computing Mode, que é outra funcionalidade da kernel do Linux pra restringir chamadas de sistema. Ele normalmente é usado em combinação com outros mecanismos de segurança, mas o seccomp em si oferece a infra na kernel pra aplicar filtros nos programas. Se alguém tentar fazer alguma coisa que não deveria, a kernel recusa.







Em cima disso temos projetos como AppArmor e SE-Linux. Olhando só por cima, eles se complementam. Ambos servem pra forçar políticas de segurança nos programas. O AppArmor permite especificar que recursos, como arquivos, dispositivos e sockets de rede um programa tem permissão pra usar. SE-Linux significa Security Enhanced Linux que também força políticas, por exemplo, pra acesso a hardware externo. É ele quem pode proibir um aplicativo de usar sua webcam.







Além disso, do jeito que falei, parece que todo container vai usar Namespaces de Linux com o comando unshare, mas existem outras formas de fazer containers, como o projeto Bubblewrap que é um container mais simples e usa outro recurso da kernel do Linux que são namespaces unprivileged e seccomp-bpf.







Mencionei ostree, seccomp, apparmor, se-linux e bubblewrap porque se você juntar todos eles num único projeto, começa a surgir com coisas como Flatpak. Sabe, aquele instalador de aplicativos? Tecnicamente é como se fosse um Docker ou Podman, mas feito pra funcionar melhor com aplicativos, especialmente aplicativos gráficos, com janela e que precisam acessar seus arquivos, USB e se comunicar com outros programas, precisando ter acesso a serviços como dbus. Tem gente que fica pensando em usar Docker pra instalar um Gimp ou LibreOffice. Não né, pra isso serve Flatpak.







Flatpak roda aplicativos como Spotify, Discord, Zoom, dentro de containers semi-isolados. Menos isolados que um container de Docker, mas um pouco mais seguros do que se fosse instalado direto via apt ou pacman. E o Snap de Ubuntu é similar, um gerenciador de containers. Em vez dos pacotes serem tipo zips como expliquei no video de Slackware, Flatpak e Snap baixam imagens, como imagens de Docker, só que em vez de imagem OCI é OSTree.







Entenda que Flatpak e Snap são primos de Docker e Kubernetes. As tecnologias por baixo também dependem da kernel do Linux e sempre caímos em cgroups, namespaces, capabilities e algum formato de HD virtual dentro de um linguição de bytes binários que chamamos de imagens. Espero que tenha dado uma luz no entendimento de containers e espero que ninguém mais tenha a pachorra de confundir containers com máquinas virtuais. Se ficaram com dúvidas mandem nos comentários abaixo, se curtiram o video deixem um joinha, assinem o canal e compartilhem o video com seus amigos. A gente se vê, até mais!

