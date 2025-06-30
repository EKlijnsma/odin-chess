# frozen_string_literal: true

module BoardRenderer
  def render
    clear_screen
    print_bar
    @state.each_with_index do |rank, i|
      print_row(rank, i)
      print_bar
    end
    print_file_labels(%w[A B C D E F G H])
  end

  private

  def clear_screen
    # clears the console on a UNIX system
    puts `clear`
  end

  def print_row(rank, i)
    # print the rank label and the contents of each square (either the piece or nothing)
    string = "#{8 - i} |"
    rank.each do |piece|
      string += piece.nil? ? '   |' : " #{piece} |"
    end
    puts string
  end

  def print_file_labels(files)
    string = '  '
    files.each do |file|
      string += "  #{file} "
    end
    puts string
  end

  def print_bar
    puts "  #{'+---' * 8}+"
  end
end
