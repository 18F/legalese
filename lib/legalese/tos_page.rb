require_relative 'page'

module Legalese
  class TosPage < Page
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

    def contains_clause?(clause)
      terms = self.class.terms_for(clause)
      terms.any? do |term|
        contains_text?(term)
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
