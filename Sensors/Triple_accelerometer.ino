#include<math.h>
//#include<stdio.h>
#include<Arduino.h>
#include "AcceleroMMA7361.h"

#define A_X A3
#define A_Y A4
#define A_Z A5

AcceleroMMA7361 acc;

void setup() {
  pinMode(A_X, INPUT);
  pinMode(A_Y, INPUT);
  pinMode(A_Z, INPUT);

  Serial.begin(9600);   // serial transmission bitrate

  acc.begin(13, 12, 11, 10, A_X, A_Y, A_Z);
  acc.setARefVoltage(5);  // Set the reference voltage to 3.3V
  acc.setSensitivity(HIGH);  // Set sensitivity to 1.5g (LOW for 6g)
  acc.calibrate();
}

void loop() {
  Serial.println("***********************");
  Serial.print("LIBRARY (raw): ");
  Serial.print(acc.getXRaw());
  Serial.print(", ");
  Serial.print(acc.getYRaw());
  Serial.print(", ");
  Serial.println(acc.getZRaw());
 
  Serial.print("LIBRARY (volt): ");
  Serial.print((float) acc.getXVolt()/1000);
  Serial.print(", ");
  Serial.print((float) acc.getYVolt()/1000);
  Serial.print(", ");
  Serial.println((float) acc.getZVolt()/1000);

  Serial.print("LIBRARY (degrees): ");
  Serial.print(acc.getXAccel());
  Serial.print(", ");
  Serial.print(acc.getYAccel());
  Serial.print(", ");
  Serial.println(acc.getZAccel());

  delay(1000);
}
