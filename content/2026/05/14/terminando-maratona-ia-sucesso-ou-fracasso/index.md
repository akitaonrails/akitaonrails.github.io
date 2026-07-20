---
title: "Terminando Minha Maratona de IA: Sucesso ou Fracasso?"
date: '2026-05-14T14:00:00-03:00'
draft: false
translationKey: terminando-maratona-ia-sucesso-ou-fracasso
description: "Após mais de 500 horas em 24 repositórios, Akita ranqueia seus experimentos e conclui que Codex e Claude Code sustentam programação diária, mas sem revisão e XP a produtividade vira slop."
tags:
- vibe-coding
- agentes-de-codigo
- engenharia-de-software
---

Acho que finalmente saí do meu hiperfoco em IA. Quando comecei a acelerar em fevereiro e fui até quase maio, o objetivo era responder uma pergunta simples: dá ou não dá pra usar a nova geração de frontier LLMs da Anthropic e da OpenAI pra codar 100% do tempo? Resposta curta: dá.

Em vez de fazer um demo de 1 dia e arriscar um "eu acho que sim", resolvi ir all-in: mais de 500 horas, quase meio milhão de linhas de código e documentação, 24 repositórios entre públicos e privados.

Mas hoje me chamaram atenção pra um ponto que eu não imaginei que fosse gerar dúvida:

> "Todos os 24 projetos são perfeitos, modelos de excelência de código?" — **ABSOLUTAMENTE NÃO.**

Achei que isso fosse óbvio. Pra começo de conversa, se eu achasse que qualquer um deles fosse tão bom assim, já estaria abrindo uma startup em cima. Não me falta recurso pra investir. Se não estou fazendo isso, obviamente é tudo em ritmo de hobby.

Segundo ponto óbvio: se eu pulo de um projeto pra outro em poucos dias, é porque perdi o interesse. Se gostasse muito, estaria ajustando até hoje. Sempre falei nos vídeos: software nunca "acaba". Quando para, morre.

O objetivo era testar tipos diferentes de projetos pra ver como as LLMs se saíam em cada caso. Por isso tem projeto em Ruby on Rails, Rust, Go, Python, Crystal. Mais frameworks como Tauri e Flutter. Eu achava, por exemplo, que Flutter sendo bem popular, as LLMs não teriam muito trabalho. Tiveram. Conseguem avançar, só não tão suave quanto em Rails. Tauri foi "ruim" também. Crystal foi BEM ruim.

Terceiro ponto: todo projeto experimental virou "Frank". Sarcasmo, claro. Não tenho paciência pra inventar nome bonito num projeto que sei de antemão que vai ser one-off.

Eu uso meu GitHub basicamente como repositório de exercícios e experimentos. Olhem todos os repos do passado: quase nenhum é "projeto" de verdade que eu queira manter. Faço o que eu prego nos vídeos: pra aprender, exercite-se em MUITOS projetos, mesmo que a maioria seja pra JOGAR FORA. Ninguém aprende tentando fazer um único projeto perfeito. Veja meus vídeos [A Dor de Aprender](/2020/05/15/a-dor-de-aprender/) ou o [Guia Definitivo de Aprendendo a Aprender](/2020/05/16/guia-definitivo-de-aprendendo-a-aprender/).

No meio de vários projetos meia-boca, alguns emergem naturalmente como os que eu gosto e mantenho. Na prática joguei todos contra a parede pra ver quais grudam. Os melhores naturalmente atraíram mais contribuidores também. Não fico vendo Issues e PRs todos os dias. Vejo uma vez por semana. Há uns dois ou três dias dei uma passada e fechei tudo que estava pendente, por exemplo. Mesmo nos projetos que não gosto tanto, se chega PR, eu reviso e aceito. Não foi útil pra mim, mas pode ser útil pra outra pessoa.

## O ranking dos projetos

Pra ficar claro, segue um ranking dos projetos com comentário em cada um. As contagens de PR abaixo são não-dependabot (bump de gem não conta). A nota é minha estimativa de "quão estável e usável isso está no estado atual".

### Tier de cima (7-8/10)

