
class frameRate{
  byte imgChangeRate = 0;
  boolean isOpenDoor = false, isShowMonsterList =false;
  
  int doorOpenRate = 0;
  int doorIndex =0;
  int doorX=0, doorY=0;
}

class ImageData extends frameRate{
  private PImage ITEM, BACKGROUND, HINT, REFERENCE, REFBACKGROUND; 
  private int [][] itemLoc;   // init with 250 image location
  
  ImageData(){
    itemLoc = new int[250][4];
    ITEM = new PImage();
    BACKGROUND = new PImage();
    HINT = new PImage();
   
    ITEM = loadImage("..\\MoTa_Img\\Mota50Floor.png");
    BACKGROUND = loadImage("..\\MoTa_Img\\Mota50Frame.png");
    HINT = loadImage("..\\MoTa_Img\\BlueImage.png");
    REFERENCE = loadImage("..\\MoTa_Img\\Reference.png");
    REFBACKGROUND = loadImage("..\\MoTa_Img\\ReferenceBackground.png");
    String[] totalItemLoc = loadStrings("..\\Data\\Floor\\PictureLocation.txt");     // capture the each item location on item image
    for(int i=0; i<totalItemLoc.length; i++){
      if(totalItemLoc[i].isEmpty()) continue;
      String[] currentLoc = split(totalItemLoc[i], ' ');
      for(int j=0; j<4; j++){
        itemLoc[int(currentLoc[5])][j] = int(currentLoc[j]); //  currentLoc[5] always save the fix item index 0-1 & 2-3 save the first and second x-y positions.
      }
    }
  }

  void drawGameBoard(){
    drawBackground();
    drawFloorIndexImage();
    drawBraver();
    drawMagicItem();
  }
  
  void update(){
    if(imageData.isShowMonsterList){
      showMonsterList();
    }
    updateChangeRate();
  }
  
//--------Monster List------------------------------------------------------------------------------------------------------------------------
  void showMonsterList(){
    drawRefenceBackGround();
        // save the all monster without same index that live on current Floor, 
        // and return the floorIndex array into the drawMonsterUIText() funtion to draw all the text and image from that aray
    drawMonsterUIText(getCurrentFloorIndex());                                                
    
  }
  
  void drawMonsterUIText(int [] monsterIndex){
    int maxLimit = 0;  // should not show over than 7 monster data at the same time
    for(int index=0; index<monsterIndex.length; index++){
      if(monsterIndex[index] == 0 ) continue;
      int x = 256, y = 80+index*40;
      drawReference(monsterIndex[index], x, y);
      creatureData.monster[monsterIndex[index]-105].showMonsterStatusText(x+20, y+16, x+35, y+37, x+90, y+37, x + 160, y+37, x + 220, y +37, x+160, y+16);
      if(maxLimit>=6) return;
      else maxLimit++;
    }
  }
  
 void switchOnMonsterList(){
   if(isShowMonsterList == true) isShowMonsterList = false;
   else isShowMonsterList = true;
 }
 
   int[] getCurrentFloorIndex(){
     int floorIndex = 0, monsterNum=0;
     int [] monsterIndex = new int [20];     
     for(int i=0; i<13; i++){
      for(int j=0;j<13; j++){
        floorIndex = floorArray[creatureData.braver.floor][i][j];
        if(floorIndex >= 105 && floorIndex < 140){
          boolean isSame = false;
          for(int index=0; index<monsterNum; index++){
            if(monsterIndex[index] == floorIndex) isSame = true;
          }
          if(!isSame){
            monsterIndex[monsterNum] = floorIndex;
            monsterNum++;
          }
        }
      }
    }
    return monsterIndex;
   }
 
//--------BackGround------------------------------------------------------------------------------------------------------------------------
  void drawBackground(){
    image(BACKGROUND,0,0);
  }
  void drawRefenceBackGround(){
    image(REFBACKGROUND,192,32);
  }
  void drawReference(int floorIndex, int pX, int pY){
    if(floorIndex ==124) image(ITEM,pX-50,pY,imgScale*1.3,imgScale*1.3,itemLoc[124][0]+imgChangeRate*imgScale*3, itemLoc[124][1], itemLoc[124][2]+imgChangeRate*imgScale*3, itemLoc[124][3]);
    else if (floorIndex == 138) image(ITEM,pX-50,pY,imgScale*1.3,imgScale*1.3,itemLoc[138][0]+imgChangeRate*imgScale*3, itemLoc[138][1], itemLoc[138][2]+imgChangeRate*imgScale*3, itemLoc[138][3]);
    else drawAnimatedImagePixel(floorIndex,pX-50,pY, imgScale*1.3);
    image(REFERENCE, pX,pY);
  }
  void drawHintBackGround(){
    image(HINT,6*imgScale,48, imgScale*11, imgScale*6);
  }
  
