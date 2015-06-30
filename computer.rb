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
    p best_move                            # debug info
    @board.move(best_move.from, best_move.to)
  end

  private

  def evaluate_moves
    sleep(0.25 + 0.3 * rand(2))
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
      # points += dumb_select(move)
      points += attack_points(move)
      points += develops_pieces(move)
      points += can_lead_to_self_in_check(move)
      # points += retreat_value(move)
      # points += pawn_formation(move)
      # points += leads_to_checkmate(move)
      move.value = points
    end
  end

  def dumb_select(move)
    @board[*move.to] && @board[*move.to].color == @opp ? 3 : 0
  end

  def attack_points(move)
    other_piece = @board[*move.to]
    fake_move(move)
    at_risk = at_risk?(move)
    our_value = PIECE_VALUES[move.piece.class]
    their_value = PIECE_VALUES[other_piece.class]
    points = 0

    if @board.in_check?(@opp) && !at_risk
      points += puts_in_check_wo_risk
    end

    if other_piece && !at_risk && their_value > our_value
      points += kills_greater_wo_risk(their_value, our_value)
    end


    if other_piece && at_risk && their_value > our_value
      points += kills_greater_w_risk(their_value, our_value)
    end

    if other_piece && !at_risk && their_value <= our_value
      points += kills_lesser_or_equal_wo_risk(their_value, our_value)
    end

    undo_fake_move(move)
    points
  end

  def puts_in_check_wo_risk
    # puts "Putting in check without risk!"
    15
  end

  def kills_greater_wo_risk(their_value, our_value)
    # puts "Killing greater without risk!"
    (their_value - our_value) * 8
  end

  def kills_greater_w_risk(their_value, our_value)
    # puts "Killing greater WITH risk!"
    7 + (their_value - our_value) * 4
  end

  def kills_lesser_or_equal_wo_risk(their_value, our_value)
    # puts "Killing lesser or equal without risk!"
    1 + (their_value - our_value)
  end

  def develops_pieces(move)
    # puts "Developing pieces!"
    our_value = PIECE_VALUES[move.piece.class]
    move.to[0].between?(2, 5) ? 1 : 0
  end

  def can_lead_to_self_in_check(move)
    fake_move(move)
    points = checkable? ? -20 : 0
    undo_fake_move(move)
    points
  end

  # def pawn_formation(move)
  # end

  # def retreat_value(move)
  # end

  # def leads_to_checkmate(move)
  # end

  def fake_move(move)
    piece = move.piece
    @saved_tile_contents = @board[*move.to]
    @saved_move_state = piece.moved

    @board[*move.from] = nil
    @board[*move.to] = piece
    piece.pos = move.to
    piece.moved = true
  end

  def at_risk?(move)
    @board.all_valid_moves(@opp).map(&:to).include?(move.to)
  end

  def checkable?
    @board.all_valid_moves(@opp).map(&:to).include?(@board.king_pos(@color))
  end

  def undo_fake_move(move)
    piece = move.piece
    @board[*move.to] = @saved_tile_contents
    @board[*move.from] = move.piece
    piece.pos = move.from
    piece.moved = @saved_move_state
  end
end
