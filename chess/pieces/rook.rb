require_relative './movements/horizontal'

class Rook < Piece
  include Horizontalable

  def moves
    h_moves
  end

  def to_s
    " R "
  end
end
