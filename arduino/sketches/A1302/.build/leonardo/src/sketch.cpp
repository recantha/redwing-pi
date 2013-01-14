#include <Arduino.h>
void setup();
void measureGauss();
void loop();
#line 1 "src/sketch.ino"
#define HALLPIN 1
#define NOFIELD 505L
#define TOMILLIGAUSS 3756L

int analogReading = 0;

void setup()
{
	Serial.begin(9600);
	pinMode(HALLPIN, INPUT);
}

void measureGauss()
{
	analogReading = analogRead(HALLPIN);
	Serial.println(analogReading);

	long compensated = analogReading - NOFIELD;
	long gauss = compensated * TOMILLIGAUSS / 1000;

	Serial.print("Mag: ");
	Serial.print(gauss);
	Serial.print(" Gauss");

	if (gauss > 0)
		Serial.print(" S");
	else if (gauss < 0)
		Serial.print(" N");

	Serial.println();
}

void loop() {
	delay(1000);
	measureGauss();
}
