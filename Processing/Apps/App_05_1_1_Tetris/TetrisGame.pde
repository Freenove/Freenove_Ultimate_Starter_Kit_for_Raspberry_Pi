
class Game {
  int wellWidth;
  int wellHeight;
  int score;
  int level;
  boolean[][] blocks;
  Block fallingBlock;
  Block nextBlock;
  boolean erasingNeeded;
  
  Game (int w, int h) {
    wellWidth = w;
    wellHeight = h;
    fallingBlock = null;
    erasingNeeded = false;
    
    blocks = new boolean[w][h];
    for (int x = 0; x < w; x++)
      for (int y = 0; y < h; y++)
        blocks[x][y] = false;
  }
};