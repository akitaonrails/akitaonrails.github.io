#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'
require 'date'
require 'cgi'

CONTENT_DIR = 'content'
INDEX_FILE = "#{CONTENT_DIR}/_index.md"
INDEX_FILE_EN = "#{CONTENT_DIR}/_index.en.md"
ARCHIVES_DIR = "#{CONTENT_DIR}/archives"
ARCHIVES_FILE = "#{ARCHIVES_DIR}/_index.md"
ARCHIVES_FILE_EN = "#{ARCHIVES_DIR}/_index.en.md"
AKITANDO_DIR = "#{CONTENT_DIR}/akitando"
AKITANDO_FILE = "#{AKITANDO_DIR}/_index.md"
OFF_TOPIC_DIR = "#{CONTENT_DIR}/off-topic"
OFF_TOPIC_FILE = "#{OFF_TOPIC_DIR}/_index.md"
OFF_TOPIC_FILE_EN = "#{OFF_TOPIC_DIR}/_index.en.md"
FRONTMATTER_DELIMITER = '---'

FEATURED_POSTS = [
  ['2026-07-17', 'LLM Benchmarks: Kimi K3', '/2026/07/17/llm-benchmarks-kimi-k3/'],
  ['2026-07-12', 'Notícias Quânticas: Majorana 2 e entendendo Shor', '/2026/07/12/noticias-quanticas-majorana-2-e-entendendo-shor/'],
  ['2026-07-12', 'Usando IA pra resolver meus probleminhas do dia-a-dia', '/2026/07/12/usando-ia-pra-resolver-meus-probleminhas-do-dia-a-dia/'],
  ['2026-07-11', 'Como me precaver pros meus agentes não apagarem minhas coisas?', '/2026/07/11/como-me-precaver-pros-meus-agentes-nao-apagarem-minhas-coisas/'],
  ['2026-07-09', 'LLM Benchmarks: Grok 4.5 e GPT 5.6 Sol', '/2026/07/09/llm-benchmark-grok-4-5-gpt-5-6-sol/'],
  ['2026-06-24', 'Por que LLMs vão falhar na Sua Empresa?', '/2026/06/24/por-que-llms-vao-falhar-na-sua-empresa/'],
  ['2026-06-11', 'LLM Benchmark: Fable 5 e a novela da Anthropic', '/2026/06/11/llm-benchmark-fable-5-e-a-novela-da-anthropic/'],
  ['2026-06-05', 'Controvérsia de IA em contribuições de projetos de código aberto - minha opinião', '/2026/06/05/controversia-ia-contribuicoes-projetos-codigo-aberto-minha-opiniao/'],
  ['2026-05-30', 'Boas práticas de projetos de código aberto com LLM - O Mínimo', '/2026/05/30/boas-praticas-projetos-codigo-aberto-llm-o-minimo/'],
  ['2026-04-25', 'LLM Benchmarks: Vale a Pena ($$) Misturar 2 Modelos? (Planner + Executor)', '/2026/04/25/llm-benchmarks-vale-a-pena-misturar-2-modelos/'],
  ['2026-04-24', 'Benchmark de LLMs pra Coding (Maio 2026): DeepSeek v4, Kimi v2.6, Grok 4.3, GPT 5.5', '/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/'],
  ['2026-04-20', 'Clean Code pra Agentes de IA', '/2026/04/20/clean-code-para-agentes-de-ia/'],
  ['2026-04-11', 'VS Code é o novo Cartão Perfurado', '/2026/04/11/vs-code-e-o-novo-cartao-perfurado/'],
  ['2026-02-24', 'RANT: o Akita abriu as pernas pra IA??', '/2026/02/24/rant-o-akita-abriu-as-pernas-pra-ia/'],
  ['2026-02-16', 'Vibe Code: Do Zero à Produção em 6 DIAS | The M.Akita Chronicles', '/2026/02/16/vibe-code-do-zero-a-producao-em-6-dias-the-m-akita-chronicles/'],
  ['2026-02-08', 'RANT: IA acabou com os programadores?', '/2026/02/08/rant-ia-acabou-com-programadores/'],
  ['2025-06-18', 'AGI ou Skynet não vão chegar tão cedo', '/2025/06/18/agi-ou-skynet-nao-vai-chegar-tao-cedo/'],
  ['2025-05-02', 'RANT - LLMs são LOOT BOXES!', '/2025/05/02/rant-llms-sao-loot-boxes/']
].freeze

