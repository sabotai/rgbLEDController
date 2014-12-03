
import processing.serial.*;
import controlP5.*;


Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port


String[] rawData;
String[][] data;
int selected = -1;
char receivedChar;
String received;

int numCols = 5; //specify this manually
int numRows = 0;
int division = 0; //keep track of which row has a new 
int howManyTypes = 0;

int count = 1;
float xSpacing, ySpacing;

boolean runCustom = false;
boolean doLoop = false;
float startTime = 0;
float clearTime =70; //amount of time to wait between commands, otherwise results in garbage
int loopIterator = 1;

ControlP5 cp5;
CheckBox checkbox;
ListBox l, l1;

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
  ControlFont cFont = new ControlFont(pfont, 22);

  cp5.setControlFont(cFont);
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


  l = cp5.addListBox("type1List")
    .setPosition(20, 100)
      .setSize(400, 600)
        .setItemHeight(60)
          .setBarHeight(60)
            .setColorBackground(color(255, 128))
              .setColorActive(color(0))
                .setColorForeground(color(255, 100, 0))
                  ;

  l.captionLabel().toUpperCase(true);
  l.captionLabel().set(data[1][1]);
  l.captionLabel().setColor(0xffff0000);
  l.captionLabel().setFont(cFont);
  l.captionLabel().style().marginTop = 3;
  l.valueLabel().style().marginTop = 3;
  l.scroll(1000);

  for (int i=1; i<division; i++) {
    ListBoxItem lbi = l.addItem(data[i][2], i);
    lbi.setColorBackground(0xffff0000);
  }

  l1 = cp5.addListBox("type2List")
    .setPosition(460, 100)
      .setSize(400, 600)
        .setItemHeight(60)
          .setBarHeight(60)
            .setColorBackground(color(255, 128))
              .setColorActive(color(0))
                .setColorForeground(color(255, 100, 0))
                  ;

  l1.captionLabel().toUpperCase(true);
  l1.captionLabel().set(data[division][1]);
  l1.captionLabel().setColor(0xffff0000);
  l1.captionLabel().setFont(cFont);
  l1.captionLabel().style().marginTop = 3;
  l1.valueLabel().style().marginTop = 3;

  for (int i=division; i<numRows; i++) {
    ListBoxItem lbi = l1.addItem(data[i][2], i);
    lbi.setColorBackground(0xffff0000);
  }



  checkbox = cp5.addCheckBox("checkBox")
    .setPosition(20, 700)
      .setColorForeground(color(120))
        .setColorActive(color(255))
          .setColorLabel(color(255))
            .setSize(40, 40)
              .setItemsPerRow(6)
                .setSpacingColumn(270)
                  .setSpacingRow(10)
                    .addItem("Start/Stop Loop", 0);
  ;

  for (int i = 1; i < numRows; i++) {
    if (data[i][4].equals("yes") == true) {
      if (i < division) {
        checkbox.addItem(data[i][2] + " b", i);
      } else {
        checkbox.addItem(data[i][2] + " s", i);
      }
    }
  }
}

void draw() {
  background(0);


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
  if (doLoop) {
    loops();
  }
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
