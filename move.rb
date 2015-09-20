class Move
  include Comparable
  attr_accessor :from, :to, :piece, :value, :reasons

  def initialize(from, to, piece)
    @from, @to, @piece = from, to, piece
    @value = 0
    @reasons = []
  end

  def ==(other)
    @from == other.from && @to == other.to && @piece == other.piece
  end

  def hash
    [@from, @to, @piece].hash
  end

  def inspect
    "#{piece}: #{from} - #{to}, value: #{value}"
  end
end
