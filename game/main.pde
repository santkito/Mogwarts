// ===== MOGWARTS PSL SCALE - INTRO SCREENS =====
// Estilo Pokemon Fire Red

PFont pixelFont;
PFont pixelFontSmall;
PFont pixelFontTitle;

PImage[][] tiles;

int screen = 0; // 0=title, 1=controls, 2=context, 3=game, 4=loading
float blinkTimer = 0;
boolean showBlink = true;
int contextScroll = 0;
int contextTarget = 0;

// Colores Fire Red palette
color CREAM = color(248, 248, 208);
color DARK = color(40, 40, 40);
color RED_MAIN = color(200, 40, 40);
color RED_LIGHT = color(240, 80, 80);
color BLUE_DARK = color(24, 56, 144);
color BLUE_MID = color(56, 104, 216);
color BLUE_LIGHT = color(136, 168, 248);
color GOLD = color(232, 192, 0);
color WHITE = color(255, 255, 255);
color SHADOW = color(16, 16, 16);
color GRAY_LIGHT = color(200, 200, 200);
color GRAY_MED = color(140, 140, 140);

// Animacion titulo
float titleY = 0;
float titlePulse = 0;
boolean titleReady = false;
int titleAnim = 0; // frames

// Estrellas de fondo
float[] starX = new float[80];
float[] starY = new float[80];
float[] starBright = new float[80];
float[] starSpeed = new float[80];

// Context page
String[] contextLines;
float contextFade = 0;

// Controls page  
float controlsFade = 0;

// Transicion
float fadeAlpha = 255;
boolean fadingIn = true;
boolean fadingOut = false;
int nextScreen = -1;

// Loading screen variables
float loadingProgress = 0;
int loadingDots = 0;
int loadingDotsTimer = 0;
int totalImages = 8 * 5;
int loadedImages = 0;

float SCALE_FACTOR = 1.0;
int GAME_W = 480;
int GAME_H = 320;

void setup() {
  fullScreen();
  frameRate(60);
  // Calcular el zoom para que 480x320 llene la pantalla (manteniendo proporciones)
  SCALE_FACTOR = min((float)displayWidth / GAME_W, (float)displayHeight / GAME_H);
  textFont(createFont("Courier New Bold", 14));
  
  // Inicializar estrellas
  for (int i = 0; i < starX.length; i++) {
    starX[i] = random(width);
    starY[i] = random(height);
    starBright[i] = random(100, 255);
    starSpeed[i] = random(0.1, 0.4);
  }
  
  // Preparar texto de contexto
  String contextRaw = "En Mogwarts, la vida social funciona como un ranking invisible llamado PSL Scale, donde cada estudiante es evaluado por su frame, presencia y estatus.\n\nClavicular lleva años estudiando el sistema. Analiza rostros, compara estructuras óseas y calcula su posición en la jerarquía social. Según sus propias estimaciones, está cada vez más cerca de convertirse en un Chadlite.\n\nPero existe un nivel por encima de todos: las fraternidades. Y entre ellas, un nombre domina la cima del ranking.\n\nEl ASU Frat Leader.\n\nHoy, Clavicular está a punto de encontrarse cara a cara con él… y descubrir si su teoría sobre la jerarquía de Mogwarts era correcta.\n\nO si está a punto de ser brutalmente moggeado.";
  
  contextLines = wrapText(contextRaw, 44);

  setupGame();
  setupPlayer();
  tiles = new PImage[8][5];
  screen = 4; // Start with loading screen
  drawLoadingScreen(); // Draw initial loading screen to avoid gray screen
}

String[] wrapText(String txt, int maxChars) {
  String[] paragraphs = txt.split("\n");
  ArrayList<String> lines = new ArrayList<String>();
  
  for (String para : paragraphs) {
    if (para.equals("")) {
      lines.add("");
      continue;
    }
    String[] words = para.split(" ");
    String current = "";
    for (String word : words) {
      if ((current + word).length() > maxChars) {
        if (!current.equals("")) lines.add(current.trim());
        current = word + " ";
      } else {
        current += word + " ";
      }
    }
    if (!current.trim().equals("")) lines.add(current.trim());
  }
  return lines.toArray(new String[0]);
}

