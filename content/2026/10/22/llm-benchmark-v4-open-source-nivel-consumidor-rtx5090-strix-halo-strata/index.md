---
title: "LLM Benchmark v4: open source nível consumidor na RTX5090 ou Strix Halo. E o Strata?"
slug: "llm-benchmark-v4-open-source-nivel-consumidor-rtx5090-strix-halo-strata"
date: '2026-10-22T11:30:00-03:00'
draft: false
translationKey: llm-benchmark-v4-open-source-nivel-consumidor-rtx5090-strix-halo-strata
description: "Voltei pro hardware de consumidor depois dos testes em datacenter. O Qwen3.8 Flash-Next fez 91,0, Tier A, numa RTX 5090 com o motor Strata, a 1,5 ponto da B300 e a 159 tokens por segundo. É um modelo diferente do Qwen 3.8 27B que eu tinha chamado de lento: um MoE com 6B ativos por token, servido com os especialistas mais usados na placa. A Strix Halo fez 80,0 com o 27B, mas a 7,7 tokens por segundo. É o primeiro modelo local que fez Tier A no v4 e que vale testar no dia a dia de programação, se você achar uma 5090: a NVIDIA nega o fim da produção, mas admite oferta apertada."
tags:
- benchmarks-de-llm
- modelos-locais
- llms
- hardware
images:
- /2026/10/22/llm-benchmark-v4-can-my-team-fit-in-a-4x-b300-h200/dgx-spark-box.jpeg
---

Nos dois últimos artigos eu cobri o [benchmark dos modelos grandes em 4x B300](/2026/10/22/llm-benchmark-v4-open-source-que-so-cabe-em-4x-b300/) e a [conta de time e custo por usuário em B300 e H200](/2026/10/22/llm-benchmark-v4-can-my-team-fit-in-a-4x-b300-h200/). Agora a pergunta de todo desenvolvedor que não tem um pod na Runpod: **hardware de consumidor já serve pra trabalhar com IA de verdade?**

Voltei pra duas máquinas que eu já tinha: uma workstation com RTX 5090 e um mini PC Strix Halo. E com um motor de inferência novo, o Strata, que promete fazer MoE grande caber em PC comum. A resposta curta: um modelo de 125B já faz Tier A numa RTX 5090. O resto é mais complicado.

## As máquinas, lado a lado

Antes de qualquer nota, entenda a diferença física do que eu estou comparando:

| Hardware | Memória | Banda | Arquitetura | Custo aproximado |
| --- | --- | --- | --- | --- |
| NVIDIA B300 | 288 GB HBM3e | ~8 TB/s | Blackwell Ultra, FP8 e FP4 | US$ 9/hora (Runpod) |
| NVIDIA H200 | 141 GB HBM3e | ~4,8 TB/s | Hopper, FP8 | US$ 3,59/hora |
| DGX Spark | 128 GB unificada | 273 GB/s | GB10, FP4 | ~US$ 6.950 |
| RTX 5090 | 32 GB GDDR7 | ~1,8 TB/s | Blackwell sm_120, FP8/FP4 | US$ 1.999 sugerido (~5x no varejo) |
| Strix Halo (Ryzen AI Max+ 395) | 128 GB unificada | ~256 GB/s | gfx1151, ROCm | ~US$ 2.000 |

O B300 tem mais de 30 vezes a banda de memória da Strix Halo. A 5090 tem 7 vezes. Isso explica por que o mesmo modelo voa numa máquina e rasteja na outra, e por que quantização deixa de ser detalhe e vira decisão de projeto.

E tem o detalhe da memória ser compartilhada: na Strix e na Spark, a mesma RAM serve CPU, GPU e sistema operacional. Não é VRAM dedicada, então a folga real é bem menor que o número bonito da caixa.

## O ranking em hardware de consumidor

A régua é a mesma do benchmark v4 de sabotagem: 14 defeitos plantados, nota de vigilância de revisão, Tier A a partir de 83.

