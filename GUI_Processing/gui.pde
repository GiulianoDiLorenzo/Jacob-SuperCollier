/* =========================================================
 * ====                   WARNING                        ===
 * =========================================================
 * The code in this tab has been generated from the GUI form
 * designer and care should be taken when editing this file.
 * Only add/edit code inside the event handlers i.e. only
 * use lines between the matching comment tags. e.g.

 void myBtnEvents(GButton button) { //_CODE_:button1:12356:
     // It is safe to enter your event code here  
 } //_CODE_:button1:12356:
 
 * Do not rename this tab!
 * =========================================================
 */


//You might want to add a method to handle GOption events syntax is
//public void handleToggleControlEvents(GToggleControl option, GEvent event




public void panel0_Click1(GPanel source, GEvent event) { //_CODE_:Knob_Panel:977156:
  println("panel1 - GPanel >> GEvent." + event + " @ " + millis());

} //_CODE_:Knob_Panel:977156:

public void knobVol_event(GKnob source, GEvent event) { //_CODE_:Volume_knob:300969:
  knobVol = source.getValueF();
  println("Volume - GKnob >> GEvent." + event + " @ " + millis() + " Value: " + knobVol);
} //_CODE_:Volume_knob:300969:

public void knobClipp_event(GKnob source, GEvent event) { //_CODE_:Clipping:241030:
  knobClipp = source.getValueF();
  println("Clipp - GKnob >> GEvent." + event + " @ " + millis() + " Value: " + knobClipp);
} //_CODE_:Clipping:241030:

public void knobRev_event(GKnob source, GEvent event) { //_CODE_:Reverb:753075:
  knobRev = source.getValueF();
  println("Reverb - GKnob >> GEvent." + event + " @ " + millis() + " Value: " + knobRev);
} //_CODE_:Reverb:753075:

public void panel1_Click1(GPanel source, GEvent event) { //_CODE_:Mapping_panel:559424:
  println("panel2 - GPanel >> GEvent." + event + " @ " + millis());
} //_CODE_:Mapping_panel:559424:

public void panel2_Click1(GPanel source, GEvent event) { //_CODE_:panel_X_position:865444:
  println("panel2 - GPanel >> GEvent." + event + " @ " + millis());
} //_CODE_:panel_X_position:865444:

public void Panning_X_position_event(GOption source, GEvent event) { //_CODE_:Panning_X_position:585929:
  println("Vol_mod_1 - GOption >> GEvent." + event + " @ " + millis());  
  // Deselect Panning_Y_position if it's already selected
  if (Panning_Y_position.isSelected()) {
    modY = 1;
    Panning_Y_position.setSelected(false);  //Unselect Panning_Y_position
    Mix_Y_position.setSelected(true);       // Select Mix_Y_position
  }
    modX = 0;
} //_CODE_:Panning_X_position:585929:

public void Mix_X_position_event(GOption source, GEvent event) { //_CODE_:Mix_X_position:920265:
  println("Reverb_mod_1 - GOption >> GEvent." + event + " @ " + millis());
  if (Mix_Y_position.isSelected()) {
    modY = 2;
    Mix_Y_position.setSelected(false);  //Unselect Panning_Y_position
    Room_Y_position.setSelected(true);       // Select Mix_Y_position
  }
  modX = 1;
} //_CODE_:Mix_X_position:920265:

public void Room_X_position_event(GOption source, GEvent event) { //_CODE_:Room_X_position:497020:
  println("Clipp_mod_1 - GOption >> GEvent." + event + " @ " + millis());
  if (Room_Y_position.isSelected()) {
    modY = 3;
    Room_Y_position.setSelected(false);  //Unselect Panning_Y_position
    Volume_Y_position.setSelected(true);       // Select Mix_Y_position
  }
  modX = 2;
} //_CODE_:Room_X_position:497020:

public void Vol_X_position_event(GOption source, GEvent event) { //_CODE_:Vol_X_position:608371:
  println("Other_mod_1 - GOption >> GEvent." + event + " @ " + millis());;
  if (Volume_Y_position.isSelected()) {
    modY = 0;
    Volume_Y_position.setSelected(false);  //Unselect Panning_Y_position
    Panning_Y_position.setSelected(true);       // Select Mix_Y_position
  } 
  modX = 3;
} //_CODE_:Vol_X_position:608371:

