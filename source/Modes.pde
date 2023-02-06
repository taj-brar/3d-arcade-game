final char KEY_VIEW = 'r'; // switch between orthographic and perspective views

// player character
final char KEY_LEFT = 'a';
final char KEY_RIGHT = 'd';
final char KEY_UP = 'w';
final char KEY_DOWN = 's';
final char KEY_SHOOT = ' ';

// useful for debugging to turn textures or collisions on/off
final char KEY_TEXTURE = 't';
final char KEY_COLLISION = 'c';

final char KEY_BONUS = 'b';

boolean doBonus = false;
boolean doTextures = false;
boolean doCollision = false;

boolean modeOrtho = true;

void keyPressed()
{
  // Act from input if game going
  if (!gameOver) {
    // Proceed based on key pressed
    switch (key) {
    case KEY_VIEW:
      switchViews();
      break;
    case KEY_LEFT:
      moveLeft = true;
      break;
    case KEY_RIGHT:
      moveRight = true;
      break;
    case KEY_UP:
      moveUp = true;
      break;
    case KEY_DOWN:
      moveDown = true;
      break;
    case KEY_SHOOT:
      playerShooting = true;
      break;
    case KEY_COLLISION:
      doCollision = !doCollision;
      break;
    case KEY_TEXTURE:
      doTextures = !doTextures;
      break;
    }// switch
  }// if
}// keyPressed

void keyReleased() {
  // Act from input if game going
  if (!gameOver) {
    // Proceed based on key released
    switch (key) {
    case KEY_LEFT:
      moveLeft = false;
      break;
    case KEY_RIGHT:
      moveRight = false;
      break;
    case KEY_UP:
      moveUp = false;
      break;
    case KEY_DOWN:
      moveDown = false;
      break;
    case KEY_SHOOT:
      playerShooting = false;
      break;
    }// switch
  }// if
}// keyReleased

/*
  This method switches between orthographic and perspective view by changing the
  camera location and the setting the appropriate projection matrix.
 */
void switchViews() {
  // Switch projection modes
  modeOrtho = !modeOrtho;

  // Proceed based on new mode
  if (modeOrtho) {
    // Change projection matrix and move camera
    setProjection(projectOrtho);
    camera(0, 0, 0, 0, 0, -F, 0, 1, 0);
  } else {
    // Change projection matrix and move camera
    setProjection(projectPerspective);
    camera(0, 0, -7.49, 0, 0, -F, 0, 1, 0);    // maps nicely
    //camera(0, -1, -7.2, 0, 0, -F, 0, 1, 0);    // has more perspective
  }// if-else

  // Print statement
  println("PROJECTION MODE: " + (modeOrtho ? "ORTHO" : "PERSPECTIVE"));
}// switchViews
