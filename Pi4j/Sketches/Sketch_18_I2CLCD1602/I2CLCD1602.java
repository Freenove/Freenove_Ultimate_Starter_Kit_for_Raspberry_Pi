// Shebang line for JBang to execute this script directly  
///usr/bin/env jbang "$0" "$@" ; exit $?  

// Dependencies for this script  
//DEPS org.slf4j:slf4j-api:2.0.12  
//DEPS org.slf4j:slf4j-simple:2.0.12  
//DEPS com.pi4j:pi4j-core:2.6.0  
//DEPS com.pi4j:pi4j-plugin-raspberrypi:2.6.0  
//DEPS com.pi4j:pi4j-plugin-gpiod:2.6.0  
//DEPS com.pi4j:pi4j-plugin-linuxfs:2.6.0  

import java.io.BufferedReader;
import java.io.Closeable;
import java.io.File;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.Arrays;

import com.pi4j.Pi4J;
import com.pi4j.context.Context;
import com.pi4j.io.i2c.I2C;
import com.pi4j.io.i2c.I2CConfig;
import com.pi4j.io.i2c.I2CConfigBuilder;
import com.pi4j.io.i2c.I2CProvider;

class IIC {
  protected String dev;
  protected int handle;
  protected int slave;
  protected byte[] out;
  protected boolean transmitting;

  private Context pi4j;
  I2CConfigBuilder i2cConfigBuilder;
  I2CProvider i2CProvider;
  I2CConfig i2cConfig;
  I2C i2c;
  int bus = 1;

  public IIC(int bus) {
    this.bus = bus;
    constructor();
  }

  public IIC(String s) {
    String b = s.split("i2c-")[1];
    try {
      this.bus = Integer.parseInt(b);
    } catch (Exception e) {
      this.bus = 1;
    }
    constructor();
  }

  private void constructor() {
    pi4j = Pi4J.newAutoContext();
    i2CProvider = pi4j.provider("linuxfs-i2c");
    i2cConfigBuilder = I2C.newConfigBuilder(pi4j).bus(bus);
  }

  public void beginTransmission(int address) {
    if (i2cConfig == null) {
      i2cConfig = i2cConfigBuilder.device(address).build();
    }

    if (i2c == null) {
      i2c = i2CProvider.create(i2cConfig);
    }
  }

  public void write(int b) {
    i2c.write(b);
  }

  public byte read() {
    return i2c.readByte();
  }

  public byte[] read(int size) {
    return i2c.readByteBuffer(size).array();
  }

  public void endTransmission() {
    i2c.close();
  }

  public static String[] list() {
    ArrayList<String> devs = new ArrayList<String>();
    File dir = new File("/dev");
    File[] files = dir.listFiles();
    if (files != null) {
      for (File file : files) {
        if (file.getName().startsWith("i2c-")) {
          devs.add(file.getName());
        }
      }
    }
    String[] tmp = devs.toArray(new String[devs.size()]);
    Arrays.sort(tmp);
    return tmp;
  }
}

class PCF8574 {
  private int address;
  private IIC i2c;
  private int currValue;

  public PCF8574(int addr) {
    address = addr;
    i2c = new IIC(IIC.list()[0]);
    currValue = 0;
  }

  public int digitalRead(int pin) {
    int val = readByte();
    return ((val & (1 << pin)) == (1 << pin)) ? 1 : 0;
  }

  public int readByte() {
    return currValue;
  }

  public void digitalWrite(int pin, int val) {
    int value = currValue;
    if (val == 1) {
      value |= (1 << pin);
    } else if (val == 0) {
      value &= ~(1 << pin);
    } else {
      return;
    }
    writeByte(value);
  }

  public void writeByte(int data) {
    currValue = data;
    i2c.beginTransmission(address);
    i2c.write(data);
    i2c.endTransmission();
  }

  public int getCurrentValue() {
    return currValue;
  }
}

class Freenove_LCD1602 {
  final public int // HD44780U commands
  CLEAR = 0x01,
      HOME = 0x02,
      ENTRY = 0x04,
      CTRL = 0x08,
      CDSHIFT = 0x10,
      FUNC = 0x20,
      CGRAM = 0x40,
      DDRAM = 0x80;

  final public int // flags for display entry mode
  ENTRY_SH = 0x01,
      ENTRY_ID = 0x02;

  final public int // flags for display/cursor on/off control
  BLINK_CTRL = 0x01,
      CURSOR_CTRL = 0x02,
      DISPLAY_CTRL = 0x04;

  final public int // flags function set
  FUNC_F = 0x04,
      FUNC_N = 0x08,
      FUNC_DL = 0x10,
      MOVERIGHT = 0x04, // flags for display/cursor shift
      MOVELEFT = 0x00,
      DISPLAYMOVE = 0x08,
      CURSORMOVE = 0x00;

  final public int[] rowOff = { 0x00, 0x40, 0x14, 0x54 };
  private int func = 0, control = 0;
  PCF8574 pcf;
  private int rows, cols, rsPin, enPin, rwPin;
  int displayMode = 0;

  private void delay(long ms) {
    long startTime = System.nanoTime();
    long endTime = startTime + (ms * 1000 * 1000);
    while (System.nanoTime() < endTime) {
    }
  }

  private int constrain(int value, int min, int max) {
    if (value < min) {
      return min;
    } else if (value > max) {
      return max;
    } else {
      return value;
    }
  }

