# frozen_string_literal: true

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

  describe '#valid_move?' do
    let(:king) { King.new(:white) }

    it 'returns true for a valid king move' do
      expect(king.valid_move?([5, 5], [4, 5])).to be true
      expect(king.valid_move?([5, 5], [6, 6])).to be true
    end

    it 'returns false for an invalid king move' do
      expect(king.valid_move?([5, 5], [7, 6])).to be false
      expect(king.valid_move?([5, 5], [3, 5])).to be false
    end
  end

  describe '#target' do
    it 'returns all adjacent squares from the center' do
      position = [4, 4]
      targets = king.targets(position)

      expected = [
        [3, 3], [3, 4], [3, 5],
        [4, 3],         [4, 5],
        [5, 3], [5, 4], [5, 5]
      ]

      expect(targets).to match_array(expected)
    end
  end

  describe '#castles?' do
    let(:white_king) { King.new(:white) }
    let(:black_king) { King.new(:black) }

    context 'with valid castling moves' do
      it 'returns true for white kingside castling' do
        expect(white_king.castles?([7, 4], [7, 6])).to be true
      end

      it 'returns true for white queenside castling' do
        expect(white_king.castles?([7, 4], [7, 2])).to be true
      end

      it 'returns true for black kingside castling' do
        expect(black_king.castles?([0, 4], [0, 6])).to be true
      end

      it 'returns true for black queenside castling' do
        expect(black_king.castles?([0, 4], [0, 2])).to be true
      end
    end

    context 'with invalid castling attempts' do
      it 'returns false for white king trying black castling square' do
        expect(white_king.castles?([0, 4], [0, 6])).to be false
      end

      it 'returns false for black king trying white castling square' do
        expect(black_king.castles?([7, 4], [7, 2])).to be false
      end

      it 'returns false if from square is wrong' do
        expect(white_king.castles?([7, 3], [7, 6])).to be false
      end

      it 'returns false if to square is wrong' do
        expect(white_king.castles?([7, 4], [7, 5])).to be false
      end
    end
  end
end
