---
title: "Web Scrapping em 2026 | Bastidores do The M.Akita Chronicles"
slug: "web-scrapping-em-2026-bastidores-do-the-m-akita-chronicles"
date: 2026-02-18T14:57:22+00:00
draft: false
tags:
- themakitachronicles
- rubyonrails
- webscrapping
- chromium
- datadome
---

Este post vai fazer parte de uma série; acompanhe pela tag [/themakitachronicles](/tags/themakitachronicles). Esta é a parte 2.

E não deixe de assinar minha nova newsletter [The M.Akita Chronicles](https://themakitachronicles.com/)!

--

Dez anos atrás, buscar dados em um site era trivial. Quatro linhas de Ruby: `Net::HTTP.get`, Nokogiri parse, CSS selector, pronto. O mundo inteiro estava aberto pra qualquer script com um User-Agent decente.

Hoje? Metade dos sites que preciso ler pra montar minha newsletter retorna "Are you a robot?" pra qualquer requisição HTTP convencional. A outra metade renderiza o conteúdo inteiramente em JavaScript — não há HTML nenhum na resposta do servidor. E os mais paranoicos combinam as duas coisas.

Meu objetivo era criar uma rotina diária pro M.arvin me devolver as principais notícias pela manhã no meu Discord. Assim eu não preciso sair caçando as notícias do dia. Parecia simples… no começo.

![daily routine](https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/frankmd/2026/02/screenshot-2026-02-18_11-59-42.jpg)

Este post é sobre como passei de "uma chamada HTTP" pra "empacotar um Chromium inteiro no Docker" — e por que isso é a realidade de qualquer projeto que precisa ler a web programaticamente em 2026.

## A Idade de Ouro: HTTP Simples

Vamos começar pelo que ainda funciona. Alguns serviços oferecem dados estruturados sem nenhuma resistência:

```ruby
# RSS feeds: o formato mais resiliente da web
uri = URI("https://news.google.com/rss/search?q=when:24h+allinurl:reuters.com/world")
xml = Net::HTTP.get(uri)
doc = REXML::Document.new(xml)
doc.get_elements("//item").each do |item|
  title = item.get_text("title").to_s
  url   = item.get_text("link").to_s
end

# APIs públicas: JSON limpo, documentado, estável
response = HTTParty.get("https://api.jikan.moe/v4/top/anime?filter=airing")
animes = response.parsed_response["data"]

# GitHub trending: HTML server-rendered sem proteção
html = HTTParty.get("https://github.com/trending").body
doc = Nokogiri::HTML(html)
repos = doc.css("article.Box-row")
```

Hacker News, GitHub Trending, APIs de anime, feeds RSS, Project Gutenberg — todos funcionam com um `GET` e um parser. Sem JavaScript, sem autenticação implícita, sem fingerprinting. Assim como a web deveria ser.

O problema é que esses são a exceção. Os sites que têm dados financeiros, notícias exclusivas ou conteúdo premium — exatamente os dados que mais importam — estão cada vez mais blindados.

## O Primeiro Obstáculo: SPAs e JavaScript Rendering

Quando o servidor retorna algo tipo:

```html
<html>
<body>
  <div id="root"></div>
  <script src="/app-3fa8c2.js"></script>
</body>
</html>
```

Seu `Net::HTTP.get` retorna exatamente isso: uma div vazia e um link pra um bundle de 2 MB. O conteúdo real — artigos, preços, listas — é montado no browser por React, Vue, Angular ou o framework da semana.

Pra um script, essa página é inútil. Pra extrair o conteúdo, você precisa executar o JavaScript. Isso significa rodar um browser real.

No mundo Ruby, a resposta é a gem `ferrum` — um cliente CDP (Chrome DevTools Protocol) que controla o Chromium programaticamente:

```ruby
browser = Ferrum::Browser.new(headless: "new", timeout: 30)
browser.go_to("https://www.morningstar.com/markets")
browser.network.wait_for_idle  # espera o JS terminar de carregar
html = browser.body  # agora sim o DOM está populado
browser.quit
```

Esse `browser.body` retorna o HTML **depois** que o JavaScript executou. Mesmos dados que você vê no browser, agora acessíveis pro seu parser.

Mas aqui começa a dor de cabeça: você precisa de um binário do Chromium disponível no sistema. No Docker, isso significa adicionar ~300MB à imagem. No servidor, significa mais uma dependência pra gerenciar. E a latência de abrir um browser, navegar, esperar JS renderizar, e extrair o HTML — estamos falando de 3 a 10 segundos por página, ao invés dos 200ms de um HTTP GET.

O projeto usa isso como estratégia principal no `ArticleFetcher`: primeiro tenta com browser (pra pegar SPAs), depois faz um fallback HTTP simples (pra pegar metadata OpenGraph quando o browser falha). A maioria dos links que os leitores mandam no Discord são de sites que renderizam com JavaScript, então o browser-first compensa.

## O Segundo Obstáculo: Bot Detection

Abrir uma página com Chromium headless resolve o problema de JavaScript. Mas resolve 50% dos sites — não 100%. Porque existe uma indústria inteira dedicada a distinguir browsers reais de browsers automatizados.

### O Que o Headless Chrome Revela

Chromium em modo headless é quase idêntico ao Chrome normal. Quase. As diferenças são sutis, mas suficientes pra detecção:

**1. `navigator.webdriver`** — Em todo Chrome controlado por automação, essa propriedade retorna `true`. Em browsers normais, `undefined`. É o flag mais óbvio.

**2. `navigator.plugins`** — Chrome normal tem 3-5 plugins (PDF viewer, etc.). Headless retorna array vazio. Bot detectado.

**3. `navigator.userAgentData`** — A Client Hints API. Chrome real retorna brands, platform, mobile flag. Headless pode não ter isso.

**4. WebGL fingerprint** — O renderer WebGL num headless Chrome retorna "SwiftShader" (renderizador por software). Chrome real retorna "NVIDIA GeForce" ou "Intel Iris" ou o que for. Bot detectado.

**5. Timing e behavior** — Browsers reais demoram pra carregar. Fazem scroll. Movem o mouse. Têm focus events. Um script que faz `go_to` → `body` em 2 segundos não se parece com um humano.

A solução é o que chamo de StealthBrowser — um wrapper que injeta patches JavaScript antes de qualquer script da página rodar:

```ruby
class StealthBrowser
  STEALTH_JS = <<~JS
    // Remove o flag de automação
    Object.defineProperty(navigator, 'webdriver', { get: () => false });

    // Simula plugins reais
    Object.defineProperty(navigator, 'plugins', {
      get: () => [
        { name: 'Chrome PDF Plugin', filename: 'internal-pdf-viewer' },
        { name: 'Chrome PDF Viewer', filename: 'mhjfbmdgcfjbbpaeojofohoefgiehjai' },
        { name: 'Native Client', filename: 'internal-nacl-plugin' }
      ]
    });

    // Simula WebGL renderer real
    const getParameter = WebGLRenderingContext.prototype.getParameter;
    WebGLRenderingContext.prototype.getParameter = function(p) {
      if (p === 37445) return 'Google Inc. (NVIDIA)';
      if (p === 37446) return 'ANGLE (NVIDIA, GeForce GTX 1080 ...)';
      return getParameter.call(this, p);
    };

    // Client Hints API (ausente em headless = bot signal)
    if (!navigator.userAgentData) {
      Object.defineProperty(navigator, 'userAgentData', {
        get: () => ({
          brands: [
            { brand: 'Chromium', version: '131' },
            { brand: 'Google Chrome', version: '131' }
          ],
          mobile: false, platform: 'Linux'
        })
      });
    }
  JS

  def self.fetch(url, name:, wait_for: nil)
    browser = Ferrum::Browser.new(headless: "new", timeout: 30,
      browser_options: {
        "disable-blink-features" => "AutomationControlled",
        "user-agent" => REAL_USER_AGENT
      })

    # Injeta ANTES de qualquer script da página rodar
    browser.page.command("Page.addScriptToEvaluateOnNewDocument", source: STEALTH_JS)

    browser.go_to(url)
    yield browser
  ensure
    browser&.quit
  end
end
```

O truque-chave é `Page.addScriptToEvaluateOnNewDocument` — um comando CDP que registra o JavaScript pra ser executado **antes** de qualquer script da página. Isso significa que, quando o bot detector roda, ele vê os valores falsos que injetamos, e não os reais. E `disable-blink-features=AutomationControlled` remove o flag `navigator.webdriver` no nível do browser, antes mesmo do JavaScript.

Isso funciona pra maioria dos sites. Morningstar, Hindenburg Research, sites de notícias genéricos — passam com o stealth. Yahoo Finance precisa de mais — TLS fingerprinting que bloqueia até o Chromium sem crumb authentication. Mas o browser stealth resolve o grosso.

## O Terceiro Obstáculo: DataDome e CDPs de Anti-Bot

E aí chegamos aos profissionais. **DataDome**, Cloudflare Turnstile, PerimeterX, Akamai Bot Manager — são serviços especializados em detectar automação. E eles jogam num nível completamente diferente.

A Reuters, por exemplo, usa DataDome. Quando tentei acessar `reuters.com/world/` com o StealthBrowser, recebi de volta uma página de 1.500 bytes com um captcha JavaScript. Todos os patches de `navigator.webdriver`, WebGL, plugins — inúteis.

Por quê? Porque o DataDome não checa só propriedades JavaScript. Ele detecta o **próprio protocolo de automação**.

### O Problema Fundamental do CDP

Quando o **Ferrum** (ou Puppeteer, ou Playwright) controla um Chrome, ele faz isso via Chrome DevTools Protocol — o CDP. E a primeira coisa que o Ferrum faz ao conectar é enviar `Runtime.enable` — um comando que ativa o runtime evaluation no browser.

O problema é que `Runtime.enable` muda o comportamento observável do browser. Especificamente, ele ativa interceptors internos que podem ser detectados via `console.debug`. O DataDome usa isso: ele faz um `console.debug` com um getter que observa se o runtime está interceptando. Se está — e com CDP sempre está — bot detectado.

```javascript
// O que o DataDome faz (simplificado):
let detected = false;
const el = document.createElement('div');
Object.defineProperty(el, 'id', {
  get: () => { detected = true; return 'test'; }
});
console.debug(el);
// Se Runtime.enable está ativo, o getter é trigado
// Em um browser normal, não é
```

Isso não é algo que você pode patchar com JavaScript. O `Runtime.enable` é mandado pelo Ferrum **antes** de qualquer script rodar — é parte do protocolo de automação. Pra resolver, você precisaria modificar o Ferrum pra não mandar esse comando, o que quebraria a maioria das funcionalidades da gem.

### As Alternativas (e Por Que Nenhuma é Ideal)

Pesquisei extensivamente. As opções:

1. **nodriver (Python)**: Usa Chrome via CDP sem `Runtime.enable`. Não tem equivalente em Ruby. E mesmo assim, está numa corrida de gato-e-rato com DataDome.

2. **curl-impersonate**: Faz TLS fingerprinting idêntico ao Chrome sem abrir um browser. Bom pra sites com TLS detection, inútil pra SPAs.

3. **Scraping APIs** (ScraperAPI, ZenRows): Terceirizam o problema. Funcionam, mas custam dinheiro e adicionam latência e dependência.

4. **Fork do Ferrum**: Modificar a gem pra opcionalmente não mandar `Runtime.enable`. Viável tecnicamente, mas manutenção infinita.

5. **Google News RSS**: O Google já leu a Reuters. O resultado tá num feed RSS público. Sem JavaScript, sem DataDome, sem browser.

A opção 5 venceu. Pra Reuters, troquei toda a complexidade de headless browser por:

```ruby
class ReutersClient
  RSS_URL = "https://news.google.com/rss/search?q=when:24h+allinurl:reuters.com/world"

  def self.fetch_headlines(limit: 10)
    xml = Net::HTTP.get(URI(RSS_URL))
    doc = REXML::Document.new(xml)
    doc.get_elements("//item").first(limit).filter_map do |item|
      title = item.get_text("title")&.to_s&.strip
      url   = item.get_text("link")&.to_s&.strip
      next if title.blank? || url.blank?
      { title: title.sub(/\s*-\s*Reuters\s*\z/, ""), url: url, category: nil }
    end
  rescue StandardError => e
    Rails.logger.warn("ReutersClient failed: #{e.message}")
    []
  end
end
```

Simples. Confiável. Zero dependências de browser. O link do Google News redireciona pro artigo original quando o leitor clica — funciona perfeitamente pra uma newsletter.

A lição: **nem todo problema de scraping precisa de uma solução de scraping**. Às vezes o dado já está disponível num formato acessível — você só precisa encontrar.

## O Quarto Obstáculo: Sites que Mudam de Estrutura (Diariamente)

Mesmo quando o scraping funciona, a manutenção nunca para. O Morningstar é um caso didático — porque me fez errar **duas vezes** antes de chegar numa solução resiliente.

### Tentativa 1: Selecionar pela Hierarquia DOM

Originalmente, os links de artigos estavam dentro de `<h2>` e `<h3>`:

```html
<h2><a href="/markets/article-slug">Título do Artigo</a></h2>
```

Um dia depois: zero resultados. O Morningstar mudou a estrutura pra flat links com classes CSS específicas — sem heading elements:

```html
<a class="mdc-basic-feed-item__mdc" href="/markets/article-slug">
  <header><h3>Título do Artigo</h3></header>
  <div class="mdc-metadata__mdc">Autor · Data</div>
</a>
```

### Tentativa 2: Selecionar pela Classe CSS

A correção óbvia: trocar hierarquia DOM por seletores CSS baseados na classe do componente:

```ruby
ARTICLE_CSS = "a.mdc-basic-feed-item__mdc, a.mdc-card--link__mdc"
doc.css(ARTICLE_CSS).each { |link| ... }
```

Funcionou. Por exatamente um dia. Depois: zero resultados de novo. O Morningstar — como muitos sites modernos com frameworks CSS-in-JS — gera nomes de classe dinamicamente. O que era `mdc-basic-feed-item__mdc` virou outra coisa. E pode virar algo diferente amanhã.

Isso é cada vez mais comum. Sites que usam CSS Modules, styled-components, ou Tailwind com JIT geram hashes aleatórios nos nomes de classe como parte do build. A cada deploy do site, as classes mudam. Seu seletor hardcoded é uma bomba-relógio.

### Tentativa 3: Não Depender de Nenhum Nome de Classe

A solução final é inverter a lógica: ao invés de dizer ao parser **quais** classes procurar, deixar o parser **descobrir** quais links são artigos baseado em propriedades estruturais que não mudam:

1. **Links de artigos têm URLs longas**: `/news/why-stock-market-is-up-today-2026-02-17` vs links de navegação como `/markets` ou `/tools`
2. **Links de artigos são agrupados**: aparecem em listas, feeds, grids — múltiplos links com a mesma classe CSS
3. **Links de artigos têm títulos descritivos**: textos longos, não labels curtas como "Markets" ou "Tools"

O algoritmo:

```ruby
def self.parse_html(html, limit)
  doc = Nokogiri::HTML(html)

  # 1. Coleta todos os <a> internos com href, classe, e texto suficiente
  candidates = doc.css("a[href]").filter_map do |link|
    href = link["href"].to_s.strip
    css_class = link["class"].to_s.strip
    next if href.blank? || css_class.blank?
    next unless internal_href?(href)

    path = extract_path(href)
    segments = path.split("/").reject(&:empty?)
    next if segments.length < 2  # links de nav têm 1 segmento: /markets

    title = extract_title(link)
    next if title.blank? || title.length < 10

    { title: title, url: absolutize(href), css_class: css_class, slug_length: path.length }
  end

  # 2. Agrupa por classe CSS
  groups = candidates.group_by { |c| c[:css_class] }

  # 3. Filtra: mínimo 3 links no grupo (clusters de artigos, não links soltos)
  # 4. Seleciona o grupo com maior média de comprimento de slug
  best = groups
    .select { |_cls, items| items.length >= 3 }
    .max_by { |_cls, items| items.sum { |i| i[:slug_length] }.to_f / items.length }

  return [] unless best

  best[1].map { |c| c.slice(:title, :url) }.uniq { |a| a[:url] }.first(limit)
end
```

A beleza dessa abordagem: **nenhum nome de classe é hardcoded**. O Morningstar pode renomear todas as classes amanhã e o parser vai continuar funcionando — porque ele descobre o padrão de artigos pela estrutura, não pelo nome.

O que é estável num site:

- **URLs de artigos são sempre mais longas** que URLs de navegação (isso é arquitetural, não cosmético)
- **Artigos são sempre agrupados** sob o mesmo componente (isso é UX, não implementação)
- **Títulos de artigos são descritivos** (isso é editorial, não técnico)

O que **não** é estável:

- Nomes de classes CSS (mudam a cada build)
- Hierarquia DOM (muda a cada redesign)
- Atributos `data-*` (mudam conforme a equipe de frontend decide)

A lição: **não tente identificar elementos pelo nome — identifique pelo comportamento**. Links de artigos se comportam diferente de links de navegação de formas mensuráveis (URL length, clustering, título), e essas propriedades são inerentes ao que o elemento É, não a como ele foi implementado.

## A Hierarquia de Confiabilidade

Depois de horas lidando com isso, emerge uma hierarquia clara de fontes de dados, da mais pra menos confiável:

| Fonte | Confiabilidade | Latência | Manutenção |
|-------|---------------|----------|------------|
| API oficial (JSON) | Alta | ~200ms | Baixa |
| RSS/Atom feed | Alta | ~300ms | Baixa |
| HTML server-rendered | Média | ~500ms | Média |
| SPA com headless browser | Baixa-Média | ~5s | Alta |
| Site com anti-bot ativo | Baixa | ~8s+ | Altíssima |

A regra: **sempre prefira a fonte mais simples que funcione**. Se o site tem RSS, use RSS. Se tem API, use a API. Só vá pro headless browser quando não há alternativa.

No projeto, a distribuição ficou assim:

**HTTP simples** (Net::HTTP ou HTTParty):

- Google News RSS (Reuters world headlines)
- Hacker News RSS (top stories)
- HackerNoon RSS (top stories)
- dev.to API (trending articles)
- Jikan API (anime rankings)
- YouTube Data API (vídeos)
- Yahoo Finance news RSS

**Headless browser** (StealthBrowser + Ferrum):

- Morningstar (SPA + componentes dinâmicos)
- Yahoo Finance charts (TLS fingerprinting + crumb auth)
- FinViz market map (canvas rendering)
- Artigos genéricos de leitores (qualquer URL pode ser SPA)
- Hindenburg Research (JavaScript-rendered)

Ou seja: **a maioria das fontes de dados funciona sem browser**. O browser é necessário pra meia dúzia de sites problemáticos — mas são esses sites que dão mais trabalho.

## O Custo Real

Vamos ser práticos sobre o que "empacotar um Chrome" significa:

**Imagem Docker**: +300MB. O Chromium e suas dependências (fontes, libs gráficas, sandbox) são enormes. Num Dockerfile otimizado com multi-stage build:

```dockerfile
# Instala Chromium e dependências mínimas
RUN apt-get install -y chromium fonts-liberation libnss3 libatk-bridge2.0-0 \
    libdrm2 libxkbcommon0 libgbm1
```

**Memória**: Cada instância de Chromium consome 200-400MB de RAM. Se você tem 3 workers paralelos, são 1.2GB só pra browsers. Num VPS de 2GB, isso é 60% da memória.

**Latência**: Uma página que leva 200ms via HTTP leva 3-8 segundos via headless browser (boot do processo, navegação, JS execution, network idle). Pra 10 fontes de dados, são 30-80 segundos ao invés de 2.

**Estabilidade**: Chromium pode crashar, travar, ou vazar memória. Timeout de 30 segundos com cleanup no `ensure` é obrigatório:

```ruby
def self.fetch(url, name:)
  browser = create(name: name)
  browser.go_to(url)
  yield browser
ensure
  browser&.quit  # SEMPRE quit, mesmo com exceção
end
```

Se não fizer o `quit`, o processo Chromium fica pendurado consumindo CPU e memória. Já tive servidor com 15 processos Chrome zumbis comendo 3GB de RAM porque um `ensure` estava faltando.

## O Futuro (Ou: Vai Piorar)

A tendência é clara: sites estão ficando mais difíceis de acessar programaticamente. A cada trimestre, os DataDomes e Cloudflares da vida adicionam novas técnicas de detecção. Chrome headless fica mais parecido com Chrome real — mas os detectores acompanham.

A web que nasceu aberta e legível por máquina está se tornando um jardim murado. Até RSS, que é trivial de implementar e útil pra todo mundo, está sendo abandonado por muitos sites — porque não querem que seus dados sejam lidos fora do contexto (e dos anúncios) do site original.

Pra quem constrói sistemas que agregam informação, o playbook é:

1. **Use APIs e feeds sempre que existirem**. É mais estável, mais rápido, mais respeitoso
2. **Mantenha um browser stealth pra SPAs** que não têm alternativa
3. **Nunca hardcode seletores CSS**. Sites com CSS-in-JS mudam nomes de classe a cada deploy. Identifique elementos por propriedades estruturais (comprimento de URL, clustering, tamanho do título) que sobrevivem a redesigns
4. **Detecte bloqueios e falhe graciosamente** — `og:description` como fallback, título extraído da URL como último recurso
5. **Nunca dependa de um único método de acesso**. O site que funciona hoje pode bloquear amanhã
6. **Aceite que alguns sites são inacessíveis**. Se o DataDome não deixa, o dado terá que vir de outra fonte

A web em 2026 é um campo de batalha entre quem quer ler e quem quer controlar a leitura. E se tem algo que aprendi: no longo prazo, a criatividade de quem quer acessar dados vence — mas custa mais esforço a cada ano. E, diferente do que eu pensei no começo: nunca é simples.
