//daniel xiao
//wuz here

///////////////////////////////////////////////////////////////////////
//
// Command Line Interface (CLI) Parser  
//
///////////////////////////////////////////////////////////////////////
String gCurrentFile = new String("rect_test.cli"); // A global variable for holding current active file name.

///////////////////////////////////////////////////////////////////////
//
// Press key 1 to 9 and 0 to run different test cases.
//
///////////////////////////////////////////////////////////////////////
void keyPressed() {
  switch(key) {
    case '1':  gCurrentFile = new String("t0.cli"); interpreter(); break;
    case '2':  gCurrentFile = new String("t1.cli"); interpreter(); break;
    case '3':  gCurrentFile = new String("t2.cli"); interpreter(); break;
    case '4':  gCurrentFile = new String("t3.cli"); interpreter(); break;
    case '5':  gCurrentFile = new String("c0.cli"); interpreter(); break;
    case '6':  gCurrentFile = new String("c1.cli"); interpreter(); break;
    case '7':  gCurrentFile = new String("c2.cli"); interpreter(); break;
    case '8':  gCurrentFile = new String("c3.cli"); interpreter(); break;
    case '9':  gCurrentFile = new String("c4.cli"); interpreter(); break;
    case '0':  gCurrentFile = new String("c5.cli"); interpreter(); break;
  }
}

float fov = 0;//eh
ArrayList lights;//array of light sources
PVector bgColor;//background color

ArrayList vertices; //arraylist for making a shape
ArrayList triangles;//all triangles in the scene
Surface currSurr;//current surface

