---
title: Omarchy 2.0 - Bitwarden Self-Hosted / VaultWarden
date: "2025-09-10T20:00:00-03:00"
slug: omarchy-2-0-bitwarden-self-hosted-vaultwarden
tags:
  - homeserver
  - omarchy
  - bitwarden
  - vaultwarden 
  - aegis
  - docker
  - cloudflare
draft: false
---

Continuando a [série de Omarchy](/tags/omarchy) e fazendo cross-over com a série de [home server](/tags/homeserver), vamos falar sobre Gerenciador de Senhas e 2FA. Quem me acompanha que eu falo frequentemente sobre segurança digital pessoal, a importância de prestar atenção em links pra não cair em golpes, phishing, nem instalar malware sem querer.

Mais importante: ter uma senha forte, aleatória, exclusiva e diferente para **CADA** site, app ou serviço que usa. Nunca, jamais, reusar uma senha. Por que? Porque todo dia um desses sites é invadido e as senhas são vazadas. Se você procurar por você mesmo no site [Have I Been Pwned](https://haveibeenpwned.com/) certamente vai achar contas suas que já vazaram. E se você compartilha essa mesma senha com 10 outros sites, alguém já deve ter entrado na sua conta a essa altura.

Assista meu video sobre segurança:

<iframe width="560" height="315" src="https://www.youtube.com/embed/s7ldn31OEFc?si=qRZe05yPPyhmS1U4" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

Ter preguiça de usar um gerenciador de senhas é só uma desculpa idiota de gente preguiçosa. E um programador sequer tem direito de usar essa desculpa.

### Omarchy 1Password

Quem acompanha o DHH desde os primórdios de quando Macs eram a melhor plataforma pra desenvolvedores, lembra que ele sempre foi fã do 1Password, um dos que funcionava melhor em iPhones.

Eu migrei de volta pra Android e Linux muitos anos atrás, em 2015. Eu usava **1Password**, mas em Android o app era tenebroso de feio de ruim de usar. Por isso desisti dele e fiquei migrando entre vários outros apps. Seja Google Authenticator, seja Lastpass (que não recomendo).

Sei que tem diversos outros open source que as pessoas preferem, mas eu acabei caindo no Bitwarden, que é **BONITO** tanto em Android como a extension pra navegadores. Além disso ele tem componentes abertos e permite **self-hosting**.

Mais do que isso, ele não dificulta que você exporte todos os dados da sua conta e importe em outro lugar. Diferente de apps como o Twilio Authy, que te bloqueia de tudo e por isso deixei de usar.

Bitwarden tem gerador seguro de senhas aleatórias, tem suporte a **2FA TOTP**, dá pra armazenar anotações (tipo mini textos) seguras e muito mais. Os apps integram com biometria do celular, então é bem conveniente de usar.

Ainda mantenho meu Bitwarden dentro do [Secure Vault](https://www.samsung.com/global/sustainability/popup/popup_doc/AYUqoB6qDDMAIx_C/) da Samsung, o **Samsung Knox Vault**. Então são 2 níveis de segurança. E quando preciso andar em algum lugar suspeito, não levo meu celular principal, só um burner-phone sem nada de importante logado.

![Bitwarden Generator](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250910193713_bitwarden-generator.png)

Olhem como é bonito. Eu gosto dele e uso já faz alguns anos. Minhas senhas variam entre 21 a 42 caracteres aleatórios, um diferente pra cada site. Eu atualizei todas as senhas de tudo mais de uma vez nos últimos anos, e todas as contas tem 2FA/TOTP cadastrado no Bitwarden também, assim consegui sair do Authy.

### Instalando VaultWarden Self-Hosted

Mais importante, chegou a hora de hostear meu próprio servidor de Bitwarden, o [**vaultwarden**](https://github.com/dani-garcia/vaultwarden) que é uma alternativa open source, código aberto no GitHub, então você mesmo pode fuçar pra aprender ou até contribuir com ele. Novamente, subo tudo com Docker Compose no meu Home Server, então só precisei adicionar este trecho no meu arquivo:

```yaml
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    restart: unless-stopped
    environment:
      DOMAIN: "https://bitwarden.fabioakita.dev"
      SIGNUPS_ALLOWED: "false"          # set to true only to create first user
      WEBSOCKET_ENABLED: "true"
      ADMIN_TOKEN: "iA...Q9"  # for /admin
      # SMTP (recommended)
      SMTP_HOST: "smtp.gmail.com"
      SMTP_PORT: "587"
      SMTP_SECURITY: "starttls"
      SMTP_USERNAME: "boss@akitaonrails.com"
      SMTP_PASSWORD: "xxx"
      SMTP_FROM: "boss@akitaonrails.com"
    volumes:
      - /home/akitaonrails/vaultwarden/data:/data
    ports:
      - "9999:80"
    healthcheck:
      test: ["CMD", "wget", "-q", "-O", "-", "http://localhost/health"]
      interval: 30s
      timeout: 5s
      retries: 5
```

Importante:

- Crie um `ADMIN_TOKEN` longo e aleatório. Use o próprio Bitwarden pra isso, mantenha secreto.
- Mude `SIGNUPS_ALLOWED` pra `true` somente uma vez, entre no site local e crie sua nova conta. Depois mude no arquivo pra `false`, reinicie o container. Dessa forma ninguém mais poderá criar nenhuma nova conta.
- É recomendado configurar um GMAIL SMTP pra mandar emails de notificações. Pra isso precisa criar uma senha de aplicativo no Google.

Pra criar uma senha exclusivamente pro vaultwarden, acesse [Google App Passwords](https://myaccount.google.com//apppasswords) e gere uma nova senha secreta exclusiva:

![App Password](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250910194453_screenshot-2025-09-10_16-34-48.png)

Ele só vai mostrar essa senha uma única vez. Copie e cole direto no yaml do docker compose. Configurando e-mail bonitinho, toda vez que alguém fizer login, ele manda um e-mail notificando. Isso é bom pra ter certeza que não tem ninguém suspeito mexendo no seu servidor:

![notification](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250910201642_screenshot-2025-09-10_20-16-25.png)

Agora só preciso subir o container:

```bash
docker compose -f utils-docker-compose.yml up -d
```

### Roteando túnel do Cloudflared

Como já mostrei no [post de Cloudflared](https://akitaonrails.com/2025/09/09/acessando-meu-home-server-com-dominio-de-verdade/) agora quero poder acessar remotamente, via túnel seguro, usando uma URL pública como `https://bitwarden.fabioakita.dev`. Pra fazer isso temos que editar aquele arquivo `/etc/cloudflared/config.yml` e adicionar no final dele assim:

```yaml
  - hostname: bitwarden.fabioakita.dev
    service: http://192.168.0.200:9999
    originRequest:
      httpHostHeader: bitwarden.fabioakita.dev
      http2Origin: true
  - service: http_status:404
```

Depois temos que reiniciar o serviço e também adicionar a rota manualmente:

```bash
sudo cloudflared tunnel route dns homelab bitwarden.fabioakita.dev
sudo systemctl restart cloudflared
```

E pronto! Talvez demore até 5 minutos pros DNS sincronizarem e tudo mais, mas daí é só entrar no seu navegador e vai ver isto:

![VaultWarden Login](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250910194927_screenshot-2025-09-10_19-49-14.png)

Se aquele `SIGNUPS_ALLOWED` estiver `true` também vai ter um link pra "Criar nova conta". No meu caso eu já fiz isso e desliquei, então só tem login mesmo.

### Importando seus Dados

Antes de continuar, vamos abrir a extension do Bitwarden - que continua logado na versão cloud em bitwarden.com e exportar todos os meus dados:

![Export Vault](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250910195209_bitwarden-export.png)

Basta se autenticar, daí na barra inferior de ícones vai ter "Settings", depois "Vault Options" e, finalmente "Export vault". Deixe o padrão no formato JSON mesmo (vai ser um **JSON encriptado**) e faça download desse arquivo pra algum lugar seguro.

Agora podemos logar de volta na nossa versão self-hosted em `https://bitwarden.fabioakita.dev` e seguir pelo mesmo menu, mas escolher "Import":

![Import](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250910195410_screenshot-2025-09-10_19-53-56.png)

E pronto! Agora minha versão self-hosted está **idêntica** à versão cloud que vinha usando até agora.

### Logando no novo servidor self-hosted

Agora basta deslogar tanto do App mobile quanto da extension do navegador. Daí na tela de login vai ter a seguinte opção:

![Login self-hosted](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250910195632_bitwarden-login.png)

Na extension web a janela não deixa ver essa opção, use o scroll do mouse e scrole até o fim da janela e vai ter essa opção pequena. Escolha "self-hosted" e vai abrir uma janela pra digitar a URL `https://bitwarden.fabioakita.dev` e pronto!

A partir daqui o uso é exatamente o mesmo de antes. A interface é a mesma, as opções são as mesmas. Configure **biometria**, PIN, timeout pra lock e tudo mais pra deixar do jeito que você gosta.

Faça a mesma coisa no app mobile e pronto!

Nessa nova conta que criamos no servidor self-hosted, não esqueça de habilitar 2FA também, que é a opção "Authenticator App" em "Settings/Security":

![2FA](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250910200009_screenshot-2025-09-10_19-59-55.png)

Pra todas as outras contas, podemos registrar o 2FA dentro do Bitwarden. Mas pra conta master do próprio Bitwarden/Vaultwarden, precisamos usar um segundo app só pra isso.

Não sei se é o melhor, mas eu tenho gostado de usar o [Aegis Authenticator](https://getaegis.app/) no meu Android:

![Aegis](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250910203243_hero.7C782sEM.png)

É open source, o código está no [GitHub](https://github.com/beemdevelopment/aegis), então parece minimamente confiável. Também deixo ele dentro do Samsung Knox Vault. Só preciso dele quando preciso re-logar no Bitwarden/Vaultwarden. Pra logar nos Google, Steam ou qualquer outra conta, o 2FA de cada uma está dentro do Vaultwarden mesmo:

![2FA](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250910200449_2fa.png)

### Conclusão

Agora só faltou mesmo me logar com minha conta antiga em **bitwarden.com**, que é a versão "oficial" no cloud e deletar minha conta, pra garantir que ninguém mais tenha acesso.

![Deletar](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/20250910200615_screenshot-2025-09-10_20-06-04.png)

E pronto, **PERMANENTEMENTE APAGADO**! Não existe mais minhas contas num servidor qualquer que eu não controlo, mesmo que fosse encriptado.

Estou bem contente com esta solução. Agora meu Vaultwarden está num container, os dados do home server tem backup automático pro meu NAS, tudo é encriptado e só tem acesso via túnel seguro da Cloudflare. O risco é bem baixo e ninguém tem chance de ter acesso aos meus dados, porque eles não estão mais no "cloud".

Meus dados são somente meus.
