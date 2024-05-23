#include<math.h>
#include<stdio.h>

#define A_H A1

int sensorValue;

void setup() {
  pinMode(A_H, INPUT);
  Serial.begin(9600);   // serial transmission bitrate
}

void loop() {
  Serial.println("***********************");
  
  sensorValue = analogRead(A1);

  if (sensorValue) {
    Serial.print("Heart rate sensor: ");
    Serial.println(sensorValue);
  }
  else {  // TO BE CHECKED
    Serial.println("Data not valid!");
  }
  
  delay(1000);
}
