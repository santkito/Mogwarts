// screen6.pde - Boss fight screen

boolean screen6Initialized = false;

PImage screen6Jefe;
PImage screen6Dominio;
PImage[] screen6MessageImages;
PImage screen6EImg;

// E key press effect
boolean screen6EPressed = false;
int screen6EPressedTimer = 0;
int screen6EPressedDuration = 40;

// R key report explosion effect
boolean screen6RExplosion = false;
float screen6RExplosionScale = 0;
float screen6RExplosionAlpha = 255;
float screen6RExplosionX, screen6RExplosionY;
int screen6RExplosionTimer = 0;
int screen6RExplosionDuration = 70;

float screen6PlayerX;
float screen6PlayerY;

// Movement controls
boolean screen6WPressed = false;
boolean screen6SPressed = false;
boolean screen6APressed = false;
boolean screen6DPressed = false;
char screen6LastDirection = ' ';

boolean screen6MostrarImagen = false;
float screen6AlphaFade = 0;

boolean screen6GameStarted = false;
boolean screen6GamePaused = false;

int screen6NumCirculos = 12;
float screen6Separacion = 70;
float screen6Radio = 0;
float screen6Velocidad = 10;

// Game Variables
ArrayList<Message> screen6Messages;
int screen6WellBeing = 100;
int screen6Score = 0; // Reset score
int screen6BullCount = 0;
int screen6ConsecutiveBullying = 0;
int screen6TotalMessages = 0;

