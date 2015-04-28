class Piece
  attr_reader :color, :pos
  def initialize(color, board, pos)
    @color, @board, @pos, @moved = color, board, pos, false
  end

  def same_team?(other_piece)
    @color == other_piece.color
  end

  def move(new_pos)
    return false unless on_board?(new_pos) && valid_move?(new_pos)
    @pos = new_pos
    @board.move(self, new_pos)
    true
  end

  def valid_move?(to_pos)
    raise "Not yet implemented."
  end

  def on_board(position)
    position.all? { |nums| nums.between?(0, 7) }
  end
end

Module Horizontalable
  def in_horizontal?(new_pos)
    x, y = @pos
    newx, newy = new_pos

    x == newx || y == newy
  end
end

Module Diagonalable
  def in_diagonal?(new_pos)
    x, y = @pos
    newx, newy = new_pos

    (x - newx).abs == (y - newy).abs
  end
end

Module DiscreteMoveable
  def valid_move?(to_pos)
    x, y = @pos
    xnew, ynew = to_pos
    diff = [x - xnew, y - ynew]

    MOVES.include?(diff)
  end
end

class Knight < Piece
  include DiscreteMoveable
  MOVES = [2, 1, -1, -2].permutation(2).to_a
                        .select! { |pair| pair.map(&:abs).inject(:+) == 3 }
end

class Bishop < Piece
  include Diagonalable
  def valid_move?(to_pos)
    in_diagonal?(to_pos)
  end
end

class Rook < Piece
  include Horizontalable
  def valid_move?(to_pos)
    in_horizontal?(to_pos)
  end
end

class Pawn < Piece
  def valid_move?(to_pos)
  end
end

class Queen < Piece
  include Diagonalable
  include Horizontalable
  def valid_move?(to_pos)
    in_horizontal?(to_pos) || in_diagonal?(to_pos)
  end
end

class King < Piece
  include DiscreteMoveable
  MOVES = [1, 1, 0, -1, -1].permutation(2).to_a.uniq!
end
































# ..
