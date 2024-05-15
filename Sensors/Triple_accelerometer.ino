#include<math.h>
#include<stdio.h>

#define A_H A1
#define A_X A3
#define A_Y A4
#define A_Z A5

// ACCELEROMETER
float x, y, z;
float sens = 1.5;
int supply = 5;   // 5V voltage supply
float voltage_1g = supply/sens;    // voltage value for 1g
int adc_max = 1023;   // adc value for maximum voltage (5V)
int adc_1g = adc_max*(voltage_1g/supply);

void setup() {
  pinMode(A_H, INPUT);
  pinMode(A_X, INPUT);
  pinMode(A_Y, INPUT);
  pinMode(A_Z, INPUT);

  Serial.begin(9600);   // serial transmission bitrate
}

void loop() {
  Serial.println("***********************");

  Serial.print("Raw (accelerometer): ");
  Serial.print(analogRead(A_X));
  Serial.print(", ");
  Serial.print(analogRead(A_Y));
  Serial.print(", ");
  Serial.println(analogRead(A_Z));

  x = (analogRead(A_X) * (adc_1g / adc_max)/9.81);
  delay(2);
  y = (analogRead(A_Y) * (adc_1g / adc_max)/9.81);
  delay(2);
  z = (analogRead(A_Z) * (adc_1g / adc_max)/9.81);
  delay(2);

  Serial.print("Acceleration (m/s^2): ");
  Serial.print(x);
  Serial.print(", ");
  Serial.print(y);
  Serial.print(", ");
  Serial.println(z);

  // capturing heart rate duty cycle (ms)
  int sensorValue;
  sensorValue = analogRead(A1);

  if (sensorValue) {
    Serial.print("Heart rate sensor: ");
    Serial.println(sensorValue);
  }
  else {
    Serial.println("Data not valid!");
  }

  delay(1000);
}
