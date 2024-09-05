/*****************************************************
 * Filename    : Sketch_12_1_1_LEDMatrix
 * Description : Control the LEDMatrix by 74HC595
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
int index = 0;           // index of number
//encoding for smile face
final int[] pic = {0x1c, 0x22, 0x51, 0x45, 0x45, 0x51, 0x22, 0x1c};
//encoding for character 0-9 of ledmatrix
final int[] numCode={  
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // " "
  0x00, 0x00, 0x3E, 0x41, 0x41, 0x3E, 0x00, 0x00, // "0"
  0x00, 0x00, 0x21, 0x7F, 0x01, 0x00, 0x00, 0x00, // "1"
  0x00, 0x00, 0x23, 0x45, 0x49, 0x31, 0x00, 0x00, // "2"
  0x00, 0x00, 0x22, 0x49, 0x49, 0x36, 0x00, 0x00, // "3"
  0x00, 0x00, 0x0E, 0x32, 0x7F, 0x02, 0x00, 0x00, // "4"
  0x00, 0x00, 0x79, 0x49, 0x49, 0x46, 0x00, 0x00, // "5"
  0x00, 0x00, 0x3E, 0x49, 0x49, 0x26, 0x00, 0x00, // "6"
  0x00, 0x00, 0x60, 0x47, 0x48, 0x70, 0x00, 0x00, // "7"
  0x00, 0x00, 0x36, 0x49, 0x49, 0x36, 0x00, 0x00, // "8"
  0x00, 0x00, 0x32, 0x49, 0x49, 0x3E, 0x00, 0x00, // "9"  
  0x00, 0x00, 0x3F, 0x44, 0x44, 0x3F, 0x00, 0x00, // "A"
  0x00, 0x00, 0x7F, 0x49, 0x49, 0x36, 0x00, 0x00, // "B"
  0x00, 0x00, 0x3E, 0x41, 0x41, 0x22, 0x00, 0x00, // "C"
  0x00, 0x00, 0x7F, 0x41, 0x41, 0x3E, 0x00, 0x00, // "D"
  0x00, 0x00, 0x7F, 0x49, 0x49, 0x41, 0x00, 0x00, // "E"
  0x00, 0x00, 0x7F, 0x48, 0x48, 0x40, 0x00, 0x00, // "F"
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, // " "
};
myThread t = new myThread();    //create a new thread for ledmatrix
void setup() {
  size(640, 360);
  mBar = new ProgressBar(borderSize, height-borderSize, width-borderSize*2);
  mBar.setTitle("Speed");    //set the ProgressBar's title
  ic = new IC74HC595(dataPin, latchPin, clockPin);
  t.start();    //thread start
}

void draw() {
  background(255);
  titleAndSiteInfo();  //title and site information
  strokeWeight(4);    //border weight
  mBar.create();      //create the ProgressBar
  displayNum(hex(index, 1));    //show the number in dispaly window
}
class myThread extends Thread {
  public void run() {
    while (true) {
      showMatrix();    //show smile picture 
      showNum();      //show the character "0-F"
    }
  }
}
void showMatrix() {
  for (int j=0; j<3000; j++) {    //picture show time
    int x=0x80;
    for (int i=0; i<8; i++) {    //display a frame picture
      GPIO.digitalWrite(latchPin, GPIO.LOW);
      ic.shiftOut(ic.MSBFIRST, pic[i]);
      ic.shiftOut(ic.MSBFIRST, ~x);
      GPIO.digitalWrite(latchPin, GPIO.HIGH);
      x>>=1;
    }
  }
}
void showNum() {
  for (int j=0; j<numCode.length-8; j++) { //where to start showing
    index = j/8;
    for (int k =0; k<300*(1.2-mBar.progress); k++) {    //speed
      int x=0x80;
      for (int i=0; i<8; i++) {    //display a frame picture
        GPIO.digitalWrite(latchPin, GPIO.LOW);
        ic.shiftOut(ic.MSBFIRST, numCode[j+i]);
        ic.shiftOut(ic.MSBFIRST, ~x);
        GPIO.digitalWrite(latchPin, GPIO.HIGH);
        x>>=1;
      }
    }
  }
}
void displayNum(String num) {
  fill(0);
  textSize(100);
  textAlign(CENTER, CENTER);
  text(num, width/2, height/2);
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
  text("LEDMatrix Display", width / 2, 40);    //title
  textSize(16);
  text("www.freenove.com", width / 2, height - 20);    //site
}