///////////////////////////////////////////////////////////////////////
//
//  Parser core. It parses the CLI file and processes it based on each 
//  token. Only "color", "rect", and "write" tokens are implemented. 
//  You should start from here and add more functionalities for your
//  ray tracer.
//
//  Note: Function "splitToken()" is only available in processing 1.25 
//       or higher.
//
///////////////////////////////////////////////////////////////////////
void interpreter() {
  
  String str[] = loadStrings(gCurrentFile);
  if (str == null) println("Error! Failed to read the file.");
  for (int i=0; i<str.length; i++) {
    
    String[] token = splitTokens(str[i], " "); // Get a line and parse tokens.
    if (token.length == 0) continue; // Skip blank line.
    
    if (token[0].equals("fov")) {
      fov = float(token[1]);
    }
    else if (token[0].equals("background")) {
      float r = float(token[1]);
      float g = float(token[2]);
      float b = float(token[3]);
      bgColor = new PVector(r, g, b);
    }
    else if (token[0].equals("light")) {
      float x = float(token[1]);
      float y = float(token[2]);
      float z = float(token[3]);
      float r = float(token[4]);
      float g = float(token[5]);
      float b = float(token[6]);
      PVector xyz = new PVector(x, y, z);
      PVector rgb = new PVector(r, g, b);
      LightSource newlight = new LightSource(xyz, rgb);
      lights.add(newlight);
    }
    else if (token[0].equals("surface")) {
      float cdr = float(token[1]);
      float cdg = float(token[2]);
      float cdb = float(token[3]);
      PVector diffuse = new PVector(cdr, cdg, cdb);
      
      float car = float(token[4]);
      float cab = float(token[5]);
      float cag = float(token[6]);
      PVector ambient = new PVector(car, cag, cab);
      
      float csr = float(token[7]);
      float csg = float(token[8]);
      float csb = float(token[9]);
      PVector specular = new PVector(csr, csg, csb);
      
      float phong = float(token[10]);
      float reflection = float(token[11]);
      
      currSurr = new Surface(diffuse, ambient, specular, phong, reflection);
    }    
    else if (token[0].equals("sphere")) {
      
    }
    else if (token[0].equals("begin")) {
      vertices = new ArrayList();//reset vertices
    }
    else if (token[0].equals("vertex")) {
      float x = float(token[1]);
      float y = float(token[2]);
      float z = float(token[3]);
      PVector vertex = new PVector(x, y, z);
      vertices.add(vertex);
    }
    else if (token[0].equals("end")) {
      if(vertices.size() >= 3){
        Triangle tri = new Triangle((PVector)vertices.get(0), (PVector)vertices.get(1), (PVector)vertices.get(2), currSurr);
        triangles.add(tri);
        vertices = new ArrayList();//reset vertices
      }else{
        print("not enough vertices to make a triangle here");
      }
    }
    else if (token[0].equals("color")) {
      float r =float(token[1]);
      float g =float(token[2]);
      float b =float(token[3]);
      fill(r, g, b);
    }
    else if (token[0].equals("rect")) {
      float x0 = float(token[1]);
      float y0 = float(token[2]);
      float x1 = float(token[3]);
      float y1 = float(token[4]);
      rect(x0, height-y1, x1-x0, y1-y0);
    }
    else if (token[0].equals("write")) {
      // you should render the scene here
      save(token[1]);  
    }
  }
}
//trace through entire screen
void raytrace(){
  for(int i = 0; i<width;i++){
    for(int j = 0; j<height;j++){
      PVector origin = new PVector(0,0,0);
      PVector direction = new PVector(i,j,-1);
      RayHit hitData = raycast(origin, direction);
      
    }
  }
}
//cast a ray
RayHit raycast(PVector origin, PVector direction){
    float x = direction.x;
    float y = direction.y;
    Ray castRay = new Ray(origin, direction, fov);

    float k = tan(radians(fov/2));
    float xp = (x - width/2)*(2*k / width);
    float yp = (y - height/2)*(2*k / height);
    
    Ray ray = castRay;
    PVector hitPos = P;
    PVector normal = N;
    boolean wasHit = true;
    Surface surface = tri.s;
    RayHit hitData;
    
    //use a triangle's ocation as a point
    for(int i = 0; i<triangles.size();i++){
      Triangle thisTri = (Triangle)triangles.get(i);
      PVector Q = thisTri.getCenter();
      PVector ttv1 = thisTri.pt1;
      PVector ttv2 = thisTri.pt2;
      PVector ttv3 = thisTri.pt3;
      
      PVector pA = PVector.sub(ttv2, ttv1);
      PVector pB = PVector.sub(ttv3,ttv1);
      PVector N = (pA.cross(pB));
      
      PVector QO = PVector.sub(Q, origin);
      float t = QO.dot(N) / direction.dot(N);    

      
      //find a triangle that intersects with this intersection,f t intersects
      if(t!=0){
        PVector tR = new PVector(t*direction.x, t*direction.y, t*direction.z);
        PVector P = PVector.add(origin, tR);
        for(int j = 0; j<triangles.size();j++){
          Triangle tri = (Triangle)triangles.get(j);
          
          PVector v0 = tri.pt1;
          PVector v1 = tri.pt2;
          PVector v2 = tri.pt3;
          //check if within triangle's x
          PVector edge0 = PVector.sub(v1, v0);
          PVector edge1 = PVector.sub(v2, v1);
          PVector edge2 = PVector.sub(v0, v2);
          
          PVector c0 = PVector.sub(P, v0);
          PVector c1 = PVector.sub(P, v1);
          PVector c2 = PVector.sub(P, v2);
          
          PVector ec0 = edge0.cross(c0);
          PVector ec1 = edge1.cross(c1);
          PVector ec2 = edge2.cross(c2);
          
          if(N.dot(ec0) > 0 && N.dot(ec1) > 0 && N.dot(ec2) > 0){
            //we did it, it's this triangle
            hitData = new RayHit(ray, hitPos, normal, wasHit, surface);
           
          }
        }
      }
      
    }
    
       return hitData;
}


//draw a pixel on the screen
void writePixel (int x, int y, PVector rgb) {
  float r = rgb.x;
  float g = rgb.y;
  float b = rgb.z;
  int index = (height - y - 1) * width + x;
  pixels[index] = color (r, g, b);
}

///////////////////////////////////////////////////////////////////////
//
// Some initializations for the scene.
//
///////////////////////////////////////////////////////////////////////
void setup() {
  size(300, 300);  
  noStroke();
  colorMode(RGB, 1.0);
  background(0, 0, 0);
  //instantiate arraylists
  lights = new ArrayList();
  triangles = new ArrayList();
  
  interpreter();
  
  
}

///////////////////////////////////////////////////////////////////////
//
// Draw frames.  Should leave this empty.
//
///////////////////////////////////////////////////////////////////////
void draw() {
}



