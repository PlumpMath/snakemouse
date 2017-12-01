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

  public void render(int c, float w) {
    stroke(c);
    strokeWeight(w);
    line(x0, y0, x1, y1);
  }

  public boolean intersects(Line other) {
    // Intersection code below adapted from http://www.cdn.geeksforgeeks.org/check-if-two-given-line-segments-intersect/
    return doIntersect(x0, y0, x1, y1, other.x0, other.y0, other.x1, other.y1);
  }

  /**
   * Returns whether point q lies on line segment pr
   * p q and r must be colinear
   */
  public boolean onSegment(float px, float py, float qx, float qy, float rx, float ry)
  {
    if (qx <= max(px, rx) && qx >= min(px, rx) &&
        qy <= max(py, ry) && qy >= min(py, ry))
      return true;

    return false;
  }

  /**
   * Returns the orientation of points p q r.
   * 0: colinear, 1: cw, 2: ccw
   */
  public int orientation(float px, float py, float qx, float qy, float rx, float ry)
  {
    float val = (qy - py) * (rx - qx) - (qx - px) * (ry - qy);

    if (abs(val) <= 0.00000001f)
      return 0;

    return (val > 0)? 1: 2;
  }

  /**
   * Returns whether segments p1q1 and p2q2 intersect
   */
  public boolean doIntersect(float p1x, float p1y, float q1x, float q1y, float p2x, float p2y, float q2x, float q2y)
  {
    // Find the four orientations needed for general and
    // special cases
    int o1 = orientation(p1x, p1y, q1x, q1y, p2x, p2y);
    int o2 = orientation(p1x, p1y, q1x, q1y, q2x, q2y);
    int o3 = orientation(p2x, p2y, q2x, q2y, p1x, p1y);
    int o4 = orientation(p2x, p2y, q2x, q2y, q1x, q1y);

    // General case
    if (o1 != o2 && o3 != o4)
      return true;

    // Special Cases
    // p1, q1 and p2 are colinear and p2 lies on segment p1q1
    if (o1 == 0 && onSegment(p1x, p1y, p2x, p2y, q1x, q1y)) return true;

    // p1, q1 and p2 are colinear and q2 lies on segment p1q1
    if (o2 == 0 && onSegment(p1x, p1y, q2x, q2y, q1x, q1y)) return true;

    // p2, q2 and p1 are colinear and p1 lies on segment p2q2
    if (o3 == 0 && onSegment(p2x, p2y, p1x, p1y, q2x, q2y)) return true;

    // p2, q2 and q1 are colinear and q1 lies on segment p2q2
    if (o4 == 0 && onSegment(p2x, p2y, q1x, q1y, q2x, q2y)) return true;

    return false;
  }
}