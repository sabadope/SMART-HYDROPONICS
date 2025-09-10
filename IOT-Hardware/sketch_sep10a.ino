#include <SoftwareSerial.h>

const int BT_RX = 10; // Arduino reads here (from HC-05 TXD)
const int BT_TX = 11; // Arduino writes here (to HC-05 RXD via divider)
SoftwareSerial BT(BT_RX, BT_TX);

const int LED_PIN = 8;

void setup() {
  pinMode(LED_PIN, OUTPUT);
  digitalWrite(LED_PIN, LOW);
  Serial.begin(9600);
  BT.begin(9600); // HC-05 default baud
}

void loop() {
  if (BT.available()) {
    String cmd = BT.readStringUntil('\n');
    cmd.trim();
    if (cmd.equalsIgnoreCase("ON") || cmd == "1") {
      digitalWrite(LED_PIN, HIGH);
      BT.println("LED=ON");
    } else if (cmd.equalsIgnoreCase("OFF") || cmd == "0") {
      digitalWrite(LED_PIN, LOW);
      BT.println("LED=OFF");
    } else if (cmd.equalsIgnoreCase("STATUS")) {
      BT.print("LED=");
      BT.println(digitalRead(LED_PIN) ? "ON" : "OFF");
    } else {
      BT.println("ERR:UNKNOWN_CMD");
    }
  }

  // Optional heartbeat every 3s
  static unsigned long last = 0;
  if (millis() - last > 3000) {
    last = millis();
    BT.print("HB:");
    BT.println(millis() / 1000);
  }
}
