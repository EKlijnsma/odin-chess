# frozen_string_literal: true

require_relative '../lib/board'
require_relative '../lib/player'
require_relative '../lib/piece'
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

  describe '#execute_move' do
    it 'moves a piece from the from position to the to position' do
      piece = Rook.new(:white)
      board.state[0][0] = piece

      board.execute_move([0, 0], [0, 3])

      expect(board.state[0][0]).to be_nil
      expect(board.state[0][3]).to eq(piece)
    end

    it 'overwrites the destination if occupied' do
      white_rook = Rook.new(:white)
      black_king = King.new(:black)
      board.state[0][0] = white_rook
      board.state[0][3] = black_king

      board.execute_move([0, 0], [0, 3])

      expect(board.state[0][0]).to be_nil
      expect(board.state[0][3]).to eq(white_rook)
    end
  end

  describe '#friendly_fire?' do
    it 'returns true if destination has same-color piece' do
      white_rook = Rook.new(:white)
      white_king = King.new(:white)
      board.state[0][0] = white_rook
      board.state[0][1] = white_king

      expect(board.friendly_fire?([0, 0], [0, 1])).to be true
    end

    it 'returns false if destination has opponent piece' do
      white_rook = Rook.new(:white)
      black_king = King.new(:black)
      board.state[0][0] = white_rook
      board.state[0][1] = black_king

      expect(board.friendly_fire?([0, 0], [0, 1])).to be false
    end

    it 'returns false if destination is empty' do
      white_rook = Rook.new(:white)
      board.state[0][0] = white_rook

      expect(board.friendly_fire?([0, 0], [0, 1])).to be false
    end
  end

  describe '#clear_path?' do
    before do
      board.clear_board
    end

    it 'returns true for clear diagonal path' do
      expect(board.clear_path?([0, 0], [3, 3])).to be true
    end

    it 'returns false if diagonal path is blocked' do
      board.state[1][1] = Knight.new(:black)
      expect(board.clear_path?([0, 0], [3, 3])).to be false
    end

    it 'returns true for clear vertical path' do
      expect(board.clear_path?([0, 0], [3, 0])).to be true
    end

    it 'returns false if vertical path is blocked' do
      board.state[1][0] = Knight.new(:black)
      expect(board.clear_path?([0, 0], [3, 0])).to be false
    end

    it 'returns true for clear horizontal path' do
      expect(board.clear_path?([3, 0], [3, 5])).to be true
    end

    it 'returns false if horizontal path is blocked' do
      board.state[3][2] = Bishop.new(:white)
      expect(board.clear_path?([3, 0], [3, 5])).to be false
    end

    it 'returns true if from and to are adjacent' do
      expect(board.clear_path?([4, 4], [4, 5])).to be true
    end

    it 'returns true when from and to are same (no path)' do
      expect(board.clear_path?([4, 4], [4, 4])).to be true
    end
  end

  describe '#deep_clone' do
    it 'returns a new Board object with an independent copy of the state' do
      clone = board.deep_clone

      # Ensure it's a different object
      expect(clone).not_to equal(board)

      # Ensure the state is duplicated (not shallow copied)
      expect(clone.state).not_to equal(board.state)

      # Mutating the clone should not affect the original
      clone.state[0][0] = nil
      expect(board.state[0][0]).not_to be_nil
    end

    it 'copies the pieces correctly' do
      clone = board.deep_clone

      original_piece = board.state[0][4]
      cloned_piece = clone.state[0][4]

      expect(cloned_piece).to be_a(original_piece.class)
      expect(cloned_piece.color).to eq(original_piece.color)
      expect(cloned_piece).not_to equal(original_piece)
    end
  end

  describe '#find_king' do
    it 'finds the white king in its initial position' do
      expect(board.find_king(:white)).to eq([7, 4])
    end

    it 'finds the black king in its initial position' do
      expect(board.find_king(:black)).to eq([0, 4])
    end

    it 'returns nil if the king is not on the board' do
      board.state[0][4] = nil
      expect(board.find_king(:black)).to be_nil
    end
  end

  describe '#get_all_targets' do
    before do
      board.clear_board
    end

    it 'returns correct targets for a knight' do
      knight = double('Knight', color: :white, sliding?: false)
      allow(knight).to receive(:targets).with([0, 0]).and_return([[2, 1], [1, 2]])

      board.place_piece(knight, [0, 0])

      expect(board.get_all_targets(:white)).to match_array([[2, 1], [1, 2]])
    end

    it 'does not include blocked targets for a rook' do
      rook = double('Rook', color: :white, sliding?: true)
      allow(rook).to receive(:targets).with([0, 0]).and_return([
                                                                 [1, 0], [2, 0], [3, 0], [4, 0], [5, 0], [6, 0], [7, 0], # down
                                                                 [0, 1], [0, 2], [0, 3], [0, 4], [0, 5], [0, 6], [0, 7] # right
                                                               ])

      blocker = double('Blocker', color: :white, sliding?: false)
      allow(blocker).to receive(:targets).with([3, 0]).and_return([])

      board.place_piece(rook, [0, 0])
      board.place_piece(blocker, [3, 0])

      # assuming Board#get_all_targets removes [4,0] and beyond due to blocker at [3,0]
      expect(board.get_all_targets(:white)).to include([1, 0], [2, 0], [3, 0])
      expect(board.get_all_targets(:white)).not_to include([4, 0], [5, 0])
    end

    it 'returns combined targets from multiple white pieces' do
      rook = double('Rook', color: :white, sliding?: true)
      allow(rook).to receive(:targets).with([0, 0]).and_return([[1, 0], [2, 0]])

      knight = double('Knight', color: :white, sliding?: false)
      allow(knight).to receive(:targets).with([1, 1]).and_return([[2, 3], [0, 2]])

      board.place_piece(rook, [0, 0])
      board.place_piece(knight, [1, 1])

      expect(board.get_all_targets(:white)).to match_array([[1, 0], [2, 0], [2, 3], [0, 2]])
    end

    it 'does not include targets from opponent pieces' do
      white_rook = double('Rook', color: :white, sliding?: true)
      allow(white_rook).to receive(:targets).with([0, 0]).and_return([[1, 0]])

      black_knight = double('Knight', color: :black, sliding?: false)
      allow(black_knight).to receive(:targets).with([7, 7]).and_return([[5, 6], [6, 5]])

      board.place_piece(white_rook, [0, 0])
      board.place_piece(black_knight, [7, 7])

      expect(board.get_all_targets(:white)).to eq([[1, 0]])
      expect(board.get_all_targets(:black)).to eq([[5, 6], [6, 5]])
    end

    it 'returns a flat array of coordinate pairs when combining multiple pieces' do
      rook = double('Rook', color: :white, sliding?: true)
      allow(rook).to receive(:targets).with([0, 0]).and_return([[1, 0], [2, 0]])

      knight = double('Knight', color: :white, sliding?: false)
      allow(knight).to receive(:targets).with([1, 1]).and_return([[2, 3], [0, 2]])

      board.place_piece(rook, [0, 0])
      board.place_piece(knight, [1, 1])

      result = board.get_all_targets(:white)

      # Flat array of coordinate pairs: [[1, 0], [2, 0], [2, 3], [0, 2]]
      expect(result).to be_an(Array)
      expect(result).to all(be_an(Array).and(have_attributes(size: 2)))
      expect(result.flatten).to all(be_an(Integer))

      # Explicitly confirm no nested arrays like [[[...]]]
      expect(result).not_to include(an_instance_of(Array).and(satisfy { |a| a.any? { |x| x.is_a?(Array) } }))
    end
  end

  describe '#in_check?' do
    before do
      board.clear_board
    end

    it 'returns true if the king is under attack' do
      # Stub the king's position
      allow(board).to receive(:find_king).with(:white).and_return([4, 0])
      # Simulate that black is targeting that square
      allow(board).to receive(:get_all_targets).with(:black).and_return([[4, 0], [3, 2]])

      expect(board.in_check?(:white)).to be true
    end

    it 'returns false if the king is not under attack' do
      allow(board).to receive(:find_king).with(:white).and_return([4, 0])
      allow(board).to receive(:get_all_targets).with(:black).and_return([[3, 2], [5, 1]])

      expect(board.in_check?(:white)).to be false
    end

    it 'checks correct opponent color' do
      # Just a sanity check for black's king this time
      allow(board).to receive(:find_king).with(:black).and_return([4, 7])
      allow(board).to receive(:get_all_targets).with(:white).and_return([[4, 7]])

      expect(board.in_check?(:black)).to be true
    end
  end

  describe '#results_in_check?' do
    let(:piece) { double('Piece', color: :white) }
    let(:clone) { instance_double(Board) }

    before do
      board.clear_board
      allow(board).to receive(:piece_at).with([1, 1]).and_return(piece)
      allow(board).to receive(:deep_clone).and_return(clone)
      allow(clone).to receive(:execute_move)
    end

    it 'returns true if move results in check' do
      allow(clone).to receive(:in_check?).with(:white).and_return(true)

      result = board.results_in_check?([1, 1], [2, 2])
      expect(result).to be true
    end

    it 'returns false if move does not result in check' do
      allow(clone).to receive(:in_check?).with(:white).and_return(false)

      result = board.results_in_check?([1, 1], [2, 2])
      expect(result).to be false
    end

    it 'uses the correct piece color when checking for check' do
      expect(clone).to receive(:in_check?).with(:white).and_return(false)

      board.results_in_check?([1, 1], [2, 2])
    end

    it 'executes the move on the cloned board' do
      expect(clone).to receive(:execute_move).with([1, 1], [2, 2])
      allow(clone).to receive(:in_check?).with(:white).and_return(false)

      board.results_in_check?([1, 1], [2, 2])
    end
  end

end
