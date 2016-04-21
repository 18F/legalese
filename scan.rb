require 'nokogiri'
require 'open-uri'

# copy third column from
# https://docs.google.com/spreadsheets/d/180JGMG8O13_R9VxSDLYDWGg0JSWa3Higy911RS-PeNk/edit#gid=0
column = %w(
http://www.aha.io/product/integrations/github
https://apiary.io/
https://biterg.io/



https://codecov.io/










https://www.quantifiedcode.com/
)

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

column.each do |service_url|
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
