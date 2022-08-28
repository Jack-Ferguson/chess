class Pawn extends Piece {
  
  boolean enPassantVulnerable = false;
  
  public Pawn(int row, int col, int team) {
    super(row, col, team);
  }
  
  public void calculateMoves() {
    //clear previous list of moves
    this.possibleMoves.clear();
    
    //white and black pawns move in opposite directions
    if (team == 1) {
      //black pawns
      
      //pawns can't move into occupied spaces in front of them
      if (board.checkTile(row+1, col) == null) {
        possibleMoves.add(new PVector(col, row+1));
      
        //pawns can move 2 spaces if they have not moved yet, but not if the tile is occupied
        if (!hasMoved && board.checkTile(row+2, col) == null) {
          possibleMoves.add(new PVector(col, row+2));
        }
        
      }
      
      //handle captures
      //handle edge pawns differently
      Piece toCheckPassant;
      
      if (col < 7) {
        
        //normal capture
        //println("Tile Check: "+board.checkTile(row+1, col+1));
        if (board.checkTile(row+1, col+1) != null && board.checkTile(row+1, col+1).team != team) {
          possibleMoves.add(new PVector(col+1, row+1));
          //println("Pawn capture possible");
        }
        
        //for black pawns, en passant capture is possible only if they are in the 5th row (index 4)
        if (row == 4) {
          toCheckPassant = board.checkTile(row, col+1);
          if (toCheckPassant instanceof Pawn && ((Pawn)toCheckPassant).enPassantVulnerable && toCheckPassant.team != team) {
            possibleMoves.add(new PVector(col+1, row+1, 1));
          }
        }
      }
      if (col > 0) {
        
        //normal capture
        if (board.checkTile(row+1, col-1) != null && board.checkTile(row+1, col-1).team != team)
            possibleMoves.add(new PVector(col-1, row+1));
            
        if (row == 4) {
          toCheckPassant = board.checkTile(row, col-1);
          if (toCheckPassant instanceof Pawn && ((Pawn)toCheckPassant).enPassantVulnerable && toCheckPassant.team != team) {
            possibleMoves.add(new PVector(col-1, row+1, 1));
          }
        }
      }
        
    } else if (team == 0) {
      //white pawns
      
      //pawns can't move into occupied spaces in front of them
      if (board.checkTile(row-1, col) == null) {
        possibleMoves.add(new PVector(col, row-1));
        //pawns can move 2 spaces if they have not moved yet, but not if the tile is occupied
        if (!hasMoved && board.checkTile(row-2, col) == null) {
          possibleMoves.add(new PVector(col, row-2));
        }
      }
      
      //handle captures
      //handle edge pawns differently
      Piece toCheckPassant;
      
      if (col < 7) {
          if (board.checkTile(row-1, col+1) != null && board.checkTile(row-1, col+1).team != team)
            possibleMoves.add(new PVector(col+1, row-1));
            
          //for white pawns, en passant capture is possible only if they are in the 4th row (index 3)
          if (row == 3) {
            toCheckPassant = board.checkTile(row, col+1);
            if (toCheckPassant instanceof Pawn && ((Pawn)toCheckPassant).enPassantVulnerable && toCheckPassant.team != team) {
              possibleMoves.add(new PVector(col+1, row-1, 1));
            }
          }
      }
      if (col > 0) {
        if (board.checkTile(row-1, col-1) != null && board.checkTile(row-1, col-1).team != team)
            possibleMoves.add(new PVector(col-1, row-1));
            
        if (row == 3) {
          toCheckPassant = board.checkTile(row, col-1);
            if (toCheckPassant instanceof Pawn && ((Pawn)toCheckPassant).enPassantVulnerable && toCheckPassant.team != team) {
              possibleMoves.add(new PVector(col-1, row-1, 1));
            }
        }
      }
      
    }
    if (isPinned() || board.inCheck[team])
      filterMovesForCheck();
  }
  
  //this override is specifically for pawns because en passant can only occur if the captured pawn has JUST moved two spaces
  //the en passant check ensures the capturing pawn is in the correct row, meaning any pawn's first move can be vulnerable to en passant without breaking
  @Override
  public void tryMoveTo(PVector tile) {
    //if possibleMoves contains the same tile but with the en passant mask, just assign the en passant mask to the input tile
    if (possibleMoves.contains(new PVector(tile.x, tile.y, 1)))
      tile.z = 1;
    if (possibleMoves.contains(tile)) { 
      //any successful move should make any previously vulnerable pawns no longer vulnerable to en passant
      for (int i = 0; i < board.pieces.size(); i++) {
          if (board.pieces.get(i) instanceof Pawn) {
            ((Pawn)board.pieces.get(i)).enPassantVulnerable = false;
          }
      }
      //make pawn vulnerable to en passant if it is the most recent move
      if (hasMoved == false) {
        enPassantVulnerable = true;
      } else
        enPassantVulnerable = false;
        
        hasMoved = true;
        
        //a tile z value of 1 indicates an en passant capture, the team mask will determine which side the pawn to capture is on
        if (tile.z == 1) {
          if (team == 0) {
            board.tryTakePiece(board.checkTile(new PVector(tile.x, tile.y-1)));
          } else if (team == 1) {
            board.tryTakePiece(board.checkTile(new PVector(tile.x, tile.y+1)));
          }
        } else {
          board.tryTakePiece(board.checkTile(tile));
        }
        row = (int)tile.y;
        col = (int)tile.x;
        //just assume any pawn reaching the end will be promoted to a queen
        if (row == 0 || row == 7) {
          board.pieces.add(new Queen(row, col, team));
          board.pieces.remove(this);
        }
        
        board.advanceTurn();
    } else
      println("Invalid Move");
  }
  
  public void show() {
    
    image(pawn[team], displayX, displayY);
    
  }
  
}
