#!/usr/bin/env ruby
# frozen_string_literal: true
#
# migrate_phase2_pairs.rb — Merge separate EN dirs into EN siblings (i18n scheme).
#
# For each PT/EN pair:
#   1. Read EN dir/index.md
#   2. Update EN frontmatter: remove 'english'/'translation' tags, add slug + translationKey
#   3. Write as PT_dir/index.en.md
#   4. Update PT dir/index.md: add translationKey + aliases for old EN URL
#   5. Delete old EN dir
#
# Run with --dry-run to preview without writing.

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

  # Parse PT
  pt_content = File.read(pt_index)
  pt_fm, _, pt_body = parse_frontmatter(pt_content)
  return false unless pt_fm

  # Parse EN
  en_content = File.read(en_index)
  en_fm, _, en_body = parse_frontmatter(en_content)
  return false unless en_fm

  # EN slug from dir name
  en_slug = File.basename(en_dir)
  # PT slug from frontmatter or dir name
  pt_slug = pt_fm['slug'] || File.basename(pt_dir)
  # Build old EN URL for alias
  # EN dir path relative to content: e.g. content/2010/06/16/railsconf-2010-video-interview-...
  date_path = en_dir.delete_prefix("#{CONTENT_DIR}/").then { |p| p.split('/').first(3).join('/') }
  old_en_url = "/#{date_path}/#{en_slug}/"

  puts "PAIR: #{File.basename(pt_dir)} <-> #{File.basename(en_dir)}"
  puts "  EN slug: #{en_slug}"
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
  # Remove 'traduzido' if present (these are original bilingual posts)
  pt_fm.delete('traduzido')

  # Update EN frontmatter
  en_fm['translationKey'] = translation_key
  en_fm['slug'] = en_slug
  # Remove 'english' and 'translation' tags
  en_tags = Array(en_fm['tags']).map(&:to_s)
  en_tags.reject! { |t| %w[english translation traduzido].include?(t) }
  en_fm['tags'] = en_tags.empty? ? nil : en_tags
  en_fm.delete('tags') if en_fm['tags'].nil?

  unless dry_run
    # Write updated PT index.md
    File.write(pt_index, build_content(pt_fm, pt_body))
    puts "  Updated PT: #{pt_index}"

    # Write EN index.en.md next to PT
    en_sibling = "#{pt_dir}/index.en.md"
    File.write(en_sibling, build_content(en_fm, en_body))
    puts "  Created EN sibling: #{en_sibling}"

    # Copy any other assets from EN dir (images etc) to PT dir
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

    # Remove old EN dir
    FileUtils.rm_rf(en_dir)
    puts "  Deleted EN dir: #{en_dir}"
  else
    puts "  DRY RUN — would update #{pt_index}, create #{pt_dir}/index.en.md, delete #{en_dir}"
  end

  true
end

