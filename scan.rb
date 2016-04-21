require 'nokogiri'
require 'open-uri'

checks = [
  {
    title_terms: %w(terms privacy legal),
    clause_terms: [
      # indemnity
      'defend',
      'hold harmless',
      'indemnification',
      'indemnify',
      'indemnity',

      # governing law
      'governing law',
      'jurisdiction'
    ]
  }
]

def search_case_insensitive(doc, text, tag='*')
  # convert to lower case
  # http://stackoverflow.com/a/3803222/358804
  doc.xpath("//#{tag}[contains(translate(text(),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')
,'#{text.downcase}')]")
end

def contains?(doc, text)
  !search_case_insensitive(doc, text).empty?
end

File.foreach('domains.txt') do |service_url|
  service_url.strip!
  next if service_url.empty?
  homepage_doc = Nokogiri::HTML(open(service_url))
  checks.each do |check|
    check[:title_terms].each do |title_term|
      anchors = search_case_insensitive(homepage_doc, title_term, 'a')
      if anchors.empty?
        puts "Couldn't find legal pages for #{service_url}."
      end

      anchors.each do |anchor|
        policy_path = anchor[:href]
        policy_url = URI.join(service_url, policy_path).to_s
        policy_doc = Nokogiri::HTML(open(policy_url))
        check[:clause_terms].each do |clause_term|
          if contains?(policy_doc, clause_term)
            puts "Found '#{clause_term}' in #{policy_url}."
          else
            puts "Didn't find '#{clause_term}' in #{policy_url}."
          end
        end
      end
    end
  end
end
