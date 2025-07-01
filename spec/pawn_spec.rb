# frozen_string_literal: true

require_relative '../lib/pawn'

describe Pawn do
  context 'when white' do
    subject(:pawn) { described_class.new(:white) }

    it 'has forward and capture offsets' do
      expect(pawn.possible_moves).to include([-1, 0], [-2, 0], [-1, 1], [-1, -1])
    end
  end

  context 'when black' do
    subject(:pawn) { described_class.new(:black) }

    it 'has forward and capture offsets' do
      expect(pawn.possible_moves).to include([1, 0], [2, 0], [1, 1], [1, -1])
    end
  end

  describe '#valid_move?' do
    let(:white_pawn) { Pawn.new(:white) }
    let(:black_pawn) { Pawn.new(:black) }

    it 'returns true for a valid forward move (white)' do
      expect(white_pawn.valid_move?([6, 0], [5, 0])).to be true
      expect(white_pawn.valid_move?([6, 0], [4, 0])).to be true
    end

    it 'returns true for a valid forward move (black)' do
      expect(black_pawn.valid_move?([1, 0], [2, 0])).to be true
      expect(black_pawn.valid_move?([1, 0], [3, 0])).to be true
    end

    it 'returns false for invalid pawn moves' do
      expect(white_pawn.valid_move?([6, 0], [3, 0])).to be false
      expect(white_pawn.valid_move?([6, 0], [6, 1])).to be false
    end
  end
  
end