# Special case: EN dir becomes canonical, PT moved from a --2 dir
def merge_swapped_pair(canonical_dir, pt_source_dir, en_slug, pt_slug, translation_key, dry_run: false)
  en_index = "#{canonical_dir}/index.md"
  pt_index = "#{pt_source_dir}/index.md"

  unless File.exist?(en_index) && File.exist?(pt_index)
    warn "SKIP: Missing files for swapped pair #{canonical_dir}"
    return false
  end

  en_content = File.read(en_index)
  en_fm, _, en_body = parse_frontmatter(en_content)
  pt_content = File.read(pt_index)
  pt_fm, _, pt_body = parse_frontmatter(pt_content)
  return false unless en_fm && pt_fm

  date_path = canonical_dir.delete_prefix("#{CONTENT_DIR}/").then { |p| p.split('/').first(3).join('/') }
  old_pt_url = "/#{date_path}/#{File.basename(pt_source_dir)}/"

  puts "SWAPPED PAIR: #{File.basename(canonical_dir)} (canonical) + #{File.basename(pt_source_dir)} (pt source)"

  # Update PT frontmatter
  pt_fm['translationKey'] = translation_key
  pt_fm['slug'] = pt_slug
  existing_aliases = Array(pt_fm['aliases']).map(&:to_s)
  unless existing_aliases.include?(old_pt_url)
    existing_aliases << old_pt_url
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
    # EN stays as index.en.md in canonical dir
    FileUtils.mv(en_index, "#{canonical_dir}/index.en.md")
    puts "  Moved EN: #{canonical_dir}/index.md → index.en.md"
    File.write("#{canonical_dir}/index.en.md", build_content(en_fm, en_body))

    # PT becomes index.md in canonical dir
    File.write("#{canonical_dir}/index.md", build_content(pt_fm, pt_body))
    puts "  Created PT: #{canonical_dir}/index.md (from #{pt_source_dir})"

    # Copy other assets from pt_source_dir
    Dir.glob("#{pt_source_dir}/**/*").each do |src|
      next if File.directory?(src)
      next if src == pt_index
      rel = src.delete_prefix("#{pt_source_dir}/")
      dst = "#{canonical_dir}/#{rel}"
      unless File.exist?(dst)
        FileUtils.cp(src, dst)
        puts "  Copied asset: #{dst}"
      end
    end

    FileUtils.rm_rf(pt_source_dir)
    puts "  Deleted old PT dir: #{pt_source_dir}"
  else
    puts "  DRY RUN — would move EN to index.en.md, create PT index.md, delete #{pt_source_dir}"
  end

  true
end

