
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


//float mainKnobVol;

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
  
}

public void draw(){
  background(230);
  controlEvent();
  
  
  
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
  
  // Send the message to the remote location (loopback address)
  oscP5.send(msg, myRemoteLocation);
  msg.print();
  
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
  msgSlider.print();
  
 

  
}

  
