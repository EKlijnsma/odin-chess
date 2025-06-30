# frozen_string_literal: true

require_relative 'piece'

class King < Piece
  def assign_symbol
    color == :white ? '♔' : '♚'
  end

  def possible_moves
    [
      [-1, -1], [-1, 0], [-1, 1], [0, 1],
      [1, 1], [1, 0], [1, -1], [0, -1]
    ]
  end
end
