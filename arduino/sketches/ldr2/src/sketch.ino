#define LDRPIN 0
int ldrReading = 0;

void setup()
{
	Serial.begin(9600);
	pinMode(LDRPIN, INPUT);
}

void loop()
{
	ldrReading = analogRead(LDRPIN);
	Serial.println(ldrReading);
}
