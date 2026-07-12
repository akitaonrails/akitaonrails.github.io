---
title: "Notícias Quânticas: Majorana 2 e entendendo Shor"
slug: "noticias-quanticas-majorana-2-e-entendendo-shor"
date: '2026-07-12T12:00:00-03:00'
draft: false
translationKey: quantum-news-majorana-2-and-understanding-shor
description: "A Microsoft anunciou o Majorana 2 com qubits de 20 segundos e físicos respondendo que nada foi resolvido. Aproveito pra explicar direito o algoritmo de Shor, por que fatoração vira busca de período, e no que computador quântico é bom de verdade."
tags:
  - quantum
  - computacao-quantica
  - shor
  - microsoft
  - majorana
  - criptografia
  - rsa
---

Computação quântica voltou ao noticiário e, como sempre, com mais hype do que substância. Antes de entrar no assunto: se você nunca estudou o básico, eu já fiz um vídeo inteiro no canal explicando os fundamentos, o [Akitando #66 sobre supremacia quântica](/2019/11/06/akitando-66-entendendo-supremacia-quantica/), e falei mais um pouco neste podcast:

{{< youtube id="_Hl9wiLkns4" >}}

Este post tem duas partes. Primeiro, a notícia: o anúncio do Majorana 2 da Microsoft e por que os físicos da área continuam com um pé (os dois, na verdade) atrás. Depois, a parte educativa: uma explicação decente do algoritmo de Shor, porque muita gente repete "computador quântico quebra RSA" sem a menor ideia do mecanismo, e o mecanismo é bonito demais pra ficar de fora.

## Majorana 2: o anúncio

No dia 2 de junho de 2026, na conferência Build em San Francisco, a Microsoft revelou o **Majorana 2**, a segunda geração do seu chip quântico topológico. As manchetes: estabilidade de qubit 1.000 vezes melhor que a do Majorana 1 (anunciado uns 15 meses antes), e o cronograma pra um computador quântico escalável encurtado de 2033 pra 2029.

O número central do paper técnico: tempos de vida de paridade Z acima de **20 segundos** (mais precisamente 22 ± 1 segundos) num dispositivo de InAs com chumbo, contra 1 a 12 **milissegundos** nos dispositivos de alumínio do Majorana 1. Três ordens de magnitude de melhoria. A mudança de hardware principal foi trocar o supercondutor de alumínio por chumbo, cujo gap supercondutor é cerca de quatro vezes maior, o que dobrou o gap topológico reportado e derrubou drasticamente a taxa de erros de paridade.

Esses números de engenharia de materiais são reais e mensuráveis, e até os críticos reconhecem o avanço nessa frente. O problema está no que o paper NÃO mostra.

## O histórico que o anúncio prefere não lembrar

O programa quântico topológico da Microsoft carrega quase duas décadas de história, e uma parte dela é constrangedora. Em 2018, um time financiado pela Microsoft na TU Delft publicou na Nature evidências de condutância Majorana quantizada. Em 2021 o paper foi retratado, depois que os físicos Sergey Frolov e Vincent Mourik demonstraram que os dados tinham sido apresentados seletivamente. O comitê de integridade científica da TU Delft concluiu que os dados foram "desnecessariamente corrigidos". Um segundo paper do mesmo grupo foi retratado em 2022.

Quando o Majorana 1 foi anunciado em fevereiro de 2025 como "o primeiro qubit topológico do mundo", o paper na Nature que o acompanhava dizia menos do que o press release: os próprios revisores da Nature escreveram que as medições publicadas **não representavam evidência da presença de Majorana zero modes** nos dispositivos. Quando a Microsoft apresentou dados adicionais no encontro da APS em março de 2025, o Frolov (Universidade de Pittsburgh) chamou publicamente os dados de "só ruído", e o físico Henry Legg (St Andrews) levantou objeções parecidas, incluindo críticas ao próprio Topological Gap Protocol, o método que a Microsoft usa pra identificar a fase topológica.

E o Majorana 2 respondeu essas críticas? Em poucas horas os mesmos físicos responderam que não. O Legg, à Science News: "Nada nesse preprint resolve as questões fundamentais. Nada nos dados apresentados prova a existência de um qubit topológico ou de Majoranas nesses dispositivos." O Frolov, à Scientific American, foi mais ácido: "Quando a Microsoft é mencionada hoje em dia, físicos e especialistas em computação quântica só dão risada ou levantam a sobrancelha."

A [análise detalhada do Marin Ivezic no PostQuantum](https://postquantum.com/industry-news/microsoft-majorana-2-analysis/), que recomendo ler inteira, lista o que falta com precisão:

- **Sem medições X.** Um qubit funcional exige dois tipos complementares de medição: Z (paridade de um fio) e X (paridade conjunta dos dois fios do tetron). O paper do Majorana 2 só apresenta Z. E a medição X era exatamente o ponto de contenção do Majorana 1. Sem ela, o que foi demonstrado é um estado de paridade de vida longa num fio supercondutor. Um qubit, ainda não.
- **Sem demonstração de que os estados são topológicos.** As medições são consistentes com Majorana zero modes, mas também são potencialmente consistentes com estados de Andreev triviais que imitam as mesmas assinaturas. O próprio paper admite a ambiguidade.
- **Sem portas lógicas, sem entrelaçamento, sem algoritmos.** É um experimento de caracterização, sem computação nenhuma. O Chetan Nayak, que lidera o programa, diz ter dados não publicados de controle de qubits. Enquanto não publicar, é afirmação, sem evidência.
- **Sem peer review.** O paper saiu no site da Microsoft e no arXiv. Dado o histórico de retratações do programa, a ausência de revisão por pares no lançamento merece escrutínio extra.
- **Sem reprodutibilidade demonstrada.** Os 22 segundos vêm de um único fio de um único tetron de um único chip. Nada de ensemble de dispositivos idênticos ou chips fabricados independentemente.

Meu resumo da ópera: a engenharia de materiais avançou de verdade, e isso conta. Mas a pergunta que vale trilhões ("isso é um qubit topológico?") continua exatamente tão aberta quanto antes do anúncio. E encurtar o cronograma público de 2033 pra 2029 em cima de um resultado que não demonstra nem um qubit é decisão de marketing, com o rigor científico ficando pro futuro.

## Shor: por que fatorar números vira caçar período

Agora a parte divertida. Todo mundo repete que computador quântico quebra o RSA. O algoritmo responsável é o de **Peter Shor, de 1994**, e o truque central dele é uma das ideias mais elegantes da computação. Esse vídeo do Computerphile explica muito bem, e recomendo assistir antes de continuar:

{{< youtube id="k_kyepATqB8" >}}

A segurança do RSA depende de um fato simples: multiplicar dois primos gigantes é fácil, mas pegar o resultado N e descobrir quais eram os primos é brutalmente difícil. O melhor algoritmo clássico conhecido leva tempo sub-exponencial, o que na prática significa que com chaves grandes o Sol apaga antes de você terminar.

A sacada do Shor foi provar que fatorar N é redutível a outro problema: **encontrar o período de uma função**. Você escolhe um número `a` coprimo com N e olha pra função:

```
f(x) = a^x mod N
```

Essa função é periódica: existe um `r` tal que os valores se repetem a cada `r` passos. Encontrando esse período `r`, um pouco de teoria dos números clássica (que qualquer computador comum resolve em instantes) te entrega os fatores primos de N. O problema é que, classicamente, achar o período pra um N gigante é tão difícil quanto o problema original.

É aqui que entra o computador quântico, em quatro movimentos:

1. Prepara uma **superposição** de muitos valores de `x` ao mesmo tempo.
2. Avalia `f(x)` em superposição (o tal paralelismo quântico: uma avaliação sobre todos os `x` de uma vez).
3. O estado resultante agora **codifica a periodicidade** da função.
4. Aplica a **Transformada de Fourier Quântica (QFT)**, que usa interferência construtiva e destrutiva pra amplificar exatamente as componentes de frequência do período, e mede.

O detalhe que quase todo mundo erra: você não "lê todas as respostas de uma vez" (medição colapsa a superposição e te dá UM valor). A genialidade está em usar interferência pra fazer as respostas erradas se cancelarem e a informação global que você quer (o período) sobreviver na distribuição de probabilidade. A QFT transforma uma propriedade global da função, que nenhuma medição individual revela, numa feature local e mensurável. É por isso que fatoração cai de tempo sub-exponencial pra tempo polinomial num computador quântico. E é por isso que a criptografia pós-quântica existe como área.

## Então computador quântico é bom com "funções periódicas"?

Essa é a conclusão apressada que eu quero desfazer. Periodicidade e análise estilo Fourier são de fato um ponto forte, e não só no Shor: a estimação de fase quântica (QPE), os problemas de subgrupo escondido e boa parte das simulações de sistemas físicos vivem nesse território. Mas a formulação correta é outra: computador quântico brilha quando o problema tem **estrutura matemática explorável**, algo que dê pra mapear em superposição, entrelaçamento e interferência.

Tem vantagens quânticas que nada têm a ver com período. O algoritmo de **Grover** faz busca não estruturada com ganho quadrático (√N em vez de N). A **simulação de sistemas quânticos** (moléculas, materiais) é provavelmente a aplicação mais promissora de todas, porque ali o espaço de Hilbert do problema é naturalmente o espaço da máquina. Tem o **HHL** pra sistemas lineares, técnicas de otimização, alguns métodos de machine learning. O fio condutor é sempre o mesmo: existe estrutura (simetria, grupo, geometria) que a interferência quântica explora melhor que qualquer método clássico conhecido.

E a pergunta inversa: dá pra decompor qualquer algoritmo clássico em funções periódicas e ganhar speedup quântico? Não. Computador quântico consegue simular qualquer algoritmo clássico (na notação da área, BQP contém P), então tecnicamente tudo roda lá. Mas rodar não é acelerar: sem estrutura explorável, você paga todo o overhead quântico (correção de erro, coerência de qubits, temperaturas criogênicas) pra chegar no mesmo resultado, provavelmente mais devagar.

Ordenação, aritmética, a maioria dos problemas de grafos, o grosso do que um computador faz no dia-a-dia: nada disso tem speedup quântico superpolinomial conhecido. Pra essas tarefas, o computador clássico é mais rápido, mais barato e mais confiável, e vai continuar sendo.

> Computador quântico é acelerador de problemas com estrutura específica. Uma máquina universal melhor, ele não é.

## Conclusão: guarde o hype no armário

Junta as duas metades do post e o quadro fica claro. De um lado, o algoritmo de Shor é real, é lindo, e é a razão de existir toda a corrida da criptografia pós-quântica. Do outro, o hardware necessário pra rodar Shor contra uma chave RSA de verdade exige milhões de qubits físicos com correção de erros, e o estado da arte anunciado com fanfarra em 2026 é... um estado de paridade de 22 segundos num único fio, que os especialistas nem concordam que seja um qubit.

Na prática, no curto prazo, computação quântica segue sendo uma solução muito nichada, muito limitada e muito impraticável. As aplicações reais que surgirem primeiro vão ser em simulação de química e materiais, dentro de laboratórios e datacenters de pesquisa, não na sua vida. Não espere usar um computador quântico você mesmo tão cedo. Acompanhe as notícias como eu acompanho: com curiosidade genuína pela física, e com a sobrancelha levantada pros press releases.
