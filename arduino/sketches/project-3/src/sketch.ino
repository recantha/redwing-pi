int minorDelay = 2000;
int changeDelay = 5000;

int redPin = 10;
int amberPin = 9;
int greenPin = 8;

void setup() {
	pinMode(redPin, OUTPUT);
	pinMode(amberPin, OUTPUT);
	pinMode(greenPin, OUTPUT);
	
	digitalWrite(redPin, HIGH);
	digitalWrite(amberPin, HIGH);
	digitalWrite(greenPin, HIGH);
}

void flash(int pin) {
	digitalWrite(pin, HIGH);
	delay(minorDelay/5);
	digitalWrite(pin, LOW);
	delay(minorDelay/5);
}

void loop() {
	Serial.println("Red");
	digitalWrite(redPin, LOW);	
	delay(changeDelay);
	
	Serial.println("Red amber");
	digitalWrite(amberPin, LOW);
	delay(minorDelay);

	Serial.println("Green");
	digitalWrite(greenPin, LOW);
	digitalWrite(redPin, HIGH);
	digitalWrite(amberPin, HIGH);
	delay(changeDelay);
	
	Serial.println("Amber");
	digitalWrite(amberPin, LOW);
	digitalWrite(greenPin, HIGH);
	delay(minorDelay);
	
	for (int i=0;i<5;i++) {
		flash(amberPin);
	}
	digitalWrite(amberPin, HIGH);
	// rinse and repeat
}

