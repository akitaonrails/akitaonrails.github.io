#!/usr/bin/env ruby
# frozen_string_literal: true
#
# migrate_phase3_pairs.rb — Merge "chatting with" EN dirs into "conversando com" PT dirs.
#
# Each PT "conversando-com-*" dir becomes the canonical home.
# The EN "chatting-with-*" content moves in as index.en.md.
# Old EN URL is preserved via aliases: in the PT index.md.

require 'yaml'
require 'fileutils'

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

def parse_frontmatter(content)
  return [nil, nil, content] unless content.start_with?("#{FRONTMATTER_DELIMITER}\n")
  end_index = content.index("\n#{FRONTMATTER_DELIMITER}\n", 4)
  return [nil, nil, content] unless end_index
  yaml_str = content[4..end_index]
  fm = YAML.safe_load(yaml_str, permitted_classes: [Date, Time])
  fm_end = end_index + "\n#{FRONTMATTER_DELIMITER}\n".length
  body = content[fm_end..]
  [fm, yaml_str, body]
rescue Psych::SyntaxError => e
  warn "YAML parse error: #{e.message}"
  [nil, nil, content]
end

def serialize_frontmatter(fm)
  YAML.dump(fm).sub(/\A---\n/, '').strip
end

def build_content(fm, body)
  "---\n#{serialize_frontmatter(fm)}\n---\n#{body}"
end

def merge_pair(pt_dir, en_dir, translation_key, dry_run: false)
  pt_index = "#{pt_dir}/index.md"
  en_index = "#{en_dir}/index.md"

  unless File.exist?(pt_index)
    warn "SKIP: PT file not found: #{pt_index}"
    return false
  end
  unless File.exist?(en_index)
    warn "SKIP: EN file not found: #{en_index}"
    return false
  end

  pt_content = File.read(pt_index)
  pt_fm, _, pt_body = parse_frontmatter(pt_content)
  return false unless pt_fm

  en_content = File.read(en_index)
  en_fm, _, en_body = parse_frontmatter(en_content)
  return false unless en_fm

  en_slug = File.basename(en_dir)
  pt_slug = pt_fm['slug'] || File.basename(pt_dir)

  # Old EN URL: extract date from EN dir path
  en_path_parts = en_dir.delete_prefix("#{CONTENT_DIR}/").split('/')
  # e.g. ["2007", "04", "16", "chatting-with-dr-nic"]
  en_date_path = en_path_parts.first(3).join('/')
  old_en_url = "/#{en_date_path}/#{en_slug}/"

  puts "PAIR: #{File.basename(pt_dir)} <-> #{File.basename(en_dir)}"
  puts "  translationKey: #{translation_key}"
  puts "  old EN URL → alias: #{old_en_url}"

  # Update PT frontmatter
  pt_fm['translationKey'] = translation_key
  pt_fm['slug'] = pt_slug unless pt_fm['slug']
  existing_aliases = Array(pt_fm['aliases']).map(&:to_s)
  unless existing_aliases.include?(old_en_url)
    existing_aliases << old_en_url
    pt_fm['aliases'] = existing_aliases
  end

  # Update EN frontmatter
  en_fm['translationKey'] = translation_key
  en_fm['slug'] = en_slug
  en_tags = Array(en_fm['tags']).map(&:to_s)
  en_tags.reject! { |t| %w[english translation traduzido].include?(t) }
  en_fm['tags'] = en_tags.empty? ? nil : en_tags
  en_fm.delete('tags') if en_fm['tags'].nil?

  unless dry_run
    File.write(pt_index, build_content(pt_fm, pt_body))
    puts "  Updated PT: #{pt_index}"

    en_sibling = "#{pt_dir}/index.en.md"
    File.write(en_sibling, build_content(en_fm, en_body))
    puts "  Created EN sibling: #{en_sibling}"

    # Copy assets from EN dir
    Dir.glob("#{en_dir}/**/*").each do |src|
      next if File.directory?(src)
      next if src == en_index
      rel = src.delete_prefix("#{en_dir}/")
      dst = "#{pt_dir}/#{rel}"
      unless File.exist?(dst)
        FileUtils.cp(src, dst)
        puts "  Copied asset: #{dst}"
      end
    end

    FileUtils.rm_rf(en_dir)
    puts "  Deleted EN dir: #{en_dir}"
  else
    puts "  DRY RUN"
  end

  true
end

# [pt_dir, en_dir, translation_key]
PAIRS = [
  # 2007/04
  ['content/2007/04/16/conversando-com-dr-nic',
   'content/2007/04/16/chatting-with-dr-nic',
   'chatting-dr-nic'],
  ['content/2007/04/21/conversando-com-geoffrey-grosenbach',
   'content/2007/04/19/chatting-with-geoffrey-grosenbach',
   'chatting-geoffrey-grosenbach'],
  # 2007/05
  ['content/2007/05/07/conversando-com-chad-fowler',
   'content/2007/05/04/chatting-with-chad-fowler',
   'chatting-chad-fowler'],
  ['content/2007/05/11/conversando-com-david-black',
   'content/2007/05/11/chatting-with-david-black',
   'chatting-david-black'],
  # 2007/06
  ['content/2007/06/21/conversando-com-ola-bini-jruby-core-team-member',
   'content/2007/06/21/chatting-with-ola-bini-jruby-core-team-member',
   'chatting-ola-bini'],
  # 2007/07
  ['content/2007/07/20/conversando-com-carl-youngblood',
   'content/2007/07/20/chatting-with-carl-youngblood',
   'chatting-carl-youngblood'],
  # 2007/08
  ['content/2007/08/06/conversando-com-jamis-buck',
   'content/2007/08/03/chatting-with-jamis-buck',
   'chatting-jamis-buck'],
  # 2007/11
  ['content/2007/11/12/conversando-com-john-lam-ironruby',
   'content/2007/11/12/chatting-with-john-lam-ironruby',
   'chatting-john-lam'],
  # 2007/12
  ['content/2007/12/15/conversando-com-avi-bryant-parte-1',
   'content/2007/12/15/chatting-with-avi-bryant-part-1',
   'chatting-avi-bryant-part-1'],
  ['content/2007/12/22/conversando-com-avi-bryant-parte-2',
   'content/2007/12/22/chatting-with-avi-bryant-part-2',
   'chatting-avi-bryant-part-2'],
  # 2008/01
  ['content/2008/01/01/conversando-com-adrian-holovaty',
   'content/2008/01/01/chatting-with-adrian-holovaty',
   'chatting-adrian-holovaty'],
  ['content/2008/01/09/conversando-com-peter-cooper',
   'content/2008/01/04/chatting-with-peter-cooper',
   'chatting-peter-cooper'],
  # 2008/02
  ['content/2008/02/11/conversando-com-evan-phoenix',
   'content/2008/02/11/chatting-with-evan-phoenix',
   'chatting-evan-phoenix'],
  # 2008/09
  ['content/2008/09/27/conversando-com-joshua-peek',
   'content/2008/09/26/chatting-with-joshua-peek',
   'chatting-joshua-peek'],
].freeze

puts "Phase 3 pair migration — #{DRY_RUN ? 'DRY RUN' : 'LIVE'}"
puts "=" * 60

success = 0
failures = 0

PAIRS.each do |pt_dir, en_dir, translation_key|
  if merge_pair(pt_dir, en_dir, translation_key, dry_run: DRY_RUN)
    success += 1
  else
    failures += 1
  end
  puts
end

puts "=" * 60
puts "Done: #{success} pairs merged, #{failures} failures"
