require_relative 'legalese/service'

module Legalese
  class << self
    def scan(url)
      puts url

      srvice = Service.new(url)
      puts "  privacy policy found: #{srvice.has_privacy_policy?}"

      tos_found = srvice.tos_pages.any?
      puts "  ToS found: #{tos_found}"
      if tos_found
        Service.clauses.each do |clause|
          has_clause = srvice.contains_tos_clause?(clause)
          puts "    #{clause} clause: #{has_clause}"
        end
      end
    end
  end
end
