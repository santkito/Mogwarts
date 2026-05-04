// player.pde

PImage spriteSheet;
int spriteCol = 1;      // 0=izq, 1=centro, 2=der
int spriteRow = 0;      // 0=S, 1=W, 2=A, 3=D
int animTimer = 0;
int animSpeed = 8;      // frames entre columnas

void setupPlayer() {
  spriteSheet = loadImage("protasprites.png");
}

void updatePlayer() {
  if (lastDirection == 's') spriteRow = 0;
  else if (lastDirection == 'w') spriteRow = 3;  
  else if (lastDirection == 'a') spriteRow = 1;  // cambia hasta que aparezca
  else if (lastDirection == 'd') spriteRow = 2;  // cambia hasta que aparezca

  if (lastDirection == ' ') {
    // Quieto: columna central
    spriteCol = 1;
    animTimer = 0;
  } else {
    // Animando: alterna entre columnas 0, 1 y 2
    animTimer++;
    if (animTimer >= animSpeed) {
      animTimer = 0;
      spriteCol = (spriteCol + 1) % 3;
    }
  }
}


void drawPlayer() {
  int srcX = spriteCol * 45;
  int srcY = spriteRow * 45;

  PImage frame = spriteSheet.get(srcX, srcY, 45, 45);

  if (facingDirection == 'w') {
    pushMatrix();
    translate(224, 144 + 45);
    scale(1, -1);
    image(frame, 0, 0, 45, 45);
    popMatrix();
  } else if (facingDirection == 'a' || facingDirection == 'd') {
    pushMatrix();
    translate(224 + 45, 144);
    scale(-1, 1);
    image(frame, 0, 0, 45, 45);
    popMatrix();
  } else {
    image(frame, 224, 144, 45, 45);
  }
}