String[][] screen6Frases = {
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

void setupScreen6() {
  screen6Dominio = loadImage("dominio.jpeg");
  if (swscreen3 == 3) {
    screen6Jefe = loadImage("jefe2.png");
  } else if (swscreen3 == 4) {
    screen6Jefe = loadImage("jefe3.png");
  } else if (swscreen3 == 5) {
    screen6Jefe = loadImage("jefe4.png");
  } else {
    screen6Jefe = loadImage("imagenesjefes/jefe1.png");
  }
  
  screen6MessageImages = new PImage[3];
  screen6MessageImages[0] = loadImage("m0.png"); // positivo
  screen6MessageImages[1] = loadImage("m1.png"); // neutro
  screen6MessageImages[2] = loadImage("m2.png"); // bullying
  screen6EImg = loadImage("E.png");
  
  // Reset animation states
  screen6EPressed = false;
  screen6EPressedTimer = 0;
  screen6RExplosion = false;
  screen6RExplosionScale = 0;
  screen6RExplosionAlpha = 255;
  screen6RExplosionTimer = 0;
  
  screen6PlayerX = width / 2;
  screen6PlayerY = height / 2;
  facingDirection = 'd';

  screen6MostrarImagen = false;
  screen6AlphaFade = 0;
  screen6GameStarted = false;
  screen6GamePaused = false;

  // Initialize game
  screen6Messages = new ArrayList<Message>();
  screen6WellBeing = 100;
  screen6Score = 0; // Reset score
  screen6BullCount = 0;
  screen6ConsecutiveBullying = 0;
  screen6TotalMessages = 0;
}

void drawScreen6() {
  if (!screen6Initialized) {
    setupScreen6();
    screen6Initialized = true;
  }
  background(5, 6, 12);

  if (!screen6MostrarImagen) {
    translate(width/2, height/2);
    for (int i = 0; i < screen6NumCirculos; i++) {
      float r = screen6Radio - i * screen6Separacion;
      if (r > 0) {
        float t = frameCount * 0.03 + i * 0.4;
        float base = map(i, 0, screen6NumCirculos, 80, 5);
        float azul = base + 10 * sin(t + 2.0);
        float rojo = base * 0.6 + 5 * sin(t);
        float verde = base * 0.4;
        
        if (i == screen6NumCirculos - 1) {
          fill(2, 2, 5);
        } else {
          fill(rojo, verde, azul);
        }
        ellipse(0, 0, r, r);
      }
    }
    
    imageMode(CENTER);
    if (screen6Jefe != null) {
      float scaleFactor = 0.4;
      image(screen6Jefe, 0, 0, screen6Jefe.width * scaleFactor, screen6Jefe.height * scaleFactor);
    }
    imageMode(CORNER);
    screen6Radio += screen6Velocidad;
    
    if (screen6Radio > width * 1.3) {
      screen6MostrarImagen = true;
    }
    
  } else if (!screen6GameStarted) {
    tint(255, screen6AlphaFade);
    image(screen6Dominio, 0, 0, width, height);
    noTint();

    if (screen6AlphaFade < 255) {
      if (screen6Jefe != null) {
        imageMode(CENTER);
        float scaleFactor = 0.4;
        tint(255, 255 - screen6AlphaFade);
        image(screen6Jefe, width/2, height/2, screen6Jefe.width * scaleFactor, screen6Jefe.height * scaleFactor);
        imageMode(CORNER);
        noTint();
      }
      screen6AlphaFade += 18;
    } else {
      screen6GameStarted = true;
    }
    
  } else {
    // GAME SCREEN
    image(screen6Dominio, 0, 0, width, height);
    
    // Generar nuevos mensajes
    if (frameCount % 60 == 0 && screen6Messages.size() < 8) {
      int type = int(random(3));
      screen6Messages.add(new Message(type));
      screen6TotalMessages++;
    }
    
    // Actualizar y dibujar mensajes
    for (int i = screen6Messages.size() - 1; i >= 0; i--) {
      Message m = screen6Messages.get(i);
      m.update();
      m.display();
      
      // Checar si el mensaje alcanzó al jugador
      if (m.checkCollision(screen6PlayerX, screen6PlayerY)) {
        if (m.type == 2) { // bullying
          screen6WellBeing = max(0, screen6WellBeing - 10);
          screen6ConsecutiveBullying++;
          screen6BullCount++;
        } else if (m.type == 0) { // positivo
          screen6WellBeing = min(100, screen6WellBeing + 5);
          screen6Score += 10;
          screen6ConsecutiveBullying = 0;
        } else { // neutral
          screen6ConsecutiveBullying = 0;
        }
        screen6Messages.remove(i);
      }
    }
    
    // Manejar movimiento
    if (screen6LastDirection == 'w') screen6PlayerY -= 15;
    if (screen6LastDirection == 's') screen6PlayerY += 15;
    if (screen6LastDirection == 'a') screen6PlayerX -= 15;
    if (screen6LastDirection == 'd') screen6PlayerX += 15;
    
    screen6PlayerX = constrain(screen6PlayerX, 45, width - 45);
    screen6PlayerY = constrain(screen6PlayerY, 45, height - 150);
    
    // Actualizar animacion del sprite
    lastDirection = screen6LastDirection;
    if (screen6LastDirection != ' ') {
      updatePlayer();
    }
    
    // Dibujar jefe1 centrado arriba
    imageMode(CENTER);
    if (screen6Jefe != null) {
      image(screen6Jefe, width/2, height/2 - 200);
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
      image(frame, screen6PlayerX, screen6PlayerY, drawW, drawH);
    }
    imageMode(CORNER);
    
    // === E key press effect: E.png centrada sobre el jugador ===
    if (screen6EPressed && screen6EImg != null) {
      screen6EPressedTimer++;
      float eAlpha = map(screen6EPressedTimer, 0, screen6EPressedDuration, 255, 0);
      float eSize = 240;
      imageMode(CENTER);
      tint(255, eAlpha);
      image(screen6EImg, screen6PlayerX, screen6PlayerY, eSize, eSize);
      noTint();
      imageMode(CORNER);
      if (screen6EPressedTimer >= screen6EPressedDuration) {
        screen6EPressed = false;
        screen6EPressedTimer = 0;
      }
    }
    
    // === R explosion effect: E.png haciendose grande desde el jugador ===
    if (screen6RExplosion && screen6EImg != null) {
      screen6RExplosionTimer++;
      // Escala: empieza en 0.3, crece hasta 5
      screen6RExplosionScale = map(screen6RExplosionTimer, 0, screen6RExplosionDuration, 60, 1200);
      // Alpha: se mantiene y luego desvanece en el ultimo tercio
      if (screen6RExplosionTimer < screen6RExplosionDuration * 0.6) {
        screen6RExplosionAlpha = 255;
      } else {
        screen6RExplosionAlpha = map(screen6RExplosionTimer, screen6RExplosionDuration * 0.6, screen6RExplosionDuration, 255, 0);
      }
      imageMode(CENTER);
      tint(255, screen6RExplosionAlpha);
      image(screen6EImg, screen6RExplosionX, screen6RExplosionY, screen6RExplosionScale, screen6RExplosionScale);
      noTint();
      imageMode(CORNER);
      if (screen6RExplosionTimer >= screen6RExplosionDuration) {
        screen6RExplosion = false;
        screen6RExplosionTimer = 0;
        screen6RExplosionScale = 0;
      }
    }
    
    // Dibujar barra de bien-estar
    drawWellBeingBarScreen6();
    
    // Dibujar puntuación y contadores
    fill(CREAM);
    textAlign(LEFT, TOP);
    textSize(24);
    text("Score: " + screen6Score, 20, 20);
    text("Well-Being: " + screen6WellBeing, 20, 60);
    if (screen6BullCount >= 3) {
      fill(255, 100, 100);
      text("BULLYING DETECTED - Press R to Report!", 20, 100);
    }
    
    // Dibujar controles
    fill(GRAY_MED);
    textAlign(LEFT, TOP);
    textSize(16);
    text("E = Block | Q = Capture Positive | R = Report | P = Pause", 20, height - 60);

    if (screen6Score >= 150) {
      fill(CREAM);
      textAlign(CENTER, CENTER);
      textSize(24);
      text("Presiona ENTER para continuar", width / 2, height - 100);
    }
    
    if (screen6GamePaused) {
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

void drawWellBeingBarScreen6() {
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
  float fillWidth = map(screen6WellBeing, 0, 100, 0, barWidth - 4);
  if (screen6WellBeing > 50) fill(100, 200, 100);
  else if (screen6WellBeing > 25) fill(255, 200, 100);
  else fill(200, 100, 100);
  
  noStroke();
  rect(barX + 2, barY + 2, fillWidth, barHeight - 4, 6);
  
  // Text
  fill(CREAM);
  textAlign(CENTER, CENTER);
  textSize(20);
  text(screen6WellBeing + "/100", width/2, barY + 15);
}

void screen6KeyPressed() {
  if (!screen6GameStarted) return;
  
  char key_lower = Character.toLowerCase(key);
  
  if (keyCode == ENTER && screen6Score >= 150) {
    screen6Score = 0;
    screen6Initialized = false;
    if (swscreen3 == 2 || swscreen3 < 2) {
      // Venía de casa1 (jefe1) → ir a casa2 con jefe2
      screen = 3;
      swscreen3 = 3;
    } else if (swscreen3 == 3) {
      // Venía de casa2 (jefe2) → ir a casa3 con jefe3
      screen = 3;
      swscreen3 = 4;
    } else if (swscreen3 == 4) {
      // Venía de casa3 (jefe3) → ir a casa4 con jefe4
      screen = 3;
      swscreen3 = 5;
    } else {
      screen = 3;
    }
    paused = false;
    return;
  }
  
  if (key_lower == 'p') {
    screen6GamePaused = !screen6GamePaused;
  }
  
  if (screen6GamePaused) return;
  
  // Movement
  if (key_lower == 'w') { screen6WPressed = true; screen6LastDirection = 'w'; lastDirection = 'w'; }
  if (key_lower == 's') { screen6SPressed = true; screen6LastDirection = 's'; lastDirection = 's'; }
  if (key_lower == 'a') { screen6APressed = true; screen6LastDirection = 'a'; lastDirection = 'a'; }
  if (key_lower == 'd') { screen6DPressed = true; screen6LastDirection = 'd'; lastDirection = 'd'; }
  
  if (key_lower == 'e') {
    // Mostrar E.png centrada sobre el jugador
    screen6EPressed = true;
    screen6EPressedTimer = 0;
    
    // Block message - find closest message to player
    if (screen6Messages.size() > 0) {
      float minDist = Float.MAX_VALUE;
      int closestIdx = -1;
      
      for (int i = 0; i < screen6Messages.size(); i++) {
        Message m = screen6Messages.get(i);
        float d = dist(m.x, m.y, screen6PlayerX, screen6PlayerY);
        if (d < minDist) {
          minDist = d;
          closestIdx = i;
        }
      }
      
      if (closestIdx != -1) {
        Message m = screen6Messages.get(closestIdx);
        if (m.type == 0) { // positivo
          screen6WellBeing = max(0, screen6WellBeing - 15);
          screen6Score = max(0, screen6Score - 20);
        }
        screen6Messages.remove(closestIdx);
      }
    }
  }
  
  if (key_lower == 'q') {
    // Capture positive message
    if (screen6Messages.size() > 0) {
      float minDist = Float.MAX_VALUE;
      int closestIdx = -1;
      
      for (int i = 0; i < screen6Messages.size(); i++) {
        Message m = screen6Messages.get(i);
        if (m.type == 0) { // only positive
          float d = dist(m.x, m.y, screen6PlayerX, screen6PlayerY);
          if (d < minDist) {
            minDist = d;
            closestIdx = i;
          }
        }
      }
      
      if (closestIdx != -1) {
        Message m = screen6Messages.get(closestIdx);
        screen6WellBeing = min(100, screen6WellBeing + 15);
        screen6Score += 25;
        screen6Messages.remove(closestIdx);
      }
    }
  }
  
  if (key_lower == 'r' && screen6BullCount >= 3) {
    // Report bullying
    screen6RExplosion = true;
    screen6RExplosionTimer = 0;
    screen6RExplosionX = screen6PlayerX;
    screen6RExplosionY = screen6PlayerY;
    screen6Score += 100;
    screen6WellBeing = min(100, screen6WellBeing + 20);
    screen6BullCount = 0;
  }
}

void screen6KeyReleased() {
  char key_lower = Character.toLowerCase(key);
  
  if (key_lower == 'w') screen6WPressed = false;
  if (key_lower == 's') screen6SPressed = false;
  if (key_lower == 'a') screen6APressed = false;
  if (key_lower == 'd') screen6DPressed = false;
  
  // Set next direction
  if (screen6WPressed) screen6LastDirection = 'w';
  else if (screen6SPressed) screen6LastDirection = 's';
  else if (screen6APressed) screen6LastDirection = 'a';
  else if (screen6DPressed) screen6LastDirection = 'd';
  else screen6LastDirection = ' ';
}