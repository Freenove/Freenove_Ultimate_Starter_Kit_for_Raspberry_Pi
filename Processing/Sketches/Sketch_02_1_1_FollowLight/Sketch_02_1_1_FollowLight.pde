/*****************************************************
 * Filename    : Sketch_02_1_1_FollowLight
 * Description : Use the mouse to control the LEDGraph Bar 
 * auther      : www.freenove.com
 * modification: 2024/09/04
 *****************************************************/
import freenove.processing.io.*;

int leds[]={17, 18, 27, 22, 23, 24, 25, 2, 3, 8}; //define ledPins

void setup() {
  size(640, 360);  //display window size
  for (int i=0; i<10; i++) {  //set led Pins to output mode
    GPIO.pinMode(leds[i], GPIO.OUTPUT);
  }
  background(102);
  textAlign(CENTER);    //set the text centered
  textSize(40);        //set text size
  text("Follow Light", width / 2, 40);    //title
  textSize(16);
  text("www.freenove.com", width / 2, height - 20);    //site
}

void draw() {
  for (int i=0; i<10; i++) {    //draw 10 rectanglar box
    if (mouseX>(25+60*i)) {    //if the mouse cursor on the right of rectanglar box 
      fill(255, 0, 0);        //fill the rectanglar box in red color
      GPIO.digitalWrite(leds[i], GPIO.LOW);  //turn on the corresponding led
    } else {
      fill(255, 255, 255);  //else fill the rectanglar box in white color and turn off the led
      GPIO.digitalWrite(leds[i], GPIO.HIGH);  
    }
    rect(25+60*i, 90, 50, 180);    //draw a rectanglar box
  }
}