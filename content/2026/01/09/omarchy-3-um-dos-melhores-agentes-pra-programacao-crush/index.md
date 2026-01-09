---
title: "Omarchy 3 - Um dos Melhores Agentes pra Programação: Crush"
slug: "omarchy-3-um-dos-melhores-agentes-pra-programacao-crush"
date: 2026-01-09T20:01:04-0300
draft: false
tags:
- omarchy
- AI
---

Ano passado eu estava recomendando o [Aider](https://aider.chat/) como agente pra auxiliar programação. Mas sinto que ele meio que parou no tempo. Comparado com os Cursor ou Windsurf da vida, ficou bem pra trás.

Felizmente, no mundo open source existem novas opções. O DHH resolveu trazer o [OpenCode](https://opencode.ai/) no Omarchy 3.x.

[![dhh opencode](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260109200839_screenshot-2026-01-09_20-08-17.png)](https://x.com/dhh/status/2007589042485883374)
Depois que fiz o upgrade (rodar `omarchy-update`) vi que também veio a opção de instalar o que estou começando a usar agora, o [**CRUSH**](https://github.com/charmbracelet/crush).

Crush é do mesmo pessoal que vem fazendo diversas bibliotecas pra facilitar desenvolvimento de TUIs (Terminal User Interface Apps), como o [BubbleTea](https://github.com/charmbracelet/bubbletea) e [Gum](https://github.com/charmbracelet/gum). Recomendo olhar esses repositórios também. É muito mais interessante fazer apps pra terminal, hoje em dia, especialmente ferramentas pra dev ou Linux em geral.

É um TUI muito bem feito. Essa é a cara dele:

![Crush UI](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260109202710_screenshot-2026-01-09_20-26-58.png)

Como primeira impressão, rodei no meu projetinho deste blog, que é um site estático gerado pelo [Hugo](https://akitaonrails.com/2025/09/10/meu-novo-blog-como-eu-fiz/).

Como eu já tenho variáveis de ambiente pra [OpenRouter](https://openrouter.ai/docs/quickstart), nem precisei configurar nada. Só rodar `crush` no diretório do projeto.

A primeira coisa que fez foi analisar meu projeto. Como é pequeno, foi bem rápido. Não sei como lida com projetos gigantes. Mas sai vasculhando o código-fonte e no final anota tudo num arquivo [AGENTS.md](https://github.com/akitaonrails/akitaonrails.github.io/blob/master/AGENTS.md). E fiquei impressionado que fez um excelente trabalho em resumir o projeto, veja um trecho:

![agents.md](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260109201559_screenshot-2026-01-09_20-15-47.png)
Eu nem sabia que tinha a opção de rodar `scripts/dev.sh new-post` pra automaticamente gerar o sub-diretório com timestamp pra um novo post. Eu estava fazendo manualmente toda vez 😅.

Eu sabia que meu script de [`scripts/generate_index.rb`](https://github.com/akitaonrails/akitaonrails.github.io/blob/master/scripts/generate_index.rb) estava meio bagunçado então perguntei ao Crush se ele conseguiria refatorar:

![refactor generate_index](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260109201839_screenshot-2026-01-09_20-18-30.png)
No final ele refatorou bonitinho, sem introduzir novos bugs, sem reescrever coisas que não precisa. Melhorou muito mesmo refatorar só o que precisa. Mudou coisas como usar `Dir.glob` em vez de `Find.find`, trocou pra usar symbols em vez de strings (mais idiomático), etc.

Gostei que ele roda a versão modificada e checa se continua executando como deveria.

Segui pedindo pra fazer a mesma coisa com o [`scripts/dev.sh`](https://github.com/akitaonrails/akitaonrails.github.io/blob/master/scripts/dev.sh):

![refactor dev.sh](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260109202153_screenshot-2026-01-09_20-21-44.png)
E nesse caso ele até encontrou um bug que eu não tinha percebido. Novamente, ele editou esse shell script pra deixar mais seguro, separou constantes, melhor checagem de erro, etc.

Este é o [commit com as modificações](https://github.com/akitaonrails/akitaonrails.github.io/commit/440470b09e822af0dc23a7c6aec73b4ead89caf7). Dêem uma olhada. Ele realmente não colocou nenhum código desnecessário. Tudo continua funcionando como antes, mas agora está mais organizado. E ainda corrigiu um bug que eu não tinha visto.

Neste pequeno exemplo, escolhi usar o modelo **Claude Opus 4.5**. Todo o código foi gerado por ele. O Crush é só um Agente que usa o modelo e instrui com o contexto adequado.

Por enquanto só fiz coisas bestas e simples. Diz a documentação que ele integra com LSPs e MCPs pra ter ainda mais contexto sobre o código, mas não testei isso ainda.

De qualquer forma, resolvi fazer um post rápido só pra dizer que essas novas opções como Crush e OpenCode já estão muito boas pra usar no dia a dia. Vale a pena testar no seu projeto.
