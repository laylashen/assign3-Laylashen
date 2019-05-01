final int GAME_START = 0, GAME_RUN = 1, GAME_OVER = 2;
int gameState = 0;
int transY=0;

final int GRASS_HEIGHT = 15;
final int START_BUTTON_W = 144;
final int START_BUTTON_H = 60;
final int START_BUTTON_X = 248;
final int START_BUTTON_Y = 360;

final int STOP = 0;
final int DOWNWARD = 1;
final int LEFTWARD = 2;
final int RIGHTWARD = 3;
int movement = STOP;

int soilX=80;
int soilY=80;
int groundY=soilY*2;
int soilRestrict;

float hogX=320;
float hogY=80;

PImage title, gameover, startNormal, startHovered, restartNormal, restartHovered;
PImage bg;
PImage heart;
PImage hog;
PImage [] soil = new PImage[6];
PImage rock1,rock2;

// For debug function; DO NOT edit or remove this!
int playerHealth = 2;
float cameraOffsetY = 0;
boolean debugMode = false;

void setup() {
  size(640, 480, P2D);
  // Enter your setup code here (please put loadImage() here or your game will lag like crazy)
  bg = loadImage("img/bg.jpg");
  title = loadImage("img/title.jpg");
  gameover = loadImage("img/gameover.jpg");
  startNormal = loadImage("img/startNormal.png");
  startHovered = loadImage("img/startHovered.png");
  restartNormal = loadImage("img/restartNormal.png");
  restartHovered = loadImage("img/restartHovered.png");

  hog = loadImage("img/groundhogIdle.png");

  rock1 = loadImage("img/stone1.png");
  rock2 = loadImage("img/stone2.png");
  soil[0] = loadImage("img/soil0.png"); 
  soil[1] = loadImage("img/soil1.png"); 
  soil[2] = loadImage("img/soil2.png"); 
  soil[3] = loadImage("img/soil3.png"); 
  soil[4] = loadImage("img/soil4.png"); 
  soil[5] = loadImage("img/soil5.png");
  heart = loadImage("img/life.png");
}

void stone2(int soilRestrict){
  for(int y=soilRestrict; y<soilRestrict+soilY*4 ; y+=soilX*3){
      image(rock1,soilX,y);
      image(rock1,soilX*2,y);
      image(rock1,soilX*5,y);
      image(rock1,soilX*6,y);
  }
}

void stone3(int[]arr){
  for(int i=0; i<arr.length;i++){
    for(int y=soilRestrict; y<soilRestrict+soilY*8 ; y+=soilX*3){
      image(rock1,soilX*arr[i],y);
    }
  }
}

void stone3Dark(int[]arr){
  for(int i=0; i<arr.length;i++){
    for(int y=soilRestrict; y<soilRestrict+soilY*8 ; y+=soilX*3){
      image(rock2,soilX*arr[i],y);
    }
  }
}

