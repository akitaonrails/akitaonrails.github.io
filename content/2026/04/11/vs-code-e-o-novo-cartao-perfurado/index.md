---
title: "VS Code é o novo Cartão Perfurado"
date: '2026-04-11T12:00:00-03:00'
draft: false
slug: vs-code-e-o-novo-cartao-perfurado
translationKey: vs-code-is-the-new-punch-card
tags:
  - ai
  - llm
  - opinion
  - programming
description: "Na era dos agentes de código, digitar tudo manualmente no VS Code virou o equivalente moderno do cartão perfurado. O que não virou legado foi fundamento."
---

Toda vez que alguém pergunta se os júniors vão deixar de aprender a programar porque LLMs escrevem código, eu tenho a mesma reação: vocês estão fazendo a pergunta errada.

Vocês estão confundindo **input de código** com **engenharia de software**.

Não é a mesma coisa. Nunca foi.

Teve uma época em que programar significava saber converter números pra binário de cor e enfiar instrução direto em endereço de memória, bit por bit, na mão. Teve uma época em que programar significava saber organizar baralho de cartão perfurado, saber que ordem do deck estava certa, saber onde um furo errado destruiu a execução, e saber debugar visualmente sem a fantasia moderna de backspace infinito. Teve uma época em que programar de verdade significava saber 6502, Z80 e Assembly porque os computadores tinham tão pouco recurso que cada byte importava mesmo, não como figura de linguagem.

![Altair 8800, símbolo da era em que programar ainda passava por painéis físicos e entrada manual de instruções](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/altair-8800-computer.jpg)

*Painel frontal e switches: antes de editor, antes de IDE, antes de terminal confortável.*

E olha, tem fase da computação que foi ainda pior que cartão perfurado. Esse vídeo abaixo mostra alguém programando num LGP-21, um dos computadores pessoais mais antigos do mundo (o segundo mais velho, depois do Bendix G15 dos anos 50). Começa a partir do minuto 5:

{{< youtube id="TJjRCCetyo4" start="300" >}}

Imagina o que isso era: você digitava o programa em binário direto numa máquina de escrever, olhando pro acumulador, instrução por instrução, depois virava uma alavanca fisicamente pra executar, e o resultado era datilografado de volta em papel. A métrica não era framerate. Era caractere por minuto. Uma operação que hoje você faz num piscar de olho dentro de qualquer aplicativo, ali demorava horas de trabalho humano, digitando bit a bit, conferindo, testando, conferindo de novo.

É a mesma coisa que tá acontecendo com digitar código em editor de texto hoje versus agente de IA rodando no seu lugar. O jeito manual continua funcionando, do mesmo jeito que o painel do Altair continuou funcionando por anos depois que compilador ficou comum. Mas a ferramenta de escolha virou outra, e a diferença de velocidade e esforço é exatamente a mesma ordem de magnitude que separava o LGP-21 do editor de texto moderno. A nossa geração tá vendo essa transição acontecer em câmera lenta, e muita gente não quer ver.

Depois vieram compiladores melhores. Veio C. Vieram máquinas mais gordas, consoles 32/64 bits, PCs mais decentes, e Assembly deixou de ser o centro de tudo pra virar ferramenta de baixo nível, otimização localizada, rotina crítica, inicialização, driver, essas coisas. Ninguém sério olhou pra essa transição e falou: "pronto, agora acabou a programação porque o compilador escreve as instruções de máquina pra você."

No século 21 veio a Web e empurrou uma geração inteira pra HTML, CSS e um monte de burocracia de markup que agrega pouco valor intelectual e exige muito trabalho braçal pra ficar minimamente certo. Eu continuo achando que a indústria estendeu demais a vida útil desse modelo. Por anos demais, programador virou operador de formulário glorificado, montador de CRUD, alinhador de `div`, sacerdote de framework de front-end que faz a mesma coisa com sintaxe diferente.

E aí a bolha dos anos 2010 piorou tudo.

Eu já escrevi sobre isso em [RANT: IA acabou com os programadores?](/2026/02/08/rant-ia-acabou-com-programadores/) e também no [37 dias de Imersão em Vibe Coding](/2026/03/05/37-dias-de-imersão-em-vibe-coding-conclusão-quanto-a-modelos-de-negócio/). A bolha das startups, o dinheiro barato e a fome de contratação produziram uma legião de programadores muito ruins, saídos de bootcamps de dois meses e cursinhos prometendo salário de Google sem base, sem formação e sem profundidade. O mercado passou uma década fingindo que isso era normal. Não era. Era a mesma história de sempre: muito volume, pouco valor agregado, muita gente confundindo empregabilidade inflada com competência real.

