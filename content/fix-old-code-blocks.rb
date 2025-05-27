require 'fileutils'

Dir.glob("**/*.md") do |filename|
  lines = File.readlines(filename, chomp: true)
  out_lines = []
  in_frontmatter = false
  frontmatter_ended = false
  dash_codeblock_count = 0

  lines.each_with_index do |line, idx|
    if idx == 0 && line.strip == "---"
      # Beginning: Start frontmatter.
      in_frontmatter = true
      out_lines << line
      next
    end

    if in_frontmatter
      if line.strip == "---"
        in_frontmatter = false
        frontmatter_ended = true
      end
      out_lines << line
      next
    end

    # Outside frontmatter: replace codeblock separator
    if line.strip == "---"
      dash_codeblock_count += 1
      out_lines << "```"
    else
      out_lines << line
    end
  end

  if dash_codeblock_count > 0
    FileUtils.cp(filename, "#{filename}.bak")
    File.open(filename, "w") { |f| f.puts(out_lines) }
    puts "Fixed #{filename} (#{dash_codeblock_count} code block delimiter(s) changed, backup at #{filename}.bak)"
  end
end

puts "Done!"

