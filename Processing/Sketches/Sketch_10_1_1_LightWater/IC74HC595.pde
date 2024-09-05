/*****************************************************
 * Filename    : IC74HC595 
 * Description : class IC74HC595
 * auther      : www.freenove.com
 * modification: 2016/08/22
 *****************************************************/
import freenove.processing.io.*;

class IC74HC595 {
  final int LSBFIRST = 1;
  final int MSBFIRST = 2;
  int dataPin, latchPin, clockPin;
  public IC74HC595(int dPin, int lPin, int cPin) {
    dataPin = dPin;
    latchPin = lPin;
    clockPin = cPin;
    GPIO.pinMode(dataPin, GPIO.OUTPUT);
    GPIO.pinMode(latchPin, GPIO.OUTPUT);
    GPIO.pinMode(clockPin, GPIO.OUTPUT);
  }
  public void write(int order,int value) {
    constrain(order,1,2);
    GPIO.digitalWrite(latchPin,GPIO.LOW);
    shiftOut(order,value);
    GPIO.digitalWrite(latchPin,GPIO.HIGH);
  }
  private void shiftOut(int order, int val) {
    for (int i = 0; i<8; i++) {
      GPIO.digitalWrite(clockPin, GPIO.LOW);
      if (order == LSBFIRST) {
        GPIO.digitalWrite(dataPin, ((0x01&(val>>i))==0x01) ? GPIO.HIGH : GPIO.LOW);
      } else if (order == MSBFIRST) {
        GPIO.digitalWrite(dataPin, ((0x80&(val<<i))==0x80) ? GPIO.HIGH : GPIO.LOW);
      }
      GPIO.digitalWrite(clockPin, GPIO.HIGH);
    }
  }
}
