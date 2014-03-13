//daniel xiao

class Triangle{
  PVector pt1, pt2, pt3;
  Surface s;
  Triangle(PVector pt1param, PVector pt2param, PVector pt3param, Surface sparam){
    pt1 = pt1param;
    pt2 = pt2param;
    pt3 = pt3param;
  }
  
  //
  PVector getCenter(){
    float cx = (pt1.x + pt2.x + pt3.x)/3;
    float cy = (pt1.y + pt2.y + pt3.y)/3;
    float cz = (pt1.z + pt2.z + pt3.z)/3;
    return new PVector (cx, cy, cz);
  }
  
}
