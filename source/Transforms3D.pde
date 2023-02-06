/*
Put your projection and camera operations here.
Add more constants, variables and functions as needed.
*/

PMatrix3D projectOrtho, projectPerspective;

void setupProjections() {
  ortho(L, R, T, B);
  projectOrtho = getProjection();
  
  frustum(L, R, B, T, N, F);

  fixFrustumYAxis();
  projectPerspective = getProjection();
  
  setProjection(projectOrtho);
}
