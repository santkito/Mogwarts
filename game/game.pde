int camX, camY;
boolean wPressed = false;
boolean sPressed = false;
boolean aPressed = false;
boolean dPressed = false;
char lastDirection = ' ';
char facingDirection = 's';

void setupGame() {
  camX = constrain(4 * 256, 0, max(0, 8 * 256 - GAME_W));
  camY = constrain(3 * 256 + 96, 0, max(0, 5 * 256 - GAME_H));
}

void drawGame() {
  background(0);
  // Handle movement (no diagonal - last key pressed has priority)
  if (lastDirection == 'w') camY -= 4;
  else if (lastDirection == 's') camY += 4;
  else if (lastDirection == 'a') camX -= 4;
  else if (lastDirection == 'd') camX += 4;
  camX = constrain(camX, 0, max(0, 8 * 256 - GAME_W));
  camY = constrain(camY, 0, max(0, 5 * 256 - GAME_H));
  pushMatrix();
  translate(-camX, -camY);
  int startRow = max(camY / 256 - 1, 0);
  int endRow   = min((camY + GAME_H) / 256 + 1, 4);
  int startCol = max(camX / 256 - 1, 0);
  int endCol   = min((camX + GAME_W) / 256 + 1, 7);
  for (int row = startRow; row <= endRow; row++) {
    for (int col = startCol; col <= endCol; col++) {
      if (tiles[col][row] != null) {
        image(tiles[col][row], col * 256, row * 256, 256, 256);
      }
    }
  }
  popMatrix();
  
  // Draw player
  updatePlayer();
  drawPlayer();
  if (paused) drawPauseMenu();
}

void keyPressed() {
if (key == 'p' || key == 'P') {
  paused = !paused;
  return;
}

if (paused) {
  handlePauseInput(keyCode, key);
  return;  // <- este return evita que WASD lleguen al movimiento
}

// movimiento normal solo llega aqui si !paused
if (key=='w'||key=='W') { wPressed=true; lastDirection='w'; }
if (key=='s'||key=='S') { sPressed=true; lastDirection='s'; }
if (key=='a'||key=='A') { aPressed=true; lastDirection='a'; }
if (key=='d'||key=='D') { dPressed=true; lastDirection='d'; }
}

void keyReleased() {
  if (key == 'w' || key == 'W') {
    wPressed = false;
  }
  if (key == 's' || key == 'S') {
    sPressed = false;
  }
  if (key == 'a' || key == 'A') {
    aPressed = false;
  }
  if (key == 'd' || key == 'D') {
    dPressed = false;
  }
  
  // Set next direction based on what keys are still pressed
  if (wPressed) {
    lastDirection = 'w';
  } else if (sPressed) {
    lastDirection = 's';
  } else if (aPressed) {
    lastDirection = 'a';
  } else if (dPressed) {
    lastDirection = 'd';
  } else {
    lastDirection = ' ';
  }
}