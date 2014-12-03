
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

boolean runCustom = false;

ControlP5 cp5;

String textValue = "";

void setup() 
{
  size(1920, 1080);



  rawData = loadStrings("data/commandList.csv");
  splitData();

  println(Serial.list());
  String portName = Serial.list()[32];
  myPort = new Serial(this, portName, 9600);

  xSpacing = (0.6 * (width/numCols));
  ySpacing = (height/(numRows+1));


  cp5 = new ControlP5(this);

  PFont pfont = createFont("Anita  Semi-square", 30, true); // use true/false for smooth/no-smooth
  PFont font = createFont("Anita  Semi-square", 48);
  ControlFont cFont = new ControlFont(pfont, 30);

  textSize(22);
  //cp5.label

  cp5.addTextfield("Command")
    .setPosition(xSpacing * numCols, 100)
      .setSize(400, 80)
        .setFont(font)
          .setFocus(true)
            .setColor(color(100, 100, 255))
              //.setText(100)

              .setAutoClear(false)
              .captionLabel().setFont(cFont);
                ;

  cp5.addBang("submit")
    .setPosition(xSpacing * numCols+240, 200)
      .setSize(160, 60)
        .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
          ;
          
  cp5.getController("submit").captionLabel().setFont(cFont);

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

      float xPos = 40+ i * xSpacing;
      float yPos = 40+j * ySpacing;


      text(data[j][i], xPos, yPos);
    }
  }


  //show the serial read in the console
  if (myPort.available() > 0) {
    receivedChar = (char)myPort.read();
    print(receivedChar);
  }

  if (runCustom) {
    customRun();
  }


  //text(cp5.get(Textfield.class,"input").getText(), 360,130);
  //text(textValue, 360, 180);
}

void sendCode(int which) {

  String bufferString = str(unhex(data[which][3]));
  myPort.write(bufferString);
  myPort.write('*');  //signal finished command
}


void customRun() {
  if (frameCount % 50 == 0) {
    println("go2");
    sendCode(7);
  }
  if (frameCount % 70 == 0) {
    println("go3");
    sendCode(15);
  }
}
