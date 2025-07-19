# frozen_string_literal: true

require_relative 'piece'

# Subclass of Piece, represents the queen piece, holding all possible moves and acts as sliding piece
class Queen < Piece
  def assign_symbol
    color == :white ? '♕' : '♛'
  end

  def possible_moves # rubocop:disable Metrics/MethodLength
    moves = []
    (1..7).each do |i|
      moves << [0, i]
      moves << [0, -i]
      moves << [i, 0]
      moves << [-i, 0]
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
