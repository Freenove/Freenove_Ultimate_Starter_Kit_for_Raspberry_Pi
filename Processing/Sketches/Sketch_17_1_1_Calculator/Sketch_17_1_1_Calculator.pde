/*****************************************************
 * Filename    : Sketch_17_1_1_MatrixKeypad
 * Description : Make a calculator using the keypad
 * auther      : www.freenove.com
 * modification: 2024/09/04
 *****************************************************/
import freenove.processing.io.*;

final static char[]  keys = {  //key code
  '1', '2', '3', '+', 
  '4', '5', '6', '-', 
  '7', '8', '9', '*', 
  'C', '0', '=', '/'  };
final int[] rowsPins = {18, 23, 24, 25};  //Connect to the row pinouts of the keypad
final int[] colsPins = {10, 22, 27, 17};  //Connect to the column pinouts of the keypad
Keypad kp = new Keypad(keys, rowsPins, colsPins);    //class Object
Calculator cc = new Calculator(kp);    //class Object
void setup() {
  size(640, 360);
}
void draw() { 
  background(102);
  titleAndSiteInfo();  //Tile and site information
  cc.process();    //Get key and processing
  drawDisplay(cc.contentStr);  //Draw display area and content
  drawKeypad(width-kpSize, 70);    //draw virtual Keypad
}
void titleAndSiteInfo() {
  fill(0);
  textAlign(CENTER);    //set the text centered
  textSize(40);        //set text size
  text("Calculator", width / 4, 200);    //title
  textSize(20);
  text("www.freenove.com", width / 4, height - 20);    //site
}