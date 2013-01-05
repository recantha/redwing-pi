#include <wiringPi.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

int main(void) {
	int greenLedPin = 5;

	printf ("Initialised\n");

	if (wiringPiSetup() == -1)
		exit(1);

	pinMode(greenLedPin, OUTPUT);


	for (;;) {
		digitalWrite(greenLedPin, 1);
		printf ("On\n");
		delay(200);
		digitalWrite(greenLedPin, 0);
		printf ("Off\n");
		delay(200);
	}

	return 0;
}
