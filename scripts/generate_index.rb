#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'
require 'date'

CONTENT_DIR = 'content'
INDEX_FILE = "#{CONTENT_DIR}/_index.md"
INDEX_FILE_EN = "#{CONTENT_DIR}/_index.en.md"
ARCHIVES_DIR = "#{CONTENT_DIR}/archives"
ARCHIVES_FILE = "#{ARCHIVES_DIR}/_index.md"
ARCHIVES_FILE_EN = "#{ARCHIVES_DIR}/_index.en.md"
FRONTMATTER_DELIMITER = '---'

# Posts from January of last year onward appear on the main index.
# Everything older goes to the archives page.
CUTOFF_YEAR = Date.today.year - 1

def escape_markdown(text)
  text.to_s.gsub('[', '\\[').gsub(']', '\\]')
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

  { title: frontmatter['title'], url: url, date: date, has_en: has_en, lang: lang }
rescue ArgumentError, Psych::SyntaxError => e
  warn "Error parsing #{path}: #{e.message}"
  nil
end

def collect_posts(include_future: false)
  now = DateTime.now
  Dir.glob("#{CONTENT_DIR}/**/index.md")
     .reject { |path| path == "#{CONTENT_DIR}/index.md" || path == "#{CONTENT_DIR}/_index.md" }
     .reject { |path| path.start_with?("#{ARCHIVES_DIR}/") }
     .filter_map { |path| parse_post(path, lang: :pt) }
     .select { |post| include_future || post[:date] <= now }
end

def collect_posts_en(include_future: false)
  now = DateTime.now
  Dir.glob("#{CONTENT_DIR}/**/index.en.md")
     .reject { |path| path.start_with?("#{ARCHIVES_DIR}/") }
     .filter_map { |path| parse_post(path, lang: :en) }
     .select { |post| include_future || post[:date] <= now }
end

def group_by_month(posts)
  posts
    .sort_by { |post| post[:date] }
    .reverse
    .group_by { |post| [post[:date].year, post[:date].month] }
end

def render_months(grouped_posts)
  sorted_months = grouped_posts.keys.sort.reverse
  lines = []

  sorted_months.each do |(year, month)|
    month_name = Date::MONTHNAMES[month]
    lines << "## #{year} - #{month_name}\n"

    grouped_posts[[year, month]].each do |post|
      lines << "- [#{escape_markdown(post[:title])}](#{post[:url]})"
    end

    lines << ''
  end

  lines
end

def generate_index(grouped_posts)
  lines = ["#{FRONTMATTER_DELIMITER}\ntitle: AkitaOnRails Blog\n#{FRONTMATTER_DELIMITER}\n"]
  lines << '{{< lang-toggle >}}'
  lines << ''
  lines.concat(render_months(grouped_posts))
  lines << "[Arquivo completo →](/archives/)\n"
  lines.join("\n")
end

def generate_archives(grouped_posts)
  lines = ["#{FRONTMATTER_DELIMITER}\ntitle: AkitaOnRails Blog - Arquivo\n#{FRONTMATTER_DELIMITER}\n"]
  lines << '{{< lang-toggle >}}'
  lines << ''
  lines.concat(render_months(grouped_posts))
  lines.join("\n")
end

def generate_index_en(grouped_posts)
  lines = ["#{FRONTMATTER_DELIMITER}\ntitle: AkitaOnRails Blog\n#{FRONTMATTER_DELIMITER}\n"]
  lines << '{{< lang-toggle >}}'
  lines << ''
  if grouped_posts.empty?
    lines << "_No posts translated to English yet. Check back soon._\n"
  else
    lines.concat(render_months(grouped_posts))
  end
  lines << "[Full archive →](/en/archives/)\n"
  lines.join("\n")
end

def generate_archives_en(grouped_posts)
  lines = ["#{FRONTMATTER_DELIMITER}\ntitle: AkitaOnRails Blog - Archives\n#{FRONTMATTER_DELIMITER}\n"]
  lines << '{{< lang-toggle >}}'
  lines << ''
  if grouped_posts.empty?
    lines << "_Older posts are only available in Portuguese. Visit the [Portuguese archive](/archives/) to browse them._\n"
  else
    lines.concat(render_months(grouped_posts))
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
