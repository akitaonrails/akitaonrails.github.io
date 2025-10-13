# AkitaOnRails - based on Hextra Starter Template

I have tweaked the Starter Template for the AkitaOnRails Blog. Check their github repo for more info.

I will accept some pull requests, but do not make any massive changes, only tweaks.

## Desenvolvimento Local

### Pré-requisitos

**Docker (Recomendado)**

- Docker e Docker Compose

**Instalação Local**

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

2. **Inicie o ambiente:**

```shell
./scripts/dev.sh start
```

3. **Acesse o blog:**

- <http://localhost:1313>

4. **Comandos úteis:**

```shell
./scripts/dev.sh logs           # Ver logs
./scripts/dev.sh stop           # Parar ambiente
./scripts/dev.sh new-post       # Criar novo post
./scripts/dev.sh generate-index # Gerar índice
./scripts/dev.sh help           # Ver todos os comandos
```

### Instalação Local

```shell
# clone repository
git clone https://github.com/akitaonrails/akitaonrails.github.io.git
cd akitaonrails.github.io

# adicionar conteúdo
nvim content/2025/08/29/hello/index.md

# gerar índice
./scripts/generate_index.rb

# build
hugo

# rodar servidor
hugo server --logLevel debug --disableFastRender -p 1313
```

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
date: 2025-01-15T10:00:00-03:00
draft: false
description: "Descrição do post"
tags: [tag1, tag2]
categories: [categoria]
---

Conteúdo do post aqui...
```

### 6. Pull Request

- Push para sua branch: `git push origin feature/nova-funcionalidade`
- Abra um Pull Request no GitHub
- Descreva suas mudanças claramente

## Estrutura do Projeto

```
akitaonrails.github.io/
├── content/           # Posts e páginas (Markdown)
├── layouts/           # Templates HTML
├── assets/            # CSS, JS, imagens
├── hugo.yaml         # Configuração do Hugo
├── go.mod            # Dependências Go
├── scripts/          # Scripts de desenvolvimento
├── Dockerfile        # Imagem Docker
└── docker-compose.yml # Orquestração Docker
```

## Checklist para Contribuições

- [ ] Testei localmente com Docker ou instalação local
- [ ] Gerei o índice de posts (`./scripts/dev.sh generate-index`)
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
