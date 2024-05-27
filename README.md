# Jacob SuperCollier -  COLM Dance Designer

"COLM Dance Designer" is a computer music system that allows a dancer to interact with the sound desgin of a MIDI keyboard.
Through various sensors, the dancer movements can determine how the sound processing elements will behave in real-time.

```mermaid
graph LR
    Dancer --> Sensors
    Sensors -->Arduino
    Arduino -->|Serial communication| Processing
    
    Processing -->|OSC| SuperCollider
    Processing -->|OSC| Juce
    
    MIDI_Input --> SuperCollider
    SuperCollider -->|synth| Juce
    
    Juce --> Speaker

    subgraph Input System
        Dancer
        Arduino
        Sensors
    end
    
    subgraph MIDI System
        Musician --> MIDI_Input
    end

    subgraph Modulation System
        SuperCollider
        Juce
    end
    subgraph User Interface
        Processing
    end
```

You may appreciate a demonstration video:

(VIDEO)

## What do you need?

In order to use this system at the best of its potential, you need :
* a MIDI instrument
* an external electronic platform (such as Arduino) and some sensors
* a PC and all you need to connect them all

## Software to use

This system consists of:

 * a sound synthesis module made in SuperCollider

```mermaid
graph LR 
    Sensors --> Synth_Properties
    
    subgraph Synth_Properties
        note
        vel
        pan 
        mix
        volume
    end

Synth_Properties --> SynthDef"\synth"

SynthDef"\synth" --> Dictionary"notes"

SynthDef"\synth" --> VAC

SynthDef"\synth" -->|effectBus| SynthDef"\FX"

SynthDef"\FX" --> VAC

Sensors --> FX_Properties 

FX_Properties --> SynthDef"\FX"

subgraph FX_Properties
    room
    pre_delay
    end





    
```

 * a sound effects module made in JUCE
* an external board management module (Arduino IDE) 
 * a GUI module made in Processing 

## Libraries, modules and external dependencies

The SuperCollider code works without any external dependency.

The plugin development has been done by using the JUCE's audio plugin library, in addition to the DSP module and the OSC module.

The Arduino snippet requires two libraries in order to work :

* the Arduino-MMA7361 library which offers specific functionalities for the Triple Axis Accelerometer from DFRobot, that we found on GitHub (see the report for more details) 
* the built-in Serial communication library in order to send messages that will be read by Processing
* Arduino AVR Board and Arduino  megaAVR Board which allow to use WI-Fi Rev2 board

The Processing code requires the oscP5 and the netP5 libraries in order to setup the OSC communication.
Its graphic interface has been developed through the G4P library that also needs to be downloaded (both Tool and Library).

A virtual audio cable is necessary to connect SuperCollider and the standalone plugin.
In this system, the "Hi-Fi Cable" by VB-Audio has been used and it needs to be installed and setup accordingly to your PC. The user must be careful with the selected sampling rate of both Juce and the Virtual Audio Cable which must be identical.

See the report for more details.

## Setting everything up

Finally, in order to use every components in this repository, you need to follow these steps in the given order:

* Open the Arduino script and upload it on the board
* Check that the serial monitor is receiving values correctly
* Close the serial monitor display
* Open the sketch code in Processing and run it
* Check that you can see the GUI (PHOTO), and that the OSC messages are sent, you can check the Processing's console
* Open the SuperCollider script, boot the server and run every block
* (Optional) Open the backing track code, that offers you a 1-minute track to play along with
* Open the standalone plugin and setup "Hi-Fi Cable Output" as input source

## Project's limitations

As of now, the Juce code listens to the Processing's OSC messages but no modifications occurs, only SuperCollider is effectively responsive to the dancer.
Moreover, the accelerometer we used for this project is actually closer to a gyroscope. The dancer's movements are not interpreted as we'd like them to be. Indeed, the sensor's inclination is the prevalent modifier.

The heart rate we used also seems to read BPM values lower than 75. Indeed, after several trials, the detected value never exceeded 75 BPM even when the dancer was cardiacally stressed.

## Future improvements

As said before, the sensors are the first thing we'd like to fix. Acquiring better sensors might solve a lot of the issues we faced. One might also want to keep the sensors and change how the measured values influence the signal processing.

Besides, the JUCE script also needs to modify the modulations's parameters as indicated in the OSC messages.
We tried to fix this problem by means of  `juce::Value` ,  `.referTo()` and  `.getValueObject()`.  However we could not fix it in time before the deadline.

Moreover, it would be interesting to find a better packaging for the arduino board and its sensors to reduc the uncomfortableness of the actual setup. One might also want to setup Wi-Fi communication to get rid of cables. 

## Credentials

This computer system is the result of the project work for "Computer Music - Languages and Systems" exam at Politecnico di Milano, made by "Jacob SuperCollier" team.
"Jacob SuperCollier" is:

* Cagnetta Angelica
* Di Lorenzo Giuliano
* Mugnaini Nicola
* Ouali Ernest

We thanks Sgauldino Serena for the dancing performance contribution for the video demo.
