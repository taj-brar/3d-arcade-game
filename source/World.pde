final float PLAYER_RADIUS = PLAYER_SIZE*3/4;              // radius of player's hitbox
final float ENEMY_RADIUS = ENEMY_SIZE/3;                  // radius of enemy's hitbox
final float ENEMY_BULLET_RADIUS = ENEMY_BULLET_SIZE/2;    // radius of enemy's bullet hitbox
final float PLAYER_BULLET_RADIUS = PLAYER_BULLET_SIZE/2;  // radius of player's bullet hitbox

/*
  All textures that are used to create the game.
 */
enum Textures {
  enemy1,
    enemy2,
    enemy3,
    player,
    playerBullet,
    enemyBullet,
    tile1,
    tile2
}// Textures

/*
  This method checks collision between player, enemies, and bullets.
 */
void checkCollisions() {
  playerCollide();
  enemyCollide();
  bulletsCollide();
}// checkCollision

/*
  This method checks if a player collided with an enemy or their bullets.
 */
void playerCollide() {
  Enemy e;    // current enemy

  // Check if the player collides with any enemies or their bulletss
  for (int i=0; i<enemies.size(); i++) {
    // Get current enemt
    e = enemies.get(i);

    // Check if enemy collided with player
    playerEnemyCollision(e);

    // Check if the player collides with any bullets from this enemy
    for (int j=0; j<e.enemyBullets.bullets.size(); j++) {
      // Check if bullet collides with player
      playerBulletCollision(e, e.enemyBullets.bullets.get(j));
    }// for
  }// for
}// playerCollide

/*
  This method checks if an enemy collided with any player bullets.
 */
void enemyCollide() {
  Enemy e;    // current enemy

  // Check each enemy
  for (int i=0; i<enemies.size(); i++) {
    // Get current enemy
    e = enemies.get(i);

    // Check if the enemy collides with any player bullets
    for (int j=0; j<playerBullets.bullets.size(); j++) {
      enemyBulletCollision(e, playerBullets.bullets.get(j));
    }// for
  }// for
}// enemyCollide

/*
  This method checks if an enemy bullet and a player bullet collided.
 */
void bulletsCollide() {
  Enemy e;                    // current enemy
  boolean removed = false;    // boolean to track if a bullet has been removed

  // Check each enemy
  for (int i=0; i<enemies.size(); i++) {
    // Get current enemy
    e = enemies.get(i);

    // Check all bullets
    for (int k=0; k<e.enemyBullets.bullets.size(); k++) {
      removed = false;

      // Check if the enemy bullets collides with any player bullets
      for (int j=0; j<playerBullets.bullets.size() && !removed; j++) {
        removed = twoBulletCollision(e, e.enemyBullets.bullets.get(k), playerBullets.bullets.get(j));
      }// for
    }// for
  }// for
}// bulletCollide

/*
  This method checks if two bullets collided and destroys them if they did.
 */
Boolean twoBulletCollision(Enemy e, Bullet enemyBullet, Bullet playerBullet) {
  PVector enemyBulletLocation = new PVector(enemyBullet.xPos, enemyBullet.yPos);
  PVector playerBulletLocation = new PVector(playerBullet.xPos, playerBullet.yPos);
  float radiiSum = PLAYER_BULLET_RADIUS+ENEMY_BULLET_RADIUS;
  float dist;
  Boolean collision = false;

  // Get distance between locations
  dist = PVector.dist(enemyBulletLocation, playerBulletLocation);

  // Check for collision
  if (dist <= radiiSum) {
    collision = true;

    // Destroy enemy and player bullets
    destroyBullet(e, enemyBullet);
    destroyBullet(null, playerBullet);
  }// if

  return collision;
}// twoBulletCollision

/*
  This method checks if a player and enemy collided and destroys them if they did.
 */
void playerEnemyCollision(Enemy e) {
  PVector enemyLocation = new PVector(e.xPos, e.yPos);
  PVector playerLocation = new PVector(xPlayer, yPlayer);
  float radiiSum = PLAYER_RADIUS + ENEMY_RADIUS;
  float dist;

  // Get distance between locations
  dist = PVector.dist(enemyLocation, playerLocation);

  // Check for collision
  if (dist <= radiiSum) {
    // Destroy enemy and player
    destroyEnemy(e);
    destroyPlayer();
  }// if
}// playerEnemyCollision

/*
  This method checks if a player and enemy bullet collided and destroys them if they did.
 */
