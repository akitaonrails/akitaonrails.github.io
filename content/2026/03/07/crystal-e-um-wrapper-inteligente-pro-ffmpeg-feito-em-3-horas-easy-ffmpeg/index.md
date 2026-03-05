---
title: "Crystal e um wrapper inteligente pro FFmpeg feito em 3 horas | easy-ffmpeg"
date: 2026-03-07T18:00:00-03:00
draft: false
tags: ["crystal", "ffmpeg", "cli", "vibe-coding", "open-source"]
description: "Eu queria converter vídeos sem decorar flags do FFmpeg. Saiu uma CLI inteligente em Crystal com presets, modo interativo e compilação estática pra Linux e macOS, em 3 horas de vibe coding."
---

Todo mundo que já precisou converter um vídeo no terminal conhece a dor do FFmpeg. Ele faz tudo. Absolutamente tudo. Mas pra fazer qualquer coisa, você precisa lembrar combinações de flags que parecem feitiço:

```bash
ffmpeg -i input.mkv -c:v libx264 -crf 23 -preset medium \
  -profile:v high -level 4.1 -c:a aac -b:a 128k \
  -movflags +faststart output.mp4
```

O que isso faz? Converte pra H.264 com qualidade razoável pra web, usando AAC no áudio e movendo o moov atom pro início do arquivo pra permitir streaming progressivo. Se você já sabia disso, parabéns. Se não sabia, bem-vindo ao clube de 99% das pessoas que usam FFmpeg copiando comandos do Stack Overflow.

E esse é o caso simples. Quer fazer um GIF animado a partir de uma sequência de PNGs? Precisa de um pipeline de duas passadas com geração de paleta:

```bash
ffmpeg -framerate 10 -i frame_%04d.png \
  -vf "split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" output.gif
```

Quer cortar um trecho, redimensionar pra 720p e forçar aspect ratio 16:9? Boa sorte montando o filter chain.

