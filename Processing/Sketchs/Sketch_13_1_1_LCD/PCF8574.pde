/*****************************************************
 * Filename    : PCF8574
 * Description : class PCF8574
 * auther      : www.freenove.com
 * modification: 2016/08/20
 *****************************************************/

class PCF8574 {
  private int address;
  private I2C i2c;
  private int currValue;
  //constructor,Parameters for the PCF8591 I2C address
  public PCF8574(int addr) { 
    address = addr;
    i2c = new I2C(I2C.list()[0]);
    currValue = 0;
  }
  //Read the data of one port
  public int digitalRead(int pin) {
    int val = readByte();    
    return ((val&(1<<pin)) == (1<<pin)) ? 1 : 0;
  }
  //Read data of all ports
  public int readByte() {
    //// byte[] in  = new byte[0];
    //int val = 0;
    //i2c.beginTransmission(address);
    ////i2c.write(0xff);
    //i2c.endTransmission();
    //try {
    //  byte[] in = i2c.read(1);
    //  val = in[0]&0xff;
    //}
    //catch(Exception e) {
    //  println(e);
    //}
    //not yet implement
    
    return currValue;
  }
  //Write the data to one of the ports
  public void digitalWrite(int pin, int val) {
    int value = currValue;
    if (val == GPIO.HIGH) {
      value |= (1<<pin);
    } else if (val == GPIO.LOW) {
      value &= ~(1<<pin);
    } else {
      println("value error!");
      return;
    }
    writeByte(value);
  }
  //Write the data to all ports
  public void writeByte(int data) {
    currValue = data;
    i2c.beginTransmission(address);
    i2c.write(data);
    i2c.endTransmission();
  }
}