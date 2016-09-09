static final int MoveLeft = -1;
static final int MoveRight = 1;

boolean isBlockStuck(Game game)
{
  Block block = game.fallingBlock;  
  if (block == null)
    return false;

  boolean[][] blocks = game.blocks;
  BlockPart[] parts = block.parts;

  boolean stuck = false;
  for (int i = 0; (i < BlockPartsCount) && (!stuck); i++) {
    if (parts[i].xPos >= 0 && parts[i].yPos >= 0)
      stuck = stuck
        || parts[i].yPos + 1 >= game.wellHeight
        || blocks[parts[i].xPos][parts[i].yPos + 1];
  }

  return stuck;
}

void fixateBlock(Game game) {
  Block block = game.fallingBlock;  
  if (block == null)
    return;

  BlockPart[] parts = block.parts;

  for (int i = 0; i < BlockPartsCount; i++) {
    if (parts[i].yPos >= 0)
      game.blocks[parts[i].xPos][parts[i].yPos] = true;
  }

  game.fallingBlock = null;
}

void eraseFilledLines(Game game) {
  int eraseRows=0;
  for (int y = game.wellHeight - 1; y >= 0; ) {

    boolean erasable = true;
    for (int x = 0; x < game.wellWidth; x++)
      erasable = erasable && game.blocks[x][y];

    if (erasable) {
      eraseRows +=1;
      // Move blocks down
      for (int y2 = y - 1; y2 >= 0; y2--)
        for (int x = 0; x < game.wellWidth; x++)
          game.blocks[x][y2 + 1] = game.blocks[x][y2];

      // Top level needs to be cleared.
      for (int x = 0; x < game.wellWidth; x++)
        game.blocks[x][0] = false;
    } else {
      y--;
    }
  }
  if (eraseRows != 0) {
    game.score+=10*(eraseRows*2-1);
    eraseRows=0;
    game.level = game.score / 200;
    if (game.level <0) {
      game.level = 0;
    } else if (game.level > 9) {
      game.level = 9;
    }
    gameSpeed = (gameInitSpeed-game.level);
  }
  game.erasingNeeded = false;
}

void enableErasing(Game game) {
  game.erasingNeeded = true;
}

Block randomBlock() {
  int blockType = int(random(0, BlocksCount));
  int blockDirection = int(random(0, DirectionsCount));
  Block block = new Block(blockType, 0, 0, blockDirection);
  block.parts = getBlockParts(block);
  return block;
}

void generateRandomBlock(Game game) {
  int blockType = int(random(0, BlocksCount));
  int blockDirection = int(random(0, DirectionsCount));
  //int xPos = int(random(0, game.wellWidth));
  int xPos = game.wellWidth/2-1;
  //game.fallingBlock = createBlock(blockType, blockDirection, xPos, -1, game.wellWidth);
  if (game.nextBlock == null) {
    game.fallingBlock = createBlock(blockType, blockDirection, xPos, -1, game.wellWidth);
    game.nextBlock = randomBlock();
  } else {    
    game.fallingBlock = game.nextBlock;
    game.fallingBlock.xPos = game.wellWidth/2-1;
    arrangeNewBlock(game.fallingBlock, game.wellWidth); 
    game.nextBlock = randomBlock();
  }
}

boolean isBlockMovingPossible(Game game, int moveDirection) {
  Block block = game.fallingBlock;
  if (block == null)
    return false;

  boolean possible = true;
  for (int i = 0; i < BlockPartsCount; i++) {

    int desiredXPos = block.parts[i].xPos + moveDirection;
    int desiredYPos = block.parts[i].yPos;

    possible = possible 
      && (moveDirection == MoveLeft ? desiredXPos >= 0 : desiredXPos < game.wellWidth);

    if ((desiredYPos >= 0) && (desiredYPos < game.wellHeight))
      possible = possible && !(game.blocks[desiredXPos][desiredYPos]);
  }
  return possible;
}

void moveBlock(Game game, int moveDirection) {
  if (isBlockMovingPossible(game, moveDirection))
    moveBlockHorizontal(game.fallingBlock, moveDirection);
}

void makeBlockFall(Game game) {
  if (isBlockStuck(game)) {
    fixateBlock(game);
    enableErasing(game);
    generateRandomBlock(game);
  } else {
    makeBlockFall(game.fallingBlock);
  }
}

void rotateBlock(Game game) {
  Block block = game.fallingBlock;
  Block rotated = createBlock(block.type, rotateDirection(block.direction), block.xPos, block.yPos, game.wellWidth);
  game.fallingBlock = rotated;
}

Game updateGameState(Game game) {
  Game currentGame = game;
  if (currentGame.erasingNeeded) {
    eraseFilledLines(currentGame);
  } else if (currentGame.fallingBlock != null) {
    makeBlockFall(currentGame);
  }
  return currentGame;
}

boolean isGameOver(Game game) {
  for (int i = 0; i < game.wellWidth; i++)
    if (game.blocks[i][0])
      return true;
  return false;
}