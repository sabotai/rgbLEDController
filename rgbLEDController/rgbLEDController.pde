
import processing.serial.*;
import controlP5.*;


import ddf.minim.ugens.*;
import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.signals.*;





Serial myPort, myPort1;  // Create object from Serial class
int numOutputs = 1;

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

int count = 2;
float xSpacing, ySpacing;

boolean runCustom = false;
boolean doLoop = false;
float startTime = 0;
int loopIterator = 1;

//amount of time to wait between commands, otherwise results in garbage
//70 was ok for strip, 120 for bulb
float clearTime =120; 

ControlP5 cp5;
CheckBox checkbox;
ListBox l, l1;

String textValue = "";


////////////////////////////////////
//  audio visualizer
//values setup to work with headphones

Boolean doAudioViz = false;
float audioThreshold = 1.1;

Minim minim;
AudioInput in;
AudioOutput out;

Oscil fm;
InputOutputBind signal;

float buffer[];
float gain;
FFT fft;
float avg, strokeSize;
float scaleAmt, rotAmt, transZ;



//
////////////////////////////////////

void setup() 
{
  size(1920, 1080, P3D);



  rawData = loadStrings("data/commandList.csv");
  splitData();

  println(Serial.list());
  String portName = Serial.list()[32];
  myPort = new Serial(this, portName, 9600);
  if (numOutputs > 1) {
    String portName1 = Serial.list()[33];
    myPort1 = new Serial(this, portName1, 9600);
  }
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
    .setPosition(xSpacing * numCols+240, 220)
      .setSize(160, 60)
        .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
          ;

  cp5.getController("submit").captionLabel().setFont(cFont);


  l = cp5.addListBox("type1List")
    .setPosition(20, 100)
      .setSize(400, 600)
        .setItemHeight(60)
          .setBarHeight(60)
            //.setColorBackground(color(255, 128))
            //.setColorActive(color(0))
            //.setColorForeground(color(255, 100, 0))
            ;

  l.captionLabel().toUpperCase(true);
  l.captionLabel().set(data[1][1]);
  //l.captionLabel().setColor(0xffff0000);
  l.captionLabel().setFont(cFont);
  l.captionLabel().style().marginTop = 3;
  l.valueLabel().style().marginTop = 3;
  l.scroll(1000);

  for (int i=1; i<division; i++) {
    ListBoxItem lbi = l.addItem(data[i][2], i);
    //lbi.setColorBackground(0xffff0000);
  }

  l1 = cp5.addListBox("type2List")
    .setPosition(460, 100)
      .setSize(400, 600)
        .setItemHeight(60)
          .setBarHeight(60)
            //.setColorBackground(color(255, 128))
            //.setColorActive(color(0))
            //.setColorForeground(color(255, 100, 0))
            ;

  l1.captionLabel().toUpperCase(true);
  l1.captionLabel().set(data[division][1]);
  //l1.captionLabel().setColor(0xffff0000);
  l1.captionLabel().setFont(cFont);
  l1.captionLabel().style().marginTop = 3;
  l1.valueLabel().style().marginTop = 3;

  for (int i=division; i<numRows; i++) {
    ListBoxItem lbi = l1.addItem(data[i][2], i);
    //lbi.setColorBackground(0xffff0000);
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

  /*
//replaced with slider
   cp5.addTextfield("Loop Buffer Clear Time")
   .setPosition(xSpacing * numCols, 300)
   .setSize(400, 80)
   .setFont(font)
   .setFocus(true)
   .setColor(color(100, 100, 255))
   //.setText(100)
   
   .setAutoClear(false)
   .captionLabel().setFont(cFont);
   ;
   
   cp5.addBang("update")
   .setPosition(xSpacing * numCols+220, 420)
   .setSize(180, 60)
   .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
   ;
   */
  cp5.addSlider("clearTime")
    .setPosition(xSpacing * numCols, 300)
      .setSize(400, 40)
        .setRange(70, 5000)
          ;

  cp5.addSlider("audioThreshold")
    .setPosition(xSpacing * numCols, 360)
      .setSize(400, 40)
        .setRange(0, 3)
          ;


///////////////////////////////
// audio visualizer


  minim = new Minim(this);
  gain = height;
  int bufferSize = 1024;

  in = minim.getLineIn(Minim.MONO, bufferSize);
 
  buffer = new float[in.bufferSize()];
  fft = new FFT(in.bufferSize(), in.sampleRate());
  println(in.bufferSize());
  
  
  out = minim.getLineOut(Minim.MONO, bufferSize);
  
  
  signal = new InputOutputBind(bufferSize);
  //add listener to gather incoming data
  in.addListener(signal);
  // adds the signal to the output
  //out.addSignal(signal);
  /*
  
  Oscil wave = new Oscil( 200, 0.8, Waves.TRIANGLE );

  fm   = new Oscil( 10, 2, Waves.SINE );
  fm.offset.setLastValue( 200 );
  fm.patch( wave.frequency );
  wave.patch( out );
  */
  
  
  /////////////////////////////////


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


  if (doLoop) {
    loops();
  }
  
  if (doAudioViz){
   audioViz(); 
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
