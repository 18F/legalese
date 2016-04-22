require 'nokogiri'
require 'open-uri'

module Legalese
  class Page
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def body
      @body ||= open(url)
    end

    def doc
      @doc ||= Nokogiri::HTML(body)
    end

    def contains_text?(text)
      search_case_insensitive(text).any?
    end

    # Returns an Array of URLs as Strings.
    def urls_for(text)
      links_to(text).map do |anchor|
        path = anchor[:href]
        # make absolute
        URI.join(url, path).to_s
      end
    end

    private

    # Returns an array of Elements.
    def search_case_insensitive(text, tag='*')
      # convert to lower case
      # http://stackoverflow.com/a/3803222/358804
      doc.xpath("//#{tag}[contains(translate(text(),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')
    ,'#{text.downcase}')]")
    end

    # Returns an array of anchor Elements.
    def links_to(text)
      search_case_insensitive(text, 'a')
    end
  end
end
