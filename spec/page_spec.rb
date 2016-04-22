require_relative '../lib/legalese/page'

describe Legalese::Page do
  def page_with_body(body)
    page = Legalese::Page.new('http://example.com')
    html = construct_html(body)
    expect(page).to receive(:body).and_return(html)

    page
  end

  describe "uniqueness" do
    it "is == to another with the same URL" do
      page1 = Legalese::Page.new('http://example.com')
      page2 = Legalese::Page.new('http://example.com')
      expect(page1 == page2).to eq(true)
    end

    it "is #eql? to another with the same URL" do
      page1 = Legalese::Page.new('http://example.com')
      page2 = Legalese::Page.new('http://example.com')
      expect(page1.eql?(page2)).to eq(true)
    end
  end

  describe '#contains_text?' do
    it "matches exact text" do
      page = page_with_body('<h1>Cats and Dogs</h1>')
      expect(page.contains_text?('Cats')).to eq(true)
    end

    it "matches case insensitively" do
      page = page_with_body('<h1>Cats and Dogs</h1>')
      expect(page.contains_text?('cats')).to eq(true)
    end

    it "returns false for no matches" do
      page = page_with_body('<h1>Cats and Dogs</h1>')
      expect(page.contains_text?('birds')).to eq(false)
    end
  end

  describe '#urls_for' do
    it "matches exact text" do
      page = page_with_body('<a href="http://foo.com">Cats and Dogs</h1>')
      expect(page.urls_for('Cats')).to eq(['http://foo.com'])
    end

    it "matches case insensitively" do
      page = page_with_body('<a href="http://foo.com">Cats and Dogs</h1>')
      expect(page.urls_for('cats')).to eq(['http://foo.com'])
    end

    it "returns empty Array for no matches" do
      page = page_with_body('<a href="http://foo.com">Cats and Dogs</h1>')
      expect(page.urls_for('birds')).to eq([])
    end

    it "returns absolute URLs" do
      page = page_with_body('<a href="foo.html">Cats and Dogs</h1>')
      expect(page.urls_for('Cats')).to eq(['http://example.com/foo.html'])
    end
  end
end
