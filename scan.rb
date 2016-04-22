require_relative 'lib/legalese/reporter'

urls = File.readlines('urls.txt')
urls.map!(&:strip!)
urls.reject!(&:empty?)
urls.uniq!

urls.each do |url|
  Legalese::Reporter.new(url).run
end
