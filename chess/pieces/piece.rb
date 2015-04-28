class Piece
  attr_accessor :color, :pos
  def initialize(board, color = nil, pos = nil)
    @color, @board, @pos, @moved = color, board, pos, false
  end

  def same_team?(other_piece)
    @color == other_piece.color
  end

  def move(new_pos)
    return false unless on_board?(new_pos) && valid_move?(new_pos)
    @pos = new_pos
    @board.move(self, @pos, new_pos)
    true
  end

  def on_board(position)
    position.all? { |num| num.between?(0, 7) }
  end

  def inspect
    to_s
  end
end
