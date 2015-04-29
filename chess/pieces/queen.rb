require_relative './movements/horizontal'
require_relative './movements/diagonal'

class Queen < Piece
  include Diagonalable
  include Horizontalable

  def moves
    h_moves + d_moves
  end

  def valid_move?(to_pos)
    moves.include?(to_pos)
  end

  def to_s
    "-Q-"
  end
end
