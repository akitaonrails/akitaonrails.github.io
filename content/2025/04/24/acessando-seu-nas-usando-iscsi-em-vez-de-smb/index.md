---
title: Acessando seu NAS usando iSCSI em vez de SMB
date: '2025-04-24T01:00:00-03:00'
slug: acessando-seu-nas-usando-iscsi-em-vez-de-smb
tags:
- nfs
- smb
- iscsi
- synology
- nas
- docker
draft: false
---



Se você tem um NAS ou qualquer tipo de servidor de arquivos na rede, provavelmente o padrão é criar uma pasta compartilhada e depois montar no seu sistema operacional, seja Windows, Mac ou Linux usando o velho, e cansado, protocolo SMB (Samba).

Em Linux, isso é um enorme pé no saco, porque o protocolo SMB (feito pra Windows), não trás direito conceitos como ownership (chown) ou permissões (chmod). Ele não entende coisas como permissão de execução (tudo é executável). Pra coisas simples como diretório de Downloads, Videos, Fotos, meio que não importa.

Mas digamos que queira editar código fonte em projetos com Git. Vai ser um pesadelo, porque o SMB sobrescreve as permissões, independente do que está por baixo, e toda vez vai conflitar com o Git, que vai achar que arquivos foram modificados (mudar permissões é uma mudança que ele guarda), e vai ficar mandando você fazer commit disso, e isso vai sujar todo seu repositório (nunca use projetos Git em SMB na rede).

