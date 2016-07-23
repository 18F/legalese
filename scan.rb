
require_relative 'lib/legalese/reporter'

class Scanner
  attr_reader :urls

  def initialize(file_name)
    @urls = File.readlines(file_name)
    @urls.map!(&:strip)
    @urls.reject!(&:empty?)
    @urls.uniq!
  end

  def run
    Legalese::Reporter.print_key
    urls.each do |url|
      begin
        Legalese::Reporter.new(url).run
      rescue Exception => e
        puts "Url #{url} caused an exception: #{e.message}\n"
      end
    end
  end
end

if $0 == __FILE__
  # scanner = Scanner.new('test_urls_bad.txt')
  scanner = Scanner.new('urls.txt')
  scanner.run
end