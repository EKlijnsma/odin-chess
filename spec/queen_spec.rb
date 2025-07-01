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

  describe '#target' do
    it 'returns all orthogonal and diagonal targets from the center' do
      position = [3, 3]
      targets = queen.targets(position)
      expected = []

      0.upto(7) { |i| expected << [i, 3] unless i == 3 } # vertical
      0.upto(7) { |j| expected << [3, j] unless j == 3 } # horizontal

      (1..7).each do |offset|
        expected << [3 + offset, 3 + offset] if (3 + offset).between?(0, 7)
        expected << [3 - offset, 3 - offset] if (3 - offset).between?(0, 7)
        expected << [3 + offset, 3 - offset] if (3 + offset).between?(0, 7) && (3 - offset).between?(0, 7)
        expected << [3 - offset, 3 + offset] if (3 - offset).between?(0, 7) && (3 + offset).between?(0, 7)
      end

      expect(targets).to match_array(expected)
    end
  end
end
