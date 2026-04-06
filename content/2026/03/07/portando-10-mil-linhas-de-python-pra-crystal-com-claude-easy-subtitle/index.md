---
title: "Portando 10 Mil Linhas de Python pra Crystal com Claude: easy-subtitle"
date: '2026-03-07T22:00:00-03:00'
draft: false
translationKey: easy-subtitle-python-to-crystal
tags:
  - crystal
  - python
  - claude
  - vibe-coding
  - subtitle
---

No [artigo anterior](/2026/03/07/crystal-e-um-wrapper-inteligente-pro-ffmpeg-feito-em-3-horas-easy-ffmpeg/) eu mostrei por que escolhi Crystal pra CLIs de linha de comando. Nesse artigo eu quero mostrar um caso mais ambicioso. Não é mais uma ferramenta do zero -- é um port feature-parity de um projeto open source de 10 mil linhas de Python.

## O Problema: Legendas

Quem mantém uma coleção de filmes e séries sabe a dor. Você baixa o arquivo MKV, mas a legenda embutida está dessincronizada. Ou pior: não tem legenda nenhuma no idioma que você quer. Aí você vai no OpenSubtitles, baixa uma legenda, e ela tá 3 segundos adiantada porque foi feita pra outro release. O fluxo manual é:

1. Extrair tracks de legenda do MKV com `mkvextract`
2. Ir no OpenSubtitles, procurar legenda pro filme
3. Baixar, testar, ver que tá fora de sync
4. Rodar algum tool de sync (ffsubsync, alass)
5. Renomear o arquivo, mover pro lugar certo
6. Repetir pra cada idioma, pra cada filme

Pra quem tem 10 filmes, é tolerável. Pra quem tem centenas, é insano. É exatamente o tipo de coisa que deveria ser automatizada.

## Subservient: A Solução Python

