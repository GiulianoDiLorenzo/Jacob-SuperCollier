// Need G4P library for the GUI 
import g4p_controls.*;

//import controlP5.*;
import oscP5.*; //OSC messages library
import netP5.*; //Network addressing

import processing.serial.*; //Serial communication handled by Arduino


OscP5 oscP5;
NetAddress myRemoteLocation; 
//ControlP5 cp5; 

Serial serialPort;

//================================================//
// Variables to store the OSC Messages from Arduino
//================================================//
float accXInput, accYInput, accZInput, HRInput;
float timeStep = 0.200; // [s] MATCHING WITH ARDUINO'S timeStep



//====================================================================//
// Interaction storing values
// CHECK THAT THE INITIALISATION MATCHES WITH THE GUI SELECTED OPTIONS
//===================================================================//
float knobVol, knobClipp, knobRev; // Variables to store the knob values
float sliderVal;                   // Variables to store the slider value
int  modX, modY, modZ, modHR;      // Variables to store the modulation mapping values

//=======================//
//Canvas attributes
//=======================//
float x_off;   // [pixels]
float y_off;   // [pixels]
float l ;      // [pixels]
float w ;      // [pixels]
float r_canv;  // [pixels]

//=======================//
//Dancer's attributes
float x_off_d, y_off_d, z_off_d;    // [pixels]      arbitrary offset position for the display of the dancer
float x, y, z;                      // [pixels]      Variables to store the position of the dancer
float speedX, speedY;               // [m/s]    Variables to store the speed of the dancer
float accX, accY;                   // [m/s²]   Variables to store the acceleration of the dancer
float radius;                       // [pixels] Radius of the "dancer"


//=====================================================================//
// Linear factors for converting the dancer's signal into relevant values
//=====================================================================//
float a,b;                // [-]
float a_room, b_room;     // [-]
float a_mix, b_mix;       // [-]
float a_vol, b_vol;       // [-]
float a_filter, b_filter; // [-]
float a_chorus, b_chorus; // [-]



//=======================//
// Temporary BPM values for crash testing
float BPM = 180/4;
float BPM_Hz = BPM / 60;
float max_BPM_Hz = 180/60;
float min_cut_off_freq; // [Hz]  We assume BPM to be at least 0 (dead dancer scenario)
float max_cut_off_freq; // [Hz]


//===========================================================//
// Modulation effects values to communicate to SC and/or JUCE
//===========================================================//
float panning, volume, mix, room, filter_freq, pitch_shift, phaser_period, rev_decay, chorus_fb;

ArrayList<Integer> list = new ArrayList<Integer>();

public void setup(){
  size(500, 600, JAVA2D);  
  createGUI(); 
  
  serialPort = new Serial(this, "COM6", 9600);      // INSERT YOUR COM FOR ARDUINO, MAKE SURE IT MATCHES THE DETECTED COM IN ARDUINO

  oscP5 = new OscP5(this, 12000);    //public OscP5(Object theParent, int theReceiveAtPort)
      //12 000 representing the port number on the remote machine to which the OSC messages should be sent
  
  myRemoteLocation = new NetAddress("127.0.0.1", 57120);  //address where we send the osc messages, "127.0.0.1" as local work here
      
  //cp5 = new ControlP5(this);
  
  //===============================//
  //Canvas attributes, all in pixels
  //===============================//
  x_off = 25;
  y_off = 220;
  l =450;
  w = 250;
  r_canv = 10;
  
  //=========================================================================================//
  //Placing the dancer at the centre of the "room", all in pixels except for z (to check later)
  //=========================================================================================//
  x_off_d = x_off + l/ 2;        
  y_off_d = y_off + w / 2;      
  radius = 10;                         
  x = x_off_d;
  y = y_off_d;
  z_off_d = 1.3; // [m]
  z = z_off_d + 1.5;
  
  //===============================//
  //Initialising the selected options
  //===============================//
  modX = 0; modY = 1; modZ = 0; modHR = 0;
  
  
  //========================================//
  //Setting the frequency limits of our filter
  //========================================//
  min_cut_off_freq = 200; // [Hz]
  max_cut_off_freq = 2000; // [Hz]


  //==============================================//
  // Initialising the effects parameters, arbitrary
  //==============================================//
  panning = 0;                     // [-]
  volume = 0;                      // [dB]
  mix = 0;                         // [-]
  room = 0;                        // [-]
  filter_freq = min_cut_off_freq;  // [Hz]
  pitch_shift = 0;                 // [-]
  phaser_period = 0.010;           // [s]
  rev_decay = 0.010;               // [s] 
  chorus_fb = 0.0;                 // [-]
  
  delay(1000);  //Delay to make sure that calibration is done when we first display the GUI
}

