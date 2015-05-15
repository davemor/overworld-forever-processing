class Camera {
  float x, y;
  float zoom = 1.0f;
  boolean mouseWasPressed = false;

  Camera() {
    x = -width/2;
    y = -height/2;
  }

  void begin() {
    update();
    pushMatrix();
    translate(width/2, height/2);
    scale(zoom);
    translate(x, y);
  }
  void end() {
    popMatrix();
  }
  PVector transformScreenToWorld(float ix, float iy) {
    ix -= width/2;
    iy -= height/2;
    ix /= zoom;
    iy /= zoom;
    ix -= x;
    iy -= y;
    return new PVector(ix, iy);
  }
  private void update() {
    // pan
    if (mousePressed) {
      if (mouseWasPressed && (mouseButton == RIGHT)) {
        x += (mouseX - pmouseX) / zoom;
        y += (mouseY - pmouseY) / zoom;
      } 
      else {
        mouseWasPressed = true;
      }
    } 
    else {
      mouseWasPressed = false;
    }
    // zoom on keys
    if (keyPressed) {
      if (key == 'w') {
        zoom *= 1.05f;
      }
      if (key == 's') {
        zoom *= 0.95f;
      }
    }
  }
}

