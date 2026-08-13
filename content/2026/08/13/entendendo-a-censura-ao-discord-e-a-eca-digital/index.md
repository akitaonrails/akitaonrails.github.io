---
title: "Entendendo a censura ao Discord e a ECA digital"
slug: entendendo-a-censura-ao-discord-e-a-eca-digital
date: '2026-08-13T11:00:00-03:00'
draft: false
translationKey: entendendo-a-censura-ao-discord-e-a-eca-digital
description: "A ANPD mandou o Discord desligar o Go Live no Brasil porque a criptografia impede a moderação. Explico o caso de Naviraí, a Lei Felca, o choque com a LGPD e o precedente perigoso que isso abre."
tags:
- seguranca
- leis-e-regulacao
- politica
---

Em seis dias, o Brasil saiu de uma tragédia para um precedente regulatório que deveria preocupar qualquer pessoa que entende de tecnologia. No dia 22 de julho, uma adolescente de 13 anos morreu em Naviraí, Mato Grosso do Sul, durante uma transmissão ao vivo no Discord, coagida por um grupo que a polícia investiga como organização criminosa. No dia 12 de agosto, a ANPD ordenou que o Discord suspendesse as transmissões ao vivo no país inteiro.

Entre um ponto e outro: a primeira-dama pedindo bloqueio da plataforma em cerimônia oficial, a AGU anunciando ação civil pública, e a primeira grande fiscalização da história da ECA Digital. Vamos por partes, porque o diabo mora exatamente nas partes.

## O caso de Naviraí

