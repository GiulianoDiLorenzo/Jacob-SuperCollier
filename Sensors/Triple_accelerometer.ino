#include<math.h>
#include<stdio.h>
//#include "DFRobot_Heartrate.h"

//#define heartratePin A1
#define A_X 3
#define A_Y 4
#define A_Z 5

// DFRobot_Heartrate heartrate(ANALOG_MODE);

int x, y, z;
uint8_t rateValue;
int sensorValue;

void setup() {
  // put your setup code here, to run once:
  pinMode(A_X,INPUT);
  pinMode(A_Y,INPUT);
  pinMode(A_Z,INPUT);

  Serial.begin(9600);
  // Serial.begin(115200);
}

void loop() {
  // put your main code here, to run repeatedly:
  x = analogRead(A_X);
  y = analogRead(A_Y);
  z = analogRead(A_Z);

  Serial.print(" x: ");
  Serial.print(x);
  Serial.print(" y: ");
  Serial.print(y);
  Serial.print(" z: ");
  Serial.print(z);

  sensorValue = analogRead(A1);
  
  Serial.println(" Heart rate sensor: ");
  Serial.println(sensorValue);

  delay(1000);
}
