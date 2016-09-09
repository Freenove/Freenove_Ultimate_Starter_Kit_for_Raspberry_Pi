/*****************************************************
 * Filename    : Key
 * Description : class Key
 * auther      : www.freenove.com
 * modification: 2016/09/02
 *****************************************************/

//class Key:Define some of the properties of Key
class Key {
  final char NO_KEY = '\0';
  //Defines the four states of Key
  final int IDLE = 0, 
    PRESSED = 1, 
    HOLD = 2, 
    RELEASED = 3;
  //define OPEN and CLOSED
  final int OPEN = 0, 
    CLOSED = 1;
  char kchar;
  int kstate, kcode;
  boolean stateChanged;
  //constructor
  public Key() {
    kchar = NO_KEY;
    kstate = IDLE;
    kcode = -1;
    stateChanged = false;
  }
}