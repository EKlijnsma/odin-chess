# frozen_string_literal: true

require_relative '../lib/bishop'

describe Bishop do
  subject(:bishop) { described_class.new(:white) }

  describe '#possible_moves' do
    it 'returns all diagonal move offsets' do
      expected = []
      (1..7).each { |i| expected += [[i, i], [i, -i], [-i, i], [-i, -i]] }
      expect(bishop.possible_moves).to match_array(expected)
    end
  end
end
