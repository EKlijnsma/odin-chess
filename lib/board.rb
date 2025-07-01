# frozen_string_literal: true

require_relative 'bishop'
require_relative 'board_renderer'
require_relative 'king'
require_relative 'knight'
require_relative 'pawn'
require_relative 'queen'
require_relative 'rook'

class Board
  include BoardRenderer
  attr_accessor :state

  def initialize
    @state = Array.new(8) { Array.new(8) }
    set_up_pieces
  end

  def set_up_pieces
    back_rank = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    back_rank.each_with_index do |piece_class, col|
      @state[0][col] = piece_class.new(:black)
      @state[7][col] = piece_class.new(:white)
    end

    8.times do |col|
      @state[1][col] = Pawn.new(:black)
      @state[6][col] = Pawn.new(:white)
    end
  end

  def piece_at(coords)
    @state[coords[0]][coords[1]]
  end

  def execute_move(from, to)
    # get piece
    piece = @state[from[0]][from[1]]

    # move piece to target
    @state[to[0]][to[1]] = piece

    # empty starting square
    @state[from[0]][from[1]] = nil
  end

  def validate_selection(coords, player)
    piece = piece_at(coords)
    # if nil there is no piece here, otherwise verify that the piece is the same color as the player
    piece.nil? ? false : piece.color == player.color
  end

  def validate_destination(piece_coords, destination_coords)
    # Test 1: is the destination a valid movement for the piece? (check the possible moves method for the piece)
    condition1 = piece_at(piece_coords).valid_move?(piece_coords, destination_coords)

    # Test 2: is the destination not occupied by a same color piece?
    condition2 = !friendly_fire?(piece_coords, destination_coords)

    # Test 3: is the path not blocked?
    condition3 = clear_path?(piece_coords, destination_coords)

    # Test 4: is the move not resulting in a check of the own king?
    condition4 = results_in_check?(from, to)

    # Test 5: when en passant, is it allowed?
    # TODO

    # Test 6: when castling, is it allowed?
    # TODO

    condition1 && condition2 && condition3
  end

  def results_in_check?(from, to)
    # Clone the board
    clone = deep_clone

    # execute the move
    clone.execute_move(from, to)

    # king in check?
    color = piece_at(from).color
    clone.in_check?(color)
  end

  def in_check?(color)
    target = find_king(color)
    opposing_color = color == :white ? :black : :white
    # Find all targets for the opposing color
    all_targets = get_all_targets(color)

    # check if the kings square is in the all targets array
    # account for blocking pieces
    # TODO
  end

  def get_all_targets(color)
    all_targets = []
    @state.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        next if piece.nil? || piece.color != color

        targets = piece.targets([i, j])
        # check blockades for sliding pieces. May want to give pieces an @sliding attribute
        # which can be used to determine which validations need to be done
        # TODO
      end
    end
    all_targets
  end

  def find_king(color)
    @state.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        return [i, j] if piece.instance_of?(King) && piece.color == color
      end
    end
    nil
  end

  def deep_clone
    Marshal.load(Marshal.dump(self))
  end

  def friendly_fire?(piece_coords, destination_coords)
    moving_piece = piece_at(piece_coords)
    target_piece = piece_at(destination_coords)

    target_piece.nil? ? false : moving_piece.color == target_piece.color
  end

  def clear_path?(from, to)
    # Leverage spaceship operator to get -1, 0 or +1 values to user as directions/vectors
    vector = [to[0] <=> from[0], to[1] <=> from[1]]

    position = from
    loop do
      position = [position[0] + vector[0], position[1] + vector[1]]
      break if position == to
      return false unless piece_at(position).nil?
    end
    true
  end

  def clear_board
    @state = Array.new(8) { Array.new(8) }
  end
end
