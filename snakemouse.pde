Snake snake;
Mouse mouse;
PShape fruitShape;
PVector fruit = new PVector();
boolean gameOn = false;


void setup() {
  smooth();
  size(800, 600);
  randomFruit();
  snake = new Snake();
  mouse = new Mouse();
  fruitShape = loadShape("apple.svg");
  frameRate(60);
}

void draw() {
  background(0);
  if (gameOn) {
    snake.addSegment();
    snake.updatePosition();
    snake.render();

    // Causes the mouse to squeak in fear
    mouse.squeak(snake);
    mouse.render();

    if (captureFruit()) {
      snake.maxSegments += 5;
      randomFruit();
    }

    stroke(255, 0, 0);
    fill(255, 0, 0);
    shape(fruitShape, fruit.x, fruit.y);
  } else {
    stroke(255);
    noFill();
    ellipse(width/2, height/2, 40, 40);
    if (dist(mouseX, mouseY, width/2, height/2) <= 20) {
      gameOn = true;
      noCursor();
    }
  }
}

void mouseClicked() {
  snake.maxSegments += 5;
}

void randomFruit() {
  fruit.x = random(width - 60) + 30;
  fruit.y = random(height - 60) + 30;
}

boolean captureFruit() {
  PVector snakeHead = snake.getHead();
  if (snakeHead.dist(fruit) < 15) {
    return true;
  }
  return false;
}

/**
 * Returns the heading 0 <= heading < TAU
 * @param u A vector
 * @return u's heading 0 <= theta < TAU
 */
float tauHeading(PVector u) {
  float heading = u.heading();
  if (heading < 0) {
    heading = TAU + heading;
  }
  return heading;
}

/**
 * Given two angles 0 <= theta < TAU this will return
 * the shortest rotation between them
 * @param thetaA an angle 0 <= theta < TAU
 * @param thetaB an angle 0 <= theta < TAU
 * @return shortest rotation between
 */
float shortestRotation(float thetaA, float thetaB) {
  float[] rotations = new float[]{thetaB - thetaA, thetaB - thetaA + TAU, thetaB - thetaA - TAU};
  float rotation = rotations[0];
  if(abs(rotations[1]) < abs(rotation)) rotation = rotations[1];
  if(abs(rotations[2]) < abs(rotation)) rotation = rotations[2];
  return rotation;
}