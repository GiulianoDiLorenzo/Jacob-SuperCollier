#include<math.h>
//#include<stdio.h>
#include<Arduino.h>
#include "AcceleroMMA7361.h"
#include <OSCMessage.h>
#include <OSCBoards.h>

// Renaming Pins
#define A_HR A1
#define A_X A3
#define A_Y A4
#define A_Z A5

// Variables to store the sensors' signals
float sensorValue; 
float accX;
float accY;
float accZ;
float timeStep = 200; //[ms]


// Variables to hold the zero-g voltage after calibration, see calibratesensor()
float zeroGVoltageX = 0.0;
float zeroGVoltageY = 0.0;
float zeroGVoltageZ = 0.0;


// Calibration values for 5V supply and 1.5g sensitivity setting, see calibratesensor()
const float zeroGVoltage = 2.5; // Zero-g voltage at 2.5V (assuming 5V supply)
const float sensitivity = 0.8;  // Sensitivity (V/g) for 1.5g setting

//Instantiating a object of the class accelerometer
AcceleroMMA7361 acc;

void setup() {
  Serial.begin(9600);   // serial transmission bitrate

  //Setting pins as Inputs only
  pinMode(A_HR, INPUT);
  pinMode(A_X, INPUT);
  pinMode(A_Y, INPUT);
  pinMode(A_Z, INPUT);

  //Calibrating the sensor
  acc.begin(13, 12, 11, 10, A_X, A_Y, A_Z);
  acc.setARefVoltage(5);  // Set the reference voltage to 3.3V
  acc.setSensitivity(HIGH);  // Set sensitivity to 1.5g (LOW for 6g)
  calibrateSensor();
}

void loop() {

  // Read the analog values
  accX = analogRead(A_X);
  accY = analogRead(A_Y);
  accZ = analogRead(A_Z);
  sensorValue = analogRead(A1);

  // Convert analog values to voltage
  accX = (accX * 5.0) / 1023.0;
  accY = (accY * 5.0) / 1023.0;
  accZ = (accZ * 5.0) / 1023.0;

  // Calculate acceleration in g
  accX = (accX - zeroGVoltageX) / sensitivity;
  accY = (accY - zeroGVoltageY) / sensitivity;
  accZ = (accZ - zeroGVoltageZ) / sensitivity;

  // Calculate acceleration in m/s²
  accX *= 9.81;
  accY *= 9.81;
  accZ *= 9.81;

  // Print the results on the Serial port for Processing
  Serial.print(String(accX));
  Serial.print(",");
  Serial.print(String(accY));
  Serial.print(",");
  Serial.print(String(accZ));
  Serial.print(",");
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

  //Printing the calibration result
  /*
  Serial.print("Calibrated zero-g voltage for X: ");
  Serial.println(zeroGVoltageX);
  Serial.print("Calibrated zero-g voltage for Y: ");
  Serial.println(zeroGVoltageY);
  Serial.print("Calibrated zero-g voltage for Z: ");
  Serial.println(zeroGVoltageZ);
  */
} 