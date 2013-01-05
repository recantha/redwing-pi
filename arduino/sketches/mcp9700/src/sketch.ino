// read mcp9700 temperature sensor

float temp;
float calibration = -55;
int tempPin = 0;

int redPin = 10;

void setup()
{
	Serial.begin(9600);
	pinMode(tempPin, INPUT);
	pinMode(redPin, OUTPUT);
}

void loop()
{
	temp = analogRead(tempPin) * 5 / 1024.0;
	temp = temp / 0.01;
	temp = temp + calibration;

	digitalWrite(redPin, HIGH);

	Serial.print("Temp:");
	Serial.print (temp);
	Serial.println(" C");
	delay(200);

	digitalWrite(redPin, LOW);
	delay(200);
}
