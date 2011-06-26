byte cnlData[6];
int cnlPins[6] = {3, 5, 6, 9, 10, 11};

void setup() {
  Serial.begin(9600);
  for (int i=0; i<6; i++) {
    cnlData[i] = 0;
    pinMode(cnlPins[i], OUTPUT); // init pin for channel
  }
  output();
}

void loop() {
  loopBob();
  output(); 
}

void loopBob() {
  int data;
  if (Serial.available() >= 3) {
    timeout = 0;
    data = Serial.read();
    cnlData[0] = data;     
    cnlData[3] = data;
    data = Serial.read();
    cnlData[1] = data;     
    cnlData[4] = data;
    data = Serial.read();
    cnlData[2] = data;     
    cnlData[5] = data;
  }
}

void output() {
  for (int i=0; i<6; i++) {
    analogWrite(cnlPins[i], cnlData[i]);
  }
}