| Modelo / máquina | Variante e engine | Nota / Tier | Velocidade |
| --- | --- | ---: | ---: |
| **Qwen3.8 Flash-Next** (125B-A6B) | RTX 5090, Strata, IQ3_S | **91,0 (A)** | 159,2 tok/s |
| Ornith-1.5-35B-A3B | RTX 5090, Strata, Q8_0 GGUF | 64,5 (C) | ~80 tok/s |
| Qwen3.8-27B | 5090 → Strix, Q5_K_M → Q8_0 | 80,0 (B) | 7,7 tok/s |
| GLM-4.7-Flash (30B-A3B) | RTX 5090, llama-swap, Q5_K_M | 24,0 (D) | não medido |

O GLM-4.7-Flash completou o protocolo inteiro (depois de uma primeira tentativa aninhada que precisou de retry) e mesmo assim fracassou em detectar sabotagem. E tem uma lição de humildade no Qwen 27B: ele fez 80 na mesma tarefa em que fez 80,5 na B300, mas a 7,7 tokens por segundo na sonda Q8 e 706 minutos de relógio. Nota boa não paga produtividade.

Deixei de fora os testes que ainda não têm nota final: a Qwen3.8 Flash-Next na Strix com Strata só está confirmada como executável, e as densas de 27B foram descartadas na Strix pelo corte de 30 tok/s.

## O tuning que faz modelo rodar bem em PC

Hardware de consumidor não perdoa configuração preguiçosa. O que eu aprendi na prática:

