require 'colorize'
require_relative 'service'
require_relative 'tos_search'

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
      puts ''
      puts url
      report_privacy_policy
      report_tos
    end

    def self.print_key
      puts "Key:\n"
      puts '  green'.colorize(:green) + ' - pass'
      puts '  magenta'.colorize(:magenta) + ' - soft fail'
      puts '  red'.colorize(:red) + ' - hard fail'
    end

    private

    def privacy_policy_message
      if srvice.has_privacy_policy?
        page = srvice.privacy_policy_pages.first
        page.url.colorize(:green)
      else
        "not found".colorize(:red) + " (should be verified manually)"
      end
    end

    def report_privacy_policy
      puts "  privacy policy: #{privacy_policy_message}"
    end

    def tos_message
      if srvice.has_tos?
        page = srvice.tos_pages.first
        page.url.colorize(:green)
      else
        "not found".colorize(:red) + " (should be verified manually)"
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
        "found".colorize(:magenta) + " (needs further investigation)"
      else
        "not found".colorize(:green)
      end
    end

    def report_tos_clauses(srvice)
      TosSearch.clauses.each do |clause|
        msg = tos_clause_message(clause)
        puts "    #{clause} clause: #{msg}"
      end
    end
  end
end