  void drawHideBackGround(){
    fill(128, 128,128);
    rect(6*imgScale, imgScale, 11*imgScale, 11*imgScale);
  } 
//-------- Item ---------------------------------------------------------------------------------------------------------------------------
  void drawFloorIndexImage(){   // the all the index which indicate the relavent images
    for (int i=0; i<13; i++) {
      for (int j=0; j<13; j++) {
        int floorIndex = floorArray[creatureData.braver.floor][i][j];
        if (floorIndex<97 && floorIndex!=4 && floorIndex!=6) imageData.drawItemImage(floorIndex, j, i);        // draw fix item
        else if(floorIndex == 124 || floorIndex == 138) drawAnimatedBigImage(floorIndex, j,i);
        else  imageData.drawAnimatedImage(floorIndex, j, i);    // draw moveable icon Ex: monster
      }
    }
  }
  
  void drawMagicItem() {
      int magicIndex =0;
      for (int i=0; i<5; i++) {
        for (int j=0; j<3; j++) {
          if (creatureData.braver.magicItem[magicIndex] == true) {
            imageData.drawItemImagePixel(magicIndex+50, (j+0.6)*imgScale*1.2, (i+5.2)*imgScale*1.2, imgScale*1.2);
          }
          magicIndex++;
        }
      }
    }
  
//-------- ChangeRate ---------------------------------------------------------------------------------------------------------------------------
  
  void updateChangeRate(){
    if(frameCount % monsterImageChangeRate ==0){
      if(imgChangeRate >= 3) imgChangeRate = 0;
      else imgChangeRate++;
    }
    if(isOpenDoor){
      drawAnimatedImage(doorIndex,doorX, doorY, doorOpenRate);
      if(frameCount % doorOpenChangeRate == 0 ){
        if(doorOpenRate == 3){ 
          doorOpenRate=0; 
          isOpenDoor=false;
          creatureData.braver.moveable = true;
          setFloorIndex();      // used for appear wall condition and set the floor index into 1
        }
        else doorOpenRate++;
      }
    }
    if(creatureData.braver.isFighting){
      imageData.drawFightingImg(creatureData.braver.x,creatureData.braver.y);
    }
  }
  
  void setFloorIndex(){
    if(doorIndex == 17){
      floorArray[creatureData.braver.floor][doorY][doorX] = 1;
    }
  }
  
  void drawItemImage(int index, int x, int y){                 // draw fix Image onto gameBoard. the scale is limit to 11*11
    x = (x+5)*imgScale;
    y = y * imgScale;
    image(ITEM,x,y,imgScale,imgScale,itemLoc[index][0], itemLoc[index][1], itemLoc[index][2], itemLoc[index][3]);
  }
  
  void drawItemImagePixel(int index, int pX, int pY){                 // draw fix Image onto gameBoard. the scale is limit to 11*11
    image(ITEM,pX,pY,imgScale,imgScale,itemLoc[index][0], itemLoc[index][1], itemLoc[index][2], itemLoc[index][3]);
  }
  
  void drawItemImagePixel(int index, int pX, int pY, float ChangedScale){                 // draw fix Image onto gameBoard. the scale of the image can adjustable from the input changedScale
    image(ITEM,pX,pY,ChangedScale,ChangedScale,itemLoc[index][0], itemLoc[index][1], itemLoc[index][2], itemLoc[index][3]);
  }
  
  void drawItemImagePixel(int index, float pX, float pY, float ChangedScale){                 // draw fix Image onto gameBoard. the scale of the image can adjustable from the input changedScale
    image(ITEM,pX,pY,ChangedScale,ChangedScale,itemLoc[index][0], itemLoc[index][1], itemLoc[index][2], itemLoc[index][3]);
  }
  