void playerBulletCollision(Enemy e, Bullet b) {
  PVector bulletLocation = new PVector(b.xPos, b.yPos);
  PVector playerLocation = new PVector(xPlayer, yPlayer);
  float radiiSum = PLAYER_RADIUS + ENEMY_BULLET_RADIUS;
  float dist;

  // Get distance between locations
  dist = PVector.dist(bulletLocation, playerLocation);

  // Check for collision
  if (dist <= radiiSum) {
    // Destroy enemy and player
    destroyBullet(e, b);
    destroyPlayer();
  }// if
}// playerBulletCollision

/*
  This method checks if an enemy and player bullet collided and destroys them if they did.
 */
void enemyBulletCollision(Enemy e, Bullet b) {
  // Proceed if enemy is alive
  if (e.alive) {
    PVector bulletLocation = new PVector(b.xPos, b.yPos);
    PVector enemyLocation = new PVector(e.xPos, e.yPos);
    float radiiSum = ENEMY_RADIUS + PLAYER_BULLET_RADIUS;
    float dist;

    // Get distance between locations
    dist = PVector.dist(bulletLocation, enemyLocation);

    // Check for collision
    if (dist <= radiiSum) {
      // Destroy enemy and player
      destroyBullet(null, b);
      destroyEnemy(e);
    }// if
  }// if
}// enemyBulletCollision

/*
  This method destroys a given enemy and adds an explosion at that location.
 */
void destroyEnemy(Enemy e) {
  e.alive = false;

  // Create an explosion at enemy location
  explosions.add(new Explosion(e.xPos, e.yPos));
}// destroyEnemy

/*
  This method destroys a given bullet.
 */
void destroyBullet(Enemy e, Bullet b) {
  if (e != null)
    e.enemyBullets.bullets.remove(b);
  else
    playerBullets.bullets.remove(b);
}// destroyEnemy

/*
  This method destroys the player, adds an explosion at that location, and ends the game.
 */
void destroyPlayer() {
  // Create an explosion at enemy location
  explosions.add(new Explosion(xPlayer, yPlayer));
  endGame();
}// destroyPlayer

/*
  This method ends the game and stops any player movement/shootin.
 */
void endGame() {
  gameOver = true;
  moveLeft = false;
  moveRight = false;
  moveUp = false;
  moveDown = false;
  playerShooting = false;
}// endGame

/*
  This method runs all the current explosions and removes any dead explosions.
 */
void runExplosions() {
  Explosion e;    // current explosion

  // Loop through all explosions
  for (int i=0; i<explosions.size(); i++) {
    e = explosions.get(i);

    // Run each explosion
    e.run();

    // Check if explosion should be removed
    if (!e.alive)
      explosions.remove(e);
  }// for
}// runExplosions

/*
  This method sets up all the images used for textures.
 */
void setupImages() {
  PLAYER_IMAGE = loadImage(PLAYER_FILE_NAME);
  ENEMY_IMAGE1 = loadImage(ENEMY_FILE1_NAME);
  ENEMY_IMAGE2 = loadImage(ENEMY_FILE2_NAME);
  ENEMY_IMAGE3 = loadImage(ENEMY_FILE3_NAME);
  PLAYER_BULLET_IMAGE = loadImage(PLAYER_BULLET_FILE_NAME);
  ENEMY_BULLET_IMAGE = loadImage(ENEMY_BULLET_FILE_NAME);
  SIDE_TILE_IMAGE = loadImage(SIDE_TILE_NAME);
  TOP_TILE_IMAGE1 = loadImage(TOP_TILE_NAME1);
  TOP_TILE_IMAGE2 = loadImage(TOP_TILE_NAME2);
}// setupImages


/*
  This method draws a cube in model space.
 */
void drawCube(float[] cubeColor, Textures t) {
  // Proceed based on type of cube
  if (!doTextures)
    drawColouredCube(cubeColor);
  else
    drawTexturedCube(t);
}// drawCube

/*
  This method draws a cube for a particle in model space.
 */
void drawParticleCube(float[] cubeColor) {
  drawColouredCube(cubeColor);
}// drawCube

/*
  This method draws a textured cube in model space, given the texture.
 */
