require 'net/http'
require 'uri'
require 'fileutils'
require 'openssl'

CLOUDFRONT_REGEX = %r{
  https://d1g6lioiw8beil\.cloudfront\.net/rails/active_storage/blobs/redirect/[^\s\)]+
}x

def resolve_redirect(url, limit = 5)
  raise "Too many redirects" if limit == 0
  uri = URI.parse(url)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = (uri.scheme == "https")
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE # (disable for maximum compatibility)
  request = Net::HTTP::Get.new(uri)

  response = http.request(request)
  case response
  when Net::HTTPSuccess
    url # No redirect, this is the final URL
  when Net::HTTPRedirection
    location = response['location']
    if !location.start_with?('http')
      # Relative redirect, build absolute
      location = "#{uri.scheme}://#{uri.host}#{location}"
    end
    resolve_redirect(location, limit - 1)
  else
    url # Return original if any error
  end
end

md_files = Dir.glob("**/*.md")
md_files.each do |filename|
  original = File.read(filename)
  rewritten = original.dup

  matches = rewritten.scan(CLOUDFRONT_REGEX).uniq
  next if matches.empty?

  puts "[#{filename}] Found #{matches.size} CloudFront link(s). Replacing..."

  matches.each do |cloudfront_url|
    begin
      s3_url = resolve_redirect(cloudfront_url)
      if s3_url.include?("amazonaws.com")
        rewritten.gsub!(cloudfront_url, s3_url)
        puts "  ✔️  #{cloudfront_url} → #{s3_url}"
      else
        puts "  ⚠️  Final URL not S3 for: #{s3_url}"
      end
    rescue => e
      puts "  ❌ Error for #{cloudfront_url}: #{e}"
    end
  end

  if rewritten != original
    FileUtils.cp(filename, "#{filename}.bak")
    File.write(filename, rewritten)
    puts "  ✅ Updated #{filename} (backup at #{filename}.bak)"
  end
end

puts "All done."