- **Na 5090, compile o llama.cpp pro sm_120.** Imagem pronta cai em fallback PTX lento. É `-DGGML_CUDA=ON -DCMAKE_CUDA_ARCHITECTURES=120`, driver 570+, e nada de `--ctx-size 0` numa placa de 32 GB: o default de contexto de treino estoura a VRAM na primeira alocação. Contexto tem teto explícito, e se der OOM no primeiro request, corta 25 a 50%.
- **KV cache em q8_0.** Corta a memória de KV pela metade sem custo mensurável de qualidade. Flash-attention ligado por padrão, mas o GLM 4.7 Flash precisa dele desligado, porque a arquitetura deepseek2 dele é incompatível.
- **Raciocínio híbrido dá trabalho.** O Qwen3.8-27B, com a arquitetura SSM/Mamba, precisou de build fresco do llama.cpp/Ollama por causa do `ssm_conv1d`. E o modo "sem raciocínio" não impediu loop de coerência em uma das tentativas; a saída foi retomar na Strix com Q8_0 e `--reasoning off`. Não foi memória extra que resolveu, foi desligar o pensamento.
- **Na Strix, o ajuste é ROCm, não mágica.** `HSA_OVERRIDE_GFX_VERSION`, `GGML_HIP_NO_VMM`, `-dio`. O trunfo dela é capacidade (128 GB), não velocidade (~256 GB/s). Q4_K_M deu 12,6 tok/s e Q8_0 deu 7,7 tok/s, abaixo do meu corte de 30 tok/s pra uso interativo. Por isso a Strix virou escape hatch de modelo grande, não caixa de chat rápida.
- **Especulação só ajuda com aceitação alta.** Num [teste do Mihai Farcas](https://mihai.ltd/blog/beating-llamacpp-from-scratch-consumer-amd) numa RX 7900 XTX, a especulação por n-gram do llama.cpp, sem modelo de rascunho, teve só 5 de 64 tokens aceitos, e a vazão ficou igual numa rodada e caiu uns 2% na outra. O ganho aparece com um rascunhador feito pro modelo, como o ajudante que o Strata usa no Flash-Next.

## O que é esse tal de Strata

O [Strata](https://github.com/Niko1221/Strata) é um motor de inferência open source, licença MIT, feito em torno de um modelo: o **Qwen3.8 Flash-Next**, um MoE de 125 bilhões de parâmetros que normalmente pede servidor. Ele também roda MoEs menores, como a Ornith-35B que testei aqui. O código é C++ e CUDA e reaproveita partes do llama.cpp/ggml. Tem builds pra NVIDIA (CUDA 12 e 13), AMD (inclusive Strix Halo), Intel Arc e Apple Silicon, e sobe uma API compatível com OpenAI e Anthropic em localhost, que pluga direto no Claude Code, Codex CLI ou OpenCode.

Cuidado com o nome. O Mihai Farcas publicou [outro motor chamado Strata](https://mihai.ltd/blog/beating-llamacpp-from-scratch-consumer-amd), em Rust com kernels HIP, pra modelos densos pequenos do Qwen 3.5 numa RX 7900 XTX. São projetos diferentes, e o que rodou aqui foi o primeiro.

O problema que ele ataca é o MoE grande em máquina pequena. A estratégia é **expert-offload**, em camadas:

- o modelo tem 24.576 especialistas, 512 em cada uma das 48 camadas, e cada token usa só 10 por camada;
- a GPU guarda uns 4 mil especialistas, os mais usados;
- a RAM do sistema guarda todos;
- uma tabela de consulta de uns 29 GB fica no SSD, e o modelo lê poucas linhas dela por token.

Em cima disso, um ajudante pequeno chuta as próximas palavras e o modelo grande confere todas de uma vez. O README promete a mesma resposta 1,6 a 1,8 vez mais rápido. O mínimo é 32 GB somando RAM e VRAM, mais uns 80 GB de disco, e a variante IQ3_S que eu usei tem uns 55 GB.

O que me fez acreditar nele foi o resultado: o **Qwen3.8 Flash-Next na 5090 com Strata fez 91,0, com zero nudges e os 14 itens resolvidos**, a 1,5 ponto do 92,5 que o mesmo modelo fez na B300 com vLLM. O próprio relatório chama isso de "dentro do ruído". Um projeto de comunidade, numa placa de consumidor, ficou colado no mesmo modelo servido em datacenter em NVFP4.

## Cuidado: o Strata come a GPU toda, e o desktop morre

Tem um custo que não aparece em benchmark: rodar o Strata na mesma GPU que desenha a sua área de trabalho. Ele foi feito pra encher a placa, e enche mesmo.

No meu caso, o motor alocou 32.085 dos 32.607 MiB da 5090, 98,4% da VRAM. O Hyprland ficou com uns 500 MiB pra si, as alocações do desktop falharam, e até o terminal parou de responder. Só resolveu com hard reset.

Foram duas falhas em sequência. A reserva que eu tinha configurado era de 2.560 MiB, mas o proxy disparava uma única vez, engolia a exceção e nunca tentava de novo. O endpoint `/v1/vram` ainda não estava no ar naquele instante, então a reserva não foi aplicada. E 2.560 MiB já era pouco pra Hyprland, navegador e terminal juntos.

A correção, validada em teste de carga:

- Reserva de **4.096 MiB** (4 GiB), com retry por até alguns minutos, verificação da resposta do motor e log de confirmação. Nada de fire-and-forget.
- Reafirmação da reserva a cada 30 segundos enquanto o motor está carregado, pra fechar qualquer deriva de rebalanceamento.
- No primeiro teste de carga, com a GPU a 99%, ficaram **3.629 a 3.888 MiB livres durante toda a geração**. No teste seguinte, uma geração longa e outras três requisições concorrentes terminaram com sucesso; a menor folga observada foi 3.949 MiB. O desktop continuou vivo.

O preço aparece na vazão. O cache de especialistas caiu de uns 11.700 slots pra 9.700, então mais especialistas viajam por PCIe. Na medição inicial, saiu de ~200 pra ~150 tokens por segundo. Eu pago isso feliz: um desktop que não congela vale mais que aqueles 25% de velocidade naquele teste.

Tem uma alternativa estrutural: essa máquina tem uma Radeon 610M integrada, e dá pra mover o Hyprland pra ela. A 5090 ficaria dedicada à inferência.

O custo é que a 610M é fraca pra jogos e o multi-GPU da NVIDIA no Wayland tem suas manias. Eu preferi a reserva elástica, porque o modelo também descarrega quando fica ocioso.

A lição geral: **não deixe motor de inferência tomar 100% de uma GPU que também desenha sua tela.** Nesta configuração não tenho uma reserva rígida de VRAM no driver pro cliente de display. Precisei resolver do lado do motor: reservar alguns GB, reafirmar depois de cada cold start e medir de novo com a área de trabalho aberta.

### Os mesmos 32 GB também limitam a sessão

A conta da 5090 é apertada por todos os lados. Os mesmos 32 GB precisam acomodar os pesos densos e buffers fixos do modelo, o cache dos especialistas quentes, a parte residente do KV cache e ainda a reserva de 4 GiB pro Hyprland, navegador e terminal. O que sobra pra uma coisa sai de outra.

KV cache é a memória da conversa. Cada token do prompt, das respostas anteriores e dos arquivos lidos cria estado que o modelo precisa consultar nos próximos tokens. No meu Strata ele está em `int8`, com 32K células por camada residentes na GPU.

O restante pode ser transmitido da RAM, por isso aumentar a janela de 128K pra 256K não aumentou a VRAM nem derrubou a velocidade no meu teste sintético. Esse streaming evita o estouro imediato, mas continua usando memória e não transforma uma 5090 num servidor sem limite.

O teto configurado aqui é **262.144 tokens, ou 256K**. Vários modelos comerciais que testei, inclusive os Claude mais novos, já trabalham na classe de 1 milhão de tokens. Quase quatro vezes a janela muda o jeito de trabalhar: no Claude Code dá pra acumular muito mais histórico antes da compactação; no Qwen local eu preciso tratar contexto como orçamento desde o primeiro prompt.

A conversa que aparece no terminal é só uma parte do contexto. Dependendo do harness, também entram o system prompt, `AGENTS.md` e `CLAUDE.md`, catálogo e conteúdo carregado de skills, descrições e schemas de ferramentas, servidores MCP, instruções de plugins, saídas de comandos, arquivos e o espaço reservado pra resposta. Uma skill bem implementada carrega o texto completo só quando é chamada, mas o catálogo dela ainda pode entrar no prompt. Plugin que registra vinte ferramentas também manda vinte schemas antes de você pedir qualquer coisa.

Foi por isso que o benchmark não usou meu OpenCode normal. O runner [gera uma configuração isolada](https://github.com/akitaonrails/llm-coding-benchmark#local-opencode-benchmark-config), sem os plugins e MCPs globais, com apenas os providers e agentes necessários pro teste. Também fixa o limite real de 262.144 tokens em vez de fingir que o modelo aceita o contexto anunciado por outro backend.

Pra usar esse Qwen no dia a dia, eu faria a mesma limpeza:

- começar com o harness mais enxuto possível e ativar plugins ou MCPs quando o projeto realmente precisar;
- deixar skills pesadas sob demanda, sem despejar manuais inteiros no começo da sessão;
- compactar ou abrir uma sessão nova antes de encostar no teto, registrando decisões importantes em arquivos do projeto;
- reservar espaço pra saída do modelo. Uma janela lotada de entrada não serve se não sobra token pra ele pensar, chamar ferramentas e responder.

> Com 256K, contexto é recurso de hardware. Instalar integração demais e carregar tudo em toda sessão consome janela e memória antes do trabalho começar.

## Mas o Qwen 3.8 não era lento demais?

Era, e eu escrevi isso. No [ranking do v4](/2026/09/15/novo-llm-benchmark-v4-retestando-todos-llms-parte-2/), o Qwen 3.8 27B rodando local levou quase 12 horas pra fechar as sete sprints. No [artigo da B300](/2026/10/19/llm-benchmark-v4-os-top-llms-open-source-numa-b300/) eu resumi: fez 80, levou 706 minutos, "então nem tente".

Só que aquele é outro Qwen 3.8. A família tem os dois, e eles se comportam de jeitos opostos em casa:

| | Qwen 3.8 27B | Qwen3.8 Flash-Next |
| --- | --- | --- |
| Arquitetura | denso, 27B | MoE, 125B no total, 6B ativos por token |
| Onde terminou o v4 | Strix Halo, Q8_0 | RTX 5090, IQ3_S, Strata |
| Velocidade | 7,7 tok/s | **159,2 tok/s** |
| Nota v4 | 80,0 (B) | **91,0 (A)** |

### Por que o maior roda mais rápido

Na geração de token, máquina local é limitada por banda de memória: cada token precisa ler todos os pesos ativos. O 27B denso lê os 27 bilhões a cada token, uns 29 GB em Q8. A Strix move uns 256 GB/s, então o teto fica perto de 9 tokens por segundo, e eu medi 7,7.

Na 5090 o mesmo 27B seria rápido, mas em Q8 ele não cabe nos 32 GB junto com o contexto que sete sprints acumulam. Em Q5_K_M ele coube, mas travou num loop de raciocínio no sprint 3. Terminou na Strix, em Q8_0 e com o raciocínio desligado (`--reasoning off`), que foi o que destravou o loop.

O Flash-Next tem quase cinco vezes mais parâmetros no total, mas só uns 6 bilhões trabalham por token. Em 3 bits, isso é por volta de um décimo do que o 27B em Q8 precisa ler. Os especialistas quentes ficam na GDDR7 da 5090, com sete vezes a banda da Strix, e o ajudante de especulação adianta tokens. Resultado: uns 20 vezes a velocidade do 27B na Strix, com nota maior.

> A virada veio da troca de modelo e de motor: um MoE com poucos parâmetros ativos, servido por um motor de expert-offload feito sob medida pra ele. Flag nenhuma de configuração tiraria isso do 27B denso na Strix.

### O tuning ainda cobra

O preço de rodar em casa muda de modelo pra modelo. O Flash-Next em 3 bits perdeu só 1,5 ponto contra a versão NVFP4 da B300. A Ornith-35B, no mesmo motor e na mesma placa, perdeu 16,5 contra a versão BF16 dela na B300. Meça o seu modelo antes de confiar nele.

## O que cada modelo fez de interessante

**Flash-Next: a prova de que consumidor chega em Tier A.** 34 de 40 sem aviso, mais 6 com peso de revelação, e só dois itens precisando de apontar. Nenhum nudge, todas as sprints limpas. É o único local que junta nota de Tier A, velocidade interativa (159 tok/s) e protocolo completo sem ajuda. Se a pergunta é "da pra usar no trabalho", esse é o exemplo.

**Ornith-35B: rápido, mas não bom o suficiente.** A mesma Ornith que fez 81 na B300 em BF16 fez 64,5 na 5090 com Q8_0. Caiu a detecção sem aviso de 30 pra 23. Mudou quantização, motor e hardware ao mesmo tempo, então não dá pra isolar a causa: essa combinação de Q8_0 + Strata + 5090 perdeu 16,5 pontos, e eu não sei quanto veio de cada variável. O recado é claro: "roda rápido" não é "revisa bem".

**Qwen 27B: boa nota, péssima experiência.** Fez 80 na retomada na Strix, com sprints 1 e 2 na 5090, quase o 80,5 da B300. Mas 7,7 tok/s na sonda Q8 e 706 minutos de wall time. E ainda por cima zero consertos na revelação, com quatro itens abertos. Usar isso no dia a dia é escolher esperar.

**GLM-4.7-Flash: o motor rodou, o modelo falhou.** Protocolo completo em 29 minutos, e zero detecção sem aviso. Recuperou 8 de 14 só quando apontado, e mesmo assim deixou os consertos sem commit. Na B300 ele fez 33,5, que também não é bom. O problema não é só a placa.

## A distância entre as categorias

A pergunta que todo dev tem é se consumidor já chega lá. Comparação direta, na mesma régua:

| Categoria | Modelos | Nota |
| --- | --- | ---: |
| Frontier comercial | Claude Opus 5 / 5.5 | 100,0 |
| Frontier comercial | GPT-6 Luna | 95,5 |
| Frontier comercial | GLM 5.3 (hospedado) | 94,0 |
| Frontier comercial | GPT-6 Sol / Sonnet 5 | 91,0 |
| Frontier comercial | Kimi K3 | 85,0 |
| Open datacenter | DeepSeek V4.1 Flash (4x B300) | 92,5 |
| Open datacenter | GLM 5.3 Flash / Qwen3.8 Flash-Next (B300) | 92,5 |
| **Open consumidor** | **Qwen3.8 Flash-Next (5090 + Strata)** | **91,0** |
| Open consumidor | Qwen3.8-27B (Strix) | 80,0 |
| Open consumidor | Ornith-35B (5090) | 64,5 |
| Open consumidor | GLM-4.7-Flash (5090) | 24,0 |

A leitura é que o topo do consumidor está **9 pontos abaixo do topo comercial absoluto e 1,5 ponto abaixo do topo aberto em datacenter**, nessa métrica de vigilância. É uma distância pequena, e ela some quando você percebe que o GPT-6 Sol e o Sonnet 5 também estão a 91. O abismo real não é entre datacenter e consumidor: é entre o modelo certo e todos os outros. Entre o Flash-Next e a Ornith, na mesma 5090, são 26,5 pontos.

## Então, hardware de consumidor já serve pra trabalhar?

**Serve, com o modelo e o motor certos.** Uma RTX 5090 com Strata entrega Tier A em vigilância de código, a 159 tokens por segundo, sem pagar um centavo por token depois que o hardware existe. Pra quem faz revisão de código, testa agente de codificação e mantém dado privado em casa, isso muda o jogo.

Pela primeira vez neste benchmark eu tenho um modelo testado, em hardware de consumidor, que merece ir pro trabalho de todo dia. Já deixei o Flash-Next configurado no OpenCode apontando pra 5090. O próximo passo é usar em programação de verdade, fora da régua de sabotagem, e ver se a nota se sustenta.

O que não serve é achar que qualquer configuração serve. A Strix Halo é ótima pra ter 128 GB e montar modelo grande, mas a velocidade dela não paga interatividade; a Ornith roda rápido e revisa mal; o GLM-4.7-Flash completa protocolo e não detecta nada sem aviso. E tem o preço invisível: quantização agressiva pode cobrar nota, dependendo do modelo e da configuração, e tempo de espera cobra paciência.

Se eu fosse montar uma caixa pra um dev hoje, seria uma 5090 com Strata e o Flash-Next, e usaria a Strix pra tarefa de fundo que aceita ser lenta. A fronteira comercial continua ganhando de quem precisa do máximo. Mas o consumidor deixou de ser consolação: já tem Tier A na prateleira de casa.

### O problema agora é achar uma 5090

Em outubro, leakers garantiram que a NVIDIA ia parar de produzir a RTX 5090 e reservar os chips GB202 pras linhas profissionais e de datacenter. A placa chegou a sumir da loja oficial da NVIDIA nos Estados Unidos. No dia 16 de outubro, num evento em Taipei, o **Jeff Fisher**, vice-presidente sênior da NVIDIA, [negou a descontinuação](https://www.guru3d.com/story/nvidia-says-geforce-rtx-5090-production-is-continuing/) e disse que a empresa vai continuar entregando, mas admitiu que a capacidade de produção está apertada.

Na prática:

- o preço sugerido continua US$ 1.999, e a maioria dos anúncios na Newegg americana [passa de US$ 9.300, quase cinco vezes isso](https://www.techspot.com/news/114254-nvidia-rtx-5090-production-but-absence-company-us.html);
- no Brasil, cada unidade sai na casa dos [R$ 35 mil no varejo](https://www.baguete.com.br/noticias/carga-milionaria-de-gpus-some-de-guarulhos);
- e dois pallets de RTX 5090 da Zotac, importados pela distribuidora Oderço e avaliados em uns R$ 2,5 milhões, [sumiram no aeroporto de Guarulhos](https://www.terra.com.br/noticias/misterio-em-guarulhos-r-25-milhoes-em-placas-de-video-desaparecem,a7596d7874eddfb490f96345b4be1b09z4eix4rc.html). A GRU Airport comunicou as autoridades, e o caso segue em investigação, sem confirmação de roubo.

> O primeiro modelo local Tier A do v4 roda justamente na placa mais difícil de comprar do momento. A prateleira de casa já tem Tier A. Falta conseguir a prateleira.