  public Freenove_LCD1602(PCF8574 ipcf) {
    pcf = ipcf;
    rows = 2;
    cols = 16;
    rsPin = 0; // connect to PCF8574 module
    enPin = 2;
    rwPin = 1;

    pcf.digitalWrite(rsPin, 0);
    pcf.digitalWrite(enPin, 0);
    pcf.digitalWrite(rwPin, 0);
    delay(35);
    func = FUNC | FUNC_DL; // set 8-bit mode 3 times
    put4Command(func >> 4);
    delay(35);
    put4Command(func >> 4);
    delay(35);
    put4Command(func >> 4);
    delay(35);
    func = FUNC; // set 4-bit mode
    put4Command(func >> 4);
    delay(35);
    if (rows > 1) {
      func = FUNC_N;
      putCommand(func);
      delay(35);
    }
    display(true); // lcd initializtion
    lcdCursor(false);
    cursorBlink(false);

    displayMode = ENTRY | ENTRY_ID;
    putCommand(displayMode);
    putCommand(CDSHIFT | MOVERIGHT);
    backLightON();
    home();
    lcdClear();
  }

  // for sending data/cmds
  public void sendDataCmd(int data) {
    int d4 = data & 0xf0;
    int currentValue = pcf.getCurrentValue();
    pcf.writeByte(d4 | (currentValue & 0x0f));
    strobe();
    currentValue = pcf.getCurrentValue();
    d4 = (data << 4) & 0xf0;
    pcf.writeByte(d4 | (currentValue & 0x0f));
    strobe();
  }

  // send command
  public void putCommand(int cmd) {
    pcf.digitalWrite(rsPin, 0);
    sendDataCmd(cmd);
    delay(2);
  }

  public void put4Command(int command) {
    int currentValue = pcf.getCurrentValue();
    pcf.digitalWrite(rsPin, 0);
    pcf.writeByte(((command << 4) & 0xf0) | (currentValue & 0x0f));
    strobe();
  }

  // pulse enable
  public void strobe() {
    pcf.digitalWrite(enPin, 1);
    pcf.digitalWrite(enPin, 0);
  }

  // send a data byte to be displayed on the display.
  public void putChar(char data) {
    pcf.digitalWrite(rsPin, 1);
    sendDataCmd(data);
  }

  // Send a string to be displayed on the display.
  public void puts(String str) {
    for (int i = 0; i < str.length(); i++) {
      putChar(str.charAt(i));
    }
  }

  // turn display, cursor, cursor blinking on/off
  public void display(boolean state) {
    if (state) {
      control |= DISPLAY_CTRL;
    } else {
      control &= ~DISPLAY_CTRL;
    }
    putCommand(CTRL | control);
  }

  public void lcdCursor(boolean state) {
    if (state) {
      control |= CURSOR_CTRL;
    } else {
      control &= ~CURSOR_CTRL;
    }
    putCommand(CTRL | control);
  }

  public void cursorBlink(boolean state) {
    if (state) {
      control |= BLINK_CTRL;
    } else {
      control &= ~BLINK_CTRL;
    }
    putCommand(CTRL | control);
  }

  // set the position of the cursor on the display
  public void position(int x, int y) {
    constrain(x, 0, cols);
    constrain(y, 0, rows);
    putCommand(x + (DDRAM | rowOff[y]));
  }

  // Home the cursor
  public void home() {
    putCommand(HOME);
  }

  // clear the screen
  public void lcdClear() {
    putCommand(CLEAR);
    putCommand(HOME);
  }

  // turn on the backLight
  public void backLightON() {
    pcf.digitalWrite(3, 1);
  }

  // turn off the backLight
  public void backLightOFF() {
    pcf.digitalWrite(3, 0);
  }

  // scroll the display a unit to left
  public void scrollDisplayLeft() {
    putCommand(CDSHIFT | DISPLAYMOVE | MOVELEFT);
  }

  // scroll the display a unit to right
  public void scrollDisplayRight() {
    putCommand(CDSHIFT | DISPLAYMOVE | MOVERIGHT);
  }

  // text flows left to right
  public void leftToRight() {
    displayMode |= ENTRY_ID;
    putCommand(ENTRY | displayMode);
  }

  // text flows right to left
  public void rightToLeft() {
    displayMode &= ~ENTRY_ID;
    putCommand(ENTRY | displayMode);
  }

  // scroll the display follow the cursor
  public void autoScroll() {
    displayMode |= ENTRY_SH;
    putCommand(ENTRY | displayMode);
  }

  public void noAutoScroll() {
    displayMode &= ~ENTRY_SH;
    putCommand(ENTRY | displayMode);
  }
}

public class I2CLCD1602 {
  public static void main(String[] args) throws Exception {
    PCF8574 pcf = new PCF8574(0x27); // or 0x3F
    Freenove_LCD1602 lcd;
    lcd = new Freenove_LCD1602(pcf);
    lcd.position(0, 0); // show time on the lcd display
    lcd.puts("Hello World.");
    try {
      int count = 0;
      while (true) {
        String buf = "Count: " + count;
        lcd.position(0, 1); // show time on the lcd display
        lcd.puts(buf);
        Thread.sleep(1000);
        count++;
      }
    } catch (InterruptedException e) {
      Thread.currentThread().interrupt();
    }
  }
}