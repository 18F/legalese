
require_relative 'lib/legalese/reporter'

urls = File.readlines('urls.txt')
urls.map!(&:strip)
urls.reject!(&:empty?)
urls.uniq!

Legalese::Reporter.print_key
urls.each do |url|
  begin
    Legalese::Reporter.new(url).run
  rescue OpenSSL::SSL::SSLError
    puts "Failed with #{url} due to OpenSSL errors"
  end
end
