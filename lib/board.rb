require_relative 'bishop'
require_relative 'board_renderer'
require_relative 'king'
require_relative 'knight'
require_relative 'pawn'
require_relative 'queen'
require_relative 'rook'

class Board
  include BoardRenderer
  attr_accessor :state

  def initialize
    @state = Array.new(8) { Array.new(8) }
    set_up_pieces
  end

  def set_up_pieces
    back_rank = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    back_rank.each_with_index do |piece_class, col|
      @state[0][col] = piece_class.new(:black)
      @state[7][col] = piece_class.new(:white)
    end

    8.times do |col|
      @state[1][col] = Pawn.new(:black)
      @state[6][col] = Pawn.new(:white)
    end
  end

  def piece_at(coords)
    @state[coords[0]][coords[1]]
  end

  def execute_move(from, to)
    # get piece
    piece = @state[from[0]][from[1]]

    # move piece to target
    @state[to[0]][to[1]] = piece

    # empty starting square
    @state[from[0]][from[1]] = nil
  end

  def validate_selection(coords, player)
    piece = piece_at(coords)
    # if nil there is no piece here, otherwise verify that the piece is the same color as the player
    piece.nil? ? false : piece.color == player.color
  end

  def validate_destination(_piece_coords, _destination_coords)
    true
    # TODO
    # Test 1: is the destination a valid movement for the piece? (check the possible moves method for the piece)
    # Test 2: is the destination not occupied by a same color piece?
    # Test 3: is the path not blocked?
    # Test 4: is the move not resulting in a check of the own king?
  end

  # Next steps:
  # 1 - Board rendering (keep it simple, can always make it more fancy later)
  # 2 - Move execution (simply update the board state)
  # 3 - Turn logic in the Game class, prompt for a move, execute move
  # 4 - Game logic or validation logic (similar)
end
