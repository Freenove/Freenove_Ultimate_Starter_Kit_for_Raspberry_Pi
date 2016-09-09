/*****************************************************
 * Filename    : Calculator
 * Description : class Calculator
 * auther      : www.freenove.com
 * modification: 2016/09/02
 *****************************************************/
import java.math.BigDecimal;
class Calculator {
  Keypad keypad;

  double result=0;    //Calculate result
  String txt = "";    //
  String contentStr = "";    //Display string
  char mark;    //operate mark
  final int NUM=1, MARK=2, RESULT=3, BLANK = 4; //Current content
  int currentContent = BLANK;  //
  boolean calcul_isStandBy = true; //Star and Clear
  char kkey = ' ';    //the key value
  public Calculator(Keypad kp) {
    keypad = kp;
  }
  public void process() {
    kkey = kp.getKey();
    if (kkey != keypad.NO_KEY) {    //if there is a key is pressed   
      calcul_isStandBy = false;
      if ((kkey > 0x2F)&&(kkey < 0x3A)) {    //key code is 0-9
        if (currentContent == RESULT) {  //current Content is last results,clear
          txt="";
          txt+=kkey;    //Store the key code
          currentContent=NUM;
        } else {
          txt+=kkey;
          currentContent=NUM;
        }
      } else if ((kkey == '+') || (kkey == '-')||(kkey == '*')||(kkey == '/')) {
        if (currentContent == RESULT) {  //last results,Use it to make continuous calculations
          txt = ""+result;
          txt +=kkey;
        } else if (currentContent==MARK) {  //change mark
          txt = txt.substring(0, txt.length()-1)+kkey;
        } else if (currentContent==BLANK) {  //0 + mark
          txt+=("0"+kkey);
        } else {
          txt +=kkey;
        }
        currentContent=MARK;
      } else if (kkey == '=') {  //if the key code is "="
        if (currentContent == RESULT) {  //Keep last results
          txt+=("="+result);
          currentContent = RESULT;
        } else if (currentContent == BLANK) {  //No active,keep standby
          calcul_isStandBy = true;
          currentContent = BLANK;
        } else {
          if (currentContent==MARK) {    //if the last char is a MARK,delete it. 
            txt = txt.substring(0, txt.length()-1);
          }
          if (txt.charAt(0) == '-') {    //negative number,add "0" in start bit
            txt = "0".concat(txt);
          }
          result = parse(txt);    //calculate the result
          txt+=("="+result);
          currentContent = RESULT;
        }
      } else if (kkey == 'C') {  //clear
        cclear();
      }
    }
    if (calcul_isStandBy) {    
      contentStr = "0";
    } else {      
      contentStr = txt;
    }
  }
  public void cclear() {    //Clear all datas, make calculator standby
    txt = "";
    calcul_isStandBy = true;
    result = 0;
    currentContent = BLANK;
  }
  public double parse(String content) { //parse processing
    int index = content.indexOf("+");
    if (index != -1) {
      BigDecimal b1 = new BigDecimal(parse(content.substring(0, index)));
      BigDecimal b2 = new BigDecimal(parse(content.substring(index+1)));
      return rround(b1.add(b2).doubleValue(),6);
      //return parse(content.substring(0, index)) + parse(content.substring(index+1));
    }
    index = content.lastIndexOf("-");
    if (index != -1) {
      BigDecimal b1 = new BigDecimal(parse(content.substring(0, index)));
      BigDecimal b2 = new BigDecimal(parse(content.substring(index+1)));
      return rround(b1.subtract(b2).doubleValue(),6);
      //return parse(content.substring(0, index)) - parse(content.substring(index+1));
    }
    index = content.indexOf("*");
    if (index != -1) {
      //println("* : "+content.substring(0, index) +"  " + content.substring(index+1));
      BigDecimal b1 = new BigDecimal(parse(content.substring(0, index)));
      BigDecimal b2 = new BigDecimal(parse(content.substring(index+1)));
      return rround(b1.multiply(b2).doubleValue(),6);
      //return parse(content.substring(0, index)) * parse(content.substring(index+1));
    }
    index = content.lastIndexOf("/");
    if (index != -1) {
      //println("/ : "+content.substring(0, index) +"  " + content.substring(index+1));
      BigDecimal b1 = new BigDecimal(parse(content.substring(0, index)));
      BigDecimal b2 = new BigDecimal(parse(content.substring(index+1)));
      return b1.divide(b2,6,BigDecimal.ROUND_HALF_UP).doubleValue();      
      //return parse(content.substring(0, index)) / parse(content.substring(index+1));
    }  
    Double result = 0d; 
    //try {
    result = Double.parseDouble(content);
    //}
    //catch(Exception e) {
    //  println(e+" \n txt: "+txt);
    //}
    //println("result:  "+result);
    return result;
  }
  public double rround(double d,int len){    //rounding
    BigDecimal b1 = new BigDecimal(d);
    BigDecimal b2 = new BigDecimal(1);
    return b1.divide(b2,len,BigDecimal.ROUND_HALF_UP).doubleValue();
  }
}