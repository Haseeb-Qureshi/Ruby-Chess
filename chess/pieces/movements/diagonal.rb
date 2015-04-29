module Diagonalable

  def d_moves
    moves_arr = []
    moves_arr += right_up
    moves_arr += left_down
    moves_arr += up_left
    moves_arr += down_right
  end

  def right_up
    right_up_arr = []
    x, y = @pos

    i, j = x - 1, y + 1
    until i < 0 || j > 7
      p el = @board[i, j]
      if el.nil?
        right_up_arr << [i, j]
      elsif el && el.color == @color
        break
      else
        right_up_arr << [i, j]
        break
      end

      i -= 1
      j += 1
    end

    right_up_arr
  end

  def left_down
    left_down_arr = []
    x, y = @pos

    i, j = x + 1, y - 1
    until i > 7 || j < 0
      p el = @board[i, j]
      if el.nil?
        left_down_arr << [i, j]
      elsif el && el.color == @color
        break
      else
        left_down_arr << [i, j]
        break
      end

      i += 1
      j -= 1
    end

    left_down_arr
  end

  def up_left
    up_left_arr = []
    x, y = @pos

    i, j = x - 1, y - 1
    until i > 7 || j < 0
      p el = @board[i, j]
      if el.nil?
        up_left_arr << [i, j]
      elsif el && el.color == @color
        break
      else
        up_left_arr << [i, j]
        break
      end

      i -= 1
      j -= 1
    end

    up_left_arr
  end

  def down_right
    down_right_arr = []
    x, y = @pos

    i, j = x + 1, y + 1
    until i > 7 || j < 0
      p el = @board[i, j]
      if el.nil?
        down_right_arr << [i, j]
      elsif el && el.color == @color
        break
      else
        down_right_arr << [i, j]
        break
      end

      i += 1
      j += 1
    end

    down_right_arr
  end
  # def in_diagonal?(new_pos)
  #   x, y = @pos
  #   newx, newy = new_pos
  #
  #   valid = (x - newx).abs == (y - newy).abs
  #   valid ? !d_collisions? : false
  # end
  #
  # def d_collisions?(new_pos)
  #   y, x = @pos
  #   newy, newx = new_pos
  #
  #   x - newx == y - newy ? up_left_col?(new_pos) : up_right_col?(new_pos)
  #
  # end
  #
  # def up_right_col?(new_pos)
  #   y, x = @pos
  #   newy, newx = new_pos
  #
  #   right = newx > x
  #   i, j = x, y
  #
  #   until i == newx && j == newy
  #     collision = true if row[i] && row[i] != self
  #     if right
  #       i += 1; j -= 1
  #     else
  #       i -= 1; j += 1
  #     end
  #   end
  #
  #   collision
  # end
  #
  # def up_left_col?(new_pos)
  #   y, x = @pos
  #   newy, newx = new_pos
  #
  #   right = newx > x
  #   i, j = x, y
  #
  #   until i == newx && j == newy
  #     collision = true if row[i] && row[i] != self
  #     if right
  #       i += 1; j += 1
  #     else
  #       i -= 1; j -= 1
  #     end
  #   end
  #
  #   collision
  # end
end
