class Player
  attr_accessor :name, :color

  def initialize(name, color)
    self.name = name
    self.color = color
  end

  def select_piece
    puts 'Select one of your pieces by entering its square (e.g. "e2"):'
    gets.chomp
  end

  def select_destination
    puts 'Select a destination square (e.g. "e4"), or type "cancel" to select a different piece:'
    gets.chomp
  end
end
