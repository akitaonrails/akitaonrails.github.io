#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cgi'
require 'json'
require 'open3'
require 'time'
require 'tmpdir'
require 'uri'

# Compare the RSS instants with the article's timezone-aware structured data.
Dir.mktmpdir('akitaonrails-rss-dates-') do |destination|
  started = Time.now.to_i
  stdout, stderr, status = Open3.capture3('hugo', '--quiet', '--destination', destination)
  abort [stdout, stderr].join("\n") unless status.success?
  finished = Time.now.to_i
  checked = 0

  %w[index.xml en/index.xml].each do |feed|
    xml = File.read(File.join(destination, feed))
    built = Time.rfc2822(CGI.unescapeHTML(xml[/<lastBuildDate>(.*?)<\/lastBuildDate>/, 1])).to_i
    raise "#{feed}: horário de build incorreto" unless (started..finished).cover?(built)

    items = xml.scan(/<item>(.*?)<\/item>/m).flatten
    raise "#{feed}: feed sem artigos" if items.empty?

    items.each do |item|
      link = item[/<link>(.*?)<\/link>/, 1]
      path = URI::DEFAULT_PARSER.unescape(URI(link).path).delete_prefix('/')
      html = File.read(File.join(destination, path, 'index.html'))
      schemas = html.scan(/<script type="application\/ld\+json">(.*?)<\/script>/m)
                    .map { |match| JSON.parse(match.first) }
      article = schemas.find { |schema| schema['@type'] == 'BlogPosting' }
      raise "#{link}: metadados do artigo ausentes" unless article

      expected = Time.iso8601(article.fetch('datePublished'))
      actual = Time.rfc2822(CGI.unescapeHTML(item[/<pubDate>(.*?)<\/pubDate>/, 1]))
      raise "#{link}: RSS #{actual.iso8601}, artigo #{expected.iso8601}" unless actual == expected

      checked += 1
    end
  end
  puts "OK: #{checked} datas de artigos e datas de build dos feeds PT/EN validadas."
end
