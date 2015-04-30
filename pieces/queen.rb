require_relative './movements/horizontal'
require_relative './movements/diagonal'

class Queen < Piece
  include Diagonalable
  include Horizontalable

  def moves
    h_moves + d_moves
  end

  def to_s
    color == :b ? "♛".colorize(:black) : "♛".colorize(:white)
  end
end