void draw() {
  background(0);
  // Centrar y escalar el canvas logico 480x320
  float offsetX = (width - GAME_W * SCALE_FACTOR) / 2;
  float offsetY = (height - GAME_H * SCALE_FACTOR) / 2;
  pushMatrix();
  translate(offsetX, offsetY);
  scale(SCALE_FACTOR);

  // Only clear with menu background on non-game screens
  if (screen != 3) {
    background(DARK);
    // Base animations apply only to UI screens
    blinkTimer += 0.04;
    if (blinkTimer > PI) {
      blinkTimer = 0;
      showBlink = !showBlink;
    }
    titlePulse += 0.05;
    // Scroll suave del contexto
    contextScroll += (contextTarget - contextScroll) * 0.15;
  }
  
  if (screen == 0) drawTitleScreen();
  else if (screen == 1) drawControlsScreen();
  else if (screen == 2) drawContextScreen();
  else if (screen == 3) drawGame();
  else if (screen == 4) drawLoadingScreen();
  
  // Fade overlay
  handleFade();
  
  popMatrix();
  titleAnim++;
}

// ===== PANTALLA 1: TITULO =====
void drawTitleScreen() {
  // Fondo degradado nocturno
  for (int y = 0; y < GAME_H; y++) {
    float t = (float)y / GAME_H;
    color c = lerpColor(color(8, 12, 48), color(24, 16, 56), t);
    stroke(c);
    line(0, y, GAME_W, y);
  }
  
  // Estrellas animadas
  noStroke();
  for (int i = 0; i < starX.length; i++) {
    starY[i] += starSpeed[i];
    if (starY[i] > GAME_H) starY[i] = 0;
    float b = starBright[i] * (0.5 + 0.5 * sin(frameCount * 0.03 + i));
    fill(b, b, b * 0.9, b);
    ellipse(starX[i], starY[i], 1.5, 1.5);
  }
  
  // Luna/planeta decorativo
  noStroke();
  fill(BLUE_DARK, 80);
  ellipse(GAME_W - 60, 55, 90, 90);
  fill(BLUE_MID, 120);
  ellipse(GAME_W - 55, 50, 75, 75);
  fill(BLUE_LIGHT, 60);
  ellipse(GAME_W - 65, 42, 50, 50);
  
  // Castillo silueta (simple, pixelado)
  drawCastle();
  
  // Panel titulo principal
  int panelW = 360;
  int panelH = 90;
  int panelX = (GAME_W - panelW) / 2;
  int panelY = 30;
  
  // Sombra panel
  fill(SHADOW, 160);
  rect(panelX + 4, panelY + 4, panelW, panelH, 4);
  
  // Panel borde dorado
  fill(GOLD);
  rect(panelX - 2, panelY - 2, panelW + 4, panelH + 4, 6);
  fill(BLUE_DARK);
  rect(panelX, panelY, panelW, panelH, 4);
  
  // Linea decorativa interior
  stroke(GOLD, 180);
  strokeWeight(1);
  line(panelX + 8, panelY + 8, panelX + panelW - 8, panelY + 8);
  line(panelX + 8, panelY + panelH - 8, panelX + panelW - 8, panelY + panelH - 8);
  noStroke();
  
  // Titulo "MOGWARTS"
  float pulse = sin(titlePulse) * 2;
  
  // Sombra texto
  fill(SHADOW);
  textAlign(CENTER, CENTER);
  textSize(28);
  text("MOGWARTS", GAME_W/2 + 2, panelY + 32 + 2);
  
  // Texto dorado
  fill(GOLD);
  textSize(28);
  text("MOGWARTS", GAME_W/2, panelY + 32);
  
  // Subtitulo
  fill(BLUE_LIGHT);
  textSize(11);
  text("PSL  SCALE  EDITION", GAME_W/2, panelY + 62);
  
  // Lineas decorativas
  fill(RED_MAIN);
  rect(panelX + 20, panelY + 45, panelW - 40, 2);
  
  // Personaje (ASCII art simple con shapes)
  drawCharacter(GAME_W/2, 205);
  
  // "CLICK EN CUALQUIER LADO"
  if (showBlink) {
    // Caja de texto estilo pokemon
    drawDialogBox(60, 262, 360, 42);
    fill(DARK);
    textAlign(CENTER, CENTER);
    textSize(12);
    text("▼  Click en cualquier lado  ▼", GAME_W/2, 283);
  } else {
    drawDialogBox(60, 262, 360, 42);
    fill(DARK);
    textAlign(CENTER, CENTER);
    textSize(12);
    text("   Click en cualquier lado   ", GAME_W/2, 283);
  }
  
  // Version
  fill(GRAY_MED);
  textSize(9);
  textAlign(LEFT, BOTTOM);
  text("v1.0  MOGWARTS", 8, GAME_H - 4);
  textAlign(CENTER, CENTER);
}

