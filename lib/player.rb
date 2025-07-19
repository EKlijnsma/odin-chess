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

  def prompt_move
    from = select_piece
    return from if %w[s q].include?(from)

    to = select_destination
    return prompt_move if to == 'cancel'
    return to if %w[s q].include?(to)

    [from, to]
  end

  def to_s
    @name
  end

  def to_json(*_args)
    JSON.dump({
                name: @name,
                color: @color.to_s
              })
  end

  def self.from_json(string)
    data = JSON.parse(string)
    instance = allocate
    instance.instance_variable_set(:@name, data['name'])
    instance.instance_variable_set(:@color, data['color'].to_sym)
    instance
  end

  def self.from_hash(hash)
    new(hash['name'], hash['color'].to_sym)
  end

  def game_control
    input = nil
    loop do
      Display.options
      input = gets.chomp.downcase
      return input if %w[s q p].include?(input)

      Display.invalid_input('please enter a valid option')
    end
    input
  end

  private

  def select_piece
    input = nil
    loop do
      Display.prompt_move(self)
      Display.enter_square('select')
      input = gets.chomp.downcase
      return input if chess_square?(input) || %w[s q].include?(input)

      Display.invalid_input('please enter a square like "e2" to select a piece (or S / Q to Save / Quit).')
    end
    input
  end

  def select_destination
    input = nil
    loop do
      Display.enter_square('destination')
      input = gets.chomp.downcase
      return input if chess_square?(input) || input == 'cancel'

      Display.invalid_input('please enter a valid square or "cancel" (or S / Q to Save / Quit).')
    end
    input
  end

  def chess_square?(string)
    # returning a boolean indicating if the string represents a valid chess square
    !!string.match(/^[a-h][1-8]$/)
  end
end
