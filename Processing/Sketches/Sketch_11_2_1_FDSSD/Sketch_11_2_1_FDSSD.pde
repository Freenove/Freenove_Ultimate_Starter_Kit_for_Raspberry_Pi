/*****************************************************
 * Filename    : Sketch_11_2_1_FDSSD
 * Description : Control the 4-Digit 7-segment display by 74HC595
 * auther      : www.freenove.com
 * modification: 2024/09/04
 *****************************************************/
import freenove.processing.io.*;

int dataPin = 24;    //connect to the 74HC595
int latchPin = 23;
int clockPin = 18;
int[] digitPin = {17, 27, 22, 10};	//Connected to a common anode digital tube through the transistor
final int borderSize = 45;    //border size 
ProgressBar mBar;    //ProgressBar Object
IC74HC595 ic;      //IC74HC595 Object
boolean mMouse = false;    //determined whether a mouse click the ProgressBar
int index = 0;           // index of number
int lastMoveTime = 0;      //led last move time point
//encoding for character 0-9 of common anode SevenSegmentDisplay
final int[] numCode = {0xc0, 0xf9, 0xa4, 0xb0, 0x99, 0x92, 0x82, 0xf8, 0x80, 0x90};
PFont mFont;

void setup() {
  size(640, 360);
  for (int i =0; i<4; i++) {
    GPIO.pinMode(digitPin[i], GPIO.OUTPUT);
  }
  mBar = new ProgressBar(borderSize, height-borderSize, width-borderSize*2);
  mBar.setTitle("Speed");    //set the ProgressBar's title
  ic = new IC74HC595(dataPin, latchPin, clockPin);
  mFont = loadFont("DigifaceWide-100.vlw");  //create DigifaceWide font
  thread("displaySSD");
}

void draw() {
  background(255);
  titleAndSiteInfo();  //title and site information
  strokeWeight(4);    //border weight
  mBar.create();      //create the ProgressBar
  //control the speed of number change
  if (millis() - lastMoveTime > 50/(0.05+mBar.progress)) {
    lastMoveTime = millis();
    index++;
    if (index > 9999) {
      index = 0;
    }
  }
  showNum(index);    //show the number in dispaly window
}
void showNum(int num) {
  fill(0);
  textSize(100);
  textFont(mFont);    //digiface font
  textAlign(CENTER, CENTER);
  text(nf(num,4,0), width/2, height/2);
}

void displaySSD() {
  while (true) {
    display(index);
  }
}
void selectDigit(int digit) {
  GPIO.digitalWrite(digitPin[0], ((digit&0x08) == 0x08) ? GPIO.LOW : GPIO.HIGH);
  GPIO.digitalWrite(digitPin[1], ((digit&0x04) == 0x04) ? GPIO.LOW : GPIO.HIGH);
  GPIO.digitalWrite(digitPin[2], ((digit&0x02) == 0x02) ? GPIO.LOW : GPIO.HIGH);
  GPIO.digitalWrite(digitPin[3], ((digit&0x01) == 0x01) ? GPIO.LOW : GPIO.HIGH);
}
void display(int dec) {
  selectDigit(0x00);  
  ic.write(ic.MSBFIRST, numCode[dec%10]);  
  selectDigit(0x01);      //select the first, and display the single digit
  delay(1);               //display duration
  selectDigit(0x00);  
  ic.write(ic.MSBFIRST, numCode[dec%100/10]);
  selectDigit(0x02);      //select the second, and display the tens digit
  delay(1);
  selectDigit(0x00);  
  ic.write(ic.MSBFIRST, numCode[dec%1000/100]);
  selectDigit(0x04);      //select the third, and display the hundreds digit
  delay(1);
  selectDigit(0x00);  
  ic.write(ic.MSBFIRST, numCode[dec%10000/1000]);
  selectDigit(0x08);      //select the fourth, and display the thousands digit
  delay(1);
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
  textFont(createFont("", 100));  //default font
  textSize(40);        //set text size  
  text("4-Digit 7-Segment Display", width / 2, 40);    //title
  textSize(16);
  text("www.freenove.com", width / 2, height - 20);    //site
}