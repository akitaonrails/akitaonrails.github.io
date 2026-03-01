#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'
require 'date'

CONTENT_DIR = 'content'
INDEX_FILE = "#{CONTENT_DIR}/_index.md"
ARCHIVES_DIR = "#{CONTENT_DIR}/archives"
ARCHIVES_FILE = "#{ARCHIVES_DIR}/_index.md"
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

def parse_post(path)
  content = File.read(path)
  frontmatter = extract_frontmatter(content)
  return nil unless frontmatter&.dig('title') && frontmatter&.dig('date')

  date = DateTime.parse(frontmatter['date'].to_s)
  url = path.delete_prefix("#{CONTENT_DIR}/").delete_suffix('/index.md') + '/'

  { title: frontmatter['title'], url: url, date: date }
rescue ArgumentError, Psych::SyntaxError => e
  warn "Error parsing #{path}: #{e.message}"
  nil
end

def collect_posts(include_future: false)
  now = DateTime.now
  Dir.glob("#{CONTENT_DIR}/**/index.md")
     .reject { |path| path == "#{CONTENT_DIR}/index.md" || path == "#{CONTENT_DIR}/_index.md" }
     .reject { |path| path.start_with?("#{ARCHIVES_DIR}/") }
     .filter_map { |path| parse_post(path) }
     .select { |post| include_future || post[:date] <= now }
end

def group_by_month(posts)
  posts
    .sort_by { |post| post[:date] }
    .reverse
    .group_by { |post| [post[:date].year, post[:date].month] }
end

def render_months(grouped_posts, url_prefix: '')
  sorted_months = grouped_posts.keys.sort.reverse
  lines = []

  sorted_months.each do |(year, month)|
    month_name = Date::MONTHNAMES[month]
    lines << "## #{year} - #{month_name}\n"

    grouped_posts[[year, month]].each do |post|
      lines << "- [#{escape_markdown(post[:title])}](#{url_prefix}#{post[:url]})"
    end

    lines << ''
  end

  lines
end

def generate_index(grouped_posts)
  lines = ["#{FRONTMATTER_DELIMITER}\ntitle: AkitaOnRails Blog\n#{FRONTMATTER_DELIMITER}\n"]
  lines.concat(render_months(grouped_posts))
  lines << "[Arquivo completo →](/archives/)\n"
  lines.join("\n")
end

def generate_archives(grouped_posts)
  lines = ["#{FRONTMATTER_DELIMITER}\ntitle: AkitaOnRails Blog - Arquivo\n#{FRONTMATTER_DELIMITER}\n"]
  lines.concat(render_months(grouped_posts, url_prefix: '/'))
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
