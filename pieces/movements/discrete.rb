module DiscreteMoveable
  def moves
    move_diffs.map do |x, y|
      [x + @pos.first, y + @pos.last]
    end.select do |pos|
      on_board?(pos)
    end.reject do |pos|
      @board[*pos] && @board[*pos].color == @color
    end
  end

  # debug

  def moves_debug_diffsmap
    move_diffs.map do |x, y|
      [x + @pos.first, y + @pos.last]
    end
  end

  def moves_debug_select
    moves_debug_diffsmap.select! do |pos|
      on_board?(pos)
    end
  end
end
