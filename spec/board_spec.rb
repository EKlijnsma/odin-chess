require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/rook'
require_relative '../lib/knight'
require_relative '../lib/bishop'
require_relative '../lib/queen'
require_relative '../lib/king'
require_relative '../lib/pawn'

describe Board do
  subject(:board) { described_class.new }

  let(:white_player) { Player.new('Alice', :white) }
  let(:black_player) { Player.new('Bob', :black) }

  describe '#initialize' do
    it 'places all pieces in their correct starting positions' do
      expect(board.state[0][0]).to be_a(Rook)
      expect(board.state[0][0].color).to eq(:black)

      expect(board.state[0][1]).to be_a(Knight)
      expect(board.state[0][2]).to be_a(Bishop)
      expect(board.state[0][3]).to be_a(Queen)
      expect(board.state[0][4]).to be_a(King)
      expect(board.state[0][5]).to be_a(Bishop)
      expect(board.state[0][6]).to be_a(Knight)
      expect(board.state[0][7]).to be_a(Rook)

      expect(board.state[1].all? { |piece| piece.is_a?(Pawn) && piece.color == :black }).to be(true)
      expect(board.state[6].all? { |piece| piece.is_a?(Pawn) && piece.color == :white }).to be(true)

      expect(board.state[7][0]).to be_a(Rook)
      expect(board.state[7][0].color).to eq(:white)

      expect(board.state[7][4]).to be_a(King)
      expect(board.state[7][4].color).to eq(:white)
    end
  end

  describe '#piece_at' do
    it 'returns the correct piece at a given coordinate' do
      expect(board.piece_at([0, 0])).to be_a(Rook)
      expect(board.piece_at([1, 0])).to be_a(Pawn)
      expect(board.piece_at([4, 4])).to be_nil
    end
  end

  describe '#validate_selection' do
    context 'when a player selects their own piece' do
      it 'returns true for white player selecting white pawn' do
        expect(board.validate_selection([6, 0], white_player)).to be true
      end

      it 'returns true for black player selecting black knight' do
        expect(board.validate_selection([0, 1], black_player)).to be true
      end
    end

    context 'when a player selects an empty square' do
      it 'returns false' do
        expect(board.validate_selection([4, 4], white_player)).to be false
      end
    end

    context 'when a player selects an opponent\'s piece' do
      it 'returns false for white player selecting black piece' do
        expect(board.validate_selection([0, 0], white_player)).to be false
      end

      it 'returns false for black player selecting white piece' do
        expect(board.validate_selection([7, 0], black_player)).to be false
      end
    end
  end
end
