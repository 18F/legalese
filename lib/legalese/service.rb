require 'set'
require_relative 'page'
require_relative 'search/legal_pages'
require_relative 'search/tos'

module Legalese
  class Service
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def homepage
      @homepage ||= Page.new(url)
    end

    def legal_pages_search
      Search::LegalPages.new(homepage)
    end

    def privacy_policy_pages
      legal_pages_search.privacy_policy_pages
    end

    def has_privacy_policy?
      privacy_policy_pages.any?
    end

    def tos_pages
      legal_pages_search.tos_pages
    end

    def has_tos?
      tos_pages.any?
    end

    def contains_tos_clause?(clause)
      tos_pages.any? do |page|
        search = Search::Tos.new(page)
        search.contains_clause?(clause)
      end
    end
  end
end
