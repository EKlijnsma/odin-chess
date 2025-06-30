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
end
