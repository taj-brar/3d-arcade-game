final float MAX_DIST = 4;                          // maximum distance that can be travelled by a bullet
final float DELTA_ANGLE = PI/20;                   // change in bullet angle every frame
final float[] BULLET_COLOUR = {0, 0, 1};           // colour of the bullet
final float BULLET_HEIGHT = PLAYER_HEIGHT - 0.14;  // z cooridnate of the bullets

/*
  This class implements bullets for a given enitity (player/enemy).
 */
class Bullets {
  ArrayList<Bullet> bullets;    // list of all bullets

  /*
   Create Bullets object
   */
  Bullets() {
    // Initialize ArrayList
    bullets = new ArrayList<Bullet>();
  }// Bullets - constructor

  /*
    This method runs this set of bullets.
   */
  void run() {
    // Remove dead bullets
    removeDeadBullets();

    // Run all bullets in ArrayList
    for (int i=0; i<bullets.size(); i++)
      bullets.get(i).run();
  }// run

  /*
    This method removes all dead bullets from this set of objects.
   */
  void removeDeadBullets() {
    // Loop through all bullets
    for (int i=0; i<bullets.size(); i++) {
      // Remove bullet if its dead
      if (!bullets.get(i).alive)
        bullets.remove(i);
    }// for
  }// removeDeadBullets

  /*
  This method adds a bullet given its coords., direction, speed, texture, and size
   */
  void add(float xStart, float yStart, PVector towards, float speed, Textures t, float size) {
    // Create new bullet and insert into ArrayList
    Bullet b = new Bullet(xStart, yStart, towards, speed, t, size);
    bullets.add(b);
  }// addBullet
}// end class Bullets

/*
  This class implements a single bullet.
 */
class Bullet {
  float xPos;
  float yPos;
  float distTravelled;
  float speed;
  float bulletSize;
  float angle;
  boolean alive;
  PVector direction;
  Textures texture;

  /*
   This method creates a bullet given its coords., direction, speed, texture, and size.
   */
  Bullet(float xStart, float yStart, PVector towards, float bulletSpeed, Textures t, float size) {
    // Instantiate object
    xPos = xStart;
    yPos = yStart;
    alive = true;
    direction = towards;
    speed = bulletSpeed;
    texture = t;
    bulletSize = size;
    distTravelled = 0;
    angle = 0;
  }// Bullet - constructor

  /*
    This method runs this bullet.
   */
  void run() {
    // Draw bullet
    drawBullet();

    // Move bullet if game running
    if (!gameOver)
      moveBullet();
  }// run

  /*
    This method moves the bullet.
   */
  void moveBullet() {
    // Get angle with horizontal
    float angle = direction.heading();

    // Move bullet in dir.
    xPos += cos(angle)*speed;
    yPos += sin(angle)*speed;
    distTravelled += speed;

    // Check if beyond death point
    if (distTravelled > MAX_DIST)
      alive = false;

    // Update the angle
    updateAngle();
  }// moveBullet

  /*
    This method updates the angle of the bullet.
   */
  void updateAngle() {
    // Get new angle based on delta
    angle = (angle + DELTA_ANGLE) % TWO_PI;
  }// updateAngle

  /*
    This method draws the bullet at its current location.
   */
  void drawBullet() {
    pushMatrix();

    // Color bullet
    fill(255, 0, 0);

    // Draw bullet at correct size and location
    translate(xPos, yPos, BULLET_HEIGHT);
    rotate(angle);
    scale(bulletSize);
    if (doTextures)
      drawSquare(null, texture);
    else
      drawSquare(BULLET_COLOUR, null);

    popMatrix();
  }// drawBullet
}// end class Bullet
