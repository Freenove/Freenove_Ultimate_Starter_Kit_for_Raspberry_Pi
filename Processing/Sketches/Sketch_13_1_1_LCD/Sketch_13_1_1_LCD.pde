/*****************************************************
 * Filename    : Sketch_13_1_1_LCD
 * Description : Use the I2C-LCD1602 display the string
 * auther      : www.freenove.com
 * modification: 2024/09/04
 *****************************************************/
import freenove.processing.io.*;

//Create a object of class PCF8574
PCF8574 pcf = new PCF8574(0x27);
Freenove_LCD1602 lcd;  //Create a lcd object
String time = "";    
String date = "";
void setup() {
  size(640, 360);
  lcd = new Freenove_LCD1602(pcf);
  frameRate(2);    //set display window frame rate for 2 HZ
}
void draw() {
  background(255);
  titleAndSiteInfo();
  //get current time
  time = nf(hour(), 2, 0) + ":" + nf(minute(), 2, 0) + ":" + nf(second(), 2, 0);  
  //get current date 
  date = nf(day(), 2, 0)+"/"+nf(month(), 2, 0)+"/"+nf(year(), 2, 0);
  lcd.position(4, 0);  //show time on the lcd display
  lcd.puts(time);
  lcd.position(3, 1);  //show date on the lcd display
  lcd.puts(date);
  showTime(time, date);  //show time/date on the display window
}
void showTime(String time, String date) {
  fill(0);
  textAlign(CENTER, CENTER);
  textSize(50);
  text(time, width/2, height/2);
  textSize(30);
  text(date, width/2, height/2+50);
}
void titleAndSiteInfo() {
  fill(0);
  textAlign(CENTER);    //set the text centered
  textSize(40);        //set text size
  text("I2C-LCD1602", width / 2, 40);    //title
  textSize(16);
  text("www.freenove.com", width / 2, height - 20);    //site
}