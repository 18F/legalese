require_relative 'page'

module Legalese
  # This class is used to search for Privacy Policy and ToS pages.
  class RootPage < Page
    def privacy_policy_pages
      @privacy_policy_pages ||= urls_to_pages(urls_for('privacy'))
    end

    def tos_pages
      @tos_pages ||= urls_to_pages(tos_urls)
    end

    private

    def tos_urls
      @tos_urls ||= %w(terms tos legal).flat_map do |title_term|
        urls_for(title_term)
      end.to_set
    end

    def urls_to_pages(urls)
      urls.map do |url|
        Page.new(url)
      end
    end
  end
end
