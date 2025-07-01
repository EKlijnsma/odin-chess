# frozen_string_literal: true

require_relative '../lib/queen'

describe Queen do
  subject(:queen) { described_class.new(:white) }

  describe '#possible_moves' do
    it 'returns all rook and bishop move offsets' do
      expected = []
      (1..7).each do |i|
        expected += [[i, i], [i, -i], [-i, i], [-i, -i], [i, 0], [-i, 0], [0, i], [0, -i]]
      end
      expect(queen.possible_moves).to match_array(expected)
    end
  end

  describe '#valid_move?' do
    it 'returns true for vertical, horizontal, and diagonal moves' do
      expect(queen.valid_move?([5, 5], [5, 0])).to be true
      expect(queen.valid_move?([5, 5], [2, 2])).to be true
    end

    it 'returns false for invalid queen moves' do
      expect(queen.valid_move?([5, 5], [6, 3])).to be false
      expect(queen.valid_move?([5, 5], [4, 7])).to be false
    end
  end
end
