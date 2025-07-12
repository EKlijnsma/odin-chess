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
  attr_accessor :state, :en_passant_target, :castling_rights

  def initialize
    @state = Array.new(8) { Array.new(8) }
    @en_passant_target = nil
    @castling_rights = {
      white_kingside: true,
      white_queenside: true,
      black_kingside: true,
      black_queenside: true
    }
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

  # def execute_en_passant(from, to)
  #   pawn = piece_at(from)

  #   # move pawn to new square
  #   @state[to[0]][to[1]] = pawn
  #   # empty starting square
  #   @state[from[0]][from[1]] = nil
  #   # remove enemy pawn (row 3 for black pieces, row 4 for white pieces)
  #   direction = pawn.color == :white ? -1 : 1
  #   captured_row = to[0] - direction
  #   @state[captured_row][to[1]] = nil
  # end

  def update_en_passant_target(pawn, from)
    # if pawn comes from row 1, the en passant target will be on row 2 (black pieces), otherwise it will be on row 5 (white pieces)
    direction = pawn.color == :white ? -1 : 1
    intermediate_row = from[0] + direction
    @en_passant_target = [intermediate_row, from[1]]
  end

  # def execute_castling(from, to)
  #   row = from[0]

  #   if to[1] == 6 # kingside
  #     # Move king
  #     @state[row][6] = @state[row][4]
  #     @state[row][4] = nil
  #     # Move rook
  #     @state[row][5] = @state[row][7]
  #     @state[row][7] = nil

  #   elsif to[1] == 2 # queenside
  #     # Move king
  #     @state[row][2] = @state[row][4]
  #     @state[row][4] = nil
  #     # Move rook
  #     @state[row][3] = @state[row][0]
  #     @state[row][0] = nil
  #   end
  # end

  # def execute_promotion(from, to)
  #   color = piece_at(from).color

  #   input = nil
  #   loop do
  #     puts 'Promote to Queen, Rook, Knight or Bishop? Enter Q, R, K or B'
  #     input = gets.chomp.downcase
  #     break if %w[q r k b].include?(input)

  #     puts 'Invalid input'
  #   end

  #   pieces = { 'q' => Queen, 'r' => Rook, 'k' => Knight, 'b' => Bishop }

  #   @state[to[0]][to[1]] = pieces[input].new(color)
  #   @state[from[0]][from[1]] = nil
  # end

  # def execute_move(from, to)
  #   piece = piece_at(from)

  #   # Handle castling moves
  #   if piece.is_a?(King) && piece.castles?(from, to)
  #     execute_castling(from, to)

  #   # Handle en passant moves
  #   elsif piece.is_a?(Pawn) && @en_passant_target == to
  #     execute_en_passant(from, to)

  #   # Handle pawn promotion
  #   elsif piece.is_a?(Pawn) && [7, 0].include?(to[0])
  #     execute_promotion(from, to)

  #   # Handle standard moves
  #   else
  #     @state[to[0]][to[1]] = piece
  #     @state[from[0]][from[1]] = nil
  #   end

  #   # Update en passant target
  #   if piece.is_a?(Pawn) && (from[0] - to[0]).abs == 2
  #     update_en_passant_target(piece, from)
  #   else
  #     @en_passant_target = nil
  #   end

  #   # Revoke castling rights
  #   update_castling_rights(from) if piece.is_a?(King) || piece.is_a?(Rook)
  # end

  def update_castling_rights(from)
    # Black
    @castling_rights[:black_queenside] = false if from == [0, 0]
    @castling_rights[:black_kingside] = false if from == [0, 7]
    if from == [0, 4]
      @castling_rights[:black_queenside] = false
      @castling_rights[:black_kingside] = false
    end

    # White
    @castling_rights[:white_queenside] = false if from == [7, 0]
    @castling_rights[:white_kingside] = false if from == [7, 7]
    return unless from == [7, 4]

    @castling_rights[:white_queenside] = false
    @castling_rights[:white_kingside] = false
  end

  def pieces(color)
    pieces = []
    @state.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        next if piece.nil? || piece.color != color

        pieces << { piece: piece, row: i, col: j }
      end
    end
    pieces
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

  def clear_board
    @state = Array.new(8) { Array.new(8) }
  end

  def place_piece(piece, square)
    @state[square[0]][square[1]] = piece
  end
end
