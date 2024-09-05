/*****************************************************
 * Filename    : Sketch_15_1_1_Relay
 * Description : Control the Motor by Relay
 * auther      : www.freenove.com
 * modification: 2024/09/04
 *****************************************************/
import freenove.processing.io.*;

int relayPin = 17;
int buttonPin = 18;
SingleKey skey = new SingleKey(buttonPin);
boolean relayState = false;
BUTTON btn;
float rotaSpeed = 0.02 * PI;  //virtual fan's rotating speed, 
float rotaPosition = 0;  //motor position
void setup() {
  size(640, 360);
  GPIO.pinMode(relayPin, GPIO.OUTPUT);
  btn = new BUTTON(90, height - 90, 50, 30);   //define the button
  btn.setBgColor(0, 255, 0);  //set button color
  btn.setText("OFF");        //set button text
}

void draw() {
  background(255);
  titleAndSiteInfo();  //title and site information

  skey.keyScan();    //key scan
  if (skey.isPressed) {  //key is pressed?
    relayAction();
  }
  textAlign(RIGHT, CENTER);
  text("RelayState: ", btn.x, btn.y+btn.h/2);
  btn.create();      //create the button
  if (relayState) {
    rotaPosition += rotaSpeed;
  }
  if (rotaPosition >= 2*PI) {
    rotaPosition = 0;
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
void relayAction() {
  if (relayState) {
    GPIO.digitalWrite(relayPin, GPIO.LOW);
    relayState = false;
    btn.setBgColor(255, 0, 0);
    btn.setText("OFF");
  } else {
    GPIO.digitalWrite(relayPin, GPIO.HIGH);
    relayState = true;
    btn.setBgColor(0, 255, 0);
    btn.setText("ON");
  }
}
void mousePressed() {
  if ((mouseY< btn.y+btn.h) && (mouseY>btn.y) 
    && (mouseX< btn.x+btn.w) && (mouseX>btn.x)) { // the mouse click the button
    relayAction();
  }
}

void titleAndSiteInfo() {
  fill(0);
  textAlign(CENTER);    //set the text centered
  textSize(40);        //set text size
  text("Relay & Motor", width / 2, 40);    //title
  textSize(16);
  text("www.freenove.com", width / 2, height - 20);    //site
}