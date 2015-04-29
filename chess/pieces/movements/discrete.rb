module DiscreteMoveable
  def moves
    move_diffs.map do |x, y|
      [x + @pos.first, y + @pos.last]
    end
    .select! do |pos|
      on_board?(pos)
    end
    .reject! do |pos|
      @board[*pos] && @board[*pos].color == @color
    end
  end
end
