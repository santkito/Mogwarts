// ===== MOGWARTS PSL SCALE - INTRO SCREENS =====
// Estilo Pokemon Fire Red

PFont pixelFont;
PFont pixelFontSmall;
PFont pixelFontTitle;

PImage[][] tiles;
PImage titleImg;

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
  
  // Preparar texto de contexto
  String contextRaw = "En un lugar donde la confianza lo era todo, las amistades parecían inquebrantables.\n"
+ "Risas compartidas, secretos guardados y promesas que nunca debían romperse… o al menos eso parecía.\n\n"
+ "Pero no todas las historias siguen el camino que esperamos.\n\n"
+ "A veces, las palabras más duras vienen de quien solía apoyarte.\n"
+ "Las miradas cambian, los gestos pesan más, y lo que antes era amistad se convierte en algo difícil de reconocer.\n"
+ "El silencio empieza a doler tanto como las palabras.\n\n"
+ "Esta es una historia sobre enfrentar lo que duele.\n"
+ "Sobre encontrar la voz cuando parece más fácil callar.\n"
+ "Y sobre descubrir que incluso en los momentos más difíciles, siempre hay una elección:\n"
+ "quedarse en la sombra… o dar un paso al frente.";
  
  contextLines = wrapText(contextRaw, 44);

  setupGame();
  setupPlayer();
  setupTutorial();
  tiles = new PImage[8][5];
  titleImg = loadImage("title.png");
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

  if (screen == 5) {
    drawTutorial();
    handleFade();
    return;
  }
  
  if (screen == 6) {
    drawScreen6();
    handleFade();
    return;
  }

  if (screen == 7) {
    drawCredits();
    return;
  }

  float offsetX = (width - GAME_W * SCALE_FACTOR) / 2;
  float offsetY = (height - GAME_H * SCALE_FACTOR) / 2;
  pushMatrix();
  translate(offsetX, offsetY);
  scale(SCALE_FACTOR);

  if (screen != 3) {
    background(DARK);
    blinkTimer += 0.04;
    if (blinkTimer > PI) {
      blinkTimer = 0;
      showBlink = !showBlink;
    }
    // Scroll suave del contexto
    contextScroll += (contextTarget - contextScroll) * 0.15;
  }
  
  if (screen == 0) drawTitleScreen();
  else if (screen == 1) drawControlsScreen();
  else if (screen == 2) drawContextScreen();
  else if (screen == 3) drawGame();
  else if (screen == 4) drawLoadingScreen();
  
  handleFade();
  
  popMatrix();
}

// ===== PANTALLA 1: TITULO =====
void drawTitleScreen() {
  // Imagen de titulo a pantalla completa (espacio logico 480x320)
  if (titleImg != null) {
    image(titleImg, 0, 0, GAME_W, GAME_H);
  } else {
    background(DARK);
  }

  // Prompt parpadeante encima de la imagen
  if (showBlink) {
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
PImage controlesImg;

void drawControlsScreen() {
  if (controlesImg == null) controlesImg = loadImage("controles.png");
  if (controlesImg != null) {
    image(controlesImg, 0, 0, GAME_W, GAME_H);
  } else {
    background(DARK);
  }

  // Footer parpadeante encima de la imagen
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
    boolean isSpecial = contextLines[i].startsWith("El silencio") || contextLines[i].startsWith("quedarse en")|| contextLines[i].startsWith("palabras")|| contextLines[i].startsWith("frente");
    
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
    if (screen == 5) {
      rect(0, 0, width, height);
    } else {
      rect(0, 0, GAME_W, GAME_H);
    }
  }
}

void goToScreen(int s) {
  if (s == 5) {
    screen = s;
    contextScroll = 0;
    contextTarget = 0;
    return;
  }
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
  if (dialogoVaris) {
    if (swscreen3 == 1) {
      if (dialogoPage == 0) {
        dialogoPage = 1; // avanzar a dialogo de Lacy
      } else if (dialogoPage == 1) {
        dialogoPage = 2; // avanzar a dialogo de Clavicular
      } else if (dialogoPage == 2) {
        dialogoPage = 3; // avanzar a dialogo final de Varis
      } else if (dialogoPage == 3) {
        // Varis y Lacy se van: swscreen3 = 2, NPCs desaparecen
        dialogoVaris = false;
        dialogoPage = 0;
        swscreen3 = 2;
      }
    } else {
      dialogoVaris = false;
      goToScreen(5);
    }
    return;
  }
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
  } else if (screen == 5) {
    // Manejar click en tutorial
    tutorialMousePressed();
  } else if (screen == 6) {
    // Click en pantalla 6: continuar (puedes cambiar el destino)
    goToScreen(3);
  }
}

void mouseWheel(MouseEvent event) {
  if (screen == 2) {
    float lineHeight = 17;
    float maxScroll = contextLines.length * lineHeight - 218 + 32;
    contextTarget = (int)constrain(contextTarget + event.getCount() * 25, 0, maxScroll);
  }
}

// ===== PANTALLA 6: NUEVA ZONA =====
// Implemented in screen6.pde