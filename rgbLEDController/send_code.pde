
void sendCode(int which) {

  if (which >= division) {
    outputChannel = 1;
  } else {
  outputChannel = 0;
    
  }



  String bufferString = str(unhex(data[which][3]));


  if ((numOutputs == 2)  && (outputChannel == 1)) {
    myPort1.write(bufferString);
    myPort1.write('*');
  } else {


    myPort.write(bufferString);
    myPort.write('*');  //signal finished command
  }
}
