import processing.sound.*;

import java.util.HashMap;

SoundFile ourSong;

float songDuration;

Amplitude amp;

Waveform miFormaCohete;
Waveform miFormaMeteoro;
Waveform rectPlanetFigure;

int muestrasEstelaCohete = 1920 / 4;
int muestrasMeteoro = 360;
int muestrasRectPlanet = width / 4;


float yCohete = 0;

float sleep = 0;
float trans = 0.25;


float sumAmpRoundPlanet;
float[] sumAmpRectPlanet;
float[] sumAmpCohete;
float[] sumAmpMeteoro;

HashMap<String, ArrayList<ArrayList<Boolean>>> letras = new HashMap<String, ArrayList<ArrayList<Boolean>>>();

int option;
float posXPlanet;
float posYPlanet;
float tamPlanet;

float posXMeteor;
float posYMeteor;
float tamMeteor;

int ad = 0;

void setup() {
  agregarLetras();
  fullScreen();
  sumAmpCohete = new float[muestrasEstelaCohete];
  sumAmpMeteoro = new float[muestrasMeteoro];
  ourSong = new SoundFile(this, "song.wav");
  miFormaCohete = new Waveform(this, muestrasEstelaCohete);
  miFormaMeteoro = new Waveform(this, muestrasMeteoro);
  rectPlanetFigure = new Waveform(this, muestrasRectPlanet);
  sumAmpRectPlanet = new float[muestrasRectPlanet];
  amp = new Amplitude(this);
  ourSong.play();
  miFormaCohete.input(ourSong);
  miFormaMeteoro.input(ourSong);
  rectPlanetFigure.input(ourSong);
  amp.input(ourSong);

  option = 0;
  posXPlanet = width + 100;
  posYPlanet = random(200, height-200);
  tamPlanet = random(100, 400);

  posXMeteor = width + 100;
  posYMeteor = -100;
  tamMeteor = random(25, 150);
    
  background(#003153);
  noStroke();
}

void draw() {
  sleep = sleep + 1;
  estelaCohete();
  estrella_cayente(posXMeteor,posYMeteor,tamMeteor);
  cohete((width/4)-30,int(yCohete),1);

  stroke(#f5faf9);

  rectPlanet(width/2, height/2);
  estrella(width/2, height/2, 0.5);
  showPlanet();


  if (posXPlanet < -100) {
    posXPlanet = width + 100;
    posYPlanet = random(200, height-200);
    tamPlanet = random(100, 400);
  }

  if (posYMeteor > height + 100) {
    posXMeteor = width + 100;
    posYMeteor = -100;
    tamMeteor = random(25, 150);
  }

  posXPlanet = posXPlanet - 1;
  posXMeteor = posXMeteor - 2;
  posYMeteor = posYMeteor + 2;
  
}

/**
  La estela toma un valor máximo de tamanio, este debe ser considerado para ser el offset de la estela los valores de x y y de este
  se calculan con el valor de 2^{1/2}/2 multiplicado por la hipostenusa, en este caso trabajamos con un tríangulo isoceles.
  desde este valor inicial de x y y se calcula el valor de x y y final de la punta de la estela. como valor mínimo será 0 y estará
  al borde la estrella, valor máximo de tamanio para que redoble el tamaño del meteoro. Número de estelas: 7 con variación de angulo
  desde 45 reduciendo y aumentando respectivamente el valor en 5 grados por estela.
 */
void estrella_cayente(float xInicio, float yInicio, float tamanio) {
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

void roundPlanet(float posX, float posY, float tam) {

  sumAmpRoundPlanet = sumAmpRoundPlanet + (amp.analyze() - sumAmpRoundPlanet) * trans;

  float scale = map(sumAmpRoundPlanet, 0, 1, 0, tam);
  fill(255, 255, 255, 100);
  noStroke();
  ellipse(posX, posY, scale, scale);

}

void rectPlanet(float posX, float posY, float tam) {
  stroke(255, 255, 255, 100);
  noFill();
  rectPlanetFigure.analyze();

  beginShape();
  for (int numR = 0; numR < muestrasRectPlanet; numR = numR + 1) {
    sumAmpRectPlanet[numR] = sumAmpRectPlanet[numR] + (rectPlanetFigure.data[numR] - sumAmpRectPlanet[numR]) * trans;
    float alto = map(sumAmpRectPlanet[numR], -1.0, 1.0, 0, tam/2);
    float x = alto * cos(numR) + (posX);
    float y = alto * sin(numR) + (posY);
    vertex(x, y);
  }
  endShape(CLOSE);
}


void estrella(int x, int y, float tamanio) {
  stroke(255);
  strokeWeight(1);
  beginShape();
  vertex(x, y + int(20 * tamanio));
  vertex(x + int(20 * tamanio), y + int(18 * tamanio));
  vertex(x + int(25 * tamanio), y);
  vertex(x + int(30 * tamanio), y + int(18 * tamanio));
  vertex(x + int(50 * tamanio), y + int(20 * tamanio));
  vertex(x + int(35 * tamanio), y + int(35 * tamanio));
  vertex(x + int(40 * tamanio), y + int(50 * tamanio));
  vertex(x + int(25 * tamanio), y + int(40 * tamanio));
  vertex(x + int(10 * tamanio), y + int(50 * tamanio));
  vertex(x + int(15 * tamanio), y + int(35 * tamanio));
  endShape(CLOSE);

}
// 45 pixeles entre letra y letra. Espacios de 75 para palabras normales. 80 de alto
void letras(int x, int y, String letra) {
  float tam = 0.125;
  for (int j=0;j<7;j++) {
    for (int i=0;i<5;i++) {
      if (letras.get(letra).get(j).get(i)) {
        estrella(x+int(i*(7.5)),y+int(j*(7.5)),tam); 
      }
    }
  }
}

void showPlanet() {

  float songPos = ourSong.position();

  print(songPos + "\n");

  if (songPos < 36 || songPos > 84) {
    if (songPos > 0+ad && songPos < 2+ad) {
        option = 1;
    } else if (songPos > 2+ad && songPos < 4.15+ad) {
        option = 0;
    } else if (songPos > 4.15+ad && songPos < 6.17+ad) {
        option = 1;
    } else if (songPos > 6.17+ad && songPos < 8+ad) {
        option = 0;
    } else if (songPos > 8+ad && songPos < 9.8+ad) {
        option = 1;
    } else if (songPos > 9.8+ad && songPos < 11.7+ad) {
        option = 0;
    } else if (songPos > 11.7+ad && songPos < 13.7+ad) {
        option = 1;
    } else if (songPos > 13.6+ad && songPos < 15.4+ad) {
        option = 0;
    } else if (songPos > 15.4+ad && songPos < 18+ad) {
        option = 1;
        ad += 18;
    }

    if (option == 0) {
      roundPlanet(posXPlanet, posYPlanet, tamPlanet);
    } else if (option == 1) {
      rectPlanet(posXPlanet, posYPlanet, tamPlanet);
    }
  }

}

void agregarLetras() {
  for (int k=0;k<28;k++) {
    switch (k) {
    case 0:
      ArrayList<ArrayList<Boolean>> letterA = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if ((i == 0 && (j == 1 || j == 2 || j == 3)) || ((i == 1 || i == 2 || i == 4 || i == 5 || i==6) && (j == 0 || j == 4)) || (i==3)) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterA.add(row);
      }
      letras.put("a", letterA);
      break;
    case 1:
      ArrayList<ArrayList<Boolean>> letterB = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if (j == 0 || (i == 0 || i == 3 || i == 6) && j < 4 || (j == 4 && (i != 0 && i != 3 && i != 6))) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterB.add(row);
      }
      letras.put("b", letterB);
      break;
    case 2:
      ArrayList<ArrayList<Boolean>> letterC = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if (j == 0 && i > 0 && i < 6 || (i == 0 || i == 6) && j > 0) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterC.add(row);
      }
      letras.put("c", letterC);
      break;
    case 3:
      ArrayList<ArrayList<Boolean>> letterD = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if ((j == 0) || ((i == 0 || i == 6) && (j == 1 || j == 2)) || (i >= 2 && i <= 4) && j == 4 || (i == 1 || i == 5) && j == 3) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterD.add(row);
      }
      letras.put("d", letterD);
      break;
    case 4:
      ArrayList<ArrayList<Boolean>> letterE = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if (j == 0 || i == 0 || i == 6 || (i == 3 && j <= 3)) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterE.add(row);
      }
      letras.put("e", letterE);
      break;
    case 5:
      ArrayList<ArrayList<Boolean>> letterF = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if (j == 0 || i == 0 || (i == 3 && j <= 3)) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterF.add(row);
      }
      letras.put("f", letterF);
      break;
    case 6:
      ArrayList<ArrayList<Boolean>> letterG = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if ((i == 0 || i == 6) && (j > 0 && j < 4) || (i == 6 && j == 4) || (i >= 3 && i <= 5) && (j == 0 || j == 4) || (i == 2) && (j == 0) || (i == 1) && (j == 0 || j == 4) || (i == 3 && j >= 2)) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterG.add(row);
      }
      letras.put("g", letterG);
      break;
    case 7:
      ArrayList<ArrayList<Boolean>> letterH = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if (j == 0 || j == 4 || i == 3) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterH.add(row);
      }
      letras.put("h", letterH);
      break;
    case 8:
      ArrayList<ArrayList<Boolean>> letterI = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if (j == 2 || i == 0 || i == 6) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterI.add(row);
      }
      letras.put("i", letterI);
      break;
    case 9:
      ArrayList<ArrayList<Boolean>> letterJ = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if ((j == 3 && i<6) || (i == 0 && j >= 2 && j <= 4) || (i == 5 && j == 0)|| (i == 6 && (j == 1 || j == 2))) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterJ.add(row);
      }
      letras.put("j", letterJ);
      break;
    case 10:
      ArrayList<ArrayList<Boolean>> letterK = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if (j == 0 || (j==5-1-i && j!= 0) || (j==i-2 && j!= 0)) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterK.add(row);
      }
      letras.put("k", letterK);
      break;
    case 11:  
      ArrayList<ArrayList<Boolean>> letterL = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if (j == 0 || i == 6) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterL.add(row);
      }
      letras.put("l", letterL);
      break;
    case 12:
      ArrayList<ArrayList<Boolean>> letterM = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if (j == 0 || j == 4 || (j==1 || j==3) && (i==1) || (j==2) && (i==2 || i == 3)) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterM.add(row);
      }
      letras.put("m", letterM);
      break;
    case 13:
      ArrayList<ArrayList<Boolean>> letterN = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if (j == 0 || j == 4 || i == j) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterN.add(row);
      }
      letras.put("n", letterN);
      break;
    case 14:
      ArrayList<ArrayList<Boolean>> letterO = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if ((i == 0 || i == 6) && j >= 1 && j <= 3) {
            row.add(true);
          } else if ((j == 0 || j == 4) && i >= 1 && i <= 5) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterO.add(row);
      }
      letras.put("o", letterO);
      break;
    case 15:
      ArrayList<ArrayList<Boolean>> letterP = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if (j == 0 || (i == 0 || i == 3) && j < 4 || (i > 0 && i < 3) && j == 4) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterP.add(row);
      }
      letras.put("p", letterP);
      break;
    case 16:
      ArrayList<ArrayList<Boolean>> letterQ = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if ((i == 0 || i == 6) && j >= 1 && j <= 3) {
            row.add(true);
          } else if ((j == 0 || j == 4) && i >= 1 && i <= 5) {
            row.add(true);
          } else if (i >= 4 && i <= 6 && j == 3) {
            row.add(true);
          } else if (i == 5 && j == 4) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterQ.add(row);
      }
      letras.put("q", letterQ);
      break;
    case 17:
      ArrayList<ArrayList<Boolean>> letterR = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if (j == 0 || (i == 0 || i == 3) && j < 4 || (i > 0 && i < 3) && j == 4 || (i>=4 && j==i-2)) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterR.add(row);
      }
      letras.put("r", letterR);
      break;
    case 18:
      ArrayList<ArrayList<Boolean>> letterS = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if ((i==0 || i == 3 || i == 6) && j > 0 && j < 4 || (i == 1 || i == 2) && j == 0 || (i == 4 || i == 5) && j == 4 || (i==6 && j==0) || (i==0 && j==4)) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterS.add(row);
      }
      letras.put("s", letterS);
      break;
    case 19:
      ArrayList<ArrayList<Boolean>> letterT = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if (i == 0 || (i != 0 && j == 2)) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterT.add(row);
      }
      letras.put("t", letterT);
      break;
    case 20:
      ArrayList<ArrayList<Boolean>> letterU = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if ((i == 0 && (j == 0 || j == 4)) || (i == 6 && (j == 0 || j == 4)) || (i > 0 && i < 6 && (j == 0 || j == 4)) || (i == 6 && j > 0 && j < 4)) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterU.add(row);
      }
      letras.put("u", letterU);
      break;
    case 21:
      ArrayList<ArrayList<Boolean>> letterV = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if ((i < 4 && (j == 0 || j == 4)) || ((i == 4|| i == 5) && (j==1 ||j==3)) || (i == 6 && j == 2)) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterV.add(row);
      }
      letras.put("v", letterV);
      break;
    case 22:
      ArrayList<ArrayList<Boolean>> letterW = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if (((j == 0  || j == 4) && i != 6) || (i==6 && (j==1 || j==3)) || (j==2 && (i==3 || i==4|| i==5 ))) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterW.add(row);
      }
      letras.put("w", letterW);
      break;
    case 23:
      ArrayList<ArrayList<Boolean>> letterX = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if ((i == j) || (i + j == 4)) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterX.add(row);
      }
      letras.put("x", letterX);
      break;
    case 24:
      ArrayList<ArrayList<Boolean>> letterY = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if ((i<3 && (j==0 || j==4)) || (i==3 && (j==1 || j==3)) || (i==4 && j==2) || (i==5 && j==2) || (i==6 && j==2)) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterY.add(row);
      }
      letras.put("y", letterY);
      break;
    case 25:
      ArrayList<ArrayList<Boolean>> letterZ = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if (i == 0 || i == 6 || j == 5 - i) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        letterZ.add(row);
      }
      letras.put("z", letterZ);
      break;
    case 26:
      ArrayList<ArrayList<Boolean>> apostropheSymbol = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if ((i == 0 && j == 2) || (i == 1 && j == 1) || (i == 2 && j == 0)) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        apostropheSymbol.add(row);
      }
      letras.put("'", apostropheSymbol);
      break;
    case 27:
      ArrayList<ArrayList<Boolean>> commaSymbol = new ArrayList<ArrayList<Boolean>>();
      for (int i = 0; i < 7; i++) {
        ArrayList<Boolean> row = new ArrayList<Boolean>();
        for (int j = 0; j < 5; j++) {
          if (i == 4 && (j == 3 || j == 4) || (i==5 && j==4 )|| (i==6 && j==3)) {
            row.add(true);
          } else {
            row.add(false);
          }
        }
        commaSymbol.add(row);
      }
      letras.put(",", commaSymbol);
    default:
      System.out.println("Invalid grade");
      break;
    }
  }
}