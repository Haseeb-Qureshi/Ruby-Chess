class Knight < Piece
  KNIGHT_MOVE_DIFFS = [2, 1, -1, -2].permutation(2).to_a
                        .select! { |pair| pair.map(&:abs).inject(:+) == 3 }

  include DiscreteMoveable

  def move_diffs
    KNIGHT_MOVE_DIFFS
  end

  def to_s
    color == :b ? "♞".colorize(:black) : "♞".colorize(:white)
  end

end
