//daniel xiao

class Surface{
  PVector diffuse; 
  PVector ambient;
  PVector specular;
  float phong;
  float reflection;
  
  Surface(PVector diffuseParam, PVector ambientParam, PVector specularParam, float phongParam, float reflectionParam){
    diffuse = diffuseParam;
    ambient = ambientParam;
    specular = specularParam;
    phong = phongParam;
    reflection = reflectionParam;
  }
}
