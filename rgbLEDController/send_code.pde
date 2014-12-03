
void sendCode(int which) {

  String bufferString = str(unhex(data[which][3]));
  myPort.write(bufferString);
  myPort.write('*');  //signal finished command
}
