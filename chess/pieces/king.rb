class King < Piece
  KING_MOVES = [1, 1, 0, -1, -1].permutation(2).to_a.uniq!

  def moves
    KING_MOVES
  end

  include DiscreteMoveable

  def to_s
    "-K-"
  end
end
