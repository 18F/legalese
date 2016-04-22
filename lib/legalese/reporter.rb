require_relative 'service'
require_relative 'tos_page'

module Legalese
  class Reporter
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def srvice
      @srvice ||= Service.new(url)
    end

    def run
      puts url

      report_privacy_policy
      report_tos
    end

    def report_privacy_policy
      msg = if srvice.has_privacy_policy?
        srvice.privacy_policy_pages.first.url
      else
        "not found"
      end
      puts "  privacy policy: #{msg}"
    end

    def report_tos
      msg = if srvice.has_tos?
        srvice.tos_pages.first.url
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
