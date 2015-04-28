require 'byebug'

module Horizontalable
  def in_horizontal?(new_pos)
    x, y = @pos
    newx, newy = new_pos

    valid = x == newx || y == newy
    valid ? !h_collisions?(new_pos) : false
  end

  def h_collisions?(new_pos)
    y, x = @pos
    newy, newx = new_pos
    horizontal = y == newy

    row = horizontal ? @board.rows[y] : @board.rows.transpose[x]
    starting_pos = horizontal ? y : x

    diff = newy - y > 0 || newx - x > 0 ? 1 : -1

    i = starting_pos
    collision = false
  #debugger
    until horizontal ? i == newy : i == newx
# debugger
      collision = true unless row[i] == self
      i += diff
    end

    collision
  end
end

module Diagonalable
  def in_diagonal?(new_pos)
    x, y = @pos
    newx, newy = new_pos

    valid = (x - newx).abs == (y - newy).abs
    valid ? !d_collisions? : false
  end

  def d_collisions?

  end
end

module DiscreteMoveable
  def valid_move?(to_pos)
    x, y = @pos
    xnew, ynew = to_pos
    diff = [x - xnew, y - ynew]

    moves.include?(diff)
  end
end