void drawTexturedCube(Textures t) {
  // Draw front face
  beginShape(QUADS);
  if (t == Textures.tile1 || t == Textures.tile2)
    texture(SIDE_TILE_IMAGE);
  vertex(-1, -1, -1, 0, 0);
  vertex(1, -1, -1, 1, 0);
  vertex(1, -1, 1, 1, 1);
  vertex(-1, -1, 1, 0, 1);

  // Draw back face
  vertex(-1, 1, -1, 0, 0);
  vertex(1, 1, -1, 1, 0);
  vertex(1, 1, 1, 1, 1);
  vertex(-1, 1, 1, 0, 1);

  // Draw left face
  vertex(-1, 1, -1, 1, 0);
  vertex(-1, -1, -1, 0, 0);
  vertex(-1, -1, 1, 0, 1);
  vertex(-1, 1, 1, 1, 1);

  // Draw right face
  vertex(1, 1, -1, 1, 0);
  vertex(1, -1, -1, 0, 0);
  vertex(1, -1, 1, 0, 1);
  vertex(1, 1, 1, 1, 1);

  // Draw bottom face
  vertex(-1, -1, -1, 0, 0);
  vertex(1, -1, -1, 1, 0);
  vertex(1, 1, -1, 1, 1);
  vertex(-1, 1, -1, 0, 1);
  endShape();

  // Draw top face
  beginShape(QUAD);
  if (t == Textures.tile1)
    texture(TOP_TILE_IMAGE1);
  else if (t == Textures.tile2)
    texture(TOP_TILE_IMAGE2);
  vertex(-1, -1, 1, 0, 0);
  vertex(1, -1, 1, 1, 0);
  vertex(1, 1, 1, 1, 1);
  vertex(-1, 1, 1, 0, 1);
  endShape();
}// drawTexturedCube

/*
  This method draws a coloured cube in model space, given the colour.
 */
void drawColouredCube(float[] colour) {
  fill(colour[RED], colour[GREEN], colour[BLUE]);
  noStroke();

  beginShape(QUADS);
  // Draw front face
  vertex(-1, -1, -1);
  vertex(1, -1, -1);
  vertex(1, -1, 1);
  vertex(-1, -1, 1);

  // Draw back face;
  vertex(-1, 1, -1);
  vertex(1, 1, -1);
  vertex(1, 1, 1);
  vertex(-1, 1, 1);

  // Draw left face
  vertex(-1, 1, -1);
  vertex(-1, -1, -1);
  vertex(-1, -1, 1);
  vertex(-1, 1, 1);

  // Draw right face
  vertex(1, 1, -1);
  vertex(1, -1, -1);
  vertex(1, -1, 1);
  vertex(1, 1, 1);

  // Draw bottom face
  vertex(-1, -1, -1);
  vertex(1, -1, -1);
  vertex(1, 1, -1);
  vertex(-1, 1, -1);

  // Draw top face
  vertex(-1, -1, 1);
  vertex(1, -1, 1);
  vertex(1, 1, 1);
  vertex(-1, 1, 1);
  endShape();
}// drawColouredCube

/*
  This method draws a textured or coloured cube in model space, given the texture/colour.
 */
void drawSquare(float[] colour, Textures t) {
  // Check if textured
  if (t == null)
    drawColouredSquare(colour);
  else
    drawTexturedSquare(t);
}// drawSquare

/*
  This method draws a coloured square in model space, given the colour.
 */
void drawColouredSquare(float[] colour) {
  fill(colour[RED], colour[GREEN], colour[BLUE]);

  beginShape(QUAD);

  // Draw square
  vertex(-1, -1, 0, 1);
  vertex(1, -1, 1, 1);
  vertex(1, 1, 1, 0);
  vertex(-1, 1, 0, 0);

  endShape();
}// drawColouredSquare

/*
  This method draws a textured square in model space, given the texture.
 */
void drawTexturedSquare(Textures t) {
  beginShape(QUAD);

  // Choose correct shading
  if (t == Textures.player)
    texture(PLAYER_IMAGE);
  else if (t == Textures.enemy1)
    texture(ENEMY_IMAGE1);
  else if (t == Textures.enemy2)
    texture(ENEMY_IMAGE2);
  else if (t == Textures.enemy3)
    texture(ENEMY_IMAGE3);
  else if (t == Textures.enemyBullet)
    texture(ENEMY_BULLET_IMAGE);
  else if (t == Textures.playerBullet)
    texture(PLAYER_BULLET_IMAGE);
  
  // Draw sqaure
  vertex(-1, -1, 0, 1);
  vertex(1, -1, 1, 1);
  vertex(1, 1, 1, 0);
  vertex(-1, 1, 0, 0);

  endShape();
}// drawColouredSquare
