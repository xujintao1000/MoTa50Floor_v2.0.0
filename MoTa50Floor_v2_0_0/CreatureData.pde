class Creature{
    int index, hp, atk, def, gold;

    Creature(int index, int hp, int atk, int def, int gold){
        this.hp = hp;
        this.atk = atk;
        this.def = def;
        this.gold = gold;
        this.index = index;
    }
    
    boolean Combat(Creature opponent){
        hp -= Math.max(opponent.atk-def,0);
        return hp>0;   // return true if hp still have hp
    }
}


//---Braver Class--------------------------------------------------------------------------------------------------
class Braver extends Creature {
    boolean isFighting = false;
    boolean isMoving = false;
    boolean moveable = true;
    boolean [] magicItem = new boolean[15];
    int floor =1, floorIsReach=1;
    int x = 6, y = 11, pX = 6*imgScale, pY = 11*imgScale;
    int face = 2;
    int [] keyArray;        // 0- empty 1-yellow key, 2-blue key, 3-red key
    String [] swardName, shieldName;
    byte sward, shield;
    Braver(){
      super(100,1000,10,10,0);
      for(int i=0; i<magicItem.length; i++) magicItem[i] = false;
      keyArray = new int[40];  
      initSwardShield();
    }
    
    
    void updateStatus(){
      if(isFighting && frameCount % fightingTimePeriod == 0){
        this.Combat(creatureData.currentFightMonster);
        creatureData.currentFightMonster.Combat(this);
        if(creatureData.currentFightMonster.hp <=0){  // finish for fighting 
          this.gold += creatureData.currentFightMonster.gold;
          creatureData.currentFightMonster.hp =0;
          isFighting = false;
          floorArray[floor][y][x] = 0;
          moveable = true;
        }
      }
      if(isMoving){
        if ( pX - (x+5) * imgScale < (x+5) * imgScale  - pX) pX+=2;
        else if(pX != (x+5) * imgScale) pX-=2;
        
        if ( pY - y * imgScale < y * imgScale  - pY) pY+=2;
        else if(pY != y * imgScale) pY-=2;
        
        if(pX == (x+5) * imgScale && pY == y * imgScale){
          if(showConsoleText) println("Finish braver to Move.");
          isMoving = false;
          moveable = true;
          int floorIdex = floorArray[floor][y][x];
          if(floorIdex>=105 && floorIdex<140){ isFighting = true; moveable = false;}
          else activateItem(floorIdex);
        }
      }
    }
    
    //****************** Magin Item ***********************//
    boolean tryToUseMaginItem(int magicIndex){
      if(magicIndex>15) magicIndex-=50;
      if(magicItem[magicIndex]){
        switch(magicIndex){
          //case 50: imageData.
        }
      }
      return false;
    }
    
    
    
    //****************** Change the floor ***********************//
    void addFloor(){
      if(floor==43) floor+=2;
      else if(floor+1 >= 50) return;  // unable to go above
      else floor++;
      movePosToFloorDown();
    }
    
    void subFloor(){
      if(floor==45) floor-=2;
      else if(floor-1 ==0) return;  // unable to go below 
      else floor--;
      movePosToFloorDown();
    }
    
    void movePosToFloorDown(){  // move the braver position into flooeDown index
      for(int i=0; i<13; i++){
        for(int j=0; j<13; j++){
          if(floorArray[floor][i][j] == 11){  // index for floo down;
            x = j;
            y = i;
            return;
          }
        }
      }
  
    }
    //****************** After moving the indicated point, to get the corresponding item ***********************//
    void activateItem(int floorIndex){
      boolean remove = true;
      switch(floorIndex){
        case 10: floor++; remove = false; break;
        case 11: floor--; remove = false; break;
        case 20: case 21: case 22:  addKey(floorIndex-19); break;
        case 24: addAttack(); break;
        case 25: addDefence(); break;
        case 28: addSmallHp(); break;
        case 29: addLargeHp(); break;
        case 40: atk+=10; break; case 41: atk+=20; break; case 42: atk+=50; break; case 43: atk+=80; break; case 44: atk+=100; break;   // get sward
        case 45: def+=10; break; case 46: def+=20; break; case 47: def+=50; break; case 48: def+=80; break; case 49: def+=100; break;   // get shield
      }
      if(remove) floorArray[floor][y][x] = 0;
    }
    
