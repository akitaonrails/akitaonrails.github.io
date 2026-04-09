---
title: "20 Anos de Blog: Traduzindo Tudo pra Inglês"
date: '2026-04-09T08:00:00-03:00'
draft: false
translationKey: 20-years-of-blog-ai-finally-translated-everything
tags:
  - blog
  - ai
  - llm
  - themakitachronicles
  - off-topic
description: "Quatro dias atrás completei 20 anos de blog. E por coincidência, quando eu ia escrever esse post, resolvi fazer algo que nunca tinha tido fôlego pra fazer: traduzir todo o blog pra inglês. Com Claude Code, num fim de semana."
---

![20 ANOS em letras grandes brilhantes em estilo neon-tech, com taças de champanhe, sparklers, confete e silhuetas de monitor CRT e código no fundo, paleta roxa com acentos ciano e magenta](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260409_20years_blog_celebration.png)

Quatro dias atrás, 5 de abril de 2026, meu blog completou 20 anos. Eu sei, eu atrasei o post comemorativo. Mas tem um motivo, e esse motivo é o assunto desse texto.

Eu comecei em 2006 no Blogspot do Google, como a maioria fazia na época. Depois migrei pra um CMS em Rails 2.0 que já existia, passei pelo Typo3, e lá em 2012 [fiz minha própria engine do zero em ActiveAdmin](/2025/09/10/meu-novo-blog-como-eu-fiz/), que fui arrastando de Rails 3 até Rails 7. Só recentemente, em setembro de 2025, finalmente larguei essa engine própria e fui pro [Hugo com o tema Hextra](/2025/09/10/meu-novo-blog-como-eu-fiz/), que é onde esse post está rodando agora. Vinte anos carregando os mesmos posts de Textile, migrando de Less pra Sass, trocando Liquid por Markdown, e removendo lixo obsoleto ao longo do caminho.

## Duas décadas, cinco eras

