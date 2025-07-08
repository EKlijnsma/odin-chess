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

  def castles?(from, to)
    if color == :white
      from == [7, 4] && [[7, 2], [7, 6]].include?(to)
    else
      from == [0, 4] && [[0, 2], [0, 6]].include?(to)
    end
  end
end
