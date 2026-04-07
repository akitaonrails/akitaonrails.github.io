---
title: Protegendo seu Home Server com Cloudflare Zero Trust
date: "2025-09-10T02:00:00-03:00"
slug: protegendo-seu-home-server-com-cloudflare-zero-trust
tags:
  - homeserver
  - cloudflare
  - zero trust
  - google oauth
  - segurança
draft: false
translationKey: cloudflare-zero-trust-home-server
---

No [post anterior](https://akitaonrails.com/2025/09/09/acessando-meu-home-server-com-dominio-de-verdade/) explico como eu registrei um domínio de verdade na Cloudflare e criei túneis seguros encriptados que me permitem acessar até de fora de casa, sem precisar expor portas no roteador ou qualquer coisa assim.

Desta forma posso acessar `https://portainer.fabioakita.dev` (domínio falso de exemplo) do meu celular, por 5G, e vai acessar o container Docker do portainer, que está na minha LAN em `http://192.168.0.200:9000` e só era acessível em casa. Tudo via um túnel seguro.

Notem que estou o tempo todo falando que estou usando domínio e IPs falsos de exemplo nestes posts, porque não quero expor o domínio de verdade.

Só de estar atrás de um túnel seguro da Cloudflare, significa que estou embaixo de várias camadas de segurança como proteção contra ataques DDoS, e vários outros tipos de ataques conhecidos. E embora eu tome o cuidado de configurar cada serviço com uma senha forte e aleatória, diferente pra cada serviço, o risco não é zero que alguém possa encontrar meus serviços e tente quebrar a senha, ou use alguma vulnerabilidade zero-day em um dos diversos serviços, como Prowlarr ou Sonarr da vida.

Então eu fico à mercê desses bugs ainda não encontrados que podem surgir do nada, em particular na tela de login de cada um deles, ou endpoints de APIs.

Pra evitar esse risco, existe outro produto da Cloudflare que vale a pena configurar: o [**Zero Trust**](https://www.cloudflare.com/zero-trust/products/access/). A idéia é simples: **adicionar um novo login por cima de tudo**, da própria Cloudflare, pra proteger cada um dos serviços. Dessa forma, alguém precisa quebrar a própria Cloudflare antes de conseguir tentar quebrar um dos meus serviços.

### 1. Contratar o serviço

Essa é a parte fácil. Pra poucos serviços e poucos usuários (somente eu), existe um plano **gratuito**, só contratar:

![Free Plan](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-10_00-35-57.png)

### 2. Criar Credenciais OAuth no Google Cloud

Como eu pago Google Workspace, decidi usar login integrado com OAuth do Google, mas pode ser qualquer outro, você escolhe o que preferir. Pra isso preciso acessar meu [console do Google Cloud](https://console.cloud.google.com) e entrar na seção **API & Services**. Aqui criamos credenciais pra **OAuth client ID** e configuramos assim:

![Oauth client config](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-10_00-58-02.png)

O nome tanto faz, é o que vai aparecer na tela de login, o importante são os campos de **Javascript Origins** que tem que ser neste formato:

```
https://<your-team-name>.cloudflareaccess.com
```

E o campo de **redirect URIs** que é pra onde a tela de login do Google vai redirecionar, e tem que devolver pro nosso Cloudflare:

```
https://<your-team-name>.cloudflareaccess.com/cdn-cgi/access/callback
```

Feito isso, vai te dar a opção de baixar um arquivo **JSON** com os metadados e segredo. O importante é que no final ele vai te dar um **OAuth Client ID**, que é uma URL no formato `xxxxxx.apps.googleusercontent.com` e o mais importante, um **Client Secret**, que é bom guardar num BitWarden ou outro meio seguro.

### 4. Criando Login Method no Zero Trust

Agora voltamos pro console do Zero Trust na Cloudflare e clicamos em "Settings" no fim do menu, onde precisamos entrar em "Authentication" e criar um novo **Login Method**:

![Login Method](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-10_01-04-35.png)

Depois de clicar em "Add new" é só preencher com os dados que trouxemos do Google Cloud:

![New Google Login Method](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-10_01-07-17.png)

Novamente, coloque o nome que quiser e cole o OAuth Client ID como "App ID" e o Client Secret, e pronto, com isso temos Google OAuth integrado como método de login no nosso Zero Trust.

### 5. Criando Policies

Agora vem uma parte que eu não sei se fiz totalmente correto. Se não fiz, expliquem nos comentários abaixo!

Entendi que precisamos criar, pelo menos, duas **Policies** uma pra Service Auth e outra pro Email que quero permitir vindo do Google.

![Policies](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-10_01-09-06.png)

Pra continuar, só clicar em "Add a Policy" e editar a primeira policy:

![Service Token](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-10_01-10-42.png)

O nome, pode ser o qualquer coisa, o importante é que em "Action" escolha **"Service Auth"** e em "Add Rules" escolha **Any Access Service Token** (esta é a parte que eu acho que está errada, mas não achei outra opção melhor - não entendi bem como funciona Service Token).

Agora precisamos criar a segunda policy assim:

![Email Policy](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-10_01-20-47.png)

Desta vez o importante é term "Action" como "Allow" e adicionar a Rule "Emails" e escolher o email que você quer autenticar. No meu caso, somente eu.

### 6. Criando nova Applications

Agora podemos criar uma nova application no Zero Trust:

![Applications](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-10_01-22-51.png)

Clique em "Add an Application" e escolha type sendo **"Self-Hosted"**:

![Application Basic Information](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-10_01-26-20.png)

Entendi que cada application suporta no máximo 5 hostnames. Eu tenho bem mais que isso então vou ter que criar mais de uma application. A configuração em todas é a mesma. Em "Basic Information" só cadastrei os subdomínios de cada container que quero proteger.

![Policies](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-10_01-28-37.png)

Indo pra aba **"Policies"** basta clicar em "Select existing policies" e adicionar as duas policies que acabamos de criar. Só isso.

![Login Method](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-10_01-29-43.png)

Finalmente, em **"Login methods"** só escolher a do Google que acabamos de configurar também. E sim, estas são as telas de edição de uma application que eu já tinha criado. A tela de nova application tem tudo isso numa tela só, mas vocês entenderam.

E eu entendi que é só isso. Teoricamente já está tudo funcionando!

### 7. Testando o novo Login

Se nada der errado, basta acessar um dos hostnames que cadastramos na application do Zero Trust, por exemplo `https://immich.fabioakita.dev` e temos que receber esta tela primeiro:

![Zero Trust Login](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-10_01-33-41.png)

Se isso aparecer, sucesso! O Zero Trust impediu de acessar minha aplicação sem antes eu me logar nele.

Depois pode configurar o texto pra ficar como quiser, mas como é pra mim mesmo, tanto faz o texto de "bem vindo", na verdade, **ninguém é bem vindo aqui, somente EU!**

Clicando em "Google" vai abrir o Pop-up que todo mundo conhece de login do Google e só depois disso que eu consigo entrar no login da minha aplicação por baixo. E isso vale pra todos os hostnames que adicionei nas applications do Zero Trust.

![Google Sign In](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/userinter.png)

Uma vez que fizer login no Google com o usuário correto, a sessão vai ficar válida por 24 horas (que é o que configuramos nas policies e application). Nesse período não precisa mais fazer login no Zero Trust em nenhuma das outras aplicações do meu home server. A sessão é a mesma pra todas as applications.

### 8. Deslogando Sessões

Depois que fizer o primeiro login com seu usuário, dá pra controlar essa sessão indo no menu "My team" e "Users":

![Users](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-10_01-38-38.png)

Clicando no usuário, temos várias informações e opções, em particular veja **"Revoke Sessions"**.

![Revoke](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-10_01-40-31.png)

Desta forma podemos testar o login sem precisar esperar 24 horas até o token de autenticação expirar com o tempo. É uma forma de forçar o logout dos seus usuários. No plano gratuito do Zero Trust, entendi que dá pra ter até 10 usuários na sua organização.

### Conclusão

Eu nunca tinha usado Zero Trust, então pode ser que tenha cometido algum erro no procedimento, então leiam a documentação também. Em princípio, parece que está funcionando. Já criei mais applications e cadastrei o resto dos meus hostnames,

Só de usar CloudflareD pra túneis encriptados, todo tráfego que chega no meu home server passa por uma série de proteções da Cloudflare que incluem: DDoS protection, URL normalization, Origin Rules, IP Address Rules, WAF (Web Application Firewall), Bots Mitigation, Rate Limiting, Cache, Compression e mais.

Essas camadas protegem contra os principais tipos de ataques conhecidos e eles estão sempre adicionando novas regras a cada nova vulnerabilidade que fica conhecida. Mesmo que você, como desenvolvedor, não saiba como se proteger de tudo na sua aplicação, existe a chance da Cloudflare te proteger antes. Por isso recomendo deixar seus domínios sempre sob controle da Cloudflare.

Em cima disso tudo, ainda adicionamos **Zero Trust**, que garante que só depois de um login com minha conta do Google é que ele vai começar a permitir acesso pra baixo. E no final disso ainda tem a última barreira que são os logins de cada aplicação independente rodando no meu home server.

Além disso, no dashboard da Cloudflare tem monitoramento do tráfego, analytics e muito mais. Eu configurei só o básico, mas se quiser ir mais a fundo, tem várias policies e regras extras que podem ser adicionadas.

![Analytics](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/screenshot-2025-09-10_01-53-58.png)

Pra alguém conseguir atravessar tudo isso e conseguir invadir meu home server e minha LAN, realmente precisa ser alguém muito dedicado e muito inteligente - não acredito que exista alguém assim perdendo tanto tempo pra acessar um servidor de videos 🤣 mas podem tentar.
