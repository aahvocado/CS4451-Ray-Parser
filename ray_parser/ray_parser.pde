//daniel xiao
//wuz here



//trace through entire screen
void raytrace(){
  print("\nDrawing shape...");
  
  float k = tan(radians(fov/2));
  for(int i = 0; i<width;i++){
    for(int j = 0; j<height;j++){
      //float xP = ((i - (width/2))*((2*k)/width));
      //float yP = ((j - (height/2))*((2*k)/height));
      float xP = ((2.0*k/width)*i)-k;
      float yP = ((-2.0*k/height)*j)+k;
      float vMag = sqrt(pow(xP,2) + pow(yP,2) + 1);
      
      PVector origin = new PVector(0,0,0);
      PVector direction = new PVector(xP/vMag,yP/vMag,-1/vMag);
      Ray r = new Ray(origin, direction, fov);
      
      PVector getC = r.instersections(objects);
      //print("\ni: "+i+" j: "+j+" color: " + getC);
      color c = color(getC.x, getC.y, getC.z);
      if(!(getC.x == 0 && getC.y == 0 && getC.z == 0)){
        set(i,j,c);
      }else{
        set(i,j, bgColor);
      }
    }
  }
}








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
color bgColor;//background color

ArrayList vertices; //arraylist for making a shape
ArrayList objects;//all spheres and triangles in the scene
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
      bgColor = color(r, g, b);
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
      float r = float(token[1]);
      float x = float(token[2]);
      float y = float(token[3]);
      float z = float(token[4]);
      PVector sPos = new PVector(x,y,z);
      objects.add(new Sphere(sPos, r, currSurr));
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
        objects.add(tri);
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
          
  //background(bgColor.x, bgColor.y, bgColor.z);
      raytrace();
      save(token[1]);  
      reset();
    }
  }
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
  reset();
  interpreter();
  
  
}

void reset(){
  lights = new ArrayList();
  objects = new ArrayList();
}

///////////////////////////////////////////////////////////////////////
//
// Draw frames.  Should leave this empty.
//
///////////////////////////////////////////////////////////////////////
void draw() {
}


