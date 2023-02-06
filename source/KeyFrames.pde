final int X = 0;                    // index of x coord.
final int Y = 1;                    // index of y coord.
final int NUM_KEY_FRAMES = 6;       // number of keyframes
final float PIXELS_PER_SEC = 0.1;   // speed of animation

float[][] keyFrames = new float[NUM_KEY_FRAMES][2];    // coords. of all keyframes
float[] numSteps = new float[NUM_KEY_FRAMES];          // number of steps for all keyframes (for const. speed)

/*
  This method sets up all the keyframe coords and corresponding number of steps.
 */
void setupKeyframes() {
  // Set locations for the keyframes
  // First keyframe
  keyFrames[0][X] = 0;
  keyFrames[0][Y] = 0;

  // Second keyframe
  keyFrames[1][X] = -1+ENEMY_SIZE/2;
  keyFrames[1][Y] = 0;

  // Third keyframe
  keyFrames[2][X] = 0;
  keyFrames[2][Y] = 1-ENEMY_SIZE/2;

  // Fourth keyframe
  keyFrames[3][X] = 0.5;
  keyFrames[3][Y] = 0.5;

  // Fifth keyframe
  keyFrames[4][X] = 1-ENEMY_SIZE/2;
  keyFrames[4][Y] = 1-ENEMY_SIZE/2;

  // Sixth keyframe
  keyFrames[5][X] = 1-ENEMY_SIZE/2;
  keyFrames[5][Y] = 0;

  // Get steps for all keyframes
  for (int i=0; i<NUM_KEY_FRAMES; i++)
    numSteps[i] = getNumSteps(keyFrames[i], keyFrames[(i+1)%NUM_KEY_FRAMES]);
}// setupKeyFrames

/*
  This method gets the number of steps given the start and end coords.
 */
float getNumSteps(float[] start, float[] end) {
  // Get vectors from array
  PVector startVec = new PVector(start[X], start[Y]);
  PVector endVec = new PVector(end[X], end[Y]);

  // Get displacement between start and end
  PVector displacement = endVec.copy();
  displacement.sub(startVec);

  // Get distance between start and end
  float distance = displacement.mag();

  // Calculate and return the number of steps
  return distance*frameRate/PIXELS_PER_SEC;
}// getNumSteps
