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
    @opp = @game.opp(@color)
  end

  def evaluate_moves
    evaluated_moves = apply_logic_chain(@game.all_valid_moves(@color))
    best_move(evaluated_moves)
  end

  def best_move(moves)
    p moves
    if moves.none? { |move| move.value > 0 }
      moves.sample
    else
      moves.max_by(&:value)
    end
  end

  def apply_logic_chain(moves)
    moves.each do |move|
      dumb_select!(move)
      puts_in_check_wo_risk!(move)                    # + 20
      kills_greater_wo_risk!(move)                    # + 30
      kills_greater_piece!(move)                      # + 20
      # kills_lower_wo_risk!(move)                      # + 10
      # develops_pieces!(move)                          # + 3
      # pawn_formation!(move)                           # + 2
      # trade!(move)                                    # + 2
      # can_lead_to_self_in_check!(move)                # - 15
      # retreat_value!(move)                            # + variable
    end
  end

  def dumb_select!(move)
    move.value += 1 if @board[*move.to] && @board[*move.to].color == @opp
  end

  def puts_in_check_wo_risk!(move)
    fake_move(move)
    if @game.in_check?(@opp) &&
      !@game.all_valid_moves(@opp).map(&:to).include?(move.to)
      move.value += 23
    end
    undo_move(move)
  end

  def kills_greater_wo_risk(move)
  end

  def kills_greater_piece!(move)
    fake_move(move)
    if @board[*move.to]
      us = PIECE_VALUES[move.piece.class]
      them = PIECE_VALUES[@board[*move.to].class]
      puts "KILLING GREATER PIECE us #{us} them: #{them}"
      if them > us
        puts "inside IF statement"
        move.value += (them - us) * 5
      end
    end
    undo_move(move)
  end

  def kills_lower_wo_risk!(move)
    fake_move(move)

    undo_move(move)
  end

  def develops_pieces!(move)
    fake_move(move)

    undo_move(move)
  end

  def pawn_formation!(move)
    fake_move(move)
    undo_move(move)
  end

  def trade!(move)
    fake_move(move)
    undo_move(move)
  end

  def can_lead_to_self_in_check!(move)
    fake_move(move)
    undo_move(move)
  end

  def retreat_value!(move)
    fake_move(move)
    undo_move(move)
  end

  def kills_greater_wo_risk!(move)
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
