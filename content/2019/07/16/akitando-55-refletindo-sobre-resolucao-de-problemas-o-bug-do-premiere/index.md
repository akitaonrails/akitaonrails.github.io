---
title: "[Akitando] #55 - Refletindo sobre RESOLUÇÃO de Problemas | O bug do Premiere"
date: '2019-07-16T17:00:00-03:00'
slug: akitando-55-refletindo-sobre-resolucao-de-problemas-o-bug-do-premiere
tags:
- Adobe
- Adobe Premiere
- Final Cut
- Da Vinci Resolve
- Problemas
- Resolução
- Processo Investigativo
- Método Socrático
- Sócrates
- Sherlock
- akitando
draft: false
---

{{< youtube id="3W6xc4Yh2P0" >}}


No episódio sobre Ubuntu pra Devs da semana passada, quem me acompanhou pelas redes sociais (que é @akitaonrails em todas) viu que eu passei por um perrengue pra conseguir editar o vídeo e isso me custou uns 2 dias de atraso. Por isso o vídeo foi entregue só na sexta-feira e eu dormi mal duas noites.

Neste vídeo quero falar duas coisas. A primeira é explicar o que aconteceu e como eu resolvi o problema, pra quem tem interesse em edição de vídeo aprender também.

A segunda coisa é usar esse episódio pra refletir sobre como eu penso sobre resolução de problemas de modo mais amplo, sobre o processo investigativo e sobre a avaliação das minhas próprias capacidades, e como vocês também podem usar os mesmos conceitos quando encararem problemas difíceis e inesperados.

Se você me mandou mensagens no Insta, talvez veja sua mensagem no video hoje :-) Vou agrupar as sugestões em categorias e explicar porque elas não funcionam. Mas calma, não vou criticar não! 


== Links