FEATURED_POSTS_EN = [
  ['2026-07-17', 'LLM Benchmarks: Kimi K3', '/en/2026/07/17/llm-benchmarks-kimi-k3/'],
  ['2026-07-12', 'Quantum News: Majorana 2 and Understanding Shor', '/en/2026/07/12/quantum-news-majorana-2-and-understanding-shor/'],
  ['2026-07-12', 'Using AI to Solve My Little Day-to-Day Problems', '/en/2026/07/12/using-ai-to-solve-my-little-day-to-day-problems/'],
  ['2026-07-11', 'How Do I Protect Myself From My Agents Deleting My Stuff?', '/en/2026/07/11/how-to-protect-yourself-from-agents-deleting-your-stuff/'],
  ['2026-07-09', 'LLM Benchmarks: Grok 4.5 and GPT 5.6 Sol', '/en/2026/07/09/llm-benchmark-grok-4-5-gpt-5-6-sol/'],
  ['2026-06-24', 'Why LLMs Will Fail at Your Company', '/en/2026/06/24/why-llms-will-fail-at-your-company/'],
  ['2026-06-11', 'LLM Benchmark: Fable 5 and the Anthropic Soap Opera', '/en/2026/06/11/llm-benchmark-fable-5-anthropic-soap-opera/'],
  ['2026-06-05', 'AI Controversy in Open Source Project Contributions - My Take', '/en/2026/06/05/ai-controversy-open-source-project-contributions-my-take/'],
  ['2026-05-30', 'Open Source Best Practices with LLMs - The Bare Minimum', '/en/2026/05/30/open-source-best-practices-llm-the-minimum/'],
  ['2026-04-25', 'LLM Benchmarks: Is It Worth ($$) Mixing 2 Models? (Planner + Executor)', '/en/2026/04/25/llm-benchmarks-vale-a-pena-misturar-2-modelos/'],
  ['2026-04-24', 'LLM Coding Benchmark (May 2026): DeepSeek v4, Kimi v2.6, Grok 4.3, GPT 5.5', '/en/2026/04/24/llm-benchmarks-parte-3-deepseek-kimi-mimo/'],
  ['2026-04-20', 'Clean Code for AI Agents', '/en/2026/04/20/clean-code-for-ai-agents/'],
  ['2026-04-11', 'VS Code Is the New Punch Card', '/en/2026/04/11/vs-code-is-the-new-punch-card/'],
  ['2026-02-24', 'RANT: Did Akita Bend Over for AI??', '/en/2026/02/24/rant-akita-caved-to-ai/'],
  ['2026-02-16', 'Vibe Code: From Zero to Production in 6 DAYS | The M.Akita Chronicles', '/en/2026/02/16/vibe-code-zero-to-production-in-6-days-the-m-akita-chronicles/'],
  ['2026-02-08', 'RANT: Did AI Kill Programmers?', '/en/2026/02/08/rant-ai-killed-programmers/'],
  ['2025-06-18', "AGI or Skynet Isn't Coming Anytime Soon", '/en/2025/06/18/agi-or-skynet-isnt-coming-anytime-soon/'],
  ['2025-05-02', 'RANT - LLMs are LOOT BOXES!', '/en/2025/05/02/rant-llms-are-loot-boxes/']
].freeze

# Posts from January of last year onward appear on the main index.
# Everything older goes to the archives page.
CUTOFF_YEAR = Date.today.year - 1

def escape_markdown(text)
  text.to_s.gsub('[', '\\[').gsub(']', '\\]')
end

def escape_html(text)
  CGI.escapeHTML(text.to_s)
end