    //****************** Braver change or update status ***********************//
    void addSmallHp(){
      if(floor<10) hp+=50;
      else if(floor<20) def+=100;
      else if(floor<40) def+=200;
      else if(floor<40) def+=200;
    }
    
    void addLargeHp(){
      if(floor<10) hp+=200;
      else if(floor<20) def+=400;
      else if(floor<40) def+=800;
      else if(floor<40) def+=800;
    }
    
    void addAttack(){
      if(floor<10) atk++;
      else if(floor<20) atk+=2;
      else if(floor<40) atk+=3;
      else if(floor<40) atk+=4;
    }
    
    int getDefence(){return def;}
    void addDefence(){
      if(floor<10) def++;
      else if(floor<20) def+=2;
      else if(floor<40) def+=3;
      else if(floor<40) def+=4;
    }
    
    //****************** Braver Movement ***********************//
    void moveBraver(int moveX, int moveY) {   // x and y are not the axis coordinate, but the change of x and y //<>//
      int nextX = x + moveX;
      int nextY = y + moveY;
      int floorIndex = floorArray[floor][nextY][nextX];
      if(checkIfMoveable(floorIndex, nextX, nextY)){    // if next point is item, monster NPC, door
        isMoving = true;
        moveable = false;
        pX = (this.x+5) * imgScale;
        pY = this.y * imgScale;
        x = nextX;
        y = nextY;
      }
    }
    
    boolean checkIfMoveable(int floorIndex, int nextX, int nextY) {
      if((floorIndex >= 7 && floorIndex <= 9 && removeKey(floorIndex)) || floorIndex==17 || floorIndex == 14 ){
        imageData.isOpenDoor = true; imageData.doorX = nextX; imageData.doorY = nextY; imageData.doorIndex = floorIndex;
        floorArray[floor][nextY][nextX] = 0;
        creatureData.braver.moveable = false;
      }    // check if face with door
      for(int i=0; i<canPassFloorIndex.length; i++) if(floorIndex == canPassFloorIndex[i]) return true;     // check if face with road, props, special event
      if(checkIfFightable(floorIndex)) return true;                                                         // check if face with monster
      return false;
    }
    
    //****************** Braver Fighting ***********************//
    boolean checkIfFightable(int floorIndex){
      Creature tmep = new Creature(0, this.hp, this.atk, this.def, this.gold);
      if(floorIndex>=105 && floorIndex<140){ // check if at correct monster index
        creatureData.updateCurrentFightMonster(floorIndex);     // update the fighting monster data
        while(true){
          tmep.Combat(creatureData.currentFightMonster);
          creatureData.currentFightMonster.Combat(tmep);
          if(tmep.hp <= 0){
            if(showConsoleText) println("Too Strong, can not fight at the moment");
            return false;  // Unable to fight with monster
          } 
          else if(creatureData.currentFightMonster.hp <= 0){
            if(showConsoleText) println("After testing, this monster can be fight");
            break;
          }
        }
        creatureData.updateCurrentFightMonster(floorIndex);     // update the fighting monster data
        return true;                                            // able to fight with monster 
      }
      return false; 
    }
     
    
    //****************** Braver Weapon ***********************//
    void initSwardShield(){
      sward = 5;
      shield = 5;
      swardName = new String[6];
      shieldName = new String[6];
      String[] temp = loadStrings("..\\Data\\Sward-Shield.txt");
      for(int i=0; i<6; i++) swardName[i] = temp[i];
      for(int i=0; i<6; i++) shieldName[i] = temp[i+6];
    }
    
