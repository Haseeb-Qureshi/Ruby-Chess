require_relative './movements/diagonal'

class Bishop < Piece
  include Diagonalable

  def moves
    d_moves
  end

  def valid_move?(to_pos)
    moves.include?(to_pos)
  end

  def to_s
    " B "
  end
end