def extract_frontmatter(content)
  return nil unless content.start_with?("#{FRONTMATTER_DELIMITER}\n")

  end_index = content.index("\n#{FRONTMATTER_DELIMITER}\n", 4)
  return nil unless end_index

  yaml_content = content[4..end_index]
  YAML.safe_load(yaml_content, permitted_classes: [Date, Time])
end

def parse_post(path, lang: :pt)
  content = File.read(path)
  frontmatter = extract_frontmatter(content)
  return nil unless frontmatter&.dig('title') && frontmatter&.dig('date')

  date = DateTime.parse(frontmatter['date'].to_s)
  base_path = path.sub(%r{/index(\.en)?\.md\z}, '')
  dir_url = base_path.delete_prefix("#{CONTENT_DIR}/") # e.g. 2026/04/06/rag-esta-morto-contexto-longo

  # Honor a `slug:` frontmatter override (used by EN translations to get a
  # translated URL while keeping the original PT directory name on disk).
  if frontmatter['slug'] && !frontmatter['slug'].to_s.empty?
    slug = frontmatter['slug'].to_s
    parts = dir_url.split('/')
    parts[-1] = slug
    dir_url = parts.join('/')
  end

  url = '/' + dir_url + '/'
  url = '/en' + url if lang == :en

  has_en = File.exist?("#{base_path}/index.en.md")
  tags = Array(frontmatter['tags']).map(&:to_s)

  { title: frontmatter['title'], url: url, date: date, has_en: has_en, lang: lang, tags: tags }
rescue ArgumentError, Psych::SyntaxError => e
  warn "Error parsing #{path}: #{e.message}"
  nil
end

def akitando_post?(post)
  post[:tags].include?('akitando')
end

def off_topic_post?(post)
  post[:tags].include?('off-topic')
end

def collect_posts(include_future: false)
  now = DateTime.now
  Dir.glob("#{CONTENT_DIR}/**/index.md")
     .reject { |path| path == "#{CONTENT_DIR}/index.md" || path == "#{CONTENT_DIR}/_index.md" }
     .reject { |path| path.start_with?("#{ARCHIVES_DIR}/") }
     .reject { |path| path.start_with?("#{AKITANDO_DIR}/") }
     .reject { |path| path.start_with?("#{OFF_TOPIC_DIR}/") }
     .filter_map { |path| parse_post(path, lang: :pt) }
     .reject { |post| akitando_post?(post) }
     .select { |post| include_future || post[:date] <= now }
end

def collect_posts_en(include_future: false)
  now = DateTime.now
  Dir.glob("#{CONTENT_DIR}/**/index.en.md")
     .reject { |path| path.start_with?("#{ARCHIVES_DIR}/") }
     .reject { |path| path.start_with?("#{AKITANDO_DIR}/") }
     .reject { |path| path.start_with?("#{OFF_TOPIC_DIR}/") }
     .filter_map { |path| parse_post(path, lang: :en) }
     .reject { |post| akitando_post?(post) }
     .select { |post| include_future || post[:date] <= now }
end

def collect_off_topic_posts(include_future: false)
  now = DateTime.now
  Dir.glob("#{CONTENT_DIR}/**/index.md")
     .reject { |path| path == "#{CONTENT_DIR}/index.md" || path == "#{CONTENT_DIR}/_index.md" }
     .reject { |path| path.start_with?("#{ARCHIVES_DIR}/") }
     .reject { |path| path.start_with?("#{AKITANDO_DIR}/") }
     .reject { |path| path.start_with?("#{OFF_TOPIC_DIR}/") }
     .filter_map { |path| parse_post(path, lang: :pt) }
     .reject { |post| akitando_post?(post) }
     .select { |post| off_topic_post?(post) }
     .select { |post| include_future || post[:date] <= now }
end

