class Rook < Piece
  include Horizontalable

  def valid_move?(to_pos)
    in_horizontal?(to_pos)
  end

  def to_s
    " R "
  end
end
