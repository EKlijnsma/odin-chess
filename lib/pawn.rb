# frozen_string_literal: true

require_relative 'piece'

class Pawn < Piece
  def assign_symbol
    color == :white ? '♙' : '♟'
  end

  def possible_moves
    # white pawns move up the board (is negative in the board array)
    # black pawns move down the board (is positive in the board array)
    direction = color == :white ? -1 : 1
    single = 1 * direction
    double = 2 * direction

    [
      [single, 0], [double, 0],
      [single, 1], [single, -1]
    ]
  end
end
