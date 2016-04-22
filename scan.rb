require_relative 'lib/legalese/service'

File.foreach('domains.txt') do |service_url|
  service_url.strip!
  next if service_url.empty?

  puts service_url

  srvice = Legalese::Service.new(service_url)
  puts "  privacy policy: #{srvice.has_privacy_policy?}"

  tos_found = srvice.tos_pages.any?
  puts "  ToS found: #{tos_found}"
  if tos_found
    clauses = Legalese::Service::CLAUSE_TERMS.keys
    clauses.each do |clause|
      has_clause = srvice.contains_tos_clause?(clause)
      puts "  ToS #{clause} clause: #{has_clause}"
    end
  end
end
