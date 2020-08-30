  
PShape s;
PShape plane;
PShape butterfly;
PShape spaceShip;

PShape[] shapes = new PShape[3];
PShape[] spaceships = new PShape[numAgents-1]; //this array stores all the ships except the main ship

void setUpPlane(){
      plane  = createShape();
      plane.beginShape();
      plane.fill(0, 255, 0);
      plane.stroke(0,255,0);
      plane.vertex(planeLen, planeYValue, planeLen);
      plane.vertex(planeLen, planeYValue, -planeLen);
      plane.vertex(-planeLen, planeYValue, -planeLen);
      plane.vertex(-planeLen, planeYValue, planeLen);
      plane.endShape();
}

void setUpShips(){
  
   shapes[0] = loadShape("Spaceship.obj");
   shapes[1] = loadShape("Spaceship3.obj");
   shapes[2] = loadShape("Spaceship5.obj");
   //main ship
   spaceShip = loadShape("Spaceship4.obj");
   currAngle = agent1[0].velocity;
   currentAngle = atan(agent1[0].velocity.zp/agent1[0].velocity.xp);
   //print(degrees(currentAngle));
   //pushMatrix();
   
   spaceShip.rotateX(PI); // ship looks away from us
    // spaceShip.rotateY(currentAngle); // ship looks away from us
   spaceShip.scale(10);  //10 is the ideal 
   //popMatrix();
 
  for(int i=0; i < spaceships.length; i++){
    int rs = int(random(0,2));
    spaceships[i] = shapes[rs]; //randomly assing the ship object
    spaceships[i].rotateX(PI);
    float scale = random(1, 2);
   agent1[i].agentCurrAngle = agent1[i].velocity;
   agent1[i].agentAngle = atan(agent1[i].velocity.zp/agent1[i].velocity.xp);
    spaceships[i].scale(scale);   
  }
  
  //spaceShip = loadShape("Spaceship4.obj");
}

void showMainShip(){
    pushMatrix();
    translate(0, 0, agent1[0].position.zp);
    shape(spaceShip, agent1[0].position.xp, planeYValue);
    popMatrix(); 
}  

void showShips(){
  for(int i=1; i < spaceships.length; i++){
    pushMatrix();
    translate(0, 0, agent1[i].position.zp);
    shape(spaceships[i], agent1[i].position.xp, planeYValue);
    popMatrix(); 
    
  }  

}
  
  //the main ship uses gloabal variables currentAngle and currAngle
  //all other ships use agentCurrentAngle and agentAngle
void rotateShip(){
    float velAngle = atan(agent1[0].velocity.zp/agent1[0].velocity.xp);//Calculates the angle in the x-z plane of the velocity vector
    float velAngleMag = agent1[0].velocity.magnitude();
    float currAngleMag = currAngle.magnitude();
    float dot = currAngle.dotv(currAngle, agent1[0].velocity);
    
    float betweenAngle = acos(dot/(velAngleMag*currAngleMag )); //angle between the current way ship points and the way the ship is heading
    float diffDeg = degrees(betweenAngle);
   //println("diffDeg:", diffDeg);
   if(abs(diffDeg)> 10){ //only rotate the ship of the velocity angle and the ship's angle differ by x degrees
      spaceShip.rotateY((2*PI)-betweenAngle); //rotate the ship by the velcotiy vector angle with respcect to the orgin
      currentAngle = velAngle; //now the ships angle in the x-z plane is the same as the velocity angle
      currAngle = agent1[0].velocity;
   }
}

void rotateShips(){
  
  for(int i = 1; i < spaceships.length; i++){
    float velAngle = atan(agent1[i].velocity.zp/agent1[i].velocity.xp);//Calculates the angle in the x-z plane of the velocity vector
    float velAngleMag = agent1[i].velocity.magnitude();
    float currAngleMag = agent1[i].agentCurrAngle.magnitude();
    float dot = agent1[i].agentCurrAngle.dotv(agent1[i].agentCurrAngle, agent1[i].velocity);
    
    float betweenAngle = acos(dot/(velAngleMag*currAngleMag )); //angle between the current way ship points and the way the ship is heading
    float diffDeg = degrees(betweenAngle);
   //println("diffDeg:", diffDeg);
   if(abs(diffDeg)> 15){ //only rotate the ship of the velocity angle and the ship's angle differ by x degrees
      spaceships[i].rotateY((2*PI)-betweenAngle); //rotate the ship by the velcotiy vector angle with respcect to the orgin
      agent1[i].agentAngle = velAngle; //now the ships angle in the x-z plane is the same as the velocity angle
      agent1[i].agentCurrAngle = agent1[1].velocity;
   }
  } 
}


void setUpStars(){
  for(int i = 0; i < stars.length; i++){   
        stars[i]  = new VECTOR(random(-1000, 1000), random(-1000, 1000), random(-1000, 1000));        
  }
}

void drawStars(){
  
  for(int i = 0; i < stars.length; i++){   
        pushMatrix();
        lights();
        fill(255, 255, 255, 200);
        translate(stars[i].xp, stars[i].yp, stars[i].zp);
        sphere(random(0.5, 1.5));
        popMatrix();
  }
}  