public void draw(){
  background(230);
  frameRate(120);
  
  //OSC message function
  controlEvent();
 
  // Gathering the Arduino messages 
  harvestSerial();
  
  //Updating the list of parameters we don't change
  setNan();
  
  //Draw the canvas
  rect(x_off, y_off, l, w, r_canv);
  fill(255); //White
  
  // Draw the "dancer"
  fill(0); //Black
  if (modX ==0){
    ellipse(x, y, radius, radius);}
    else{
      rect(x, y, radius, radius);}
  fill(255); //White
  
  // Updating the dancer's position
  x += accXInput * timeStep * timeStep;   // [pixels]
  y += accYInput * timeStep * timeStep;  // [pixels]
  
  //Check for collisions with the walls - The dancer cannot go outside of the canvas
  if (x + radius >= l + x_off)      {x = l + x_off - radius;}
  else if (x - radius <= x_off )    {x = x_off + radius;}
  if (y + radius >= y_off + w)      {y = y_off + w - radius;}
  else if (y - radius <= y_off)     {y = y_off + radius;}
  
  
  //println("====================");
  change_X_pos_mapping();
  change_Y_pos_mapping();
  change_Z_pos_mapping();
  change_HR_mapping();
  //println("====================\n");
  //println("\n");
}

public void controlEvent(){
  //Construct OSC messages with the provided values
  // Sends the OSC message so that SuperCollider and/or Juce can use them
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
  //msgMods.print();
  
  
  OscMessage msgSlider = new OscMessage("/Slider"); //message name
  msgSlider.add( sliderVal );
  oscP5.send(msgSlider, myRemoteLocation);
  //msgSlider.print(); 
  
  
  OscMessage msgModValue = new OscMessage("/Effects_Values"); //message name
  msgModValue.add( panning );
  msgModValue.add( mix );
  msgModValue.add( room );
  msgModValue.add( volume );
  msgModValue.add( filter_freq );
  msgModValue.add( pitch_shift );
  msgModValue.add( phaser_period );
  msgModValue.add( rev_decay );
  msgModValue.add( chorus_fb );
  
  oscP5.send(msgModValue, myRemoteLocation);
  msgModValue.print();
}

void change_X_pos_mapping(){
  //================================================
  // Change the selected parameters for X - position
  // We assume that modX = {0, 1, 2, 3}
  //This function changes the appropriate modulation effect, depending on the selected option and on the values provided by the dancer's sensors
  if (modX == 0){
    b = -1 - 2 * x_off/  l;
    a = 2 / l;
    panning = a*x +b;
    //println("panning = " + panning);
  }
  else if (modX == 1){
    b_mix = - x_off/  l;
    a_mix = 1 / l;
    mix = a_mix*x +b_mix;
    //println("mix = " + mix);
  }
  else if (modX == 2){
    b_room = - x_off/  l;
    a_room = 1 / l;
    room = a_room*x +b_room;
    //println("room = " + room);
  }
  else if (modX == 3){
      a_vol = - 20 / l;
      b_vol = 20*x_off/l;
      volume = a_vol*x + b_vol;
      //println("volume = " + volume + "dB");
    }
  else { println("Error in modX value"); exit();}
}


void change_Y_pos_mapping(){
  //================================================
  // Change the selected parameters for Y - position
  // We assume that modY = {0, 1, 2, 3}
  //This function changes the appropriate modulation effect, depending on the selected option and on the values provided by the dancer's sensors
  if (modY == 0){
    b = -1 - 2 * y_off/ w;
    a =   2 / w;
    panning = - ( a*y + b) ;
    //println("panning = " + panning);
  }
  else if (modY == 1){
    b_mix = 1 + y_off/  w;
    a_mix =  - 1 / w;
    mix =  a_mix*y + b_mix ;
    //println("mix = " + mix);
  }
  else if (modY == 2){
    b_room = 1 + y_off/  w;
    a_room = - 1 / w;
    room = a_room*y +b_room;
    //println("room = " + room);
  }
  else if (modY == 3){
      a_vol =   - 20 / w;
      b_vol = 20*y_off/w;
      volume = a_vol*y + b_vol;
      //println("volume = " + volume + " dB");
    }
  else { println("Error in modY value"); exit();}
}

