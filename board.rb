require_relative './pieces/pieces.rb'
require 'byebug'

class Board
  attr_accessor :rows

  def self.opp(color)
    color == :w ? :b : :w
  end

  def initialize(game)
    @game = game
    @rows = Array.new(8) { Array.new(8) { nil } }
    set_board
  end

  def [](x, y)
    @rows[x][y]
  end

  def []=(x, y, val)
    @rows[x][y] = val
  end

  def move(start_pos, end_pos)
    piece = self[*start_pos]
    target = self[*end_pos]

    self[*start_pos] = nil
    self[*end_pos] = piece

    @game.captured << target if target
    @game.avail_moves = []
    piece.pos = end_pos
    piece.moved = true
  end

  def pieces(color)
    @rows.flatten.compact.select { |piece| piece.color == color }
  end

  def king(color)
    pieces(color).find { |piece| piece.is_a?(King) }
  end

  def king_pos(color)
    @rows.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        return [i, j] if piece.is_a?(King) && piece.color == color
      end
    end
  end

  def valid_pos?(pos)
    x, y = pos
    x.between?(0, 7) && y.between?(0, 7)
  end

  def in_check?(color)
    all_moves = pieces(Board.opp(color)).inject([]) do |move_collector, piece|
      move_collector + piece.moves
    end

    all_moves.include?(king(color).pos)
  end

  def puts_in_check?(from_coords, to_coords, color)
    there = self[*to_coords]
    piece = self[*from_coords]
    self[*from_coords] = nil
    self[*to_coords] = piece
    piece.pos = to_coords

    check = in_check?(color)

    self[*to_coords] = there
    self[*from_coords] = piece
    piece.pos = from_coords

    check
  end

  def checkmate?(color)
    pieces(color).all? do |piece|
      piece.moves.all? do |move|
        puts_in_check?(piece.pos, move, color)
      end
    end
  end

  def invalid_move?(from_coords, to_coords)
    !self[*from_coords].moves.include?(to_coords)
  end

  def all_valid_moves(color)
    all_moves = pieces(color).inject([]) do |all, piece|
      all + piece.moves.select do |move|
        !puts_in_check?(piece.pos, move, color)
      end.map { |move| Move.new(piece.pos, move, piece) }
    end
    all_moves.uniq
  end

  def empty?(pos)
    self[*pos].nil?
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
    [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook].map do |piece|
      piece.new(self)
    end
  end

  def set_row(row, row_num, color)
    row.each.with_index do |piece, i|
      piece.color = color
      piece.pos = [row_num, i]
    end
  end
end
