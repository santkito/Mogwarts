// Event handlers for tutorial game

void tutorialMousePressed() {
  if (!gameStarted && mostrarDialogo) {
    // During intro dialog
    dialogoIndex++;
    if (dialogoIndex >= dialogos.length) {
      gameStarted = true;
    } else {
      dialogoLines = wrapText(dialogos[dialogoIndex], 75);
    }
  }
}

void tutorialKeyPressed() {
  if (!gameStarted) return;
  
  char key_lower = Character.toLowerCase(key);
  
  if (keyCode == ENTER && score >= 150) {
    screen = 3;
    swscreen3 = 1;
    paused = false;
    return;
  }
  
  if (key_lower == 'p') {
    gamePaused = !gamePaused;
  }
  
  if (gamePaused) return;
  
  // Movement
  if (key_lower == 'w') { tutorialWPressed = true; tutorialLastDirection = 'w'; lastDirection = 'w'; }
  if (key_lower == 's') { tutorialSPressed = true; tutorialLastDirection = 's'; lastDirection = 's'; }
  if (key_lower == 'a') { tutorialAPressed = true; tutorialLastDirection = 'a'; lastDirection = 'a'; }
  if (key_lower == 'd') { tutorialDPressed = true; tutorialLastDirection = 'd'; lastDirection = 'd'; }
  
  if (key_lower == 'e') {
    // Mostrar E.png centrada sobre el jugador
    ePressed = true;
    ePressedTimer = 0;
    
    // Block message - find closest message to player
    if (messages.size() > 0) {
      float minDist = Float.MAX_VALUE;
      int closestIdx = -1;
      
      for (int i = 0; i < messages.size(); i++) {
        Message m = messages.get(i);
        float d = dist(m.x, m.y, tutorialPlayerX, tutorialPlayerY);
        if (d < minDist && d < 150) {
          minDist = d;
          closestIdx = i;
        }
      }
      
      if (closestIdx != -1) {
        Message m = messages.get(closestIdx);
        if (m.type == 0) {
          // Blocking positive message = penalty
          wellBeing = max(0, wellBeing - 15);
          score = max(0, score - 20);
        } else if (m.type == 2) {
          // Bloqueó un mensaje rojo con E
          consecutiveBullying++;
          bullCount++;
        }
        messages.remove(closestIdx);
      }
    }
  }
  
  if (key_lower == 'q') {
    // Capture positive messages
    for (int i = messages.size() - 1; i >= 0; i--) {
      Message m = messages.get(i);
      if (m.type == 0 && dist(m.x, m.y, tutorialPlayerX, tutorialPlayerY) < 200) {
        wellBeing = min(100, wellBeing + 15);
        score += 25;
        consecutiveBullying = 0;
        messages.remove(i);
      }
    }
  }
  
  if (key_lower == 'r') {
    // Report bullying
    if (bullCount >= 3) {
      score += 100; // Bonus points
      for (int i = messages.size() - 1; i >= 0; i--) {
        Message m = messages.get(i);
        if (m.type == 2) {
          messages.remove(i);
        }
      }
      consecutiveBullying = 0;
      bullCount = 0;
      wellBeing = min(100, wellBeing + 20);
      
      // Activar animacion explosion de E.png desde el jugador
      rExplosion = true;
      rExplosionTimer = 0;
      rExplosionScale = 0;
      rExplosionAlpha = 255;
      rExplosionX = tutorialPlayerX;
      rExplosionY = tutorialPlayerY;
    }
  }
}

void tutorialKeyReleased() {
  char key_lower = Character.toLowerCase(key);
  if (key_lower == 'w') tutorialWPressed = false;
  if (key_lower == 's') tutorialSPressed = false;
  if (key_lower == 'a') tutorialAPressed = false;
  if (key_lower == 'd') tutorialDPressed = false;
  
  // Determinar la última dirección presionada
  if (tutorialWPressed) {
    tutorialLastDirection = 'w';
  } else if (tutorialSPressed) {
    tutorialLastDirection = 's';
  } else if (tutorialAPressed) {
    tutorialLastDirection = 'a';
  } else if (tutorialDPressed) {
    tutorialLastDirection = 'd';
  } else {
    tutorialLastDirection = ' ';
  }
}
