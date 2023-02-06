final int RED = 0;        // index of red colour
final int GREEN = 1;      // index of green colour
final int BLUE = 2;       // index of blue colour
final int NUM_COLORS = 3; // number of colours

/*
  This method draws a given grid at the given position.
 */
void drawGridAtPosition(Grid gridToDraw, float position) {
  pushMatrix();

  // Move to given position and draw grid
  translate(0, position, 0);
  gridToDraw.drawGrid();

  popMatrix();
}// drawGridAtPosition

/*
  This method moves both grids at a set speed.
 */
void moveGrids() {
  // Move grids at set speed
  positionG1 = positionG1 + SPEED;
  positionG2 = positionG2 + SPEED;

  // Check if grid 1 went out of view
  if (positionG1 < -GRID_SIZE) {
    // Reset tiles
    g1.initializeGrid();

    // Reset to above grid 2
    positionG1 = positionG2 + GRID_SIZE;
  }// if

  // Check if grid 2 went out of view
  if (positionG2 < -GRID_SIZE) {
    // Reset tiles
    g2.initializeGrid();

    // Reset to above grid 1
    positionG2 = positionG1 + GRID_SIZE;
  }// if
}// moveGrids

/*
  This class implements a grid with tiles.
 */
class Grid {
  final float MIN_HEIGHT = 0.5;                                 // minimum height of a tile
  final float MAX_HEIGHT = 0.7;                                 // maximum height of a tile
  final float CUBE_SIZE = 0.1;                                  // half length of a cube side
  final float START_X = -GRID_SIZE/2 + CUBE_SIZE;               // x coord. of where grid starts
  final float START_Y = -GRID_SIZE/2 + CUBE_SIZE;               // y coord. of where grid starts
  final float END_X = GRID_SIZE/2 + CUBE_SIZE;                  // x coord. of where grid ends
  final float END_Y = GRID_SIZE/2 + CUBE_SIZE;                  // y coord. of where grid ends
  final int NUM_TILES = (int)((END_X-START_X)/(2*CUBE_SIZE));   // number of tiles in a grid row

  float[][] tileHeights = new float[NUM_TILES][NUM_TILES];
  Textures[][] tileTextures = new Textures[NUM_TILES][NUM_TILES];
  float[][][] tileColors = new float[NUM_TILES][NUM_TILES][NUM_COLORS];

  /*
    This method intializes the grid by setting the colours, heights, and the textures.
   */
  void initializeGrid() {
    setColors();
    setHeights();
    setTextures();
  }// initializeGrid

  /*
    This method sets the color of the tiles in the grid.
   */
  void setColors() {
    // Loop through each row of tiles
    for (int i=0; i<NUM_TILES; i++) {
      // Loop through tiles in a row
      for (int j=0; j<NUM_TILES; j++) {
        // Get random color and insert into array
        // Loop through each color
        for (int k=0; k<NUM_COLORS; k++) {
          tileColors[i][j][k] = random(256)/256.0;
        }// for
      }// for
    }// for
  }// setColor

  /*
    This method sets the textures of the tiles in the grid (one of two).
   */
  void setTextures() {
    // Loop through each row of tiles
    for (int i=0; i<NUM_TILES; i++) {
      // Loop through tiles in a row
      for (int j=0; j<NUM_TILES; j++) {
        // Get random height and insert into array
        tileTextures[i][j] = (random(1) < 0.5) ? Textures.tile1 : Textures.tile2;
      }// for
    }// for
  }// setTextures

  /*
    This method sets the heights of the tiles in the grid randomly.
   */
  void setHeights() {
    // Loop through each row of tiles
    for (int i=0; i<NUM_TILES; i++) {
      // Loop through tiles in a row
      for (int j=0; j<NUM_TILES; j++) {
        // Get random height and insert into array
        tileHeights[i][j] = random(MIN_HEIGHT, MAX_HEIGHT);
      }// for
    }// for
  }// setColor

  /*
    This method draws the grid by drawing all tiles.
   */
  void drawGrid() {
    float x, y, z;    // coords. of a tile

    // Loop through each row of tiles
    for (int i=0; i<NUM_TILES; i++) {
      // Loop through tiles in a row
      for (int j=0; j<NUM_TILES; j++) {
        // Get coords of tile
        x = START_X + j*CUBE_SIZE*2;
        y = START_Y + i*CUBE_SIZE*2;
        z =  -F+tileHeights[i][j]/2;

        // Draw current tile
        pushMatrix();
        translate(x, y, z);
        scale(CUBE_SIZE, CUBE_SIZE, tileHeights[i][j]);
        drawCube(tileColors[i][j], tileTextures[i][j]);
        popMatrix();
      }// for
    }// for
  }// drawTiles
}// end class Grid
