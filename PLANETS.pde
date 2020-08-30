class PLANET{
  
  //We need a distance and angle from the sun
  
  float radius;
  float angle;
  float  distance;
  PLANET[] planets; //stores the planets that orbit this planet/sun
  
  float orbitSpeed;
  PVector v;
  PShape globe;
  PImage planetImg;
  

  PLANET(float r, float d, float o, PImage img ){
    v = PVector.random3D();
    distance = d;  
    radius = r;
    v.mult(distance);
    angle = random(TWO_PI);
    orbitSpeed = o;
    
    noStroke();
    noFill();
    globe = createShape(SPHERE, radius);
    planetImg = img;
    globe.setTexture(planetImg);
    globe.translate(0, planeYValue, 0);

 
  }
  
  
  void orbit(){
   angle  = angle + orbitSpeed;
   if(planets != null){
     for(int i=0; i < planets.length; i++){
       planets[i].orbit();
        
     }      
   }  
}

  
void spawnMoons(int total, int level){
  planets = new PLANET[total];
  for(int i=0; i < planets.length; i++){
      float r1 = radius/(level*2);
      float d1 = random((radius + r1), ((radius + r1)*10));
      float o1 =  random(-0.002, 0.1);
      int index;
      if(earth == false){
        index = int(random(0, textures.length));
        if(index == 0){
           earth = true;
        }      
      }
      else{
         index = int(random(1, textures.length));
      }
      
      planets[i] = new PLANET(r1, d1, o1, textures[index]); 
      
      if(level < 2){
        int num = 1; //int(random(0, 4));
        planets[i].spawnMoons(num, level+1);
      }    
  }    
}

  
  
  void show(){
   pushMatrix(); 
   noStroke();
   PVector v2 = new PVector(1,0,1);
   PVector p = v.cross(v2);
   rotate(angle, p.x, p.y, p.z); //we want to roatet first and then translate
   stroke(255);
   translate(v.x, v.y, v.z);
   //globe.setTexture(planetImg);
   noStroke();  
   fill(255);
   shape(globe);
   //ellipse(0, 0, radius*2, radius*2);
   
   
   //sphere(radius);
   if(planets != null){
     for(int i=0; i < planets.length; i++){
       planets[i].show();   
      }
    } 
   popMatrix(); 
  }




}//class
