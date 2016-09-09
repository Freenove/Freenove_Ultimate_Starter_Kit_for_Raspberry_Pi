/*
 ******************************************************************************
 * class  Keypad
 * Author  Freenove (http://www.freenove.com)
 * Date    2016/08/27
 ******************************************************************************
 * Brief
 *   This class is used to get a single button key value (GPIO numbering)
 ******************************************************************************
 * Copyright
 *   Copyright © Freenove (http://www.freenove.com)
 * License
 *   Creative Commons Attribution ShareAlike 3.0 
 *   (http://creativecommons.org/licenses/by-sa/3.0/legalcode)
 ******************************************************************************
 */
int keyValue = -1;
class KeyPad
{
  final int IDLE = 0, 
    PRESSED = 1, 
    HOLD = 2, 
    RELEASED = 3;
  int btnState = IDLE;
  long holdTimer = 0;
  final int holdTime = 500;
  boolean changeState = false;
  int lastButtonIOState = GPIO.HIGH;
  int buttonIOState=GPIO.HIGH;
  int nowButtonState;
  boolean buttonChanged = false;
  int lastChangeTime;
  int decounceTime = 50;
  int pin;
  public KeyPad(int Pin) {
    pin = Pin;
    GPIO.pinMode(pin, GPIO.INPUT);
  }

  void keyScan() {
    nowButtonState =GPIO.digitalRead(pin);
    if (nowButtonState != lastButtonIOState) {
      lastChangeTime = millis();
    }
    if (millis() - lastChangeTime > decounceTime) {
      if (buttonIOState != nowButtonState) {
        buttonIOState = nowButtonState;
        changeState = true;
        if (buttonIOState == GPIO.LOW) {
          //btnState = PRESSED;
          //keyValue = pin;
          //println("Key is Pressed !! ");
        } else if (buttonIOState == GPIO.HIGH) {
          //println("Key is Released !! ");
        }
      }
    }
    switch(btnState) {
    case IDLE:
      if (changeState) {
        changeState = false;
        btnState = PRESSED;
        holdTimer = millis();
        keyValue = pin;
      }
      break;
    case PRESSED:
      if (millis() - holdTimer > holdTime) {
        btnState = HOLD;
        keyValue = pin;
      }else if(changeState){
        changeState = false;
        btnState = RELEASED;
      }
      break;
    case HOLD:
      keyValue = pin;
      if (changeState) {
        changeState = false;
        btnState = RELEASED;
      }
      break;
    case RELEASED:
      keyValue = -1;
      btnState = IDLE;
      break;
    }
    lastButtonIOState = nowButtonState;
  }
}