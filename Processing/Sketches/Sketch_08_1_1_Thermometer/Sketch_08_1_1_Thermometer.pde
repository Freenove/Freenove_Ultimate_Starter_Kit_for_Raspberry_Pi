/*****************************************************
 * Filename    : Sketch_08_1_1_Thermometer
 * Description : A DIY Thermometer
 * auther      : www.freenove.com
 * modification: 2016/08/21
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
  float tempK,tempC,Rt;        //
  Rt = 10*volt / (3.3-volt);    //calculate the resistance value of thermistor
  tempK = 1/(1/(273.15+25) + log(Rt/10)/3950);  //calaulate temperature(Kelvin)
  tempC = tempK - 273.15;    //calaulate temperature(Celsius)
  
  background(255);
  titleAndSiteInfo();
  
  fill(0);
  textAlign(CENTER);    //set the text centered
  textSize(30);
  text("ADC: "+nf(adc, 0, 0), width / 2, height/2+50);
  textSize(30);
  text("voltage: "+nf(volt, 0, 2)+"V", width / 2, height/2+100);
  textSize(40);        //set text size
  text("Temperature: "+nf(tempC, 0, 2)+" C", width / 2, height/2);    //
}
void titleAndSiteInfo() {
  fill(0);
  textAlign(CENTER);    //set the text centered
  textSize(40);        //set text size
  text("Thermometer", width / 2, 40);    //title
  textSize(16);
  text("www.freenove.com", width / 2, height - 20);    //site
}