* Screencasts Liberados Gratuitamente! (https://www.akitaonrails.com/2012/04/09/screencasts-liberados-gratuitamente)
* Iniciando com Git (https://www.youtube.com/watch?v=jdinE9SkUnE&list=PLevVxVF0KI-DZM6IyBXop7FV6nJeC90hd)
* From the Macbook Pro to the Dell XPS. Arch Linux for Creative Pro Users (https://www.akitaonrails.com/2017/01/31/from-the-macbook-pro-to-the-dell-xps-arch-linux-for-creative-pro-users)

== Videos antigos (em private)

* Rubyconf 2014 Website Teaser (https://youtu.be/yhqDBekgISU)
* Speakers Rubyconf 2014 Teaser (https://youtu.be/g8mpq30qlAI)
* Rubyconf Brasil 2014 - Teaser Trailer (https://youtu.be/vzYEsj1Ze4A)

* AMV - Rurouni Kenshin - Sanbum - capturado de VHS (https://youtu.be/EzidwCO-L2I)
* Mesmo AMV só que reeditado com clips um pouco melhores (https://youtu.be/PCrg29XEA1c)

=== Script


Olá pessoal, Fabio Akita

O último vídeo sobre ambiente dev em Ubuntu deu bastante trabalho pra fazer e parece que vocês gostaram! Em dois dias ele já ultrapassou os views do vídeo anterior. E isso porque o diabo tem uma hora e vinte minutos! Esse vídeo foi bem sofrido de fazer e me custou aproximadamente umas 40 horas de trabalho.

Eu tive um problema técnico que me fez quase varar 2 noites e atrasou o lançamento em quase 2 dias, por isso acabei lançando só sexta feira passada. Meio que sem pensar eu fui compartilhando o que estava acontecendo nas stories do meu Instagram e Facebook, então quem me segue nas redes sociais viu acontecendo em tempo real. Aliás, se vocês ainda não me seguem, agora é uma boa hora pra fazer isso!

Como curiosidade de bastidores eu fiquei com vontade de explicar o que aconteceu e como eu resolvi o problema, se por acaso vocês tenham interesse de como funciona um Adobe Premiere, mas em paralelo eu pensei no video de hoje por causa dos comentários que alguns de vocês me mandaram em privado. Como esse vídeo é dividido meio que em duas partes, se a parte mais técnica de edição de vídeo não interessa tanto, pulem pra este tempo aqui embaixo pra ir direto pra segunda parte.

Alguns me deram boas dicas, outros mandaram sugestões enlatadas kkk Eu sei que alguns foi piada pra quebrar o gelo e nenhum foi com má intenção. Porém achei um bom gancho pra um tipo de recomendação que se vocês ainda não ouviram, vão ouvir centenas de vezes durante toda a carreira de vocês. E em como você organiza um pouco a resolução de problemas técnicos, que vai ser válido se você for programador também.


(...)





Então, o que diabos aconteceu? Como background, eu comecei o canal em Agosto de 2018, este é o episódio 55 então eu já editei mais de 50 vídeos em 1 ano. Mas essa não é a primeira vez que eu edito vídeos. Eu já editava videos de forma ainda mais amadora no passado. Em 2010 eu experimentei com a ideia de tentar vender cursos em video, eu fiz uns 3 videos que divulguei pelo meu blog, eu acho que cobrei R$ 10 reais? Não lembro. 



Foram os videos ensinando Git, outro ensinando Vim e uma palestra. Porém, o volume de compra foi tão baixo que ficou claro que eu não ia ganhar a vida vendendo video, então eu liberei os videos gratuitamente logo depois. Vou deixar os links nas descrições abaixo caso alguém tenha interesse em ver video velho. Apesar de não terem viralizado nem nada, até hoje eu ainda encontro pessoas que falam que aprenderam Git por esse video. Não lembro se foi o de Git ou de Vim mas um deles tinha umas 3 horas de duração. Se por acaso você aprendeu Git ou Vim por esses vídeos mandem nos comentários abaixo!



Antes disso, vira e mexe eu brincava de fazer curtas. Por exemplo, quando eu organizava a Rubyconf Brasil eu fiz alguns videos pra divulgação. No fundo era mais uma desculpa pra eu brincar com isso. Eu gosto de fazer essas coisas faz anos. A primeira vez que vi edição de video foi quando amigos meus faziam AMV ou Anime Music Video no fim dos anos 90 usando dois VCR, sim VHS mesmo. Fitas de video tinham duas trilhas, uma de video e outra de audio e era possível em alguns gravadores de video mais caros gravar as trilhas separadamente, então dava pra colocar um VHS no primeiro player, gravar o trecho de video no segundo e ir concatenando os pedaços de video um atrás do outro e no fim adicionar o audio de uma vez na trilha separada. Aliás, de curiosidade eu disse que eu comecei este canal em Agosto de 2018 mas se você olhar no About do canal vai ver que ele está aberto desde Junho de 2007. Eu devia ter aberto um segundo canal, mas eu só escondi os videos aleatorios que eu subia aqui pra começar a subir os do Akitando. Os links do music video e videos de Rubyconf que eu mencionei ficavam aqui e vou manter privado pra não poluir o canal mas vou deixar os links nas descrições se alguém tiver curiosidade de ver.





Eu mesmo cheguei a conseguir um capturador de video pra PC que eu ligava o VCR e fiz meu primeiro AMV numa das primeiras versões do Adobe Premiere lá por 2000 ou algo assim. E desde então eu sempre me interessei por isso no nível de hobby, eu nunca cheguei a tentar ganhar a vida com isso. Edição de video digital segue o mesmo principio até hoje. Numa fita você podia ter 2 trilhas, uma trilha de video e outra de audio. É a mesma coisa digitalmente, mas você pode editar em múltiplas trilhas pra ser compilado em uma no final. As coisas avançaram bastaram nos últimos 20 anos. Codecs foi uma delas. Eu queria fazer um video falando só de Codecs de audio e video, mas só de pensar que ia virar um video de 3 horas eu desisto kk Um dia, um dia …




Enfim, eu ainda vou fazer um video só sobre os bastidores do canal, mas eu posso dizer que a parte de editar os videos é a que menos dá trabalho. Normalmente eu levo uma média de 5 a 6 horas entre começar a editar, exportar, fazer upload, colocar os cards e fazer thumbnail. Em videos mais simples que não tem tanta imagem pra procurar e colocar eu demoro menos. Ultimamente eu gravo o video domingo ou segunda, daí chego em casa terça e começo a editar lá pelas 19h e até 1h ou no máximo 2h terminei tudo. Agora, o video da semana passada de Linux, só a parte de edição deve ter levado mais de 20 horas!




O sintoma foi assim: eu comecei a editar normalmente como sempre faço. A diferença desta vez é que tinha um video mais longo, de 3 horas, que foi a parte que eu capturei com o programa OBS. São todas as cenas do Ubuntu, que eu gravei da minha tela seguindo o script. As partes onde eu apareço e o audio que acompanha as telas eu já tinha gravado antes. Eu vou recortando e editando de acordo com o script. A gravação da tela ficou com 3 horas porque tem muita parte do apt install e compilação das linguagens que é basicamente ficar esperando até terminar. Se vocês assistiram o video devem ter visto que eu acelerei bastante essas partes pra vocês não ficarem esperando.




Então eu fui cortando, sincronizando o audio com a gravação da tela. Aos poucos eu notei que o preview ia ficando um pouco lento pra iniciar, tipo um lag. Mas fui indo mesmo assim e chegou uma hora quando eu tinha editado uns 50 minutos de video que eu não conseguia fazer mais nada. Qualquer coisa travava a interface e eu tinha que fechar forçado o Premiere inteiro e reiniciar. Simplesmente não conseguia mais editar. 



O script que eu escrevi foi o mais longo até agora. Na média meus scripts tem umas 10 páginas de Word. Os mais compridos que eu já tinha feito era umas 20 páginas. Mas dessa vez eu me superei e escrevi nada menos que 30 páginas. Eu falei que gravo domingo ou segunda, mas desta vez eu já estava atrasado. Eu deixei pra terminar de escrever, gravar e editar tudo na terça que foi feriado, na minha cabeça eu tinha estimado que ia dar tempo pra soltar na quarta como sempre. Porém chegou na terça de noite e começou a acontecer essas travadas. Quem nunca passou por isso? Tá tudo andando bem, você vai cumprir o prazo que estimou, mas aí aparece uma situação que você não esperava, um bug inesperado ou um problema de BIOS mesmo, e aí seu prazo vai pelos ares.




Fica a dica: quando isso acontece, como meu sócio diria, Inês é morta. Além disso vale lembrar: eu sou amador em edição de video. Eu nunca trabalhei profissionalmente com video. Então eu sou no máximo nível junior. E junior sempre se fode. Eu sei os 20% sobre edição de video que resolve 80% dos meus problemas e eu consigo entregar os videos toda semana. Lembram que eu expliquei esse conceito no meu video de Devo Fazer Faculdade, versão de 22 anos depois? E eu disse que pra resolver os últimos 20% vai precisar dos 80% de conhecimento que eu ainda não tenho. Essa regra é quase uma lei. E uma hora eu ia passar por isso. Qualquer um que trabalha com video profissionalmente vai ver o que aconteceu e dar risada porque foi um erro trivial pra quem é sênior nisso.




E sim, eu sei que no Preview você deve fazer ele apresentar em metade ou um quarto da resolução se o video original for 1080p ou até 8 ou 16 vezes menor se a resolução original for 4K pra cima. Também sei que é pra desabilitar alta qualidade. Também me certifiquei se a configuração de memória estava adequada com o máximo de memória reservada pro Premiere. Chequei se o cache de media estava apontando pro HD mais rápido porque eu tenho um SSD SATA-3 Samsung EVO como drive principal mas ainda tenho um HD mecânico como drive secundário. 




Também chequei se por algum acidente ele estava usando o renderizador de preview Mercury via software que usa OpenGL. Como eu tenho uma placa de video decente que é a Nvidia GTX 1070Ti o certo é usar a versão do Mercury que usar CUDA que é o jeito programático de usar os cores da NVIDIA. Se estiver em Mac ou estiver usando placas AMD como as Radeon ou Vega, o certo é escolher o OpenCL. 




E por último, eu sempre crio as sequences com a mesma configuração do video principal que estou editando, ou seja, mesma resolução, mesma taxa de quadros por segundo. Tudo isso estava ok como deveria. Então não era problema de configuração. Aliás, bônus pra você porque todo video ou artigo sobre otimizar Premiere que você procurar vai dizer exatamente esses mesmos pontos que acabei de falar então já te economizei pesquisa.




Engraçado que as primeiras idéias que vem na cabeça eu até sei que a probabilidade é baixa, mas o lado geek quer tentar elas primeiro. O OBS grava por padrão os videos em H.264 mas ele coloca no envelope MKV, o Matroska. Diferente do MP4 que é o container padrão hoje em dia, derivado do Quicktime da Apple, o Matroska é muito flexível pra ser um container universal de dezenas de codecs. Por isso o suporte a MP4 costuma ser mais estável, porque ele é mais restrito então fica mais fácil de dar suporte. Ao contrário, suportar Matroska direito é mais complicado. Hoje em dia, eu até acho que um editor como o Premiere não deveria ter problemas com isso. 




Mas, eu resolvi tentar fazer Proxy files. Isso era uma feature do Premiere que eu sabia que existia mas nunca tentei usar. A idéia de Proxy é que se você filmar numa camera profissional da RED ou da Hasselblad como os YouTubers profissionais fazem, ele vai gravar arquivos de 8K. É impossível editar 8K em tempo real e ter preview, especialmente se adicionar efeitos por cima como Adjustment Layers pra color grading e color correction. Por isso o comum é exportar os videos 8K em resolução mais baixa que 1080p ou Full HD. Só que fazer isso manualmente pra todo clip seria muito trabalhoso então o Premiere oferece a opção de Proxies. Daí você edita na versão de baixa resolução mas na hora de exportar ele vai usar os originais.




Problema de fazer proxy é que tem o tempo de exportar os videos. Pensa que demorou quase 1 hora pra exportar o video de 3 horas de captura de tela do OBS. E pensa que já tinha passado da 1 da manhã quando tentei fazer isso. Péssima opção porque durante 1 hora eu não podia fazer nada. Daí terminou e, claro, não fez diferença nenhuma. Interessante que eu tentei mudar pro renderizador via software em vez de via GPU e aí ficava tudo lento mas pelo menos não travava a interface. Fiquei contemplando a idéia de editar tudo lento mas pelo menos não crashear. Mas isso seria um inferno porque ainda tinha mais meia hora de video pra editar das 2 horas restantes de material. Depois de ficar tentando outras coisas já tava dando 5 horas da manhã, então resolvi ir dormir pra conseguir ir pro escritório de manhã. 




E aqui vai outra dica: eu demorei mais do que devia, o certo era ter ido dormir antes. Eu não posso julgar quem faz isso porque passei a vida inteira varando 1 ou 2 ou até 3 noites sem parar às vezes. Mas não adianta, todo mundo falava a mesma coisa pra mim e eu nunca ouvia. Especialmente quando a gente é mais novo, a tendência é achar que temos stamina infinita, ainda mais se for arrogantão como eu que tem confiança que não importa o problema, sempre vou conseguir resolver. Enfim, lembre-se que é sempre melhor dormir quando já tá tarde e você tá travado.



Fui dormir com uma suspeita, pensei nisso durante o dia seguinte, e quando cheguei em casa voltei pra editar. Como eu expliquei antes, tinha os clips onde eu estava acelerando os videos pra vocês não ficarem esperando, as partes de instalação e compilação. Eram trechos que eu queria mostrar sem cortes, só acelerado. Só que pra caber em 10 segundos eu precisava acelerar 1000 porcento, mil e quinhentos porcento, às vezes 6000 porcento! Mesmo sem estar em cima desses clips, o preview de nada funcionava e travava tudo. 




Parece um bug na realidade, porque pelo menos os clips sem efeito deveria tocar o preview, por isso eu não tinha certeza. Mas daí eu imaginei que devia ter uma forma de pré-renderizar os clipes com efeitos como esse de aceleração. E de fato tem, aprendi só nesse dia sobre o recurso de Render and Replace que é parecido com a idéia de Proxy, mas ele vai usar o mesmo render na exportação final também. Serve pra clips com efeitos complicados que também custam caro de dar preview em tempo real. E eu tinha dezenas de clipes acelerados. Podia ser mais uma aposta que ia me custar o tempo de esperar renderizar tudo mas fazia sentido.




Eu tinha feito isso em alguns clipes na noite passada também e por isso só fui dormir 5 da manhã. Mas também não deu diferença nenhuma, a timeline continuava travando tudo. Mas na minha cabeça tinha que funcionar. Não fazia sentido não funcionar. Primeiro pensei que podia ser o codec. De repente se eu usasse um codec que não comprimisse tanto não usaria muito processamento pra fazer o preview então fiquei entre o GoPro Cineform e o Apple ProRes. Ambos ocupam espaço pra caramba mas acabei escolhendo o ProRes, e eu sei que foi um canhão pra matar uma mosca. Mas aí que me toquei que tinha um maldito checkbox que renderiza com os efeitos aplicados. 




Duh, óbvio que na noite anterior não tinha feito diferença nenhuma renderizar porque acelerar o tempo do video é um efeito, e até mais caro do que eu pensava, e se não marcasse esse checkbox ele estava só trocando seis por meia dúzia, de um codec pra outro, mas o efeito ainda tava sendo processado em tempo real. Dito e feito, umas 2 ou 3 horas fazendo Render and Replace, o preview ainda estava com um lag de 6 a 10 segundos mas pelo menos tocava e não travava tudo!




Daí segui uma dica que me deram no Instagram. O cara que mais me deu dicas úteis foi o limas, aliás se estiver assistindo valeu por me ajudar! Não sei o nome dele, o usuário é Limas então vou chamar de Limas. Ele fez certinho, ouviu os sintomas e fomos por eliminação em possíveis causas. Ele trabalhou com edição de video e a última coisa que eu fiz que ajudou bastante foi criar uma segunda sequence já que mesmo não travando mais ainda tinha o lag de 6 a 10 segundos que falei antes. Daí eu conseguia ir editando novos trechos, recortar e colar na sequence principal. Na segunda sequence o preview funcionou em velocidade máxima, na sequence principal mesmo depois de renderizar todos os efeitos ainda dava o tal lag, então teria sido super sofrido se tivesse que continuar assim, mas com a segunda sequence em velocidade normal eu consegui prosseguir sem dores de cabeça.





Além de dormir, outra dica muito importante, quando você trava num problema é falar com alguém. Não é obrigatório que essa pessoa tenha a capacidade de resolver seu problema. Só que não diga muita besteira de volta. Só de repetir o que você mesmo disse já ajuda. E mesmo que algumas das sugestões não ajudem, não importa. 




Esse diálogo faz parte do processo investigativo, eu falo comigo mesmo quando não tem ninguém por perto, mas não é a mesma coisa. Se eu for ser mais técnico, quando você tem um problema difícil de resolver o método socrático pode ajudar, é uma forma de diálogo onde você leva a pessoa à resposta fazendo perguntas simples pra guiar o processo investigativo. Você já viu algo parecido se assistiu séries como House ou qualquer adaptação de Sherlock Holmes, é pra isso que serve o Watson, a segunda metade do método socrático. 



É um dos motivos de porque eu falo que se você é iniciante ou inexperiente, não vá direto pro caminho de ser freelancer ou trabalhar home-office. Você precisa de outra pessoa pra dialogar, não necessariamente só pra te ensinar, mas pra ser o espelho no seu processo de aprendizado. Outra dica, se na emergência você está sozinho e não tem ninguém pra dialogar, escreva no papel todos os sintomas e hipóteses, mesmo as mais triviais. Não é eficiente, mas vai ajudar a colocar as peças no lugar. É o equivalente ao que você também já viu em séries como CSI ou séries de investigação jornalística onde o investigador vai colocando as pistas num quadro e vai ligando com um barbante. 




De qualquer forma, mesmo assim teve 2 bugs na edição, logo depois da intro acabou ficando um pequeno espaço preto que vocês nem devem ter notado, e na seção que inicio falando de Docker faltou uns segundos de áudio. Eu coloquei na errata nas descrições do video. Mas considerando o tamanho do video e o tanto de problema, até que ficou bom. Em resumo, o problema todo foi não ter tido a noção que acelerar video é um efeito que pode ficar caro e um conjunto grande de clipes com esse efeito por alguma razão cria lag na timeline inteira da sequence, e isso parece um bug do programa.




Agora, a segunda parte deste video foi justamente os comentários dos usuários. Primeiro de tudo, agradecimentos a todo mundo que ficou acompanhando meu sofrimento nas stories do Insta e mandou mensagens de apoio! Tirando o Limas que teve uma paciência de Jó de ficar pensando comigo, todo mundo que mandou sugestões infelizmente errou. Mas eu não estou aqui pra criticar não, porque eu sei que todo mundo só mandou alguma coisa porque se importou em tentar ajudar. Mas eu quero salientar que muitas das respostas são conclusões automáticas que muita gente tem pra vários outros tipos de problemas. E muitos, perigosamente, levam isso a sério.




Se eu for resumir, as sugestões tinham 3 padrões: os que assumiam que eu precisava de uma máquina ou algum componente melhor ou mais potente, os que lembraram que eu uso Windows então já vieram falando que eu devia usar Mac, ou os que sugeriam que eu mudasse do Premiere pra Final Cut do Mac ou Da Vinci Resolve ou Sony Vega. Aliás, curioso que duas pessoas me falaram do Vega, e eu nunca tinha ouvido falar.




Muita gente chega nas mesmas conclusões pra todo problema, incluindo em programação: 1) trocar pra hardware mais potente; 2) trocar de sistema operacional; 3) trocar de ferramentas. Tirando casos extremos, raramente qualquer uma dessas três respostas deve ser a primeira da lista, na realidade eu diria que seriam as últimas opções. O raciocínio que vou usar agora serve não só pro meu caso imediato de edição de video mas pra tudo, incluindo programação, então acompanhem pra entender e usem pro seu dia a dia também.




Trocar de hardware raramente ajuda. O raciocínio é simples: muito filme muito mais complexo já foi editado em hardware muito inferior ao meu. Eu tenho um PC que comprei especificamente pra editar video, e como eu disse no video anterior, você não precisa disso se for iniciante, mas no meu caso eu tenho a escolha de comprar mais do que preciso, então montei uma torre com Core i7 8a geração com 6 cores e 12 threads, tenho 32 GB de RAM, 1 Terabyte de SSD mais 2 Terabyte de HD mecânico secundário, uma placa GTX 1070Ti com 16GB de VRAM e um sistema de watercooling da Corsair pra CPU nunca ter thermal throttle, que é quando a CPU derruba o clock quando detecta temperaturas muito altas. Quem mandou mensagem não sabia necessariamente disso. Mas mesmo se fosse um notebook mais fraco, não seria esse o caso. Em todos os 30 anos que fui programador, o hardware raramente me impediu de fazer alguma coisa. Podia funcionar mais lento, mas não crashear. E o sintoma que falei é que tudo trava, não que fica lento.





O segundo caso é a reputação de estabilidade de Mac e Linux comparado à má reputação que o Windows acumulou ao longo dos anos. E isso começou principalmente com o Windows Me ou Millenium que foi o pior sistema operacional nos anos 90. O Windows 2000 ajudou a não derrubar a reputação porque ele era estável, como o Windows NT 4 antes dele. O Windows XP era usável em 2001 mas manter ele vivo por tantos anos destruiu a reputação. A demora no projeto Longhorn que se tornaria o Windows Vista e o resultado catastrófico de prometer demais e entregar muito de menos prejudicou ainda mais essa já horrorosa reputação. O Windows 7 e 8 não ajudaram. Foi só agora no Windows 10 e mesmo assim depois de vários updates que eles finalmente acertaram a mão, mas ele veio uma década mais tarde do que deveria. 




O Windows 10 ainda não atingiu os mesmos níveis de estabilidade do MacOS ou de qualquer Linux, porém com um hardware bom e principalmente drivers bons, eu não tenho nenhum problema de estabilidade faz muito tempo. Se eu disser que só vi uma tela azul em 2 anos não estou exagerando. E com a opção de agendar pra aplicar updates que exigem reboot só de madrugada, também nunca travei por conta de updates. Claro, na minha ordem de escolha eu continuo preferindo o MacOS mas desde 2014 eu não gosto do jeito que a Apple vem lidando com o hardware e por isso mudei pra hardwares PC. Eu gosto muito do Linux mas eu também gosto dos programas que tem no MacOS e no Windows que não tem no Mac. Por isso eu uso Linux em máquina virtual pra desenvolver. Apesar disso, eu não considero mais o Windows como primeiro fator pra um problema. Eu ainda não usaria Windows como servidor, mas como desktop ele está muito bom.





Finalmente, terceiro ponto, trocar de ferramenta. O Adobe Premiere é como o Windows, ele tem mais problemas que seus concorrentes. O Final Cut X é o melhor de todos em usabilidade e fluxo de trabalho apesar de ter um pouco menos funcionalidades. A combinação Final Cut  com Motion é o equivalente do Premiere com AfterEffects. Mas em Windows não tem Final Cut então a primeira opção é o Premiere. Hoje em dia existe a opção do Da Vince Resolve, cuja reputação é excelente e ele tem versões pra Mac, Windows e até Linux, fora que ele tem uma versão gratuita que compete com as versões pagas. 




Eu já estava de olho no Da Vince, que nasceu como uma ferramenta pra fazer color grading e color correction, por isso ele é o melhor de todos nesse departamento, mas ao longo do tempo ele embutiu o equivalente das funcionalidades do Premiere, AfterEffects e Audition tudo numa mesma ferramenta, então ele é extremamente poderoso. Não existe nenhum motivo pra eu não mudar pro Da Vince a não ser preguiça mesmo. Mudar o workflow de trabalho não é exatamente trivial, mas eu pretendo fazer isso em breve nem que seja só pra aprender uma ferramenta nova.




Porém, eu estava no meio de uma edição. Mudar de ferramenta no meio da edição não é a melhor resposta. Mudar de linguagem de programação, jogar fora o projeto atual que está funcionando, pelos possíveis benefícios de performance ou escalabilidade ou estabilidade não é uma escolha tão trivial quanto parece. Se eu tivesse mudado pro Da Vince naquela quinta-feira, vocês não teriam tido o video pronto na sexta. Talvez levasse mais dias ainda até eu aprender o workflow do Da Vinci e migrar tudo pra ele. Além disso eu ainda podia ter problemas inesperados no futuro próximo. 



A grande vantagem das ferramentas da Adobe é o ecossistema. Tem muito mais documentação em foruns e sites explicando como resolver as coisas, tem muito mais assets como videos, audio, efeitos, composições em dezenas de site. A intro do meu video é uma composição de After Effects que eu comprei. E eu tenho essa opção sempre que precisar. No Da Vince não vou ter, dai eu teria que comprar pra After Effects, exportar num video e importar no Da Vince de qualquer jeito, daí o fator preço já não é uma vantagem tão grande. O mesmo raciocínio vale pra frameworks ou linguagens de programação. Mudar não é trivial. Não quer dizer que não vale a pena, só que o contexto precisa ser levado em consideração e o melhor momento de fazer isso não é justo quando você tá com prazo apertado e no meio de uma emergência.





Agora a conclusão que devia ser a primeira e mais óbvia: milhares de pessoas estão neste instante usando o mesmo Premiere que eu. O Premiere é usado pra editar filmes e documentários, muito mais longos e complicados que um video de YouTube, com muito mais efeitos, muito mais tomadas de VFX, com dezenas de composições de AfterEffects, ou dynamic links com Audition. E eles conseguem editar e exportar tranquilamento. A conclusão mais óbvia é que “eu” não estou sabendo usar a ferramenta, não que a ferramenta, ou o sistema operacional ou o hardware são ruins. Essas 3 opções partem da premissa que não tem nada de errado comigo e sim com as ferramentas que estou usando.





Mas na grande maioria das vezes é o oposto: considere sempre como primeira hipótese que é você que não está sabendo usar as ferramentas. Considere sempre que todo bug, todo crash, toda lentidão, todo lag, todo atraso é sempre culpa sua. A última opção é a ferramenta, o sistema ou o hardware, a última da última opção. Todas as vezes que tive problemas desse tipo, raramente a culpa não era minha. E esse foi justamente mais um caso: só porque eu já editei e entreguei mais de 50 videos ao longo de 1 ano não significa que eu já sou senior, muito pelo contrário, só significa que eu aprendi um jeito de fazer as coisas e repeti esse mesmo jeito por 1 ano, e finalmente esbarrei num projeto que desafiou esse caminho e me obrigou a repensar minha forma de trabalhar. Se eu mudasse de ferramenta não teria aprendido nada. Ao longo do processo de resolver o problema eu aprendi mais e treinei coisas como Proxy files, Render and Replace, otimizações do Premiere, estudei sobre outros codecs e muito mais. Nada disso resolveu o problema imediato, mas eu ganhei mais conhecimento pro futuro. 



Ainda tem outro ponto a se considerar, e aqui é um princípio pessoal. Vocês sabem que eu não monetizo o canal. Quem define quando um vídeo vai ficar pronto, em que ritmo, sou eu. Por princípio eu decidi que eu só iria gravar e editar a noite, depois que volto do trabalho. Considere que eu sou dono da minha própria empresa, tecnicamente não existe nenhum problema se eu usasse o dia pra fazer isso. Mas por princípio eu escolhi fazer dentro dessas restrições e decidi que eu entregaria um video por semana salvo quando eu tivesse que viajar ou fazer eventos por exemplo. Eu sou o meu próprio chefe e o meu próprio cliente. Eu não conseguir cumprir os deadlines que eu mesmo decidi vai contra meus princípios. Não estou dizendo que todo mundo deve fazer isso, mas se você realmente quer ir um nível acima, deveria ter padrões mais elevados do que desistir e se justificar dizendo “ah, eu nem ganho o suficiente pra ter essa dor de cabeça”. Lógico esse princípio estou exagerando na explicação, mas acho que vocês entenderam o ponto.




A moral da história: sempre assumir que você ainda não sabe tudo e não inventar desculpas esfarrapadas. Mas também não adianta só ter falsa-humildade. Ai, tadinho de mim. Falso-humilde é um inútil. Eu preciso saber objetivamente quais itens eu ainda não sei e aprender e treinar um de cada vez. Alguém comentou no meu video sobre Conhecimentos Básicos que depois de assistir viu que não sabia nem esse básico e se questionou “eu devo ser burro mesmo”. E eu digo, não necessariamente, antes você não sabia que não sabia. Agora você sabe o que não sabe, faz uma enorme diferença, porque agora você tem uma meta pra cumprir. É um passo que vai te deixar melhor do que é hoje. A pior coisa é não ter consciência que não sabe. Como você vai melhorar, se não sabe o que não sabe?



Por fim, outro motivo que eu quis usar este exemplo: eu venho fazendo videos por quase 1 ano. Nesse período eu saí do 0 pros tais 20% em 3 meses. Dali em diante eu venho basicamente repetindo o mesmo processo. Ter feito 10 videos ou 50 videos ou 100 só seguindo o mesmo processo, não me torna muito melhor hoje do que eu já era em Janeiro. Esse problema que eu tive semana passada foi a primeira vez em meses que eu finalmente subi mais um nível. Isso é o aviso que eu dou a todo estagiário, trainee, junior. É muito, mas muito fácil, sair do 0 e ir pros 20% o suficiente pra conseguir entregar coisas que parecem produtos finais. Veja meus videos, se você só bater o olho ia dizer que eu sou que nivel? Sejam objetivos, seu nível em 1 ou 2 anos continua sendo junior, o meu nível aqui em edição continua sendo junior. Eu preciso apanhar mais vezes como semana passada se eu quiser subir de nivel. E pra isso eu mesmo preciso caçar problemas novos pra resolver em vez de voltar pra zona de conforto e evitar fazer os videos difíceis.




E é isso aí, era essa a história e o processo de pensamento que eu queria compartilhar com vocês hoje, se ficaram com dúvidas ou tem outras sugestões mandem nos comentários abaixo, se curtiram o video mandem um joinha, não deixem de assinar o canal e clicar no sininho pra não perder os próximos videos e compartilhem com seus amigos pra ajudar o canal. A gente se vê semana que vem, até mais!


No episódio sobre Ubuntu pra Devs da semana passada, quem me acompanhou pelas redes sociais (que é @akitaonrails em todas) viu que eu passei por um perrengue pra conseguir editar o vídeo e isso me custou uns 2 dias de atraso. Por isso o vídeo foi entregue só na sexta-feira e eu dormi mal duas noites.

Neste vídeo quero falar duas coisas. A primeira é explicar o que aconteceu e como eu resolvi o problema, pra quem tem interesse em edição de vídeo aprender também.

A segunda coisa é usar esse episódio pra refletir sobre como eu penso sobre resolução de problemas de modo mais amplo, sobre o processo investigativo e sobre a avaliação das minhas próprias capacidades, e como vocês também podem usar os mesmos conceitos quando encararem problemas difíceis e inesperados.

