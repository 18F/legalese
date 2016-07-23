
require_relative 'lib/legalese/reporter'

urls = File.readlines('urls.txt')
urls.map!(&:strip!)
puts urls.count
urls.reject!(&:empty?)
puts urls.count
urls.uniq!

Legalese::Reporter.print_key
urls.each do |url|
  Legalese::Reporter.new(url).run
end
