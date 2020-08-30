class AGENT{
      //For the agent
      float speed = 35; //35;//70;//105;//140;//35; //50;
      int num = numpoints + 1;
      color colors;
      boolean atEnd = false;
      VECTOR STARTINGPOSITION = new VECTOR(0, 0, 0); //value should never be changed in the code except to initialize starting position of each agent
      //VECTOR position = new VECTOR(0,0,0); //position;
      VECTOR position;
      VECTOR velocity;
      VECTOR acceleration;
      
      VECTOR[] arrayOfPoints = new VECTOR[num]; 
      float agentAngle;
      VECTOR agentCurrAngle;
           
      //For TTC
      float agentRadius; // = agentAndTargetRadius ; //for ttc
      float sensingRadius; //= agentRadius + 15; //for ttc???
      VECTOR goalVelocity; //for ttc
      VECTOR goalForce = new VECTOR(0, 0, 0);//for ttc
      VECTOR start = new VECTOR(0,0,0);//for ttc
      VECTOR agentGoal = goal;//for ttc
      VECTOR forceAvoid = new VECTOR(0, 0, 0);//for ttc

      //For BFS
      //array of booleans to determine if visited
      boolean visited[]  = new boolean[num]; 
      ArrayList<Integer>[] neighbors = new ArrayList[num];  //A list of neighbors can can be reached from a given node
      int[] parent = new  int[num];
      //To store the path
      ArrayList<Integer> path = new ArrayList(); 
      int nextNode; //keeps track of the next path
      
      //For AStar
      int aStarStart; //start_index is 0
      int end;   //end_index is num - 1
      int current;   
      int lowestIndex;
      IntList openSet = new IntList();;
      IntList closedSet = new IntList();
      IntList AStarPath = new IntList();        
      float[] f = new float[num];
      float[] g = new float[num];
      float[] h = new float[num];    
      int[] previous = new int[num];   
      boolean inClosedSet[]  = new boolean[num];
      boolean inOpenSet[]  = new boolean[num];  
      boolean newPath = false;  
      
      //for ship
      boolean rotate = false;
 
  ///START: First Constructor//////////////////////////////////////////////////////////////////////////////////////////////////
AGENT(VECTOR[] array, VECTOR i_position){    
   
       position = new VECTOR(0,0,0);
       //velocity = new VECTOR(random(-20, 20),random(-20,20),0); //this is the original setup from loading_obj_files_example_draft 4
       velocity = new VECTOR(random(-20, 20),0,random(-20,20)); //there should be no velocity in the y direction for the 3d model
       acceleration = new VECTOR(0,0,0);
       
       STARTINGPOSITION = i_position;
       position = i_position;
       
       arrayOfPoints[0] = position;
       //arrayOfPoints[0] = position; //Use this when adding obstacles
       //copy the points onto the array for the 
       arrayOfPoints[0].vectorPrint();
       for(int i = 1; i < num; i++)
       {
         arrayOfPoints[i] = array[i-1];  
         //println("arrayOfPoints is", i);
         //arrayOfPoints[i].vectorPrint();
       }
       

}
// Use this constructor to just run boids
AGENT(VECTOR i_position){    
   
       position = new VECTOR(0,0,0);
       velocity = new VECTOR(random(-20, 20),0, random(-20,20));
       acceleration = new VECTOR(0,0,0);
       
       position = i_position;
      
 
}     
// Use this constructor to just run TTC
//AGENT(VECTOR i_position, float i_radius){    
       
//       position = new VECTOR(0,0,0);
//       velocity = new VECTOR(random(-20, 20),random(-20,20),0);
//       acceleration = new VECTOR(0,0,0);
//       goalVelocity = new VECTOR(0, 0, 0);
//       start = i_position;
//       position = i_position;
//       agentRadius = i_radius;
//       sensingRadius = agentRadius; 
       
//       goalVelocity.subtract(start,agentGoal);
//       goalVelocity.normalizev();
//       goalVelocity = new VECTOR(goalVelocity.xpn, goalVelocity.ypn, goalVelocity.zpn); //now goalVelocity vecotor is normal    
//}    

void edges(){  
 if(position.xp  > planeLen){
   position.xp = -agentStart.xp;}
 else if(position.xp < -planeLen){
   position.xp = agentStart.xp;}
 if(position.zp  > planeLen){
   position.zp = agentStart.zp;}
 else if(position.zp < -planeLen){
   position.zp = -agentStart.zp;}
   position.yp = 300;
}

void updateposit(float dt){
  
   velocity.normalizev();
   velocity = new VECTOR(velocity.xpn, velocity.ypn, velocity.zpn);      
   velocity = velocity.scalarmultiply(speed*dt);
   position.addv(position, velocity);
   acceleration = acceleration.scalarmultiply(dt);
   velocity.addv(velocity, acceleration);
    
}




//this is from loading_obj_files_example_draft4// the only difference is making sure that we did not change the velocity 
//in the y-direction
void updatevelocity(float dt, int count){     
  
    if(count == -1){      
        count = 0;           
    }      
    // Head to the first stop in the path
    if(count == AStarPath.size()-2)
    { 
      //SOMETIMES CODE BREAKS HERE
        velocity.subtract(arrayOfPoints[AStarPath.get(count)], position); 
    }
    //check if we are close enough to head towards the next stop
   if(position.distance(position, arrayOfPoints[AStarPath.get(count)]) < 1 & count > 0)
    {     
       print("too close");
       velocity.subtract(arrayOfPoints[AStarPath.get(count)], position); 
       nextNode--;
    }
    
   //check if near the gaol
   if(count == 0)
   {           
     if(atEnd == false){
  
       velocity.subtract(arrayOfPoints[AStarPath.get(count)], position);
       
       if(position.distance(position, arrayOfPoints[AStarPath.get(count)]) < 10){             
                atEnd = true;
                colors = #4BDCF7;
                print("Ship made it!");

               velocity.xp = random(-20, 20);
               //velocity.yp = random(-20, 20);
               velocity.zp = random(-20, 20);  
       }
      
   }   
   
}  
  
}

//the setup for connect is different for astar and bfs. see the boids version to see the setup for bfs
   void connect()
      {
        //boolean collide = false;
        for (int i = 0; i < num; i++)
        {
      
          neighbors[i] = new ArrayList<Integer>();//for Astar
          VECTOR poc = new VECTOR(0,0,0);
          poc.subtract(arrayOfPoints[i], sphere);
          
          float c; 
          c = (poc.xp*poc.xp) + (poc.zp*poc.zp) - (radius*radius);
          // This should avoid connecting with oneself and also checking twice for the same pair of points
         
          for ( int j = i+1; j < num; j++)
          {
            boolean collide = false;
            VECTOR vel = new VECTOR(0,0,0);
            vel.subtract(arrayOfPoints[i], arrayOfPoints[j]);
      
            float a; 
            
            a = vel.magnitude();
            a *= a;
      
            float b;
            b = 2*vel.dotv(vel, poc);
    
                  for(int k = 0; k < debrisTotal; k++){
                  //for(int k = 0; k < satellites.length; k++){
                    
                  
                      VECTOR pock = new VECTOR(0, 0, 0);   
                      pock.subtract(arrayOfPoints[i], debris[k].position);
         
                      float ck; 
                      ck = (pock.xp*pock.xp) + (pock.zp*pock.zp) - (debris[k].radius*debris[k].radius);
                      
                            
                      float ak; 
                     ak = vel.magnitude();
                      //ak = vel.magnitude()*vel.magnitude();
                      ak *= ak;
                
                      float bk;
                      bk = 2*vel.dotv(vel, pock);
                      
                      if (sqrt(bk*bk - 4*ak*ck) > 0)
                      {
                        collide = true;      
                      } 
                      else
                      {
                      }
      
                    //println(k);
                    //print(collide);
                
               }
           
            
            //checking for j = 2 should avoid connecting the agents
            //if (sqrt(b*b - 4*a*c) > 0 && (collide == false))
            if (sqrt(b*b - 4*a*c) > 0 )
            {
              collide = true;
            } 
            else if( collide == false)
            {
              neighbors[i].add(j);
            }
          }
  
        }//outerloop
      }
      
    void bfs() {
      //initialize the arrays to represent the graph
      for (int i = 0; i < num; i++)
      { 
        neighbors[i] = new ArrayList<Integer>(); 
        visited[i] = false;
        parent[i] = -1; //No partent yet
      }
      
      connect();
      println("List of Neghbors:");
      println(neighbors);
    
      int start = 0;
      int goal = num - 1;
    
    
      ArrayList<Integer> fringe = new ArrayList(); 
      println("\nBeginning Search");
    
      visited[start] = true;
      fringe.add(start);
      println("Adding node", start, "(start) to the fringe.");
      println(" Current Fring: ", fringe);
    
      while (fringe.size() > 0) {
        int currentNode = fringe.get(0);
        fringe.remove(0);
        if (currentNode == goal) {
          println("Goal found!");
          break;
        }
        for (int i = 0; i < neighbors[currentNode].size(); i++) {
          int neighborNode = neighbors[currentNode].get(i);
          if (!visited[neighborNode]) {
            visited[neighborNode] = true;
            parent[neighborNode] = currentNode;
            fringe.add(neighborNode);
            println("Added node", neighborNode, "to the fringe.");
            println(" Current Fringe: ", fringe);
          }
        }
      }
      
      
      print("\nReverse path: ");
      int prevNode = parent[goal];
      path.add(goal);
      print(goal, " ");
      while (prevNode >= 0) {
        print(prevNode, " ");
        path.add(prevNode);
        prevNode = parent[prevNode];
      }
      print("\n");
      println("The path is:");
      println(path);
      print("\n");
    }

//We use three functions for AStar: AStarSetup() and aStar() ane heuristic()  
void AStartSetup(){ //each agent should send its own agent.arrayOfPoints[]       
    aStarStart = 0;
    end = num-1; //num is in AGENT   
    //initialize all the arrays
    for(int i = 0; i< num; i++){
      f[i] = 0;
      g[i] = 0;
      h[i] = 0;
      previous[i] = -1;
      //neighbors[i] = new ArrayList<Integer>(); 
      inClosedSet[i] = false; 
      inOpenSet[i] = false;
    } 
    
    connect(); 
    for(int i = 0; i < num; i++){
     
        println(i, neighbors[i]);
    }  
    openSet.set(0,aStarStart);
    println("start added");
    println("size is", openSet.size());
    inOpenSet[aStarStart] = true; //state that arrayOfPoints[0] is in openSet+
    println("Astar SETUP is complete for agent");      
}

float heuristic(VECTOR a, VECTOR b){
    //float distance = dist(a.xp, a.yp, b.xp, b.yp); // for diagonal movement
    float distance = distance(a, b);
    //float distance = abs(a.xp - b.yp) + abs(a.yp - b.yp);
    return distance;
}
void aStar(){
println("starting aStar");
println("size is", openSet.size());
while(openSet.size() > 0){
       //we keep going
       //lowestIndex is the index for openSet(); which may not match the index for the f[], g[], g[], and previous[], etc arrays. 
       lowestIndex = 0;

       for(int i = 0; i < openSet.size(); i++){
         if(f[openSet.get(i)] < f[openSet.get(lowestIndex)]){
           
              lowestIndex = i;
              println("LowestIndex is", i);
              
          }      
       }
       current = openSet.get(lowestIndex);    
       println("current is");
       if(current == end){
         
            println("done");
              
             AStarPath = new IntList();
             int temp = current;
             //AStarPath.add(agent.arrayOfPoints[temp]);
            AStarPath.append(temp);
            
             //while(temp.previous != null){
            while(previous[temp] != -1){       
             AStarPath.append(previous[temp]);
             temp = previous[temp];
             }  
             println("the astar path is", AStarPath);  
             return;
         //noLoop();
        // println();
        // println("DONE");
         
       } 
       println("size is", openSet.size());
       println("current is", current);
       openSet.remove(lowestIndex);
       inOpenSet[current] = false;
       closedSet.set(current, current);
       inClosedSet[current] = true;
       //now check neighbors that haven't been checked before
       //what are all the neighbors of current?
       //we must evaluate all neighbors before we add them to the openSet  
       //ArrayList<VECTOR> neighbors = current.neighbors; 
       println("the neighbors of current are",neighbors[current]); 
       //ArrayList<Integer> aStarneighbors = neighbors[lowestIndex]; //get the neighbors of current. That is what is the arrayList stored in agent.neighbors[lowestIndex]
       //lowestIndex is an index for openSet(), the indices of which may not match the other arrays f[], g[], h[], and neighbors[]
       ArrayList<Integer> aStarneighbors = neighbors[current]; //get the neighbors of current. That is what is the arrayList stored in agent.neighbors[lowestIndex]
       println(aStarneighbors);    
       for(int i = 0; i < aStarneighbors.size(); i++){
           //check every neighbor and increase g by one
           //g is the number of steps to get to neighbor
           int neighbor = aStarneighbors.get(i); 
           //unless neighbor is in the closed set
          if(inClosedSet[neighbor] == false){
             
                 float tempG = g[neighbor] = g[current]+1;                 
                 //We don't want to add to g if there is already an efficient g
                 newPath = false;
                 if(inOpenSet[neighbor] == true){
                    if(tempG <  g[neighbor]){
                       g[neighbor] = tempG;
                       newPath = true;
                    }  
                 }
                 else{
                     g[neighbor] = tempG;
                     newPath = true;
                     //openSet.add(arrayOfPoints[neighbor]);
                     openSet.set(neighbor, neighbor);
                     
                     inOpenSet[neighbor] = true;
                 }
                 //the heuristic is the euclidean distance
                 if(newPath){
                   h[neighbor] = heuristic(arrayOfPoints[neighbor], arrayOfPoints[num-1]);
                   f[neighbor] = g[neighbor] + h[neighbor];  
                   previous[neighbor] = lowestIndex;
                 }
           }
           
       }//for
                 
   }//while
       
       println();
       println("No Solution");
         
}
   
}//class
