/******************************************************************************* //<>//
 * Sketch  App_02_1_1_Ellipse
 * Author Freenove (http://www.freenove.com)
 * Date    2024/09/05
 ******************************************************************************
 * Brief
 *   This sketch is used to control a 2D ellipse 
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
void setup()
{
  size(360, 360);
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
}

void draw()
{
  int[] analogs = new int[2];
  analogs[0] = adc.analogRead(0);
  analogs[1] = adc.analogRead(1);
  if (analogs != null)
  {
    background(102);
    drawEllipse(analogs[0], analogs[1]);
  }
}

void drawEllipse(int x, int y)
{
  int maxDiameter = 280;

  fill(255, 255, 255);
  textAlign(CENTER, CENTER);
  textSize(16);
  text("Press Enter to visit www.freenove.com", width / 2, height - 20);
  text("X: " + x, width / 2 - 30, 20);
  text("Y: " + y, width / 2 + 30, 20);

  x = x * maxDiameter / 255;
  y = y * maxDiameter / 255;
  fill(227, 118, 12);
  ellipse(width / 2, height / 2, x, y);
}

void keyPressed() 
{
  if (key == '\n' || key == '\r')
  {
    link("http://www.freenove.com");
  }
}
