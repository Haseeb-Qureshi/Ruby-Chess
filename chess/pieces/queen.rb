class Queen < Piece
  include Diagonalable
  include Horizontalable

  def valid_move?(to_pos)
    in_horizontal?(to_pos) || in_diagonal?(to_pos)
  end

  def to_s
    "-Q-"
  end
end
