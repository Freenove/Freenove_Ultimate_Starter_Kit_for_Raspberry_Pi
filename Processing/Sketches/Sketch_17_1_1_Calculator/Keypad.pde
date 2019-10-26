/*****************************************************
 * Filename    : Keypad
 * Description : class Keypad
 * auther      : www.freenove.com
 * modification: 2016/09/02
 *****************************************************/

class Keypad {
  final char NO_KEY = '\0';
  final int IDLE = 0, 
    PRESSED = 1, 
    HOLD = 2, 
    RELEASED = 3;
  //define OPEN and CLOSED
  final int OPEN = 0, 
    CLOSED = 1;
  final int LIST_MAX = 10, //Max number of keys on the active list.
    MAPSIZE = 10;//MAPSIZE is the number of rows (times 16 columns)
  int[] bitMap = new int[MAPSIZE];
  Key[] key = new Key[LIST_MAX];
  int   holdTime = 500, //key hold time
    holdTimer = 0;
  int[] rowPins, colPins;
  int numRows, numCols;
  char[] keymap;
  int debounceTime = 10;  //10ms
  long startTime = 0;
  public Keypad(char[] usrKeyMap, int[] row_Pins, int[] col_Pins) {
    keymap = usrKeyMap;
    rowPins = row_Pins;
    colPins = col_Pins;
    numRows = rowPins.length;
    numCols = colPins.length;
    for (int i=0; i<LIST_MAX; i++) {
      key[i] = new Key();
    }
    setPinMode();
  }
  // Returns a single key only. Retained for backwards compatibility.
  public char getKey() {
    if (getKeys() && key[0].stateChanged && (key[0].kstate==PRESSED)) {
      return key[0].kchar;
    }
    return NO_KEY;
  }
  public boolean getKeys() {
    boolean keyActivity = false;
    //Limit how often the keypad is scanned.
    if ((millis() - startTime) > debounceTime) {
      scanKeys();
      keyActivity = updateList();
      startTime = millis();
    }
    return keyActivity;
  }
  //set pins for input/output
  void setPinMode() {  
    for (int i=0; i<numRows; i++) {    
      GPIO.pinMode(rowPins[i], GPIO.INPUT);
    }
    for (int i=0; i<numCols; i++) {    
      GPIO.pinMode(colPins[i], GPIO.OUTPUT);
    }
  }
  //Hardware scan ,the result store in bitMap
  void scanKeys() {    
    //for (int i=0; i<numRows; i++) {
    //  println("pinMode start."+i+"   time:"+millis());
    //  GPIO.pinMode(rowPins[i], GPIO.INPUT);
    //  println("pinMode end."+i+"   time:"+millis());
    //}    
    //bitMap stores ALL the keys that are being pressed.
    for (int i=0; i<numCols; i++) {
      //GPIO.pinMode(colPins[i], GPIO.OUTPUT);
      GPIO.digitalWrite(colPins[i], GPIO.LOW);// Begin column pulse output.
      for (int j=0; j<numRows; j++) {// keypress is active low so invert to high.
        bitMap[j] = bitWrite(bitMap[j], i, (~GPIO.digitalRead(rowPins[j])&0x01));
      }
      GPIO.digitalWrite(colPins[i], GPIO.HIGH);
      //GPIO.pinMode(colPins[i], GPIO.INPUT);
    }
  }
  // Manage the list without rearranging the keys. Returns true if any keys on the list changed state.
  boolean updateList() {    
    boolean anyActivity = false;
    // Delete any IDLE keys
    for (int i=0; i<LIST_MAX; i++) {
      if (key[i].kstate == IDLE) {
        key[i].kchar = NO_KEY;
        key[i].kcode = -1;
        key[i].stateChanged = false ;
      }
    }
    // Add new keys to empty slots in the key list.
    for (int r=0; r<numRows; r++) {
      for (int c=0; c<numCols; c++) {
        boolean button = bitRead(bitMap[r], c);    
        char keyChar = keymap[r * numCols +c];
        int keycode = r * numCols +c;
        int idx = findInList(keycode);
        // Key is already on the list so set its next state.
        if (idx > -1) {
          nextKeyState(idx, button);
        }
        // Key is NOT on the list so add it.
        if ((idx == -1)&& button) {
          for (int i=0; i<LIST_MAX; i++) {
            if (key[i].kchar == NO_KEY) {// Find an empty slot or don't add key to list.
              key[i].kchar = keyChar;
              key[i].kcode = keycode;
              key[i].kstate = IDLE;    // Keys NOT on the list have an initial state of IDLE.
              nextKeyState(i, button);
              break;// Don't fill all the empty slots with the same key.
            }
          }
        }
      }
    }
    // Report if the user changed the state of any key.
    for (int i=0; i<LIST_MAX; i++) {
      if (key[i].stateChanged) {
        anyActivity = true;
      }
    }   
    return anyActivity;
  }
  // This function is a state machine but is also used for debouncing the keys.
  private void nextKeyState(int idx, boolean button) {
    key[idx].stateChanged = false;
    switch (key[idx].kstate) {
    case IDLE:
      if (button) {
        transitionTo (idx, PRESSED);
        holdTimer = millis();
      }    // Get ready for next HOLD state.
      break;
    case PRESSED:
      if ((millis()-holdTimer)>holdTime)  // Waiting for a key HOLD...
        transitionTo (idx, HOLD);
      else if (!button)        // or for a key to be RELEASED.
        transitionTo (idx, RELEASED);
      break;
    case HOLD:
      if (!button) {
        transitionTo (idx, RELEASED);
      }
      break;
    case RELEASED:
      transitionTo (idx, IDLE);
      break;
    }
  }
  private void transitionTo(int idx, int nextState) {
    key[idx].kstate = nextState;
    key[idx].stateChanged = true;
  }
  // Search by code for a key in the list of active keys.
  // Returns -1 if not found or the index into the list of active keys.
  private int findInList(int keycode) {
    for (int i=0; i<LIST_MAX; i++) {
      if (key[i].kcode == keycode) {
        return i;
      }
    }
    return -1;
  }
  public void setDebounceTime(int ms) {
    debounceTime = ms;
  }
  public void setHoldTime(int ms) {
    holdTime = ms;
  }
  public boolean isPressed(char keyChar) {
    for (byte i=0; i<LIST_MAX; i++) {
      if ( key[i].kchar == keyChar ) {
        if ( (key[i].kstate == PRESSED) && key[i].stateChanged )
          return true;
      }
    }
    return false;  // Not pressed.
  }
  public char waitForKey() {
    char waitKey = NO_KEY;
    while ( (waitKey = getKey()) == NO_KEY );  // Block everything while waiting for a keypress.
    return waitKey;
  }

  // Backwards compatibility function.
  public int getState() {
    return key[0].kstate;
  }
  // The end user can test for any changes in state before deciding
  // if any variables, etc. needs to be updated in their code.
  boolean keyStateChanged() {
    return key[0].stateChanged;
  }
  private int bitWrite(int x, int n, int b) {
    if (b != 0) {
      x |= (1<<n);
    } else {
      x &= (~(1<<n));
    }
    return x;
  }
  private boolean bitRead(int x, int n) {
    if (((x>>n)&1) == 1) {
      return true;
    } else {
      return false;
    }
  }
}