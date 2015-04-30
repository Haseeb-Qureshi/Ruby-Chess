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
      el = @board[i, j]
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
      el = @board[i, j]
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
    until i < 0 || j < 0
      el = @board[i, j]
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
    until i > 7 || j > 7
      el = @board[i, j]
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
end
