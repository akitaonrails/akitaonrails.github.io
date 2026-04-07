---
title: "SmallTips: Rodando o GitLab CI Runner Localmente"
date: '2018-04-28T18:35:00-03:00'
slug: smalltips-rodando-o-gitlab-ci-runner-localmente
translationKey: gitlab-ci-runner-locally
aliases:
- /2018/04/28/smalltips-running-gitlab-ci-runner-locally/
tags:
- smalltips
- gitlab
- traduzido
draft: false
---

Se tem uma coisa que você sempre deve fazer é manter sua suíte de testes. A cada bug corrigido, a cada nova funcionalidade, adicione novos testes.

Nas últimas semanas trabalhei muito pesado, literalmente codificando sem parar, sete dias por semana. Lembra daquela história de "para de reclamar que não tem tempo, o que você faz da meia-noite às 6 da manhã?"? Pois é, isso não se aplica a mim.

E é justamente quando você está com sono e exausto que começa a cometer erros. Mesmo que o seu código rode localmente, você vai se ferrar em uma dessas sessões de código às 3 da manhã.

A suíte de testes foi minha salvação nesses momentos — meu copiloto, me trazendo de volta à razão sempre que a noite ficava pesada demais.

Mantenho meu próprio servidor GitLab para todos os projetos de clientes e internos da empresa. É só um pouco de paranoia, para garantir que meu código fica comigo. E o GitLab é uma ferramenta fantástica, ainda mais porque tem [seu próprio sistema de Integração Contínua](https://about.gitlab.com/features/gitlab-ci-cd/).

Basta adicionar o arquivo `.gitlab-ci.yml` ao projeto, criar uma branch, fazer o push e abrir um Merge Request — o CI entra em ação, com [jobs paralelos](https://docs.gitlab.com/ee/ci/yaml/#jobs) se você quiser. Mesmo quando eu esquecia de rodar os testes localmente, o CI não me deixava passar.

Manter o CI funcionando exige que você pare e cuide das specs periodicamente. Às vezes você vai se perguntar: por que esse teste passa na minha máquina mas continua falhando no servidor de CI?

É aí que fica muito útil rodar a imagem Docker do CI localmente, para resolver de vez aquelas inconsistências de ambiente.

Você consegue fazer isso rodando o próprio GitLab CI Runner. Ele lê o `.gitlab-ci.yml` do seu projeto e executa tudo localmente via Docker. Qualquer problema que aparece no servidor vai se reproduzir localmente também. Com a vantagem de que você não precisa entrar em fila caso haja outros jobs aguardando execução (muitos desenvolvedores trabalhando, poucas máquinas disponíveis para processar tudo na hora). E você não fica poluindo essa fila com jobs desnecessários.

Se você seguiu minhas recomendações e instalou a excelente distro Arch Linux (ou meu derivado favorito, Manjaro Gnome), pode instalar o runner pelo AUR assim:

```
pacaur -S gitlab-runner
```

Caso contrário, verifique os repositórios da sua distro ou baixe o binário [aqui](https://gitlab.com/gitlab-org/gitlab-runner/blob/master/docs/install/bleeding-edge.md#download-the-standalone-binaries). Por exemplo:

```
wget https://gitlab-runner-downloads.s3.amazonaws.com/master/binaries/gitlab-runner-linux-amd64
sudo mv gitlab-runner-linux-amd64 /usr/local/bin
sudo chmod +x /usr/local/bin/gitlab-runner
```

Com o runner instalado, suponha que você tenha um trecho assim no seu `.gitlab-ci.yml`:

```yaml
backend:
  stage: test
  script:
    - ./bin/cc-test-reporter before-build
    - bundle exec rspec --exclude-pattern "**/features/**/*_spec.rb"
  after_script:
    - ./bin/cc-test-reporter after-build --exit-code $? || true
```

Você pode configurar vários jobs de teste rodando em paralelo. Recomendo separar: testes JS de front-end, testes unitários de back-end com Rspec/minitest, testes de feature com Capybara, verificações de segurança com Brakeman, por exemplo. Cada um roda em paralelo e você não precisa esperar tudo terminar se só quer ver o resultado dos testes de JS. Feedback mais rápido, correção imediata.

Localmente, a partir da raiz do projeto, basta rodar:

```
gitlab-runner exec docker backend
```

Claro, assumindo que você já tem o Docker instalado e configurado. Se não tiver, leia [o excelente artigo do Arch Wiki sobre Docker](https://wiki.archlinux.org/index.php/Docker#Installation) — basicamente é instalar o pacote Docker e se adicionar ao grupo docker.

É isso! Super simples, quase sem fricção, e o runner faz tudo que o servidor GitLab CI faria.

Um porém: infelizmente, parece que você [não consegue salvar cache ou artefatos](https://gitlab.com/gitlab-org/gitlab-runner/issues/2409) entre execuções (gems, pacotes npm, etc.), então toda vez que o runner local roda, ele começa do zero. Isso o torna menos útil para uso contínuo, mas ainda é mais rápido do que fazer push para o servidor e esperar sua vez numa fila cheia.

Já me salvou algumas vezes.