    //****************** Braver KeyArray ***********************//
    // Set  List--(1-yellow, 2-blue, 3-red )
    
    void drawKeyList() {
     int numKey =0;
     for (int i=0; i<3; i++) {
       for (int j=0; j<6; j++) {
         while (!(keyArray[numKey] >0 && keyArray[numKey] < 4)) {
           if (numKey== 39) return;
           numKey++;
         }
         imageData.drawUIKey(keyArray[numKey], 595+j*20, 150+i*25);
         numKey++;
      }
    }
}
    
    int checkKeyExist(int keyIndex){      //  return -1 if not found the key on the keylist
      for(int i=0; i<keyArray.length; i++){
        if(keyArray[i] == keyIndex) return i;
      }
      return -1;
    }
    
    boolean removeKey(int keyIndex){
      keyIndex-=6; //<>//
      println(keyIndex);
      int index = checkKeyExist(keyIndex);
      if(index >= 0){
        if(showConsoleText) println("successfully remove the key on the key list, keyIndex is: " + keyArray[1] + ", and the index is: " + index );
        keyArray[index] = 0;
        return true;       // successfully remove the key on the key list;
      }
      else{
        if(showConsoleText) println("No corresponding key founded, unable to open the door.");
        return false;  
      }
    }
    
    boolean addKey(int keyIndex){
      for(int i=0; i<keyArray.length; i++){
        if(keyArray[i] == 0){
          keyArray[i] = keyIndex; 
          if(showConsoleText) println("Get Key, Index is :" + keyIndex);
          return true;
        }
      }
      if(showConsoleText) println("Cannot add any more key at the moment");
      return false;
    }
     //<>//
    
    //******************* Braver Text ********************//
    void showText(){    //Showing the braver status onto the UI interface
      fill(255);
      textSize(18);
      PFont font1 = createFont("Microsoft YaHei Bold",18);
      textFont(font1);
      textAlign(CENTER);
      if (floor>9) {
        text(floor, 103, 52);
      } else text(floor, 104, 52);
      textSize(16);
      textAlign(RIGHT);
      text(hp, 134, 86);
      text(atk, 134, 115);
      text(def, 134, 143);
      text(gold, 134, 171);
      
      // show sward & shield name and index on UI interface
      textAlign(CENTER);
      text(swardName[sward], 635, 69);
      text(shieldName[shield], 635, 127);
      if (sward !=0) imageData.drawItemImagePixel(sward+39,671, 30, imgScale*1.4);
      if (shield !=0) imageData.drawItemImagePixel(shield+44, 670, 87, imgScale*1.4);
      
      drawKeyList();
    }
}

//---Monster Class-------------------------------------------------------------------------------------------------------------------------
class Monster extends Creature {
    String name;
    Monster(){
      super(16,1000,10,10,0); 
      name = "怪物名字";
    }
    Monster(int index, String name, int hp, int atk, int def, int gold){
      super(index,hp, atk, def, gold); 
      this.name = name;
    }
    //******************* Monster Text ********************//
    void showUIText(){    //Showing the Monster status onto the UI page
      fill(255);
      textSize(18);
      PFont font1 = createFont("Microsoft YaHei Bold",18);
      textFont(font1);
      textAlign(CENTER);
      text(name, 660, 314);
      text(hp, 680, 338);
      text(atk, 680, 362);
      text(def, 680, 388);
      //imageData.drawAnimatedImagePixel(index, 635, 245);
    }
    
    //******************* Monster Status Text ********************//
    void showMonsterStatusText(int nameX, int nameY, int hpX, int hpY, int atkX, int atkY, int defX, int defY, int goldX, int goldY, int CutHealthX, int CutHealthY){
      showNameTextPixel(nameX, nameY);
      showHpTextPixel(hpX, hpY);
      showAtkTextPixel(atkX, atkY);
      showDefTextPixel(defX, defY);
      showGoldTextPixel(goldX, goldY);
      showForecastHealthCut(CutHealthX,CutHealthY);
    }
    
