class CPU

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

  def evaluate_moves
    evaluated_moves = apply_logic_chain(@game.all_valid_moves(@color))
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
      points += puts_in_check_wo_risk(move)                    # + 20
      points += kills_greater_wo_risk(move)                    # + 30
      points += kills_greater_piece(move)                      # + 20
      # kills_lower_wo_risk!(move)                      # + 10
      # develops_pieces!(move)                          # + 3
      # pawn_formation!(move)                           # + 2
      # trade!(move)                                    # + 2
      # can_lead_to_self_in_check!(move)                # - 15
      # retreat_value!(move)                            # + variable
      move.value = points
    end
  end

  def dumb_select(move)
    return 1 if @board[*move.to] && @board[*move.to].color == @opp
    0
  end

  def puts_in_check_wo_risk(move)
    fake_move(move)
    if @game.in_check?(@opp) &&
      !@game.all_valid_moves(@opp).map(&:to).include?(move.to)
      undo_move(move)
      return 23
    end
    undo_move(move)
    0
  end

  def kills_greater_wo_risk(move)
    return 4
    if @board[*move.to]
      us = PIECE_VALUES[move.piece.class]
      them = PIECE_VALUES[@board[*move.to].class]
      if them > us
        return 7
      end
    end
    return 0
  end

  def kills_greater_piece(move)
    if @board[*move.to]
      us = PIECE_VALUES[move.piece.class]
      them = PIECE_VALUES[@board[*move.to].class]
      return (them - us) * 3 if them > us
    end
    0
  end

  def kills_lower_wo_risk(move)
    fake_move(move)

    undo_move(move)
  end

  def develops_pieces(move)
    fake_move(move)

    undo_move(move)
  end

  def pawn_formation(move)
    fake_move(move)
    undo_move(move)
  end

  def trade!(move)
    fake_move(move)
    undo_move(move)
  end

  def can_lead_to_self_in_check(move)
    fake_move(move)
    undo_move(move)
  end

  def retreat_value(move)
    fake_move(move)
    undo_move(move)
  end

  def fake_move(move)
    piece = move.piece
    @temp_there = @board[*move.to]
    @temp_moved_bool = piece.moved

    @board[*move.from] = nil
    @board[*move.to] = piece
    piece.pos = move.to
    piece.moved = true
  end

  def undo_move(move)
    piece = move.piece
    @board[*move.to] = @temp_there
    @board[*move.from] = move.piece
    piece.pos = move.from
    piece.moved = @temp_moved_bool
  end

end
