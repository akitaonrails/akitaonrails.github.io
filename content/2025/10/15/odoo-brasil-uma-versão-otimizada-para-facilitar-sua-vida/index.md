---
title: "Odoo Brasil, uma versão otimizada para facilitar sua vida"
author: "Erick Bruno (erickdevit)"
date: 2025-10-14T23:21:08-0300
draft: false
description: "Como configurar, buildar e deployar o Odoo 16 com módulos OCA Brasil usando Docker."
tags: []
categories: []
---

Olá, pessoal!

Hoje eu quero compartilhar um projeto pessoal que nasceu de uma necessidade que enfrentei diversas vezes ao longo da minha jornada com Odoo aqui no Brasil: a complexidade de configurar um ambiente de desenvolvimento limpo, replicável e alinhado com as particularidades brasileiras. Foi pensando em resolver essa dor que criei o **OdooBR**.

### A Motivação: Por que o OdooBR?

Quem trabalha com Odoo sabe que, embora seja uma ferramenta incrivelmente poderosa, preparar o ambiente de desenvolvimento pode ser um processo repetitivo e, por vezes, frustrante. Conflitos de dependências, configurações de banco de dados, instalação de módulos específicos (especialmente os de localização brasileira)... cada novo projeto exigia um ritual de setup.

Eu queria uma solução "plug-and-play". Um jeito de clonar um repositório, rodar um único comando e ter um ambiente Odoo funcional, com PostgreSQL e as dependências Python prontas para começar a desenvolver. A resposta para essa automação, como muitos de vocês já devem imaginar, estava no Docker.

### O que é o OdooBR?

O OdooBR é, em essência, um template de projeto que utiliza Docker e Docker Compose para orquestrar um ambiente de desenvolvimento Odoo completo e isolado. O objetivo é simples: **acelerar o setup inicial para que possamos focar no que realmente importa: desenvolver.**

A estrutura do projeto foi pensada para ser mínima, mas completa. Vamos dar uma olhada nos componentes principais:

```
/
├── docker-compose.yml
├── Dockerfile
├── odoo.conf
├── requirements.txt
└── ...
```

#### `docker-compose.yml`: O Maestro da Orquestra

Este é o coração do projeto. O `docker-compose.yml` define e conecta os dois serviços essenciais para o nosso ambiente:

1.  **`db`**: Um contêiner PostgreSQL, o banco de dados padrão do Odoo. Ele é configurado para ter um volume persistente, garantindo que seus dados não sejam perdidos ao reiniciar os contêineres.
2.  **`odoo`**: O contêiner da nossa aplicação Odoo. Ele é construído a partir do `Dockerfile` local, se conecta ao serviço `db` e expõe a porta `8069` para que possamos acessar a interface no nosso navegador.

#### `Dockerfile`: A Receita do Nosso Ambiente Odoo

Enquanto o `docker-compose` orquestra os serviços, o `Dockerfile` é responsável por construir a imagem personalizada do Odoo. Ele usa uma imagem oficial do Odoo como base e adiciona nossas próprias customizações. A principal delas é a instalação das dependências Python listadas no `requirements.txt`.

#### `requirements.txt`: As Dependências do Projeto

Aqui listamos todas as bibliotecas Python que nosso projeto Odoo irá precisar. Isso é especialmente útil para adicionar os módulos da localização brasileira ou qualquer outra dependência externa que seu projeto customizado venha a ter. Manter isso em um arquivo separado torna a gestão de dependências muito mais limpa.

#### `odoo.conf`: A Configuração Fina

Este é o arquivo de configuração padrão do Odoo. Através dele, definimos parâmetros cruciais como as credenciais de acesso ao banco de dados, o caminho dos addons (`addons_path`) e a senha de administrador (master password). No OdooBR, ele já vem pré-configurado para se conectar ao contêiner do PostgreSQL definido no `docker-compose`.

Configuração que Importa
```
ini[options]
admin_passwd = MUDE_ESTA_SENHA_AGORA
db_host = db
db_port = 5432
db_user = odoo
db_password = odoo
dbfilter = .*
list_db = True
addons_path = /seu/dir/addons
data_dir = /var/lib/odoo
logfile = /var/log/odoo/odoo.log
log_level = info
workers = 2
max_cron_threads = 1
limit_memory_hard = 2684354560
limit_memory_soft = 2147483648
limit_request = 8192
limit_time_cpu = 600
limit_time_real = 1200
```
**Configurações críticas explicadas:**

***admin_passwd:*** Senha mestre do Odoo. MUDE ISSO IMEDIATAMENTE.

***dbfilter:*** Regex para filtrar databases disponíveis. Em produção, use ^nome_empresa$

***addons_path:*** Caminho para os módulos. A ordem importa — primeiro os oficiais, depois OCA, depois custom

***workers:*** Número de processos. Regra: (CPU cores * 2) + 1

***limit_memory_hard/soft:*** Limites de RAM por worker (aqui: 2.5GB/2GB)

***limit_time_cpu/real:*** Timeouts para requisições (600s/1200s)

### Como Começar a Usar? (A Melhor Parte)

A simplicidade é o maior benefício do projeto. Para ter seu ambiente Odoo rodando, basta seguir estes três passos:

1.  **Clone o repositório:**
    ```bash
    git clone https://github.com/erickdevit/odoobr.git
    cd odoobr
    ```
2.  **Suba os contêineres:**
    ```bash
    docker-compose up -d
    ```
    Este comando irá baixar as imagens necessárias, construir o contêiner do Odoo e iniciar os serviços em background.

3.  **Acesse o Odoo:**
    Abra seu navegador e acesse `http://localhost:8069`. Pronto! Você verá a tela de criação de banco de dados do Odoo, com tudo funcionando.

### A força da comunidade

Um ponto essencial desse projeto é o uso dos módulos oficiais da OCA (Odoo Community Association), especialmente o pacote l10n-brazil, que garante conformidade com as normas fiscais e contábeis brasileiras.

Eu acredito profundamente na colaboração open source, e o OdooBR é meu modo de contribuir de volta para essa comunidade incrível que tem facilitado tanto o trabalho de quem desenvolve e implanta soluções Odoo.

### Contribuições

O OdooBR é um projeto de código aberto e está em constante evolução. A ideia é que ele sirva como uma base sólida para a comunidade. Penso em adicionar mais exemplos de módulos, scripts de automação e melhorar ainda mais a documentação.

Se você teve uma ideia, encontrou um bug ou quer adicionar uma melhoria, sinta-se à vontade para abrir uma *issue* ou enviar um *pull request* no GitHub. Toda contribuição é bem-vinda!

📦 Repositório oficial: github.com/erickdevit/odoobr

🐋 Imagem Docker: hub.docker.com/r/erickdevit/odoobr

Espero que este projeto seja tão útil para vocês quanto tem sido para mim. O objetivo é remover as barreiras iniciais e permitir que mais desenvolvedores possam mergulhar no incrível ecossistema do Odoo de forma rápida e eficiente.

Abraços e até a próxima!

### 🙏 Agradecimentos

-   [OCA (Odoo Community Association)](https://odoo-community.org/)
-   [l10n-brazil](https://github.com/OCA/l10n-brazil)
-   [account-payment](https://github.com/OCA/account-payment)
-   [bank-payment](https://github.com/OCA/bank-payment)

