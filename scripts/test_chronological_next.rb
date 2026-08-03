#!/usr/bin/env ruby
# frozen_string_literal: true

require 'fileutils'
require 'open3'
require 'time'
require 'tmpdir'
require 'uri'

Post = Struct.new(:source, :language, :date, :url)

def frontmatter_value(contents, key)
  contents[/^#{Regexp.escape(key)}:\s*["']?([^"'\n]+)["']?\s*$/, 1]
end

def post_from(path)
  contents = File.binread(path).force_encoding(Encoding::UTF_8).scrub
  return if frontmatter_value(contents, 'draft') == 'true'

  date = frontmatter_value(contents, 'date')
  return unless date

  language = path.end_with?('/index.en.md') ? 'en' : 'pt-br'
  slug = frontmatter_value(contents, 'slug') || File.basename(File.dirname(path))
  year, month, day = path.split('/')[1, 3]
  prefix = language == 'en' ? '/en' : ''

  Post.new(path, language, Time.iso8601(date), "#{prefix}/#{year}/#{month}/#{day}/#{slug}/")
end

def assert(condition, message)
  raise "FALHOU: #{message}" unless condition
end

posts = Dir['content/{19,20}[0-9][0-9]/**/index{,.en}.md'].filter_map { |path| post_from(path) }
posts_by_url = posts.to_h { |post| [URI::DEFAULT_PARSER.unescape(post.url), post] }

Dir.mktmpdir('akitaonrails-chronological-next-') do |destination|
  command = ['hugo', '--quiet', '--destination', destination]
  stdout, stderr, status = Open3.capture3(*command)
  abort [stdout, stderr].reject(&:empty?).join("\n") unless status.success?

  checked = 0

  posts.each do |current|
    output = File.join(destination, current.url.delete_prefix('/'), 'index.html')
    next unless File.file?(output)

    html = File.binread(output).force_encoding(Encoding::UTF_8).scrub
    recommendation = html.match(
      %r{<aside class="aor-next-post.*?<a class="aor-next-post__link" href="([^"]+)"}m
    )
    newer_posts = posts.select { |post| post.language == current.language && post.date > current.date }

    if newer_posts.empty?
      assert(!recommendation, "#{current.url} não deveria recomendar um artigo depois do mais recente")
      next
    end

    assert(recommendation, "#{current.url} deveria exibir uma recomendação")

    recommended_url = URI::DEFAULT_PARSER.unescape(recommendation[1])
    recommended = posts_by_url[recommended_url]
    assert(recommended, "#{current.url} recomenda uma URL desconhecida: #{recommended_url}")
    assert(recommended.language == current.language, "#{current.url} atravessa idiomas")
    assert(recommended.date >= current.date, "#{current.url} recomenda um artigo anterior")

    dates_between = newer_posts.select { |post| post.date < recommended.date }
    assert(dates_between.empty?, "#{current.url} pulou um artigo cronologicamente mais próximo")

    card_position = html.index('class="aor-next-post')
    comments_position = html.index('id="disqus_wrapper"')
    assert(comments_position, "#{current.url} perdeu os comentários do Disqus")
    assert(card_position < comments_position, "#{current.url} posiciona a recomendação depois dos comentários")

    expected_label = current.language == 'en' ? 'Next post' : 'Próximo post'
    assert(html.include?(expected_label), "#{current.url} usa o rótulo incorreto")
    checked += 1
  end

  assert(checked.positive?, 'nenhuma página com recomendação foi testada')
  puts "OK: #{checked} páginas com recomendações cronológicas validadas."
end