void drawCastle() {
  // Silueta castillo
  fill(color(15, 10, 35));
  noStroke();
  
  // Base
  rect(100, 230, 280, 60);
  
  // Torres
  rect(100, 195, 40, 50);
  rect(340, 195, 40, 50);
  rect(160, 210, 30, 40);
  rect(290, 210, 30, 40);
  rect(210, 200, 60, 50);
  
  // Almenas torres principales
  for (int i = 0; i < 5; i++) {
    rect(100 + i * 9, 188, 6, 10);
    rect(340 + i * 9, 188, 6, 10);
  }
  for (int i = 0; i < 4; i++) {
    rect(160 + i * 8, 203, 5, 8);
    rect(290 + i * 8, 203, 5, 8);
  }
  // Torre central
  for (int i = 0; i < 7; i++) {
    rect(210 + i * 9, 193, 6, 9);
  }
  
  // Ventanas brillantes
  fill(GOLD, 100 + 80 * sin(frameCount * 0.04));
  rect(116, 215, 8, 10);
  rect(356, 215, 8, 10);
  fill(BLUE_LIGHT, 80 + 60 * sin(frameCount * 0.03 + 1));
  rect(231, 220, 18, 12);
}

void drawCharacter(float x, float y) {
  // Personaje estilo 16-bit simple
  float bob = sin(frameCount * 0.06) * 2;
  y += bob;
  
  // Sombra
  fill(SHADOW, 80);
  ellipse(x, y + 32, 40, 8);
  
  // Capa/toga
  fill(color(80, 30, 120));
  triangle(x - 18, y + 10, x + 18, y + 10, x + 12, y + 30);
  triangle(x - 18, y + 10, x - 12, y + 30, x + 5, y + 30);
  
  // Cuerpo
  fill(color(60, 60, 80));
  rect(x - 12, y - 5, 24, 22, 3);
  
  // Corbata
  fill(RED_MAIN);
  rect(x - 3, y - 2, 6, 14);
  triangle(x - 3, y + 12, x + 3, y + 12, x, y + 18);
  
  // Cabeza
  fill(color(220, 180, 140));
  ellipse(x, y - 14, 26, 24);
  
  // Pelo
  fill(DARK);
  ellipse(x, y - 22, 26, 12);
  rect(x - 13, y - 22, 26, 8);
  
  // Ojos
  fill(DARK);
  ellipse(x - 5, y - 14, 4, 4);
  ellipse(x + 5, y - 14, 4, 4);
  
  // Gafas (lentes)
  noFill();
  stroke(DARK);
  strokeWeight(1.5);
  ellipse(x - 5, y - 14, 8, 7);
  ellipse(x + 5, y - 14, 8, 7);
  line(x - 1, y - 14, x + 1, y - 14);
  line(x - 9, y - 14, x - 13, y - 15);
  line(x + 9, y - 14, x + 13, y - 15);
  noStroke();
  
  // Sombrero
  fill(color(30, 20, 60));
  rect(x - 14, y - 28, 28, 8, 2);
  triangle(x - 10, y - 28, x + 10, y - 28, x, y - 48);
  
  // Brillo sombrero
  fill(WHITE, 60);
  triangle(x - 3, y - 45, x + 2, y - 30, x + 4, y - 44);
}

void drawDialogBox(float x, float y, float w, float h) {
  // Sombra
  fill(SHADOW, 120);
  rect(x + 3, y + 3, w, h, 6);
  
  // Borde exterior
  fill(DARK);
  rect(x - 2, y - 2, w + 4, h + 4, 8);
  
  // Borde blanco
  fill(WHITE);
  rect(x, y, w, h, 6);
  
  // Interior crema
  fill(CREAM);
  rect(x + 4, y + 4, w - 8, h - 8, 4);
}

