

BlockPart[] getBlockParts(Block block) {
  switch(block.type) {
    case I: return getIBlockParts(block.direction);
    case O: return getOBlockParts();
    case T: return getTBlockParts(block.direction);
    case S: return getSBlockParts(block.direction);
    case Z: return getZBlockParts(block.direction);
    case J: return getJBlockParts(block.direction);
    case L: return getLBlockParts(block.direction);
  }
  
  return getIBlockParts(block.direction);
}

void makeBlockFall(Block block) {
  block.yPos += 1;
  for (int i = 0; i < BlockPartsCount; i++) {
   block.parts[i].yPos += 1;
  }
}

// We assume, only unsigned int is possible in block parts[i].xPos.
void arrangeNewBlock(Block block, int wellWidth) {
  
  int leftXShift = 0;
  int maxYShift = 0;
  for (int i = 0; i < BlockPartsCount; i++) {
    
    maxYShift = max (block.parts[i].yPos, maxYShift);
    
    block.parts[i].xPos = block.parts[i].xPos + block.xPos;
    block.parts[i].yPos = block.parts[i].yPos + block.yPos;
   
    if (block.parts[i].xPos >= wellWidth)
      leftXShift = max(leftXShift, block.parts[i].xPos + 1 - wellWidth);
  }
  
  for (int i = 0; i < BlockPartsCount; i++) {
    block.parts[i].xPos = block.parts[i].xPos - leftXShift;
    block.parts[i].yPos = block.parts[i].yPos - (1 + maxYShift);
  }
}

Block createBlock(int type, int direction, int xPos, int yPos, int wellWidth) {
  Block block = new Block(type, xPos, yPos, direction);
  block.parts = getBlockParts(block);
  arrangeNewBlock(block, wellWidth); 
  return block;
}

void moveBlockHorizontal(Block block, int distance) {
  for (int i = 0; i < BlockPartsCount; i++) {
    block.parts[i].xPos = block.parts[i].xPos + distance;
  }  
  block.xPos += distance;
}

int rotateDirection(int prevDirection) {
  if (prevDirection < DirectionsCount - 1)
    return prevDirection + 1;
  return 0;
}