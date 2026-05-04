PImage dominio;
PImage hedwigVol;
PImage hedwigL;
PImage hedwigF;
PImage gameplayImg;
PImage[] messageImages;
PImage eImg; // E.png

// E key press effect
boolean ePressed = false;
int ePressedTimer = 0;
int ePressedDuration = 40; // frames que permanece visible

// R key report explosion effect
boolean rExplosion = false;
float rExplosionScale = 0;
float rExplosionAlpha = 255;
float rExplosionX, rExplosionY;
int rExplosionTimer = 0;
int rExplosionDuration = 70; // frames de la animacion

float tutorialPlayerX;
float tutorialPlayerY;

// Movement controls
boolean tutorialWPressed = false;
boolean tutorialSPressed = false;
boolean tutorialAPressed = false;
boolean tutorialDPressed = false;
char tutorialLastDirection = ' ';

float radio = 0;
float velocidad = 10;

boolean mostrarImagen = false;
float alphaFade = 0;
float hedwigAlpha = 255;

boolean mostrarDialogo = false;
boolean mostrarGameplayImage = false;
boolean tutorialMovementEnabled = false;
boolean gameplayClicked = false;
boolean gameStarted = false;
boolean gamePaused = false;

int dialogoIndex = 0;
String[] dialogos;
String[] dialogoLines;

int numCirculos = 12;
float separacion = 70;

// Game Variables
ArrayList<Message> messages;
int wellBeing = 100;
int score = 0;
int bullCount = 0;
int consecutiveBullying = 0;
int totalMessages = 0;

String[][] frases = {
    {
        "Me alegra mucho verte",
        "Estoy orgulloso de ti",
        "Puedes lograrlo",
        "Gracias por estar aquí",
        "Confío en ti",
        "Te ves muy bien hoy",
        "Aprecio lo que haces",
        "Eres importante para mí",
        "Todo va a salir bien",
        "Cuentas conmigo"
    },
    {
        "Hola, ¿cómo estás?",
        "¿Qué hiciste hoy?",
        "Nos vemos luego",
        "Pásame eso, por favor",
        "¿A qué hora es la reunión?",
        "Está bien",
        "De acuerdo",
        "Luego hablamos",
        "¿Dónde estás?",
        "Avísame cuando llegues"
    },
    {
        "No sirves para nada",
        "Todo lo haces mal",
        "Me decepcionas",
        "No me importas",
        "Cállate",
        "Eres un fracaso",
        "Ojalá no estuvieras aquí",
        "Siempre arruinas todo",
        "No quiero verte",
        "Nadie te quiere"
    }
};

// Clase para los mensajes flotantes
class Message {
  float x, y;
  float vx, vy;
  int type; // 0 = positivo, 1 = neutro, 2 = bullying
  String text;
  float radius = 40;
  boolean blocked = false;
  int createdFrame;
  
  Message(int t) {
    type = t;
    text = frases[type][int(random(frases[type].length))];
    x = random(80, width - 80);
    y = random(80, height - 200);
    vx = random(-2, 2);
    vy = random(1, 3);
    createdFrame = frameCount;
  }
  
  // Constructor rapido para screen6
  Message(int t, boolean fast) {
    type = t;
    // screen6 usa sus propias frases
    text = screen6Frases[type][int(random(screen6Frases[type].length))];
    x = random(80, width - 80);
    y = random(80, height - 200);
    float speed = random(5, 12);
    float angle = random(TWO_PI);
    vx = cos(angle) * speed;
    vy = sin(angle) * speed;
    createdFrame = frameCount;
  }
  
  void update() {
    if (!blocked && !gamePaused && !screen6GamePaused) {
      x += vx;
      y += vy;
      
      // Rebotar en los bordes
      if (x < radius) { x = radius; vx *= -1; }
      if (x > width - radius) { x = width - radius; vx *= -1; }
      if (y < radius) { y = radius; vy *= -1; }
      if (y > height - 200) { y = height - 200; vy *= -1; }
    }
  }
  
  void display() {
    if (messageImages[type] != null) {
      imageMode(CENTER);
      
      // Mensajes en blanco
      tint(255, 255, 255);
      image(messageImages[type], x, y, 80, 80);
      noTint();
      imageMode(CORNER);
      
      // Dibujar texto centrado
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(14);
      text(text, x, y);
    }
  }
  
  boolean checkCollision(float px, float py) {
    float d = dist(x, y, px, py);
    return d < radius + 25;
  }
}

