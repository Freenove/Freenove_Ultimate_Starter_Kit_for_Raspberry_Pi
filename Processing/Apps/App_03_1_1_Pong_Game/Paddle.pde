/*
 *******************************************************************************
 * Class   Paddle
 * Author  Ethan Pan @ Freenove (http://www.freenove.com)
 * Date    2016/7/22
 *******************************************************************************
 * Brief
 *   This class is for pong game.
 *******************************************************************************
 * Copyright
 *   Copyright © Freenove (http://www.freenove.com)
 * License
 *   Creative Commons Attribution ShareAlike 3.0 
 *   (http://creativecommons.org/licenses/by-sa/3.0/legalcode)
 *******************************************************************************
 */

/*
 * Brief  This class is for paddle
 *****************************************************************************/
class Paddle {
  Point position = new Point();
  Size size;

  Paddle(Size paddleSize, int xPosition)
  {
    size = paddleSize;
    position.x = xPosition;
    position.y = height / 2;
  }

  void moveTo(int yPosition)
  {
    position.y = yPosition;
  }

  void display()
  {
    rectMode(CENTER);
    noStroke();
    fill(255, 255, 255);
    rect(position.x, position.y, size.width, size.height);
  }
}