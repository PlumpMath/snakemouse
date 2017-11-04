class Line {
  float x0, y0, x1, y1;
  
  Line(float x0, float y0, float x1, float y1) {
    this.x0 = x0;
    this.y0 = y0;
    this.x1 = x1;
    this.y1 = y1;
  }
  
  Line() {
    this(0, 0, 0, 0); 
  }
  
  void render(color c, float w) {
    stroke(c);
    strokeWeight(w);
    line(x0, y0, x1, y1);
  }
}