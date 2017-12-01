int score;
Snake snake;
Mouse mouse;
PShape fruitShape;
PVector fruit;
boolean gameOn, presentScore;
int circleDiameter;
int gameFrames;

public void setup() {
  // Frame and rendering setup
  size(800, 800);
  noCursor();
  smooth();
  noStroke();
  fill(255);
  frameRate(60);

  // Globals setup
  score = 0;

  fruitShape = createShape(ELLIPSE, 0, 0, 20, 20);
  fruit = new PVector();
  gameOn = false;
  presentScore = false;
  circleDiameter = (width - 150);
}

public void draw() {
  background(0);
  textSize(10);
  text("snakemouse by Alistair Carscadden", 10, height - 10);
  line(mouseX, mouseY, mouseX, mouseY); // Draw a clarity dot for cursor outside of circle

  if (gameOn) {
    gameFrames++;
    strokeWeight(1);
    noFill();
    ellipse(400, 400, circleDiameter, circleDiameter);

    textSize(30);
    text(score, width>>1, 50);

    snake.addSegment();
    snake.updatePosition(mouse.position);
    snake.render();

    mouse.render();

    if (captureFruit()) {
      snake.maxSegments += 5;
      score += 1;
      randomFruit();
    }

    shape(fruitShape, fruit.x, fruit.y);

    if (gameFrames > 60)
      checkLose();
  } else {
    stroke(255);
    strokeWeight(1);
    noFill();
    ellipse(width/2, height/2, 40, 40);

    if (presentScore) {
      textSize(30);
      text(String.format("You died!\nYou got %d %s!", score, score != 1 ? "points" : "point"), 30, 50);
    } else {
      textSize(30);
      text("Mouse over the circle to start.\n\nYou will have 1 second to run away\nfrom the snake or it'll eat you!", 30, 50);
    }

    if (dist(mouseX, mouseY, width/2, height/2) <= 20) {
      newGame();
    }
  }
}

public void newGame() {
  gameOn = true;
  presentScore = false;
  gameFrames = 0;
  score = 0;
  snake = new Snake();
  mouse = new Mouse();
  randomFruit();
}

public void checkLose() {
  boolean lose = false;
  if (snake.getHead().dist(mouse.position) < 6) {
    lose = true;
  }

  final int safeLength = 5; // 5 segments in either direction dont count

outside:
  for (int i = snake.segments.size() - 1; i >= 0; --i) {
    for (int j = snake.segments.size() - 1; j >= 0; --j) {
      if (abs(i-j) > safeLength) {
        if (snake.segments.get(i).intersects(snake.segments.get(j))) {
          lose = true;
          break outside;
        }
      }
    }
  }

  if (lose) {
    presentScore = true;
    gameOn = false;
  }
}

public void randomFruit() {
  fruit.x = random(width - 60) + 30;
  fruit.y = random(height - 60) + 30;
  cullVector(fruit, width>>1, height>>1, circleDiameter/2 - 40);
}

public boolean captureFruit() {
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
public float tauHeading(PVector u) {
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
public float shortestRotation(float thetaA, float thetaB) {
  float[] rotations = new float[]{thetaB - thetaA, thetaB - thetaA + TAU, thetaB - thetaA - TAU};
  float rotation = rotations[0];
  if (abs(rotations[1]) < abs(rotation)) rotation = rotations[1];
  if (abs(rotations[2]) < abs(rotation)) rotation = rotations[2];
  return rotation;
}

public void cullVector(PVector vector, float aboutX, float aboutY, float cullingRadius) {
  vector.x -= aboutX;
  vector.y -= aboutY;
  if (vector.mag() > cullingRadius) {
    vector.setMag(cullingRadius);
  }
  vector.x += aboutX;
  vector.y += aboutY;
}