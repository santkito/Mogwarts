int camX, camY;
int playerX, playerY;
int tutorialTimer = 300;
PImage npcSprite;
boolean dialogoVaris = false;
int npcWorldX = (4 * 256) + 400;
int npcWorldY = (4 * 256);
boolean wPressed = false;
boolean sPressed = false;
boolean aPressed = false;
boolean dPressed = false;
char lastDirection = ' ';
char facingDirection = 's';

void setupGame() {
  camX = constrain(4 * 256, 0, max(0, 8 * 256 - GAME_W));
  camY = constrain(3 * 256 + 96, 0, max(0, 5 * 256 - GAME_H));
  playerX = camX + GAME_W / 2 - 22;
  playerY = camY + GAME_H / 2 - 22;
  npcSprite = loadImage("npc.png");
}

void drawGame() {
  background(0);
  // Handle movement (no diagonal - last key pressed has priority)
  boolean colisionNPC = abs(playerX - npcWorldX) < 45 && abs(playerY - npcWorldY) < 39;

  if (!colisionNPC) {
    if (lastDirection == 'w') playerY -= 4;
    else if (lastDirection == 's') playerY += 4;
    else if (lastDirection == 'd') playerX += 4;  
    else if (lastDirection == 'a') playerX -= 4;  
  }

  playerX = constrain(playerX, 0, 8 * 256 - 45);
  playerY = constrain(playerY, 0, 5 * 256 - 45);
  camX = constrain(playerX - GAME_W / 2 + 22, 0, max(0, 8 * 256 - GAME_W));
  camY = constrain(playerY - GAME_H / 2 + 22, 0, max(0, 5 * 256 - GAME_H));

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
  
  // NPC dentro del mundo (antes del popMatrix)
  image(npcSprite, npcWorldX, npcWorldY, 30, 39);
  popMatrix();
  
  // Draw player
  if (!colisionNPC) updatePlayer();
  drawPlayer();
  
  if (colisionNPC) {
  dialogoVaris = true;
  lastDirection = ' ';
}
  if (tutorialTimer > 0) {
  tutorialTimer--;
  drawDialogBox(40, GAME_H - 50, GAME_W - 80, 30);
  fill(DARK);
  textAlign(CENTER, CENTER);
  textSize(10);
  text("Habla con tu mejor amigo Varis", GAME_W / 2, GAME_H - 35);
}
if (dialogoVaris) {
  // Caja nombre
  fill(BLUE_DARK);
  rect(40, GAME_H - 90, 70, 18, 3);
  fill(CREAM);
  textAlign(LEFT, CENTER);
  textSize(9);
  text("Varis", 50, GAME_H - 81);
  
  // Caja dialogo
  drawDialogBox(30, GAME_H - 72, GAME_W - 60, 60);
  fill(DARK);
  textAlign(LEFT, TOP);
  textSize(9);
  text("Tiempo sin verte, Clavicular. Sé que eres\nnuevo en Mogwarts, así que conjuré un\ncompañero mágico para ti. Conózcanse,\ntengo que irme a resolver unos asuntos.", 44, GAME_H - 62);
  
  // Instruccion
  fill(GRAY_MED);
  textAlign(RIGHT, BOTTOM);
  textSize(8);
  text("Click para continuar", GAME_W - 38, GAME_H - 16);
}
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