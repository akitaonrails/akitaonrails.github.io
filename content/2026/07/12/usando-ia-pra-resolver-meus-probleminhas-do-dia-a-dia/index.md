---
title: "Usando IA pra resolver meus probleminhas do dia-a-dia"
slug: "usando-ia-pra-resolver-meus-probleminhas-do-dia-a-dia"
date: '2026-07-12T11:00:00-03:00'
draft: false
translationKey: using-ai-to-solve-my-little-day-to-day-problems
description: "Um apanhado dos meus pequenos projetos open source: relógio de mesa com widgets, leitores de mangá, email decente, treino de digitação, karaokê de YouTube, ComfyUI em Docker e mais. Tudo nascido de probleminhas reais do meu dia-a-dia."
tags:
- vibe-coding
- open-source
- inteligencia-artificial
---

Eu não ia escrever artigo pra cada projetinho open source que eu faço. A maioria resolve um probleminha muito específico do MEU dia-a-dia, e artigo dedicado ficaria desproporcional. Só que os projetinhos foram acumulando, e olhando pra trás percebi que já são vários que nunca apareceram por aqui. Então resolvi fazer diferente: um artigo só, mencionando a maioria de uma vez.

O padrão se repete em todos: eu esbarro numa pequena fricção do cotidiano, daquelas que a gente normalmente engole porque consertar custaria um fim de semana inteiro, e em vez de engolir eu abro um agente de IA e resolvo. O custo de transformar irritação em ferramenta despencou tanto que o cálculo inverteu. Hoje vale a pena consertar quase tudo.

