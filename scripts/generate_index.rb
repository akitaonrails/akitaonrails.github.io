#!/usr/bin/env ruby
# frozen_string_literal: true

require 'yaml'
require 'date'

CONTENT_DIR = 'content'
OUTPUT_FILE = "#{CONTENT_DIR}/_index.md"
FRONTMATTER_DELIMITER = '---'

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

def collect_posts
  Dir.glob("#{CONTENT_DIR}/**/index.md")
     .reject { |path| path == "#{CONTENT_DIR}/index.md" || path == "#{CONTENT_DIR}/_index.md" }
     .filter_map { |path| parse_post(path) }
end

def group_by_month(posts)
  posts
    .sort_by { |post| post[:date] }
    .reverse
    .group_by { |post| [post[:date].year, post[:date].month] }
end

def generate_index(grouped_posts)
  sorted_months = grouped_posts.keys.sort.reverse

  lines = ["#{FRONTMATTER_DELIMITER}\ntitle: AkitaOnRails's Blog\n#{FRONTMATTER_DELIMITER}\n"]

  sorted_months.each do |(year, month)|
    month_name = Date::MONTHNAMES[month]
    lines << "## #{year} - #{month_name}\n"

    grouped_posts[[year, month]].each do |post|
      lines << "- [#{escape_markdown(post[:title])}](#{post[:url]})"
    end

    lines << ''
  end

  lines.join("\n")
end

posts = collect_posts
grouped = group_by_month(posts)
File.write(OUTPUT_FILE, generate_index(grouped))

puts "Generated #{OUTPUT_FILE} with #{posts.size} posts grouped by year & month."
