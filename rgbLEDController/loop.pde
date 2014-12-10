void loops() {


  while (loopIterator < checkbox.getArrayValue ().length) {

    //println("next while cycle");
    int n = (int)checkbox.getArrayValue()[loopIterator];
    if (n==1) {
      if (millis() > startTime + clearTime) {
        //print(n);
        //println("sending " + loopIterator);
        sendCode(int(checkbox.getItem(loopIterator).internalValue()));
        startTime = millis();
        loopIterator++;
      }
    } else {
      startTime = millis();
      loopIterator++;
    }
  }
  loopIterator = 1;
  //println("loop completed");

  if (doAudioViz) {
    doLoop = false;
  }
}
