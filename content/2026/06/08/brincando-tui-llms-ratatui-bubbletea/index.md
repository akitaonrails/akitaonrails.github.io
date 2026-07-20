---
title: "Brincando de TUI com LLMs - Ratatui+Bubbletea"
date: '2026-06-08T16:00:00-03:00'
draft: false
translationKey: brincando-tui-llms-ratatui-bubbletea
description: "Criei o ratatui-bubbletea para dar ao Ratatui temas e componentes inspirados no Bubble Tea, usando Rust e LLMs. O toolkit já alimenta TUIs reais como o ai-usagebar sem substituir a biblioteca base."
tags:
- ai-usagebar
- ferramentas-de-desenvolvimento
- rust
- open-source
---

Antes de falar do brinquedo novo, um lembrete rápido: [ai-jail](https://github.com/akitaonrails/ai-jail) e [ai-memory](https://github.com/akitaonrails/ai-memory) continuam recebendo bastante atenção. Issues, pull requests, pequenas correções, melhorias de empacotamento, bugs de ambiente, ajustes de documentação. Aquelas coisas que ninguém vê num post de lançamento, mas que transformam experimento em ferramenta que dá pra usar todo dia.

Eu gosto dessa fase. O projeto deixa de ser "o que eu imaginei no meu setup" e vira "o que quebra na máquina de outra pessoa". Aí aparece Windows, macOS, Arch, AUR, path esquisito, token salvo em lugar diferente, shell diferente, terminal diferente. Chato? Sim. Necessário? Também.

Mas o prato principal de hoje não é ai-jail nem ai-memory. É TUI. Mais especificamente, é minha mania recente de escrever pequenas ferramentas de terminal em Rust com [Ratatui](https://ratatui.rs/), mas querendo que elas fiquem com cara de [Bubble Tea](https://github.com/charmbracelet/bubbletea).

## O app que não vou abrir

Nas últimas semanas também mexi num projeto privado que não pretendo abrir. É uma TUI pra acompanhar minha conta nos EUA, investimentos, assets, posições, covered calls, open calls, essas coisas chatas de adulto. Não vou publicar o código porque é o tipo de ferramenta que nasceu colada no meu fluxo financeiro, nas minhas planilhas, nos meus extratos e nas minhas gambiarras internas. Abrir isso seria transformar uma ferramenta minha em suporte gratuito pra bug de banco dos outros. Tô fora.

Mas dá pra mostrar a cara geral. Censurei o que precisava censurar:

**Observação óbvia, mas vou deixar explícito: todos os valores, tickers, posições e datas mostrados no screenshot são dados falsos de demonstração. Não é dado real da minha conta, nem portfolio real, nem recomendação de investimento.**

![TUI privada de portfolio em terminal, com abas de dashboard e tabela de holdings. O nome do banco foi censurado.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/06/08/ratatui-bubbletea/private-portfolio-censored.png)

![TUI privada mostrando uma visão de alocação por classe de asset, com nomes sensíveis censurados.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/06/08/ratatui-bubbletea/private-allocation-censored.png)

![TUI privada mostrando uma aba de open calls com dados falsos de demonstração e nomes sensíveis censurados.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/06/08/ratatui-bubbletea/private-open-calls-censored.png)

Toda vez que faço uma TUI pequena, a mesma dúvida aparece: que stack usar?

Se eu fosse escrever tudo na unha, provavelmente escolheria Python ou Go. São linguagens mais confortáveis pra esse tipo de utilitário pequeno. Python porque é direto, cheio de biblioteca, ótimo pra script que conversa com API e parseia JSON. Go porque gera binário simples, cruza plataforma bem, e tem ergonomia boa pra CLI.

Só que hoje eu raramente escrevo esse código todo na unha. Eu orquestro Claude, Codex, OpenCode, mando revisar, mando refatorar, mando testar. Nesse cenário, a falta de ergonomia do Rust pesa menos, porque quem briga com borrow checker, trait bound e lifetime chato é o LLM. Eu fico mais no papel de revisor e usuário final. E aí Rust começa a ficar muito atraente.

Ferramental bom. `cargo` é ótimo. Testes são fáceis de rodar. Cross compile é administrável. O binário final é limpo. Erro de memória idiota praticamente some. Não estou dizendo que Rust é magicamente melhor que Go ou Python pra toda TUI. Não é. Mas com LLM escrevendo a maior parte, o custo que normalmente me faria evitar Rust cai bastante. E os modelos atuais estão surpreendentemente competentes em Rust, desde que você mande rodar teste, consertar warning e não aceite a primeira versão como se fosse revelação divina.

## Ratatui é bom, mas eu queria a cara do Charm

O [Ratatui](https://ratatui.rs/) é uma biblioteca Rust pra construir interfaces ricas no terminal: dashboards, apps interativos, tabelas, listas, gauges, layouts, tudo aquilo que antigamente a gente chamava de "ncurses moderno". Ele é o sucessor espiritual do `tui-rs`, e hoje é provavelmente o caminho mais óbvio se você quer fazer TUI séria em Rust.

Ratatui funciona bem. O problema é gosto pessoal: por padrão, não acho bonito. Não é feio no sentido "isso parece programa de DOS de 1993". Dá pra fazer coisa boa. Mas muita TUI em Ratatui cai naquela estética quadrada, cinza, funcional, meio admin panel de datacenter.

Eu gosto mais da pegada da [Charmbracelet](https://charm.sh/). O `gum`, por exemplo, é uma coleção de comandos pra deixar shell script interativo sem virar festival de `read -p` e `case`. Prompt, select, filter, spinner, tabela, pager, estilo. Você monta um script bash com cara de app decente em minutos.

E tem o [Bubble Tea](https://github.com/charmbracelet/bubbletea), em Go, inspirado na arquitetura Elm. Você tem um model, recebe mensagens, atualiza estado, renderiza uma view. É uma ideia simples e muito boa pra terminal: estado entra, evento entra, view sai. A Charm também tem um gosto visual que eu curto: cores boas, espaçamento decente, componentes leves, nada com cara de formulário WinForms jogado no terminal.

Então eu queria o seguinte: continuar em Rust com Ratatui, mas roubar a sensação de Bubble Tea. Não o runtime inteiro. Não um clone perfeito. Só a direção visual e alguns componentes.

Daí nasceu o [ratatui-bubbletea](https://github.com/akitaonrails/ratatui-bubbletea).

![Showcase do ratatui-bubbletea rodando em terminal, com SelectList, Spinner, Theme, ThemedTable, TextInput, Progress e Viewport no estilo Charm.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/06/08/ratatui-bubbletea/ratatui-bubbletea-example.png)

O projeto não substitui o Ratatui. Ele fica por cima. A ideia é oferecer uma camada de tema e componentes com inspiração em Bubble Tea/Bubbles, mas ainda renderizando com Ratatui.

Hoje ele é dividido em crates:

- `ratatui-bubbletea-theme`, com paleta, helpers e estilos compartilhados.
- `ratatui-bubbletea-components`, com componentes prontos como select list, spinner, progress, table, text input, viewport e help.
- `ratatui-tea`, opcional, pra quem quer uma ergonomia mais perto de `Model`, `Msg` e `Cmd`, sem fingir que Rust virou Go.

O README tem os exemplos completos e a documentação do que já existe. Por enquanto, eu trato como toolkit pequeno. Serve pra meus apps, e se servir pra mais alguém, ótimo. Se não servir, também não tem drama. O objetivo era parar de reimplementar o mesmo tema e os mesmos widgets toda vez que eu começava uma TUI nova.

## ai-usagebar como exemplo público

Como não vou abrir o app financeiro, precisava de um exemplo público usando essa estética. Então atualizei meu [ai-usagebar](https://github.com/akitaonrails/ai-usagebar).

Pra quem não lembra, expliquei o projeto no post ["Criei um Widget de Waybar pra Omarchy pra Monitorar Uso de Planos de LLM: ai-usagebar"](/2026/05/24/criei-widget-waybar-omarchy-monitorar-uso-llms-ai-usagebar/). Ele nasceu como widget de Waybar pra mostrar uso de planos de LLM: Claude, OpenAI Codex/ChatGPT, Z.AI, OpenRouter. Bateu o olho na barra, sabe se está perto do limite e qual vendor usar agora.

Depois virou também TUI standalone. E graças a contribuições, hoje suporta Windows também. Isso é engraçado porque a origem dele é totalmente Linux/Omarchy/Waybar. Mas é open source: alguém usa em outro ambiente, encontra atrito, manda PR, e pronto, o projeto fica menos provinciano.

![ai-usagebar em modo TUI mostrando dashboard de uso de OpenAI, abas de vendors, gauges de limite e atalhos no rodapé.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/06/08/ratatui-bubbletea/ai-usagebar.png)

No ai-usagebar a diferença visual não muda a vida de ninguém. É uma tela simples. Abas, gauges, texto, atalhos. Mas é um bom exemplo porque é pequeno, real, testado, empacotado, e não depende do meu app privado. Dá pra olhar o código e ver como apliquei a camada de tema.

## Os apps de coceira própria

Esses projetos todos seguem a mesma lógica: eu tenho uma coceira, faço uma ferramenta pequena, uso, ajusto, empacoto. Nada de roadmap de startup. Nada de manifesto. Só ferramenta que resolve um incômodo meu.

Um exemplo recente é o [clock-tui](https://github.com/akitaonrails/clock-tui). Ele não nasceu comigo. Era um projeto Rust antigo, `tclock`, que parecia abandonado. Eu queria um relógio grande no meu segundo monitor vertical. Aquele monitor fica do lado, e eu gosto de ter um "desk clock" enorme ocupando parte da tela. Usei o clock-tui original por um tempo.

Só que uma tela vertical inteira só pra mostrar hora é desperdício. Eu já tinha o [ghpending](https://github.com/akitaonrails/ghpending), que lista issues e PRs abertos em todos os meus projetos. Ele é meu "tem alguém esperando resposta?" em formato de CLI. Também queria ver minha agenda.

Então fiz outro app pequeno: [google-calendar-tui](https://github.com/akitaonrails/google-calendar-tui). Ele usa as contas Gmail já registradas no GNOME Online Accounts e resume meus próximos compromissos no terminal. Read-only. Sem ritual de OAuth novo. Sem mais um config secreto espalhado em lugar esquisito.

Com essas duas peças, modernizei o clock-tui e adicionei layout de widgets auto-refresh. Agora o relógio ocupa a tela como eu queria, mas em volta dele aparecem pendências do GitHub e agenda do Google Calendar.

![tclock em monitor vertical, com relógio grande, widget de pendências do GitHub à esquerda e agenda do Google Calendar à direita.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/06/08/ratatui-bubbletea/tclock.png)

Isso é exatamente o tipo de coisa que eu nunca faria se custasse um fim de semana inteiro. Mas com LLM, vira uma sequência de tarefas pequenas: lê o projeto antigo, moderniza dependências, roda teste, adiciona módulo de widget, chama ghpending, chama google-calendar-tui, organiza layout, corrige bug, empacota. Ainda dá trabalho. Mas é trabalho de supervisão e refinamento, não de ficar brigando com boilerplate.

## Ajustando Geary sem fork

Outra coceira veio do GNOME.

Como eu queria centralizar minhas contas no GNOME Online Accounts, comecei a usar [Geary](https://wiki.gnome.org/Apps/Geary) e o calendário do GNOME no segundo monitor também. Gosto da ideia: contas configuradas uma vez, apps do desktop reaproveitando a mesma infraestrutura, nada de cada programinha inventar seu próprio login.

O problema é que o Geary tem um layout fixo de três colunas. Numa tela normal, tudo bem. Num monitor vertical, fica apertado. A coluna de pastas, a lista de mensagens e o corpo do e-mail brigam por espaço. Eu não queria manter um fork do Geary só pra esconder uma sidebar. Fork de app GTK grande é dívida. Você pisca e passa o resto da vida resolvendo conflito de merge.

Então fiz um módulo GTK: [geary-hide-sidebar-module](https://github.com/akitaonrails/geary-hide-sidebar-module). Ele injeta um comportamento no Geary em runtime e permite recolher/expandir a sidebar, com atalho e auto-collapse em janela estreita. Sem recompilar Geary. Sem manter fork. Só um módulo pequeno com uma responsabilidade bem específica.

![Geary com sidebar recolhida, mostrando lista de e-mails e corpo da mensagem em layout mais confortável para tela vertical.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/06/08/ratatui-bubbletea/geary-sidebar-hidden.png)

Essa é uma lição boa: às vezes você não precisa forkar a aplicação inteira. Dá pra ajustar por fora. GTK_MODULES existe. Wrapper existe. Config existe. CSS existe. Script existe. Nem toda personalização precisa virar uma manutenção eterna de código dos outros.

## Código pequeno ficou barato

É por isso que estou insistindo tanto nessa ideia de apps pequenos. Com LLMs atuais, ficou muito fácil implementar uma ideia específica pra deixar seu ambiente do jeito que você quer. Sem esperar alguém ter exatamente a mesma dor. Sem ficar procurando no GitHub por três horas uma ferramenta que faz 80% do que você quer e 40% do que você não quer.

Você descreve a coceira, cria um repo, pede um protótipo, testa, manda refatorar, manda escrever teste, manda empacotar. Se ficar ruim, joga fora. Se ficar bom, instala e usa.

Eu não deixo isso virar gambiarra jogada no `~/bin` sem dono. Meus apps têm testes. Têm builds automatizados. Muitos têm release no GitHub, pacote no AUR, instalação normal com `yay` no Arch. Usam paths XDG, então config vai pra `~/.config`, cache vai pra `~/.cache`, dados vão pra `~/.local/share`. Fica organizado. Dá pra atualizar. Dá pra remover. Dá pra outra pessoa clonar e contribuir.

Pra fechar, os links todos num lugar só:

- [ratatui-bubbletea](https://github.com/akitaonrails/ratatui-bubbletea)
- [ai-usagebar](https://github.com/akitaonrails/ai-usagebar)
- [clock-tui](https://github.com/akitaonrails/clock-tui)
- [ghpending](https://github.com/akitaonrails/ghpending)
- [google-calendar-tui](https://github.com/akitaonrails/google-calendar-tui)
- [geary-hide-sidebar-module](https://github.com/akitaonrails/geary-hide-sidebar-module)
- [ai-jail](https://github.com/akitaonrails/ai-jail)
- [ai-memory](https://github.com/akitaonrails/ai-memory)

Se você usar algum deles e quebrar no seu setup, abre issue. Se souber corrigir, manda PR. Eu uso essas ferramentas de verdade, então bug report útil tende a virar correção rápido.

Minha regra prática é essa: personalize seu ambiente sem transformar tudo em gambiarra. Faça ferramenta pequena. Teste. Empacote. Documente. Deixe o LLM carregar o peso chato e use seu cérebro pra decidir o que presta.

Essa é a parte divertida de programar que tinha sumido um pouco. Agora voltou.
