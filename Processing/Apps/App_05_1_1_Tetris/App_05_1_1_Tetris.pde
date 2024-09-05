/*
 ******************************************************************************
 * Sketch  App_05_1_1_Tetris
 * Author  Freenove (http://www.freenove.com)
 * Date    2024/09/05
 ******************************************************************************
 * Brief
 *   This sketch is used to play Tetris game 
 ******************************************************************************
 * Copyright
 *   Copyright © Freenove (http://www.freenove.com)
 * License
 *   Creative Commons Attribution ShareAlike 3.0 
 *   (http://creativecommons.org/licenses/by-sa/3.0/legalcode)
 ******************************************************************************
 */
import freenove.processing.io.*;

static final int w = 10; // 4
static final int h = 25; // 60
static final int framesInSecond = 30;
static float gameInitSpeed = 10;
static float gameSpeed = 10;
static final int BlockScale = 15;
static final int sizeWidth = w*BlockScale+100;
static final int sizeHeight = h*BlockScale;


KeyPad keyUp = new KeyPad(23);
KeyPad keyDown = new KeyPad(17);
KeyPad keyLeft = new KeyPad(22);
KeyPad keyRight = new KeyPad(18);

boolean isPaused = false;
boolean keyAllow = true;
float updatingThreshold = 0;
Game game;

float recalculateUpdatingThreshold(float threshold) {
  return threshold + 1;
}
void settings() {
  size(sizeWidth, sizeHeight);
}
void setup() {
  game = new Game(w, h);
  generateRandomBlock(game);
  frameRate(framesInSecond);
  thread("keypadDetect");
}

void draw() {

  background(102); 
  Game newGame = game;

  updatingThreshold = recalculateUpdatingThreshold(updatingThreshold);
  if (updatingThreshold > gameSpeed) {
    if (isGameOver(newGame)) {
    } else if (isPaused) {
    } else {
      newGame = updateGameState(game);
    }
    updatingThreshold = 0;
  }
  drawGameState(newGame);
  if (!isGameOver(newGame)&& (isPaused)) {  //pause
    textSize(40);
    fill(0);
    text("Pause", BlockScale*2, 150);
    keyAllow = false;
  } else if (isGameOver(newGame)&& (isPaused)) {    //restart game
    game = new Game(w, h);
    generateRandomBlock(game);
    isPaused = false;
    keyAllow = false;
  } else if (isGameOver(newGame)) {    //game over
    textSize(40);
    fill(0);
    text("Game \nOver", BlockScale*2, 150);
    keyAllow = false;
  } else {        //playing
    keyAllow = true;
  }

  //level,score information
  pushMatrix();
  translate(w*BlockScale, 0);
  fill(255);
  textSize(20);
  text("Level\n"+game.level, 10, BlockScale*7);
  text("Scores\n"+game.score, 10, BlockScale*11);
  textSize(12);
  text("Freenove.com", 10, sizeHeight-30);
  drawNextBlock(game.nextBlock, BlockScale*2, BlockScale*1);
  popMatrix();
}

void keyPressed() {
  if (key == CODED) {
    if (keyAllow) {
      switch (keyCode) {
      case LEFT:  
        moveBlock(game, MoveLeft);  
        break;
      case RIGHT: 
        moveBlock(game, MoveRight); 
        break;
      case DOWN:  
        makeBlockFall(game);        
        break;
      case UP:    
        rotateBlock(game);          
        break;
      }
    }
  } else if (key == ' ') { // SPACE
    isPaused =! isPaused;
  }
}
void keypadDetect() {
  while (true) {
    keyUp.keyScan();
    keyDown.keyScan();
    keyLeft.keyScan();
    keyRight.keyScan();    
    transAction();
    try {
      Thread.sleep(10);
    }
    catch(Exception e) {
    }
  }
}
void transAction() {
  if ((keyValue !=  -1))
  {
    if (keyAllow) {
      if (keyValue == keyLeft.pin) {
        moveBlock(game, MoveLeft);
      } else if (keyValue == keyRight.pin) {
        moveBlock(game, MoveRight);
      } else if (keyValue == keyDown.pin) {
        makeBlockFall(game);
      } else if (keyValue == keyUp.pin) {
        rotateBlock(game);
      }
    }
    try {
      Thread.sleep(50);
    }
    catch(Exception e) {
    }
    keyValue =  -1;
  }
}
