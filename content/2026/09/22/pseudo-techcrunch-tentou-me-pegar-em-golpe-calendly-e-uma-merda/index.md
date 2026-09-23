---
title: "Cuidado! Pseudo-Techcrunch tentou me pegar em golpe! E Calendly é uma MERDA"
slug: "pseudo-techcrunch-tentou-me-pegar-em-golpe-calendly-e-uma-merda"
date: '2026-09-22T21:00:00-03:00'
draft: false
translationKey: pseudo-techcrunch-tentou-me-pegar-em-golpe-calendly-e-uma-merda
description: "Uma conta se passando por jornalista da TechCrunch me mandou DM hoje pedindo reunião, com um link de Calendly que redireciona pra uma tela de autorização OAuth do X. É o mesmo golpe que já pegou o José Valim, criador do Elixir. Documento o golpe passo a passo, com prova técnica."
tags:
- seguranca
- inteligencia-artificial
---

Hoje à noite recebi uma DM no X de uma conta se apresentando como jornalista, cobrindo IA pra TechCrunch, perguntando sobre como agentes de código lidam com contexto de projeto. Pedido de entrevista educado, tema batendo direto com o que eu escrevo aqui. E terminou em cima de um link que redireciona pra uma tela de autorização de conta do X. Isso é golpe, documentado, com prova técnica. Se você usa rede social e já recebeu mensagem parecida, este texto é pra você.

## A conta

![Perfil no X de uma conta chamada Mia, @MiaEsswein, com selo de verificado, se apresentando como jornalista cobrindo IA para a TechCrunch, anteriormente na Mashable](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/09/22/scam-mia-profile.png)

A bio diz: *"Covering AI, startups, markets, and emerging technologies for @TechCrunch | prev @mashable"*. Selo de verificado, conta desde agosto de 2014, mais de 45 mil posts, 1.409 seguidores. Pelos números, parece uma conta antiga e ativa, não um perfil criado ontem.

## A conversa

Aqui está a troca completa, sem cortar nada:

![Conversa de DM no X: a conta manda um link do Calendly e pede pra marcar reunião com o time dela; eu respondo recusando autorizar o Calendly a acessar minha conta do X e peço identificação](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/09/22/scam-dm-conversation.png)

E aqui está o link, exatamente como veio, pra quem quiser reconhecer se recebeu o mesmo:

> **Link de phishing confirmado. Não clique. Se já clicou, não autorize nada.**
> `https://calendly.com/d/d336-3mq-q2z`

## Eu já sabia que era golpe

