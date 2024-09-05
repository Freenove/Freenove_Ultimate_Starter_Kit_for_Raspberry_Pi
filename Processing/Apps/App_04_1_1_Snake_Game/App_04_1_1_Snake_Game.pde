/*
 ******************************************************************************
 * Sketch  App_04_1_1_Snake_Game
 * Author  Freenove (http://www.freenove.com)
 * Date    2024/09/05
 ******************************************************************************
 * Brief
 *   This sketch is used to play snake game 
 ******************************************************************************
 * Copyright
 *   Copyright © Freenove (http://www.freenove.com)
 * License
 *   Creative Commons Attribution ShareAlike 3.0 
 *   (http://creativecommons.org/licenses/by-sa/3.0/legalcode)
 ******************************************************************************
 */
import freenove.processing.io.*;
int threshold = 400;

KeyPad keyUp = new KeyPad(23);
KeyPad keyDown = new KeyPad(17);
KeyPad keyLeft = new KeyPad(22);
KeyPad keyRight = new KeyPad(18);

Snake snake;
Food food;

void setup() {
  print("Starting ... \n");
  size(640, 360);
  background(102);
  textAlign(CENTER, CENTER);
  textSize(64);
  text("Starting...", width / 2, (height - 40) / 2);
  textSize(16);
  text("www.freenove.com", width / 2, height - 20);

  food = new Food(new GridMap(new Size(width, height), 20, 2));
  snake = new Snake(new GridMap(new Size(width, height), 20, 2));
  thread("keypadDetect");
}

void draw() {
  background(102);
  if (snake.gameState == GameState.WELCOME)
  {
    rectMode(CENTER);
    stroke(0, 0, 0);
    fill(0, 0, 0, 50);
    rect(width / 2, height / 2, width / 2, height / 3);
    fill(255, 255, 255);
    textSize(24);
    textAlign(CENTER, CENTER);
    text("Snake Game", width / 2, height / 2 - 24);
    text("Press Space to start", width / 2, height / 2 + 24);
  } else if (snake.gameState == GameState.PLAYING)
  {

    if (snake.body[0].x == food.position.x && snake.body[0].y == food.position.y)
    {
      snake.grow();
      food.generate(snake.body, snake.length);
      snake.speedUp();
    }
    snake.step();
    showGame();
  } else if (snake.gameState == GameState.LOSE)
  {
    showGame();
    rectMode(CENTER);
    stroke(0, 0, 0);
    fill(0, 0, 0, 50);
    rect(width / 2, height / 2, width / 2, height / 3);
    fill(255, 255, 255);
    textSize(24);
    textAlign(CENTER, CENTER);
    text("You lose!", width / 2, height / 2 - 24);
    text("Press Space to start", width / 2, height / 2 + 24);
  }
}

void showGame()
{
  snake.display();
  food.display();

  fill(255, 255, 255);
  textSize(16);
  textAlign(LEFT, CENTER);
  text("Press Enter to visit www.freenove.com", 20, height - 20);
  textAlign(RIGHT, CENTER);
  text("Press Space to restart game", width - 20, height - 20);
  textAlign(LEFT, CENTER);
  text("Score: " + (snake.length - 3), 20, 20);
  textAlign(RIGHT, CENTER);
  text("Speed: " + ((snake.initSpeed - snake.speed) / 5 + 1), width - 20, 20);
}

void keyPressed() {
  if ((key == CODED) || (keyValue !=  -1))
  {
    if ((keyCode == UP) ||((keyValue ==  keyUp.pin)))
    {
      if (snake.direction != Direction.DOWN)
        snake.nextDirection = Direction.UP;
    } else if ((keyCode == DOWN)||((keyValue ==  keyDown.pin))) {
      if (snake.direction != Direction.UP)
        snake.nextDirection = Direction.DOWN;
    } else if ((keyCode == LEFT)||((keyValue ==  keyLeft.pin))) {
      if (snake.direction != Direction.RIGHT)
        snake.nextDirection = Direction.LEFT;
    } else if ((keyCode == RIGHT)||((keyValue ==  keyRight.pin))) {
      if (snake.direction != Direction.LEFT)
        snake.nextDirection = Direction.RIGHT;
    }
    //keyValue = -1;
    println(keyValue);
  } else
  {
    if (key == '\n' || key == '\r')
    {
      link("http://www.freenove.com");
    } else if (key == ' ')
    {
      snake.reset();
      food.generate(snake.body, snake.length);
      snake.gameState = GameState.PLAYING;
    }
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
    if (keyValue ==  keyUp.pin)
    {
      if (snake.direction != Direction.DOWN)
        snake.nextDirection = Direction.UP;
    } else if (((keyValue ==  keyDown.pin))) {
      if (snake.direction != Direction.UP)
        snake.nextDirection = Direction.DOWN;
    } else if (((keyValue ==  keyLeft.pin))) {
      if (snake.direction != Direction.RIGHT)
        snake.nextDirection = Direction.LEFT;
    } else if (((keyValue ==  keyRight.pin))) {
      if (snake.direction != Direction.LEFT)
        snake.nextDirection = Direction.RIGHT;
    }
    keyValue = -1;
  }
}
