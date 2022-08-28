class Bishop extends Piece {
    
  public Bishop(int row, int col, int team) {
    super(row, col, team);
  }
  
  public void show() {
    
    image(bishop[team], displayX, displayY);
    
  }
  
  public void calculateMoves() {
    possibleMoves.clear();
    
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
    
    if (isPinned() || board.inCheck[team])
      filterMovesForCheck();
    
  }
  
}
