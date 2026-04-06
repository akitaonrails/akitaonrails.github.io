---
title: "Omarchy 3 - Um dos Melhores Agentes pra Programação: Crush"
slug: "omarchy-3-um-dos-melhores-agentes-pra-programacao-crush"
date: 2026-01-09T20:01:04-0300
draft: false
translationKey: omarchy-3-crush
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

### Segundo Teste

Como o Crush se deu bem com esse teste básico de web, resolvi pegar o desafio que fiz ano passado. Fiz um pequeno projeto de linha de comando que é um chat básico, feito do zero, usando direto a biblioteca llama.cpp, com CUDA, e em Zig - que é uma linguagem de baixo nível, ainda experimental e inacabada. Justamente o desafio é porque pouca gente usa, então tem pouca documentação e exemplos. A LLM vai ter que suar pra fazer funcionar.

Diferente de uma página Web com React e Tailwind - que tem milhares de posts em fóruns, tutoriais, blog posts e tudo mais, Zig não tem quase nada. O único app popular que eu conheço que usa Zig é o Ghostty.

Pra piorar, saiu versão nova recentemente, a 0.15, que muda bastante toda a API de IO (em preparação pra suportar melhor coisas como Async IO). Saiu versões novas de Llama, Cuda, etc. Então a idéia seria usar o Crush com Claude Opus pra ver se consegue refatorar, consertar bugs, atualizar as APIs e conseguir chegar até o ponto de compilar um binário que funciona.

Em resumo: **conseguiu!**

![crush - qwen-cli-zig](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260109211613_screenshot-2026-01-09_21-15-57.png)
Na primeira rodada de refatoramento, consumiu só USD 5.64 de crédito da minha conta na Anthropic. Conseguiu pegar o macarrão monolítico (que eu fiz de propósito como desafio) em arquivos menores como `chat.zig` e `llama.zig`.

Conseguiu mapear as funções em C do Llama como funções no Zig. Conseguiu descobrir que coisas como ArrayList mudaram no Zig novo. Conseguiu descobrir que todas as APIs de IO mudaram no 0.15. E conseguiu modificar os lugares certos.

Ele foi rodando `zig build`, checando os erros e fazendo correções que fazem sentido, até conseguir gerar o binário final.

Vocês podem checar o [Pull Request](https://github.com/akitaonrails/qwen-cli-zig/pull/1/files) com tudo que ele fez. Foi uma mudança bem razoável e não deixou o projeto quebrado.

![llama.cpp externs](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260109212115_screenshot-2026-01-09_21-21-03.png)
O fato dele ter conseguido consultar a documentação do Zig 0.15, também inferir corretamente quais funções novas do Llama.cpp deveria fazer extern, foi bem impressionante.

De qualquer forma, na primeira rodada, ele conseguiu chegar até o ponto onde compila. Mas não significa que funciona. E de fato, quando tentei executar, terminou com um segmentation fault:

![qwen-cli-zig segmentation fault](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260109213331_screenshot-2026-01-09_21-33-22.png)

Então pedi ao Crush pra executar e checar esse erro. Ele encontrou o bug e fez as modificações necessárias. Ele encontrou uma struct errada e ainda encontrou um problema de memory leak. Resolveu ambos os problemas e agora o programa roda como deveria:

![qwen-cli-zig](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260109213702_screenshot-2026-01-09_21-36-23.png)
Como disse antes, é um programinha besta de chat, que usa Llama.cpp direto pra carregar o modelo Qwen3 e abrir um chat pra eu conversar. É só um exercício porque um chat assim já existe, basta usar o Ollama. Mas eu queria fazer um do zero, em baixo nível, como exercício pra LLMs. Até ano passado nenhuma LLM que eu testei conseguiu finalizar esse programa de forma adequada. Mas agora foi.

![crush explanation of the crash](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260109213930_screenshot-2026-01-09_21-39-22.png)

E como podem ver, no final gastei quase 8 dólares pra refatorar, consertar os bugs, e fazer esse programa funcionar corretamente. Não foi barato, mas pelo menos não foram créditos jogados fora, como acontecia 1 ano atrás. Não testei com LLMs locais ainda, pra ver se o Crush consegue chegar em resultados semelhantes.

Mas se ele consegue lidar com uma linguagem obscura como Zig me deixa bem animado pra brincar mais com isso. Finalmente as ferramentas e LLMs chegaram num ponto que realmente é prático de usar. Não estou dizendo que resolve tudo, mas comparado com 1 ano atrás, foi um salto significativo.

Recomendo muito testar Crush com outros modelos. Eu só brinquei um pouco com o Opus mas outros modelos podem dar resultados diferentes dependendo do problema que está tentando resolver.
