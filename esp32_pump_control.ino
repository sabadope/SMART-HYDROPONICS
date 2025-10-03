#include <WiFi.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include <time.h>

// ================== WiFi CONFIG ==================
const char* WIFI_SSID     = "A.Pagtakhan";
const char* WIFI_PASSWORD = "AP.101010";

// ================== SUPABASE CONFIG ==================
const char* SUPABASE_URL = "https://ihscuhuksaixfjmmttqa.supabase.co/rest/v1/pump_sensors";
const char* SUPABASE_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imloc2N1aHVrc2FpeGZqbW10dHFhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc1MTU0NTAsImV4cCI6MjA3MzA5MTQ1MH0.6eKAuH33Rn4c4RsIy-5XXYrArhdy4f0suJ6S82Q7cW8"; // 🔒 keep safe

// ================== SENSOR + RELAY CONFIG ==================
#define SENSOR_PIN 34        // Water level sensor (digital input)
#define RELAY_PIN  5         // Relay pin
#define RELAY_ACTIVE_LOW 0   // 0 = Active HIGH relay

// ================== TIME CONFIG ==================
const char* ntpServer          = "pool.ntp.org";
const long gmtOffset_sec       = 8 * 3600;  // UTC+8
const int daylightOffset_sec   = 0;

// ================== VARIABLES ==================
bool lastWaterStatus = false;   // true = liquid detected, false = no liquid
bool lastPumpStatus  = false;
unsigned long lastCheck = 0;
const unsigned long interval = 1000; // check every second

String lastInsertedTime = "";   // track our last insert timestamp

// ================== HELPERS ==================
void connectWiFi() {
    if (WiFi.status() == WL_CONNECTED) return;

    Serial.print("🌐 Connecting to WiFi");
    WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

    unsigned long start = millis();
    while (WiFi.status() != WL_CONNECTED && millis() - start < 15000) {
        delay(500);
        Serial.print(".");
    }

    if (WiFi.status() == WL_CONNECTED) {
        Serial.println("\n✅ WiFi Connected! IP: " + WiFi.localIP().toString());
    } else {
        Serial.println("\n❌ WiFi Failed. Retrying later...");
    }
}

String getTimeStamp() {
    struct tm timeinfo;
    if (!getLocalTime(&timeinfo)) return "";

    char buffer[30];
    strftime(buffer, sizeof(buffer), "%Y-%m-%dT%H:%M:%SZ", &timeinfo);
    return String(buffer);
}

void setRelay(bool on) {
    digitalWrite(RELAY_PIN, (RELAY_ACTIVE_LOW ? (on ? LOW : HIGH) : (on ? HIGH : LOW)));
    Serial.println(on ? "💧 Pump: ON" : "💧 Pump: OFF");
    lastPumpStatus = on;
}

// ================== DATABASE OPS ==================
bool insertRow(bool waterDetected) {
    if (WiFi.status() != WL_CONNECTED) {
        connectWiFi();
        if (WiFi.status() != WL_CONNECTED) return false;
    }

    HTTPClient http;
    http.begin(SUPABASE_URL);
    http.addHeader("Content-Type", "application/json");
    http.addHeader("apikey", SUPABASE_KEY);
    http.addHeader("Authorization", String("Bearer ") + SUPABASE_KEY);
    http.addHeader("Prefer", "return=representation");

    StaticJsonDocument<300> doc;
    doc["waterlevel_status"] = waterDetected;
    doc["pump_status"]       = lastPumpStatus;
    doc["date_time"]         = getTimeStamp();

    lastInsertedTime = doc["date_time"].as<String>(); // save our own insert time

    String payload;
    serializeJson(doc, payload);
    Serial.println("📤 Sending Payload: " + payload);

    int code = http.POST(payload);
    String response = http.getString();
    http.end();

    if (code >= 200 && code < 300) {
        Serial.println("✅ Row inserted");
        return true;
    } else {
        Serial.printf("❌ Insert error: %d\n", code);
        Serial.println("🔎 Response: " + response);
        return false;
    }
}

