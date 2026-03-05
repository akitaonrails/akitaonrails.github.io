---
title: "37 dias de Imersão em Vibe Coding: Conclusão quanto a Modelos de Negócio"
slug: "37-dias-de-imersão-em-vibe-coding-conclusão-quanto-a-modelos-de-negócio"
date: 2026-03-05T14:00:00-03:00
draft: false
tags: ["ai", "vibe-coding", "startups", "business", "opinion"]
description: "Depois de 37 dias, 650+ commits, ~144K linhas de código e quase 10 projetos publicados, minha conclusão sobre o que vibe coding significa para o futuro de startups e modelos de negócio."
---

Nos últimos 37 dias eu me enfiei numa imersão em vibe coding. O objetivo era simples: entender de verdade o que a geração atual de LLMs e agentes de código consegue fazer. Não testando num toy project de fim de semana, mas construindo projetos reais, com deploy em produção, usuários, e as dores de manutenção que vêm junto.

O resultado foram 653 commits, ~144K linhas de código em 8 projetos publicados no GitHub, e uma série de artigos documentando cada um deles. Se você acompanhou, já leu os post-mortems. Se não acompanhou, aqui vai o índice:

## Os artigos

- [Vibe Code: Eu fiz um appzinho 100% com GLM 4.7 (TV Clipboard)](/2026/01/28/vibe-code-eu-fiz-um-appzinho-100-com-glm-4-7-tv-clipboard/)
- [Vibe Code: Qual LLM é a MELHOR?? Vamos falar a REAL](/2026/01/29/vibe-code-qual-llm-é-a-melhor-vamos-falar-a-real/)
- [Vibe Code: Fiz um Editor de Markdown do zero com Claude Code (FrankMD) PARTE 1](/2026/02/01/vibe-code-fiz-um-editor-de-markdown-do-zero-com-claude-code-frankmd-part-1/)
- [Vibe Code: Fiz um Editor de Markdown do zero com Claude Code (FrankMD) PARTE 2](/2026/02/01/vibe-code-fiz-um-editor-de-markdown-do-zero-com-claude-code-frankmd-parte-2/)
- [RANT: IA acabou com os programadores?](/2026/02/08/rant-ia-acabou-com-programadores/)
- [Vibe Code: Do Zero à Produção em 6 DIAS - The M.Akita Chronicles](/2026/02/16/vibe-code-do-zero-a-producao-em-6-dias-the-m-akita-chronicles/)
- [Do Zero à Pós-Produção em 1 Semana - Como usar IA em Projetos de Verdade](/2026/02/20/do-zero-a-pos-producao-em-1-semana-como-usar-ia-em-projetos-de-verdade-bastidores-do-the-m-akita-chronicles/)
- [Vibe Code: Fiz um clone do Mega em Rails em 1 dia pro meu Home Server](/2026/02/21/vibe-code-fiz-um-clone-do-mega-em-rails-em-1-dia-pro-meu-home-server/)
- [Vibe Code: Fiz um Indexador Inteligente de Imagens com IA em 2 dias - Frank Sherlock](/2026/02/23/vibe-code-fiz-um-indexador-inteligente-de-imagens-com-ia-em-2-dias/)
- [RANT: o Akita abriu as pernas pra IA??](/2026/02/24/rant-o-akita-abriu-as-pernas-pra-ia/)
- [ai-jail: Sandbox para Agentes de IA](/2026/03/01/ai-jail-sandbox-para-agentes-de-ia-de-shell-script-a-ferramenta-real/)
- [Software Nunca Está 'Pronto' - 4 Projetos, a Vida Pós-Deploy](/2026/03/01/software-nunca-esta-pronto-4-projetos-a-vida-pos-deploy-e-por-que-one-shot-prompt-e-mito/)
- [Eu Fiz um Sistema de Data Mining pra Minha Namorada Influencer](/2026/03/04/eu-fiz-um-sistema-de-data-mining-pra-minha-namorada-influencer-dicas-e-truques/)
- [Meu primeiro fracasso com Vibe Code e como Consertei - Frank Yomik](/2026/03/05/meu-primeiro-fracasso-com-vibe-code-e-como-consertei-frank-yomik/)

## Os projetos

