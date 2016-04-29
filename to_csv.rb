require 'csv'
require 'parallel'
require_relative 'lib/legalese/service'

def pages_to_url(pages)
  page = pages.first
  if page
    page.url
  else
    nil
  end
end

def to_char(bool)
  bool ? 'Y' : 'N'
end

urls = File.readlines('urls.txt')
urls.map!(&:strip!)

results = Parallel.map(urls, in_threads: 4) do |url|
  srv = Legalese::Service.new(url)
  [
    url,
    pages_to_url(srv.privacy_policy_pages),
    pages_to_url(srv.tos_pages),
    srv.has_tos? ? to_char(srv.contains_tos_clause?(:indemnity)) : nil,
    srv.has_tos? ? (srv.contains_tos_clause?(:governing_law) ? 'Y?' : 'N') : nil
  ]
end

results.each do |row|
  puts CSV.generate_line(row)
end
