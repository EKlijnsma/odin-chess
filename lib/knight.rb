# frozen_string_literal: true

require_relative 'piece'

# Subclass of Piece, represents the knight piece, holding all possible moves
class Knight < Piece
  def assign_symbol
    color == :white ? '♘' : '♞'
  end

  def possible_moves
    [
      [-2, -1], [-2, 1],
      [-1, -2], [-1, 2],
      [1, -2],  [1, 2],
      [2, -1],  [2, 1]
    ]
  end
end
