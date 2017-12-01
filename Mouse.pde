class Mouse {
  PShape body;
  float angle;
  float maximumRotation = TAU/32;
  PVector position;

  Mouse() {
    fill(255);
    noStroke();
    this.body = createShape(TRIANGLE, 0, -10, 0, 10, 30, 0);
    this.angle = 0;
    position = new PVector(mouseX, mouseY);
  }

  public void update() {
    updateAngle();
    position.x = mouseX;
    position.y = mouseY;
    cullVector(position, width>>1, height>>1, circleDiameter>>1);
  }

  public void render() {
    update();
    shape(body, position.x, position.y);
  }
  
  public void updateAngle() {
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
}