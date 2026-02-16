---
title: "Vibe Code: Do Zero à Produção em 6 DIAS | The M.Akita Chronicles"
slug: "vibe-code-do-zero-a-producao-em-6-dias-the-m-akita-chronicles"
date: 2026-02-16T14:19:56+00:00
draft: false
tags:
- vibecode
- makitachronicles
- rubyonrails
---

**ASSINE O NOVO NEWSLETTER:** [The M.Akita Chronicles](https://themakitachronicles.com/)
**LEIA A VERSÃO BLOG:** [Blog](https://blog.themakitachronicles.com/)
**OUÇA NO SPOTIFY!!** [Podcast](https://open.spotify.com/show/7MzG2UB7IAkC3GAwEXEIVD)

--

![a ideia](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-14_18-59-53.png)

Dia 10 de fevereiro de 2026, eu postei o tweet acima só jogando no ar uma coisa que está na minha to-do list faz anos, desde que eu publicava vídeos no YouTube. Nunca fiz porque eu odeio HTML/CSS e ter que fazer template de e-mail era suficiente pra não começar. Além disso, fazer mais uma newsletter, que é só uma lista de links chata, não me motivava.

Mas nesse dia eu já estava terminando meu segundo projeto com vibe coding, o [FrankMD](https://github.com/akitaonrails/FrankMD), e acho que entendi os principais truques e a metodologia pra fazer um produto completo da forma certa. Então, começaram a surgir várias ideias. Dei dump e escrevi este [pequeno documento](https://gist.github.com/akitaonrails/d2a7983fc4c839b8071f5d0babaadf94).

[![conceito original](/images/preview/screenshot-2026-02-14_19-02-15.png)](https://gist.github.com/akitaonrails/d2a7983fc4c839b8071f5d0babaadf94)

Pensei: e se eu fizesse não só o código do sistema de newsletter com vibe code, mas também tivesse parte do próprio conteúdo gerada por IA de forma inusitada, na forma de comentaristas, eu e um robô? E, claro, com Guia do Mochileiro na mente, tinha que ser o MARVIN, ou melhor, o "M.Arvin" (pra ninguém encher com copyright).

É claro, vai ter versão por e-mail semanal e blog de arquivos. Mas já que vai ter tudo isso, por que não já reescrever toda a newsletter em script de podcast. E já que recentemente saiu o [Qwen3 TTS](https://qwen.ai/blog?id=qwen3tts-0115), open source, por que não treinar um LoRa com minha voz (obviamente, tenho centenas de horas de minha voz no YouTube) e fazer um podcast totalmente automatizado?

Finalmente, um dos desmotivadores pra mim seria criar um Web Admin tradicional e ter que entrar manualmente lá pra cadastrar os links de notícias e meus comentários. Eu sei que ia me dar preguiça e, a uma hora, ia cansar. Só tinha uma solução: criar um bot mais inteligente com o qual eu pudesse conversar via **DISCORD**. Assim, eu posso rapidamente acessar, seja do meu PC, seja do meu smartphone, sem precisar logar num sistema separado nem nada. Eu já converso com pessoas no Discord, então a fricção seria zero.

Então:
- Marvin Bot pra gerenciar todo conteúdo (que eu mando e os automatizados, com comentários e tudo mais)
- Monitor de X.com pra checar o que eu postei e já pegar pra usar na newsletter. Incluindo as replies que eu dou, que vão virar Q&A!
- Newsletter website pra assinar, cancelar, etc
- Blog pra arquivos de newsletter e de transcripts dos podcasts (também com termos de serviço e de privacidade — sim, sou LGPD compliant!)
- Gerador automático de vozes e montador de podcast que vai subir automaticamente pra deixar disponível pro Spotify
- E ainda templates de blog e e-mail, com versões de tema light e dark.

Você, que é um programador experiente, sem IA, quanto tempo levaria pra fazer tudo isso?

Pois bem, eu comecei no dia 10 de fevereiro. Terminei tudo no domingo, dia 15 de fevereiro. E hoje, dia 16, rodaram os jobs de produção pela primeira vez, o que gerou newsletter, os blog posts, podcast, upload pro Spotify, envio de email.

E não foi do jeito podre que todo vibe coder amador faz:

![newsletter stats](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-16_11-37-20.jpg)

![bot stats](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-16_11-37-27.jpg)

Quem é de Rails deve ter ficado surpreso: projeto com taxa de 1 pra 1 de testes! 1 linha de testes pra cada 1 linha de código: 100% de cobertura. E isso, sem contar um projeto separado deles de integração completa, ponta a ponta (que usei pra garantir que a produção ia ser perfeita).

Todas as estratégias que eu aprendi ao longo dos anos colocando projeto em produção: segurança, escalabilidade, durabilidade, garantia de entrega sem spammar duplicatas de e-mails, etc. Depois vejo se faço mais posts específicos sobre alguns dos truques técnicos.

Este projeto não vou abrir como open source. Eu fiz 100% customizado pra mim, pro meu fluxo de trabalho e meus estilos. Não é difícil pra outro programador competente fazer a mesma coisa com vibe code: se eu consegui, qualquer um consegue. Então é só não ter preguiça de pensar e fazer. Aliás, não entendo como tech youtubers ainda não estão lançando 1 projeto completo em produção, por vídeo, pra todo mundo testar e ver.

No screenshot também não está o servidor de Qwen3-TTS, que faz a produção de áudio. Esse é bem mais simples, um servidor PyTorch. Aqui foi Python mesmo. O mais importante é o fine tuning do modelo pra gerar vozes exatamente do jeito que eu queria:

![qwen3 server](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-16_11-45-20.jpg)

O blog é todo com **Hugo/Hextra**, como este também. E meu bot publica lá automaticamente.

## M.Arvin Bot

O M.Arvin tem uma personalidade que eu detalhei como eu queria. E é um bot de Discord, então meu trabalho é assim:

![bot url register](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-16_11-54-29.jpg)

Só preciso mandar um link com meu comentário (igual eu faria no X.com), ou posso postar direto no X, que ele vai pegar igual. Daí ele busca o conteúdo, faz um resuminho, faz um pequeno fact-check e o M.Arvin gera seu comentário em cima do meu.

Eu programei ele pra responder a um monte de comandos pra facilitar meu dia a dia. Isso é só uma pequena parte:

![bot help commands](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-16_11-56-13.jpg)

Eis um exemplo, eu tenho controle sobre quanto de IA ele está usando (é bem barato):

![AI cost](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-16_11-57-07.jpg)

## Deployment

Neste post não vou detalhar muito, mas uma coisa que demorei bastante, passando por várias discussões e versões com o Claude Code, foi na arquitetura de infraestrutura. E no final ele conseguiu me dar um Deployment Guide, que consegui seguir até o fim e sabendo que minimamente está como eu mesmo faria se tivesse feito tudo sozinho:

![topology](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-16_11-58-45.jpg)

Nenhum software tem garantia de ser 100% perfeito; este também não deve ser. Mesmo eu tendo revisado incansavelmente por dias, revendo e refinando cada etapa múltiplas vezes, sempre vai ter algum bug que eu não previ. Eu "acho" que, pelo menos, tudo o que sei que costuma dar problema em produção, "acho" que consegui cobrir de forma satisfatória. Se fosse uma equipe humana, eu teria colocado em produção num estado pior do que o que atingi com o Claude.

Tudo o que dava pra proteger com Cloudflare, eu configurei. Todas as boas práticas pra e-mail/mailing, eu segui. Todas as precauções contra acidentes eu tomei (todo deploy automatizado com Kamal), e todos os e-mails dos assinantes encriptados com AES-256 no banco de dados (mesmo que vazar por acidente, não vazam os dados dos usuários). Não implementei profiling, cookies ou pixels de rastreamento, nada. Privacidade foi o foco.

Tudo o que dava pra reduzir custos eu reduzi, afinal, vou pagar do meu bolso. Então, coisas como GPU na RunPod pra gerar os áudios são serverless. Eu subo só no momento de gerar; ele faz todo o processo e, depois, a máquina desliga. O servidor está todo organizado numa imagem Docker leve. Todos os modelos de IA estão num volume de rede separado.

## Spoiler do Processo

Depois pretendo fazer um post maior falando da minha metodologia, mas é muito simples: trate o Claude Code/Codex como se fosse um programador humano esforçado — que vai cometer muitos erros, mas sabe obedecer ordens super explícitas, diretas, claras e sem ambiguidade. Meu papel é gerente de produto, Tech Lead ou QA. Têm que ser os TRÊS papéis. 

![commits](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-16_12-06-47.jpg)

No total, o Claude Code fez 201 commits. Mas não são commits normais; eu considero que, num projeto normal com humanos, cada um teria sido aproximadamente **150 Pull Requests**.

Pergunta a vocês que participam de sprints em projetos: quanto tempo leva pra ter 150 user stories/bug fixes aprovados e em produção no seu projeto real? Quantos user stories vocês conseguem fazer e aprovar (com QA e tudo) em UMA semana?

Eis um exemplo de um commit/"user story":

![commit example](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-16_12-08-55.jpg)

Quando estava lá no commit, talvez 50, eu já pensava: "Já funciona!"* É o estágio que todo criador de conteúdo (que nunca colocou projetos de verdade em produção) já postaria, dizendo: *"fiz vibe code em 2 dias"*. De fato, em 2 dias eu já tinha o grosso das funcionalidades prontas.

Os outros 4 dias foram: 

- 1 dia pra deploy em produção (quando tem tudo planejado com antecedência, todas as contingências já pensadas, é fácil).
- 3 dias só testando, criando testes automatizados/integração, gerando e regerando, exercitando todas as etapas de todas as partes, múltiplas vezes, e fazendo ajustes, refatorações ou até mesmo jogando fora um pedaço inteiro pra mudar, porque os testes indicaram que valia mais a pena.

Isso levou de 50 a 200 commits! E é a parte que todo vibe coder **pula**. Sendo justa, é a parte que qualquer pessoa, com ou sem IA, pularia. E é por isso que sempre os projetos dão errado e vão pra produção cheios de erros e buracos óbvios de segurança.

Mesmo depois de pedir ao Claude Code pra revisar boas práticas de segurança e cobertura de testes, múltiplas vezes. Depois eu abri o Codex e pedi pra fazer a mesma coisa, e ele ainda achou mais buracos de segurança e mais testes faltando, múltiplas vezes. Mesmo depois dos dois fazerem essas checagens várias vezes, eu ainda encontrei sozinho mais buracos que mandei consertar. Em nenhum momento, nenhum dos dois conseguiu achar "TUDO". Ninguém consegue, nem a IA.

## Conclusão

Programar Vibe Coding da forma correta só tem um jeito: Extreme Programming!

Sim, todas as coisas "chatas" e "burocráticas" que todo desenvolvedor odeia fazer são o que garante que a IA vai devolver um resultado aceitável pra colocar em produção:

- Pair Programming: você precisa mandar a IA planejar primeiro e te dizer exatamente tudo o que vai fazer, ANTES de começar. Eu reviso, ajusto e só quando estou satisfeito deixo fazer. Fico olhando cada coisa que ele faz e, no final, mando ajustar o que acho que faltou.
- Test-Driven Development: toda funcionalidade deve vir acompanhada de testes unitários. Toda correção de bug precisa de testes de regressão.
- Continuous Integration: Toda vez que termina de implementar, precisa rodar script de CI pra ver se nada quebrou em outro lugar. Mais do que isso: no branch master, só há commits com testes que passam. Eu posso reverter em qualquer ponto e o projeto roda.
- Small Releases: isso eu achei ótimo no Claude, mesmo se eu acabar esquecendo de mandar ele comitar uma tarefa e mandar fazer outra, no fim, ele não faz aquela tosquice de `git add .` — não: ele separa em 2 commits e descreve cada um da forma correta. Além disso, eu subi produção na sexta-feira, e continuei sábado e domingo testando integração local e em ambiente de produção, pra garantir que não tem isso de *"só na minha máquina funciona"*
- Coding Standard: eu iniciei com o mínimo de requerimentos técnicos, mas, durante o desenvolvimento, mandei refatorar do meu jeito várias e várias vezes.

![tech stack](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-16_12-21-22.jpg)

Essas são as principais coisas que precisam ser feitas. Já adianto: "Spec Driven Development" não é totalmente inútil, mas a estrutura não tem importância: é o seu texto que tem.

É a mesma coisa que User Stories. Grande bosta que você escreveu "Eu, como o usuário final, Quero que quando digitar X ..., o sistema responda com Y". O formato NUNCA é importante. O que é importante é COMO você escreveu o que vai no meio. Se você não sabe escrever, a IA não vai saber responder a você como deveria. Vou fazer outro artigo só pra demonstrar como todos vocês são péssimos em escrever.

O recado é simples: Vibe Code funciona, em partes.

> O que funciona mesmo é "Senior Agile Vibe Coder"

Vou perguntar de novo: quanto tempo, sem IA, você levaria pra produzir 150 user stories/bug fixes, no escopo que resumi no começo? Até colocar em produção com tudo testado? Duvido que seja em 6 dias como eu fiz.