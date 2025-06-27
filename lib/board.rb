require_relative 'lib/rook'
require_relative 'lib/knight'
require_relative 'lib/bishop'
require_relative 'lib/king'
require_relative 'lib/queen'
require_relative 'lib/pawn'

class Board
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

  def validate_selection(piece, player)
    # TODO
  end

  def validate_destination(piece, destination)
    # TODO
  end
end
