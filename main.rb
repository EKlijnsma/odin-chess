require_relative 'lib/game'
require_relative 'lib/board'
require_relative 'lib/player'

emiel = Player.new('Emiel', :white)
renee = Player.new('Renee', :black)
board = Board.new

game = Game.new(board, emiel, renee)

game.play
