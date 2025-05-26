---
title: Configurando meu NAS Synology com NFS no Linux
date: '2025-04-17T20:40:00-03:00'
slug: configurando-meu-nas-synology-com-nfs-no-linux
tags:
- synology
- nas
- raid
- btrfs
- autofs
draft: false
---

3 posts no mesmo dia, mas é que tirei o dia pra resolver meus problemas de Linux hoje, então segue mais uma anotação pra mim mesmo do futuro.

Todos que me acompanham, em particular no [Instagram](https://www.instagram.com/akitaonrails/), sabem da minha saga com NAS. Em particular meu novo Synology DS1821+ com mais de **100TB** (4 HDs de 12TB e 4 HDs de 20TB e já tenho 4 outros HDs de 20TB pra atualizar no futuro quando precisar). Uso pra muita coisa, em particular meu [Netflix Pessoal](https://www.akitaonrails.com/2024/04/03/meu-netflix-pessoal-com-docker-compose) que expliquei nesse outro post como eu configurei com Docker.

![Synology DSM](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBaDBCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f1926772b5a43634dccb510a2a34fa33dece5e2c/Screenshot%20From%202025-04-17%2019-46-47.png?disposition=attachment&locale=en)

Nos destaques e post sobre isso no Insta já discuti detalhes desse NAS mas resumindo:

* prefiro Synology porque no fundo ele é um Linux com filesystem BTRFS (que eu gosto), que é quase tão flexível mas mais fácil de usar do que ZFS. E sim, eu sei que existe unraid, TrueNAS e outros. Mas eu acho que o Synology DSM é bem competente (tem versão open source se quiserem), e ele faz tudo que eu preciso.
* prefiro Plex do que Emby ou Jellyfin. Já testei eles, mas o suporte do Plex a apps de TV e celular eu acho muito melhor, acho o player mais estável, também acho que as funcionalidades de organização dele são mais robustas.
* porque não usar só Cloud? Primeiro porque é lento. Minha fibra é só 1Gbps e upload é metade disso. Segundo porque minha rede interna é ultra veloz (10Gbps) e muito melhor. Terceiro porque nada no "Cloud" tem garantia de nada, podem te bloquear, podem te invadir, podem apagar por engano. Quarto, tudo que é meu, eu gosto sendo **realmente** meu, no meu alcance, no meu total controle, sem ninguém pra fazer m&rda com minha propriedade. Custa mais caro, é uma escolha. Eu literalmente tenho mais filmes e séries melhores que a Netflix com conteúdo que você não vai mais achar fácil em nenhum streaming, por exemplo.

Na verdade, eu confio tão pouco em "cloud" que eu uso mas faço uma cópia de tudo no meu NAS local usando o app Cloud Sync que tem na loja da Synology:

![Cloud Sync](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBaUVCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--cc3c67ca43495fef1f4f8d93e9ecffd534722071/Screenshot%20From%202025-04-17%2020-11-02.png?disposition=attachment&locale=en)

**"Ah, mas e se der pau irreversível no seu NAS e você perder TUDO!!??"**

Nenhum backup é completo se não segue o **Mantra 3-2-1**, lembram??

* **3 cópias, 2 mídias, 1 off-site**

Eu tenho algumas coisas gravadas em Millenial Discs (mdiscs, que são como Blu-Rays mas de material inorgânico que nunca estraga). E eu faço cópias das coisas mais importantes do meu NAS pra Amazon Glacier usando o app "Glacier Backup" que também tem na loja da Synology.

Glacier é como S3 só que bem mais barato porque ele não tem acesso fácil nem transferência rápida. É feito pra backups mesmo, que você grava uma vez e quase nunca acessa de novo. **ENCRIPTADO**, lógico.

![Glacier Backup](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBaUlCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--32c69218fcf474976e45ae7c9e864ebccbf959a3/Screenshot%20From%202025-04-17%2020-12-47.png?disposition=attachment&locale=en)

Notem como eu confio tão pouco em cloud, como dropbox, que eu faço uma cópia no meu NAS e mando pra outro cloud. Tem coisas com múltiplas cópias mesmo. Eu não confio no serviço de ninguém, sempre algum humano vai cometer um erro catastrófico algum dia, é só questão de tempo. 

Ah sim, e eu baixo mesmo muita coisa de torrent e eu me considero Power User e sei o que é malware/virus do que não é e sei como funcionam. Mas eu também sou humano então todos os meus Windows tem no mínimo o Windows Defender ativo, Malwarebytes que eu gosto também e mesmo assim eu ainda rodo mais um antivirus no NAS também, que também tem na loja da Synology. Eu não confio em nada sem redundância de tudo, sob meu total controle.

![antivirus](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBaU1CIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--03808abbe4284ee607e125b48c38d6667fa055eb/Screenshot%20From%202025-04-17%2020-17-22.png?disposition=attachment&locale=en)

Mais importante e porque escolho BTRFS tanto no NAS quanto no meu PC: **snapshots**. Ele faz snapshots de tudo periodicamente. Assim, se alguma hora eu rodar um `rm -Rf` da vida errado, eu não perco nada, basta voltar pro snapshot anterior e vai estar tudo lá, bonitinho. Snapshots são inteligentes, eles quase não ocupam espaço, porque no BTRFS o mesmo binário do arquivos iguais, apontam pro mesmo lugar físico. Não é como um `rsync` que realmente duplica tudo e duplica espaço ocupado.

![Synology Snapshots](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBaVVCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--e7027f3ce1659849530d0df0c92417b24f33eae8/Screenshot%20From%202025-04-17%2020-33-32.png?disposition=attachment&locale=en)

No seu PC/notebook Linux, com BTRFS, instale o programa Timeshift pra fazer a mesma coisa. A melhor coisa: se uma hora você atualizar seu sistema e ele não bootar ou alguma coisa quebrar depois de update, é fácil: só rebootar e no GRUB escolher o snapshot anterior e pronto, vai voltar exatamente igual antes do update. No Arch/Manjaro ele é inteligente e já faz snapshots automaticamente toda vez antes do `pacman` rodar:

![Timeshift](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBaVlCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--6d7d2d524ee406859d6c6b02b1df9fac497151ee/Screenshot%20From%202025-04-17%2020-36-04.png?disposition=attachment&locale=en)

Enfim, outro dos usos é pra projetinhos pessoais de código mesmo no meu Linux. No mini-PC que uso na TV pra media center, eu rodo Windows 11 mesmo. Porque uso ligado a outra eGPU com uma RTX 4060 e eu uso Steam pra games. Sim, muitos jogos de Steam rodam em Linux, tem Bazzite, etc. Mas tem coisas que só rodam no Windows e eu preferi comodidade mesmo. Só uso pra games e media então ph0da-se, funciona plug and play.

Meu outro home server mini-PC é onde rodam meus Docker pro media center, torrent, plex server e tudo mais. É um Ubuntu LTS headless. Além dos meus handhelds como o Rog Ally X que roda Windows. Todos eles tem acesso ao meu NAS da Synology, onde exponho pastas compartilhadas com SMB e é isso. Plug and play.

Eu fazia a mesma coisa no meu Manjaro Linux: montava as pastas com SMB. Mas isso tem um problema se eu quero codar alguma coisa e quero usar Git: em SMB não existem atributos de chmod (como flag +x pra script executável) e toda vez que faço git push, zoa todas as permissões de tudo. É um enorme saco. Quem já usou Git no Windows sabe disso. 

Eu não consigo deixar scripts executáveis nesse diretório compartilhado. Então dificulta minha vida no Linux. Então resolvi consertar isso de uma vez e fazer a coisa certa: parar de usar SMB e passar a usar NFS que é a forma nativa de Linux pra acessar pastas compartilhadas na rede de um outro servidor Linux (se o servidor fosse Windows, aí tinha que ser SMB mesmo, mas ninguém em sã consciência monta um NAS com Windows Server).

No SMB, o serviço ignora ownership e permissões do filesystem. Eu crio usuários e atribuo ao serviço, e não aos arquivos. Basta logar com esse usuário e ele vai ter acesso aos arquivos. Então não tem como fazer `chown` e mudar ownership e nem fazer `chmod` e mudar permissões individualmente nos arquivos, é tudo normalizado.

Em NFS, o serviço expõe exatamente o ownership e permissões no filesystem direto, sem um intermediário de ACL pra checar permissões por fora. Então eu tenho o mesmo nível de acesso pra esses atributos que eu tenho nos arquivos locais do meu Linux, que é o que eu quero.

Mas a Synology faz uma coisa irritante não sei porque. Em qualquer Linux, o primeiro usuário e o primeiro grupo criados costumam ser UID: 1000 e GID: 1000. Faça o teste, vai no seu terminal e faça `id [seu usuário]`:

```
❯ id akitaonrails
uid=1000(akitaonrails) gid=1000(akitaonrails) groups=1000(akitaonrails),998(wheel),996(audio),994(input),...
```

Então tanto faz fazer `chown akitaonrails:akitaonrails foo.txt` ou `chown 1000:1000 foo.txt`. Na prática é o número identificador que é importante e não o nome.

Com NFS, se no lado da Synology tem um usuário com mesmo número de UID e GID, eu automaticamente tenho permissão. Mas quando se cria usuários na Synology, não sei porque cargas d'água, ele começa criando com IDs acima de **1020 em vez de 1000**. Então eu tenho um usuário "akitaonrails" no Synology com UID 1026 em vez de 1000.

Mesmo conseguindo montar a pasta compartilhada com NFS, se tento usar Git, por exemplo, ele detecta que meu UID local é 1000 e os arquivos estão com ownership do UID 1026:

```
git st fatal: detected dubious ownership in repository at '/mnt/gigachad/Projects/dotfiles' To add an exception for this directory, call: 

	git config --global --add safe.directory /mnt/gigachad/Projects/dotfiles
```

Não dá pra ficar usando com UIDs misturados, vira uma zona tão ruim quanto SMB. Mas tem formas de mapear e outras gambiarras, mas só tem duas soluções mais "limpas":

* mudar meu UID/GID do meu Linux pra ser 1026 também
* criar um novo usuário no Synology, mudar o ID dele pra 1000 e fazer chown em todos os arquivos pra esse novo usuário.

Escolhi a segunda opção. Primeira coisa é habilitar acesso a SSH no NAS (o ideal é deixar coisas assim desligadas, por segurança, mas estou numa rede local privada então o risco é mínimo):

![SSH Synology](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBaDRCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--28d1473bff26301e49d0ff5a30eac1df7f1051ac/Screenshot%20From%202025-04-17%2020-07-43.png?disposition=attachment&locale=en)

No mínimo eu sempre troco a porta padrão do SSH, costume, mas tanto faz. Precisa saber usar SSH, não ensinar aqui, tem ChatGPT pra isso.

Agora, criar um novo usuário padrão:

![Novo Usuário](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBaDhCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--7acba2b3f559ad04221d7b68e31a8fc6361a5ff3/Screenshot%20From%202025-04-17%2020-08-55.png?disposition=attachment&locale=en)

Vamos garantir que o serviço de NFS está ligado também, já que vou passar a usar ele (por padrão vem desligado, só SMB ligado porque maioria dos clientes são PCs Windows mesmo):

![Enable NFS](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBaUFCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--b9bc6562f317e7bcce4bb1d08c3947e894814499/Screenshot%20From%202025-04-17%2020-09-43.png?disposition=attachment&locale=en)

Agora é logar com SSH no NAS e editar o UID e GID, primeiro editando `/etc/passwd` e achando uma linha como:

```
akitaonrails-nfs:x:10xx:10xx:...
```

E trocando pra:

```
akitaonrails-nfs:x:1000:1000:...
```

Agora editando `/etc/group` e mesma coisa, trocando o grupo `akitaonrails-nfs` recém criado pra `1000` também. Pronto, agora eu tenho um usuário com UID 1000 e GID 1000 criado. O nome não é o mesmo do meu PC mas isso não importa, só os números.

Na GUI da Synology DSM, não esquecer de adicionar permissões pra cada pasta compartilhada, pra NFS:

![NFS permissions](https://d1g6lioiw8beil.cloudfront.net/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBaVFCIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--f9adc6d81f88255103b1604870f2a91b4b259375/Screenshot%20From%202025-04-17%2020-26-36.png?disposition=attachment&locale=en)

Ainda via SSH, tem que alterar o ownership e consertar as permissões de **TODOS OS ARQUIVOS** e no meu caso, com terabytes, levou BASTANTE tempo, só deixar lá rodando:

```
sudo chown -R 1000:1000 /volume1/GIGACHAD
sudo chmod -R 0755 /volume1/GIGACHAD
```

Se eu quiser desconectar do SSH e deixar lá rodando (já que vai levar um tempão), basta rodar desconectado da sessão SSH com `nohup`:

```
nohup chown -R 1000:1000 /volume1/GIGACHAD > /tmp/chown.log 2>&1 &
```



Um cuidado que precisa tomar é não fazer algo como `chmod -R -x` em tudo. Primeiro: diretórios precisam ter o bit de execução e se remover, não vai mais conseguir navegar por diretórios, então tem que separar correção de diretórios e arquivos. Segundo: é bom passar esse conserto em diretórios pra garantir que não ficou arquivos com bit executável (o que pode gerar problemas de segurança, imagine arquivos aleatórios de diretórios de Node modules). Terceiro: diretórios como "#snapshot" são pra controle do filesystem e são read-only, tentar mexer neles só vai comer MUITO tempo, então é melhor filtrar e não mexer neles.

Ou fazer um script com isso e rodar com nohub pra poder sair do SSH enquanto espera ele rodar (no meu caso, com terabytes, leva horas):

```
nohup /tmp/fix-terachad-perms.sh > /dev/null 2>&1 &
```

Tem alguns probleminhas escondidos ainda. Ainda no SSH da Synology tem que mudar o `/etc/exports` que o NFS usa porque ele ainda mapeia por default pro usuário UID 1026 e 100, tem que mudar os dois pra 1000:

```
# antigo
sudo cat /etc/exports
Password:

/volume1/GIGACHAD       192.168.0.0/24(rw,async,no_wdelay,no_root_squash,insecure_locks,sec=sys,anonuid=1025,anongid=100)
/volume1/TERACHAD       192.168.0.0/24(rw,async,no_wdelay,crossmnt,no_root_squash,insecure_locks,sec=sys,anonuid=1025,anongid=100
```

Problema de mexer em arquivos de sistema como esse é que não se sabe se mexer na GUI de permissões do NFS, ou se vier updates, vai voltar como era antes. Se alguém souber de alguma solução mais permanente, avisem.

E pronto, com tudo isso, basta desconfigurar a configuração de CIFS/SMB que eu tinha e substituir por NFS. Eu prefiro usar o [AutoFS](https://wiki.archlinux.org/title/Autofs) pra fazer isso. Eu tinha um `auto.cifs` antes, que agora posso deletar. E criar um novo `/etc/autofs/auto.nfs` assim:

```
gigachad  -fstype=nfs4,rw,nosuid,noatime 192.168.0.xx:/volume1/GIGACHAD
terachad  -fstype=nfs4,rw,nosuid,noatime 192.168.0.xx:/volume1/TERACHAD
```

E trocar a linha de `auto.cifs` em `/etc/autofs/auto.master` por isso:

```
/mnt  /etc/autofs/auto.nfs --timeout=60 --ghost --browse
```

Agora é reiniciar o serviço:

```
sudo systemctl daemon-reexec
sudo systemctl restart autofs
```

E pronto, tudo montado com NFS e agora eu tenho suporte completo a ownership e permissions nativas de Linux, sem o overhead e incompatibilidades da porcaria de SMB. Deu um "medinho" ficar fazendo chown e chmod em massa, mas é um NAS com BTRFS. Tem RAID pra aguentar corrupção de dados, tem snapshots se precisar reverter alguma coisa. Essa é a vantagem de ter sistemas de segurança: dá pra fazer as coisas sabendo que se algo der errado, tem como reverter. Essa paz de espírito não tem preço.
