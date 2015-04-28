
# board

attr_reader :rows

  def initialize(sym = :qu)
    @rows = Array.new(8) { Array.new(8) }
    @q = sym
  end

  def prepare_board
    @rows = Array.new(8) { Array.new(8) }
    random_8_qs
    self
  end

  def [](x, y)
    @rows[x][y]
  end

  def []=(x, y, val)
    @rows[x][y] = val
  end


# knight movement


def self.valid_moves(pos)
    my_x, my_y = pos
    potentials = []
    (my_x - 2..my_x + 2).each { |x| (my_y - 2..my_y + 2)
                        .each { |y| potentials << [x, y] } }
    select_valids(potentials, my_x, my_y)
  end

  def self.select_valids(potentials, x, y)
    potentials.select do |xy|
      xy[0].between?(0, 7) && xy[1].between?(0, 7) && # is it overflowing the board?
      (x - xy[0]).abs < 3 && (y - xy[1]).abs < 3 && # can't move 3 in a straight line
      (x - xy[0]).abs + (y - xy[1]).abs == 3 # but must move 3 steps
    end
  end
