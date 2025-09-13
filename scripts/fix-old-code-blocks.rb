require 'fileutils'

def is_frontmatter_start?(idx, line)
  idx == 0 && line.strip == "---"
end

def is_frontmatter_end?(in_frontmatter, line)
  in_frontmatter && line.strip == "---"
end

# Comment out if your frontmatter might use ... to end.
def is_possible_codeblock_marker?(line)
  # Matches "---", "--- ruby", "---yaml", etc (with or w/o space)
  line =~ /^---\s*([a-zA-Z0-9_-]*)\s*$/
end

Dir.glob("**/*.md") do |filename|
  lines = File.readlines(filename, chomp: true)
  out_lines = []
  in_frontmatter = false
  frontmatter_done = false
  replaced_count = 0

  lines.each_with_index do |line, idx|
    if is_frontmatter_start?(idx, line)
      in_frontmatter = true
      out_lines << line
      next
    end

    if is_frontmatter_end?(in_frontmatter, line)
      in_frontmatter = false
      out_lines << line
      next
    end

    if in_frontmatter
      out_lines << line
      next
    end

    # Replace codeblock marker
    if m = line.match(/^---\s*([a-zA-Z0-9_-]*)\s*$/)
      lang = m[1]
      out_lines << "```#{lang}"
      replaced_count += 1
    else
      out_lines << line
    end
  end

  if replaced_count > 0
    FileUtils.cp(filename, "#{filename}.bak")
    File.open(filename, "w") {|f| f.puts(out_lines) }
    puts "Fixed #{filename} (#{replaced_count} code block delimiter(s) changed, backup at #{filename}.bak)"
  end
end

puts "Done!"
