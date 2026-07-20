#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'json'
require 'open3'
require 'optparse'
require 'set'
require 'tempfile'
require 'yaml'

Translation = Struct.new(:path, :source_path, :title, :date, :source_description, keyword_init: true)

OPTIONS = {
  batch_size: 24,
  model: ENV.fetch('DESCRIPTION_MODEL', 'gpt-5.6-luna'),
  limit: nil,
  include_modified: false,
  dry_run: false,
  verbose: false
}.freeze

FORBIDDEN_PATTERNS = {
  /\bunviable\b/i => 'awkward English: unviable',
  /\bvalue frontier\b/i => 'coined abstraction: value frontier',
  /\b(?:delves? into|serves as|stands as|showcases?|underscores?)\b/i => 'generic AI phrasing'
}.freeze

def parse_options
  options = OPTIONS.dup

  OptionParser.new do |parser|
    parser.banner = 'Usage: scripts/translate_descriptions.rb [options]'
    parser.on('--batch-size N', Integer, 'Maximum descriptions sent in one call') { |v| options[:batch_size] = v }
    parser.on('--model MODEL', 'Codex model name') { |v| options[:model] = v }
    parser.on('--limit N', Integer, 'Process at most N descriptions') { |v| options[:limit] = v }
    parser.on('--include-modified', 'Regenerate EN descriptions changed in the worktree') { options[:include_modified] = true }
    parser.on('--dry-run', 'Generate and validate without changing files') { options[:dry_run] = true }
    parser.on('--verbose', 'Print every translated description') { options[:verbose] = true }
  end.parse!

  options
end

def split_document(content, path)
  match = content.match(/\A---[ \t]*\r?\n(.*?)\r?\n---[ \t]*\r?\n/m)
  raise "Missing YAML frontmatter in #{path}" unless match

  frontmatter = YAML.safe_load(match[1], permitted_classes: [Date, Time], aliases: true) || {}
  [frontmatter, match[1], content[match.end(0)..].to_s]
rescue Psych::SyntaxError => e
  raise "Invalid YAML frontmatter in #{path}: #{e.message}"
end

def modified_english_paths
  stdout, status = Open3.capture2('git', 'diff', 'HEAD', '--name-only', '--', 'content')
  raise 'Could not inspect modified English posts' unless status.success?

  stdout.lines.map(&:strip).grep(%r{/index\.en\.md\z}).to_set
end

def collect_translations(include_modified:)
  modified = include_modified ? modified_english_paths : Set.new

  Dir.glob('content/[0-9][0-9][0-9][0-9]/[0-9][0-9]/[0-9][0-9]/*/index.en.md').filter_map do |path|
    source_path = path.sub('/index.en.md', '/index.md')
    next unless File.exist?(source_path)

    target_frontmatter, = split_document(File.read(path), path)
    next if target_frontmatter['draft'] == true

    existing = target_frontmatter['description'].to_s.strip
    next unless existing.empty? || modified.include?(path)

    source_frontmatter, = split_document(File.read(source_path), source_path)
    source_description = source_frontmatter['description'].to_s.strip
    next if source_description.empty?

    Translation.new(
      path: path,
      source_path: source_path,
      title: target_frontmatter.fetch('title').to_s,
      date: DateTime.parse(target_frontmatter.fetch('date').to_s),
      source_description: source_description
    )
  end.sort_by { |item| [-item.date.to_time.to_f, item.path] }
end

def prompt_for(batch)
  payload = batch.each_with_index.map do |item, index|
    {
      id: index + 1,
      english_title: item.title,
      pt_br_description: item.source_description
    }
  end

  <<~PROMPT
    Translate each AkitaOnRails frontmatter description from Brazilian Portuguese to natural American English.

    This is translation, not summarization. Use only pt_br_description as the source of meaning. Do not read, infer from, or add facts from the English title. Preserve every concrete claim, number, product name, comparison, qualification, opinion, and conclusion. Do not add or remove information.

    Editorial requirements:
    - Keep the direct, personal, colloquial Akita voice. Write idiomatic English, never a literal or robotic translation.
    - Preserve one or two sentences and approximately the same density. The result should normally be 150-210 characters and never exceed 240.
    - Keep established technical terms in English.
    - Vary naturally across the batch, but do not rewrite merely for variety.
    - Avoid promotional language, rhetorical questions, vague significance, generic conclusions, em dashes, semicolons, forced lists, rule-of-three padding, and negative-parallel templates.
    - Never start with "This article", "This post", "Discover", or "Learn how". Do not use Markdown or calls to action.
    - Before returning, silently compare each translation with its PT-BR source and remove any added, missing, softened, or exaggerated claim. Then run a humanizer pass for natural English.

    Return exactly one translation for every id in the same order. Return JSON only.

    TRANSLATIONS_JSON:
    #{JSON.pretty_generate(payload)}
  PROMPT