Eu cansei de ficar decorando flags. Queria uma CLI que eu falasse "converte isso pra MP4 otimizado pra web" e ela resolvesse. Então fiz o [easy-ffmpeg](https://github.com/akitaonrails/easy-ffmpeg).

## O que o easy-ffmpeg faz

É um wrapper inteligente. Você dá o arquivo de entrada e o formato de saída, e ele analisa o vídeo com ffprobe, descobre quais streams de vídeo, áudio e legenda existem, verifica compatibilidade de codecs com o container de destino, e decide sozinho o que pode copiar direto (sem re-encoding, instantâneo) e o que precisa transcodificar.

O uso mais básico:

```bash
# Converter MKV pra MP4 (copia streams compatíveis, sem re-encoding desnecessário)
easy-ffmpeg input.mkv mp4

# Otimizado pra web (H.264 + AAC, faststart)
easy-ffmpeg input.mkv mp4 --web

# Otimizado pra celular (720p, AAC stereo, arquivo menor)
easy-ffmpeg input.mkv mp4 --mobile

# Compressão máxima (H.265, CRF 28)
easy-ffmpeg input.mkv mp4 --compress

# Qualidade alta pra streaming (H.265, CRF 18)
easy-ffmpeg input.mkv mp4 --streaming
```

## Exemplos do que dá pra fazer

**Cortar um trecho do vídeo:**

```bash
# Do minuto 1:30 até 3:00
easy-ffmpeg video.mp4 mp4 --start 1:30 --end 3:00

# Os primeiros 90 segundos
easy-ffmpeg video.mp4 mp4 --duration 90

# Aceita vários formatos de tempo: 90, 1:30, 01:30.5, 1:02:30
```

**Redimensionar:**

```bash
# Pra 720p
easy-ffmpeg video.mp4 mp4 --scale hd

# Pra 1080p
easy-ffmpeg video.mp4 mp4 --scale fullhd

# Presets: 2k (1440p), fullhd (1080p), hd (720p), retro (480p), icon (240p)
```

**Mudar aspect ratio:**

```bash
# Forçar 16:9 (adiciona barras pretas se necessário)
easy-ffmpeg video.mp4 mp4 --aspect wide

# Formato TikTok/Stories (9:16 vertical)
easy-ffmpeg video.mp4 mp4 --aspect tiktok

# Quadrado pro Instagram
easy-ffmpeg video.mp4 mp4 --aspect square

# Croppar em vez de adicionar barras
easy-ffmpeg video.mp4 mp4 --aspect wide --crop
```

**Sequência de imagens pra vídeo:**

```bash
# Detecta automaticamente o padrão de numeração (frame_0001.png, frame_0002.png...)
easy-ffmpeg /pasta/com/frames/ mp4

# GIF animado com paleta otimizada
easy-ffmpeg /pasta/com/frames/ gif

# Sequência de imagens em 720p a 30fps
easy-ffmpeg /pasta/com/frames/ mp4 --fps 30 --scale hd
```

**Ver o que vai fazer sem executar:**

```bash
easy-ffmpeg video.mkv mp4 --web --dry-run
# Mostra o comando ffmpeg exato que seria executado
```

**Combinar tudo:**

```bash
# Cortar, redimensionar e comprimir pra mandar por WhatsApp
easy-ffmpeg video.mkv mp4 --start 0:30 --end 2:00 --scale hd --compress
```

E se você rodar `easy-ffmpeg` sem argumentos num terminal interativo, abre um modo TUI com seleção de arquivo por fuzzy search, escolha de preset por menu, e input de tempos com validação -- tudo sem precisar lembrar de nenhuma flag.

## Por que Crystal

Faz anos que eu não mexia com Crystal. A última vez foi pra brincar, antes da versão 1.0. E eu queria revisitar.

Crystal ocupa um nicho interessante. Go e Crystal competem pelo mesmo espaço: linguagens compiladas pra aplicações, que geram binários estáticos, com garbage collector e sem dependência de runtime. Mas a abordagem é bem diferente.

Go é famoso por ser deliberadamente simples. Sem generics por anos (só chegaram na 1.18), sem exceções (error returns), sem expressividade. O argumento é que isso facilita leitura e manutenção em equipes grandes. Na prática, resulta em código verboso e repetitivo, com `if err != nil` em todas as linhas.

Crystal tem tipagem estática com inferência, macros em tempo de compilação, blocos como closures (igual Ruby), exceções, generics desde sempre, e uma sintaxe que qualquer Rubista reconhece:

```crystal
# Crystal: ler um JSON e extrair dados
streams = json["streams"].as_a.map do |s|
  StreamInfo.new(
    codec: s["codec_name"]?.try(&.as_s) || "unknown",
    width:  s["width"]?.try(&.as_i) || 0,
    height: s["height"]?.try(&.as_i) || 0,
  )
end

# Go equivalente: seria 3x mais linhas com type assertions e error checks
```

A stdlib do Crystal tem HTTP server, JSON parsing, YAML, regex, fibers (green threads com scheduler cooperativo), channels (igual Go), e até IO::FileDescriptor com raw mode pra terminal -- que eu usei pro modo interativo. Concorrência funciona com `spawn` (equivalente ao `go` do Go) e `Channel` (idêntico ao chan do Go). A diferença é que tudo vem com a ergonomia do Ruby.

Pra uma CLI que precisa compilar num binário estático sem dependências, rodar em Linux e macOS, e ser distribuída como download direto -- Crystal é perfeito. O compilador gera binários nativos, e com o Docker Alpine dá pra fazer static linking com musl pra Linux. O binário final do easy-ffmpeg tem ~6MB.

Eu considero Rust melhor pra código de sistemas (kernels, drivers, databases, coisas onde ownership e lifetime importam). Mas pra uma CLI de conversão de vídeo? Rust seria overkill. Crystal dá o mesmo resultado final (binário estático e rápido) com um terço do código e sem brigar com o borrow checker.

## Os números

O projeto inteiro foi construído em uma tarde. 10 commits entre 18:32 e 21:33 do dia 7 de março de 2026. Três horas.

```
Linguagem    Arquivos    Linhas    Código
Crystal      13          2.823     2.342
Shell        1           109       91
Markdown     1           266       210
YAML         2           46        34
─────────────────────────────────────────
Total        20          3.326     2.419
```

2.342 linhas de Crystal fazem: CLI com 5 presets, análise de mídia via ffprobe, planejamento inteligente de conversão com matriz de compatibilidade de codecs, progress bar com ETA, modo interativo com fuzzy search, suporte a sequências de imagem e GIF, e trimming/scaling/aspect ratio com validação.

A ferramenta já está com CI/CD no GitHub Actions, compilando binários estáticos pra Linux (x86_64 e arm64) e macOS (arm64), com instalação via curl one-liner:

```bash
curl -fsSL https://raw.githubusercontent.com/akitaonrails/easy-ffmpeg/master/install.sh | sh
```

Três horas de uma tarde, da primeira linha de código ao release no GitHub com binários pra três plataformas. O FFmpeg continua fazendo o trabalho pesado -- eu só coloquei uma interface decente na frente.

O [repositório está aqui](https://github.com/akitaonrails/easy-ffmpeg). MIT license.
