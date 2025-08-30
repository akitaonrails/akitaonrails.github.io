#!/bin/bash

set -e

print_message() {
    echo "[INFO] $1"
}

print_error() {
    echo "[ERROR] $1"
}

check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker não está instalado."
        exit 1
    fi
    
    if ! docker compose version &> /dev/null; then
        print_error "Docker Compose não está disponível."
        exit 1
    fi
}

start_dev() {
    print_message "Iniciando ambiente..."
    docker compose up --build -d
    print_message "Servidor em: http://localhost:1313"
}

stop_dev() {
    print_message "Parando ambiente..."
    docker compose down
}

rebuild() {
    print_message "Rebuildando..."
    docker compose down
    docker compose build --no-cache
    docker compose up -d
}

logs() {
    docker compose logs -f
}

exec_command() {
    if [ -z "$1" ]; then
        print_error "Comando não especificado"
        exit 1
    fi
    
    print_message "Executando: $1"
    docker compose exec akitaonrails-blog $1
}

generate_index() {
    print_message "Gerando índice..."
    docker compose exec akitaonrails-blog sh -c "cd content && ruby generate_index.rb"
}

new_post() {
    if [ -z "$1" ]; then
        print_error "Título do post não especificado"
        print_message "Uso: ./scripts/dev.sh new-post 'Título do Post'"
        exit 1
    fi
    
    DATE_PATH=$(date +%Y/%m/%d)
    POST_DIR="content/${DATE_PATH}/$(echo "$1" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/-\+/-/g' | sed 's/^-\|-$//g')"
    
    print_message "Criando post: $POST_DIR"
    
    mkdir -p "$POST_DIR"
    
    cat > "$POST_DIR/index.md" << EOF
---
title: "$1"
date: $(date +%Y-%m-%dT%H:%M:%S%z)
draft: false
description: "Descrição do post aqui"
tags: []
categories: []
---

Conteúdo do post aqui...

EOF
    
    print_message "Post criado em: $POST_DIR/index.md"
}

show_help() {
    echo "Comandos:"
    echo "  start          - Inicia o ambiente"
    echo "  stop           - Para o ambiente"
    echo "  restart        - Reinicia o ambiente"
    echo "  rebuild        - Rebuilda a imagem"
    echo "  logs           - Mostra os logs"
    echo "  exec <cmd>     - Executa comando no container"
    echo "  generate-index - Gera o índice de posts"
    echo "  new-post <title> - Cria um novo post"
    echo "  help           - Mostra esta ajuda"
}

main() {
    check_docker
    
    case "${1:-help}" in
        start)
            start_dev
            ;;
        stop)
            stop_dev
            ;;
        restart)
            stop_dev
            start_dev
            ;;
        rebuild)
            rebuild
            ;;
        logs)
            logs
            ;;
        exec)
            shift
            exec_command "$@"
            ;;
        generate-index)
            generate_index
            ;;
        new-post)
            shift
            new_post "$@"
            ;;
        help|--help|-h)
            show_help
            ;;
        *)
            print_error "Comando desconhecido: $1"
            show_help
            exit 1
            ;;
    esac
}

main "$@"
