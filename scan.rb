require_relative 'lib/legalese'

urls = File.readlines('domains.txt')
urls.map!(&:strip!)
urls.reject!(&:empty?)
urls.uniq!

urls.each do |url|
  Legalese.scan(url)
end
