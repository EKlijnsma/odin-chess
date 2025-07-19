# frozen_string_literal: true

require_relative 'piece'

# Subclass of Piece, represents the king piece, holding all possible regular moves
# and has castle checking method
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

  # Returns a boolean indicating whether the move is a castling move or not
  def castles?(from, to)
    if color == :white
      from == [7, 4] && [[7, 2], [7, 6]].include?(to)
    else
      from == [0, 4] && [[0, 2], [0, 6]].include?(to)
    end
  end
end
