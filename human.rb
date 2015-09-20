class Human
  attr_reader :color

  MOVEMENT = {
    "w" => [-1, 0],
    "a" => [0, -1],
    "s" => [1, 0],
    "d" => [0, 1],
    "\r" => [0, 0]
    }

  FUNCTIONS = {
      "q" => :quit,
      "v" => :save
    }

  def initialize(game, board, color)
    @game, @board, @color = game, board, color
    @opp = Board.opp(@color)
  end

  def make_move
    from_coords = get_move_from
    piece = @board[*from_coords]

    puts "Where do you want to move?"

    to_coords = get_move_to
    raise CheckError if @board.puts_in_check?(from_coords, to_coords, @color)

    @board.move(Move.new(from_coords, to_coords, piece))

  rescue InvalidError
    puts "Invalid selection. Try again.".colorize(color: :red).bold
    @game.reset_render
    retry
  rescue UnableError
    puts "You can't do that.".colorize(color: :red).bold
    @game.reset_render
    retry
  rescue CheckError
    puts "That move would put you in check. Try something else.".colorize(color: :red).bold
    @game.reset_render
    retry
  end

  def get_move(first_click)
    choice = false
    until choice
      input = get_input
      @game.update_cursor(MOVEMENT[input])

      if first_click
        piece = @board[*@game.get_cursor]
        @game.show_avail_moves(piece)
      end
      @game.render

      if MOVEMENT[input] == [0, 0]
        if first_click
          raise InvalidError unless piece && piece.color == @color
          raise UnableError if piece.moves.empty?
        else
          raise UnableError if !@game.avail_moves.include?(@game.get_cursor)
        end
        choice = true
      end
    end
    @game.get_cursor.dup
  end

  def get_move_from
    get_move(true)
  end

  def get_move_to
    get_move(false)
  end

  def get_input
    puts "Use W-A-S-D to navigate to a piece. Press enter to select."
    puts "Press 'Q' to quit, and 'V' to save."
    movement = false
    until movement
      key = $stdin.getch.downcase
      do_function(key) if FUNCTIONS[key]
      movement = true if movement?(key)
    end
    key
  end

  def do_function(char)
    case FUNCTIONS[char]
    when :quit then system "clear";  puts "Thanks for playing!".bold; exit
    when :save then @game.save!
    end
  end

  def movement?(char)
    return false unless MOVEMENT.has_key?(char)
    x, y = @game.get_cursor
    dx, dy = MOVEMENT[char]
    @board.valid_pos?([x + dx, y + dy])
  end

  def fake_move(move)
    piece = move.piece
    @temp_there = @board[*move.to]
    @temp_moved_bool = piece.moved

    @board[*move.from] = nil
    @board[*move.to] = piece
    piece.pos = move.to
    piece.moved = true
  end

  def undo_move(move)
    piece = move.piece
    @board[*move.to] = @temp_there
    @board[*move.from] = move.piece
    piece.pos = move.from
    piece.moved = @temp_moved_bool
  end

end

class UnableError < StandardError
end

class InvalidError < StandardError
end

class CheckError < StandardError
end
