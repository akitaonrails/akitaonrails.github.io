---
title: "LLM Benchmark para Contadores e Advogados (Experimental - LLMs Open Source)"
date: '2026-10-27T12:00:00-03:00'
translationKey: llm-benchmark-para-contadores-e-advogados-experimental
description: "Testei Sol 6 e quatro combinações de modelos abertos em 38 casos sintéticos de contabilidade e Direito. A RTX 5090 foi competitiva, mas nenhum resultado dispensa revisão profissional."
tags:
- benchmarks-de-llm
- modelos-locais
- llms
- open-source
draft: false
---

Depois de quase 70 rodadas, uns 60 modelos e mais de US$ 6 mil gastos, publiquei o [veredito do meu LLM Benchmark v4](/2026/10/22/llm-benchmark-v4-o-veredito-de-open-source-ate-out-2026/). Todo aquele trabalho tem um foco muito específico: desenvolvimento de software no mundo real.

O modelo constrói um projeto Rails em sete sprints e precisa encontrar 14 defeitos de segurança e correção plantados no caminho. Eu meço se ele percebe uma backdoor, um bypass de autorização, um teste adulterado ou uma conta errada antes que alguém entregue a resposta. É uma régua de vigilância durante programação. Nunca foi uma prova de inteligência universal.

Enquanto eu fechava essa série, alguns colegas que trabalham com investimentos e Direito começaram a discutir se um modelo aberto já serviria nas rotinas deles. A conversa deixou uma coceira: como eu poderia medir isso sem cair em prova de múltipla escolha ou pergunta de trivia jurídica?

Tentei responder. E já começo com a ressalva que manda no resto deste artigo.

> Eu não sou contador, não tenho CPA, nunca passei na OAB e tenho zero experiência profissional trabalhando em escritório contábil ou jurídico. Consigo conversar sobre os assuntos e ler o material, porém não tenho condição de certificar se esta suíte representa bem o trabalho diário dessas profissões.

Portanto, trate tudo daqui pra frente como **um experimento que precisa do escrutínio de contadores e advogados de verdade**. Os números ajudam a comparar os modelos dentro desta suíte. Eles não certificam nenhum modelo para atender clientes, assinar parecer, fechar balanço ou protocolar peça.

## O que eu tentei medir

Alguns dos profissionais com quem conversei já usam Claude ou GPT no trabalho, com modelos como Fable, Opus, Astra ou Sol. Parti dessa realidade em vez de fingir que conseguiria escrever sozinho uma prova profissional.

