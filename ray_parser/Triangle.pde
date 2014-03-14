//daniel xiao

class Triangle{
  PVector pt1, pt2, pt3;
  Surface s;
  Triangle(PVector pt1param, PVector pt2param, PVector pt3param, Surface sparam){
    pt1 = pt1param;
    pt2 = pt2param;
    pt3 = pt3param;
    s = sparam;
  }
  
  float rayIntersects(Ray ray){
    float t = 0;
    
    PVector O = ray.origin;
    PVector R = ray.direction;
    PVector Q = getCenter();
    PVector N = getNormal();
    
    PVector E1 = getEdge1();
    PVector E2 = getEdge2();
    PVector E3 = getEdge3();
        
    PVector Nnormalized = new PVector(N.x, N.y, N.z);
    Nnormalized.normalize();
    float dN = getDistance(N);
    float d = -1*(N.x*pt1.x + N.y*pt1.y + N.z*pt1.z);
    if(N.dot(R) == 0){
      print("not this tri");
      return -1;
    }
    
    t = -(N.x * O.x + N.y*O.y + N.z*O.z + d)/(N.dot(R));
    
    float xIntersect = O.x + t*R.x;
    float yIntersect = O.y + t*R.y;
    float zIntersect = O.z + t*R.z;
    PVector intersect = new PVector(xIntersect, yIntersect, zIntersect);
    
    PVector p0 = PVector.sub(intersect, pt1);
    PVector p1 = PVector.sub(intersect, pt2);
    PVector p2 = PVector.sub(intersect, pt3);
    
    PVector p0p1 = PVector.sub(pt2, pt1);
    PVector p1p2 = PVector.sub(pt3, pt2);
    PVector p2p0 = PVector.sub(pt1, pt3);
    
    if(p0p1.cross(p0).dot(N) < 0){
      return -1;
    }
    if(p1p2.cross(p1).dot(N) < 0){
      return -1;
    }
    if(p2p0.cross(p2).dot(N) < 0){
      return -1;
    }
    
    //print("\n"+t);
    return t;
  }
  
  boolean leftTriangleTest(Ray ray, PVector plane){ 
    PVector N = getNormal();
    PVector E1 = getEdge1();
    PVector E2 = getEdge2();
    PVector E3 = getEdge3();
    
    float S1 = PVector.dot(N.cross(E1), (PVector.sub(getCenter(), E1)));
    float S2 = PVector.dot(N.cross(E2), (PVector.sub(getCenter(), E2)));
    float S3 = PVector.dot(N.cross(E3), (PVector.sub(getCenter(), E3)));
    
    float PS1 = PVector.dot(N.cross(E1), (PVector.sub(plane, E1)));
    float PS2 = PVector.dot(N.cross(E2), (PVector.sub(plane, E2)));
    float PS3 = PVector.dot(N.cross(E3), (PVector.sub(plane, E3)));
    
    if((S1 > 0 && PS1 > 0) || (S1 < 0 && PS1 < 0)){
      if((S2 > 0 && PS2 > 0) || (S2 < 0 && PS2 < 0)){
        if((S3 > 0 && PS3 > 0) || (S3 < 0 && PS3 < 0)){
          return true;
        }
      }
    }
    return false;
  }
  
  float getDistance(PVector A){
    return sqrt(pow(A.x, 2) + pow(A.y, 2) + pow(A.z, 2));
  }
  
  PVector getEdge1(){//edge 1
    return PVector.sub(pt2, pt1);
  }
  PVector getEdge2(){//edge 2
    return PVector.sub(pt3, pt1);
  }
  PVector getEdge3(){//edge 3
    return PVector.sub(pt2, pt3);
  }
  
  //finds the normal vector
  PVector getNormal(){
    PVector A = PVector.sub(pt1, pt2);
    PVector B = PVector.sub(pt1, pt3);
    PVector normalVector = A.cross(B);
    //normalVector.normalize();
    return normalVector;
  }
  
  //gets the center of the triangle
  PVector getCenter(){
    float cx = (pt1.x + pt2.x + pt3.x)/3;
    float cy = (pt1.y + pt2.y + pt3.y)/3;
    float cz = (pt1.z + pt2.z + pt3.z)/3;
    return new PVector (cx, cy, cz);
  }
  
  String toString(){
    String str = "\nTriangle: ";
    str = str + " PT1 x: "+pt1.x + " y: "+pt1.y +" z: "+pt1.z;
    str = str + " || PT2 x: "+pt2.x + " y: "+pt2.y +" z: "+pt2.z;
    str = str + " || PT3 x: "+pt3.x + " y: "+pt3.y +" z: "+pt3.z;
    return str;
  }
  
}
