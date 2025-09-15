#!/usr/bin/env ruby
require 'yaml'
require 'find'
require 'date'

def escape_markdown(text)
  text.to_s.gsub('[', '\\[').gsub(']', '\\]')
end

entries = []

Find.find('content/.') do |path|
  next unless path.end_with?('index.md')
  next if ['./index.md', './_index.md'].include?(path)

  begin
    lines = File.readlines(path)
    if lines.first&.strip == '---'
      fm_lines = []
      i = 1
      while i < lines.size && lines[i].strip != '---'
        fm_lines << lines[i]
        i += 1
      end
      if lines[i]&.strip == '---'
        front = YAML.safe_load(fm_lines.join)
        if front && front['title'] && front['date']
          date = begin
            DateTime.parse(front['date'].to_s)
          rescue StandardError
            nil
          end
          if date
            url = path.sub('content/', '').sub('./', '').sub('/index.md', '/')
            entries << { 'title' => front['title'], 'url' => url, 'date' => date }
          end
        end
      end
    end
  rescue StandardError => e
    warn "YAML error in #{path}: #{e.message}"
  end
end

# Sort newest first
entries.sort_by! { |e| e['date'] }.reverse!

# Group by year and month
grouped = entries.group_by { |e| [e['date'].year, e['date'].month] }

# Sort year-month pairs descending
sorted_keys = grouped.keys.sort.reverse

File.open('content/_index.md', 'w') do |f|
  f.puts '---'
  f.puts "title: AkitaOnRails's Blog"
  f.puts '---'
  f.puts

  sorted_keys.each do |(year, month)|
    month_name = Date::MONTHNAMES[month] # "May", "June", etc
    f.puts "## #{year} - #{month_name}\n\n"
    # Sort posts within each month by date (newest first)
    grouped[[year, month]].sort_by { |post| post['date'] }.reverse.each do |post|
      f.puts "- [#{escape_markdown(post['title'])}](#{post['url']})"
    end
    f.puts
  end
end

puts 'Generated _index.md with posts grouped by year & month.'
