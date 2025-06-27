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
end
