require_relative 'lib/legalese'

File.foreach('domains.txt') do |url|
  url.strip!
  next if url.empty?

  Legalese.scan(url)
end
