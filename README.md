# AkitaOnRails - based on Hextra Starter Template

I have tweaked the Starter Template for the AkitaOnRails Blog. Check their github repo for more info.

I will accept some pull requests, but do not make any massive changes, only tweaks.

## Desenvolvimento Local

### Pré-requisitos

#### Docker (Recomendado)

- Docker e Docker Compose

#### Dependências locais

- Hugo (Extended version)
- Go
- Ruby
- Git

### Usando Docker

1. **Clone o repositório:**

```shell
git clone https://github.com/akitaonrails/akitaonrails.github.io.git
cd akitaonrails.github.io
```

1. **Inicie o ambiente:**

```shell
./scripts/dev.sh start
```

1. **Acesse o blog:**

- <http://localhost:1313>

1. **Comandos úteis:**

```shell
./scripts/dev.sh logs           # Ver logs
./scripts/dev.sh stop           # Parar ambiente
./scripts/dev.sh new-post       # Criar novo post
./scripts/dev.sh generate-index # Gerar índice
./scripts/dev.sh help           # Ver todos os comandos
./scripts/tag_catalog.rb --search "assuntos centrais" # Procurar tags canônicas
./scripts/tag_catalog.rb --check                      # Validar tags PT/EN
```

### Instalação Local

```shell
# clone repository
git clone https://github.com/akitaonrails/akitaonrails.github.io.git
cd akitaonrails.github.io

# adicionar conteúdo
nvim content/2025/08/29/hello/index.md

# gerar índices PT/EN da home, arquivo e seções
./scripts/generate_index.rb

# build completo (produção) — sem --gc para não invalidar o cache do Netlify
hugo --minify

# dev server rápido (só renderiza 2025+ via renderSegments + in-memory + fast render)
hugo server --renderSegments recent --renderToMemory -p 1313

# dev server completo (se precisar ver posts antigos)
hugo server --renderToMemory -p 1313
```

> **Performance do build no Netlify:** o `netlify.toml` está configurado com
> o `netlify-plugin-cache` persistindo `resources/_gen` e o cache de módulos
> do Hugo entre builds. O primeiro deploy depois de habilitar o cache é
> frio; os seguintes reusam imagens processadas, SCSS compilado e módulos
> remotos (~50–80% mais rápido). Por isso o build command não usa `--gc`:
> isso limparia exatamente o que queremos cachear.

## Homepage, descrições e tags

A homepage preserva a lista cronológica como visualização padrão e oferece
uma grade responsiva de cards. A escolha fica salva no navegador. Destaques,
posts mensais e cards usam o `description` do frontmatter como TL;DR; ao passar
o mouse sobre o link principal da lista ou sobre um card, o navegador mostra a
descrição completa.

Todo post publicado precisa de uma descrição concreta em cada idioma
disponível. A descrição é escrita uma vez a partir do artigo PT-BR final e
traduzida para o sibling `index.en.md`. Tags também são definidas primeiro em
PT-BR e mapeadas para os nomes EN pela taxonomia controlada em
`data/tag_taxonomy.yml`. Consulte `TAGGING.md` e procure antes de criar uma tag:

```shell
./scripts/tag_catalog.rb --search "título e assuntos centrais"
./scripts/tag_catalog.rb --check
```

As tags aparecem abaixo dos títulos na lista, nos cards e dentro dos artigos,
e levam às páginas de agrupamento do Hugo.

## Como Contribuir

### 1. Fork e Clone

- Faça um fork do repositório
- Clone seu fork localmente

### 2. Ambiente de Desenvolvimento

- Use Docker (recomendado) ou instale as dependências localmente
- Siga as instruções acima para configurar o ambiente

### 3. Fazendo Mudanças

- Crie uma branch para sua feature: `git checkout -b feature/nova-funcionalidade`
- Faça suas alterações
- Teste localmente usando `./scripts/dev.sh start` (Docker) ou `hugo server`
- Commit suas mudanças: `git commit -m "Adiciona nova funcionalidade"`

### 4. Criando Posts

```shell
# Com Docker
./scripts/dev.sh new-post "Título do Post"

# Manualmente
mkdir -p content/2025/01/15/meu-post
nvim content/2025/01/15/meu-post/index.md
```

### 5. Estrutura de um Post

```markdown
---
title: "Título do Post"
date: '2025-01-15T10:00:00-03:00'
description: "TL;DR concreto do artigo final."
tags:
- tag-canonica
- outra-tag
draft: false
---

Conteúdo do post aqui...
```

### 6. Pull Request

- Push para sua branch: `git push origin feature/nova-funcionalidade`
- Abra um Pull Request no GitHub
- Descreva suas mudanças claramente

## Estrutura do Projeto

```text
akitaonrails.github.io/
├── content/              # Posts PT-BR e siblings index.en.md
│   ├── _index.md         # Homepage PT-BR (auto-gerada)
│   ├── _index.en.md      # Homepage EN (auto-gerada)
│   └── archives/
│       └── _index*.md    # Arquivos PT/EN (auto-gerados)
├── data/
│   └── tag_taxonomy.yml  # Tags canônicas e mapeamento PT/EN
├── layouts/              # Templates, tags e lista/grade da homepage
├── assets/               # CSS, JS, imagens
├── hugo.yaml             # Configuração do Hugo (inclui render segments)
├── go.mod                # Dependências Go
├── scripts/
│   ├── generate_index.rb # Gera home, arquivos e índices de seções
│   └── tag_catalog.rb    # Busca, documenta e valida tags
├── TAGGING.md            # Catálogo gerado da taxonomia
├── Dockerfile            # Imagem Docker
└── docker-compose.yml    # Orquestração Docker (usa --renderSegments recent)
```

## Checklist para Contribuições

- [ ] Testei localmente com Docker ou instalação local
- [ ] Adicionei/revisei a descrição final em cada idioma publicado
- [ ] Reusei tags existentes após consultar `TAGGING.md`
- [ ] Validei a taxonomia (`./scripts/tag_catalog.rb --check`)
- [ ] Gerei o índice de posts (`./scripts/dev.sh generate-index` ou `./scripts/generate_index.rb`)
- [ ] Rodei o build completo (`hugo --minify`)
- [ ] Verifiquei se o site funciona corretamente
- [ ] Segui as convenções de nomenclatura do projeto
- [ ] Documentei mudanças significativas

## Diretrizes de Contribuição

- Mantenha mudanças pequenas e focadas
- Teste sempre antes de submeter
- Use mensagens de commit descritivas
- Respeite o estilo de código existente
- Para mudanças grandes, abra uma issue primeiro

## Licença

Shield: [![CC BY-NC-SA 4.0][cc-by-nc-sa-shield]][cc-by-nc-sa]

This work is licensed under a
[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License][cc-by-nc-sa].

[![CC BY-NC-SA 4.0][cc-by-nc-sa-image]][cc-by-nc-sa]

[cc-by-nc-sa]: http://creativecommons.org/licenses/by-nc-sa/4.0/
[cc-by-nc-sa-image]: https://licensebuttons.net/l/by-nc-sa/4.0/88x31.png
[cc-by-nc-sa-shield]: https://img.shields.io/badge/License-CC%20BY--NC--SA%204.0-lightgrey.svg
