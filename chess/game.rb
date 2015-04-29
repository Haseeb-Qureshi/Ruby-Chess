require_relative 'board'

# CHECK_MATE?
# CREATE AN ARRAY OF ALL CAPTURES FOR EACH PLAYER
# IN DISPLAY METHOD, APPEND 8-1 for each row, a-h on bottom
# FINISH WRITING PAWN METHODS

class Game

  def initialize
    @board = Board.new
    @players = [:w, :b]
    @captured = []
  end

  def play
    welcome
    render_game
    until game_over?
      player_move(@players.first)
      @players = @players.rotate(1)
      render_game
    end
  end

  def welcome
    puts "Welcome to chess! White goes first."
  end

  def render_game
    @board.rows.each { |row| p row }
  end

  def player_move(color)
    from_coords = move_from(color)
    piece = @board[*from_coords]

    puts "Where do you want to move?"
    to_coords = move_to(from_coords, color)
    move(from_coords, to_coords)
  rescue ArgumentError
    puts "Invalid selection. Try again."
    retry
  rescue UnableError
    puts "That piece can't move. Pick another piece."
    retry
  end

  def move(from_coords, to_coords)
    there = @board[*to_coords]
    piece = @board[*from_coords]
    @captured << there if there

    @board[*from_coords] = nil
    @board[*to_coords] = piece

    piece.moved = true
  end

  def move_from(color)
    puts "Please pick what piece you want to move."
    puts "Select a piece like so: 'a1', 'h7'"
    from_coords = parse_input(gets.chomp)
    piece = @board[*from_coords]
    raise ArgumentError unless piece && piece.color == color
    raise UnableError if piece.moves.empty?
    from_coords
  end

  def move_to(from_coords, color)
    puts "Please pick what spot you'd like to move to."
    to_coords = parse_input(gets.chomp)
    if invalid_move?(from_coords, to_coords)
      raise InvalidError
    elsif in_check?(from_coords, to_coords, color)
      raise CheckError
    end
    to_coords
  rescue CheckError
    puts "You can't move into Check"
    retry
  rescue InvalidError
    puts "You can't move there!"
    retry
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

  def parse_input(input)
    case
    when input.length != 2 then raise ArgumentError
    when !input[0][/[A-Ha-h]/] || !input[1].to_i.between?(1, 8)
      raise ArgumentError
    else
      x = input[0].downcase.ord - 'a'.ord
      y = 8 - input[1].to_i
    end
    [y, x]
  end



end

class UnableError < StandardError
end

class InvalidError < StandardError
end

class CheckError < StandardError
end
