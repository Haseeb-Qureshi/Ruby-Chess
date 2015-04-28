class Knight < Piece
  KNIGHT_MOVES = [2, 1, -1, -2].permutation(2).to_a
                        .select! { |pair| pair.map(&:abs).inject(:+) == 3 }

  include DiscreteMoveable

  def moves
    KNIGHT_MOVES
  end

  def to_s
    " N "
  end
end
