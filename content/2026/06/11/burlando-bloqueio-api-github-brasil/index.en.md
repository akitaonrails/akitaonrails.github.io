---
title: "Bypassing the GitHub API Block in Brazil"
slug: "bypassing-github-api-block-brazil"
date: '2026-06-11T20:00:00-03:00'
draft: false
translationKey: burlando-bloqueio-api-github-brasil
tags:
  - github
  - brazil
  - censorship
  - anatel
  - networking
  - linux
  - opensource
---

This is a Brazil problem today. It may be your problem tomorrow if you live under a government that likes silent network blocks, copyright panic, opaque court orders, or any other flavor of "trust us, we know what we are doing." The concrete symptom here is simple: `api.github.com` started timing out in Brazil. The main `github.com` site opens. SSH clones may keep working. But tools that depend on the GitHub API, like `gh`, CI automations, personal scripts, bots, CLIs, dashboards, and anything that queries issues and pull requests, start hanging.

[Ayub posted on X](https://x.com/ayubio/status/2064878070394183955) that this has all the usual signs of a national block ordered by Anatel against `api.github.com`. In that same context, the tweet he quoted showed `api.github.com` resolving to `4.228.31.149`, but with no working route. The author said he tested through VIVO, Claro, and Oracle, and that it only worked through a Miami VPN. In other words: this does not look like "my Wi-Fi is down." It looks like a block somewhere in the path.

According to Ayub, this kind of thing often happens in blocking waves, many times after Wednesday meetings with large carriers, inside the Brazilian mechanism for blocking addresses under the excuse of fighting piracy. The problem is the blast radius: instead of taking down only the target, it breaks legitimate infrastructure. Today it was the GitHub API. Tomorrow it can be anything your work depends on.

And yes, I confirmed it from here.

## How to know if you were affected

First, test whether the main site opens:

```bash
curl -4 -I --connect-timeout 8 --max-time 12 https://github.com/
```

Here it worked. Then test the API:

```bash
curl -4 -I --connect-timeout 8 --max-time 12 https://api.github.com/
```

Here I got:

```text
curl: (28) Connection timed out after 8002 milliseconds
```

Now check which IP your system resolves:

```bash
getent ahostsv4 api.github.com
```

In my case:

```text
4.228.31.149    STREAM api.github.com
4.228.31.149    DGRAM
4.228.31.149    RAW
```

And `gh` depends on this API too. So commands like these may hang:

```bash
gh api rate_limit
gh pr list
gh issue list
```

If you are a developer and suddenly `gh` stopped, your release scripts stopped, your PR-listing bot stopped, or some CLI that queries issues started hanging, this may be it. It is not your bug. Your route to `api.github.com` is being thrown into a hole.

## First try DNS 9.9.9.9

Some people mentioned that changing DNS to [Quad9](https://www.quad9.net/), `9.9.9.9`, could work around it. It makes sense to test, because some blocks are done through DNS: the provider returns the wrong IP, NXDOMAIN, or sends you into a sinkhole. If the problem is only your provider's DNS, changing DNS fixes it.

Test without changing anything in the system:

```bash
dig @9.9.9.9 +short api.github.com A
```

In my case, it did not help. Quad9 also returned:

```text
4.228.31.149
```

And forcing that IP in `curl` still timed out:

```bash
curl -4 -I --connect-timeout 8 --max-time 12 \
  --resolve api.github.com:443:4.228.31.149 \
  https://api.github.com/
```

Result:

```text
curl: (28) Connection timed out after 8002 milliseconds
```

So, on my link, 9.9.9.9 did not fix it. But test yours. If your provider is only poisoning DNS, it may work.

On Arch with NetworkManager, it would be something like this:

```bash
sudo pacman -S bind-tools curl

nmcli con show --active
sudo nmcli con mod "YOUR CONNECTION NAME" \
  ipv4.ignore-auto-dns yes \
  ipv4.dns "9.9.9.9 149.112.112.112"
sudo nmcli con down "YOUR CONNECTION NAME"
sudo nmcli con up "YOUR CONNECTION NAME"
```

On Ubuntu, same idea. Install the tools and adjust through NetworkManager:

```bash
sudo apt install dnsutils curl
nmcli con show --active
```

Or use the GNOME/KDE network settings screen and set manual DNS to `9.9.9.9` and `149.112.112.112` for the connection. Then disconnect and reconnect.

Test again:

```bash
dig +short api.github.com A
curl -4 -I --connect-timeout 8 --max-time 12 https://api.github.com/
```

If it works, good. You are done here.

If it keeps timing out, DNS was only the first layer. Then you need to route the connection through another path.

## Why I do not like the fixed-IP hack

Another suggestion I saw was manually adding IPs to local DNS, like Pi-hole, Unbound, `/etc/hosts`, dnsmasq, that sort of thing. Example: "resolve `api.github.com` to this other IP that works."

That can work for a few hours. I don't like it.

GitHub is large infrastructure. IPs change. Routes change. Load balancing changes. Regions change. The IP that works for somebody in Miami may be bad for you in São Paulo. The IP that works today may fail tomorrow. And if the block is a blackhole route at the provider, changing DNS to another IP may only trade one hole for another.

Pi-hole is great for a home network. Unbound is great. `/etc/hosts` saves you in an emergency. But pinning the IP of a large service like GitHub is how you forget an invisible hack and lose two hours next month trying to understand why only your machine is broken.

Use alternate DNS as a test. Use fixed IP only as a temporary bandage and document where you changed it.

## Fallback: SOCKS proxy only for GitHub tools

My solution was the least invasive thing I could make: a wrapper that starts a local SOCKS proxy through Tor and runs only the command I choose through it. It does not route the whole system. It does not touch the browser. It does not affect package managers, Steam, banking, nothing. Just `gh`, or whatever tool I explicitly call.

In my case, the wrapper lives at `~/.config/zsh/bin/github-proxy`, and the alias in `~/.config/zsh/aliases` does this:

```bash
alias gh='$HOME/.config/zsh/bin/github-proxy gh'
```

The wrapper is this:

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

Notice `socks5h`. That `h` matters. It makes DNS resolution happen through the proxy, not through your local network. If you use plain `socks5://`, depending on the library, DNS may still happen locally before the proxy is used. With `socks5h://`, the idea is: "take the hostname to the other side and resolve it there."

## Installing on Arch

On Arch:

```bash
sudo pacman -S tor github-cli iproute2
mkdir -p ~/.local/bin
```

Create the script:

```bash
nano ~/.local/bin/github-proxy
```

Paste the wrapper above and make it executable:

```bash
chmod +x ~/.local/bin/github-proxy
```

Test it directly:

```bash
~/.local/bin/github-proxy gh api rate_limit --jq .resources.core.limit
```

An authenticated account usually returns:

```text
5000
```

That is what happened here. Direct timed out. Through the wrapper, `gh api rate_limit --jq .resources.core.limit` returned `5000`.

Now add an alias to your shell.

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

Test:

```bash
gh api rate_limit --jq .resources.core.limit
gh pr list
```

## Ubuntu

On Ubuntu, the Tor package is easy:

```bash
sudo apt update
sudo apt install tor iproute2 curl
```

For GitHub CLI, if the `gh` package is available in your version:

```bash
sudo apt install gh
```

If it is not, follow the official GitHub CLI installation for Ubuntu/Debian. The rest is the same: create `~/.local/bin/github-proxy`, run `chmod +x`, and put the alias in `.bashrc` or `.zshrc`.

## Better alternatives than Tor

Tor worked and it is convenient, but it is not the only option. Sometimes it is slow. Sometimes a service dislikes Tor exits. For `gh api` and listing PRs, fine. For heavier use, you may want something more predictable.

Reasonable options:

- Normal VPN: Proton, Mullvad, IVPN, your own WireGuard. Route everything or use split tunneling if you know how to configure it.
- Tailscale with an exit node outside Brazil: clean, if you have a trusted machine outside the country or a VPS.
- SSH SOCKS to a VPS: `ssh -N -D 127.0.0.1:9050 user@your-vps`. Then use the same `HTTPS_PROXY=socks5h://127.0.0.1:9050`.
- Corporate proxy: if your company has egress outside Brazil, configure only the tools that need it.

The care here is not changing everything at the same time. First prove that direct `api.github.com` fails. Then prove that another path works. Only then automate.

## Adjusting your own tools: ghpending

This block also hit one of my utilities: [ghpending](https://github.com/akitaonrails/ghpending). I already wrote about it in ["I Built a CLI to Check My GitHub Pending Stuff: ghpending"](/en/2026/05/23/i-built-a-cli-to-check-my-github-pending-stuff-ghpending/). It lists open issues and pull requests across my repositories, so I know where somebody is waiting for an answer.

The problem is obvious: it uses the GitHub API. If `api.github.com` falls into a hole, it falls with it.

So I added a proxy fallback. `ghpending` now reads `GITHUB_TOKEN` like before, but also tries to use a SOCKS proxy in this order:

1. `GHPENDING_GITHUB_PROXY`, if you want to force a specific proxy.
2. `HTTPS_PROXY`, `https_proxy`, `ALL_PROXY`, or `all_proxy`, if they are `socks5://` or `socks5h://`.
3. A local SOCKS proxy at `127.0.0.1:9050`, if one is listening.
4. If none of that exists, it tries direct access.

In the README, it looks like this:

```bash
GITHUB_TOKEN=$(gh auth token) ghpending
```

And for proxy:

```bash
GHPENDING_GITHUB_PROXY=socks5h://127.0.0.1:9050 ghpending
```

Or just run it through the wrapper:

```bash
~/.local/bin/github-proxy ghpending
```

My wrapper starts Tor on `127.0.0.1:9050`; `ghpending` detects that proxy and uses it for API calls. If you are not blocked, it keeps working directly. If you are blocked, it has an escape route.

This is the kind of fallback every Brazilian dev should now consider for tools that depend on foreign APIs. It is ugly, but the Brazilian internet is getting unpredictable.

## The political problem

At the end of the thread, [Ayub reminded everyone](https://x.com/ayubio/status/2064880160893968643) that, because of these secret collateral blocks and their side effects, there would already be around 250 million addresses blocked on the Brazilian internet. He also linked a presentation about the state of blocking in Brazil. In another tweet in the same thread, he says authorities defend secrecy as the only alternative left to fight crime.

I do not buy that excuse.

Secret blocking of critical infrastructure, with no transparency, no public adversarial process, no auditable list, no explanation of scope, is operational censorship. In my read, it is illegal precisely because it dodges the public, auditable process that should exist when the State orders internet access to be broken. Maybe it started with pirate TV boxes. Maybe the speech sounds noble. But the mechanism is there: somebody presses a button, carriers apply the block, legitimate users only find out when a work tool stops.

Today, the collateral damage hit honest developers trying to work with GitHub. Tomorrow it hits a Linux package, a container registry, a CDN, a payment API, an authentication service. Then everybody runs to VPNs, Tor, proxies, alternate DNS, `/etc/hosts`, Pi-hole. Congratulations: little by little, we are rebuilding the survival manual for a censored internet.

No need to overdo the metaphor. Brazil is not China yet. But the smell is the same: centralized opaque blocking, collateral damage, and ordinary users having to learn bypasses to work.

If you were affected, document it. Run the commands. Save outputs. Open an issue with your provider. Complain with data. Share workarounds, but do not normalize this. A bypass is a bandage. The real problem is a State giving itself the power to silently break pieces of the internet.

And if all you wanted was to run `gh pr list` to review a pull request: welcome to Brazilian infrastructure in 2026.
