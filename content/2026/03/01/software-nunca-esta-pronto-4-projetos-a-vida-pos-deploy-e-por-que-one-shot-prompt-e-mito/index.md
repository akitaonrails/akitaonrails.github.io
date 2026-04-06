---
title: "Software Nunca Está 'Pronto' — 4 Projetos, a Vida Pós-Deploy, e Por Que One-Shot Prompt É Mito"
slug: "software-nunca-esta-pronto-4-projetos-a-vida-pos-deploy-e-por-que-one-shot-prompt-e-mito"
date: 2026-03-01T12:00:00-03:00
draft: false
tags:
- themakitachronicles
- frankmd
- franksherlock
- frankmega
- agile
- xp
- extremeprogramming
translationKey: software-never-done
---

E não deixe de assinar minha newsletter [The M.Akita Chronicles](https://themakitachronicles.com/)!

--

Publiquei o "post final" da série [Bastidores do The M.Akita Chronicles](/2026/02/20/do-zero-a-pos-producao-em-1-semana-como-usar-ia-em-projetos-de-verdade-bastidores-do-the-m-akita-chronicles/) há 10 dias. 274 commits, 1.323 testes, deploy em produção. Escrevi as lições, fiz a conclusão, coloquei a citação no final. Done.

125 commits de pós-produção depois, posso confirmar: **software *"done"* não existe.**

Hoje o repositório do M.Akita Chronicles tem 335 commits e 1.422 testes. Amanhã, segunda-feira, os assinantes recebem a 3ª newsletter consecutiva — gerada, revisada, e enviada por um sistema que não para de evoluir. Enquanto isso, o [Frank Sherlock](/2026/02/23/vibe-code-fiz-um-indexador-inteligente-de-imagens-com-ia-em-2-dias/) saiu de 50 commits e v0.1 pra 103 commits e v0.7 com face detection. O [FrankMD](/2026/02/01/vibe-code-fiz-um-editor-de-markdown-do-zero-com-claude-code-frankmd-part-1/) recebeu 3 contribuidores externos e lançou a v0.2.0. E até o [FrankMega](/2026/02/21/vibe-code-fiz-um-clone-do-mega-em-rails-em-1-dia-pro-meu-home-server/) — um projeto construído em 1 dia — precisou de correções quando usuários reais apareceram.

Ao longo de fevereiro, publiquei mais de uma dezena de posts detalhando a construção de cada projeto. Este post é diferente. Não é sobre construir do zero, já cobri isso. É sobre o que acontece **depois**. E o que acontece depois destrói a narrativa do one-shot prompt. Software precisa de um humano experiente no volante. Desenvolvimento iterativo é a única forma que funciona. Quem discorda não botou sistema em produção ainda.

Vou provar com `git log`.

## A Vida Depois do Deploy

| Projeto | Commits pós-publicação | Destaque |
|---------|----------------------|----------|
| The M.Akita Chronicles | 56 | 3ª semana em produção, features novas, 13 bug fixes, prompt tuning |
| Frank Sherlock | 53 | De v0.3 a v0.7: video support, face detection, AUR publish |
| FrankMD | 14 | 3 contribuidores externos, 4 PRs merged, v0.2.0 |
| FrankMega | 2 | MIME types que ninguém previu |
| **Total** | **125** | |

Vamos aos detalhes.

## The M.Akita Chronicles: 3 Semanas em Produção

O sistema de newsletter está no ar desde 16 de fevereiro. Já enviou 2 newsletters e amanhã envia a terceira. 56 commits aconteceram desde o "post final":

| Data | Commits | O que aconteceu |
|------|---------|-----------------|
| 20/fev (qui) | 16 | Steam Gaming (seção nova inteira), bug fixes em paywall detection |
| 21/fev (sex) | 12 | /preview command, YouTube collage, notificações de /rerun |
| 22/fev (sáb) | 1 | Fix: /preflight mandando resultado pro channel errado |
| 23/fev (dom) | 10 | Publicação da 2ª newsletter, Gmail clipping warning, TTS revert |
| 24/fev (seg) | 1 | Ajuste de prompt do podcast |
| 28/fev (sáb) | 7 | Marvin prompt tuning, rate limiting, /rerun comments |
| 01/mar (dom) | 9 | Mood system, switch pra Grok-4, QA pipeline, centralização de config |

### Features que Ninguém Previu

**Steam Gaming.** Não existia no plano original. Nasceu porque a seção de entretenimento só tinha anime — e leitores gamers ficaram de fora. Resultado: 6 commits só no dia de lançamento. O primeiro commit (`bf41e25`) adicionou a seção completa — serviço de API Steam, job de geração, testes, shortcode Hugo. Os 5 seguintes corrigiram: parsing de datas em português, offset pro ranking não repetir o top 10, filtro de wishlist pra releases, dark theme. Nenhum spec do mundo prevê que a API do Steam retorna datas com abreviações em português (`"fev"`, `"mar"`, `"abr"`) quando você pede `l=brazilian`. Isso você descobre quando o parser quebra em produção.

**Sistema de preview.** O `/preview` nasceu porque eu precisava ver como o conteúdo auto-gerado ficava **antes** de publicar a newsletter inteira. Parece óbvio em retrospecto, mas na v1 a única forma de validar era gerar tudo e olhar o resultado final. 5 commits pra construir um sistema de preview com 9 seções, aliases (`hn` pra hacker_news, `steam` pra steam_gaming), modo de preview de comentários separado, e rescue quando uma seção falha sem derrubar as outras (`d23c725` — porque uma seção com erro estava matando o preview inteiro).

**Moods do Marvin.** O Marvin (a persona sarcástica do bot) sofre de um problema crônico de LLMs: suavização. Sem intervenção, todo comentário vira o mesmo tom morno. A solução iterativa foi um sistema de moods — 9 modos que o operador escolhe por story:

```ruby
MARVIN_MOODS = {
  "sarcastic"   => "Be extra sarcastic and biting in your commentary.",
  "ironic"      => "Use irony and dark humor to make your point.",
  "grounded"    => "Be more neutral and journalist-like, factual and measured.",
  "provocative" => "Be provocative and controversial, challenge assumptions.",
  "counter"     => "Take the opposite position from Akita's comment.",
  "insightful"  => "Find a non-obvious angle -- a historical parallel, a second-order consequence.",
  "positive"    => "Find the genuinely positive angle.",
  "hopeful"     => "Be cautiously optimistic. Acknowledge the good potential.",
  "negative"    => "Be extra pessimistic and bleak."
}.freeze
```

Nada disso surgiu de uma spec. Surgiu de 3 semanas lendo comentários genéricos e pensando *"isso não tá bom"*. São 7 commits só de prompt tuning ao longo de 10 dias. Bani padrões formulaicos (`d4bd3a6`). Eliminei o "Ah," como abertura (`4171628`). Removi o Marvin de seções inteiras do podcast porque ele tava contaminando o tom (`246cc60`). Forcei substância ao invés de trocadilhos (`8bc47c4`). Cada commit de prompt é uma micro-correção que só faz sentido depois de ler o output anterior.

### Bugs que Só Existem em Produção

Dos 56 commits, 13 são bug fixes. Alguns favoritos:

- **Gmail clipping** (`3258f5b`): Gmail silenciosamente corta emails maiores que 102KB. Descobri quando a 2ª newsletter saiu mais longa e leitores no Gmail não viram o final. Resultado: um check de tamanho no content preflight que avisa antes de publicar. Reduzi as seções de história de 10 pra 5 itens (`51ce528`) pra caber no limite.

- **False paywall detection** (`1fd8739`): o scraper marcava sites como paywall quando encontrava texto de bloqueio acidental num rodapé genérico. Só apareceu quando a lista de stories cresceu pra dezenas de fontes reais.

- **t.co link mangling** (`6bd056f`): o Twitter encurta URLs com t.co, mas também auto-linka nomes de arquivo que parecem domínios. `config.yml` vira um link pro domínio `config.yml`. 158 linhas de fix pra tratar corretamente textos de tweet.

- **TTS language revert** (`7803ad9` -> `c1dd668`): tentei trocar o idioma do TTS de "Portuguese" pra "Auto". O modelo gerou sotaque misturado. Revertido no mesmo dia.

- **Podcast section ordering** (`5bef18c`): seções do podcast saíram fora de ordem. Fix de 3 linhas + untrack de 1.504 linhas de conteúdo gerado que foi commitado por acidente.

- **Elementor sites com múltiplos `<article>`** (`e70b756`): sites construídos com Elementor usam a tag `<article>` de forma não-semântica. O extrator de conteúdo pegava o bloco errado. 171 linhas de fix + testes.

Nenhum desses bugs poderia ter sido previsto numa spec. Eles só existem porque o sistema tá no ar, processando dados reais, batendo em APIs reais, sendo lido por gente real.

### De 1.323 pra 1.422 Testes

A suíte de testes continuou crescendo junto:

| App | Testes (20/fev) | Testes (01/mar) | Crescimento |
|-----|-----------------|-----------------|-------------|
| marvin-bot | 970 | 1.060 | +90 |
| newsletter | 353 | 362 | +9 |
| **Total** | **1.323** | **1.422** | **+99** |

Feature nova? Vem com teste. Bug fix? Vem com teste de regressão. Sem isso, os 56 commits de pós-produção seriam 56 oportunidades de quebrar algo que funcionava ontem. TDD não é fase, é hábito.

### O Modelo Mudou: De Claude pra Grok-4

Commit `8f9d11c`: `Switch default model to x-ai/grok-4`. A arquitetura isolou o modelo LLM numa variável de ambiente desde o início. Mas o nome do modelo ainda estava referenciado em código por 24 arquivos. Resultado: commit `c8c688e` — `Centralize LLM model config` — 24 arquivos tocados pra garantir que trocar de modelo seja uma mudança de 1 linha de config.

Esse tipo de refactoring só surge na operação. Quando você começa o projeto, não sabe que vai trocar de modelo. Quando troca, quer que seja trivial. E a limpeza pra tornar trivial? Só acontece quando a dor aparece.

## Frank Sherlock: De v0.1 a v0.7 em 4 Dias

O [post sobre o Frank Sherlock](/2026/02/23/vibe-code-fiz-um-indexador-inteligente-de-imagens-com-ia-em-2-dias/) cobriu os primeiros 2 dias e ~50 commits: a pesquisa de benchmarks, o scaffold do app Tauri (Rust + React), a pipeline de classificação com Ollama, e o lançamento da v0.1.0 com binários pra Linux, macOS e Windows.

O que o post não cobriu: os 53 commits seguintes, em 4 dias, que levaram o projeto da v0.3 pra v0.7:

| Versão | Data | Destaque |
|--------|------|----------|
| v0.4.0 | 24/fev | Duplicate detection (SHA-256 + dHash), PDF password manager |
| v0.5.0 | 24/fev | Auto-update, scan performance 2x, checkpoint resume |
| v0.6.0 | 25/fev | Video support (11 formatos), directory tree, FTS stemmer |
| v0.7.0 | 27/fev | **Face detection** com ONNX nativo, person management |

### Face Detection: A Feature que Nasceu da Iteração

A v0.1 era um indexador de imagens com classificação por LLM. A v0.7 tem detecção de rostos com embeddings de 512 dimensões, clustering por similaridade de cosseno, e busca por pessoa (`face:alice`). Nada disso tava no plano original. Surgiu porque comecei a usar o app com fotos de verdade e pensei *"quero encontrar todas as fotos de fulano"* A feature nasceu do uso, não da spec.

O caminho até lá foi metódico:

1. **`f34132f`**: A/B testing framework pra face detection — benchmarkear antes de implementar, não depois
2. **`ef3be82`**: Resultados do A/B (SCRFD + ArcFace venceu)
3. **`6d9174a`**: Implementação nativa com ONNX Runtime — sem Python, sem dependência externa
4. **`3b25eaf`**: Clustering, person management, FacesView completa
5. **`a02d67f`**: Refactoring — extrair helpers, deletar código morto, compartilhar CSS

Benchmark -> implementar -> refatorar. O mesmo ciclo de sempre. E algo que nenhum one-shot prompt produz.

### Video Support: Outro Emergente

O app foi pensado pra imagens. Mas pastas reais de mídia têm vídeos. Commit `a67a2f9` adicionou suporte completo: scanning de 11 formatos (MP4, MKV, AVI, MOV, WebM...), extração de keyframe pra classificação pelo LLM, skip de frames pretos, parsing de legendas .srt pro índice full-text, e preview inline com streaming HTTP Range.

1.626 linhas adicionadas num commit. Uma feature inteira que nasceu do uso real, não de uma especificação.

### 7 Releases, 3 Plataformas, AUR Automático

Em 7 dias, o Frank Sherlock teve 7 releases. Cada um com binários compilados pra Linux (AppImage), macOS (DMG com notarização e code signing), e Windows (MSI). A pipeline de CI/CD (`release.yml`) faz tudo automaticamente. A partir da v0.5.0, um workflow adicional (`aur-publish.yml`) publica automaticamente no AUR — o repositório de pacotes do Arch Linux.

No final: 17.210 linhas de Rust, 10.863 linhas de TypeScript, 621 testes (322 Rust + 299 frontend). Cross-platform. Releases publicados e instaláveis por qualquer usuário. Uma semana, um dev, um agente de IA.

A parte de CI/CD pra cross-platform é onde a fantasia do *"funciona na minha máquina"* morre. Foram 17 commits só de build: Windows UNC paths, macOS signing com notarização, Linux AppImage, permissões de release workflow, macOS Intel target removido. Nenhum LLM do mundo sabe que o macOS exige entitlements específicos pra hardened runtime ou que paths no Windows começam com `\\?\`. Esse tipo de trabalho de deploy exige alguém que já passou por essa dor antes.

## FrankMD: Open Source de Verdade

O FrankMD foi o primeiro projeto desta saga, um editor Markdown self-hosted com Rails 8. Os [posts de fevereiro](/2026/02/01/vibe-code-fiz-um-editor-de-markdown-do-zero-com-claude-code-frankmd-part-1/) cobriram a construção. O que aconteceu depois é mais interessante: outras pessoas começaram a contribuir.

14 commits desde 20 de fevereiro. 3 contribuidores externos. 4 PRs merged. Release v0.2.0 no dia 28:

| PR | Autor | Tipo | O que fez |
|----|-------|------|-----------|
| #34 | @murilo-develop | Bug fix | Integração Ollama: ModelNotFoundError + API base URL |
| #36 | @rafaself | Bug fix | Comportamento de table hints no editor (3 commits iterativos) |
| #38 | @LuccaRomanelli | Feature | Auto-sync de tema com o desktop environment Omarchy |
| #39 | @LuccaRomanelli | Feature | "New Folder" no menu de contexto do explorer |

### O Padrão do Maintainer

O mais revelador não são as contribuições em si, mas o que eu fiz depois de cada merge.

Quando o @LuccaRomanelli submeteu o PR do Omarchy theme sync (+308 linhas), eu mergeei e imediatamente commitei `fix: harden Omarchy theme integration and fix broken tests` — **+163 linhas** de fixes e testes no commit seguinte. O contribuidor implementou a feature. O maintainer endureceu.

Quando o @rafaself submeteu o fix de table hints, foram 3 commits iterativos no mesmo dia — `enhance`, `improve`, `streamline` — mostrando o mesmo padrão de refinamento progressivo que eu faço com o agente de IA. No dia seguinte, ele mandou um commit separado atualizando faraday, nokogiri e rack por security advisories.

No dia 28, sentei e fiz tudo de uma vez: mergeei as 4 PRs, commitei o hardening, atualizei 5 gems (brakeman, bootsnap, selenium-webdriver, web-console, mocha), e publiquei as release notes da v0.2.0. Um *"release day"* clássico.

O FrankMD hoje tem 226 commits, 1.804 testes (425 Ruby + 1.379 JavaScript), e contribuidores ativos. Não é mais *"meu projetinho pessoal"*. Virou software com comunidade. E comunidade não aparece pra protótipo sem testes que *"funciona na minha máquina"*. Aparece pra projeto com CI verde, documentação, releases versionados, e código que dá pra ler.

## FrankMega: Até o Menor Projeto Precisa de Pós-Produção

O FrankMega foi construído em [1 dia](/2026/02/21/vibe-code-fiz-um-clone-do-mega-em-rails-em-1-dia-pro-meu-home-server/). 26 commits, file sharing seguro com Rails 8, 210 testes, deploy via Docker + Cloudflare Tunnel. Post publicado no mesmo dia. Pronto, certo?

Três dias depois, 2 commits:

- `db4bb705` — Add macOS, Linux, and Windows package MIME types to seed defaults
- `b0c4829a` — Fix MIME types to match Marcel detection, add normalizes strip

Usuários tentaram compartilhar arquivos `.dmg`, `.deb`, e `.msi`. O MIME type detection (via gem Marcel) não reconhecia esses formatos porque não estavam nos defaults do seed. Dois commits. 22 linhas. 15 minutos.

Mas sem eles, o FrankMega não servia pra compartilhar pacotes de instalação — que é exatamente o caso de uso mais comum num home server de devs.

> Nenhum prompt no mundo prevê que seus usuários vão querer compartilhar `.deb` no primeiro dia.

O projeto mais simples de todos, com a pós-produção mais curta. E mesmo assim, precisou de iteração.

## Os Números Consolidados

| Projeto | Commits (total) | Testes | Pós-produção |
|---------|----------------|--------|--------------|
| The M.Akita Chronicles | 335 | 1.422 | 56 commits, 10 dias em produção |
| Frank Sherlock | 103 | 621 | 53 commits, 4 releases extras |
| FrankMD | 226 | 1.804 | 14 commits, 3 contribuidores |
| FrankMega | 28 | 210 | 2 commits, MIME fixes |
| **Total** | **692** | **4.057** | **125 commits pós-publicação** |

692 commits. 4.057 testes. 4 projetos em produção. Fevereiro de 2026. Eu e um agente de IA.

## Por Que One-Shot Prompt É Mito

Olha os 125 commits de pós-produção e me diz qual deles poderia ter sido previsto por uma especificação.

Gmail corta emails maiores que 102KB, e você só descobre quando manda o primeiro email longo. A Steam API retorna datas com abreviações em português (`"fev"`, `"abr"`), e você só descobre quando o parser quebra no domingo de geração. Usuários de macOS tentam compartilhar `.dmg` e não conseguem porque o MIME type não tá no seed. O Marvin abre todo comentário com *"Ah,"* e você só percebe quando lê 30 seguidos e quer arrancar os olhos. O modelo LLM precisa ser trocável com 1 linha de config, mas tá espalhado em 24 arquivos. Windows usa UNC paths que começam com `\\?\`, e o CI explode na sua cara. E o TTS em modo "Auto"? Gera um sotaque que parece português de Lisboa tentando ser carioca.

Nada disso é "debugar" no sentido tradicional. É navegar um espaço de problemas que só se revela quando o software encontra a realidade. Cada um desses foi uma decisão tomada em tempo real por alguém com contexto.

A fantasia do one-shot prompt é que, se você escrever uma especificação suficientemente detalhada, a IA produz o software perfeito. Mas a especificação perfeita exigiria que você soubesse de antemão tudo que vai dar errado. E se você soubesse de antemão tudo que vai dar errado, você não precisaria da especificação — já teria o software pronto na cabeça.

Software bom é o resultado de centenas de micro-decisões tomadas com o sistema rodando. Não de uma macro-decisão tomada antes de escrever a primeira linha.

## O Papel do Desenvolvedor Experiente

A IA acelerou tudo isso. Sem ela, 692 commits em um mês seria impossível pra uma pessoa só. Mas aceleração sem direção é só entropia mais rápida.

Em cada projeto houve decisões que a IA não teria como tomar sozinha. Trocar de Claude pra Grok-4 porque o modelo anterior tava fraco num domínio específico. Benchmark de SCRFD vs alternativas *antes* de implementar face detection, porque a escolha errada ia custar dias. O hardening de +163 linhas que eu commitei imediatamente depois de mergear o PR do Omarchy, porque eu vi onde ia quebrar. O revert do TTS em modo Auto no mesmo dia, porque eu sei que "Auto" num modelo de TTS pra português brasileiro vai produzir sotaque misturado.

O caso do circuit breaker é o mais ilustrativo. Quando adicionei rate limiting, a Brave Search API começou a retornar 429 de vez em quando. Se eu pedisse, o agente implementaria um retry com backoff exponencial. Mas eu não pedi retry. Pedi circuit breaker:

```ruby
class WebSearcher
  CIRCUIT_BREAKER_SECONDS = 120

  def self.search(query, max_results: 5)
    return [] if circuit_open?

    response = brave_search(query, max_results)

    if response.code == 429
      trip_circuit!
      Rails.logger.warn("WebSearcher rate limited (429)")
      return []
    end
  rescue Net::OpenTimeout, Net::ReadTimeout => e
    trip_circuit!
    []
  end
end
```

Se a API retorna 429 ou timeout, para de tentar por 120 segundos. Sem retry, sem backoff, sem fila. Por quê? Porque eu sei que o cron roda todo dia às 8h e que nos domingos de geração de newsletter o volume de queries triplica. Uma manada de retries atrasando tudo é pior que resultados vazios numa seção.

A IA implementa um circuit breaker quando você pede. Mas ela não vai pedir pra implementar um circuit breaker. Ela não tem o contexto operacional. Isso é conhecimento que vem de rodar sistemas em produção por décadas.

> O agente escreve o código. Eu decido qual código escrever. E essa decisão exige experiência que nenhum prompt substitui.

## As Lições

**1. Software em produção diverge da spec em horas, não em meses.** Os primeiros bugs do M.Akita Chronicles surgiram na primeira newsletter real. Os MIME types do FrankMega quebraram nos primeiros uploads. Quem acha que deploya e acabou tá vivendo num mundo que não existe.

**2. Pós-produção não é "manutenção".** 56 commits em 10 dias no M.Akita Chronicles não são patches. São features novas (Steam Gaming, preview, moods), refactoring de arquitetura (centralização de config do LLM), hardening de segurança (rate limiting). Isso é desenvolvimento. O software não parou de evoluir só porque eu disse *"done"* num blog post.

**3. TDD protege a evolução.** 99 novos testes em 10 dias. Os 1.804 testes do FrankMD permitiram mergear 4 PRs de contribuidores externos sem medo. Sem testes, cada merge é roleta russa.

**4. Small releases mantêm a sanidade.** 7 releases do Frank Sherlock em 7 dias. CI verde, binários compilados, release notes. Deu problema? Reverte uma versão. Compara com "6 meses + big bang release" e me conta qual funciona melhor.

**5. Comunidade aparece pra projetos reais.** Ninguém manda PR pra protótipo sem testes que *"funciona na minha máquina"*. O FrankMD recebeu 3 contribuidores porque tem CI verde, documentação, e releases versionados.

**6. A experiência do desenvolvedor é o gargalo, não a velocidade da IA.** 692 commits em um mês. Mas cada commit que importa exigiu décadas de experiência pra saber que era necessário. A IA digita rápido. Eu sei o que digitar.

**7. One-shot é pra demo. Iteração é pra produção.** Se o objetivo é um vídeo de 10 minutos mostrando um *"SaaS pronto"*, one-shot serve. Se o objetivo é software que sobrevive ao contato com usuários reais, só iteração funciona. E iteração sustentável exige disciplina: TDD, CI, small releases, refactoring contínuo. Sem atalho.

## Pro Sênior que Ainda Tá de Braços Cruzados

Até aqui eu bati nos amadores que acham que podem mandar um prompt e a IA cospe um sistema pronto. Justo. Mas tem um outro grupo que me preocupa tanto quanto: o desenvolvedor sênior que viu a IA errar três vezes, declarou que *"isso não serve pra nada"*, e voltou a fazer tudo na mão.

Eu entendo o raciocínio. A IA alucina, gera código com bugs sutis, sugere soluções over-engineered. Tudo verdade, e eu documentei cada um desses problemas nos posts anteriores. Mas me diz uma coisa: você nunca fez exatamente a mesma coisa? Você nunca passou 2 horas lendo documentação pra descobrir que era um typo na config? A diferença é que quando a IA erra, você pega nos testes e corrige em minutos. Quando você erra sozinho, leva o mesmo tempo pra cometer o erro e mais tempo ainda pra achar, porque você confia no próprio código.

Vamos olhar pros números concretos do que eu entreguei em fevereiro, uma pessoa e um agente de IA:

| Projeto | Tempo | Resultado |
|---------|-------|-----------|
| M.Akita Chronicles | 8 dias | 4 apps (Rails + Python + Hugo), 335 commits, 1.422 testes, em produção há 3 semanas |
| Frank Sherlock | 7 dias | App desktop Tauri (Rust + React), 103 commits, 621 testes, 7 releases, binários pra 3 OS |
| FrankMD | ~4 dias | Editor Markdown Rails 8, 226 commits, 1.804 testes, 3 contribuidores externos |
| FrankMega | 1 dia | File sharing Rails 8, 28 commits, 210 testes, deploy Docker + Cloudflare |

Agora faz a conta de cabeça. Quanto tempo você levaria pra fazer o Frank Sherlock sozinho? Um app Tauri do zero, com pipeline de classificação por LLM em Rust, OCR via Python, full-text search com FTS5, detecção de duplicatas por perceptual hash, face detection com ONNX nativo, suporte a vídeo com extração de keyframe, CI pra 3 plataformas com code signing e notarização no macOS, auto-update, e publicação automática no AUR. Com 621 testes. Em Rust, que não perdoa.

Sendo honesto: sem IA, um dev sênior bom levaria no mínimo 3-4 semanas nisso, provavelmente mais. Eu fiz em 7 dias, sozinho, e cada release tá publicado com binários que qualquer pessoa pode baixar e instalar.

O M.Akita Chronicles eu já estimei no [post anterior](/2026/02/20/do-zero-a-pos-producao-em-1-semana-como-usar-ia-em-projetos-de-verdade-bastidores-do-the-m-akita-chronicles/): ~200 user stories. Em Scrum com equipe sênior de 2-3 devs, sem impedimentos, seriam 10-15 semanas. Fiz em 8 dias. Hoje, 3 semanas depois, o sistema continua rodando, evoluindo, com 99 testes a mais do que quando *"acabou"*.

O FrankMega é mais modesto, mas file sharing seguro com Rails 8, I18n em 2 idiomas, 22 issues de segurança corrigidos, deploy via Docker, 210 testes. Fiz em 1 dia. Um sênior bom, sem IA, faria em 1-2 semanas na melhor das hipóteses.

E não estou falando de protótipos descartáveis. Gente de fora manda PR pro FrankMD. Assinantes reais recebem a newsletter do M.Akita Chronicles toda segunda-feira. Qualquer pessoa pode baixar o Frank Sherlock no GitHub Releases ou no AUR. CI verde, Brakeman zerado, testes reais, deploys automatizados. Isso é software de produção, não demo de conferência.

*"Ah, mas eu faço código melhor sem IA."* Talvez. Mas em quanto tempo? O que eu mostrei aqui não é que a IA faz código perfeito. Longe disso. É que com TDD, CI, pair programming com agente, e refactoring contínuo, o resultado final é código de produção com qualidade. 4.057 testes estão lá pra provar. Brakeman zerado. 125 commits de pós-produção mostram que o código aguenta evolução sem virar uma bola de lama.

E usar IA de vez em quando pra gerar um trecho de código aqui e ali, tipo autocomplete glorificado, também não é a resposta. Você tá deixando 90% do ganho na mesa. O que eu fiz em fevereiro foi pair programming full-time com um agente. Do primeiro commit ao deploy em produção. Com a mesma disciplina que eu usaria com um par humano. Resultado: 4 projetos em produção em 1 mês, com qualidade que eu coloco meu nome. Porque eu coloquei.

Se você é sênior e ainda tá esperando a IA *"melhorar"* pra começar a usar de verdade, eu digo o seguinte: ela já tá boa o suficiente. Os 692 commits estão aí pra provar. O gargalo agora é você aprender a trabalhar com ela.

## Conclusão

Em fevereiro de 2026, eu construí 4 projetos do zero à produção com IA. Mas a construção é a parte fácil. O que separa software de verdade de demo são os 125 commits que vieram depois, quando os bugs que ninguém previu apareceram, quando contribuidores externos mandaram PRs que precisaram de hardening, quando features novas surgiram do uso real e não de uma planilha de requisitos.

A IA me tornou absurdamente mais produtivo. Sem ela, o Frank Sherlock não teria face detection em 7 dias. Sem ela, o M.Akita Chronicles não estaria na 3ª semana de operação com 1.422 testes. A velocidade é real.

Mas nenhuma das decisões que importam veio da IA. Trocar de modelo, revertar o TTS no mesmo dia, olhar pro PR do contribuidor e ver que ia quebrar, pedir circuit breaker ao invés de retry. Tudo isso fui eu. A IA executou. As decisões foram minhas.

A IA é o acelerador. As técnicas de Extreme Programming (TDD, small releases, pair programming, refactoring contínuo) são o freio e a direção. Sem disciplina, IA produz código rápido que acumula dívida técnica mais rápido ainda. Com disciplina, IA produz software que evolui de verdade, semana após semana.

692 commits. 4.057 testes. 4 projetos em produção. E amanhã, segunda-feira, às 7h, os assinantes do The M.Akita Chronicles recebem a 3ª newsletter. Gerada, revisada, e enviada por um sistema que nunca vai estar *"pronto"*. Porque software pronto é software morto.

> "Software pronto é software morto. Software vivo itera."
