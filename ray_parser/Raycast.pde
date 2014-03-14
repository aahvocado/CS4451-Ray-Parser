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
  
  //checks if this ray intersects any of the following objects
  PVector instersections(ArrayList objects){
    PVector surfaceColor = new PVector(0,0,0);
    float t = 10000;
    for(int i =0;i<objects.size();i++){
      if(objects.get(i) instanceof Sphere){
        Sphere sph = (Sphere)objects.get(i);
        if(sph.rayIntersects(this, t)){
          surfaceColor = sph.s.diffuse;
        }
      }else if(objects.get(i) instanceof Triangle){
        Triangle tri = (Triangle)objects.get(i);
        PVector planeVector = PVector.sub(tri.getCenter(), origin); 
        //t = (planeVector.dot(tri.getNormal()) / (direction.dot(tri.getNormal())));
        if(t > 0){
          PVector target = PVector.mult(direction, t);
          float intersectTime = tri.rayIntersects(this); 
          if(intersectTime>0 && intersectTime<t){
            t = intersectTime;
            surfaceColor = tri.s.diffuse;
          }
        }
      }
    }
    return surfaceColor;
  }
}

/*
ArrayList spheresIntersected;
ArrayList trianglesIntersected;


//takes in a sphere paramter
PVector sphereTest(Sphere p){
  PVector surf = new PVector(0,0,0);
  
  PVector CO = PVector.sub(origin, direction);
  PVector rayS = PVector.mult(direction, 2);
  float A = direction.dot(direction);
  float B = rayS.dot(CO);
  float c = (CO.dot(CO)) - sphere.r;
  
  float discriminant = sqrt(pow(b, 2) - (4*a*c));
  if(discriminant > 0){
    float t0 = (-b + discriminant)/2*a;
    float t1 = (-b - discriminant)/2*a;
    surf = p.surface.diffuse;
    if(t0 < t){
       t = min(t0, t);
    }else if(t1<t){
      t = min(t1, t);
    }
  }
  return surf;
}*/


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
