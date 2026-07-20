---
title: "Criei um CLI pra Checar Pendências no Meu GitHub: ghpending"
slug: "criei-cli-pra-checar-pendencias-github-ghpending"
date: '2026-05-23T22:00:00-03:00'
draft: false
translationKey: criei-cli-pra-checar-pendencias-github-ghpending
description: "Akita criou o ghpending para consultar issues e PRs de vários repositórios num digest Rust, buscando tudo em paralelo e elevando o limite do GitHub de 60 para 5.000 req/h com token."
tags:
- ghpending
- automacao
- ferramentas-de-desenvolvimento
- controle-de-versao
---

Depois da minha [maratona de IA](/2026/05/14/terminando-maratona-ia-sucesso-ou-fracasso/), fiquei com dezenas de repositórios públicos no GitHub pra cuidar. Vários deles têm contribuidores postando issues e mandando pull requests. O problema é que abrir o navegador, entrar em cada repo, ver se tem alguma coisa nova esperando, vira um ritual cansativo que eu acabo evitando. E quando evito, fico semanas sem responder os colaboradores.

Sei que tem várias ferramentas que resolvem isso. Mas eu queria algo bem simples e rápido pra rodar no terminal e ver pendências de todos os meus projetos de uma vez só. Então fiz: o **[ghpending](https://github.com/akitaonrails/ghpending)**.

![Saída do ghpending no terminal: tabela compacta listando cada repo monitorado com contagem de issues e pull requests abertos, autor da última atividade e há quanto tempo.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/23/ghpending/ghpending-screenshot.png)

Roda em Linux e macOS. Eu testei em Linux (Arch + Omarchy) mas ainda não rodei no macOS. Se você for testar lá e topar com algum bug, abre uma issue lá: [github.com/akitaonrails/ghpending/issues](https://github.com/akitaonrails/ghpending/issues).

## Instalação

Três caminhos, escolhe o que mais combina com seu setup.

Via Homebrew (macOS ou Linux):

```sh
brew tap akitaonrails/tap && brew install ghpending
```

Via Cargo:

```sh
cargo install ghpending
```

Via mise:

```sh
mise use -g github:akitaonrails/ghpending
```

## Atualizando

```sh
# Homebrew
brew upgrade ghpending

# Cargo
cargo install ghpending --force

# mise
mise upgrade ghpending

# From source
cd ghpending && git pull && cargo install --path .
```

## Uso

Quatro comandos. O fluxo normal é rodar `ghpending add` uma vez pra configurar quais repos você quer monitorar, depois é só `ghpending` quando quiser ver o digest.

```sh
ghpending add    # pick os repos de um usuário ou org pra monitorar
ghpending        # imprime o digest de issues e PRs abertos
ghpending list   # mostra os repos monitorados
ghpending rm     # tira repos do monitoramento via menu interativo
```

O `add` pergunta o usuário ou organização, lista os repos públicos, e deixa você marcar os que quer acompanhar. O username fica salvo, então rodar `add` de novo já pula essa pergunta.

O comando principal (`ghpending` sem argumentos) busca todos os repos monitorados em paralelo e mostra a tabela com issues e PRs abertos.

## Token do GitHub (opcional)

Sem autenticação funciona, mas o GitHub limita em 60 requisições por hora pra anônimo. Pra subir esse teto pra 5.000 req/h, exporta um token:

```sh
GITHUB_TOKEN=$(gh auth token) ghpending
```

Ele é lido silenciosamente na inicialização, não precisa configurar nada.

## Onde fica o config

- Linux: `~/.config/ghpending/config.toml`
- macOS: `~/Library/Application Support/ghpending/config.toml`

Você pode editar direto se quiser reordenar ou trocar o `user`. Estrutura:

```toml
user = "akitaonrails"
repos = ["akitaonrails/ai-memory", "akitaonrails/ai-jail"]
```

## Por que esse CLI existe

A real é simples: ferramenta que eu fizesse pra mim mesmo, eu uso. Ferramenta de outro autor, sempre tem fricção (login web, opinião arquitetural diferente, feature que faltou ou sobrou). Como o objetivo era reduzir o atrito de checar 30 repos por semana, melhor 200 linhas de Rust escritas num sábado à tarde do que aprender um stack novo.

Agora espero conseguir responder as pendências dos colaboradores mais rápido. Se você achar útil, é MIT, PRs são bem-vindos.
