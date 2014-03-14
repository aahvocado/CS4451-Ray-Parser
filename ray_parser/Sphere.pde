//daniel xiao

class Sphere{
  PVector pos;
  float r;//radius
  Surface s;//surface
  Sphere(PVector posParam, float radiusParam, Surface surfaceParam){
    pos = posParam;
    r = radiusParam;
    s = surfaceParam;
  }
  
  //returns
  boolean rayIntersects(Ray ray, float t){   
    PVector surfaceColor = new PVector(0,0,0);
    PVector CO = PVector.sub(ray.origin, pos);
    PVector rayS = PVector.mult(ray.direction, 2);
    
    float a = ray.direction.dot(ray.direction);
    float b = (rayS.dot(CO));
    float c = ((CO.dot(CO))-r);
    
    float discriminant = sqrt(pow(b, 2) - (4 * a * c));
    if (discriminant > 0) {
      if (discriminant == 0) {
        float tTemp = -b/2*a;
        if (tTemp < t) {
          surfaceColor = s.diffuse;
          t = min(tTemp, t);
          return true;
        }
      } else {
        float tf = (-b + discriminant)/2*a;
        float tn = (-b - discriminant)/2*a;
        if (tf < t) {
          surfaceColor = s.diffuse;
          t = min(tf, t);
          return true;
        }
        if (tn < t) {
          surfaceColor = s.diffuse;
          t = min(tn, t);
          return true;
        }
      }
    }
    return false;
  }
  
}
