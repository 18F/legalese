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

    private

    def privacy_policy_message
      if srvice.has_privacy_policy?
        srvice.privacy_policy_pages.first.url
      else
        "not found"
      end
    end

    def report_privacy_policy
      puts "  privacy policy: #{privacy_policy_message}"
    end

    def tos_message
      if srvice.has_tos?
        srvice.tos_pages.first.url
      else
        "not found"
      end
    end

    def report_tos
      puts "  ToS: #{tos_message}"
      if srvice.has_tos?
        report_tos_clauses(srvice)
      end
    end

    def tos_clause_message(clause)
      if srvice.contains_tos_clause?(clause)
        "found"
      else
        "not found"
      end
    end

    def report_tos_clauses(srvice)
      TosPage.clauses.each do |clause|
        msg = tos_clause_message(clause)
        puts "    #{clause} clause: #{msg}"
      end
    end
  end
end
