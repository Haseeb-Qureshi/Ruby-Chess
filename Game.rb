require 'io/console'
require 'colorize'
require 'byebug'
require 'yaml'
require_relative 'board'
require_relative 'move'
require_relative 'computer'
require_relative 'human'
require_relative 'display'

# TODO: ADD PAWN PROMOTION
# TODO: REWORK AI, GET AI DEBUG WORKING

class Game
  attr_reader :board, :cursor, :players, :all_cpu
  attr_accessor :avail_moves, :captured

  def self.load(file)
    YAML.load_file(file)
  rescue
    system 'clear'
    puts "Sorry, that file can't be found.".bold
    exit
  end

  def initialize
    @debug = true        # turns on debug menu
    @players = []
    @captured = []
    @board = Board.new(self)
    @display = Display.new(self, @debug)
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
    @display.render
  end

  def get_options
    puts "1 - Computer vs Computer"
    puts "2 - Human vs Computer"
    puts "3 - Human vs Human"
    puts "4 - Load saved game"
    make_players()

  rescue OptionsError
    system 'clear'
    welcome
  end

  def game_over_message
    winner = @players.last.color == :w ? "White" : "Black"
    puts "Checkmate! #{winner} won!".colorize(color: :yellow).bold
  end

  def reset_render
    @display.reset_render
  end

  def update_cursor(move)
    @display.update_cursor(move)
  end

  def show_avail_moves(piece)
    @display.show_avail_moves(piece)
  end

  def avail_moves
    @display.avail_moves
  end

  def get_cursor
    @display.cursor
  end

  def current_player
    @players.first
  end

  private

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

  def make_players()
    option = $stdin.getch
    case option.to_i
    when 1
      @players << CPU.new(self, @board, :w)
      @players << CPU.new(self, @board, :b)
      @all_cpu = true
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
end

class OptionsError < StandardError
end

class LoadingError < StandardError
end

if __FILE__ == $0
  Game.new.start
end
