# frozen_string_literal: true

require_relative 'piece'

# Subclass of Piece, represents the bishop piece, holding all possible moves and acts as sliding piece
class Bishop < Piece
  def assign_symbol
    color == :white ? '♗' : '♝'
  end

  def possible_moves
    moves = []
    (1..7).each do |i|
      moves << [i, i]
      moves << [i, -i]
      moves << [-i, i]
      moves << [-i, -i]
    end
    moves
  end

  def sliding?
    true
  end
end
