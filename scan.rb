require_relative 'lib/legalese/reporter'

urls = File.readlines('domains.txt')
urls.map!(&:strip!)
urls.reject!(&:empty?)
urls.uniq!

urls.each do |url|
  Legalese::Reporter.new(url).run
end
