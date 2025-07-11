# frozen_string_literal: true

# The Display module handles all output messages shown to the player.
# It provides methods for announcing game results, prompting for input,
# and notifying players of game state changes (e.g., check or invalid input).
module Display
  def self.announce_winner(winner)
    puts "\nCheckmate! #{winner.name} wins the game!"
  end

  def self.announce_draw(reason)
    puts "\nThe game is a draw. (#{reason})"
  end

  def self.prompt_move(player)
    puts "#{player}'s turn: "
  end

  def self.enter_square(reason)
    case reason
    when 'select'
      puts 'Select one of your pieces by entering its square (e.g. "e2"):'
    when 'destination'
      puts 'Select a destination square (e.g. "e4"), or type "cancel" to select a different piece:'
    end
  end

  def self.declare_check(player)
    puts "#{player} is in check!"
  end

  def self.invalid_input(message)
    puts "❌ #{message}"
  end
end