| Projeto | Commits | LOC | Tempo | O que faz |
|---------|---------|-----|-------|-----------|
| [FrankMD](https://github.com/akitaonrails/FrankMD) | 234 | 38K | ~5 dias | Editor de Markdown em Rust/Tauri |
| [FrankYomik](https://github.com/akitaonrails/FrankYomik) | 131 | 21K | ~9 dias | Tradutor de mangá/webtoon (Go + Python + Flutter) |
| [FrankSherlock](https://github.com/akitaonrails/FrankSherlock) | 103 | 37K | ~6 dias | Indexador inteligente de imagens (Rails + Python) |
| mila-bot (privado) | 60 | 30K | ~3 dias | Sistema de data mining (Rails + Discord) |
| [TVClipboard](https://github.com/akitaonrails/tvclipboard) | 49 | 5K | ~2 dias | App de clipboard cross-device com GLM 4.7 |
| [ai-jail](https://github.com/akitaonrails/ai-jail) | 46 | 6K | ~4 dias | Sandbox de segurança pra agentes de IA (Rust) |
| [FrankMega](https://github.com/akitaonrails/FrankMega) | 29 | 7K | ~1 dia | Clone do Mega para home server (Rails) |
| The M.Akita Chronicles | 1+ | muitas | ~6 dias | Blog/newsletter completo em produção |

Isso tudo aconteceu entre 27 de janeiro e 5 de março de 2026.

Não vou repetir os detalhes técnicos de cada projeto. Cada post-mortem acima já cobriu isso. O que eu quero discutir aqui é a consequência.

## O que esses 37 dias me mostraram

Projetos que antes levariam semanas ou meses pra um desenvolvedor experiente agora levam dias. Um editor de Markdown completo em 5 dias. Um clone do Mega em 1 dia. Um sistema de data mining com 40+ ferramentas de bot em 3 dias. Um indexador de imagens com vision AI em 2 dias.

E não estou falando de protótipos jogados fora. Esses projetos estão em produção. Têm testes. Têm deploy automatizado. São software de verdade construído com práticas de engenharia de verdade, só que com velocidade que antes era impensável.

Essa velocidade não é exclusiva minha. A Cloudflare acabou de demonstrar algo parecido. [Num post recente](https://blog.cloudflare.com/vinext/), eles descrevem como um engenheiro reimplementou o surface de API do Next.js sobre Vite em uma semana, usando Claude como ferramenta principal. US$ 1.100 em tokens de API, mais de 800 sessões, 1.700 testes unitários, 380 testes E2E, builds 4.4x mais rápidos que o Next.js original. Controvérsias à parte sobre se é uma reimplementação "completa" ou não, o ponto central é real: software que antes exigia equipes e meses agora pode ser construído por uma pessoa em dias.

E isso muda tudo pra quem quer empreender.

## A morte da startup fácil

Durante anos, o modelo clássico de startup funcionava assim: alguém tem uma ideia, monta uma equipe pequena, desenvolve um MVP em 3-6 meses, levanta seed money, e tenta escalar. A barreira de entrada era o custo de desenvolvimento. Programadores são caros, desenvolvimento é lento, e o primeiro a chegar no mercado tem vantagem.

Esse modelo está quebrando.

Se eu consigo fazer um clone funcional do Mega em 1 dia, quanto vale a startup de "cloud storage"? Se a Cloudflare reimplementa o core do Next.js em 1 semana com um engenheiro e US$ 1.100 em tokens, qual é o moat real de uma plataforma como Vercel? O SaaS de "social listening" que cobra R$ 500/mês compete com algo que eu fiz em 3 dias como side project.

Todo aquele empreendedor que chegava descrevendo sua ideia como "é tipo um Uber, mas pra..." ou "é como Airbnb, só que..." ou "mais uma rede social, mas com..." -- essas pessoas precisam parar e repensar. Quando qualquer desenvolvedor competente com acesso a Claude Code ou GPT Codex consegue replicar seu MVP numa semana, sua ideia não vale mais nada. A execução ficou barata demais.

Não estou exagerando. Nos meus 37 dias, eu fiz coisas que antigamente eu não faria nem em 6 meses. Pequenos CRMs, ecommerces, gerenciadores de conteúdo, ferramentas de produtividade, apps de data mining, pipelines de processamento -- tudo isso virou commodity. O código em si não é mais diferencial.

## O que é diferencial, então?

Aqui entra a parte que a maioria dos entusiastas de vibe coding ignora. Pra ilustrar, vou usar meu próprio projeto como exemplo.

O [Frank Yomik](https://github.com/akitaonrails/FrankYomik) traduz páginas de mangá de japonês pra inglês em tempo quase real. O pipeline inteiro (detecção de balões, OCR, tradução, renderização) funciona. Mas o componente mais importante do sistema não é nenhum código que eu escrevi. É o modelo `ogkalu/comic-text-and-bubble-detector`, um RT-DETR-v2 treinado em ~11.000 imagens rotuladas de quadrinhos.

Eu não treinei esse modelo. Eu não poderia treinar esse modelo facilmente. Coletar 11.000 imagens de quadrinhos diversas, rotular manualmente os balões de fala em cada uma (ou gerar labels com alguma pipeline semi-automatizada, o que também não é trivial), configurar o treinamento, e rodar no hardware necessário -- isso é trabalho de natureza diferente. É trabalho que vibe coding não resolve.

E esse é o caso de um modelo relativamente pequeno. Um detector de objetos pode ser treinado com algumas centenas a milhares de imagens rotuladas numa única GPU em horas. Estudos mostram que resultados úteis são possíveis com 100-350 imagens pra domínios específicos, mas detectores robustos pro mundo real geralmente precisam de milhares. O custo é baixo, na casa de centenas de dólares.

Agora olha o que acontece quando subimos pra modelos maiores.

## Os números que importam

O GPT-4 custou mais de US$ 100 milhões pra treinar, segundo o próprio Sam Altman. A Stanford estimou o custo de compute do Gemini Ultra do Google em US$ 191 milhões. O Llama 3 da Meta consumiu 39,3 milhões de GPU-horas em H100s, e a Meta montou dois clusters de 24.576 GPUs cada pra viabilizar isso -- e até o final de 2024, planejava ter 350.000 H100s na sua infraestrutura.

Esses custos estão acelerando. Segundo a Epoch AI, o custo de hardware e energia pra treinar modelos de fronteira cresce a 2,4x por ano desde 2016. Se essa tendência continuar, os maiores treinamentos vão custar mais de US$ 1 bilhão antes do fim de 2027. O Dario Amodei, CEO da Anthropic, já disse que desenvolvedores de fronteira provavelmente estão gastando perto de um bilhão por treinamento agora, com treinamentos de US$ 10 bilhões esperados em dois anos.

E o hardware? Uma GPU H100 custa US$ 25.000-40.000 por unidade. Um servidor com 8 GPUs sai entre US$ 200.000 e US$ 400.000. A memória HBM que essas GPUs usam está com capacidade esgotada -- SK Hynix, Samsung e Micron já anunciaram aumentos de ~20% nos preços pra 2026. A NVIDIA consome mais de 60% da produção global de HBM. É um gargalo estrutural, não temporário.

Em termos de energia: data centers globais consumiram ~415 TWh de eletricidade em 2024, segundo o IEA, cerca de 1,5% da eletricidade mundial. A projeção é ~945 TWh até 2030. Novos data centers estão sendo construídos com capacidades de 100 MW a 1 GW cada.

E os investimentos das big techs refletem isso. Em 2025, os gastos de capital agregados de Amazon (\~$125B), Google (\~$91B), Microsoft (\~$80B) e Meta (\~$71B) passaram de US$ 400 bilhões, crescimento de 62% sobre 2024. Goldman Sachs projeta mais de US$ 500 bilhões em 2026.

Esses números não são pra assustar. São pra contextualizar de onde vem a barreira de entrada real.

## A nova barreira: dados exclusivos e capacidade de treinamento

Se software ficou barato de produzir, o diferencial competitivo migrou. A pergunta deixou de ser "quem escreve o código mais rápido?" e virou "quem tem acesso a dados que ninguém mais tem, e sabe transformar esses dados em modelos úteis?"

O DeepSeek-V3 anunciou que seu treinamento custou US$ 5,5 milhões em compute. A imprensa celebrou o "modelo barato chinês". Mas o The Register reportou que o custo de aquisição dos 256 servidores GPU usados foi de mais de US$ 51 milhões -- e isso exclui R&D, aquisição de dados, limpeza de dados, e todos os treinamentos fracassados antes do run final que deu certo. O custo real de desenvolver a capacidade é uma ou duas ordens de grandeza acima do custo marginal do treinamento final bem-sucedido.

É por isso que só vemos grandes empresas produzindo modelos de fronteira. Meta, Alibaba, Google, Amazon, Microsoft, Anthropic -- empresas que investem dezenas de bilhões em hardware e energia. Uma startup em garagem não consegue competir nessa dimensão.

Mas a questão vai além de modelos de fronteira. Mesmo modelos especializados menores exigem algo que não se compra: dados proprietários de qualidade.

O Llama 3 foi treinado em 15 trilhões de tokens. A Epoch AI já documentou que estamos nos aproximando dos limites de dados textuais gerados por humanos na internet. Dados públicos estão sendo exauridos. Quem tem dados exclusivos -- dados médicos, financeiros, industriais, logísticos, de sensores, de comportamento de usuário -- tem algo que não pode ser replicado por vibe coding.

E mesmo quem treina modelos especializados com dados proprietários enfrenta um problema: a vantagem é temporária. Outro competidor pode coletar dados similares e treinar um modelo concorrente em meses. O diferencial precisa ser continuamente alimentado: mais dados, melhor curadoria, pipelines de treinamento mais eficientes, acesso a hardware que está cada vez mais escasso e caro.

## O cenário

Se você está pensando em montar uma startup, a pergunta que importa mudou.

Antes era: "consigo construir esse software?" Agora a resposta é quase sempre sim, rápido e barato.

A pergunta agora é: "tenho dados exclusivos que ninguém mais tem, e sei como transformar esses dados em algo útil que seja difícil de replicar?"

Se a resposta for não, qualquer concorrente com Claude Code replica seu produto em dias. E depois aparece outro. E outro. A corrida pro fundo em preço é imediata quando o custo de construir é próximo de zero.

Se a resposta for sim, você tem um moat real -- mas temporário. Modelos concorrentes treinados em dados similares podem aparecer em meses. Seu diferencial precisa ser continuamente alimentado.

A era das startups fáceis acabou. Não porque ficou mais difícil construir software -- ficou muito mais fácil. Mas justamente por isso: quando todo mundo consegue construir a mesma coisa em uma semana, a vantagem competitiva precisa vir de outro lugar. E esse "outro lugar" requer capital e infraestrutura que são ordens de grandeza mais caros do que escrever código.

A garagem ainda funciona. Mas o que sai dela não pode mais ser "um app".
