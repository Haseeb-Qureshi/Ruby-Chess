class Display
  def initialize(game, debug)
    @game = game
    @board = game.board
    @debug = debug
    @avail_moves = []
    @cursor = [0, 0]
    @debug_msgs = []
    @captured = @game.captured
  end

  def render
    system 'clear'
    screen = []
    @board.rows.each_with_index do |row, num|
      screen << render_row(row, num)
    end
    puts add_indices(screen) + @debug_msgs
  end

  def reset_render
    sleep(1)
    @avail_moves = []
    render
  end

  def update_cursor(move)
    init_debug           # reinitializes debug information
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

  def render_row(row, i)
    j = 0
    this_line = row.inject("") do |line, piece|
      here = [i, j]
      j += 1
      line + construct_square(here, piece)
    end
    this_line << captured_pieces(:w) if i == 0
    this_line << captured_pieces(:b).colorize(color: :blue) if i == 7
    this_line << "   Check!" if i == 4 && @game.players.map(&:color).any? { |c| @board.in_check?(c) }
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
