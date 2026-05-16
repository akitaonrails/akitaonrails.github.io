#!/usr/bin/env bash
# Validador de frontmatter dos posts.
# Exit 1 se qualquer post tiver problema.

set -u

ERRORS=0

for f in $(find content -name "index.md" -path "*/posts/*"); do
  has_error=0

  # Campos obrigatórios
  for field in title date translationKey category tags author description cover; do
    if ! grep -qE "^${field}:" "$f"; then
      if [[ $has_error -eq 0 ]]; then echo "Validando: $f"; has_error=1; fi
      echo "  ❌ Falta campo: $field"
      ERRORS=$((ERRORS + 1))
    fi
  done

  # Category enum
  category=$(grep -E "^category:" "$f" | head -1 | sed 's/category: *//' | tr -d ' "')
  case "$category" in
    tecnologia|gestao|entregas-rapidas|cases) ;;
    "")
      if [[ $has_error -eq 0 ]]; then echo "Validando: $f"; has_error=1; fi
      echo "  ❌ Category ausente"
      ERRORS=$((ERRORS + 1))
      ;;
    *)
      if [[ $has_error -eq 0 ]]; then echo "Validando: $f"; has_error=1; fi
      echo "  ❌ Category inválida: '$category' (use: tecnologia|gestao|entregas-rapidas|cases)"
      ERRORS=$((ERRORS + 1))
      ;;
  esac

  # Cover existe
  cover=$(grep -E "^cover:" "$f" | head -1 | sed 's/cover: *//' | tr -d ' "')
  if [[ -n "$cover" && ! -f "static/$cover" ]]; then
    if [[ $has_error -eq 0 ]]; then echo "Validando: $f"; has_error=1; fi
    echo "  ❌ Cover não existe: static/$cover"
    ERRORS=$((ERRORS + 1))
  fi

  # translationKey é único
  tkey=$(grep -E "^translationKey:" "$f" | head -1 | sed 's/translationKey: *//' | tr -d ' "')
  if [[ -n "$tkey" ]]; then
    count=$(grep -rE "^translationKey: *[\"']?${tkey}[\"']?\$" content/ | wc -l | tr -d ' ')
    # Esperado: 2 (pt-br + en) ou 1 (só pt-br)
    if [[ $count -gt 2 ]]; then
      if [[ $has_error -eq 0 ]]; then echo "Validando: $f"; has_error=1; fi
      echo "  ❌ translationKey duplicada (${count}x): $tkey"
      ERRORS=$((ERRORS + 1))
    fi
  fi
done

if [[ $ERRORS -gt 0 ]]; then
  echo ""
  echo "❌ Total de erros: $ERRORS"
  exit 1
fi

echo "✅ Todos os posts válidos."
