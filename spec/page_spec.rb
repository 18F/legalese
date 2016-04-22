require_relative '../lib/legalese/page'

describe Legalese::Page do
  def construct_html(body)
    <<-HTML
    <html>
      <head></head>
      <body>
        #{body}
      </body>
    </html>
    HTML
  end

  def page_with_body(body)
    page = Legalese::Page.new('http://example.com')
    html = construct_html(body)
    expect(page).to receive(:body).and_return(html)

    page
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
end
