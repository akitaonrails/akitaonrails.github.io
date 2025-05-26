---
title: "[Akitando] #147 - Criptografia na Prática - Certificados, BitTorrent, Git,
  Bitcoin"
date: '2023-11-10T10:00:00-03:00'
slug: akitando-147-criptografia-na-pratica-certificados-bittorrent-git-bitcoin
tags:
- openssl
- certbot
- letsencrypt
- linux
- manjaro
- arch
- bittorrent
- git
- bitcoin
- akitando
draft: false
---

<iframe width="560" height="315" src="https://www.youtube.com/embed/iAA8NrfQtHo?si=nUo3ltQLH_h50fwP" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>

Como que se geram chaves secretas pra encriptação? Pra que servem pares de chaves? Como certificados funcionam? Qual a diferença de impressão digital e assinatura digital? Como tudo isso funciona junto e chega em coisas como BitTorrent, Git ou Bitcoin?

Já tinha feito 2 videos falando do básico de criptografia, hoje é dia de ver como essas coisas funcionam na prática e são usados em aplicações de verdade.
  
## Capítulos


* 00:00:00 - Intro
* 00:01:28 - CAP 1 - Criptografia Simétrica - OpenSSL
* 00:10:11 - CAP 2 - Criptografia Assimétrica - Chaves RSA
* 00:17:06 - CAP 3 - Certificados Digitais - Let's Encrypt
* 00:29:18 - CAP 4 - Impressões e Assinaturas Digitais - Hashing
* 00:38:54 - CAP 5 - Picotando Arquivos - Introdução a BitTorrent
* 00:46:03 - CAP 6 - Entendendo Links Magnéticos - BitTorrent
* 00:53:52 - CAP 7 - Árvores de Merkle - Escalando BitTorrent
* 01:01:13 - CAP 8 - Git e Merkle - Reescrevendo a História
* 01:06:10 - CAP 9 - Juntando as Peças - BitTorrent e NoSQL
* 01:09:56 - CAP 10 - As Últimas Peças - De ZFS a Bitcoin
* 01:13:03 - Bloopers

## Links

