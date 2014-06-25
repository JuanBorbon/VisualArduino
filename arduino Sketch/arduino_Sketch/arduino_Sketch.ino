void setup() {
  Serial.begin(9600);
}

void loop() {
  
  int sensors[6];

  if (Serial.available()>0) {
    
    Serial.read(); //discard first byte
  
    for (int i = 0; i < 6; i++) {
      sensors[i] = analogRead(i);
       Serial.print(sensors[i]);
       if (i <5) {
          Serial.print(",");
       }
    }
    Serial.println();
  }  
}

