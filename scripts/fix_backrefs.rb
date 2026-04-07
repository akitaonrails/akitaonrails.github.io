#!/usr/bin/env ruby
# frozen_string_literal: true
#
# fix_backrefs.rb — Update internal links in post BODY after i18n slug migration.
#
# For each translated post (index.md with aliases:), builds a mapping:
#   old EN URL → new PT URL
#
# Then scans all content files for references to old EN URLs in the BODY ONLY
# (frontmatter is left untouched — aliases must keep the old URL for redirects).
#
# Replacement rules:
#   - In PT files (index.md): replace with new PT slug URL
#   - In EN files (index.en.md): replace with /en/ + new PT slug URL
#
# Run with --dry-run to preview changes without writing.

require 'yaml'

DRY_RUN = ARGV.include?('--dry-run')
CONTENT_DIR = 'content'
FRONTMATTER_DELIMITER = '---'

def split_frontmatter(content)
  return [nil, content] unless content.start_with?("#{FRONTMATTER_DELIMITER}\n")
  end_index = content.index("\n#{FRONTMATTER_DELIMITER}\n", 4)
  return [nil, content] unless end_index
  fm_end = end_index + "\n#{FRONTMATTER_DELIMITER}\n".length
  [content[0...fm_end], content[fm_end..]]
end

def extract_frontmatter(content)
  return nil unless content.start_with?("#{FRONTMATTER_DELIMITER}\n")
  end_index = content.index("\n#{FRONTMATTER_DELIMITER}\n", 4)
  return nil unless end_index
  YAML.safe_load(content[4..end_index], permitted_classes: [Date, Time])
rescue Psych::SyntaxError
  nil
end

# Build mapping: old_url => new_pt_url
mapping = {}
Dir.glob("#{CONTENT_DIR}/**/index.md").each do |path|
  content = File.read(path)
  fm = extract_frontmatter(content)
  next unless fm

  aliases = Array(fm['aliases']).map(&:to_s)
  next if aliases.empty?

  new_slug = fm['slug'].to_s
  next if new_slug.empty?

  dir = File.dirname(path).delete_prefix("#{CONTENT_DIR}/")
  year_path = dir.split('/').first(3).join('/')

  aliases.each do |old_url|
    old_url = "/#{old_url.gsub(%r{^/|/$}, '')}/"
    new_url  = "/#{year_path}/#{new_slug}/"
    mapping[old_url] = new_url unless old_url == new_url
  end
end

puts "Built mapping with #{mapping.size} slug redirects."

changes_total = 0

Dir.glob("#{CONTENT_DIR}/**/*.md").sort.each do |path|
  next if path.end_with?('_index.md') || path.end_with?('_index.en.md')

  is_en = path.end_with?('.en.md')
  content = File.read(path)

  # Split into frontmatter and body — only update the body
  fm_section, body = split_frontmatter(content)
  next unless body

  new_body = body.dup

  mapping.each do |old_url, new_pt_url|
    target_url = is_en ? "/en#{new_pt_url}" : new_pt_url

    # Replace bare URL and URL without trailing slash
    [old_url, old_url.chomp('/')].each do |from|
      to = from.end_with?('/') ? target_url : target_url.chomp('/')
      next if from == to
      new_body = new_body.gsub(from, to) if new_body.include?(from)
    end
  end

  next if new_body == body

  new_content = fm_section ? (fm_section + new_body) : new_body
  changes_total += 1

  if DRY_RUN
    puts "WOULD UPDATE: #{path}"
    body.lines.zip(new_body.lines).each_with_index do |(old_l, new_l), i|
      next if old_l == new_l
      puts "  line #{i + 1 + (fm_section ? fm_section.lines.size : 0)}:"
      puts "    OLD: #{old_l.chomp}"
      puts "    NEW: #{new_l.chomp}"
    end
  else
    File.write(path, new_content)
    puts "Updated: #{path}"
  end
end

puts "\nTotal files #{DRY_RUN ? 'that would be' : ''} updated: #{changes_total}"
