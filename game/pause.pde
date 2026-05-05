
boolean paused = false;
int pauseSelected = 0;
String[] pauseOptions = {"Continuar", "Reiniciar", "Salir"};

void drawPauseMenu() {
  if (pausaImg != null) {
    // Usar la imagen de pausa a pantalla completa (espacio logico 480x320)
    image(pausaImg, 0, 0, GAME_W, GAME_H);
  } else {
    // Fallback si la imagen no cargó
    fill(0, 160);
    rect(0, 0, GAME_W, GAME_H);

    int pw = 220, ph = 160;
    int px = (GAME_W - pw) / 2;
    int py = (GAME_H - ph) / 2;

    fill(SHADOW, 180); rect(px+4, py+4, pw, ph, 6);
    fill(GOLD);        rect(px-2, py-2, pw+4, ph+4, 6);
    fill(BLUE_DARK);   rect(px, py, pw, ph, 4);

    fill(GOLD);
    textAlign(CENTER, CENTER);
    textSize(16);
    text("PAUSA", GAME_W/2, py + 28);

    stroke(GOLD, 120); strokeWeight(1);
    line(px+16, py+42, px+pw-16, py+42);
    noStroke();

    for (int i = 0; i < pauseOptions.length; i++) {
      float optY = py + 72 + i * 30;
      if (i == pauseSelected) {
        fill(GOLD, 40);
        rect(px+12, optY-12, pw-24, 24, 3);
        fill(GOLD);
        textSize(11); textAlign(LEFT, CENTER);
        text("▶", px+22, optY);
      } else {
        fill(CREAM);
      }
      textSize(11); textAlign(CENTER, CENTER);
      text(pauseOptions[i], GAME_W/2, optY);
    }
  }
}

void handlePauseInput(int keyCode, char key) {
  if (key == 'p' || key == 'P') { paused = false; return; }
  if (key == 'w' || key == 'W') pauseSelected = (pauseSelected - 1 + pauseOptions.length) % pauseOptions.length;
  if (key == 's' || key == 'S') pauseSelected = (pauseSelected + 1) % pauseOptions.length;
  if (keyCode == ENTER) {
    if (pauseSelected == 0) paused = false;
    if (pauseSelected == 1) restartGame();
    if (pauseSelected == 2) exit();
  }
}

void restartGame() {
  camX = (4 * 256);
  camY = (3 * 256+96);
  lastDirection = ' ';
  facingDirection = 's';
  paused = false;
  swscreen3 = 0;
}