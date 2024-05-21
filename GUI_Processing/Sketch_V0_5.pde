
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


OscP5 oscP5;
NetAddress myRemoteLocation; 
ControlP5 cp5; 


//=======================//
// 
float knobVol, knobClipp, knobRev; // Variables to store the knob values
float sliderVal;                   // Variables to store the slider value
int  modX, modY, modZ, modHR;      // Variables to store the modulation mapping values






//=======================//
//Canvas attributes
float x_off = 10;
float y_off = 240;
float l =450;
float w = 250;
float r_canv = 10;
//=======================//

//=======================//
//Dancer's attributes
float x, y; // Variables to store the position of the dancer
float x_off_d = ( l + x_off )  / 2;
float y_off_d = ( w + 2*y_off )  / 2; 
float speedX, speedY; // Variables to store the speed of the dancer
float accX, accY; // Variables to store the acceleration of the dancer
float radius = 10; // Radius of the "dancer"
//=======================//

float a,b;
float a_room, b_room;
float a_mix, b_mix;
float a_vol, b_vol;
float a_filter, b_filter;


//We assume BPM to be at least 0 (dead dancer scenario)
float min_cut_off_freq = 500; // [Hz]
float max_cut_off_freq = 2000; // [Hz]

float BPM = 180/2;
float BPM_Hz = BPM / 60;
float max_BPM_Hz = 180/60;


float panning, volume, mix, room, filter_freq;


public void setup(){
  size(905, 640, JAVA2D);
  // Position the canvas on the screen (x, y)
  createGUI();
  //customGUI();
   

  // Place your setup code here
  
  oscP5 = new OscP5(this, 12000);    //public OscP5(Object theParent, int theReceiveAtPort)
      //12 000 representing the port number on the remote machine to which the OSC messages should be sent
  
  myRemoteLocation = new NetAddress("127.0.0.1", 57120);  //address where we send the osc messages, "127.0.0.1" as local work here
      //127.0.0.1 being the "localhost"
      
  //cp5 = new ControlP5(this);
  speedX = 3;
  speedY = 3;
  x = x_off_d;
  y = y_off_d;
  
}

public void draw(){
  background(230);
  //frameRate(30);
  controlEvent();
  //draw2();
  
  //Draw the canvas
  rect(x_off, y_off, l, w, r_canv);
  fill(255); //White
  
  // Draw the ball
  fill(0); //Black
  if (modX ==0){
    ellipse(x, y, radius, radius);}
    else{
      rect(x, y, radius, radius);}
  fill(255); //White
  
  // Temporary 
  //Check for collisions with the walls
  if (x + radius >= l + x_off || x - radius <= x_off) {speedX *= -1; // Reverse the x direction
  }
  if (y + radius >= y_off + w || y - radius <= y_off) {speedY *= -1; // Reverse the y direction}
  }
  
  // Update the position of the ball
  x += speedX ;
  y += speedY;
  
  
  //================================================
  // Change the selected parameters for X - position
  if (modX == 0){
    b = -1 - 2 * x_off/  l;
    a = 2 / l;
    panning = a*x +b;
    println("panning = " + panning);
  }
  else if (modX == 1){
    b_mix = - x_off/  l;
    a_mix = 1 / l;
    mix = a_mix*x +b_mix;
    println("mix = " + mix);
  }
  else if (modX == 2){
    b_room = - x_off/  l;
    a_room = 1 / l;
    room = a_room*x +b_room;
    println("room = " + room);
  }
  else if (modX == 3){
      a_vol = 20 / l;
      b_vol = -10 -20*x_off/l;
      volume = a_vol*x + b_vol;
      println("volume = " + volume);
    }
  else { println("Error in modX value"); exit();}
  
  
  //============================================
  // Change the selected parameters for HR value
  if (modHR == 0){
    b_filter = min_cut_off_freq;
    a_filter = (max_cut_off_freq - min_cut_off_freq) / max_BPM_Hz;
    filter_freq = a_filter * BPM_Hz + b_filter;
    println("b_fitler = " + b_filter);
    println("a_fitler = " + a_filter);
    println("fitler_freq = " + filter_freq);
  }
  
}

// Use this method to add additional statements
// to customise the GUI controls
public void customGUI(){
}


public void controlEvent(){
  //Controls which event happens in the processing code
  OscMessage msgKnob = new OscMessage("/knobs"); //message name
  msgKnob.add( knobVol );
  msgKnob.add( knobClipp );
  msgKnob.add( knobRev );
  oscP5.send(msgKnob, myRemoteLocation);// Send the message to the remote location (loopback address)
  //msgKnob.print();
  
  OscMessage msgMods = new OscMessage("/Modulation_mapping"); //message name
  msgMods.add( modX );
  msgMods.add( modY );
  msgMods.add( modZ );
  msgMods.add( modHR );
  oscP5.send(msgMods, myRemoteLocation);
  msgMods.print();
  
  
  OscMessage msgSlider = new OscMessage("/Slider"); //message name
  msgSlider.add( sliderVal );
  oscP5.send(msgSlider, myRemoteLocation);
  //msgSlider.print();
  
 

  
}

  