// ================== STATE LOGGER ==================
void logStateIfChanged(bool newWaterStatus, bool newPumpStatus) {
    if (newWaterStatus != lastWaterStatus || newPumpStatus != lastPumpStatus) {
        lastWaterStatus = newWaterStatus;
        lastPumpStatus  = newPumpStatus;
        insertRow(lastWaterStatus);
    }
}

// ================== FETCH LATEST COMMAND ==================
bool fetchLatestCommand() {
    if (WiFi.status() != WL_CONNECTED) {
        connectWiFi();
        if (WiFi.status() != WL_CONNECTED) return false;
    }

    HTTPClient http;
    String url = String(SUPABASE_URL) + "?order=date_time.desc&limit=1";
    http.begin(url);
    http.addHeader("apikey", SUPABASE_KEY);
    http.addHeader("Authorization", String("Bearer ") + SUPABASE_KEY);

    int code = http.GET();
    String response = http.getString();
    http.end();

    if (code >= 200 && code < 300) {
        Serial.println("📥 Latest row: " + response);

        StaticJsonDocument<512> doc;
        DeserializationError err = deserializeJson(doc, response);
        if (err) {
            Serial.println("❌ JSON parse failed");
            return false;
        }

        bool remotePump = doc[0]["pump_status"] | false;

        // ✅ Check if pump_status changed (instead of timestamp)
        if (remotePump != lastPumpStatus) {
            Serial.println("🔄 Pump status changed! Updating pump...");
            Serial.print("🎮 Remote command: ");
            Serial.println(remotePump ? "TURN PUMP ON" : "TURN PUMP OFF");

            setRelay(remotePump);
            // Note: We don't insert a new row here since Flutter updates existing records
        }

        return true;
    } else {
        Serial.printf("❌ Fetch error: %d\n", code);
        Serial.println("🔎 Response: " + response);
        return false;
    }
}

// ================== SETUP ==================
void setup() {
    Serial.begin(115200);
    delay(100);

    pinMode(SENSOR_PIN, INPUT);
    pinMode(RELAY_PIN, OUTPUT);

    // Force relay OFF at boot
    setRelay(false);

    connectWiFi();
    configTime(gmtOffset_sec, daylightOffset_sec, ntpServer);
    delay(2000);

    // Insert initial state
    lastWaterStatus = (digitalRead(SENSOR_PIN) == HIGH);
    logStateIfChanged(lastWaterStatus, lastPumpStatus);

    Serial.println("📢 Type 'On' to turn pump ON, 'Off' to turn pump OFF.");
}

// ================== LOOP ==================
void loop() {
    unsigned long now = millis();
    if (now - lastCheck >= interval) {
        lastCheck = now;

        // 1️⃣ Check water level sensor
        bool waterDetected = (digitalRead(SENSOR_PIN) == HIGH);

        if (lastPumpStatus && !waterDetected) {
            Serial.println("⛔ No liquid detected! Pump shutting OFF automatically.");
            setRelay(false);
            insertRow(false); // 🔥 Insert forced OFF event
        }

        // Log state only if changed
        logStateIfChanged(waterDetected, lastPumpStatus);

        // 2️⃣ Fetch remote pump command
        fetchLatestCommand();
    }

    // 3️⃣ Check for user input (manual via Serial Monitor)
    if (Serial.available() > 0) {
        String command = Serial.readStringUntil('\n');
        command.trim();

        if (command.equalsIgnoreCase("On")) {
            if (!lastWaterStatus) {
                Serial.println("⛔ Cannot turn pump ON: No liquid detected!");
            } else if (!lastPumpStatus) {
                Serial.println("🖥 Manual Command: Pump ON");
                setRelay(true);
                insertRow(lastWaterStatus);  // 🔥 Insert new row immediately
            }
        }
        else if (command.equalsIgnoreCase("Off")) {
            if (lastPumpStatus) {
                Serial.println("🖥 Manual Command: Pump OFF");
                setRelay(false);
                insertRow(lastWaterStatus);  // 🔥 Insert new row immediately
            }
        }
        else {
            Serial.println("⚠️ Invalid command. Use 'On' or 'Off'");
        }
    }
}