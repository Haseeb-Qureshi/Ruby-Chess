class Bishop < Piece
  include Diagonalable

  def valid_move?(to_pos)
    in_diagonal?(to_pos)
  end

  def to_s
    " B "
  end
end