// ===== PANTALLA 2: CONTROLES =====
void drawControlsScreen() {
  // Fondo
  for (int y = 0; y < GAME_H; y++) {
    float t = (float)y / GAME_H;
    color c = lerpColor(color(16, 24, 72), color(8, 48, 40), t);
    stroke(c);
    line(0, y, GAME_W, y);
  }
  noStroke();
  
  // Header
  fill(BLUE_DARK);
  rect(0, 0, GAME_W, 52);
  stroke(GOLD);
  strokeWeight(2);
  line(0, 50, GAME_W, 50);
  noStroke();
  
  // Decoracion header
  fill(GOLD);
  rect(0, 48, GAME_W, 4);
  
  fill(WHITE);
  textAlign(CENTER, CENTER);
  textSize(20);
  text("CONTROLES", GAME_W/2 + 2, 27 + 1);
  fill(GOLD);
  text("CONTROLES", GAME_W/2, 27);
  
  // Panel principal controles
  drawDialogBox(30, 62, 420, 195);
  
  // Controles
  float[][] controls = {
    {0}, // placeholder
  };
  
  String[][] ctrlData = {
    {"W  A  S  D", "Movimiento"},
    {"P", "Pausa"},
    {"Q", "Capturar"},
    {"E", "Bloquear"},
    {"R", "Reportar"}
  };
  
  color[] ctrlColors = {BLUE_MID, RED_MAIN, color(40, 160, 40), color(200, 120, 0), color(140, 40, 160)};
  
  for (int i = 0; i < ctrlData.length; i++) {
    float rowY = 82 + i * 36;
    
    // Fila alterna
    if (i % 2 == 0) {
      fill(BLUE_LIGHT, 40);
      rect(38, rowY - 2, 404, 28, 3);
    }
    
    // Tecla(s)
    String keys = ctrlData[i][0];
    String[] keyParts = keys.split("  ");
    float keyX = 60;
    
    for (String k : keyParts) {
      drawKey(keyX, rowY + 6, k, ctrlColors[i]);
      keyX += k.length() * 9 + 20;
    }
    
    // Separador
    fill(GRAY_MED);
    textAlign(LEFT, CENTER);
    textSize(10);
    text("→", 210, rowY + 13);
    
    // Descripcion
    fill(DARK);
    textSize(13);
    textAlign(LEFT, CENTER);
    text(ctrlData[i][1], 228, rowY + 13);
  }
  
  // Footer
  drawDialogBox(60, 270, 360, 38);
  fill(DARK);
  textAlign(CENTER, CENTER);
  textSize(11);
  if (showBlink) {
    text("▼  Click para continuar  ▼", GAME_W/2, 289);
  } else {
    text("   Click para continuar   ", GAME_W/2, 289);
  }
}

void drawKey(float x, float y, String k, color c) {
  float kw = max(28, k.length() * 10 + 10);
  float kh = 22;
  
  // Sombra tecla
  fill(lerpColor(c, SHADOW, 0.7));
  rect(x + 2, y + 2, kw, kh, 4);
  
  // Tecla
  fill(c);
  rect(x, y, kw, kh, 4);
  
  // Brillo
  fill(WHITE, 80);
  rect(x + 2, y + 2, kw - 4, kh/2 - 2, 3);
  
  // Texto
  fill(WHITE);
  textAlign(CENTER, CENTER);
  textSize(10);
  text(k, x + kw/2, y + kh/2);
}

