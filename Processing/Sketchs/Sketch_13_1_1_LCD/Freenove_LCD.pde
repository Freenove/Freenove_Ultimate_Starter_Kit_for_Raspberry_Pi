/*****************************************************
 * Filename    : Freenove_LCD
 * Description : use I2C(pcf8574)control LCD1602 
 * auther      : www.freenove.com
 * modification: 2016/08/24
 *****************************************************/

class Freenove_LCD1602 {

  final public int //HD44780U commands
    CLEAR  = 0x01, 
    HOME   = 0x02, 
    ENTRY  = 0x04, 
    CTRL   = 0x08, 
    CDSHIFT= 0x10, 
    FUNC   = 0x20, 
    CGRAM  = 0x40, 
    DDRAM  = 0x80;

  final public int   //flags for display entry mode
    ENTRY_SH  =  0x01, 
    ENTRY_ID  =  0x02;

  final public int   //flags for display/cursor on/off control
    BLINK_CTRL  =  0x01, 
    CURSOR_CTRL =  0x02, 
    DISPLAY_CTRL=  0x04;

  final public int  //flags function set
    FUNC_F  =  0x04, 
    FUNC_N  =  0x08, 
    FUNC_DL =  0x10, 
    MOVERIGHT = 0x04, //flags for display/cursor shift
    MOVELEFT = 0x00, 
    DISPLAYMOVE  = 0x08, 
    CURSORMOVE = 0x00;

  final public int[] rowOff = {0x00, 0x40, 0x14, 0x54 };
  private int func = 0, control = 0;
  PCF8574 pcf;
  private int rows, cols, rsPin, enPin, rwPin;
  int displayMode = 0;

  public Freenove_LCD1602(PCF8574 ipcf) {
    pcf = ipcf;
    rows = 2;    
    cols = 16;
    rsPin = 0;    //connect to PCF8574 module
    enPin = 2;
    rwPin = 1;

    pcf.digitalWrite(rsPin, 0);
    pcf.digitalWrite(enPin, 0);
    pcf.digitalWrite(rwPin, 0);
    delay(35);
    func = FUNC  |  FUNC_DL;  //set 8-bit mode 3 times
    put4Command(func>>4);      
    delay(35); 
    put4Command(func>>4);      
    delay(35); 
    put4Command(func>>4); 
    delay(35); 
    func = FUNC;        //set 4-bit mode
    put4Command(func>>4);    
    delay(35);
    if (rows > 1) {
      func = FUNC_N;
      putCommand(func);    
      delay(35);
    }
    display(true);    //lcd initializtion
    lcdCursor(false);
    cursorBlink(false);

    displayMode = ENTRY | ENTRY_ID;
    putCommand(displayMode);
    putCommand(CDSHIFT | MOVERIGHT);
    backLightON();
    home();
    lcdClear();
  }
  //for sending data/cmds
  public void sendDataCmd(int data) {
    int d4 = data & 0xf0;
    pcf.writeByte(d4 | (pcf.currValue&0x0f));
    strobe();
    d4 = (data<<4) & 0xf0;
    pcf.writeByte(d4 | (pcf.currValue&0x0f));
    strobe();
  }
  //send command
  public void putCommand(int cmd) {
    pcf.digitalWrite(rsPin, 0);
    sendDataCmd(cmd);
    delay(2);
  }
  public void put4Command(int command) {
    pcf.digitalWrite(rsPin, 0);
    pcf.writeByte(((command<<4)&0xf0) | (pcf.currValue&0x0f));
    strobe();
  }
  //pulse enable
  public void strobe() {
    pcf.digitalWrite(enPin, 1);
    //delay(1);
    //delayMicroseconds(50);
    pcf.digitalWrite(enPin, 0);
    //delay(1);
    //delayMicroseconds(50);
  }
  //send a data byte to be displayed on the display.
  public void putChar(char data) {
    pcf.digitalWrite(rsPin, 1);
    sendDataCmd(data);
  }
  //Send a string to be displayed on the display.
  public void puts(String str) {
    for (int i=0; i<str.length(); i++) {
      putChar(str.charAt(i));
    }
  }
  //turn display, cursor, cursor blinking on/off
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
  //set the position of the cursor on the display
  public void position(int x, int y) {
    constrain(x, 0, cols);
    constrain(y, 0, rows);
    putCommand(x+(DDRAM | rowOff[y]));
  }
  //Home the cursor 
  public void home() {
    putCommand(HOME);
  }
  //clear the screen
  public void lcdClear() {
    putCommand(CLEAR);
    putCommand(HOME);
  }
  //turn on the backLight
  public void backLightON() {
    pcf.digitalWrite(3, 1);
  }
  //turn off the backLight
  public void backLightOFF() {
    pcf.digitalWrite(3, 0);
  }
  //scroll the display a unit to left
  public void scrollDisplayLeft() {
    putCommand(CDSHIFT | DISPLAYMOVE | MOVELEFT);
  }
  //scroll the display a unit to right
  public void scrollDisplayRight() {
    putCommand(CDSHIFT | DISPLAYMOVE | MOVERIGHT);
  }
  //text flows left to right
  public void leftToRight() {
    displayMode |= ENTRY_ID;
    putCommand(ENTRY | displayMode);
  }
  //text flows right to left
  public void rightToLeft() {
    displayMode &= ~ENTRY_ID;
    putCommand(ENTRY | displayMode);
  }
  //scroll the display follow the cursor
  public void autoScroll() {
    displayMode |= ENTRY_SH;
    putCommand(ENTRY | displayMode);
  }
  public void noAutoScroll() {
    displayMode &= ~ENTRY_SH;
    putCommand(ENTRY | displayMode);
  }
}