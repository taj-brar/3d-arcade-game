final float PARTICLE_SIZE = 0.01;          // size of the particle
final float PARTICLE_SPEED = 0.05;         // speed at which particle moves
final int NUM_PARTICLES = 100;             // number of particles per explosion
final int MAX_LIFE = 30;                   // max number of frames the explosion lasts for
final float[] PARTICLE_COLOR = {1, 0, 0};  // colour of particles in explosion

ArrayList<Explosion> explosions = new ArrayList();    // list of all explosion

/*
  This class implements an explosion.
 */
class Explosion {
  float xPos;      // x position of the explosion
  float yPos;      // y position of the explosion
  Boolean alive;   // boolean to track if explosion is alive
  int age;         // age of explosion in frames
  ArrayList<Particle> particles;  // list of all particles in explosion

  /*
    This method creates a new instance at the given coordinates.
   */
  Explosion(float x, float y) {
    // Instantiate explosion
    xPos = x;
    yPos = y;
    alive = true;
    age = 0;
    particles = new ArrayList();

    // Add particles to explosion
    addParticles();
  }// Explosion - constructor

  /*
    This method adds the max number of particles to the explosion.
   */
  void addParticles() {
    // Add max number of particles
    for (int i=0; i<NUM_PARTICLES; i++)
      particles.add(new Particle(xPos, yPos));
  }// addParticles

  /*
    This method runs the explosion by running each particle.
   */
  void run() {
    // Loop through all particles and run them
    for (int i=0; i<particles.size(); i++)
      particles.get(i).run();

    // Kill explosion if beyond max lifetime
    if (age > MAX_LIFE)
      alive = false;
    else
      age++;
  }// run
}// end class Explosion

/*
  This class implements a particle.
 */
class Particle {
  float xPos;        // x position of the particle
  float yPos;        // y position of the particle
  float zPos;        // z position of the particle
  PVector direction; // direction the particle is travelling in

  /*
    This method creates a particle at a given location.
   */
  Particle (float x, float y) {
    // Instantiate particle
    xPos = x;
    yPos = y;
    zPos = PLAYER_HEIGHT;    // explosion starts at fixes z height

    // Get random direction of travel
    direction = PVector.random3D();
  }// Particle - constructor

  /*
    This method runs the particle.
   */
  void run() {
    // Move and draw particle
    moveParticle();
    drawParticle();
  }// run

  /*
    This method moves the particle in its direction of travel.
   */
  void moveParticle() {
    // Move particle in determined direction
    xPos += PARTICLE_SPEED*direction.x;
    yPos += PARTICLE_SPEED*direction.y;
    zPos += PARTICLE_SPEED*direction.z;
  }// moveParticle

  /*
    This method draws the particle at its given location.
   */
  void drawParticle() {
    pushMatrix();

    // Apply modifications and draw particle
    translate(xPos, yPos, zPos);
    scale(PARTICLE_SIZE, PARTICLE_SIZE, 0);
    drawParticleCube(PARTICLE_COLOR);

    popMatrix();
  }// drawParticle
}// end class Particle