public void panel3_Click1(GPanel source, GEvent event) { //_CODE_:panel_Y_position:205923:
  println("panel3 - GPanel >> GEvent." + event + " @ " + millis());
} //_CODE_:panel_Y_position:205923:

public void Panning_Y_position_event(GOption source, GEvent event) { //_CODE_:Panning_Y_position:860463:
  println("Vol_mod_2 - GOption >> GEvent." + event + " @ " + millis());
  if (Panning_X_position.isSelected()) {
    modX = 1;
    Panning_X_position.setSelected(false);  //Unselect Panning_Y_position
    Mix_X_position.setSelected(true);       // Select Mix_Y_position
  }
  modY = 0;
} //_CODE_:Panning_Y_position:860463:

public void Mix_Y_position_event(GOption source, GEvent event) { //_CODE_:Mix_Y_position:761062:
  println("Rev_mod_2 - GOption >> GEvent." + event + " @ " + millis());
  if (Mix_X_position.isSelected()) {
    modX = 2;
    Mix_X_position.setSelected(false);  //Unselect Panning_Y_position
    Room_X_position.setSelected(true);       // Select Mix_Y_position
  }
  modY = 1;
} //_CODE_:Mix_Y_position:761062:

public void Room_Y_position_event(GOption source, GEvent event) { //_CODE_:Room_Y_position:630130:
  println("Clipp_mod_2 - GOption >> GEvent." + event + " @ " + millis());
  if (Room_X_position.isSelected()) {
    modX = 3;
    Room_X_position.setSelected(false);  //Unselect Panning_Y_position
    Vol_X_position.setSelected(true);       // Select Mix_Y_position
  }
  modY = 2;
} //_CODE_:Room_Y_position:630130:

public void Volume_Y_position_event(GOption source, GEvent event) { //_CODE_:Volume_Y_position:905159:
  println("Other_mod_2 - GOption >> GEvent." + event + " @ " + millis());
  if (Vol_X_position.isSelected()) {
    modX = 0;
    Vol_X_position.setSelected(false);  //Unselect Panning_Y_position
    Panning_X_position.setSelected(true);       // Select Mix_Y_position
  }
  modY = 3;
} //_CODE_:Volume_Y_position:905159:

public void panel4_Click1(GPanel source, GEvent event) { //_CODE_:panel_Z_position:899736:
  println("panel4 - GPanel >> GEvent." + event + " @ " + millis());
} //_CODE_:panel_Z_position:899736:

public void Pitch_shift_Z_pos_event(GOption source, GEvent event) { //_CODE_:Pitch_shift_Z_pos:253008:
  println("Vol_Z_speed - GOption >> GEvent." + event + " @ " + millis());
  modZ = 0;
  source.setSelected(true);
} //_CODE_:Pitch_shift_Z_pos:253008:

public void Rev_Z_event(GOption source, GEvent event) { //_CODE_:Rev_Z_speed:207221:
  println("Rev_Z_speed - GOption >> GEvent." + event + " @ " + millis());
  modZ = 1;
  source.setSelected(true);
} //_CODE_:Rev_Z_speed:207221:

public void Clipp_Z_event(GOption source, GEvent event) { //_CODE_:Clipp_Z_speed:437441:
  println("Clipp_Z_speed - GOption >> GEvent." + event + " @ " + millis());
  modZ = 2;
  source.setSelected(true);
} //_CODE_:Clipp_Z_speed:437441:

public void Other_Z_event(GOption source, GEvent event) { //_CODE_:Other_Z_speed:388718:
  println("Other_Z_speed - GOption >> GEvent." + event + " @ " + millis());
  modZ = 3;
  source.setSelected(true);
} //_CODE_:Other_Z_speed:388718:

public void panel5_Click1(GPanel source, GEvent event) { //_CODE_:panel_HR:291612:
  println("panel5 - GPanel >> GEvent." + event + " @ " + millis());
} //_CODE_:panel_HR:291612:

