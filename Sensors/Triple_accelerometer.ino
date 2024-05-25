#include<math.h>
//#include<stdio.h>
#include<Arduino.h>
#include "AcceleroMMA7361.h"
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
float timeStep = 200; //[ms]


// Variables to hold the zero-g voltage after calibration
float zeroGVoltageX = 0.0;
float zeroGVoltageY = 0.0;
float zeroGVoltageZ = 0.0;


// Calibration values for 5V supply and 1.5g sensitivity setting
const float zeroGVoltage = 2.5; // Zero-g voltage at 2.5V (assuming 5V supply)
const float sensitivity = 0.8;  // Sensitivity (V/g) for 1.5g setting



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
  //acc.calibrate();
  calibrateSensor();
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
 /*
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
  */
  

/*
  Serial.print("LIBRARY (degrees): ");
  Serial.print(acc.getXAccel());
  Serial.print(", ");
  Serial.print(acc.getYAccel());
  Serial.print(", ");
  Serial.println(acc.getZAccel());
*/

  // Read the analog values
  int xAnalog = analogRead(A_X);
  int yAnalog = analogRead(A_Y);
  int zAnalog = analogRead(A_Z);

  // Convert analog values to voltage
  float xVoltage = (xAnalog * 5.0) / 1023.0;
  float yVoltage = (yAnalog * 5.0) / 1023.0;
  float zVoltage = (zAnalog * 5.0) / 1023.0;

  // Calculate acceleration in g
  float xAcceleration = (xVoltage - zeroGVoltageX) / sensitivity;
  float yAcceleration = (yVoltage - zeroGVoltageY) / sensitivity;
  float zAcceleration = (zVoltage - zeroGVoltageZ) / sensitivity;

  // Calculate acceleration in m/s²
  xAcceleration *= 9.81;
  yAcceleration *= 9.81;
  zAcceleration *= 9.81;

  // Print the results
  /*
  Serial.print("X acceleration : " + String(xAcceleration) + " m/s²");
  Serial.print("Y acceleration : " + String(yAcceleration) + " m/s²");
  Serial.print("Z acceleration : " + String(zAcceleration) + " m/s²");
  Serial.println();
  */

  Serial.print(String(xAcceleration));
  Serial.print(",");
  Serial.print(String(yAcceleration));
  Serial.print(",");
  Serial.print(String(zAcceleration));
  Serial.print(",");

  sensorValue = analogRead(A1);
  Serial.print(sensorValue);
  Serial.println(",");

  delay(timeStep);
}


void calibrateSensor() {
  const int numReadings = 100; // Number of readings for calibration
  float xTotal = 0;
  float yTotal = 0;
  float zTotal = 0;

  // Take multiple readings to average out the zero-g voltage
  for (int i = 0; i < numReadings; i++) {
    int xAnalog = analogRead(A_X);
    int yAnalog = analogRead(A_Y);
    int zAnalog = analogRead(A_Z);

    // Convert analog values to voltage
    xTotal += (xAnalog * 5.0) / 1023.0;
    yTotal += (yAnalog * 5.0) / 1023.0;
    zTotal += (zAnalog * 5.0) / 1023.0;

    delay(10); // Small delay between readings
  }

  // Calculate the average zero-g voltage
  zeroGVoltageX = xTotal / numReadings;
  zeroGVoltageY = yTotal / numReadings;
  zeroGVoltageZ = zTotal / numReadings;

  /*
  Serial.print("Calibrated zero-g voltage for X: ");
  Serial.println(zeroGVoltageX);
  Serial.print("Calibrated zero-g voltage for Y: ");
  Serial.println(zeroGVoltageY);
  Serial.print("Calibrated zero-g voltage for Z: ");
  Serial.println(zeroGVoltageZ);
  */
} 