Os fatos, conforme a [Polícia Civil do MS e o G1](https://g1.globo.com/politica/noticia/2026/08/04/policia-faz-operacao-contra-suspeitos-de-induzir-adolescente-a-tirar-a-propria-vida-e-transmitir-em-rede-social.ghtml): Lívia, 13 anos, foi encontrada morta na manhã de 22 de julho no quintal de casa. Ela tirou a própria vida durante uma transmissão no Go Live, o recurso de vídeo ao vivo do Discord, sob pressão, humilhação e incentivo explícito de outros usuários. Mais de 200 pessoas assistiam.

A [Operação Lívia](https://www.enfoquems.com.br/operacao-livia-combate-grupo-neonazista-que-coagiu-adolescente-ao-suicidio-em-navirai/), deflagrada em 4 de agosto com mandados em cinco estados, revelou o que havia por trás: um grupo composto majoritariamente por adolescentes — o líder investigado tem 14 anos — que recrutava menores via Discord **e Telegram**, espalhava conteúdo neonazista e misógino, e é investigado por homicídio qualificado e organização criminosa. Uma segunda menina foi induzida a se automutilar na mesma live, mas saiu da transmissão.

Guarde dois detalhes pra depois: o grupo operava em mais de uma plataforma, e o Ministério da Justiça [pediu à ANPD que investigasse Discord e Telegram](https://g1.globo.com/politica/noticia/2026/08/04/policia-faz-operacao-contra-suspeitos-de-induzir-adolescente-a-tirar-a-propria-vida-e-transmitir-em-rede-social.ghtml). Só um dos dois foi sancionado.

## Da primeira-dama à ANPD em seis dias

No dia 6 de agosto, na cerimônia de sanção do PL 3066/2025 (que endurece penas para crimes digitais contra crianças e permite interromper transmissões de abuso em tempo real), a primeira-dama Janja da Silva [não deixou margem pra dúvida](https://www1.folha.uol.com.br/cotidiano/2026/08/janja-chama-discord-de-rede-horrorosa-apos-caso-de-suicidio-ao-vivo-e-pede-seu-bloqueio-no-brasil.shtml): *"a gente precisa bloquear o Discord no Brasil de qualquer forma... a gente precisa atuar junto ao Judiciário para tirar essa rede horrorosa do ar"*. O advogado-geral da União, Jorge Messias, anunciou ali mesmo uma ação civil pública pra tirar a plataforma do ar.

No dia 7, a ANPD [abriu processo de fiscalização contra o Discord](https://www.gov.br/anpd/pt-br/assuntos/noticias/anpd-instaura-processo-de-fiscalizacao-contra-o-discord-para-apurar-falhas-na-protecao-de-criancas-e-adolescentes), com cinco dias úteis pra empresa se explicar. No dia 12, [a medida preventiva saiu](https://www.gov.br/anpd/pt-br/assuntos/noticias/em-medida-preventiva-anpd-determina-que-discord-suspenda-transmissoes-ao-vivo-no-brasil): o Discord deve suspender o Go Live e recursos equivalentes de compartilhamento de vídeo no Brasil em três dias úteis, e só religa quando provar medidas eficazes de proteção infantil e obtiver autorização expressa da ANPD. A base legal: artigos 6º, 10, 17, 28 e 29 da ECA Digital, com multas de até R$ 50 milhões por infração (art. 35).

O Discord [chamou a medida de "prematura"](https://www.meioemensagem.com.br/midia/anpd-suspende-transmissoes-ao-vivo-do-discord-no-brasil): recebeu o processo na sexta-feira, ainda estava dentro do prazo de resposta, e afirma que removeu o servidor privado onde o crime aconteceu. E soltou a frase mais interessante de toda a resposta: sua investigação interna encontrou evidências de que *"a atividade criminosa foi coordenada em outras plataformas antes da criação do servidor no Discord e continuou nelas depois"*.

Sobre isso, um esclarecimento necessário. Circulou a versão de que o caso teria se originado no Instagram. Fui checar e não encontrei nenhuma fonte que confirme: a plataforma citada pela polícia, além do Discord, é o Telegram. O Discord não nomeia as "outras plataformas". O que importa continua de pé, só que com outro nome no lugar: o caso **não era exclusivo do Discord**, o Ministério da Justiça pediu investigação de duas plataformas, e só o Discord tomou a sanção. O Telegram, que sequer tem representação legal robusta no Brasil, segue intocado.

E aqui aparece a primeira pergunta incômoda: se o problema é sistêmico, por que a sanção é cirúrgica?

## O que é a ECA Digital, a "Lei Felca"

A sanção só foi possível por causa de uma lei novinha em folha. Em agosto de 2025, o YouTuber Felca publicou o vídeo *"Adultização"*, expondo perfis que monetizavam conteúdo sexualizado com menores — o caso mais chocante sendo o do influenciador Hytalo Santos, [preso naquele mês e condenado em fevereiro de 2026](https://www.poder360.com.br/poder-justica/hytalo-santos-e-marido-sao-condenados-por-exploracao-de-menores/) a mais de 11 anos de prisão. O vídeo passou de 30 milhões de views, o Senado abriu uma CPI, e o Congresso [correu pra aprovar em regime de urgência](https://gcaa.com.br/eca-digital-e-sancionado-comentarios-sobre-marco-regulatorio-de-protecao-de-criancas-e-adolescentes-em-ambientes-digitais/) o PL 2628/2022, do senador Alessandro Vieira.

Resultado: a [Lei 15.211, de 17 de setembro de 2025](https://www.planalto.gov.br/ccivil_03/_ato2023-2026/2025/lei/l15211.htm), o Estatuto Digital da Criança e do Adolescente, em vigor desde 17 de março de 2026. Os pontos que importam pra esta discussão:

- **Dever de cuidado** (art. 6º): plataformas devem tomar *"medidas razoáveis desde a concepção"* pra prevenir exposição de menores a exploração sexual, violência e indução a autolesão e suicídio.
- **Verificação de idade** (art. 9º, §1º): *"mecanismos confiáveis de verificação de idade a cada acesso"*, com uma frase de efeito devastador: **"vedada a autodeclaração"**.
- **Notificação e remoção** (art. 29): dever de retirar conteúdo que viole direitos de crianças assim que comunicados, **independentemente de ordem judicial**.
- **Fiscalizador**: a ANPD, que acumulou o cargo com a LGPD e, desde maio de 2026, com deveres do Marco Civil da Internet. Virou o regulador digital de fato do país.
- **Multas** de até 10% do faturamento no Brasil, limitadas a R$ 50 milhões por infração. Suspensão de atividades, no papel, [só pelo Judiciário](https://www.planalto.gov.br/ccivil_03/_ato2023-2026/2025/lei/l15211.htm) (art. 35, §5º).

Esse último ponto já está em disputa: [especialistas ouvidos pela Folha](https://www1.folha.uol.com.br/cotidiano/2026/08/anpd-tem-poder-para-fiscalizar-discord-mas-competencias-ainda-sao-discutiveis-dizem-especialistas.shtml) apontam que a "medida preventiva" da ANPD pode ser, na prática, uma suspensão temporária de atividades — sanção que a lei reserva ao Judiciário. Mal nasceu, a regulação já flerta com a própria ilegalidade.

Vale lembrar o contexto maior: em junho de 2025 o STF [derrubou parcialmente o art. 19 do Marco Civil](https://www.conjur.com.br/2025-jun-11/stf-forma-maioria-por-responsabilizacao-de-big-techs-por-publicacoes-de-usuarios/), acabando com a exigência de ordem judicial específica pra responsabilizar plataformas. Em junho de 2026 o mesmo tribunal [consolidou um "dever de cuidado"](https://www.cnnbrasil.com.br/politica/stf-exige-representante-de-big-techs-no-brasil-e-da-60-dias-para-adaptacao/) com categorias de remoção imediata, incluindo indução a suicídio e crimes graves contra crianças. A ECA Digital legisla nessa direção. Em um ano, a responsabilidade das plataformas no Brasil deixou de ser reativa e virou proativa.

## O oximoro: "pode criptografar, desde que a gente possa ler"

Agora o miolo, que é o que me motivou a escrever. A justificativa oficial da ANPD pra suspender o Go Live merece ser lida com atenção: a arquitetura do Discord usa criptografia de ponta a ponta, **a plataforma não tem acesso ao conteúdo das transmissões ao vivo**, e portanto a moderação em tempo real é impossível. Na avaliação da ANPD, se a moderação depende de sistemas automatizados falhos e da denúncia de quem está na sala onde o crime acontece, o recurso é incompatível com a lei.

Leia de novo, devagar. A ANPD não proibiu criptografia — uma proibição direta seria indefensável em público. Ela disse outra coisa, muito mais engenhosa: você pode ter criptografia de ponta a ponta, desde que consiga monitorar o conteúdo pra cumprir os deveres legais.

Só que isso é um oximoro. O propósito inteiro da criptografia de ponta a ponta é que o servidor transporta texto cifrado e não tem como ler. Pra "monitorar o conteúdo", esse conteúdo precisa chegar aberto aos servidores — e aí não é mais ponta a ponta. Não existe terceira opção: ou é ilegível pra plataforma, ou é legível. A ANPD não criminalizou a criptografia; ela apenas tornou impossível oferecer criptografia de verdade e operar no Brasil ao mesmo tempo. Tecnicamente errado dizer que "proibiram criptografia". Funcionalmente, é exatamente o que aconteceu.

E não sou eu quem está dizendo. O Carlos Affonso Souza, diretor do ITS Rio, [disse à CNN Brasil](https://www.cnnbrasil.com.br/politica/discord-anpd-cria-precedente-perigoso-sobre-criptografia-diz-especialista/) que é a primeira vez que a ANPD trata criptografia de ponta a ponta como obstáculo regulatório, um precedente perigoso comparável aos bloqueios do WhatsApp — e que os criminosos simplesmente migram pra plataformas menos cooperativas e sem representação no país (alguém disse Telegram?).

Pra ser justo com o debate: o texto da lei não menciona criptografia uma única vez, e o art. 34, §1º [proíbe expressamente](https://www.planalto.gov.br/ccivil_03/_ato2023-2026/2025/lei/l15211.htm) *"mecanismos de vigilância massiva, genérica ou indiscriminada"*. Os checadores [derrubaram os boatos](https://www.boatos.org/tecnologia/ia-tera-acesso-a-todas-conversas-do-whatsapp-a-partir-de-hoje.html) de que a ECA Digital leria seu WhatsApp. Tudo isso é verdade — e tudo isso é sobre o papel. Na prática, a primeira fiscalização grande da história da lei tratou a impossibilidade técnica de vigiar como fundamento pra derrubar um recurso. O papel aceita tudo; a caneta da fiscalização é que escreve o direito real.

E tem ganchos na letra da lei esperando pra serem usados: o art. 18, III exige que ferramentas de controle parental permitam *"identificar os perfis de adultos com os quais a criança ou o adolescente se comunica"* — me explica como um mensageiro criptografado de ponta a ponta cumpre isso. O art. 27 manda *"remover e comunicar"* conteúdo de abuso *"detectado"* direta ou indiretamente — e detectar pressupõe ver. Nenhum dos dois foi usado ainda. O precedente do Go Live mostra como serão lidos quando forem.

> **Pra guardar:** a ANPD não proibiu criptografia. Proibiu um recurso cuja criptografia impede a vigilância do conteúdo. O efeito prático é idêntico: no Brasil, criptografia de ponta a ponta agora é um risco regulatório.

## ECA Digital contra LGPD

A ironia maior é institucional. Em 2018 aprovamos a LGPD pra proteger os dados pessoais do brasileiro, construída sobre princípios como minimização (colete só o necessário) e finalidade (use só pro que foi coletado). A ECA Digital, aplicada pela mesma agência, empurra na direção oposta.

A verificação de idade é o exemplo cristalino. *"Vedada a autodeclaração"* significa que todo usuário — adulto inclusive — vai precisar provar a idade pra acessar serviços comuns. Provar como? Documento, biometria facial, credencial verificável. A [Gazeta do Povo ouviu especialistas](https://www.gazetadopovo.com.br/vida-e-cidadania/verificacao-etaria-do-eca-digital-poe-em-risco-privacidade-de-dados/) que alertam pro óbvio: estamos construindo uma infraestrutura permanente de identificação de toda a população na internet, com dados biométricos que, uma vez vazados, não têm como trocar — você troca de senha, não troca de cara.

E não é teoria. Uma [carta aberta assinada por 438 cientistas de 32 países](https://convergenciadigital.com.br/governo/inutil-e-perigoso-cientistas-alertam-contra-sistemas-de-verificacao-de-idade-na-internet/) chama esses sistemas de "inúteis e perigosos": fáceis de burlar com VPN e deepfake, enviesados contra minorias. E cita o exemplo perfeito — o próprio Discord, que [vazou fotos de documentos de ~70 mil usuários](https://convergenciadigital.com.br/governo/inutil-e-perigoso-cientistas-alertam-contra-sistemas-de-verificacao-de-idade-na-internet/) justamente por causa de verificação de idade terceirizada. A plataforma que a ANPD pune por não vigiar é a mesma que provou, na prática, o custo de coletar.

A lei tem salvaguardas no papel — o art. 13 limita o uso dos dados de verificação *"unicamente para essa finalidade"*, o art. 12 fala em minimização. Mas note o conflito de interesses estrutural: a ANPD acumula três mandatos — LGPD, ECA Digital e Marco Civil. A agência que deveria defender a minimização dos seus dados é a mesma que agora exige que você os entregue. Quando os dois papéis colidirem dentro do mesmo órgão, qual deles você acha que vence?

## E os criminosos de verdade?

Tem um contrassenso nessa história que quase ninguém comentou. A sanção contra o Discord caiu em seis dias, com potencial de R$ 50 milhões de multa por infração. E o que acontece com os autores do crime que motivou tudo isso?

O grupo de Naviraí era composto por cinco adolescentes de 13 a 17 anos e um jovem de 18. O líder investigado tem 14. Pela lei brasileira, só o de 18 responde como adulto, por homicídio qualificado. Os outros cinco entram no regime do ECA — o clássico, não o digital: medida socioeducativa de internação, com [teto de três anos](https://www.atfcursosjuridicos.com.br/repositorio/material/15893963154125-ecaparaoabatf.pdf) e soltura compulsória aos 21. O caso corre em sigilo e não sabemos as medidas aplicadas, mas o teto é esse, não importa a crueldade. O mentor intelectual do massacre de Suzano, com 10 mortos, tinha 17 anos e [ficou internado](https://g1.globo.com/sp/mogi-das-cruzes-suzano/noticia/2019/05/03/justica-decide-manter-internacao-de-menor-apontado-como-mentor-intelectual-do-massacre-em-suzano.ghtml) — três anos, independentemente da contagem de corpos.

E tem uma ironia de calendário: em fevereiro de 2026 o Brasil [sancionou a lei que tornou hedionda a indução online a suicídio e autolesão](https://www.brasilparalelo.com.br/noticias/lula-sanciona-lei-que-define-bullying-e-cyberbullying-como-crimes), com pena dobrada pra líderes de grupo. Pra adultos. Pros cinco adolescentes de Naviraí, investigados exatamente por isso, não muda nada: o teto continua sendo os três anos do ECA.

E segue assim por escolha, porque tentativa não faltou. Em março de 2026, o relator da PEC da Segurança Pública incluiu um [referendo sobre a redução da maioridade penal pra 16 anos](https://www.congressoemfoco.com.br/amp/noticia/116889/governo-se-manifesta-contra-a-reducao-da-maioridade-penal--ineficaz); o governo chamou a redução de "ineficaz e inconstitucional" e o trecho foi arrancado pra PEC passar — [aprovada por 487 a 15](https://www.nsctotal.com.br/noticias/camara-aprova-pec-da-seguranca-publica-apos-retirada-de-mencao-a-maioridade-penal) sem uma linha sobre o assunto. Em junho, a CCJ da Câmara [aprovou a admissibilidade de outra PEC da redução, por 44 a 18](https://www.camara.leg.br/noticias/1280551-comissao-de-constituicao-e-justica-aprova-pec-que-reduz-maioridade-penal/), mas ela ainda precisa de 308 votos em dois turnos de plenário — exatamente o muro onde a versão de 2015 morreu. Até a saída intermediária empaca: o [PL 1.473/2025](https://www12.senado.leg.br/noticias/materias/2025/10/22/vai-a-camara-mais-tempo-de-internacao-de-adolescente-em-conflito-com-a-lei), que subiria a internação máxima de 3 pra 5 anos (10 pra crimes violentos), passou no Senado em outubro de 2025 e dorme na Câmara até hoje.

Enquanto isso, o crime organizado faz aritmética. Facções recrutam adolescentes de propósito, porque sabem que o ECA protege o executor: nos ataques de facções no Ceará, adultos [pagavam de R$ 1.000 a R$ 5.000 por atentado](https://ponte.org/periferias-sao-as-principais-vitimas-dos-ataques-de-faccoes-no-ceara/) pra adolescentes tocarem fogo em veículos — o mandante não se expõe, o executor não vai pra prisão. O grupo de Naviraí é a versão digital da mesma lógica: um líder de 14 anos coordenando crimes que, se cometidos por um adulto, dariam décadas de cadeia.

E o Brasil virou exceção até na vizinhança. A Argentina [aprovou em fevereiro a redução de 16 pra 14 anos](https://g1.globo.com/mundo/noticia/2026/02/27/argentina-aprova-lei-que-reduz-maioridade-penal-de-16-para-14-anos.ghtml). A Suécia, de todos os países, [baixou pra 13 anos em crimes graves a partir de julho](https://noticias.r7.com/prisma/espaco-prisma/com-13-anos-um-adolescente-pode-matar-e-ir-para-a-cadeia-a-suecia-decidiu-que-sim-o-brasil-ainda-nao-sabe-05022026/) — depois que gangues passaram a recrutar crianças pelo Snapchat pra atentados justamente porque elas não podiam ser processadas. Inglaterra pune a partir dos 10 (embora a própria Ordem dos Advogados de lá queira subir pra 14), a maioria dos estados americanos transfere adolescentes de 14 pra vara criminal em homicídio, Portugal pune aos 16.

Pra constar, o outro lado existe: a [UNICEF se posicionou contra a redução](https://brasil.un.org/pt-br/317703-redu%C3%A7%C3%A3o-da-maioridade-penal-unicef-manifesta-preocupa%C3%A7%C3%A3o-com-avan%C3%A7o-da-pec-na-c%C3%A2mara-dos), e os dados de reincidência são desconfortáveis pros dois lados — ~43% depois da internação, ~70% depois da prisão comum. Se é pra debater o modelo, debata. O que não dá é o resultado atual: uma lei nova conseguiu em seis dias tirar do ar um recurso usado por milhões de pessoas inocentes, enquanto o sistema que pune os autores do crime não sai do lugar há trinta. A gente pune o cano porque o cano é quem está ao alcance.

## Enquanto isso, no STF: o sigilo da fonte furado

Se fosse só o Discord, dava pra chamar de acidente regulatório. Mas na mesma semana, outro pilar caiu.

Desde novembro de 2025, o jornalista Luís Pablo, do Maranhão, publicava reportagens sobre o uso de um carro oficial do TJ-MA pelo ministro Flávio Dino e familiares. Em março, Alexandre de Moraes autorizou [busca e apreensão contra o jornalista](https://www.gazetadopovo.com.br/republica/decisao-de-moraes-sobre-jornalista-cita-inquerito-das-fake-news-e-contraria-nota-oficial-do-stf/) — numa decisão que citava o inquérito das fake news, o que a assessoria do STF depois negou. Celulares, notebook e pen drive apreendidos. Em abril, o equipamento foi devolvido, mas a análise forense continuou.

No dia 11 de agosto, [a PF cumpriu mandados contra Raimundo Cutrim](https://g1.globo.com/jornal-nacional/noticia/2026/08/11/moraes-determina-investigacao-contra-fonte-de-jornalista-em-reportagem-sobre-dino.ghtml), ex-secretário de Segurança do Maranhão — identificado como a fonte do jornalista. Como chegaram nele? Pela análise dos dispositivos apreendidos do jornalista.

Entendeu o mecanismo? O art. 5º, XIV da Constituição protege o sigilo da fonte, e o jornalista pode se recusar a revelar — como ele fez, ficando em silêncio no depoimento. Então não perguntaram. Apreenderam o material de trabalho, leram tudo, e identificaram a fonte pelas costas. A constitucionalista Vera Chemin [resumiu na CNN](https://www.cnnbrasil.com.br/politica/especialistas-avaliam-decisao-de-moraes-sobre-fonte-de-jornalista/): *"não se pode violar o sigilo para depois verificar se houve um crime ou não"*.

O próprio STF já decidiu isso, e mais de uma vez. Na ADPF 601, em 2019, Gilmar Mendes [protegeu o Glenn Greenwald na Vaza Jato](https://noticias.stf.jus.br/postsnoticias/ministro-gilmar-mendes-garante-sigilo-da-fonte-a-jornalista-glenn-greenwald/) com uma frase que deveria estar emoldurada: o sigilo da fonte *"impossibilita que o Estado utilize medidas coercivas para constranger a atuação profissional e devassar a forma de recepção e transmissão daquilo que é trazido a conhecimento público"*. "Devassar a forma de recepção" é literalmente o que a análise forense dos dispositivos fez.

Pra constar, a defesa do STF existe e merece ser apresentada: a investigação apura monitoramento ilegal de um ministro e da família dele, com placas, nomes de seguranças e imagens clandestinas de crianças publicados; a PF aponta que Cutrim usou cargo público pra acessar sistemas restritos; e há uma transferência de R$ 100 mil de um segundo investigado pro jornalista, cuja natureza ninguém provou ainda. Os autos correm em sigilo, então nenhuma das versões é verificável de fora. É possível que haja crime ali. Mas é exatamente por isso que a ordem importa: primeiro se investiga com meios lícitos, depois — talvez, em casos excepcionalíssimos — se discute exceção. Inverter essa ordem transforma a exceção em método.

A reação foi a de sempre, só que mais alta: [Abraji](https://www.abraji.org.br/noticias/abraji-condena-violacao-de-sigilo-de-fonte-de-jornalista-no-maranhao), ANJ, ABERT, SIP internacional, e [editoriais dos três maiores jornais do país no mesmo dia](https://www.poder360.com.br/poder-midia/globo-folha-e-estadao-criticam-stf-por-quebra-de-sigilo-da-fonte/). O Estadão escreveu que o inquérito das fake news *"foi convertido em instrumento de intimidação"*. Miro Teixeira, o advogado que derrubou a Lei de Imprensa da ditadura em 2009, disse que o STF [atua "momentaneamente como tribunal de exceção"](https://www.poder360.com.br/poder-justica/stf-atua-momentaneamente-como-tribunal-de-excecao-diz-miro-teixeira/).

## Conclusão: estamos virando um país censurado?

O padrão é o que me preocupa, não os episódios isolados. Em 2024, o X ficou um mês fora do ar no Brasil por ordem monocrática. Em 2025, caiu o art. 19 do Marco Civil e a responsabilidade das plataformas virou proativa. Em 2026, a ECA Digital entregou ao Executivo um pacote de obrigações tão intrusivo que, na primeira vez usado, derrubou um recurso criptografado no país inteiro — enquanto o líder de 14 anos do grupo que motivou a sanção enfrenta, no máximo, três anos de internação. E o sigilo da fonte jornalística foi furado por via forense, com aval do mesmo tribunal que o consagrou.

Cada degrau dessa escada tem uma justificativa simpática, e é exatamente por isso que a escada é perigosa. Ninguém constrói infraestrutura de censura dizendo que é pra censura. Constrói-se pra proteger crianças, pra proteger ministros, pra proteger a democracia.

O problema é que infraestrutura não tem dono moral. A régua que hoje mede o Discord mede qualquer aplicativo amanhã. A fiscalização que hoje exige transmissão aberta pra proteger a Lívia vai exigir transmissão aberta pra qualquer coisa que o governo de plantão queira ver. A quebra de sigilo que hoje pega a fonte do caso Dino pega qualquer fonte, de qualquer caso, contra qualquer um.

E o detalhe mais revelador da semana: das duas plataformas que o Ministério da Justiça pediu pra investigar, a sancionada foi a que tem escritório, CNPJ e advogados no Brasil — a que *coopera*. A mensagem que o regulador mandou pro mercado foi invertida: cooperar te expõe; ser opaco te protege. Os adolescentes do grupo neonazista de Naviraí não vão pra lugar nenhum — vão pro Telegram, que ninguém tocou.

E tem o traço mais brasileiro de todos nesse arranjo: ficou impossível estar em dia com a lei. Se você protege seus usuários de verdade, com criptografia de ponta a ponta, descumpre a ECA Digital. Se cumpre a ECA Digital, abre os dados dos seus usuários e descumpre a LGPD. Se coleta documento pra verificar idade, vira alvo de vazamento e de sanção; se não coleta, vira alvo de fiscalização. Não existe configuração segura.

E isso é tradição nossa: leis tão amplas, com tantas exceções empilhadas, que qualquer um vira infrator por acidente em qualquer esquina. Quando todo mundo está sempre devendo, a lei deixa de ser regra e vira opção — o poder real migra pra quem escolhe contra quem aplicar. Foi o que aconteceu essa semana: duas plataformas investigadas, uma punida. A que tinha endereço aqui.

Proteger crianças é dever civilizatório inegociável. Investigar crime contra ministro é obrigação do Estado. A pergunta que fica não é se essas causas são legítimas — são. É se o Brasil ainda consegue perseguir causas legítimas sem demoliar as garantias que tornam o país uma democracia liberal: privacidade real, criptografia funcional, imprensa com fonte protegida. Essa semana, a resposta foi não três vezes seguidas.

Não é censura de regime. É pior, de certa forma: é censura por acumulado, votada, sancionada e aplaudida, cada tijolo com uma plaquinha de boa intenção. E a gente só percebe o muro quando ele já está em volta.
