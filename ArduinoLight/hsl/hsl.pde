byte cnlData[6];
int cnlPins[6] = {3, 5, 6, 9, 10, 11};
int sliderPins[3] = {2, 1, 0};
float h = 0;

void setup() {
  for (int i=0; i<6; i++) {
    pinMode(cnlPins[i], OUTPUT); // init pin for channel
  }
}

void hsl_to_rgb(byte pH, byte pS, byte pL, byte &r, byte &g, byte &b) {
  float h = (float)pH / (float)255;
  float s = (float)pS / (float)255;
  float l = (float)pL / (float)255;

  if (s == 0) {
    r = l*255;
    g = l*255;
    b = l*255;
  } else {
    float tr;
    float tg;
    float tb;
    float t2;
  
    if (l < 0.5) {t2 = l * (1.0+s);}
    else {t2 = l+s - l*s;}

    float t1 = 2.0*l - t2;

    float t3r = h + 1.0/3.0;
    if (t3r < 0) {t3r = t3r + 1.0;}
    if (t3r > 1) {t3r = t3r - 1.0;}
    
    float t3g = h;
    if (t3g < 0) {t3g = t3g + 1.0;}
    if (t3g > 1) {t3g = t3g - 1.0;}
    
    float t3b = h - 1.0/3.0;
    if (t3b < 0) {t3b = t3b + 1.0;}
    if (t3b > 1) {t3b = t3b - 1.0;}
    
    if (6.0*t3r < 1) {tr = t1+(t2-t1)*6.0*t3r;}
    else if (2.0*t3r < 1) {tr = t2;}
    else if (3.0*t3r < 2) {tr = t1+(t2-t1)*((2.0/3.0)-t3r)*6.0;}
    else {tr = t1;}
    
    
    if (6.0*t3g < 1) {tg = t1+(t2-t1)*6.0*t3g;}
    else if (2.0*t3g < 1) {tg = t2;}
    else if (3.0*t3g < 2) {tg = t1+(t2-t1)*((2.0/3.0)-t3g)*6.0;}
    else {tg = t1;}
    
    
    if (6.0*t3b < 1) {tb = t1+(t2-t1)*6.0*t3b;}
    else if (2.0*t3b < 1) {tb = t2;}
    else if (3.0*t3b < 2) {tb = t1+(t2-t1)*((2.0/3.0)-t3b)*6.0;}
    else {tb = t1;}
    
    r = tr*255;
    g = tg*255;
    b = tb*255;
  }
}

void loopSliders(int &a, int &b, int &c) {
  a = analogRead(sliderPins[0]);
  b = analogRead(sliderPins[1]);
  c = analogRead(sliderPins[2]);
}

void loop() {
  int s1 = 0;
  int s2 = 0;
  int s3 = 0;
  loopSliders(s1, s2, s3);
  
  byte s = map(s2, 0, 1023, 0, 255);
  byte l = map(s3, 0, 1023, 0, 255);

  h += s1*0.0005;
  if (h > 255) {h = 0;}
  
  byte r = 0;
  byte g = 0;
  byte b = 0;
  
  hsl_to_rgb(h,s,l,r,g,b);
  
  cnlData[0] = r;
  cnlData[3] = r;
  cnlData[2] = g;
  cnlData[5] = g;
  cnlData[1] = b;
  cnlData[4] = b;

  output(); 
  
  delay(10);
}

void output() {
  for (int i=0; i<6; i++) {
    analogWrite(cnlPins[i], cnlData[i]);
  }
}

