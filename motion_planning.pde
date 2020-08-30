//This is to find the sample PRM points
void findPRMpoints(){
          
          PRMpoints[numpoints-1] = goal;
          println("The goal is:");
          PRMpoints[numpoints-1].vectorPrint();

         
          for (int i = 0; i < numpoints-1; i++)
          {         
              //VECTOR samplePoint = new VECTOR(random(0,800), random(0, 800), 0);//this is so that points are not within the plane
              VECTOR samplePoint = new VECTOR(random(-planeLen+radius, planeLen-radius), planeYValue, random(-planeLen+radius, planeLen-radius));

              
              float dist;
              dist = distance(samplePoint, sphere);
              dist *= dist;
                   
              while(dist <= radius)
              {   
                  //samplePoint = new VECTOR(random(0, width), random(0, height), 0);//this is so that points are not within the plane
                  samplePoint = new VECTOR(random(-planeLen-radius, planeLen+radius), planeYValue, random(-planeLen+radius, planeLen-radius));

              }
              
              PRMpoints[i] = samplePoint;
              println(i);
              println("the sample point is:");
              PRMpoints[i].vectorPrint();
              println();

          }
          println("Done sampling points!");
}

float distance(VECTOR firstVector, VECTOR secondVector)
{  
          float xdiff;
          float ydiff;
          float zdiff;
          xdiff = firstVector.xp - secondVector.xp;
          ydiff = firstVector.yp - secondVector.yp;
          zdiff = firstVector.zp - secondVector.zp;
          
          return sqrt(xdiff*xdiff + ydiff*ydiff + zdiff*zdiff);  
} 
         
//connect function for PRM points


//array of booleans to determine if visited
int num = numpoints + 1;
boolean prmvisited[]  = new boolean[num]; 
ArrayList<Integer>[] prmneighbors = new ArrayList[num];  //A list of neighbors can can be reached from a given node 
void prmConnect(){
        //boolean collide = false;
        for (int i = 0; i < numpoints; i++)
        {
      
          prmneighbors[i] = new ArrayList<Integer>(); //comment out for if within in agents
          VECTOR poc = new VECTOR(0,0,0);
          poc.subtract(PRMpoints[i], sphere);
          
          float c; 
          c = (poc.xp*poc.xp) + (poc.zp*poc.zp) - (radius*radius);
          // This should avoid connecting with oneself and also checking twice for the same pair of points
         
          for ( int j = i+1; j < numpoints; j++)
              
              {
                boolean collide = false;
                VECTOR vel = new VECTOR(0,0,0);
                vel.subtract(PRMpoints[i], PRMpoints[j]);
          
                float a; 
                
                a = vel.magnitude();
                a *= a;
          
                float b;
                b = 2*vel.dotv(vel, poc);
        
                      for(int k = 0; k < debrisTotal; k++){
                      
                          VECTOR pock = new VECTOR(0, 0, 0);   
                          pock.subtract(PRMpoints[i], debris[k].position);
             
                          float ck; 
                          ck = (pock.xp*pock.xp) + (pock.yp*pock.yp) - (debris[k].radius*debris[k].radius);
                          
                                
                          float ak; 
                          ak = vel.magnitude();
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
          
                        println(k);
                        print(collide);
                    
                   }
               
                
                //checking for j = 2 should avoid connecting the agents
                //if (sqrt(b*b - 4*a*c) > 0 && (collide == false))
                if (sqrt(b*b - 4*a*c) > 0 )
                {
                  collide = true;
                } 
                else if( collide == false)
                {
                  prmneighbors[i].add(j);
                }
          }
  
        }//outerloop
}
      
      
      
