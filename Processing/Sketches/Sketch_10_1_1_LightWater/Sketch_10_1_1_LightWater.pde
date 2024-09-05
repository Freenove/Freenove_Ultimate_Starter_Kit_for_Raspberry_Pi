/*****************************************************
 * Filename    : Sketch_10_1_1_LightWater
 * Description : Control the LEDBar Graph by 74HC595
 * auther      : www.freenove.com
 * modification: 2024/09/04
 *****************************************************/
import freenove.processing.io.*;

int dataPin = 17;    //connect to the 74HC595
int latchPin = 27;
int clockPin = 22;
final int borderSize = 45;    //border size 
ProgressBar mBar;    //ProgressBar Object
IC74HC595 ic;      //IC74HC595 Object
boolean mMouse = false;    //determined whether a mouse click the ProgressBar
int leds = 0x01;           //number of led on
int lastMoveTime = 0;      //led last move time point
void setup() {
  size(640, 360);
  mBar = new ProgressBar(borderSize, height-borderSize, width-borderSize*2);
  mBar.setTitle("Speed");    //set the ProgressBar's title
  ic = new IC74HC595(dataPin, latchPin, clockPin);
}

void draw() {
  background(255);
  titleAndSiteInfo();  //title and site information
  strokeWeight(4);    //border weight
  mBar.create();      //create the ProgressBar
  //control the speed of lightwater
  if (millis() - lastMoveTime > 50/(0.05+mBar.progress)) {
    lastMoveTime = millis();
    leds<<=1;
    if (leds == 0x100)
      leds = 0x01;
  }
  ic.write(ic.LSBFIRST, leds);    //write 74HC595
  
  stroke(0);
  strokeWeight(1);
  for (int i=0; i<10; i++) {    //draw 10 rectanglar box
    if (leds == (1<<i)) {    //
      fill(255, 0, 0);        //fill the rectanglar box in red color
    } else {
      fill(255, 255, 255);  //else fill the rectanglar box in white color
    }
    rect(25+60*i, 90, 50, 180);    //draw a rectanglar box
  }
}

void mousePressed() {
  if ( (mouseY< mBar.y+5) && (mouseY>mBar.y-5) ) {
    mMouse = true;    //the mouse click the progressBar
  }
}
void mouseReleased() {
  mMouse  = false;
}
void mouseDragged() {
  int a = constrain(mouseX, borderSize, width - borderSize);
  float t = map(a, borderSize, width - borderSize, 0.0, 1.0);
  if (mMouse) {
    mBar.setProgress(t);
  }
}
void titleAndSiteInfo() {
  fill(0);
  textAlign(CENTER);    //set the text centered
  textSize(40);        //set text size
  text("LightWater", width / 2, 40);    //title
  textSize(16);
  text("www.freenove.com", width / 2, height - 20);    //site
}