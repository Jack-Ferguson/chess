class ChessBoard {
  
  boolean[] inCheck = new boolean[2];
  int rows = 8, cols = 8;
  int turnCount = -1;
  color lightColor = color(238, 238, 210), darkColor = color(118, 150, 86);
  ArrayList<Piece> pieces = new ArrayList<Piece>();
  King[] kings = new King[2];
  
  
  public ChessBoard() {
    pieces.add(new Rook(0, 0, 1));
    pieces.add(new Knight(0, 1, 1));
    pieces.add(new Bishop(0, 2, 1));
    pieces.add(new Queen(0, 3, 1));
    King whiteKing = new King(0, 4, 1);
    pieces.add(whiteKing);
    kings[1] = whiteKing;
    pieces.add(new Bishop(0, 5, 1));
    pieces.add(new Knight(0, 6, 1)); 
    pieces.add(new Rook(0, 7, 1));
      
    pieces.add(new Pawn(1, 0, 1));
    pieces.add(new Pawn(1, 1, 1));
    pieces.add(new Pawn(1, 2, 1)); 
    pieces.add(new Pawn(1, 3, 1));
    pieces.add(new Pawn(1, 4, 1)); 
    pieces.add(new Pawn(1, 5, 1));
    pieces.add(new Pawn(1, 6, 1));
    pieces.add(new Pawn(1, 7, 1));
      
      
      
      
      
    pieces.add(new Pawn(6, 0, 0));
    pieces.add(new Pawn(6, 1, 0));
    pieces.add(new Pawn(6, 2, 0));
    pieces.add(new Pawn(6, 3, 0));
    pieces.add(new Pawn(6, 4, 0));
    pieces.add(new Pawn(6, 5, 0));
    pieces.add(new Pawn(6, 6, 0));
    pieces.add(new Pawn(6, 7, 0));
    
    pieces.add(new Rook(7, 0, 0));
    pieces.add(new Knight(7, 1, 0));
    pieces.add(new Bishop(7, 2, 0));
    pieces.add(new Queen(7, 3, 0));
    King blackKing = new King(7, 4, 0);
    pieces.add(blackKing);
    kings[0] = blackKing;
    pieces.add(new Bishop(7, 5, 0));
    pieces.add(new Knight(7, 6, 0));
    pieces.add(new Rook(7, 7, 0));
    
    for (Piece p : pieces) {
      p.updateDisplayPos();
    }
  }
  
  
  //display the board and its pieces
  public void show() {
    
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        
        //checker pattern
        if (i % 2 == j % 2)
          fill(lightColor);
        else
          fill(darkColor);
          
          rect(j * tileSize, i * tileSize, tileSize, tileSize);
        
      }
    }
    
    for (int i = 0; i < pieces.size(); i++) {
      if (pieces.get(i).selected) {
        pieces.get(i).displayMoves();
        pieces.get(i).setDisplayPos(mouseX, mouseY);
      }
      pieces.get(i).show();
    }
  }
  
  //return the piece found at a given tile, null if no piece found
  public Piece checkTile(int row, int col) {
    
    for (int i = 0; i < pieces.size(); i++) {
      if (pieces.get(i).row == row && pieces.get(i).col == col) {
        return pieces.get(i);
      }
    }
    
    return null;
  }
  
  public Piece checkTile(PVector tile) {
    return checkTile((int)tile.y, (int)tile.x);
  }
  
  public void tryTakePiece(Piece p) {
    pieces.remove(p);
    pieces.trimToSize();
  }
  
  public PVector coordsToTile(int x, int y) {
    //integer division makes this easy
    return new PVector(x/tileSize, y/tileSize);
  }
  
  public void advanceTurn() {
    turnCount++;
    checkChecks();
    println("White King in Check: " + inCheck[0]);
    println("Black King in Check: " + inCheck[1]);
    switch(checkCheckmate()) {
      case 0:
        println("White Wins");
        break;
      case 1:
        println("Black Wins");
        break;
    }
  }
  
  public void checkChecks() {
    inCheck[0] = false;
    inCheck[1] = false;
    
    //this was originally done by just checking all possible moves to see if the King was targeted
    //but in any practical application it resulted in infintie recursion
    //for (int i = 0; i < pieces.size(); i++) {
    //  pieces.get(i).calculateMoves();
    //  for (int j = 0; j < pieces.get(i).possibleMoves.size(); j++) {
    //    if (pieces.get(i).possibleMoves.get(j).x == kings[0].col && pieces.get(i).possibleMoves.get(j).y == kings[0].row) {
    //      inCheck[0] = true;
    //    }
    //    if (pieces.get(i).possibleMoves.get(j).x == kings[1].col && pieces.get(i).possibleMoves.get(j).y == kings[1].row) {
    //      inCheck[1] = true;
    //    }
    //  }
    //}
    
    //a king is in check if any piece can attack it so check all piece attack angles
    
    //pawns
    if (kings[1].row > 0) {
      Piece toCheck = checkTile(kings[1].row-1, kings[1].col-1);
      if (toCheck != null && kings[1].col > 0 && toCheck.team != 1 && toCheck instanceof Pawn) {
        inCheck[1] = true;
        return;
      }
      toCheck = checkTile(kings[1].row-1, kings[1].col+1);
      if (toCheck != null && kings[1].col < 7 && toCheck.team != 1 && toCheck instanceof Pawn) {
        inCheck[1] = true;
        return;
      }
    }
    if (kings[0].row < 7) {
      Piece toCheck = checkTile(kings[0].row+1, kings[0].col-1);
      if (toCheck != null && kings[0].col > 0 && toCheck.team != 1 && toCheck instanceof Pawn) {
        inCheck[0] = true;
        return;
      }
      toCheck = checkTile(kings[0].row+1, kings[0].col+1);
      if (toCheck != null && kings[0].col < 7 && toCheck.team != 1 && toCheck instanceof Pawn) {
        inCheck[0] = true;
        return;
      }
    }
    
    //knights
    Piece toCheck;
    
    for (int i = 0; i < 2; i++) {
    
      if (kings[i].row - 2 >= 0) {
        toCheck = board.checkTile(kings[i].row-2, kings[i].col-1);
        if (toCheck != null && kings[i].col - 1 >= 0 && toCheck instanceof Knight && toCheck.team != i) {
          inCheck[i] = true;
          return;
        }
        toCheck = board.checkTile(kings[i].row-2, kings[i].col+1);
        if (toCheck != null && kings[i].col + 1 >= 0 && toCheck instanceof Knight && toCheck.team != i) {
          inCheck[i] = true;
          return;
        }
      }
      if (kings[i].row + 2 <= 7) {
        toCheck = board.checkTile(kings[i].row+2, kings[i].col-1);
        if (toCheck != null && kings[i].col - 1 >= 0 && toCheck instanceof Knight && toCheck.team != i) {
          inCheck[i] = true;
          return;
        }
        toCheck = board.checkTile(kings[i].row+2, kings[i].col+1);
        if (toCheck != null && kings[i].col + 1 >= 0 && toCheck instanceof Knight && toCheck.team != i) {
          inCheck[i] = true;
          return;
        }
      }
      if (kings[i].col - 2 >= 0) {
        toCheck = board.checkTile(kings[i].row-1, kings[i].col-2);
        if (toCheck != null && kings[i].row - 1 >= 0 && toCheck instanceof Knight && toCheck.team != i) {
          inCheck[i] = true;
          return;
        }
        toCheck = board.checkTile(kings[i].row+1, kings[i].col-2);
        if (toCheck != null && kings[i].col + 1 >= 0 && toCheck instanceof Knight && toCheck.team != i) {
          inCheck[i] = true;
          return;
        }
      }
      if (kings[i].col + 2 >= 0) {
        toCheck = board.checkTile(kings[i].row-1, kings[i].col+2);
        if (toCheck != null && kings[i].row - 1 >= 0 && toCheck instanceof Knight && toCheck.team != i) {
          inCheck[i] = true;
          return;
        }
        toCheck = board.checkTile(kings[i].row+1, kings[i].col+2);
        if (toCheck != null && kings[i].row + 1 >= 0 && toCheck instanceof Knight && toCheck.team != i) {
          inCheck[i] = true;
          return;
        }
      }
    }
    
    //bishops/queen diagonals
    for (int k = 0; k < 2; k++) {
      for (int i = -1; i <= 1; i += 2) {  
        for (int j = -1; j <= 1; j += 2) {
          
          int nextRow = kings[k].row;
          int nextCol = kings[k].col;
          
          while (nextRow >= 0 && nextRow <= 7 && nextCol >= 0 && nextRow <= 7) {
            nextRow += i;
            nextCol += j;
            if (board.checkTile(nextRow, nextCol) != null) {
              
              if (board.checkTile(nextRow, nextCol).team != k) {
                if (board.checkTile(nextRow, nextCol) instanceof Bishop || board.checkTile(nextRow, nextCol) instanceof Queen) {
                  inCheck[k] = true;
                  break;
                } else {
                  break;
                }
              } else {
                break;
              }
         
            }
          }
        }
      }
    }
    
    //rooks/queen straights
    for (int k = 0; k < 2; k++) {
    
      //vertical
      for (int i = -1; i <= 1; i += 2) {
        int nextRow = kings[k].row;
        while (nextRow >= 0 && nextRow <= 7) {
          nextRow += i;
          if (board.checkTile(nextRow, kings[k].col) != null) {
            if (board.checkTile(nextRow, kings[k].col).team != k) {
              if (board.checkTile(nextRow, kings[k].col) instanceof Bishop || board.checkTile(nextRow, kings[k].col) instanceof Queen) {
                inCheck[k] = true;
                break;
              } else {
                break;
              }
            } else {
              break;
            }
          }
        }
      }
      
      //horizontal
      for (int i = -1; i <= 1; i += 2) {
        int nextCol = kings[k].col;
        while (nextCol >= 0 && nextCol <= 7) {
          nextCol += i;
          if (board.checkTile(kings[k].row, nextCol) != null) {
            if (board.checkTile(kings[k].row, nextCol).team != k) {
              if (board.checkTile(kings[k].row, nextCol) instanceof Bishop || board.checkTile(kings[k].row, nextCol) instanceof Queen) {
                inCheck[k] = true;
                break;
              } else {
                break;
              }
            } else {
              break;
            }
          }
        }
      }
    }
  }
  
  //returns the team mask that is checkmated, -1 if no team
  public int checkCheckmate() {
    
    boolean whiteMove = false;
    boolean blackMove = false;
    
    for (int i = 0; i < board.pieces.size(); i++) {
      
      board.pieces.get(i).calculateMoves();
      if (board.pieces.get(i).team == 0) {
        if (board.pieces.get(i).possibleMoves.size() > 0)
          blackMove = true;
      } else if (board.pieces.get(i).team == 1) {
        if (board.pieces.get(i).possibleMoves.size() > 0)
          whiteMove = true;
      }
    }
    
    if (!whiteMove)
      return 0;
    if (!blackMove)
      return 1;
    return -1;
  }
  
}
