require_relative './movements/horizontal'

class Rook < Piece
  include Horizontalable

  def moves
    h_moves
  end

  def to_s
    color == :b ? "♜".colorize(:black) : "♜".colorize(:white)
  end
end
