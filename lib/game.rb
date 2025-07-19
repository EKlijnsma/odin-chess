# frozen_string_literal: true

require 'json'
require_relative 'player'
require_relative 'board'
require_relative 'display'
require_relative 'move_validator'
require_relative 'move_generator'
require_relative 'move_executor'

# Represents the game class, holding the board and 2 players, keeps track of the current player
# and a history of positions. Contains the game logic like the game play loop, and end-of-game checks
class Game
  attr_accessor :player1, :player2, :board, :current_player

  def initialize(board, player1, player2)
    @board = board
    @player1 = player1
    @player2 = player2
    @current_player = player1
    @position_history = []
  end

  def to_json(*_args)
    JSON.dump({
                board: @board.to_json,
                player1: @player1.to_json,
                player2: @player2.to_json,
                current_player: @current_player.to_json,
                position_history: @position_history.map do |snapshot|
                  snapshot.map do |key, value|
                    if key == :board
                      [key, value.map { |piece| piece.nil? ? nil : piece.to_json }]
                    else
                      [key, value]
                    end
                  end.to_h # convert mapped output back to a hash
                end
              })
  end

  def self.from_json(string)
    data = JSON.parse(string)
    instance = allocate
    instance.instance_variable_set(:@board, Board.from_json(data['board']))
    instance.instance_variable_set(:@player1, Player.from_json(data['player1']))
    instance.instance_variable_set(:@player2, Player.from_json(data['player2']))
    instance.instance_variable_set(:@current_player, Player.from_json(data['current_player']))
    instance.instance_variable_set(:@position_history, rebuild_position_history(data['position_history']))
    instance
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

  # Adds a snapshot of the current position to the history
  def update_position_history
    snapshot = {
      board: @board.state.flatten,
      turn: @current_player,
      castling: @board.castling_rights,
      en_passant: @board.en_passant_target
    }
    @position_history << snapshot
  end

  def save_game
    # Write the JSON string to a file
    File.write('saved_game.json', to_json)
    Display.save
  end

  def terminate
    Display.exit
    exit
  end

  def self.rebuild_position_history(array)
    array.map do |snapshot|
      {
        board: snapshot['board'].map do |piece_data|
          piece_data.nil? ? nil : Board.resolve_piece_class(JSON.parse(piece_data)['type']).from_json(piece_data)
        end,
        turn: Player.from_hash(snapshot['turn']),
        castling: snapshot['castling'].transform_keys(&:to_sym),
        en_passant: snapshot['en_passant']
      }
    end
  end

  def take_turn(player)
    loop do
      # Prompt player input and convert to coordinates
      input = player.prompt_move
      save_game if input == 's'
      terminate if %w[s q].include?(input)
      from = notation_to_coords(input[0])
      to = notation_to_coords(input[1])
      move = [from, to]

      # Prompt again, unless the move is valid for the current player
      next unless MoveValidator.new(@board).valid_move?(move[0], move[1], player.color)

      # Execute the move, update the history and render the new board
      MoveExecutor.new(@board).execute_move(move[0], move[1])
      update_position_history
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
    # Stalemate means there are no legal moves but the king is not in check
    mv = MoveValidator.new(@board)
    !mv.in_check?(player.color) && !mv.legal_moves?(player.color)
  end

  def checkmate?(player)
    # Checkmate means there are no legal moves and the king is in check
    mv = MoveValidator.new(@board)
    mv.in_check?(player.color) && !mv.legal_moves?(player.color)
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

  # Get the white and black bishops, and if only 1 from each color is present
  # check if they are on the same colored squares.
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

  private_class_method :rebuild_position_history
end
