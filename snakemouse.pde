Snake snake = new Snake();
PVector fruit = new PVector();
boolean gameOn = false;

void setup() {
  size(800, 600);
  randomFruit();
}

void draw() {
  background(0);
  if (gameOn) {
    snake.addSegment();
    snake.updatePosition();
    snake.render();
    
    if(captureFruit()) {
      snake.maxSegments += 5;
      randomFruit();
    }
    
    stroke(255, 0, 0);
    fill(255, 0, 0);
    ellipse(fruit.x, fruit.y, 5, 5);
  } else {
    stroke(255);
    noFill();
    ellipse(width/2, height/2, 40, 40);
    if (dist(mouseX, mouseY, width/2, height/2) <= 20) {
      gameOn = true;
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
  if(snakeHead.dist(fruit) < 15) {
    return true; 
  }
  return false;
}