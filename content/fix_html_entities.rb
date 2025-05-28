#!/usr/bin/env ruby
require 'find'

# Mapping of HTML entities to unicode characters
ENTITY_MAP = {
  '&ldquo;' => '“',
  '&rdquo;' => '”',
  '&lsquo;' => '‘',
  '&rsquo;' => '’',
  '&ndash;' => '–',
  '&mdash;' => '—',
  '&hellip;' => '…',
  '&amp;'   => '&',
  '&lt;'    => '<',
  '&gt;'    => '>',
  '&quot;'  => '"',
  '&apos;'  => "'"
  # You can add more as needed
}

# Recursively walk through all .md files
Find.find('.') do |path|
  next unless path.end_with?('.md')
  orig = File.read(path)
  fixed = orig.dup

  ENTITY_MAP.each do |entity, char|
    fixed.gsub!(entity, char)
  end

  if fixed != orig
    puts "Fixing: #{path}"
    File.write(path, fixed)
  end
end

puts "Done."
