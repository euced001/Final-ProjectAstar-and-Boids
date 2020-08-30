//SOURCES: 
//https://youtu.be/aKYlikFAV4k for A* Algorithm
//SOURCES: The Coding Train Coding Challenge: https://youtu.be/aKYlikFAV4k //This was for Astar.
//SOURCES: Part 2: https://youtu.be/EaZxUCWAjb0
//SOURCES: My OWN implementing_ASTAR_draft2
//SOURCES: Guide to Anticipatory Collision Avoidance Chapter 19 by Stephen Guy and Ioannis Karamouzas //This is for TTC
//SOURCES: // Liam's Camera was Created for CSCI 5611 by Liam Tyler and Stephen Guy
//SOURCES: For the angle b/w two vectors: https://www.youtube.com/watch?v=dYPRYO8QhxUs
//SOURCES: TO create the solar system: https://www.youtube.com/watch?v=l8SiJ-RmeHU&t=472s
//https://www.youtube.com/watch?v=dncudkelNxw
//SOURCE: For planet images: http://planetpixelemporium.com/
//SOURCE: for alien and ships https://drive.google.com/drive/folders/1rPLtJJCmqcKKU-YBiqaDVZxHBBo1t3-5
//SOURCES: debris picture https://phys.org/news/2018-11-space-debris-cleanup-national-threat.html


//NOTES:
//Changed the code to work with ASTAR

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//for camera
Camera camera;

import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;
//import peasy.test.*;


//PeasyCam cam;

//Alien

PShape person;


//for 3d scenes
float planeLen = 600; //planeLen is actually 2x this value 
float planeYValue = 300;

int numAgents = 10; //1;
int numpoints = 10;//25;//10; //numpoints is the number of sample points for PRM
int radiusOfPercep = 50;//500; //50;
int radius = 50; //10; //sphere radius //50 is the radius of the sun
//int agentAndTargetRadius = 25;
int agentAndTargetRadius = 15;

VECTOR ZERO = new VECTOR (0,0,0); //the zero vector
VECTOR SUN = new VECTOR (0, planeYValue, 0);

//VECTOR sphere = new VECTOR(400,400,0);
VECTOR sphere = new VECTOR(0,planeYValue,0);
VECTOR steering = new VECTOR(0,0,0);
VECTOR goal = new VECTOR(planeLen, planeYValue, -planeLen);
VECTOR agentStart = new VECTOR(-375, planeYValue, 375); //to be on the one corner of the plane
VECTOR point; //???
AGENT[] agent1; //the agents contain the horse position, velocity, acceleration, starting posotion, goal, and path
VECTOR[] PRMpoints = new VECTOR[numpoints]; //this stores the PRM points
VECTOR[] stars = new VECTOR[100]; 

//this is for the user to draw obstacles //keep in mind that bfs has to be called again if we add new obstacles
int debrisTotal = 0;
int numSatellites = 1000;
CIRCLE[] debris;
//for solar system
float currentAngle = 0;
VECTOR currAngle;
PLANET sun; //I know the sun is not a planet.

PImage sunTexture;
PImage[] textures = new PImage[5];

//we can only have one earth
boolean earth = false;

void setup(){
        //size(600,600);
        size(600,600, P3D);
        //cam = new PeasyCam(this, 100); //look at the center of the world from 100 units away
        setUpStars();
        camera = new Camera();
        setUpPlane();
        findPRMpoints();      
        prmConnect();
        agent1 = new AGENT[numAgents];
        debris = new CIRCLE[numSatellites]; //max size of circles is 1000 
        agent1[0] = new AGENT(PRMpoints, agentStart);// all agents start at the same position
        agent1[0].colors = #3FD61E;
        agent1[0].AStartSetup();
        agent1[0].aStar();
        

       //println("Astar SETUP is complete for agent", i);   
       //agent1[0].bfs();
       //println("BFS is complete for agent", 0);
     
       agent1[0].nextNode = agent1[0].AStarPath.size()-2;          
        for(int i = 1; i < numAgents; i++){ 
                   VECTOR random = new VECTOR(random(-planeLen, planeLen), planeYValue, random(-planeLen, planeLen)); 
                   agent1[i] = new AGENT(random); 
                
        }  
        

       setUpShips();//We must set up Ships after all the agents are setup
       //for solar system
       sunTexture = loadImage("sun.jpg");  
       textures[0] = loadImage("earth.jpg");
       textures[1] = loadImage("mars.jpg");
       textures[2] = loadImage("pluto.jpg");
       textures[3] = loadImage("neptune.jpg");
       textures[4] = loadImage("jupiter.jpg");
       sun = new PLANET(50, 0, 0, sunTexture);   
       sun.spawnMoons(4, 1); // We are at level zero
       //person
       person = loadShape("astronaut.obj");
       person.rotateX(PI/2);
       person.scale(5);

       
       
       
}
//Start: For Camera////////////////////////For Camera//////////////////////////////For Camera/////////////////////////////////
void keyPressed()
{
  camera.HandleKeyPressed();
}

void keyReleased()
{
  camera.HandleKeyReleased();  
}
//End: For Camera////////////////////////For Camera//////////////////////////////For Camera/////////////////////////////////


///START//////////////////DRAW////////////////////////////////////////////////////DRAW///////////////////////////////////////////
void draw(){ 
  background(0);
  lights();
  camera.Update( 1.0/frameRate);
  drawStars();
  sun.show();
 //shape(plane);

  //drawPRMPoints(); 
  ////drawShips();
  showMainShip();
  showShips();
  rotateShip();  
  //rotateShips();
  
  //draw the path points
  //for(int i = 0; i < agent1[0].AStarPath.size(); i++){
   
  //  VECTOR p =agent1[0].arrayOfPoints[agent1[0].AStarPath.get(i)]; 
  //  float x = p.xp;
  //  float y = p.yp;
  //  float z = p.zp;
  //  pushMatrix();
  //  fill(0,0,255);
  //  translate(x, y, z); 
  //  sphere(60);
  //  popMatrix();
    
  //}
 

  agent1[0].updatevelocity(1/frameRate, agent1[0].nextNode);
  agent1[0].updateposit(1/frameRate);
  
  runBoids();
  //runTTC();


   //draw the person until ship gets to it 
   if(agent1[0].atEnd == false){
     pushMatrix();
     translate(goal.xp, goal.yp, goal.zp);
     shape(person);
     popMatrix();
   }
   
  if(key == 'g')
        camera.position = new PVector(18.8, 88.6, 22);
  if(key == 'p'){      
    println(camera.position);
    println(camera.theta);
    println(camera.phi);
  } 

}
////END/////////////////DRAW////////////////////////////////////////////////////DRAW///////////////////////////////////////////























  
