import processing.sound.*;

SoundFile ourSong;

Waveform miForma;
Waveform rectPlanetFigure;
Amplitude amp;
int muestras;
Waveform miFormaCohete;
Waveform miFormaMeteoro;
int muestrasEstelaCohete = 1920 / 4;
int muestrasMeteoro = 360;

float miDur;

float yCohete = 0;

float sleep = 0;
float trans = 0.25;


float[] sumAmp;
float sumAmpRoundPlanet;
float[] sumAmpRectPlanet;
float[] sumAmpCohete;
float[] sumAmpMeteoro;


int bpm = 128; // BPM (pulsos por minuto)
int beat = 0; // Contador de pulsos
float minutes;
float interval; // Intervalo entre pulsos


void setup() {
  fullScreen();
  // size(1250, 900);
  muestras = width/4;
  sumAmpCohete = new float[muestrasEstelaCohete];
  sumAmpMeteoro = new float[muestrasMeteoro];
  ourSong = new SoundFile(this, "song.wav");
  miFormaCohete = new Waveform(this, muestrasEstelaCohete);
  miFormaMeteoro = new Waveform(this, muestrasMeteoro);
  rectPlanetFigure = new Waveform(this, muestras);
  sumAmp = new float[muestras];
  sumAmpRectPlanet = new float[muestras];
  miForma = new Waveform(this, muestras);
  amp = new Amplitude(this);

  interval = 60.0 / bpm * 1000;

  ourSong.play();
  miFormaCohete.input(ourSong);
  miFormaMeteoro.input(ourSong);
  miForma.input(ourSong);
  rectPlanetFigure.input(ourSong);
  amp.input(ourSong);
    
  background(#003153);
  noStroke();
}




void draw() {
  sleep = sleep + 1;
  estelaCohete();
  estrella_cayente(1200,800,200);
  cohete((width/4)-30,int(yCohete),1);

  stroke(#f5faf9);

  rectPlanet(width/2, height/2);
  
}

/**
  La estela toma un valor máximo de tamanio, este debe ser considerado para ser el offset de la estela los valores de x y y de este
  se calculan con el valor de 2^{1/2}/2 multiplicado por la hipostenusa, en este caso trabajamos con un tríangulo isoceles.
  desde este valor inicial de x y y se calcula el valor de x y y final de la punta de la estela. como valor mínimo será 0 y estará
  al borde la estrella, valor máximo de tamanio para que redoble el tamaño del meteoro. Número de estelas: 7 con variación de angulo
  desde 45 reduciendo y aumentando respectivamente el valor en 5 grados por estela.
 */
void estrella_cayente(int xInicio, int yInicio, int tamanio) {
  stroke(#b5b141);
  strokeWeight(4);
  for (int i = 0; i < 7; i++) {
    float lim = map(amp.analyze(), 0.0, 1.0, 0.0, tamanio);
    float ran = random(tamanio*2/3, tamanio);
    float xMax = int((ran)*cos(radians(30+(i*5))));
    float yMax = int((ran)*sin(radians(30+(i*5))));
    float xFinal = xInicio + int((lim+xMax)*cos(radians(30+(i*5))));
    float yFinal = yInicio - int((lim+yMax)*sin(radians(30+(i*5))));
    line(xInicio,yInicio,xFinal,yFinal);
  }
  miFormaMeteoro.analyze();
  stroke(#f5faf9);
  strokeWeight(1);
  for (int numR = 0; numR < muestrasMeteoro; numR = numR + 1) {
    if (numR%6==0) {
      sumAmpMeteoro[numR] = sumAmpMeteoro[numR] + (miFormaMeteoro.data[numR] - sumAmpMeteoro[numR]) * trans;
      float alto = map(sumAmpMeteoro[numR], -1.0, 1.0, 0, tamanio);
      float xFin = alto * cos(radians(numR-90)) + (xInicio);
      float yFin = alto * sin(radians(numR-90)) + (yInicio);
      line(xInicio, yInicio, xFin, yFin);
    }
  }

}



void cohete(int x, int y, int tamanio) {
  beginShape();
  stroke(0);
  strokeWeight(1);
  beginShape();
  fill(0,160,0);
  vertex(x, y + 22 * tamanio);
  bezierVertex(x, y + 22 * tamanio, x + 10 * tamanio, y + 14 * tamanio, x + 22 * tamanio, y + 16 * tamanio);
  bezierVertex(x + 22 * tamanio, y + 16 * tamanio, x + 21 * tamanio, y + 18 * tamanio, x + 21 * tamanio, y + 19 * tamanio);
  bezierVertex(x + 21 * tamanio, y + 19 * tamanio, x + 13 * tamanio, y + 17 * tamanio, x + 6 * tamanio, y + 22 * tamanio);
  bezierVertex(x + 6 * tamanio, y + 22 * tamanio, x + 12 * tamanio, y + 28 * tamanio, x + 21 * tamanio, y + 26 * tamanio);
  bezierVertex(x + 21 * tamanio, y + 26 * tamanio, x + 21 * tamanio, y + 27 * tamanio, x + 22 * tamanio, y + 29 * tamanio);
  bezierVertex(x + 22 * tamanio, y + 29 * tamanio, x + 10 * tamanio, y + 31 * tamanio, x, y + 22 * tamanio);
  endShape();
    
  beginShape();
  fill(160,0,0);
  vertex(x + 21 * tamanio, y + 19 * tamanio);
  bezierVertex(x + 21 * tamanio, y + 19 * tamanio, x + 13 * tamanio, y + 17 * tamanio, x + 6 * tamanio, y + 22 * tamanio);
  bezierVertex(x + 6 * tamanio, y + 22 * tamanio, x + 12 * tamanio, y + 28 * tamanio, x + 21 * tamanio, y + 26 * tamanio);
  bezierVertex(x + 21 * tamanio, y + 26 * tamanio, x + 20 * tamanio, y + 22 * tamanio, x + 21 * tamanio, y + 19 * tamanio);
  endShape();
    
  beginShape();
  fill(0,0,160);
  vertex(x + 23 * tamanio, y + 15 * tamanio);
  bezierVertex(x + 23 * tamanio, y + 15 * tamanio, x + 22 * tamanio, y + 16 * tamanio, x + 22 * tamanio, y + 16 * tamanio);
  bezierVertex(x + 22 * tamanio, y + 16 * tamanio, x + 21 * tamanio, y + 18 * tamanio, x + 21 * tamanio, y + 19 * tamanio);
  bezierVertex(x + 21 * tamanio, y + 19 * tamanio, x + 20 * tamanio, y + 22 * tamanio, x + 21 * tamanio, y + 26 * tamanio);
  bezierVertex(x + 21 * tamanio, y + 26 * tamanio, x + 21 * tamanio, y + 27 * tamanio, x + 22 * tamanio, y + 29 * tamanio);
  bezierVertex(x + 22 * tamanio, y + 29 * tamanio, x + 22 * tamanio, y + 29 * tamanio, x + 23 * tamanio, y + 30 * tamanio);
  vertex(x + 30 * tamanio, y + 29 * tamanio);
  bezierVertex(x + 30 * tamanio, y + 29 * tamanio, x + 25 * tamanio, y + 22 * tamanio, x + 30 * tamanio, y + 16 * tamanio);
  vertex(x + 23 * tamanio, y + 15 * tamanio);
  endShape();
    
  beginShape();
  fill(105,69,49);
  vertex(x + 32 * tamanio, y + 15 * tamanio);
  bezierVertex(x + 32 * tamanio, y + 15 * tamanio, x + 38 * tamanio, y + 9 * tamanio, x + 28 * tamanio, y);
  bezierVertex(x + 28 * tamanio, y, x + 40 * tamanio, y - 2 * tamanio, x + 47 * tamanio, y + 9 * tamanio);
  bezierVertex(x + 47 * tamanio, y + 9 * tamanio, x + 39 * tamanio, y + 10 * tamanio, x + 32 * tamanio, y + 15 * tamanio);
  endShape();
    
  beginShape();
  fill(105,69,49);
  vertex(x + 32 * tamanio, y + 30 * tamanio);
  bezierVertex(x + 32 * tamanio, y + 30 * tamanio, x + 38 * tamanio, y + 35 * tamanio, x + 28 * tamanio, y + 45 * tamanio);
  bezierVertex(x + 47 * tamanio, y + 40 * tamanio, x + 47 * tamanio, y + 35 * tamanio, x + 47 * tamanio, y + 35 * tamanio);
  bezierVertex(x + 47 * tamanio, y + 35 * tamanio, x + 32 * tamanio, y + 30 * tamanio, x + 32 * tamanio, y + 30 * tamanio);
  endShape();
    
  beginShape();
  fill(0,160,160);
  vertex(x + 30 * tamanio, y + 29 * tamanio);
  bezierVertex(x + 30 * tamanio, y + 29 * tamanio, x + 25 * tamanio, y + 22 * tamanio, x + 30 * tamanio, y + 16 * tamanio);
  bezierVertex(x + 30 * tamanio, y + 16 * tamanio, x + 50 * tamanio, y, x + 80 * tamanio, y + 11 * tamanio);
  bezierVertex(x + 80 * tamanio, y + 11 * tamanio, x + 75 * tamanio, y + 22 * tamanio, x + 80 * tamanio, y + 34 * tamanio);
  bezierVertex(x + 80 * tamanio, y + 34 * tamanio, x + 60 * tamanio, y + 44 * tamanio, x + 30 * tamanio, y + 29 * tamanio);
  endShape();
    
  beginShape();
  fill(160,160,0);
  vertex(x + 80 * tamanio, y + 11 * tamanio);
  bezierVertex(x + 80 * tamanio, y + 11 * tamanio, x + 75 * tamanio, y + 22 * tamanio, x + 80 * tamanio, y + 34 * tamanio);
  bezierVertex(x + 80 * tamanio, y + 34 * tamanio, x + 93 * tamanio, y + 28 * tamanio, x + 96 * tamanio, y + 22 * tamanio);
  bezierVertex(x + 96 * tamanio, y + 22 * tamanio, x + 93 * tamanio, y + 16 * tamanio, x + 80 * tamanio, y + 11 * tamanio);
  endShape();
    
  fill(160,0,160);
  circle(x + 47 * tamanio, y + 22 * tamanio, 10 * tamanio);
  circle(x + 66 * tamanio, y + 22 * tamanio, 13 * tamanio);
  endShape();
}

void estelaCohete() {
  noStroke();  
  background(#003153);
  stroke(#f5faf9);
  noFill();
  miFormaCohete.analyze();
  beginShape();
  for (int numR = 0; numR < muestrasEstelaCohete; numR = numR + 1) {
    sumAmpCohete[numR] = sumAmpCohete[numR] + (miFormaCohete.data[numR] - sumAmpCohete[numR]) * trans;
    float alto = map(sumAmpCohete[numR], -1.0, 1.0, 0, height);
    if (sleep%10==0) {
      yCohete=alto;
    }
    if (numR >= muestrasEstelaCohete-30) {
      vertex((0+numR)*((width)/(4*muestrasEstelaCohete)), yCohete+21);
    }
    else {
      vertex((0+numR)*((width)/(4*muestrasEstelaCohete)), alto+21);
    }
  }
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
    //vertex((0+numR)*(width/muestras), alto);
    vertex(x, y);
  }
  endShape(CLOSE);
}