// ===== PANTALLA 3: CONTEXTO =====
void drawContextScreen() {
  // Fondo pergamino oscuro
  for (int y = 0; y < GAME_H; y++) {
    float t = (float)y / GAME_H;
    color c = lerpColor(color(32, 20, 12), color(20, 32, 16), t);
    stroke(c);
    line(0, y, GAME_W, y);
  }
  noStroke();
  
  // Efecto ruido/textura
  for (int i = 0; i < 200; i++) {
    float nx = random(GAME_W);
    float ny = random(GAME_H);
    fill(255, random(5, 20));
    ellipse(nx, ny, 1, 1);
  }
  
  // Header escudo
  fill(color(48, 28, 8));
  rect(0, 0, GAME_W, 56);
  fill(GOLD);
  rect(0, 54, GAME_W, 3);
  
  // Escudo decorativo
  drawShield(GAME_W/2, 28);
  
  // "HISTORIA"
  fill(CREAM);
  textAlign(CENTER, CENTER);
  textSize(9);
  text("✦  PROLOGO  ✦", GAME_W/2, 44);
  
  // Area de texto con scroll
  int textAreaY = 64;
  int textAreaH = 218;
  
  // Marco del texto
  fill(color(20, 35, 20), 200);
  rect(24, textAreaY, GAME_W - 48, textAreaH, 4);
  stroke(color(80, 120, 60));
  strokeWeight(1);
  rect(24, textAreaY, GAME_W - 48, textAreaH, 4);
  noStroke();
  
  // Clip/mascara visual (barras arriba y abajo)
  fill(color(32, 20, 12));
  rect(0, 0, GAME_W, textAreaY);
  rect(0, textAreaY + textAreaH, GAME_W, GAME_H);
  
  // Texto scrollable
  float lineHeight = 17;
  float startY = textAreaY + 16 - contextScroll;
  
  for (int i = 0; i < contextLines.length; i++) {
    float ly = startY + i * lineHeight;
    if (ly < textAreaY + 2 || ly > textAreaY + textAreaH) continue;
    
    // Fade at edges
    float fadeTop = constrain(map(ly, textAreaY, textAreaY + 30, 0, 255), 0, 255);
    float fadeBot = constrain(map(ly, textAreaY + textAreaH - 30, textAreaY + textAreaH, 255, 0), 0, 255);
    float alpha = min(fadeTop, fadeBot);
    
    if (contextLines[i].equals("")) continue;
    
    // Detección párrafos iniciales
    boolean isSpecial = contextLines[i].startsWith("El ASU") || contextLines[i].startsWith("moggeado.") || contextLines[i].startsWith("O si");
    
    fill(isSpecial ? RED_LIGHT : CREAM, alpha);
    textAlign(LEFT, CENTER);
    textSize(11);
    text(contextLines[i], 36, ly);
  }
  
  // Re-dibujar barras encima del texto
  fill(color(32, 20, 12));
  rect(0, 0, GAME_W, textAreaY);
  
  // Recalcular Y del footer
  int footerY = textAreaY + textAreaH + 4;
  fill(color(32, 20, 12));
  rect(0, footerY, GAME_W, GAME_H - footerY);
  
  // Header de nuevo encima
  fill(color(48, 28, 8));
  rect(0, 0, GAME_W, 56);
  fill(GOLD);
  rect(0, 54, GAME_W, 3);
  drawShield(GAME_W/2, 28);
  fill(CREAM);
  textAlign(CENTER, CENTER);
  textSize(9);
  text("✦  PROLOGO  ✦", GAME_W/2, 44);
  
  // Scrollbar
  float totalH = contextLines.length * lineHeight;
  float scrollRatio = contextScroll / max(1, totalH - textAreaH + 32);
  float barH = max(20, textAreaH * (textAreaH / max(totalH, 1)));
  float barY = textAreaY + scrollRatio * (textAreaH - barH);
  
  fill(color(80, 120, 60), 120);
  rect(GAME_W - 18, textAreaY, 8, textAreaH, 4);
  fill(GOLD, 180);
  rect(GAME_W - 18, barY, 8, barH, 4);
  
  // Footer
  drawDialogBox(60, 288, 360, 26);
  fill(DARK);
  textAlign(CENTER, CENTER);
  textSize(10);
  
  float maxScroll = contextLines.length * lineHeight - textAreaH + 32;
  if (contextScroll >= maxScroll - 5) {
    if (showBlink) text("▼  Click para comenzar  ▼", GAME_W/2, 301);
    else text("   Click para comenzar   ", GAME_W/2, 301);
  } else {
    text("Scroll o Click para avanzar", GAME_W/2, 301);
  }
}

void drawShield(float x, float y) {
  // Escudo simple
  fill(BLUE_DARK);
  beginShape();
  vertex(x - 16, y - 18);
  vertex(x + 16, y - 18);
  vertex(x + 16, y + 2);
  vertex(x, y + 18);
  vertex(x - 16, y + 2);
  endShape(CLOSE);
  
  stroke(GOLD);
  strokeWeight(1.5);
  beginShape();
  vertex(x - 16, y - 18);
  vertex(x + 16, y - 18);
  vertex(x + 16, y + 2);
  vertex(x, y + 18);
  vertex(x - 16, y + 2);
  endShape(CLOSE);
  noStroke();
  
  fill(GOLD);
  textAlign(CENTER, CENTER);
  textSize(14);
  text("M", x, y - 2);
}

