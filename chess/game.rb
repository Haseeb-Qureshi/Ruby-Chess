require_relative 'board'

class Game

  def initialize
    @board = Board.new
    @players = [:w, :b]
  end

  def play
    welcome
    until false #game_over?
      player_move(@players.first)
      @players = @players.rotate(1)
    end
  end

  def welcome
    puts "Welcome to chess! White goes first."
  end

  def player_move(color)
    from_coords = move_from(color)
    piece = @board[*from_coords]

    puts "Where do you want to move?"
    to_coords = move_to(color)

    #FINISH THIS
  rescue
    puts "Invalid input. Try again."
    retry
  end

  def move_from(color)
    puts "Please pick what piece you want to move."
    puts "Select a piece like so: 'a1', 'h7'"
    from_coords = parse_input(gets.chomp)
    raise ArgumentError unless @board[*from_coords] &&
                               @board[*from_coords].color == color
  end

  def move_to(color)
    puts "Please pick what spot you'd like to move to."
    to_coords = parse_input(gets.chomp)
    raise ArgumentError unless [VALIDMOVE] or [PUTS KING IN CHECK]
    #WRITE METHODS: IN CHECK?
    # CHECK_MATE?
    # CREATE AN ARRAY OF ALL CAPTURES FOR EACH PLAYER
    # IN DISPLAY METHOD, APPEND 8-1 for each row, a-h on bottom
    # FINISH WRITING PAWN METHODS


  end

  def parse_input(input)
    case
    when input.length != 2 then raise ArgumentError
    when !input[0][/[A-Ha-h]/] || !input[1].to_i.between?(1, 8)
      raise ArgumentError
    else
      x = input[0].downcase.ord - 'a'.ord
      y = 8 - input[1].to_i
      [x, y]
    end
  end



end
