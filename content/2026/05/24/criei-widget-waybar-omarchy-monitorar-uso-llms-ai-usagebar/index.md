---
title: "Criei um Widget de Waybar pra Omarchy pra Monitorar Uso de Planos de LLM: ai-usagebar"
slug: "criei-widget-waybar-omarchy-monitorar-uso-llms-ai-usagebar"
date: '2026-05-24T00:01:00-03:00'
draft: false
translationKey: criei-widget-waybar-omarchy-monitorar-uso-llms-ai-usagebar
description: "O ai-usagebar, port do claudebar para Rust, reúne Claude, Codex, Z.AI e OpenRouter num widget Waybar ou numa TUI standalone que funciona em qualquer terminal, inclusive via SSH."
tags:
- ai-usagebar
- omarchy
- ferramentas-de-desenvolvimento
- llms
---

Quem acompanha o blog já sabe que eu uso um monte de vendor de LLM diferente. Os principais são Claude e GPT, via Claude Code e Codex. Eu uso o harness de cada um porque estou preso aos planos de assinatura deles (Pro, Plus, Max), que saem muito mais baratos do que pagar crédito por token tipo OpenRouter. Mesmo assim, também uso OpenRouter pra acessar outros modelos pra teste, e tenho até uma assinatura Z.AI GLM pra coisas pequenas.

