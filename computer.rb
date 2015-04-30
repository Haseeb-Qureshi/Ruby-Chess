class CPU
  attr_reader :color

  PIECE_VALUES = {
    Pawn => 1,
    Knight => 3,
    Bishop => 3,
    Rook => 5,
    Queen => 9,
    King => 1
  }

  def initialize(game, board, color)
    @game, @color, @board = game, color, board
    @moves = 0
    @opp = Board.opp(@color)
  end

  def make_move
    best_move = evaluate_moves
    p best_move                            # DEBUG INFO
    @board.move(best_move.from, best_move.to)
  end

  def evaluate_moves
    sleep(0.35 + 0.1 * rand(2))
    evaluated_moves = apply_logic_chain(@board.all_valid_moves(@color))
    best_move(evaluated_moves)
  end

  def best_move(moves)
    if moves.none? { |move| move.value > 0 }
      moves.sample
    else
      moves.max_by(&:value)
    end
  end

  def apply_logic_chain(moves)
    moves.each do |move|
      points = 0
      points += dumb_select(move)
      # points += puts_in_check_wo_risk(move)                    # + 20
      # points += kills_greater_wo_risk(move)                    # + 30
      # points += kills_greater_w_risk(move)               # + 20
      # points += kills_wo_risk(move)                      # + 10
      # points += develops_pieces(move)                          # + 3
      # pawn_formation!(move)                           # + 2
      # trade!(move)                                    # + 2
      # can_lead_to_self_in_check!(move)                # - 15
      # retreat_value!(move)                            # + variable
      # points += leads_to_checkmate(move)              # + 1000
      move.value = points
    end
  end

  def dumb_select(move)
    return 5 if @board[*move.to] && @board[*move.to].color == @opp
    0
  end

  def puts_in_check_wo_risk(move)
    at_risk = fake_move_puts_at_risk?(move)
    if @board.in_check?(@opp) && !at_risk
      undo_move(move)
      p "puts_in_check_wo_risk #{move.to_s}"   # DEBUG
      return 22
    end
    undo_move(move)
    0
  end

  def kills_greater_wo_risk(move)
    other = @board[*move.to]
    at_risk = fake_move_puts_at_risk?(move)
    if other && !at_risk
      us = PIECE_VALUES[move.piece.class]
      them = PIECE_VALUES[other.class]
      undo_move(move)
      p "kills_greater_wo_risk #{move.to_s}" if them > us # DEBUG
      return (them - us) * 8 if them > us
    end
    undo_move(move)
    0
  end

  def kills_greater_w_risk(move)
    other = @board[*move.to]
    at_risk = fake_move_puts_at_risk?(move)
    if other && at_risk
      us = PIECE_VALUES[move.piece.class]
      them = PIECE_VALUES[other.class]
      undo_move(move)
      p "kills_greater_w_risk #{move.to_s}" if them > us
      return 7 + (them - us) * 4 if them > us
    end
    undo_move(move)
    0
  end

  def kills_wo_risk(move)
    other = @board[*move.to]
    at_risk = fake_move_puts_at_risk?(move)
    if other && at_risk
      us = PIECE_VALUES[move.piece.class]
      them = PIECE_VALUES[other.class]
      undo_move(move)
      p "kills_wo_risk #{move.to_s}" if them > us
      return 15 + (them - us)
    end
    undo_move(move)
    0
  end

  def develops_pieces(move)
    dividing_line = @color == :w ? 6 : 1
    return move.to[0] > dividing_line ? 1 : 0
  end

  # def pawn_formation(move)
  #   at_risk = fake_move_puts_at_risk?(move)
  #   undo_move(move)
  # end
  #
  # def trade!(move)
  #   at_risk = fake_move_puts_at_risk?(move)
  #   undo_move(move)
  # end
  #
  # def can_lead_to_self_in_check(move)
  #   at_risk = fake_move_puts_at_risk?(move)
  #   undo_move(move)
  # end
  #
  # def retreat_value(move)
  #   at_risk = fake_move_puts_at_risk?(move)
  #   undo_move(move)
  # end

  def fake_move_puts_at_risk?(move)
    piece = move.piece
    @temp_there = @board[*move.to]
    @temp_moved_bool = piece.moved

    @board[*move.from] = nil
    @board[*move.to] = piece
    piece.pos = move.to
    piece.moved = true

    at_risk = @board.all_valid_moves(@opp).map(&:to).include?(move.to)
  end

  def undo_move(move)
    piece = move.piece
    @board[*move.to] = @temp_there
    @board[*move.from] = move.piece
    piece.pos = move.from
    piece.moved = @temp_moved_bool
  end

end
