require 'set'
require_relative 'root_page'

module Legalese
  class Service
    # looks for these terms in the legal pages
    CLAUSE_TERMS = {
      indemnity: [
        'defend',
        'hold harmless',
        'indemnification',
        'indemnify',
        'indemnity'
      ],
      governing_law: [
        'governing law',
        'jurisdiction'
      ]
    }

    attr_reader :url

    def initialize(url)
      @url = url
    end

    def homepage
      @homepage ||= RootPage.new(url)
    end

    def privacy_policy_url
      homepage.privacy_policy_urls.first
    end

    def has_privacy_policy?
      !!privacy_policy_url
    end

    def tos_urls
      homepage.tos_urls
    end

    def tos_pages
      homepage.tos_pages
    end

    def contains_tos_term?(term)
      tos_pages.any? do |page|
        page.contains_text?(term)
      end
    end

    def contains_tos_clause?(clause)
      terms = CLAUSE_TERMS[clause.to_sym]
      terms.any? do |term|
        contains_tos_term?(term)
      end
    end

    def self.clauses
      CLAUSE_TERMS.keys
    end
  end
end
