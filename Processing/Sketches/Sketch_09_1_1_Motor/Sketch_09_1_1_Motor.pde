/*****************************************************
 * Filename    : Sketch_09_1_1_Motor
 * Description : Control speed and direction of the motor
 * auther      : www.freenove.com
 * modification: 2024/09/04
 *****************************************************/
import freenove.processing.io.*;

int motorPin1 = 17;    //connect to the L293D
int motorPin2 = 27;
int enablePin = 22;
final int borderSize = 45;    //border size 
//MOTOR Object 
MOTOR motor = new MOTOR(motorPin1, motorPin2, enablePin);
ProgressBar mBar;    //ProgressBar Object
boolean mMouse = false;    //determined whether a mouse click the ProgressBar
BUTTON btn;    //BUTTON Object, For controlling the direction of motor 
int motorDir = motor.CW;    //motor direction
float rotaSpeed = 0, rotaPosition = 0;  //motor speed
void setup() {
  size(640, 360);
  mBar = new ProgressBar(borderSize, height-borderSize, width-borderSize*2);
  mBar.setTitle("Duty Cycle");    //set the ProgressBar's title
  btn = new BUTTON(45, height - 90, 50, 30);   //define the button
  btn.setBgColor(0, 255, 0);  //set button color
  btn.setText("CW");        //set button text
}

void draw() {
  background(255);
  titleAndSiteInfo();  //title and site information
  strokeWeight(4);    //border weight
  mBar.create();      //create the ProgressBar
  motor.start(motorDir, (int)(mBar.progress*100));  //control the motor starts to rotate
  btn.create();      //create the button
  rotaSpeed = mBar.progress * 0.02 * PI;  //virtual fan's rotating speed
  if (motorDir == motor.CW) {
    rotaPosition += rotaSpeed;
    if (rotaPosition >= 2*PI) {
      rotaPosition = 0;
    }
  } else {
    rotaPosition -= rotaSpeed;
    if (rotaPosition <= -2*PI) {
      rotaPosition = 0;
    }
  }
  drawFan(rotaPosition);    //show the virtual fan in Display window 
}
//Draw a clover fan according to the stating angle
void drawFan(float angle) {    
  constrain(angle, 0, 2*PI);
  fill(0);
  for (int i=0; i<3; i++) {
    arc(width/2, height/2, 200, 200, 2*i*PI/3+angle, (2*i+0.3)*PI/3+angle, PIE);
  }
  fill(0);
  ellipse(width/2, height/2, 30, 30);
  fill(128);
  ellipse(width/2, height/2, 15, 15);
}

void mousePressed() {
  if ( (mouseY< mBar.y+5) && (mouseY>mBar.y-5) ) {
    mMouse = true;    //the mouse click the progressBar
  } else if ((mouseY< btn.y+btn.h) && (mouseY>btn.y) 
    && (mouseX< btn.x+btn.w) && (mouseX>btn.x)) { // the mouse click the button
    if (motorDir == motor.CW) {    //change the direction of rotation of motor
      motorDir = motor.CCW;
      btn.setBgColor(255, 0, 0);
      btn.setText("CCW");
    } else if (motorDir == motor.CCW) {
      motorDir = motor.CW;
      btn.setBgColor(0, 255, 0);
      btn.setText("CW");
    }
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
  text("Motor", width / 2, 40);    //title
  textSize(16);
  text("www.freenove.com", width / 2, height - 20);    //site
}