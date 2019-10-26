/*****************************************************
 * Filename    : BUTTON
 * Description : class BUTTON
 * auther      : www.freenove.com
 * modification: 2016/08/22
 *****************************************************/
class BUTTON {
  public int x, y, w, h;
  public String txt;
  private int bgr, bgg, bgb;
  private int tr, tg, tb;
  public BUTTON(int ix, int iy, int iw, int ih) {
    setPosition(ix, iy);
    setSize(iw, ih);
    setText("BTN");
    setBgColor(0, 0, 0);
    setTextColor(255,255,255);
  }
  public void create() {
    pushMatrix();
    translate(x,y);
    fill(bgr, bgg, bgb);
    rect(0, 0, w, h);
    fill(tr, tg, tb);
    textSize(min(w,h)/2);
    textAlign(CENTER, CENTER);
    text(txt, w/2, h/2);
    popMatrix();
  }
  public void setBgColor(int ir, int ig, int ib) {
    bgr = ir;
    bgg = ig;
    bgb = ib;
  }
  public void setText(String str) {
    txt = str;
  }
  public void setTextColor(int ir, int ig, int ib) {
    tr = ir;
    tg = ig;
    tb = ib;
  }
  public void setSize(int iw, int ih) {
    w = iw;
    h = ih;
  }
  public void setPosition(int ix, int iy) {
    x= ix;
    y = iy;
  }
}