require_relative 'player'
require_relative 'board'

class Game
  attr_accessor :player1, :player2, :board, :current_player

  def initialize(board, player1, player2)
    @board = board
    @player1 = player1
    @player2 = player2
    @current_player = player1
  end

  def get_move(player)
    piece_coords = select_valid_piece(player)
    destination_coords = select_valid_destination(player, piece_coords)
    [piece_coords, destination_coords]
  end

  def select_valid_piece(player)
    loop do
      input = player.select_piece
      coords = notation_to_coords(input)
      return coords if @board.validate_selection(coords, player)

      puts 'Invalid piece selection, try again.'
    end
  end

  def select_valid_destination(player, piece_coords)
    loop do
      input = player.select_destination
      return get_move(player) if input == 'cancel'

      coords = notation_to_coords(input)
      return coords if @board.validate_destination(piece_coords, coords)

      puts 'Invalid destination, try again or type "cancel" to select a different piece.'
    end
  end

  def notation_to_coords(notation)
    file = notation[0]
    rank = notation[1]

    # for the column, use the integer ordinal to determine the index, a = 0, b = 1, etc.
    col = file.ord - 'a'.ord

    # for the row, rank 8 is index 0, rank 7 is index 1, etc.
    row = 8 - rank.to_i

    [row, col]
  end
end
