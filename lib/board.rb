# frozen_string_literal: true

require_relative 'bishop'
require_relative 'board_renderer'
require_relative 'king'
require_relative 'knight'
require_relative 'pawn'
require_relative 'queen'
require_relative 'rook'

# Represents the board, holding a state, which is a 2D array representing the squares
# and keeps track of en passant opportunities and castling rights. Has methods returning the
# position of the king of a given color, or all pieces from a given color, etc.
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

  def piece_at(coords)
    @state[coords[0]][coords[1]]
  end

  def update_en_passant_target(pawn, from)
    # if pawn comes from row 1, the en passant target will be on row 2 (black pieces), otherwise it will be on row 5 (white pieces)
    direction = pawn.color == :white ? -1 : 1
    intermediate_row = from[0] + direction
    @en_passant_target = [intermediate_row, from[1]]
  end

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

  def place_piece(piece, square)
    @state[square[0]][square[1]] = piece
  end

  def to_json(*_args)
    JSON.dump({
                state: @state.map { |row| row.map { |piece| piece&.to_json } },
                en_passant_target: @en_passant_target,
                castling_rights: @castling_rights
              })
  end

  def self.from_json(string)
    data = JSON.parse(string)
    instance = allocate
    instance.instance_variable_set(:@en_passant_target, data['en_passant_target'])
    instance.instance_variable_set(:@castling_rights, rebuild_castling_rights(data['castling_rights']))
    instance.instance_variable_set(:@state, data['state'].map do |row|
      row.map do |piece_data|
        next if piece_data.nil?

        parsed_piece = JSON.parse(piece_data)
        resolve_piece_class(parsed_piece['type']).from_json(piece_data)
      end
    end)

    instance
  end

  def self.resolve_piece_class(type_string)
    mapping = {
      'Rook' => Rook,
      'Bishop' => Bishop,
      'Knight' => Knight,
      'King' => King,
      'Queen' => Queen,
      'Pawn' => Pawn
    }

    mapping[type_string]
  end

  private

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

  def clear_board
    @state = Array.new(8) { Array.new(8) }
  end

  def self.rebuild_castling_rights(data)
    { white_kingside: data['white_kingside'],
      white_queenside: data['white_queenside'],
      black_kingside: data['black_kingside'],
      black_queenside: data['black_queenside'] }
  end

  private_class_method :rebuild_castling_rights
end
