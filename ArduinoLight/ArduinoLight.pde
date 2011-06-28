const int cnlPins[3] = {10, 11, 9};

void  setup() {
  Serial.begin(9600);
  for (int i=0; i<3; i++) {
    pinMode(cnlPins[i], OUTPUT); // init pin for channel
  }
}

void loop() {
  byte data;

//  Wait until we have the start byte)
  while (Serial.available() < 1) { }
 
//  Check we're starting at the right place
  if (Serial.read() == 0x55) {
    //  Wait until we have the start byte)
    while (Serial.available() < 1) { }
    if (Serial.read() == 0xAA) {
      //  Ensure that we have 3 data bytes
      while (Serial.available() < 3) { }
        
      for (int i=0; i<3; i++) {
          data = Serial.read();
          analogWrite(cnlPins[i], data);
      }
    }
  }
}
