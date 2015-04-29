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
      str += "\n\nWhite in check?: #{in_check?(:w)}\nBlack in check?: #{in_check?(:b)}\n"
      str += "Checkmate-W: #{checkmate?(:w)} \nCheckmate-B?: #{checkmate?(:b)}"
    end
    #@debug << str
  end

  def play
    welcome
    puts render_game
    until game_over?
      player_move(@players.first)
      @players = @players.rotate(1)
      puts render_game
    end
    game_over_message
  end

  def welcome
    puts "Welcome to chess! White goes first."
  end

  def game_over_message
    winner = @players.last == :w ? "White" : "Black"
    puts "#{winner} won the game!".colorize(color: :yellow).bold
  end

  def render_game
    sleep(0.1)
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
      this_line << captured(:b).colorize(color: :blue) if i == 7
      this_line << "   Check!" if i == 4 && @players.any?{ |c| in_check?(c) }
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
    raise CheckError if puts_in_check?(from_coords, to_coords, color)

    move(from_coords, to_coords)
  rescue ArgumentError
    puts "Invalid selection. Try again."
    sleep(1)
    reset_render
    retry
  rescue UnableError
    puts "You can't do that."
    sleep(1)
    reset_render
    retry
  rescue CheckError
    puts "That move would put you in check."
    sleep(1)
    reset_render
    retry
  end

  def reset_render
    @avail_moves = []
    puts render_game
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

  def in_check?(color)
    all = @board.pieces(opp(color)).inject([]) do |all_moves, piece|
      all_moves + piece.moves
    end

    all.include?(@board.king(color).pos)
  end

  def puts_in_check?(from_coords, to_coords, color)
    there = @board[*to_coords]
    piece = @board[*from_coords]
    @board[*from_coords] = nil
    @board[*to_coords] = piece
    piece.pos = to_coords

    check = in_check?(color)

    @board[*to_coords] = there
    @board[*from_coords] = piece
    piece.pos = from_coords

    check
  end

  def opp(color)
    color == :w ? :b : :w
  end

  def checkmate?(color)
    @board.pieces(color).all? do |piece|
      piece.moves.all? do |move|
        puts_in_check?(piece.pos, move, color)
      end
    end
  end

  def game_over?
    checkmate?(@players.first)
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

  def checkdebug()
    move([6, 5], [5, 5])
    move([1, 4], [3, 4])
    move([6, 6], [4, 6])
    play
  end

  # def all_valid_moves(color)
  #   @board.pieces(color).inject
  #
  #   end
  # end


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
