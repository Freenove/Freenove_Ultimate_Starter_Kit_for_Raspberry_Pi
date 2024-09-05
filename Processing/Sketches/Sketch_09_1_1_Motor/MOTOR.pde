/*****************************************************
 * Filename    : MOTOR
 * Description : class MOTOR
 * auther      : www.freenove.com
 * modification: 2016/08/22
 *****************************************************/

import freenove.processing.io.*;

class MOTOR {
  int mPin1, mPin2, enPin;
  SOFTPWM p;
  public int dir;
  final public int CW = 1, CCW = 2, STOP = 3;
  public MOTOR(int pin1, int pin2, int enablePin) {
    mPin1 = pin1;
    mPin2 = pin2;
    enPin = enablePin;
    GPIO.pinMode(mPin1, GPIO.OUTPUT);
    GPIO.pinMode(mPin2, GPIO.OUTPUT);
    p = new SOFTPWM(enPin, 0, 100);
    dir = 0;
  }
  public void start(int dir, int speed) {
    switch(dir) {
    case CW:
      GPIO.digitalWrite(mPin1, GPIO.HIGH);
      GPIO.digitalWrite(mPin2, GPIO.LOW);
      break;
    case CCW:
      GPIO.digitalWrite(mPin1, GPIO.LOW);
      GPIO.digitalWrite(mPin2, GPIO.HIGH);
      break;
    case STOP:
      GPIO.digitalWrite(mPin1, GPIO.LOW);
      GPIO.digitalWrite(mPin2, GPIO.LOW);
      break;
    default:
      GPIO.digitalWrite(mPin1, GPIO.LOW);
      GPIO.digitalWrite(mPin2, GPIO.LOW);
      break;
    }
    constrain(speed, 0, 100);
    p.softPwmWrite(speed);
  }
}
