import processing.sound.*;

SoundFile miCancion;

Waveform miForma;
Waveform rectPlanetFigure;
Amplitude amp;
int muestras;

float miDur;

float y = 0;

float sleep = 0;


float trans = 0.25;
float[] sumAmp;
float sumAmpRoundPlanet;
float[] sumAmpRectPlanet;


int bpm = 128; // BPM (pulsos por minuto)
int beat = 0; // Contador de pulsos
float minutes;
float interval; // Intervalo entre pulsos


void setup() {
  fullScreen();
  // size(1250, 900);
  muestras = width/4;
  sumAmp = new float[muestras];
  sumAmpRectPlanet = new float[muestras];
  miCancion = new SoundFile(this, "song.wav");
  miForma = new Waveform(this, muestras);
  rectPlanetFigure = new Waveform(this, muestras);
  amp = new Amplitude(this);

  miCancion.play();
  miForma.input(miCancion);
  rectPlanetFigure.input(miCancion);
  amp.input(miCancion);

  interval = 60.0 / bpm * 1000;

  background(#003153);
  noStroke();
}

void draw() {
  noStroke();  
  background(#003153);
  stroke(#f5faf9);
  noFill();
  miForma.analyze();
  int x = width/4-10;
  beginShape();
  for (int numR = 0; numR < muestras; numR = numR + 1) {
    sumAmp[numR] = sumAmp[numR] + (miForma.data[numR] - sumAmp[numR]) * trans;
    float alto = map(sumAmp[numR], -1.0, 1.0, 0, height);
    if (millis() - beat >= interval) {
      y=alto;
      print(128);
      beat = millis();
    }
    if (numR >= muestras-10) {
      vertex((0+numR)*((width)/(4*muestras)), y);
    }
    else {
      vertex((0+numR)*((width)/(4*muestras)), alto);
    }
    
  }
  endShape();
  cohete(x,int(y),1);

  //roundPlanet(width/2, height/2);
  rectPlanet(width/2, height/2);
}

void cohete(int x, int y, int tamanio) {
    beginShape();
    stroke(0);
    strokeWeight(1);
    beginShape();
    fill(0,160,0);
    vertex(x, y+22*tamanio);
    bezierVertex(x, y+22*tamanio, x+10*tamanio, y+14*tamanio, x+22*tamanio, y+16*tamanio);
    bezierVertex(x+22*tamanio, y+16*tamanio, x+21*tamanio, y+18*tamanio, x+21*tamanio, y+19*tamanio);
    bezierVertex(x+21*tamanio, y+19*tamanio, x+13*tamanio, y+17*tamanio, x+6*tamanio, y+22*tamanio);
    bezierVertex(x+6*tamanio, y+22*tamanio, x+12*tamanio, y+28*tamanio, x+21*tamanio, y+26*tamanio);
    bezierVertex(x+21*tamanio, y+26*tamanio, x+21*tamanio, y+27*tamanio, x+22*tamanio, y+29*tamanio);
    bezierVertex(x+22*tamanio, y+29*tamanio, x+10*tamanio, y+31*tamanio, x, y+22*tamanio);
    endShape();

    beginShape();
    fill(160,0,0);
    vertex(x+21*tamanio, y+19*tamanio);
    bezierVertex(x+21*tamanio, y+19*tamanio, x+13*tamanio, y+17*tamanio, x+6*tamanio, y+22*tamanio);
    bezierVertex(x+6*tamanio, y+22*tamanio, x+12*tamanio, y+28*tamanio, x+21*tamanio, y+26*tamanio);
    bezierVertex(x+21*tamanio, y+26*tamanio, x+20*tamanio, y+22*tamanio, x+21*tamanio, y+19*tamanio);
    endShape();

    beginShape();
    fill(0,0,160);
    vertex(x+23*tamanio, y+15*tamanio);
    bezierVertex(x+23*tamanio, y+15*tamanio, x+22*tamanio, y+16*tamanio, x+22*tamanio, y+16*tamanio);
    bezierVertex(x+22*tamanio, y+16*tamanio, x+21*tamanio, y+18*tamanio, x+21*tamanio, y+19*tamanio);
    bezierVertex(x+21*tamanio, y+19*tamanio, x+20*tamanio, y+22*tamanio, x+21*tamanio, y+26*tamanio);
    bezierVertex(x+21*tamanio, y+26*tamanio, x+21*tamanio, y+27*tamanio, x+22*tamanio, y+29*tamanio);
    bezierVertex(x+22*tamanio, y+29*tamanio, x+22*tamanio, y+29*tamanio, x+23*tamanio, y+30*tamanio);
    vertex(x+30*tamanio, y+29*tamanio);
    bezierVertex(x+30*tamanio, y+29*tamanio, x+25*tamanio, y+22*tamanio, x+30*tamanio, y+16*tamanio);
    vertex(x+23*tamanio, y+15*tamanio);
    endShape();

    beginShape();
    fill(105,69,49);
    vertex(x+32*tamanio, y+15*tamanio);
    bezierVertex(x+32*tamanio, y+15*tamanio, x+38*tamanio, y+9*tamanio, x+28*tamanio, y);
    bezierVertex(x+28*tamanio, y, x+40*tamanio, y-2*tamanio, x+47*tamanio, y+9*tamanio);
    bezierVertex(x+47*tamanio, y+9*tamanio, x+39*tamanio, y+10*tamanio, x+32*tamanio, y+15*tamanio);
    endShape();

    beginShape();
    fill(105,69,49);
    vertex(x+32*tamanio, y+30*tamanio);
    bezierVertex(x+32*tamanio, y+30*tamanio, x+38*tamanio, y+35*tamanio, x+28*tamanio, y+45*tamanio);
    bezierVertex(x+47*tamanio, y+40*tamanio, x+47*tamanio, y+35*tamanio, x+47*tamanio, y+35*tamanio);
    bezierVertex(x+47*tamanio, y+35*tamanio, x+32*tamanio, y+30*tamanio, x+32*tamanio, y+30*tamanio);
    endShape();

    beginShape();
    fill(0,160,160);
    vertex(x+30*tamanio, y+29*tamanio);
    bezierVertex(x+30*tamanio, y+29*tamanio, x+25*tamanio, y+22*tamanio, x+30*tamanio, y+16*tamanio);
    bezierVertex(x+30*tamanio, y+16*tamanio, x+50*tamanio, y, x+80*tamanio, y+11*tamanio);
    bezierVertex(x+80*tamanio, y+11*tamanio, x+75*tamanio, y+22*tamanio, x+80*tamanio, y+34*tamanio);
    bezierVertex(x+80*tamanio, y+34*tamanio, x+60*tamanio, y+44*tamanio, x+30*tamanio, y+29*tamanio);
    endShape();

    beginShape();
    fill(160,160,0);
    vertex(x+80*tamanio, y+11*tamanio);
    bezierVertex(x+80*tamanio, y+11*tamanio, x+75*tamanio, y+22*tamanio, x+80*tamanio, y+34*tamanio);
    bezierVertex(x+80*tamanio, y+34*tamanio, x+93*tamanio, y+28*tamanio, x+96*tamanio, y+22*tamanio);
    bezierVertex(x+96*tamanio, y+22*tamanio, x+93*tamanio, y+16*tamanio, x+80*tamanio, y+11*tamanio);
    endShape();

    fill(160,0,160);
    circle(x+47*tamanio, y+22*tamanio, 10*tamanio);
    circle(x+66*tamanio, y+22*tamanio, 13*tamanio);
    endShape();
}

void roundPlanet(int posX, int posY) {

  sumAmpRoundPlanet = sumAmpRoundPlanet + (amp.analyze() - sumAmpRoundPlanet) * trans;

  float tam = map(sumAmpRoundPlanet, 0, 1, 0, 100);
  fill(255, 255, 255, 100);
  noStroke();
  ellipse(posX, posY, tam, tam);

}


void rectPlanet(int posX, int posY) {
  stroke(255, 255, 255, 100);
  noFill();
  rectPlanetFigure.analyze();
  beginShape();
  for (int numR = 0; numR < muestras; numR = numR + 1) {
    sumAmpRectPlanet[numR] = sumAmpRectPlanet[numR] + (rectPlanetFigure.data[numR] - sumAmpRectPlanet[numR]) * trans;
    
    float alto = map(sumAmpRectPlanet[numR], -1.0, 1.0, 0, height/2);
    float x = alto * cos(numR) + (width/2);
    float y = alto * sin(numR) + (height/2);
    //rect((0+numR)*(width/muestras), height/2, width/muestras, alto);
    vertex((0+numR)*(width/muestras), alto);
    vertex(x, y);
  }
  endShape(CLOSE);
}