def collect_off_topic_posts_en(include_future: false)
  now = DateTime.now
  Dir.glob("#{CONTENT_DIR}/**/index.en.md")
     .reject { |path| path.start_with?("#{ARCHIVES_DIR}/") }
     .reject { |path| path.start_with?("#{AKITANDO_DIR}/") }
     .reject { |path| path.start_with?("#{OFF_TOPIC_DIR}/") }
     .filter_map { |path| parse_post(path, lang: :en) }
     .reject { |post| akitando_post?(post) }
     .select { |post| off_topic_post?(post) }
     .select { |post| include_future || post[:date] <= now }
end

def collect_akitando_posts(include_future: false)
  now = DateTime.now
  Dir.glob("#{CONTENT_DIR}/**/index.md")
     .reject { |path| path == "#{CONTENT_DIR}/index.md" || path == "#{CONTENT_DIR}/_index.md" }
     .reject { |path| path.start_with?("#{ARCHIVES_DIR}/") }
     .reject { |path| path.start_with?("#{OFF_TOPIC_DIR}/") }
     .filter_map { |path| parse_post(path, lang: :pt) }
     .select { |post| akitando_post?(post) }
     .select { |post| include_future || post[:date] <= now }
end

def group_by_month(posts)
  posts
    .sort_by { |post| post[:date] }
    .reverse
    .group_by { |post| [post[:date].year, post[:date].month] }
end

PT_MONTHNAMES = [nil, 'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
                 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'].freeze

def render_months(grouped_posts, lang: :pt)
  sorted_months = grouped_posts.keys.sort.reverse
  lines = []

  sorted_months.each do |(year, month)|
    month_name = lang == :pt ? PT_MONTHNAMES[month] : Date::MONTHNAMES[month]
    lines << "## #{year} - #{month_name}\n"

    grouped_posts[[year, month]].each do |post|
      lines << "- [#{escape_markdown(post[:title])}](#{post[:url]})"
    end

    lines << ''
  end

  lines
end

def render_featured_posts
  render_featured_section(
    id: 'aor-featured-posts',
    title: 'Destaques',
    button_open: 'Esconder',
    button_closed: 'Mostrar',
    posts: FEATURED_POSTS
  )
end

def render_featured_posts_en
  render_featured_section(
    id: 'aor-featured-posts-en',
    title: 'Featured',
    button_open: 'Hide',
    button_closed: 'Show',
    posts: FEATURED_POSTS_EN
  )
end

def render_featured_section(id:, title:, button_open:, button_closed:, posts:)
  lines = []

  lines << <<~HTML.chomp
    <section id="#{id}" class="aor-featured" data-button-open="#{button_open}" data-button-closed="#{button_closed}">
      <div class="aor-featured__header">
        <h2>#{title}</h2>
        <button class="aor-featured__toggle" type="button" aria-expanded="true" aria-controls="#{id}-body">#{button_open}</button>
      </div>
      <div id="#{id}-body" class="aor-featured__body">
        <ul>
  HTML

  posts.each do |date, post_title, url|
    lines << "          <li><code>#{escape_html(date)}</code> — <a href=\"#{escape_html(url)}\">#{escape_html(post_title)}</a></li>"
  end

  lines << <<~HTML.chomp
        </ul>
      </div>
    </section>

    <style>
      .aor-featured {
        margin: 1.5rem 0;
        padding: 0.75rem 1rem;
        border: 1px solid color-mix(in srgb, currentColor 18%, transparent);
        border-radius: 0.75rem;
      }

      .aor-featured__header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 1rem;
      }

      .aor-featured__header h2 {
        margin: 0;
      }

      .aor-featured__toggle {
        cursor: pointer;
        border: 1px solid color-mix(in srgb, currentColor 25%, transparent);
        border-radius: 999px;
        padding: 0.25rem 0.7rem;
        background: transparent;
        color: inherit;
        font: inherit;
        font-size: 0.9rem;
      }

      .aor-featured__body {
        overflow: hidden;
        transition: max-height 220ms ease, opacity 160ms ease, margin-top 220ms ease;
        max-height: 40rem;
        opacity: 1;
        margin-top: 0.75rem;
      }

      .aor-featured.is-collapsed .aor-featured__body {
        max-height: 0;
        opacity: 0;
        margin-top: 0;
      }
    </style>

    <script>
      (function () {
        var box = document.getElementById('#{id}');
        if (!box) return;

        var button = box.querySelector('.aor-featured__toggle');
        var interacted = false;
        var openLabel = box.getAttribute('data-button-open') || 'Hide';
        var closedLabel = box.getAttribute('data-button-closed') || 'Show';

        function setCollapsed(collapsed) {
          box.classList.toggle('is-collapsed', collapsed);
          button.setAttribute('aria-expanded', collapsed ? 'false' : 'true');
          button.textContent = collapsed ? closedLabel : openLabel;
        }

        button.addEventListener('click', function () {
          interacted = true;
          setCollapsed(!box.classList.contains('is-collapsed'));
        });

        window.setTimeout(function () {
          if (interacted) return;
          setCollapsed(true);
        }, 1000);
      }());
    </script>
  HTML

  lines << ''
  lines
