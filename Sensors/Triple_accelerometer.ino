#include<math.h>
#include<stdio.h>

#define A_H A1
#define A_X A3
#define A_Y A4
#define A_Z A5

void setup() {
  pinMode(A_H, INPUT);
  pinMode(A_X, INPUT);
  pinMode(A_Y, INPUT);
  pinMode(A_Z, INPUT);

  Serial.begin(9600);   // serial transmission bitrate
}

void loop() {
  Serial.println("***********************");

  // buffers of 10 values from each sensor
  int x[10], y[10], z[10];
  
  // min and max values of each buffer
  int min_x= 0;
  int max_x = 0;
  int min_y = 0;
  int max_y = 0;
  int min_z = 0;
  int max_z = 0;

  // gathering x, y and z values in the 10-entries arrays
  for (int i=0; i<10; i++) {
    x[i] = analogRead(A_X);
    if (min_x > x[i]) {
      min_x = x[i];
    }
    if (max_x < x[i]) {
      max_x = x[i];
    }
    delay(2);

    y[i] = analogRead(A_X);
    if (min_y > y[i]) {
      min_y = y[i];
    }
    if (max_y < y[i]) {
      max_y = y[i];
    }
    delay(2);

    z[i] = analogRead(A_X);
    if (min_z > z[i]) {
      min_z = z[i];
    }
    if (max_z < z[i]) {
      max_z = z[i];
    }
    delay(2);
  }

  // computing the average value
  int avg_x, avg_y, avg_z;

  avg_x = (max_x - min_x) / 2;
  avg_y = (max_y - min_y) / 2;
  avg_z = (max_z - min_z) / 2;

  Serial.print("Average x: ");
  Serial.print(avg_x);
  Serial.print(" Average y: ");
  Serial.print(avg_y);
  Serial.print(" Average z: ");
  Serial.println(avg_z);

  delay(10);

  // computing acceleration
  int acc;
  acc = sqrt(avg_x^2 + avg_y^2 + avg_z^2);
  Serial.print(" Acceleration: ");
  Serial.println(acc);

  // capturing heart rate duty cycle (ms)
  int sensorValue;
  sensorValue = analogRead(A1);

  if (sensorValue) {
    Serial.print(" Heart rate sensor: ");
    Serial.println(sensorValue);
  }
  else {
    Serial.println(" Data not valid!");
  }

  delay(1000);
}
