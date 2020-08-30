//SOURCES:
//https://youtu.be/h0NJK4mEIJU for dot product and cross product explanation
//https://www.geeksforgeeks.org/program-dot-product-cross-product-two-vector/


//NOTES
//The functions change the values of the this.vector. To use these functions always declare a new vector and call the functions with the new vector 
//Future Work: Separate the class and the library


////START///////CLASS/////////////////////////CLASS////////////////////////CLASS//////////////////////////////////////////////////////
class VECTOR{

    float xp;
    float yp;
    float zp;
    
    //normalized  positions
    float xpn;
    float ypn;
    float zpn;

    float magnitude;
    
 VECTOR(float ini_xp, float ini_yp, float ini_zp){
        
            xp = ini_xp;
            yp = ini_yp;
            zp = ini_zp;          
  }

 float dotv(VECTOR  firstVector, VECTOR secondVector){
   
   return (firstVector.xp*secondVector.xp) + (firstVector.yp*secondVector.yp) + (firstVector.zp*secondVector.zp);
    
 }
//From geeksforgeeks.org: (a2 * b3 – a3 * b2) * i + (a3 * b1 – a1 * b3) * j + (a1 * b2 – a2 * b1) * k, where [(a2 * b3 – a3 * b2), (a3 * b1 – a1 * b3), (a1 * b2 – a2 * b1)] are the coefficient of unit vector along i, j and k directions.  
//gives the vector perpendicular to the firstVector and secondVector. The magnitude of crossVector is the area of the parallelogram formed by firstVector and secondVector 
 void crossv(VECTOR  firstVector, VECTOR secondVector){
   
   xp = (firstVector.yp*secondVector.zp)- (firstVector.zp*secondVector.yp);
   yp = (firstVector.zp*secondVector.xp)- (firstVector.xp*secondVector.zp); 
   zp = (firstVector.xp*secondVector.yp)- (firstVector.yp*secondVector.xp);
   
 }

// VECTOR crossv(VECTOR  firstVector, VECTOR secondVector){
   
  // VECTOR crossVector;
  // float xpc = (firstVector.yp*secondVector.zp)- (firstVector.zp*secondVector.yp);
  // float ypc = (firstVector.zp*secondVector.xp)- (firstVector.xp*secondVector.zp); 
  // float zpc = (firstVector.xp*secondVector.yp)- (firstVector.yp*secondVector.xp);
        
   //crossVector = new VECTOR(xpc, ypc, zpc);
   
 //  return crossVector;
// }

float magnitude(){
   
       magnitude = sqrt(xp*xp + yp*yp + zp * zp);
       return magnitude;
 }
 
 void normalizev(){
   
      magnitude = sqrt(xp*xp + yp*yp + zp * zp); 
      xpn = xp/magnitude;
      ypn = yp/magnitude;
      zpn = zp/magnitude;  
 
 }  
 
 VECTOR scalarmultiply(float c){
     
     return new VECTOR(c*xp, c*yp, c*zp);
 
 
 }

 void addv(VECTOR firstVector, VECTOR secondVector){
         
         xp = firstVector.xp+secondVector.xp;
         yp = firstVector.yp+secondVector.yp;
         zp = firstVector.zp+secondVector.zp;  
  }   
           
 void subtract(VECTOR firstVector, VECTOR secondVector){

         xp = firstVector.xp-secondVector.xp;
         yp = firstVector.yp-secondVector.yp;
         zp = firstVector.zp-secondVector.zp;
   }
// this function prints the vector coordinates


  float distance(VECTOR firstVector, VECTOR secondVector)
  {
  
    float xdiff;
    float ydiff;
    float zdiff;
    
    xdiff = firstVector.xp - secondVector.xp;
    ydiff = firstVector.yp - secondVector.yp;
    zdiff = firstVector.zp - secondVector.zp;
    
   return sqrt((xdiff*xdiff) + (ydiff*ydiff) + (zdiff*zdiff));
  
  }

 void vectorPrint(){
  
        println(xp, yp, zp);
  }
  
}//Class
////END///////CLASS/////////////////////////CLASS////////////////////////CLASS//////////////////////////////////////////////////////
