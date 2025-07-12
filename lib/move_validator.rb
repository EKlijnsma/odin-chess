# frozen_string_literal: true

require_relative 'display'
require_relative 'move_generator'
require_relative 'move_executor'

class MoveValidator
  attr_accessor :board

  def initialize(board)
    @board = board
  end

  def valid_move?(from, to, color)
    if !valid_selection?(from, color)
      Display.invalid_input("You don't have a piece to move in that position")
      return false
    elsif !valid_destination?(from, to)
      Display.invalid_input("You can't move that piece to that position")
      return false
    end
    true
  end

  def clear_path?(from, to)
    # Leverage spaceship operator to get -1, 0 or +1 values to user as directions/vectors
    vector = [to[0] <=> from[0], to[1] <=> from[1]]

    position = from
    loop do
      position = [position[0] + vector[0], position[1] + vector[1]]
      break if position == to
      return false unless @board.piece_at(position).nil?
    end
    true
  end

  def in_check?(color, board = @board)
    enemy_color = (color == :white ? :black : :white)
    king_position = board.find_king(color)

    MoveGenerator.new(board).all_targets(enemy_color).include?(king_position)
  end

  def has_legal_moves?(color)
    moves = MoveGenerator.new(@board).all_moves(color)
    moves.each do |move|
      return true if valid_destination?(move[0], move[1])
    end
    false
  end

  private

  def valid_selection?(coords, color)
    piece = @board.piece_at(coords)
    # if nil there is no piece here, otherwise verify that the piece is the same color as the player
    if piece.nil? || piece.color != color
      false
    else
      true
    end
  end

  def valid_destination?(from, to)
    piece = @board.piece_at(from)

    return valid_pawn_move?(piece, from, to) if piece.is_a?(Pawn)
    return valid_castle?(from, to, piece) if piece.is_a?(King) && piece.castles?(from, to)

    return false unless piece.targets(from).include?(to)
    return false if friendly_fire?(from, to)
    return false if piece.sliding? && !clear_path?(from, to)

    return false if results_in_check?(from, to)

    true
  end

  def valid_pawn_move?(moving_piece, from, to)
    target_piece = @board.piece_at(to)

    # Forward move
    if from[1] == to[1]
      return false unless target_piece.nil? && clear_path?(from, to)
    elsif @board.en_passant_target == to
    # Diagonal move
    # ok for now, but cant return true before the results_in_check? validation
    elsif target_piece.nil? || target_piece.color == moving_piece.color
      return false
    end
    # For all moves: not valid if resulting in check
    return false if results_in_check?(from, to)

    true
  end

  def valid_castle?(from, to, piece)
    castle_data = {
      [7, 2] => { rook_pos: [7, 0], skipped_square: [7, 3], rights: :white_queenside },
      [7, 6] => { rook_pos: [7, 7], skipped_square: [7, 5], rights: :white_kingside },
      [0, 2] => { rook_pos: [0, 0], skipped_square: [0, 3], rights: :black_queenside },
      [0, 6] => { rook_pos: [0, 7], skipped_square: [0, 5], rights: :black_kingside }
    }

    data = castle_data[to]
    return false unless data

    return false unless @board.castling_rights[data[:rights]] # If no longer has castling rights
    return false if in_check?(piece.color) # If currently in check
    return false unless clear_path?(from, data[:rook_pos]) # If pieces are still between king and rook
    return false if results_in_check?(from, data[:skipped_square]) # If passing through check
    return false if results_in_check?(from, to) # If ending up in check

    # If all the above passes, its a valid castling move
    true
  end

  def friendly_fire?(from, to)
    moving_piece = @board.piece_at(from)
    target_piece = @board.piece_at(to)

    target_piece.nil? ? false : moving_piece.color == target_piece.color
  end

  def results_in_check?(from, to)
    # Execute the move on a cloned board and evaluate if the king is in check
    color = @board.piece_at(from).color
    test_board = @board.deep_clone
    MoveExecutor.new(test_board).execute_move(from, to)
    in_check?(color, test_board)
  end
end
