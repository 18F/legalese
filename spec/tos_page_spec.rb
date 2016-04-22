require_relative '../lib/legalese/tos_page'

describe Legalese::TosPage do
  def page_with_body(body)
    page = Legalese::TosPage.new('http://example.com')
    html = construct_html(body)
    expect(page).to receive(:body).and_return(html)

    page
  end

  describe '#contains_clause?' do
    it "finds a given clause" do
      page = page_with_body('foo indemnify bar')
      expect(page.contains_clause?('indemnity')).to eq(true)
    end

    it "ignores other clauses" do
      clauses = Legalese::TosPage.clauses
      other_term = Legalese::TosPage.terms_for(clauses.last).first
      page = page_with_body("foo #{other_term} bar")
      expect(page.contains_clause?(clauses.first)).to eq(false)
    end
  end
end
