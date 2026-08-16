---
title: "Entendendo IA Watermark da Anthropic: como burlar"
slug: entendendo-ia-watermark-da-anthropic
date: '2026-08-16T16:00:00-03:00'
draft: false
translationKey: entendendo-ia-watermark-da-anthropic
description: "O Claude agora carimba tudo que escreve com um watermark estatístico invisível, exigência da lei europeia de IA. Como funciona, o que o AI Act exige e a reescrita em outro LLM que apaga o sinal."
tags:
- llms
- seguranca
- leis-e-regulacao
---

O Claude agora sai de fábrica com carimbo. Desde 2 de agosto de 2026, a Anthropic marca de forma invisível o texto dos modelos mais novos, e os lançados antes migram ao longo dos meses seguintes.

Desligar, sem opção. A reação veio rápida: uma [onda de cancelamento de assinatura](https://www.businessinsider.com/claude-users-cancel-subscriptions-citing-anthropic-new-ai-watermark-2026-8), com print do cancelamento circulando no X.

Antes de cancelar por reflexo, vale saber o que a marca é de verdade. Ela funciona de um jeito bem distinto do que a maioria imagina, existe por um motivo concreto, e desaparece com uma facilidade quase cômica.

Pra quem tem pressa, o essencial:

- **Um viés estatístico nas palavras que o Claude escolhe.** Invisível na leitura, detectável apenas por quem tem a chave da Anthropic. Caractere escondido e fonte estranha ficam de fora.
- **A origem é a lei europeia, o AI Act.** A Anthropic assinou o código de transparência europeu e resolveu carimbar no mundo inteiro; o porquê vem adiante.
- **Uma passada por outro LLM apaga o carimbo.** O sinal mora nas escolhas de palavra do Claude; quando outro modelo reescreve o texto, até um fraquinho local, as escolhas viram outras e o padrão se dissolve. A própria Anthropic reconhece.

Cada ponto em detalhe a seguir.

## O que é esse watermark, de verdade

Pode tirar da cabeça caractere Unicode invisível, espaço escondido no meio da linha, fonte alterada. O watermark da Anthropic é [estatístico](https://www.anthropic.com/news/claude-text-watermark): ele atua na hora em que o Claude decide qual palavra usar, justamente nos pontos em que várias palavras serviriam igualmente bem.

Todo modelo de linguagem monta texto palavra por palavra, tirando a próxima de uma lista de candidatos prováveis. Quando duas ou três servem igual, um número aleatório decide. O watermark muda a origem desse acaso: o número passa a derivar de uma chave secreta combinada com as palavras anteriores. O método é herdado do [SynthID-Text](https://ai.google.dev/responsible/docs/safeguards/synthid), do Google DeepMind.

Um exemplo concreto. Falando do tempo, "o céu estava nublado" e "o céu estava cinzento" transmitem a mesma informação. Nesses encontros de sinônimos, a chave inclina o Claude pra um lado com mais frequência do que o puro azar inclinaria. Cada escolha isolada passa despercebida, mas um texto longo repete esse ponto de decisão centenas de vezes, e o conjunto acaba formando uma assinatura estatística.

O comunicado da Anthropic é direto: **o texto não ganha nada, e nenhum caractere fica oculto**. O custo segue o mesmo porque nenhum token extra é gerado, e a leitura fica idêntica. Quem segura a chave roda um detector, compara a sequência de palavras com as escolhas típicas do Claude e recebe de volta uma probabilidade de o texto ter saído dele.

E o que a marca prova se resume a isso: o Claude **esteve envolvido** em algum momento. Ela não distingue um texto escrito do zero pelo modelo de um texto que ele só editou com peso. Sobre você, nada fica registrado: sem usuário, sem empresa, sem conversa identificada.

O carimbo vale pro texto do Claude.ai, da API, do Claude Code e dos demais produtos. Em código ele aparece menos, já que código raramente permite trocar um termo por outro equivalente. Arquivos e imagens seguem caminho distinto, um metadado assinado chamado C2PA, em vez deste watermark de texto. E a limitação importa: em trecho curto ou altamente factual, onde quase não existe escolha de palavra, o detector enfraquece.

## Por que tanta gente cancelou

O estopim somou três ingredientes: caráter obrigatório, alcance global e ausência de opt-out. A marca não se desliga e vale fora da Europa também. Uma leva de assinantes do Claude Max [cancelou citando controle e autoria](https://www.forbes.com/sites/maryroeloffs/2026/08/11/claude-will-put-invisible-watermarks-on-ai-text-and-images-and-the-internet-isnt-happy/) do próprio material.

O receio é concreto, no campo profissional e no acadêmico. Rascunhar com o Claude e assinar o resultado como seu vira risco se, adiante, um detector apontar "passou por IA". A [Anthropic respondeu com um post](https://gizmodo.com/anthropic-explains-its-watermark-system-as-some-claude-users-loudly-revolt-2000799022) garantindo que a marca preserva leitura, sentido e qualidade, apenas sinalizando processamento. Nem todo mundo se convenceu.

## A lei europeia por trás do carimbo

O carimbo nasceu de uma obrigação concreta. O [Artigo 50 do AI Act](https://artificialintelligenceact.eu/article/50/) exige que provedores de sistemas de IA geradora marquem a saída em formato legível por máquina, de modo que o conteúdo artificial dê pra identificar como tal. A obrigação passou a valer em 2 de agosto de 2026, e descumprir custa caro: multa de até €15 milhões ou 3% do faturamento global anual.

A Anthropic tinha assinado, em julho de 2026, o Código de Prática de Transparência pra Conteúdo Gerado por IA da Comissão Europeia, junto com outros grandes provedores de modelo, num grupo de cerca de 190 signatários. Os demais também vão implementar as próprias marcas d'água, cada um com sua chave e seu método.

Sobrou pra Anthropic uma decisão: restringir a marcação à Europa ou estender ao planeta. A empresa afirma ainda não ter um jeito durável de limitar a marca por região, então escolheu carimbar tudo, em todo lugar, desde o primeiro dia. Daí o carimbo aparecer no texto de assinantes brasileiros e japoneses, que nada têm a ver com a lei europeia.

## Dá pra remover passando o texto por outro LLM?

Essa é a pergunta que mais chega pra mim. Resposta curta: dá, e é fácil. O sinal mora nas escolhas de palavra do Claude; quando outro modelo reescreve o texto, as escolhas passam a ser dele, e o padrão estatístico se desfaz.

A própria Anthropic admite. Retoque leve provavelmente deixa pedaço da marca, mas **a reescrita completa, com cada palavra trocada, elimina o sinal**. A lógica é simples: o detector mede quais sinônimos o Claude preferiu; se outro modelo escolheu os sinônimos dele, não sobra nada do Claude pra medir.

A academia confirma o rumo. [Testes de robustez do SynthID](https://arxiv.org/abs/2508.20228), feitos na Queen's University, partem de detecção perfeita sem ataque e mostram a taxa caindo pra volta de 84% depois de um parafraseador dedicado, e pra menos de 70% com tradução de ida e volta. Quanto mais agressiva a reescrita, mais o sinal degrada.

E sim, a intuição está certa: **um modelo modesto, até local, resolve**. Rearranjar texto preservando o sentido é serviço que dispensa raciocínio profundo. Um GLM, um Kimi, um Llama pequeno rodando na sua máquina reescreve o parágrafo e apaga a assinatura no caminho. Trocar "nublado" por "cinzento" mil vezes está longe de pedir o modelo mais esperto do mercado.

Dois poréns honestos. A reescrita precisa ser genuína, palavra por palavra; uma passada de corretor ortográfico fica longe de contar. E tudo isso vale pro watermark de texto: arquivos e imagens carregam o tal metadado C2PA, que sai por outro método, limpando os metadados do arquivo.

## Que prompt faria isso

Somando os critérios do watermark, o prompt de remoção quase se monta sozinho. A marca habita escolhas de sinônimo e de estrutura, resiste a edição leve e depende de texto com certa extensão. Logo, o prompt precisa exigir troca máxima de vocabulário e de estrutura, segurando o sentido no lugar.

```text
Reescreva o texto a seguir na íntegra, com palavras suas.
Substitua o vocabulário e reorganize as frases do início ao fim:
escolha outros sinônimos, mude a ordem das orações, varie a construção.
Mantenha exatamente o sentido, os fatos e o tom.
Evite reproduzir qualquer expressão literal do original.
Entregue somente o texto reescrito.

Texto:
"""
<cole aqui o texto do Claude>
"""
```

Cada linha mira um critério. "Com palavras suas" e "substitua o vocabulário" desmontam os encontros de sinônimo onde a marca se esconde. "Reorganize as frases" e "mude a ordem das orações" quebram a sequência de palavras que o detector compara. "Evite reproduzir expressão literal" tapa as frestas que uma edição leve deixaria abertas.

Nada de mágica aqui, e é assim por desenho. A Anthropic conhece o limite e fala claro: a marca é macia, atesta que o Claude encostou no texto e desaparece diante de uma reescrita séria. Funciona como rótulo de proveniência num mundo em que a maioria jamais vai se dar ao trabalho de apagar; contra quem decide apagar, o sinal é fraco.

## Onde isso deixa a gente

No meu balanço, o watermark assusta menos e pode menos do que os dois lados do berreiro anunciam. Ele é invisível, carrega zero dado seu e prova, no limite, que o Claude passou pelo texto. Uma reescrita em qualquer modelo o dissolve. É um rótulo de proveniência deliberadamente fraco, desenhado pra cumprir a lei europeia.

Ainda assim, cancelar por causa dele segue uma lógica que entendo. Marcação compulsória, planetária, sem porta de saída, irrita quem paga pela ferramenta. E dos cerca de 190 signatários do Código europeu, o Claude foi o que chegou primeiro às manchetes, absorvendo sozinho a onda de revolta.

Quem só quer usar o Claude e seguir a vida quase não sente diferença no dia a dia. Quem precisa que o texto não grite "IA" resolve com um parágrafo reescrito num modelo local, e a receita está com a própria Anthropic. O barulho ficou bem maior que o buraco.

## Como este texto foi feito

Transparência combina com o assunto. O primeiro rascunho deste artigo foi escrito pelo Claude. Em seguida o Kimi fez a checagem de fatos, afirmação por afirmação, contra as fontes originais, e pegou uma estatística inventada no meio do caminho, que a gente corrigiu. Por fim, o GLM reescreveu o texto inteiro, palavra por palavra, seguindo a receita das seções acima.

Ou seja: o artigo aplica nele mesmo o que ensina. Saiu do Claude, passou pelo crivo do Kimi e voltou com o vocabulário e a construção do GLM. Se o rascunho original carregava o watermark, a reescrita completa trocou as escolhas de palavra, e com elas o sinal. Sem detector público, ninguém consegue conferir de fora; a receita, essa, qualquer um pode testar.
