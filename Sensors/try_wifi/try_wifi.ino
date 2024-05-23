#include <SPI.h>
#include <WiFiNINA.h>  // Include the WiFi library

// Replace with your mobile hotspot credentials
char ssid[] = "OSUS PHONE";   // Your hotspot SSID
char pass[] = "ernestouali";  // Your hotspot password

char server[] = "192.168.43.109";  //IPV4 address of Ernest's mobile HOTSPOT
  //This is the local IP adress of the computer on the network

int port = 8080;  // Port number for communication, 80 is default for HTTP, no firewall of privileged access...

WiFiClient client ; //Instantiating a Wifi CLient

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);  // Initialize serial communication

  // Attempt to connect to WiFi network
  Serial.print("Connecting to ");
  Serial.println(ssid);

  int status = WL_IDLE_STATUS;  // WiFi connection status
  while (status != WL_CONNECTED) {
    status = WiFi.begin(ssid, pass);  // Connect to the network
    delay(2000);                      // Wait 10 seconds for connection attempt
  }

  // Once connected, print the IP address
  Serial.println("Connected to WiFi network");
  Serial.print("IP Address: ");
  Serial.println(WiFi.localIP()); //Printing the board's IP address

  printCurrentNet();
  printWifiData();


}


void loop() {
  // put your main code here, to run repeatedly:
  int a = 1;
  int b = 2;
  float c = 3;
  
  // Establish connection with the server
  if (!client.connected()) {
    if (!client.connect(server, port)) {
      Serial.println("Failed to connect to server");
      delay(1000);
      return;
    } else {
      Serial.println("Connection estabished");
    }
  }

  else {
    Serial.println("Already connected bro");
  }
  

  // Construct message
  String message = String(a) + "," + String(b) + "," + String(c);

  // Send message to the server
  client.println(message);
  Serial.println("Message sent to server: " + message);

  // Wait before sending the next message
  delay(1000);

}




void printWifiData() {
  // print your board's IP address:
  IPAddress ip = WiFi.localIP();
  Serial.print("IP Address: ");
  Serial.println(ip);
  Serial.println(ip);

  // print your MAC address:
  byte mac[6];
  WiFi.macAddress(mac);
  Serial.print("MAC address: ");
  printMacAddress(mac);
}



void printCurrentNet() {


  // print the SSID of the network you're attached to:
  Serial.print("SSID: ");
  Serial.println(WiFi.SSID());

  // print the MAC address of the router you're attached to:
  byte bssid[6];
  WiFi.BSSID(bssid);
  Serial.print("BSSID: ");
  printMacAddress(bssid);
  // print the received signal strength:
  long rssi = WiFi.RSSI();
  Serial.print("signal strength (RSSI):");
  Serial.println(rssi);
  // print the encryption type:
  byte encryption = WiFi.encryptionType();
  Serial.print("Encryption Type:");
  Serial.println(encryption, HEX);
  Serial.println();

}


void printMacAddress(byte mac[]) {

  for (int i = 5; i >= 0; i--) {
    if (mac[i] < 16) {
      Serial.print("0");
    }
    Serial.print(mac[i], HEX);
    if (i > 0) {
      Serial.print(":");
    }
  }
  Serial.println();
}