end

def output_schema
  {
    type: 'object',
    additionalProperties: false,
    required: ['descriptions'],
    properties: {
      descriptions: {
        type: 'array',
        items: {
          type: 'object',
          additionalProperties: false,
          required: %w[id description],
          properties: {
            id: { type: 'integer' },
            description: { type: 'string', minLength: 60, maxLength: 240 }
          }
        }
      }
    }
  }
end

def call_codex(batch, model:)
  Tempfile.create(['translation-schema', '.json']) do |schema_file|
    Tempfile.create(['translation-output', '.json']) do |output_file|
      schema_file.write(JSON.pretty_generate(output_schema))
      schema_file.flush
      output_file.close

      command = [
        'codex', 'exec',
        '--model', model,
        '--sandbox', 'read-only',
        '--ephemeral',
        '--ignore-user-config',
        '--ignore-rules',
        '--skip-git-repo-check',
        '-C', '/tmp',
        '-c', 'model_reasoning_effort="medium"',
        '--output-schema', schema_file.path,
        '--output-last-message', output_file.path,
        '--color', 'never',
        '-'
      ]

      _stdout, stderr, status = Open3.capture3(*command, stdin_data: prompt_for(batch))
      unless status.success?
        detail = stderr.lines.last(20).join
        raise "Codex failed with status #{status.exitstatus}:\n#{detail}"
      end

      JSON.parse(File.read(output_file.path)).fetch('descriptions')
    end
  end
end

def validate_translations(batch, generated)
  expected_ids = (1..batch.length).to_a
  actual_ids = generated.map { |item| item.fetch('id') }
  raise "Expected ids #{expected_ids.inspect}, got #{actual_ids.inspect}" unless actual_ids == expected_ids

  generated.map.with_index do |item, index|
    description = item.fetch('description').strip.gsub(/\s+/, ' ')
    description = description.gsub(/;\s*([[:alpha:]])/) { ". #{$1.upcase}" }.tr(';', '.')
    path = batch[index].path

    raise "Translation for #{path} is too short (#{description.length})" if description.length < 60
    raise "Translation for #{path} is too long (#{description.length})" if description.length > 240
    raise "Translation for #{path} contains Markdown" if description.match?(/\[[^\]]+\]\([^)]+\)|[*_]{2}/)
    raise "Translation for #{path} contains an em dash" if description.include?('—')
    raise "Translation for #{path} uses generic framing" if description.match?(/\A(?:This (?:article|post)|Discover|Learn how)\b/i)

    FORBIDDEN_PATTERNS.each do |pattern, reason|
      raise "Translation for #{path} contains #{reason}" if description.match?(pattern)
    end

    description
  end
end

def write_description(item, description)
  content = File.read(item.path)
  _frontmatter, raw_frontmatter, body = split_document(content, item.path)
  lines = raw_frontmatter.lines
  lines[-1] = "#{lines[-1]}\n" unless lines.empty? || lines[-1].end_with?("\n")
  replacement = "description: #{JSON.generate(description)}\n"
  description_index = lines.index { |line| line.match?(/^description:\s*/) }

  if description_index
    lines[description_index] = replacement
  else
    insert_at = lines.index { |line| line.match?(/^tags:\s*/) } || lines.length
    lines.insert(insert_at, replacement)
  end

  updated = "---\n#{lines.join}---\n#{body}"
  parsed, = split_document(updated, item.path)
  raise "Failed to write translation in #{item.path}" unless parsed['description'] == description

  File.write(item.path, updated)
end

def process_batch(batch, options, number:, total:)
  puts "Batch #{number}/#{total}: #{batch.length} translation(s)"
  descriptions = nil

  3.times do |attempt|
    generated = call_codex(batch, model: options[:model])
    descriptions = validate_translations(batch, generated)
    break
  rescue StandardError => e
    warn "  Attempt #{attempt + 1}/3 failed: #{e.message}"
    raise if attempt == 2
  end

  batch.zip(descriptions).each do |item, description|
    puts "  #{item.path} (#{description.length}): #{description}" if options[:verbose]
    write_description(item, description) unless options[:dry_run]
  end
end

options = parse_options
translations = collect_translations(include_modified: options[:include_modified])
translations = translations.first(options[:limit]) if options[:limit]

if translations.empty?
  puts 'Every targeted English post already has an aligned description.'
  exit
end

batches = translations.each_slice(options[:batch_size]).to_a
puts "Translating #{translations.length} description(s) in #{batches.length} batch(es) with #{options[:model]}"
puts 'Dry run: no files will be changed.' if options[:dry_run]

batches.each_with_index do |batch, index|
  process_batch(batch, options, number: index + 1, total: batches.length)
end


puts "Completed #{translations.length} translation(s)."
