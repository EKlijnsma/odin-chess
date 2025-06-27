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
end
