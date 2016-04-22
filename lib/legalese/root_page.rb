require_relative 'page'
require_relative 'tos_page'

module Legalese
  class RootPage < Page
    def privacy_policy_urls
      urls_for('privacy')
    end

    def tos_urls
      @tos_urls ||= %w(terms tos legal).flat_map do |title_term|
        urls_for(title_term)
      end.to_set
    end

    def tos_pages
      @tos_pages ||= tos_urls.map do |tos_url|
        TosPage.new(tos_url)
      end
    end
  end
end
