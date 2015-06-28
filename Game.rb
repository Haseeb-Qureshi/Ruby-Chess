require 'io/console'
require 'colorize'
require 'byebug'
require 'yaml'
require_relative 'board'
require_relative 'move'
require_relative 'computer'
require_relative 'human'

#ADD PAWN PROMOTION
#REFACTOR DIAGONAL AND HORIZONTAL MOVEMENT
#REWORK AI, GET AI DEBUG WORKING

class Game
  attr_reader :board, :cursor
  attr_accessor :avail_moves, :captured

  def self.load(file)
    YAML.load_file(file)
  rescue
    system 'clear'
    puts "Sorry, that file can't be found.".bold
    exit
  end

  def initialize
    @board = Board.new(self)
    @players = []
    @captured = []
    @avail_moves = []
    @cursor = [0, 0]
    @debug = false
    @debug_msgs = []
  end

  def start
    welcome
    play
  end

  def play
    render
    until game_over?
      current_player.make_move
      @players.rotate!
      render
    end
    game_over_message
  end

  def welcome
    puts "Welcome to chess! Select your mode."
    get_options
  end

  def game_over?
    @board.checkmate?(current_player.color)
  end

  def render
    system 'clear'
    screen = []
    @board.rows.each_with_index do |row, num|
      screen << render_row(row, num)
    end
    puts add_indices(screen) + @debug_msgs
  end

  def get_options
    puts "1 - Computer vs Computer"
    puts "2 - Human vs Computer"
    puts "3 - Human vs Human"
    puts "4 - Load saved game"
    make_players($stdin.getch)

  rescue OptionsError
    system 'clear'
    welcome
  end

  def game_over_message
    winner = @players.last.color == :w ? "White" : "Black"
    puts "Checkmate! #{winner} won!".colorize(color: :yellow).bold
  end

  def reset_render
    sleep(1)
    @avail_moves = []
    render
  end

  def update_cursor(move)
    init_debug                            #Can remove init_debug later
    x, y = @cursor
    dx, dy = move
    @cursor = [x + dx, y + dy]
  end

  def show_avail_moves(piece)
    if piece && piece.color == current_player.color
      @avail_moves = piece.moves.select do |potential_move|
        @board.all_valid_moves(current_player.color).select do |move_obj|
          move_obj.piece == piece
        end.map(&:to).include?(potential_move)
      end
    else
      @avail_moves = []
    end
  end

  def save!
    puts "Where do you want to save this? Enter a filename (with no extension)."
    filename = gets.chomp + '.yml'

    File.open(filename, 'w') do |f|
      f.puts self.to_yaml
    end

    puts "Your game was successfully saved to #{filename}!"
    sleep(2)
    puts "Now resuming gameplay."
    sleep(2)
  end

  private

  def current_player
    @players.first
  end

  def make_players(num)
    case num.to_i
    when 1
      @players << CPU.new(self, @board, :w)
      @players << CPU.new(self, @board, :b)
    when 2
      @players << Human.new(self, @board, :w)
      @players << CPU.new(self, @board, :b)
    when 3
      @players << Human.new(self, @board, :w)
      @players << Human.new(self, @board, :b)
    when 4
      load_game_prompt
    else raise OptionsError
    end
  end

  def load_game_prompt
    puts "What file do you want to load?"
    puts "Enter the exact filename below."
    load_game = Game.load(gets.chomp)
    if load_game.is_a?(Game)
      load_game.play
    else
      raise LoadingError
    end

  rescue LoadingError
    system 'clear'
    puts "Sorry, your save data was corrupted.".bold
    start
  end

  def render_row(row, i)
    j = 0
    this_line = row.inject("") do |line, piece|
      here = [i, j]
      j += 1
      line + construct_square(here, piece)
    end
    this_line << captured_pieces(:w) if i == 0
    this_line << captured_pieces(:b).colorize(color: :blue) if i == 7
    this_line << "   Check!" if i == 4 && @players.map(&:color).any? { |c| @board.in_check?(c) }
    this_line
  end

  def captured_pieces(color)
    line = @captured.select { |piece| piece.color == color }
    "  " + line.join(" ")
  end

  def construct_square(here, piece)
    background = here.inject(:+).even? ? :light_red : :light_cyan
    piece_img = piece ? piece.to_s : " "
    square = " #{piece_img}  ".colorize(background: background)


    if @avail_moves.include?(here)
       square = square.colorize(background: :light_green)
     end
    if here == @cursor
      square = square.colorize(background: :yellow)
    end
    square
  end

  def add_indices(rendered)
    rendered.map!.with_index do |line, i|
      " #{8 - i} " + line
    end
    letters = ('a'..'h').to_a.map { |l| "  #{l} " }
    rendered << "  " + letters.join
  end

  def init_debug
    if @debug
      @debug_msgs = []
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
        str += "\n\nWhite in check?: #{@board.in_check?(:w)}\nBlack in check?: #{@board.in_check?(:b)}\n"
        str += "Checkmate-W: #{@board.checkmate?(:w)} \nCheckmate-B?: #{@board.checkmate?(:b)}\n"
        str += "All valid moves (#{current_player.color}): #{@board.all_valid_moves(current_player.color)}"
      end
      @debug_msgs << str
    end
  end
end

class OptionsError < StandardError
end

class LoadingError < StandardError
end

if __FILE__ == $0
  Game.new.start
end
