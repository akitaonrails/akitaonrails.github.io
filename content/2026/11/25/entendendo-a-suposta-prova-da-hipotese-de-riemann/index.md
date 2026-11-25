---
title: "Entendendo a suposta prova da hipótese de Riemann"
date: '2026-11-25T09:00:00-03:00'
slug: entendendo-a-suposta-prova-da-hipotese-de-riemann
translationKey: entendendo-a-suposta-prova-da-hipotese-de-riemann
description: "Levent Alpöge (Anthropic) anunciou uma prova da Hipótese de Riemann em 17 milhões de linhas de Lean feitas com Claude, fez piada com 250 mil páginas e gerou acusação de fraude por causa de anyGeometry := True. Explico o que é verdade nisso tudo."
tags:
- inteligencia-artificial
- ciencia-da-computacao
- llms
draft: false
---

Na última sexta-feira, 20 de novembro, o matemático **Levent Alpöge** (pesquisador da equipe técnica da Anthropic) soltou uma bomba: publicou uma nota curta em [alpo.ge/remark.pdf](https://alpo.ge/remark.pdf) afirmando que, trabalhando em conjunto com uma versão interna do **Claude**, conseguiu provar a **Hipótese de Riemann** e a **Hipótese de Riemann Generalizada** para funções L de Dirichlet.

O detalhe que incendiou a internet imediatamente é que ele não enviou um artigo tradicional para uma revista de matemática. Ele jogou no ar um arquivo de código em **Lean 4** com **17,4 milhões de linhas** espalhadas por **175.187 arquivos**, acompanhado de uma nota de rodapé mencionando que havia gerado um rascunho em texto com o Claude que passou de **250 mil páginas**.

Na segunda-feira (23), depois que a história das "250 mil páginas" viralizou na imprensa e irritou matemáticos do mundo inteiro, Alpöge foi ao X numa [thread chamada *"Stupid things I did"*](https://x.com/__alpoge__/status/2124987173439209561) e disse na cara dura: *"250,000+ pages was a joke guys!, I find big number extremely hilarious"*. Ele explicou que estava fazendo *lengthmaxxing* só pela graça do absurdo, incluindo pedantismos cômicos como o Teorema 1 demonstrando que os números reais são totalmente ordenados, admitiu que o próprio código Lean estava cheio de bagunça (*"yoloing a lot in there"*), e depois [rebateu no X](https://x.com/__alpoge__/status/2125062170207457583) quem entendeu errado insistindo que a prova formal em si valia.

No meio dessa confusão, hoje mesmo (25 de novembro) a pesquisadora **J. L. Nielsen** publicou no PhilPapers o artigo [The Invalidity of Alpöge's Proof of the Riemann Hypothesis](https://philpapers.org/archive/NIEIOT-2.pdf), acusando a prova de ser uma tautologia fraudulenta baseada em predicados que sempre retornam `True`. Vamos separar o circo da técnica e entender o que realmente está acontecendo aqui.

## Em termos simples: o que é a Hipótese de Riemann e o que muda na prática?

Proposta por Bernhard Riemann em 1859, a **Hipótese de Riemann** é o mais famoso dos sete Problemas do Milênio do Instituto Clay (que pagam um milhão de dólares por solução). Ela trata do padrão escondido por trás dos **números primos** (2, 3, 5, 7, 11, 13...).

Olhando de perto, os números primos parecem surgir de forma caótica. Olhando de longe, a densidade com que eles aparecem segue uma lei assintótica bem precisa. Para quem quiser ver isso desenhado com calma, recomendo fortemente o [vídeo clássico do canal 3Blue1Brown sobre a Hipótese de Riemann](https://www.youtube.com/watch?v=sD0NjbwqlYw).

Riemann descobriu que o "erro" entre a estimativa suave e a contagem real de primos é controlado por uma função matemática chamada **função zeta de Riemann** (escrita com a letra grega zeta: `ζ(s)`). Em vez de receber apenas números comuns da reta (como 1, 2 ou 3), essa função recebe **números complexos** (`s`), que funcionam como coordenadas em um mapa 2D: o eixo horizontal é a "parte real" (os números normais que você conhece, `-1, 0, 1, 2...`) e o eixo vertical é a "parte imaginária" (`1i, 2i, 3i...`).

[![Visualização da linha crítica da Hipótese de Riemann no plano complexo, no vídeo do 3Blue1Brown](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/11/25/riemann-hypothesis/3blue1brown-critical-line.png)](https://www.youtube.com/watch?v=sD0NjbwqlYw)

Olhe a imagem acima, tirada do [vídeo do 3Blue1Brown](https://www.youtube.com/watch?v=sD0NjbwqlYw). A hipótese afirma que todos os pontos interessantes onde essa função zera (os chamados "zeros não triviais", representados pelas bolinhas amarelas) caem perfeitamente alinhados em cima daquela **linha vertical amarela** que cruza o eixo horizontal exatamente na metade entre 0 e 1 (ou seja, coordenada X igual a `0,5`, ou `1/2`, a famosa **linha crítica**). Até hoje, computadores já verificaram trilhões desses pontos e todos caíram nessa linha, mas em matemática testar trilhões de casos ainda não prova que o próximo trilhão também vai obedecer.

> **E o que muda na sua vida prática se a Hipótese de Riemann estiver provada de vez? Quase nada no curto prazo.**

Primeiro, vamos matar o mito mais repetido na internet: **provar a Hipótese de Riemann não quebra a criptografia RSA nem o Bitcoin**. O RSA depende da dificuldade de fatorar o produto de dois primos gigantes (`n = p × q`). Saber com precisão máxima quantos primos existem até um limite `X` não entrega nenhum atalho para descobrir quais dois primos multiplicados geram um número específico `n`. (A ameaça real ao RSA continua sendo computação quântica com o algoritmo de Shor.)

Na prática, uma prova válida transforma milhares de teoremas de teoria dos números e alguns testes determinísticos de primalidade (como o teste de Miller), que hoje dependem da suposição "assumindo a Hipótese de Riemann (ou sua versão generalizada, a GRH)", em resultados incondicionais. Assim como aconteceu com o anúncio recente da OpenAI sobre [Navier-Stokes](https://en.wikipedia.org/wiki/Navier%E2%80%93Stokes_existence_and_smoothness) em setembro (um problema cuja resposta teórica importa muito para matemáticos, enquanto engenheiros já simulam aviões e clima todo dia com aproximações numéricas), provar Riemann é um marco histórico da matemática pura e um grande *"nice to have"* teórico para a engenharia do dia a dia.

## O que é Lean e por que "compilar" não basta sozinho

Para entender a briga entre Alpöge e seus críticos, vale explicar rapidamente o que é o **Lean 4**. Ele é ao mesmo tempo uma linguagem de programação funcional e um assistente de provas formais, criado originalmente por Leonardo de Moura na Microsoft Research e mantido hoje pela Lean FRO.

No Lean, teoremas matemáticos são escritos como **tipos**, e demonstrações são escritas como **programas** que constroem um valor daquele tipo. Quando o código compila no kernel do Lean sem atalhos (`sorry`) e sem axiomas inventados, o compilador garante que os passos lógicos deduzem a conclusão a partir das definições declaradas.

Só que existe uma pegadinha gigantesca que muita gente fora da área ignora: **o kernel do Lean verifica a lógica interna do código, mas ele não faz a menor ideia se a definição que você escreveu corresponde à matemática real**. Um arquivo Lean pode compilar perfeitamente, passar com zero erros e zero axiomas extras, e ainda assim ser matematicamente furado se a definição ou as hipóteses do enunciado tiverem uma falha.

Olhe um exemplo mínimo em Lean 4 puro que compila de primeira e "prova" uma bobagem matemática:

```lean
-- Definimos "todo número primo é par" com uma hipótese impossível escondida:
def TodoPrimoEhPar : Prop :=
  ∀ n : Nat, (n > 2 ∧ n < 2) → n % 2 = 0

theorem provei_que_todo_primo_eh_par : TodoPrimoEhPar := by
  intro n h
  omega

#print axioms provei_que_todo_primo_eh_par
-- Saída: não depende de nenhum axioma e compila sem nenhum 'sorry'
```

Esse código compila limpo, roda no verificador sem um único `sorry` e sem usar nenhum axioma extra. Ainda assim, a afirmação de que "todo primo é par" é obviamente falsa; o truque está na definição `TodoPrimoEhPar`, onde a condição `n > 2 ∧ n < 2` nunca pode ser verdadeira (e na lógica clássica, de uma premissa falsa você deduz qualquer coisa).

É por isso que "compilou em Lean" sozinho nunca prova nada. Além de compilar, você precisa auditar as **definições e asserções** do enunciado principal para ter certeza de que o programa está provando a Hipótese de Riemann de verdade, sem nenhum truque escondido no enunciado.

## O que a comunidade do Lean realmente verificou

Quem acompanha o blog lembra do artigo recente sobre [por que não fazemos provas formais definitivas em tudo](/2026/10/24/por-que-nao-fazemos-provas-formais-definitivas-de-codigo-sem-bug/), onde expliquei como funciona um kernel de checagem formal. No caso do Lean 4, a vantagem de soltar o código em vez de um PDF é que qualquer pessoa com máquina forte o suficiente pode rodar o compilador e auditar se as regras lógicas foram seguidas.

E o pessoal do Lean e do MIT fez isso em tempo recorde. Eu mesmo não compilei os 175 mil arquivos aqui na minha máquina local porque o export cru da prova tem **61,6 GB** e exige quase **100 GiB de RAM** e **48 a 72 horas** em uma única thread nos kernels padrão e paranoico do Lean. Felizmente, **Andrew Sutherland (MIT)** documentou cada passo da replicação em [math.mit.edu/~drew/grh/](https://math.mit.edu/~drew/grh/), e a **Lean FRO** junto com a **Mathlib Initiative** publicaram uma [nota conjunta](https://leanprover-community.github.io/blog/posts/riemann-hypothesis/) confirmando quatro fatos objetivos:

* Todos os **175.187 módulos** compilam sem erro no Lean v4.33.1 / Mathlib v4.33.1, e um `lake build` independente em sandbox sem rede reproduziu exatamente os mesmos 61,57 GB de export byte a byte.
* O comando `#print axioms` nos teoremas principais mostra **apenas os três axiomas padrão** do Lean (`propext`, `Classical.choice` e `Quot.sound`), sem nenhum `sorry` escondido e sem nenhum axioma inventado.
* Duas ferramentas independentes de comparação (`comparator` e `con-leche --compare` / `con-ron --compare`) confirmaram que o teorema provado em `Main.lean` tem exatamente o mesmo enunciado da definição oficial de `RiemannHypothesis` na Mathlib.
* O export inerte foi aceito sem rejeições pelo kernel padrão do Lean, pelo kernel paranoico do Lean e por verificadores independentes (incluindo implementações em Rust), como `nanoda` (em Rust, cerca de 28 minutos em 80 threads), `con-leche` (em Lean, 3 minutos em 64 threads) e `con-ron` (em Rust, 7 minutos em 64 threads), sendo que `con-leche` e `con-ron` possuem prova formal relativa à teoria dos conjuntos de que não aceitam deduções falsas.

> Do ponto de vista mecânico, o kernel do Lean e múltiplos verificadores independentes confirmaram que existe um termo fechado do tipo `RiemannHypothesis` usando apenas axiomas padrão.

## A acusação de fraude: `anyGeometry := True` e o paper de Nielsen

Se os verificadores independentes aprovaram tudo, por que o paper [NIEIOT-2.pdf](https://philpapers.org/archive/NIEIOT-2.pdf) de J. L. Nielsen está chamando a prova inteira de fraude e tautologia?

Porque Nielsen vasculhou os 175 mil arquivos do código gerado pelo Claude e encontrou, de fato, pedaços bizarros no meio do caminho do teorema principal (`everyCharacter`):

* Um predicado geométrico definido literalmente como `def anyGeometry : GeoP := fun _ _ _ => True`, que ignora todos os argumentos e sempre retorna `True` (o equivalente em Lean a um `assert true`), aparecendo 118 vezes em 24 arquivos e sendo satisfeito com `GeoCl.base trivial`.
* Objetos geométricos degenerados cujos próprios nomes no código são `geoDegenerate`, `algDegenerate`, `padDegenerate` e `mdlJunk`, com volumes zerados, superfícies vazias (`Empty`) e o mapa de reticulado enviando tudo para zero.
* Uma função `setDiv` que sobrescreve o campo de altura do divisor (`div.h`) diretamente com a fórmula analítica `hExpl6`, fazendo a igualdade `div.h u = hExpl6` fechar por reflexividade (`rfl`).

A partir daí, Nielsen conclui que a prova é circular: o programa finge checar geometria com um `True` falso, cola a resposta analítica no campo geométrico, compara a cópia com o original usando `rfl` e declara a Hipótese de Riemann provada.

### Quem tem razão nessa briga?

É aqui que entender teoria de tipos e compiladores salva você de cair em conversa mole dos dois lados.

**Nielsen acertou no diagnóstico da sujeira do código.** Aqueles nomes (`anyGeometry := fun _ _ _ => True`, `geoDegenerate`, `mdlJunk`, `setDiv`) estão lá no repositório de verdade. O código gerado por Alpöge e Claude é uma montanha caótica de andaimes abandonados e código morto que o modelo foi empilhando durante meses de tentativa e erro.

**Mas Nielsen errou feio na conclusão lógica de que isso torna a prova do Lean inválida.** Em Lean 4 (que implementa a correspondência de Curry-Howard), uma prova é um programa cujo tipo de retorno é o teorema. Se um teorema tem a assinatura `theorem riemannHypothesis : RiemannHypothesis` (sem receber nenhuma hipótese de entrada, sem `sorry` e sem axiomas extras), é **logicamente impossível** fabricar um valor do tipo `RiemannHypothesis` a partir de `fun _ _ _ => True` ou de um `rfl` de uma struct interna, a menos que o próprio kernel do Lean (e mais três verificadores independentes) tenham um bug catastrófico de solidez que permitiria provar `False`.

A prova definitiva desse erro está no próprio **Apêndice A** do paper de Nielsen (página 17). Quando ela tenta escrever um script mínimo em Lean 4 para "reproduzir o mesmo truque tautológico sem `sorry`", olhe a assinatura que o compilador do Lean a obrigou a escrever:

```lean
theorem claimed_rh (hRH : RiemannHypothesis) :
  (∃ b : Bundle, anyGeometry 0 ∧ b.model.height = targetFormula) ∧ RiemannHypothesis := by
  let b := buildBundle
  exact ⟨⟨b, valid_bundle_of_manufactured b⟩, hRH⟩
```

Repare no parâmetro **`(hRH : RiemannHypothesis)`** na primeira linha. Para o exemplo "tautológico" dela compilar, ela precisou **passar a própria Hipótese de Riemann como premissa de entrada** e apenas devolvê-la na saída. O `Main.lean` do Alpöge **não tem nenhuma premissa de entrada**: ele prova `RiemannHypothesis` do zero.

O que a existência de `anyGeometry := fun _ _ _ => True` realmente revela é o oposto de uma fraude de kernel: revela **gordura morta**. Se o compilador aceita substituir o predicado geométrico por `True` e ainda assim consegue derivar `RiemannHypothesis` sem axiomas extras, isso significa que **a demonstração real não precisava daquela camada geométrica**. Todo o trabalho pesado que de fato impede zeros fora da linha crítica aconteceu nas desigualdades analíticas e estimativas de matrizes (`DivInputsR`, `WordFacts`, `LinkGLOBAL`), e o Claude apenas deixou a casca geométrica degenerada pendurada na arquitetura.

## O problema real: código compilado ainda precisa ser compreendido

Mesmo com o argumento da fraude de Nielsen desmoronando diante do kernel, vale separar duas perguntas diferentes: **a prova em Lean já estabelece que a Hipótese de Riemann é verdadeira além de dúvida razoável?**

No plano puramente mecânico, quase certamente sim. Para o teorema provado estar errado, uma de apenas duas coisas extraordinárias precisaria ser verdade: ou existiria um bug sutil na própria definição de `RiemannHypothesis` (ou em suas dependências, como `riemannZeta` e continuação analítica) dentro da Mathlib, ou haveria uma falha de solidez compartilhada simultaneamente pelo kernel padrão do Lean, pelo kernel paranoico, pelo `nanoda`, pelo `con-leche`, pelo `con-ron` e pelo `lean4lean`. A chance de qualquer um desses dois cenários acontecer é minúscula, embora nunca literalmente zero, porque a cadeia de definições da Mathlib também é código escrito por humanos.

No plano científico e matemático, porém, o trabalho está longe de encerrado. O próprio Alpöge admitiu em `remark.pdf` que está entregando ao mundo um argumento completo antes mesmo de dominar a vizinhança inteira da matemática que o Claude construiu. E o comportamento dele nas redes sociais, fazendo piada com "250 mil páginas" e jogando 17,4 milhões de linhas cheias de `mdlJunk` no colo da comunidade, só piorou a recepção.

Além disso, as regras do Prêmio do Milênio do Instituto Clay exigem publicação em periódico revisado por pares e dois anos de aceitação pela comunidade matemática mundial; um arquivo `.tar.gz` de 61 GB ainda está longe de cumprir esse rito. É por isso que pesquisadores como **Manvir Jaswal** já correram para publicar guias de leitura ([The Riemann hypothesis for Dirichlet L-functions [after Levent Alpöge]](https://hexagonmath.org/pdf/2611.00799v1)) e nomes como **Kevin Buzzard** e **Terence Tao** destacam que o trabalho duro agora é fazer engenharia reversa dessa caixa-preta, podar os milhões de linhas de lixo e extrair uma demonstração enxuta que seres humanos consigam ler, entender e usar para avançar a área.

## Ciência não funciona por concurso de popularidade

O que mais me incomodou acompanhando essa novela nos últimos cinco dias foi ver quanta gente está tratando tudo isso como torcida de futebol. De um lado, pessoas dizendo *"o meu matemático favorito disse que passou no Lean, então acabou a discussão, está provado"*. Do outro, pessoas compartilhando o PDF de Nielsen sem ler o Apêndice A e gritando *"eu sabia que era golpe da Anthropic"*.

Ciência e matemática não funcionam por apelo à autoridade e muito menos por voto da maioria. Ter o selo do MIT, da Lean FRO ou de um ganhador da Medalha Fields ajuda a saber onde vale a pena olhar primeiro, mas autoridade nenhuma substitui clareza e reprodutibilidade.

> Ou a explicação é perfeitamente clara, transparente e reprodutível para qualquer pessoa qualificada conferir passo a passo, ou o trabalho científico ainda não terminou.

Hoje temos um artefato computacional impressionante que passou nos verificadores formais mais rigorosos que existem, misturado com milhões de linhas de código espaguete gerado por IA e um espetáculo desnecessário de relações públicas. Até que a comunidade consiga limpar essa gordura, traduzir a ideia central em matemática legível e confirmar cada passo à luz do dia, a única postura adulta é acompanhar com curiosidade técnica e ceticismo saudável, longe de torcida.
