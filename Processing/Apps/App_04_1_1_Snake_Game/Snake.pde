/*
 *******************************************************************************
 * Class   Snake
 * Author  Ethan Pan @ Freenove (http://www.freenove.com)
 * Date    2016/8/6
 *******************************************************************************
 * Brief
 *   This class is for snake game.
 *******************************************************************************
 * Copyright
 *   Copyright © Freenove (http://www.freenove.com)
 * License
 *   Creative Commons Attribution ShareAlike 3.0 
 *   (http://creativecommons.org/licenses/by-sa/3.0/legalcode)
 *******************************************************************************
 */

/*
 * Brief  This class is for snake
 *****************************************************************************/
class Snake {
  GridMap map;

  int length;
  final int initSpeed = 150;
  int speed;
  int stepCounter;
  int direction; 
  int nextDirection; 
  Point[] body;

  int gameState = GameState.WELCOME;

  Snake(GridMap gridMap)
  {
    map = gridMap;
    body = new Point[map.gripSize.height * map.gripSize.width];
    reset();
  }

  void reset()
  {
    length = 3;
    speed = initSpeed ;
    direction = Direction.UP; 
    nextDirection = Direction.UP; 
    body[0] = new Point(map.gripSize.width / 2, map.gripSize.height / 2);
    body[1] = new Point(body[0].x, body[0].y + 1);
    body[2] = new Point(body[0].x, body[0].y + 2);
  }

  void display()
  {
    rectMode(CENTER);
    noStroke();
    fill(227, 118, 12);
    for (int i = 0; i < length; i++)
    {
      Point mapPosition = map.getMapPoint(body[i]);
      rect(mapPosition.x, mapPosition.y, map.blockLength, map.blockLength);
    }
  }

  void speedUp()
  {
    if (speed > 0)
      speed--;
  }

  void grow()
  {
    length++;
  }

  void step()
  {
    if (stepCounter++ % (speed / 5) != 0)
      return;

    for (int i = length; i > 0; i--)
      body[i] = body[i - 1];

    direction = nextDirection;
    if (direction == Direction.UP)
    {
      body[0] = new Point(body[1].x, body[1].y - 1);
      if (body[0].y < 0)
        gameState = GameState.LOSE;
    } 
    else if (direction == Direction.DOWN)
    {
      body[0] = new Point(body[1].x, body[1].y + 1);
      if (body[0].y > map.gripSize.height - 1)
        gameState = GameState.LOSE;
    } 
    else if (direction == Direction.LEFT)
    {
      body[0] = new Point(body[1].x - 1, body[1].y);
      if (body[0].x < 0)
        gameState = GameState.LOSE;
    } 
    else if (direction == Direction.RIGHT)
    {
      body[0] = new Point(body[1].x + 1, body[1].y);
      if (body[0].x > map.gripSize.width - 1)
        gameState = GameState.LOSE;
    }

    for (int i = 1; i < length; i++)
    {
      if (body[0].x == body[i].x && body[0].y == body[i].y)
        gameState = GameState.LOSE;
    }
  }
}