require_relative './movements/diagonal'

class Bishop < Piece
  include Diagonalable

  def moves
    d_moves
  end

  def to_s
    color == :b ? "♝".colorize(:black) : "♝".colorize(:white)
  end
end
