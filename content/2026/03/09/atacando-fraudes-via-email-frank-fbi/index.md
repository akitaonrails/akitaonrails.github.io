---
title: "Atacando fraudes via email | Frank FBI"
date: '2026-03-09T13:00:00-03:00'
draft: false
translationKey: frank-fbi-email-fraud
tags:
  - ruby
  - rails
  - security
  - email
  - fraud-detection
  - open-source
  - AI
  - vibe-coding
---

Esse fim de semana eu trabalhei em 3 projetos. Dois deles eu já publiquei: o [easy-ffmpeg](/2026/03/07/crystal-e-um-wrapper-inteligente-pro-ffmpeg-feito-em-3-horas-easy-ffmpeg/), um wrapper inteligente pro FFmpeg em Crystal, e o [easy-subtitle](/2026/03/07/portando-10-mil-linhas-de-python-pra-crystal-com-claude-easy-subtitle/), um port de 10 mil linhas de Python pra Crystal em menos de 40 minutos. Continuo melhorando os dois, adicionando features e corrigindo edge cases conforme uso no dia-a-dia.

Mas o terceiro projeto é de outra natureza. É um projeto de segurança. E a motivação vem de uma dor antiga.

## O problema: emails demais

Como ex-YouTuber e criador de conteúdo, eu recebo uma quantidade absurda de emails. Convites pra eventos, propostas de collab, ofertas de patrocínio, pedidos de divulgação. Todo tipo de abordagem.

Eu deleto 100% deles. Não leio. A maioria eu marco como SPAM sem sequer abrir. A forma mais fácil de ser reportado é me mandar um email -- eu não ligo, porque eu não preciso. Eu também não atendo telefone. Nunca. E bloqueio automaticamente qualquer pessoa que mande mensagem direto no meu WhatsApp, independente do conteúdo. Meu tempo é valioso demais pra eu ficar triando mensagem de desconhecido. Deleto tudo e sigo em frente.

Funciona pra mim. Mas eu sei que a maioria das pessoas não opera assim.

## O veneno é a VAIDADE

A maioria das pessoas que cai em phishing por email não cai por ignorância técnica. Cai por **VAIDADE**.

"Olá, queremos te convidar pra nosso evento exclusivo." "Sua marca foi selecionada para uma parceria especial." "Parabéns, você foi indicado como referência no seu setor."

A dopamina bate antes da razão ter chance de intervir. Alguém reconheceu seu trabalho, alguém quer te dar dinheiro. É exatamente aí que o golpista te pega.

Não é o CEO de multinacional que cai no golpe do príncipe nigeriano. É o microinfluencer que recebe uma proposta de patrocínio "boa demais pra ser verdade". É o pequeno empresário que recebe um convite pra um evento que parece legítimo. A vaidade desliga o senso crítico.

E os golpes estão cada vez mais sofisticados. Com LLMs, qualquer criminoso gera emails perfeitos em português, sem erros gramaticais, com formatação profissional, com domínios que imitam empresas reais. O velho "olha os erros de português" já não serve mais como filtro.

## A ideia: Frank FBI

Em vez de tentar ensinar todo mundo a identificar phishing (o que não funciona, porque a vaidade é mais forte que o treinamento), por que não criar uma ferramenta que faça isso automaticamente?

Recebeu um email suspeito? Encaminha pra um endereço dedicado. Em poucos minutos, recebe de volta um relatório detalhado com tudo que a ferramenta conseguiu descobrir sobre aquele email.

