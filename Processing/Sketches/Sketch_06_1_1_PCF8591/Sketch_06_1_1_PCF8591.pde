/*****************************************************
 * Filename    : Sketch_06_1_1_PCF8591
 * Description : ADC and DAC of PCF8591
 * auther      : www.freenove.com
 * modification: 2016/08/20
 *****************************************************/
import processing.io.*;
//Create a object of class PCF8591
PCF8591 pcf = new PCF8591(0x48);
void setup() {
  size(640, 360);
}
void draw() {
  int adc = pcf.analogRead(0);    //Read the ADC value of channel 0
  float volt = adc*3.3/255.0;    //calculate the voltage
  pcf.analogWrite(adc);        //Write the DAC
  background(255);
  titleAndSiteInfo();
  
  fill(0);
  textAlign(CENTER);    //set the text centered
  textSize(30);
  text("ADC: "+nf(adc, 3, 0), width / 2, height/2+50);
  textSize(30);
  text("DAC: "+nf(adc, 3, 0), width / 2, height/2+100);
  textSize(40);        //set text size
  text("Voltage: "+nf(volt, 0, 2)+"V", width / 2, height/2);    //
}
void titleAndSiteInfo() {
  fill(0);
  textAlign(CENTER);    //set the text centered
  textSize(40);        //set text size
  text("ADC & DAC", width / 2, 40);    //title
  textSize(16);
  text("www.freenove.com", width / 2, height - 20);    //site
}