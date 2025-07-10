# frozen_string_literal: true

require_relative '../lib/game'

describe Game do
  let(:board) { instance_double('Board') }
  let(:player1) { instance_double('Player') }
  let(:player2) { instance_double('Player') }
  subject(:game) { described_class.new(board, player1, player2) }

  describe '#initialize' do
    it 'assigns board and players correctly' do
      expect(game.board).to eq(board)
      expect(game.player1).to eq(player1)
      expect(game.player2).to eq(player2)
      expect(game.current_player).to eq(player1)
    end
  end

  describe '#notation_to_coords' do
    it 'converts notation e2 to correct coordinates' do
      expect(game.notation_to_coords('e2')).to eq([6, 4]) # row 6, col 4
    end

    it 'converts notation a8 to correct coordinates' do
      expect(game.notation_to_coords('a8')).to eq([0, 0])
    end

    it 'converts notation h1 to correct coordinates' do
      expect(game.notation_to_coords('h1')).to eq([7, 7])
    end
  end

  describe '#select_valid_piece' do
    it 'returns valid piece coordinates' do
      allow(player1).to receive(:select_piece).and_return('e2')
      allow(game).to receive(:notation_to_coords).with('e2').and_return([6, 4])
      allow(board).to receive(:validate_selection).with([6, 4], player1).and_return(true)

      expect(game.select_valid_piece(player1)).to eq([6, 4])
    end

    it 'repeats prompt until valid piece selected' do
      allow(player1).to receive(:select_piece).and_return('z9', 'e2')
      allow(game).to receive(:notation_to_coords).with('z9').and_return([0, 0])
      allow(game).to receive(:notation_to_coords).with('e2').and_return([6, 4])

      allow(board).to receive(:validate_selection).with([0, 0], player1).and_return(false)
      allow(board).to receive(:validate_selection).with([6, 4], player1).and_return(true)

      expect(game).to receive(:puts).with('Invalid piece selection, try again.').once

      expect(game.select_valid_piece(player1)).to eq([6, 4])
    end
  end

  describe '#select_valid_destination' do
    let(:piece_coords) { [6, 4] }

    it 'returns valid destination coordinates' do
      allow(player1).to receive(:select_destination).and_return('e4')
      allow(game).to receive(:notation_to_coords).with('e4').and_return([4, 4])
      allow(board).to receive(:validate_destination).with(piece_coords, [4, 4]).and_return(true)

      expect(game.select_valid_destination(player1, piece_coords)).to eq([4, 4])
    end

    it 'repeats prompt until valid destination selected' do
      allow(player1).to receive(:select_destination).and_return('z9', 'e4')
      allow(game).to receive(:notation_to_coords).with('z9').and_return([0, 0])
      allow(game).to receive(:notation_to_coords).with('e4').and_return([4, 4])

      allow(board).to receive(:validate_destination).with(piece_coords, [0, 0]).and_return(false)
      allow(board).to receive(:validate_destination).with(piece_coords, [4, 4]).and_return(true)

      expect(game).to receive(:puts).with('Invalid destination, try again or type "cancel" to select a different piece.').once

      expect(game.select_valid_destination(player1, piece_coords)).to eq([4, 4])
    end

    it 'calls get_move again when input is cancel' do
      allow(player1).to receive(:select_destination).and_return('cancel')
      expect(game).to receive(:get_move).with(player1)

      game.select_valid_destination(player1, piece_coords)
    end
  end

  describe '#insufficient_material?' do
    let(:white_king) { instance_double('King') }
    let(:white_knight) { instance_double('Knight') }
    let(:white_bishop) { instance_double('Bishop') }
    let(:black_bishop) { instance_double('Bishop') }
    let(:white_pawn) { instance_double('Pawn') }
    let(:black_king) { instance_double('King') }

    before do
      allow(white_knight).to receive(:is_a?).with(Knight).and_return(true)
      allow(white_knight).to receive(:is_a?).with(Bishop).and_return(false)
      allow(black_bishop).to receive(:is_a?).with(Knight).and_return(false)
      allow(black_bishop).to receive(:is_a?).with(Bishop).and_return(true)
      allow(white_bishop).to receive(:is_a?).with(Knight).and_return(false)
      allow(white_bishop).to receive(:is_a?).with(Bishop).and_return(true)
      allow(white_king).to receive(:is_a?).with(Knight).and_return(false)
      allow(white_king).to receive(:is_a?).with(Bishop).and_return(false)
      allow(white_pawn).to receive(:is_a?).with(Knight).and_return(false)
      allow(white_pawn).to receive(:is_a?).with(Bishop).and_return(false)
      allow(black_king).to receive(:is_a?).with(Knight).and_return(false)
      allow(black_king).to receive(:is_a?).with(Bishop).and_return(false)
    end
    it 'returns true for King vs King' do
      allow(board).to receive(:pieces).with(:white).and_return([{ piece: white_king, row: 0, col: 4 }])
      allow(board).to receive(:pieces).with(:black).and_return([{ piece: black_king, row: 7, col: 4 }])
      expect(game.insufficient_material?).to be true
    end

    it 'returns true for King vs King + Knight' do
      allow(board).to receive(:pieces).with(:white).and_return([{ piece: white_knight, row: 1, col: 4 },
                                                                { piece: white_king, row: 0, col: 4 }])
      allow(board).to receive(:pieces).with(:black).and_return([{ piece: black_king, row: 7, col: 4 }])
      expect(game.insufficient_material?).to be true
    end

    it 'returns true for King vs King + Bishop' do
      allow(board).to receive(:pieces).with(:white).and_return([{ piece: white_king, row: 0, col: 4 }])
      allow(board).to receive(:pieces).with(:black).and_return([{ piece: black_king, row: 7, col: 4 },
                                                                { piece: black_bishop, row: 5, col: 4 }])
      expect(game.insufficient_material?).to be true
    end

    it 'returns true for King+Bishop vs King+Bishop with same-colored squares' do
      allow(board).to receive(:pieces).with(:white).and_return([{ piece: white_king, row: 0, col: 4 },
                                                                { piece: white_bishop, row: 0, col: 5 }])
      allow(board).to receive(:pieces).with(:black).and_return([{ piece: black_king, row: 7, col: 4 },
                                                                { piece: black_bishop, row: 5, col: 4 }])
      expect(game.insufficient_material?).to be true
    end

    it 'returns false for King+Bishop vs King+Bishop with opposite-colored squares' do
      allow(board).to receive(:pieces).with(:white).and_return([{ piece: white_king, row: 0, col: 4 },
                                                                { piece: white_bishop, row: 1, col: 5 }])
      allow(board).to receive(:pieces).with(:black).and_return([{ piece: black_king, row: 7, col: 4 },
                                                                { piece: black_bishop, row: 5, col: 4 }])
      expect(game.insufficient_material?).to be false
    end

    it 'returns false if either player has more than 2 pieces' do
      allow(board).to receive(:pieces).with(:white).and_return([{ piece: white_king, row: 0, col: 4 },
                                                                { piece: white_bishop, row: 1, col: 5 },
                                                                { piece: white_knight, row: 1, col: 2 }])
      allow(board).to receive(:pieces).with(:black).and_return([{ piece: black_king, row: 7, col: 4 }])
      expect(game.insufficient_material?).to be false
    end

    it 'returns false when King vs King + pawn' do
      allow(board).to receive(:pieces).with(:white).and_return([{ piece: white_king, row: 0, col: 4 },
                                                                { piece: white_pawn, row: 1, col: 2 }])
      allow(board).to receive(:pieces).with(:black).and_return([{ piece: black_king, row: 7, col: 4 }])
      expect(game.insufficient_material?).to be false
    end
  end

  describe '#same_colored_bishops?' do
    let(:white_king) { instance_double('King') }
    let(:white_bishop) { instance_double('Bishop') }
    let(:black_king) { instance_double('King') }
    let(:black_bishop) { instance_double('Bishop') }
    let(:white) { [{ piece: white_king, row: 0, col: 4 }, { piece: white_bishop, row: 0, col: 5 }] }
    let(:black) { [{ piece: black_king, row: 7, col: 4 }, { piece: black_bishop, row: 5, col: 4 }] }
    let(:black2) { [{ piece: black_king, row: 7, col: 4 }, { piece: black_bishop, row: 6, col: 4 }] }

    before do
      allow(white_king).to receive(:is_a?).with(Bishop).and_return(false)
      allow(black_king).to receive(:is_a?).with(Bishop).and_return(false)
      allow(white_bishop).to receive(:is_a?).with(Bishop).and_return(true)
      allow(black_bishop).to receive(:is_a?).with(Bishop).and_return(true)
    end
    

    it 'returns true for same-colored bishops' do
      expect(game.same_colored_bishops?(black, white)).to be true
    end
    
    it 'returns false for opposite-colored bishops' do
      expect(game.same_colored_bishops?(black2, white)).to be false
    end
  end

  describe '#threefold_repetition?' do
    context 'when given a simple array' do
      it 'returns true when 3 repeated items' do
        game.instance_variable_set(:@position_history, [1,2,3,2,5,2])
        expect(game.threefold_repetition?).to be true
      end
      
      it 'returns false when 2 repeated items' do
        game.instance_variable_set(:@position_history, [1,2,3,4,5,2])
        expect(game.threefold_repetition?).to be false
      end
      
      it 'returns false when empty' do
        game.instance_variable_set(:@position_history, [])
        expect(game.threefold_repetition?).to be false
      end
    end
    
    context 'when given an array of position hashes' do
      let(:pos1) do
        {
          board: Array.new(64, nil),
          turn: player1,
          castling: { white: %i[k], black: %i[k q] },
          en_passant: nil
        }
      end
      let(:pos2) do
        {
          board: Array.new(64, nil),
          turn: player2,
          castling: { white: %i[k], black: %i[k q] },
          en_passant: [1,2]
        }
      end
      it 'returns true when 3 repeated items' do
        game.instance_variable_set(:@position_history, [pos1, pos2, pos1, pos2, pos1])
        expect(game.threefold_repetition?).to be true
      end

      it 'returns false when 2 repeated items' do
        game.instance_variable_set(:@position_history, [pos1, pos2, pos1, pos2])
        expect(game.threefold_repetition?).to be false
      end
    end
  end
end
