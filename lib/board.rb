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
    @en_passant_target = nil
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

    # If the piece is a pawn:
    if piece.is_a?(Pawn)
      # If the 'to' square equals the @en_pasasnt_target, an en passant capture is being made
      # if move was 2 squares? set @en_passant_target to the passed over square
      # else set @en_passant_target to nil
    else

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

  def validate_pawn_move(from, to)
    moving_piece = piece_at(from)
    target_piece = piece_at(to)

    # Forward move
    if from[1] == to[1] 
      return false unless target_piece.nil? && clear_path?(from, to)
    else
      # Diagonal move
      if @en_passant_target == to
        # ok for now, but cant return true before the results_in_check? validation
      else
        return false if target_piece.nil? || target_piece.color == moving_piece.color
      end
    end
    # For all moves: not valid if resulting in check
    return false if results_in_check?(from, to)

    true
  end

  def validate_destination(from, to)
    piece = piece_at(from)

    return false if piece.nil?
    return validate_pawn_move(from, to) if piece.is_a?(Pawn)
    
    return false unless piece.targets(from).include?(to)
    return false if friendly_fire?(from, to)
    return false if piece.sliding? && !clear_path?(from, to)
    # return false if illegal castling
    
    return false if results_in_check?(from, to)

    true
  end

  def results_in_check?(from, to)
    # Execute the move on a cloned board and evaluate if the king is in check
    clone = deep_clone
    clone.execute_move(from, to)
    color = piece_at(from).color
    clone.in_check?(color)
  end

  def in_check?(color)
    king_position = find_king(color)
    enemy_color = (color == :white ? :black : :white)
    get_all_targets(enemy_color).include?(king_position)
  end

  def get_all_targets(color)
    all_targets = []
    @state.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        next if piece.nil? || piece.color != color

        piece.targets([i, j]).each do |target|
          all_targets << target unless piece.sliding? && !clear_path?([i, j], target)
        end
      end
    end
    all_targets
  end

  def get_all_moves(color)
    all_moves = []
    @state.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        next if piece.nil? || piece.color != color

        piece.targets([i, j]).each do |target|
          all_moves << [[i, j], target] unless piece.sliding? && !clear_path?([i, j], target)
        end
      end
    end
    all_moves
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

  def place_piece(piece, square)
    @state[square[0]][square[1]] = piece
  end
end
