#include <SoftwareSerial.h>
#include <cactus_io_AM2302.h>
#define AM2302_PIN 7

const int pinPhoto = A0;
int raw = 0;
const int inputPin = 6;
AM2302 dht(AM2302_PIN);
const int ledPin = 13;


SoftwareSerial Bluetooth(9, 8);

void setup() {
  Bluetooth.begin(9600);
  Serial.begin(9600);
  dht.begin();
  pinMode( pinPhoto, INPUT );
  pinMode(inputPin, INPUT);
  pinMode(ledPin, OUTPUT);
}

void loop() {
  int value = digitalRead(inputPin);
  dht.readHumidity();
  dht.readTemperature();
  raw = analogRead(pinPhoto);
  
  if (isnan(dht.humidity) || isnan(dht.temperature_C)) {
    return;
  }

  if (value == HIGH)
  {
    
    digitalWrite(ledPin, HIGH);
    Serial.print("wake");Serial.print(" ");Serial.print(raw); Serial.print(" "); Serial.print(dht.temperature_C); Serial.print(" "); Serial.println(dht.humidity);
    Bluetooth.print("wake"); Bluetooth.print("  "); Bluetooth.print(raw); Bluetooth.print("  "); Bluetooth.print(dht.temperature_C); Bluetooth.print("  "); Bluetooth.print(dht.humidity);Bluetooth.println("  ");
    
  }
  else
  {
//    Serial.print(dht.temperature_C);Serial.print(",");Serial.print(raw); Serial.print(",");Serial.print(dht.humidity);Serial.print(",");Serial.print("sleep");Serial.println();
    Serial.print("sleep");Serial.print(" ");Serial.print(raw); Serial.print(" "); Serial.print(dht.temperature_C); Serial.print(" "); Serial.println(dht.humidity);
    Bluetooth.print("sleep"); Bluetooth.print("  "); Bluetooth.print(raw); Bluetooth.print("  "); Bluetooth.print(dht.temperature_C); Bluetooth.print("  "); Bluetooth.print(dht.humidity);Bluetooth.println("  ");
    digitalWrite(ledPin, LOW);
  }

  delay(5*1500);
}
