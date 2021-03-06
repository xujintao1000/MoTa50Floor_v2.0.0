int imgScale = 32;
boolean showConsoleText = true;
int monsterImageChangeRate = 10;
int doorOpenChangeRate = 10;
int fightingTimePeriod = 30;

int canPassFloorIndex[] = {0, 10, 11, 20, 21, 22, 23, 24, 25, 28, 29, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50,51, 52, 53, 54,55,56,57,58,59, 60, 61,62,63,201};


void initFloorArray(){
  String[] floorData = loadStrings("..\\Data\\Floor\\FloorData.txt");
  int x=0, y=0, floor =0;
  for(int line=0; line<floorData.length; line++){
    if(!floorData[line].isEmpty()){   // ckeck if empty line catch
      if(y==13){
        floor++;
        y=0;
      }
      int i=0; // save the index of floorData after continue of looping 
      while(i != floorData[line].length()){
        if(floorData[line].charAt(i) != ' '){
          String num = new String();
          num = num + floorData[line].charAt(i);
          while((i+1)<floorData[line].length() && floorData[line].charAt(i+1) != ' '){
            num += floorData[line].charAt(i+1);
            i++;
          }
          floorArray[floor][y][x] = int(num);
          x++;
        }
        i++;
      }
      if(x!=0) y++;
      x=0;
    }
  }
}
