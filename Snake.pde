class Snake {
  ArrayList<Line> segments;
  float lastLineTime;
  color segmentColour;
  float segmentWidth;
  int maxSegments;
  int curSegments;
  static final int SEGMENT_LENGTH = 12;
  float speed;
  PVector lastPlacedTail;

  Snake() {
    segments = new ArrayList<Line>();
    lastPlacedTail = new PVector();
    lastLineTime = 0;
    segmentColour = color(255);
    segmentWidth = 3f;
    maxSegments = 5;
    curSegments = 0;
    speed = 10;
  }

  /**
   * Considers adding a new segment by looking at the game state.
   * Returns whether or not a new segment was added.
   */
  boolean addSegment() {
    // Don't add new segment if we're at the max length
    if (curSegments >= maxSegments) {
      return false;
    }

    // Find the tail of the snake
    Line curTail;
    try {
      curTail = segments.get(0);
    } 
    catch (IndexOutOfBoundsException e) {
      curTail = null;
    }

    Line newTail = null;
    if (curTail != null) {
      // If the snake hasn't travelled far enough since the last tail was placed, no new tail
      if (!(dist(curTail.x0, curTail.y0, lastPlacedTail.x, lastPlacedTail.y) > SEGMENT_LENGTH)) {
        return false;
      }

      // Create new tail segment, which will be in the same direction as the current tail
      newTail = new Line(2 * curTail.x0 - curTail.x1, 
        2 * curTail.y0 - curTail.y1, 
        curTail.x0, 
        curTail.y0);
    } else {
      // If there is yet to be any snake, make the first segment where the pointer started
      newTail = new Line(mouseX, mouseY, mouseX, mouseY);
    }

    lastPlacedTail.x = newTail.x0;
    lastPlacedTail.y = newTail.y0;
    segments.add(0, newTail);
    curSegments++;
    return true;
  }

  /**
   * Renders the snake!
   */
  void render() {
    for (Line l : snake.segments) {
      l.render(segmentColour, segmentWidth);
    }
  }

  /**
   * Pulls every segment so the head is now at (x, y)
   */
  void updatePosition() {
    PVector curPosition = getHead();
    PVector newPosition = new PVector(mouseX - curPosition.x, mouseY - curPosition.y).normalize().mult(speed).add(curPosition);
    println(newPosition.toString());
    for (int i = segments.size() - 1; i >= 0; --i) {
      Line segment = segments.get(i);
      segment.x1 = newPosition.x;
      segment.y1 = newPosition.y;
      // Calculates the amount the "tail-end" of the segment has to move towards
      // the new location of it's "head-end"
      PVector u = new PVector(segment.x0 - newPosition.x, segment.y0 - newPosition.y);
      u.normalize();
      u.mult(SEGMENT_LENGTH);
      segment.x0 = newPosition.x + u.x;
      segment.y0 = newPosition.y + u.y;
      newPosition.x = segment.x0;
      newPosition.y = segment.y0;
    }
  }
  
  PVector getHead() {
    Line head = segments.get(segments.size() - 1);
    return new PVector(head.x1, head.y1); 
  }
}