end

def generate_index(grouped_posts)
  lines = ["#{FRONTMATTER_DELIMITER}\ntitle: AkitaOnRails Blog\n#{FRONTMATTER_DELIMITER}\n"]
  lines << '{{< lang-toggle >}}'
  lines << ''
  lines.concat(render_featured_posts)
  lines.concat(render_months(grouped_posts, lang: :pt))
  lines << "[Arquivo completo →](/archives/)\n"
  lines.join("\n")
end

def generate_archives(grouped_posts)
  lines = ["#{FRONTMATTER_DELIMITER}\ntitle: AkitaOnRails Blog - Arquivo\n#{FRONTMATTER_DELIMITER}\n"]
  lines << '{{< lang-toggle >}}'
  lines << ''
  lines << 'Quer ver as transcrições do Canal Akitando? [Clique aqui](/akitando/).'
  lines << "Quer ver só os posts Off-Topic? [Clique aqui](/off-topic/).\n"
  lines.concat(render_months(grouped_posts, lang: :pt))
  lines.join("\n")
end

def generate_index_en(grouped_posts)
  lines = ["#{FRONTMATTER_DELIMITER}\ntitle: AkitaOnRails Blog\n#{FRONTMATTER_DELIMITER}\n"]
  lines << '{{< lang-toggle >}}'
  lines << ''
  lines.concat(render_featured_posts_en)
  if grouped_posts.empty?
    lines << "_No posts translated to English yet. Check back soon._\n"
  else
    lines.concat(render_months(grouped_posts, lang: :en))
  end
  lines << "[Full archive →](/en/archives/)\n"
  lines.join("\n")
end

def generate_archives_en(grouped_posts)
  lines = ["#{FRONTMATTER_DELIMITER}\ntitle: AkitaOnRails Blog - Archives\n#{FRONTMATTER_DELIMITER}\n"]
  lines << '{{< lang-toggle >}}'
  lines << ''
  lines << 'Want to see the Akitando Channel transcripts (Portuguese only)? [Click here](/akitando/).'
  lines << "Want to see only the Off-Topic posts? [Click here](/en/off-topic/).\n"
  if grouped_posts.empty?
    lines << "_Older posts are only available in Portuguese. Visit the [Portuguese archive](/archives/) to browse them._\n"
  else
    lines.concat(render_months(grouped_posts, lang: :en))
  end
  lines.join("\n")
end

def generate_akitando(grouped_posts)
  lines = ["#{FRONTMATTER_DELIMITER}\ntitle: Akitando - Transcrições\n#{FRONTMATTER_DELIMITER}\n"]
  lines << ''
  lines << 'Transcrições dos episódios do canal [Akitando](https://www.youtube.com/c/akitando) no YouTube.'
  lines << ''
  lines.concat(render_months(grouped_posts, lang: :pt))
  lines.join("\n")
end