Reconheci o padrão na hora porque o José Valim, criador do Elixir, caiu exatamente nessa isca em março deste ano e [documentou tudo publicamente](https://x.com/josevalim/status/2029628027945021810).

![Post do José Valim no X contando que a conta dele foi hackeada temporariamente pelo mesmo golpe do Calendly com autorização falsa do Twitter](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/09/22/scam-josevalim-post.png)

Mesmo pretexto, TechCrunch pedindo entrevista sobre tema técnico que a vítima domina. Mesmo mecanismo, link de Calendly que termina numa autorização do X. A conta dele acabou sendo usada pra espalhar spam de cripto antes dele revogar o acesso.

Quando a mensagem chegou pra mim hoje, quase comemorei. Sabia na hora que ia virar bom conteúdo pro blog. Por isso continuei a conversa educadamente, só o suficiente pra printar tudo, e agora estou expondo a conta publicamente. **Sempre exponha quem tenta te aplicar golpe.** Isso não é sobre humilhar ninguém, é sobre deixar rastro público pra próxima pessoa que receber a mesma mensagem e for procurar no Google.

## Mesmo sem saber do Valim, dava pra ver

Contato frio pedindo reunião, do nada, sem apresentação prévia, é golpe em 99% dos casos. Ninguém profissional de verdade opera assim, e muito menos por DM de rede social. Fazer isso é ser vendedor de porta em porta com Wi-Fi.

Nome de veículo grande no pretexto não muda nada pra mim. Eu me considero melhor do que a TechCrunch ou a capenga da Mashable, e nem alguém alegando falar em nome da Casa Branca ia me impressionar. Sem pedir desculpa por isso.

E mesmo se fosse uma pessoa normal por trás: meu tempo não é de graça. Quer consultoria de verdade? Fala com minha empresa, marca reunião comercial no Calendly *da empresa*, assina contrato, paga o valor, e só depois eu converso. Não existe atalho de "vamos bater um papo rápido" com estranho.

No momento em que cliquei no link, ele redirecionou direto pra tela de autorização do X, óbvio que recusei. Cliquei de propósito só pra tirar o print.

## O mecanismo técnico

![Tela de autorização OAuth do X pedindo permissão para o app "Events Portal" acessar a conta, com aviso de que o app não é afiliado ao X e está pedindo permissões sensíveis, callback em plugins.cal-apis.com](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/09/22/scam-oauth-authorize.png)

Um leitor comentou que a barra de endereço do print original mostrava um `oauth_token` na URL, e perguntou se isso não era inseguro de publicar. Boa pergunta, e editei o print pra apagar aquele trecho mesmo assim. Mas o risco real ali era zero: aquilo é um token de pedido do OAuth 1.0a, não um token de acesso. Ele só vira credencial de verdade depois que a autorização é aprovada e o app troca esse token por um verificador junto com sua própria chave secreta, nenhuma das duas coisas aconteceu, porque eu cliquei em cancelar. Token de pedido não usado também expira sozinho em poucos minutos, por definição do próprio X. Mesmo sem risco nenhum, não custa nada tirar da imagem, e vale como regra geral: nunca publique nada que pareça token, mesmo o que você tem certeza que já morreu.

O primeiro passo é real: `calendly.com/d/d336-3mq-q2z` roda em cima da infraestrutura de verdade do Calendly, confirmei isso batendo direto no link e conferindo os cookies e cabeçalhos de resposta, tudo genuíno. É um formulário de roteamento padrão do produto, nome e tipo de reunião.

O golpe mora no que acontece depois de enviar o formulário. O Calendly tem um recurso legítimo de "redirecionar após o agendamento", e é exatamente esse recurso que foi configurado pra mandar a vítima pra uma tela de autorização OAuth do X. Essa tela também é real, ela roda em `api.x.com`, o domínio de verdade do X. O golpe não falsifica a tela de login. Ele abusa de um recurso genuíno do Calendly pra encadear numa tela genuína do X, autorizando um aplicativo de terceiro malicioso.

E aqui vai a parte que eu quero deixar bem marcada: essa não é falha exótica escondida em algum canto obscuro. É um pseudo-recurso ligado por padrão, redirecionamento livre pra qualquer URL depois do agendamento, sem checagem nenhuma de destino. Enquanto o Calendly não desativar ou pelo menos restringir esse redirecionamento, ele continua sendo vetor de phishing pronto pra uso, e a responsabilidade de fechar essa porta é do Calendly, não do usuário que só queria marcar uma reunião.

Esse aplicativo se chama **"Events Portal"**, alega ser `www.eventsportal.com`, e o X mostra um aviso próprio: *"Este app não é afiliado ao X e está solicitando permissões sensíveis"*, com o callback apontando pra `plugins.cal-apis.com`, não pra nenhum domínio real do Calendly. As permissões pedidas são de sequestro de conta completo:

- ver posts protegidos, listas e coleções;
- ver configuração de conta e perfil;
- ver quem você segue, silencia e bloqueia;
- seguir e deixar de seguir por você;
- atualizar seu perfil e configurações;
- criar e excluir posts, curtir, repostar e responder por você;
- criar, gerenciar e excluir listas;
- silenciar, bloquear e denunciar contas por você.

Com isso autorizado, a conta vira arma pra atacar a próxima pessoa, exatamente o que aconteceu com o José Valim.

## O que eu confirmei por conta própria

Calendly de verdade não pede login de rede social pra marcar reunião, ponto final. O que a tela mostrou é o recurso legítimo de "redirecionar após o agendamento" sequestrado pra virar vetor de phishing contra conta do X. Não parei na primeira impressão, fui confirmar cada peça sozinho:

- o domínio `cal-apis.com` foi registrado há só seis dias, em 16 de setembro de 2026, por um revendedor chinês ligado à Alibaba Cloud, escondido atrás de servidor de nome do Cloudflare. Domínio descartável, criado especificamente pra isso, não infraestrutura real de nenhuma empresa;
- pesquisadores de segurança (Push Security e Validin) já documentaram campanha de phishing com tema Calendly usada pra roubar conta de Google Workspace e de Facebook Business, mesma família de golpe, alvo diferente do meu caso;
- especificamente contra conta do X, o que existe documentado é relato em primeira mão: o próprio José Valim, e um relato público de fevereiro de 2025 contando que um golpe quase idêntico, Calendly falso levando a login do X, quase pegou duas outras pessoas conhecidas da comunidade de tecnologia;
- não achei nenhum registro de "Mia Esswein" como jornalista de verdade da TechCrunch ou da Mashable em nenhuma busca. Não é prova definitiva de nada sozinha, mas some ao resto da pilha de evidência.

## O checklist que eu uso

- contato frio pedindo reunião, sem apresentação, é golpe até prova em contrário;
- ferramenta de agendamento de verdade nunca pede login de rede social pra marcar horário;
- app de terceiro pedindo "permissão sensível" e avisando que "não é afiliado" à plataforma é bandeira vermelha, não detalhe técnico ignorável;
- se você já autorizou algo assim, revogue agora: no X, Configurações → Segurança e acesso à conta → Apps e sessões;
- denuncie a conta que mandou o link, e denuncie o evento do Calendly se ainda tiver a conversa.

## Pra quem tentou

Vocês escolheram a pessoa errada pra tentar. Eu não converso de graça com estranho por princípio, muito menos autorizo aplicativo desconhecido em conta que eu uso pra trabalhar. Reconheço o padrão de longe porque leio sobre isso, e ainda por cima ganhei um artigo novo pro blog de brinde. Da próxima vez, invistam menos em domínio novo registrado às pressas e mais em disfarce que sobreviva a alguém que presta atenção.