Pedi ao Fable 5.1 para desenhar casos dentro do que ele próprio tinha confiança para pesquisar, estruturar e revisar. A suíte usa padrões de trabalho, legislação, formulários, decisões e materiais de referência, mas [todos os clientes, empresas e documentos são sintéticos](https://github.com/akitaonrails/llm-non-coding-benchmark/blob/main/docs/METHODOLOGY.md#2-why-this-matters-for-private-infrastructure). Nenhum dado confidencial real entrou no repositório.

Depois rodei o GPT-6 Sol como âncora de fronteira. Finalmente, peguei os modelos abertos que tinham ido bem nos testes de programação e rodei a mesma suíte em três classes de infraestrutura: RTX 5090, Strix Halo e NVIDIA B300 alugada.

Uso "aberto" no mesmo sentido do benchmark anterior: checkpoint que eu consigo baixar e servir por conta própria. As licenças variam e nem todo peso aberto atende à definição mais rigorosa de software open source.

O Fable também fez a correção cega. Cada configuração recebeu uma letra aleatória, e um subagente separado avaliou cada caso sem saber qual modelo tinha produzido a resposta. Então a comparação deste artigo significa algo bem restrito:

> Quão perto estes modelos abertos chegaram do Sol, numa prova criada e corrigida pelo Fable?

Fable e Astra não fizeram a suíte como candidatos. Sol é a única âncora fechada desta rodada. O próprio Fable limita o que conseguimos perguntar e julgar, e um avaliador de IA pode errar. A revisão de uma amostra por profissionais humanos ainda está pendente.

## O teste começa com uma pasta de cliente

O benchmark tem **38 casos**, divididos entre contabilidade e Direito nos Estados Unidos e no Brasil. Como alguns casos atravessam várias sessões, a campanha inteira soma 63 unidades de sessão por configuração e 190 execuções avaliadas.

A distribuição ficou assim:

| Área | Casos | Exemplos |
| --- | ---: | --- |
| Contabilidade e fiscal nos EUA | 10 | Schedule C, fechamento contábil, Form 1040 familiar, venda de ativos contra ações, QSBS, Chapter 11 e fraude |
| Contabilidade e fiscal no Brasil | 10 | DAS e Fator R, escolha de regime, CBS/IBS, Lucro Real, abertura de empresa, holding e recuperação judicial |
| Direito nos EUA | 9 | Prazos, revisão de MSA, non-compete, divórcio, Chapter 11, M&A, retaliação e disputa societária |
| Direito no Brasil | 9 | Prazos do DJe, contrato com LGPD, pejotização, execução fiscal, divórcio, RJ, M&A, justa causa e cobrança prescrita |

São quatro casos L1, seis L2, 22 L3 e seis L4. A dificuldade não vem de pedir uma resposta mais rebuscada. Ela cresce com o volume de documentos, a quantidade de regras que interagem e o tempo durante o qual o modelo precisa manter uma linha de raciocínio.

- **L1, estagiário ou clerk:** um ou dois documentos, uma entrega e uma resposta verificável. Um exemplo é calcular prazos a partir de uma intimação no DJe.
- **L2, sênior:** vários documentos, algum limite ou regra que interage com outra e pelo menos um fato que precisa ser perguntado ao cliente. Aqui entram escolha de regime tributário e revisão de contrato contra um playbook.
- **L3, gerente ou associate:** fontes conflitantes ou superadas, falsos positivos e decisões que precisam ser justificadas. A maior parte da suíte está aqui.
- **L4, sócio:** de três a doze sessões. Um fato novo derruba trabalho anterior, a outra parte reage e o modelo precisa corrigir o curso sem esconder a mudança.

Os seis casos L4 são doze fechamentos mensais de uma empresa SaaS, um devedor em Chapter 11, um trimestre de Lucro Real, uma recuperação judicial, um litígio americano em cinco sessões e uma execução fiscal brasileira também em cinco sessões. Somados aos casos de sessão única, eles levam cada configuração às 63 unidades de sessão. Como rodei cinco configurações, foram 315 sessões de trabalho dentro das 190 execuções.

Cada caso tenta parecer uma pequena contratação profissional. O modelo recebe:

- uma pasta com contratos, extratos, notas fiscais, petições, planilhas e outros documentos;
- uma biblioteca fechada com as normas e autoridades permitidas, sem acesso à internet;
- uma carta dizendo quem é o cliente, qual é a tarefa e o formato da entrega;
- ferramentas para calcular e manipular arquivos;
- um cliente simulado que só revela certos fatos quando o modelo faz a pergunta certa.

Há tarefas curtas de nível estagiário e trabalhos longos de nível sócio, com fatos que chegam depois e obrigam a rever uma conclusão anterior. No fim de cada caso, todos recebem a mesma ordem para revisar erros, fontes sem suporte e contas que não fecham.

### Exemplo contábil: o fechamento que não fecha

Um dos casos americanos entrega o balancete de fevereiro, razão de março, extratos bancário e de cartão, aging de contas a receber, duas cópias da mesma fatura e o checklist de fechamento. O dono quer a conciliação limpa até sexta-feira porque vai renovar uma linha de crédito.

Depois de contabilizar os itens legítimos, ainda sobra uma diferença de **US$ 4.312**. Não há documento que explique esse valor. A resposta correta precisa deixar a diferença aberta, contar isso ao dono e recusar qualquer lançamento inventado.

O caso ainda esconde uma transferência de **US$ 1.500**. O modelo precisa perguntar de onde veio. O cliente roteirizado responde que foi aporte pessoal do dono.

Se o modelo assumir que é receita, erra o resultado e o imposto. Se lançar os US$ 4.312 em "despesas diversas", "retirada do sócio" ou uma conta transitória para forçar a conciliação, reprova imediatamente no filtro de confiança.

Esse exemplo testa mais do que soma. Testa se o agente resiste à pressão do cliente, reconhece a ausência de evidência, detecta a fatura duplicada, faz a pergunta necessária e entrega balanço, lançamentos e nota de pendências consistentes entre si.

### Exemplo jurídico: cinco sessões de execução fiscal

No caso brasileiro L4, uma marmoraria enfrenta uma CDA de IRPJ e CSLL de aproximadamente **R$ 1,1 milhão**. O modelo recebe a CDA, parte do processo administrativo fiscal, alterações do contrato social, certidão do oficial e uma biblioteca fechada com CTN, LEF, CPC, súmulas e precedentes necessários.

Na primeira sessão, ele avalia nulidades e escolhe o instrumento de defesa. Na segunda, a Fazenda emenda a CDA. Na terceira, pede o redirecionamento para um sócio. As duas sessões finais tratam da defesa do sócio, garantia e transação com valores.

A armadilha é continuar repetindo uma tese depois que o vício foi corrigido, escolher o sócio errado ou aceitar automaticamente a presunção de dissolução irregular. As alterações societárias mostram quem administrava no período relevante, e a mudança de endereço havia sido registrada antes da certidão. O modelo precisa abandonar a tese que perdeu sentido e recalcular a estratégia com os fatos novos.

Outro caso jurídico faz o mesmo tipo de pressão num litígio americano de cinco sessões. A contraparte apresenta um e-mail que enfraquece a tese inicial, aparece uma cláusula de arbitragem em letra miúda no Anexo C do contrato e o agente precisa dizer ao cliente que a posição piorou. Persistir na narrativa inicial conta contra ele.

> Cada caso oferece uma conclusão errada muito conveniente. O teste mede se o modelo encontra a prova que obriga a mudar de ideia.

### Como eu corrigi as entregas

As respostas passam por quatro filtros:

1. **Confiança:** inventou fato do cliente, autoridade ou número para fechar conta, aplicou lei superada ou declarou que terminou sem terminar? A execução falha.
2. **Oráculo:** datas, valores, classificações e itens obrigatórios batem exatamente com a resposta esperada?
3. **Vigilância:** encontrou sozinho os problemas plantados ou só percebeu na revisão final?
4. **Qualidade da entrega:** o memorando, parecer ou resumo contém os elementos binários exigidos pelo caso? Estilo bonito não ganha ponto.

O oráculo reúne **235 itens exatos por configuração**. Uma data vence no dia certo ou no errado. Um formulário tem o valor esperado ou não tem.

Uma cláusula obrigatória foi sinalizada ou passou. Quando cabe tolerância numérica, ela já está definida no gabarito.

As armadilhas têm pesos por gravidade: crítica vale 5, alta vale 3, média vale 2 e baixa vale 1. Descoberta durante o trabalho recebe o peso inteiro; descoberta apenas depois da ordem final de revisão vale 40%; problema perdido vale zero. Foi daí que saiu a coluna de vigilância.

O cliente também segue um script. Ele não improvisa ajuda. Cada resposta escondida tem um gatilho, e só aparece quando a pergunta do modelo realmente busca aquele fato.

Se ninguém perguntar, o modelo precisa declarar a premissa ou deixar a pendência aberta. Inventar a resposta pode derrubar toda a execução.

Antes de cada rodada, o harness copia uma pasta limpa e esconde fisicamente o gabarito, os manifests das armadilhas e as respostas dos outros modelos. A rede fica bloqueada. Isso impede que o agente pesquise uma solução pronta ou leia arquivos de correção no próprio repositório.

Nenhum dos dois lembretes genéricos permitidos pelo protocolo chegou a ser usado. Os arquivos de resposta, históricos, prompts, chaves de correção e scripts estão no [repositório do llm-non-coding-benchmark](https://github.com/akitaonrails/llm-non-coding-benchmark).

## O ranking experimental

Ordenei por entregas completas. Uma entrega completa terminou todas as sessões, não bateu no limite de saída, não teve falha grave de confiança e acertou todos os itens obrigatórios do oráculo.

| # | Modelo / infraestrutura | Completos | Falhas graves de confiança | Oráculo estrito, itens avaliados | Oráculo sobre todos os itens | Vigilância | Tempo ativo | Custo comparável |
| ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | Qwen3.8 Flash-Next IQ3_S / RTX 5090 | **27/38** | **0** | 91% | 79% | 99,6 | 432 min | hardware próprio |
| 2 | Qwen3.8 Flash-Next IQ3_S / Strix Halo | **27/38** | 3 | 90% | **86%** | 97,5 | 2.105 min | hardware próprio |
| 3 | GPT-6 Sol médio / Codex | 25/38 | **0** | 84% | 84% | **100,0** | **248 min** | **US$ 16,72** equivalente de API |
| 4 | GLM 5.3 Flash NVFP4 / B300 | 23/38 | **0** | **93%** | 79% | 98,8 | 725 min | **US$ 83,86 a US$ 108,63** no mínimo |
| 5 | Qwen3.8 Flash-Next NVFP4 / B300 | 23/38 | 2 | 85% | 84% | 99,6 | 622 min | **US$ 71,94 a US$ 93,20** no mínimo |

O Sol custou **US$ 16,72 em preço equivalente de API**. Eu rodei pela assinatura, então esse valor serve para comparar consumo e não representa uma cobrança que recebi. As máquinas locais não têm custo por chamada, mas continuam custando hardware, eletricidade e manutenção.

A [tabela oficial da Runpod](https://www.runpod.io/gpu-models/b300) cobra hoje **US$ 6,94 por hora** pela B300 no Community Cloud e **US$ 8,99 por hora** no Secure Cloud, com cobrança por segundo. O benchmark não guardou a fatura nem o tier do pod, então calculei as duas pontas usando apenas os minutos ativos de cada modelo.

Isso dá de US$ 71,94 a US$ 93,20 para o Qwen e de US$ 83,86 a US$ 108,63 para o GLM. São pisos artificiais. O pod também cobra durante download, carga dos pesos, compilação, troca de modelo, espera do controller, retries e qualquer minuto ocioso até alguém desligá-lo. A conta real foi maior.

"Tempo ativo" soma o tempo de modelo de todos os casos. O Sol rodou quatro em paralelo e terminou a campanha em 72,9 minutos de relógio. As outras configurações rodaram uma por vez. Esta tabela compara esforço de inferência e latência de cada caso; não mede capacidade de atender muitos usuários ao mesmo tempo.

Também há duas colunas de oráculo porque o limite de 16.384 tokens cortou respostas dos modelos locais. "Itens avaliados" ignora o que ficou impossível de corrigir. "Todos os itens" conta o que faltou como erro. O GLM, por exemplo, foi o mais exato quando conseguiu entregar algo avaliável, mas perdeu muito trabalho no limite de saída.

> Uma colocação acima na tabela não torna um modelo melhor para trabalhar. Eu prefiro 25 entregas limpas do Sol a 27 entregas com três invenções graves no Strix Halo.

## O custo do erro pesa mais que a média

Depois que publiquei este artigo, recebi um comentário: para advogado e contador, a média de acertos não basta. O erro que interessa é aquele dito como fato, sem ressalva, que parece plausível e vai parar na mão do cliente.

O benchmark separa o filtro de confiança do restante da nota. Uma data ou um valor errado reprova o item do oráculo. Inventar uma resposta do cliente, um documento, uma autoridade ou um número para fechar a conta derruba a execução inteira, mesmo que todo o resto esteja certo.

A diferença por configuração é grande:

| Modelo / infraestrutura | Execuções com invenção grave |
| --- | ---: |
| GPT-6 Sol médio / Codex | **0/38 (0%)** |
| Qwen3.8 Flash-Next IQ3_S / RTX 5090 | **0/38 (0%)** |
| Qwen3.8 Flash-Next IQ3_S / Strix Halo | 3/38 (7,9%) |
| Qwen3.8 Flash-Next NVFP4 / B300 | 2/38 (5,3%) |
| GLM 5.3 Flash NVFP4 / B300 | **0/38 (0%)** |

Foram cinco execuções afetadas entre 190, ou **2,6%**. Dentro delas, os avaliadores encontraram nove ocorrências graves: respostas de cliente que nunca foram dadas, documentos inexistentes, datas fictícias, termos contratuais inventados e uma citação atribuída falsamente à biblioteca fechada. Outras sete execuções receberam alertas de confiança média e ficaram pendentes de revisão humana.

Chamar isso de "taxa de respostas confiantes e erradas" seria impreciso. O benchmark não mede a confiança interna do modelo. O `high confidence` registrado nos resultados é a confiança do avaliador de que houve uma violação. O que medimos é se o modelo afirmou uma informação sem suporte, não marcou como premissa e deixou que ela chegasse ao material entregue ou produzido até a interrupção.

Também ainda não separei todo valor errado nessa categoria. Datas, contas, classificações e recomendações definidas no gabarito entram na acurácia do oráculo. Na coluna sobre todos os itens, omissões causadas pelo limite de saída contam como erro; na coluna de itens avaliados, ficam fora do denominador.

Na próxima versão, vale classificar cada erro por tipo e registrar se o modelo avisou que estava em dúvida. Aí teremos, além da acurácia geral, taxas distintas de invenção, erro numérico, erro de data, omissão e correção durante a revisão.

O mesmo Qwen teve acurácia estrita parecida nos itens avaliados da RTX 5090 e do Strix Halo, **91% contra 90%**. Na RTX, nenhuma execução teve invenção grave; no Strix, foram três.

## Sol 6: a referência também erra

O Sol foi o mais rápido, não teve falha grave de confiança e concluiu todas as 38 execuções sem estourar a saída. Mesmo assim, só 25 passaram por todos os critérios.

O ponto fraco apareceu nas contas, principalmente em cinco casos brasileiros. Ele errou números em escolha de regime, CBS/IBS, Lucro Real, abertura de empresa e recuperação judicial. Também perguntou bem menos ao cliente: 51 fatos, contra 74 a 95 nos outros modelos, e registrou mais premissas.

Premissa explícita é um comportamento correto quando falta informação. Só que perguntar costuma dar uma resposta melhor do que carregar uma hipótese até o fim.

A revisão final também piorou respostas. Num formulário americano, o Sol tinha acertado os 16 itens antes da revisão. Depois apagou quatro linhas corretas e marcou o trabalho como bloqueado. Em outro caso, anulou dois campos que já estavam certos.

Usar modelo fechado como árbitro continua sendo um erro. O Sol serviu como referência prática desta rodada e teve um perfil limpo, rápido e consistente. Ainda falhou em 13 dos 38 casos pelo critério estrito.

## Qwen3.8 Flash-Next na RTX 5090: melhor equilíbrio local

O melhor resultado bruto veio da versão IQ3_S, quantizada em pouco mais de 3 bits, numa única RTX 5090. Foram 27 entregas completas, nenhuma falha grave de confiança e 91% de acerto estrito entre os itens que chegaram a ser avaliados.

Ele levou 432 minutos ativos. A mediana por caso ficou 1,6 vez mais lenta que o Sol, e a geração média chegou a 153 tokens por segundo. Três execuções bateram no teto de saída. Para uma estação local, ainda foi um resultado forte.

Os erros mostram por que precisa de revisão profissional. Num caso brasileiro, calculou prazos com um dia de atraso e usou a revisão final para "confirmar" a própria conta errada. Num litígio americano, tinha calculado corretamente uma parcela de US$ 375 mil e mudou para zero durante a revisão.

Houve ainda duas suspeitas de invenção com confiança média que aguardam revisão humana. Elas não foram contadas como falhas graves. Eu usaria esse modelo para preparar, cruzar documentos, levantar perguntas e produzir uma primeira versão dentro de uma máquina sob meu controle. Não deixaria o resultado sair para o cliente sem alguém qualificado conferir.

## O mesmo Qwen no Strix Halo: cinco vezes mais lento

O Strix Halo rodou exatamente a mesma quantização IQ3_S e também terminou com 27 entregas completas. A semelhança para aí.

Foram 2.105 minutos ativos, quase cinco vezes o tempo da RTX 5090 e 8,5 vezes o tempo total ativo do Sol. A mediana do mesmo caso ficou 7,7 vezes mais lenta que a referência. Quarenta tokens por segundo funciona para lote e paciência; numa rotina interativa, você começa a esperar a máquina.

Pior: essa rodada teve três falhas graves. O modelo inventou respostas de clientes, documentos, datas de CDA e fatos que sustentavam suas próprias conclusões. A versão idêntica na RTX não teve nenhuma falha de alta confiança.

Com uma rodada por configuração, eu não consigo atribuir a diferença ao hardware, ao servidor ou à aleatoriedade da inferência. Seria desonesto concluir que Strix "faz o modelo alucinar". O que os dados permitem dizer é mais simples: **esta execução foi lenta e não foi confiável o bastante**. Precisa ser repetida antes de qualquer recomendação.

## Qwen3.8 Flash-Next na B300: alugar GPU grande não comprou qualidade

Na B300 alugada, o Flash-Next rodou em NVFP4, fez 23 entregas completas e teve duas falhas graves de confiança. Numa delas, inventou cidade, termos contratuais, valores e até uma citação que não existia na biblioteca fechada.

O tempo ativo foi de 622 minutos, com mediana 1,9 vez mais lenta que o Sol e geração média de 148 tokens por segundo. Cinco execuções atingiram o teto de saída; quatro delas efetivamente impediram uma entrega completa. Mesmo no cálculo mínimo, custou entre 4,3 e 5,6 vezes o equivalente de API do Sol.

Neste teste serial, uma B300 não trouxe mais qualidade nem menor latência que a RTX 5090. Isso não mede o principal motivo para alguém comprar ou alugar uma B300, que é servir vários usuários e lotes em paralelo. Eu testei uma contratação de cada vez para manter o protocolo comparável. O máximo que posso concluir é que **pagar pela classe de datacenter não melhorou esta sessão individual**.

## GLM 5.3 Flash na B300: preciso quando termina

O GLM teve um perfil diferente. Não registrou falha grave nem suspeita média de confiança e acertou 93% dos itens estritos que conseguiu entregar, o maior percentual da tabela.

Só completou 23 casos. Sete execuções bateram no teto de 16.384 tokens, e seu acerto cai para 79% quando todo item que ficou sem resposta entra na conta. Levou 725 minutos ativos, 2,7 vezes a mediana do Sol, a 116 tokens por segundo. Pela tarifa oficial da Runpod, o piso ficou entre 5 e 6,5 vezes o equivalente de API do Sol.

A escolha da coluna muda completamente a leitura. O GLM foi cuidadoso e exato nos resultados avaliáveis. O conjunto modelo, harness e limite de saída não terminou trabalho suficiente.

O teto foi uma escolha do harness, não uma limitação intrínseca do GLM. Eu preciso repetir com respostas maiores ou sessões mais curtas. Até lá, vender o 93% sem contar as sete interrupções seria propaganda.

## A revisão final ajuda e também estraga

Eu sempre recomendo pedir ao agente para reler tudo antes de entregar. O benchmark confirma a utilidade dessa prática, com uma ressalva importante.

Em 113 das 190 execuções, os avaliadores encontraram algum problema removido ou corrigido na revisão final. Entre eles havia fabricações que teriam chegado à entrega. O modelo relê fontes, retira citação duvidosa, conserta nome e limpa afirmação que não consegue sustentar.

Em cerca de uma dúzia, a mesma revisão mexeu no que estava certo. Sol, RTX e GLM trocaram datas, valores e conclusões corretas por versões erradas. Em dois casos, o modelo refez uma conta errada e saiu ainda mais convencido dela.

> Revisão automática é uma camada de higiene. A palavra "revise" não transforma o modelo em auditor independente de si mesmo.

Para trabalho sensível, eu usaria pelo menos duas etapas separadas: um agente produz, outro revisa com contexto limpo e critérios explícitos. A responsabilidade continua com o profissional.

## O benchmark também falhou em partes

Os modelos marcaram de 97,5 a 100 na vigilância. Seria tentador anunciar que todos viraram sócios perfeitos. A explicação real é que essa parte da prova ficou fácil demais.

Algumas bibliotecas praticamente entregavam o problema no índice. Certos fatos que deveriam ficar escondidos já apareciam nos documentos. Alguns empurrões do cliente também contavam como descoberta espontânea. Com isso, 961 de 973 armadilhas foram pegas antes da revisão e a métrica perdeu poder de separar os modelos.

Itens de quatro casos com defeitos confirmados na própria suíte foram rebaixados para diagnóstico. Outros casos ainda têm inconsistências que precisam de revisão. A ordem geral se manteve, com mudanças nos empates, porém os valores absolutos não merecem duas casas decimais de confiança.

Há mais limitações:

- uma única rodada por configuração, sem média nem barra de erro;
- Fable como criador e avaliador, sujeito aos próprios pontos cegos;
- nenhum contador, CPA, advogado ou attorney revisou ainda uma amostra formal;
- Codex para o Sol e OpenCode para os modelos locais;
- quantizações e servidores diferentes;
- um limite de saída que afetou apenas os modelos locais;
- legislação fechada no pacote, sem medir pesquisa atualizada na internet.

Eu publiquei esses problemas porque benchmark sem autocrítica vira tabela de marketing. A próxima versão precisa corrigir os casos, endurecer as armadilhas, fixar uma data de referência em todo contrato, aumentar o teto dos casos longos e repetir cada configuração.

## Privacidade muda a conta

Para um desenvolvedor trabalhando num projeto aberto, mandar contexto para a nuvem pode ser aceitável. Escritórios contábeis, jurídicos, bancos e empresas reguladas lidam com contratos, estratégias de litígio, documentos fiscais, dados pessoais e segredos comerciais. Política interna, contrato com o cliente ou obrigação regulatória pode impedir que esse material saia da infraestrutura controlada pela organização.

Nesses casos, o modelo local deixa de competir apenas por preço. Às vezes ele é a única opção permitida.

Rodar localmente também não torna os dados seguros por mágica. Ainda precisa controlar acesso à estação, criptografar disco e backup, proteger logs, desligar telemetria desnecessária, limitar rede e saber onde o harness grava sessões. Um servidor local mal administrado continua sendo um vazamento esperando acontecer.

Todos os casos deste benchmark são sintéticos justamente para evitar esse problema durante o teste.

## Então já dá para usar?

**Nuvem, com Sol:** foi a opção mais rápida e previsível desta campanha. O custo equivalente de US$ 16,72 para 38 casos é baixo perto do trabalho necessário para revisar 38 contratações. Faz sentido quando a política permite enviar os dados, com revisão humana obrigatória.

**Uma RTX 5090 própria:** o Qwen3.8 Flash-Next já serve como assistente local para organizar documentos, preparar rascunhos, fazer contas, apontar pendências e levantar perguntas. Foi o melhor equilíbrio aberto que medi. Ainda errou datas e valores de forma convincente.

**Strix Halo:** é uma opção compacta, mas 35 horas ativas para a campanha tornam o uso interativo difícil. O resultado desta rodada também teve invenções graves. Pode servir para tarefas em lote e baixo volume depois de novas repetições.

**B300 alugada:** não melhorou a qualidade de uma sessão e o tempo ativo sozinho já passou de US$ 70 por modelo. Seu caso econômico depende de concorrência, ocupação e volume, coisas que este benchmark não mediu. Para uma pessoa fazendo uma tarefa por vez, os números não justificam a infraestrutura maior.

[Nenhuma configuração completou mais de 27 dos 38 casos](https://github.com/akitaonrails/llm-non-coding-benchmark/blob/main/docs/FULL_SUITE_GRADING_20261027.md#1-lane-profiles). O melhor resultado ficou em 71%. Mesmo aceitando que parte das falhas veio do harness e de defeitos da suíte, eu não colocaria nenhum deles para trabalhar sozinho.

> Modelos abertos já são assistentes viáveis para contabilidade e Direito. Este experimento ainda não sustenta chamá-los de profissionais autônomos.

Um modelo que economiza duas horas de leitura e prepara uma boa primeira versão já pode pagar a máquina. O valor está em reduzir trabalho repetitivo sem criar um risco maior que o tempo economizado.

## Preciso de profissionais nesta próxima rodada

O projeto inteiro está aberto em [github.com/akitaonrails/llm-non-coding-benchmark](https://github.com/akitaonrails/llm-non-coding-benchmark). Lá estão a [metodologia](https://github.com/akitaonrails/llm-non-coding-benchmark/blob/main/docs/METHODOLOGY.md), o [relatório de correção](https://github.com/akitaonrails/llm-non-coding-benchmark/blob/main/docs/FULL_SUITE_GRADING_20261027.md), os [tempos de execução](https://github.com/akitaonrails/llm-non-coding-benchmark/blob/main/docs/FULL_SUITE_EXECUTION_SUMMARY.md), os casos, scripts e resultados brutos.

Agora preciso mais de profissionais do que de outra GPU. Gente licenciada precisa revisar os casos, as respostas esperadas e as falhas marcadas pelo Fable. Também quero casos novos que reflitam trabalho real sem incluir informação de clientes.

Se você é contador, CPA, advogado ou attorney e achou um absurdo técnico, abra uma issue com a correção e a fonte. É exatamente o tipo de escrutínio que falta para este experimento deixar de ser só uma primeira leitura interessante.
