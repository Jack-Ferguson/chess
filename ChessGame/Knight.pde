class Knight extends Piece {
  
  public Knight(int row, int col, int team) {
    super(row, col, team);
  }
  
  public void show() {
    
    image(knight[team], displayX, displayY);
    
  }
  
  public void calculateMoves() {
    possibleMoves.clear();

    //knight moves are 2 rows 1 col away or 1 row 2 cols away
    Piece toCheck;
    
    if (row - 2 >= 0) {
      toCheck = board.checkTile(row-2, col-1);
      if (col - 1 >= 0 && (toCheck == null || toCheck.team != team))
        possibleMoves.add(new PVector(col-1, row-2));
      toCheck = board.checkTile(row-2, col+1);
      if (col + 1 >= 0 && (toCheck == null || toCheck.team != team))
        possibleMoves.add(new PVector(col+1, row-2));
    }
    if (row + 2 <= 7) {
      toCheck = board.checkTile(row+2, col-1);
      if (col - 1 >= 0 && (toCheck == null || toCheck.team != team))
        possibleMoves.add(new PVector(col-1, row+2));
      toCheck = board.checkTile(row+2, col+1);
      if (col + 1 >= 0 && (toCheck == null || toCheck.team != team))
        possibleMoves.add(new PVector(col+1, row+2));
    }
    if (col - 2 >= 0) {
      toCheck = board.checkTile(row-1, col-2);
      if (row - 1 >= 0 && (toCheck == null || toCheck.team != team))
        possibleMoves.add(new PVector(col-2, row-1));
      toCheck = board.checkTile(row+1, col-2);
      if (row + 1 >= 0 && (toCheck == null || toCheck.team != team))
        possibleMoves.add(new PVector(col-2, row+1));
    }
    if (col + 2 >= 0) {
      toCheck = board.checkTile(row-1, col+2);
      if (row - 1 >= 0 && (toCheck == null || toCheck.team != team))
        possibleMoves.add(new PVector(col+2, row-1));
      toCheck = board.checkTile(row+1, col+2);
      if (row + 1 >= 0 && (toCheck == null || toCheck.team != team))
        possibleMoves.add(new PVector(col+2, row+1));
    }
    
    if (isPinned() || board.inCheck[team])
      filterMovesForCheck();
  }
  
}
