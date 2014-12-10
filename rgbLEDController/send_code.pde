
void sendCode(int which) {
  int outputChannel = 0;

  if (which > division) {
    outputChannel = 1;
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
