---
title: "[Akitando] #131 - Sua Segurança é uma DROGA | Gerenciadores de Senhas, 2FA,
  Encriptação"
date: '2022-11-08T10:20:00-03:00'
slug: akitando-131-sua-seguranca-e-uma-droga-gerenciadores-de-senhas-2fa-encriptacao
tags:
- segurança
- 2fa
- two-factor
- bitwarden
- authy
- veracrypt
- bcrypt
- pbkdf2
- sha512
- aes
- bitlocker
- filevault
- luks
- lastpass
- 1password
- kevin mitnick
- akitando
draft: false
---

{{< youtube id="s7ldn31OEFc" >}}

Você já deve ter consciência que não deveria estar usando a mesma senha pra tudo, nem senhas curtas, nem senhas fáceis, e não deveria estar recebendo código 2FA via SMS, e deveria ter habilitado encriptação nos seus HDs.

Mas por quê? Hoje quero demonstrar porque todas essas "boas práticas" que todo mundo tá careca de saber, e até hoje tem preguiça de colocar em prática, realmente significa. Vamos entender.

== Errata

3:57 - eu falo que o Mitnick não mostra o programa mas eu que não prestei atenção, é o bom e velho HASHCAT. Procurem no Google pra saber a respeito.

== Capítulos

* 00:00 - Intro
* 01:14 - Cap 01 - Pra que Senhas Fortes? Quebrando senhas
* 06:11 - Cap 02 - Como se Guarda Senhas no Banco de Dados? bcrypt vs sha512
* 09:41 - Cap 03 - Pra que Servem Gerenciadores de Senhas? Bitwarden
* 17:17 - Cap 04 - Como funciona Two-Factor Authentication? TOTP
* 22:32 - Cap 05 - Como se pega um Ransomware? Pirataria
* 31:49 - Cap 06 - Encripte seus Drives
* 33:59 - Cap 07 - Veracrypt: Segredo do Segredo
* 40:44 - Bloopers

== Links

