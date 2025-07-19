# frozen_string_literal: true

require_relative 'display'

# Contains logic concerning the generation of movement on the board
class MoveGenerator
  attr_accessor :board

  def initialize(board)
    @board = board
  end

  def all_moves(color)
    mv = MoveValidator.new(@board)
    all_moves = []
    @board.state.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        next if piece.nil? || piece.color != color

        piece.targets([i, j]).each do |target|
          all_moves << [[i, j], target] unless piece.sliding? && !mv.clear_path?([i, j], target)
        end
      end
    end
    all_moves
  end

  def all_targets(color)
    all_moves = all_moves(color)
    targets = []

    all_moves.each do |move|
      targets << move[1]
    end

    targets
  end
end
