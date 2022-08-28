class King extends Piece {
  
  public King(int row, int col, int team) {
    super(row, col, team);
  }
  
  public void show() {
    
    image(king[team], displayX, displayY);
    
  }
  
  public void calculateMoves() {
    possibleMoves.clear();
    
    Piece toCheck;
    
    if (row - 1 >= 0) {
      
      toCheck = board.checkTile(row-1, col);
      if (toCheck == null || toCheck.team != team)
        possibleMoves.add(new PVector(col, row-1));
        
      toCheck = board.checkTile(row-1, col-1);
      if (col - 1 >= 0 && (toCheck == null || toCheck.team != team))
        possibleMoves.add(new PVector(col-1, row-1));
        
      toCheck = board.checkTile(row-1, col+1);
      if (col + 1 <= 7 && (toCheck == null || toCheck.team != team))
        possibleMoves.add(new PVector(col+1, row-1));
    }
    if (row + 1 <= 7) {
      
      toCheck = board.checkTile(row+1, col);
      if (toCheck == null || toCheck.team != team)
        possibleMoves.add(new PVector(col, row+1));
        
      toCheck = board.checkTile(row+1, col-1);
      if (col - 1 >= 0 && (toCheck == null || toCheck.team != team))
        possibleMoves.add(new PVector(col-1, row+1));
        
      toCheck = board.checkTile(row+1, col+1);
      if (col + 1 <= 7 && (toCheck == null || toCheck.team != team))
        possibleMoves.add(new PVector(col+1, row+1));
    }
    
    toCheck = board.checkTile(row, col-1);
    if (col - 1 >= 0 && (toCheck == null || toCheck.team != team))
      possibleMoves.add(new PVector(col-1, row));
      
    toCheck = board.checkTile(row, col+1);
    if (col + 1 <= 7 && (toCheck == null || toCheck.team != team))
      possibleMoves.add(new PVector(col+1, row));
      
    //castling
    if (!hasMoved) {
        Piece castleRook = board.checkTile(row, col-4);
        //path to rook is clear
        if (board.checkTile(row, col-1) == null && board.checkTile(row, col-2) == null && board.checkTile(row, col-3) == null)
          if (!castleRook.hasMoved)
            possibleMoves.add(new PVector(col-2, row));
        castleRook = board.checkTile(row, col+3);
        //path to rook is clear
        if (board.checkTile(row, col+1) == null && board.checkTile(row, col+2) == null)
          if (!castleRook.hasMoved)
            possibleMoves.add(new PVector(col+2, row));
    }
    
    //king's moves need to be filtered for checkmate
    if (board.inCheck[team])
      filterMovesForCheck();
  }
  
  //king needs to override tryMoveTo for castling
  @Override
  public void tryMoveTo(PVector tile) {
    if (possibleMoves.contains(tile)) {
      //any successful move should make any previously vulnerable pawns no longer vulnerable to en passant
      for (int i = 0; i < board.pieces.size(); i++) {
          if (board.pieces.get(i) instanceof Pawn) {
            ((Pawn)board.pieces.get(i)).enPassantVulnerable = false;
          }
      }
      //Kingside castle
      if (!hasMoved && tile.x == col+2) {
        Piece rook = board.checkTile(row, col+3);
        rook.col = col+1;
        rook.hasMoved = true;
      }
      
      //Queenside castle
      if (!hasMoved && tile.x == col-2) {
        Piece rook = board.checkTile(row, col-4);
        rook.col = col-1;
        rook.hasMoved = true;
      }
      //move is possible, take any piece present on the tile and perform it
      hasMoved = true;
      board.tryTakePiece(board.checkTile(tile));
      this.row = (int)tile.y;
      this.col = (int)tile.x;
      
      board.advanceTurn();
    } else {
      println("Invalid Move");
    }
  }
  
}
