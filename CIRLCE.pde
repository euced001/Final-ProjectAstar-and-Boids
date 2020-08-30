class CIRCLE{
      
      PShape deb;
      VECTOR position = new VECTOR(0, 0, 0); 
      float rotAngle = random(0, PI);
       float rotAngle2 = random(0, PI);
       int boxLength = 40;//25;
      float radius = boxLength + 10;
      
      PImage debImg;
      
     
  
      //SATELLITE(VECTOR i_position, int i_radius, color i_c){
CIRCLE(VECTOR i_position){
   deb = createShape(BOX, boxLength,boxLength,boxLength);
   debImg = loadImage("spacedbr.jpg");
   //position = 
   position = i_position;
   noStroke();
   //noFill();
   //deb.setTexture(debImg);
   deb.rotateY(rotAngle);
   deb.rotateX(rotAngle2);
   //circ.scale(10);


}
    
void showDebris(){           
  
  
  pushMatrix();
  fill(255, 0, 0);
  //translate(position.xp, position.yp, position.zp);     
  translate(position.xp,position.yp, position.zp);
  shape(deb);
  popMatrix();      



}

}//class
