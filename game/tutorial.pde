PImage dominio;
PImage hedwigVol;
PImage hedwigL;
PImage gameplayImg;

float tutorialPlayerX;
float tutorialPlayerY;

float radio = 0;
float velocidad = 10;

boolean mostrarImagen = false;
float alphaFade = 0;
float hedwigAlpha = 255;

boolean mostrarDialogo = false;
boolean mostrarGameplayImage = false;
boolean tutorialMovementEnabled = false;
boolean gameplayClicked = false;
int dialogoIndex = 0;
String[] dialogos;
String[] dialogoLines;

int numCirculos = 12;
float separacion = 70;

void setupTutorial() {
  dominio = loadImage("dominio.jpeg");
  hedwigVol = loadImage("hedwigVol.png");
  hedwigL = loadImage("hedwigL.png");
  gameplayImg = loadImage("gameplay.jpeg");
  tutorialPlayerX = width / 2;
  tutorialPlayerY = height / 2;
  facingDirection = 'd'; // Mirando hacia D inicialmente

  mostrarDialogo = false;
  mostrarGameplayImage = false;
  tutorialMovementEnabled = false;
  gameplayClicked = false;
  dialogoIndex = 0;

  dialogos = new String[]{
    "Ah… hola, muchacho Clav. Soy Hedwig. Bienvenido seas a mi dominio. Este es un rincón del reino de las sombras, donde te enseñaré, si es que aún tienes oídos para escuchar, a lidiar con todo aquello que habrá de ponerte a prueba en Mogwarts…",
    "Ah… muchacho… tendrás que enfrentarte a muchas personas que desean hacerte daño por ser tú mismo. Pero si sabes gestionarlo con sabiduría, podrás ir llenando tu barra de estado, y así aumentar tu poder mágico. De ese modo, alcanzarás posiciones cada vez más altas… y, con el tiempo, quizá llegues a ser presidente de Mogwarts…"
  };
  dialogoLines = wrapText(dialogos[dialogoIndex], 75);
}

void drawTutorial() {

  background(5, 6, 12);

  if (!mostrarImagen) {
    translate(width/2, height/2);

    for (int i = 0; i < numCirculos; i++) {
      float r = radio - i * separacion;

      if (r > 0) {

        float t = frameCount * 0.03 + i * 0.4;

        // SOLO GAMAS OSCURAS
        // cuanto más externo el círculo → más oscuro

        float base = map(i, 0, numCirculos, 80, 5);

        float azul = base + 10 * sin(t + 2.0);
        float rojo = base * 0.6 + 5 * sin(t);
        float verde = base * 0.4;

        // el último círculo (más externo) casi negro puro
        if (i == numCirculos - 1) {
          fill(2, 2, 5);
        } else {
          fill(rojo, verde, azul);
        }

        ellipse(0, 0, r, r);
      }
    }

    imageMode(CENTER);
    if (hedwigVol != null) {
      float scaleFactor = 0.4;
      image(hedwigVol, 0, 0, hedwigVol.width * scaleFactor, hedwigVol.height * scaleFactor);
    }
    imageMode(CORNER);

    radio += velocidad;

    // transición más rápida también
    if (radio > width * 1.3) {
      mostrarImagen = true;
    }

  } else {
    tint(255, alphaFade);
    image(dominio, 0, 0, width, height);
    noTint();

    if (alphaFade < 255) {
      if (hedwigVol != null) {
        imageMode(CENTER);
        float scaleFactor = 0.4;
        tint(255, 255 - alphaFade);
        image(hedwigVol, width/2, height/2, hedwigVol.width * scaleFactor, hedwigVol.height * scaleFactor);
        imageMode(CORNER);
        noTint();
      }
      alphaFade += 18; // fade MÁS RÁPIDO
    } else {
      if (mostrarGameplayImage) {
        if (gameplayImg != null) {
          image(gameplayImg, 0, 0, width, height);
        }
        fill(GRAY_MED);
        textAlign(CENTER, BOTTOM);
        textSize(24);
        text("Click para continuar", width / 2, height - 40);
        return;
      }

      if (!mostrarDialogo && !tutorialMovementEnabled) {
        mostrarDialogo = true;
      }
      if (tutorialMovementEnabled) {
        if (lastDirection == 'w') tutorialPlayerY -= 20;
        else if (lastDirection == 's') tutorialPlayerY += 20;
        else if (lastDirection == 'a') tutorialPlayerX -= 20;
        else if (lastDirection == 'd') tutorialPlayerX += 20;

        tutorialPlayerX = constrain(tutorialPlayerX, 45, width - 45);
        tutorialPlayerY = constrain(tutorialPlayerY, 45, height - 45);

        if (lastDirection != ' ') {
          facingDirection = lastDirection;
        }
        updatePlayer();
      }

      imageMode(CENTER);
      float scaleFactor = 0.2;
      if (hedwigL != null && !tutorialMovementEnabled) {
        image(hedwigL, width/2 + 200, height/2, hedwigL.width * scaleFactor, hedwigL.height * scaleFactor);
      }
      if (spriteSheet != null) {
        int srcX = spriteCol * 45;
        int srcY = spriteRow * 45;
        PImage frame = spriteSheet.get(srcX, srcY, 45, 45);
        float drawW = 45 * 2;
        float drawH = 45 * 2;
        image(frame, tutorialPlayerX, tutorialPlayerY, drawW, drawH);
      }
      imageMode(CORNER);

      // Dibujar diálogo
      if (mostrarDialogo) {
        // Caja nombre
        fill(BLUE_DARK);
        rect(160, height - 480, 320, 72, 12);
        fill(CREAM);
        textAlign(LEFT, CENTER);
        textSize(36);
        text("Hedwig", 200, height - 444);

        // Caja diálogo
        drawDialogBox(120, height - 408, width - 240, 360);
        fill(DARK);
        textAlign(LEFT, TOP);
        textSize(36);
        for (int i = 0; i < dialogoLines.length; i++) {
          text(dialogoLines[i], 176, height - 368 + i * 60);
        }

        // Instrucción
        fill(GRAY_MED);
        textAlign(RIGHT, BOTTOM);
        textSize(32);
        text("Click para continuar", width - 152, height - 64);
      }
    }
  }
}