require_relative '../lib/knight'

describe Knight do
  context 'when initialized as white' do
    subject(:white_knight) { described_class.new(:white) }

    it 'has the white knight symbol' do
      expect(white_knight.symbol).to eq('♘')
    end

    it 'returns 8 possible move offsets' do
      expect(white_knight.possible_moves.length).to eq(8)
    end

    it 'includes [2, 1] as a possible move' do
      expect(white_knight.possible_moves).to include([2, 1])
    end
  end

  context 'when initialized as black' do
    subject(:black_knight) { described_class.new(:black) }

    it 'has the black knight symbol' do
      expect(black_knight.symbol).to eq('♞')
    end
  end
end
