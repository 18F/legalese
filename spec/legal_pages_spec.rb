require_relative '../lib/legalese/search/legal_pages'

describe Legalese::Search::LegalPages do
  def search_with_body(body)
    page = page_with_body(body)
    Legalese::Search::LegalPages.new(page)
  end

  describe '#privacy_policy_pages' do
    it "returns an empty Array when there are none found" do
      search = search_with_body('')
      expect(search.privacy_policy_pages).to eq([])
    end

    it "finds the privacy page" do
      search = search_with_body('<a href="privacy.html">Privacy Policy</a>')
      results = search.privacy_policy_pages
      expect(results.length).to eq(1)
      expect(results.first.url).to eq('http://example.com/privacy.html')
    end

    it "only returns each Page once" do
      search = search_with_body('<a href="privacy.html">Privacy Policy</a><a href="privacy.html">Privacy</a>')
      results = search.privacy_policy_pages
      expect(results.length).to eq(1)
    end
  end

  describe '#tos_pages' do
    it "returns an empty Array when there are none found" do
      search = search_with_body('')
      expect(search.tos_pages).to eq([])
    end

    it "finds the ToS page" do
      search = search_with_body('<a href="tos.html">Terms of Service</a>')
      results = search.tos_pages
      expect(results.length).to eq(1)
      expect(results.first.url).to eq('http://example.com/tos.html')
    end

    it "only returns each Page once" do
      search = search_with_body('<a href="tos.html">Terms of Service</a><a href="tos.html">ToS</a>')
      results = search.tos_pages
      expect(results.length).to eq(1)
    end
  end
end
