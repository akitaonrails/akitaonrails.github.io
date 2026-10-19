#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cgi'
require 'open3'
require 'tmpdir'
require 'uri'

def assert(condition, message)
  raise "FALHOU: #{message}" unless condition
end

def read_output(destination, path)
  File.read(File.join(destination, path), encoding: 'UTF-8')
end

def links(xml)
  xml.scan(/<item>.*?<link>(.*?)<\/link>.*?<\/item>/m).flatten.map { |url| CGI.unescapeHTML(url) }
end

# Parse only generated XML/HTML fields; no extra Ruby gems are needed.
def rss_href(html)
  tag = html.scan(/<link\b[^>]*>/).find { |link| link.include?('application/rss+xml') }
  tag && CGI.unescapeHTML(tag[/href="([^"]+)"/, 1])
end

Dir.mktmpdir('akitaonrails-rss-scope-') do |destination|
  stdout, stderr, status = Open3.capture3(ENV.fetch('HUGO', 'hugo'), '--quiet', '--destination', destination)
  abort [stdout, stderr].join("\n") unless status.success?

  checked = 0
  ['', 'en/'].each do |prefix|
    home = read_output(destination, "#{prefix}index.xml")
    home_links = links(home)
    assert(home_links.length == 20, "#{prefix}home deve preservar os 20 itens")
    home_links.each do |url|
      assert(URI(url).path.start_with?('/en/') == (prefix == 'en/'), 'idiomas misturados no RSS')
    end
    %W[#{prefix}index.xml #{prefix}tags/ruby/index.xml #{prefix}archives/index.xml].each do |path|
      xml = read_output(destination, path)
      self_url = CGI.unescapeHTML(xml[/<atom:link href="([^"]+)"/, 1].to_s)
      assert(URI(self_url).path == "/#{path}", "self incorreto: #{path}")
      page_path = path.sub(/index\.xml$/, 'index.html')
      advertised = rss_href(read_output(destination, page_path))
      assert(advertised == self_url, "descoberta RSS incorreta: #{page_path}")
      channel = CGI.unescapeHTML(xml[/<channel>.*?<link>(.*?)<\/link>/m, 1])
      assert(URI(channel).path == "/#{path.sub(/index\.xml$/, '')}", 'link do canal incorreto')
      checked += 1
    end
    tag_xml = read_output(destination, "#{prefix}tags/ruby/index.xml")
    tag_links = links(tag_xml)
    assert(!tag_links.empty? && tag_links != home_links, 'Ruby repete o feed geral ou fica vazio')
    tag_xml.scan(/<item>(.*?)<\/item>/m).flatten.each do |item|
      assert(item.scan(/<category>(.*?)<\/category>/m).flatten.include?('ruby'), 'item sem tag Ruby')
    end
    tag_page = read_output(destination, "#{prefix}tags/ruby/index.html")
    expected = tag_page.scan(/class="aor-index-list__main-link" href="([^"]+)"/).flatten.first(20)
    assert(tag_links.map { |url| URI(url).path } == expected, 'RSS deve seguir ordem e seleção da página da tag')
    assert(links(read_output(destination, "#{prefix}archives/index.xml")) == home_links,
           'preservar comportamento das seções geradas sem páginas filhas')
    article_path = URI(home_links.first).path.delete_prefix('/') + 'index.html'
    assert(rss_href(read_output(destination, article_path)) == rss_href(read_output(destination, "#{prefix}index.html")),
           'artigo deve anunciar o feed geral do próprio idioma')
  end
  puts "OK: #{checked} feeds, tags Ruby PT/EN e descoberta RSS em homes, tags, arquivos e artigos."
end
