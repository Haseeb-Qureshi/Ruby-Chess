class Pawn < Piece

  def initialize(board, color = nil, pos = nil)
    super(board, color, pos)
    @x_dir = color == :b ? 1 : -1
  end

  def valid_move?(to_pos)
  end

  def moves
    @moved ? moved : never_moved
  end

  def never_moved

  end

  def moved

  end


  def to_s
    " p "
  end
end
