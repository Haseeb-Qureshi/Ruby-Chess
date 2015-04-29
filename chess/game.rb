require_relative 'board'
require 'colorize'
require 'byebug'

# CHECK_MATE?
# CREATE AN ARRAY OF ALL CAPTURES FOR EACH PLAYER

class Game
  INPUT = {
    "w" => [-1, 0],
    "a" => [0, -1],
    "s" => [1, 0],
    "d" => [0, 1],
    "\r" => [0, 0]
    }

  def initialize
    @board = Board.new
    @players = [:w, :b]
    @captured = []
    @cursor = [0, 0]
    @avail_moves = []
    @debug = []
  end

  def debug
    @debug = []
    piece = @board[*@cursor]
    str = ''
    if piece
      str += "Type: #{piece.class} \n"
      str += "Color: #{piece.color} \n"
      str += "Pos : #{piece.pos} \n"
      str += "Moves: #{piece.moves} \n"
      str += "Moved?: #{piece.moved} \n"
      str += "X_dir: #{piece.x_dir}" if piece.is_a?(Pawn)
      str += "Diffmap: #{piece.moves_debug_diffsmap} \n" if piece.is_a?(Knight)
      str += "Select_valids: #{piece.moves_debug_select}" if piece.is_a?(Knight)
    end
    @debug << str
  end

  def play
    welcome
    puts render_game
    until game_over?
      player_move(@players.first)
      @players = @players.rotate(1)
      puts render_game
    end
  end

  def welcome
    puts "Welcome to chess! White goes first."
  end

  def render_game
    sleep(0.3)
    system 'clear'
    rendered = []
    @board.rows.each_with_index do |row, i|
      this_line = ""

      row.each_with_index do |piece, j|
        render_piece = piece ? piece.to_s : " "
        bg = (i + j).even? ? :light_red : :light_cyan
        square = " #{render_piece} ".colorize(background: bg)
        square = square.swap if [i, j] == @cursor #swap
        square = square.colorize(background: :yellow) if
                            @avail_moves.include?([i, j])
        this_line += square
      end
      this_line << captured(:w) if i == 0
      this_line << captured(:b) if i == 7
      rendered << this_line
    end
    add_indices(rendered) + @debug # REMOVE DEBUG LATER
  end

  def captured(color)
    line = @captured.select { |piece| piece.color == color }
    "  " + line.join(" ")
  end

  def player_move(color)
    from_coords = move_from(color)
    piece = @board[*from_coords]

    puts "Where do you want to move?"
    to_coords = move_to(color)
    move(from_coords, to_coords)
  rescue ArgumentError
    puts "Invalid selection. Try again."
    puts render_game
    retry
  rescue UnableError
    puts "You can't do that."
    puts render_game
    retry
  end

  def move(from_coords, to_coords)
    there = @board[*to_coords]
    piece = @board[*from_coords]
    @captured << there if there

    @board[*from_coords] = nil
    @board[*to_coords] = piece
    piece.pos = to_coords

    @avail_moves = []
    piece.moved = true
  end

  def move_from(my_color)
    loop do
      puts "Use W-A-S-D to navigate to a piece. Press enter to select."
      valid_key = false
      until valid_key
        key = $stdin.getch.downcase
        valid_key = true if valid_input?(key)
      end

      update_cursor(key)
      piece = @board[*@cursor]
      if piece && piece.color == my_color
        @avail_moves = piece.moves
      else
        @avail_moves = []
      end
      puts render_game

      if key == "\r"
        raise ArgumentError unless piece && piece.color == my_color
        raise UnableError if piece.moves.empty?
        break
      end
    end
    @cursor.dup
  end

  def move_to(color)
    loop do
      puts "Use W-A-S-D to navigate. Press enter to select your move."
      valid_key = false
      until valid_key
        key = $stdin.getch.downcase
        valid_key = true if valid_input?(key)
      end

      update_cursor(key)
      puts render_game
      if key == "\r"
        piece = @board[*@cursor]
        raise UnableError if !@avail_moves.include?(@cursor)
        break
      end
    end
    @cursor.dup
  end

  def update_cursor(key)
    x, y = @cursor
    dx, dy = INPUT[key]
    @cursor = [x + dx, y + dy]
                            debug # REMOVE LATER
  end

  def valid_input?(char)
    charsym = char
    return false unless INPUT.has_key?(charsym)
    x, y = @cursor
    dx, dy = INPUT[charsym]
    (x + dx).between?(0, 7) && (y + dy).between?(0, 7)
  end

  def in_check?(from_coords, to_coords,color)
    there = @board[*to_coords]
    piece = @board[*from_coords]
    @board[*from_coords] = nil
    @board[*to_coords] = piece

    check = false
    @board.rows.each do |row|
      row.each do |piece|
        next if piece.nil? || piece.color == color
        check = true if piece.valid_moves.include?(king_coords(color))
      end
    end

    @board[*to_coords] = there
    @board[*from_coords] = piece
    check
  end

  def game_over?
    false
  end

  def king_coords(color)
    @board.rows.each_with_index do |row, x|
      rows.each_with_index do |piece, y|
        if piece && piece.color == color && piece.is_a?(King)
          return [x, y]
        end
      end
    end
  end

  def invalid_move?(from_coords, to_coords)
    !@board[*from_coords].moves.include?(to_coords)
  end

  def add_indices(rendered)
    rendered.map!.with_index do |line, i|
      " #{8 - i} " + line
    end
    letters = ('a'..'h').to_a.map { |l| " #{l} " }
    rendered << "   " + letters.join
  end



end

class UnableError < StandardError
end

class InvalidError < StandardError
end

class CheckError < StandardError
end

if __FILE__ == $0
  Game.new.play
end
