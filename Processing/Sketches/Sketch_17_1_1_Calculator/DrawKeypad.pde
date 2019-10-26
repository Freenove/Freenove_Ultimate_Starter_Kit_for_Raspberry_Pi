/*****************************************************
 * Filename    : drawKeypad
 * Description : function drawKeypad
 * auther      : www.freenove.com
 * modification: 2016/09/02
 *****************************************************/

final int gap =10;
final int kSize = 50;
final int kpSize = kSize*4+3*gap+gap*4;
boolean keyIsPressed = false; 
int changeColorCnt = 0;
int changeKeyCode = 0;
void drawKeypad(int x, int y) {
  pushMatrix();
  translate(x, y);
  noStroke();
  fill(0);
  rect(0, 0, kpSize, kpSize, 10);

  strokeWeight(4);
  stroke(255);
  fill(0);
  rect(gap, gap, kpSize-2*gap, kpSize-2*gap, 10);

  strokeWeight(4);
  stroke(255);
  //fill(0,255,0);
  textSize(40);
  textAlign(CENTER, CENTER);
  for (int i=0; i<4; i++) {
    for (int j=0; j<4; j++) {
      if (((i<3)&&(j<3))||((i==3)&&(j==1))) {    //blue and red
        fill(64, 64, 255);
      } else {
        fill(255, 64, 64);
      }
      if (cc.kkey == keys[4*i+j]) {    //if any key is pressed,fill in green
        changeKeyCode = 4*i+j;
        fill(64, 255, 64);
        keyIsPressed = true;
        changeColorCnt = 0;
      } else if (keyIsPressed && (changeKeyCode == 4*i+j)) { //Keep green for some time 
        changeColorCnt ++ ;
        if (changeColorCnt>20) {
          changeColorCnt = 0;
          keyIsPressed = false;
        }
        fill(64, 255, 64);
      }
      rect(2*gap+j*(kSize+gap), 2*gap+i*(kSize+gap), kSize, kSize, 5);  //draw key
      fill(255);    //draw key code of key
      text(keys[4*i+j], (2*gap+j*(kSize+gap)+kSize/2), (2*gap+i*(kSize+gap)+kSize/2));
    }
  }  
  popMatrix();
}

void drawDisplay(String content) {
  stroke(0);
  strokeWeight(4);
  fill(255);
  rect(0, 0, width, 50);  //Display area
  fill(0);  
  textSize(40);
  textAlign(RIGHT, TOP);
  text(content, width-5, 5);  //Display content
}