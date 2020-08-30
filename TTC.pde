//THIS is the TTC Library
//SOURCES: Guide to Anticipatory Collision Avoidance Chapter 19 by Stephen Guy and Ioannis Karamouzas 

float tau; //time to collision
int INFTY = 1000;
float tH = 4;//4s is reccomendation on CH 19
float maxF = 20;


void runTTC(){
  ////for ttc
  for(int i = 0; i < numAgents; i++){
      agent1[i].edges();
      //*ttcAlgorithm(agent1[i], 1/frameRate);
      float d = distance(agent1[i].position, goal);
      if(d > agentAndTargetRadius*1.5){
        ttcAlgorithm(agent1[i], 1/frameRate);
        
      } 
  }
}


////////////////Below is the code from the chapter. //////////////////
float ttc(AGENT agent1, AGENT agent2){
    
  float r = agent1.agentRadius + agent2.agentRadius;
  VECTOR w = new VECTOR(0,0,0);
  w.subtract(agent1.position, agent2.position);
  println(w);
  
  float c = w.dotv(w, w) - r*r; //agents are colliding
  if(c>0){
    return 0;   
  }
  VECTOR v = new VECTOR(0,0,0);
  v.subtract(agent1.velocity, agent2.velocity);
  float a = v.dotv(v,v);
  float b = v.dotv(w,v);
  float discr = b*b - a*c;
  if(discr <=0){
    return INFTY;
  }
  tau = (b - sqrt(discr))/a;
  if(tau < 0){
    return INFTY;
  }
  return tau;
  
}


void ttcAlgorithm(AGENT agent, float dt){

  ArrayList<AGENT> ttcNeighbors = new ArrayList(); 
  //for each agent i find all the neighbors within sensing radius
  for(int i = 0; i < numAgents; i ++){
      float d =  distance(agent.position, agent1[i].position);    
      if(d < agent.sensingRadius && agent != agent1[i]){
         ttcNeighbors.add(agent1[i]);
      }    
  }
  
  agent.goalForce.subtract(agent.goalVelocity, agent.velocity);   //compute the goal force eqn 19.3
  agent.goalForce.scalarmultiply(2);
  for(int i = 0; i < ttcNeighbors.size(); i++){
    //compute time-to-collision
    float t = ttc(agent, ttcNeighbors.get(i));
    //compute collision avoidance foce
    //force direction eqn 19.5        
    VECTOR vector1 = new VECTOR(0, 0, 0); //x[i] + v[i]*t
    VECTOR vector2 = new VECTOR(0, 0, 0); //x[j] + v[j]*t
    VECTOR forceAvoid = new VECTOR(0, 0, 0);
    agent.velocity.scalarmultiply(t);
    ttcNeighbors.get(i).velocity.scalarmultiply(t); 
    vector1.addv(agent.position, agent.velocity); 
    vector2.addv(ttcNeighbors.get(i).position, ttcNeighbors.get(i).velocity);  //???typo in the 19.3 Listing?
    forceAvoid.subtract(vector1, vector2);
    if(agent.forceAvoid != ZERO && ttcNeighbors.get(i).forceAvoid != ZERO){
       float c = sqrt(forceAvoid.dotv(forceAvoid, forceAvoid));
       forceAvoid.scalarmultiply(1/c); 
    }  
    //Force Magnitue eqn 19.6
    float mag = 0;
    if(t>=0 && t <= tH){
       mag = (tH - t)/(t+0.001);
    }
    if(mag > maxF){
       mag = maxF;
    } 
    forceAvoid.scalarmultiply(mag);
    agent.goalForce.addv(agent.goalForce, forceAvoid);   
  }
  //Apply the forces eqn 19.4 
  agent.goalForce.scalarmultiply(dt);
  agent.velocity.addv(agent.velocity, agent.goalForce);
  agent.velocity.scalarmultiply(dt);
  agent.position.addv(agent.position, agent.velocity);

}
