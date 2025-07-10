# frozen_string_literal: true

require_relative 'player'
require_relative 'board'

class Game
  attr_accessor :player1, :player2, :board, :current_player

  def initialize(board, player1, player2)
    @board = board
    @player1 = player1
    @player2 = player2
    @current_player = player1
    @position_history = []
  end

  def update_position_history
    snapshot = {
      board: @board.state.flatten,
      turn: @current_player,
      castling: @board.castling_rights,
      en_passant: @board.en_passant_target
    }
    @position_history << snapshot
  end

    
  def play
    loop do
      take_turn(@current_player)
      break if game_over?

      switch_players
    end
    announce_result
  end

  def take_turn(player)
    @board.render
    puts "#{player}'s turn"
    move = get_move(player)
    @board.execute_move(move[0], move[1])
    @board.render
  end

  def announce_result
    # TODO: -> winner if checkmate, else draw
  end

  def switch_players
    @current_player = if @current_player == player1
                        player2
                      else
                        player1
                      end
  end

  def game_over?
    next_player = (@current_player == @player1 ? @player2 : @player1)

    checkmate?(next_player) || stalemate?(next_player) || threefold_repetition? || insufficient_material?
  end

  def stalemate?(player)
    !@board.in_check?(player.color) && !has_legal_moves?(player)
  end

  def checkmate?(player)
    @board.in_check?(player.color) && !has_legal_moves?(player)
  end

  def threefold_repetition?
    # Take the latest position snapshot and see if it has occured 3 times or more
    current = @position_history[-1]
    @position_history.count(current) >= 3
  end

  def insufficient_material?
    # Fetch all white and black pieces
    white_pieces = @board.pieces(:white)
    black_pieces = @board.pieces(:black)
    all_pieces = white_pieces + black_pieces

    # King vs King is a draw
    return true if all_pieces.size == 2

    # King vs King + Bishop or vs King + Knight is a draw
    bishops = all_pieces.filter { |p| p[:piece].is_a?(Bishop) }
    knights = all_pieces.filter { |p| p[:piece].is_a?(Knight) }
    
    return true if all_pieces.size == 3 && (bishops + knights).size == 1

    # The only other case for a draw if is Kings vs same squared Bishops (light or dark squares)
    return true if all_pieces.size == 4 && same_colored_bishops?(white_pieces, black_pieces)

    false
  end

  def same_colored_bishops?(white, black)
    white_bishops = white.filter { |p| p[:piece].is_a?(Bishop) }
    black_bishops = black.filter { |p| p[:piece].is_a?(Bishop) }
  
    if white_bishops.size == 1 && black_bishops.size == 1
      same_color = (white_bishops[0][:row] + white_bishops[0][:col]) % 2 ==
                   (black_bishops[0][:row] + black_bishops[0][:col]) % 2
      return true if same_color
    end
    false
  end

  def has_legal_moves?(player)
    moves = @board.get_all_moves(player.color)
    moves.each do |move|
      return true if @board.validate_destination(move[0], move[1])
    end
    false
  end

  def get_move(player)
    piece_coords = select_valid_piece(player)
    destination_coords = select_valid_destination(player, piece_coords)
    [piece_coords, destination_coords]
  end

  def select_valid_piece(player)
    loop do
      input = player.select_piece
      coords = notation_to_coords(input)
      return coords if @board.validate_selection(coords, player)

      puts 'Invalid piece selection, try again.'
    end
  end

  def select_valid_destination(player, piece_coords)
    loop do
      input = player.select_destination
      return get_move(player) if input == 'cancel'

      coords = notation_to_coords(input)
      return coords if @board.validate_destination(piece_coords, coords)

      puts 'Invalid destination, try again or type "cancel" to select a different piece.'
    end
  end

  def notation_to_coords(notation)
    file = notation[0]
    rank = notation[1]

    # for the column, use the integer ordinal to determine the index, a = 0, b = 1, etc.
    col = file.ord - 'a'.ord

    # for the row, rank 8 is index 0, rank 7 is index 1, etc.
    row = 8 - rank.to_i

    [row, col]
  end
end
