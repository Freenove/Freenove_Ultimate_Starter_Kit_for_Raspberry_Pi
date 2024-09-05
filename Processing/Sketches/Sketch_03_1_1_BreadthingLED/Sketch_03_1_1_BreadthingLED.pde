/*****************************************************
 * Filename    : Sketch_03_1_1_BreathingLED
 * Description : Using PWM control LED brightness 
 * auther      : www.freenove.com
 * modification: 2024/09/04
 *****************************************************/
import freenove.processing.io.*;

int ledPin = 17;    //led Pin
int borderSize = 40;  //
float t = 0.0;      //progress percent
float tStep = 0.004;    // speed
SOFTPWM p = new SOFTPWM(ledPin, 10, 100);    //Create a PWM pin,initialize the duty cycle and period
void setup() {
  size(640, 360);  //display window size
  strokeWeight(4);  //stroke Weight
}

void draw() {
  // Show static value when mouse is pressed, animate otherwise
  if (mousePressed) {
    int a = constrain(mouseX, borderSize, width - borderSize);
    t = map(a, borderSize, width - borderSize, 0.0, 1.0);
  } else {
    t += tStep;
    if (t > 1.0) t = 0.0;
  }
  p.softPwmWrite((int)(t*100)); //wirte the duty cycle according to t
  background(255);  //A white background
  titleAndSiteInfo();  //title and Site infomation

  fill(255, 255-t*255, 255-t*255);  //cycle
  ellipse(width/2, height/2, 100, 100);
  
  pushMatrix();
  translate(borderSize, height - 45);
  int barLength = width - 2*borderSize;
  
  barBgStyle();  //progressbar bg
  line(0, 0, barLength, 0);    
  line(barLength, -5, barLength, 5);

  barStyle();  //progressbar 
  line(0, -5, 0, 5);
  line(0, 0, t*barLength, 0);

  barLabelStyle();    //progressbar label
  text("progress : "+nf(t*100,2,2),barLength/2,-25);
  popMatrix();
}

void titleAndSiteInfo() {
  fill(0);
  textAlign(CENTER);    //set the text centered
  textSize(40);        //set text size
  text("Breathing Light", width / 2, 40);    //title
  textSize(16);
  text("www.freenove.com", width / 2, height - 20);    //site
}
void barBgStyle() {
  stroke(220);
  noFill();
}

void barStyle() {
  stroke(50);
  noFill();
}

void barLabelStyle() {
  noStroke();
  fill(120);
}