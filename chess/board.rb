require_relative 'pieces.rb'

class Board
  attr_accessor :rows

  def initialize
    @rows = Array.new(8) { Array.new(8) }
    set_board
  end

  def set_board
    self
  end

  def [](x, y)
    @rows[x][y]
  end

  def []=(x, y, val)
    @rows[x][y] = val
  end

end
