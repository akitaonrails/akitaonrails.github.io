---
title: "AI Agents: Instalando LSPs pro Crush"
slug: "ai-agents-instalando-lsps-pro-crush"
date: 2026-01-21T13:14:07-0300
tags:
- crush
- lsp
---

Este post é mais pra eu documentar e não esquecer. Como falei nos últimos posts, tenho usado [Charm's Crush](https://github.com/charmbracelet/crush) como meu agente favorito de IA pra programação. Repetindo: tanto faz se você usa Claude Code ou OpenCode, todos eles são igualmente bons. Minha preferência pessoal ainda é Crush porque acho mais bonito, só isso.

Ainda não entendi o quanto faz diferença ou não, mas tanto OpenCode quanto Crush tem suporte a Language Servers (LSPs) então achei legal deixar configurado. Eis meu `~/.config/crush/crush.json`:

```json
{
  "$schema": "https://charm.land/crush.json",
  "default_provider": "openrouter",
  "providers": {
    "openrouter": {
      "api_key": "sk-..."
    },
    "lmstudio": {
      "name": "LM Studio",
      "base_url": "http://localhost:1234/v1/",
      "type": "openai",
      "models": [
        {
          "name": "gpt-oss-120b",
          "id": "gpt-oss:120b",
          "context_window": 100000,
          "default_max_tokens": -1,
          "supports_tools": true
        },
        {
          "name": "gpt-oss-20b",
          "id": "gpt-oss:20b",
          "context_window": 130000,
          "default_max_tokens": -1,
          "supports_tools": true
        },
        {
          "name": "zai-org/glm-4.6v-flash",
          "id": "glm-4.6v-flash",
          "context_window": 130000,
          "default_max_tokens": -1,
          "supports_tools": true
        },
        {
          "name": "deepseek-coder-v2-lite-instruct",
          "id": "deepseek-coder-v2-lite-instruct",
          "context_window": 64000,
          "default_max_tokens": -1,
          "supports_tools": true
        },
        {
          "id": "qwen/qwen3-coder-30b",
          "name": "qwen3-coder-30b",
          "context_window": 120000,
          "default_max_tokens": -1,
          "supports_tools": true
        }
      ]
    },
    "ollama": {
      "type": "openai-compat",
      "base_url": "http://127.0.0.1:11434/v1",
      "api_key": "ollama",
      "models": [
        {
          "name": "glm-4.7-flash",
          "id": "glm-4.7-flash",
          "context_window": 65536,
          "default_max_tokens": -1,
          "supports_tools": true
        },
        {
          "name": "gpt-oss-20b",
          "id": "gpt-oss:20b",
          "context_window": 64000,
          "default_max_tokens": -1,
          "supports_tools": true
        },
        {
          "id": "qwen3-nuclear",
          "name": "qwen3-nuclear",
          "context_window": 120000,
          "default_max_tokens": -1,
          "supports_tools": true
        },
        {
          "id": "qwen3-coder:30b",
          "name": "qwen3-coder:30b",
          "context_window": 120000,
          "default_max_tokens": -1,
          "supports_tools": true
        },
        {
          "id": "qwen2.5-coder:32b",
          "name": "qwen2.5-coder:32b",
          "context_window": 32768,
          "default_max_tokens": -1,
          "supports_tools": true
        },
        {
          "id": "deepseek-coder-v2:16b",
          "name": "deepseek-coder-v2:16b",
          "context_window": 128000,
          "default_max_tokens": -1,
          "supports_tools": true
        },
        {
          "id": "glm-4.7:cloud",
          "name": "glm-4.7:cloud",
          "context_window": 128000,
          "default_max_tokens": -1,
          "supports_tools": true
        }
      ]
    }
  },
  "lsp": {
    "gopls": {
      "command": "gopls"
    },
    "rust-analyzer": {
      "command": "rust-analyzer"
    },
    "ruby-lsp": {
      "command": "ruby-lsp"
    },
    "solargraph": {
      "command": "solargraph",
      "args": [
        "stdio"
      ]
    },
    "pylsp": {
      "command": "pylsp"
    },
    "pyright": {
      "command": "pyright-langserver",
      "args": [
        "--stdio"
      ]
    },
    "elixir-ls": {
      "command": "elixir-ls"
    },
    "docker-langserver": {
      "command": "docker-langserver",
      "args": [
        "--stdio"
      ],
      "languages": [
        "dockerfile"
      ]
    },
    "bash-language-server": {
      "command": "bash-language-server",
      "args": [
        "start"
      ]
    },
    "marksman": {
      "command": "marksman",
      "args": [
        "server"
      ]
    },
    "typescript-language-server": {
      "command": "typescript-language-server",
      "args": [
        "--stdio"
      ]
    },
    "vscode-html-language-server": {
      "command": "vscode-html-language-server",
      "args": [
        "--stdio"
      ]
    },
    "vscode-css-language-server": {
      "command": "vscode-css-language-server",
      "args": [
        "--stdio"
      ]
    },
    "vscode-json-language-server": {
      "command": "vscode-json-language-server",
      "args": [
        "--stdio"
      ]
    },
    "yaml-language-server": {
      "command": "yaml-language-server",
      "args": [
        "--stdio"
      ]
    },
    "taplo": {
      "command": "taplo",
      "args": [
        "lsp",
        "stdio"
      ]
    }
  },
  "mcp": {
    "blender": {
      "type": "stdio",
      "command": "uvx",
      "args": [
        "blender-mcp"
      ]
    }
  }
}
```

Notem que eu uso primariamente Claude Opus 4.5 via OpenRouter e tenho LM Studio e Ollama configurados como providers pra testar outros modelos open source.

Também uso [Mise](/2025/09/07/omarchy-2-0-mise-pra-organizar-ambientes-de-desenvolvimento/) pra organizar as linguagens de programação que uso.

Porém, agora precisa instalar os LSPs de cada linguagem. Eu não conheço um jeito melhor de gerenciar isso da mesma forma como com um Mason no Neovim. Então fiz um script pra instalar tudo pra mim (no meu Arch Linux). Pra isso criei este script `~/.local/bin/install-lsps.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail

# LSP Installer for Arch Linux with Mise
# Installs major LSPs using native package managers or yay
# Only installs LSPs for languages that are already installed

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[OK]${NC} $1"; }
warn() { echo -e "${YELLOW}[SKIP]${NC} $1"; }
skip_lang() { echo -e "${RED}[LANG]${NC} $1 not installed, skipping LSPs"; }

command_exists() { command -v "$1" &>/dev/null; }

# ─────────────────────────────────────────────────────────────
# Language detection helpers
# ─────────────────────────────────────────────────────────────
has_c()       { command_exists gcc || command_exists clang; }
has_rust()    { command_exists rustc || command_exists cargo; }
has_go()      { command_exists go; }
has_python()  { command_exists python || command_exists python3; }
has_node()    { command_exists node || command_exists npm; }
has_java()    { command_exists java || command_exists javac; }
has_kotlin()  { command_exists kotlin || command_exists kotlinc; }
has_ruby()    { command_exists ruby; }
has_php()     { command_exists php; }
has_lua()     { command_exists lua || command_exists luajit; }
has_zig()     { command_exists zig; }
has_haskell() { command_exists ghc || command_exists stack || command_exists cabal; }
has_elixir()  { command_exists elixir || command_exists iex; }
has_scala()   { command_exists scala || command_exists sbt; }
has_dotnet()  { command_exists dotnet; }
has_ocaml()   { command_exists ocaml || command_exists opam; }
has_clojure() { command_exists clojure || command_exists clj || command_exists lein; }
has_nix()     { command_exists nix; }
has_terraform() { command_exists terraform || command_exists tofu; }
has_latex()   { command_exists latex || command_exists pdflatex || command_exists xelatex; }
has_docker()  { command_exists docker || command_exists podman; }
has_ansible() { command_exists ansible; }
has_sql()     { command_exists psql || command_exists mysql || command_exists sqlite3; }
has_bash()    { command_exists bash; }

# ─────────────────────────────────────────────────────────────
# Package installation helpers
# ─────────────────────────────────────────────────────────────
install_pacman() {
    local pkg="$1"
    if pacman -Qi "$pkg" &>/dev/null; then
        warn "$pkg already installed"
    else
        sudo pacman -S --noconfirm --needed "$pkg" && success "$pkg" || warn "Failed: $pkg"
    fi
}

install_yay() {
    local pkg="$1"
    if ! command_exists yay; then
        warn "yay not found, skipping $pkg"
        return
    fi
    if yay -Qi "$pkg" &>/dev/null; then
        warn "$pkg already installed"
    else
        yay -S --noconfirm --needed "$pkg" && success "$pkg" || warn "Failed: $pkg"
    fi
}

install_npm() {
    local pkg="$1"
    if npm list -g "$pkg" &>/dev/null 2>&1; then
        warn "$pkg already installed"
    else
        npm install -g "$pkg" && success "$pkg" || warn "Failed: $pkg"
    fi
}

install_pipx() {
    local pkg="$1"
    if ! command_exists pipx; then
        pip install --user pipx 2>/dev/null || {
            pip install --user "$pkg" && success "$pkg" || warn "Failed: $pkg"
            return
        }
    fi
    if pipx list 2>/dev/null | grep -q "$pkg"; then
        warn "$pkg already installed"
    else
        pipx install "$pkg" && success "$pkg" || warn "Failed: $pkg"
    fi
}

install_go() {
    local pkg="$1"
    local name="${pkg##*/}"
    name="${name%%@*}"
    
    # Check if binary already exists in GOPATH/bin
    local gobin="${GOBIN:-${GOPATH:-$HOME/go}/bin}"
    if [[ -x "$gobin/$name" ]]; then
        warn "$name already installed"
        return
    fi
    
    go install "$pkg" && success "$name" || warn "Failed: $name"
}

install_gem() {
    local pkg="$1"
    if gem list -i "^${pkg}$" &>/dev/null; then
        warn "$pkg already installed"
    else
        gem install "$pkg" && success "$pkg" || warn "Failed: $pkg"
    fi
}

# ─────────────────────────────────────────────────────────────
# C/C++ LSPs
# ─────────────────────────────────────────────────────────────
install_c_lsps() {
    if ! has_c; then
        skip_lang "C/C++ (gcc/clang)"
        return
    fi
    info "Installing C/C++ LSPs..."
    install_pacman clang  # includes clangd
}

# ─────────────────────────────────────────────────────────────
# Rust LSPs
# ─────────────────────────────────────────────────────────────
install_rust_lsps() {
    if ! has_rust; then
        skip_lang "Rust"
        return
    fi
    info "Installing Rust LSPs..."
    
    if command_exists rustup; then
        rustup component add rust-analyzer 2>/dev/null && success "rust-analyzer (rustup)" || install_pacman rust-analyzer
    else
        install_pacman rust-analyzer
    fi
}

# ─────────────────────────────────────────────────────────────
# Go LSPs
# ─────────────────────────────────────────────────────────────
install_go_lsps() {
    if ! has_go; then
        skip_lang "Go"
        return
    fi
    info "Installing Go LSPs..."
    
    install_go golang.org/x/tools/gopls@latest
    install_go github.com/go-delve/delve/cmd/dlv@latest
    install_go github.com/nametake/golangci-lint-langserver@latest
}

# ─────────────────────────────────────────────────────────────
# Python LSPs
# ─────────────────────────────────────────────────────────────
install_python_lsps() {
    if ! has_python; then
        skip_lang "Python"
        return
    fi
    info "Installing Python LSPs..."
    
    # Prefer npm pyright (faster updates) if node available
    if has_node; then
        install_npm pyright
    else
        install_pipx pyright
    fi
    
    install_pipx python-lsp-server
    install_pipx ruff-lsp
}

# ─────────────────────────────────────────────────────────────
# Node.js/TypeScript LSPs
# ─────────────────────────────────────────────────────────────
install_node_lsps() {
    if ! has_node; then
        skip_lang "Node.js"
        return
    fi
    info "Installing Node.js/TypeScript LSPs..."
    
    install_npm typescript
    install_npm typescript-language-server
    install_npm vscode-langservers-extracted  # HTML, CSS, JSON, ESLint
    install_npm "@tailwindcss/language-server"
    install_npm "@vue/language-server"
    install_npm svelte-language-server
    install_npm graphql-language-service-cli
    install_npm "@prisma/language-server"
    install_npm emmet-ls
}

# ─────────────────────────────────────────────────────────────
# Java LSPs
# ─────────────────────────────────────────────────────────────
install_java_lsps() {
    if ! has_java; then
        skip_lang "Java"
        return
    fi
    info "Installing Java LSPs..."
    install_yay jdtls
}

# ─────────────────────────────────────────────────────────────
# Kotlin LSPs
# ─────────────────────────────────────────────────────────────
install_kotlin_lsps() {
    if ! has_kotlin; then
        skip_lang "Kotlin"
        return
    fi
    info "Installing Kotlin LSPs..."
    install_yay kotlin-language-server
}

# ─────────────────────────────────────────────────────────────
# Ruby LSPs
# ─────────────────────────────────────────────────────────────
install_ruby_lsps() {
    if ! has_ruby; then
        skip_lang "Ruby"
        return
    fi
    info "Installing Ruby LSPs..."
    install_gem solargraph
    install_gem ruby-lsp
}

# ─────────────────────────────────────────────────────────────
# PHP LSPs
# ─────────────────────────────────────────────────────────────
install_php_lsps() {
    if ! has_php; then
        skip_lang "PHP"
        return
    fi
    if ! has_node; then
        warn "PHP LSP (intelephense) requires npm, skipping"
        return
    fi
    info "Installing PHP LSPs..."
    install_npm intelephense
}

# ─────────────────────────────────────────────────────────────
# Lua LSPs
# ─────────────────────────────────────────────────────────────
install_lua_lsps() {
    if ! has_lua; then
        skip_lang "Lua"
        return
    fi
    info "Installing Lua LSPs..."
    install_pacman lua-language-server
}

# ─────────────────────────────────────────────────────────────
# Zig LSPs
# ─────────────────────────────────────────────────────────────
install_zig_lsps() {
    if ! has_zig; then
        skip_lang "Zig"
        return
    fi
    info "Installing Zig LSPs..."
    install_pacman zls
}

# ─────────────────────────────────────────────────────────────
# Haskell LSPs
# ─────────────────────────────────────────────────────────────
install_haskell_lsps() {
    if ! has_haskell; then
        skip_lang "Haskell"
        return
    fi
    info "Installing Haskell LSPs..."
    install_yay haskell-language-server
}

# ─────────────────────────────────────────────────────────────
# Elixir LSPs
# ─────────────────────────────────────────────────────────────
install_elixir_lsps() {
    if ! has_elixir; then
        skip_lang "Elixir"
        return
    fi
    info "Installing Elixir LSPs..."
    install_yay elixir-ls
}

# ─────────────────────────────────────────────────────────────
# Scala LSPs
# ─────────────────────────────────────────────────────────────
install_scala_lsps() {
    if ! has_scala; then
        skip_lang "Scala"
        return
    fi
    info "Installing Scala LSPs..."
    install_yay metals
}

# ─────────────────────────────────────────────────────────────
# C# / F# (.NET) LSPs
# ─────────────────────────────────────────────────────────────
install_dotnet_lsps() {
    if ! has_dotnet; then
        skip_lang ".NET (C#/F#)"
        return
    fi
    info "Installing .NET LSPs..."
    install_yay omnisharp-roslyn
    install_yay fsautocomplete
}

# ─────────────────────────────────────────────────────────────
# OCaml LSPs
# ─────────────────────────────────────────────────────────────
install_ocaml_lsps() {
    if ! has_ocaml; then
        skip_lang "OCaml"
        return
    fi
    info "Installing OCaml LSPs..."
    if command_exists opam; then
        opam install ocaml-lsp-server -y && success "ocaml-lsp-server" || warn "Failed"
    else
        install_yay ocaml-lsp-server
    fi
}

# ─────────────────────────────────────────────────────────────
# Clojure LSPs
# ─────────────────────────────────────────────────────────────
install_clojure_lsps() {
    if ! has_clojure; then
        skip_lang "Clojure"
        return
    fi
    info "Installing Clojure LSPs..."
    install_yay clojure-lsp-bin
}

# ─────────────────────────────────────────────────────────────
# Nix LSPs
# ─────────────────────────────────────────────────────────────
install_nix_lsps() {
    if ! has_nix; then
        skip_lang "Nix"
        return
    fi
    info "Installing Nix LSPs..."
    install_pacman nil
}

# ─────────────────────────────────────────────────────────────
# Bash LSPs
# ─────────────────────────────────────────────────────────────
install_bash_lsps() {
    if ! has_bash; then
        skip_lang "Bash"
        return
    fi
    info "Installing Bash LSPs..."
    install_pacman bash-language-server
}

# ─────────────────────────────────────────────────────────────
# Terraform LSPs
# ─────────────────────────────────────────────────────────────
install_terraform_lsps() {
    if ! has_terraform; then
        skip_lang "Terraform"
        return
    fi
    info "Installing Terraform LSPs..."
    install_pacman terraform-ls
}

# ─────────────────────────────────────────────────────────────
# LaTeX LSPs
# ─────────────────────────────────────────────────────────────
install_latex_lsps() {
    if ! has_latex; then
        skip_lang "LaTeX"
        return
    fi
    info "Installing LaTeX LSPs..."
    install_pacman texlab
}

# ─────────────────────────────────────────────────────────────
# Docker LSPs
# ─────────────────────────────────────────────────────────────
install_docker_lsps() {
    if ! has_docker; then
        skip_lang "Docker"
        return
    fi
    info "Installing Docker LSPs..."
    install_yay dockerfile-language-server
}

# ─────────────────────────────────────────────────────────────
# Ansible LSPs
# ─────────────────────────────────────────────────────────────
install_ansible_lsps() {
    if ! has_ansible; then
        skip_lang "Ansible"
        return
    fi
    if ! has_node; then
        warn "Ansible LSP requires npm, skipping"
        return
    fi
    info "Installing Ansible LSPs..."
    install_npm "@ansible/ansible-language-server"
}

# ─────────────────────────────────────────────────────────────
# SQL LSPs
# ─────────────────────────────────────────────────────────────
install_sql_lsps() {
    if ! has_sql; then
        skip_lang "SQL (psql/mysql/sqlite)"
        return
    fi
    info "Installing SQL LSPs..."
    install_pacman sqls
}

# ─────────────────────────────────────────────────────────────
# Generic config file LSPs (always install)
# ─────────────────────────────────────────────────────────────
install_generic_lsps() {
    info "Installing generic config LSPs (YAML, TOML, JSON, Markdown, XML)..."
    install_pacman yaml-language-server
    install_pacman taplo               # TOML
    install_pacman marksman            # Markdown
    install_yay lemminx                # XML
}

# ─────────────────────────────────────────────────────────────
# Main
# ─────────────────────────────────────────────────────────────
main() {
    echo "═══════════════════════════════════════════════════════════"
    echo "         LSP Installer for Arch Linux + Mise"
    echo "    (Only installs LSPs for detected languages)"
    echo "═══════════════════════════════════════════════════════════"
    echo
    
    # Language-specific LSPs
    install_c_lsps
    install_rust_lsps
    install_go_lsps
    install_python_lsps
    install_node_lsps
    install_java_lsps
    install_kotlin_lsps
    install_ruby_lsps
    install_php_lsps
    install_lua_lsps
    install_zig_lsps
    install_haskell_lsps
    install_elixir_lsps
    install_scala_lsps
    install_dotnet_lsps
    install_ocaml_lsps
    install_clojure_lsps
    install_nix_lsps
    install_bash_lsps
    install_terraform_lsps
    install_latex_lsps
    install_docker_lsps
    install_ansible_lsps
    install_sql_lsps
    
    echo
    # Always-useful LSPs for config files
    install_generic_lsps
    
    echo
    echo "═══════════════════════════════════════════════════════════"
    success "LSP installation complete!"
    echo "═══════════════════════════════════════════════════════════"
}

main "$@"
```

Teoricamente é só isso. Se alguém conhecer um jeito melhor, mande nos comentários abaixo.
