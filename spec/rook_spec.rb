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

  describe '#valid_move?' do
    it 'returns true for horizontal and vertical moves' do
      expect(rook.valid_move?([5, 5], [5, 0])).to be true
      expect(rook.valid_move?([5, 5], [0, 5])).to be true
    end

    it 'returns false for diagonal moves' do
      expect(rook.valid_move?([5, 5], [6, 6])).to be false
      expect(rook.valid_move?([5, 5], [4, 4])).to be false
    end
  end

  describe '#targets' do
    it 'returns all in-bounds orthogonal targets from the center' do
      position = [3, 3]
      targets = rook.targets(position)
      expected = []

      0.upto(7) { |i| expected << [i, 3] unless i == 3 } # vertical
      0.upto(7) { |j| expected << [3, j] unless j == 3 } # horizontal

      expect(targets).to match_array(expected)
    end
  end
end
