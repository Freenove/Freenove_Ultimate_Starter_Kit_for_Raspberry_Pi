/*
 ******************************************************************************
 * Sketch  App_03_1_1_Pong_Game
 * Author  Freenove (http://www.freenove.com)
 * Date    2024/09/05
 ******************************************************************************
 * Brief
 *   This sketch is used to play pong game
 ******************************************************************************
 * Copyright
 *   Copyright © Freenove (http://www.freenove.com)
 * License
 *   Creative Commons Attribution ShareAlike 3.0 
 *   (http://creativecommons.org/licenses/by-sa/3.0/legalcode)
 ******************************************************************************
 */
import freenove.processing.io.*;

ADCDevice adc = new ADCDevice();

int winScore = 3;
float acceleration = 0.5;
float deviate = 1;
/* Private variables ---------------------------------------------------------*/

Ball ball;
Paddle lPaddle, rPaddle;
int gameState = GameState.WELCOME;
int lScore, rScore;

void setup() {
  size(640, 360);
    if (adc.detectI2C(0x48)) {
    adc = new PCF8591(0x48);
  } else if (adc.detectI2C(0x4b)) {
    adc = new ADS7830(0x4b);
  } else {
    println("Not found ADC Module!");
    System.exit(-1);
  }
  background(102);
  textAlign(CENTER, CENTER);
  textSize(64);
  text("Starting...", width / 2, (height - 40) / 2);
  textSize(16);
  text("www.freenove.com", width / 2, height - 20);

  ball = new Ball(10);
  lPaddle = new Paddle(new Size(12, 80), 12);
  rPaddle = new Paddle(new Size(12, 80), width - 12);

}

void draw() {
  int[] analogs = new int[2];
  analogs[0] = adc.analogRead(0);
  analogs[1] = adc.analogRead(1);
  if (analogs !=null)
  {
    lPaddle.position.y = analogs[0] * height /255;
    rPaddle.position.y = analogs[1] * height /255;
  }

  background(102);
  if (gameState == GameState.WELCOME)
  {
    showGUI();
    lPaddle.display();
    rPaddle.display();
    showInfo("Pong Game");
  } 
  else if (gameState == GameState.PLAYING)
  {  
    ball.updata();
    calculateGame();
    showGUI();
    ball.display();
    lPaddle.display();
    rPaddle.display();
  } 
  else if (gameState == GameState.PLAYER1WIN)
  {
    showGUI();
    lPaddle.display();
    rPaddle.display();
    showInfo("Player 1 win!");
  } 
  else if (gameState == GameState.PLAYER2WIN)
  {
    showGUI();
    lPaddle.display();
    rPaddle.display();
    showInfo("Player 2 win!");
  }

}

void showInfo(String info)
{
  rectMode(CENTER);
  stroke(0, 0, 0);
  fill(0, 0, 0, 50);
  rect(width / 2, height / 2, width / 2, height / 3);
  fill(255, 255, 255);
  textSize(24);
  textAlign(CENTER, CENTER);
  text(info, width / 2, height / 2 - 24);
  text("Press Space to start", width / 2, height / 2 + 24);
}

void calculateGame()
{
  if (ball.position.x - ball.radius < lPaddle.position.x + lPaddle.size.width / 2)
  {
    if (ball.position.y < lPaddle.position.y - lPaddle.size.height / 2 - ball.radius||
      ball.position.y > lPaddle.position.y + lPaddle.size.height / 2 + ball.radius)
    {
      rScore++;
      ball.reset();
    } 
    else
    {
      ball.speed.getSpeed();
      ball.speed.speed += acceleration;
      ball.speed.getXYSpeed((ball.position.y - lPaddle.position.y) / (lPaddle.size.height / 2) * deviate);
    }
  }

  if (ball.position.x + ball.radius > rPaddle.position.x - rPaddle.size.width / 2)
  {
    if (ball.position.y < rPaddle.position.y - rPaddle.size.height / 2 - ball.radius||
      ball.position.y > rPaddle.position.y + rPaddle.size.height / 2 + ball.radius)
    {
      lScore++;
      ball.reset();
    } 
    else
    {
      ball.speed.getSpeed();
      ball.speed.speed += acceleration;
      ball.speed.getXYSpeed((ball.position.y - rPaddle.position.y) / (rPaddle.size.height / 2) * deviate);
      ball.speed.x = - ball.speed.x;
    }
  }

  if (lScore == winScore)
    gameState = GameState.PLAYER1WIN;
  if (rScore == winScore)
    gameState = GameState.PLAYER2WIN;
}

void showGUI()
{
  fill(255, 255, 255);
  textSize(16);
  textAlign(CENTER, CENTER);
  text("Press Enter to visit www.freenove.com", width / 4, height - 20);
  text("Press Space to restart game", width * 3 / 4, height - 20);
  text("Player 1: " + lScore, width / 4, 20);
  text("Player 2: " + rScore, width * 3 / 4, 20);

  rectMode(CENTER);
  noStroke();
  fill(144, 144, 144);
  rect(width / 2, height / 2, 4, height);
}

void keyPressed() {
  if (key == '\n' || key == '\r')
  {
    link("http://www.freenove.com");
  } 
  else if (key == ' ')
  {
    lScore = 0;
    rScore = 0;
    ball.reset();
    gameState = GameState.PLAYING;
  }
}
