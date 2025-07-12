# frozen_string_literal: true

require_relative 'player'
require_relative 'board'
require_relative 'display'
require_relative 'move_validator'
require_relative 'move_generator'

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
      @board.render
      Display.declare_check(@current_player) if MoveValidator.new(@board).in_check?(@current_player.color)
      take_turn(@current_player)
      break if game_over?

      switch_players
    end
  end

  private

  def take_turn(player)
    loop do
      input = player.get_move
      from = notation_to_coords(input[0])
      to = notation_to_coords(input[1])
      move = [from, to]
      puts "move = #{move}"
      next unless MoveValidator.new(@board).valid_move?(move[0], move[1], player.color)

      # Execute
      @board.execute_move(move[0], move[1])
      @board.render
      break
    end
  end

  def switch_players
    @current_player = if @current_player == @player1
                        @player2
                      else
                        @player1
                      end
  end

  def game_over?
    next_player = (@current_player == @player1 ? @player2 : @player1)
    if checkmate?(next_player)
      Display.announce_winner(@current_player)
      true
    elsif stalemate?(next_player)
      Display.announce_draw('Stalemate')
      true
    elsif threefold_repetition?
      Display.announce_draw('Repeated positions')
      true
    elsif insufficient_material?
      Display.announce_draw('Insufficient material')
      true
    else
      false
    end
  end

  def stalemate?(player)
    mv = MoveValidator.new(@board)
    !mv.in_check?(player.color) && !mv.has_legal_moves?(player.color)
  end

  def checkmate?(player)
    mv = MoveValidator.new(@board)
    mv.in_check?(player.color) && !mv.has_legal_moves?(player.color)
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