* [Intel® Advanced Encryption Standard Instructions (AES-NI)](https://www.intel.com/content/www/us/en/developer/articles/technical/advanced-encryption-standard-instructions-aes-ni.html)
* [VeraCrypt - Free Open source disk encryption with strong security for the Paranoid](https://www.veracrypt.fr/en/Downloads.html)
* [Rng-tools - ArchWiki (archlinux.org)](https://wiki.archlinux.org/title/Rng-tools)
* [Trusted Platform Module - Gentoo wiki](https://wiki.gentoo.org/wiki/Trusted_Platform_Module)
* [How to choose an AES encryption mode (CBC ECB CTR OCB CFB)? - Stack Overflow](https://stackoverflow.com/questions/1220751/how-to-choose-an-aes-encryption-mode-cbc-ecb-ctr-ocb-cfb)
* [encryption - ECDSA vs ECIES vs ECDH - Cryptography Stack Exchange](https://crypto.stackexchange.com/questions/12823/ecdsa-vs-ecies-vs-ecdh)
* [VU#836068 - MD5 vulnerable to collision attacks (cert.org)](https://www.kb.cert.org/vuls/id/836068)
* [Google Online Security Blog: Announcing the first SHA1 collision (googleblog.com)](https://security.googleblog.com/2017/02/announcing-first-sha1-collision.html)
* [The GNU Privacy Guard (gnupg.org)](https://www.gnupg.org/)
* [How-to verify GPG key of official .ISO images - Manjaro](https://wiki.manjaro.org/index.php/How-to_verify_GPG_key_of_official_.ISO_images)

## SCRIPT

Olá pessoal, Fabio Akita


Criptografia é um assunto super extenso, hoje quero mostrar um pouco mais na prática alguns componentes comuns que vocês vão esbarrar mais cedo ou mais tarde. Já tinha feito 2 videos sobre a teoria, depois assistam. 




Eu não sou especialista em segurança, sou um desenvolvedor que se interessou pelo assunto, só. Por isso não considerem que tudo que vou falar é o único jeito ou é completo. É apenas o que eu considero o mínimo, de desenvolvedor pra desenvolvedor. Quem for especialista na área, por favor, complementem nos comentários abaixo.




Quem evitou o assunto até agora, hoje é o dia de cair de cabeça. Quero mostrar como encriptação de dados funciona, como certificados digitais funcionam, e como tudo isso é aplicado no mundo real, passo a passo. Na segunda metade vou explicar como um BitTorrent funciona e quais tecnologias tornam ela similar a um Git. Vamos lá.




(....)




Este é um video pra quem já saiu da faculdade mas ainda não brincou o suficiente com criptografia, infelizmente você vai precisar ter um mínimo de base pra prosseguir e desta vez não vou segurar muito na mão. Prestem bastante atenção, façam anotações se precisar. Se não entenderem este começo, não vão conseguir seguir o raciocínio depois. Pausem, voltem e revejam, até entender. A primeira metade, vale até abrir o terminal e tentar os comandos vocês mesmos pra sentirem na mão como funcionam. Videos densos como de hoje não é pra assistir só uma vez.






Toda CPU moderna tem instruções em hardware pra encriptar dados. Se você tem Mac e habilitou File Vault, se tem Windows e habilitou BitLocker, ou se usa Linux com LUKS, todos usam o algoritmo de encriptação AES, provavelmente a variante de 256 bits. Em CPUs novas é muito raro sentir que o sistema ficou mais lento por causa disso, por isso recomendo manter ativado, especialmente em notebooks. Caso sejam roubados, a chance de alguém acessar seus dados é perto de zero. Se quiser aumentar performance, o certo não é desligar encriptação e sim comprar um SSD melhor.







Há quem ainda ache que só porque precisa fazer login na sua conta quando liga a máquina, está seguro. Mas não. Se remover o HD ou SSD do seu notebook e ligar numa outra máquina, vou ter acesso a todos os arquivos se não estiverem encriptados. Seu login e senha não fazem nenhuma diferença. Login em sistema operacional só evita que um usuário tenha acesso aos arquivos de outro usuários enquanto a máquina está ligada e ninguém tem acesso físico ao hardware. Se tiver acesso físico, não faz diferença. Isso vale pra qualquer sistema operacional.







No episódio de Sua Segurança é uma Droga eu demonstrei o uso do Veracrypt. Diferente de BitLocker do Windows, por exemplo, que só dá suporte a AES porque é o mais performático, o Veracrypt permite escolher outros algoritmos. Pra coisas muito grandes vai ser mais lento, mas por outro é o mais seguro. Um HD com BitLocker, pode ser difícil de quebrar, mas sabendo que é AES podemos focar só nisso. Mas uma imagem encriptada com Veracrypt, não sabemos nem o algoritmo usado, e isso aumenta a segurança exponencialmente. Por isso que pra coisas absolutamente críticas, é melhor usar Veracrypt. Pro dia a dia AES de BitLocker ou FileVault é mais que suficiente.








Vou repetir: se você tem dados importantes, num notebook que carrega embaixo do braço, pra trabalhar de um starbucks da vida, espero que não seja burro de andar por aí sem encriptação. Mas como que funciona esse tipo de encriptação? Vamos dar alguns exemplos.







Um dos pacotes de segurança e criptografia mais conhecidos e utilizados do mundo é o famoso OpenSSL. É um pacote gigante, com praticamente tudo que se precisa pra lidar com criptografia. Existem outras alternativas como LibreSSL, BoringSSL do Google, NSS da Mozilla e outros, mas vou focar no OpenSSL porque ainda é um dos mais usados. De um terminal num Linux, é assim podemos gerar uma chave aleatória. Vamos chamar de "key.bin"

```
openssl rand -out key.bin 32
hexdump key.bin
```




Geramos uma chave binária de 32 bytes ou 256 bits. Essa chave é segura o suficiente pra maioria dos usos hoje. Pra ser mais seguro deveríamos adicionar entropia externa, por exemplo, com um hardware externo ou o chip de TPM que vem em máquinas modernas usando algo como TPM2-TSS. Entropia inicial é extremamente importante pra definir a força de uma chave. Mas só pra usar de exemplo, isso vai servir.






Por ser importante, vale mais uma tangente. Tudo em criptografia depende de um PRNG ou Pseudo Random Number Generator. Não existe número verdadeiramente aleatório, existem funções que, dado um número inicial, consegue ir "cuspindo" números que parecem aleatórios. Se colocarmos numa distribuição estatística, seria uniforme, onde todos os números tem mais ou menos as mesmas chances de aparecer, sem nenhum viés.






Mais do que isso, os números gerados não devem parecer diferentes de aleatoriedade verdadeira, devem ser resistentes a backtracking. Não deveria ser possível reconstruir números anteriores só vendo uma sequência de números gerados, ou seja, devem ser resistentes à previsão, não podendo ser fácil prever os próximos. Devem ser difíceis ou impossíveis de serem reproduzidos.









Bons números aleatórios são fornecidos pelo sistema operacional. No caso de Linux, existe um dispositivo em "/dev/random" que é de onde pacotes como OpenSSL se conectam. Podemos aumentar a entropia dele usando um serviço como "rngd". Num Arch é só instalar com "pacman -S rngd", habilitar e iniciar com "systemctl enable" e "systemctl start". Esse serviço vai tentar puxar entropia de dispositivos de hardware ou do chip TPM do seu PC, se ele for moderno. 







Chip TPM, de Trusted Platform Module, é o que gerou controvérsia quando o Windows 11 inicialmente ia obrigar todo mundo a ter. No fim voltaram atrás porque muita gente não ia ter e reclamaram muito. Mas o certo é realmente ter esse chip. Toda placa mãe tem um slot pra esse chip, mas em modelos baratos ele vem vazio, pra você comprar separadamente. Dentre as várias funções de segurança que ele fornece, está entropia via hardware. Esse serviço "rngd" vai alimentar o "/dev/random" que, por sua vez, é usado pelo OpenSSL. 







Várias classes de malware e vírus são bloqueados ao ter um chip TPM devidamente configurado, em particular rootkits, além de melhorar a encriptação com BitLocker. Cheque se sua máquina tem, ou se tem suporte de instalar. Se tiver, compre e instale. Todo Mac e iPhone tem um chip similar instalado de fábrica, o chip T2, que é uma das razões de um Mac ser mais seguro que um PC mais barato. Nada disso torna você 100% seguro, mas certamente melhora sua defesa.







Voltando ao exemplo, agora vou criar um arquivo idiota chamado "test.txt" com a boa e velha frase "Hello World". E vamos encriptar usando nossa chave. Esta linha de comando de OpenSSL vai usar AES 256 em modo CBC, com salt, passando o test.txt e devolvendo test.txt.enc, usando a chave key.bin que acabamos de gerar. Pronto. Se dermos um "cat" no novo arquivo, vai devolver um lixo binário. Podemos ver com hexdump e não tem nada a ver mais com o arquivo original. Esse é o resultado esperado.


```
openssl enc -aes-256-cbc -salt -in test.txt -out test.txt.enc -pass file:./key.bin

cat test.txt.enc
Salted__����z�F�ğQw8��#�- ���4

hexdump test.txt.enc
0000000 6153 746c 6465 5f5f 1ae2 88f0 d67a cc46
0000010 9fc4 7751 fc38 23b4 2da6 f020 aaf5 0a34
0000020

hexdump test.txt
0000000 6548 6c6c 206f 6f57 6c72 0a64          
000000c
```






Mais um adendo aqui. Só pra simplificar o exemplo, escolhi AES 256 em modo CBC ou Cipher Block Chaining. Ele é melhor que o anterior ECB mas é sensitivo a erros de ciphertext e é vulnerável a ataques de padding oracles se não for implementado corretamente. 
Além de CBC existe Cipher Feedback ou CFB, Output Feedback ou OFB, Counter ou CTR e Galois/Counter Mode ou GCM. Se precisar escolher, use GCM.






Estou usando CBC com um salt, que já é melhor que só CBC sozinho, mas se for usar GCM ele vai gerar um tag de autenticação e anexar no arquivo encriptado. Mas o certo é se preocupar com o tráfego desse tag, porque ele precisa ser transportado de forma segura e não num anexo de email, aberto, por exemplo. Além disso tem que se preocupar com Initialization Vectors, IVs. Por isso a maioria dos tutoriais por aí, assim como meu exemplo, usam CBC: porque é mais simples de explicar. 







Entenda isso: pareceu que falei uma sopa de letrinhas a toa só pra dificultar, mas foi pra demonstrar que a maioria dos tutoriais vai escolher a opção mais simples de explicar, que costuma ser a mais insegura. Por isso eu falo que se você não estudou criptografia a fundo, não deveria tomar decisões de criptografia: vai usar errado e vai tornar a encriptação do seu sistema mais inseguro. 






Era uma das minhas críticas quando JWT, o JSON Web Authentication, por exemplo, foi lançado lá atrás: ele exigia que o desenvolvedor soubesse tomar essas decisões de algoritmos e modos, mas quase ninguém sabe e nem vai aprender certo. Ele não deveria permitir as combinações obviamente mais inseguras. Só que ao fazer isso, tornaria a usabilidade mais difícil. É sempre um trade-off: quanto mais usável tentar fazer alguma coisa, mais inseguro vai ser. Segurança é complicado mesmo.






Agora eu poderia enviar o arquivo encriptado pra outra pessoa pela internet e, se ela tiver a minha chave, conseguiria decriptar com uma linha de comando parecida com esta. OpenSSL modo AES 256 CBC recebendo o test.txt.enc encriptado e descriptografando em test.txt.dec passando a chave key.bin. Com um comando "cat" vemos que foi com sucesso.

```
openssl enc -aes-256-cbc -d -in test.txt.enc -out test.txt.dec -pass file:./key.bin

cat test.txt.dec
Hello World
```




Bacana, de forma simplificada, é assim que um BitLocker ou FileVault ou Veracrypt da vida estaria lidando seus dados. Eu digo simplificando porque aqui dei exemplo lidando com arquivos inteiros, mas sistemas de arquivos lidam com stream de blocos. Enfim, no HD físico só teria o equivalente àquele arquivo "test.txt.enc", a versão encriptada. E precisa ter essa chave em algum lugar pra conseguir ler o conteúdo original de volta. Isso normalmente seria pesado de computar, mas a encriptação e decriptação não é feita via software e sim via instruções direto da CPU, em hardware, por isso o processo é mais acelerado e quase não sentimos, na prática.






Mas no exemplo anterior temos um problema gigantesco. Se o objetivo de encriptar algum arquivo for pra poder enviar de forma segura pra outra pessoa, como fazemos pra enviar a chave de forma segura também? A única forma seria essa pessoa vir até minha casa, trazendo um pendrive, e eu gravar a chave direto no pendrive, sem nunca trafegar pela internet. Mas isso não é prático. Como consigo passar uma chave pra outra pessoa de forma que ninguém na internet consiga interceptar ou adulterar?






Aqui entra o conceito de chaves assimétricas. Novamente, explico sobre isso em detalhes no 2o video de criptografia. Mas deixa eu dar um exemplo prático. De volta ao terminal, vamos usar OpenSSL pra gerar um par de chaves. Literalmente são dois arquivos, um chamado private.pem e outro chamado public.pem.



```
openssl genpkey -algorithm RSA -out private.pem -pkeyopt rsa_keygen_bits:2048
openssl rsa -pubout -in private.pem -out public.pem
```





Enfim, escolhi a opção de algoritmo RSA de 2048 bits. E eu sei que já deve ter gente indo nos comentários reclamar "porra Akita, você devia ter usado curva elíptica em vez de RSA". Eu expliquei o que são esses algoritmos e as diferenças no meu video antigo, mas resumindo, sim, Elliptic Curve Cryptograph ou ECC é mais forte que RSA. Uma chave ECC de 256 bits é mais forte que uma chave RSA de 3072 bits, mais de 10 vezes o tamanho.






O problema é que OpenSSL não oferece comandos simples pra encriptar dados arbitrários com chaves ECC porque ECC é normalmente usado pra coisas como tráfego de chaves ou ECDH, assinatura digital que é ECDSA ou com mecanismos de encapsulamento de chave em ECIES. Ou seja, não é simples pra sair encriptando qualquer dado arbitrário. Eu poderia usar ECDH mas a ideia desse video não é entrar nas minúcias de ECC e sim dar uma noção geral de criptografia e, pra esse fim, RSA vai ser mais que suficiente. RSA é mais simples pra usar e ensinar, mas se estiverem fazendo algo sério, estudem tudo que acabei de falar sobre ECC.







E o que são esses arquivos RSA que foram gerados? Podemos usar o comando "cat" e vai listar o conteúdo. É a versão em Base64 da chave binária. Base64 é como encodamos um binário em caracteres ASCII que dá pra mostrar na tela. Convertemos 8 bits em 7 bits, por isso ele fica um pouco maior. O private.pem é mais longo e o public.pem é mais curto. Olhem só. 


	❯ cat private.pem
	-----BEGIN PRIVATE KEY-----
	MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC5cMQZZd85emyr
	oL9cvrR522tmBBlcwpF7QyobGwAmk8smL2HoMf207LJl3wi7JE736qqWdme/Rwr8
	Zsz8ZOAeiud4SIk/NbfezMoLVkUxQGOg0GprpYciUVUp9e/3HKl5PS9Yr9lU6QN8
	Bs7gY96DohUrGz/hQR7G550O+/ITV+qm3VZytPiH8tQAXrueqC8lf/Ly97UnlfLr
	bauftw6QIw1ldI8NjxPIcwbNot+BfXcN6kiJifttdLi7/kEaAboecjYxcoipntjb
	RdAntX/Y6xluwKtKRqrTs1XxHAPtEEQrVvfc6CjM2kLiFe//r3oZCLhHAAyZhJ6X
	+J3zt0gXAgMBAAECggEAArvbsDzVEc2xEhtVvDd1hVcLmh6VBHiRLijbKI4j2O2/
	MMoXCUDKFY49wmG2M71rypzeNJynQpB4uX2HJ8YRmxxUyuxVgFCO7DfHAhbHVga1
	0Uub811RL4YqbsAY8GLZnsIc/hONl9ey555ZaMEgKSmiYpciwHPg0RwzWmKy0BUq
	bFRLIHhfJfxzIpHxw3LExW///jyVw56sK9IE260pYqf8MxX/mhxPllj5VLNbctzj
	YO1W+EjeUlolI19xSMJSlqW2bGeoXIalddDR0552QrmZAXEpRgI9V+NoQdSKnrXr
	gHJS2uav2ORqoxDp3+7np0dnt06dtD/rzevrDtoDzQKBgQD0IiKU9L0QbZDWz8SH
	b+SF5IymsMKRykyAXkghEjyzMXbbgnOHo7Eesc4iU07k1kzOKgtCcwt0glnEwKei
	qlzpDOZoW+UdloWVUXSuLFcW1Oy67B8w/YLp6PFBce7YMjij1hOvJSQS5unEfmt2
	8PZ01JUA9m49DGfXTUrnzX6mRQKBgQDCdEnZLkIyo9RKBjsrd57+Yp4KtJuAqn8o
	fuBh33qxnrImkA/RMwrcUQIoLJly3DUk8UhJRIIqCLOp4BHc9WDkxa+7bqLl7OXG
	qWfyvwNLVY1M98oMbU7ESJPZb2BHLNrWgnD/tGYLrRQq+WbVkh2B7b+31SP63UZz
	sWG3W8TYqwKBgQDAZSZbvYRCLha3M4XuNoAiBLvTofm0a3lesO6nIXg0wAard2MU
	wiwTxIxvALhsH3boArpc481jRFb6d9mkmB4gi8oI9GLbroQX6NnLaaY4mBT4Op1a
	Pm+tZ6a5rNBOEUYR1+QrY1nKi7Au6nJGih+wctf6qjq2YdB0HLWreIcXAQKBgAFj
	ezOF1QsviFCPAtUooYYHhkFlUMb2cLoFTezk/6dNDtCfrr07tBQmr/FBgEcFs4tz
	/aQoTRWnwkCwTPBbADoh/0NDYv5pVqq4gvmEy606CyxFiLfV//3+1q9y0Ckx9M4b
	WFs7Go9yyPYVmdpklLlczUWuy/b6pYol9iCtExbJAoGAWgDbmrwo6Pg2ro+f98i6
	K761tCW43rB2Trfl0XyB38OT/8geW14/BLBJdRp3XChg60b2UaVVwLhp3WvfKs9u
	FDFmsSSdnSs+X+JNtfnixbwXJl5I3z+s3Uz9wxRY/82RHM2f1FgQ22JFV7Es2H1U
	XENsUtHZ/bgOggoZTP3uEl0=
	-----END PRIVATE KEY-----

	/tmp 
	❯ cat public.pem
	-----BEGIN PUBLIC KEY-----
	MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuXDEGWXfOXpsq6C/XL60
	edtrZgQZXMKRe0MqGxsAJpPLJi9h6DH9tOyyZd8IuyRO9+qqlnZnv0cK/GbM/GTg
	HorneEiJPzW33szKC1ZFMUBjoNBqa6WHIlFVKfXv9xypeT0vWK/ZVOkDfAbO4GPe
	g6IVKxs/4UEexuedDvvyE1fqpt1WcrT4h/LUAF67nqgvJX/y8ve1J5Xy622rn7cO
	kCMNZXSPDY8TyHMGzaLfgX13DepIiYn7bXS4u/5BGgG6HnI2MXKIqZ7Y20XQJ7V/
	2OsZbsCrSkaq07NV8RwD7RBEK1b33OgozNpC4hXv/696GQi4RwAMmYSel/id87dI
	FwIDAQAB
	-----END PUBLIC KEY-----




Arquivos ponto "pem" significa Privacy Enhanced Mail que é um formato de arquivo texto exatamente como dessas chaves que acabei de mostrar. É isso, um arquivo que começa com esses hifens, BEGIN, lá embaixo termina com END, e no meio é algum binário formatado com Base64. Se usa SSH, você já gerou chaves nesse formato.




As chaves pública e privada geradas com os comandos `openssl genpkey` e `openssl rsa` estão relacionadas por meio do algoritmo de criptografia RSA. O processo começa gerando dois números primos enormes e aleatórios. Esses números primos são mantidos em segredo e são a base da segurança do sistema. Em seguida, esses números primos são multiplicados entre si, resultando em um número chamado 'módulo'. Este módulo é usado na criação de ambas as chaves.




A chave pública é derivada do módulo e de um expoente público, que é um número pré-definido e geralmente pequeno. A chave pública pode ser compartilhada com qualquer pessoa e é usada para criptografar mensagens que só podem ser descriptografadas pela chave privada correspondente.




Por outro lado, a chave privada é gerada usando os números primos originais e um expoente privado calculado a partir deles. A chave privada é mantida em segredo e é usada para descriptografar as mensagens criptografadas pela chave pública.




Embora as chaves pública e privada não sejam os números primos em si, elas são matematicamente relacionadas aos números primos utilizados durante a geração. Esse relacionamento matemático é fundamental para o funcionamento da criptografia RSA e é o que permite a comunicação segura, onde informações criptografadas com a chave pública só podem ser lidas pela chave privada correspondente, e vice-versa. Fodeu, não entendeu nada né. Vamos simplificar com um exemplo. 


```
openssl pkeyutl -encrypt -pubin -inkey public.pem -in key.bin -out key.bin.enc
```

Digito o comando openssl pedindo pra encriptar minha chave key.bin usando a chave pública e resultando num novo arquivo key.bin.enc. Pronto, agora temos a chave simétrica original, encriptada usando a nova chave pública. Se listarmos o conteúdo com hexdump, veja como os binários são diferentes. 




```bash

❯ hexdump key.bin.enc
0000000 84b4 f414 6144 087d 079a 3036 4eb7 5798
0000010 28de 7505 e9fe fc0e 851c 877e be59 4b97
0000020 a5b6 05de e379 c30f 974b 9f31 a24a f567
0000030 68ad 0af9 d39b f770 3e20 0be8 3116 c52f
0000040 7437 4224 54f4 d071 b28e a5ff d29e 7a85
0000050 e78a 8ec2 b125 38ea 204a c071 82d0 5526
0000060 8923 4a84 23d6 72ea da81 434a 5f05 9e87
0000070 3b8d f2c1 5331 fc16 e92a 4e3b d695 4759
0000080 2472 0453 34cc db67 6dbf 8fbb 92ec e52f
0000090 be0c f295 3b5e 2aac 7fdb 0e82 bf0a 0cf8
00000a0 f158 0014 f93e 33f0 fe77 ca3a 3144 25f8
00000b0 877c a25f 4012 4953 be15 e06e 9894 a4ef
00000c0 a399 3b4a 1efe dc57 1e85 5410 5df3 7f95
00000d0 c957 9182 c426 55a6 ea7e 5e0d 1270 9ab2
00000e0 4781 44ae 3437 886b ef0c 82d6 5d66 5c5b
00000f0 e072 0888 bccd 55ba f217 100c 4906 f45e
0000100

/tmp 
❯ hexdump key.bin
0000000 ccab 139c 27f3 c206 76af 952d 0fb1 2c17
0000010 51a5 0a43 731b 5bf4 9f3c 72b5 1e57 2503
0000020

```




Pra não ficar confuso vamos recapitular. Eu gerei uma chave simétrica AES chamada "key.bin". Quero usar essa chave pra criptografar arquivos ou mensagens pra mandar pra uma segunda pessoa em algum lugar na internet, vamos chamar de John. Porém, não adianta criptografar a mensagem e mandar pro John porque ele precisa ter a chave. Mas não posso mandar a chave via email ou whatsapp porque aí não tem segurança nenhuma. Precisamos garantir que nada no meio do caminho possa interceptar ou adulterar minhas mensagens pro John. 







O problema de mandar a chave direto por email é se alguém na internet, vamos chamar de Skynet, intercepte essa comunicação e fique com minha chave, sem passar pra frente. Daí ela manda uma outra chave falsificada pro John. O John não sabe que recebeu uma chave falsa. Agora eu, Fabio, vou mandar uma mensagem criptografada com minha chave que diz "John, descobri a localização da Skynet, ele tá nas coordenadas X Y". 







Skynet intercepta essa comunicação, e como já tinha interceptado minha chave, consegue facilmente abrir a mensagem. Agora ela forja uma segunda mensagem dizendo "John, achei a Skynet, clique neste link pra ver a localização!", criptografa com a chave falsa e manda pro John. O John abre achando que veio de mim. Daí, na confiança, clica no link e é isso, acabou a raça humana. Game over. Eu sempre digo: nunca saia clicando em links que recebe por email ou whatsapp.







Mas eu sei que isso poderia acontecer. Em vez disso já tinha ensinado: "John, cria um par de chaves RSA, e manda a chave pública pra mim, mas nunca, jamais, transmita a chave privada pra fora da sua máquina". Ele me manda a chave pública, por email aberto mesmo, e com essa chave eu encripto aquele arquivo "key.bin". Quando o John receber a mensagem criptografada, pode rodar o seguinte comando. Openssl decriptar o arquivo key.bin.enc com a chave privada.



```
openssl pkeyutl -decrypt -inkey private.pem -in key.bin.enc -out key.bin.dec
```



Entenda, quando encripto alguma coisa com a chave pública do John, o único que vai conseguir abrir é o John com sua chave privada. Se eu conseguir passar minha chave simétrica key.bin pra ele, de forma segura, garantidamente só nós dois temos o segredo e podemos começar a trocar comunicação encriptada com AES e a Skynet não vai ter como interceptar nem ficar no meio do caminho tentando forjar mensagens. 






Mas tem um pequeno defeito nesse processo. Como eu sei que a chave pública que o John me mandou veio realmente do John e não é de novo a porra da Skynet tentando me enganar? Esse é o mesmo problema que temos hoje em websites e ecommerces da vida. Como eu sei que a chave pública que recebi da Amazon é realmente da Amazon? Como eu sei que não é um site de um hacker, uma Skynet, tentando se passar pela Amazon? Vamos entender a última peça que falta: a autoridade certificadora.







Esse é o princípio por trás de SSL ou, mais corretamente, TLS, que todo navegador utiliza. O que acontece por trás dos panos sem você ver é o seguinte: primeiro, abrimos o navegador e digitamos "https://amazon.com" da vida. Importante que seja um site "https". Então o navegador pede uma conexão segura pro servidor web da amazon que, por sua vez, devolve um certificado digital.







Um certificado digital é um pacote que contém a chave pública, a metade do par de chaves de uma Amazon. A chave privada nunca sai do servidor. Lembrem-se desse conceito: chaves privadas nunca podem tocar a internet, jamais. Mas, como eu posso garantir que não é a Skynet, minha conexão foi interceptada e recebi um certificado falso? Pra isso que existem CAs ou Certificate Authorities. Vamos ilustrar com um exemplo, porque é importante ter esse processo na cabeça.







De novo, o objetivo do video não é ser um tutorial. Mas se nunca viu, vou criar um novo certificado digital usando o serviço Letsencrypt associado ao meu domínio válido "akitando.me". Pra criar um certificado precisa ter um domínio registrado válido. O jeito tradicional é um passo a passo super chato. É um processo já bem documentado, que tem em dezenas de lugares, só procurar no Google. Mas Letsencrypt é mais fácil porque simplifica vários passos. Pra começar precisa ter instalado o programa "certbot" na sua máquina.







Iniciamos o processo pedindo pra gerar um certificado pro meu domínio usando o método de checar um registro no DNS pra garantir que sou mesmo o dono desse domínio. Só quem é dono do domínio consegue configurar o nameserver. No caso ele gera o que chamamos de um challenge, um desafio, que é esse número aleatório aqui. Eu tenho que registrar um campo TXT no DNS do domínio com exatamente esse número. Isso não é uma senha, fica aberto mesmo. É só pra garantir que a pessoa pedindo pra gerar o certificado realmente é o dono do domínio.






No caso, meu DNS ou nameserver tá na AWS então abro o Route53 pra editar os registros do meu domínio "akitando.me". Dependendo de onde tá seu domínio, vai ser um tela diferente, mas o princípio é o mesmo. Daí tem que esperar alguns minutos pra essa informação replicar pela internet. Se não sabe como isso de DNS funciona, não deixe de ver minha série sobre redes. Já expliquei isso lá.



```
sudo certbot certonly --manual --preferred-challenges dns -d akitando.me


Saving debug log to /var/log/letsencrypt/letsencrypt.log
Requesting a certificate for akitando.me

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Please deploy a DNS TXT record under the name:

_acme-challenge.akitando.me.

with the following value:

m_6yRys7mMCh-jg_R8kpwCl3mx5EVK3tMp9jeIR9RFI

Before continuing, verify the TXT record has been deployed. Depending on the DNS
provider, this may take some time, from a few seconds to multiple minutes. You can
check if it has finished deploying with aid of online tools, such as the Google
Admin Toolbox: https://toolbox.googleapps.com/apps/dig/#TXT/_acme-challenge.akitando.me.
Look for one or more bolded line(s) below the line ';ANSWER'. It should show the
value(s) you've just added.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Press Enter to Continue


Successfully received certificate.
Certificate is saved at: /etc/letsencrypt/live/akitando.me/fullchain.pem
Key is saved at:         /etc/letsencrypt/live/akitando.me/privkey.pem
This certificate expires on 2023-11-22.
These files will be updated when the certificate renews.

NEXT STEPS:
- This certificate will not be renewed automatically. Autorenewal of --manual certificates requires the use of an authentication hook script (--manual-auth-hook) but one was not provided. To renew this certificate, repeat this same certbot command before the certificate's expiry date.

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
If you like Certbot, please consider supporting our work by:
 * Donating to ISRG / Let's Encrypt:   https://letsencrypt.org/donate
 * Donating to EFF:                    https://eff.org/donate-le
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

```


(screenshot route53)

Uma vez validado, vamos ganhar dois arquivos gravados em "/etc/letsencrypt/live/akitando.me", um chamado "fullchain.pem", o certificado digital propriamente dito, que vai ser servido pra todo navegador que conectar no meu servidor web, e o "privkey.pem", que é a chave privada que jamais deve sair do meu servidor, nem ser transmitido pela internet de nenhuma forma. 






Estou repetindo pra vocês nunca esquecerem: chave privada se chama "privada" por uma razão. Se perder essa chave privada, qualquer um pode se passar por você. E se alguém ficou pensando "porra, mas e se realmente eu perder essa chave?". A solução é imediatamente gerar um novo certificado e substituir.







Eu não instalei de verdade essa chave porque não tenho site nesse domínio, mas se tivesse, no seu navegador iria aparecer o famoso cadeado. As informações que aparecem quando clica no cadeado é exatamente o conteúdo desse arquivo "fullchain.pem". Ele contém a chave pública e está assinado por uma CA, a Central Authority, no caso, a LetsEncrypt.







Eis a resposta de como podemos garantir que o certificado que o site me deu é confiável. Todo navegador, Firefox, Safari, Edge, Chrome, Opera, já vem pré-instalados com vários certificados raíz, seja da Certsign, Digicert, GlobalSign. São arquivos que foram instalados juntos com seu navegador ou que seu navegador puxa do próprio sistema operacional. Um dos dois vai ter esses certificados raiz.






Se baixou seu navegador fora do site oficial, num site genérico de downloads, não existe garantia nenhuma. La garantia soy yo. Mas se estiver usando o Safari que já veio no seu Mac ou o Edge que já veio no seu Windows, a probabilidade é que sejam legítimos. De novo, se comprou sua máquina usada de um terceiro, e nunca formatou, não dá pra garantir nada. Nenhuma máquina que não foi você quem instalou, ou que não comprou numa loja de verdade, não tem nenhuma garantia, ponto final.






Podemos abrir diretamente o arquivo "fullchain.pem" e veja só, temos uma cadeia de certificados. Primeiro o do meu domínio. Em seguida, vemos que foi assinada pela Letsencrypt que é essa R3. E ela mesma, por sua vez, é assinada por outra autoridade, a Digital Signature Trust Co.






Certificados raíz podem ser instalados com o sistema operacional, ou podem vir com os navegadores. Google Chrome e outros navegadores baseados em Chromium costumam usar o que tem no sistema operacional. Firefox prefere usar certificados próprios. Num Arch Linux, como o Manjaro que eu uso, vem no pacote "ca-certificates" e costumam ficar no diretório "/etc/ssl/certs". Olha só um trecho da listagem dos certificados. E se olharmos mais pra baixo, temos o certificado "ISRG Root X1" que é a raiz que vimos no certificado digital gerado pela Letsencrypt.







Meu navegador acha o ISRG Root X1 instalado na máquina. Ele parte do pressuposto que pode confiar em todo certificado que foi assinado por qualquer autorizada abaixo dela. É uma cadeia de assinaturas. O certificado do meu domínio akitando.me foi assinado pela chave privada da Letsencrypt que, por sua vez, tem um certificado assinado por essa ISRG que é verificado pela Digital Signature Trust que, em última instância, foi instalado no meu sistema operacional. Em última instância, confiamos que o sistema operacional não foi adulterado, porque instalamos com o ISO oficial ou já veio pré-instalado de fábrica e a máquina é nova.







Quando fizemos o processo do "Certbot". Ele gerou aquele "fullchain.pem". Começou gerando o par de chaves pública e privada. Daí empacotou no certificado, que é uma estrutura de dados com informações como o nome do domínio, email, a chave pública, etc. É só um arquivo, como se fosse um JSON da vida, por exemplo, mas num formato específico de certificado. No final, ele gera a impressão digital desse arquivo, que é um hash, usando um algoritmo como um SHA256 da vida.







Impressão digital é outro nome pra um hash. Quando passamos um arquivo ou algum conteúdo por um algoritmo de hashing, o resultado é uma impressão digital. Porque se alterarmos 1 bit que seja do arquivo original e refizermos o hashing, o resultado vai ser completamente diferente. Daqui a pouco vou voltar no tema de hashing. Por enquanto entenda que hashing serve pra identificar exatamente o conteúdo original de qualquer coisa. E o que chamamos de assinatura digital é o hash via chave privada de alguma autoridade. 








Vamos em outro exemplo. YouTube.com. Olha o cadeado aqui no navegador. Se abrirmos vemos que a raíz é um tal de GTS Root R1. Voltando lá pro diretório "/etc/ssl/certs" achamos o arquivo do certificado e abrindo podemos ver que se trata do Google Trust Services LLC. Uma empresa do próprio Google dedicado só a gerenciar esse certificado raíz. O Google sendo gigante, é do interesse dela ter controle sobre uma autoridade certificadora também. Sim, seu computador automaticamente acredita em tudo do Google. Existem várias implicações éticas nesse tipo de coisa mas não é escopo desse video.








Com isso o navegador sabe que o certificado do site é "válido". Daí ele pode pegar a chave pública de dentro do certificado, e usar pra encriptar uma chave simétrica. Isso estabelece o que se chama de "conexão segura". Falando assim dá impressão que passamos a usar, sei lá, um cabo de rede especial que é mais seguro ou algo assim né? Mas não, nada mudou. Estamos na mesma rede física que antes. A diferença é que conseguimos comunicar de forma segura, encriptando todos os pacotes. E a partir daqui, tudo que o navegador mandar pro servidor e vice versa, vai ser encriptado com essa chave.








Tudo isso é feito pra garantir que ninguém no meio do caminho, nem a Skynet, nem o provedor, nem ninguém, consiga ver o que está sendo trafegado, porque vai tudo encriptado. Esse imbróglio todo de cadeias de certificados, assinaturas digitais, pares de chaves assimétricas, é a implementação de um "triângulo de confiança". Segurança é quando eu e o John temos confiança num mesmo terceiro, que é uma autoridade reconhecida por ambos. Pra haver confiança, sempre precisa haver um terceiro elemento que ambos os lados confiam. 







Voltando pra pergunta original, como eu posso confiar na chave pública do John? Como eu sei que não é a Skynet me mandando uma chave falsificada, se passando pelo John? E a resposta é porque tanto minha máquina, quanto a do John, foram configuradas pela primeira vez pela mãe dele. Mãezona Sara Connor se certificou de instalar um certificado raíz dela em ambas as máquinas. Quando o John me mandar o certificado dele, basta ver se tá assinado pelo certificado da Sara. E vou saber isso porque eu também tenho o certificado de CA dela na minha máquina, igual o exemplo do Google que mostrei. E com isso a humanidade ainda tem chances contra a Skynet.







Pra finalizar esta parte, já vimos como usar o certbot pra gerar um novo certificado digital, assinado pela Letsencrypt, pronto pra colocar no meu servidor web. Mas posso já usar aqui mesmo no terminal. Pra isso podemos usar openssl pra extrair só a chave pública que está dentro desse certificado, pelo terminal como estou mostrando. Openssl passando x509 que é o formato de um certificado, passando o arquivo do certificado e mandando extrair a chave pública pra esse arquivo pubkey.pem. Podemos dar cat nesse arquivo e voilá, eis o base64 da chave.


	openssl x509 -pubkey -noout -in /etc/letsencrypt/live/akitando.me/fullchain.pem > pubkey.pem

	cat pubkey.pem 
	-----BEGIN PUBLIC KEY-----
	MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAE+3a8eg0k/O7Sny46alWDx64kA8FK
	SvBs1GxEJA+1ay/6XLg2cF8xEjlDrLbkDrZlUPEr4KxVtFxKAS6uSaCtUA==
	-----END PUBLIC KEY-----



Tendo a chave pública, pra encriptar uma mensagem qualquer ou a chave simétrica, como meu arquivo "key.bin" do começo do video, é só usar openssl pra encriptar, como já mostrei antes. Mas tem um porém. Não vai dar pra mostrar isso porque essa chave pública que extraí do certificado gerado pelo certbot é uma curva elíptica ECC. Lembram porque eu usei RSA no exemplo lá atrás? Porque OpenSSL não consegue encriptar uma mensagem qualquer com ECC, lembra? Foi o motivo todo de porque eu fiz um exemplo com RSA. 







Diferente do exemplo de encriptar uma chave simétrica diretamente usando a chave pública RSA; com curva elíptica, num navegador o que acontece é outro processo chamado de "key exchange" ou troca de chaves. Um método popular é usando o método de Diffie-Hellman que expliquei no meu video antigo de criptografia, ou ECDH que é a variante pra curva elíptica. Está fora do escopo deste vídeo explicar os detalhes, mas pesquise sobre ECDH. 







Em resumo, o navegador já tem implementado um processo só pra trocar chaves simétricas usando essas chaves assimétricas, não precisa fazer na mão como estou mostrando no terminal. Curva elíptica é mais eficiente e mais sofisticado do que o RSA antigo. Mas RSA é suficiente e mais fácil pra demonstrar passo a passo no terminal. Objetivo do vídeo não é tornar ninguém aqui especialista em criptografia, só molhar os dedos pra vocês mesmos depois irem procurar as formas mais avançadas.








Também não é objetivo do video explicar arquitetura de segurança de aplicações web. Só usei o exemplo de TLS pra explicar a utilidade de chaves assimétricas. Muita gente ainda tem na cabeça a imagem de que criptografia é meramente uma única chave secreta super longa. Ou até como nos filmes mostra uma chave física mesmo. Quem assistiu o último Missão Impossível? Eles passam o filme todo literalmente atrás de uma chave dividida em duas ... não é assim que funciona par de chaves. Mas enfim.







Agora precisamos estar na mesma página sobre outro conceito importantíssimo: impressões digitais ou fingerprints e assinatura digital. Novamente, não vou detalhar o que já expliquei no primeiro video de criptografia. Entenda assim: existem diversas funções de hashing como SHA512 que é um dos mais usados. Existem algumas que já são sabidamente defeituosas e fracas, como o antigo MD5. O MD5 não deve ser usado pra assinatura digital porque não é difícil criar colisões, mas não quer dizer que seja inútil. Dependendo do caso de uso, ela ainda é usada. SHA1 é a mesma coisa, deve ser evitado.







A função SHA 512 tem esse nome porque independente do que  passarmos pra ele, o resultado sempre vai ser um número binário de 512 bits, representado como uma string de 128 caracteres, mostrando o binário em formato hexadecimal pra ficar mais fácil de conseguirmos copiar e colar o texto. Pra demonstração, precisamos do programa "sha512sum". Acho que na maioria das distros Linux já vem pré-instalado. No caso de distros derivadas de Arch, costuma ficar no pacote "coreutils".







Vamos pegar aquele arquivo "test.txt" que usamos lá atrás e que tinha o conteúdo "Hello World". Se fizermos "sha512sum test.txt" vai devolver esta string:

```
sha512sum test.txt
e1c112ff908febc3b98b1693a6cd3564eaf8e5e6ca629d084d9f0eba99247cacdd72e369ff8941397c2807409ff66be64be908da17ad7b8a49a2a26c0e8086aa  test.txt
```



Olha só. "Hello World" é super curto, mas mesmo assim o resultado do hash é sempre fixo: um número de 512 bits. Vamos editar esse arquivo e fazer uma modificação de nada. Só adicionar um ponto no final do arquivo. Rodamos o mesmo comando "sha512sum" e olha o resultado, é um novo hash completamente diferente. É essa propriedade que tornam hashes importantes.


```
sha512sum test.txt
cf260f19ff6ac4d64990e2173a7d51252b3bd054cbd1ea5df0841035140592832a2ebc64f17c3dd48e3d8f1682143087217b979de7568c8e1836b008d1a5e463  test.txt
```




Comparem o hash de antes e o novo. Apesar de ter só adicionado um mísero ponto no final, os hashes são completamente diferentes. Não tem como dizer que vieram de arquivos tão parecidos. E este é o objetivo. Por isso eles servem de impressão digital. Um ser humano lendo um texto mais longo, poderia passar batido numa pontuação fora do lugar. Num documento importante, digamos um contrato, um zero fora do lugar pode significar a diferença entre se comprometer a pagar 100 mil ou 1 milhão de dólares. 







Se o contrato tiver 50 páginas, a maioria de nós, seres humanos, íamos passar batido. Mas se o documento original tem uma impressão digital. Basta passarmos o novo documento pelo "sha512sum" e ver se o hash continua batendo. Se bater, temos certeza que o documento está intacto e não foi adulterado. Porém, se o número for diferente, sabemos com certeza que foi adulterado e não pode ser confiado. Não sabemos onde foi adulterado, mas sabemos que foi. Lembram do episódio anterior sobre recuperação de dados? É assim que um sistema de arquivos como ZFS ou BTRFS sabe que um arquivo pode estar corrompido.






Outro exemplo. Vou no site da minha distro favorita, Manjaro e vou baixar a ISO pra instalar. É um arquivão de 3.7 gigabytes. Digamos que eu fiz o download numa rede pública, tipo num aeroporto ou num Starbucks. Como posso garantir que ninguém interceptou minha requisição e me mandou um arquivão falso? Daí quando eu for instalar, na verdade vai instalar um malware?






Chegando numa rede confiável, como minha casa ou escritório, posso baixar esse arquivo de checksum, com extensão .iso.sha512. Agora posso rodar o seguinte comando. Sha512sum passando esse arquivo de SHA e o ISO baixado.


```
sha512sum -c manjaro-gnome-22.1.3-230529-linux61.iso.sha512
manjaro-gnome-22.1.3-230529-linux61.iso: OK
```



Se devolver "OK" é porque tá tudo bem, mas o que ele fez? Vamos abrir o arquivo .iso.sha512. É um numerozão no formado da saída do sha512sum. A empresa que faz o Manjaro, que criou o arquivo de instalação original, gerou o sha512 e gravou nesse arquivo pra gente. 

```
cat manjaro-gnome-22.1.3-230529-linux61.iso.sha512
78b8fa6a5222bc10a2e767485e76f82f3c7b2b59f4a70501b4a9fb846c5ad94987cf8b8ed630a701a8a3386debc0a39fc7363a743df8f13f41d3d8324d74e227  manjaro-gnome-22.1.3-230529-linux61.iso
```




Podemos simplesmente calcular o sha512 em cima do ISO de 3.7 gigabytes com o comando "sha512sum", igual fizemos com o arquivo do Hello World e olha só, gerou exatamente o mesmo hash. Com isso sabemos que nenhum bit dos 3.7 gigabytes veio adulterado. Se um único bit tivesse sido corrompido no download, o hash gerado seria completamente diferente. Com isso sabemos que o ISO é válido e podemos instalar.



```
sha512sum manjaro-gnome-22.1.3-230529-linux61.iso
78b8fa6a5222bc10a2e767485e76f82f3c7b2b59f4a70501b4a9fb846c5ad94987cf8b8ed630a701a8a3386debc0a39fc7363a743df8f13f41d3d8324d74e227  manjaro-gnome-22.1.3-230529-linux61.iso
```





Lembra dos meus videos sobre Git? Esse stringzão não parece com o identificador de um commit? Só que no caso de commit é mais curto. Isso porque Git usa SHA1 em vez de SHA256. SHA1, assim como MD5, também não é mais pra ser usado, mas é difícil migrar pra SHA256 sem quebrar compatibilidade e gerar confusão na cabeça de todo mundo, por isso não usamos SHA256 ainda, mas uma hora Git também deve mudar.






A razão de não usarmos mais MD5 é porque descobriram um bug no seu processo que torna razoavelmente fácil gerar colisões. Ou seja, se modificarmos um determinado documento, cuidadosamente, nos bits certos, temos como mudar o conteúdo e no final o MD5 vai gerar exatamente o mesmo hash. Aí perde o propósito. Descobriram que dá pra fazer isso com SHA1 também, mas não é tão trivial, mesmo assim não é impossível. Não é prático, mas é estatisticamente possível, e isso é suficiente pra considerarmos parar de usar.






Dois conteúdos diferentes que geram o mesmo hash, chamamos de "colisão" e mais cedo ou mais tarde, colisões acontecem. É estatisticamente inevitável, mas é muito difícil de controlar a colisão pra acontecer exatamente quando queremos num SHA256 ou outra função melhor. Mas MD5 e SHA1 já sabemos como controlar as colisões, adicionar bits extras que dá pra ignorar, só pro arquivo no final conseguir chegar no mesmo hash.







Eu explico no video de criptografia sobre hashes usados pra não guardar senhas abertas num banco de dados, assistam depois porque é importante saber disso. Mas caso não saiba, é considerado certificado de estupidez gravar senha dos usuários aberto numa tabela no seu banco de dados. Também é uma idiotice achar que é esperto e gerar o hash da senha e gravar numa tabela. Precisa de salt. E tem algoritmos melhores do que outros. Assista depois pra entender.






O principal é o seguinte: quando um determinado conteúdo, um arquivo ou documento, tem conteúdo secreto, o certo é encriptar o arquivo inteiro usando um algoritmo como AES com uma chave bem longa e forte. Mas pra diversos usos, só pra identificar se foi ou não adulterado, como um contrato, não precisa encriptar o arquivo todo, basta encriptar a impressão digital, que vai ser mais curta. Um exemplo disso é o download da ISO do site da Manjaro.






É um desperdício encriptar uma ISO inteira, não tem nada secreto dentro. É um arquivo público que qualquer um pode baixar e instalar de graça. O problema é saber se a ISO baixada não foi adulterada no meio do caminho. Pra isso tem coisas como o arquivo ".iso.sha512". Mas tem um outro arquivo no site deles também, olha só, eles chamam de assinatura e é um arquivo ".iso.sig". Não dá pra listar porque é um arquivo binário, mas é a assinatura do hash da ISO.






O problema de um arquivo .sha512 é que se baixamos os dois ao mesmo tempo, se o ISO foi adulterado no caminho, certamente o arquivo .sha512 também foi adulterado. Por isso, no exemplo, de propósito eu disse que o cenário é que baixei a ISO do aeroporto mas depois baixei o arquivo .sha512 quando cheguei em casa, numa rede confiável. Mas não precisamos confiar na rede pra checar essas coisas.






Antes de sair de casa, o certo é já ter instalado o pacote "GNUPG" o famoso GPG, que é implementação do padrão OpenPGP, de Pretty Good Privacy. É outro pacote que faz uso do conceito de chaves assimétricas, como no exemplo de TLS com RSA ou curva elíptica, lembra? Chaves pública e privada? Só que no exemplo anterior estávamos lidando com certificados .pem pra servidores web. GPG é similar, mas pra identificar pessoas, e não servidores.






Tendo o GPG instalado, no meu caso, que uso Manjaro, eu já teria que ter baixado as chaves GPG da equipe do Manjaro. Só fazer o download do arquivo com "wget" e instalar com "gpg" assim:

```
wget gitlab.manjaro.org/packages/core/manjaro-keyring/-/raw/master/manjaro.gpg

gpg --import manjaro.gpg
```




Lembra o conceito que o sistema operacional ou o navegador já trazem certificados raiz de autoridades certificadoras? Aqueles arquivos em "/etc/ssl/certs"? O conceito é parecido. Esse arquivo "manjaro.gpg" tem as chaves confiáveis da equipe do Manjaro. Tudo que a equipe de lá assinar, temos como checar agora.






Eu fiz isso em casa, agora estou no aeroporto e resolvi baixar a ISO do Manjaro. Uma rede pública é o oposto de confiável. Por isso recomendamos sempre usar VPN. Mas digamos que não estou numa VPN e ainda assim quero me arriscar a baixar a ISO. Como eu sei que não veio adulterado? Algum hacker esperto subiu um servidor do note dele, adulterou o DNS do roteador do aeroporto, e agora todo download que eu faço na verdade é um malware?






Baixamos também o arquivo ".iso.sig" e podemos checar com o seguinte comando. GPG verify o arquivo .sig e o arquivo ISO.

```
gpg --verify manjaro-gnome-22.1.3-230529-linux61.iso.sig manjaro-gnome-22.1.3-230529-linux61.iso
gpg: Signature made seg 29 mai 2023 06:38:26 -03
gpg:                using RSA key 3B794DE6D4320FCE594F4171279E7CF5D8D56EC8
gpg: Good signature from "Manjaro Build Server <build@manjaro.org>" [unknown]
gpg: WARNING: This key is not certified with a trusted signature!
gpg:          There is no indication that the signature belongs to the owner.
Primary key fingerprint: 3B79 4DE6 D432 0FCE 594F  4171 279E 7CF5 D8D5 6EC8
```



Dentro desse arquivo de assinatura tem o hashing do ISO, assinado pelo Manjaro Build Server. Ele checa o hashing e diz "Good Signature", então o binário do ISO pelo menos bate com o hashing dentro da assinatura. Mas aí tem um bugzinho que pelo jeito existe faz alguns anos no Manjaro: a chave desse servidor de build não pôde ser confirmado. Sei lá porque não vem já pré-instalado como deveria e quando vai checar dá esse aviso. O certo era ter o certificado raiz desse build@manjaro.org já no meu sistema, mas pelo visto não tem. Bug do Manjaro que até hoje não foi corrigido. Se isso mudou, mandem nos comentários abaixo.






O ponto todo desse exercício foi pra vocês terem na cabeça o que é um hash, uma impressão digital e uma assinatura digital. Deixa eu expandir o exemplo do download da ISO pra algo que muitos de vocês já devem ter usado pelo menos uma vez na vida: BitTorrent. De novo, objetivo do video não é ser uma explicação detalhada sobre BitTorrent, então procurem a documentação depois. Eu quero que vocês consigam entender os conceitos de criptografia que ele usa e como eles resolvem o problema de arquivos distribuídos.







Vamos lá, no próprio site do Manjaro, posso baixar um arquivo .torrent. Um download normal, que é o link do lado, vai puxar os 3.7 gigabytes direto do servidor da empresa do Manjaro. Mas com esse arquivo .torrent, a expectativa é conseguir baixar até mais rápido ou com mais estabilidade, porque vou baixar pedaços da ISO de diversos peers diferentes pela internet. Todo mundo que baixou a ISO e deixou o programa de BitTorrent ativo, está compartilhando o mesmo arquivo. Eu posso baixar pedaços em paralelo de várias pessoas diferentes. Essa é a idéia básica de BitTorrent.







Tangente de história. Nos anos 90 a internet era muito mais lenta que hoje, conexões de modem discado. No mundo dos servidores era tudo super imaturo. Ninguém sabia como manter servidores de download decentes, além de banda ser caro. Era terrível, e no meio disso surgiram os primeiros serviços de compartilhamento de arquivos, vulgo pirataria, como o lendário Napster, seguidos de copycats nos anos 2000 como Limewire, Kazaa, eDonkey e outros.






Mas o princípio na época era só um jeito de dizer pra outras pessoas quais arquivos tem na sua máquina pra compartilhar e deixar todo mundo baixar livremente. É o modelo mais simples de compartilhamento de arquivos. Foram anos de controvérsia, diversos processos da indústria de música, até culminar no surgimento dos primeiros serviços comerciais de venda de música e depois de assinatura como iTunes e hoje Spotify.






O grande defeito desse modelo simples de compartilhamento, é que era muito fácil identificar quem tinha os arquivos e ir processar direto essa pessoa, derrubando o compartilhamento. Uma vez que desliga a máquina do cara, somem os arquivos e ninguém baixa mais. Esse era o problema a ser resolvido. O problema ainda não foi totalmente resolvido, mas vamos ver como BitTorrent melhorou radicalmente nossa situação.






Primeiro de tudo, precisamos acabar com o conceito de um servidor único, centralizado de arquivos, de onde todo mundo puxa. É o mesmo problema do servidor de ISOs da Manjaro. Se todo mundo vai no mesmo lugar pra baixar, quanto mais gente descobrir o servidor, mais lento vai ficar pra todo mundo, e maiores os riscos desse servidor cair ou ser derrubado e todo mundo ficar sem nada.






Lembra da minha série sobre armazenamento, sistemas de arquivos e tudo mais? O que é um arquivo? É só um linguição de bits. Por baixo dos panos, eles são organizados como blocos de bits. Podemos picotar um arquivo como quiser e depois remontar. Inclusive é assim que eles são gravados em HDs e SSDs: fora de ordem. Vamos simular esse exercício num terminal de Linux só pra terem essa imagem na cabeça.






Podemos fazer isso com qualquer arquivo, seja texto ou binário, já expliquei que pro computador não faz diferença nenhuma, por baixo é tudo um linguição de bits. Só pra nós humanos que faz diferença porque arquivos texto conseguimos abrir e ler. De exemplo, peguei o script do episódio 142 que foi a explicação sobre ChatGPT. Esse script tem 94 kilobytes, ou seja, 94 mil letras. Quero conseguir dividir isso em arquivos iguais de exatamente 10 kilobytes cada, pra simular blocos de 10 kilobytes.






Pra isso usamos o comando "split" que tem em Linux. Só passar o tamanho de cada pedaço, o arquivo original e o prefixo do nome dos pedaços, que vou chamar de chunk.


```
split -b 10K subtitle_142.txt chunk_

❯ ls -la
.rw-r--r--  10k akitaonrails 18 jul 13:22  chunk_aa
.rw-r--r--  10k akitaonrails 18 jul 13:22  chunk_ab
.rw-r--r--  10k akitaonrails 18 jul 13:22  chunk_ac
.rw-r--r--  10k akitaonrails 18 jul 13:22  chunk_ad
.rw-r--r--  10k akitaonrails 18 jul 13:22  chunk_ae
.rw-r--r--  10k akitaonrails 18 jul 13:22  chunk_af
.rw-r--r--  10k akitaonrails 18 jul 13:22  chunk_ag
.rw-r--r--  10k akitaonrails 18 jul 13:22  chunk_ah
.rw-r--r--  10k akitaonrails 18 jul 13:22  chunk_ai
.rw-r--r-- 1,5k akitaonrails 18 jul 13:22  chunk_aj
.rw-r-----  94k akitaonrails 18 jul 13:21  subtitle_142.txt
```



Pronto, obviamente, só o último arquivo vai ser menos que 10 kilobytes, mas vejam como consegui dividir direitinho. Posso tentar dar cat em qualquer pedaço e vai vir o trecho do script. Quebrar arquivos grandes em pedaços menores era algo que fazíamos o tempo todo nos anos 90 porque era muito arriscado tentar fazer download de um arquivo gigante. O modem podia desligar no meio do caminho, algoritmos de checagem de corrupção ainda não eram difundidos, então podia vir sujeira na linha e o arquivo ser corrompido. Se viesse corrompido, precisava mandar baixar tudo de novo do zero.






Então dividíamos o risco. Era melhor deixar agendado pra ir baixando um pedaço de cada vez. Se alguma coisa desse errado, só um pedaço ia ser corrompido e dava pra baixar só aquele pedaço separado depois, em vez de ter que recomeçar do zero. Hoje em dia o próprio protocolo HTTP suporta resumir um download pela metade e o protocolo TCP garante que os pacotes não vão vir corrompidos, como já expliquei na série de redes. Mas estou falando de uma era antes dessas facilidades.






E agora vocês já sabem. Uma forma de manualmente checar se meus pedaços vieram corretamente seria ter um arquivo com o hash de cada pedaço. Assim podemos comparar o hash do download e ver se nada foi corrompido. Lembra? Como estou falando de anos 90, poderíamos fazer o SHA1 de cada pedaço. Por exemplo, eis o hash do primeiro pedaço, com o comando sha1sum:


```
❯ sha1sum chunk_aa
c3bb4df901fb79af2421cc274e9db87309bf6424  chunk_aa
```



Com um pouco de mágica de script de shell, podemos fazer a mesma coisa pra todos os pedaços e colocar num arquivo "index.txt" da seguinte forma, fazendo, pra cada file, ou arquivo, que começa com "chunk", gere o sha1 e vá adicionando nesse arquivo index.txt.


```
for file in chunk_*; do
    sha1=$(sha1sum "$file" | awk '{print $1}')
    echo "$file $sha1" >> index.txt
done


/tmp/subtitle 
❯ cat index.txt 
chunk_aa c3bb4df901fb79af2421cc274e9db87309bf6424
chunk_ab 79a5c1fb9a9708982a92009d874bd9ee3db65a31
chunk_ac 84de6f8eb80fc64628514500b8d6b09ff930bda5
chunk_ad 2f68d9f1caffdfca69b28ae33348cdd0ca467474
chunk_ae c644daae2adcc6c87b8b4ee91052535c50edbe4f
chunk_af de3471b65337f2ffb2d97bbd6ef45b1e95d6ba88
chunk_ag 454093fda498e7f67cacb0919e3a5ffa579d0cb6
chunk_ah a0d040c39213188382dc681d7a74da283bfb07c0
chunk_ai 0469b41afb556f10c01cca5f099a81e6b5e17a31
chunk_aj 45fa07b4fdfea4a0a5c02abcad6520b652264a25
```



Por isso é interessante aprender sobre scripts de shell. Abrindo o arquivo "index.txt" com "cat" temos o nome do arquivo de cada pedaço seguido do seu hash SHA1. Olhem como o sha1 do primeiro arquivo bate com o que geramos na mão antes. Então está correto. Além disso, esse arquivo me diz exatamente a totalidade dos pedaços que preciso baixar. Poderíamos fazer outro script pra baixar cada pedaço, checar o SHA1 e se vier errado, mandar refazer o download só daquele pedaço. Fica de exercício pra vocês fazerem isso.






Ok, fizemos o download de todos os pedaços. E agora? Como  remontamos o arquivo original? É simples, bastar dar "cat" de todos os pedaços e redirecionar pra um arquivo final, assim, cat chunk asterisco maior pra restored.txt: 

```
cat chunk_* > restored.txt

❯ sha512sum restored.txt   
bfec6c9efe398146b8197b7b0258860563f6057dac7f6d1931ec5d4118c730d47007678ddd2cf9387b5b02903c7dd35a1911a2da4707d624ce4e996514a766c6  restored.txt

/tmp/subtitle 
❯ sha512sum subtitle_142.txt 
bfec6c9efe398146b8197b7b0258860563f6057dac7f6d1931ec5d4118c730d47007678ddd2cf9387b5b02903c7dd35a1911a2da4707d624ce4e996514a766c6  subtitle_142.txt
```


Isso funciona em shells modernos porque a maioria sempre lista os arquivos em ordem alfabética. Caso o seu não faça isso, precisaria primeiro usar o comando "sort", de novo, fica de exercício. Mas assumindo que o cat pegou cada arquivo chunk na ordem certa, como sei que o arquivo restored.txt realmente é idêntico ao original? Vocês já sabem né? Só comparar o hash dos dois. E como podem ver, é exatamente igual. Se um único bit tivesse vindo errado, os hashes seriam diferentes.







Estão entendendo como podemos manipular qualquer tipo de dados e garantir a integridade deles via ferramentas criptográficas? Sabendo desses conceitos, vou fazer uma explicação super de alto nível pra explicar como BitTorrent tira proveito disso que acabei de explicar.







Existem duas formas de baixar um arquivo via Torrent. Um é baixando um arquivo .torrent, como aquele do site do Manjaro. Podemos usar o programa "transmission-show" que vem no pacote "transmission-cli" pra abrir e ver o conteúdo desse arquivo.


```
❯ transmission-show manjaro-gnome-22.1.3-230529-linux61.iso.torrent 
Name: manjaro-gnome-22.1.3-230529-linux61.iso
File: manjaro-gnome-22.1.3-230529-linux61.iso.torrent

GENERAL

  Name: manjaro-gnome-22.1.3-230529-linux61.iso
  Hash v1: 68617f6ffc9f95bbca41733556f666739f647f9c
  Created by: mktorrent 1.1
  Created on: Mon May 29 06:38:30 2023

  Piece Count: 1769
  Piece Size: 2.00 MiB
  Total Size: 3.71 GB
  Privacy: Public torrent

TRACKERS

  Tier #1
  udp://tracker.opentrackr.org:1337

WEBSEEDS

  https://download.manjaro.org/gnome/22.1.3/manjaro-gnome-22.1.3-230529-linux61.iso

FILES

  manjaro-gnome-22.1.3-230529-linux61.iso (3.71 GB)
```


O importante desse arquivo é que ele identifica o que vamos baixar, no caso o ISO, e onde podemos achar esse arquivo. Primeiro temos esse tal de tracker. Um tracker é um servidor que contém listas de peers que estão online e que tem o arquivo com este hash. Se tiver pelo menos 1 peer ativo que seja um seeder, vai começar a baixar. Peer é o nome que damos pra qualquer máquina, PC, servidor, participando dessa rede. Um tracker não necessariamente tem o arquivo ou seus pedaços, mas sabe quem pode ter, que são os peers.






Você já deve ter visto essa nomenclatura em programas de torrent como QBitTorrent ou Transmission. Quanto mais seeders tiver ativo, melhor será o download. Seeder são computadores online que também estão compartilhando o mesmo arquivo ou pedaços. Leechers são computadores online fazendo download mas não contribuindo em nada. Parasitando mesmo, leeching. O algoritmo do BitTorrent tenta ser justo e deixar download mais rápido pra quem contribui e download mais lento pra quem é só parasita.







Trackers só compartilham e sincronizam a lista de peers, peers podem ser tanto seeders quanto leechers. Quanto mais seeders, mais rápido o download, quanto mais leechers e menos seeders, mais lento o download. O mundo ideal é todo mundo ser seeder. Alguns são chatos e desligam mesmo, outros realmente não conseguem contribuir porque a rede do provedor bloqueia e eles não sabem como furar firewall. Eu falo de furar firewall na série de redes. Depois procurem saber mais como habilitar portas, usar VPN pra torrent e coisas assim, não vou falar disso hoje.







Vamos voltar pro arquivo .torrent. Olhem outras informações que ele nos dá. Sabemos que o arquivo ISO tem 3.7 gigabytes, como já repeti várias vezes, e sabemos que este torrent está organizado em mil setecentos e sessenta e nove pedaços de 2 megabytes cada. Lembra os chunks que fiz usando o comando split? É a mesma coisa. Ele não mostra aqui, mas dentro desse torrent vai ter uma lista de pedaços seguido do hash de cada pedaço, parecido com aquele arquivo "index.txt" que fiz no exemplo.







Cada seeder que o tracker conhece, vai ter ou o arquivo inteiro ou o arquivo parcial, porque ainda não terminou o download. Agora eu, que comecei o download agora, começo a baixar cada um desses pedaços de cada um dos seeders disponíveis, em paralelo. Por exemplo, digamos que na rede tenha o seeder John, a seeder Sara e o seeder Kyle. E eu vou baixar aquele meu arquivo de script. Começo a baixar o chunk_aa do John, o chunk_ab da Sara, o chunk_ac do Kyle e assim por diante.







Toda vez que um chunk termina de baixar, consigo checar o hash e sei que tá correto, daí peço o chunk seguinte, distribuindo a carga entre todos os seeders. Se outra pessoa aparecer pedindo o mesmo arquivo, talvez ele pegue um chunk de mim. Entenderam? O seeder não precisa ter o arquivo completo pra começar a contribuir, basta ter pelo menos um chunk completo. E por isso, quanto mais gente tiver, menos pesado fica pra todo mundo, especialmente pro servidor principal da Manjaro. É a base de computação distribuída.







Se não tiver nenhum seeder ativo, o arquivo .torrent aponta pra um Webseed, que é o link pro arquivo original no servidor da Manjaro. Daí seria como um download direto normal mesmo. Entenderam até aqui: com uma lista de pedaços e seus respectivos hashes, distribuídos entre diversos computadores num swarm, ou enxame, e cada um baixando um pedaço do computador do outro, até todo mundo ter o arquivo completo, essa é a arquitetura básica por trás do BitTorrent.







BitTorrent é "decentralizado" no sentido que, diferente de um iTunes da Apple, não tem uma única empresa nem um único servidor que centraliza os downloads. Eis alguns mecanismos que tornam o BitTorrent resiliente, embora não totalmente invulnerável.






De cara, poderíamos pensar que se derrubarmos quem mantém trackers, poderíamos parar um enxame, não? Primeiro, não existe somente um tracker, existem diversos trackers servindo um de backup pro outro. Precisaria derrubar todos os trackers em atividade no mundo. Mas isso não seria suficiente.






Toda vez que você abre um programa como Transmission ou Nano Torrent da vida, ele faz "bootstrapping" usando uma lista de "bootstrapping nodes", uma lista de nós bem conhecidos na rede que acreditamos que costumam estar online, vários deles. São esses nós que nos ajudam a achar outros nós. Assim como trackers, eles também não são pontos únicos de falha. 







Quando seu programa se conecta e acha um tracker ou um bootstrapping node, ele se junta à rede DHT ou Hash Table distribuído. Cada nó que entra na rede armazena informação sobre a rede toda ou um pedaço da rede. Então, quando você pergunta ao DHT por alguma coisa, seu cliente de BitTorrent manda uma requisição pra um nó que ele conhece. Esse nó ou vai ter a informação e te retornar ou vai te direcionar pra outro nó que pode saber essa informação. A partir desse ponto você, como nó da rede, passa a ter essa informação e pode responder a alguém que te perguntar também. Todo mundo se torna backup e contribui pra outras pessoas.







O conceito de trackers é um pouco obsoleto na realidade, das primeiras versões de BitTorrent. Ele veio evoluindo e agora temos o conceito de DHT e PEX que é Peer Exchange. Mesmo derrubando todos os trackers, cada pessoa conectada na rede contribui pra distribuir a informação do resto da rede. Hoje em dia os programas de BitTorrent implementam as duas maneiras.







Eu falei do arquivo .torrent que baixamos pra começar um download via BitTorrent, mas nem precisamos desse arquivo. Vocês já devem ter visto o que se chama de link magnético, que é tipo uma URL que usa o protocolo "magnet". Lembram o arquivo .torrent da ISO do Manjaro que baixamos? Podemos gerar um link a partir dele usando o programa "transmission-show" com a opção "-m":


```
❯ transmission-show -m /mnt/terachad/Downloads/manjaro-gnome-22.1.3-230529-linux61.iso.torrent
magnet:?xt=urn:btih:68617f6ffc9f95bbca41733556f666739f647f9c&dn=manjaro-gnome-22.1.3-230529-linux61.iso&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&ws=https%3A%2F%2Fdownload.manjaro.org%2Fgnome%2F22.1.3%2Fmanjaro-gnome-22.1.3-230529-linux61.iso
```


É esse link que encontramos em diversos sites que listam torrents pra baixar. Veja num Piratebay da vida, onde tem esse ícone de ímã. Quando clica, automaticamente pede pra abrir seu programa de Torrent instalado. A parte mais importante é esse "btih" logo no começo que é o BitTorrent InfoHash, o hash que identifica unicamente esse arquivo de ISO. O resto ajuda mas é opcional. Por exemplo, ele tem o link pro webseed caso ninguém esteja oferecendo o arquivo na rede e também o link pra um tracker.





Vamos fazer um html idiota com o link pra esse magnet. Um link com a URL inteira que foi gerado e um segundo link só com o infohash. 


```
<html>
	<body>
		<p><a href="magnet:?xt=urn:btih:68617f6ffc9f95bbca41733556f666739f647f9c&dn=manjaro-gnome-22.1.3-230529-linux61.iso&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&ws=https%3A%2F%2Fdownload.manjaro.org%2Fgnome%2F22.1.3%2Fmanjaro-gnome-22.1.3-230529-linux61.iso">Magnet pro ISO</a></p>
		<p><a href="magnet:?xt=urn:btih:68617f6ffc9f95bbca41733556f666739f647f9c">Magnet pro ISO (só infohash)</a></p>
	</body>
</html>
```





Se abrir num navegador e clicar no link, o media type está associado ao QBitTorrent instalado no meu Manjaro. Ele abre e oferece pra começar a baixar. Se eu abrir pelo segundo link, mesmo sem informação de webseed e nem de tracker, só com o infohash, olha só, abre normalmente e oferece pra baixar igual. Isso porque o QBitTorrent na minha máquina se uniu à rede, via DHT e PEX e conseguiu achar os seeders e já sabe como começar a baixar.







Entenderam? Pra parar um arquivo de ser compartilhado, não basta derrubar todos os trackers, precisa parar 100% de todo mundo que está compartilhando o arquivo, de todas as partes do mundo, ao mesmo tempo. Se tiver só um nó na rede funcionando, dá pra continuar compartilhando, porque via DHT e PEX, essa informação vai voltar a ser distribuída. Computação distribuída é fascinante por causa disso: ninguém consegue parar somente com uma canetada sem comprometer a internet inteira de funcionar direito. Por isso eu gosto desse conceito.







DHT e PEX são assuntos fascinantes por si só, pra garantir a descentralização da rede, então espero que vocês pesquisem mais sobre isso depois. Ótimo tema pra TCC. Mas tem um assunto menos comentado que eu acho ainda mais interessante. É o conceito de Árvores de Hashes ou Merkle Trees, nome dado por causa do criador do conceito, Ralph Merkle, que inventou isso no fim dos anos 70.







Vamos lá. O que temos até agora é um arquivo "index.txt" com uma lista de chunks ou pedaços daquele meu arquivo de script. 10 pedaços com o hash SHA1 do lado de cada um, lembram? Numa versão rudimentar de BitTorrent, eu poderia ter baixado esse arquivo e perguntado na tabela distribuída de hashes, o tal DHT, de onde baixar cada pedaço, identificado pelo SHA1, que serve como um ID único pra cada pedaço.






Depois que fizer o download de cada pedaço, basta rodar o comando "sha1sum" e comparar o hash com o que tem no arquivo "index.txt". Se bater é porque veio correto, sem corromper nem nada. No final, basta concatenar os pedaços como fiz antes, gerar o hash do arquivo todo, comparar com o hash mestre do arquivo original, pra garantir que tenho o mesmo arquivo no final. Parece simples e parece que só isso é o suficiente.







Mas no mundo real tem várias razões de porque isso não é suficiente. Pra começar, via BitTorrent podemos trafegar arquivos de qualquer tamanho gigante, posso compartilhar diretórios inteiros com milhares de arquivos. Eu poderia fazer um torrent do C: inteiro do meu Windows se quisesse. E posso puxar pedaços de diversos nós diferentes no enxame de computadores participando na rede. Pra validar o hash de tudo, dessa forma, não seria prático. Imagine ter que computar o hashzão do seu HD inteiro pra saber se o que fiz download tá correto. Seria muito pesado, em alguns casos até inviável.







Em programação, você sempre vai bater nesse caso: pra um arquivo pequeno, com poucos kilobytes ou megabytes de tamanho, o esquema simples de um arquivo de hashes é mais que suficiente. Mas pra escala de internet, onde podemos querer lidar com gigabytes ou terabytes, milhares de arquivos num mesmo torrent, não vai escalar.






Pense assim, temos 10 hashes, um pra cada pedaço, e temos 1 hash mestre, que valida o arquivo completo inteiro. Eu recebo esses hashes e começo a fazer download de algum nó. Veio esse primeiro pedaço chunk_aa, o hash começa com c3bb. Eu rodo o comando sha1sum e vejo que, sim, o hash começa com c3bb mesmo. Bacana. Isso só garante que o pedaço é quem ele diz que é, mas como eu sei que de fato esse pedaço faz parte do arquivão inteiro?







A única forma é baixar todos os 10 pedaços, concatenar tudo, rodar o "sha1sum" pro arquivo gerado e comparar com o hash mestre. Só assim vou saber que todos os pedaços são realmente válidos pra esse arquivo, entenderam? Os hashes individuais não me dizem nada sobre o arquivo inteiro original. Eu tenho que confiar que o nó da rede, que me deu essa informação, não mentiu pra mim. Imagina se fosse um torrent como falei antes, com vários arquivos e muitos gigabytes. Eu só ia ter certeza que todos são válidos depois que baixar tudo.







Em BitTorrent, vocês já devem ter visto que podemos escolher baixar somente alguns dos arquivos e não todos. Então, de cara, esse esquema de só ter um hash mestre pra tudo não funciona. Eu preciso de hashes parciais, no mínimo um pra cada arquivo separado, não? E mesmo assim, preciso garantir que esse arquivo, uma vez que baixei os pedaços e montei, de fato faz parte do conjunto todo, sem ter que baixar o conjunto todo. Como faz?






Pra simplificar, vamos partir de novo do exemplo de 10 pedaços. Imagine que isso poderia ser um arquivo de milhares de pedaços e dezenas de arquivos em sub-diretórios. É uma simplificação, ok? Pois bem, começo organizando esses pedaços em pares. chunk_aa com chunk_ab, depois chunk_ac com chunk_ad e assim por diante. Pares de pedaços.






Agora pegamos o hash de cada par e concatenamos só eles. Por exemplo, o hash c3bb do chunk_aa com o hash 79a4 do chunk_ab. E gero o hash dessa combinação. Vai dar um hash que começa com "0285". Faço a mesma coisa com os hashes do próximo par, vai dar um novo hash que começa com "84de" e continuo fazendo isso pros outros pares.

```
/tmp/subtitle 
❯ echo "c3bb4df901fb79af2421cc274e9db87309bf642479a5c1fb9a9708982a92009d874bd9ee3db65a31" | sha1sum
0285f4ec89c694112c330ec20a571457a4e159f2  -

/tmp/subtitle 
❯ echo "84de6f8eb80fc64628514500b8d6b09ff930bda52f68d9f1caffdfca69b28ae33348cdd0ca467474" | sha1sum
05e420886ad96877bd78051df8a01c4a9414cc33  -

/tmp/subtitle 
❯ echo "c644daae2adcc6c87b8b4ee91052535c50edbe4fde3471b65337f2ffb2d97bbd6ef45b1e95d6ba88" | sha1sum
d9e3a713ccd57d87adb4ea04aede0cebdcc8fd8e  -

/tmp/subtitle 
❯ echo "454093fda498e7f67cacb0919e3a5ffa579d0cb6a0d040c39213188382dc681d7a74da283bfb07c0" | sha1sum
4c6b2637222b6a7cc9e52a3d5441dedcdf00b4e6  -

/tmp/subtitle 
❯ echo "0469b41afb556f10c01cca5f099a81e6b5e17a3145fa07b4fdfea4a0a5c02abcad6520b652264a25" | sha1sum
65c704fefd21e50f92df28de813ef2d3b4d7cff4  -

```

```
0285f4ec89c694112c330ec20a571457a4e159f2
05e420886ad96877bd78051df8a01c4a9414cc33
d9e3a713ccd57d87adb4ea04aede0cebdcc8fd8e
4c6b2637222b6a7cc9e52a3d5441dedcdf00b4e6
65c704fefd21e50f92df28de813ef2d3b4d7cff4
```



No final vou ter 5 novos hashes. Agora repito o mesmo processo. Organizo pares de hashes, concateno e gero um novo hash pra cada par. Pego esse hash que começa com "0285" com o hash que começa com "05e4" e gero o hash que começa com "9361". Faço isso pro segundo par. Só no terceiro par que vou ter problemas porque o último hash vai ficar sozinho. Não tem problema, gero o hash dele também, concatenado com vazio mesmo.

```
/tmp/subtitle 
❯ echo "0285f4ec89c694112c330ec20a571457a4e159f205e420886ad96877bd78051df8a01c4a9414cc33" | sha1sum
9361c518dbcc3374c2d9a6c343dfa903f5226219  -

/tmp/subtitle 
❯ echo "d9e3a713ccd57d87adb4ea04aede0cebdcc8fd8e4c6b2637222b6a7cc9e52a3d5441dedcdf00b4e6" | sha1sum
910ec073793aafe29790941efe004c17debdc2d9  -

/tmp/subtitle 
❯ echo "65c704fefd21e50f92df28de813ef2d3b4d7cff4" | sha1sum
2924e53ff12eae61d88da7a0cca2967150881598  -


```



Vamos repetir mais uma vez. Par de hashes "9361" com "910e" vai dar "bdf3" e o último hash é "2354". E pronto. Chegamos ao final, temos só dois hashes resultantes. Geramos o hash da concatenação desses dois também. Vai dar um hash final que começa com "f2fb". Esse hash é especial, é o que chamamos de Merkle Root ou Raiz Merkle. É o hash que engloba todos os outros hashes.

```
/tmp/subtitle 
❯ echo "9361c518dbcc3374c2d9a6c343dfa903f5226219910ec073793aafe29790941efe004c17debdc2d9" | sha1sum
bdf3037c43dbe2cb7bf318a38948b3a504bea5d7  -

/tmp/subtitle 
❯ echo "2924e53ff12eae61d88da7a0cca2967150881598" | sha1sum
2354ddf1e76303140524dad59d5c2c3f418d87b7  -



/tmp/subtitle 
❯ echo "bdf3037c43dbe2cb7bf318a38948b3a504bea5d72354ddf1e76303140524dad59d5c2c3f418d87b7" | sha1sum
f2fb982d0f416376d64a7b451fa2d2176bf45ca8  -


```


```
chunk_aa c3bb
chunk_ab 79a5  0285
chunk_ac 84de
chunk_ad 2f68  05e4  9361
chunk_ae c644
chunk_af de34  d9e3
chunk_ag 4540
chunk_ah a0d0  4c6b  910e  bdf3
chunk_ai 0469
chunk_aj 45fa   65c7  2924  2354  f2fb
```




Antes, se eu só tivesse o hash mestre, precisaria de todos os 10 hashes de cada pedaço pra saber se tá tudo correto. Mas nesse esquema da árvore de Merkle, digamos que eu queira saber se o pedaço "aa" que acabei de baixar realmente faz parte do arquivo final, sem baixar os outros pedaços, como eu faço? Peço pro servidor somente os hashes do irmão "ab", com isso consigo calcular "aa" e "ab" como fiz antes. Daí preciso que o servidor me mande os 4 hashes "acad", "aeaf", "agah", "aiaj". 






Tendo somente esses 4 hashes, mais o hash do pedaço "aa", consigo recalcular a árvore e achar a raiz Merkle e comparar com o que o servidor me indicou. Se bater, quer dizer que esse pedaço que baixei faz parte do arquivo final. Repetindo: eu diminuí a necessidade de precisar de todos os 10 hashes pra somente 4 hashes, sacaram?






De novo, é um exemplo super pequeno e simples só pra caber aqui na tela. Mas veja aquele exemplo da ISO do Manjaro, lembram? Eram quase mil e oitocentos pedaços. Se eu baixar só um pedaço, pra garantir que ele faz realmente parte do ISO original, precisaria calcular o hash mestre usando todos os quase mil e oitocentos hashes. Mas organizado numa árvore, precisaria só de uns log2(2048) que dá 11.







A árvore precisa ser balanceada, e o próximo número acima de mil e oitocentos que balanceia uma árvore binária é 2048. Enfim, eu preciso que o servidor me mande a raiz Merkle que ele tem pré-calculado e 11 hashes dessa árvore, mais ou menos. Não é um número exato esse log. Mas entenda que 11 é uma ordem de grandeza menos hashes do que mil e oitocentos. Mesmo nesse exemplo simples de só uma ISO de Manjaro, já temos um ganho significativo.






BitTorrent não foi criado com árvores Merkle, isso é uma coisa mais recente. Da mesma forma que hoje não precisaria de trackers por causa de DHT e PEX. É uma tecnologia ainda em evolução. Lembram do que eu falei no video sobre bancos de dados: árvores são as estruturas de dados mais importantes da computação, tudo são árvores. Nesse caso, árvores binárias, mas já falei de B-trees ou B+Trees em sistemas de arquivos. Assistam meu video de Árvores depois.






Sabe que outro programa se beneficia de árvores Merkle? Git. O que são commits? São diffs com trechos de arquivos de código fonte, mais metadados, como nome do arquivo, autor da modificação, datas. Uma característica importante de um commit é que ele é identificado por um hash, um SHA1 do seu conteúdo. É como sabemos que o conteúdo não foi adulterado, da mesma forma como fizemos pra checar os chunks do download via BitTorrent.







Mas um commit de Git tem outra característica importante: ele contém o SHA1 do commit pai anterior. Por isso commits formam uma cadeia, mais especificamente, uma árvore. Objetos de árvore de diretórios também tem SHA1 dos objetos filho. Tudo isso forma um DAG, um direct acyclic graph ou grafo direcionado não cíclico, mais especificamente um Merkle DAG.







Uma característica importante é que como todo commit contém o SHA1 do commit anterior, é impossível modificar só um commit no meio da árvore. Precisaria reescrever todos os commits na frente e regerar SHA1 novos pra todos. É o que chamamos de "reescrever a história". Vocês já devem ter ouvido falar disso em discussões se é melhor fazer merge ou rebase e todo mundo é contra fazer rebases na master porque isso "reescreve a história". É isso que significa reescrever a história: tem que regerar o SHA1 de todos os commits pra frente.







Deixa eu mostrar rapidamente com um exemplo. Vamos iniciar um novo repositório com "git init" e criar um arquivo de teste idiota só pra criar o primeiro commit.

```
❯ git init
hint: Using 'master' as the name for the initial branch. This default branch name
hint: is subject to change. To configure the initial branch name to use in all
hint: of your new repositories, which will suppress this warning, call:
hint: 
hint: 	git config --global init.defaultBranch <name>
hint: 
hint: Names commonly chosen instead of 'master' are 'main', 'trunk' and
hint: 'development'. The just-created branch can be renamed via this command:
hint: 
hint: 	git branch -m <name>
Initialized empty Git repository in /tmp/teste/.git/



teste on  master 
❯ echo "hello world" > hello.txt

teste on  master [?] 
❯ git a .

teste on  master [+] 
❯ git c "initial commit"
[master (root-commit) 308ba8d] initial commit
 1 file changed, 1 insertion(+)
 create mode 100644 hello.txt

```


Fazendo "git log" vemos o commit identificado pelo hash que começa com "4b4c". Agora vamos criar um novo branch chamado "teste", modificar o arquivo e criar um novo commit. 
No caso criou um novo commit identificado pelo hash que começa com "65c2". (no exemplo abaixo está com outro hash porque refiz o exemplo e a mudança de data gera hashes diferentes)

```
commit 1eb601ac03c713abaa08fd54e002eec04ee66922 (HEAD -> teste)
Author: AkitaOnRails <fabioakita@gmail.com>
Date:   Thu Aug 24 11:54:32 2023 -0300

    adding hello again

commit 308ba8d7ee9ac84c6b318393614203e2b905f0f4 (master)
Author: AkitaOnRails <fabioakita@gmail.com>
Date:   Thu Aug 24 11:53:28 2023 -0300

    initial commit


```


Agora vou voltar pro branch master, criar um novo arquivo qualquer e gravar em outro commit. Veja só, criou esse commit com hash que começa com "9431". Agora, em vez de merge vou fazer rebase do branch teste em cima do branch master com "git rebase teste". Como não fiz nada demais, vai terminar sem nenhum conflito.

```
commit 921bb4796a2545fabc87324b5a8fa069d53201f2 (HEAD -> master)
Author: AkitaOnRails <fabioakita@gmail.com>
Date:   Thu Aug 24 11:55:16 2023 -0300

    adding foo

commit 1eb601ac03c713abaa08fd54e002eec04ee66922 (teste)
Author: AkitaOnRails <fabioakita@gmail.com>
Date:   Thu Aug 24 11:54:32 2023 -0300

    adding hello again

commit 308ba8d7ee9ac84c6b318393614203e2b905f0f4
Author: AkitaOnRails <fabioakita@gmail.com>
Date:   Thu Aug 24 11:53:28 2023 -0300

    initial commit

```


Fazemos "git log" e olha só, o commit que eu tinha acabado de fazer, que tinha o hash começando em "9431" agora começa com "ee00". Isso porque antes, o commit anterior era o "initial commit" com hash "4b4c". Como fiz rebase, ele trouxe o commit "adding hello again" de hash "65c2", que passa a ser o novo pai do commit "adding teste", portanto o hash desse commit tem que ser recalculado e por isso mudou pra "ee00", ou seja, acabamos de reescrever a história.






Esse conceito é muito importante. Ao colocar o SHA1 do commit anterior no commit atual, criamos uma dependência entre esses dois objetos. Se o objeto anterior mudar, se seu hash mudar, o hash do objeto seguinte vai ser invalidado e precisa ser recalculado também. Não dá pra simplesmente entuchar um commit no meio da cadeia sem consequências e é isso que garante a integridade do código fonte armazenado nesse repositório. 






Se alguém tentar adulterar um commit lá atrás no passado, ele vai ser obrigado a fazer rebase de tudo pra frente, ou seja, recalcular o SHA1 de todo mundo. Daí todo mundo vai imediatamente saber que o repositório foi modificado, porque os IDs de tudo vão estar diferentes. É onde temos que lidar com conflitos depois. Se você nunca parou pra entender como o Git realmente funciona, recomendo que assista meu video de "Entendendo Git".






Entenda, ter um Merkle Tree não impede que um commit seja adulterado. Só torna mais fácil de identificar quando for. E torna mais barato fazer os cálculos pra chegar nessa conclusão, do que ter que checar o SHA1 de 100% de tudo. No caso de Git, que é um repositório decentralizado, digamos que era uma equipe de 5 pessoas. Uma delas faz pull do GitHub e nota que alguém fez merda e deu "push --force" de um rebase gigante que reescreveu centenas de commits.






Você consegue ver que isso aconteceu e consegue ligar pra um dos outros colegas que ainda não fez "pull" e pedir pra ele dar um novo "push --force" pra recuperar o histórico como era antes e eliminar a cagada. O fato de termos várias cópias do mesmo repositório nas máquinas de todo mundo é um tipo de backup. Se o repositório elegido como principal ficou zoado, tem formas de recuperar. E não precisa sobrescrever tudo, só a partir do commit onde deu rebase, entenderam?






Existem várias discussões sobre centralizadores de Git como GitHub ou GitLab. Eles centralizaram a confiança de Git neles, mas Git originalmente não era pra ter um ponto único de falha. Você pode fazer git clone do repositório de alguém localmente, num pendrive, como mostrei no episódio anterior. Não precisa obrigatoriamente ter que fazer git clone de um repositório do GitHub. Isso é outra discussão, só pra vocês saberem que Git também foi feito pra ser distribuído, mas hoje em dia usamos centralizado num GitHub da vida.








Voltando pro exemplo de BitTorrent. Como qualquer computador na internet pode participar do compartilhamento de arquivos, sim, algum computador malicioso poderia começar a tentar espalhar binários adulterados. Mas o principal é o arquivo .torrent ou link magnético que aponta pra algum nó que normalmente confiamos, que vai nos fornecer a árvore Merkle com os hashes. Tendo os hashes, conseguimos checar se os pedaços que baixamos são válidos ou não.







Esses hashes são organizados numa tabelona, mais especificamente numa tabela distribuída, ou Distributed Hash Table, o DHT que eu fico falando. Pra quem é desenvolvedor web, é parecido com um DynamoDB. Cada item nessa tabelona ganha um ID longo de 160 bits. E os possíveis IDs são particionados entre os diversos nós da rede, de tal forma que cada nó só é responsável por um pedaço do espaço de IDs possíveis. 







Toda vez que algum nó precisa registrar alguma coisa, ele gera uma chave e com isso determina qual nó que é responsável pelo espaço de IDs que essa nova chave faz parte, e manda pra esse nó. Mesma coisa pra pesquisar dados na tabela, tendo o ID pra consultar, ele pergunta pro nó responsável por esse intervalo de IDs. 






Uma rede de BitTorrent é gigantesca, milhares ou milhões de nós ao mesmo tempo. É impossível meu computador saber quais são todos os nós ativos neste exato momento no mundo. Em vez disso, cada nó mantém um tipo de tabela de roteamento com informações sobre um sub-conjunto dos nós na rede, preferencialmente os mais "próximos" do espaço de IDs. Quando alguém pede pro seu nó gravar ou ler um certo ID mas você não é o responsável, dá pra usar essa tabela de roteamento pra redirecionar pro nó certo.






E claro, um nó pode simplesmente desaparecer do nada. Como cada nó pode ser um computador caseiro, alguém pode desligar o PC e sair da rede. Por isso essas informações são redundantes entre vários nós. Os algoritmos de DHT e roteamento vão se balanceando e atualizando dinamicamente com nós entrando e nós saindo. 







Se isso pareceu similar a um banco de dados NoSQL distribuído como Amazon DynamoDB ou Cassandra, é porque é. Uns três ou quatro episódios atrás eu expliquei como funcionam chaves distribuídas, depois assistam. BitTorrent não deixa de ser um grande banco de dados NoSQL distribuído. São tecnologias similares. Toda vez que você abre um programa como Transmission ou QBitTorrent pra baixar alguma coisa, está participando dessa coordenação toda e se tornando um nó réplica de um grande banco de dados NoSQL distribuído. Você só não sabia disso.







Diferente de um banco de dados, eu não preciso que todos os dados que já foram gravados num DHT, permaneçam lá pra sempre. Arquivos novos aparecem, arquivos que ninguém mais quer desaparecem. Se não tem ninguém compartilhando algum determinado arquivo, não preciso ter informações dele trafegando. Seria ineficiente. Só interessa arquivos que alguém está compartilhando.






Num Git não, eu preciso que tudo que os desenvolvedores do projeto fizeram, seja adicionar novos arquivos, modificar existentes, ou até apagar, esteja devidamente registrado no log de commits do repositório, e que seja possível voltar pra qualquer momento no passado e ter tudo intacto, exatamente como era. Não pode ser parcial. Por outro lado, não pode ficar no caminho do desenvolvedor e adicionar obstáculos. Se o desenvolvedor achar que quer reescrever a história, precisa deixar.







A resiliência do Git aparece numa equipe, com mais de uma pessoa. Basta ter mais um desenvolvedor que tem como comparar os repositórios nas máquinas de cada um e ver que houve problemas. Basta checar os hashes dos commits. Se tiver 3 desenvolvedores já temos como fazer um tipo rudimentar de consenso: o que tiver o histórico mais diferente tá errado.







Eu só expliquei os conceitos bem básicos, tem bem mais detalhes por trás pra vocês pesquisarem depois. Árvores Merkle são úteis pra BitTorrent e pra Git, mas também são usados em outros lugares. O sistema de arquivos ZFS, que é usado no TrueNAS pra grandes servidores de armazenamento também usa árvores Merkle pra detectar corrupção de dados e ter a funcionalidade de snapshots com pouco overhead. 







Outras redes ponto a ponto como o IPFS, que é o InterPlanetary File System, um sistema de arquivos distribuídos global, usa árvores Merkle, mais especificamente Merkle DAGs como Git. Não só sistemas de arquivos, mas bancos de dados distribuídos como Cassandra ou Riak usam árvores de Merkle pra minimizar a quantidade de dados que precisam ser transmitidos pra sincronização de dados.







No começo do video eu mostrei a cadeia de certificados e como o certificado do meu domínio é assinado pela Letsencrypt que, por sua vez é assinado pela ISRG. O protocolo TLS usa uma variante de árvore de Merkle chamada Merkle Hash Tree, no framework de Certificado de Transparência pra fornecer um log auditável de certificados gerados. E essa característica é importante: qualquer coisa que precise ser auditável pode usar árvores Merkle pra oferecer "prova de inclusão", de forma que é possível provar que um pedaço de dados faz parte de um determinado conjunto, sem revelar o conjunto inteiro. 






E se você já parou pra estudar o básico de Bitcoin e outras criptomoedas, já deve ter se deparado com Árvores Merkle e Merkle Root. É o que está na raíz do bloco de transações da tal de blockchain. Um blockchain e um repositório Git ou a árvore de merkle de Bit Torrent são muito parecidos: eles garantem que não dá pra adulterar um bloco sozinho, sem precisar re-gerar todos os blocos à frente dele. Com um ingrediente a mais: o tal processo de mineração. Em Git, um rebase é uma operação razoavelmente rápida. 







Mas num blockchain de Bitcoin, o equivalente de rebase de Git custa absurdamente caro, astronomicamente caro na real, o que garante que é perto de impossível fazer um rebase. É isso que torna o blockchain interessante. Um blockchain onde é barato fazer rebase não é diferente de um Git e, como reserva de valor, não vale nada. Tudo que expliquei neste episódio são as tecnologias que estão na fundação do Bitcoin.








Se conseguiram chegar até aqui, nós vimos na prática como encriptação com chaves simétrica funciona. Aprendemos como funciona troca de chaves usando criptografia assimétrica. Vimos como quebrar arquivos e trafegar pedaços de uma forma que conseguimos checar se os pedaços vieram corretamente e vimos como BitTorrent e Git funcionam com árvores Merkle. Tudo em computação moderna usa esses conceitos, em particular certificados digitais TLS, bancos de dados NoSQL e até Bitcoin, por isso é importante estudarem tudo. Se ficaram com dúvida deixem nos comentários abaixo, se curitram o video mandem um joinha, assinem o canal e não deixem de compartilhar com seus amigos. A gente se vê, até mais!

