class Queen < Piece
  include Slideable

  def to_s
    color == :b ? "♛".colorize(:black) : "♛".colorize(:white)
  end

  protected

  def move_dirs
    diagonal_dirs + horizontal_dirs
  end
end