O problema de ter vários planos é acompanhar quanto já gastei de cada um. Eu vinha usando o [claudebar](https://github.com/mryll/claudebar), um widget de Waybar que mostra o uso do plano da Anthropic. Gosto dele, mas queria ver todos os meus vendors num lugar só, pra bater o olho e saber onde estou. E não queria encher minha Waybar de widget separado pra cada vendor. Então resolvi fazer o meu: o **[ai-usagebar](https://github.com/akitaonrails/ai-usagebar)**.

![Widget na Waybar mostrando "cld 29% · 1h 12m" no canto superior direito, com tooltip aberto exibindo o plano Claude Max 20x: Session 29%, Weekly 47%, Sonnet only 0%, Extra usage $0.00 sobre limite de $1100, e horário da última atualização.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/24/ai-usagebar/ai-usagebar-waybar.png)

É um port em Rust do claudebar, drop-in compatível, estendido pra quatro vendors: Anthropic Claude, OpenAI Codex/ChatGPT, Z.AI (GLM) e OpenRouter. Mantém os mesmos parâmetros (`--icon`, `--format`, `--tooltip-format`, etc.), o mesmo tooltip minimalista com borda Pango, e a mesma auto-detecção do tema do Omarchy. A diferença é que agora os quatro vendors aparecem no mesmo lugar, em vez de 865 linhas de bash cuidando de um só.

## Como ele autentica em cada vendor

Essa é a parte que vale explicar, porque cada vendor faz diferente. Claude e Codex usam OAuth: os CLIs oficiais (`claude` e `codex`) já escreveram as credenciais no disco quando você logou, e o ai-usagebar lê esses mesmos arquivos. Não precisa de variável de ambiente nenhuma, o token até se renova sozinho.

Z.AI e OpenRouter usam API key, então pra esses você precisa setar uma chave (via env var ou inline no config).

| Vendor | Método | O que você precisa fazer |
|---|---|---|
| Anthropic | OAuth, lê de `~/.claude/.credentials.json` | Roda `claude` uma vez pra logar. Token renova sozinho. |
| OpenAI | OAuth, lê de `~/.codex/auth.json` | Roda `codex login` uma vez. Token renova sozinho. |
| Z.AI | API key (`ZAI_API_KEY` ou `[zai] api_key` no config) | Seta uma das duas. |
| OpenRouter | API key (`OPENROUTER_API_KEY` ou `[openrouter] api_key`) | Seta uma das duas. |

## A interface além da Waybar

Além do widget na barra, tem uma TUI com abas (`ai-usagebar-tui`) pra ver tudo de uma vez. Navega com Tab / h / l entre os vendors, atualiza a cada 60s. Dá pra abrir clicando no widget da Waybar, ou rodar direto no terminal (mais sobre isso na próxima seção).

A aba do OpenRouter mostra saldo de crédito, gasto de hoje / semana / mês e o tier:

![ai-usagebar-tui na aba OpenRouter: gauge de saldo de crédito em 98% em vermelho ($13.67 restante de $900), bloco de uso por período (hoje/semana/mês), tier pago.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/24/ai-usagebar/ai-usagebar-tui-openrouter.png)

E tem um overlay de settings pra escolher o vendor primário e colar as API keys sem editar o config na mão:

![Overlay de settings flutuando sobre a TUI: radio de vendor primário (Anthropic selecionado), API key da Z.AI mascarada (•••), API key do OpenRouter mascarada (•••), botão Save, atalhos no rodapé.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/24/ai-usagebar/ai-usagebar-tui-settings.png)

## Não usa Omarchy nem Hyprland? Roda como TUI standalone

O widget de Waybar é opcional. Os dois binários são independentes, então se você não usa Omarchy, nem Hyprland, nem Waybar (ou simplesmente prefere checar o uso de vez em quando em vez de ter na barra o tempo todo), o `ai-usagebar-tui` funciona como app de terminal totalmente standalone:

```bash
ai-usagebar-tui    # abre no seu terminal atual
```

Roda em qualquer emulador de terminal (Kitty, Alacritty, Foot, Ghostty, etc.), funciona até numa sessão SSH pura, e não depende de compositor nem de feature de window manager. Todos os controles e o overlay de settings funcionam igual. Os mesmos quatro vendors, as mesmas abas:

![ai-usagebar-tui na aba OpenAI rodando num terminal: gauges de Codex 5h e semanal, bloco de Credits com faixas de contagem de mensagens, abas Claude / OpenAI / GLM (Z.AI) / OpenRouter no topo, atalhos de tecla no rodapé.](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/2026/05/24/ai-usagebar/ai-usagebar-tui-openai.png)

Uso típico fora do Omarchy: uma checada rápida antes de começar uma sessão longa ("será que tô perto do limite semanal do Claude?"), um monitor num painel de tmux enquanto você programa, ou uma ferramenta só de shell em máquina remota (instala o binário e pronto, sem dependência de Waybar ou Hyprland). A TUI é a forma canônica de ver os quatro vendors de uma vez, independente de você configurar o widget ou não.

## Instalação

No Arch tem pacote no AUR, dois sabores:

```bash
yay -S ai-usagebar-bin    # binário pré-compilado do GitHub Releases (~5s)
yay -S ai-usagebar        # compila do fonte (~30-60s)
```

Ou do fonte direto:

```bash
cargo build --release
sudo make install                  # → /usr/local/bin
# ou
make install PREFIX=$HOME/.local   # → ~/.local/bin
```

A config de Waybar recomendada é um único módulo com scroll pra ciclar entre os vendors, e clique pra abrir a TUI:

```jsonc
"custom/aibar": {
    "exec": "ai-usagebar --format '{vendor_short} {session_pct}% · {session_reset}'",
    "return-type": "json",
    "interval": 300,
    "signal": 13,
    "tooltip": true,
    "on-click": "ai-usagebar-tui",
    "on-scroll-up":   "ai-usagebar --cycle-next",
    "on-scroll-down": "ai-usagebar --cycle-prev"
}
```

Se preferir ver os quatro vendors ao mesmo tempo, dá pra usar um módulo por vendor. O [README](https://github.com/akitaonrails/ai-usagebar) tem o detalhe completo de config, placeholders de formato, e as variações.

## Por que fiz

Esse parecia um projetinho de sábado à noite, então resolvi só fazer. E foi: portar o claudebar pra Rust e adicionar os vendors extras que eu queria foi tranquilo. Saí de uma noite com um widget que faz exatamente o que eu precisava e ainda é mais confiável (testado, modular) do que o shell script original.

Se você usa outros vendors que eu não cobri, ou achar bug, manda issue ou pull request: [github.com/akitaonrails/ai-usagebar](https://github.com/akitaonrails/ai-usagebar). É MIT.