  void drawAnimatedImage(int index, int x, int y){ // draw Animated Image onto gameBoard the scale is limit to 11*11
    frameRate= (frameRate%4)*32;
     x = (x+5)*imgScale;
     y= y * imgScale;
      image(ITEM,x,y,imgScale,imgScale,itemLoc[index][0]+imgChangeRate*imgScale, itemLoc[index][1], itemLoc[index][2]+imgChangeRate*imgScale, itemLoc[index][3]);
  }
  
  void drawAnimatedImage(int index, int x, int y, int rate){ // draw Animated Image onto gameBoard with special rate. EX: doorRate
    //frameRate= (frameRate%4)*32;
     x = (x+5)*imgScale;
     y= y * imgScale;
      image(ITEM,x,y,imgScale,imgScale,itemLoc[index][0]+rate*imgScale, itemLoc[index][1], itemLoc[index][2]+rate*imgScale, itemLoc[index][3]);
  }
  
   void drawAnimatedBigImage(int index, int x, int y){   // draw Animated Image onto gameBoard with special rate. 3*3
     x = (x+5)*imgScale;
     y= y * imgScale;
      image(ITEM,x,y,imgScale*3,imgScale*3,itemLoc[index][0]+imgScale*3*imgChangeRate, itemLoc[index][1], itemLoc[index][2]+imgScale*3*imgChangeRate, itemLoc[index][3]);
  }
  
  void drawAnimatedImagePixel(int index, float pX, float pY){ // draw Animated Image onto gameBoard the scale is limit to 11*11
    image(ITEM,pX,pY,imgScale,imgScale,itemLoc[index][0]+imgChangeRate*imgScale, itemLoc[index][1], itemLoc[index][2]+imgChangeRate*imgScale, itemLoc[index][3]);
  }
  
  void drawAnimatedImagePixel(int index, float pX, float pY, float ChangedScale){ // draw Animated Image onto gameBoard the scale is limit to 11*11
    image(ITEM,pX,pY,ChangedScale,ChangedScale,itemLoc[index][0]+imgChangeRate*imgScale, itemLoc[index][1], itemLoc[index][2]+imgChangeRate*imgScale, itemLoc[index][3]);
  }
  
//-------- FightImage ---------------------------------------------------------------------------------------------------------------------------
  void drawFightingImg(int x, int y){
    x = (x+5)*imgScale;
    y = y*imgScale;
    image(ITEM,x,y,imgScale,imgScale,itemLoc[149][0]+imgChangeRate*imgScale, itemLoc[149][1], itemLoc[149][2]+imgChangeRate*imgScale, itemLoc[149][3]);   // index of 149 represent fighting image
  }
//-------- UI Interface ---------------------------------------------------------------------------------------------------------------------------
  void drawUIKey(int index, int pX, int pY){
    switch(index){ // input of index should be 1-3
      case 1: index = 36; break;  // Yellow key
      case 2: index = 37; break; // blue key
      case 3: index = 38; break;   // red key
    }
    image(ITEM,pX,pY,imgScale/7*5,imgScale/7*5,itemLoc[index][0], itemLoc[index][1], itemLoc[index][2], itemLoc[index][3]);
  }
  
 
  
  void drawUIBraverItem(int index, int pX, int pY){      // use for drawing the UI magic item, sward and shield
    image(ITEM,pX,pY,imgScale,imgScale,itemLoc[index][0], itemLoc[index][1], itemLoc[index][2], itemLoc[index][3]);
  }

//-------- Braver ---------------------------------------------------------------------------------------------------------------------------
  void drawBraver(){ // 1-left 2-up 3-right 4-down
    if(creatureData.braver.isMoving) drawAnimatedImagePixel(100+creatureData.braver.face-1, creatureData.braver.pX, creatureData.braver.pY);
    else drawItemImage(100+creatureData.braver.face-1, creatureData.braver.x, creatureData.braver.y);
  }
  void drawBraverPixel(){ // 1-left 2-up 3-right 4-down
    drawItemImagePixel(100+creatureData.braver.face-1, creatureData.braver.pX, creatureData.braver.pY);
  }
}
