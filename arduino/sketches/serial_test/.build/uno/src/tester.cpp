#include <Arduino.h>
void dah();
void dit();
void setup();
void loop();
#line 1 "src/tester.ino"
int led =0;

void dah() {
  /* turn on LED for half second, then turn off */
  digitalWrite(led, HIGH);
  delay(500);
  digitalWrite(led, LOW);
  delay(200);
}

void dit() {
  digitalWrite(led, HIGH);
  delay(200);
  digitalWrite(led, LOW);
  delay(200);
}

// the setup routine runs once when you press reset:
void setup() {                
  led = 13;
  pinMode(led, OUTPUT);

  dah();
  dah();
  dah();

  Serial.begin(19200);

  dah();
  dah();
  dah();

  while (!Serial)
  {
    // do nothing
    dit();
  }

  dah();
  dah();
  dah();

  Serial.println("Hello, world");
}

void loop() {
  Serial.println("flash");
  dah();
  Serial.println("finish");
  delay(500);
}


