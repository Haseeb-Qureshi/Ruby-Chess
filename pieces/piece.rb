class Piece
  attr_accessor :color, :pos, :moved
  def initialize(board, color = nil, pos = nil)
    @color, @board, @pos, @moved = color, board, pos, false
  end

  def move(new_pos)
    return false unless on_board?(new_pos) && valid_move?(new_pos)
    @pos = new_pos
    @board.move(Move.new(@pos, new_pos, self))
    true
  end

  def on_board?(position)
    position.all? { |num| num.between?(0, 7) }
  end

  def valid_move?(to_pos)
    moves.include?(to_pos)
  end

  def inspect
    to_s
  end

end