public void Filter_HR_event(GOption source, GEvent event) { //_CODE_:Filter_HR:253166:
  println("Drums_tempo_HR - GOption >> GEvent." + event + " @ " + millis());
  modHR = 0;
  source.setSelected(true);
} //_CODE_:Filter_HR:253166:

public void Phaser_event(GOption source, GEvent event) { //_CODE_:Phaser_HR:244265:
  println("Phaser_HR - GOption >> GEvent." + event + " @ " + millis());
  modHR = 1;
  source.setSelected(true);
} //_CODE_:Phaser_HR:244265:

public void Rever_Decay_HR_event(GOption source, GEvent event) { //_CODE_:Rever_Decay_HR:294957:
  println("Pitch_HR - GOption >> GEvent." + event + " @ " + millis());
  modHR = 2;
  source.setSelected(true);
} //_CODE_:Rever_Decay_HR:294957:

public void panel1_Click2(GPanel source, GEvent event) { //_CODE_:Slider_Panel:967632:
  println("MySlider - GPanel >> GEvent." + event + " @ " + millis());
} //_CODE_:Slider_Panel:967632:

public void slider_event(GSlider source, GEvent event) { //_CODE_:Panning:788127:
  //println("Panning - GSlider >> GEvent." + event + " @ " + millis());
  sliderVal = source.getValueF();
  println("Panning - GSlider >> GEvent." + event + " @ " + millis() + " Value: " + sliderVal);
} //_CODE_:Panning:788127:

public void panel1_Click4(GPanel source, GEvent event) { //_CODE_:WF_2_Display_panel:276233:
  println("WF_2_Display_panel - GPanel >> GEvent." + event + " @ " + millis());
} //_CODE_:WF_2_Display_panel:276233:

public void textarea1_change1(GTextArea source, GEvent event) { //_CODE_:Credits_text:788940:
  println("Credits_text - GTextArea >> GEvent." + event + " @ " + millis());
} //_CODE_:Credits_text:788940:



// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  G4P.messagesEnabled(true);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setCursor(ARROW);
  surface.setTitle("Sketch Window");
  Knob_Panel = new GPanel(this, 0, 540, 200, 100, "Knobs Controls");
  Knob_Panel.setCollapsible(false);
  Knob_Panel.setDraggable(false);
  Knob_Panel.setText("Knobs Controls");
  Knob_Panel.setOpaque(true);
  Knob_Panel.addEventHandler(this, "panel0_Click1");
  Volume_knob = new GKnob(this, 0, 40, 60, 70, 0.8);
  Volume_knob.setTurnRange(110, 70);
  Volume_knob.setTurnMode(GKnob.CTRL_HORIZONTAL);
  Volume_knob.setSensitivity(1);
  Volume_knob.setShowArcOnly(false);
  Volume_knob.setOverArcOnly(false);
  Volume_knob.setIncludeOverBezel(true);
  Volume_knob.setShowTrack(true);
  Volume_knob.setLimits(0.5, 0.0, 1.0);
  Volume_knob.setShowTicks(true);
  Volume_knob.setOpaque(false);
  Volume_knob.addEventHandler(this, "knobVol_event");
  Clipping = new GKnob(this, 60, 40, 60, 70, 0.8);
  Clipping.setTurnRange(110, 70);
  Clipping.setTurnMode(GKnob.CTRL_HORIZONTAL);
  Clipping.setSensitivity(1);
  Clipping.setShowArcOnly(false);
  Clipping.setOverArcOnly(false);
  Clipping.setIncludeOverBezel(true);
  Clipping.setShowTrack(true);
  Clipping.setLimits(0.5, 0.0, 1.0);
  Clipping.setShowTicks(true);
  Clipping.setOpaque(false);
  Clipping.addEventHandler(this, "knobClipp_event");
  Reverb = new GKnob(this, 120, 40, 60, 70, 0.8);
  Reverb.setTurnRange(110, 70);
  Reverb.setTurnMode(GKnob.CTRL_HORIZONTAL);
  Reverb.setSensitivity(1);
  Reverb.setShowArcOnly(false);
  Reverb.setOverArcOnly(false);
  Reverb.setIncludeOverBezel(true);
  Reverb.setShowTrack(true);
  Reverb.setLimits(0.5, 0.0, 1.0);
  Reverb.setShowTicks(true);
  Reverb.setOpaque(false);
  Reverb.addEventHandler(this, "knobRev_event");
  label_volume_knob = new GLabel(this, 2, 20, 50, 20);
  label_volume_knob.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label_volume_knob.setText("Volume");
  label_volume_knob.setOpaque(false);
  label_clipping_knob = new GLabel(this, 65, 20, 50, 20);
  label_clipping_knob.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label_clipping_knob.setText("Clipping");
  label_clipping_knob.setOpaque(false);
  label_reverb_knob = new GLabel(this, 126, 20, 50, 20);
  label_reverb_knob.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  label_reverb_knob.setText("Reverb");
  label_reverb_knob.setOpaque(false);
  Knob_Panel.addControl(Volume_knob);
  Knob_Panel.addControl(Clipping);
  Knob_Panel.addControl(Reverb);
  Knob_Panel.addControl(label_volume_knob);
  Knob_Panel.addControl(label_clipping_knob);
  Knob_Panel.addControl(label_reverb_knob);
  Mapping_panel = new GPanel(this, 10, 60, 451, 140, "Input events mapping");
  Mapping_panel.setCollapsible(false);
  Mapping_panel.setDraggable(false);
  Mapping_panel.setText("Input events mapping");
  Mapping_panel.setOpaque(true);
  Mapping_panel.addEventHandler(this, "panel1_Click1");
  panel_X_position = new GPanel(this, 2, 25, 111, 110, "X-position");
  panel_X_position.setCollapsible(false);
  panel_X_position.setDraggable(false);
  panel_X_position.setText("X-position");
  panel_X_position.setOpaque(true);
  panel_X_position.addEventHandler(this, "panel2_Click1");
  X_pos_group = new GToggleGroup();
  Panning_X_position = new GOption(this, 0, 25, 80, 20);
  Panning_X_position.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  Panning_X_position.setText("Panning");
  Panning_X_position.setOpaque(false);
  Panning_X_position.addEventHandler(this, "Panning_X_position_event");
  Mix_X_position = new GOption(this, 0, 45, 80, 20);
  Mix_X_position.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  Mix_X_position.setText("Mix");
  Mix_X_position.setOpaque(false);
  Mix_X_position.addEventHandler(this, "Mix_X_position_event");
  Room_X_position = new GOption(this, 0, 65, 80, 20);
  Room_X_position.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  Room_X_position.setText("Room");
  Room_X_position.setOpaque(false);
  Room_X_position.addEventHandler(this, "Room_X_position_event");
  Vol_X_position = new GOption(this, 0, 85, 80, 20);
  Vol_X_position.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  Vol_X_position.setText("Volume");
  Vol_X_position.setOpaque(false);
  Vol_X_position.addEventHandler(this, "Vol_X_position_event");
  X_pos_group.addControl(Panning_X_position);
  Panning_X_position.setSelected(true);
  panel_X_position.addControl(Panning_X_position);
  X_pos_group.addControl(Mix_X_position);
  panel_X_position.addControl(Mix_X_position);
  X_pos_group.addControl(Room_X_position);
  panel_X_position.addControl(Room_X_position);
  X_pos_group.addControl(Vol_X_position);
  panel_X_position.addControl(Vol_X_position);
  panel_Y_position = new GPanel(this, 114, 25, 111, 110, "Y-position");
  panel_Y_position.setCollapsible(false);
  panel_Y_position.setDraggable(false);
  panel_Y_position.setText("Y-position");
  panel_Y_position.setOpaque(true);
  panel_Y_position.addEventHandler(this, "panel3_Click1");
  Y_pos_group = new GToggleGroup();
  Panning_Y_position = new GOption(this, 0, 25, 80, 20);
  Panning_Y_position.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  Panning_Y_position.setText("Panning");
  Panning_Y_position.setOpaque(false);
  Panning_Y_position.addEventHandler(this, "Panning_Y_position_event");
  Mix_Y_position = new GOption(this, 0, 45, 80, 20);
  Mix_Y_position.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  Mix_Y_position.setText("Mix");
  Mix_Y_position.setOpaque(false);
  Mix_Y_position.addEventHandler(this, "Mix_Y_position_event");
  Room_Y_position = new GOption(this, 0, 65, 80, 20);
  Room_Y_position.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  Room_Y_position.setText("Room");
  Room_Y_position.setOpaque(false);
  Room_Y_position.addEventHandler(this, "Room_Y_position_event");
  Volume_Y_position = new GOption(this, 0, 85, 80, 20);
  Volume_Y_position.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  Volume_Y_position.setText("Volume");
  Volume_Y_position.setOpaque(false);
  Volume_Y_position.addEventHandler(this, "Volume_Y_position_event");
  Y_pos_group.addControl(Panning_Y_position);
  panel_Y_position.addControl(Panning_Y_position);
  Y_pos_group.addControl(Mix_Y_position);
  Mix_Y_position.setSelected(true);
  panel_Y_position.addControl(Mix_Y_position);
  Y_pos_group.addControl(Room_Y_position);
  panel_Y_position.addControl(Room_Y_position);
  Y_pos_group.addControl(Volume_Y_position);
  panel_Y_position.addControl(Volume_Y_position);
  panel_Z_position = new GPanel(this, 226, 25, 111, 110, "Z-position");
  panel_Z_position.setCollapsible(false);
  panel_Z_position.setDraggable(false);
  panel_Z_position.setText("Z-position");
  panel_Z_position.setOpaque(true);
  panel_Z_position.addEventHandler(this, "panel4_Click1");
  Z_speed_group = new GToggleGroup();
  Pitch_shift_Z_pos = new GOption(this, 0, 25, 80, 20);
  Pitch_shift_Z_pos.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  Pitch_shift_Z_pos.setText("Pitch shift");
  Pitch_shift_Z_pos.setOpaque(false);
  Pitch_shift_Z_pos.addEventHandler(this, "Pitch_shift_Z_pos_event");
  Rev_Z_speed = new GOption(this, 0, 45, 80, 20);
  Rev_Z_speed.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  Rev_Z_speed.setText("Reverb");
  Rev_Z_speed.setOpaque(false);
  Rev_Z_speed.addEventHandler(this, "Rev_Z_event");
  Clipp_Z_speed = new GOption(this, 0, 65, 80, 20);
  Clipp_Z_speed.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  Clipp_Z_speed.setText("Clipping");
  Clipp_Z_speed.setOpaque(false);
  Clipp_Z_speed.addEventHandler(this, "Clipp_Z_event");
  Other_Z_speed = new GOption(this, 0, 85, 80, 20);
  Other_Z_speed.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  Other_Z_speed.setText("Other");
  Other_Z_speed.setOpaque(false);
  Other_Z_speed.addEventHandler(this, "Other_Z_event");
  Z_speed_group.addControl(Pitch_shift_Z_pos);
  Pitch_shift_Z_pos.setSelected(true);
  panel_Z_position.addControl(Pitch_shift_Z_pos);
  Z_speed_group.addControl(Rev_Z_speed);
  panel_Z_position.addControl(Rev_Z_speed);
  Z_speed_group.addControl(Clipp_Z_speed);
  panel_Z_position.addControl(Clipp_Z_speed);
  Z_speed_group.addControl(Other_Z_speed);
  panel_Z_position.addControl(Other_Z_speed);
  panel_HR = new GPanel(this, 338, 25, 111, 110, "Heart-Rate");
  panel_HR.setCollapsible(false);
  panel_HR.setDraggable(false);
  panel_HR.setText("Heart-Rate");
  panel_HR.setOpaque(true);
  panel_HR.addEventHandler(this, "panel5_Click1");
  group_HR = new GToggleGroup();
  Filter_HR = new GOption(this, 0, 25, 107, 20);
  Filter_HR.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  Filter_HR.setText("Filter (low pass?)");
  Filter_HR.setOpaque(false);
  Filter_HR.addEventHandler(this, "Filter_HR_event");
  Phaser_HR = new GOption(this, 0, 45, 107, 20);
  Phaser_HR.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  Phaser_HR.setText("Phaser's period");
  Phaser_HR.setOpaque(false);
  Phaser_HR.addEventHandler(this, "Phaser_event");
  Rever_Decay_HR = new GOption(this, 0, 65, 107, 20);
  Rever_Decay_HR.setIconAlign(GAlign.LEFT, GAlign.MIDDLE);
  Rever_Decay_HR.setText("Reverb Decay");
  Rever_Decay_HR.setOpaque(false);
  Rever_Decay_HR.addEventHandler(this, "Rever_Decay_HR_event");
  group_HR.addControl(Filter_HR);
  Filter_HR.setSelected(true);
  panel_HR.addControl(Filter_HR);
  group_HR.addControl(Phaser_HR);
  panel_HR.addControl(Phaser_HR);
  group_HR.addControl(Rever_Decay_HR);
  panel_HR.addControl(Rever_Decay_HR);
  Mapping_panel.addControl(panel_X_position);
  Mapping_panel.addControl(panel_Y_position);
  Mapping_panel.addControl(panel_Z_position);
  Mapping_panel.addControl(panel_HR);
  labelTitle = new GLabel(this, 377, 9, 200, 45);
  labelTitle.setIcon("CENTER", 1, GAlign.EAST, GAlign.RIGHT, GAlign.MIDDLE);
  labelTitle.setTextAlign(GAlign.CENTER, GAlign.MIDDLE);
  labelTitle.setText("Jacob SuperCollier's amazing Plug-In");
  labelTitle.setOpaque(false);
  Slider_Panel = new GPanel(this, 205, 540, 200, 80, "Sliders");
  Slider_Panel.setCollapsible(false);
  Slider_Panel.setDraggable(false);
  Slider_Panel.setText("Sliders");
  Slider_Panel.setOpaque(true);
  Slider_Panel.addEventHandler(this, "panel1_Click2");
  Panning = new GSlider(this, 0, 20, 200, 60, 10.0);
  Panning.setShowValue(true);
  Panning.setLimits(0.0, -1.0, 1.0);
  Panning.setShowTicks(true);
  Panning.setNumberFormat(G4P.DECIMAL, 2);
  Panning.setOpaque(false);
  Panning.addEventHandler(this, "slider_event");
  Slider_Panel.addControl(Panning);
  WF_2_Display_panel = new GPanel(this, 480, 60, 400, 360, "Insert plots here");
  WF_2_Display_panel.setCollapsible(false);
  WF_2_Display_panel.setDraggable(false);
  WF_2_Display_panel.setText("Insert plots here");
  WF_2_Display_panel.setOpaque(true);
  WF_2_Display_panel.addEventHandler(this, "panel1_Click4");
  Credits_text = new GTextArea(this, 760, 570, 165, 80, G4P.SCROLLBARS_NONE);
  Credits_text.setText("Credits : \n CAGNETTA Angelica \n DI LORENZO Giuliano \n MUGNAINI Nicola \n OUALI Ernest");
  Credits_text.setOpaque(false);
  Credits_text.addEventHandler(this, "textarea1_change1");
}