// ===== FADE TRANSITION =====
void handleFade() {
  if (fadingIn) {
    fadeAlpha -= 15;
    if (fadeAlpha <= 0) {
      fadeAlpha = 0;
      fadingIn = false;
    }
  }
  if (fadingOut) {
    fadeAlpha += 15;
    if (fadeAlpha >= 255) {
      fadeAlpha = 255;
      fadingOut = false;
      fadingIn = true;
      screen = nextScreen;
      contextScroll = 0;
      contextTarget = 0;
      
    }
  }
  
  if (fadeAlpha > 0) {
    fill(SHADOW, fadeAlpha);
    rect(0, 0, GAME_W, GAME_H);
  }
}

void goToScreen(int s) {
  if (!fadingOut && !fadingIn) {
    fadingOut = true;
    nextScreen = s;
  }
}

void drawLoadingScreen() {
  // Fondo
  background(DARK);
  
  // Logo/titulo pequeño arriba
  fill(GOLD);
  textAlign(CENTER, CENTER);
  textSize(16);
  text("MOGWARTS", GAME_W/2, 90);
  fill(BLUE_LIGHT);
  textSize(9);
  text("PSL SCALE EDITION", GAME_W/2, 110);

  // Barra de carga
  int barW = 280, barH = 16;
  int barX = (GAME_W - barW) / 2;
  int barY = GAME_H/2 - barH/2;

  // Borde barra
  fill(SHADOW); rect(barX-2, barY-2, barW+4, barH+4, 4);
  fill(GRAY_MED); rect(barX, barY, barW, barH, 3);

  // Relleno progreso
  fill(GOLD);
  rect(barX, barY, barW * loadingProgress, barH, 3);

  // Brillo barra
  fill(WHITE, 60);
  rect(barX, barY, barW * loadingProgress, barH/2, 3);

  // Porcentaje
  fill(WHITE);
  textAlign(CENTER, CENTER);
  textSize(10);
  text(int(loadingProgress * 100) + "%", GAME_W/2, barY + barH + 14);

  // "Cargando..."
  loadingDotsTimer++;
  if (loadingDotsTimer > 20) { loadingDotsTimer = 0; loadingDots = (loadingDots + 1) % 4; }
  String dots = "";
  for (int i = 0; i < loadingDots; i++) dots += ".";
  fill(CREAM);
  textSize(11);
  text("Cargando" + dots, GAME_W/2, barY - 20);

  // Load images progressively (20 per frame for faster loading)
  int imagesPerFrame = 20;
  for (int k = 0; k < imagesPerFrame && loadedImages < totalImages; k++) {
    int i = loadedImages / 5;
    int j = loadedImages % 5;
    tiles[i][j] = loadImage("images/" + i + "_" + j + ".png");
    loadedImages++;
  }
  loadingProgress = (float)loadedImages / totalImages;
  if (loadingProgress >= 1.0) {
    loadingProgress = 1.0;
    goToScreen(0); // Go to title after loading
  }
}

// ===== INPUT =====
void mousePressed() {
  if (fadingIn || fadingOut) return;
  
  // Convertir coordenadas del mouse al espacio logico
  float offsetX = (width - GAME_W * SCALE_FACTOR) / 2;
  float offsetY = (height - GAME_H * SCALE_FACTOR) / 2;
  float lx = (mouseX - offsetX) / SCALE_FACTOR;
  float ly = (mouseY - offsetY) / SCALE_FACTOR;
  
  if (screen == 0) {
    goToScreen(1);
  } else if (screen == 1) {
    goToScreen(2);
  } else if (screen == 2) {
    float lineHeight = 17;
    float maxScroll = contextLines.length * lineHeight - 218 + 32;
    contextTarget = (int)min(contextTarget + 80, maxScroll);
    
    if (contextTarget >= maxScroll - 5) {
      // Fin - pasar al juego de prueba
      goToScreen(3);
    }
  }
}

void mouseWheel(MouseEvent event) {
  if (screen == 2) {
    float lineHeight = 17;
    float maxScroll = contextLines.length * lineHeight - 218 + 32;
    contextTarget = (int)constrain(contextTarget + event.getCount() * 25, 0, maxScroll);
  }
}