/*****************************************************
 * Filename    : Sketch_07_1_1_SoftLight
 * Description : control the brightness of led through a potentiometer
 * auther      : www.freenove.com
 * modification: 2016/08/20
 *****************************************************/
import processing.io.*;

int ledPin = 17;    //led
//Create a object of class PCF8591
PCF8591 pcf = new PCF8591(0x48);
SOFTPWM p = new SOFTPWM(ledPin, 0, 100);
void setup() {
  size(640, 360);
}
void draw() {
  int adc = pcf.analogRead(0);    //Read the ADC value of channel 0
  float volt = adc*3.3/255.0;    //calculate the voltage
  float dt = adc/255.0;
  p.softPwmWrite((int)(dt*100));  //output the pwm
  background(255);
  titleAndSiteInfo();

  fill(255, 255-dt*255, 255-dt*255);  //cycle
  noStroke();  //no border
  ellipse(width/2, height/2, 100, 100);

  fill(0);
  textAlign(CENTER);    //set the text centered
  textSize(30);
  text("ADC: "+nf(adc, 3, 0), width / 2, height/2+130);
  text("Voltage: "+nf(volt, 0, 2)+"V", width / 2, height/2+100);    //
}
void titleAndSiteInfo() {
  fill(0);
  textAlign(CENTER);    //set the text centered
  textSize(40);        //set text size
  text("SoftLight", width / 2, 40);    //title
  textSize(16);
  text("www.freenove.com", width / 2, height - 20);    //site
}