def generate_off_topic(grouped_posts)
  lines = ["#{FRONTMATTER_DELIMITER}\ntitle: Off-Topic\n#{FRONTMATTER_DELIMITER}\n"]
  lines << '{{< lang-toggle >}}'
  lines << ''
  lines << 'Todos os posts Off-Topic do blog — filosofia, carreira, gerenciamento, e outros assuntos fora da programação do dia a dia.'
  lines << ''
  lines.concat(render_months(grouped_posts, lang: :pt))
  lines.join("\n")
end

def generate_off_topic_en(grouped_posts)
  lines = ["#{FRONTMATTER_DELIMITER}\ntitle: Off-Topic\n#{FRONTMATTER_DELIMITER}\n"]
  lines << '{{< lang-toggle >}}'
  lines << ''
  lines << "All Off-Topic posts from the blog — philosophy, career, management, and other topics outside of day-to-day programming."
  lines << ''
  if grouped_posts.empty?
    lines << "_No Off-Topic posts translated to English yet. Visit the [Portuguese Off-Topic page](/off-topic/) to browse them._\n"
  else
    lines.concat(render_months(grouped_posts, lang: :en))
  end
  lines.join("\n")
end

include_future = ARGV.include?('--future')
posts = collect_posts(include_future: include_future)
grouped = group_by_month(posts)

recent = grouped.select { |(year, _month), _| year >= CUTOFF_YEAR }
archived = grouped.select { |(year, _month), _| year < CUTOFF_YEAR }

Dir.mkdir(ARCHIVES_DIR) unless Dir.exist?(ARCHIVES_DIR)

File.write(INDEX_FILE, generate_index(recent))
recent_count = recent.values.flatten.size
puts "Generated #{INDEX_FILE} with #{recent_count} posts (#{CUTOFF_YEAR}+).#{' (including future posts)' if include_future}"

File.write(ARCHIVES_FILE, generate_archives(archived))
archived_count = archived.values.flatten.size
puts "Generated #{ARCHIVES_FILE} with #{archived_count} posts (before #{CUTOFF_YEAR}).#{' (including future posts)' if include_future}"

# English index — only posts with index.en.md siblings
posts_en = collect_posts_en(include_future: include_future)
grouped_en = group_by_month(posts_en)
recent_en = grouped_en.select { |(year, _month), _| year >= CUTOFF_YEAR }

File.write(INDEX_FILE_EN, generate_index_en(recent_en))
recent_en_count = recent_en.values.flatten.size
puts "Generated #{INDEX_FILE_EN} with #{recent_en_count} posts."

archived_en = grouped_en.select { |(year, _month), _| year < CUTOFF_YEAR }
File.write(ARCHIVES_FILE_EN, generate_archives_en(archived_en))
archived_en_count = archived_en.values.flatten.size
puts "Generated #{ARCHIVES_FILE_EN} with #{archived_en_count} posts (before #{CUTOFF_YEAR})."

# Akitando transcripts page (PT only — no EN translation, EN sidebar links to /akitando/)
Dir.mkdir(AKITANDO_DIR) unless Dir.exist?(AKITANDO_DIR)
akitando_posts = collect_akitando_posts(include_future: include_future)
grouped_akitando = group_by_month(akitando_posts)
File.write(AKITANDO_FILE, generate_akitando(grouped_akitando))
puts "Generated #{AKITANDO_FILE} with #{akitando_posts.size} posts."

# Off-Topic page (PT + EN)
Dir.mkdir(OFF_TOPIC_DIR) unless Dir.exist?(OFF_TOPIC_DIR)
off_topic_posts = collect_off_topic_posts(include_future: include_future)
grouped_off_topic = group_by_month(off_topic_posts)
File.write(OFF_TOPIC_FILE, generate_off_topic(grouped_off_topic))
puts "Generated #{OFF_TOPIC_FILE} with #{off_topic_posts.size} posts."

off_topic_posts_en = collect_off_topic_posts_en(include_future: include_future)
grouped_off_topic_en = group_by_month(off_topic_posts_en)
File.write(OFF_TOPIC_FILE_EN, generate_off_topic_en(grouped_off_topic_en))
puts "Generated #{OFF_TOPIC_FILE_EN} with #{off_topic_posts_en.size} posts."
