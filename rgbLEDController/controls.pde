
void mouseClicked() {
  /*
  if (mouseX < (numCols * xSpacing)){
  count = (mouseY / int(ySpacing));

  println("Clicked on " + count);
  sendCode(count);
  }
  */
}

void keyReleased() {

  if (keyCode == UP) {
    //myPort.write( = str(unhex(data[3][3]));
    sendCode(3);
  } else if (keyCode == DOWN) {
    //bufferString = str(unhex(data[9][3]));
    sendCode(9);
  } else {
  
    if ((keyCode == RIGHT) || (keyCode == LEFT) || (keyCode == ENTER)) {
    if (keyCode == RIGHT) {
      count++;
    } else if (keyCode == LEFT) {
      count--;
    } else if (keyCode == ENTER) {
      //runCustom = !runCustom;
      doAudioViz = !doAudioViz;
    }
    count = constrain(count, 1, numRows-1);

    println(count);
    //String bufferString = str(unhex(data[myKey][3]));
    sendCode(count);
    }
  }
}
