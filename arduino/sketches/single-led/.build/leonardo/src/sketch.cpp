#include <Arduino.h>
void setup();
void loop();
#line 1 "src/sketch.ino"
int redPin = 10;
//int greenPin = 11;

void setup() {
	pinMode(redPin, OUTPUT);
//	pinMode(greenPin, OUTPUT);
}

void loop() {
	digitalWrite(redPin, HIGH);
//	digitalWrite(greenPin, HIGH);
	Serial.println("Red");
	delay(200);
	
	digitalWrite(redPin, LOW);
//	digitalWrite(greenPin, LOW);
	Serial.println("Red");
	delay(200);
}