void change_Z_pos_mapping(){
  //================================================
  // Change the selected parameters for Z - position
  // We assume that modZ = {0, 1}
  //This function changes the appropriate modulation effect, depending on the selected option and on the values provided by the dancer's sensors
  //For now, we are thresholding the pitch shift, but this might change later
  
  if (modZ == 0){
    if ( (z >= 0) && (z < 0.5) ) {
      pitch_shift = -2 ; //-2 semitones shift
    }
    else if ( (z >= 0.5) && (z < 1) ) {
      pitch_shift = -1 ; //-1 semitone shift
    }
    else if ( (z >= 1) && (z < 1.5) ) {
      pitch_shift = 0 ; //0 semitone shift
    }
    else if ( (z >= 1.5) && (z < 2) ) {
      pitch_shift = +1 ; //+1 semitones shift
    }
    else {
      pitch_shift = +2 ; //+2 semitones shift
    }
    //println("pitch_shift = " + pitch_shift);
  }
  else if (modZ == 1){
    b_chorus = -1 ;
    a_chorus = + 1 ;
    chorus_fb = a_chorus*z + b_chorus;
    //println("chorus_fb = " + chorus_fb);
  }
  else  {println("Error in modZ value"); exit();}
}

void change_HR_mapping(){
  //================================================
  // Change the selected parameters for HR value
  // We assume that modHR = {0, 1, 2}
  //This function changes the appropriate modulation effect, depending on the selected option and on the values provided by the dancer's sensors
  if (modHR == 0){
    b_filter = min_cut_off_freq;
    a_filter = (max_cut_off_freq - min_cut_off_freq) / max_BPM_Hz;
    filter_freq = a_filter * (1000/HRInput) + b_filter;
    //println("fitler_freq = " + filter_freq);
  }
  else if (modHR == 1){
    phaser_period = (1000/HRInput);
    //println("phaser_period = " + phaser_period + "s");
  }
  else if (modHR == 2){
    rev_decay = (1000/HRInput);
    //println("reverb decay = " + rev_decay + "s");
  }
  else { println("Error in modHR value"); exit();}
}



void harvestSerial(){
    //This function gathers the Arduino messages and stores the values in 4 different variables of interest
  if (serialPort.available() > 0) {
    String data = serialPort.readStringUntil('\n');
    
    println("data:" + data);
    
    if (data != null) {
      // Split the received string into accelerometer and heart rate values
      String[] values = data.trim().split(",");
      
      /*
      println("values length: " + values.length);
      println("values[0]: " + values[0]);
      println("values[1]: " + values[1]);
      println("values[2]: " + values[2]);
      println("values[3]: " + values[3]);
      */
      if (values.length == 4) {
        accXInput = float(values[0]);
        accYInput = float(values[1]);
        accZInput = float(values[2]);
        HRInput = float(values[3]);
      }
    }
  }
  /*
  println("AccX: " + accXInput);
  println("AccY: " + accYInput);
  println("AccZ: " + accZInput);
  println("HR: " + HRInput);
  println();
*/
}

void setNan() {
  //This function updates the list of parameters that are not modified by the dancer
  //This will allow us to include in the OSC Message, what to look for to modify the effects
  //If a value is NaN, SuperCollider and/or Juce will know that this parameter is not modified by the dancer
  list.clear();
  list.add(0);
  list.add(1);
  list.add(2);
  list.add(3);
  
  if (list.contains(modX)) {
    list.remove(Integer.valueOf(modX));
  }
  
  if (list.contains(modY)) {
    list.remove(Integer.valueOf(modY));
  }
  
  print("list: " + list);
  
  if (list.get(0) == 0 || list.get(1) == 0) {
    panning = Float.NaN;
  }
  if (list.get(0) == 1 || list.get(1) == 1) {
    mix = Float.NaN;
  }
  if (list.get(0) == 2 || list.get(1) == 2) {
    room = Float.NaN;
  }
  if (list.get(0) == 3 || list.get(1) == 3) {
    volume = Float.NaN;
  }
}
