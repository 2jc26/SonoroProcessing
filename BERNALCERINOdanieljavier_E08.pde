import processing.sound.*;

SoundFile miCancion;

Waveform miForma;
int muestras;

float miDur;

float trans = 0.25;
float[] sumAmp;

void setup() {
  fullScreen();
  //size(800, 600);
  muestras = width;
  sumAmp = new float[muestras];
  miCancion = new SoundFile(this, "song.wav");
  miForma = new Waveform(this, muestras);

  miCancion.play();
  miForma.input(miCancion);

  background(255);
  noStroke();
}

void draw() {
  noStroke();  
  fill(255, 255, 255, 50);
  rect(0, 0, width, height);

  stroke(250, 20, 100);
  noFill();
  miForma.analyze();
  beginShape();
  for (int numR = 0; numR < muestras; numR = numR + 1) {
    sumAmp[numR] = sumAmp[numR] + (miForma.data[numR] - sumAmp[numR]) * trans;
    float alto = map(sumAmp[numR], -1.0, 1.0, 0, height);
    vertex((0+numR)*(width/muestras), alto);
  }
  endShape();
}