E quando os layoffs começaram em 2022, isso não caiu do céu. Eu passei anos avisando que a bolha ia estourar. Tá tudo registrado na playlist [EU AVISEI](https://www.youtube.com/watch?v=wpPv1dJWjDs&list=PLdsnXVqbHDUehzKjiRruy--gncHz9Injy&pp=sAgC). A mensagem sempre foi a mesma: quando o dinheiro barato acabasse, a régua subiria de novo, e só teria chance quem tivesse feito o esforço de aprender Ciência da Computação de verdade. O novo ciclo econômico seria menos sobre volume de contratação e mais sobre eficiência. Foi exatamente o que aconteceu.

## O que mudou de verdade

LLMs ficaram populares no fim de 2022. Isso é fato. Mas popular não é a mesma coisa que útil pra projeto sério.

Entre 2023 e 2024, eu já usava IA pra escrever código. Funcionava? Funcionava. Mas ainda era cheio de chatice: alucinação demais, loop agente demais, contexto se perdendo fácil demais, ferramenta quebrando demais, custo alto demais pra pouca confiabilidade. Era útil pro programador experiente que sabia segurar o bicho na coleira. Ainda não era ferramenta madura pra trabalho pesado do dia a dia.

Pra mim, a virada veio no fim de 2025. Foi quando a combinação de melhores modelos, prompt caching, tool calling decente, otimizações de inferência, janelas de contexto mais úteis na prática, e principalmente interfaces de agentes de verdade fizeram a coisa parar de parecer demo de conferência e começar a parecer ferramenta de trabalho.

Foi aí que Claude Code, Codex, OpenCode e similares deixaram de ser "autocomplete turbinado" e viraram outra categoria de interface.

Pra mim, Claude Code já virou o novo terminal. O editor ficou em segundo plano.

Eu falei disso também em [Migrando meu Home Server com Claude Code](/2026/03/31/migrando-meu-home-server-com-claude-code/). Eu simplesmente não tenho mais paciência pra gastar atenção com trabalho braçal de shell Linux quando o problema é mundano: instalar servidor, subir e organizar serviços Docker, endurecer firewall, revisar regra de segurança, ajustar parâmetro de kernel, auditar `dmesg`, caçar log de systemd, esse tipo de coisa. Eu mando o Claude fazer o grosso, eu reviso direção e risco. E, ironicamente, meus Linux nunca pareceram tão estáveis, rápidos e robustos.

Hoje, pra quem trabalha o dia inteiro construindo software, voltar pro combo cru de editor de texto mais terminal e fazer tudo manualmente começa a parecer regressão. Não porque digitar ficou impossível. Claro que não. Eu digitei código por décadas. O problema é outro: virou desperdício de atenção.

Se eu posso descrever uma intenção, pedir pra um agente vasculhar o código, editar vinte arquivos, rodar teste, compilar, corrigir, e me devolver uma proposta de mudança em minutos, por que exatamente eu vou sentir nostalgia de ficar digitando boilerplate na unha dentro do VS Code?

Não vou.

E aqui entra uma distinção que muita gente ainda não entendeu. Não é pra usar agente de código como se fosse extensão burra de editor, no estilo "gera esse arquivinho aqui" e você fica microgerenciando cada linha no canto da tela. Isso é usar Ferrari pra ir comprar pão na esquina. O ganho grande não vem de tratar Claude Code, Codex ou similares como autocomplete glorificado dentro do VS Code. O ganho vem quando você larga a mentalidade de operador de editor e passa a tratar o agente como pair programmer de verdade.

Em vez de agir como digitador profissional, você sobe um nível. Age mais como tech lead, product owner, QA, gerente do fluxo. Define a intenção, explica contexto, cobra critério, pede plano, manda rodar teste, pede refatoração, pede comparação de alternativas, pede revisão da própria mudança. Deixa o trabalho braçal do código com o agente e usa sua cabeça pra julgar direção, prioridade, risco e qualidade.

Mas tem um equilíbrio aí que eu já comentei em outros posts de Agile Vibe Coding. Não é pra largar o volante e deixar a LLM dar `git push` cega em tudo. E também não é pra cair no extremo oposto e virar fiscal de vírgula, nitpickando cada detalhe pequeno até o agente virar mais uma burocracia e matar o ganho de velocidade. Os dois extremos são ruins. Num extremo você terceiriza responsabilidade. No outro você estrangula produtividade.

O ponto certo do pêndulo é outro: usar práticas de XP e engenharia de verdade pra sustentar a velocidade. Refactoring contínuo. Testes. CI. Revisão. Feedback rápido. Código pequeno. Mudança incremental. Foi exatamente isso que eu vim documentando em posts como [Do Zero à Pós-Produção em 1 Semana - Como usar IA em Projetos de Verdade](/2026/02/20/do-zero-a-pos-producao-em-1-semana-como-usar-ia-em-projetos-de-verdade-bastidores-do-the-m-akita-chronicles/) e [Software Nunca Está 'Pronto'](/2026/03/01/software-nunca-esta-pronto-4-projetos-a-vida-pos-deploy-e-por-que-one-shot-prompt-e-mito/). O multiplicador de 10x não vem da mágica do modelo. Vem do modelo somado a processo decente.

![Interface moderna de agente de código, representando a transição do editor tradicional para uma interface orientada a intenção e execução assistida](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/cursor-homepage-crop.png)

*A interface mudou. O que continua igual é a necessidade de julgamento.*

## VS Code é o novo cartão perfurado

É isso que o título quer dizer.

VS Code não "ficou ruim". Não é isso. Cartão perfurado também não era "ruim" no contexto histórico dele. Foi uma evolução brutal em relação a digitar bit na mão ou religar fio. O ponto é que ele era o mecanismo da era dele pra informar instruções à máquina.

![Deck de cartões perfurados, quando a profissão exigia mais disciplina na preparação do input do que conforto na interface](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/punched-card-program-deck.jpg)

*VS Code não é o inimigo. Ele só está virando o mecanismo de input da era anterior.*

Hoje, editor de texto está virando isso de novo: um mecanismo de input que ainda funciona, ainda vai existir por muito tempo, mas que já não é mais o centro da atividade.

Se você nunca viu essa história das eras mais antigas da computação, eu já expliquei isso em [Akitando #86 - O Computador de Turing e Von Neumann](/2020/10/23/akitando-86-o-computador-de-turing-e-von-neumann-por-que-calculadoras-nao-sao-computadores/):

{{< youtube id="G4MvFT8TGII" >}}

E se quiser relembrar por que 6502, Z80 e as máquinas antigas forçavam outro tipo de disciplina, revisita o [Guia +Hardcore de Introdução à Computação](/2020/06/04/akitando-80-o-guia-hardcore-de-introducao-a-computacao/) e o episódio [Aprendendo sobre Computadores com Super Mario (do jeito Hardcore++)](/2020/06/18/akitando-81-aprendendo-sobre-computadores-com-super-mario-do-jeito-hardcore/). Aquilo não era nostalgia de velho. Era pra mostrar que, em cada era, a interface muda, mas a máquina continua exigindo precisão.

![Thumbnail do Akitando #80, parte da série feita para ensinar fundamentos de computação usando a era 6502 e microcomputadores como ponto de partida](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/akitando-80-6502.jpg)

*Foi pra isso que boa parte do Akitando existiu: ensinar o que continua valendo quando a ferramenta da moda muda.*

Aliás, vale lembrar uma coisa que muita gente esquece: os 146 vídeos do [Akitando](https://www.youtube.com/@Akitando), mais de 96 horas de conteúdo, foram feitos justamente pra ensinar esse tipo de fundamento pra estudante de Ciência da Computação, júnior e pra quem queria deixar de ser apertador de framework. Eu gravei aquilo porque já via a indústria empurrando gente demais pra tarefa braçal e entendimento de menos. Ironicamente, agora que os agentes chegaram, esse acervo ficou mais relevante do que nunca.

Hoje a interface mudou de novo.

Antes você precisava saber como digitar a instrução.
Depois você precisava saber como ordenar o deck.
Depois você precisava saber como convencer o compilador.
Depois você precisava saber como costurar framework, HTML, CSS, YAML, CI, container, cloud, ORM, fila, observabilidade e mais cinquenta camadas de parafernália.

Agora você precisa saber como **orquestrar um agente**.

E isso, de novo, não elimina fundamento. Só muda o ponto onde o trabalho braçal termina e o trabalho intelectual começa.

## "Então não precisa mais aprender Ciência da Computação?"

Pelo contrário.

Agora precisa mais.

O sujeito sem base olha pro agente fazendo um `SELECT * FROM table`, vê o negócio funcionando localmente com 300 linhas na base fake, e acha que tá tudo certo. Em produção a query puxa um milhão de linhas, explode memória, degrada latência, derruba fila, congestiona conexão, e o cidadão não faz a menor ideia de por que "na minha máquina funciona".

Esse é o problema real.

O agente não sabe o contexto do seu sistema do jeito que um engenheiro experiente sabe. Ele não sabe quais tabelas vão crescer dez vezes no próximo trimestre. Ele não sabe qual endpoint precisa responder em 80 ms e qual pode levar 2 segundos. Ele não sabe qual fluxo precisa de transação, qual precisa de idempotência, qual precisa de lock pessimista, qual precisa de compensação assíncrona, qual precisa de auditoria, qual não pode jamais vazar dado sensível.

Ele pode até acertar a sintaxe.

Só que sintaxe nunca foi a parte mais difícil.

Eu já falei isso no [RANT: o Akita abriu as pernas pra IA??](/2026/02/24/rant-o-akita-abriu-as-pernas-pra-ia/): o que IA faz muito bem é remover as tarefas mundanas. E graças a deus. Eu não entrei em computação pra virar operador de IDE. Eu não sinto nenhum apego romântico por ficar formatando HTML, brigando com CSS, montando CRUD de sempre, colando framework novo em stack velha, ou escrevendo pela centésima vez o mesmo monte de código de infraestrutura que qualquer máquina decente já deveria conseguir produzir.

Mas o que sobra depois que essa camada mundana some?

Sobra justamente a parte que separa amador de programador de verdade:

- modelagem de domínio
- arquitetura
- trade-off
- performance
- escalabilidade
- segurança
- observabilidade
- manutenção
- legibilidade
- custo operacional
- decisão de produto

Tudo isso continua existindo. Tudo isso continua sendo difícil. Tudo isso continua dependendo de julgamento.

## O erro da turma que acha que programar era digitar

Tem gente realmente achando que, se a máquina escreve o código, então acabou a necessidade de saber software.

Isso é a mesma burrice de achar que compilador matou a necessidade de entender computador.

Não matou.

Só matou a necessidade de ficar escrevendo Assembly pra tudo.

E ainda bem.

Da mesma forma, agente de código não mata a necessidade de entender software. Mata a necessidade de você ser datilógrafo de sintaxe.

E ainda bem.

Aliás, tem uma ironia bonita aqui: durante anos a indústria vendeu a fantasia de que programar era "aprender framework". Depois vendeu a fantasia de que programar era "aprender React". Depois vendeu a fantasia de que programar era "aprender a stack do momento". Agora vai vender a fantasia de que programar é "aprender prompt".

Também não é.

Prompt é interface.
Framework é interface.
IDE é interface.
Cartão perfurado era interface.

Programação continua sendo o ato de instruir uma máquina a computar algo útil dentro de restrições reais.

Quem entende isso sobrevive a qualquer mudança de ferramenta.
Quem não entende vira operador da ferramenta da moda e, quando a moda muda, dança junto.

## O que eu acho que vai acontecer com os júniors

Então vamos responder a pergunta original direito.

Os júniors não vão deixar de aprender.

Mas vão ter que aprender **outra coisa**.

Se o júnior de 2015 conseguia passar anos escondendo ignorância atrás de tarefa braçal de baixo valor, mexendo em view, ajustando CSS, montando endpoint bobo, copiando snippet de Stack Overflow e fazendo parecer que estava "produzindo", esse esconderijo está acabando.

O júnior da era dos agentes vai subir de nível mais rápido ou vai ser exposto mais rápido. Não tem muito meio-termo.

Se ele usar agente e realmente estudar fundamento, ele vai conseguir testar hipótese mais rápido, ler mais código, comparar mais soluções, iterar mais, errar mais cedo e corrigir mais cedo. Vai aprender mais em menos tempo.

Mas se ele usar agente sem fundamento, ele vai só terceirizar a própria ignorância. Vai virar revisor incapaz de revisar. Vai aceitar patch que não entende. Vai aprovar decisão que não sabe medir. Vai confundir "passou no teste local" com "está pronto pra produção".

Esse profissional é perigoso.

Muito mais perigoso do que o júnior antigo que ao menos era limitado pela própria lentidão.

## O pós-bolha

A boa notícia é que isso vem logo depois do colapso da fase mais idiota da bolha de contratação.

Já passou da hora de o mercado parar de premiar trabalho intensivo e burro como se fosse competência. Já passou da hora de parar de tratar burocracia de stack como profundidade técnica. Já passou da hora de parar de confundir volume de commit com valor de engenharia.

Se a nova era elimina uma parte grande desse teatro, ótimo.

Num cenário pós-bolha, pós-bootcamp milagroso, pós-CSS como carreira, pós-CRUD como profissão, fundamento volta a ser o que sempre deveria ter sido: o ativo principal.

Quem entende sistema operacional, banco de dados, rede, estrutura de dados, compiladores, arquitetura de computador, profiling, debugging, concorrência, consistência, segurança e custo, vai usar agentes como exoesqueleto.

Quem não entende nada disso vai usar agente como muleta.

Exoesqueleto amplia força.
Muleta só tenta esconder fraqueza.

## "Mas isso não é sustentável"

Sempre aparece alguém com a mesma desculpa: "ah, mas eu não acho que isso seja sustentável, os data centers não vão aguentar, os preços estão subsidiados demais, não tem como isso continuar assim."

E olha, essa pessoa não está completamente errada.

Só que isso não muda em nada o que eu tenho pra fazer amanhã de manhã.

Esse tipo de preocupação pode até render papo de bar ou thread no X, mas não me ajuda a decidir nada útil. Eu, você, nenhum de nós vai sentar com a diretoria da Anthropic ou da OpenAI pra redesenhar capex de data center, renegociar contrato de energia, decidir margem de subsídio ou planejar a próxima geração de GPU. Não tem nenhuma ação concreta que saia disso pra nós além de ficar repetindo que "um dia vai dar problema".

É a mesma mentalidade de quem olhava pra internet nos anos 90 e falava: "vamos não usar muito isso, é lento demais, o limite é ridículo, o preço por kilobyte é absurdo, melhor esperar arrumarem." Ou de quem, no começo dos anos 2000, olhava pra dados móveis e dizia: "2G é lento demais, é limitado demais, melhor não depender disso." Por que exatamente você ia querer ser essa pessoa?

Ainda bem que OpenAI, Anthropic e o resto estão se estapeando e subsidiando pesado essa corrida. Eu estou aproveitando sem o menor pudor. Já torrei meu Claude Max 20x inteiro, já bati no limite de extra usage, já torrei meu plano do Codex, e subi pra Pro pra continuar usando neste fim de semana. Quem paga mensalidade e usa pouco está, na prática, me subsidiando pra eu usar tudo o que consigo. Eu não tenho a menor intenção de desacelerar. Por que você teria?

Se amanhã os preços mudarem, a infraestrutura apertar ou o jogo virar, eu reavalio amanhã. É assim que tecnologia sempre funcionou. Enquanto a janela está aberta, o racional não é frear por antecipação. O racional é aprender o máximo, extrair o máximo, ganhar vantagem enquanto o resto está ocupado explicando por que ainda não começou.

## A decisão continua sendo humana

No fim do dia, nada do que importa mudou.

Alguém continua precisando olhar pro resultado e decidir:

- isso pode ir pra produção?
- isso aguenta carga?
- isso está legível?
- isso está seguro?
- isso está fácil de manter?
- isso conversa com o resto do sistema?
- isso resolve o problema certo?

Se a resposta for não, alguém continua precisando saber **por que** é não.

E mais importante: alguém continua precisando saber **como corrigir**.

É por isso que, na era dos agentes, conhecimento de base não ficou menos importante. Ficou mais caro errar sem ele.

VS Code é o novo cartão perfurado.

Não porque ficou inútil.

Mas porque finalmente estamos entrando numa era em que o ato de digitar código manualmente deixa de ser o centro da profissão.

E, honestamente? Já foi tarde.

> **IA reflete quem você é.**
>
> Se você é bom, ela acelera código bom.
>
> Se você é ruim, ela acelera dívida técnica numa velocidade industrial.
>
> IA não vai pegar programador ruim e transformar em programador bom. Nunca transformou, não transforma e não vai transformar.

Por isso fundamento importa mais agora do que antes.

O agente pode escrever. Quem continua precisando saber se aquilo presta é você.