// Variable declarations 
// autogenerated do not edit
GPanel Knob_Panel; 
GKnob Volume_knob; 
GKnob Clipping; 
GKnob Reverb; 
GLabel label_volume_knob; 
GLabel label_clipping_knob; 
GLabel label_reverb_knob; 
GPanel Mapping_panel; 
GPanel panel_X_position; 
GToggleGroup X_pos_group; 
GOption Panning_X_position; 
GOption Mix_X_position; 
GOption Room_X_position; 
GOption Vol_X_position; 
GPanel panel_Y_position; 
GToggleGroup Y_pos_group; 
GOption Panning_Y_position; 
GOption Mix_Y_position; 
GOption Room_Y_position; 
GOption Volume_Y_position; 
GPanel panel_Z_position; 
GToggleGroup Z_speed_group; 
GOption Pitch_shift_Z_pos; 
GOption Rev_Z_speed; 
GOption Clipp_Z_speed; 
GOption Other_Z_speed; 
GPanel panel_HR; 
GToggleGroup group_HR; 
GOption Filter_HR; 
GOption Phaser_HR; 
GOption Rever_Decay_HR; 
GLabel labelTitle; 
GPanel Slider_Panel; 
GSlider Panning; 
GPanel WF_2_Display_panel; 
GTextArea Credits_text; 
