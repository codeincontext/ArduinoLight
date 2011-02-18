byte cnlData[6];
int cnlPins[6] = {3, 5, 6, 9, 10, 11};
int sliderPins[3] = {2, 1, 0};
int timeout = 0;
boolean boblight = false;

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
  if (!boblight) {
    loopSliders();
  }
  output(); 
}

void loopSliders() {
  for (int i=0; i<3; i++) {
    int v = map(analogRead(sliderPins[i]), 0, 1023, 0, 255);
    cnlData[i] = v;
    cnlData[i+3] = v;
  }
}

void loopBob() {
  int data;
  if (Serial.available() >= 4) {
    timeout = 0;
    data = Serial.read();
    if (data == 0x55) {
      data = Serial.read(); 
      if (data == 0xAA) {
        data = Serial.read(); 
        if (data < 127) {
          if (boblight){readCnlData(data);}
        } else {readCmd(data);}
        return;
      }
    }
  }
  else if (timeout < 32767){
    timeout++;
    if (timeout == 32767) {
      for (int i=0; i<6; i++) {
        cnlData[i] = 0x00;
      }
    }
  }
}

void output() {
  for (int i=0; i<6; i++) {
    analogWrite(cnlPins[i], cnlData[i]);
  }
}

void readCnlData(int startCnl) {
  int numCnls = Serial.read();

  while (Serial.available() < numCnls * 2) {
    delay(10);
  }

  byte data;
  for (int i = 0; i < numCnls; i++) {
    data = Serial.read();  // first color byte from boblight;

    if (startCnl+i < 6)
      cnlData[startCnl+i] = data;

    data = Serial.read();  // we ignore the second byte as arduino only has 8 bit PWM;
  }                                   
}

void readCmd(int cmd) {
  int numBytes = Serial.read();
  
  if (cmd == 0x81) {
    sendValues();
  }
  else if (cmd == 0x83) {
    boblight = true;                           
  }
  else if (cmd == 0x84) {
    boblight = false;                                 
  }
}

void sendValues() {
    int startCnl = Serial.read();
    int numCnls =  Serial.read();
   
    Serial.print(0x55, BYTE);
    Serial.print(0xAA, BYTE);
    
    if (numCnls <=0 || startCnl >= 6) {
      Serial.print(0, BYTE);
      Serial.print(0, BYTE);
    }
    else {
      numCnls = min(6 - startCnl, numCnls);
      Serial.print(startCnl, BYTE);
      Serial.print(numCnls, BYTE);
     
      byte byte1, byte2;
      for (int i=startCnl; i< startCnl + numCnls; i++) {
         byte1 = cnlData[i];
 	 byte2 = 0x00;
         Serial.print(byte1, BYTE);
         Serial.print(byte2, BYTE);
      }
   }
}
