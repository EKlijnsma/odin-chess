# frozen_string_literal: true

class Player
  attr_accessor :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end

  def select_piece
    input = nil
    loop do
      puts 'Select one of your pieces by entering its square (e.g. "e2"):'
      input = gets.chomp.downcase
      return input if chess_square?(input)

      puts 'Invalid input, please enter a square like "e2".'
    end
  end

  def select_destination
    input = nil
    loop do
      puts 'Select a destination square (e.g. "e4"), or type "cancel" to select a different piece:'
      input = gets.chomp.downcase
      return input if chess_square?(input) || input == 'cancel'

      puts 'Invalid input, please enter a valid square or "cancel".'
    end
  end

  def chess_square?(string)
    # returning a boolean indicating if the string represents a valid chess square
    !!string.match(/^[a-h][1-8]$/)
  end

  def to_s
    @name
  end
end
