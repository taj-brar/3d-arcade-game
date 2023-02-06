ArrayList<Enemy> enemies = new ArrayList<Enemy>();    // list of all enemies
int numEnemies = 0;                                   // number of enemies that exist
int numSpawned = 0;                                   // total number of enemies spawned
float currentShootSpacing = 60;                       // current frames before an enemy can shoot again
float currentBulletSpeed = 0.005;                     // current speed of enemy bullets
final int MAX_ENEMIES = 5;                            // maximum number of enemies allowed
final int MAX_BULLETS = 3;                            // maximum number of bullets an enemy can have in existance
final int ENEMY_MAX_FRAMES = 120;                     // maximum number of frames the enemy can have a given texture
final float DELTA_SHOOT_SPACING = 1/3f;               // change in frames before an enemy can shoot again
final float DELTA_BULLET_SPEED = 0.0005;              // change in speed of enemy bullets
final float ENEMY_SIZE = 0.15;                        // size of enemy in world
final float ENEMY_SHOOT_RANGE = 1;                    // range within which enemy "sees" player
final float ENEMY_BULLET_SIZE = PLAYER_SIZE/4;        // size of enemy bullets
final float ENEMY_HEIGHT = PLAYER_HEIGHT - 0.15;      // z coordiante of enemies
final float[] ENEMY_COLOUR = {0, 0, 0};               // colour of enemies

/*
  This method adds the max number of enemies to start.
 */
void setupEnemies() {
  // Add max number of enemies
  for (int i=0; i<MAX_ENEMIES; i++) {
    addEnemy();
  }// for
}// setupEnemies

/*
  This method adds an enemy to the list.
 */
void addEnemy() {
  enemies.add(new Enemy());
  numEnemies++;
}// addEnemy

/*
  This method returns the next texture for the enemy.
 */
Textures nextEnemyTexture(Textures currTexture) {
  Textures t = null;

  if (currTexture == Textures.enemy1)
    t = Textures.enemy2;
  else if (currTexture == Textures.enemy2)
    t = Textures.enemy3;
  else if (currTexture == Textures.enemy3)
    t = Textures.enemy1;

  return t;
}// nextEnemyTexture

/*
  This method runs all enemys in the list.
 */
void runEnemies() {
  Enemy e;    // current enemy in list

  // Loop through all enemies in list
  for (int i=0; i<enemies.size(); i++) {
    // Get enemy and run it
    e = enemies.get(i);
    e.run();

    // Check if dead and no bullets
    if (!e.alive && e.enemyBullets.bullets.size() == 0) {
      enemies.remove(e);
      numEnemies--;
    }// if
  }// for

  // Add a new enemy if one died
  if (numEnemies < MAX_ENEMIES) {
    increaseDifficulty();
    addEnemy();
  }// if
}// runEnemies

/*
  This method increases the game difficulty by making the
 enemy shoot more frequently with bullets that travel faster.
 */
void increaseDifficulty() {
  // Decrease shoot spacing
  if (currentShootSpacing > DELTA_SHOOT_SPACING)
    currentShootSpacing -= DELTA_SHOOT_SPACING;

  // Increase bullet speed
  currentBulletSpeed += DELTA_BULLET_SPEED;
}// increaseDifficulty

/*
  This class implements an enemy for the game.
 */
class Enemy {
  int enemyNumber;       // enemy ID
  int framesSinceShot;   // frames since the enemy last shot
  int frameAge;          // number of frames passed since last shot
  float xPos;            // x coordinate of the enemy
  float yPos;            // y coordiante of the enemy
  float shootSpacing;    // number of frames that must pass before shooting
  float bulletSpeed;     // speed of the bullets shot by enemy
  Bullets enemyBullets;  // bullets shot by this enemy
  Boolean alive;         // Boolean to track if enemy is alive
  Textures texture;      // Current texture of the enemy

  int counter;              // counter used for keyframes
  int startFrame, endFrame; // startFrame and endFrame indices of current keyframe

  /*
    This method creates a new enemy.
   */
  Enemy() {
    // Get enemy ID
    enemyNumber = numSpawned++;

    // Initialize varaibles used for key frames
    counter = 0;
    startFrame = enemyNumber%NUM_KEY_FRAMES;
    endFrame = (startFrame+1)%NUM_KEY_FRAMES;

    // Initialize enemy
    xPos = keyFrames[startFrame][X];
    yPos = keyFrames[startFrame][Y];
    enemyBullets = new Bullets();
    shootSpacing = currentShootSpacing;
    bulletSpeed = currentBulletSpeed;
    framesSinceShot = 0;
    frameAge = 0;
    texture = Textures.enemy1;
    alive = true;
  }// Enemy - constructor

  /*
    This method runs the enemy.
   */
  void run() {
    if (alive == true) {
      drawEnemy();

      if (!gameOver) {
        moveEnemy();
        shootAtPlayer();
        updateCounter();
        frameAge++;

        if (frameAge%ENEMY_MAX_FRAMES == 0) {
          frameAge = 0;

          texture = nextEnemyTexture(texture);
        }// if
      }// if
    }// if

    enemyBullets.run();
  }// run

  /*
  This method moves the enemy based on keyframes.
   */
  void moveEnemy() {
    // Get parameter for lerping
    float t = (float)counter/numSteps[startFrame];
    float tPrime = 0.5*(1-cos(PI*t));

    xPos = lerp(keyFrames[startFrame][0], keyFrames[endFrame][0], tPrime);
    yPos = lerp(keyFrames[startFrame][1], keyFrames[endFrame][1], tPrime);
  }// moveEnemy

  /*
    This method draw the enemy at its current location.
   */
  void drawEnemy() {
    // Draw enemy
    pushMatrix();

    // Modify square
    translate(xPos, yPos, ENEMY_HEIGHT);
    scale(ENEMY_SIZE, ENEMY_SIZE, 1);

    // Draw square with texture or not
    if (doTextures)
      drawSquare(null, texture);
    else
      drawSquare(ENEMY_COLOUR, null);

    popMatrix();
  }// drawPlayer

  /*
    This method make the enemy shoot at the player if it is within range.
   */
  void shootAtPlayer() {
    PVector playerLocation = new PVector(xPlayer, yPlayer);
    PVector enemyLocation = new PVector(xPos, yPos);
    PVector direction;

    // Check if enemy within range of player and can shoot more
    if (PVector.dist(playerLocation, enemyLocation) < ENEMY_SHOOT_RANGE
      && enemyBullets.bullets.size() < MAX_BULLETS) {

      // Check if it has been enough time between shots
      if (framesSinceShot > shootSpacing) {
        // Get direction of bullets
        direction = playerLocation;
        direction.sub(new PVector(xPos, yPos));

        // Shoot bullet in that direction
        enemyBullets.add(xPos, yPos, direction, bulletSpeed, Textures.enemyBullet, ENEMY_BULLET_SIZE);

        // Reset counter since bullet shot
        framesSinceShot = 0;
      } else {
        // Bullet not shot - increment counter
        framesSinceShot++;
      }// if-else
    }// if
  }// shootAtPlayer

  /*
    This method updates the counter used to lerp between keyframes.
   */
  private void updateCounter() {
    // Update counter
    counter++;

    // Check if the keyframe needs to be updated
    if (counter >= numSteps[startFrame]) {
      // Move to next frame
      startFrame = (startFrame+1) % NUM_KEY_FRAMES;
      endFrame = (endFrame+1) % NUM_KEY_FRAMES;

      // Reset counter
      counter = 0;
    }// if
  }// updateCounter
}// class end Enemy
