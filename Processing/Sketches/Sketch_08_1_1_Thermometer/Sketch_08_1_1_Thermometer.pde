/*****************************************************
 * Filename    : Sketch_08_1_1_Thermometer
 * Description : A DIY Thermometer
 * auther      : www.freenove.com
 * modification: 2024/09/04
 *****************************************************/
import freenove.processing.io.*;

//Create a object of class ADCDevice
ADCDevice adc = new ADCDevice();
void setup() {
  size(640, 360);
  if (adc.detectI2C(0x48)) {
    adc = new PCF8591(0x48);
  } else if (adc.detectI2C(0x4b)) {
    adc = new ADS7830(0x4b);
  } else {
    println("Not found ADC Module!");
    System.exit(-1);
  }
}
void draw() {
  int adcValue = adc.analogRead(0);    //Read the ADC value of channel 0
  float volt = adcValue*3.3/255.0;    //calculate the voltage
  float tempK,tempC,Rt;        //
  Rt = 10*volt / (3.3-volt);    //calculate the resistance value of thermistor
  tempK = 1/(1/(273.15+25) + log(Rt/10)/3950);  //calaulate temperature(Kelvin)
  tempC = tempK - 273.15;    //calaulate temperature(Celsius)
  
  background(255);
  titleAndSiteInfo();
  
  fill(0);
  textAlign(CENTER);    //set the text centered
  textSize(30);
  text("ADC: "+nf(adcValue, 0, 0), width / 2, height/2+50);
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
