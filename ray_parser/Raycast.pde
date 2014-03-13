//daniel xiao

//ray 
class Ray{
  PVector origin;
  PVector direction;
  float fov;
  Ray(PVector originParam, PVector directionParam, float fovParam){
    origin = originParam;
    direction = directionParam;
    fov = fovParam;
  }
}

//things being hit
class RayHit{
  Ray ray;
  PVector hitPos;
  PVector normal;
  boolean wasHit;
  Surface surface;
  
  RayHit(Ray rayParam, PVector posParam, PVector normalParam, boolean wasHitParam, Surface surfaceParam){
    ray = rayParam;
    hitPos = posParam;
    normal = normalParam;
    wasHit = wasHitParam;
    surface = surfaceParam;
    
  }
}
