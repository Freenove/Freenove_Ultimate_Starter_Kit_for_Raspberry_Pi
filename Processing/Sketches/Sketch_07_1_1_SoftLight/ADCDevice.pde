/*****************************************************
 * Filename    : ADCDevice
 * Description : class ADCDevice
 * auther      : www.freenove.com
 * modification: 2024/09/03
 *****************************************************/

class ADCDevice {
  public int address = 0;
  public int cmd = 0;
  public I2C i2c;
  public ADCDevice() {
    i2c = new I2C(I2C.list()[0]);
  }

  public boolean detectI2C(int addr) {
    i2c.beginTransmission(addr);
    i2c.write(0);
    try {
      i2c.endTransmission();   
      System.out.printf("Found device in address 0x%x\n", addr);
      return true;
    }
    catch(Exception e) {
      System.out.printf("Not found device in address 0x%x\n", addr);
      return false;
    }
  }

  public int analogRead(int chn) {
    println("Implemented in subclass! \n");
    return 0;
  }
}
class PCF8591 extends ADCDevice {
  //constructor,Parameters for the PCF8591 I2C address
  public PCF8591(int addr) { 
    address = addr;
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
    i2c.beginTransmission(address);
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
class ADS7830 extends ADCDevice {
  //constructor,Parameters for the ADS7830 I2C address
  public ADS7830(int addr) { 
    address = addr;
    cmd = 0x84;
  }
  //Read the ADC value of one channel
  public int analogRead(int chn) {
    int result = 0;
    i2c.beginTransmission(address);
    constrain(chn, 0, 3);
    i2c.write(cmd|(((chn<<2 | chn>>1)&0x07)<<4));
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
}
