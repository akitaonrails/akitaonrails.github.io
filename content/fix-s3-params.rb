require 'fileutils'

# Customize this to match your bucket/region if needed
S3_LINK = "https://new-uploads-akitaonrails.s3.us-east-2.amazonaws.com/"

# Regex: Match S3 links and strip off ?... (the query params)
S3_LINK_REGEX = %r{(#{Regexp.escape(S3_LINK)}[^\s\)\]]+?)\?[^)\]\s]*}

md_files = Dir.glob("**/*.md")

md_files.each do |filename|
  content = File.read(filename)
  new_content = content.gsub(S3_LINK_REGEX, '\1')
  if new_content != content
    FileUtils.cp(filename, "#{filename}.bak")
    File.write(filename, new_content)
    puts "Cleaned #{filename} (backup: #{filename}.bak)"
  end
end

puts "Done!"
