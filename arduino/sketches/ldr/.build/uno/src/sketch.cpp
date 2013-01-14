#include <Arduino.h>
void setup(void);
void loop(void);
#line 1 "src/sketch.ino"
/*
Photocell simple testing sketch. 

Connect one end of the photocell to 5V, the other end to Analog 0.
Then connect one end of a 10K resistor from Analog 0 to ground

For more information see www.ladyada.net/learn/sensors/cds.html
Modified by M.A. de Pablo. October 18, 2009.
Thanks to Grumpy_Mike for equations improvement.
*/


int photocellPin0 = 0;     // the cell and 10K pulldown are connected to a0
int photocellReading0;     // the analog reading from the analog resistor divider
float Res0=10.0;              // Resistance in the circuit of sensor 0 (KOhms)
// depending of the Resistance used, you could measure better at dark or at bright conditions.
// you could use a double circuit (using other LDR connected to analog pin 1) to have fun testing the sensors.
// Change the value of Res0 depending of what you use in the circuit

void setup(void) {
  // We'll send debugging information via the Serial monitor
  Serial.begin(9600);   
}


void loop(void) {
  photocellReading0 = analogRead(photocellPin0);   // Read the analogue pin
  float Vout0=photocellReading0*0.0048828125;      // calculate the voltage
  int lux0=500/(Res0*((5-Vout0)/Vout0));           // calculate the Lux
  Serial.print("Luminosidad 0: ");                 // Print the measurement (in Lux units) in the screen
  Serial.print(lux0);
  Serial.print(" Lux\t");
  Serial.print("Voltage: ");                       // Print the calculated voltage returned to pin 0
  Serial.print(Vout0);
  Serial.print(" Volts\t");
  Serial.print("Output: ");
  Serial.print(photocellReading0);               // Print the measured level at pin 0
  Serial.print("Ligth conditions: ");            // Print an approach to ligth conditions
  if (photocellReading0 < 10) {
    Serial.println(" - Dark");
  } else if (photocellReading0 < 200) {
    Serial.println(" - Dim");
  } else if (photocellReading0 < 500) {
    Serial.println(" - Light");
  } else if (photocellReading0 < 800) {
    Serial.println(" - Bright");
  } else {
    Serial.println(" - Very bright");
  }
  delay(1000);
}

