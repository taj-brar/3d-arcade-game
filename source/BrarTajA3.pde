Grid g1 = new Grid();    // first grid used to draw tiles
Grid g2 = new Grid();    // second grid used to draw tiles and create illusion of a continuous grid

final float L = -1;      // left coordinate of the frustum
final float R = 1;       // right coordinate of the frustum
final float B = -1;      // bottom cooridante of the frustum
final float T = 1;       // top coordinate of the frustum
final float N = 1;       // distance to near plane
final float F = 10;      // distance to far plane

final float PLAYER_HEIGHT = -F+1.35;  // z coordinate of the player
final float PLAYER_SIZE = 0.15;       // size of the player
final float GRID_SIZE = 6;            // size of a grid of tiles
final float SPEED = -0.01;            // speed at which a grid moves
float positionG1 = 0;                 // starting position of the first grid (center of screen)
float positionG2 = GRID_SIZE;         // starting position of the second grid (above first grid)
boolean gameOver = false;             // boolean to track if game is over or not

// Set up images for textures
final String PLAYER_FILE_NAME = "player.png";
final String ENEMY_FILE1_NAME = "enemy1.png";
final String ENEMY_FILE2_NAME = "enemy2.png";
final String ENEMY_FILE3_NAME = "enemy3.png";
final String PLAYER_BULLET_FILE_NAME = "playerBullet.png";
final String ENEMY_BULLET_FILE_NAME = "enemyBullet.png";
final String SIDE_TILE_NAME = "sideTile.png";
final String TOP_TILE_NAME1 = "topTile1.png";
final String TOP_TILE_NAME2 = "topTile2.png";
PImage PLAYER_IMAGE;
PImage ENEMY_IMAGE1;
PImage ENEMY_IMAGE2;
PImage ENEMY_IMAGE3;
PImage PLAYER_BULLET_IMAGE;
PImage ENEMY_BULLET_IMAGE;
PImage SIDE_TILE_IMAGE;
PImage TOP_TILE_IMAGE1;
PImage TOP_TILE_IMAGE2;

void setup() {
  size(640, 640, P3D); // change the dimensions if desired
  colorMode(RGB, 1.0f);
  textureMode(NORMAL); // use normalized 0..1 texture coords
  textureWrap(REPEAT);

  setupPOGL();
  setupProjections();
  resetMatrix(); // do this here and not in draw() so that you don't reset the camera

  // do any additional setup here
  // Initialize grids
  g1.initializeGrid();
  g2.initializeGrid();

  // Setup enemies and their keyframes
  setupKeyframes();
  setupEnemies();

  // Set up textures from images
  setupImages();
}// setup

void draw() {
  // Draw grids at their positions
  drawGridAtPosition(g1, positionG1);
  drawGridAtPosition(g2, positionG2);

  // Run enemies
  runEnemies();

  // Play game while not done
  if (!gameOver) {
    // Move grids across screen
    moveGrids();

    // Draw player
    drawPlayer();

    // Move player
    updatePlayer();

    // Draw player bullets
    playerBullets.run();

    // Run enemies
    runEnemies();

    // Check for collisons and act accordingly
    if (doCollision)
      checkCollisions();
  }// if

  // Run explosions
  runExplosions();
}// draw
