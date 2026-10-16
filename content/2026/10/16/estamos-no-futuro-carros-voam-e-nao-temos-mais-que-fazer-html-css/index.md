---
title: "Estamos no Futuro: Carros voam e não temos mais que fazer HTML/CSS"
slug: "estamos-no-futuro-carros-voam-e-nao-temos-mais-que-fazer-html-css"
date: '2026-10-16T02:00:00-03:00'
draft: false
translationKey: estamos-no-futuro-carros-voam-e-nao-temos-mais-que-fazer-html-css
description: "O Roadster da Tesla girou no ar enquanto eu redesenhava seis sites em cerca de um dia. Com agentes fazendo web, mobile e desktop, trabalho mecânico virou automação; carreira exige adaptação."
tags:
- inteligencia-artificial
- frontend
- automacao
- carreira
---

São mais de duas da manhã e eu ainda estou acordado porque acabei de assistir ao vivo ao novo Tesla Roadster subir uma rampa vertical, parar de cabeça pra baixo e, em outra passagem, girar no ar e pousar inteiro.

Eu esperava um carro rápido. Não esperava um carro com dez bocais de propulsão a ar comprimido, usando tecnologia derivada da SpaceX, e um sistema de sucção embaixo capaz, [segundo Elon Musk, de puxar até 2 G](https://paultan.org/2026/10/16/tesla-roadster-revealed-flies-on-spacex-air-thrusters-0-96-km-h-in-0-81s-production-2028/). Na demonstração, a Tesla anunciou zero a 60 milhas por hora, quase 97 km/h, em 0,81 segundo. Não divulgou o protocolo da medição.

Era esse o futuro que eu queria ver.

A demonstração inteira está na [transmissão oficial da Tesla](https://livestream.tesla.com/). A [Road & Track mediu e descreveu as manobras](https://www.roadandtrack.com/news/a74151425/the-air-assisted-tesla-roadster-flies-in-demo-hits-0-60-in-08-seconds/), e a [TechCrunch detalhou as três versões](https://techcrunch.com/2026/10/15/tesla-reveals-spacex-powered-roadster-that-flies-and-falls-with-style/): Performance com aerodinâmica ativa e sucção, Thrust com propulsores traseiros, Rocket com sistema de propulsão de dez bocais e apenas um assento.

Claro, o que vimos foi um protótipo numa demonstração controlada. A Tesla prevê iniciar a produção em 2028, e a versão Rocket não está aprovada para uso em vias públicas. Ainda assim, um carro de verdade saiu do chão, girou e pousou. Eu assisti a isso ao vivo do meu escritório. Foi espetacular.

Enquanto Musk faz foguetes pousarem e carros voarem, eu estava fazendo um trabalho bem mais mundano e pequeno: mexendo nos meus sites.

## Seis sites em cerca de um dia

Antes do evento da Tesla, eu passei o dia inteiro redesenhando seis sites:

- [Akita's AI Lair](https://ailair.akitaonrails.com/), agora combinando com o visual do meu livro novo, *Competente o Suficiente*;
- [ai-memory](https://aimemory.sh/);
- [ai-jail](https://aijail.io/);
- a newsletter [The M.Akita Chronicles](https://themakitachronicles.com/);
- o [arquivo da newsletter](https://blog.themakitachronicles.com/);
- e este blog, [AkitaOnRails.com](https://akitaonrails.com/).

![Os seis sites redesenhados em produção: Akita's AI Lair, ai-memory, ai-jail, The M.Akita Chronicles, o arquivo da newsletter e AkitaOnRails](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/10/redesign-seis-sites-stitch.jpg)

Todos começaram com variações daquele tema padrão que o Claude faz. Fundo escuro, gradiente roxo ou azul, fonte sans enorme, cartões arredondados, brilho atrás de alguma coisa. Funciona. Também ficou tão comum que hoje você bate o olho e reconhece "site feito pelo Claude" antes de ler o título.

Eu já tinha tentado pedir designs diferentes pro Claude. Ele trocava a cor, movia os cartões e entregava a mesma gramática visual. Publiquei [algumas telas e o resultado da mudança no Twitter](https://x.com/AkitaOnRails/status/2110809199890300986). Eu não sou web designer e, por um tempo, aceitei o "funciona". Ontem cansei.

Alguém me sugeriu o [Stitch, do Google](https://stitch.withgoogle.com/). É uma ferramenta experimental do Google Labs que transforma instruções e imagens em interfaces editáveis e código de front-end. A [primeira versão foi apresentada em 2025](https://developers.googleblog.com/en/stitch-a-new-way-to-design-uis/) em cima do Gemini; [a versão atual](https://blog.google/innovation-and-ai/models-and-research/google-labs/stitch-ai-ui-design/) virou uma tela de design com agente, protótipos e exportação de um `DESIGN.md` que outros agentes conseguem seguir.

[![O canvas do Google Stitch com várias interfaces, variações visuais e controles do design system](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/10/stitch-ai-native-canvas-google.webp)](https://blog.google/innovation-and-ai/models-and-research/google-labs/stitch-ai-ui-design/)

Criei a conta, peguei o token da API e comecei a trabalhar. O Stitch gerava direções visuais. Claude Code e Codex levavam essas direções pros repositórios reais, adaptavam os componentes, corrigiam responsividade, trocavam imagens, ajustavam SEO, testavam e faziam deploy. Quando a cota de um acabava, eu continuava com o outro.

Os seis sites saem de cinco repositórios. Olhando todos lado a lado, uma coisa ficou clara: o Stitch responde muito melhor quando recebe uma metáfora concreta, o público e o que aquele produto precisa comunicar. O ai-memory virou um arquivo de memória. O ai-jail, uma prisão cinematográfica. O AI Lair adotou uma feira mundial dos anos 1950 e 1960, puxada pela capa do meu livro. A newsletter virou uma transmissão noturna, e este blog, um arquivo editorial. Cinco identidades diferentes em vez de cinco variações do mesmo gradiente do Claude.

O protótipo bonito é a parte fácil. O trabalho só termina quando a linguagem visual chega às páginas internas, ao artigo, ao leitor do livro, ao e-mail, às páginas legais, aos estados de erro e ao celular. Foi isso que os agentes fizeram nos repositórios. No ai-memory, por exemplo, a verificação cobriu 102 páginas em seis idiomas, nos temas claro e escuro, em desktop e celular. No The M.Akita Chronicles, o mesmo design precisou funcionar na inscrição, no arquivo, no detalhe de newsletter, no podcast e no template do e-mail. Um mockup do Stitch não resolve nada disso sozinho.

Foram várias rodadas de protótipos em cada site. Algumas ficaram horrorosas. Outras tinham uma ideia boa cercada de decisões ruins. Eu mandava descartar, preservar uma parte, misturar com outra tentativa e recomeçar. Código ficou barato, então não existe motivo pra se apaixonar pela primeira versão.

O resultado não vai ganhar prêmio de design. Um designer profissional ainda encontraria centenas de coisas pra melhorar. Eu mesmo sei que consigo avançar se gastar mais alguns dias. Só que ficou muito melhor do que estava e, por enquanto, está competente o suficiente.

Seis sites existentes redesenhados, responsivos, com SEO, geração e substituição de imagens, ajustes de HTML, CSS e JavaScript, teste e deploy em produção. Uma pessoa. Cerca de um dia. Um ano atrás, esse pacote seria trabalho de semanas ou meses.

## Até o primeiro proofreading pode ser automatizado

No mesmo processo eu mandei agentes revisarem os sites como leitores diferentes. Não era correção gramatical. Eu queria saber o que uma pessoa entenderia nos primeiros segundos, onde ficaria perdida, qual promessa pareceria suspeita e se conseguiria completar uma tarefa sem já conhecer o produto.

No ai-jail, usei duas sessões isoladas. Uma assumiu o papel de um engenheiro cético que aprova todos os prompts e nunca tinha ouvido falar do projeto. A outra era gerente de oito desenvolvedores, sem ser engenheira, tentando decidir se deveria aprovar a ferramenta na empresa. No ai-memory foram três: um engenheiro aprendendo ferramentas de IA, uma gerente avaliando um piloto e um pai sem experiência com agentes, preocupado com AGI e empregos. Cada um leu o site sem ver o relatório dos outros.

Qualquer pessoa consegue fazer o mesmo. Suba a aplicação localmente ou abra um deploy de preview, comece sessões novas e dê a cada agente uma tarefa concreta. Um prompt básico pode ser assim:

```text
Abra este site em desktop e celular: [URL].

Você é [perfil], conhece [contexto] e nunca viu este produto.
Seu objetivo é [decisão ou tarefa concreta].

Navegue como essa pessoa. Não leia código nem documentação interna antes.
Registre:
- o que entendeu nos primeiros dez segundos;
- o que acha que o produto faz e para quem serve;
- onde não soube qual era o próximo passo;
- promessas contraditórias, absolutas ou difíceis de acreditar;
- termos que o site usa antes de explicar;
- problemas de leitura, teclado, contraste, toque e responsividade;
- o que impediria você de testar, comprar ou aprovar.

Para cada achado, mostre a página e a evidência visível.
Separe bug factual, problema de uso e preferência subjetiva.
Não proponha redesign geral. Sugira a menor mudança que resolve o problema.
```

Eu prefiro três sessões independentes a uma mesa-redonda de agentes. Se um lê o relatório do outro, começa a concordar por inércia. Depois uma sessão separada consolida os pontos repetidos, descarta gosto pessoal e confere cada afirmação contra o código e a documentação do produto. A revisão pode apontar que uma frase está errada; ela não tem autoridade pra inventar a frase correta.

Os resultados mais úteis costumam cair em quatro grupos: posicionamento, ordem da informação, caminho até a primeira ação e confiança. Testes automáticos tradicionais continuam cuidando de link quebrado, contraste, acessibilidade, overflow e estado de erro. A persona mostra que o botão tecnicamente acessível apareceu cinco telas depois de onde a pessoa precisava dele.

No [proofreading do ai-jail](https://github.com/akitaonrails/ai-jail-web/blob/main/docs/research/PROOFREAD-2026-10-15-BRIEF.md), os dois perfis concordaram que o site demorava pra mostrar o risco concreto e falava cedo demais como documentação de engenheiro. A ameaça de uma página envenenada foi puxada pra logo depois do hero. Entraram as seções "O que muda no primeiro dia" e "Para quem precisa aprovar isto", com custo operacional, limites e as chaves que uma empresa realmente expõe. A revisão também encontrou uma afirmação tecnicamente errada repetida em várias páginas: a rede não fica inteiramente desligada por padrão. O host da própria API do agente e, no Linux, os registries continuam acessíveis. Esse tipo de leitura também encontra bug de documentação.

O [relatório do ai-memory](https://github.com/akitaonrails/ai-memory-web/blob/main/docs/research/persona-review.md) encontrou permissões descritas de formas contraditórias, promessas de privacidade absolutas demais e a explicação básica soterrada por features avançadas. Na segunda rodada, os perfis perceberam que a instrução de acesso remoto mandava usar HTTP antes de exigir TLS, que um `curl` sem autenticação prometia a resposta errada e que escolhas importantes apareciam tarde demais no celular. O guia de coleta saiu de aproximadamente 4.364 pixels do topo pra 1.617; os caminhos pra indivíduo ou equipe, de 5.300 pra 2.489. Isso é uma melhoria objetiva nascida de leitura simulada.

No [redesign do AI Lair](https://github.com/akitaonrails/ai-toolkit-web/pull/4), a revisão para leitores novos reorganizou o caminho de entrada. Uma [revisão seguinte](https://github.com/akitaonrails/ai-toolkit-web/commit/c2a5237e876f662a8b53450f23f0162fdc1d4a76) deixou explícito que o meu setup com vários agentes e dois monitores é uma configuração madura, não requisito pra começar. Uma pessoa, um projeto e um agente bastam. Também surgiu um roteiro de piloto pra gerente: tarefa reversível, dado não sensível, critério de aceitação, prazo, orçamento e medição. A auditoria seguinte encontrou ARIA inválido e uma animação que escondia o texto de abertura de tecnologias assistivas; a [correção](https://github.com/akitaonrails/ai-toolkit-web/pull/5) levou o axe-core de quatro violações sérias pra zero.

Personas simuladas ainda ficam muito abaixo de feedback humano. Carregam os mesmos vícios dos modelos, podem concordar com o prompt e nunca sentem a irritação de quem perdeu vinte minutos, nem assumem o risco de colocar o próprio cartão de crédito. Os relatórios servem como hipóteses. Um usuário real sempre encontra o caso que eu, o agente e a suíte de testes não imaginaram.

Só que antes do primeiro usuário existir, a alternativa costuma ser nenhuma revisão. Duas ou três leituras independentes já pegam promessa contraditória, jargão sem explicação, informação enterrada e fluxo que só faz sentido pra quem escreveu. Rodar essas leituras custa pouco e deixa o produto menos burro antes de chegar em gente de verdade.

## HTML nunca foi programação

Durante anos eu vi gente fazendo uma ginástica danada pra defender que "HTML é linguagem de programação" e, portanto, quem escreve HTML é programador.

HTML é marcação: descreve a estrutura de um documento. CSS descreve apresentação. Isso tem valor, exige conhecimento e pode ficar terrivelmente complexo. Complexidade acidental não transforma marcação em programação.

E não há vergonha nenhuma nisso. Comecei a fazer sites nos anos 1990. Recebia um layout feito no Photoshop e transformava aquilo em HTML. Recortava imagens, montava tabela, ajustava pixel, abria em vários navegadores, voltava e tentava de novo. Foi trabalho honesto e pagou minhas contas.

Também era um trabalho basicamente mecânico: copiar, colar, ajustar, olhar, repetir. Exatamente a categoria que computadores deveriam automatizar.

Hoje eu ainda escolhi direção visual, descartei propostas ruins, decidi o que cada site precisava comunicar e reconheci quando o resultado estava bom o suficiente. Os agentes fizeram o serviço braçal. É assim que deveria ter sido há anos.

## A bolha atrasou a automação

Durante boa parte dos anos 2010, [os juros americanos ficaram perto de zero](https://fred.stlouisfed.org/series/EFFR). Dinheiro barato irrigou fundos, startups e empresas grandes. Contratar mais gente era fácil, e o mercado absorvia qualquer quantidade de trabalho manual disfarçado de engenharia.

Juro baixo não explica sozinho a expansão da tecnologia, mas uma área em recorde de contratação tem pouco incentivo pra eliminar o próprio trabalho repetitivo. Se você consegue colocar mais cinquenta pessoas pra montar tela, coloca mais cinquenta pessoas pra montar tela.

Quem assistiu às minhas palestras em eventos de tecnologia nos anos 2010 deve lembrar de **Restrição == Inovação**. O nome correto era com dois sinais de igual mesmo. Apresentei essa palestra na DevConf 2019, os [83 slides estão no meu SlideShare](https://www.slideshare.net/slideshow/devconf-2019-so-carlos/143923367), e eu já tinha escrito a mesma tese em 2013, em ["Restrições são libertadoras: menos é mais"](https://startupi.com.br/restricoes-sao-libertadoras-menos-e-mais/).

{{< youtube id="V0D3PuTLOZ8" >}}

É a velha máxima: **a necessidade é a mãe da invenção**. Restrição obriga a escolher. Escolha obriga a priorizar. Quando o caminho convencional não cabe no dinheiro, no prazo ou na capacidade disponível, alguém precisa encontrar outro caminho. É daí que costuma sair inovação de verdade.

Dinheiro financia pesquisa cara, compra equipamento e dá tempo pra experimentar. Sobra de dinheiro sem pressão por resultado faz outra coisa: esconde ineficiência com força bruta. Não precisa automatizar, simplificar nem descobrir uma solução melhor enquanto ainda der pra contratar mais gente e aumentar a planilha. Abundância demais transforma problema técnico em despesa operacional e empurra a decisão difícil pra depois.

Eu [repeti esse aviso no começo de 2026](/2026/02/08/rant-ia-acabou-com-programadores/): a bolha de programação conseguiu substituir eficiência por volume. A restrição voltou quando o dinheiro barato acabou. Coincidentemente, os agentes chegaram na mesma hora e deram às empresas uma maneira prática de automatizar o trabalho mecânico que elas passaram uma década escalando com contratação.

Foi assim que a gente passou uma década recriando o mesmo painel administrativo e chamando de inovação. Toda semana aparecia a próxima salvação do front-end: React, Angular, Vue, Svelte, outro *bundler*, outro framework em cima do framework. São ferramentas úteis em seus contextos, mas nenhuma atacava a pergunta óbvia: por que um ser humano ainda está escrevendo à mão a milésima variação do mesmo formulário?

O estouro da bolha de contratação em 2022 encerrou a festa. No fim daquele ano, o ChatGPT levou modelos de linguagem ao público. GPT-2, só pra corrigir a cronologia, tinha saído em 2019. Quatro anos depois do ChatGPT, programação agêntica virou ferramenta normal de trabalho.

Qualquer tarefa que consiste em copiar padrão, adaptar exemplo, rodar, olhar o erro e tentar de novo já está no alcance desses agentes. Front-end é o alvo mais visível porque acumulou uma quantidade absurda desse trabalho. O resto da programação não está protegido por alguma aura mística. Tem muito back-end que é CRUD, cola entre APIs e configuração repetida. Também será automatizado.

Pra mim, ótimo. Programar nunca foi digitar código. Programar é fazer um computador executar algo útil.

## VS Code é o novo cartão perfurado

Eu escrevi exatamente sobre isso em abril, em ["VS Code é o novo Cartão Perfurado"](/2026/04/11/vs-code-e-o-novo-cartao-perfurado/).

Por décadas, a interface entre intenção e computador mudou. Primeiro você ligava fios e chaves. Depois perfurava cartões. Depois escrevia Assembly, C, linguagens de alto nível, frameworks e configuração. Cada geração olhou pra anterior e automatizou uma camada de trabalho manual.

Ninguém em sã consciência defenderia hoje que operar uma perfuradora de cartões era a essência da ciência da computação. Era a interface disponível. Digitar cada tag e cada regra de CSS no VS Code também era a interface disponível.

Agora eu descrevo a intenção, mostro referências, avalio o resultado e mando o agente corrigir. Ainda preciso entender como navegador, rede, cache, acessibilidade, semântica, responsividade e SEO funcionam. Sem fundamento eu nem saberia dizer se o agente entregou uma solução ou uma bomba-relógio bonita. O teclado perdeu importância; julgamento ganhou.

Hoje, todos os modelos Tier A que eu testo, de Claude a Kimi, conseguem executar com confiabilidade o trabalho mecânico de front-end que apareceu nesses seis projetos. Eu consigo afirmar, sem hesitar, que qualquer tarefa de front-end que só transforma uma decisão já tomada em código é automatizável. Eles não inventaram seis designs brilhantes sozinhos, porém nenhum precisou que eu escrevesse manualmente o flexbox, o breakpoint ou o componente que já expliquei.

E isso não para no browser. [Escolha o framework](/2026/10/11/existem-linguagens-melhores-pra-programar-com-llms/): Android com Flutter ou Kotlin, iOS com Swift e SwiftUI, desktop com Rust/Tauri, Flutter, C# ou Electron. Em geral, agentes modernos conhecem os componentes, as ferramentas de build, os testes e as peculiaridades dessas plataformas. Ainda precisam de direção, feedback e verificação, exatamente como no front-end web. A parte mecânica já é automatizável.

Eu testei isso nos meus próprios projetos pequenos e abertos. O [FrankYomik](https://github.com/akitaonrails/FrankYomik) tem um cliente Flutter pra Android e Linux, além do servidor e da extensão. O [Frank Sherlock](https://github.com/akitaonrails/FrankSherlock) é um app desktop em Rust/Tauri que gera AppImage pra Linux, DMG pra macOS e instalador `.exe` pra Windows. Também fiz o [Frank Karaoke](https://github.com/akitaonrails/frank_karaoke) em Flutter pra Android e o [FRANK MANGA+](https://github.com/akitaonrails/frank_mangaplus) em Rust/Tauri pra desktop. Há vários outros no [meu GitHub](https://github.com/akitaonrails?tab=repositories).

Nenhum deles saiu perfeito no primeiro prompt. Flutter e Tauri me deram trabalho, especialmente nos primeiros projetos. Confiável quer dizer que o agente consegue avançar, receber uma correção, criar testes, corrigir o que quebrou e chegar num aplicativo funcional sem eu assumir a digitação braçal. Depois de testar web, Android e desktop em stacks diferentes, estou muito satisfeito com o resultado. O padrão se repete: trabalho mecânico virou trabalho de agente.

Às duas da manhã eu tinha agentes fazendo os últimos ajustes neste blog sem perder o ritmo. É disso que eu preciso.

## Quando a web ainda não sabia o que era

No auge da bolha da Internet, designers de carreira estavam criando sites. A web ainda não tinha decidido como uma página deveria funcionar, então havia espaço real pra experimentar. Era feio muitas vezes, pesado quase sempre, mas tinha criação acontecendo.

O iPhone abriu outra janela em 2007. De repente tudo precisava caber numa tela pequena, responder ao toque e funcionar sem mouse. Vieram anos de experimentação até o mercado formar uma gramática razoavelmente estável de navegação, gesto, formulário e conteúdo.

Hoje ninguém precisa redescobrir um menu, uma lista, um checkout ou uma página de artigo. Os padrões estão documentados, milhões de exemplos estão públicos e os modelos viram mais interfaces do que qualquer pessoa conseguiria estudar durante a vida.

O trabalho mais valioso continua existindo: entender o produto, a pessoa que vai usá-lo, as restrições e o que merece aparecer primeiro. O trabalho de converter uma decisão pronta em centenas de linhas previsíveis virou candidato perfeito à automação.

## Empregos desaparecem. Outros aparecem

O mundo nunca ficou parado pra preservar uma função.

Operadores de cartão perfurado digitavam dados e programas em papel. Telefonistas conectavam chamadas fisicamente. Datilógrafos mantinham escritórios funcionando. Linotipistas montavam linhas de metal quente pra imprimir jornais. A tecnologia reduziu ou eliminou essas ocupações em escala. A [lista atual de profissões em maior declínio do Bureau of Labor Statistics](https://www.bls.gov/emp/tables/fastest-declining-occupations.htm) ainda inclui digitadores, datilógrafos e operadores de telefonia. Ninguém propõe voltar a elas pra proteger emprego.

Ao mesmo tempo apareceram trabalhos que uma pessoa de 1926 nem conseguiria nomear: desenvolvedor mobile, SRE, designer de experiência, criador de vídeo pra Internet, especialista em nuvem, engenheiro de machine learning. A própria web matou trabalho antigo e abriu uma indústria inteira.

A história real é menos limpa do que a caricatura. A [OIT mostra que a tecnologia costuma automatizar tarefas sem necessariamente eliminar ocupações inteiras](https://www.ilo.org/publications/generative-ai-and-jobs-refined-global-index-occupational-exposure). Algumas funções encolhem, outras mudam e trabalhos novos aparecem. Esse consolo estatístico não resolve a vida de quem ficou obsoleto hoje. A pessoa precisa reagir antes que a média da economia reaja por ela.

Compare 2026 com 1926, três anos antes do crash de 1929. Parece outro planeta, embora um século seja muito pouco na escala da história. Não existe contrato garantindo que a sua função atual sobreviva aos próximos dez anos, muito menos aos próximos quarenta.

## Minha carreira nunca ficou no mesmo lugar

[Comecei com multimídia e sites estáticos](/2023/02/14/akitando-138-meu-comeco-de-carreira-durante-a-bolha-1997-a-2002-bug-do-milenio-crash/). Depois trabalhei em agência digital, consultoria enterprise, integração de SAP, startups, vídeo, educação e, agora, IA. No [Akitando sobre SAP](/2018/12/26/akitando-34-voce-nao-sabe-nada-de-enterprise-conhecendo-a-sap/), eu conto parte dessa fase em que precisei aprender um mundo completamente diferente do que fazia antes.

Atravessei o crash das pontocom, a crise de 2008 e o fim da bolha de juro zero. Sobrevivi porque nunca tratei a minha função do momento como identidade permanente. Continuei estudando, acumulando experiência e mudando de direção.

Uma carreira produtiva não deveria consistir em repetir a mesma tarefa mecânica por décadas. Se o seu valor depende de o mercado continuar pagando alguém pra empurrar tag e pixel à mão, o problema não começou com a IA. O problema foi apostar que o presente seria eterno.

Muita gente entende "estar preparado" como estudar o mínimo necessário pra vaga aberta hoje. Essa é a receita mais rápida pra ficar obsoleto. Faça o trabalho de curto prazo, mas estude além dele. Aprenda as coisas que parecem inúteis agora. Fundamentos, sistemas operacionais, redes, bancos de dados, negócio, economia, história. Você não sabe qual combinação vai salvar sua carreira daqui a cinco anos.

Eu passei anos falando disso no Akitando. Reveja as playlists [**Eu Avisei**](https://www.youtube.com/playlist?list=PLdsnXVqbHDUehzKjiRruy--gncHz9Injy) e [**Que curso devo fazer??**](https://www.youtube.com/playlist?list=PLdsnXVqbHDUd6wEL932R7dW9Zazt2oNWF). Se tiver que começar por um vídeo, comece pelo **Guia DEFINITIVO de Aprendendo a Aprender**. Curso nenhum salva quem ainda terceiriza o próprio aprendizado.

{{< youtube id="oUPaJxk6TZ0" >}}

O mundo não tem falta de oportunidade. A maioria das pessoas sente que nunca recebe uma porque está sempre despreparada quando ela aparece. Quando a oportunidade pousa na sua frente, já é tarde pra começar a preparação.

Portanto, eu não vou lamentar que o trabalho que levava meses coube em um dia. Estou feliz pra cacete. Ganhei tempo pra pensar no que construir, experimentar mais e jogar fora versões ruins sem desperdiçar semanas de vida.

Hoje eu vi um carro girar no ar e pousar. Em cerca de um dia, coloquei seis sites com visual novo em produção sem escrever a maior parte do HTML e CSS. O futuro que eu queria não chegou perfeito, barato nem distribuído igualmente. Mas chegou o bastante pra eu trabalhar com ele.

Aceite o que acabou. Estude o que vem depois. E esteja pronto antes da próxima oportunidade aparecer.
