/*****************************************************
 * Filename    : PCF8591
 * Description : class PCF8591,DAC and ADC
 * auther      : www.freenove.com
 * modification: 2016/08/20
 *****************************************************/

class PCF8591 {
  private int address;
  private I2C i2c;
  //constructor,Parameters for the PCF8591 I2C address
  public PCF8591(int addr) { 
    address = addr;
    i2c = new I2C(I2C.list()[0]);
  }
  //Read the ADC value of one channel
  public int analogRead(int chn) {
    int result = 0;
    i2c.beginTransmission(address);
    constrain(chn, 0, 3);
    i2c.write(0x40 | chn);
    try {
      byte[] in = i2c.read(1);
      result = in[0]&0xff;
    }
    catch(Exception e) {
      println(e);
    }
    i2c.endTransmission();
    return result;
  }
  //Read the ADC value of all channels
  public byte[] analogRead() {
    i2c.beginTransmission(address);
    i2c.write(0x44);
    i2c.endTransmission();
    byte[] in = i2c.read(4);
    return in;
  }
  //Write the DACvalue
  public void analogWrite(int data) {
    i2c.beginTransmission(address);
    i2c.write(0x40);
    i2c.write(data);
    i2c.endTransmission();
  }
}