

class ProgressBar {

  int x, y;
  int barLength;
  float progress;
  String title;
  public ProgressBar(int ix, int iy, int barlen) {
    x = ix;
    y = iy;
    barLength = barlen;
    progress = 0;
    title = "Progress";
  }
  public void setTitle(String str){
    title = str;
  }
  public void setProgress(float pgress) {
    constrain(pgress, 0, 1.0);
    progress = pgress;
  }
  public void create() {
    pushMatrix();
    translate(x, y);   
    textAlign(CENTER);
    textSize(16);
    barBgStyle();  //progressbar bg
    line(0, 0, barLength, 0);    
    line(barLength, -5, barLength, 5);

    barStyle();  //progressbar 
    line(0, -5, 0, 5);
    line(0, 0, progress*barLength, 0);

    barLabelStyle();    //progressbar label
    text(title+" : "+nf(progress*100, 2, 2)+"%", barLength/2, -5);
    popMatrix();
  }
  public void create(float pgress) {
    setProgress(pgress);
    pushMatrix();
    translate(x, y);   

    barBgStyle();  //progressbar bg
    line(0, 0, barLength, 0);    
    line(barLength, -5, barLength, 5);

    barStyle();  //progressbar 
    line(0, -5, 0, 5);
    line(0, 0, progress*barLength, 0);

    barLabelStyle();    //progressbar label
    text(title+" : "+nf(progress*100, 2, 2)+"%", barLength/2, -5);
    popMatrix();
  }
  void barBgStyle() {
    stroke(220);
    noFill();
  }

  void barStyle() {
    stroke(50);
    noFill();
  }

  void barLabelStyle() {
    noStroke();
    fill(120);
  }
}