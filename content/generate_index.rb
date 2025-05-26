require 'yaml'
require 'find'
require 'date'

def escape_markdown(text)
  text.to_s.gsub('[', '\\[').gsub(']', '\\]')
end

entries = []

Find.find('.') do |path|
  next unless path.end_with?('index.md')
  next if path == './index.md' || path == './_index.md'

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
          date = Date.parse(front['date'].to_s) rescue nil
          if date
            url = path.sub('./', '').sub('/index.md', '/')
            entries << { 'title' => front['title'], 'url' => url, 'date' => date }
          end
        end
      end
    end
  rescue => e
    warn "YAML error in #{path}: #{e.message}"
  end
end

# Sort newest first
entries.sort_by! { |e| e['date'] }.reverse!

# Group by year and month
grouped = entries.group_by { |e| [e['date'].year, e['date'].month] }

# Sort year-month pairs descending
sorted_keys = grouped.keys.sort.reverse

File.open('_index.md', 'w') do |f|
  f.puts "---"
  f.puts "title: AkitaOnRails's Blog"
  f.puts "---"
  f.puts

  sorted_keys.each do |(year, month)|
    month_name = Date::MONTHNAMES[month] # "May", "June", etc
    f.puts "## #{year} - #{month_name}\n\n"
    grouped[[year, month]].each do |post|
      f.puts "- [#{escape_markdown(post['title'])}](#{post['url']})"
    end
    f.puts
  end
end

puts "Generated _index.md with posts grouped by year & month."
