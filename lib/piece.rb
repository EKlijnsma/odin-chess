# frozen_string_literal: true

# Represents a generic piece (parent class) in the chess game.
# Stores a symbol and color, holds movement constraints and does move validation
# based on those constraints.
class Piece
  attr_accessor :color, :symbol

  def initialize(color)
    @color = color
    @symbol = assign_symbol
  end

  def possible_moves
    raise NotImplementedError, 'Subclasses must implement possible_moves'
  end

  # Returns a boolean indicating whether a move is valid based on the pieces'
  # movement constraints.
  def valid_move?(from, to)
    row_delta = to[0] - from[0]
    col_delta = to[1] - from[1]
    possible_moves.include?([row_delta, col_delta])
  end

  def sliding?
    false
  end

  def to_s
    @symbol
  end

  def to_json(*_args)
    JSON.dump({
                type: self.class.to_s,
                symbol: @symbol,
                color: @color.to_s
              })
  end

  def self.from_json(string)
    data = JSON.parse(string)
    instance = allocate
    instance.instance_variable_set(:@color, data['color'].to_sym)
    instance.instance_variable_set(:@symbol, data['symbol'])
    instance
  end

  # Returns the targets the piece can potentially have based on its current position
  # without considering any board context limitations
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
