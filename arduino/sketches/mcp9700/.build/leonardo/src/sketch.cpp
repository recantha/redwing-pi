#include <Arduino.h>
void setup();
void loop();
#line 1 "src/sketch.ino"
// read mcp9700 temperature sensor

float temp;
float calibration = -0.6;
int tempPin = 0;


void setup()
{
	Serial.begin(9600);
	pinMode(tempPin, INPUT);
}

void loop()
{
	temp = analogRead(tempPin) * 5 / 1024.0;
	temp = temp + calibration;
	temp = temp / 0.01;
	Serial.println (temp);
	delay(500);
}
