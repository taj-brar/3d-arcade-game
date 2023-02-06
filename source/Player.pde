final float MOVE_SPEED = 0.02;                        // movement speed of player
final float LOWER_X_BOUND = -1+PLAYER_SIZE;           // lower x constraint for player location
final float UPPER_X_BOUND = 1-PLAYER_SIZE;            // upper x constraint for player location
final float LOWER_Y_BOUND = -1+PLAYER_SIZE;           // lower y constraint for player location
final float UPPER_Y_BOUND = 1-PLAYER_SIZE;            // upper y constraint for player location
final float HOME_X = 0;                               // x coord. of "home"
final float HOME_Y = -0.8;                            // y coord. of "home"
final float HOME_ERROR = 0.005;                       // margin of error in "home" location to prevent jittering
final float DRIFT_SPEED  = MOVE_SPEED/5;              // speed player drifts back to "home" at
final float PLAYER_BULLET_SPEED = 0.05;               // speed of player's bullets
final float ROTATION_ANGLE = PI/7;                    // angle by which player rotates while moving
final float PLAYER_BULLET_SIZE = PLAYER_SIZE/3;       // size of player's bullets
final PVector BULLET_DIRECTION = new PVector(0, 1);   // direction player shoots in (straight up)
final float[] PLAYER_COLOUR = {1, 1, 1};              // colour of player's square
final int SHOOT_SPACING = 5;                          // number of frames that must pass before player can shoot again
int framesSinceShot = SHOOT_SPACING;                  // number of frames since player has shot

float xPlayer = 0;                        // x coord. of player
float yPlayer = -0.7;                     // y coord. of player
boolean moveLeft = false;                 // boolean to track if player is moving left
boolean moveRight = false;                // boolean to track if player is moving right
boolean moveUp = false;                   // boolean to track if player is moving up
boolean moveDown = false;                 // boolean to track if player is moving down
boolean playerShooting = false;           // boolean to track if player is shootin
Bullets playerBullets = new Bullets();    // bullets shot by player

/*
  This method makes the player shoot a bullet.
 */
void playerShoots() {
  // Shoot if not recently shot
  if (framesSinceShot == SHOOT_SPACING) {
    // Reset tracker
    framesSinceShot = 0;

    // Add new bullet at player's location
    playerBullets.add(xPlayer, yPlayer, BULLET_DIRECTION, PLAYER_BULLET_SPEED, Textures.playerBullet, PLAYER_BULLET_SIZE);
  } else
    framesSinceShot++;
}// playerShoots

/*
  This method draws the player at its current location.
 */
void drawPlayer() {
  // Check if player should be rotated or not
  float rotationX = (moveRight || moveLeft) ? ROTATION_ANGLE : 0;
  float rotationY = (moveUp || moveDown) ? ROTATION_ANGLE : 0;

  // Flip sign based on direction
  if (moveLeft)
    rotationX = -rotationX;
  if (moveUp)
    rotationY = - rotationY;

  // Draw player
  pushMatrix();
  // Color player
  fill(PLAYER_COLOUR[RED], PLAYER_COLOUR[GREEN], PLAYER_COLOUR[BLUE]);
  // Apply transformations
  translate(xPlayer, yPlayer, PLAYER_HEIGHT);
  rotateY(rotationX);
  rotateX(rotationY);
  scale(PLAYER_SIZE, PLAYER_SIZE, 1);

  // Draw sqaure coloured or textured square
  if (doTextures)
    drawSquare(null, Textures.player);
  else
    drawSquare(PLAYER_COLOUR, null);

  popMatrix();
}// drawPlayer

/*
  This method updates the flags for player movement and drifts home if needed.
 */
void updatePlayer() {
  // Check for flags
  if (moveLeft)
    movePlayerLeft(MOVE_SPEED);
  if (moveRight)
    movePlayerRight(MOVE_SPEED);
  if (moveUp)
    movePlayerUp(MOVE_SPEED);
  if (moveDown)
    movePlayerDown(MOVE_SPEED);
  if (playerShooting)
    playerShoots();

  // Check if no user input
  if (!moveLeft && !moveRight && !moveUp && !moveDown)
    // Drift player home
    driftHome();
}// movePlayer

/*
  This method moves the player towards its "home" location at a set speed.
 */
void driftHome() {
  // Proceed based on current x position
  if ((xPlayer - HOME_X) > HOME_ERROR)
    // Move left
    movePlayerLeft(DRIFT_SPEED);
  else if ((HOME_X - xPlayer) > HOME_ERROR)
    // Move right
    movePlayerRight(DRIFT_SPEED);

  // Proceed based on current y position
  if ((yPlayer - HOME_Y) > HOME_ERROR)
    // Move down
    movePlayerDown(DRIFT_SPEED);
  else if ((HOME_Y - yPlayer) > HOME_ERROR)
    // Move up
    movePlayerUp(DRIFT_SPEED);
}// driftHome

/*
  This method moves the player left at a given speed, while keeping it within bounds.
 */
void movePlayerLeft(float speed) {
  xPlayer = constrain(xPlayer-speed, LOWER_X_BOUND, UPPER_X_BOUND);
}// movePlayerLeft

/*
  This method moves the player right at a given speed, while keeping it within bounds.
 */
void movePlayerRight(float speed) {
  xPlayer = constrain(xPlayer+speed, LOWER_X_BOUND, UPPER_X_BOUND);
}// movePlayerLeft

/*
  This method moves the player up at a given speed, while keeping it within bounds.
 */
void movePlayerUp(float speed) {
  yPlayer = constrain(yPlayer+speed, LOWER_Y_BOUND, UPPER_Y_BOUND);
}// movePlayerLeft

/*
  This method moves the player down at a given speed, while keeping it within bounds.
 */
void movePlayerDown(float speed) {
  yPlayer = constrain(yPlayer-speed, LOWER_Y_BOUND, UPPER_Y_BOUND);
}// movePlayerLeft