Pesquisando o que já existia, encontrei o [Subservient](https://github.com/N3xigen/Subservient). É um projeto Python que automatiza exatamente esse fluxo: extrai legendas de MKVs, baixa do OpenSubtitles via API REST, sincroniza com ffsubsync, e limpa propagandas dos arquivos SRT.

O projeto é completo. Tem modo filme e modo série, smart sync (testa todos os candidatos em paralelo e pega o melhor) e first-match (para no primeiro que funcionar). Usa o hash do OpenSubtitles pra matching exato e limpa watermarks e propagandas com mais de 30 regex patterns.

Mas tem os problemas típicos de distribuição Python:

- **7 dependências pip**: colorama, requests, langdetect, ffsubsync, platformdirs, pycountry, tqdm
- **ffsubsync como engine de sync**: que por sua vez depende de numpy, auditok, e mais um monte de pacote Python
- **Interface interativa com menus**: boa pra uso manual, péssima pra scriptabilidade
- **Config em formato INI**: não é o fim do mundo, mas YAML é mais ergonômico
- **10.220 linhas em 6 arquivos Python**: arquivos de 2.700 linhas com funções de centenas de linhas cada

O ponto não é que Python seja ruim pra isso. O Subservient funciona. Mas instalar e manter em produção é outra história. Se você quer rodar num server headless, precisa de Python 3.8+, pip, virtualenv (ou vai poluir o sistema), e torcer pra nenhuma dependência quebrar com a próxima atualização do OS.

## O Experimento: Port pra Crystal com Claude

Aqui é onde a coisa fica interessante. Eu queria testar uma hipótese: o Claude consegue pegar um projeto open source grande, entender a arquitetura, e fazer um port completo pra outra linguagem?

Não estou falando de traduzir arquivo por arquivo. Estou falando de entender o que o projeto faz, redesenhar a arquitetura onde faz sentido, e gerar código idiomático em Crystal.

O que eu fiz:

1. Pedi pro Claude clonar e analisar o repositório do Subservient
2. Expliquei as decisões de design: usar [alass](https://github.com/kaegi/alass) (binário Rust, sem dependências Python) no lugar do ffsubsync, subcomandos CLI ao invés de menus interativos, YAML ao invés de INI
3. Pedi port feature-parity, com testes

O alass é um detalhe importante. O ffsubsync funciona bem, mas é um pacote Python que puxa numpy e faz análise de áudio. O alass faz a mesma coisa (sincronização de legendas por análise de timing), mas é um binário Rust standalone. Trocar um pelo outro elimina a maior dependência Python do stack.

## O Resultado: easy-subtitle

Cinco commits. Menos de 40 minutos do primeiro ao último.

| Commit | Hora | O que fez |
|--------|------|-----------|
| Initial implementation | 21:47 | Port completo: 42 arquivos src, 16 arquivos de teste, CI, install script |
| Track shard.lock | 21:56 | Lock de dependências pra builds reproduzíveis |
| Prefer ~/.local/bin | 22:03 | Fix no install script |
| Add doctor command | 22:20 | Novo comando `doctor` pra validar setup + bump v0.2.0 |
| Homebrew formula | 22:24 | Suporte a `brew install` e workflow de auto-update |

O primeiro commit já entrega o projeto funcional: 8 comandos CLI, cliente OpenSubtitles com rate limiting, 76 testes passando, GitHub Actions com CI e release pra Linux e macOS.

### Números

| Métrica | Subservient (Python) | easy-subtitle (Crystal) |
|---------|---------------------|------------------------|
| Código fonte | 10.220 linhas (6 arquivos) | 2.516 linhas (42 arquivos) |
| Testes | 0 | 800 linhas (76 specs) |
| Dependências runtime | 7 pacotes pip + ffsubsync | 0 (só webmock pra testes) |
| Binário | n/a (precisa Python + deps) | ~6MB estático |
| Config | INI | YAML |
| Sync engine | ffsubsync (Python) | alass (Rust) |
| UI | Menu interativo | Subcomandos CLI |
| Concorrência | ThreadPoolExecutor | Crystal fibers + channels |

A diferença de LOC é gritante: 10.220 vs 2.516. Mas isso não é mérito só do Crystal. O Python original tem arquivos monolíticos de milhares de linhas, com muita duplicação e lógica de UI misturada com lógica de negócio. O port separa as responsabilidades em módulos pequenos e focados.

### Arquitetura do Port

```
easy-subtitle/
  src/easy_subtitle/
    cli/           # Router + 9 comandos (init, extract, download, sync, run, clean, scan, hash, doctor)
    core/          # Mapa de idiomas, parser/writer/cleaner de SRT, scanner de vídeo
    acquisition/   # Cliente API OpenSubtitles, auth, busca, download, movie hash
    extraction/    # Parsing de tracks MKV, extração, remuxing
    synchronization/  # Runner do alass, cálculo de offset, estratégias smart/first-match
    models/        # VideoFile, SubtitleCandidate, CoverageEntry
```

Cada módulo tem uma responsabilidade clara. O maior arquivo tem 144 linhas (config). No Python original, o `acquisition.py` sozinho tem 2.726 linhas.

### O Que Cada Comando Faz

```bash
# Gerar config padrão
easy-subtitle init

# Extrair legendas de dentro de MKVs
easy-subtitle extract /path/to/movies

# Baixar legendas do OpenSubtitles
easy-subtitle download -l en,pt /path/to/movies

# Sincronizar legendas baixadas com o vídeo
easy-subtitle sync /path/to/movies

# Pipeline completo: extract → download → sync
easy-subtitle run /path/to/movies

# Limpar propagandas/watermarks de SRTs
easy-subtitle clean /path/to/subtitles

# Ver cobertura de legendas por idioma
easy-subtitle scan --json /path/to/movies

# Computar hash OpenSubtitles (debug)
easy-subtitle hash /path/to/movie.mkv

# Validar setup: config, credenciais, dependências
easy-subtitle doctor
```

O `doctor` é um comando que eu adicionei depois. Ele verifica se o config existe, se a API key está configurada, testa login na API, e checa se `mkvmerge`, `mkvextract` e `alass` estão no PATH. Mostra instruções de instalação específicas pro OS quando algo falta.

### Smart Sync com Fibers

O smart sync é a parte que eu mais gostei de ver o port. No Python original, ele usa `ThreadPoolExecutor` pra rodar múltiplos candidatos em paralelo. Em Crystal, a mesma lógica fica mais natural com fibers e channels:

```crystal
def execute(candidates : Array(Path), video : VideoFile) : SyncResult?
  channel = Channel(SyncResult).new(candidates.size)

  candidates.each do |candidate|
    spawn do
      result = sync_one(candidate, video)
      channel.send(result)
    end
  end

  results = Array(SyncResult).new(candidates.size)
  candidates.size.times do
    results << channel.receive
  end

  accepted = results.select(&.accepted?)
  accepted.min_by(&.offset)
end
```

Cada candidato de legenda é sincronizado em um fiber separado (via `spawn`). Os resultados voltam pelo `Channel`. No final, pega o aceito com menor offset. Sem ThreadPoolExecutor, sem futures, sem callbacks.

### Rate Limiting da API

O OpenSubtitles exige throttling de 500ms entre requests. O cliente Crystal implementa isso com Mutex:

```crystal
RATE_LIMIT_MS = 500

private def throttle! : Nil
  @mutex.synchronize do
    elapsed = Time.utc - @last_request_at
    remaining = RATE_LIMIT_MS - elapsed.total_milliseconds
    sleep(remaining.milliseconds) if remaining > 0
    @last_request_at = Time.utc
  end
end
```

Simples, thread-safe, sem biblioteca externa.

### Instalação

O binário estático sai do GitHub Actions e pode ser instalado de três formas:

```bash
# Homebrew (macOS / Linux)
brew install akitaonrails/tap/easy-subtitle

# Script de instalação
curl -fsSL https://raw.githubusercontent.com/akitaonrails/easy-subtitle/master/install.sh | bash

# Ou baixa o binário direto dos Releases
```

Um binário. Sem Python, sem pip, sem nada.

## Sobre Portar Coisas "Só Porque Sim"

Eu sempre defendi que portar software de uma linguagem pra outra só pelo fetiche da linguagem é perda de tempo. Quantos projetos foram reescritos em Rust "porque sim"? Quanto esforço gasto em reescritas que não entregaram valor novo?

Mas preciso admitir que esse experimento me fez reconsiderar.

Quando o custo de portar cai de semanas/meses pra menos de 40 minutos, a equação muda. O port do Subservient pra Crystal com Claude não foi um exercício de vaidade linguística. Eu queria um binário estático que eu pudesse jogar num server e esquecer. Sem gerenciar runtime Python, sem pip install quebrando na próxima atualização do sistema.

E o resultado não é um port mecânico. São 2.516 linhas em 42 arquivos, contra 10.220 em 6 monolíticos. O port veio com 76 testes que o original não tinha, CI com release automático pra Linux e macOS, Homebrew formula e install script com verificação de checksum.

O ponto não é que Python é ruim. É que a barreira de "será que vale a pena portar?" ficou ridiculamente baixa. Port feature-parity com testes em menos de uma hora. Difícil argumentar contra.

O [repositório está aqui](https://github.com/akitaonrails/easy-subtitle). GPL-3.0, como o original.
