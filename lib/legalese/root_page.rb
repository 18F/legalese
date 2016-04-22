require_relative 'page'
require_relative 'tos_page'

module Legalese
  # This class is used to search for Privacy Policy and ToS pages.
  class RootPage < Page
    def privacy_policy_pages
      @privacy_policy_pages ||= urls_for('privacy').map do |url|
        Page.new(url)
      end
    end

    def tos_pages
      @tos_pages ||= tos_urls.map do |tos_url|
        TosPage.new(tos_url)
      end
    end

    private

    def tos_urls
      @tos_urls ||= %w(terms tos legal).flat_map do |title_term|
        urls_for(title_term)
      end.to_set
    end
  end
end
