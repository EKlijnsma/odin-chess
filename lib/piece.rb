# frozen_string_literal: true

class Piece
  attr_accessor :color, :symbol

  def initialize(color)
    @color = color
    @symbol = assign_symbol
  end

  def possible_moves
    raise NotImplementedError, 'Subclasses must implement possible_moves'
  end

  def to_s
    @symbol
  end

  def valid_move?(piece_coords, destination_coords)
    row_delta = destination_coords[0] - piece_coords[0]
    col_delta = destination_coords[1] - piece_coords[1]
    possible_moves.include?([row_delta, col_delta])
  end

  def targets(position)
    targets = []
    possible_moves.each do |vector|
      row = vector[0] + position[0]
      col = vector[1] + position[1]
      next unless row.between?(0, 7) && col.between?(0, 7)

      targets << [row, col]
    end
    targets
  end
end
