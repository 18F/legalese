require 'parallel'
require_relative 'lib/legalese/service'

urls = File.readlines('urls.txt')
urls.map!(&:strip!)

Parallel.each(urls, in_threads: 4) do |url|
  srv = Legalese::Service.new(url)
  if srv.has_tos? && srv.contains_tos_clause?(:governing_law)
    url = srv.tos_pages.first.url
    `open #{url}`
  end
end
