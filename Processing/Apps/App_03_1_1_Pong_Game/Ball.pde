/*
 *******************************************************************************
 * Class   Ball
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
 * Brief  This class is for ball
 *****************************************************************************/
class Ball {
  Point position = new Point();
  Speed speed = new Speed();
  int radius;
  float initialSpeed = 1;

  Ball(int Radius)
  {
    radius = Radius;
    reset();
  }

  void updata()
  {
    position.x += speed.x;
    position.y += speed.y;

    if (position.y < radius || position.y > height - radius)
      speed.y = -speed.y;
  }

  void reset()
  {
    position.x = width / 2;
    position.y = height / 2;
    speed.x = (random(-1, 1) > 0 ? 1 : -1) * initialSpeed;
    speed.y = 0;
  }

  void display()
  {
    ellipseMode(CENTER);
    noStroke();
    fill(255, 255, 255);
    ellipse(position.x, position.y, 2 * radius, 2 * radius);
  }
}