Uma coisa que poucos programadores param pra refletir é o quanto o mundo de tecnologia muda em 20 anos. Eu já falei sobre isso no [Akitando #37 - A Dimensão do Tempo](/2019/01/30/akitando-37-a-dimensao-do-tempo-para-iniciantes-em-programacao-serie-comecando-aos-40/). Quando eu abri esse blog em abril de 2006, eu já tinha 10 anos de experiência. Já tinha visto a bolha da internet subir e explodir em 2000. E desde então ainda vi mais umas quantas: a ascensão das redes sociais (Orkut, Facebook, Twitter), a revolução do smartphone e do app móvel em 2008, a crise econômica de 2008, o nascimento do Bitcoin em 2009, a era da nuvem e do SaaS, agora a era da IA generativa.

Eu vi essas ondas estourarem na prática. Cada uma delas mudou completamente como a gente trabalha e quem sobrevive profissionalmente. Esse tipo de coisa a gente só enxerga olhando de longe, depois de acumular umas quantas viradas.

Minha carreira em si passou por viradas drásticas. Contei em detalhe nos [Primeiros 5 Anos (1990-1995)](/2019/09/12/akitando-61-meus-primeiros-5-anos-1990-1995/), mas resumindo: comecei em agências de multimídia, migrei pra [consultoria enterprise trabalhando com SAP](/2018/12/26/akitando-34-voce-nao-sabe-nada-de-enterprise-conhecendo-a-sap), abandonei tudo em 2006 pra entrar em Ruby on Rails e open source, passei uma década organizando evento, principalmente a Rubyconf Brasil de 2007 até 2018, depois fechei a porta do evento e comecei o canal [Akitando no YouTube](https://www.youtube.com/@Akitando), que cresceu pra mais de 500 mil inscritos. No meio disso teve a pandemia que reorganizou a vida de todo mundo. E agora, desde o começo de 2025, virei pesquisador e usuário em tempo integral de IA, rodando modelos localmente e quebrando coisas com Claude Code até elas funcionarem.

Olhando pra tag [/tags/ai](/tags/ai), eu escrevi 51 posts relacionados a IA só entre 2025 e 2026 — 19 em 2025 e mais 32 em 2026, que mal começou. Antes de 2025, entre 2018 e 2024, o blog basicamente virou o arquivo dos transcripts dos vídeos do Akitando. Eu filmava o vídeo, fazia o transcript, jogava no blog, e as pessoas liam lá. Mas desde que eu voltei a escrever ativamente, notei que tinha uma audiência leal que nunca foi embora, mesmo nos anos quietos. E foi esse feedback que me fez começar [The M.Akita Chronicles](/tags/themakitachronicles), uma série mais pessoal contando os bastidores de projetos recentes.

## O problema que eu nunca resolvi

Durante esses 20 anos, uma coisa me incomodava. Como o conteúdo é todo em português, fica inacessível pra todo mundo que não lê a língua. E faz uns bons anos que eu venho recebendo mensagens de leitores brasileiros morando fora (Portugal, Estados Unidos, Japão, Alemanha, Canadá) pedindo alguma versão em inglês pra compartilhar com colegas gringos. Coisa tipo "olha, eu mostraria esse texto pro meu time, mas só tá em português."

Eu sempre disse "um dia eu traduzo." E nunca traduzi. Por quê? Porque são centenas de posts. Passei os últimos dois dias olhando os números: 727 arquivos `index.md` em português no repositório. Traduzir tudo à mão, um por um, ia tomar semanas se não meses de trabalho dedicado. Eu nunca ia ter fôlego pra isso. E a cada ano que passava, mais posts se acumulavam pra traduzir.

A ironia é que alguns posts do blog nasceram em inglês. Durante 2017 e 2018 eu tinha decidido escrever primeiro em inglês pra tentar alcançar audiência internacional. Uma série inteira de entrevistas, as "[chatting-with](/2008/01/09/chatting-with-hal-fulton/)" com gente tipo Hal Fulton, Scott Hanselman, Chris Wanstrath (do GitHub), Blaine Cook (ex-Twitter), Adam Jacob (Chef), nasceram em inglês e ficaram lá. Faltava o inverso: pegar os posts em português e traduzir pro outro lado.

## O fim de semana que consertou 20 anos de dívida técnica

Na segunda passada eu abri o Claude Code dentro do diretório do blog. E pedi pra ele traduzir tudo pra inglês. Foi literalmente isso.

Começou na segunda-feira, dia 6 de abril, por volta das 18:30h. Eu deixei rodar. Fui dormir. Acordei terça, continuei rodando. Dormi de novo. Quarta de manhã cedo ele terminou. Contando o tempo total do primeiro commit de tradução até o último, foi algo como 39 horas. Mas não foi contínuo, teve noites, almoços, uma roda de café. Na prática, um fim de semana estendido de trabalho.

O resultado tá no repositório git, em commits que qualquer um pode inspecionar no [repositório público do blog](https://github.com/akitaonrails/akitaonrails.github.io). Olhando rapidamente o log, dá pra ver a cadência: lote de posts de 2008 QCon. Lote de 2009 RailsConf. Lote de 2011 Objective-C. 2012 completo. 2015 série Elixir. 2016, 2017, 2018 completos. Lote depois de lote, organizados por ano e por série. Mais de 80 commits marcados como `i18n:` ou `EN translation:` entre o começo da noite do dia 6 e a manhã do dia 8. No final desse post, abri 354 arquivos `index.en.md` contra os 727 `index.md` originais. Quase metade do blog inteiro traduzido de um só golpe.

E olha, noventa por cento foi tranquilo. A tradução ficou boa, natural, fiel à minha voz no original — eu não imaginava que ia funcionar tão bem. Claude Code respeita o tom do texto se você der instruções boas de voz e estilo, e mostra respeito por ideias técnicas sem "corrigir" nada do que você escreveu. No pior caso, revisa alguns parágrafos. No melhor caso, a versão em inglês soa como se você tivesse escrito direto na outra língua.

Um parênteses sobre o custo do lado Claude. Eu sou assinante do plano Max 20x da Anthropic, que é o tier de uso pesado feito pra quem abusa do Claude Code o dia inteiro. Nunca tinha batido no teto dele antes, nem nas minhas sessões mais intensas de vibe coding. Esse fim de semana de tradução foi a primeira vez que eu realmente estourei o limite do Max 20x e continuei usando já no modo de "uso extra" (a Anthropic cobra por consumo acima do teto do plano mensal).

Pra ter uma ideia do estrago, esse é o painel da minha conta agora de manhã:

![Plano Max 20x com 91% da quota semanal 'all models' consumida e R$280,88 já gastos em uso extra](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260409_claude_usage_max20x.png)

**91% da quota semanal "all models" consumida**, já pra dentro do modo de uso extra, R$280,88 (uns $50 USD) gastos em cima da mensalidade fixa, e ainda falta um bom pedaço do ciclo. Faz sentido: ler o post inteiro, gerar a tradução, aplicar o humanizer em cima, repetir centenas de vezes seguidas. A quantidade de tokens envolvida é massiva. E hoje, enquanto eu escrevo esse texto, o Claude Code tá me dando com frequência crescente o erro `API Error: Request rejected (429) · Rate limited`, o que também faz sentido: deve ser um combo de quota do meu plano e do Anthropic aplicando backpressure geral, porque eu não devo ser o único fazendo loucura esses dias. Ok, normal. É o preço de ter usado a ferramenta pesado quando fazia diferença.

Os outros dez por cento foram uma história separada.

## Quando os LLMs comerciais dizem "não"

Meia dúzia de posts antigos se recusaram a ser traduzidos. Tanto Claude quanto GPT, pela API, caíam num erro 400 com mensagem de política de conteúdo. Tentei várias vezes, em sessões frescas, com contexto limpo. Nada.

A hipótese é simples: esses posts tocavam em tópicos sensíveis pra content moderation automatizado. Um post de 2009 sobre o discurso do Steve Jobs em Stanford de 2005 (que menciona câncer, já que o Jobs estava falando do diagnóstico terminal que ele tinha recebido). Dois capítulos antigos da Ayn Rand, traduzidos por mim anos atrás, sobre direitos do homem e argumentação. Um post anti-nazista que ironicamente foi bloqueado provavelmente só porque a palavra "nazi" aparecia lá, mesmo com o contexto sendo crítico. Um post sobre o discurso do dinheiro do Atlas Shrugged. E um ensaio sobre democracia e ética que travava sistematicamente todas as tentativas.

A ironia dessa parte é que o único jeito de conseguir traduzir esses posts foi usando um modelo open source. Carreguei o [Qwen 3.5 35B](https://qwen.ai) no llama-swap, rodando localmente, sem filtros de política corporativa. O modelo leu, entendeu o contexto, e traduziu tudo sem drama. É o mesmo modelo que eu tinha [testado extensivamente no meu último benchmark de LLMs](/2026/04/05/testando-llms-open-source-e-comerciais-quem-consegue-bater-o-claude-opus/), e que eu avalio como um dos melhores open source disponíveis hoje.

Ou seja: um modelo chinês conseguiu traduzir posts que modelos ocidentais recusaram. Eu não consigo deixar de achar isso levemente hilário. Ah, claro, e não posso falar mal da China (sarcasmo). LLMs comerciais vão sempre ter o problema de política corporativa e censura preventiva aplicada com régua meio grossa. É um trade-off real pra quem quer usar eles em produção: você ganha fluência e capacidade de raciocínio, perde controle quando o tópico resvala no que a empresa decidiu que é sensível.

## O caso inverso: 2017-2018 traduzido pro português

Enquanto eu estava ajustando o Claude Code pra gerar o conteúdo em inglês, aproveitei pra resolver o problema simétrico. Os posts que eu tinha escrito originalmente em inglês durante 2017 e 2018, mais a série inteira de entrevistas "chatting-with" de 2008, estavam parados lá sem versão em português. Claude Code rodou o reverso: leu o inglês, gerou o português. Então se você não leu os originais em inglês (porque a maioria do meu público é brasileiro mesmo), agora você tem acesso também. Dá uma olhada na [seção Off-Topic](/off-topic/) pra ver o que apareceu de novidade.

Junto disso, o Claude Code também atualizou o script `generate_index.rb` pra entender a estrutura bilíngue do blog e gerar dois índices separados, um em português e outro em inglês. O seletor PT/EN no rodapé de cada post aparece automaticamente quando existe o arquivo `index.en.md` irmão. Tudo bem integrado ao Hugo, seguindo o padrão nativo de multilíngue dele.

## O ponto mais amplo

Aqui tá o recado que eu queria deixar nesse post de aniversário. Tradução em escala, centenas de artigos, conteúdo seu, na sua voz, respeitando o tom do original, era um problema caro e chato. Agora é um problema de fim de semana. Isso já tá no ar, você tá lendo o resultado. A barreira que existia pra alcançar audiência fora do Brasil virou algo barato o suficiente pra eu não ter mais desculpa.

Então, vamos lá, recapitulando o aniversário. 20 anos. 727 posts em português, construídos ao longo de cinco eras diferentes de tecnologia. 354 novos posts em inglês gerados num fim de semana. Metade do blog agora é bilíngue. E o resto vai indo. Os que faltam são principalmente posts antigos de ActiveAdmin, Rails 2 e dicas obsoletas que já faz sentido deletar ou não traduzir de propósito.

Se você tem amigo gringo que já cansou de ver você postando link em português e precisa de uma desculpa pra mandar alguma coisa minha, manda. Os posts principais sobre IA, os [Chronicles](/tags/themakitachronicles), benchmarks, rants e boa parte do arquivo histórico já tão disponíveis em inglês no mesmo domínio, é só trocar o toggle no rodapé. Obrigado a todo mundo que acompanhou esse blog por esses vinte anos. Tem leitores aqui que me conhecem desde o Blogspot. Vocês sabem quem são.

Vamos pra mais um ano.
