# frozen_string_literal: true

require_relative 'display'

# Represents a player in the chess game.
# Stores the player's name and color, and handles move input through the terminal.
# Includes methods for selecting a piece and destination square, with input validation.
class Player
  attr_accessor :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end

  def select_piece
    input = nil
    loop do
      Display.prompt_move(self)
      Display.enter_square('select')
      input = gets.chomp.downcase
      return input if chess_square?(input)

      Display.invalid_input('please enter a square like "e2".')
    end
    input
  end

  def select_destination
    input = nil
    loop do
      Display.enter_square('destination')
      input = gets.chomp.downcase
      return input if chess_square?(input) || input == 'cancel'

      Display.invalid_input('please enter a valid square or "cancel".')
    end
    input
  end

  def to_s
    @name
  end

  private

  def chess_square?(string)
    # returning a boolean indicating if the string represents a valid chess square
    !!string.match(/^[a-h][1-8]$/)
  end
end
