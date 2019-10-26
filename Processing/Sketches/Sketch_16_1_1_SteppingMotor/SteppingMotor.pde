/*****************************************************
 * Filename    : SteppingMotor
 * Description : class SteppingMotor
 * auther      : www.freenove.com
 * modification: 2016/08/31
 *****************************************************/

class SteppingMotor {

  final int[] CWStep = {0x01, 0x02, 0x04, 0x08};  //4 phase 4 steps power supply CW
  final int[] CCWStep = {0x08, 0x04, 0x02, 0x01};   //4 phase 4 steps power supply CCW
  final int CW = 1, CCW=2;
  int[] motorPins;    //define pins connected to four phase ABCD of stepping motor
  boolean isDisable = false;
  int dir= CCW, ms=1, steps=-1;
  myThread mt = new myThread();
  Thread t = new Thread(mt);
  public SteppingMotor(int[] mPins) {
    motorPins = mPins;
    for (int i=0; i<4; i++) {
      GPIO.pinMode(motorPins[i], GPIO.OUTPUT);
    }
  }
  public void motorStart() {
    t.start();
  }
  //continuos rotation function,the parameter steps spectfies the rotation steps,
  //every four step is a steps(period) 
  public void moveSteps(int idir, int ims, int isteps) {
    dir= idir; 
    ms=ims; 
    steps=isteps;
    motorRestart();
  }
  //used to motor stop rotating
  public void motorStop() {
    isDisable = true;
    for (int i=0; i<4; i++) {
      GPIO.digitalWrite(motorPins[i], GPIO.LOW);
    }
  }
  public void motorRestart() {
    isDisable = false;
    synchronized(t) {
      try {
        t.notifyAll();
      }
      catch(Exception e) {
        println(e);
      }
    }
  }
  //It's same to moveOnePeriod()
  public void moveFourStep(int idir, int ims) {
    moveOnePeriod(idir, ims);
  }
  //drive the stepping motor to take four steps,four steps is a period
  public void moveOnePeriod(int idir, int ims) {
    if (isDisable) {
      println("Motor is disabled! Please enbale it!"); 
      motorStop();
      return;
    }
    for (int j=0; j<4; j++) {  //cycle according to power supply order
      for (int i=0; i<4; i++) {    //assign to each pin ,a total of 4 pins
        if (idir == CW) {    //CW
          GPIO.digitalWrite(motorPins[i], (CWStep[j] == (1<<i) ? GPIO.HIGH :GPIO.LOW));
        } else if (idir == CCW) {          //CCW
          GPIO.digitalWrite(motorPins[i], (CCWStep[j] == (1<<i) ? GPIO.HIGH :GPIO.LOW));
        }
        if (ims<1) {  //the delay can't be less 3ms,
          ims = 1;    //otherwise it will exceed speed limit of the motor
        }
        //delay(ms);
        try {
          Thread.sleep(ims);
        }
        catch(Exception e) {
          println(e);
        }
      }
    }
  }
  class myThread implements Runnable {
    public void run() {

      while (true) {
        synchronized(t) {
          if (isDisable) {
            try {
              motorStop();
              t.wait();
            }
            catch(Exception e) {
              println("--->run:"+e);
            }
          }
        }
        if (--steps>-1) {              
          moveOnePeriod(dir, ms);
        } else {
          try {
            motorStop();
          }
          catch(Exception e) {
            println("--->run:"+e);
          }
        }
      }
    }
  }
}