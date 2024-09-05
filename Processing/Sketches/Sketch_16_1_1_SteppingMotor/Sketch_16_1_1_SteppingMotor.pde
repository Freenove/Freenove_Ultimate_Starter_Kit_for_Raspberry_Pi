/*****************************************************
 * Filename    : Sketch_16_1_1_SteppingMotor
 * Description : Control the stepping motor
 * auther      : www.freenove.com
 * modification: 2024/09/04
 *****************************************************/
import freenove.processing.io.*;

int[] pins = {18, 23, 24, 25};    //connect to motor phase A,B,C,D pins 
BUTTON btn;    //BUTTON Object, For controlling the direction of motor 
SteppingMotor m = new SteppingMotor(pins);    
float rotaSpeed = 0, rotaPosition = 0;  //motor speed
boolean isMotorRun = true;    //motor run/stop flag

void setup() {
  size(640, 360);
  btn = new BUTTON(45, height - 90, 50, 30);   //define the button
  btn.setBgColor(0, 255, 0);  //set button color
  btn.setText("RUN");        //set button text
  m.motorStart();            //start motor thread
  rotaSpeed = 0.002 * PI;  //virtual fan's rotating speed
}

void draw() {
  background(255);
  titleAndSiteInfo();  //title and site information
  btn.create();      //create the button
  if (isMotorRun) {   //motor is runnig
    fill(0);
    textAlign(LEFT,BOTTOM);
    textSize(20);
    if (m.dir == m.CW) {
      text("CW",btn.x,btn.y);    //text "CW "
      rotaPosition+=rotaSpeed;    
      if (rotaPosition>=TWO_PI) {
        rotaPosition = 0;
      }
    } else if (m.dir == m.CCW) {
      text("CCW",btn.x,btn.y);  //text "CCW"
      rotaPosition-=rotaSpeed;
      if (rotaPosition<=0) {
        rotaPosition = TWO_PI;
      }
    }
  }
  if (m.steps<=0) {      //if motor has stopped,
    if (m.dir == m.CCW) {        //change the direction ,restart.
      m.moveSteps(m.CW, 1, 512);    
    } else if (m.dir == m.CW) {     
      m.moveSteps(m.CCW, 1, 512);
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

void exit() {
  m.motorStop();
  println("exit");
  System.exit(0);
}
void mousePressed() {
  if ((mouseY< btn.y+btn.h) && (mouseY>btn.y) 
    && (mouseX< btn.x+btn.w) && (mouseX>btn.x)) { // the mouse click the button
    if (isMotorRun) {
      isMotorRun = false;
      btn.setBgColor(255, 0, 0);
      btn.setText("STOP");
      m.motorStop();
    } else {
      isMotorRun = true;
      btn.setBgColor(0, 255, 0);
      btn.setText("RUN");
      m.motorRestart();
    }
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