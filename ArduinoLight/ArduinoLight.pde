const int cnlPins[3] = {10, 11, 9};

void  setup() {
  Serial.begin(9600);
  for (int i=0; i<3; i++) {
    pinMode(cnlPins[i], OUTPUT); // init pin for channel
  }
}

void loop() {
  byte data;
  while (Serial.available() < 3) { }
  
  for (int i=0; i<3; i++) {
      data = Serial.read();
      analogWrite(cnlPins[i], data);
  }
}
