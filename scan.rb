require 'nokogiri'
require 'open-uri'
require 'set'

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

class Service
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

  def tos_anchors
    %w(terms tos legal).flat_map do |title_term|
      homepage.search_case_insensitive(title_term, 'a')
    end.to_set
  end

  def tos_urls
    tos_anchors.map do |anchor|
      path = anchor[:href]
      # make absolute
      URI.join(url, path).to_s
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
end


File.foreach('domains.txt') do |service_url|
  service_url.strip!
  next if service_url.empty?

  puts service_url

  srvice = Service.new(service_url)
  puts "  privacy policy: #{srvice.has_privacy_policy?}"

  clauses = CLAUSE_TERMS.keys
  clauses.each do |clause|
    has_clause = srvice.contains_tos_clause?(clause)
    puts "  ToS #{clause} clause: #{has_clause}"
  end
end