# === PAIR DEFINITIONS ===
# [pt_dir, en_dir, translation_key]
PAIRS = [
  # 2016/03
  [
    'content/2016/03/31/off-topic-uma-nova-era-para-a-microsoft',
    'content/2016/03/31/war-is-over-or-is-it-a-new-dawn-for-microsoft',
    'nova-era-microsoft-2016'
  ],
  # 2016/10
  [
    'content/2016/10/20/iniciativa-the-conf',
    'content/2016/10/20/the-conf-initiative',
    'theconf-initiative-2016'
  ],
  # 2010/06
  [
    'content/2010/06/16/railsconf-2010-video-entrevista-robert-martin',
    'content/2010/06/16/railsconf-2010-video-interview-robert-martin-english',
    'railsconf-2010-robert-martin'
  ],
  [
    'content/2010/06/17/railsconf-2010-video-entrevista-david-hansson',
    'content/2010/06/17/railsconf-2010-video-interview-david-hansson',
    'railsconf-2010-david-hansson'
  ],
  [
    'content/2010/06/17/railsconf-2010-video-entrevistas-parte-1',
    'content/2010/06/17/railsconf-2010-video-interviews-part-1',
    'railsconf-2010-interviews-part-1'
  ],
  [
    'content/2010/06/17/railsconf-2010-video-entrevistas-parte-2',
    'content/2010/06/17/railsconf-2010-video-interviews-part-2',
    'railsconf-2010-interviews-part-2'
  ],
  # 2010/09
  [
    'content/2010/09/03/o-rubyconf-brasil-esta-chegando',
    'content/2010/09/03/rubyconf-brazil-is-coming-up',
    'rubyconf-brazil-2010-coming'
  ],
  # 2011/07
  [
    'content/2011/07/23/em-breve-jornada-ao-japao',
    'content/2011/07/23/upcoming-journey-to-japan',
    'journey-to-japan-upcoming'
  ],
  # 2011/09
  [
    'content/2011/09/19/rubyconf-brasil-2011-esta-chegando',
    'content/2011/09/19/rubyconf-brazil-2011-is-coming',
    'rubyconf-brazil-2011-coming'
  ],
  # 2012/07
  [
    'content/2012/07/11/inscricoes-abertas-para-a-rubyconf-brasil-2012',
    'content/2012/07/11/registration-are-open-for-rubyconf-brazil-2012',
    'rubyconf-brazil-2012-registration'
  ],
  # 2013/08 — conheca/meet pairs
  [
    'content/2013/08/08/rubyconf-brasil-2013-conheca-hal-fulton',
    'content/2013/08/08/rubyconf-brasil-2013-meet-hal-fulton',
    'rubyconf-2013-hal-fulton'
  ],
  [
    'content/2013/08/09/rubyconf-brasil-2013-conheca-pablo-astigarraga',
    'content/2013/08/09/rubyconf-brasil-2013-meet-pablo-astigarraga',
    'rubyconf-2013-pablo-astigarraga'
  ],
  [
    'content/2013/08/11/rubyconf-brasil-2013-conheca-caike-souza',
    'content/2013/08/11/rubyconf-brasil-2013-meet-caike-souza',
    'rubyconf-2013-caike-souza'
  ],
  [
    'content/2013/08/14/rubyconf-brasil-2013-conheca-hongli-lai',
    'content/2013/08/14/rubyconf-brasil-2013-meet-hongli-lai',
    'rubyconf-2013-hongli-lai'
  ],
  [
    'content/2013/08/15/rubyconf-brasil-2013-conheca-danilo-sato',
    'content/2013/08/22/rubyconf-brasil-2013-meet-danilo-sato',  # different date
    'rubyconf-2013-danilo-sato'
  ],
  [
    'content/2013/08/19/rubyconf-brasil-2013-conheca-eduardo-shiota',
    'content/2013/08/19/rubyconf-brasil-2013-meet-eduardo-shiota',
    'rubyconf-2013-eduardo-shiota'
  ],
  [
    'content/2013/08/22/rubyconf-brasil-2013-conheca-bruno-abstractj',
    'content/2013/08/23/rubyconf-brasil-2013-meet-bruno-abstractj',  # different date
    'rubyconf-2013-bruno-abstractj'
  ],
  [
    'content/2013/08/23/rubyconf-brasil-2013-conheca-william-pothix',
    'content/2013/08/23/rubyconf-brasil-2013-meet-william-pothix',
    'rubyconf-2013-william-pothix'
  ],
  [
    'content/2013/08/26/rubyconf-brasil-2013-conheca-carlos-galdino',
    'content/2013/08/26/rubyconf-brasil-2013-meet-carlos-galdino',
    'rubyconf-2013-carlos-galdino'
  ],
  [
    'content/2013/08/27/rubyconf-brasil-2013-conheca-luis-cipriani',
    'content/2013/08/27/rubyconf-brasil-2013-meet-luis-cipriani',
    'rubyconf-2013-luis-cipriani'
  ],
].freeze

# Swapped pair: EN dir is canonical (nicer slug), PT was in --2 dir
# [canonical_dir, pt_source_dir, en_slug, pt_slug, translation_key]
SWAPPED_PAIRS = [
  [
    'content/2013/08/13/rubyconf-brasil-2013-jaime-andres-davila',
    'content/2013/08/13/rubyconf-brasil-2013-jaime-andres-davila--2',
    'rubyconf-brasil-2013-jaime-andres-davila',
    'rubyconf-brasil-2013-jaime-andres-davila',
    'rubyconf-2013-jaime-davila'
  ],
].freeze

puts "Phase 2 pair migration — #{DRY_RUN ? 'DRY RUN' : 'LIVE'}"
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

SWAPPED_PAIRS.each do |canonical_dir, pt_source_dir, en_slug, pt_slug, translation_key|
  if merge_swapped_pair(canonical_dir, pt_source_dir, en_slug, pt_slug, translation_key, dry_run: DRY_RUN)
    success += 1
  else
    failures += 1
  end
  puts
end

puts "=" * 60
puts "Done: #{success} pairs merged, #{failures} failures"
puts "Run scripts/generate_index.rb to regenerate indexes." unless DRY_RUN
