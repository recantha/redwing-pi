#include <Arduino.h>
void setup();
void loop();
#line 1 "src/sketch.ino"
// read mcp9700 temperature sensor

float temp;
float calibration = -55;
int tempPin = 0;

int redPin = 10;
int greenPin = 9;

void setup()
{
	Serial.begin(9600);
	pinMode(tempPin, INPUT);
	pinMode(redPin, OUTPUT);
	pinMode(greenPin, OUTPUT);
}

void loop()
{
	temp = analogRead(tempPin) * 5 / 1024.0;
	temp = temp / 0.01;
	temp = temp + calibration;

	digitalWrite(redPin, HIGH);
	digitalWrite(greenPin, LOW);

	Serial.print("Temp:");
	Serial.print (temp);
	Serial.println(" C");
	delay(200);

	digitalWrite(redPin, LOW);
	digitalWrite(greenPin, HIGH);
	delay(200);
}
