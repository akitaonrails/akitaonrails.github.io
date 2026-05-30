---
title: "Boas práticas de projetos de código aberto com LLM - O Mínimo"
slug: "boas-praticas-projetos-codigo-aberto-llm-o-minimo"
date: '2026-05-30T13:00:00-03:00'
draft: false
translationKey: open-source-best-practices-llm-the-minimum
tags:
  - opensource
  - github-actions
  - ci-cd
  - docker
  - deploy
  - rust
  - AI
  - vibe-coding
---

Nos últimos meses eu publiquei uma penca de projetos pessoais no GitHub. [Frank FBI](https://github.com/akitaonrails/frank_fbi), [Frank Mega](https://github.com/akitaonrails/FrankMega), [Frank Yomik](https://github.com/akitaonrails/FrankYomik), [Frank Sherlock](https://github.com/akitaonrails/FrankSherlock), [Frank Investigator](https://github.com/akitaonrails/frank_investigator), [ai-jail](https://github.com/akitaonrails/ai-jail), [ai-memory](https://github.com/akitaonrails/ai-memory), [ai-usagebar](https://github.com/akitaonrails/ai-usagebar), [ghpending](https://github.com/akitaonrails/ghpending), e por aí vai. Alguns em Ruby on Rails, a maioria em Rust, um ou outro em Flutter. Programados em grande parte com Claude Code e Codex, no embalo da minha [maratona de vibe coding](/2026/05/14/terminando-maratona-ia-sucesso-ou-fracasso/).

E aqui está a parte que ninguém comenta quando fala de "fiz um projeto com IA": gerar o código é a parte fácil. O difícil, o que separa um repositório que é só um amontoado de código de um projeto de código aberto de verdade, é tudo que vem **depois** do `git init`.

Eu tenho uma opinião forte sobre isso, então vou cravar logo: nenhum projeto de código aberto está pronto pra ser publicado sem três coisas. Na ordem de importância:

1. **Superfície de instalação.** O novo usuário precisa conseguir instalar e testar a ferramenta com o mínimo de atrito possível. Um comando, de preferência.
2. **Testes e CI automatizado.** Pra que contribuições sejam mais fáceis e exista um chão comum sobre o que é minimamente aceitável pra entrar no projeto.
3. **Documentação.** A versão curta e fácil de ler (o README) e um conjunto mais detalhado em `docs/`, pra novos contribuidores entenderem as decisões arquiteturais.

Sem esses três, na minha visão, o projeto não está pronto. Pode ter o código mais genial do mundo dentro dele, não importa. Se um estranho não consegue instalar, não consegue confiar que o que ele mexer não vai quebrar tudo, e não consegue entender por que as coisas são do jeito que são, então você não tem um projeto de código aberto. Você tem um arquivo morto público.

E tem um bônus que virou parte essencial do meu fluxo: **quando todos os meus projetos seguem o mesmo padrão, eu posso simplesmente pedir pro Claude Code ou pro Codex "roda o deploy" ou "solta uma release", e eles conseguem.** Porque a estrutura é previsível. `bin/deploy` faz a mesma coisa em todo projeto. A release sai de um tag. O agente não precisa adivinhar nada. Padronização é o que torna a automação confiável. Parece preciosismo de gente organizada, mas é o pré-requisito pra eu confiar de olhos fechados no que o agente vai rodar.

Vou destrinchar os três pilares e mostrar o mínimo de configuração que eu uso na prática.

## Pilar 1: A superfície de instalação

Essa é a mais importante e a mais negligenciada. As pessoas passam semanas afinando o algoritmo interno e aí soltam um README que diz "clone o repo e rode `cargo build --release`". Aí o sujeito que tava curioso pra testar precisa ter Rust instalado, esperar dez minutos de compilação, e torcer pra não faltar uma lib de sistema. Você acabou de perder 90% dos seus usuários potenciais.

O ideal é oferecer **vários caminhos**, e deixar o usuário escolher o que combina com o ambiente dele. Olha o cabeçalho de instalação do ai-jail, que é o meu campeão de opções:

```sh
# Homebrew (macOS ou Linux)
brew tap akitaonrails/tap && brew install ai-jail

# AUR (Arch Linux) - binário pré-compilado
yay -S ai-jail-bin

# cargo (qualquer plataforma com Rust)
cargo install ai-jail

# mise
mise use -g github:akitaonrails/ai-jail

# Download direto do binário
curl -fsSL https://github.com/akitaonrails/ai-jail/releases/latest/download/ai-jail-linux-x86_64.tar.gz | tar xz
```

Cinco caminhos. O usuário de Arch usa `yay`. O do macOS usa `brew`. O dev Rust usa `cargo install`. Quem usa [mise](https://github.com/jdx/mise) pra gerenciar versões pega via mise. E quem só quer o binário baixa o tarball direto da release. Cada um pega o que já está acostumado, ninguém é forçado a instalar uma cadeia de ferramentas só pra experimentar.

### O segredo: compile uma vez, reempacote várias

A pegadinha que assusta no começo é achar que cada formato de pacote exige um build separado. Não exige. O truque é **compilar o binário uma vez por arquitetura, e depois reempacotar o mesmo binário em todos os formatos.**

No meu pipeline em Rust, o job de build gera um tarball com o binário pronto e o `sha256`. As etapas de empacotamento seguintes (Docker, AUR, Homebrew) **baixam esse tarball já compilado** ao invés de recompilar. Reduz tempo de CI, garante que o byte que vai pro AUR é exatamente o mesmo que vai pro Docker, e elimina aquela classe de bug "funciona num formato e quebra no outro".

```yaml
# Job de Docker reaproveitando o binário já compilado
docker-amd64:
  needs: build-linux
  steps:
    - uses: actions/download-artifact@v4
      with:
        name: ai-memory-linux-x86_64
        path: artifacts
    - name: Desempacota o binário pré-compilado
      run: tar -xzf artifacts/ai-memory-linux-x86_64.tar.gz -C dist/docker/
    - uses: docker/build-push-action@v6
      with:
        target: runtime-prebuilt-amd64  # injeta o binário, não recompila
```

O job do AUR faz a mesma coisa: baixa o tarball, calcula o `sha256`, e injeta no `PKGBUILD`:

```sh
X86_SHA=$(awk '{print $1}' artifacts/ai-usagebar-linux-x86_64.tar.gz.sha256)
sed -i "s/^sha256sums_x86_64=.*/sha256sums_x86_64=('$X86_SHA')/" packaging/aur/PKGBUILD-bin
```

Esse é o conceito central. O binário é o artefato de verdade. RPM, DEB, AppImage, AUR, tarball Homebrew, imagem Docker, tudo isso é só **embalagem em volta do mesmo binário**.

Os dois trechos acima são recortes. Se você quiser ver o fluxo inteiro funcionando, o build-once-reuse completo (binário compilado uma vez, reaproveitado nos jobs de Docker e AUR) está no [`release.yml` do ai-memory](https://github.com/akitaonrails/ai-memory/blob/main/.github/workflows/release.yml), e a injeção de `sha256` no `PKGBUILD` está no [`release.yml` do ai-usagebar](https://github.com/akitaonrails/ai-usagebar/blob/main/.github/workflows/release.yml).

### O cardápio de formatos

Cada plataforma tem seu mundo. Segue o mínimo que vale conhecer:

**Linux** é o mais fragmentado. As opções, do mais simples pro mais trabalhoso:

- **Tarball** (`.tar.gz`): o denominador comum. Funciona em qualquer distro, é só descompactar e jogar no `PATH`. Sempre ofereça esse.
- **AUR** (Arch): dois pacotes, o `-bin` (binário pré-compilado, instala em segundos) e o de source (compila na máquina do usuário). Eu publico os dois com a action `KSXGitHub/github-actions-deploy-aur`. O `-bin` é o que todo mundo usa.
- **AppImage**: um arquivo único executável que carrega todas as dependências dentro. Bom pra apps desktop. O Frank Sherlock, que é Tauri, gera AppImage direto no build e eu ainda assino com GPG depois (o passo de assinatura está no [`release.yml` dele](https://github.com/akitaonrails/FrankSherlock/blob/master/.github/workflows/release.yml)). Pra binário simples dá pra usar `appimagetool`.
- **RPM e DEB**: pra Fedora/openSUSE e Debian/Ubuntu. A ferramenta que poupa sua vida aqui é o [nfpm](https://github.com/goreleaser/nfpm), que gera os dois a partir de um único `nfpm.yaml` declarativo, sem precisar entender as entranhas de `rpmbuild` ou `dpkg-deb`. Pega o binário já compilado e cospe os dois pacotes.

**macOS** tem dois alvos: Apple Silicon (`aarch64-apple-darwin`) e Intel (`x86_64-apple-darwin`). Você compila os dois separados ou gera um binário universal com `lipo`. E aqui mora a maior dor de cabeça da plataforma: **assinatura e notarização**. Sem isso, o Gatekeeper do macOS recusa abrir seu app. O fluxo é decodificar o certificado P12, importar num keychain temporário, assinar com `codesign --options runtime --timestamp`, e notarizar:

```sh
codesign --sign "$APPLE_SIGNING_IDENTITY" --options runtime --timestamp ./meu-binario
ditto -c -k meu-binario notarize.zip
xcrun notarytool submit notarize.zip \
  --apple-id "$APPLE_ID" --password "$APPLE_PASSWORD" \
  --team-id "$APPLE_TEAM_ID" --wait
```

Isso exige uma conta paga de Apple Developer. É chato, mas é o preço de não dar erro de "app danificado" na cara do usuário. O job inteiro de assinatura e notarização, com a dança do keychain temporário, está no [`release.yml` do ai-jail](https://github.com/akitaonrails/ai-jail/blob/master/.github/workflows/release.yml).

**Windows** é o mais simples de buildar (`x86_64-pc-windows-msvc`) e o mais espinhoso de assinar. Certificado de code signing pra Windows é caro e burocrático, então eu, sinceramente, não assino. Aceito que o SmartScreen vai dar um aviso na primeira execução e deixo isso claro no README. Pra projeto pessoal de código aberto, está de bom tamanho.

**Rust crates** (`cargo publish`): se é uma biblioteca ou CLI em Rust, publicar no [crates.io](https://crates.io) dá o `cargo install` de graça. Uma linha no pipeline. Dica: torne idempotente, porque rodar de novo num tag já publicado dá erro. Eu faço um `grep` na saída procurando "already exists" pra não quebrar a release inteira por causa disso.

**Homebrew**: a forma limpa é manter um tap próprio (`akitaonrails/homebrew-tap`). O pipeline atualiza a fórmula com a nova URL e o novo `sha256` a cada release. O usuário faz `brew tap` uma vez e depois é só `brew upgrade`.

**mise**: o [mise](https://github.com/jdx/mise) consegue instalar direto de releases do GitHub sem você configurar nada do seu lado, contanto que seus tarballs sigam uma convenção de nome de plataforma. Você ganha esse caminho praticamente de graça só por ter releases bem nomeadas.

Repara num detalhe: AUR, Homebrew, mise e o download direto **todos consomem o mesmo tarball da release**. Você publica os binários uma vez, e quatro gerenciadores de pacote diferentes sabem se virar. É por isso que "compile uma vez, reempacote várias" é a regra de ouro.

## Pilar 2: GitHub Actions, releases por tag e changelog

A segunda coisa que torna um projeto de código aberto sério é CI. Esquece o selo de "build passing" no README, o valor está no chão comum que ele cria: quando alguém manda um pull request, o CI roda os testes, o linter e o scanner de segurança, e você sabe na hora se aquela contribuição quebra alguma coisa. Sem isso, todo PR vira uma negociação manual e cansativa.

Nos meus projetos Rust o CI roda `cargo fmt --check`, `cargo clippy -D warnings`, `cargo test`, e `cargo audit`. Nos projetos Rails, é `rubocop`, `brakeman` (scanner de segurança), `bundler-audit` e a suíte de testes em Minitest. O [FrankMD](https://github.com/akitaonrails/FrankMD) sozinho tem mais de 1800 testes entre Ruby e JavaScript. O Frank Sherlock passa de 300 testes em Rust mais 300 no frontend. É essa rede de segurança que me deixa aceitar PR de estranho sem medo.

### Revisão de PR com LLM

Os testes e o CI são a rede de baixo. Acima dela tem uma camada que virou central no meu fluxo: usar o próprio LLM pra revisar os pull requests. O Opus e o GPT são absurdamente bons em code review e em refatoração de qualidade. Melhores que eu na consistência, porque não cansam e não passam o olho por cima de 200 linhas só porque já é a quinta revisão do dia.

Eu tenho dois prompts que uso o tempo todo. O primeiro, pra um PR específico que acabou de chegar:

> olha o PR aberto no github. não confie na descrição do autor. audita o código a fundo pra ver se faz sentido. garante que não tem regressão nem queda na qualidade do código. garante que a cobertura de testes está adequada. depois me diz o que você acha que a gente deveria fazer.

Repara no "não confie na descrição do autor". Isso é de propósito. A descrição do PR conta o que a pessoa achou que fez, e nem sempre bate com o que ela realmente fez. O LLM tem que ler o código de verdade, não o resumo.

O segundo prompt é pra depois de uma sessão longa de código ou de vários PRs mergeados de uma vez:

> a gente mexeu em muito código. audita o código que esses PRs mudaram, procura código morto, duplicação desnecessária, valor mágico hardcoded que deveria ser constante e/ou estar melhor documentado, falta de cobertura de teste, mira nos princípios de [clean code](/2026/04/20/clean-code-para-agentes-de-ia/), e depois verifica se a documentação foi devidamente atualizada.

Com o parecer na mão, eu decido. Pra PR incompleto, o que eu faço depende do tamanho e da minha prioridade naquele momento. Se é coisa pequena, eu mesmo corrijo direto no PR com um `amend`, respondo explicando o que mudei, e aí mergeio e fecho. Quando dá pra mergear mas não dá pra corrigir antes, mergeio e já solto um commit de correção logo em seguida. E quando é mudança grande, peço pro LLM responder o PR explicando por que a gente não vai mergear, com a direção certa do que precisa ser feito.

Foi assim que eu fechei quase 40 PRs e 20 issues só no ai-memory, em poucos dias. Esse volume não sai na mão, e também não pode sair no piloto automático.

E é nesse ponto que eu mais bato: nada disso é cego. Eu estou o tempo todo pilotando o LLM na direção desses objetivos. Ele faz a auditoria, joga as sugestões na mesa e até escreve o texto da resposta, mas quem decide mergear, corrigir ou recusar sou eu. O LLM é o revisor incansável; eu sou quem assina embaixo.

### O gatilho por tag

A parte de release é separada do CI. Enquanto o CI roda a cada push e PR, a release dispara **só quando você empurra um tag de versão**:

```yaml
on:
  push:
    tags:
      - 'v*.*.*'   # dispara em v1.2.3, v0.5.0, etc.
  workflow_dispatch: # permite disparar manualmente também
```

O fluxo de soltar uma versão vira isso:

```sh
git tag v0.5.0
git push origin v0.5.0
```

E pronto. O GitHub Actions percebe o tag, dispara o workflow de release, compila pros alvos, empacota tudo, assina o que precisa assinar, cria o GitHub Release e publica nos gerenciadores de pacote. Eu não toco em mais nada. Inclusive é literalmente isso que eu peço pro Claude Code: "solta a v0.5.0". Ele faz `cargo set-version`, atualiza o CHANGELOG, commita, cria o tag, empurra, e o resto é o pipeline.

A matriz de build em Rust compila cada alvo na plataforma nativa dele:

```yaml
strategy:
  matrix:
    include:
      - os: ubuntu-22.04
        target: x86_64-unknown-linux-gnu
      - os: ubuntu-22.04-arm
        target: aarch64-unknown-linux-gnu
      - os: macos-latest
        target: aarch64-apple-darwin
      - os: windows-latest
        target: x86_64-pc-windows-msvc
```

Uma pegadinha de cross-compilation: se você compila ARM dentro de uma máquina x86 (via [cross](https://github.com/cross-rs/cross)), você **não consegue rodar os testes** daquele binário ali, porque a arquitetura não bate. A solução é rodar os testes só no alvo nativo e cross-compilar o resto sem testar. O ai-usagebar faz exatamente isso, x86 nativo e ARM via `cross`, na matriz do [`release.yml` dele](https://github.com/akitaonrails/ai-usagebar/blob/main/.github/workflows/release.yml). E sempre use cache de compilação: o `Swatinem/rust-cache` corta o tempo de build pela metade fácil.

### Release notes e changelog importam

Aqui é onde muita gente relaxa, e não devia. Quando você solta uma release, a pessoa que está pensando em atualizar quer saber **o que mudou**. "v0.5.0" não diz nada. Um changelog diz.

Eu mantenho um `CHANGELOG.md` no formato [Keep a Changelog](https://keepachangelog.com/), com uma seção por versão. E o pipeline extrai automaticamente a seção da versão atual pra colar no corpo do GitHub Release. Um `awk` simples resolve:

```sh
awk -v ver="$VERSION" '
  BEGIN { hdr = "## [" ver "]" }
  index($0, hdr) == 1 { flag=1; next }
  flag && index($0, "## [") == 1 { exit }
  flag { print }
' CHANGELOG.md > changelog_section.md
```

Esse `awk` é o mesmo que roda na release do ai-usagebar (de novo no [`release.yml` dele](https://github.com/akitaonrails/ai-usagebar/blob/main/.github/workflows/release.yml), que é o meu mais caprichado nessa parte). Aí eu anexo, depois do changelog, as instruções de instalação e os checksums `sha256` de cada artefato. O resultado é um GitHub Release que se explica sozinho: o que mudou, como instalar, e como verificar a integridade do download. O usuário lê e decide se atualiza. Esse é o tipo de cuidado que faz um estranho confiar no seu projeto.

## Pilar 3: Deploy de verdade, sem complicação

Os projetos que rodam como serviço (os Rails, principalmente) precisam ir pra algum lugar. E aqui eu vou na contramão do hype. Não tem Kubernetes. Não tem Kamal. Não tem pipeline de deploy de três estágios com aprovação manual.

Eu tenho um home server. Um [Minisforum MS-S1 Max rodando openSUSE MicroOS](/2026/03/31/migrando-meu-home-server-com-claude-code/) que eu migrei recentemente, com um [Gitea](https://github.com/go-gitea/gitea) servindo de registry Docker privado na porta 3007. Pra um desenvolvedor solo com um servidor caseiro simples, isso é mais que suficiente. Toda a cerimônia de orquestração de cluster é resolver um problema que eu não tenho.

O deploy inteiro cabe num único `bin/deploy`. Ele faz três coisas: builda a imagem, empurra pro registry, e dá um SSH no servidor pra subir a versão nova:

```sh
#!/usr/bin/env bash
set -euo pipefail

# Config vem de um arquivo .gitignored, fora do repositório
source "$(dirname "$0")/../config/deploy.env"

IMAGE="${REGISTRY_HOST}:${REGISTRY_PORT}/akitaonrails/frank_fbi:latest"

echo "==> Buildando a imagem..."
docker build -t "$IMAGE" .

echo "==> Empurrando pro registry..."
docker push "$IMAGE"

echo "==> Subindo no servidor..."
ssh "${DEPLOY_USER}@${DEPLOY_HOST}" \
  "cd ${REMOTE_DIR} && \
   docker compose pull && \
   docker compose down --remove-orphans && \
   docker compose up -d"
```

É isso. `build`, `push`, `ssh` com `pull`, `down`, `up`. Quatro comandos no servidor remoto, encadeados num SSH só. Sem agente rodando lá, sem webhook, sem painel de controle. O servidor tem um `docker-compose.production.yml` que aponta pra imagem `:latest` do registry, e o `pull` traz a versão nova.

Repara que os dados sensíveis ficam num `config/deploy.env` que **não vai pro Git**. No repositório vai só o `config/deploy.env.example`, com a estrutura e valores fictícios. Esse padrão de "exemplo versionado, real ignorado" se repete em todo projeto meu, e é o que permite o projeto ser público sem vazar host, usuário ou caminho do meu servidor.

A imagem em si vem de um Dockerfile multi-estágio. O estágio de build instala as ferramentas de compilação, builda tudo, e o estágio final copia só o resultado pra uma imagem enxuta, rodando como usuário não-root. O compose de produção troca `build:` por `image:`, aponta os volumes pros caminhos persistentes do servidor (`/var/opt/docker/...`) e usa `restart: always` pra subir tudo de novo se o servidor reiniciar.

E de novo a beleza da padronização: como **todo** projeto meu tem esse mesmo `bin/deploy`, eu posso falar pro Claude Code "faz o deploy do Frank FBI" e ele sabe exatamente o que rodar. Não preciso lembrar de comando nenhum. A ferramenta é a documentação executável do processo.

## A lição: ninguém liga pra sua stack

Agora a parte que eu mais queria escrever, e que vale mais que todos os snippets de YAML acima.

A maioria das pessoas, quando vai apresentar um projeto, concentra tudo na tecnologia. "Olha meu banco vetorial novinho." "Olha meu framework reativo de última geração." "Usei tal arquitetura de microsserviços." E enchem o topo do README com isso: a lista de dependências, o diagrama de componentes, a stack.

Ninguém liga.

Sério. O usuário que chega no seu README não quer saber qual banco de dados você usou. Ele quer saber **que problema isso resolve pra ele**. Detalhe de implementação não pertence ao topo do README. Pertence ao `docs/`, pra quem vai contribuir. No README, o que importa é o caso de uso.

Olha a diferença. "Servidor MCP em Rust com FTS5 e consolidação opcional via LLM" não diz nada pra ninguém. Agora "memória de longo prazo compartilhada entre Claude Code, Codex e Cursor, com handoff entre sessões" — isso o cara entende na hora, porque é a dor que ele tem. Os dois descrevem o ai-memory. Um fala de tecnologia, o outro fala do problema resolvido.

O caso de uso é a coisa mais importante do projeto inteiro. Antes de escrever uma linha de código, a pergunta certa é "que problema isso resolve, e pra quem?". Se você não consegue responder isso numa frase, você está construindo uma **solução em busca de um problema**. E solução em busca de problema é, na prática, solução que não resolve nada. Não importa quão elegante seja o código por dentro.

A camada de UX, a superfície que o usuário toca, vale muito mais que a engenharia interna. Um projeto com tecnologia medíocre mas que é trivial de instalar, que diz claramente que problema resolve, e que tem documentação honesta, vai mais longe que um projeto genial que ninguém consegue rodar. Toda vez.

Então o mínimo, o verdadeiro mínimo pra um projeto de código aberto, é isto: instalação fácil, CI que dá confiança, documentação que começa pelo problema. O algoritmo bonito vem muito depois disso na fila de prioridades. Os três pilares deste post existem pra servir uma coisa só, que é a experiência de quem chega de fora. Acerta isso primeiro. O resto é detalhe de implementação.
