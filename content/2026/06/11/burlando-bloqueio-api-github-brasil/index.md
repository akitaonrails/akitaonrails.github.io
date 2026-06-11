---
title: "Burlando o bloqueio à API do GitHub no Brasil"
date: '2026-06-11T20:00:00-03:00'
draft: false
translationKey: burlando-bloqueio-api-github-brasil
tags:
  - github
  - brasil
  - censura
  - anatel
  - redes
  - linux
  - opensource
---

Hoje apareceu um problema daqueles que parecem piada, mas não são: `api.github.com` começou a dar timeout no Brasil. O site `github.com` abre. Clonar via SSH pode continuar funcionando. Mas as ferramentas que dependem da API do GitHub, como `gh`, automações de CI, scripts pessoais, bots, CLIs, dashboards e tudo que consulta issues e pull requests, começam a travar.

O [Ayub comentou no X](https://x.com/ayubio/status/2064878070394183955) que há todos os indícios típicos de bloqueio nacional determinado pela Anatel contra `api.github.com`. No mesmo contexto, o tweet citado por ele mostrava `api.github.com` resolvendo para `4.228.31.149`, mas sem rota funcionando. O autor dizia ter testado por VIVO, Claro e Oracle, e que só funcionava via VPN de Miami. Ou seja: não parece "meu Wi-Fi caiu". Parece bloqueio no caminho.

Segundo o Ayub, esse tipo de coisa costuma acontecer em ondas de bloqueios, muitas vezes em reuniões de quarta-feira com grandes operadoras, dentro desse mecanismo brasileiro de bloquear endereços sob pretexto de combater pirataria. O problema é o efeito colateral: em vez de derrubar só o alvo, derruba pedaço legítimo de infraestrutura. Hoje foi a API do GitHub. Amanhã pode ser qualquer outra coisa que seu trabalho depende.

E sim, eu confirmei daqui.

## Como saber se você foi afetado

Primeiro, teste se o site principal abre:

```bash
curl -4 -I --connect-timeout 8 --max-time 12 https://github.com/
```

Aqui funcionou. Depois teste a API:

```bash
curl -4 -I --connect-timeout 8 --max-time 12 https://api.github.com/
```

Aqui deu:

```text
curl: (28) Connection timed out after 8002 milliseconds
```

Agora veja pra qual IP seu sistema está resolvendo:

```bash
getent ahostsv4 api.github.com
```

No meu caso:

```text
4.228.31.149    STREAM api.github.com
4.228.31.149    DGRAM
4.228.31.149    RAW
```

E o `gh` também depende dessa API. Então comandos como estes podem travar:

```bash
gh api rate_limit
gh pr list
gh issue list
```

Se você é desenvolvedor e de repente `gh` parou, seus scripts de release pararam, seu bot que lista PRs parou, ou aquele CLI que consulta issues começou a ficar pendurado, pode ser isso. Não é bug seu. É a sua rota até `api.github.com` sendo jogada no buraco.

## Primeiro tente DNS 9.9.9.9

Algumas pessoas comentaram que trocar o DNS para [Quad9](https://www.quad9.net/), `9.9.9.9`, poderia contornar. Faz sentido testar, porque alguns bloqueios são feitos via DNS: o provedor responde um IP errado, NXDOMAIN, ou manda para um buraco. Se o problema for só o DNS do seu provedor, trocar de DNS resolve.

Teste sem mudar nada no sistema:

```bash
dig @9.9.9.9 +short api.github.com A
```

No meu caso, não resolveu. O Quad9 também retornou:

```text
4.228.31.149
```

E forçar esse IP no `curl` continuou dando timeout:

```bash
curl -4 -I --connect-timeout 8 --max-time 12 \
  --resolve api.github.com:443:4.228.31.149 \
  https://api.github.com/
```

Resultado:

```text
curl: (28) Connection timed out after 8002 milliseconds
```

Então, no meu link, 9.9.9.9 não resolveu. Mas teste no seu. Se o seu provedor está apenas envenenando DNS, pode funcionar.

No Arch com NetworkManager, seria algo assim:

```bash
sudo pacman -S bind-tools curl

nmcli con show --active
sudo nmcli con mod "NOME DA SUA CONEXÃO" \
  ipv4.ignore-auto-dns yes \
  ipv4.dns "9.9.9.9 149.112.112.112"
sudo nmcli con down "NOME DA SUA CONEXÃO"
sudo nmcli con up "NOME DA SUA CONEXÃO"
```

No Ubuntu, a ideia é a mesma. Instale as ferramentas e ajuste pelo NetworkManager:

```bash
sudo apt install dnsutils curl
nmcli con show --active
```

Ou use a tela de rede do GNOME/KDE e coloque DNS manual `9.9.9.9` e `149.112.112.112` na conexão. Depois desconecte e conecte de novo.

Teste de novo:

```bash
dig +short api.github.com A
curl -4 -I --connect-timeout 8 --max-time 12 https://api.github.com/
```

Se funcionar, ótimo. Você terminou aqui.

Se continuar dando timeout, o bloqueio não está só no DNS. Aí precisa rotear a conexão por outro caminho.

## Por que eu não gosto da gambiarra de IP fixo

Outra sugestão que vi foi colocar IPs manualmente no DNS local, tipo Pi-hole, Unbound, `/etc/hosts`, dnsmasq, essas coisas. Exemplo: "resolve `api.github.com` pra tal IP que funciona".

Isso pode funcionar por algumas horas. Eu não gosto.

GitHub é infraestrutura grande. IP muda. Rota muda. Balanceamento muda. Região muda. O IP que funciona pra uma pessoa em Miami pode ser ruim pra você em São Paulo. O IP que funciona hoje pode cair amanhã. E se o bloqueio for por rota blackhole no provedor, trocar DNS para outro IP pode só trocar um buraco por outro.

Pi-hole é ótimo pra rede doméstica. Unbound é ótimo. `/etc/hosts` salva em emergência. Mas fixar IP de serviço grande como GitHub é pedir pra esquecer uma gambiarra invisível e perder duas horas daqui a um mês tentando entender por que só a sua máquina não funciona.

Use DNS alternativo como teste. Use IP fixo só como curativo temporário e documente onde mexeu.

## Fallback: proxy SOCKS só para ferramentas do GitHub

Minha solução foi fazer o mínimo invasivo: um wrapper que sobe um SOCKS local via Tor e executa só o comando que eu quero por ele. Não roteia o sistema inteiro. Não mexe no navegador. Não altera pacote, Steam, banco, nada. Só `gh`, ou qualquer ferramenta que eu chamar explicitamente.

No meu caso, o wrapper está em `~/.config/zsh/bin/github-proxy` e o alias em `~/.config/zsh/aliases` faz:

```bash
alias gh='$HOME/.config/zsh/bin/github-proxy gh'
```

O wrapper é este:

```bash
#!/bin/bash
set -euo pipefail

proxy_host="127.0.0.1"
proxy_port="9050"
tor_dir="${XDG_RUNTIME_DIR:-/tmp}/github-proxy-tor"
tor_rc="$tor_dir/torrc"
tor_log="$tor_dir/tor.log"

if [[ $# -eq 0 ]]; then
  echo "usage: github-proxy <command> [args...]" >&2
  exit 2
fi

if ! ss -ltn "sport = :$proxy_port" | grep -q "$proxy_host:$proxy_port"; then
  mkdir -p "$tor_dir"
  : >"$tor_rc"
  tor -f "$tor_rc" --SocksPort "$proxy_host:$proxy_port" --DataDirectory "$tor_dir/data" >"$tor_log" 2>&1 &

  for _ in {1..60}; do
    if grep -q 'Bootstrapped 100%' "$tor_log"; then
      break
    fi
    if ! kill -0 "$!" 2>/dev/null; then
      echo "github-proxy: tor exited before bootstrap; see $tor_log" >&2
      exit 1
    fi
    sleep 1
  done

  if ! grep -q 'Bootstrapped 100%' "$tor_log"; then
    echo "github-proxy: timed out waiting for tor bootstrap; see $tor_log" >&2
    exit 1
  fi
fi

export HTTPS_PROXY="socks5h://$proxy_host:$proxy_port"
export HTTP_PROXY="socks5h://$proxy_host:$proxy_port"
export ALL_PROXY="socks5h://$proxy_host:$proxy_port"

exec "$@"
```

Repare no `socks5h`. Esse `h` importa. Ele faz a resolução DNS pelo proxy, não pela sua rede local. Se você usa `socks5://` normal, dependendo da biblioteca, o DNS ainda pode acontecer localmente antes de passar pelo proxy. Com `socks5h://`, a ideia é: "leva o hostname até o outro lado e resolve lá".

## Instalando no Arch

No Arch:

```bash
sudo pacman -S tor github-cli iproute2
mkdir -p ~/.local/bin
```

Crie o script:

```bash
nano ~/.local/bin/github-proxy
```

Cole o wrapper acima e dê permissão:

```bash
chmod +x ~/.local/bin/github-proxy
```

Teste direto:

```bash
~/.local/bin/github-proxy gh api rate_limit --jq .resources.core.limit
```

Conta autenticada normalmente retorna:

```text
5000
```

Foi o que aconteceu aqui. Direto dava timeout. Pelo wrapper, `gh api rate_limit --jq .resources.core.limit` retornou `5000`.

Agora adicione um alias no seu shell.

ZSH:

```bash
echo "alias gh='$HOME/.local/bin/github-proxy gh'" >> ~/.zshrc
source ~/.zshrc
```

Bash:

```bash
echo "alias gh='$HOME/.local/bin/github-proxy gh'" >> ~/.bashrc
source ~/.bashrc
```

Teste:

```bash
gh api rate_limit --jq .resources.core.limit
gh pr list
```

## Ubuntu

No Ubuntu, o pacote do Tor é fácil:

```bash
sudo apt update
sudo apt install tor iproute2 curl
```

Para o GitHub CLI, se o pacote `gh` estiver disponível na sua versão:

```bash
sudo apt install gh
```

Se não estiver, siga a instalação oficial do GitHub CLI para Ubuntu/Debian. O resto é igual: crie `~/.local/bin/github-proxy`, dê `chmod +x`, e coloque o alias no `.bashrc` ou `.zshrc`.

## Alternativas melhores que Tor

Tor funcionou e é conveniente, mas não é a única opção. Às vezes é lento. Às vezes algum serviço encrenca com saída Tor. Para `gh api` e listar PR, tudo bem. Para uso pesado, talvez você queira algo mais previsível.

Opções razoáveis:

- VPN normal: Proton, Mullvad, IVPN, WireGuard próprio. Roteia tudo ou usa split tunneling se você souber configurar.
- Tailscale com exit node fora do Brasil: limpo, se você tiver uma máquina confiável fora ou uma VPS.
- SSH SOCKS para uma VPS: `ssh -N -D 127.0.0.1:9050 usuario@seu-vps`. Depois use o mesmo `HTTPS_PROXY=socks5h://127.0.0.1:9050`.
- Proxy corporativo: se sua empresa tem saída fora do Brasil, configure só as ferramentas que precisam.

O cuidado aqui é não sair mexendo em tudo ao mesmo tempo. Primeiro prove que `api.github.com` direto falha. Depois prove que via outro caminho funciona. Só então automatize.

## Ajustando ferramentas próprias: ghpending

Esse bloqueio me pegou também num utilitário meu: [ghpending](https://github.com/akitaonrails/ghpending). Eu já falei dele no post ["Criei um CLI pra Checar Pendências no Meu GitHub: ghpending"](/2026/05/23/criei-cli-pra-checar-pendencias-github-ghpending/). Ele lista issues e pull requests abertos nos meus repositórios, pra eu saber onde tem gente esperando resposta.

O problema é óbvio: ele usa a API do GitHub. Se `api.github.com` cai no buraco, ele cai junto.

Então adicionei fallback de proxy. O `ghpending` agora lê `GITHUB_TOKEN` como antes, mas também tenta usar proxy SOCKS nesta ordem:

1. `GHPENDING_GITHUB_PROXY`, se você quiser forçar um proxy específico.
2. `HTTPS_PROXY`, `https_proxy`, `ALL_PROXY` ou `all_proxy`, se forem `socks5://` ou `socks5h://`.
3. Um SOCKS local em `127.0.0.1:9050`, se estiver escutando.
4. Se nada disso existir, tenta direto.

No README ficou assim:

```bash
GITHUB_TOKEN=$(gh auth token) ghpending
```

E, para proxy:

```bash
GHPENDING_GITHUB_PROXY=socks5h://127.0.0.1:9050 ghpending
```

Ou simplesmente rode pelo wrapper:

```bash
~/.local/bin/github-proxy ghpending
```

Meu wrapper sobe Tor em `127.0.0.1:9050`; o `ghpending` detecta esse proxy e usa para chamadas à API. Se você não está bloqueado, ele continua funcionando direto. Se você está bloqueado, ele tem um caminho de fuga.

Isso é o tipo de fallback que agora todo dev brasileiro deveria considerar para ferramenta que depende de API estrangeira. Não porque é bonito. Porque a internet brasileira está ficando imprevisível.

## O problema político

No fim da thread, o [Ayub lembrou](https://x.com/ayubio/status/2064880160893968643) que, por causa desses bloqueios colaterais sigilosos, já haveria cerca de 250 milhões de endereços bloqueados na internet brasileira. Ele também linkou uma apresentação sobre o panorama dos bloqueios no Brasil. Em outro tweet do mesmo fio, ele diz que autoridades defendem sigilo como única alternativa para combater crimes.

Eu não compro essa desculpa.

Bloqueio sigiloso de infraestrutura crítica, sem transparência, sem contraditório público, sem lista auditável, sem explicação de escopo, é censura operacional. Na minha leitura, é ilegal justamente por fugir do rito público e auditável que deveria existir quando o Estado manda quebrar acesso à internet. Pode ter começado com pirataria de TV box. Pode ter discurso bonito. Mas o mecanismo está aí: alguém aperta botão, operadoras aplicam bloqueio, usuários legítimos descobrem só quando ferramenta de trabalho para.

Hoje, o efeito colateral bateu em desenvolvedor honesto tentando trabalhar com GitHub. Amanhã bate em pacote de Linux, registry de container, CDN, API de pagamento, serviço de autenticação. Aí todo mundo corre pra VPN, Tor, proxy, DNS alternativo, `/etc/hosts`, Pi-hole. Parabéns: estamos recriando, aos poucos, o manual de sobrevivência de uma internet censurada.

Não precisa exagerar na metáfora. Ainda não somos a China. Mas o cheiro é o mesmo: bloqueio centralizado, opaco, com dano colateral, e usuário comum tendo que aprender bypass pra trabalhar.

Se você foi afetado, documente. Rode os comandos. Salve outputs. Abra issue no seu provedor. Reclame com dados. Compartilhe workaround, mas não normalize. Bypass é curativo. O problema real é um Estado que se dá o poder de quebrar pedaços da internet em silêncio.

E se você só queria rodar `gh pr list` pra revisar um pull request: bem-vindo à infraestrutura brasileira de 2026.
