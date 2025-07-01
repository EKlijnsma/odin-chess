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

  describe '#valid_move?' do
    it 'returns true for diagonal moves' do
      expect(bishop.valid_move?([5, 5], [7, 7])).to be true
      expect(bishop.valid_move?([5, 5], [3, 3])).to be true
    end

    it 'returns false for non-diagonal moves' do
      expect(bishop.valid_move?([5, 5], [5, 6])).to be false
      expect(bishop.valid_move?([5, 5], [6, 5])).to be false
    end
  end

  describe '#targets' do
    it 'returns all diagonal targets from the center' do
      position = [3, 3]
      targets = bishop.targets(position)
      expected = []

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