Tudo que aparece abaixo está no [meu GitHub](https://github.com/akitaonrails), com binários, releases e instruções de instalação.

Nesse post: [clock-tui](#clock-tui-um-relógio-de-mesa-que-virou-painel) (com os widgets [google-calendar-tui](#clock-tui-um-relógio-de-mesa-que-virou-painel) e [ghpending](#clock-tui-um-relógio-de-mesa-que-virou-painel)), [github-visualize](#github-visualize-inútil-mas-bonito), [frank_geary](#frank-geary-email-do-jeito-que-eu-queria), [frank_scanlation](#mangá-em-japonês-frankyomik-frank-manga-e-frank-scanlation), [frank_lyrics](#frank-lyrics-decorando-música-linha-por-linha), [frank_type](#frank-type-treino-de-digitação-com-prosa-de-verdade), [distrobox-gaming](#distrobox-gaming-uma-biblioteca-de-como-instalar-jogos-no-linux) e [aitrepreneur-docker](#aitrepreneur-docker-comfyui-sem-sujar-o-sistema).

## clock-tui: um relógio de mesa que virou painel

O caso de uso é simples: eu tenho um monitor secundário vertical, e queria algo mais útil ali do que um wallpaper, alguma coisa que eu pudesse só bater o olho e ter informação relevante. Mas tudo começou porque eu só queria um relógio de mesa. Achei um programinha open source antigo de relógio em terminal, o clock-tui original, que estava parado havia tempos, e decidi fazer um fork e continuar o trabalho: o [clock-tui](https://github.com/akitaonrails/clock-tui).

Deixei ele mais bonito, modernizei as dependências de Rust, e a mudança mais importante: adicionei suporte a **widgets de comando**. O relógio fica no topo e embaixo entram painéis que rodam qualquer comando que imprima texto, cada um com refresh independente. Dois widgets que eu mesmo criei pra ele:

- [google-calendar-tui](https://github.com/akitaonrails/google-calendar-tui): uma agenda read-only do Google Calendar no terminal, usando as contas que já estão no GNOME Online Accounts (zero configuração de OAuth). Bato o olho e sei meus compromissos do dia.
- [ghpending](https://github.com/akitaonrails/ghpending): lista issues e pull requests abertos em todos os repositórios que eu acompanho. Agora que eu tenho dezenas de projetos open source, é assim que eu percebo em segundos quando chega PR ou issue nova, sem abrir o GitHub.

![Widget do ghpending mostrando pull requests e issues abertos em vários repositórios de uma vez.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/12/probleminhas/ghpending.webp)

![Agenda colorida do google-calendar-tui impressa direto no terminal.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/12/probleminhas/google-calendar-tui.webp)

E hoje eu passei o dia adicionando suporte a temas, porque alguém no X comentou que o visual dava pra lembrar Evangelion. Desafio aceito: agora tem o tema `evangelion` (roxo e lavanda) e o tema `nerv` (vermelho, âmbar e verde, inspirado nas telas de alerta da série), alternando em runtime com `Shift+T`. O tema é injetado nos widgets via variável de ambiente, então os painéis acompanham a paleta.

![clock-tui com o tema NERV: relógio digital em vermelho com widgets de system health, calendário e GitHub em âmbar e verde.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/12/probleminhas/clock-tui-nerv.webp)

![clock-tui com o tema Evangelion: a mesma tela na paleta roxa e lavanda da EVA-01.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/12/probleminhas/clock-tui-evangelion.webp)

Instalação no Arch: `yay -S clock-tui-bin`. Os widgets: `yay -S ghpending-bin` (também tem `brew install` via `akitaonrails/tap` no macOS) e `yay -S google-calendar-tui-bin`. Todos têm binários prontos nas releases do GitHub pra quem não usa Arch.

## github-visualize: inútil, mas bonito

Esse nasceu por causa do artigo do Jarred Sumner sobre reescrever o TypeScript do Bun em Rust, sobre o qual eu [postei recentemente](/2026/07/09/resposta-sobre-bun-em-rust-que-andrew-kelly-deveria-ter-feito/). Não sei qual ferramenta ele usou pra ilustrar o post, mas eu gostei demais das animações dos gráficos. É inútil? É. Mas é bonito, e beleza é motivo suficiente pra fazer uma cópia.

O [github-visualize](https://github.com/akitaonrails/github-visualize) é um dashboard self-hosted que monitora meus repositórios do GitHub e faz replay do progresso deles com visualizações animadas: timeline de commits com linhas adicionadas e deletadas em escala logarítmica, heat map de commits por dia e hora, corrida de CI até o verde. Agora eu adiciono qualquer repositório meu e tenho visualizações bonitas de produtividade, atividade, commits e builds. Talvez eu use em slides de apresentação, ou pra ilustrar posts futuros aqui no blog.

![Replay animado da timeline de commits no github-visualize: linhas adicionadas em rosa e deletadas em ciano, com contadores animados e feed de git log.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/12/probleminhas/github-visualize-timeline.webp)

Instalação: imagem pública no Docker Hub como [`akitaonrails/github-visualize`](https://hub.docker.com/r/akitaonrails/github-visualize), container único com SQLite num volume, sem banco externo nem Redis.

## Frank Geary: email do jeito que eu queria

Eu decidi usar o Geary, do GNOME, como meu cliente de email principal. É o que chega mais perto da interface do Mail padrão da Apple: limpo, direto, sem cerimônia. Eu sei, existe o Thunderbird, mas eu o acho inchado e muito feio. Existe o Mailspring, que eu acho inchado e pesado. Meu fluxo de email é curto: varrer a inbox, taggear, arquivar e responder. Nada além disso.

O Geary é quase perfeito, mas tinha dois problemas grandes pra mim. Primeiro: no meu monitor vertical, sobra muito menos espaço horizontal, e o Geary tem 3 colunas fixas. A primeira coluna, que só lista contas e pastas/tags, eu não preciso ver o tempo todo, mas não existia jeito de recolher.

Segundo, e mais grave: o campo de destinatário do compositor na prática não autocompletava nada (o Geary até tem o mecanismo, mas com um filtro de visibilidade de contatos tão restritivo que nunca sugeria ninguém). Eu tinha que digitar o endereço na mão ou copiar e colar de outro email. Em 2026.

Minha primeira solução foram dois módulos GTK externos injetados no Geary, um pra cada problema (ambos obsoletos agora). Funcionavam, mas exigiam instalar o Geary compilado do source, e a cada `yay -Syu` lá ia ele recompilar tudo de novo.

Cansei e fiz o que deveria ter feito desde o início: forkei o Geary e criei o [Frank Geary](https://github.com/akitaonrails/frank_geary), que adiciona as duas funcionalidades direto no código. A barra lateral agora recolhe, e o destinatário autocompleta consultando os contatos dos emails existentes. Vou manter o fork rebaseando do upstream com frequência.

![Popup de autocomplete de destinatário no compositor do Frank Geary, sugerindo contatos conforme você digita.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/12/probleminhas/frank-geary-autocomplete.webp)

![Frank Geary com a barra lateral de contas recolhida: só a lista de conversas e a leitura, perfeito pra monitor vertical.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/12/probleminhas/frank-geary-sidebar.webp)

E a melhor parte: agora tem pacote no AUR, então instalar é assim:

```sh
yay -S frank-geary-bin    # binário pronto (x86_64), da release do GitHub
yay -S frank-geary        # ou compilando do source
```

Os dois pacotes substituem o `geary` do sistema (fazem provide/conflict nele), então a troca é limpa e as atualizações chegam como qualquer outro pacote. Um detalhe depois de instalar ou atualizar: quando a opção de vigiar email novo está ligada, o Geary continua rodando em background como serviço D-Bus, então roda um `geary --quit` pra garantir que nenhum processo antigo ficou no ar.

## Mangá em japonês: FrankYomik, FRANK MANGA+ e FRANK Scanlation

Quem acompanha o blog sabe do meu amor por mangá japonês. Eu já [postei sobre o FrankYomik](/2026/03/05/meu-primeiro-fracasso-com-vibe-code-e-como-consertei-frank-yomik/), que nasceu pra eu conseguir ler os mangás originais em japonês que eu compro na Amazon do Japão.

O problema: mangá voltado pra público adulto (não, não é pornô! estou falando de temas como negócios ou assuntos militares) não tem "furigana", que são as legendinhas em kana impressas ao lado dos kanji difíceis, indicando a leitura. Mangá shounen tem furigana em tudo, então dá pra ler com vocabulário de estudante. Os adultos assumem que você já sabe ler os kanji raros. Eu não sei.

O [FrankYomik](https://github.com/akitaonrails/FrankYomik) resolve isso adicionando furigana em cima da página, em tempo real: um modelo detecta os balões de fala, o manga-ocr extrai o texto e o furigana (ou uma tradução completa, via LLM local no Ollama) é renderizado por cima, tudo rodando no meu próprio hardware. E o detalhe importante: on-the-fly, por cima da imagem que eu já tenho aberto legitimamente, sem baixar nem redistribuir página nenhuma, então sem infringir copyright ou licença.

![FrankYomik adicionando furigana automaticamente sobre os kanji difíceis de uma página de mangá em japonês.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/12/probleminhas/frank-yomik-furigana.webp)

Depois veio o [FRANK MANGA+](https://github.com/akitaonrails/frank_mangaplus), sobre o qual eu [também já postei](/2026/05/30/manga-plus-shueisha-desktop-frank-manga-plus/). Eu pago a assinatura do Manga Plus, o app oficial da Shueisha, mas ele só deixa ler no celular (Android/iOS). Num tablet pequeno até vai, mas eu tenho um monitor Samsung Odyssey OLED de 32" parado na minha frente.

Descobri como usar a minha própria assinatura fora do app e construí um leitor desktop em Tauri: roda em Linux, macOS e Windows, o tier gratuito funciona direto e assinante cola o próprio secret pra liberar os capítulos premium.

![Biblioteca do FRANK MANGA+ no desktop: grade de capas dos mangás da Shueisha com busca no catálogo completo.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/12/probleminhas/frank-mangaplus-library.webp)

Instalação: AppImage, `.deb` e `.dmg` nas [releases](https://github.com/akitaonrails/frank_mangaplus/releases/latest), ou `yay -S mangaplus-reader-bin` no Arch.

E finalmente, eu também leio as eventuais "scanlations" da comunidade: fãs escaneiam as páginas do mangá original japonês e traduzem (hoje em dia a maioria usa IA no processo, existem até modelos treinados pra reconhecer os balões de fala, e eu usei um desses no próprio FrankYomik). Essas scanlations ficam espalhadas por vários sites diferentes, tipo o MangaDex.

Primeiro eu fiz uma extensão de Chrome pra embelezar esses sites (hoje obsoleta), mas cansei de viver com dezenas de abas no Brave só pra sites de scanlation. Então construí o [FRANK Scanlation](https://github.com/akitaonrails/frank_scanlation), na mesma linha do FRANK MANGA+: um app desktop que concentra todas as minhas scanlations favoritas num lugar só, com biblioteca, progresso de leitura por título e checagem de capítulos novos.

As janelas de leitura carregam o próprio site e injetam um leitor decente por cima, com spreads de página dupla e navegação por teclado. Nada é hardcoded pra site nenhum: são heurísticas que detectam sequências de imagens e numeração de capítulos em qualquer URL. Virou meu jeito preferido de ler os mangás que não existem pra comprar na Amazon nem na Shueisha.

![Biblioteca do FRANK Scanlation: cards com capas, progresso de leitura e botão de continuar de onde parou.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/12/probleminhas/frank-scanlation-library.webp)

Instalação: AppImage, `.deb` e `.rpm` (e build de macOS) nas [releases do GitHub](https://github.com/akitaonrails/frank_scanlation/releases).

## Frank Lyrics: decorando música linha por linha

Eu já [postei sobre o Frank Karaoke](/2026/04/05/transformando-youtube-num-app-de-karaoke-frank-karaoke/), um appzinho pra adicionar pontuação em cima do YouTube e curtir karaokê com família e amigos. Mas tem um caso de uso irmão: eu gosto de aprender música nova (abertura de anime nova, por exemplo), e o processo de decorar letra é repetir a MESMA linha várias vezes. No player do YouTube isso é um inferno: fica caçando no dedo o ponto exato da timeline pra voltar, erra por dois segundos, volta demais, passa do ponto.

Pra resolver isso criei o [Frank Lyrics](https://github.com/akitaonrails/frank_lyrics), uma extensão de Chrome simples que descobre o timing correto de cada linha da letra usando os marcadores públicos do [LRCLIB](https://lrclib.net/) e injeta controles na própria página do YouTube. O LRCLIB, pra quem não conhece, é uma biblioteca aberta e comunitária de letras sincronizadas: cada linha vem com timestamp (o formato LRC clássico dos players de música), com API pública, gratuita e sem chave.

A extensão casa esses timestamps com o vídeo e me dá botões de repetir a linha exata que eu estou decorando, quantas vezes eu precisar, sem caçar timeline. Se você curte karaokê, o combo Frank Karaoke + Frank Lyrics deve te atender bem.

![Painel do Frank Lyrics sobre um vídeo de letra no YouTube: cada linha da letra com seu timestamp e controles pra repetir a linha atual.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/12/probleminhas/frank-lyrics.webp)

Instalação: baixa o `.zip` das [releases](https://github.com/akitaonrails/frank_lyrics/releases), descompacta, abre `chrome://extensions`, liga o modo desenvolvedor e faz "Load unpacked" apontando pra pasta.

## Frank Type: treino de digitação com prosa de verdade

Quem me acompanha há tempo sabe que eu amo meus teclados. Tem vídeos no canal Akitando sobre isso e [posts aqui no blog sobre meus teclados favoritos](/2024/10/24/meus-teclados-modernos-favoritos/). E de tempos em tempos eu gosto de treinar no MonkeyType. Mas eu não gosto de digitar palavras aleatórias. O TypeRacer resolve isso usando textos públicos de verdade, só que ele me obriga a esperar outros jogadores na sala (eu detesto jogos multiplayer). Ou seja: eu queria uma experiência single player, com prosa de verdade, mas com a estética do MonkeyType, que eu prefiro.

Então criei o [Frank Type](https://github.com/akitaonrails/frank_type), um mini-clone dos dois: um treinador de digitação em Rails 8 que usa trechos normalizados de prosa em domínio público em vez de listas de palavras aleatórias. É local-first e sem cadastro: histórico de sessões, tempos e gráficos de perfil ficam no local storage do navegador. Tem até heat map de dígrafos pra mostrar quais combinações de teclas te atrasam.

![Tela de prática do Frank Type: texto de domínio público pra digitar, com estatísticas e heat map de dígrafos, na estética do MonkeyType.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/12/probleminhas/frank-type.webp)

Instalação: é um container Docker publicado como `akitaonrails/frank_type`. Um comando levanta em `http://localhost:3200`:

```bash
curl -fsSL https://raw.githubusercontent.com/akitaonrails/frank_type/master/bin/docker-run.sh | bash
```

## distrobox-gaming: uma biblioteca de como instalar jogos no Linux

Eu jogo no mesmo PC em que trabalho, mas me recuso a misturar pacote de emulador e gambiarra de Wine com meu ambiente de desenvolvimento. A solução foi isolar os jogos inteiros dentro de um [distrobox](https://github.com/89luca89/distrobox) (containers que se integram ao desktop como se fossem nativos), e o [distrobox-gaming](https://github.com/akitaonrails/distrobox-gaming) é o repositório de playbooks Ansible que constrói essa box Arch do zero: ES-DE de frontend, emuladores standalone, cores do RetroArch, configs por jogo. Meu Arch/Omarchy host fica limpo.

A regra que eu me impus: todo jogo novo que eu instalo tem que virar receita Ansible reproduzível. Confesso que ainda não testei a reconstrução completa do zero, mas a ideia é essa: qualquer truque ou hack necessário fica documentado no código em vez de perdido no histórico do shell.

E truque é o que não falta, porque eu ando instalando abandonware antigo: a série Colin McRae Rally (da versão de PS1 com patch de 60 fps até o DiRT de 2007), Sega Rally Revo, OutRun 2006 Coast 2 Coast, entre outros. Cada um com suas manhas de Wine, seus patches e suas configurações. Sem querer, o repositório está virando uma biblioteca de documentação sobre como instalar jogos, emuladores e retro games no Linux.

![Colin McRae Rally 04 rodando na box de gaming: a tela de Service Area com o Mitsubishi Lancer Evolution antes da próxima especial.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/07/12/probleminhas/distrobox-gaming-cmr04.webp)

Na mesma linha existe o [distrobox-llm](https://github.com/akitaonrails/distrobox-llm), que faz o mesmo isolamento pro meu ambiente de LLMs locais (CUDA, Ollama, LM Studio e companhia), deixando só o driver NVIDIA no host.

Instalação: clona o repositório e roda os playbooks:

```sh
cd ansible
ansible-galaxy collection install -r collections/requirements.yml
cp host_vars/localhost.yml.example host_vars/localhost.yml
$EDITOR host_vars/localhost.yml
ansible-playbook site.yml
```

## aitrepreneur-docker: ComfyUI sem sujar o sistema

Pra geração de imagens eu gosto do ComfyUI, e [postei sobre ele ano passado](/2025/04/20/entendendo-o-basico-de-comfyui-pra-gerar-imagens-com-i-a/). Eu acompanho um youtuber chamado [Aitrepreneur](https://www.youtube.com/@Aitrepreneur) que mantém uma página no Patreon com receitas pra instalar e configurar o ComfyUI com os modelos e workflows mais recentes. O trabalho de curadoria dele é ótimo, mas as receitas são scripts `.sh` old school, pensados pra rodar one-shot numa instância do RunPod, por exemplo.

Agora que as LLMs evoluíram a ponto de escreverem Dockerfiles decentes, criei o [aitrepreneur-docker](https://github.com/akitaonrails/aitrepreneur-docker), que converte esses scripts em imagens e containers Docker de verdade: versões pinadas, dados persistentes no host ou NAS, um comando pra subir ou atualizar cada app. Assim eu rodo tudo isolado na minha máquina, sem entulhar meu Linux com toneladas de pacotes Python e gambiarras que poderiam desestabilizar o sistema.

Dois avisos importantes. O crédito da seleção de stack, curadoria de modelos e workflows é todo do Aitrepreneur: o repositório só traduz o trabalho dele pra forma de Docker, e os scripts originais dele são conteúdo pago do Patreon que NÃO está incluído.

Se achar útil, [assine o Patreon dele](https://www.patreon.com/c/aitrepreneur/home) pra contribuir com a criação de conteúdo (é lá que você pega os arquivos originais). E o repositório não cobre tudo que ele já produziu, só as receitas mais recentes.

Instalação: `git clone`, `make setup` (cria o `.env` pra você colocar seu token da Hugging Face), `make build` e `make up`.

## E tem mais de onde vieram esses

Se você é novo por aqui: isso é só a leva que ainda não tinha aparecido no blog. Tem muito mais projeto que eu já cobri em posts dedicados. O [ai-memory](/2026/06/16/ai-memory-memoria-longo-prazo-karpathy-wiki-auto-aprendizado-hermes-projetos/) é o mais popular, mais usado e com mais contribuições de todos. O [ai-jail](/2026/05/24/dicas-e-toolkit-de-ia-do-akita-ai-jail-ai-memory-ai-usagebar/), que apareceu de novo no [post de ontem sobre agentes destrutivos](/2026/07/11/como-me-precaver-pros-meus-agentes-nao-apagarem-minhas-coisas/), foi o primeiro da série e é o segundo mais popular.

E tem os outros da série Frank ("Frank" em homenagem ao Frank Rosenblatt, criador do perceptron, a rede neural original; o nome marca os projetos experimentais que eu faço por diversão):

- [Frank Sherlock](/2026/02/23/vibe-code-fiz-um-indexador-inteligente-de-imagens-com-ia-em-2-dias/): indexador inteligente de imagens
- [Frank Mega](/2026/02/21/vibe-code-fiz-um-clone-do-mega-em-rails-em-1-dia-pro-meu-home-server/): clone do MEGA pro meu home server
- [FrankMD](/2026/02/01/vibe-code-fiz-um-editor-de-markdown-do-zero-com-claude-code-frankmd-part-1/): editor de markdown
- [Frank FBI](/2026/03/09/atacando-fraudes-via-email-frank-fbi/): analisador de fraudes por email
- [Frank Investigator](/2026/03/27/ensinando-a-questionar-noticias-frank-investigator/): ensina a questionar notícias

Tudo é open source e está no [meu GitHub](https://github.com/akitaonrails). Todo mundo é bem-vindo pra contribuir com issues, pull requests, ou simplesmente compartilhando com os amigos. Cada um desses projetos nasceu de um probleminha real meu. Vai que um deles resolve o seu também.
