---
title: "AI-MEMORY 2.0 - o melhor sistema de memória para agentes e times"
slug: "ai-memory-2-0-melhor-sistema-memoria-agentes-e-times"
date: '2026-09-02T11:00:00-03:00'
draft: false
translationKey: ai-memory-2-0-melhor-sistema-memoria-agentes-e-times
description: "O ai-memory chegou na versão 2.0 com formato aberto OKF, embeddings locais por padrão e suporte a times trabalhando em paralelo. Comparo com a concorrência e mostro o que só o ai-memory entrega."
tags:
- ai-memory
- agentes-de-codigo
- open-source
---

**TL;DR:** a [ai-memory 2.0 já está no ar](https://github.com/akitaonrails/ai-memory/releases/tag/v2.0.0), com formato aberto OKF, embeddings locais ligados por padrão e suporte de verdade a vários agentes e a um time inteiro trabalhando no mesmo projeto em paralelo. Abaixo vai o pitch completo.

Em julho eu publiquei [Novidades no meu AI-MEMORY](/2026/07/20/novidades-no-meu-ai-memory-cada-vez-melhor-pra-usar-com-suas-ias/), onde mostrei o `ai-memory run`: trocar de Claude Code pra Codex sem perder a linha de trabalho. Naquele dia estávamos na versão 1.17.1.

Hoje saiu a **2.0**. E dessa vez não vou repetir como os hooks funcionam nem como uma sessão vira página de wiki. Isso já está nos textos anteriores. Aqui eu quero falar de onde o ai-memory chegou frente à concorrência, o que a 2.0 traz e por que ela mereceu virar um "2".

Se você nunca ouviu falar do projeto, o resumo é curto. O ai-memory é um servidor de memória de longo prazo pros seus agentes de código. Ele captura o que aconteceu na sessão, consolida em páginas Markdown e devolve o contexto certo pro próximo agente, seja qual for o harness ou a máquina.

![Navegador web do ai-memory 2.0 mostrando a lista de projetos da wiki, com o aviso de backup pré-migração para o formato OKF e cartões de vários projetos como ai-memory, akitaonrails-hugo e outros](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260902132131_screenshot-2026-09-02_13-20-02.png)

Essa é a interface web que vem junto, boa pra auditar o que os agentes gravaram e pra navegar entre os projetos. Repare que cada projeto vive separado, com sua própria contagem de páginas, tudo saído das sessões de verdade.

## Por que virou 2.0

Pra mim, o primeiro número de uma versão carrega um compromisso.

A família 1.x cresceu rápido demais. Saímos da 1.1 e chegamos na 1.39 em pouco mais de dois meses, empilhando funcionalidade atrás de funcionalidade em releases menores. Funcionou pra iterar, mas embaralhou o significado dos números.

A 2.0 arruma isso. Ela junta as poucas mudanças que quebram compatibilidade num único major, e a partir daqui o versionamento passa a seguir [Semantic Versioning](https://github.com/akitaonrails/ai-memory/blob/main/CONTRIBUTING.md) de verdade. Correção vira patch. Funcionalidade nova vira minor. Só quebra de formato ou de contrato vira major, e sempre com aviso. O novo guia de contribuição deixa essa regra explícita pra qualquer PR.

A quebra principal é o novo formato em disco. Na primeira vez que você sobe a 2.0, ela migra sua wiki sozinha. Antes de mexer em qualquer coisa, ela compacta todo o seu diretório de dados num backup verificado com data no nome. Se o backup não puder ser gravado e conferido, a migração aborta e o servidor se recusa a subir. Nada de "confia em mim".

![Diálogo do ai-memory 2.0 avisando que a memória foi migrada para o formato OKF v0.2, com o caminho do backup verificado e os passos de rollback](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20260902131952_screenshot-2026-09-02_13-16-17.png)

Esse é o aviso que aparece uma vez, depois da migração: ele diz onde ficou o backup, o tamanho do arquivo e como voltar atrás se algo parecer errado. Quando você confirma que está tudo certo, é só apagar o backup e o lembrete some.

## OKF: sua memória não fica presa no ai-memory

Essa é a mudança que mais me deixou satisfeito.

A partir da 2.0 a wiki do ai-memory é, nativamente, um bundle no **Open Knowledge Format**, o formato aberto que o Google publicou em 2026. Cada página de memória é um arquivo OKF válido: Markdown comum com metadados padronizados. Não existe passo de exportação que gera uma cópia divergente. Os arquivos da wiki já são os arquivos OKF.

Na prática isso quer dizer que sua memória deixou de ser refém do meu projeto. Você pode ler tudo com `grep`, abrir no Obsidian, versionar no Git ou entregar o bundle pra um colega que usa outra ferramenta compatível com OKF. Tem até um `ai-memory export-okf` pra empacotar um projeto inteiro num tarball validado.

Sempre foi essa a tese: modelo e harness são alugados, a memória do projeto é sua. Agora o formato reforça isso por escrito.

## Embeddings locais, ligados por padrão

Até a 1.x, busca semântica de verdade dependia de você configurar um provider de embeddings. Ou pagava uma API e mandava cada página e cada query pra fora, ou subia um Ollama do lado. As duas opções têm custo.

A 2.0 traz um provider `local` que roda o modelo de embeddings dentro do próprio processo, em Rust puro, com o `all-MiniLM-L6-v2`. Sem chave de API, sem servidor externo, sem GPU e sem mandar seus dados pra lugar nenhum. E agora vem ligado por padrão. Na primeira execução ele baixa o modelo (uns 87 MB, com checksum fixo) em background e liga a busca híbrida no próximo restart.

O ganho é mensurável. No benchmark LongMemEval-S, o hit@5 sobe de 0.617 só com full-text para 0.779 com os embeddings locais. Se por algum motivo você não quiser, um `embedding_provider = "none"` desliga.

Detalhe que importa: escolhi `candle` de propósito, em vez do runtime nativo que a concorrência usa. Foi justamente essa camada nativa que gerou um tipo de crash recorrente em outros projetos de memória. Preferi não herdar o problema.

## Vários agentes ao mesmo tempo, no mesmo projeto

Aqui começa a parte que motivou boa parte do trabalho antes da 2.0.

O caso do `ai-memory run` que mostrei em julho era sequencial: fecho o Claude, abro o Codex, continuo. Mas e quando eu deixo dois ou três harnesses abertos ao mesmo tempo no mesmo projeto? Claude numa aba, Codex noutra, OpenCode numa terceira.

O ai-memory trata isso sem ninguém pisar no pé do outro. Cada chamada de memória descobre sozinha a qual projeto pertence, a partir do diretório da sessão. O ponteiro de "projeto atual" agora é por ator, então dois harnesses no mesmo checkout mantêm cada um a sua noção de contexto. E a identidade do projeto vem do nome do checkout. O caminho absoluto no disco não pesa, então o mesmo projeto no laptop e no desktop cai no mesmo lugar.

Quando duas janelas gravam na mesma página, a segunda não apaga a primeira. Ela cria uma versão nova que passa a ser a mais recente, e a anterior continua alcançável na cadeia de versões. Regravar algo idêntico não gera versão nova. Todas as escritas passam por um único writer, com fila e backpressure, então uma rajada não corrompe nada.

Isso não é teoria. Tem teste de aceitação chamando Claude, Codex, OpenCode, Pi, Crush e mais alguns de verdade, dentro de uma mesma workstream, cobrindo lease, adoção de sessão e entrega de contexto entre harnesses.

## Um time inteiro no mesmo projeto

O segundo cenário é o que dá título ao post. Aqui já são várias pessoas, um time inteiro apontando os agentes pro mesmo servidor.

A forma de rodar é simples. Alguém sobe um servidor, normalmente um container num homelab ou numa máquina da rede, e cada pessoa aponta os agentes dela pra aquela URL. HTTPS entra na frente com um proxy reverso, se você quiser. O banco continua sendo um SQLite só.

Todo mundo enxerga as mesmas páginas do projeto. O que uma pessoa aprendeu numa sessão, o agente da outra recupera. E cada sessão nova recebe um briefing com o estado do projeto logo no início. Vou ser honesto com o termo "tempo real". O que existe é um store central compartilhado, com leitura imediata, mais o briefing na abertura. A nota que um colega gravou aparece na hora pra próxima consulta ou próxima sessão de qualquer um. Uma sessão que já está rodando só recebe a novidade na consulta seguinte ou na próxima abertura, sem interrupção no meio.

O que muda no modo multiusuário é a atribuição. Cada escrita registra quem fez. Existe log de auditoria e a interface mostra "editado por fulano". Isso já vem no pacote, de graça. E não existe permissão por página, de propósito. A atribuição serve pra registrar autoria; qualquer pessoa autenticada pode escrever, e o histórico é que guarda quem foi.

Tem uma distinção de segurança importante entre o que é compartilhado e o que é pessoal. As páginas são de todos. Mas o handoff é um bastão de um dono só: exatamente uma sessão pega, e um segundo `accept` não rouba o bastão de ninguém. O handoff que você deixou pendente não é entregue nem consumido por um colega. Do mesmo jeito, os "slots" de "no que estou trabalhando agora" são por pessoa, então o seu contexto pessoal não vaza no briefing do time inteiro.

Também existe uma bateria de testes de concorrência real cobrindo esses casos: escrita simultânea, isolamento por ator sob carga, o bastão do handoff que não é roubado e os slots pessoais que não vazam.

## Onde o ai-memory fica frente à concorrência

Antes da 2.0 fizemos outra rodada de pesquisa sobre o cenário de 2026, documentada no repositório. Ela foi a base pra decidir o que a 2.0 precisava cobrir. Vou resumir o campo.

Tem o **agentmemory**, que é um MCP server em TypeScript preso a um sidecar nativo e a uma superfície gigante de dezenas de ferramentas. Tem o **basic-memory**, em Python, Markdown no disco, mas com captura manual: você tem que pedir pra ele lembrar. Tem o **cognee**, que junta grafo, vetor e relacional num pipeline pesado que pede vários gigas de RAM. Tem o **MemPalace**, que viralizou com quase 50 mil estrelas em duas semanas por causa de um número de benchmark que, auditado, se mostrou inflado, além de sofrer de corrupção quando duas escritas acontecem juntas. E tem os grafos temporais como **Zep**, os "memory OS" como **Letta** (o antigo MemGPT) e os extratores de fato como o **Mem0**.

Tem ainda a memória nativa que o próprio Claude Code passou a ligar por padrão. Essa eu trato como o funil que apresenta a categoria pras pessoas. Como concorrente ela fica limitada: presa a uma máquina, presa a um agente, sem busca de verdade e sem história de time.

A 2.0 fecha as lacunas que a pesquisa apontou. Passamos a publicar benchmark reproduzível com o LongMemEval, rodando o servidor de verdade. Ganhamos o formato aberto OKF. Ganhamos ligações tipadas entre páginas, com `causes`, `fixes` e `contradicts`, que ainda alimentam uma checagem de contradição sem gastar LLM. Ganhamos consulta com `as_of`, pra perguntar o que a gente sabia sobre um assunto numa certa data. Ganhamos os embeddings locais. E ganhamos uma passada opcional de "experiência" que revê várias sessões pra achar padrões que só aparecem no conjunto.

Agora a parte que interessa pra quem vai escolher. O que o ai-memory tem que os outros não têm, tudo junto:

- **Ele te acompanha entre agentes.** Mais de vinte harnesses alimentam uma memória só, e o handoff aqui é um protocolo de verdade: tipado, com dono e reivindicado uma vez só.
- **Ele te acompanha entre máquinas.** A memória vive num servidor que é seu. O projeto que você largou no desktop é o que você retoma no laptop.
- **Ele funciona pra time.** Autenticação multiusuário, atribuição por pessoa e log de auditoria já vêm no pacote, de graça.
- **Sua memória é Markdown puro.** A fonte da verdade é uma wiki versionada no Git. O banco é um índice derivado que dá pra reconstruir a qualquer momento a partir dos arquivos, sem vector store pra ficar de babá e sem nada preso num blob binário.
- **Ele captura o trabalho sozinho e em silêncio.** Sem cerimônia de "lembra disso". E o caminho padrão roda com zero chamada de LLM.
- **Ele é um binário só.** Sem sidecar, sem três bancos pra sincronizar. Todas as escritas passam por um único writer, com um teto de escrita que a gente mediu de verdade, com teste real. Foi exatamente esse desenho que evitou a corrupção de escrita concorrente que derrubou os outros.

Nenhum concorrente entrega esse conjunto. Alguns têm um ou outro pedaço. O ai-memory tem o pacote, e agora com paridade nos itens onde antes ficava atrás.

## A 2.0 é de todo mundo

Quando escrevi o post de julho, quinze pessoas tinham PR mergeado no projeto. Hoje são cerca de setenta. Faz tempo que isso deixou de ser um programinha de fim de semana.

Os números até a 2.0: mais de 1.500 commits, **371 pull requests mergeados** e **181 issues fechadas**. Isso saiu de gente usando de verdade e mandando correção, funcionalidade e documentação.

Preciso agradecer em especial ao [Djalma Júnior](https://github.com/djalmajr), que sozinho passou de 50 PRs mergeados, e ao [Samir Hanna Verza](https://github.com/samirhvbr), com mais de 20. Logo atrás vêm [lhzapata](https://github.com/lhzapata), [pedrofjr](https://github.com/pedrofjr), [mrpaiva](https://github.com/mrpaiva), [lucasliet](https://github.com/lucasliet), [lihuiyang1024](https://github.com/lihuiyang1024), [Murillofilho86](https://github.com/Murillofilho86) e [Matheus Rodrigues](https://github.com/matheus-rodrigues00). E tem uma cauda longa de dezenas de outras pessoas com PR mergeado que seria injusto tentar listar inteira aqui.

Se você quer entrar nessa, o [guia de contribuição](https://github.com/akitaonrails/ai-memory/blob/main/CONTRIBUTING.md) foi reescrito pra deixar tudo claro: como configurar o ambiente, os gates que o CI cobra, a regra do CHANGELOG e a política de versionamento. Bug fix costuma sair rápido no próximo patch. Funcionalidade pequena, como um novo harness ou provider, entra no próximo minor. Tem issue marcada pra quem está começando.

## Como pegar a 2.0

A página do projeto tem todos os métodos de instalação, incluindo AUR, Homebrew e binários de release:

- [ai-memory no GitHub](https://github.com/akitaonrails/ai-memory)
- [Notas da release v2.0.0](https://github.com/akitaonrails/ai-memory/releases/tag/v2.0.0)

Depois de atualizar, na primeira execução deixe a migração fazer o backup e converter sua wiki pro formato OKF. Se você usa o modo gerenciado, reinstale os hooks dos harnesses que pretende usar.

## Conclusão

A 1.x provou que a ideia funcionava. A 2.0 é a versão que eu recomendaria sem asterisco pra outra pessoa botar num time.

O formato é aberto, então sua memória não fica presa. A busca semântica roda local, então você não paga nem vaza. Vários agentes e várias pessoas trabalham no mesmo projeto sem se atropelar. E o desenho de um binário só, com um writer só, é o que evita justamente os problemas que afundaram metade da concorrência.

LLM e assinatura eu continuo alugando de quem estiver melhor no mês. A memória do projeto fica comigo, com o time, e agora num formato que ninguém tira de mim.
