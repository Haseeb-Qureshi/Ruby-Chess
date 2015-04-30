require 'io/console'
require 'colorize'
require 'byebug'
require_relative 'board'
require_relative 'move'
require_relative 'computer'

#ADD PAWN PROMOTION
#REFACTOR EVERYTHING
#CREATE OPENING MENU
#SAVE/LOAD STATES

class Game
  attr_reader :board
  attr_writer :avail_moves

  def initialize
    @board = Board.new
    @players = [:w, :b]
    @captured = []
    @avail_moves = []
    @debug = []
    @cursor = [0, 0]
    @cpu = CPU.new(self, @board, :b)
  end

  def play
    welcome
    render
    until game_over?
      player_move(@players.first)
      @players.rotate!
      render
    end
    game_over_message
  end

  def welcome
    puts "Welcome to chess! White goes first."
  end

  def game_over_message
    winner = @players.last == :w ? "White" : "Black"
    puts "Checkmate! #{winner} won!".colorize(color: :yellow).bold
  end

  def render
    system 'clear'
    screen = []
    @board.rows.each_with_index do |row, num|
      screen << render_row(row, num)
    end
    puts add_indices(screen) + @debug
  end

  def player_move(color)
    return computer_move if @players.first == :b ###CHANGE THIS LATER
    #Move Human or Move Computer
  end

  def reset_render
    sleep(1)
    @avail_moves = []
    render
  end

  def move(from_coords, to_coords) #Board class
    there = @board[*to_coords]
    piece = @board[*from_coords]
    @captured << there if there

    @board[*from_coords] = nil
    @board[*to_coords] = piece
    piece.pos = to_coords

    @avail_moves = []
    piece.moved = true
  end

  def update_cursor(move)
    init_debug                            #Can remove init_debug later
    x, y = @cursor
    dx, dy = move
    @cursor = [x + dx, y + dy]
  end

  def valid_input?(char) #Human class
    charsym = char
    return false unless INPUT.has_key?(charsym)
    x, y = @cursor
    dx, dy = INPUT[charsym]
    (x + dx).between?(0, 7) && (y + dy).between?(0, 7)
  end

  def in_check?(color) #Board class
    all = @board.pieces(Board.opp(color)).inject([]) do |all_moves, piece|
      all_moves + piece.moves
    end

    all.include?(@board.king(color).pos)
  end

  def puts_in_check?(from_coords, to_coords, color) #Board class
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

  def checkmate?(color) #Board class
    @board.pieces(color).all? do |piece|
      piece.moves.all? do |move|
        # piece.moving_into_check?(move)
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

  def all_valid_moves(color) #Board class
    @board.pieces(color).inject([]) do |all, piece|
      all + piece.moves.select { |move| !puts_in_check?(piece.pos, move, color) }.map do |move|
        Move.new(piece.pos, move, piece)
      end
    end.uniq
  end

  def computer_move #Board class
    best_move = @cpu.evaluate_moves
    p best_move
    p @board[*best_move.from]
    p @board[*best_move.to]
    move(best_move.from, best_move.to)
  end

  def save!
    puts "Someday, I'll save your file! You just wait."
  end

  def checkdebug()
    move([6, 5], [5, 5])
    move([1, 4], [3, 4])
    move([6, 6], [4, 6])
    play
  end

  private

  def render_row(row, i)
    this_line = row.inject("").with_index do |line, piece, j|
      here = [i, j]
      line + construct_square(here)
    end
    this_line << captured_pieces(:w) if i == 0
    this_line << captured_pieces(:b).colorize(color: :blue) if i == 7
    this_line << "   Check!" if i == 4 && @players.any? { |c| in_check?(c) }
  end

  def captured_pieces(color)
    line = @captured.select { |piece| piece.color == color }
    "  " + line.join(" ")
  end

  def construct_square(here)
    background = here.inject(:+).even? ? :light_red : :light_cyan
    piece_img = piece ? piece.to_s : " "
    square = " #{render_piece}  ".colorize(background: background)


    if @avail_moves.include?(here)
       square = square.colorize(background: :light_green)
     end
    if here == @cursor
      square = square.colorize(background: :yellow)
    end
  end

  def add_indices(rendered)
    rendered.map!.with_index do |line, i|
      " #{8 - i} " + line
    end
    letters = ('a'..'h').to_a.map { |l| " #{l} " }
    rendered << "   " + letters.join
  end

  def init_debug
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
      str += "Checkmate-W: #{checkmate?(:w)} \nCheckmate-B?: #{checkmate?(:b)}\n"
      str += "All valid moves (#{@players.first}): #{all_valid_moves(@players.first)}"
    end
    @debug << str
  end
end

if __FILE__ == $0
  Game.new.play
end
