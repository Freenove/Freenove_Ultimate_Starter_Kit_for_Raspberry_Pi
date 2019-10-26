/*****************************************************
 * Filename    : Sketch_14_1_1_Joystick
 * Description : Display the position of the joystick
 * auther      : www.freenove.com
 * modification: 2016/08/29
 *****************************************************/
import processing.io.*;
//Create a object of class PCF8591
PCF8591 pcf = new PCF8591(0x48);
int cx, cy, cd, cr;    //define the center point,side length & half.

void setup() {
  size(640, 360);
  cx = width/2;    //center of the display window
  cy = height/2;    //
  cd = (int)(height/1.5);
  cr = cd /2;
}
void draw() {
  int x=0, y=0, z=0;
  x = pcf.analogRead(2);  //read the ADC of joystick
  y = pcf.analogRead(1);  //
  z = pcf.analogRead(0);
  background(102);
  titleAndSiteInfo();
  fill(0);
  textSize(20);
  textAlign(LEFT,TOP);
  text("X:"+x+"\nY:"+y+"\nZ:"+z,10,10);

  fill(255);    //wall color
  rect(cx-cr, cy-cr, cd, cd);    
  fill(constrain(z, 255, 0));    //joysitck color
  ellipse(map(x, 0, 255, cx-cr, cx+cr), map(y, 0, 255, cy-cr, cy+cr), 50, 50);
}
void titleAndSiteInfo() {
  fill(0);
  textAlign(CENTER);    //set the text centered
  textSize(40);        //set text size
  text("Joystick", width / 2, 40);    //title
  textSize(16);
  text("www.freenove.com", width / 2, height - 20);    //site
}