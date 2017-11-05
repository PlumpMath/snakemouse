class Mouse {
  PShape body;
  float angle;
  float maximumRotation = TAU/32;

  Mouse() {
    this.body = loadShape("mouse.svg");
    this.angle = 0;
  }

  void render() {
    updateAngle();
    shape(body, mouseX, mouseY);
  }
  
  void updateAngle() {
    PVector mouseDirection = new PVector(mouseX - pmouseX, mouseY - pmouseY);
    
    if(mouseDirection.mag() < 2)
      return;
      
    float targetAngle = tauHeading(mouseDirection);
    float targetDifference = shortestRotation(angle, targetAngle);
    float rotation = abs(targetDifference) < maximumRotation ? angle - targetAngle : maximumRotation * Math.signum(targetDifference);
    body.rotate(rotation);
    angle += rotation;
    angle %= TAU;
  }

  void squeak(Snake snake) {
    PVector dangerNoodle = snake.getHead();
    PVector vectorToDangerNoodle = new PVector(mouseX - dangerNoodle.x, mouseY - dangerNoodle.y);
    float distanceToDangerNoodle = vectorToDangerNoodle.mag();
    if (distanceToDangerNoodle < 100) {
      stroke(255, 0, 0);
      strokeWeight(1);
      noFill();
      float threatAngle = PI + vectorToDangerNoodle.heading();
      for(int i = 70; i <= 150; i += 20) {
        arc(mouseX, mouseY, i, i, threatAngle - PI/8, threatAngle + PI/8);
      }
    }
  }
}