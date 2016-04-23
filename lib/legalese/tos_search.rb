module Legalese
  class TosSearch
    # looks for these terms
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

    attr_reader :page

    def initialize(page)
      @page = page
    end

    def contains_clause?(clause)
      terms = self.class.terms_for(clause)
      terms.any? do |term|
        page.contains_text?(term)
      end
    end

    def self.clauses
      CLAUSE_TERMS.keys
    end

    def self.terms_for(clause)
      CLAUSE_TERMS[clause.to_sym]
    end
  end
end
