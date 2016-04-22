require 'set'
require_relative 'page'

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
      @homepage ||= Page.new(url)
    end

    def has_privacy_policy?
      homepage.contains_link?('privacy')
    end

    def tos_urls
      %w(terms tos legal).flat_map do |title_term|
        homepage.urls_for(title_term)
      end.to_set
    end

    def tos_pages
      @tos_pages ||= tos_urls.map do |tos_url|
        Page.new(tos_url)
      end
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
