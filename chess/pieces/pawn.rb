class Pawn < Piece
  attr_accessor :x_dir
  def initialize(board, color = nil, pos = nil)
    super(board, color, pos)
  end

  def valid_move?(to_pos)
    moves.include?(to_pos)
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
    moves_arr = []
    moves_arr << [x + @x_dir, y] unless @board[x + @x_dir, y]
    moves_arr << [x + @x_dir, y - 1] if @board[x + @x_dir, y - 1] &&
                           @board[x + @x_dir, y - 1].color != @color
    moves_arr << [x + @x_dir, y + 1] if @board[x + @x_dir, y + 1] &&
                           @board[x + @x_dir, y + 1].color != @color
    moves_arr
  end

  def color=(color)
    @color = color
    @x_dir = @color == :b ? 1 : -1
  end

  def to_s
    @color == :b ? "♟".colorize(:black) : "♟".colorize(:white)
  end
end
