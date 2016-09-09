/*
 *******************************************************************************
 * Class   BasicClass
 * Author  Ethan Pan @ Freenove (http://www.freenove.com)
 * Date    2016/8/6
 *******************************************************************************
 * Brief
 *   These basic classes are for snake game.
 *******************************************************************************
 * Copyright
 *   Copyright © Freenove (http://www.freenove.com)
 * License
 *   Creative Commons Attribution ShareAlike 3.0 
 *   (http://creativecommons.org/licenses/by-sa/3.0/legalcode)
 *******************************************************************************
 */

/*
 * Brief  This class is used to save a point
 *****************************************************************************/
class Point
{
  int x = 0;
  int y = 0;

  Point() {
  }

  Point(int X, int Y)
  {
    x = X;
    y = Y;
  }
}

/*
 * Brief  This class is used to save a size
 *****************************************************************************/
class Size
{
  int width = 0;
  int height = 0;

  Size() {
  }

  Size(int Width, int Height)
  {
    width = Width;
    height = Height;
  }
}

/*
 * Brief  This enum is used to save a direction
 *****************************************************************************/
class Direction
{
  final static int UP = 0;
  final static int DOWN = 1;
  final static int LEFT = 2;
  final static int RIGHT = 3;
}

/*
 * Brief  This enum is used to save a gameState
 *****************************************************************************/
class GameState
{
  final static int WELCOME = 0;
  final static int PLAYING = 1;
  final static int WIN = 2;
  final static int LOSE = 3;
}

/*
 * Brief  This enum is used to save a grid map
 *****************************************************************************/
class GridMap
{
  Size mapSize;
  Size gripSize;
  int gridLength;
  int blockGap;
  int blockLength;

  GridMap() {
  }

  GridMap(Size MapSize, int GridLength, int BlockGap)
  {
    mapSize = MapSize;
    gridLength = GridLength;
    gripSize = new Size(mapSize.width / gridLength, mapSize.height / gridLength);
    blockGap = BlockGap;
    blockLength = gridLength - blockGap;
  }

  Point getGripPoint(Point mapPoint)
  {
    Point point = new Point();
    point.x = mapPoint.x / gridLength;
    point.y = mapPoint.y / gridLength;
    return point;
  }

  Point getMapPoint(Point gripPoint)
  {
    Point point = new Point();
    point.x = gripPoint.x * gridLength + gridLength / 2;
    point.y = gripPoint.y * gridLength + gridLength / 2;
    return point;
  }

  void adjustMapPoint(Point mapPoint)
  {
    mapPoint.x = mapPoint.x / gridLength * gridLength + gridLength / 2;
    mapPoint.y = mapPoint.y / gridLength * gridLength + gridLength / 2;
  }
}
