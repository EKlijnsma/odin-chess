# frozen_string_literal: true

require_relative 'lib/game'
require_relative 'lib/display'
require_relative 'lib/board'
require_relative 'lib/player'

white = Player.new('White', :white)
black = Player.new('Black', :black)
board = Board.new

input = nil
loop do
  Display.start
  input = gets.chomp.downcase
  break if %w[n l].include?(input)

  Display.invalid_input('please enter a valid option')
end

if input == 'n'
  game = Game.new(board, white, black)
else
  game = Game.from_json(File.read('saved_game.json'))
end

game.play
