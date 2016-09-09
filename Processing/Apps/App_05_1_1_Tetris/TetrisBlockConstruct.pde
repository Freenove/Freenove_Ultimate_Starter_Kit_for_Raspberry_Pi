BlockPart[] getIBlockParts(int direction) {
  BlockPart[] parts = new BlockPart[BlockPartsCount];
  if ((direction == East) || (direction == West)) {
     parts[0] = new BlockPart(0,0);
     parts[1] = new BlockPart(1,0);
     parts[2] = new BlockPart(2,0);
     parts[3] = new BlockPart(3,0); 
  } else {
     parts[0] = new BlockPart(0,0);
     parts[1] = new BlockPart(0,1);
     parts[2] = new BlockPart(0,2);
     parts[3] = new BlockPart(0,3); 
  }
  return parts;
}

BlockPart[] getOBlockParts() {
  BlockPart[] parts = new BlockPart[BlockPartsCount];
  parts[0] = new BlockPart(0,0);
  parts[1] = new BlockPart(1,0);
  parts[2] = new BlockPart(0,1);
  parts[3] = new BlockPart(1,1); 
  return parts;
}

BlockPart[] getTBlockParts(int direction) {
  BlockPart[] parts = new BlockPart[BlockPartsCount];
  switch (direction) {
    case East:
         parts[0] = new BlockPart(0,0);
         parts[1] = new BlockPart(1,0);
         parts[2] = new BlockPart(2,0);
         parts[3] = new BlockPart(1,1);
         break;
    case South:
         parts[0] = new BlockPart(1,0);
         parts[1] = new BlockPart(0,1);
         parts[2] = new BlockPart(1,1);
         parts[3] = new BlockPart(1,2);
         break;
    case West:
         parts[0] = new BlockPart(1,0);
         parts[1] = new BlockPart(0,1);
         parts[2] = new BlockPart(1,1);
         parts[3] = new BlockPart(2,1);
         break;
    case North:
         parts[0] = new BlockPart(0,0);
         parts[1] = new BlockPart(0,1);
         parts[2] = new BlockPart(1,1);
         parts[3] = new BlockPart(0,2);
         break;
  }
  return parts;
}

BlockPart[] getSBlockParts(int direction) {
  BlockPart[] parts = new BlockPart[BlockPartsCount];
  switch (direction) {
    case East:
    case West:
         parts[0] = new BlockPart(0,0);
         parts[1] = new BlockPart(0,1);
         parts[2] = new BlockPart(1,1);
         parts[3] = new BlockPart(1,2);
         break;
    case South:
    case North:
         parts[0] = new BlockPart(0,1);
         parts[1] = new BlockPart(1,0);
         parts[2] = new BlockPart(1,1);
         parts[3] = new BlockPart(2,0);
         break;
  }
  return parts;
}

BlockPart[] getZBlockParts(int direction) {
  BlockPart[] parts = new BlockPart[BlockPartsCount];
  switch (direction) {
    case East:
    case West:
         parts[0] = new BlockPart(1,0);
         parts[1] = new BlockPart(0,1);
         parts[2] = new BlockPart(1,1);
         parts[3] = new BlockPart(0,2);
         break;
    case South:
    case North:
         parts[0] = new BlockPart(0,0);
         parts[1] = new BlockPart(1,0);
         parts[2] = new BlockPart(1,1);
         parts[3] = new BlockPart(2,1);
         break;
  }
  return parts;
}

BlockPart[] getJBlockParts(int direction) {
  BlockPart[] parts = new BlockPart[BlockPartsCount];
  switch (direction) {
    case East:
         parts[0] = new BlockPart(1,0);
         parts[1] = new BlockPart(1,1);
         parts[2] = new BlockPart(0,2);
         parts[3] = new BlockPart(1,2);
         break;
    case South:
         parts[0] = new BlockPart(0,0);
         parts[1] = new BlockPart(0,1);
         parts[2] = new BlockPart(1,1);
         parts[3] = new BlockPart(2,1);
         break;
    case West:
         parts[0] = new BlockPart(0,0);
         parts[1] = new BlockPart(1,0);
         parts[2] = new BlockPart(0,1);
         parts[3] = new BlockPart(0,2);
         break;
    case North:
         parts[0] = new BlockPart(0,0);
         parts[1] = new BlockPart(1,0);
         parts[2] = new BlockPart(2,0);
         parts[3] = new BlockPart(2,1);
         break;
  }
  return parts;
}

BlockPart[] getLBlockParts(int direction) {
  BlockPart[] parts = new BlockPart[BlockPartsCount];
  switch (direction) {
    case East:
         parts[0] = new BlockPart(0,0);
         parts[1] = new BlockPart(0,1);
         parts[2] = new BlockPart(0,2);
         parts[3] = new BlockPart(1,2);
         break;
    case South:
         parts[0] = new BlockPart(0,0);
         parts[1] = new BlockPart(0,1);
         parts[2] = new BlockPart(1,0);
         parts[3] = new BlockPart(2,0);
         break;
    case West:
         parts[0] = new BlockPart(0,0);
         parts[1] = new BlockPart(1,0);
         parts[2] = new BlockPart(1,1);
         parts[3] = new BlockPart(1,2);
         break;
    case North:
         parts[0] = new BlockPart(0,1);
         parts[1] = new BlockPart(1,1);
         parts[2] = new BlockPart(2,0);
         parts[3] = new BlockPart(2,1);
         break;
  }
  return parts;
}