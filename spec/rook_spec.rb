# frozen_string_literal: true

require_relative '../lib/rook'

describe Rook do
  subject(:rook) { described_class.new(:white) }

  describe '#possible_moves' do
    it 'returns all horizontal and vertical move offsets' do
      expected = []
      (1..7).each { |i| expected += [[i, 0], [-i, 0], [0, i], [0, -i]] }
      expect(rook.possible_moves).to match_array(expected)
    end
  end
end
