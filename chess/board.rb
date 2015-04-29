require_relative './pieces/pieces.rb'
require 'byebug'

class Board
  attr_accessor :rows

  def initialize
    @rows = Array.new(8) { Array.new(8) { nil } }
    set_board
  end

  def [](x, y)
    @rows[x][y]
  end

  def []=(x, y, val)
    @rows[x][y] = val
  end

  def move(piece, start_pos, end_pos)
    self[start_pos] = nil
    self[end_pos] = piece
  end


  def set_board
    first_row = set_row(royalty, 0, :b)
    second_row = set_row(eight_pawns, 1, :b)
    bottom_pawns = set_row(eight_pawns, 6, :w)
    bottom_row = set_row(royalty, 7, :w)

    @rows[0] = first_row; @rows[1] = second_row
    @rows[6] = bottom_pawns; @rows[7] = bottom_row
  end

  private

  def eight_pawns
    [].tap { |arr| 8.times { arr << Pawn.new(self) } }
  end

  def royalty
    [Rook.new(self), Knight.new(self), Bishop.new(self),
     Queen.new(self), King.new(self), Bishop.new(self),
     Knight.new(self), Rook.new(self)]
  end

  def set_row(row, row_num, color)
    row.each.with_index do |piece, i|
      piece.color = color
      piece.pos = [row_num, i]
    end
  end

end
