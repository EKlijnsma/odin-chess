# frozen_string_literal: true

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

  describe '#valid_move?' do
    subject(:white_knight) { described_class.new(:white) }

    it 'returns true for valid L-shaped moves' do
      expect(white_knight.valid_move?([5, 5], [7, 6])).to be true
      expect(white_knight.valid_move?([5, 5], [6, 7])).to be true
    end

    it 'returns false for non L-shaped moves' do
      expect(white_knight.valid_move?([5, 5], [5, 6])).to be false
      expect(white_knight.valid_move?([5, 5], [4, 4])).to be false
    end
  end

  describe '#target' do
    subject(:white_knight) { described_class.new(:white) }
    it 'returns all valid L-shaped targets from the center' do
      position = [4, 4]
      targets = white_knight.targets(position)

      expected = [
        [2, 3], [2, 5], [3, 2], [3, 6],
        [5, 2], [5, 6], [6, 3], [6, 5]
      ]

      expect(targets).to match_array(expected)
    end
  end
end
