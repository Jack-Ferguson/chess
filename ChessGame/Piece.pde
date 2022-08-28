abstract class Piece {

  int row, col, team;
  int displayX, displayY;
  ArrayList<PVector> possibleMoves = new ArrayList<PVector>();
  boolean selected = false;
  boolean hasMoved = false;
  
  public Piece(int row, int col, int team) {
    this.row = row;
    this.col = col;
    this.team = team;
  }
  
  abstract public void show();
  
  abstract public void calculateMoves();
  
  public void displayMoves() {
    fill(255, 0, 0, 100);
    for (int i = 0; i < possibleMoves.size(); i++) {
      rect(possibleMoves.get(i).x*tileSize, possibleMoves.get(i).y*tileSize, tileSize, tileSize);
    }
  }
  
  public void updateDisplayPos() {
    displayX = col * tileSize + tileSize/2;
    displayY = row * tileSize + tileSize/2;
  }
  
  public void setDisplayPos(int displayX, int displayY) {
    this.displayX = displayX;
    this.displayY = displayY;
  }
  
  public boolean checkMouseClick() {
      return (mouseX >= col*tileSize && mouseX <= col*tileSize+tileSize && mouseY >= row*tileSize && mouseY <= row*tileSize+tileSize);
  }
  
  public void tryMoveTo(PVector tile) {
    if (possibleMoves.contains(tile)) {
      //any successful move should make any previously vulnerable pawns no longer vulnerable to en passant
      for (int i = 0; i < board.pieces.size(); i++) {
          if (board.pieces.get(i) instanceof Pawn) {
            ((Pawn)board.pieces.get(i)).enPassantVulnerable = false;
          }
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
  
  //this method will return true if removing a piece would result in own king check
  //technically it is unnecessary, but it is a less expensive calculation to see if
  //we should run filterMovesForCheck()
  public boolean isPinned() {
    
    //remove the piece from the board and see if the king would be in check
    int tempRow = row;
    int tempCol = col;
    
    row = -10;
    col = -10;
    
    board.checkChecks();
    row = tempRow;
    col = tempCol;
    return !board.inCheck[team];
    
  }
  
  //remove any moves that would leave the king in check
  public void filterMovesForCheck() {
    
    for (int i = 0; i < possibleMoves.size(); i++) {
      Piece temp = board.checkTile(possibleMoves.get(i));
      int tempRow = row;
      int tempCol = col;
      int tempTempRow = -1;
      int tempTempCol = -1;
      if (temp != null) {
        tempTempRow = temp.row;
        tempTempCol = temp.col;
        temp.row = -10;
        temp.col = -10;
      }
      col = (int)possibleMoves.get(i).x;
      row = (int)possibleMoves.get(i).y;
      board.checkChecks();
      if (board.inCheck[team]) {
        if (possibleMoves.size() == 1) {
          //println(this + " has no moves");
        }
        possibleMoves.remove(i);
        i--;
      }
      if (temp != null) {
        temp.row = tempTempRow;
        temp.col = tempTempCol;
      }
      //println(this+"Piece position restored");
      row = tempRow;
      col = tempCol;
    }
    
  }

}
