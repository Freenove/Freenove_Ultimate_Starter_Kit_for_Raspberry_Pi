import freenove.processing.io.*;

class SOFTPWM {
  public int pin=-1;
  public long range = -1;
  private Thread t = new Thread(new myThread());
  //private Thread t = new Thread(); 
  public long marks = 0;    //high level time of period
  public long space = 0;    //low level time of period
  public SOFTPWM(int iPin, int dc, int pwmRange) {
    pin = iPin;
    range = pwmRange*100000;    //unit : 0.1ms
    marks = dc*100000;
    GPIO.pinMode(pin, GPIO.OUTPUT);
    t.start();
  }
  public void softPwmWrite(int value) {
    value *= 100000;
    constrain(value, 0, range);
    marks = value;
  }
  public void softPwmStop() {
    t.stop();
    GPIO.digitalWrite(pin, GPIO.LOW);
  }
  private class myThread implements Runnable {
    public void run() {
      while (true) {
        space = range - marks;
        if (marks !=0 ) {
          GPIO.digitalWrite(pin, GPIO.HIGH);
          delayMicroSeconds(marks);          
        }
        if (space !=0 ) {
          GPIO.digitalWrite(pin, GPIO.LOW);
          delayMicroSeconds(space);
        }
        //println("mark :  "+marks+"   space : "+space);
      }
    }
  }
}

class SEC {
  public long msec;
  public int nsec;
}
void delayMicroSeconds(long howlong) {
  SEC s = new SEC();
  s.msec = howlong / 1000000;
  s.nsec = (int)howlong % 1000000;
  try {
    Thread.sleep(s.msec, s.nsec);
  }
  catch(Exception e) {
    println(e);
    println("msec: "+s.msec+"  nsec:  "+s.nsec);
  }
}