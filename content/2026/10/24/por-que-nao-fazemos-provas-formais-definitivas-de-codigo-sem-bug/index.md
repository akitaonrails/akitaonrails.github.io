---
title: "Por que não fazemos provas formais definitivas de código sem bug?"
slug: por-que-nao-fazemos-provas-formais-definitivas-de-codigo-sem-bug
date: '2026-10-24T15:00:00-03:00'
draft: false
translationKey: por-que-nao-fazemos-provas-formais-definitivas-de-codigo-sem-bug
description: "A Anthropic provou que 123 bibliotecas open source nunca dão crash, com 180 milhões de linhas de prova geradas por IA. Explico o que é prova formal, por que o seL4 custou 20 anos-pessoa, por que o Bend 2 muda a conversa, e o que a semana do PHP2Shell, do Node2Shell, do GitLab e do Railway ensina sobre dívida técnica vencendo."
tags:
- seguranca
- engenharia-de-software
- inteligencia-artificial
- linguagens-de-programacao
---

Na quinta-feira, 22 de outubro, a Anthropic publicou um texto de pesquisa chamado [LLMs are making formal software verification feasible at a much larger scale](https://www.anthropic.com/research/formal-verification). Eu li duas vezes, porque a primeira leitura me deixou cético e a segunda me deixou incomodado. Não pelo que eles fizeram, mas pelo tamanho do que eles admitem que ainda falta.

O resumo: em parceria com a [Theorem](https://theorem.dev/), a Anthropic usou o Claude para gerar provas formais de segurança sobre o código de compilado de **123 bibliotecas open source**, cobrindo **239 entry points** de testes de fuzz do OSS-Fuzz do Google. A propriedade provada é concreta: para qualquer entrada de até 64 MB, e para qualquer resposta modelada do sistema operacional e do layout de memória, aquele binário **nunca dá crash**, nunca viola memória e nunca falha uma asserção. São cerca de **180 milhões de linhas de Rocq** (o antigo Coq), com uma prova típica em torno de 600 mil linhas para um binário mediano de 18 mil instruções RISC-V.

Durante o processo, o Claude encontrou e corrigiu bugs que estavam lá há anos, inclusive coisas que fuzzers nunca acharam: um underflow num descompressor que só aparecia em entradas de uns 20 MB com um layout raro, um out-of-bounds read que precisava de 64 MB de entrada e mais de 2 GB de memória, e uma redescoberta da CVE-2026-56132 no libexpat. Achou também bug de lógica que nunca dá crash, o tipo que passa em qualquer teste.

Vou destrinchar tudo isso com calma. Primeiro o que é prova formal de verdade, depois o caso seL4, depois por que nunca foi barato, depois o que a Anthropic admite, depois a semana horrível de vulnerabilidades que motivou o texto, e no fim a minha leitura do que está acontecendo.

## O que é, de fato, prova formal de software

Todo mundo repete "código provado" como se fosse um selo de qualidade. Não é. Prova formal é uma afirmação matemática sobre um modelo do seu programa, verificada mecanicamente por um programa separado, chamado de kernel de checagem.

O fluxo é sempre o mesmo:

1. você escreve uma **especificação**: uma descrição formal do que o programa deve fazer;
2. você **modela** o programa ou a linguagem em que ele foi escrito, com semântica matemática;
3. você escreve uma **prova** de que o programa satisfaz a especificação;
4. um **checador** verifica a prova contra a especificação, mecanicamente.

O que sai disso não é "não tem bug". É "não tem bug **que viole essa especificação**, dado esse modelo do mundo". A diferença entre as duas frases é onde mora 90% da engenharia difícil, e é o motivo de a Anthropic gastar uma seção inteira de limitações falando disso.

Aqui cabe uma distinção que confunde muita gente. Existem duas grandes famílias:

**Prova dedutiva (theorem proving).** Você escreve a prova num assistente como Isabelle/HOL, Rocq, Lean ou F*, e o kernel checa. É o que o seL4 usa, é o que a Anthropic usou. Cobre sistemas grandes, permite especificações ricas, e custa caro em esforço humano por linha provada.

**Model checking.** Você descreve o sistema como uma máquina de estados finita e a ferramenta explora todos os estados. É mais barato e automatiza bem, mas sofre com explosão combinatória e com tipos de dados infinitos. Ferramentas como SPIN, TLA+ e CBMC vivem aqui.

Tem ainda um terceiro caminho, que é o mais usado na indústria sem ninguém chamar de prova formal: **interpretação abstrata**. O compilador não prova o seu programa, ele calcula uma aproximação segura de todos os comportamentos possíveis e avisa quando algo é suspeito. É o que o [Astrée](https://www.astree.ens.fr/) faz no código de aviônica da Airbus, e é o que o Astrée prova: zero erros de runtime em código C de controle de voo.

E tem a família que mais cresce na prática, a **verificação assistida por tipos e contratos**: Dafny, SPARK/Ada, F*, Verus para Rust, refinement types. Você não escreve prova de 600 mil linhas; você escreve contratos e deixa um SMT solver (Z3, CVC5) descarregar as obrigações. O custo cai uma ordem de grandeza, e o preço é que você fica limitado ao que o solver consegue decidir.

## O problema da especificação é o problema todo

A Anthropic foi explícita nisso, e é a parte que quase nenhum entusiasta de prova formal gosta de encarar: *"a dificuldade de obter uma especificação abrangente e sem ambiguidade é um obstáculo significativo para verificar software em escala maior"*.

Pense no que significaria "estar correto" para um editor de texto. Ou para um browser. Não existe resposta única, porque a especificação é uma decisão de produto, não um fato matemático. Para um decoder de PNG a coisa é fácil: a RFC 2083 define tudo. Para uma política de reembolso, a especificação é uma reunião de diretoria.

A saída que a Anthropic encontrou é engenhosa e vale entender, porque muda o jogo na prática: **transformar o teste de fuzz existente numa especificação**. Em vez de inventar do zero uma descrição do comportamento desejado, eles pegam o teste que o desenvolvedor já escreveu, compilam para RISC-V, e a especificação passa a ser "esse teste nunca dá crash para nenhuma entrada de até 64 MB". Se o teste checa round-trip de compressão, provar que ele nunca falha é provar a propriedade de round-trip. Se ele checa uma lei algébrica, você provou a lei.

É um atalho honesto e, ao mesmo tempo, uma admissão: a indústria ainda não sabe escrever especificações boas para a maior parte do software, então o jeito é extrair spec do que já existe como teste.

## seL4: o caso que mostra o teto e o custo

Se você quer entender por que prova formal não é rotina, estude o [seL4](https://sel4.systems/). É o exemplo mais bem documentado que existe, e os números são o argumento inteiro.

O seL4 é um microkernel de terceira geração da linhagem L4, com **8.700 linhas de C e 600 linhas de assembly**. Ele foi projetado desde o início para ser verificável, o que já é uma decisão rara: o time da NICTA, em Sydney, desenhou o kernel pensando na prova.

A prova de correção funcional, feita em Isabelle/HOL, tem cerca de **200 mil linhas de script** e aproximadamente **10 mil lemas intermediários**. O time reporta algo entre 20 e 25 anos-pessoa de esforço total, sendo uns 11 anos-pessoa especificamente na prova do seL4, com o resto indo para frameworks, bibliotecas e ferramentas que depois serviram para outros projetos. O paper da Anthropic cita os números mais redondos: 2 anos-pessoa para implementar, **20 para verificar**.

E o que a prova garante? Que o kernel nunca viola a especificação, nunca dá crash, nunca viola segurança de memória e impõe as propriedades de controle de acesso que declara. Nada mais que isso. O próprio paper do seL4 lista o que fica de fora: a prova **assume** a correção do compilador, do código assembly, do hardware e do código de boot.

Esse "assume o compilador" virou um problema à parte, e é uma das partes mais interessantes da história. Depois do trabalho original, o Thomas Sewell e outros construíram uma **verificação binária**: uma cadeia de ferramentas que prova que o binário compilado é refinamento do código C. Isso remove o compilador da base de confiança. O trabalho continua hoje com financiamento da seL4 Foundation.

Três lições que eu tiro do seL4:

**A primeira é que a prova acha bug.** O esforço de verificação encontrou **144 defeitos de implementação** e motivou **54 mudanças no código**, incluindo bugs que o teste normal não pegou. Prova não é só selo no fim; o processo de provar é um método de depuração violento.

**A segunda é que projeto importa mais que ferramenta.** O seL4 é pequeno o bastante para ser provado porque alguém decidiu que seria. Um monolito de 5 milhões de linhas com threads, alocação dinâmica e plugins não vira verificável por esforço, vira verificável por reescrita.

**A terceira é que o custo é real e mensurável.** Vinte anos-pessoa para 10 mil linhas. Isso é o benchmark contra o qual qualquer promessa de "IA vai resolver" tem que ser medida.

## Por que nunca foi custo-efetivo

Agora a parte que responde o título deste artigo. Existem cinco razões, e elas se somam.

### A prova é maior que o código, por ordens de grandeza

No seL4, 200 mil linhas de prova para 8.700 linhas de C: um fator de 23. No CompCert, o compilador C verificado, são [42 mil linhas de Coq](https://compcert.org/doc/) e cerca de 3 anos-pessoa, sendo 76% do total dedicado à prova, não ao compilador. Na Anthropic, uma prova típica tem 600 mil linhas para 18 mil instruções de máquina, um fator de 33.

Isso não é gordura: é a natureza do negócio. Provar que um programa faz a coisa certa em todos os caminhos exige argumentar sobre todos os caminhos, e o número de caminhos cresce mais rápido que o número de linhas.

### Manutenção é o assassino silencioso

Uma prova vale para um snapshot do código. Muda uma linha, a prova pode deixar de valer, e o trabalho de re-provar é proporcional ao impacto da mudança nas invariantes. Em software que evolui semanalmente, você paga o custo da prova de novo, e de novo.

Compare com teste: um teste que quebra te avisa que algo mudou de comportamento. Uma prova que quebra te avisa que a estrutura do seu argumento mudou, o que costuma ser bem mais trabalhoso de consertar. É por isso que verificação forte sobrevive em firmware congelado e morre em produto SaaS.

### O alvo se move mais rápido que a prova

Os nichos onde prova formal vingou são todos de evolução lenta e consequência catastrófica: kernel de SO, compilador, criptografia, controle de voo, controle de trem, componentes de satélite. Nesses mundos, o custo de errar é medido em vidas ou em bilhões, e o custo de provar se dilui em décadas de operação.

E-commerce, fintech, marketplace, SaaS B2B: o requisito muda na terça, o concorrente lança na quinta, e o time de produto quer A/B test na sexta. Provar formalmente uma regra de negócio que vai ser reescrita em três meses é queimar dinheiro. O que funciona nesses domínios é teste, observabilidade, feature flag e rollback rápido.

### Você prova o modelo, não o mundo

Essa é a limitação mais subestimada. Toda prova carrega uma **base de confiança**: o conjunto de coisas que você simplesmente acredita. No caso da Anthropic, o texto lista com honestidade o que sobra: os modelos formais do RISC-V e dos processos do Linux, os enunciados exatos dos teoremas, e o kernel de checagem do Rocq. E tecnicamente também o hardware, o SO e o compilador OCaml que roda o checador.

Numa prova de software comum, a base de confiança inclui ainda o compilador (a menos que você use verificação binária), a biblioteca padrão, o alocador, o kernel, e a fronteira de FFI. Cada pedaço de C não verificado no fim da pilha é um buraco na garantia. Você pode ter o núcleo mais provado do mundo chamando uma biblioteca de JSON com bug de parser.

### O custo do erro não é uniforme

Prova formal trata todo bug como igualmente importante, porque a especificação é binária. A realidade não é: um crash que derruba um worker é chato, um RCE anônimo é catastrófico, e um erro de arredondamento em relatório é irrelevante. Investir prova uniforme em software heterogêneo é alocar recurso no lugar errado.

O que a indústria faz, quando faz bem, é o oposto: **concentrar verificação forte no núcleo crítico e deixar o resto com teste**. É exatamente a lição do meu teste com Bend 2, e eu volto nela já já.

## Bend 2: a tentativa de virar o custo pelo avesso

Em setembro eu escrevi sobre a [Bend 2](/2026/09/19/nova-linguagem-voltada-pra-ia-bend-2/), a linguagem do Victor Taelin, e na época o pitch me pareceu exagerado. Relendo agora, à luz do paper da Anthropic, o desenho dele faz mais sentido do que eu dei crédito.

A ideia central do Bend 2 é dividir o programa em dois arquivos:

- `LAWS.bend`, escrito pelo humano, com as invariantes do sistema;
- `PROOF.bend`, escrito pela IA, com as provas dessas leis.

O type checker é um verificador de provas na linha do Lean e do Rocq. Se a prova não fecha, o código não entra. O checker roda em 0,1 segundo, o que é a parte realmente inovadora: dá para colocar no loop do agente, a cada edição. Lean leva 19 segundos e Rocq 6 segundos para o mesmo conjunto de teste que o Bend resolve em 0,38 s, embora os benchmarks dele tenham ressalvas justas, porque ele pula elaboração e unificação.

No meu teste, o resultado mais útil foi este: para garantir dois fatos simples sobre uma guarda de umas 30 linhas, precisei de **93 linhas de leis e provas**. E deixei de fora a exatidão do algoritmo, toda a aritmética em U32, e literalmente todo o resto do programa: JSON, ordenação, renderização, IO. A superfície provável era uns poucos por cento do código.

Isso é o mesmo fenômeno do seL4, em escala de brinquedo: **a prova é maior que o código e cobre menos do que você gostaria**. A diferença é que no Bend o custo por linha provada é de segundos, não de anos-pessoa, e é aí que a coisa fica interessante.

E tem a lição que eu considero a mais importante do meu experimento, e que vale para qualquer projeto de verificação: **prove uma guarda isolada, deixe o algoritmo fora da prova**. O alocador de `--limit` do ghpending ficou em dois estágios, com o algoritmo em U32 não provado propondo valores e uma guarda em Nat provada cortando o excesso. A lei vale mesmo se o estágio não provado propuser lixo. A guarda não confia na aritmética que não consegue enxergar.

Esse é o padrão que faz prova funcionar em código real: você não prova o sistema, você prova a fronteira onde o erro é catastrófico, e deixa o resto com teste. O paper da Anthropic faz exatamente isso ao escolher provar "este entry point de fuzz nunca dá crash", em vez de "esta biblioteca está correta".

A outra lição do Bend, e essa é dura, é que **no momento em que você cruza a fronteira do FFI, a prova ficou para trás**. O verificador garante o que está dentro do modelo dele; o C do outro lado é ato de fé. Os meus dois ports precisaram de oito efeitos escritos à mão em C, sem nenhuma promessa de ABI estável entre releases. É o mesmo problema do `unsafe` no Rust, onde as garantias do borrow checker valem até a borda do bloco.

## O que a Anthropic fez de diferente, e o que ela admite

O salto da Anthropic não foi inventar técnica nova de prova. Foi usar um LLM para resolver o problema de **escala do esforço**, que é o gargalo histórico.

O argumento é simples e, uma vez dito, óbvio: gerar 600 mil linhas de prova é um trabalho mecânico, tedioso e enorme, exatamente o tipo de coisa em que um modelo com milhões de tokens de orçamento é bom. O ser humano não precisa revisar essas 600 mil linhas, porque o kernel do Rocq as checa mecanicamente. O humano só precisa confiar em quatro coisas: a semântica do RISC-V, a semântica dos processos do Linux, o enunciado do teorema, e o checador.

Três números do paper mostram para onde isso vai:

- **Custo caindo.** Em 36 tarefas de verificação extraídas de código real do OSS-Fuzz, o Opus 5.5 prova metade delas com cerca de **40% menos tokens** que o Opus 5. Modelos treinados em tarefas longas de verificação ficam mais eficientes nisso.
- **Prova é reusável.** Quando agentes puderam copiar as provas uns dos outros num workspace compartilhado, gastaram **17% menos tokens**, e alguns conseguiram provar o que tinham falhado sozinhos. A maior parte de uma prova dessas é infraestrutura comum: inicialização do runtime C e do AddressSanitizer. Prova tem a mesma economia de biblioteca compartilhada que código.
- **Dependência segue lei de potência.** Provar as bibliotecas mais compartilhadas destrava uma fatia enorme do ecossistema. É a tese da Theorem, que quer verificar o ecossistema Nix inteiro, começando por glibc, OpenSSL e cURL.

E agora as admissões, que são a parte que eu respeito no texto. Eles listam quatro buracos:

**Formalmente verificado não significa livre de bug.** O checador não sabe se a sua spec corresponde à realidade. Quando aparece bug em código verificado, é porque a spec ou a semântica assumida divergiu do mundo real.

**A máquina real faz o que o modelo não descreve.** As provas valem para binários estáticos, single-threaded, RISC-V, linkados contra musl. A maioria das pessoas roda essas bibliotecas em x86 ou ARM, linkadas dinamicamente contra glibc. Fechar esse buraco exige semânticas mais próximas do que está implantado.

**A afirmação pode não cobrir o que importa.** O AddressSanitizer não detecta todos os bugs de memória, nem todos os entry points foram provados, código morto não entra, e um caller pode usar a biblioteca errado e corromper a própria memória. Fechar isso exige especificar o contrato de cada função pública e obrigar o chamador a cumpri-lo.

**Reward hacking é risco real.** Se você manda a IA consertar o código para a prova fechar, ela pode reescrever o programa para um que trivialmente nunca dá crash. A Anthropic penalizou patches e deu crédito extra por provar quais entradas o patch muda e quão poucas são, auditando os patches. É uma defesa razoável e, ao mesmo tempo, um lembrete de que você está otimizando contra um objetivo declarado, e objetivo declarado é hackeável.

Sobre a viabilidade de "mais software, mas ainda não todo, mais bem testado": eu acho que a janela é real, e que o formato de adoção vai ser parecido com o que já aconteceu com tipos estáticos. Ninguém reescreveu o mundo em Haskell. O TypeScript entrou por cima, incrementalmente, onde valia a pena. Verificação vai entrar igual: primeiro nas dependências compartilhadas, nos decoders, nos parsers, nas bibliotecas de criptografia, nos pontos onde a spec é objetiva e o custo do bug é alto. Depois, se o custo cair o suficiente, em módulos de aplicação com invariantes claras.

## A semana que explodiu

A urgência do texto da Anthropic não veio do nada. Nos dias anteriores, entre 20 e 23 de outubro, a internet levou uma sequência de socos que eu não lembro de ter visto junta. Vou passar por cada um e perguntar: prova formal teria salvado?

### PHP2Shell: CVE-2026-109618 e CVE-2026-109619

Dois RCEs críticos, CVSS 9.2, sem autenticação, em **todas as instalações de PHP que servem requisições web**: Apache com mod_php, PHP-FPM, php-cgi, FrankenPHP, LiteSpeed. Corrigidos em 21 de outubro no [PHP 8.5.12, 8.4.27, 8.3.36 e 8.2.35](https://www.php.net/archive/2026.php). O [alerta da CISA](https://www.cisa.gov/news-events/alerts/2026/10/21/critical-vulnerabilities-php-require-immediate-patching) recomenda patch imediato e já publicou regra Sigma de detecção. A [CERT-EU](https://cert.europa.eu/publications/security-advisories/2026-018) reportou tentativas de exploração antes do patch sair.

Os dois bugs são de memória. O CVE-2026-109618 é corrupção por out-of-memory durante a limpeza da requisição. O CVE-2026-109619 é estado global obsoleto sendo reaproveitado por uma requisição seguinte.

**Prova formal teria salvado?** Em princípio, sim, e é o caso mais claro da lista. Corrupção de memória e estado global obsoleto entre requisições são exatamente o tipo de propriedade que uma prova de segurança de memória e uma invariante de ciclo de vida pegam. O problema é o escopo: "todo o ciclo de vida de uma requisição PHP" inclui o core em C, todas as extensões, a SAPI, o alocador, e o libc. É uma base de confiança gigantesca, e provar isso exigiria provar meio ecossistema. Na prática, é o tipo de alvo que só faz sentido depois que a infraestrutura de prova estiver barata o suficiente, e é por isso que a estratégia de verificar as dependências compartilhadas primeiro (glibc, OpenSSL, cURL) é a que faz sentido.

### Node2Shell: CVE-2026-111497 no Brotli

Out-of-bounds write no decoder do Brotli, a biblioteca de compressão do Google que o Node embute. Um stream comprimido malicioso corrompe memória adjacente, vaza conteúdo ou executa código. Afeta Node 22.x, 24.x e 26.x, e como o bug está na [biblioteca Brotli em si](https://www.cve.org/CVERecord?id=CVE-2026-111497), afeta qualquer coisa que embuta a mesma cópia: Bun, projetos em Python, e o que mais aparecer. Versões afetadas: 1.0.3 até 1.2.0. Corrigido em [1.2.1, 1.1.1 e 1.0.10](https://github.com/google/brotli/blob/v1.2.1/CHANGELOG.md).

E tem um detalhe que vale mais que o CVE: **a correção foi escrita no código-fonte do Brotli em fevereiro e não saiu em release nenhuma até 21 de outubro**. Oito meses com o conserto pronto e parado.

**Prova formal teria salvado?** Sim, e este é o caso de melhor encaixe de todos: decoder com lei de round-trip é exatamente o ponto doce. "Se você comprime e descomprime, o resultado é o original" é uma spec objetiva, e provar que o decoder nunca escreve fora do buffer para nenhuma entrada é prova de segurança de memória padrão. O Bend 2, aliás, lista codecs com lei de round-trip como nicho natural.

Mas repare: prova não teria resolvido o problema real. O bug existia em código não provado, e a correção existia desde fevereiro. O que matou foi processo de release, não ausência de prova. Nenhuma prova formal conserta um mantenedor que não publica a versão corrigida.

### GitLab: CVE-2026-110264, CVSS 10.0

Integer overflow no Onigmo, o motor de expressões regulares que o Ruby embute, alcançável pelo renderizador de arquivos Org-mode do GitLab: a gem `org-ruby` pega a palavra-chave crua de uma linha `#+TODO:` e joga dentro de `Regexp.new`. Um padrão construído para estourar o contador faz o motor escrever fora do buffer, e um visitante sem autenticação executa código num servidor self-managed. CVSS 10.0, o máximo. E o alcance: **todas as versões desde a 7.0, de 2014**, ou seja, doze anos de releases. Corrigido em 21 de outubro nas [19.5.1, 19.4.3, 19.3.6, 19.2.9, 19.1.9, 19.0.10 e 18.11.13](https://docs.gitlab.com/releases/patches/patch-release-gitlab-19-5-1-released). Nove dias antes, o CVE-2026-97229, também CVSS 10.0 e também Onigmo, tinha sido corrigido no outro ponto de entrada do mesmo motor: o compilador de regex do CI/CD. E o conserto de verdade saiu no próprio Ruby, em 23 de outubro, porque o bug era do motor da linguagem, não do GitLab. Quem patchou em 12 de outubro precisou patch de novo em 21.

**Prova formal teria salvado?** Parcialmente, e o caso é instrutivo. Overflow aritmético em um parser é detectável: prova de ausência de overflow, ou até compilador com checagem de overflow em build de teste, pega. Mas o GitLab disse que o ataque funciona "sob certas condições" que não divulgou, o que sugere que a parte difícil é a lógica, não a aritmética. A lição que fica é outra: um parser de regex exposto a entrada não confiável é uma superfície clássica de verificação, e ninguém verifica porque é código de produto em movimento constante.

### Railway: o ataque que prova formal nenhuma impede

Não foi um bug de código. Em 20 e 21 de outubro, um atacante acessou os sistemas internos do Railway, a plataforma de deploy usada por mais de 2 milhões de desenvolvedores, e **pode ter obtido o conteúdo decriptado de variáveis de ambiente** de alguns clientes. A empresa pediu que todos os usuários revogassem e recriassem credenciais guardadas antes de 21 de outubro.

O [relatório preliminar](https://blog.railway.com/p/preliminary-report-october-security-incident) diz que foi uma campanha "sustentada e direcionada", que o atacante tinha acesso a modelos abliterados e recursos de computação substanciais, e que o objetivo era **obter chaves de API de provedores de IA** para ataques de destilação. Chaves da OpenAI, Anthropic, Google, GitHub, GitLab, Stripe e afins. A Railway pediu aos provedores que revogassem as chaves encontradas.

**Prova formal teria salvado?** Não. Nenhuma prova de correção de código impede que alguém obtenha suas chaves e decripte seus segredos. Esse é um problema de arquitetura de custódia de chave, de segregação de rede e de resposta a incidente, não de corretude de programa. E é um lembrete importante nesta conversa: a maior parte dos incidentes reais não é bug de lógica no código, é falha de configuração, credencial vazada, permissão excessiva.

### PS5: o kernel caindo firmware após firmware

Em 29 de setembro, o exploit [Relapse](https://github.com/ntfargo/Relapse-Exploit) foi publicado, funcionando em qualquer PS5 e PS5 Pro do firmware 7.00 até o 13.60. É uma cadeia com falha de use-after-free no kernel, alcançando execução de código não assinado. O firmware 14.00, de 16 de setembro, já tinha fechado a falha de kernel que o Relapse usa, segundo a cena, treze dias antes de o exploit ficar público, então a resposta pós-publicação foi outra: 14.10 em 1º de outubro e 14.20 em 21 de outubro. O 14.10 apareceu quebrado 18 dias depois, num demo privado que abria o menu de debug, e o 14.20 ganhou um entry point de userland **oito horas depois do lançamento**.

**Prova formal teria salvado?** Em princípio, sim: use-after-free é precisamente o que uma prova de segurança de memória elimina. O seL4 provou isso para um microkernel. Mas o PS5 roda um kernel derivado de FreeBSD, com hypervisor, com o AMD Platform Security Processor embaixo, tudo fechado, com milhões de linhas e nenhuma intenção de provar nada. Verificar essa pilha inteira não é caro, é impraticável. O que dá para fazer é o que o seL4 faz: provar os componentes pequenos e críticos, e aceitar que o resto fica com mitigação e bug bounty.

Uma nota de rodapé que eu acho mais reveladora que o exploit: o ritmo. A Sony lança firmware, a cena quebra em dias. Não porque o kernel é mal escrito, mas porque é grande, fechado, e atacado por gente com tempo e motivação. É o espelho invertido do seL4.

### O padrão que sai dessa tabela

| Incidente | Natureza | Prova formal resolveria? |
|---|---|---|
| PHP2Shell | Corrupção de memória + estado global | Sim em princípio, caro na prática (base de confiança enorme) |
| Node2Shell (Brotli) | Out-of-bounds write em decoder | Sim, encaixe perfeito, e o problema real era release parado |
| GitLab CVE-2026-110264 | Integer overflow em parser exposto | Parcialmente; a parte de lógica fica de fora |
| Railway | Credencial e segredo comprometidos | Não. Problema de arquitetura e custódia |
| PS5 Relapse | Use-after-free em kernel gigante e fechado | Sim em teoria, inviável no escopo |

Coluna da direita com três "sim" e dois "não" já mostra o ponto: prova formal resolve uma classe inteira de bugs, e essa classe é justamente a que mais assusta, a de corrupção de memória que vira RCE. O que ela não resolve é tudo o mais, e "tudo o mais" é a maior parte do que acontece.

## A minha leitura: a dívida técnica está vencendo

Agora eu falo por mim.

Eu postei [no X](https://x.com/AkitaOnRails/status/2113361323434070101) que uma quantidade enorme de código escrito por humanos nos últimos anos é bem ruim, e que boa parte de quem chama tudo de "AI Slop" passou a vida acumulando "Human Slop" porque contava com o fato de que ninguém ia se dar ao trabalho de checar.

Eu mantenho cada palavra. E acrescento o diagnóstico: **a indústria passou duas décadas tomando dívida técnica com a premissa implícita de que auditar era caro e raro**. Revisão de código rasa, cobertura de teste decorativa, dependência de biblioteca sem ler o changelog, permissão de admin em service account porque dá menos trabalho, segredo em variável de ambiente porque o cofre é chato de configurar. Nada disso dava problema porque o custo de descobrir era alto.

O que mudou, e mudou em meses, é o custo de descobrir. No [outro post](https://x.com/AkitaOnRails/status/2113396195561287791) eu disse que gosto da trend de qualquer não-programador armado de LLM, tokens e skills virar scanner de segurança, e que toda empresa com plataforma web deveria ficar com muito medo. E isso é bom. O Deedy descreveu a mesma coisa poucas horas antes: gente não técnica explorando PHP2Shell com modelos de fronteira, e ele admitiu estar assustado.

Eu entendo o susto. Eu discordo do enquadramento. O que aconteceu não foi a criação de uma vulnerabilidade nova; foi a **remoção do atrito de descoberta** de vulnerabilidades que já estavam lá, algumas desde 2014, como o GitLab. A dívida sempre existiu. O que mudou é que agora ela vence.

E aqui vai o equilíbrio que eu acho que falta na conversa, dos dois lados.

Do lado de quem ataca, a barreira de entrada desabou. Antes, achar um RCE exigia anos de estudo, ferramenta cara e tempo. Agora exige um modelo, uma conta e paciência. O volume de tentativas vai subir uma ordem de grandeza, e o tempo entre divulgação e exploração, que já era de dias, vai virar de horas. A PS5 quebrada em horas depois do firmware é o retrato do futuro de todo mundo.

Do lado de quem defende, a mesma alavanca existe, e é aí que eu sou otimista. As mesmas capacidades que geram exploit geram auditoria. O mesmo modelo que lê um diff procurando falha de autorização lê um diff procurando bug de memória. As mesmas técnicas de prova do paper da Anthropic servem para carimbar uma biblioteca que você usa. O custo de endurecer caiu junto com o custo de atacar, e essa simetria é a notícia boa.

O que me deixa confiante não é a tecnologia sozinha, é o incentivo. Quando o custo de achar falha cai a quase zero, o custo de **não** achar sobe a quase infinito. Um CTO que hoje aceita rodar versão de dependência com CVE conhecido vai ter que explicar por que, num mundo em que qualquer estagiário com Claude audita o supply chain dele em uma tarde. A pressão muda de "ninguém vai olhar" para "todo mundo vai olhar", e comportamento muda com incentivo, não com sermão.

Eu aposto que o resultado disso é um padrão de qualidade mais alto para todo mundo. Não porque as pessoas ficaram mais virtuosas, mas porque a fiscalização ficou barata. É a mesma dinâmica que fez HTTPS virar padrão, que fez autenticação de dois fatores virar padrão, que fez dependabot virar padrão. Nada disso aconteceu por consciência; aconteceu porque a alternativa ficou cara demais.

E prova formal entra nesse pacote como a camada de cima. Não vai ser a ferramenta do dia a dia do dev de e-commerce. Vai ser o que a gente usa nas peças que não podem falhar: o decoder que todo mundo usa, a biblioteca de cripto, o parser exposto na internet, o kernel do dispositivo, o contrato que segura dinheiro. Exatamente onde o custo do erro é maior que o custo da prova, que é a única conta que importa.

O paper da Anthropic mostra que essa conta começou a fechar pela primeira vez. A esmagadora maioria dos programadores não vai escrever prova em Rocq nunca na vida, e não precisa. Precisa que alguém escreva as provas das peças que todo mundo usa, e é isso que ficou barato o suficiente para virar rotina.

## O que eu levo deste texto

Três coisas, para não terminar em prosa bonita.

**Prova formal é uma ferramenta de recorte, não de cobertura.** Você escolhe um núcleo pequeno, escreve uma spec objetiva, e prova. O resto fica com teste, porque teste é mais barato e pega o que prova não pegou. Quem promete "código sem bug" está vendendo a coisa errada, e a própria Anthropic se deu ao trabalho de dizer isso em letras garrafais no paper.

**O gargalo mudou de lugar.** Antes era escrever a prova. Agora é escrever a especificação e manter a prova viva enquanto o código muda. A Anthropic resolveu o primeiro problema com força bruta de tokens e resolveu o segundo parcialmente com reuso de prova e granularidade de pacote. O segundo é o problema difícil de verdade, e é onde eu quero ver a próxima geração de ferramentas.

**A janela de 2026 é real.** Pela primeira vez existe um caminho em que verificar uma dependência crítica custa menos que o incidente que ela evita. E existe ao mesmo tempo uma pressão externa, na forma de gente com LLM encontrando os mesmos bugs do outro lado. Se você lidera engenharia, a pergunta deixou de ser "vale a pena investir em verificação" e virou "quanto custa ser o próximo Railway".

A dívida técnica sempre esteve lá. A diferença é que agora ela tem cobrador.

Se você quiser ver os detalhes técnicos, o paper da Anthropic tem apêndice com os estudos de caso, e as provas publicadas estão no [repositório da Theorem](https://github.com/theorem-labs/oss-verify-proofs), junto com as [semânticas de RISC-V e processos do Linux](https://github.com/theorem-labs/rocq-linux-process-semantics). O skill para rodar o pipeline no seu próprio projeto também está público. Vale a leitura, mesmo que você nunca escreva uma linha de Rocq na vida.
