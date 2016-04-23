require_relative '../lib/legalese/tos_search'

describe Legalese::TosSearch do
  def tos_with_body(body)
    page = page_with_body(body)
    Legalese::TosSearch.new(page)
  end

  describe '#contains_clause?' do
    it "finds a given clause" do
      page = tos_with_body('foo indemnify bar')
      expect(page.contains_clause?('indemnity')).to eq(true)
    end

    it "ignores other clauses" do
      clauses = Legalese::TosSearch.clauses
      other_term = Legalese::TosSearch.terms_for(clauses.last).first
      page = tos_with_body("foo #{other_term} bar")
      expect(page.contains_clause?(clauses.first)).to eq(false)
    end
  end
end
