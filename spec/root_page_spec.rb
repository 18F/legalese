require_relative '../lib/legalese/root_page'

describe Legalese::RootPage do
  def root_page_with_body(body)
    page = Legalese::RootPage.new('http://example.com')
    html = construct_html(body)
    expect(page).to receive(:body).and_return(html)

    page
  end

  describe '#privacy_policy_pages' do
    it "returns an empty Array when there are none found" do
      page = root_page_with_body('')
      expect(page.privacy_policy_pages).to eq([])
    end

    it "finds the privacy page" do
      page = root_page_with_body('<a href="privacy.html">Privacy Policy</a>')
      results = page.privacy_policy_pages
      expect(results.length).to eq(1)
      expect(results.first.url).to eq('http://example.com/privacy.html')
    end

    it "only returns each Page once" do
      page = root_page_with_body('<a href="privacy.html">Privacy Policy</a><a href="privacy.html">Privacy</a>')
      results = page.privacy_policy_pages
      expect(results.length).to eq(1)
    end
  end

  describe '#tos_pages' do
    it "returns an empty Array when there are none found" do
      page = root_page_with_body('')
      expect(page.tos_pages).to eq([])
    end

    it "finds the ToS page" do
      page = root_page_with_body('<a href="tos.html">Terms of Service</a>')
      results = page.tos_pages
      expect(results.length).to eq(1)
      expect(results.first.url).to eq('http://example.com/tos.html')
    end

    it "only returns each Page once" do
      page = root_page_with_body('<a href="tos.html">Terms of Service</a><a href="tos.html">ToS</a>')
      results = page.tos_pages
      expect(results.length).to eq(1)
    end
  end
end
