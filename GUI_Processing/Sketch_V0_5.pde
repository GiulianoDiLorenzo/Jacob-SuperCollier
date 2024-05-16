
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

import controlP5.*;
import oscP5.*; //OSC messages library
import netP5.*; //Network addressing

float knobVol, knobClipp, knobRev;

float sliderVal;

int  modX, modY, modZ, modHR;


OscP5 oscP5;
NetAddress myRemoteLocation; 
ControlP5 cp5; 

//=======================//
//Temporary Variables ? 
float x, y; // Variables to store the position of the ball
float speedX, speedY; // Variables to store the speed of the ball
float radius = 20; // Radius of the ball
//=======================//


public void setup(){
  size(905, 640, JAVA2D);
  createGUI();
  //customGUI();
  
    

  // Place your setup code here
  
  oscP5 = new OscP5(this, 12000);    //public OscP5(Object theParent, int theReceiveAtPort)
      //12 000 representing the port number on the remote machine to which the OSC messages should be sent
  
  myRemoteLocation = new NetAddress("127.0.0.1", 57120);  //address where we send the osc messages, "127.0.0.1" as local work here
      //127.0.0.1 being the "localhost"
      
  //cp5 = new ControlP5(this);
  
  //==================//
  //===Temporary setup ?==//
  
  //WF_Display_panel = new GPanel(this, 10, 220, 450, 240, "Show my Spectrogram");
  x = 460/2; // Set the initial x position to the middle of the canvas
  y = 460*0.8; // Set the initial y position to the middle of the canvas 
  speedX = 3; // Set the initial speed in the x direction
  speedY = 2; // Set the initial speed in the y direction
  

  
  
  
}

public void draw(){
  background(230);
  //frameRate(30);
  controlEvent();
  draw2();
  
  
  
}

void mouseClicked() {
  //line(mouseX, 100, mouseX, 900);
}

public void draw2(){
  //WF_Display_panel = new GPanel(this, 10, 220, 450, 240, "Show my Spectrogram");
  rect(10, 240, 450, 240, 10);
  fill(255); //White
  
  if  ( (mouseX <= 450 +10) && (mouseX >= 10) &&  (mouseY <= 220 +240) && (mouseY >= 220) ){ 
    circle(mouseX, mouseY, knobRev*20);
  }
    
    
  //==================//
  //===Temporary draw ?==//
  // Draw the ball
  fill(0); //Black
  if (modX ==0){
    ellipse(x, y, knobRev*30, knobRev*30);}
    else{
      rect(x, y, knobRev*30, knobRev*30);}
  fill(255); //White
  
  // Update the position of the ball
  x += speedX*knobVol*10;
  y += speedY*knobVol*10;
  
  
    // Check for collisions with the walls
  if (x + knobRev*20 >= 450 +10 || x - knobRev*20 <= 10) {speedX *= -1; // Reverse the x direction
  }
  if (y + radius >= 220 +240 || y - radius <= 220) {speedY *= -1; // Reverse the y direction}
  }
  
  
}


// Use this method to add additional statements
// to customise the GUI controls
public void customGUI(){
}





public void controlEvent(){
  //Controls which event happens in the processing code
  OscMessage msg = new OscMessage("/knobs"); //message name
  msg.add( knobVol );
  msg.add( knobClipp );
  msg.add( knobRev );
  oscP5.send(msg, myRemoteLocation);// Send the message to the remote location (loopback address)
  //msg.print();
  
  OscMessage msgMods = new OscMessage("/Modulation_mapping"); //message name
  msgMods.add( modX );
  msgMods.add( modY );
  msgMods.add( modZ );
  msgMods.add( modHR );
  oscP5.send(msgMods, myRemoteLocation);
  //msgMods.print();
  
  
  OscMessage msgSlider = new OscMessage("/Slider"); //message name
  msgSlider.add( sliderVal );
  oscP5.send(msgSlider, myRemoteLocation);
  //msgSlider.print();
  
 

  
}

  