Assim nasceu o [Frank FBI](https://github.com/akitaonrails/frank_fbi) -- Fraud Bureau of Investigation.

## Como funciona

Você configura uma conta Gmail dedicada (pode ser qualquer Gmail com App Password). Cadastra os emails autorizados a usar o serviço. A partir daí, o fluxo é:

1. Recebe email suspeito na sua caixa pessoal
2. Encaminha pro endereço do Frank FBI
3. O sistema analisa automaticamente
4. Recebe a resposta na mesma thread, com o relatório completo

Pra dar uma ideia do resultado, aqui está um relatório de um email legítimo (cold outreach de uma empresa real):

![Relatório de email legítimo - score 80/100](https://raw.githubusercontent.com/akitaonrails/frank_fbi/master/docs/ok-email.png)

E aqui um email suspeito, onde o domínio do remetente tenta se passar por outra empresa:

![Relatório de email suspeito - score 40/100](https://raw.githubusercontent.com/akitaonrails/frank_fbi/master/docs/suspect-email.png)

O Frank FBI roda 6 camadas de análise, cada uma com peso específico na pontuação final:

### Camada 1 -- Autenticação de headers (peso 15%)

SPF, DKIM, DMARC. O Reply-To bate com o From? Tem headers antispam suspeitos? Essa camada responde a pergunta mais básica: o email realmente veio de quem diz que veio?

### Camada 2 -- Reputação do remetente (peso 15%)

Consulta a idade do domínio via WHOIS (domínio registrado semana passada já é um sinal), verifica se o IP está em listas negras de DNS (DNSBL), e mantém um banco de reputação local que melhora conforme mais emails são analisados. Se o remetente finge ser uma empresa mas manda de um Gmail, isso pesa.

### Camada 3 -- Análise de conteúdo (peso 15%)

Aqui entra o pattern matching: urgência artificial ("sua conta será bloqueada em 24h"), pedidos de dados pessoais, impersonação de autoridade, ofertas financeiras. Também detecta URL shorteners e links onde o texto exibido não bate com o href real -- aquele clássico "clique aqui" que aponta pra um domínio completamente diferente. Verifica anexos perigosos (.exe, .scr, macros em Office).

### Camada 4 -- APIs externas (peso 15%)

O URLhaus (abuse.ch) mantém um banco de URLs maliciosas conhecido. O VirusTotal agrega resultados de dezenas de antivírus. Se alguma URL do email já foi flagada como malware ou phishing por essas bases, o score sobe. Resultados ficam em cache com TTL pra não estourar os rate limits das APIs gratuitas.

### Camada 5 -- Verificação de entidade (peso 10%)

Essa camada eu acho a mais interessante. O Frank FBI faz OSINT -- Open Source Intelligence. Usa o Brave Search pra verificar se o remetente ou empresa realmente existe. Faz WHOIS do domínio diretamente. Captura screenshot do site com Chrome headless. Cruza tudo pra tentar responder: "essa entidade é real e é quem diz ser?"

Olha um exemplo real dessa camada em ação, analisando um email que tentava se passar por uma empresa legítima:

![Verificação de identidade - OSINT detalhado](https://raw.githubusercontent.com/akitaonrails/frank_fbi/master/docs/verificacao-identidade.png)

O domínio tinha 83 dias de vida, registrado via Namecheap, sem presença online verificável. O sistema encontrou divergências entre o nome no email e os registros públicos, e identificou que o domínio legítimo da empresa real era outro.

### Camada 6 -- Análise por LLM (peso 30%)

Consulta 3 modelos de IA em paralelo: Claude Sonnet (Anthropic), GPT-4o (OpenAI) e Grok 4 (xAI), via OpenRouter. Cada modelo analisa o email de forma independente. Um sistema de consenso com peso por confiança combina os resultados. Se os 3 concordam que é fraude, a confiança é alta. Se divergem, o sistema pondera. Se todos os LLMs falharem, cai pra um score neutro de 50 em vez de adivinhar -- melhor admitir ignorância do que alucinar.

A pontuação final é uma média ponderada com ajuste de confiança. Vereditos possíveis: Legítimo (0-25), Suspeito OK (26-50), Suspeito Fraude (51-75) ou Fraudulento (76-100). Existe ainda uma política de escalação de risco que impõe pisos mínimos: se indicadores críticos foram detectados (URLs maliciosas confirmadas, DKIM falhou), o score não pode ficar abaixo de certos limiares, mesmo que outras camadas não tenham achado nada.

## Self-hosted: seus dados ficam com você

O Frank FBI é self-hosted. Você roda no seu próprio servidor. Seus emails não passam por nenhum serviço de terceiro (exceto as APIs de verificação como VirusTotal, que recebem apenas URLs, não o conteúdo do email).

Dá pra instalar no seu home server, como eu fiz, ou dentro da infraestrutura da sua empresa pra que seus funcionários usem. O deploy é via Docker Compose com 4 containers: aplicação Rails, worker de jobs em background, poller IMAP, e um setup inicial de banco. Sobe tudo com um `docker compose up -d` e está funcionando.

## Reportando fraudes pra comunidade

Além de analisar emails pra você, o Frank FBI pode opcionalmente reportar fraudes confirmadas pra bancos de dados comunitários. Isso só acontece quando o score é >= 85 e o veredito é "fraudulento". É opt-in.

O ThreatFox (abuse.ch) é um banco de dados aberto de indicadores de comprometimento (IOCs) mantido pela comunidade de segurança. Quando você reporta uma URL ou domínio malicioso lá, firewalls, filtros de email e SIEMs ao redor do mundo podem consumir essa informação pra bloquear a ameaça.

O AbuseIPDB é a mesma ideia, mas pra IPs. Se o IP do remetente do email fraudulento é reportado aqui, provedores de email e administradores de rede podem bloquear tráfego malicioso antes que chegue aos usuários.

E o SpamCop é um dos serviços mais antigos de reporting de spam. O Frank FBI encaminha o email completo pro SpamCop, que analisa os headers e reporta pros provedores responsáveis. É denunciar direto pra quem pode agir.

Cada report é uma contribuição pra que outras pessoas não caiam no mesmo golpe. E é automatizado: se o email é claramente fraudulento, o report sai sem intervenção manual.

Mas reportar coisas erradas causa dano. Por isso o sistema tem proteções anti-envenenamento: uma lista de ~40 domínios conhecidos (Microsoft, Apple, Google, Amazon, PayPal, governos) que nunca são reportados; domínios com scan limpo são excluídos; IPs de infraestrutura de cloud (Google, Microsoft, Cloudflare) são filtrados; domínios de email gratuito são ignorados. Só IOCs genuinamente maliciosos chegam aos bancos comunitários.

## Deploy: como colocar pra rodar

Vou explicar como eu fiz o deploy no meu home server. Se você tem um VPS, NAS ou qualquer máquina Linux com Docker, o processo é o mesmo.

### 1. Clonar e buildar a imagem

Você precisa de um registry privado pra guardar a imagem Docker. Eu uso [Gitea](https://gitea.io/) no meu home server -- é um GitHub self-hosted leve que inclui container registry. Se você já tem um GitHub privado, pode usar o GitHub Container Registry (ghcr.io) em vez disso.

```bash
# Clonar o repositório
git clone https://github.com/akitaonrails/frank_fbi.git
cd frank_fbi

# Buildar a imagem Docker
# Se usa Gitea (troque pelo IP/porta do seu registry):
docker build -t seu-servidor:3007/frank_fbi:latest .
docker push seu-servidor:3007/frank_fbi:latest

# Se usa GitHub Container Registry:
docker build -t ghcr.io/seu-usuario/frank_fbi:latest .
docker push ghcr.io/seu-usuario/frank_fbi:latest
```

### 2. Configurar o .env

Copie o `.env.example` e preencha. As variáveis obrigatórias:

```bash
# Gere com: ruby -rsecurerandom -e 'puts SecureRandom.hex(64)'
SECRET_KEY_BASE=

# Gere com: bin/rails db:encryption:init (roda local, copia os 3 valores)
ACTIVE_RECORD_ENCRYPTION_PRIMARY_KEY=
ACTIVE_RECORD_ENCRYPTION_DETERMINISTIC_KEY=
ACTIVE_RECORD_ENCRYPTION_KEY_DERIVATION_SALT=

# Gmail dedicado pro Frank FBI (crie uma conta só pra isso)
# Ative 2FA e gere um App Password em https://myaccount.google.com/apppasswords
GMAIL_USERNAME=seu-frank-fbi@gmail.com
GMAIL_PASSWORD=xxxx-xxxx-xxxx-xxxx
GMAIL_IMAP_HOST=imap.gmail.com
GMAIL_SMTP_HOST=smtp.gmail.com

# Senha do ingress do Action Mailbox (qualquer string aleatória)
RAILS_INBOUND_EMAIL_PASSWORD=uma-senha-qualquer-longa

# LLM via OpenRouter (obrigatório pra Camada 6)
OPENROUTER_API_KEY=sua-chave-openrouter

# Seu email de admin (pra gerenciar remetentes autorizados)
ADMIN_EMAIL=seu-email@pessoal.com
```

As APIs externas são opcionais mas recomendadas. Sem elas, as camadas correspondentes simplesmente não rodam:

```bash
# VirusTotal (grátis, 4 requests/min) - https://virustotal.com
VIRUSTOTAL_API_KEY=

# WhoisXML (grátis, 500 requests/mês) - https://whoisxmlapi.com
WHOISXML_API_KEY=

# Brave Search (grátis, 1 req/s) - https://brave.com/search/api/
BRAVE_SEARCH_API_KEY=
```

E o community reporting, que é totalmente opt-in. Deixe em branco se não quiser reportar:

```bash
THREATFOX_AUTH_KEY=
ABUSEIPDB_API_KEY=
SPAMCOP_SUBMISSION_ADDRESS=
```

### 3. Docker Compose no servidor

Crie o `docker-compose.yml` no seu servidor. Troque a imagem pelo seu registry:

```yaml
services:
  setup:
    image: seu-servidor:3007/frank_fbi:latest  # ou ghcr.io/seu-usuario/frank_fbi:latest
    command: ["./bin/rails", "db:prepare"]
    env_file: .env
    environment:
      - RAILS_ENV=production
    volumes:
      - ./storage:/rails/storage

  app:
    image: seu-servidor:3007/frank_fbi:latest
    env_file: .env
    environment:
      - RAILS_ENV=production
    volumes:
      - ./storage:/rails/storage
      - ./emails:/rails/emails
    depends_on:
      setup:
        condition: service_completed_successfully
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:3000/up"]
      interval: 10s
      timeout: 5s
      retries: 3
      start_period: 15s
    restart: unless-stopped

  worker:
    image: seu-servidor:3007/frank_fbi:latest
    command: ["./bin/jobs"]
    env_file: .env
    environment:
      - RAILS_ENV=production
    volumes:
      - ./storage:/rails/storage
    depends_on:
      setup:
        condition: service_completed_successfully
    restart: unless-stopped

  mail_fetcher:
    image: seu-servidor:3007/frank_fbi:latest
    command: ["./bin/rails", "frank_fbi:fetch_mail"]
    env_file: .env
    environment:
      - RAILS_ENV=production
      - APP_HOST=http://app:3000
    volumes:
      - ./storage:/rails/storage
    depends_on:
      app:
        condition: service_healthy
    restart: unless-stopped
```

### 4. Subir e cadastrar o primeiro usuário

```bash
docker compose up -d
```

O `setup` roda as migrations e sai. O `app` sobe o Rails, o `worker` processa os jobs em background, e o `mail_fetcher` fica fazendo polling IMAP a cada 30 segundos.

Pra cadastrar remetentes autorizados, mande um email do seu ADMIN_EMAIL pro endereço do Frank FBI com o assunto `add email1@exemplo.com, email2@exemplo.com`. Pra listar quem está cadastrado, mande com assunto `list`. Pra ver estatísticas, `stats`.

A partir daí, qualquer remetente cadastrado pode encaminhar emails suspeitos e receber os relatórios de análise.

## O processo de desenvolvimento

Esse projeto começou como uma ideia simples: "e se eu pudesse encaminhar emails suspeitos pra algum lugar e receber uma análise?". Mas projetos de segurança não são como projetos normais.

Num projeto comum, um bug é inconveniente. Num projeto de segurança, um bug pode ser uma vulnerabilidade. Se o sistema diz que um email fraudulento é legítimo, alguém pode perder dinheiro. Se reporta incorretamente um domínio legítimo como malicioso, pode prejudicar uma empresa inocente. Se um email malicioso consegue explorar o próprio analisador, o atacante ganha acesso ao servidor.

Isso muda o mindset de desenvolvimento. Cada decisão precisa considerar: "como alguém mal-intencionado poderia abusar disso?"

### Evolução via commits

Deixa eu mostrar como o projeto evoluiu olhando os commits mais relevantes.

O projeto começou com a estrutura básica de análise de email e logo precisou de controle de acesso:

```
eb59474 - Add admin access control and allowed senders whitelist
036e9f1 - Harden access control against email spoofing and admin impersonation
```

O primeiro adiciona a lista de remetentes autorizados. O segundo resolve o problema óbvio: e se alguém spoofar o email de um remetente autorizado? O sistema passou a verificar SPF/DKIM antes de aceitar qualquer submissão. Rate limiting por remetente veio junto, pra evitar abuso.

Depois vieram as preocupações com a qualidade do scoring:

```
e891270 - Fix zero-dilution scoring bug and add critical alert UX
2cbb272 - Harden fraud scoring and reporting
50d96a1 - Move text pattern detection from regex to LLM consensus layer
```

O bug de zero-dilution é sutil: quando uma camada falha e retorna score 0 com confiança baixa, ela diluía a média geral pra baixo, fazendo emails fraudulentos parecerem mais seguros do que eram. A correção implementou dampening que descarta camadas de baixa qualidade em vez de deixá-las puxar o score pra baixo.

A mudança de regex pra LLM no pattern detection foi pragmática. Padrões de fraude em linguagem natural são difíceis de capturar com regex. Falsos positivos demais. LLMs entendem contexto e intenção de um jeito que regex não consegue.

As race conditions apareceram quando o pipeline começou a rodar camadas em paralelo:

```
2e4276d - Fix race conditions across pipeline and add Brave Search rate limiting
ac433d9 - Fix WHOIS race condition and Brave Search gzip error logging
```

Jobs concorrentes tentando escrever no mesmo registro de email, consultas WHOIS pisando uma na outra, rate limits de APIs externas sendo estourados. O clássico "funciona no teste sequencial, quebra em produção".

A prevenção de alucinação dos LLMs mereceu um commit dedicado:

```
e08da9e - Prevent LLM hallucination in fraud reports
```

LLMs inventam coisas. Se o modelo diz "este domínio foi registrado ontem" sem evidência nos dados, o relatório fica comprometido. Esse commit implementou validação cruzada: claims dos LLMs são verificados contra os dados concretos das camadas determinísticas. Se o LLM afirma algo que contradiz os fatos, a informação é descartada ou sinalizada.

E quando o community reporting foi implementado:

```
a01d769 - Add community threat intelligence reporting
1b64eee - Harden community reporting against poisoning and add rate limiting
```

O primeiro commit implementa a funcionalidade. O segundo adiciona as proteções anti-envenenamento. Se um atacante percebe que o Frank FBI reporta automaticamente, ele pode tentar enviar emails que contenham IOCs de empresas legítimas como "fraude", fazendo o sistema reportar domínios inocentes pras bases comunitárias. Isso é IOC poisoning, e é um ataque real contra sistemas de threat intelligence.

### Hardening contínuo

```
9430c63 - Harden risky attachment analysis and warnings
bdc503d - Harden screenshot capture with failure recovery and pipeline timeout
125e73a - Separate suspect content from submitter signature in forwarded emails
6f7a522 - Handle forwarded message fidelity
```

Anexos maliciosos que poderiam explorar o parser. Screenshots de sites que poderiam travar o Chrome headless. Assinaturas do remetente que estavam sendo confundidas com conteúdo do email suspeito. Emails encaminhados que perdiam fidelidade no forward. Cada um desses resolve um vetor de ataque ou edge case diferente.

Segurança não é uma feature que você implementa uma vez. É um processo contínuo de "o que eu não pensei que poderia dar errado?"

## Os números

| Métrica | Valor |
|---------|-------|
| Commits | 38 |
| Horas de trabalho (~) | 17 |
| Linhas de Ruby | 14.616 |
| Arquivos Ruby | 161 |
| Código da aplicação (app/) | 8.217 linhas |
| Código de testes (test/) | 5.312 linhas |
| Ratio teste/código | 0.65 |
| Camadas de análise | 6 |
| Jobs assíncronos | 20 classes |
| Modelos de dados | 9 tabelas |
| Commits/hora | ~2.2 |
| Linhas/hora | ~860 |

860 linhas por hora. Obviamente desenvolvimento assistido por IA. Mas olha os commits de hardening: nenhum deles veio do LLM sugerindo "ei, vamos proteger contra spoofing". Fui eu que parei e pensei "espera, e se alguém spoofar o remetente autorizado?", "e se um atacante usar IOC poisoning contra o meu sistema de reporting?". Esse tipo de pergunta o LLM não faz sozinho. Ele implementa quando você pede, mas quem precisa perceber o buraco é você.

## Um aviso sério: NÃO ofereça isso como serviço

Se você olhou pro Frank FBI e pensou "legal, vou oferecer isso como SaaS pra outras pessoas", eu tenho um conselho: **NÃO faça isso**.

Eu consigo pensar em várias formas de explorar um serviço desses oferecido ao público. O operador teria acesso a todos os emails encaminhados pelos usuários -- informações pessoais, dados corporativos, correspondência sensível. Um serviço centralizado vira um alvo de alto valor: comprometa o servidor e você tem acesso a um fluxo contínuo de emails confidenciais de pessoas que já estão em situação vulnerável.

Eu conheço gente o suficiente pra saber que quem deployaria isso como serviço não ia se preocupar com criptografia em repouso nem com destruir os emails após análise. E quem garante que o operador não vai ler os emails dos usuários? Ninguém. É o tipo de coisa que parece um serviço útil mas na prática cria um honeypot de dados sensíveis gerenciado por alguém sem incentivo pra protegê-los.

O Frank FBI foi feito pra ser self-hosted. Pra rodar no seu servidor, sob seu controle, com seus dados ficando com você. Ou na infraestrutura da sua empresa, gerenciado pela sua equipe de TI.

E o projeto está licenciado sob AGPL-3.0. Se você usar meu código e oferecer como serviço de rede, você é obrigado por lei a abrir todo o código derivado. Sem exceções. Eu escolhi AGPL por esse motivo -- pra garantir que ninguém pegue o projeto, adicione tracking e telemetria, e ofereça como "serviço gratuito de verificação de email" enquanto coleta dados de usuários por baixo dos panos.

O [repositório está aqui](https://github.com/akitaonrails/frank_fbi). AGPL-3.0.
