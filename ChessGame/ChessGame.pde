ChessBoard board;
Piece selectedPiece;
int tileSize;
PImage pawn[] = new PImage[2];
PImage rook[] = new PImage[2];
PImage knight[] = new PImage[2];
PImage bishop[] = new PImage[2];
PImage queen[] = new PImage[2];
PImage king[] = new PImage[2];

void setup() {

  tileSize = 75;

  size(600, 600);

  imageMode(CENTER);

  board = new ChessBoard();
  board.advanceTurn();

  pawn[0] = loadImage("Chess_plt60.png");
  pawn[1] = loadImage("Chess_pdt60.png");
  rook[0] = loadImage("Chess_rlt60.png");
  rook[1] = loadImage("Chess_rdt60.png");
  knight[0] = loadImage("Chess_nlt60.png");
  knight[1] = loadImage("Chess_ndt60.png");
  bishop[0] = loadImage("Chess_blt60.png");
  bishop[1] = loadImage("Chess_bdt60.png");
  queen[0] = loadImage("Chess_qlt60.png");
  queen[1] = loadImage("Chess_qdt60.png");
  king[0] = loadImage("Chess_klt60.png");
  king[1] = loadImage("Chess_kdt60.png");
  
}

void draw() {

  board.show();

}

void mousePressed() {
  for (int i = 0; i < board.pieces.size(); i++) {
    if (board.pieces.get(i).checkMouseClick() && board.turnCount % 2 == board.pieces.get(i).team) {
      board.pieces.get(i).calculateMoves();
      board.pieces.get(i).selected = true;
      selectedPiece = board.pieces.get(i);
    }
  }
}

void mouseReleased() {
  PVector tile = board.coordsToTile(mouseX, mouseY);
  //println(tile);
  try {
    selectedPiece.tryMoveTo(tile);
  } catch (NullPointerException e) {
    println("No Piece Selected");
  }
  for (Piece p : board.pieces) {
    p.selected = false;
    p.updateDisplayPos();
  }
  
  selectedPiece = null;
}
