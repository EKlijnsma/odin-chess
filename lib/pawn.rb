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

  def targets(position)
    targets = []
    possible_moves.each do |vector|
      next if vector[1].zero?

      row = vector[0] + position[0]
      col = vector[1] + position[1]
      next unless row.between?(0, 7) && col.between?(0, 7)

      targets << [row, col]
    end
    targets
  end
end
