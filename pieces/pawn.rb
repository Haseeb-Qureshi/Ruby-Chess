class Pawn < Piece
  attr_accessor :x_dir
  def initialize(board, color = nil, pos = nil)
    super(board, color, pos)
  end

  def moves
    @moved ? has_moved : never_moved
  end

  def never_moved
    x, y = @pos
    if @board[x + @x_dir * 2, y] || @board[x + @x_dir, y]
      has_moved
    else
      has_moved << [x + @x_dir * 2, y]
    end
  end

  def has_moved
    x, y = @pos
    my_moves = []
    newx = x + @x_dir
    if on_board?([newx, y])
      my_moves << [newx, y] unless @board[newx, y]
      [[newx, y - 1], [newx, y + 1]].each do |jump_pos|
        if @board.valid_pos?(jump_pos) && @board[*jump_pos] && @board[*jump_pos].color != @color
          my_moves << jump_pos
        end
      end
    end
    my_moves
  end

  def color=(color)
    @color = color
    @x_dir = @color == :b ? 1 : -1
  end

  def to_s
    @color == :b ? "♟".colorize(:black) : "♟".colorize(:white)
  end
end
