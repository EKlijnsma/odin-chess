# frozen_string_literal: true

require_relative 'display'
require_relative 'move_generator'

# Contains logic concerning move execution on the board
class MoveExecutor
  attr_accessor :board

  def initialize(board)
    @board = board
  end

  def execute_move(from, to, simulate: false)
    piece = @board.piece_at(from)

    # Handle castling moves
    if piece.is_a?(King) && piece.castles?(from, to)
      execute_castling(from, to)

    # Handle en passant moves
    elsif piece.is_a?(Pawn) && @board.en_passant_target == to
      execute_en_passant(from, to)

    # Handle pawn promotion
    elsif piece.is_a?(Pawn) && [7, 0].include?(to[0])
      execute_promotion(from, to, simulate)

    # Handle standard moves
    else
      @board.state[to[0]][to[1]] = piece
      @board.state[from[0]][from[1]] = nil
    end

    # Update en passant target
    if piece.is_a?(Pawn) && (from[0] - to[0]).abs == 2
      @board.update_en_passant_target(piece, from)
    else
      @board.en_passant_target = nil
    end

    # Revoke castling rights
    @board.update_castling_rights(from) if piece.is_a?(King) || piece.is_a?(Rook)
  end

  private

  def execute_castling(from, to)
    row = from[0]

    if to[1] == 6 # kingside
      # Move king
      @board.state[row][6] = @board.state[row][4]
      @board.state[row][4] = nil
      # Move rook
      @board.state[row][5] = @board.state[row][7]
      @board.state[row][7] = nil

    elsif to[1] == 2 # queenside
      # Move king
      @board.state[row][2] = @board.state[row][4]
      @board.state[row][4] = nil
      # Move rook
      @board.state[row][3] = @board.state[row][0]
      @board.state[row][0] = nil
    end
  end

  def execute_promotion(from, to, simulate = false)
    return if simulate

    color = @board.piece_at(from).color

    input = nil
    loop do
      Display.promotion
      input = gets.chomp.downcase
      break if %w[q r k b].include?(input)

      Display.invalid_input('Invalid input')
    end

    pieces = { 'q' => Queen, 'r' => Rook, 'k' => Knight, 'b' => Bishop }

    @board.state[to[0]][to[1]] = pieces[input].new(color)
    @board.state[from[0]][from[1]] = nil
  end

  def execute_en_passant(from, to)
    pawn = @board.piece_at(from)

    # move pawn to new square
    @board.state[to[0]][to[1]] = pawn
    # empty starting square
    @board.state[from[0]][from[1]] = nil
    # remove enemy pawn (row 3 for black pieces, row 4 for white pieces)
    direction = pawn.color == :white ? -1 : 1
    captured_row = to[0] - direction
    @board.state[captured_row][to[1]] = nil
  end
end
