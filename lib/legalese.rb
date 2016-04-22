require_relative 'legalese/service'

module Legalese
  class << self
    def scan(url)
      puts url

      srvice = Service.new(url)
      report_privacy_policy(srvice)
      report_tos(srvice)
    end

    def report_privacy_policy(srvice)
      msg = if srvice.has_privacy_policy?
        srvice.privacy_policy_url
      else
        "not found"
      end
      puts "  privacy policy: #{msg}"
    end

    def report_tos(srvice)
      tos_found = srvice.tos_pages.any?

      msg = if tos_found
        srvice.tos_urls.first
      else
        "not found"
      end
      puts "  ToS: #{msg}"

      if tos_found
        Service.clauses.each do |clause|
          msg = if srvice.contains_tos_clause?(clause)
            "found"
          else
            "not found"
          end
          puts "    #{clause} clause: #{msg}"
        end
      end
    end
  end
end