void draw() {
    /* ------ Debug Function ------ 

      Please DO NOT edit the code here.
      It's for reviewing other requirements when you fail to complete the camera moving requirement.

    */
    if (debugMode) {
      pushMatrix();
      translate(0, cameraOffsetY);
    }
    /* ------ End of Debug Function ------ */

    
  switch (gameState) {

    case GAME_START: // Start Screen
    image(title, 0, 0);

    if(START_BUTTON_X + START_BUTTON_W > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_H > mouseY
      && START_BUTTON_Y < mouseY) {

      image(startHovered, START_BUTTON_X, START_BUTTON_Y);
      if(mousePressed){
        gameState = GAME_RUN;
        mousePressed = false;
      }
      }else{
      image(startNormal, START_BUTTON_X, START_BUTTON_Y);
    }
    break;

    case GAME_RUN: // In-Game

    // Background
    image(bg, 0, 0);

    // Sun
      stroke(255,255,0);
      strokeWeight(5);
      fill(253,184,19);
      ellipse(590,50,120,120);

    // Grass
    soilRestrict=groundY;
    fill(124, 204, 25);
    noStroke();
    rect(0, soilRestrict - GRASS_HEIGHT , width, GRASS_HEIGHT );

    // Soil - REPLACE THIS PART WITH YOUR LOOP CODE!
    for(int i = 0; i < soil.length; i++){
      for(int x=0; x<width ; x+=soilX){
        for(int y=0; y<soilY*4; y+=soilY ){
          image(soil[i],x,y+soilRestrict);
        }
      }
      soilRestrict+=soilY*4;
    }
    
    //Rock1
    soilRestrict=groundY;
    for(int x=0; x<width ; x+=soilX){
      image(rock1,x,soilRestrict);
      soilRestrict+=80;
    }
    
    //Rock2
    soilRestrict=groundY+soilY*8;
    stone2(soilRestrict);
    
    for(int y=soilRestrict+soilY; y<soilRestrict+soilY*8 ; y+=soilX*4){
      image(rock1,0,y);
      image(rock1,soilX*3,y);
      image(rock1,soilX*4,y);
      image(rock1,soilX*7,y);
      image(rock1,0,y+soilY);
      image(rock1,soilX*3,y+soilY);
      image(rock1,soilX*4,y+soilY);
      image(rock1,soilX*7,y+soilY);
    }
    
    soilRestrict=groundY+soilY*12;
    stone2(soilRestrict);
    
    //Rock3
    //light stone
    soilRestrict=groundY+soilY*16;
    int [] nums1= {1,2,4,5,7};
    stone3(nums1);
    soilRestrict=groundY+soilY*17;
    int [] nums2= {0,1,3,4,6,7};
    stone3(nums2);
    soilRestrict=groundY+soilY*18;
    int [] nums3= {0,2,3,5,6};
    stone3(nums3);
    
    //dark stone
    soilRestrict=groundY+soilY*16;
    int [] nums11= {2,5};
    stone3Dark(nums11);
    soilRestrict=groundY+soilY*17;
    int [] nums22= {1,4,7};
    stone3Dark(nums22);
    soilRestrict=groundY+soilY*18;
    int [] nums33= {0,3,6};
    stone3Dark(nums33);

    // Player
    image(hog,hogX,hogY);
    
    // Health UI
    int heartX=35;
    int heartY=35;
    int heartMove=70;
    imageMode(CENTER);
     for(int i=0;i<playerHealth;i++){
      image(heart,heartX+i*heartMove,heartY);
    }
    //}
    imageMode(CORNER);

    break;

    case GAME_OVER: // Gameover Screen
    image(gameover, 0, 0);
    
    if(START_BUTTON_X + START_BUTTON_W > mouseX
      && START_BUTTON_X < mouseX
      && START_BUTTON_Y + START_BUTTON_H > mouseY
      && START_BUTTON_Y < mouseY) {

      image(restartHovered, START_BUTTON_X, START_BUTTON_Y);
      if(mousePressed){
        gameState = GAME_RUN;
        mousePressed = false;
      }
    }else{
      image(restartNormal, START_BUTTON_X, START_BUTTON_Y);
    }
    break;
  }

    // DO NOT REMOVE OR EDIT THE FOLLOWING 3 LINES
    if (debugMode) {
        popMatrix();
    }
}

void keyPressed(){
  // Add your moving input code here

  // DO NOT REMOVE OR EDIT THE FOLLOWING SWITCH/CASES
    
    if (hogX % 80 == 0 && hogY % 80 == 0){
    switch(keyCode){
      
      case DOWN:
      if(groundY<-1360){
        hogY+=80;
      }else{
        groundY -= 80; //soil run
      }
      break;     
      
      case RIGHT:
      if(hogX<width)
      hogX+=80;
      break;      
      
      case LEFT:
      if(hogX>0)
      hogX-=80;
      break;
    }
  }
    
    switch(key){
      case 'w':
      debugMode = true;
      cameraOffsetY += 25;
      break;

      case 's':
      debugMode = true;
      cameraOffsetY -= 25;
      break;

      case 'a':
      if(playerHealth > 0) playerHealth --;
      break;

      case 'd':
      if(playerHealth < 5) playerHealth ++;
      break;
    }
}