* How Easy It Is To Crack Your Password, With Kevin Mitnick (https://www.youtube.com/watch?v=K-96JmC2AkE)
* Hashcat (https://hashcat.net/hashcat/)
* Bitwarden (https://bitwarden.com/)
* Host Your Own Open Source Password Manager (https://bitwarden.com/blog/host-your-own-open-source-password-manager/)
* Authy (https://authy.com/)
* Veracrypt (https://www.veracrypt.fr/en/Home.html)

## SCRIPT

Olá pessoal, Fabio Akita

Você é iniciante em programação ou já trabalha com tecnologia? Usa a mesma senha pra tudo? Anota senha num arquivo texto no seu dropbox? Baixa instaladores piratas de coisas como Photoshop ou cheats pros seus jogos? Recebe o código de autenticação two factor via SMS? Pois bem, hoje é o dia de saber porque você tá fazendo tudo errado e também porque.





Mais do que isso, qual a diferença de usar um SHA256 ou bcrypt pra gerar hash de senha pra gravar no banco? Como funciona o algoritmo de two factor? Que aplicativos devo usar de fato pra estar minimamente protegido? Finalmente vamos explorar um pouco mais sobre segurança pessoal e um pouco de como essas coisas funcionam por baixo dos panos. Então o episódio deve servir tanto pra programadores como pra quem só está preocupado em se proteger. E não importa o que faça, você nunca vai estar 100% protegido.






(...)





Meses atrás eu já tinha feito um video falando um pouco sobre hacking, consultorias de segurança e como esse mercado idiota de selo de segurança é uma grande porcaria. Depois assistam aquele video também. Mas hoje é sobre segurança profissional e não infosec.



A primeira coisa mais básica que todo mundo erra é a famosa recomendação de usar uma senha forte diferente pra cada site que tem conta. Senhas fortes é usar o máximo de caracteres diferentes possíveis, incluindo letras minúsculas e maiúsculas, números, caracteres especiais como cerquilha, asterisco, e ter um comprimento de no mínimo uns 12 caracteres. Ideal é preencher o campo de senha até o máximo que permite. Sites que até hoje limitam a senha a coisas ridículas como 8 ou 10 caracteres foram feitos por imbecis morônicos amadores que não entendem absolutamente nada de segurança.







Vamos entender de verdade porque isso é importante. Tem um video de 2018 de ninguém menos que Kevin Mitnick, um dos hackers mais famosos do mundo. Não porque é o melhor, só que virou celebridade na época em que foi preso. Nesse video ele começa demonstrando como uma pessoa normal poderia pensar em fazer uma senha que acha forte. Pra começar, vai num gerador de palavras aleatórias e escolhe uma que acha comprido, como "quadrilateral", que tem nada menos que 13 letras. Olha só, deve ser forte né?








Mas só isso não parece seguro. Vamos adicionar uns números e caracteres especiais no fim como "1", "2", asterisco e cifrão. Mas mesmo assim ainda não parece seguro. Uma coisa que todo mundo faz é converter palavras em leet codes. Leet code é trocar "A" pelo número 4 ou arroba, o "i" pelo número "1", "e" por "3" e assim por diante. E olha só, agora assim, parece uma senha forte, não parece? Uma senha de 17 caracteres misturando letras, números, caracteres especiais. 








A história hipotécia que ele conta é que conseguiu copiar o banco de dados de senhas do Windows de alguém. O Windows antigo não grava sua senha aberta, passa por um algoritmo de hash. Lembra o que é hashing? Eu explico isso no 1o video de criptografia. Assiste depois. É como uma impressão digital, não é encriptação. Ele passa essa senha por uma função que cospe uma string de tamanho fixo. Se fosse uma senha de 2 caracteres ou 100 caracteres, no final essa função cospe uma string com o mesmo tamanho fixo de 512 bits. Ou seja, pra saber se adivinhamos a senha, precisamos passar por essa mesma função e comparar o hash gerado com o hash que estava no banco de dados do Windows.









Todo desenvolvedor web já fez isso alguma vez na vida. Quando o usuário se cadastra no seu site e digita a senha no formulário, você passa por uma função de hashing como SHA512 da vida e grava o hash no banco, na esperança que se alguém um dia conseguir roubar seu banco de dados, pelo menos as senhas não vão estar facilmente visíveis. E agora quero mostrar porque só isso não ajuda em nada e tanto esse seu site quanto a autenticação antiga do Windows com NTLM são ruins.








O Mitnick usa um programa que não mostra qual é pra quebrar essa senha. Provavelmente usa uma mistura de rainbow tables, ataque de dicionário e processamento paralelo em GPUs pra gerar hashes e tentar quebrar na força bruta. Ele já tem o hash que quer achar, e a GPU vai gerando hashes a partir do dicionário e comparando pra ver se acha. Já vou explicar o que é cada uma dessas coisas, mas olhem no video. A máquina dele de 2018 tem nada menos que 8 GPUs GTX 1080 em paralelo. Lembrando que essas GPUs são 3 gerações defasadas, depois veio a RTX 2080, depois saiu a RTX 3080 que por acaso é a que eu tenho, e já foi lançada a nova RTX 4090.








E é isso, em menos de 1 minuto rodando, aquela nossa senha que parecia forte, foi quebrada. Nem 1 minuto. 17 caracteres, com números e letras especiais misturado. Só 1 minuto pra quebrar em 2018. Em 2022, com meia dúzia de RTX 3090 Ti rodando, essa senha pode ser quebrada em segundos. E agora? Tá lembrando a senha que você usa pra proteger seu email? Suas contas pessoais? Olha só, é a mesma senha pra tudo? E sua senha é mais curta e mais fraca que essa que eu mostrei? Nem sei pra que você se incomoda de colocar senha, deixa tudo aberto de uma vez, é a mesma coisa.









"Ahhh, mas ninguém nem sabe que eu existo." É verdade. Todo mundo pensa que ninguém vai se importar com você. Afinal você é insignificante, ninguém te segue nas redes sociais, ninguém vai tentar quebrar justamente suas contas. E é aí que você se engana. Todo ano dezenas de sites ao redor do mundo tem sua infraestrutura comprometida por diversos motivos. Por exemplo, em Janeiro de 2022, via uma conta de funcionário interno, vazou uma quantidade gigante de emails, números de telefone e muito mais. Você tem conta no Twitter? Provavelmente seu email agora está no banco de dados de gente que vai tentar quebrar contas.









Mas não é só isso. Existe um site chamado "Have I been Pwned" que documenta incidentes como esse do Twitter. São eventos grandes e de muita repercussão e no banco de dados deles, no momento que estou escrevendo este episódio, tem documentado a invasão de mais de 600 sites, mais de 11 bilhões de contas que vazaram. Sim, seu email e possivelmente o hash da sua senha, já vazaram e tem robôs nesse exato momento tentando entrar em uma de suas contas.








Antes de falar de como dificultar isso. Vamos entender um pouco mais por baixo dos panos pra você que é programador. Todo site bem feito nunca grava sua senha aberta. Sempre vai passar por um algoritmo de hashing. Mas não é qualquer algoritmo como MD5 ou SHA512. Não, ele vai usar um algoritmo de derivação de chaves, como bcrypt ou PBKDF2 ou o mais novo Argon2. Se você já usou um framework web como Rails ou Django, já deve ter visto esses nomes.








Qual a diferença de um algoritmo de hash como SHA512 e um algoritmo de derivação de chaves como bcrypt? É o tempo de execução. Um SHA512 foi desenhado pra ser eficiente e rápido. Ele é usado pra rapidamente conseguirmos gerar uma impressão digital de um PDF ou algo assim pra assinarmos digitalmente. É bom pra passarmos um arquivo que fizemos download como a ISO de uma distro Linux e checar com o SHA no site deles pra ver se o download veio perfeito. Mas justamente porque é eficiente, que ele não presta pra fazer hash de senhas. Bizarro isso né? Pensa: por que ser eficiente é ruim nesse caso?








Quando um hacker como um Mitnick roda o tal programa dele, precisa ir tentando diversas combinações de letras até achar a sua senha. E a cada tentativa ele precisa rodar pelo mesmo algoritmo de hash pra comparar com o hash que está no banco de dados que foi vazado. Se o algoritmo de hash for eficiente, é rápido gerar milhões ou até bilhões de hashes por segundo. Por isso usamos um bcrypt ou PBKDF2, porque não tem jeito de fazer esses algoritmos serem mais rápidos, faz parte do design deles serem lentos de rodar. Isso dificulta o trabalho de quebrar senhas. As GPUs dele vão executar bem mais lento, de bilhões de hashes por segundo com um SHA512 vai cair pra centenas de hashes de bcrypt. Estamos dificultando a vida do hacker, e isso sempre é bom.








Por isso, se você ver um SHA512 sendo usado pra hashear senhas, tá errado, tem que ser bcrypt ou PBKDF2. Eles são uma categoria diferente. Não são algoritmos de hash e sim de derivação de senhas. Como o nome diz, foram feitos pra pegar uma senha curta ou fraca e tentar derivar uma senha mais longa e mais forte. Além disso, esse é o motivo de porque todo sistema de autenticação minimamente seguro também faz uso de salts.








Salt é um número aleatório. Ele vai gravado aberto na tabela e o hash gerado não é só da senha, e sim da senha concatenado com esse salt. Digamos que duas pessoas no site usem a mesma senha "teste1234", que todo mundo usa. O hash dos dois acabaria sendo o mesmo. Portanto quando o hacker quebrar a senha de um, automaticamente tem acesso à conta dos outros usuários que tem a mesma senha. Mas se o salt for aleatório pra cada usuário, o hash dessa senha, concatenado com o salt, vai ser diferente. Agora dificultamos mais ainda pro hacker. Se ele conseguir quebrar a senha de um deles, não tem como saber que o outro também usa a mesma senha. Ele vai precisar repetir a força bruta pros dois, pra chegar na mesma senha.








Mas os hackers não são burros. Obviamente todo mundo sabe que um site bem feito vai usar bcrypt da vida. E sabe que ficar gerando hash de bcrypt é lento. Por isso eles colaboram pra gerar tabelas pré-computadas. Começa pegando um dicionário grande de palavras em inglês. E gera o bcrypt de todas e grava num banco de dados. Agora pega cada palavra e concatena com milhões de combinações diferentes de números e letras especiais, antes e depois. Daí também gera o bcrypt de todas as palavras convertidas em leet code. E assim por diante. 









Nas deep web da vida você não acha só o banco de dados vazado dos sites com Twitter ou Adobe. Também tem pra comprar esses bancos de dados de hashes pré-computados. É isso que chamamos de Rainbow Tables. Em vez de gastar tempo computando o bcrypt de tudo na mão, é mais fácil gastar gigabytes ou terabytes de espaço num banco de dados e cruzar com o hash do banco vazado. Comparar milhões de linhas de um banco de dados é super rápido hoje em dia. Em questão de minutos, a poucas horas, dá pra achar todo mundo que usou senhas fracas. Esses vão se foder primeiro. Portanto o hacker troca o trabalho de computar hashes pesadas pelo trabalho mais rápido de procura num banco de dados gigante de hashes pré-computadas.









A única forma de ficar minimamente seguro é usar senhas que não são facilmente deriváveis de palavras em dicionários. Por isso que toda vez falamos que você precisa usar senhas geradas aleatoriamente. Porque não vai ter em nenhum dicionário, o hacker vai ser obrigado a tentar achar via força bruta testando todas as combinações de todos os caracteres possíveis. O alfabeto tem 26 letras. Dobre isso porque tem maiúsculo e minúsculo. Temos 10 números. E temos pelo menos 30 caracteres especiais como asterisco ou parênteses. 









Isso dá um total de 26 mais 26 mais 10 mais 30 caracteres que são 92 possíveis letras. Se fizermos uma senha de 10 caracteres aleatórios, o hacker na pior das hipóteses vai precisar calcular hash pra 92 vezes 92 vezes 92 vezes 92 ... 10 vezes. Isso dá nada menos que 43 quintilhões de possibilidades. Se aumentar só um caractere pra 11, aumentamos as possibilidades mais 92 vezes e o número sobe pra 3 sextilhões. Cada caracter a mais dificulta 92 vezes. Quanto mais longa for a senha, mais fode a vida do hacker. 










Então vou repetir: nunca use senhas derivadas de palavras que existem. Todas as combinações que você imaginar de embaralhar um pouquinho, tipo colocar arroba no lugar do "a" ou exclamação no lugar do "i" ou "l", tudo isso já foi pré-computado e existe numa rainbow table. Sempre use senhas totalmente aleatórias. E sempre use senhas o mais longo quanto for possível. 50 caracteres, 80 caracteres. O máximo que o formulário de cadastro do site deixar. E sim, você não deve ser capaz de conseguir decorar essa senha, e esse é o objetivo. Se você consegue decorar, significa que a senha é fraca e facilmente quebrável.










Na pior da pior das hipóteses, todo navegador moderno como Firefox, Safari, Edge ou Chrome, tem já embutido um gerenciador de senhas. Não recomendo usar deles porque tem alternativas melhores, mas eu diria que se você for nesse nível de preguiçoso, pelo menos use do navegador. Único inconveniente é que vai precisar usar o mesmo navegador no seu PC de casa, no notebook e no smartphone, pra ter acesso às suas senhas, porque esses navegadores conseguem sincronizar o banco de dados via sua conta da Apple ou Google ou Microsoft da vida. Significa que pelo menos a versão encriptada dessas senhas pode estar armazenada nos servidores do Google ou Apple. Mas é um risco que vale a pena correr, muito menos risco do que usar a mesma senha fácil pra tudo.










O ideal é não ter esse banco de senhas, mesmo encriptado, no servidor de ninguém e por isso eu gosto do aplicativo Bitwarden. Ele é código-aberto, então você mesmo pode auditar o código se quiser. E tem a opção de você mesmo configurar um servidor pra manter seu próprio banco encriptado de senhas. Daí a extensão no seu navegador vai puxar tudo de um servidor que só você controla. Eu só recomendo fazer isso se você já for um devops avançado e experiente. Pra 99% das pessoas o melhor é confiar mesmo na hospedagem de algum serviço que vai ter segurança melhor do que a sua. Seja o próprio Bitwarden, 1password, Lastpass ou similares.








Olhem um exemplo de senha gerado pelo Bitwarden. É esse tipo de senha que você deve usar nos sites por aí. E como vai estar gravado e encriptado, não precisa se preocupar em decorar nada. Gere uma senha gigante e aleatória pra cada site. Entre em cada um dos sites que tem conta e altere sua senha hoje mesmo. Lembra que eu falei que vira e mexe algum site é hackeado e o banco de dados acaba na mão de algum hacker? Mesmo se ele conseguir quebrar sua senha desse site, ter senhas diferentes significa que mesmo que ele mande os robôs dele ficar tentando em dezenas de outros sites, essa senha não vai abrir nada pra ele, porque só é usado nesse um site. Quando você usa a mesma senha pra tudo, basta um site que você usa se ferrar que ele ganha acesso a todos os outros sites que você usa. Esse é o risco real e imediato.










A única senha que vai precisar decorar é a senha mestra que abre o banco encriptado desses aplicativos. Nesse caso, infelizmente, vai precisar decorar então não dá pra ser uma senha totalmente aleatória, então no mínimo use uma passphrase e não um password. Literalmente pense numa frase longa, de mais de 20 caracteres, no mínimo. Alguma coisa tipo "acomidaqueeumaisgostoémilho" ou "aviagemqueeumaisgosteifoiprojapao". Todos os bons aplicativos vão pedir essa senha da primeira vez pra sincronizar o banco encriptado de senhas e eles costumam ter opção pra habilitar autenticação via impressão digital, no caso de smartphones. Daí fica mais prático de usar.











"Akita, qual desses aplicativos é melhor?" Foda-se. Use qualquer um deles. Tem gente que morre se não for 1password. Tem gente que acha o LastPass feio. Tem gente que acha um Bitwarden mais ou menos. Tem gente que prefere mesmo usar o do próprio Google ou Microsoft no navegador. Tanto faz. O mais importante é a passphrase mestra e você hoje mesmo sair alterando a senha de todos, todos os sites que acessa, e cadastrar senhas super longas e aleatórias diferentes pra cada uma. 












A próxima recomendação é habilitar two factor authentication, o famoso 2FA ou autenticação de dois fatores. Que é aquele código que muda a cada 30 segundos e que recebe via SMS ou usa um aplicativo como Microsoft Authenticator ou Authy. Já de cara vou falar pra evitar o Google Authenticator. Sempre dá problema essa bosta, especialmente se você troca de celular e precisa instalar de novo. Use qualquer um, menos do Google. Aplicativos que gerenciam senhas como 1password ou o Bitwarden, já tem suporte a 2FA também, então pode usar tudo no mesmo aplicativo.









Outra coisa: eu não recomendo de jeito nenhum receber esse código por SMS. Celulares podem ser roubados. E não importa se seu celular tem senha. Basta tirar o SIM card e colocar em outro celular. Ou posso usar engenharia social. Ligar na Vivo ou Claro e enganar o atendente. Um hacker bom de engenharia social já tem seus dados, seu nome, RG, CPF, email, nome da mãe e tudo mais. Não são informações difíceis de achar dado que diversos sites do governo já foram hackeados e bancos de dados com todas essas informações já vazaram. Todo hacker já sabe seus dados.








Conseguir roubar seu número de celular é questão de tempo. Fora o inconveniente se você realmente perder o celular. E agora? Como você faz login nos sites que vão pedir código de dois fatores? Vai te mandar por SMS pro celular que você perdeu ou foi roubado. Até conseguir outro SIM card, vai ficar uns dias sem conseguir acessar suas coisas. Um puta pé no saco. E como Murphy sempre é eficiente nessas horas, vai ser justo num domingo de feriado prolongado e bem num dia que você precisava acessar um site importante no meio de uma viagem. 








Por que, lógico, durante essa viagem você encheu a cara na balada e só percebeu que tava sem celular quando voltou pro hotel. É assim que você se ferra à toa. E nem precisa de muito. Basta estar num lugar com sinal fraco de celular ou sem sinal. Ou estar viajando sem roaming. Como vai receber SMS sem sinal? 







O que é esse tal de two-factor? É uma função que recebe pelo menos dois parâmetros, um segredo compartilhado e uma hora do sistema e gera um código. O padrão mais conhecido é o TOTP ou Time-based One-Time Password, ou literalmente senha descartável baseada em tempo, que é definida na RFC 6238. O que acontece é o seguinte, digamos que você entre num site novo e vai cadastrar sua conta. Preenche tudo, coloca sua senha e manda habilitar two factor.








O site te dá um QR Code, que tem um código que chamamos de seed ou semente, esse é o segredo compartilhado entre o servidor e nosso app. Se estiver num app como o Bitwarden, vai ter um campo chamado Authenticator Key (TOTP) que é onde se copia e cola o seed, que costuma estar embaixo do QR Code. Ou se estiver num app separado como o Authy, pode abrir a câmera dele e ler o QR Code. Além do seed, nesse QR Code vai ter informações extras pra facilitar o cadastro como o nome do site, URL e tals. 







E pronto. O site vai pedir pra confirmar se tudo correu bem, e pra isso é só digitar o código que o app mostra. Ele vai checar e confirmar. Agora, toda vez que fizer um novo login, depois da checagem de senha,  vai pedir o código de two factor. Só abrir o app, e digitar o código dentro da janela de tempo que ele indica. 






O que acontece é o seguinte, depois do cadastro via QR Code, o servidor tem um segredo gravado e seu app tem esse segredo também gravado no app, ambos encriptados. Quando você abre o app, ele pega o horário atual, arredondado em períodos de 30 ou 60 segundos, por isso tem o timerzinho toda vez. O código que aparece é derivado de passar o segredo que é o seed mais o horário atual e gerar um hash baseado num algoritmo como HMAC-SHA1. Ele trunca o resultado em 6 dígitos e é isso que você vê no app.








Quando digita o código e manda pro servidor, lá vai fazer a mesma coisa, pegar o segredo, o horário no servidor, e gerar o mesmo código via HMAC-SHA1. Se o código bater com o que você digitou, significa que é você mesmo. Se não bater, pode ser que justo passou o período de 30 ou 60 segundos e vai pedir pra digitar de novo. A vantagem de uma senha secundária dessas é que mesmo que alguém veja esse código, ele só tem validade dentro de uma janela de menos de 1 minuto. Parece pouco tempo, mas na realidade é bastante, já falo sobre isso. De qualquer forma, como é baseado no horário, por isso é importante seu celular ter horário sincronizado com um servidor de NTP. Quando você tem problemas, primeira coisa é checar isso.








Na prática parece um troço complicado. Já tem que ter senha complicada, agora depois de digitar a senha ainda tem esse troço que dá gatilho na minha ansiedade com esse timer maldito mandando digitar rápido. Não é a toa que muita gente mais sensível ou mais preguiçosa realmente não quer ter que lidar com isso. Mas esse é o preço que se paga pela internet ter ficado popular.









Vamos resumir o que falamos até agora: instale um aplicativo de gerenciador de senhas que, de preferência, também tenha suporte a two factor authentication. Minhas escolha pessoal é o Bitwarden, mas é mais por costume. Garanta que a senha mestra é uma frase longa e que realmente só você saiba. Não anote num post-it embaixo do seu teclado. E a partir daí crie senhas hiper longas e aleatórias e habilite two factor em todas as suas contas. Com isso, mesmo se outro site que você tenha conta for invadido e alguém conseguir fazer força bruta pra quebrar sua senha, na pior das hipóteses não vai conseguir usar essa senha em nenhum outro site que você tenha conta, porque são todas com senhas diferentes.









A gente fala two factor ou autenticação de dois fatores, porque em segurança se fala em ter no mínimo 3 fatores de segurança. O mais simples é o alguma coisa que você sabe, que é sua senha. O segundo fator é alguma coisa que você tem, que pode ser seu aplicativo de two factor como o Authy ou o equivalente em hardware disso que seria algo com um Yubikey. Eu nem vou falar de Yubikey hoje, mas teoricamente ele é melhor do que só um app de two factor. Problema que nem tudo suporta hardware keys e a usabilidade não é exatamente a mais simples. Mas vale a pena dar uma pesquisada se tiver interesse.








O terceiro fator é alguma coisa que você é. No caso costumamos nos referir à biometria, como sua face num iPhone ou com Windows Hello, ou o mais comum que é impressão digital. Hoje em dia isso é mais comum em smartphones e muitos notebooks. Antigamente eram muito mau feitos, mas acho que hoje em dia a maioria das implementações é segura o suficiente. Em smartphones como iPhone, sua impressão digital não fica armazenada no mesmo lugar que seus dados e aplicativos. Ele fica numa memória separada que o sistema operacional não tem acesso e controlado por um chip independente da sua CPU. 








Isso é o que chamamos de Secure Enclave, que num iPhone é o chip T2, num PC é o chip de TPM ou Trusted Platform Module, que o Windows 11 quis tentar ser obrigatório e deu treta e acho que voltaram atrás. Mas o correto é mesmo ter um TPM no seu sistema, um chip e memória encriptada que mesmo que seu computador seja comprometido por malwares, esse chip continuaria intacto.







E falando em malwares, agora vem a parte mais problemática: evite ao máximo pegar virus e malwares. Parece meio óbvio, mas todo mundo a essa altura já pegou um malware. Se você baixou pirataria recentemente, como photoshop, com certeza já tem malware instalado. Filmes e música tem baixa probabilidade de ter. Só se alguém descobriu um bug nas bibliotecas que fazem decoding de filmes e consegue injetar malware via algum tipo de buffer overflow da vida. Antigamente tinha em imagens, não lembro se era PNG. Mas esses componentes costumam ser bem maduros e não mudam mais, então as chances são baixas.







O problema são executáveis mesmo. Instaladores de Photoshop por exemplo, esses são campeões de carregar coisas como Ransomwares. Se você tem Photoshop instalado, eu faria backup de todos os seus dados importantes num HD externo hoje, logo depois de terminar de assistir, porque provavelmente tem um ransomware encriptando seus arquivos aos poucos em background e você nem tá sabendo. 







Povo que é gamer e baixa cheats e trainers pra games, muito provavelmente vocês estão infectados também. Você acha que seu computador tá ficando lento porque tem muitos games. Mas na realidade é porque tem virus e malware rodando aí já. E não adianta baixar um antivirus e tentar rodar. Muitos virus conseguem se esconder de antivirus. Uma vez infectado já é meio tarde.








Se quiser pelo menos checar, tem vários antivirus que tem opção de queimar num pendrive e bootar direto dele. Assim o antivirus roda antes do seu Windows bootar, aí o virus não tem chance de se esconder. Acho que marcas como Kaspersky, Comodo, ESET, Avira e outros tem essa opção. Vá num computador que tem mais certeza que tá limpo, baixe a ISO. Num Windows, use um programa como o Rufus e grave a imagem num pendrive. E agora boote pelo pendrive e mande escanear seu computador. Mas lembre-se, só porque o antivirus não achou nada, não quer dizer que você tá limpo. 









A regra é simples: não baixe pirataria. Eu sei, você quer jogar de graça. Mas não rola. Pelo menos tenha um PC numa rede isolada que usa só pra jogar e nunca pra acessar coisas como seu banco, no mesmo computador. Se você instala games piratas baixado em bittorrent ou de sites como mega da vida, as chances de já estar contaminado são enormes. Nem tô brincando, serião. Em particular se você roda Windows.








Quem joga em Linux, usando um ambiente isolado de emulação como Wine com Proton, tem menos chances de ter problemas, porque um virus feito pra Windows não vai infectar um Linux ou um Mac. Virus é específico pro sistema operacional que quer contaminar. Problema de jogar em Linux é que muitos jogos não permitem jogar online em ambiente emulado porque eles não conseguem carregar os programas de anti-cheat. Depende do jogo, acho que um Overwatch da vida já dá pra jogar, mas Fortnite parece que ainda não. Se for como eu que só joga single player, aí Proton já é bem mais útil.









O tipo de malware que ficou mais famoso são os ransomware. Eles ficam trabalhando escondidos no seu PC sem você perceber. Vão encriptando seus arquivos um a um. E quando você percebe que tem algo de errado, a maioria dos seus arquivos tão lá ainda mas encriptados. Daí aparece a famosa janela de resgate, onde falam que tem a chave pra desencriptar, mas só vai te dar se mandar uma certa quantia de bitcoins pra eles. Tem garantia que eles vão te dar a chave? Não. Tem como recuperar os dados depois que foram encriptados. Não. Você se fodeu. Só aceita que dói menos, e você foi avisado, se arriscou porque quis.










A única forma de garantia que você tem caso seus arquivos sejam encriptados por um ransomware é ter backup. E tomar cuidado pra ter várias semanas de backups, porque quando o ransomware começou a criptografar seus arquivos, você pode estar fazendo backup dos arquivos já criptografados. Então precisa garantir que tem versões antigas dos arquivos, de antes do ransomware ter começado a te foder. Por isso eu vim falando do meu NAS e como sistemas de arquivos com suporte a snapshot como btrfs ou ZFS fazem a diferença nesses dados. Eu tenho snapshots de várias semanas e meses no meu backup, então mesmo que um ransomware apareça no meu PC, consigo recuperar praticamente tudo sem pagar nada.











Se você usa Linux, recomendo usar o btrfs e o programa Timeshift pra configurar tudo. Não é tema do video de hoje, mas snapshots são leves, ocupam pouco espaço, e você pode recuperar arquivos que foram apagados meses atrás se configurar direito, e é nativo do sistema operacional. Se usa Windows, precisa ter um backup que suporte um sistema de snapshots, mesmo que seja online. Serviços como o BlackBlaze. Dêem uma olhada. Backup em cloud é melhor que backup nenhum. A desvantagem é que depende da sua conexão de internet. Se perder tudo e precisar recuperar, vai demorar horas ou dias pra baixar tudo de volta via internet. Por isso o melhor é backup físico local, tipo HDs externos ou um NAS de verdade.









Na prática, não instale jogos nem programas piratas. Você vai pegar malwares. Se precisar muito rodar um programa pirata, abra uma máquina virtual, seja o VirtualBox, ou se for pra rodar só uma vez, use o Windows Sandbox, que vem no próprio Windows. Se não sabia disso, basta abrir o programa de ligar funcionalidades opcionais, ticar aqui em Windows Sandbox e deixar ele se instalar e reiniciar. E pronto, olha só, eu abro o Sandbox e é um Windows vazio numa máquina virtual. Quando fechar essa janela, tudo que tem dentro é apagado. Perfeito pra rodar programas estranhos sem riscos pro seu Windows principal.









Pra rodar máquina virtual seu PC precisa ser mais forte que a média. Nada abaixo de 16 giga de RAM. E quanto mais cores tiver sua CPU, melhor, de preferência uma CPU com 8 cores ou mais. Meu PC é um Ryzen 9 5950X com 64 giga de RAM. Isso já é demais pra maioria das pessoas, você não precisa de tudo isso. Eu gosto de brincar com máquinas virtuais porque posso fazer experimentos destrutivos e se eu quebrar a máquina, basta voltar o último snapshot dele que funcionava. Pra testar coisas, estudar sobre redes, estudar sobre vulnerabilidades e segurança, é a melhor coisa.









Falando em Windows, muita gente ignora isso mas depois dos tempos sombrios de Windows XP, que era totalmente furado, o Windows 10 e 11 até que são bonzinhos em segurança. Se seu PC não for muito antigo, configure sua BIOS pra habilitar duas coisas: o TPM que falei antes e o Secure Boot. Secure Boot em particular é bem importante. Se algum malware tentar se injetar em arquivos importantes pro boot do Windows, a própria BIOS vai detectar e impedir o boot. Uma das formas de um virus se esconder de um antivirus é justamente se injetar na kernel ou em drivers e se carregar no boot, daí ele consegue se esconder dos antivirus.








Vale a pena fuçar o aplicativo de Security do Windows. Mas não desligue nada nele. Tem muito tutorial bosta que fala pra desligar coisas como o Defender. Sim, o Defender custa recursos e em máquinas fraquinhas pode deixar um pouco mais lento, mas não, não compensa o risco de desligar segurança. Se tem máquina fraca, o melhor é desistir de Windows e migrar pra Linux se puder. Ou fazer upgrade de hardware, como instalar um SSD caso não tenha.








Um dos grandes problemas do Windows são drivers. Hoje em dia muitos drivers já vem pelo Windows Update e esses teoricamente são checados e são seguros. Mas muito hardware de fabricante bosta ainda manda você baixar driver do site deles, isso quando tem. E quando procura no Google tem sites falsos com esses drivers modificados. Aí você baixa achando que é legítimo e instala um malware. Aliás, nunca baixe nenhum desses programas que prometem atualizar seus drivers automaticamente pra você e também otimizar a performance do seu PC. Muitos são malwares, a maioria é só fearware, software que fica dizendo "olha só, achei problemas na sua máquina, me paga que eu conserto". É golpe. Não existe isso. 










Não tem performance de graça, mesmo otimizando manualmente, você não vai notar tanta diferença assim de verdade. É tudo fraude. A performance que você tem logo que instala o Windows do zero é tudo que vai ter. Se quiser um pouco mais, de novo, instale Linux e mesmo assim não vai ser nada revolucionário. Trabalhe, economize e compre SSD, mais RAM ou um PC novo.








Por último, se tiver notebook, pense em investir num programa de VPN. Seja ExpressVPN ou NordVPN ou SurfShark ou qualquer um desses. Especialmente se usa muito redes públicas como Wifi em cafés, hotel, ou qualquer lugar fora da sua casa. Eu já expliquei nos episódios de rede como é possível ficar escutando seu tráfego. Além disso também é possível fazer "DNS poisoning" que é literalmente envenenar o DNS. Lembra como seu computador acha o endereço IP das coisas perguntando pro DNS? E se o DNS ou DHCP que o Wifi público que você se conectou estiver contaminado? 








Você pode tentar baixar um programa qualquer e na realidade o DNS envenenado te redirecionou pra um site falso, tipo pra baixar a porcaria do programa de banco de um Itaú da vida. Aí você baixa um instalador falso que vai te contaminar com um malware. Todo cuidado é pouco. Não baixe nada a partir de redes que você não confia, como redes públicas. Sempre use uma VPN pelo menos pra garantir. Em alguns países do mundo como uma China ou no Oriente Médio, seu tráfego pode realmente estar sendo monitorado por agências do governo.








E falando em viagens, a última coisa que você precisa fazer se tem notebook é habilitar encriptação do seu HD. No Windows isso se chama BitLocker, em Macs se chama FileVault e em Linux se chama LUKS. Não importa qual sistema operacional usa, habilite encriptação. Eu não sei se não é óbvio, mas vou dizer o óbvio: aquela senha que você usa pra se logar na sua conta, não protege nada. 







Se eu roubar seu notebook, posso tirar o SSD, NVME e plugar em outro computador e vou ter acesso a 100% dos seus dados. Simples assim. Ah sim, você é aquele animal que guarda senha num arquivo de texto no desktop do seu computador? Se eu tiver acesso ao seu computador, vou ler tudo. Macs são mais convenientes ainda. Você pode bootar ele em Target Disk Mode e ele literalmente vira um HD externo USB gigante. Basta eu conectar via USB em outro computador e vou enxergar como se fosse um pendrive gigante. Se não sabia disso, reinicie e deixe apertado a tecla T antes do boot.









Eu já tive um macbook roubado. Bobeei uma vez a noite, numa rua escura, com as janelas abertas e minha mochila no banco de passageiro. Motoqueiro parou do meu lado, apontou uma arma e mandou eu dar a mochila. E lá se foi meu Macbook. Minha única consolação é que tava tudo encriptado, então ninguém ia poder ver nenhum arquivo. E por sorte eu tava com Find my Mac ativado. Isso é uma grande vantagem de Macs e iPhones, que tem isso por padrão. Semanas depois alguém ligou esse Macbook e eu consegui achar ele online e mandei comando de apagar tudo remotamente. Se você tem produtos Apple, ative o Find my Mac e Find my iPhone. 









Eu sou tão paranóico com essas coisas que mesmo HDs velhos, eu nunca jogo fora. Mesmo a maioria deles estando encriptado. Até pra destruir HDs você precisa fazer direito, porque um bom investigador forense tem técnicas pra recuperar dados de HDs em condições que você não acredita. Se for jogar um HD fora, pegue pregos, martelo e fure todos os discos. E mesmo usando partição encriptada eu ainda crio discos virtuais encriptados dentro usando um programa que uso faz anos, o Veracrypt.








Pra quem não conhece, o Veracrypt é o antigo TrueCrypt. Ele serve pra criar os discos virtuais mais seguros do mundo. Mesmo partição encriptada, com algum trabalho e força bruta, dá pra quebrar. Isso porque eles usam o mesmo algoritmo toda vez e é conhecido. Já no Veracrypt você pode escolher dentre uma gama de algoritmos, e criar uma partição escondida separada dentro do disco virtual encriptado, então ele teria uma partição falsa que você pode abrir caso esteja com alguém com uma arma na sua cabeça, e uma segunda partição no mesmo arquivo escondido que ninguém vai saber. Sério, dá uma estudada em Veracrypt, é animal e funciona em todo sistema operacional. Arquivos mais confidenciais, eu sempre deixo em discos criptografados por Veracrypt, porque a chance de ser quebrado é muito perto de zero. 








So de curiosidade, deixa eu criar um disco virtual com Veracrypt. Aqui na opção de Volume Type posso escolher Hidden volume, ou volume escondido. Seguindo, agora eu posso escolher o algoritmo de encriptação. Pra ser veloz, o certo é escolher AES porque hoje em dia toda CPU acelera encriptação AES em hardware. Mas pra ser seguro, performance não é importante. Eu posso escolher qualquer outro, como esse kuznichik ou sei lá como pronuncia. E o algoritmo de hash vai ser o streebog. Vou criar um volume de 50 mega só pra demonstração aqui.







Agora eu coloco, lógico, uma senha super longa e super complicada como já expliquei antes, um passphrase gigante. Como é um disco virtual, posso escolher que sistema de arquivos quero que seja formatado dentro. Se quiser compatibilide com múltiplos sistemas operacionais, posso formatar em FAT já que o volume é pequeno ou exFAT. Só pra Windows posso escolher NTFS. Se for pra Linux posso escolher ext4. Vou escolher FAT mesmo.







Nesse outro passo ele captura o movimento do meu mouse pra gerar um número aleatório seguro. Em vez de usar um gerador pseudo aleatório como o dispositivo /dev/random que tem no Linux, eu como ser humano me mexendo, vou gerar posições aleatórias de verdade, e ele vai usar isso internamente pra criptografia dele.






Agora vem o truque. Ele terminou de criar o volume, formatar como ext4 e montar como drive. Lembram quando expliquei sobre imagens, drives virtuais e pontos de montagem no video de Slackware? Revejam se não lembram. Olha só, ele montou como "/mnt/veracrypt1". É como se fosse um pendrive virtual. Mas essa é a partição falsa. Aqui eu vou gravar arquivos quaisquer que não são secretos de verdade. Por exemplo, vou arrastar uma imagem aqui dentro.







Pronto, ele fechou aquela partição e agora vai abrir outra, a de verdade que é a escondida. De novo, posso escolher outros algoritmos de encriptação pra essa partição, que vai ser protegida com outra senha. Pra simplificar, vou manter as mesmas escolhas de antes. Ele pede pra escolher o tamanho, eu tinha escolhido 50 antes, gravei uma imagem dentro, e agora posso escolher o resto do tamanho pra essa nova partição. Vou escolher tipo 20 mega só. Pra ainda ter espaço sobrando na partição falsa de antes e não ficar muito óbvio que tem uma partição escondida. Pronto, mesma coisa, ele vai formatar e no final eu posso montar.







Vamos montar a partição escondida e criar um arquivo secreto onde eu escreveria segredos altamente confidenciais. Pronto, montou. Navego até o ponto de montagem e olha só, tá vazio. Vamos criar o arquivo "segredo.txt", abrimos e vou escrever um texto super secreto. Pronto. Tá salvo. Volto pro Veracrypt e posso desmontar.





Por que eu fiz tudo isso. Digamos que algum malfeitor me pegou de refém e ele sabe que eu tenho segredos nesse arquivo. E ele vai cortar meus dedos se eu ficar falando que esqueci a senha. Então não tem jeito. Vamos montar a imagem, mas vou usar a primeira senha e não a segunda. Olha só o que vai acontecer. Montou, vamos navegar lá. Lembra que na primeira partição eu tinha só gravado uma imagem? É isso que abriu. O malfeitor não sabe que existe uma segunda partição. Mas como eu abri essa, ele não tem porque duvidar de mim. Eu dei a senha pra ele, só não a que ele queria. Nosso segredo está salvo na partição escondida. Sacaram o poder do Veracrypt?








Pra finalizar, quando estava terminando este script alguém me mandou uma DM no Insta com um site no mínimo curioso. Olha só isso. Eu esqueci de gravar a imagem original mas postei esta story no insta no mesmo segundo. Admirem a beleza desse site só por um segundo. É o símbolo de que tudo que eu disse até agora não serve pra absolutamente nada. Porque no final do dia, um monte de gente realmente vai digitar os dados do próprio cartão num site estranho, por livre e espontânea vontade. Os hackers não precisam fazer nada muito avançado. As pessoas deixam as portas de casa abertas elas mesmas. Esse tipo de golpe não só funciona, como funciona muito bem. Não seja um otário.







Não importa as proteções que você tem se você é um otário que sai clicando em tudo que te mandam. Eu fiz um teste outro dia com um tweet de gemidão. Centenas de pessoas caíram e saíram xingando. Foi um dos tweets com mais acesso que eu tive. Todo mundo clica nas coisas. É impressionante. Eu nunca clico em nada. Na verdade, se vem algum email ou mensagem com link, eu imediatamente bloqueio. Nem quero saber quem é. Não tem botão que eu uso mais em rede social que de bloqueio e botão de spam no Gmail. 







Olha alguns exemplos de emails que tá no meu spam. Eu não clico em nenhum link. Se eu não sei quem é a pessoa, ela nem devia estar me mandando mensagem. "Ah, mas pode ser importante". Eu sempre parto do princípio que se for importante mesmo, essa mesma pessoa vai achar outras formas de entrar em contato comigo. Vai me ligar. Mas se ela acha que eu vou clicar num link, tá muito enganada. O tipo de golpe que de longe é o mais aplicado e de maior sucesso se chama phishing, que é ficar bombardeando as pessoas com mensagens aleatórias assim até que algum idiota clica no link. Vem via email, whatsapp, sms e muito mais. Regra de ouro: JAMAIS CLIQUE EM NENHUM LINK, JAMAIS, ZERO.






E é isso aí. Hoje eu dei uma pincelada rápida por vários conceitos e várias ferramentas simples. São coisas que eu realmente uso no meu dia a dia e venho usando faz anos em Windows, Mac e Linux. Recomendo que todo mundo, seja programador ou não, se interesse por esse assunto, porque no final do dia você só pode contar com você mesmo. Ninguém vai te dar segurança, você precisa criar sua própria segurança, e isso começa com as coisas mais básicas, seu próprio celular, seu próprio computador. Não se preocupar com essas coisas é que nem fazer sexo sem proteção. Uma hora vai dar merda, e quando der não tem mais como voltar atrás. Se ficaram com dúvidas, mandem nos comentários abaixo. Se curtiram o video deixem um joinha, assinem o canal e compartilhem o video com seus amigos. A gente se vê, até mais!
