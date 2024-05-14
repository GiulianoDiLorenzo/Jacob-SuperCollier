import netP5.*;
import oscP5.*;



import shapes3d.*;
import shapes3d.contour.*;
import shapes3d.org.apache.commons.math.*;
import shapes3d.org.apache.commons.math.geometry.*;
import shapes3d.path.*;
import shapes3d.utils.*;

import apsync.*;
import sprites.*;
import sprites.maths.*;
import sprites.utils.*;

import g4p_controls.*;

// Need G4P library
import g4p_controls.*;
// You can remove the PeasyCam import if you are not using
// the GViewPeasyCam control or the PeasyCam library.
import peasy.*;
 
OscP5 oscP5;
NetAddress myRemoteLocation;
float y;
float gravity = 0.1;
float velocity = 0;
float bounceFactor = -0.7;
//PImage Micky;

public void setup(){
  size(905, 640, JAVA2D);
  createGUI();
  customGUI();
  // Place your setup code here
  oscP5 = new OscP5(this, 8000);
  y = 10 + 220 / 2;
  //Micky = loadImage("Micky.jpeg.jpeg");
  
}

public void draw(){
  background(230);
  
   velocity += gravity;
  y += velocity;
  imageMode(CENTER);
 // image(Micky, 320,180);
  
   if (y > 220 + 240) {
    y = 220 + 240;
    velocity *= bounceFactor;  // Inverte la velocità quando tocca il "terreno"
  }
  if (y < 220) {
    y = 220;
    velocity *= bounceFactor;  // Inverte la velocità quando tocca il "soffitto"
  }
  
  // Disegna la pallina
  stroke(0);
  imageMode(CENTER);
  ellipse(width / 2, y, 50, 50);
  //image(Micky, 20, 20, 50, 50);
  
}
void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.checkAddrPattern("/bounce")) {
    int sensorValue = theOscMessage.get(0).intValue();
    
    // Mappa il valore del sensore a un valore di velocità
    velocity = map(sensorValue, 0, 1023, -10, 10);
  }
}
// Use this method to add additional statements
// to customise the GUI controls
public void customGUI(){

}
