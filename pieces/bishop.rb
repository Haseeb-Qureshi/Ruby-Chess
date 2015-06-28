class Bishop < Piece
  include Slideable

  def to_s
    color == :b ? "♝".colorize(:black) : "♝".colorize(:white)
  end

  protected

  def move_dirs
    diagonal_dirs
  end

end
