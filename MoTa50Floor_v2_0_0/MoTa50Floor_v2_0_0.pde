private int floorArray [][][] = new int[51][13][13];
ImageData imageData;
CreatureData creatureData;


void setup() {
  size(736, 416);
  frameRate(60);
  initVariable();
  creatureData.braver.floor = 1;
  creatureData.braver.atk = 1000;
  creatureData.braver.def = 1000;
  
  //creatureData.braver.x = 5;
  //creatureData.braver.y = 2;
}

void draw(){
  imageData.drawGameBoard();
  imageData.update();
  creatureData.showUIText();
  creatureData.updata();
  
}

void keyPressed() {
  switch (keyCode){
    case 72: imageData.switchOnMonsterList(); break;//imageData.showMonsterList(); break;
    case 33: creatureData.braver.addFloor(); if(showConsoleText) println("Floor up"); break;
    case 34: creatureData.braver.subFloor(); if(showConsoleText) println("Floor down"); break;
    
    case 87: case UP: creatureData.movingBraver(2,0,-1); break;  
    case 83: case DOWN: creatureData.movingBraver(4,0,1); break;  
    case 65: case LEFT: creatureData.movingBraver(1,-1,0); break;  
    case 68: case RIGHT: creatureData.movingBraver(3,1,0); break;
    default: imageData.switchOnMonsterList();
  }
}

void initVariable(){
  imageData = new ImageData();
  creatureData = new CreatureData();
  initFloorArray();       // initial variable of floorArray
}
