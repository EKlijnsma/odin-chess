# frozen_string_literal: true

require_relative 'lib/game'
require_relative 'lib/board'
require_relative 'lib/player'

emiel = Player.new('White', :white)
renee = Player.new('Black', :black)
board = Board.new

game = Game.new(board, emiel, renee)

game.play