void setupTutorial() {
  dominio = loadImage("dominio.jpeg");
  hedwigVol = loadImage("hedwigVol.png");
  hedwigL = loadImage("hedwigL.png");
  hedwigF = loadImage("hedwigF.png");
  gameplayImg = loadImage("gameplay.jpeg");
  
  messageImages = new PImage[3];
  messageImages[0] = loadImage("m0.png"); // positivo
  messageImages[1] = loadImage("m1.png"); // neutro
  messageImages[2] = loadImage("m2.png"); // bullying
  eImg = loadImage("E.png");
  
  // Reset animation states
  ePressed = false;
  ePressedTimer = 0;
  rExplosion = false;
  rExplosionScale = 0;
  rExplosionAlpha = 255;
  rExplosionTimer = 0;
  
  tutorialPlayerX = width / 2;
  tutorialPlayerY = height / 2;
  facingDirection = 'd';

  mostrarDialogo = false;
  mostrarGameplayImage = false;
  tutorialMovementEnabled = false;
  gameplayClicked = false;
  gameStarted = false;
  gamePaused = false;
  dialogoIndex = 0;

  dialogos = new String[]{
    "Ah… hola, muchacho Clav. Soy Hedwig. Bienvenido seas a mi dominio. Este es un rincón del reino de las sombras, donde te enseñaré, si es que aún tienes oídos para escuchar, a lidiar con todo aquello que habrá de ponerte a prueba en Mogwarts…",
    "Ah… muchacho… tendrás que enfrentarte a muchas personas que desean hacerte daño por ser tú mismo. Pero si sabes gestionarlo con sabiduría, podrás ir llenando tu barra de estado, y así aumentar tu poder mágico. De ese modo, alcanzarás posiciones cada vez más altas… y, con el tiempo, quizá llegues a ser presidente de Mogwarts…"
  };
  dialogoLines = wrapText(dialogos[dialogoIndex], 75);
  
  // Initialize game
  messages = new ArrayList<Message>();
  wellBeing = 100;
  score = 0;
  bullCount = 0;
  consecutiveBullying = 0;
  totalMessages = 0;
}

