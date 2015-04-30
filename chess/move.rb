class Move
  include Comparable
  attr_accessor :from, :to, :piece, :value

  def initialize(from, to, piece)
    @from, @to, @piece = from, to, piece
    @value = 0
  end

  def ==(other)
    @from == other.from && @to == other.to && @piece == other.piece
  end

  def inspect
    "#{piece}: #{from} - #{to}, value: #{value}"
  end

end
