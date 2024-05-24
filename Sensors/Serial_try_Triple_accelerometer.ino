#include<math.h>
//#include<stdio.h>
#include<Arduino.h>
#include "src/AcceleroMMA7361/AcceleroMMA7361.h"
#include <OSCMessage.h>
#include <OSCBoards.h>

/*
#ifdef BOARD_HAS_USB_SERIAL
#include <SLIPEncodedUSBSerial.h>
SLIPEncodedUSBSerial SLIPSerial( thisBoardsSerialUSB );
#else
#include <SLIPEncodedSerial.h>
 SLIPEncodedSerial SLIPSerial(Serial); // Change to Serial1 or Serial2 etc. for boards with multiple serial ports that don’t have Serial
#endif
*/

#define A_HR A1
#define A_X A3
#define A_Y A4
#define A_Z A5

float sensorValue; 
float accX;
float accY;
float accZ;

AcceleroMMA7361 acc;

void setup() {
  Serial.begin(9600);   // serial transmission bitrate
  pinMode(A_HR, INPUT);
  pinMode(A_X, INPUT);
  pinMode(A_Y, INPUT);
  pinMode(A_Z, INPUT);

  acc.begin(13, 12, 11, 10, A_X, A_Y, A_Z);
  acc.setARefVoltage(5);  // Set the reference voltage to 3.3V
  acc.setSensitivity(HIGH);  // Set sensitivity to 1.5g (LOW for 6g)
  acc.calibrate();
}

void loop() {
  /*
  Serial.println("***********************");
  Serial.print("LIBRARY (raw): ");
  Serial.print(acc.getXRaw());
  Serial.print(", ");
  Serial.print(acc.getYRaw());
  Serial.print(", ");
  Serial.println(acc.getZRaw());
  */
 
  //Serial.print("LIBRARY (volt): ");
  accX = (float) acc.getXVolt()/1000; 
  Serial.print("AccX: ");
  Serial.println(accX);

  accY = (float) acc.getYVolt()/1000; 
  Serial.print("AccY: ");
  Serial.println(accY);


  accZ = (float) acc.getXVolt()/1000; 
  Serial.print("AccZ: ");
  Serial.println(accZ);

  sensorValue = analogRead(A1);
  Serial.print("HR: ");
  Serial.println(sensorValue);

/*
  Serial.print("LIBRARY (degrees): ");
  Serial.print(acc.getXAccel());
  Serial.print(", ");
  Serial.print(acc.getYAccel());
  Serial.print(", ");
  Serial.println(acc.getZAccel());
*/
  delay(500);
}