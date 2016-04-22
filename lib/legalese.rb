require_relative 'legalese/service'
require_relative 'legalese/tos_page'

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
      msg = if srvice.has_tos?
        srvice.tos_url
      else
        "not found"
      end
      puts "  ToS: #{msg}"

      if srvice.has_tos?
        report_tos_clauses(srvice)
      end
    end

    def report_tos_clauses(srvice)
      TosPage.clauses.each do |clause|
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
