module Horizontalable
  def h_moves
    moves_arr = []
    moves_arr += right_moves
    moves_arr += left_moves
    moves_arr += up_moves
    moves_arr += down_moves
  end

  def right_moves
    x, y = @pos
    right_moves_arr = []
    @board.rows[x].each_with_index do |el, i|
      next if i <= y
      if el.nil?
        right_moves_arr << [x, i]
      elsif el && el.color == @color
        break
      else
        right_moves_arr << [x, i]
        break
      end
    end
    right_moves_arr
  end

  def left_moves
    x, y = @pos
    y = 7 - y
    left_moves_arr = []
    @board.rows[x].reverse.each_with_index do |el, i|
      next if i <= y
      if el.nil?
        left_moves_arr << [x, 7 - i]
      elsif el && el.color == @color
        break
      else
        left_moves_arr << [x, 7 - i]
        break
      end
    end
    left_moves_arr
  end

  def up_moves
    y, x = @pos

    y = 7 - y
    up_moves_arr = []
    # p "size = #{@board.rows.size}"
    # @board.rows.each_with_index { |row, i| p row if row.size == 9; p i if row.size==9}
    @board.rows.transpose[x].reverse.each_with_index do |el, i|
      next if i <= y
      if el.nil?
        up_moves_arr << [7 - i, x]
      elsif el && el.color == @color
        break
      else
        up_moves_arr << [7 - i, x]
        break
      end
    end
    up_moves_arr
  end

  def down_moves
    y, x = @pos
    down_moves_arr = []
    @board.rows.transpose[x].each_with_index do |el, i|
      next if i <= y
      if el.nil?
        down_moves_arr << [i, x]
      elsif el && el.color == @color
        break
      else
        down_moves_arr << [i, x]
        break
      end
    end
    down_moves_arr
  end
end
