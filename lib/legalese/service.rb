require 'set'
require_relative 'root_page'

module Legalese
  class Service
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

    def has_tos?
      homepage.tos_urls.any?
    end

    def contains_tos_clause?(clause)
      tos_pages.any? do |page|
        page.contains_clause?(clause)
      end
    end
  end
end
