
import processing.serial.*;
import controlP5.*;


Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port

String[] rawData;
String[][] data;
int selected = -1;
char receivedChar;
String received;

int numCols = 4; //specify this manually
int numRows = 0;

int count = 1;
float xSpacing, ySpacing;


void setup() 
{
  size(1920, 1080);

  rawData = loadStrings("data/commandList.csv");
  splitData();

  println(Serial.list());
  String portName = Serial.list()[32];
  myPort = new Serial(this, portName, 9600);

  xSpacing = (0.75 * (width/numCols));
  ySpacing = (height/(numRows+1));
  textSize(30);
}

void draw() {

  // draw out all the entries
  for (int i = 0; i < numCols; i++) {
    for (int j = 0; j < numRows; j++) {
      if (j == count) {
        fill(255, 255, 255);
      } else {
        fill(0);
      }

      float xPos = i * xSpacing;
      float yPos = j * ySpacing;


      text(data[j][i], xPos, yPos);
    }
  }


  //show the serial read in the console
  if (myPort.available() > 0) {
    receivedChar = (char)myPort.read();
    print(receivedChar);
  }
}

void mouseClicked() {
  count = (mouseY / int(ySpacing))+1;

  //if (mouseY < mouseY - yPos < 10){
  println("Clicked on " + count);
  sendCode(count);
  //count = j; 
  //}
}

void keyReleased() {

    if (keyCode == UP) {
      //myPort.write( = str(unhex(data[3][3]));
      sendCode(3);
    } else if (keyCode == DOWN) {
      //bufferString = str(unhex(data[9][3]));
      sendCode(9);
    } else {
      
    if (keyCode == RIGHT) {
      count++;
    } else if (keyCode == LEFT) {
      count--;
    }
    count = constrain(count, 1, numRows-1);

    println(count);
    //String bufferString = str(unhex(data[myKey][3]));
    sendCode(count);
      
  } 
}

void sendCode(int which) {

  String bufferString = str(unhex(data[which][3]));
  myPort.write(bufferString);
  myPort.write('*');  //signal finished command
}

void splitData() {

  numRows = rawData.length;
  data = new String[rawData.length][numCols]; //specify how many rows of data with the length function (to make it dynamic) and columns

  for (int i = 0; i < rawData.length; i++) { //for loop to split up the csv columns

    String[] pieces = split(rawData[i], ","); //split function (what it's splitting up, what the split cue is)

    for (int j=0; j<numCols; j++) {
      data[i][j] = pieces[j];
    }
  }
}