Em vez disso, eu estou em Linux, meu NAS é Linux. O certo é usar um protocolo de Linux. Esse protocolo é NFS e eu mostrei como configurei isso no [outro post](https://www.akitaonrails.com/2025/04/17/configurando-meu-nas-synology-com-nfs-no-linux) da semana passada.

Enfim, estou usando NFS e com muito menos dor de cabeça de permissões em arquivos. Mas aí tive outro problema: se viu meus últimos posts, viu que fiquei experimentando MUITO com Docker. Gerando imagens novas como se não houvesse amanhã. Rapidamente, meu NVME local de 2 TB encheu e começou a reclamar de falta de espaço. Então pensei, _"Ah, é só mover o diretório de armazenamento do Docker, o /var/lib/docker, pra um diretório montado com NFS no meu NAS"_

Pra fazer isso é muito fácil:

```
sudo mkdir -p /mnt/nfs/docker
sudo chown root:docker /mnt/nfs/docker
sudo chmod 771       /mnt/nfs/docker
```

Isso é pra criar um novo diretório dentro do meu NAS e aplicar as permissões corretas.

```
sudo systemctl stop docker
sudo mv /var/lib/docker /mnt/nfs/docker
# sudo rm -Rf /var/lib/docker (isso vai liberar tudo pra mim)
sudo ln -s /mnt/nfs/docker /var/lib/docker
```

Isso vai liberar todo o espaço ocupado. Não preciso me preocupar com as imagens porque eu posso recriar tudo dos meus Dockerfiles. E não preciso me preocupar com volumes porque não tinha nada importante que não seja montado por fora, em diretórios de verdade. Regra: nunca guarde coisas importantes em volumes de Docker. É uma má prática!

```
# editar /etc/docker/daemon.json
{
  "data-root": "/mnt/nfs/docker"
}

sudo systemctl start docker
```

Pronto, isso muda a configuração de `/var/lib/docker` pro novo `/mnt/nfs/docker` e depois de reiniciar o serviço, ele vai passar a gravar tudo lá. Então acabou o post né?

É até aqui que a maioria vai. Mas se você trabalhar 2 minutos nessa configuração, vai sentir algo MUITO errado.

Eu tentei fazer build de uma nova imagem. E estava demorando ABSURDO. Acontece que NFS é sim, mais rápido que SMB, mas ambos foram feitos pra servidores de arquivos, e não pra sistemas operacionais. Faz muita diferença.

Esses protocolos são **FILE-BASED**, toda operação é baseada em arquivos. E isso é extremamente ineficiente.

Se assistiu meus videos sobre sistemas de arquivos, já deveria saber que eles são **BLOCK-LEVEL**. No nível do sistema de arquivos, se trabalha com blocos de bytes, de tamanho fixo, organizadas em alguma variação de árvores B-TREE (depende do sistema de arquivos). As operações são em nível de bloco. Arquivos são abstrações pra coleções de blocos.

Quando se faz um `chmod -R` que é mudança de permissão recursiva, dentro do build do Dockerfile, por exemplo, mesmo uma árvore vazia vai causar recursão em cada entrada lá dentro, seja arquivos escondidos, ACLs, etc. E ele precisa pesquisar todas as permissões de tudo lá dentro. Isso custa tempo de rede (porque NFS/SMB são protocolos de rede).

Isso causa latência. Cada permissão de cada arquivo é uma chamada remota individual, uma RPC call. Mesmo na rede mais rápida, como a minha de 10Gbps, mesmo que cada RPC seja de menos de 0.1 ms, rapidamente vai dar gargalo. E é isso mesmo que começou a acontecer.

Eu usei `sudo nfsiostat 1 10` pra checar. Tava dando isso:

```
write: ops/s=2417  kB/s≈295 MiB/s  avg exe=106 ms  avg queue=102 ms
```

Média de 106 ms pra cada RPC. Isso é uma eternidade. Tempo médio na fila de espera de 102 ms. Mesmo que que eu faça só 100 chamadas RPC, vai custar mais de 10 segundos só de latência. E num build de sistema operacional, instalando pacotes com milhares de arquivos, isso vai custar literamente uma eternidade. Não é viável usar Docker build em NFS/SMB.

### iSCSI

Obviamente eu não sou o primeiro a esbarrar nesse problema e fazer a besteira de usar um protocolo file-based pra serviços de alto volume de alterações de arquivos como cache de Docker.

O certo é criar um drive virtual iSCSI no meu NAS. Se nunca ouviu falar, SCSI é um protocolo avançado pra drives. Em PCs baratos dos anos 90 e 2000 se usava IDE/ATA, que é um protocolo mais simples e mais barato. Mas os primeiros Mac e workstations UNIX dos anos 80 e 90 sempre usaram SCSI, que era muito superior.

Ele era **assíncrono**, com controle de fila. Dava pra mandar dezenas de comandos de uma só vez e o protocolo era inteligente de reordenar esses comandos pra ter mais eficiência (por exemplo, ignorar leitura de um arquivo se antes veio um comando de deletar). IDE era bloqueante, só um comando por vez. Um único BUS de SCSI conseguia ter até 16 dispositivos. Parallel ATA era 2 por cabo. Ridículo. SCSI tinha sistemas avançados de recuperação de erros e relatórios. Tinha recursos "enterprise" pra hot-swap, gerenciamento de energia, comportamentos de timeout, recuperação, clustering, etc. E além de tudo era agnóstico ao meio de transporte, podia ser fibra ótica, SAS ou até mesmo iSCSI que é SCSI sobre Ethernet, que é o que vamos usar.

IDE/ATA não tinha nada disso. Era o protocolo de discos de PC pobre. Workstation de verdade, SUN, IRIX, Silicon Graphics, Macs, usavam SCSI.

Mais importante iSCSI é um protocolo de blocos, e não de arquivos. Enfim, isso varia de gerenciador de NAS, mas no caso do Synology DSM, que é o que eu uso, ele tem um aplicativo chamado SAN Manager, que permite criar um drive iSCSI:

![iSCSI create](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/fraxoryhuszmp4cmr0ldc8h7hiip?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-23%2023-46-23.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-23%252023-46-23.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001247Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=81179a76d559ba543cf3197b7d1cf0c8b83f523433029fb93162c9faed216193)

Só seguir o wizard, dar nome, escolher o tamanho, habilitar CHAP se precisar de segurança extra (eu não preciso, estou numa rede local controlada). Isso vai criar o drive iSCSI (pense como se fosse um drive USB remoto) e um LUN (Logical Unit Number). Um LUN é simplesmente um de muitos potenciais "discos virtuais" que um target pode apresentar. LUN é como um slot numerado no array de storage de um target. Target é um servidor de discos. Num SAN você pode ter vários discos virtuais e a forma de organizar isso é com LUNs. No nosso caso não interessa muito saber detalhes de LUN.

Demora um pouco, mas ao terminar é só voltar pro meu Manjaro Linux e fazer:

```
yay -S open-iscsi
sudo systemctl enable --now iscsi 
```

Isso sobe o serviço pra iniciar automaticamente em todo boot. Agora pra descobrir meu drive na rede:
```
```

```
❯ sudo iscsiadm -m discovery -t sendtargets -p 192.168.0.xx
192.168.0.xx:3260,1 iqn.2000-01.com.synology:TERACHAD.docker.7af6e...
[2804:1b3:....:fe18:3f7d]:3260,1 iqn.2000-01.com.synology:TERACHAD.docker.7af6e...
[fe80::9209:....:3f7d]:3260,1 iqn.2000-01.com.synology:TERACHAD.docker.7af6e...
```

Todo drive virtual tem um **IQN** que é tipo uma "URL" pro drive. Agora fazemos login:

```
❯ sudo iscsiadm -m node --login
Login to [iface: default, target: iqn.2000-01.com.synology:TERACHAD.docker.7af6e9116c1, portal: 192.168.0.21,3260] successful.
```

Como não habilitei CHAP nem pede senha nem nada (em empresa o certo é estar habilitado, lógico). E pronto. Ao fazer isso eu ouço no GNOME o barulhinho igual de quando você conecta um pen-drive no PC e ele já automaticamente aparece como um disco. Se fizer `lsblk`, vai aparecer como um drive normal `/dev/sdX` da vida. No aplicativo Disks do GNOME (ou no Disk Management do Windows) vai realmente aparecer como se fosse qualquer outro hard-drive ou SSD da vida. Ele não se comporta como uma pasta compartilhada e sim como um drive de verdade. Incluve precisa formatar, igual um pen drive novo.

![Disks](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/nvgrl3bov311vl4h251dcj1wvchz?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-23%2023-53-29.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-23%252023-53-29.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001248Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=efc3eae2637eb492ee74736c58eb17be80d091a91191bcfe6d94fa8634f1f8e7)

A formatação em si, demora bastante, porque no processo ele precisa checar e mapear bloco a bloco. Como é pela rede, é mais lento do que num drive de verdade, claro. Mas é só uma vez. Mesmo na minha rede de 10Gbps ele vai formatar numa velocidade de uns 120 MB/s, num drive de 2TB, isso vai dar na faixa de 2 horas pra um fast format. Eu esqueci que dava pra formatar com "lazy":

```
mkfs.ext4 -v -E lazy_itable_init=1,lazy_journal_init=1 /dev/sdX
```

Fica pra próxima, agora é esperar 2 horas. Pra garantir que monte automaticamente no boot, precisa checar o `node.startup` dele:

```
❯ sudo iscsiadm -m node -o show | grep -E 'Target:|node.startup'

node.startup = manual
node.startup = manual
node.startup = manual
```

Está como "manual", pra trocar pra "automatic" precisa fazer:

```
❯ sudo iscsiadm -m node \
  -T iqn.2000-01.com.synology:TERACHAD.docker.7af6... \
  -o update -n node.startup -v automatic
```

Com o daemon iSCSI de pé e depois do login, além de `/dev/sda` se fizer `ls /dev/disk/by-path` vamos encontrar algo assim:

```
ip-192.168.0.xx:3260-iscsi-iqn.2000-01.com.synology:TERACHAD.docker.7af6exxxxx-lun-1 -> ../../sdX
```

Como estou usando o serviço AUTOFS e ele "rouba" meu diretório `/mnt`, vou montar o drive iSCSI via fstab mesmo em `/media/docker` adicionando esta linha no final de `/etc/fstab`:

```
...
/dev/disk/by-path/ip-192.168.0.xx:3260-iscsi-iqn.2000-01.com.synology:TERACHAD.docker.7af6e9xxxx-lun-1  /media/docker  ext4      _netdev,nofail,x-systemd.automount,x-systemd.requires=iscsid.service,noatime,nodiratime,commit=60  0 2
```

Depois é só recarregar e montar:

```
sudo systemctl daemon-reload
sudo mount -a
```

E é isso. A partir de agora eu tenho um "drive virtual" no meu NAS remoto. Agora, vamos mudar o Docker pra começar a usar ele. Posso reconfigurar meu Docker pra fazer cache de imagens e volumes e tudo mais direto nesse drive. Só editar o arquivo `/etc/docker/daemon.json` com o mount point:

```
{
  "data-root": "/media/docker/docker"
}
```

Não esquecer de criar o diretório no novo drive com as permissões certas (e ele aceita permissões, porque é um drive formatado com ext4 como qualquer outro):

```
sudo mkdir -p /media/docker/docker
sudo chown root:docker /media/docker/docker
sudo chmod 771 /media/docker/docker
``` 


Por fim, é só reiniciar o serviço do Docker, apagar o `/usr/lib/docker` pra liberar espaço no meu NVME principal e pronto. Deve ser MUITO mais rápido que NFS, não tão rápido quanto um disco local, claro. Mesmo com 10Gbps, rede introduz latência, não tem jeito. Mas o mais pesado é mesmo o processo de build, que tem muita escrita. Pra carregar uma imagem pronta, é pra ser super rápido. Mas pelo menos usando um protocolo de bloco em vez de protocolo de arquivos, é pra diminuir a latência numa ordem de pelo menos 10x ou mais.

![docker build](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/xh40fu275xx9q6os00m6j5gyr9w9?response-content-disposition=inline%3B%20filename%3D%22Screenshot%20From%202025-04-24%2001-01-15.png%22%3B%20filename%2A%3DUTF-8%27%27Screenshot%2520From%25202025-04-24%252001-01-15.png&response-content-type=image%2Fpng&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIA5FTZDKYVLZU6Z457%2F20250527%2Fus-east-2%2Fs3%2Faws4_request&X-Amz-Date=20250527T001249Z&X-Amz-Expires=300&X-Amz-SignedHeaders=host&X-Amz-Signature=b4fb75f1780b19a0f013b2a5e72b9312e9c65790dfb7a5cf0418128b0bc860ca)

E é mais rápido mesmo? **SIM**. Nesta foto de tela do docker build rodando, com NFS os tempos à direita estavam sendo de CENTENAS DE SEGUNDOS pra vários comandos. Agora está de novo abaixo de 1 segundo como deveria. Pra todos os efeitos e propósitos, não estou sentindo diferença se fosse um HD externo USB 3.2 Gen 2.

A diferença MASSIVA que um drive virtual BLOCK-LEVEL faz, comparado com um protocolo NFS/SMB FILE-LEVEL é brutal, o protocolo é um overhead gigante. Aliás, é mais ou menos assim que funciona quando você vai na AWS e contrata storage EBS (Elastic BLOCK Store), por isso se chama "BLOCK", porque é um protocolo de BLOCO como iSCSI e não NFS. Espero que tenha aprendido como faz diferença entender como protocolos e sistemas de arquivos funcionam. Se não assistiu meus vídeos, tem [esta playlist](https://www.youtube.com/watch?v=lxjBgxmDZAI&list=PLdsnXVqbHDUcM0LTAxqrVrTy6Q7jQprjt&pp=gAQB) que explica BLOCOS em detalhes.


Mas sim, iSCSI tem desvantagens: sendo um drive, não pode, ou não deveria, ser compartilhado (pense dois PCs compartilhando o mesmo pen drive, ia dar muita m&rda). Block devices foram feitos pra serem usados por um único dispositivo. Justamente, pra compartilhar, é que existem protocolos como SMB ou NFS: pra gerenciar acessos concorrentes ao mesmo arquivo na rede. 

Outra desvantagem: o drive virtual é um grande BLOB de bits. Sem "montar" não tem como ver os arquivos. No servidor NAS, ele não mostra os arquivos. É como um arquivo .vhd de Virtual Box. Precisa "ligar" e "montar" no "PC". Por isso que ainda vou usar NFS pras coisas de sempre, como Videos ou Downloads. E o drive virtual é exclusivamente pro cache de Docker, neste caso. Aí funciona bem. Nenhum outro PC acessa. Se eu tivesse um segundo Linux que precisasse de cache de Docker, precisaria criar uma segunda LUN só pra ele. Lembre-se, é um drive. Virtual ou não, ele se comporta como um drive de verdade pro seu sistema.