**[ai-jail](https://github.com/akitaonrails/ai-jail) — 8/10.** O único que está bem próximo de uma release estável 1.0. Foi o que teve mais tração: 19 PRs fechadas, 23 Issues resolvidas. Recomendo usar, funciona muito bem.

**akitando-news (the M.Akita Chronicles) — 8/10.** Foi o que fiz com mais cuidado, no modo "Agile Vibe Coding" que descrevi alguns posts atrás. E é o que eu mexo com mais frequência. Sempre tem coisinha pra ajustar, coisas que vou colocando, tirando, experimentando. Tanto que está funcionando toda semana. Por isso também: é fechado e não pretendo abrir.

**[akitaonrails.github.io](https://github.com/akitaonrails/akitaonrails.github.io) — 7/10.** É este blog. Mexo com frequência e já fechei umas 7 Issues e 30 PRs de contribuidores. Continuo ajustando aos poucos.

**[FrankMD](https://github.com/akitaonrails/FrankMD) — 7/10.** Foi um dos primeiros que fiz, sem critério nenhum: só queria um editor que tivesse upload automático de imagem pro meu S3. Hoje uso Claude Code pra editar os posts, então só quem contribui é quem usa. Esse teve bastante tração, fechei 17 PRs e 29 Issues. Não é perfeito, mas está bom pra usar, pelo menos foi testado o suficiente.

**[easy-ffmpeg](https://github.com/akitaonrails/easy-ffmpeg) — 7/10.** Projetinho pequeno, mas esse eu uso de fato nos vídeos. Meu OBS sempre grava em MKV e, quando quero compartilhar, converto pra MP4. Casos de uso pequenos assim. Está bom o suficiente pra usar.

### Tier do meio (5/10)

**[distrobox-gaming](https://github.com/akitaonrails/distrobox-gaming) — 5/10.** É o mais recente, serve como "dump" de documentação dos meus retrogames. Uso como bloco de anotações e tem funcionado bem pro meu setup. Não estou preocupado que funcione pra mais ninguém. Quem quiser, manda PR.

**[llm-coding-benchmark](https://github.com/akitaonrails/llm-coding-benchmark) — 5/10.** Esse projeto não roda sozinho. Eu mando o Claude Code executar ele. O objetivo é tabular dados pra escrever os artigos sobre LLMs novas. O código deve estar BEM ruim.

**[FrankMega](https://github.com/akitaonrails/FrankMega) — 5/10.** É o mais próximo de um exercício "todo list". Eu só precisava compartilhar um arquivo grande com um amigo e pensei "hum, aposto que dá pra fazer um mini-mega em 1 dia". Foi isso. O nome é brincadeira, de jeito nenhum chega perto do Mega de verdade, óbvio.

**[distrobox-llm](https://github.com/akitaonrails/distrobox-llm) — 5/10.** Mais organização pessoal do meu PC: queria separar as ferramentas de IA num distrobox pra não ficar atualizando pacote grande toda hora.

### Tier de baixo (3-4/10)

**[FrankYomik](https://github.com/akitaonrails/FrankYomik) — 4/10.** Essa era uma ideia na minha cabeça há anos. Só queria ver se o conceito funcionava. Funciona. Mas rodar LLMs locais pra isso é lento e não tão prático quanto eu gostaria. É o único que ainda devo voltar pra mexer mais, porque realmente quero usar. No estado atual, está em "funciona, mais ou menos".

**[NW-Omarchy](https://github.com/akitaonrails/NW-Omarchy) — 4/10.** Outro experimento de "será que dá?", que durou 2 dias. O conceito funcionou, mas não pretendo fazer muito mais que isso. Fica pra quem tiver interesse de continuar. Na prática eu quis testar se em X11 ficaria MUITO mais ruim que em Wayland. O gap é menor do que eu esperava, mas realmente não me vejo usando no dia a dia. Como já falei, pro nicho de pessoas que não tem como usar Wayland, é uma boa alternativa.

**[frank_investigator](https://github.com/akitaonrails/frank_investigator) — 3/10.** Comecei, mas não tive saco pra continuar. Plantei as sementes da ideia. Se ninguém mandar PR, vai evoluir pouco. Precisa de mais pesquisa e muito mais teste.

**[frank_fbi](https://github.com/akitaonrails/frank_fbi) — 3/10.** Mais um que quis testar o conceito, sem uso pessoal — nunca caí em phishing. Não sei pra onde levaria isso ainda.

**[frank_karaoke](https://github.com/akitaonrails/frank_karaoke) — 3/10.** Nasceu de uma conversa de fim de semana com meus irmãos. Mais uma tentativa de usar Flutter (e ver como tem limitação tanto no Flutter quanto nas LLMs usando Flutter). Serviu pra eu aprender sobre o ecossistema de karaokê e descobrir que pontuação de verdade só com metadado específico por música. Então não avancei muito além de brinquedo.

### Fundo do poço (1-2/10)

**[FrankSherlock](https://github.com/akitaonrails/FrankSherlock) — 2/10.** Eu mesmo não uso. Por isso deve estar cheio de bug que precisa de correção. Foi teste pra ver se dava pra fazer um app Tauri, mas perdi o interesse rápido. Ainda dá pra melhorar, mas precisa de muito mais horas de uso, testes e correções. Foi a primeira vez que usei Tauri, então essa parte deve estar bem ruim também.

**[FrankClaw](https://github.com/akitaonrails/FrankClaw) — 1/10.** Eu mesmo não uso, e esse é o único que eu nem rodei uma única vez. O exercício foi só ver a dificuldade de traduzir o openclaw original de TypeScript pra Rust. Mas, como já postei várias vezes, não vejo utilidade no openclaw pra mim. Quando terminei a versão 0.1, parei. Ainda assim teve 6 PRs que fechei. Se alguém estiver interessado, pode contribuir.

**[shadPS4](https://github.com/akitaonrails/shadPS4) — 1/10.** Apesar de ter gerado muito código e muita documentação, nada foi pensado em virar contribuição. Foi exclusivamente aprendizado e pra resolver um problema muito específico. Deixei aberto pra mostrar como código puramente de material de estudo se parece.

**[easy-subtitle](https://github.com/akitaonrails/easy-subtitle) — 1/10.** Comecei, perdi o interesse, nunca parei pra testar de verdade. Só dei push e esqueci.

### Os privados

Além do akitando-news, tenho no meu Gitea privado coisas como `my-omarchy-config`, `emulators-reorg-2026`, `thinkpad-omarchy-config`, `homelab-docs`, `akitando_english_translation` etc. Não vou descrever porque vocês nunca vão ver. Servem como "scratchpads" pro Claude Code administrar minhas máquinas.

## O que esse ranking diz

Notem: não tem nenhum projeto que eu fiz que considero 10/10.

Pra um projeto sair de hobby e virar projeto de verdade, precisa de usuários e feedback. Se ninguém usa, sempre vai ter dezenas de bug funcional que nunca vai ser corrigido, porque ninguém esbarrou neles. Projeto sem usuário está morto.

Por isso eu repito nos vídeos: não existe planejar em detalhes, escrever um monte de código, e uma hora "terminar". Não. Quando você acha que "terminou", na verdade é a versão 0.1. Aí começam os meses de experimentação com usuário real reportando bug. Sair corrigindo. Dessas correções saem refatoramentos, mudanças de arquitetura porque as premissas iniciais estavam erradas comparado ao uso real. Software NUNCA acaba.

## O resumo do aprendizado dessa maratona

16 horas por dia, todos os dias, vibe coding, sempre vai sair com slop. Não tem jeito. Não adianta forçar quantidade. Tem que revisar manualmente, commit a commit, PR a PR. Por que eu não fiz isso em todos? Simples: não estou sendo pago. Fiz em uns 2 ou 3 projetos. O resto eu só queria testar o conceito e seguir pro próximo.

A forma correta é o que reportei vários posts atrás: "Agile" Vibe Coding. É meu jeito sarcástico de dizer "use XP e técnicas normais de engenharia de software". Métricas, monitoramento, CI, etc. etc. Nada disso mudou. Sem isso, vai acabar como vários dos meus exercícios: one-off pra jogar fora.

Não tenha vergonha de subir projeto "ruim". O que eu não pensei é que tem gente que assume que, só porque subi código, eu acho que é perfeito. Mas isso é o que essas pessoas fazem: acham que só vale a pena subir código bem feito, por isso nunca sobem nada. Eu já disse VÁRIAS vezes e demonstro: não ligo pro meu código, não tenho apreço pelo meu código, GitHub é diretório temporário de dump de qualquer coisa. Os que eu realmente gosto, normalmente estão privados.

Projeto realmente bom não basta "dizer" que é bom. Coloque seu dinheiro onde está sua boca: abra um negócio em cima, cobre dos usuários, entregue qualidade. Eu estou aposentado, não preciso cobrar nada, mas também não tenho vontade de trabalhar de graça. No momento que o código parou de me divertir, eu abandono e pulo pro próximo. Os que me interessaram mais (ai-jail, M.Akita Chronicles) continuo com mais frequência. Simples assim.

Como eu esperava, e como mostrei tanto nesses projetinhos quanto no benchmark, a escolha é simples: use GPT Codex ou Claude Code num dos planos subsidiados. Não pague por token. É onde está a produtividade 5x (máximo 10x, com slop junto). Sim, tem Kimi v2.6 ou DeepSeek V4 Pro. Mas adianto: os projetinhos abaixo de nota 5 virariam projetinhos abaixo de nota 2 com eles.

## O ponto que mais importa

IA não substitui um bom programador. IA reflete e acelera quem você é. Se é um bom programador, a IA acelera bom código. Se é um mau programador, a IA acelera mau código.

Foi exatamente o que eu mostrei: a maior parte dos projetos que eu fiz eram one-off e teste de conceito. Mau código, sem interesse de continuar. A IA acelerou eu terminar esses testes de forma meia-boca. Pra mim está ótimo: sem a IA eu nem teria começado. Agora que vi como fica, posso riscar da minha lista e seguir em frente.

O que importa é qual é seu OBJETIVO. Se for fazer um negócio e cobrar de gente, tem que ter 10x mais cuidado do que eu tive. Tudo que eu faço é pra jogar fora. Não preciso ganhar dinheiro com nenhum desses projetos. Não assumam coisa que eu nunca falei.
