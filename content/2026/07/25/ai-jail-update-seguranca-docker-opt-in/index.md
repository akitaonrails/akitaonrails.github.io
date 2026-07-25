---
title: "AI-Jail: update de segurança, Docker vira opt-in"
slug: "ai-jail-update-seguranca-docker-opt-in"
date: '2026-07-25T13:00:00-03:00'
draft: false
translationKey: ai-jail-update-seguranca-docker-opt-in
description: "O issue #88 provou que o socket do Docker no ai-jail dava root no host a qualquer agente. Na v1.16.0 o passthrough virou opt-in. A falha, a demo, as boas práticas e por que o Podman nasceu dessa crítica."
tags:
- ai-jail
- containers
- seguranca
---

Hoje de manhã abriram um issue importante no repositório do [ai-jail](https://github.com/akitaonrails/ai-jail): o [issue #88](https://github.com/akitaonrails/ai-jail/issues/88), reportado pelo [@mdindoffer](https://github.com/mdindoffer), com o título "Sandbox escape via a docker socket passthrough (effective host root)".

O report procedia, e a correção já está disponível na **v1.16.0**.

## Atualize pra v1.16.0

Se você usa o ai-jail, o update é o de sempre:

```bash
# Arch Linux (AUR)
yay -Syu ai-jail-bin

# Homebrew (macOS / Linux)
brew update && brew upgrade ai-jail

# crates.io
cargo install ai-jail --force

# mise
mise cache clear && mise upgrade github:akitaonrails/ai-jail
```

## O que mudou na v1.16.0

Até a v1.15.x, o ai-jail montava o socket do Docker dentro da jaula automaticamente, sempre que `/var/run/docker.sock` existia no host. Read-write. Sem aviso, sem flag, sem pedir opinião. Eu documentei isso no README como "favorece usabilidade", e era verdade: agente de coding frequentemente precisa rodar um `docker compose` pra subir banco de testes, e o passthrough automático poupava configuração.

A partir da v1.16.0 o comportamento inverteu:

- O passthrough do socket ficou **desligado por padrão**. Só entra se você pedir explicitamente com a flag `--docker` ou com `no_docker = false` no `.ai-jail`.
- Quando você liga e existe um socket no host, o ai-jail imprime um aviso na largada deixando claro que aquilo equivale a dar root no host pro processo dentro da jaula.
- O `ai-jail status` agora mostra Docker como `disabled (default)`, pra ninguém achar que ligou sem querer.
- Nos modos `--lockdown` e browser profile o socket nunca entra, como já era antes.

Mudança de comportamento, sim, e de propósito. Se o seu workflow depende de Docker dentro da jaula (o meu depende em alguns projetos), o opt-in é uma linha no `.ai-jail` do projeto:

```toml
no_docker = false
```

O nome do campo ficou feio (`no_docker = false` pra ligar, eu sei), mas configs antigas continuam parseando igual e o `--no-docker` / `no_docker = true` funcionam como antes. Só o default mudou. Os detalhes estão nas [release notes da v1.16.0](https://github.com/akitaonrails/ai-jail/blob/master/releases/v1.16.0.md).

## O que o issue #88 mostrou

O report do mdindoffer é daqueles que todo mantenedor quer receber: resumo preciso, repro em poucas linhas, proposta de correção. A essência:

O ai-jail montava o socket **cru** do Docker dentro da sandbox, read-write. O daemon do Docker roda como root no host. Logo, um agente dentro da jaula podia rodar isto:

```bash
docker run --rm -v /:/host alpine sh -c 'cat /host/etc/shadow'
```

E pronto. Leitura de qualquer arquivo do host, como root. Isso derrota de uma vez só o `$HOME` em tmpfs, o `--mask`, o `--deny-path` e o Landlock, porque a ação deixa de acontecer dentro da sandbox: acontece no daemon, que vive fora e acima de qualquer namespace que o bwrap criou. O agente nem precisa escapar da jaula quando a jaula tem uma porta que dá direto na sala de máquinas.

Em retrospecto, deixar isso ligado por padrão foi uma falha de design. Eu sabia que o passthrough era "perigoso" no abstrato, tanto que escrevi isso no README. O que eu não tinha internalizado: perigoso desse jeito, com esse default, já é vulnerabilidade.

O mdindoffer ainda propôs o caminho de hardening definitivo: em vez de montar o socket cru, interpor um proxy filtrado (estilo o [wollomatic/socket-proxy](https://github.com/wollomatic/socket-proxy)) que só aceita bind mounts de caminhos que o agente já pode escrever dentro da jaula. Está no radar pra uma versão futura. Pra fechar o buraco agora, opt-in com aviso explícito resolve o default, que era onde o problema morava.

## A classe de vulnerabilidade: docker.sock é root

Essa não é a primeira vez que eu esbarro nessa história, e aposto que também não é a sua. "Quem tem acesso ao socket do Docker tem root no host" é um dos clássicos da segurança de containers, documentado pela própria Docker na página de [daemon attack surface](https://docs.docker.com/engine/security/): só usuários confiáveis devem controlar o daemon, porque o Docker permite compartilhar qualquer diretório do host com um container, sem restrição nenhuma de acesso.

O motivo técnico é simples. O `dockerd` é um daemon que roda como root e obedece comandos que chegam pela API no socket Unix `/var/run/docker.sock`. A CLI `docker` é só um cliente dessa API. Quando você pede `docker run -v /:/host`, quem cria o container e monta o filesystem inteiro do host dentro dele é o daemon, com privilégio total. E processo dentro de container roda como uid 0 por padrão, que o kernel enxerga como uid 0 de verdade (salvo user namespace remapping, que quase ninguém liga). A conta fecha: acesso de escrita no socket equivale a root no host. O grupo `docker` é sudo sem senha com outro nome.

## A demonstração, na sua máquina

Se você tem Docker instalado e seu usuário no grupo `docker`, reproduz agora. Sem sudo, sem explorar bug nenhum:

```bash
# confirme que você é um usuário comum
$ id
uid=1000(akitaonrails) gid=1000(akitaonrails) groups=...,docker

# tente ler o /etc/shadow diretamente: negado, como esperado
$ cat /etc/shadow
cat: /etc/shadow: Permission denied

# agora peça pro daemon fazer isso por você
$ docker run --rm -v /:/host alpine sh -c 'head -3 /host/etc/shadow'
root:$6$...:...
bin:!:...
daemon:!:...
```

E se quiser o pacote completo, uma shell de root no seu próprio host:

```bash
$ docker run --rm -it -v /:/host alpine chroot /host /bin/bash
# id
uid=0(root) gid=0(root) groups=0(root)
```

Nenhum exploit, nenhum 0-day. Você usou a API oficial, do jeito documentado, e saiu de usuário comum pra root em um comando. Era exatamente isso que um agente dentro do ai-jail conseguia fazer até hoje, mesmo com todas as camadas (bwrap, Landlock, seccomp, rlimits) ligadas.

## Por que isso ainda existe?

Se todo mundo sabe disso há mais de uma década, por que ninguém "consertou"? A resposta curta: isso é arquitetura, e arquitetura não se resolve com patch.

- O daemon root com API todo-poderosa foi o design que fez o Docker simples de operar. Autorização granular por requisição existe na forma de [authorization plugins](https://docs.docker.com/engine/extend/plugins_authorization/), mas é opt-in, chata de configurar, e eu conto nos dedos os setups que já vi usando.
- O [userns-remap](https://docs.docker.com/engine/security/userns-remap/) existe desde o Docker 1.10 e mapeia o root do container pra um usuário sem privilégio no host. Vem desligado de fábrica, porque quebra compatibilidade com imagens e volumes que assumem uid 0.
- O [rootless mode](https://docs.docker.com/engine/security/rootless/) roda o daemon inteiro como o seu usuário, com o socket em `$XDG_RUNTIME_DIR/docker.sock`. Funciona, mas tem restrições de rede e storage, e a internet inteira de tutoriais assume o daemon root no caminho clássico.
- O [Podman](https://podman.io/) nasceu rootless e sem daemon justamente por causa dessa crítica. Tem uma seção inteira sobre ele logo abaixo.

Resumindo: isso vai continuar existindo. Toda ferramenta que monta `/var/run/docker.sock` dentro de um ambiente "pra conveniência" abre o mesmo buraco, consciente ou não. CI que monta o socket pra build de imagem, IDE remota, code-server, sandbox de agente de IA (oi, eu), plugin de painel web. O ajuste fica sempre do lado de quem monta o ambiente.

## Curiosidade: isso é tudo, menos novo

Se você me acompanha há algum tempo, essa história toda deve ter dado déjà vu. Em 2023 eu gravei o [[Akitando #139] - Entendendo Como Containers Funcionam](/2023/03/02/akitando-139-entendendo-como-containers-funcionam/), onde eu explico o que um container realmente é: um processo comum do Linux, limitado por cgroups, enganado por namespaces, com as capabilities cortadas. Sem mágica e sem máquina virtual. E olha o que já estava na lista de links daquele episódio: um walkthrough de [privilege escalation via Docker](https://flast101.github.io/docker-privesc/), demonstrando exatamente o truque do `docker run -v /:/host`. O buraco que o issue #88 explorou dentro do ai-jail é o mesmo que eu já apontava num video de 2023, e que já era manjado muito antes disso.

Ninguém sabe disso melhor que a Red Hat. O [Podman](https://podman.io/) nasceu lá em 2018 como resposta direta a essa arquitetura: sem daemon central, rootless por padrão. Cada container vira filho direto do seu usuário, via fork-exec, sem um processo todo-poderoso rodando como root intermediando nada. O "docker.sock é root" simplesmente não existe nesse modelo, porque não existe nem docker.sock, nem daemon, nem root.

E antes que você pergunte: sim, eu uso Podman em algumas coisas e recomendo. Mas ele também não é solução perfeita, e vale entender o porquê.

O que o Podman faz bem:

- **A arquitetura certa.** Daemonless e rootless desde o dia zero. A classe inteira de vulnerabilidade deste artigo perde o sentido.
- **Compatibilidade de CLI.** `alias docker=podman` cobre a maioria esmagadora dos comandos do dia a dia. Build, run, push, pull: mesmos comandos, mesmas flags.
- **Integração com systemd.** Os [Quadlets](https://docs.podman.io/en/latest/markdown/podman-systemd.unit.5.html) são, na minha opinião, o jeito mais limpo de rodar container como serviço no Linux. O Docker nunca chegou perto disso.

E onde ele tropeça:

- **O socket de compatibilidade não é 100%.** O Podman oferece um socket compatível com a API do Docker (o `podman.socket`), e muita ferramenta funciona em cima dele. Mas "muita" não é "toda": Testcontainers, alguns plugins de IDE, ferramentas de CI mais exóticas tropeçam em diferenças de comportamento. Funciona até o dia em que não funciona, e aí você perde uma tarde debugando.
- **Compose é cidadão de segunda classe.** O `docker compose` oficial até conversa com o socket do Podman, e existe o `podman-compose`, mas nenhum dos dois tem a mesma redondeza do par original. Projeto com compose complicado é onde a migração costuma enroscar.
- **Rootless tem preço.** A rede rootless (slirp4netns, e hoje o pasta) tem limitações: sem ping por padrão, IP de origem esquisito, throughput menor. Imagem que assume uid 0 e volume com permissão errada pedem ajuste. Nada grave, mas é atrito.
- **Docker Desktop é um produto.** No macOS e no Windows, o Docker Desktop entrega uma experiência polida que o Podman Desktop ainda está alcançando. Pra muita gente, esse é o único contato com containers que existe.

Somando tudo, você chega na resposta de por que o mundo continua no Docker: inércia de ecossistema. Todo tutorial, todo CI, toda imagem de exemplo, todo `docker run` colado de Stack Overflow assume o daemon root no caminho clássico. O Docker virou o nome da categoria, tipo Bombril. Migrar pro Podman é tecnicamente fácil e politicamente caro: é você contra o conhecimento acumulado da internet inteira.

Um detalhe que importa pra quem usa sandbox: montar o socket do Podman rootless dentro de uma jaula é bem menos catastrófico que montar o do Docker. O "daemon" equivalente roda como o seu usuário, então um agente mal-intencionado ganharia os seus privilégios, não root. Continua ruim (dá pra sobrescrever o seu `~/.ssh` com eles, por exemplo), mas é outro campeonato. Mesmo assim, o default do ai-jail continua valendo: não montar socket nenhum, de runtime nenhum. Opt-in é opt-in.

## Boas práticas pra isso não morder você

A lista que eu aplico e recomendo:

1. **Trate o grupo `docker` como sudo sem senha.** Antes de adicionar qualquer usuário ou serviço nele, pergunte se você daria sudo irrestrito pra aquilo. É a mesma coisa.
2. **Nunca monte `/var/run/docker.sock` em ambientes não confiáveis.** Agente de IA, job de CI que roda código de pull request de estranho, container de terceiro. Faça um `grep -r docker.sock` nos seus docker-compose, manifests de CI e configs de ferramentas. Aparece em mais lugares do que você lembra.
3. **Precisou expor pra algo semiconfiável? Use um socket proxy.** O [wollomatic/socket-proxy](https://github.com/wollomatic/socket-proxy) e o [docker-socket-proxy da Tecnativa](https://github.com/Tecnativa/docker-socket-proxy) ficam entre o cliente e o daemon com allowlist de endpoints e bloqueio de bind mounts arbitrários. Read-only por padrão, você liga só o que precisa.
4. **Prefira rootless sempre que possível.** Podman rootless no Linux é o caminho mais limpo; o rootless mode do próprio Docker é a segunda opção. O daemon deixa de ser root e essa classe inteira de problema perde a mordida.
5. **Em CI, construa imagem sem daemon privilegiado.** [Kaniko](https://github.com/GoogleContainerTools/kaniko) e [Buildah](https://buildah.io/) constroem imagens rootless, sem precisar montar socket nenhum no job.
6. **Não conseguiu rootless? Ligue o userns-remap.** Custa uma tarde de testes com seus volumes e compra isolamento real entre o root do container e o root do host.
7. **No ai-jail, deixe o default trabalhar por você.** Docker desligado, e `--docker` só nos projetos onde você confia no workload como confiaria num sudo. Regra prática: se você não daria `sudo` cego pro agente naquele diretório, também não dê `--docker`.

## Conclusão

Uma sandbox bem construída perde boa parte do valor se tiver uma porta dos fundos aberta por conveniência. O bwrap, o Landlock, o seccomp e os rlimits do ai-jail continuam fazendo o trabalho deles, mas nenhum deles enxerga o que acontece quando o processo lá dentro pede gentilmente pro daemon root do host montar o filesystem inteiro num container. Camada de segurança que você não audita vira decoração.

Meu agradecimento público ao [@mdindoffer](https://github.com/mdindoffer): report limpo, repro mínima, severidade correta e ainda por cima proposta de solução. É assim que se reporta vulnerabilidade em projeto open source.

Se você quer o contexto completo de como eu uso sandbox no dia a dia, escrevi sobre isso em [Como me precaver pros meus agentes não apagarem minhas coisas?](/2026/07/11/como-me-precaver-pros-meus-agentes-nao-apagarem-minhas-coisas/). A história do ai-jail está em [AI Agents: Garantindo a Proteção do seu Sistema](/2026/01/10/ai-agents-garantindo-a-protecao-do-seu-sistema/) e na [reescrita em Rust](/2026/03/01/ai-jail-sandbox-para-agentes-de-ia-de-shell-script-a-ferramenta-real/).

Agora vai lá e roda o upgrade.