    void showNameTextPixel(int pX, int pY){textAlign(LEFT); fill(255,255,255); text(name, pX, pY);}
    void showHpTextPixel(int pX, int pY){
      fill(255,255,255); text(hp, pX, pY);
    }
    void showAtkTextPixel(int pX, int pY){
      fill(255,255,255); text(atk, pX, pY);
    }
    void showDefTextPixel(int pX, int pY){
      fill(255,255,255); text(def, pX, pY);
    }
    void showGoldTextPixel(int pX, int pY){
      fill(255,255,255); text(gold, pX, pY);
    }
    void showForecastHealthCut(int pX, int pY){
      int num = foreCast();
      fill(247,5,5);
      if(num == -1){
        text("不可攻击", pX, pY);
      }
      else if(num ==0){
        fill(0,216,0);
        text("无危险", pX, pY);
      }
      else {
        text(num, pX, pY);
      }
    }
    
    
    int foreCast(){
      int cutHP=0; // save the data of how much health that the braver need to fight with this monster
      Creature tempBraver = new Creature(0, creatureData.braver.hp, creatureData.braver.atk, creatureData.braver.def, creatureData.braver.gold);
      Creature tempMonster = new Creature(0, this.hp, this.atk, this.def, this.gold);
      while(true){
        tempBraver.Combat(tempMonster);
        tempMonster.Combat(tempBraver);
        println(tempBraver.hp, tempBraver.atk, tempBraver.def, tempBraver.gold);
        println(tempMonster.hp, tempMonster.atk, tempMonster.def, tempMonster.gold);
        if(tempBraver.hp <= 0 || tempBraver.atk - tempMonster.def <= 0){
          if(showConsoleText) println("Too Strong, can not fight at the moment");
          return -1;  // Unable to fight with monster
        } 
        else if(tempMonster.hp <= 0){
          if(showConsoleText) println("After testing, this monster can be fight");
          if(cutHP <= 0) return 0;
          else return cutHP;
        }
        cutHP+=tempMonster.atk - tempBraver.def;
      }                                        // able to fight with monster 
    }
}
      
//--------------------------------------------------------------------------------------------------------------------------------
class NPC{
  
}

//---The dataSet of all creaters---------------------------------------------------------------------------------------------------------------
class CreatureData{

  Braver braver;
  Monster [] monster;
  Monster currentFightMonster;
  // NPC;
  
  CreatureData(){
    braver = new Braver();
    currentFightMonster = new Monster();
    loadMonsterData();
    
  }
  
  void updata(){
    braver.updateStatus();
  
  }
  
  
  void loadMonsterData(){       // initial monster data 
    monster = new Monster[35];
    String[] fileData = loadStrings("..\\Data\\Monster\\MonsterData.txt");
    
    for(int i=0; i<fileData.length; i++){
      String [] line = split(fileData[i], ' ');
      monster[i] = new Monster(int(line[5]), line[0],int(line[1]),int(line[2]), int(line[3]),int(line[4]));
    }
  }
  
  void updateCurrentFightMonster(int monsterindex){
    int arrayIndex = monsterindex-105;
    currentFightMonster.name = monster[arrayIndex].name;
    currentFightMonster.atk = monster[arrayIndex].atk;
    currentFightMonster.def = monster[arrayIndex].def;
    currentFightMonster.hp = monster[arrayIndex].hp;
    currentFightMonster.gold = monster[arrayIndex].gold;
  }
  
  void showUIText(){
    currentFightMonster.showUIText();
    braver.showText();
    
  }
  
  void movingBraver(int face, int moveX, int moveY){
    if(braver.moveable == true){
      braver.face = face; //<>//
      braver.moveBraver(moveX,moveY);
    }
  }
}
