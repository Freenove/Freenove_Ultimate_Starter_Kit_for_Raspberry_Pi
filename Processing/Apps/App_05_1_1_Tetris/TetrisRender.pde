

void drawWellGrid(int w, int h)
{
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      stroke(0xFFBBBB00);
      fill(0xFF00FF00);
      rect(x*BlockScale, y*BlockScale, BlockScale, BlockScale);
    }
  }
}

void drawBlocks(int w, int h, boolean[][] blocks) {
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      if (blocks[x][y]) {
        //fill(0xFF000000 | (int)random(0xFFFFFF)); // For fun.
        fill(0xFF0000FF);
        rect(x*BlockScale, y*BlockScale, BlockScale, BlockScale);
      }
    }
  }
}

void drawFallingBlock(Block block)
{
  if (block == null)
    return;

  BlockPart[] parts = block.parts;

  stroke(0x00BB0000);
  fill(0xFFFF0000);

  for (int i = 0; i < BlockPartsCount; i++)
    rect(parts[i].xPos*BlockScale, parts[i].yPos*BlockScale, BlockScale, BlockScale);
}

void drawNextBlock(Block block,int x,int y) {
  if (block == null)
    return;

  BlockPart[] parts = block.parts;
  stroke(255,0,0);
  fill(255,255,0);
  for (int i = 0; i < BlockPartsCount; i++)
    rect(parts[i].xPos*BlockScale+x, parts[i].yPos*BlockScale+y, BlockScale, BlockScale);
}

void drawGameState(Game game)
{
  drawWellGrid(game.wellWidth, game.wellHeight);
  drawBlocks(game.wellWidth, game.wellHeight, game.blocks);
  drawFallingBlock(game.fallingBlock);
}