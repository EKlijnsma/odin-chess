require_relative '../lib/king'

describe King do
  subject(:king) { described_class.new(:white) }

  describe '#possible_moves' do
    it 'returns all adjacent square offsets' do
      expected = [
        [1, 0], [1, 1], [0, 1], [-1, 1],
        [-1, 0], [-1, -1], [0, -1], [1, -1]
      ]
      expect(king.possible_moves).to match_array(expected)
    end
  end
end
