class Queen extends Piece {
  
  public Queen(int row, int col, int team) {
    super(row, col, team);
  }
  
  public void show() {
    
    image(queen[team], displayX, displayY);
    
  }
  
  public void calculateMoves() {
    possibleMoves.clear();
    
    //diagonals
    
    for (int i = -1; i <= 1; i += 2) {
      for (int j = -1; j <= 1; j += 2) {
        
        int nextRow = row;
        int nextCol = col;
        
        while (nextRow >= 0 && nextRow <= 7 && nextCol >= 0 && nextRow <= 7) {
          nextRow += i;
          nextCol += j;
          if (board.checkTile(nextRow, nextCol) == null) {
            possibleMoves.add(new PVector(nextCol, nextRow));
          } else if (board.checkTile(nextRow, nextCol).team != team){
            possibleMoves.add(new PVector(nextCol, nextRow));
            break;
          } else {
            break;
          }
        }
      }
    }
    
    
    //straight
    
    //vertical
    for (int i = -1; i <= 1; i += 2) {
      int nextRow = row;
      while (nextRow >= 0 && nextRow <= 7) {
        nextRow += i;
        if (board.checkTile(nextRow, col) == null)
          possibleMoves.add(new PVector(col, nextRow));
        else if (board.checkTile(nextRow, col).team != team) {
          possibleMoves.add(new PVector(col, nextRow));
          break;
        } else {
          break;
        }
      }
    }
    
    //horizontal
    for (int i = -1; i <= 1; i += 2) {
      int nextCol = col;
      while (nextCol >= 0 && nextCol <= 7) {
        nextCol += i;
        if (board.checkTile(row, nextCol) == null)
          possibleMoves.add(new PVector(nextCol, row));
        else if (board.checkTile(row, nextCol).team != team) {
          possibleMoves.add(new PVector(nextCol, row));
          break;
        } else {
          break;
        }
      }
    }
    
    if (isPinned() || board.inCheck[team])
      filterMovesForCheck();
    
  }
  
}
