/*
 *******************************************************************************
 * Class   Food
 * Author  Ethan Pan @ Freenove (http://www.freenove.com)
 * Date    2016/7/20
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
 * Brief  This class is for food
 *****************************************************************************/
class Food {
  Point position;
  GridMap map;

  Food(GridMap gridMap)
  {
    map = gridMap;
  }

  void generate(Point[] exclude, int length)
  {
    Point point = new Point();
    boolean isGenerating = true;

    while (isGenerating)
    {
      point.x = (int)random(0, map.gripSize.width - 1);
      point.y = (int)random(0, map.gripSize.height - 1);

      isGenerating = false;
      if (exclude != null)
      {
        for (int i = 0; i < length; i++)
        {
          if (point.x == exclude[i].x && point.y == exclude[i].y)
            isGenerating = true;
        }
      }
    }
    position = point;
  }

  void display()
  {
    rectMode(CENTER);
    noStroke();
    fill(0, 255, 0);
    Point mapPosition = map.getMapPoint(position);
    rect(mapPosition.x, mapPosition.y, map.blockLength, map.blockLength);
  }
}