# Sincronizando assets do institucional

Quando o institucional Nextside (`nextside/institucional`) atualizar logos, fontes
ou texturas, este guia descreve como propagar para o blog.

## Pastas espelhadas

| Origem (institucional) | Destino (blog) |
|---|---|
| `public/brand/` | `static/brand/` |
| `public/fonts/` | `static/fonts/` (converter `.ttf/.otf` → `.woff2`) |
| `public/textures/` | `static/textures/` |

## Comandos

```bash
# brand
cp ../institucional/public/brand/*.{svg,png} static/brand/

# fonts (precisa de pyftsubset — instalado via pip3 install fonttools brotli)
PYFTSUBSET=/Library/Frameworks/Python.framework/Versions/3.12/bin/pyftsubset
UNICODES="U+0000-00FF,U+0131,U+0152-0153,U+02BB-02BC,U+02C6,U+02DA,U+02DC,U+2000-206F,U+2074,U+20AC,U+2122,U+2191,U+2193,U+2212,U+2215,U+FEFF,U+FFFD"
for f in ../institucional/public/fonts/*; do
  base=$(basename "$f")
  cp "$f" "static/fonts/"
  $PYFTSUBSET "$f" --output-file="static/fonts/${base%.*}.woff2" --flavor=woff2 --unicodes="$UNICODES"
done

# textures
cp ../institucional/public/textures/*.png static/textures/
```

## Quando rodar

- Sempre que o institucional fizer release com mudança visual
- Não automatizar — passo manual, raro, e evita acoplamento de repos
- Abrir PR `chore: sync assets do institucional <data>`
