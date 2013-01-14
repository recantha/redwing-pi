#include <Arduino.h>
void setup();
void measureTemperature();
void measureMagnetism();
void measureDistance();
void loop();
#line 1 "src/sketch.ino"
// PiPodCorder main sensor feed

#include "NewPing.h"

// INPUTS
int PIN_TEMPERATURE = 0;
float TEMPERATURE_CONVERTER = 0.01;
float TEMPERATURE_CALIBRATION = -55;
int PIN_HALL = 1;			// A1302 hall-effect sensor
long CONVERSION_HALL = 3756L;		// A1302 conversion factor
long NOFIELD_HALL = 505L;		// 'no field' factor

int PIN_PING_TRIGGER = 8;
int PIN_PING_ECHO = 7;
int PING_MAX_DISTANCE = 400;
NewPing pingSensor(PIN_PING_TRIGGER, PIN_PING_ECHO, PING_MAX_DISTANCE);

// OUTPUTS
int PIN_LEDRED = 10;
int PIN_LEDGREEN = 9;

void setup()
{
	Serial.begin(9600);

	pinMode(PIN_TEMPERATURE, INPUT);
	pinMode(PIN_HALL, INPUT);

	pinMode(PIN_LEDRED, OUTPUT);
	pinMode(PIN_LEDGREEN, OUTPUT);
}

void measureTemperature()
{
	float temp;
	temp = analogRead(PIN_TEMPERATURE) * 5 / 1024.0;
	temp = temp / TEMPERATURE_CONVERTER;
	temp = temp + TEMPERATURE_CALIBRATION;
	Serial.print("Temp:");
	Serial.print(temp);
	Serial.println(" C");
}

void measureMagnetism()
{
	float hallReading = analogRead(PIN_HALL);
	long comp = hallReading - NOFIELD_HALL;
	long gauss = comp * CONVERSION_HALL / 1000;

	Serial.print("Mag:");
	Serial.print(gauss);
	Serial.print(" Gs");

	if (gauss > 0)
		Serial.print(" (S)");
	else
		Serial.print(" (N)");

	Serial.println();
}

void measureDistance()
{
	delay(50);	// min between pings
	unsigned int uS = pingSensor.ping();
	Serial.print("Ping:");
	Serial.print(uS / US_ROUNDTRIP_CM);
	Serial.println("cm");
}

void loop()
{
	digitalWrite(PIN_LEDRED, HIGH);
	digitalWrite(PIN_LEDGREEN, LOW);

	measureTemperature();
	delay(250);
	measureMagnetism();
	delay(250);
	measureDistance();
	delay(250);

	digitalWrite(PIN_LEDRED, LOW);
	digitalWrite(PIN_LEDGREEN, HIGH);
	delay(25);
}