void drawTutorial() {
  background(5, 6, 12);

  if (!mostrarImagen) {
    translate(width/2, height/2);
    for (int i = 0; i < numCirculos; i++) {
      float r = radio - i * separacion;
      if (r > 0) {
        float t = frameCount * 0.03 + i * 0.4;
        float base = map(i, 0, numCirculos, 80, 5);
        float azul = base + 10 * sin(t + 2.0);
        float rojo = base * 0.6 + 5 * sin(t);
        float verde = base * 0.4;
        
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
    
    if (radio > width * 1.3) {
      mostrarImagen = true;
    }
    
  } else if (!gameStarted) {
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
      alphaFade += 18;
    } else {
      if (!mostrarDialogo) {
        mostrarDialogo = true;
      }
      
      // Dibujar diálogo
      if (mostrarDialogo) {
        fill(BLUE_DARK);
        rect(160, height - 480, 320, 72, 12);
        fill(CREAM);
        textAlign(LEFT, CENTER);
        textSize(36);
        text("Hedwig", 200, height - 444);

        drawDialogBox(120, height - 408, width - 240, 360);
        fill(DARK);
        textAlign(LEFT, TOP);
        textSize(36);
        for (int i = 0; i < dialogoLines.length; i++) {
          text(dialogoLines[i], 176, height - 368 + i * 60);
        }

        fill(GRAY_MED);
        textAlign(RIGHT, BOTTOM);
        textSize(32);
        text("Click para continuar", width - 152, height - 64);
      }
    }
    
  } else {
    // GAME SCREEN
    image(dominio, 0, 0, width, height);
    
    // Generar nuevos mensajes
    if (frameCount % 60 == 0 && messages.size() < 8) {
      int type = int(random(3));
      messages.add(new Message(type));
      totalMessages++;
    }
    
    // Actualizar y dibujar mensajes
    for (int i = messages.size() - 1; i >= 0; i--) {
      Message m = messages.get(i);
      m.update();
      m.display();
      
      // Checar si el mensaje alcanzó al jugador
      if (m.checkCollision(tutorialPlayerX, tutorialPlayerY)) {
        if (m.type == 2) { // bullying
          wellBeing = max(0, wellBeing - 10);
          consecutiveBullying++;
          bullCount++;
        } else if (m.type == 0) { // positivo
          wellBeing = min(100, wellBeing + 5);
          score += 10;
          consecutiveBullying = 0;
        } else { // neutral
          consecutiveBullying = 0;
        }
        messages.remove(i);
      }
    }
    
    // Manejar movimiento
    if (tutorialLastDirection == 'w') tutorialPlayerY -= 15;
    if (tutorialLastDirection == 's') tutorialPlayerY += 15;
    if (tutorialLastDirection == 'a') tutorialPlayerX -= 15;
    if (tutorialLastDirection == 'd') tutorialPlayerX += 15;
    
    tutorialPlayerX = constrain(tutorialPlayerX, 45, width - 45);
    tutorialPlayerY = constrain(tutorialPlayerY, 45, height - 150);
    
    // Actualizar animacion del sprite
    lastDirection = tutorialLastDirection;
    if (tutorialLastDirection != ' ') {
      updatePlayer();
    }
    
    // Dibujar hedwigF centrado arriba
    imageMode(CENTER);
    if (hedwigF != null) {
      image(hedwigF, width/2, height/2 - 200);
    }
    imageMode(CORNER);
    
    // Dibujar avatar movible con sprites
    imageMode(CENTER);
    if (spriteSheet != null) {
      int srcX = spriteCol * 45;
      int srcY = spriteRow * 45;
      PImage frame = spriteSheet.get(srcX, srcY, 45, 45);
      float drawW = 45 * 2;
      float drawH = 45 * 2;
      image(frame, tutorialPlayerX, tutorialPlayerY, drawW, drawH);
    }
    imageMode(CORNER);
    
    // === E key press effect: E.png centrada sobre el jugador ===
    if (ePressed && eImg != null) {
      ePressedTimer++;
      float eAlpha = map(ePressedTimer, 0, ePressedDuration, 255, 0);
      float eSize = 240;
      imageMode(CENTER);
      tint(255, eAlpha);
      image(eImg, tutorialPlayerX, tutorialPlayerY, eSize, eSize);
      noTint();
      imageMode(CORNER);
      if (ePressedTimer >= ePressedDuration) {
        ePressed = false;
        ePressedTimer = 0;
      }
    }
    
    // === R explosion effect: E.png haciendose grande desde el jugador ===
    if (rExplosion && eImg != null) {
      rExplosionTimer++;
      // Escala: empieza en 0.3, crece hasta 5
      rExplosionScale = map(rExplosionTimer, 0, rExplosionDuration, 60, 1200);
      // Alpha: se mantiene y luego desvanece en el ultimo tercio
      if (rExplosionTimer < rExplosionDuration * 0.6) {
        rExplosionAlpha = 255;
      } else {
        rExplosionAlpha = map(rExplosionTimer, rExplosionDuration * 0.6, rExplosionDuration, 255, 0);
      }
      imageMode(CENTER);
      tint(255, rExplosionAlpha);
      image(eImg, rExplosionX, rExplosionY, rExplosionScale, rExplosionScale);
      noTint();
      imageMode(CORNER);
      if (rExplosionTimer >= rExplosionDuration) {
        rExplosion = false;
        rExplosionTimer = 0;
        rExplosionScale = 0;
      }
    }
    
    // Dibujar barra de bien-estar
    drawWellBeingBar();
    
    // Dibujar puntuación y contadores
    fill(CREAM);
    textAlign(LEFT, TOP);
    textSize(24);
    text("Score: " + score, 20, 20);
    text("Well-Being: " + wellBeing, 20, 60);
    if (bullCount >= 3) {
      fill(255, 100, 100);
      text("BULLYING DETECTED - Press R to Report!", 20, 100);
    }
    
    // Dibujar controles
    fill(GRAY_MED);
    textAlign(LEFT, TOP);
    textSize(16);
    text("E = Block | Q = Capture Positive | R = Report | P = Pause", 20, height - 60);

    if (score >= 150) {
      fill(CREAM);
      textAlign(CENTER, CENTER);
      textSize(24);
      text("Presiona ENTER para continuar", width / 2, height - 100);
    }
    
    if (gamePaused) {
      fill(0, 0, 0, 200);
      rect(0, 0, width, height);
      fill(CREAM);
      textAlign(CENTER, CENTER);
      textSize(48);
      text("PAUSED", width/2, height/2);
      textSize(24);
      text("Press P to Resume", width/2, height/2 + 60);
    }
  }
}

void drawWellBeingBar() {
  float barX = width / 2 - 150;
  float barY = height - 80;
  float barWidth = 300;
  float barHeight = 30;
  
  // Background
  fill(50);
  stroke(200);
  strokeWeight(2);
  rect(barX, barY, barWidth, barHeight, 8);
  
  // Health fill
  float fillWidth = map(wellBeing, 0, 100, 0, barWidth - 4);
  if (wellBeing > 50) fill(100, 200, 100);
  else if (wellBeing > 25) fill(255, 200, 100);
  else fill(200, 100, 100);
  
  noStroke();
  rect(barX + 2, barY + 2, fillWidth, barHeight - 4, 6);
  
  // Text
  fill(CREAM);
  textAlign(CENTER, CENTER);
  textSize(20);
  text(wellBeing + "/100", width/2, barY + 15);
}