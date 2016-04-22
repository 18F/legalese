require 'nokogiri'
require 'open-uri'

module Legalese
  class Page
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def doc
      @doc ||= Nokogiri::HTML(open(url))
    end

    def search_case_insensitive(text, tag='*')
      # convert to lower case
      # http://stackoverflow.com/a/3803222/358804
      doc.xpath("//#{tag}[contains(translate(text(),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')
    ,'#{text.downcase}')]")
    end

    def contains_text?(text)
      !search_case_insensitive(text).empty?
    end

    def contains_link?(text)
      !search_case_insensitive(text, 'a').empty?
    end
  end
end
