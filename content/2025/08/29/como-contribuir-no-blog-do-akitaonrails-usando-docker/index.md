---
title: Como Contribuir no Blog do AkitaOnRails usando Docker
date: "2025-08-29T22:37:16-03:00"
slug: como-contribuir-no-blog-do-akitaonrails-usando-docker
tags:
  - docker
  - hugo
  - desenvolvimento
  - contribuição
  - open-source
draft: false
---

Contribuir em projetos open source pode ser um saco quando você precisa configurar um ambiente de desenvolvimento complexo. No blog do AkitaOnRails, isso significava instalar Hugo Extended, Go, Ruby e suas dependências. Mas agora temos uma solução muito mais simples: **Docker**.

## O Problema

Antes, pra contribuir no blog você precisava:

1. Instalar Hugo Extended
2. Instalar Go
3. Instalar Ruby
4. Configurar todas as dependências
5. Gerar o índice de posts manualmente

Isso criava barreiras pra novos contribuidores e podia causar conflitos com outras instalações no sistema. Um inferno.

## A Solução: Docker

Agora você só precisa do Docker e Docker Compose. Tudo o resto roda em containers isolados.

### Setup Rápido

```bash
# Clone o repositório
git clone https://github.com/akitaonrails/akitaonrails.github.io.git
cd akitaonrails.github.io

# Inicie o ambiente
./scripts/dev.sh start

# Acesse o blog
open http://localhost:1313
```

Pronto! O blog está rodando e você pode começar a contribuir.

## Comandos Úteis

O projeto inclui scripts que facilitam o desenvolvimento:

```bash
# Ver todos os comandos disponíveis
./scripts/dev.sh help

# Criar um novo post
./scripts/dev.sh new-post "Título do Meu Post"

# Ver logs do servidor
./scripts/dev.sh logs

# Gerar índice de posts
./scripts/dev.sh generate-index

# Parar o ambiente
./scripts/dev.sh stop
```

## Criando um Post

Criar um novo post é super simples:

```bash
./scripts/dev.sh new-post "Como Contribuir no Blog do AkitaOnRails"
```

O script automaticamente:

- Cria a estrutura de diretórios com a data atual
- Gera um arquivo `index.md` com front matter básico
- O servidor Hugo recarrega automaticamente

## Estrutura de um Post

O arquivo criado terá esta estrutura:

```markdown
---
title: "Título do Post"
date: "2025-08-29"
draft: false
description: "Descrição do post"
tags: [tag1, tag2]
categories: [categoria]
---

Conteúdo do post aqui...
```

## Vantagens do Docker

### Para Contribuidores

- **Setup rápido**: Apenas Docker necessário
- **Ambiente isolado**: Não interfere com sistema local
- **Hot reload**: Mudanças aparecem automaticamente
- **Reproduzível**: Funciona igual para todos

### Para o Projeto

- **Menos issues**: Ambiente consistente
- **Mais contribuidores**: Barreira de entrada menor
- **Manutenção**: Fácil de atualizar dependências

## Como Funciona

O ambiente Docker inclui:

- **Hugo Extended**: Gerador de sites estáticos
- **Go**: Para módulos Hugo
- **Ruby**: Para script de geração de índice
- **Volumes**: Para hot reload dos arquivos

O `docker-compose.yml` mapeia os diretórios locais para o container, então quando você edita um arquivo, o Hugo detecta a mudança e recarrega automaticamente.

## Desenvolvimento Local (Alternativa)

Se preferir não usar Docker, ainda é possível instalar tudo localmente:

```bash
# Gerar índice
cd content && ruby generate_index.rb

# Rodar servidor
hugo server --logLevel debug --disableFastRender -p 1313
```

Mas o Docker é muito mais prático!

## Próximos Passos

1. **Teste o ambiente**: Execute `./scripts/dev.sh start`
2. **Crie um post**: Use `./scripts/dev.sh new-post`
3. **Explore o código**: Veja como personalizar layouts
4. **Contribua**: Faça um Pull Request

---

**Dica**: O ambiente Docker salva automaticamente suas mudanças e recarrega o servidor. Basta editar os arquivos e ver as mudanças em tempo real! 🚀
