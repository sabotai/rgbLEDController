void loops() {
  //println("beginning loop ... iterator = " + loopIterator);
  
  if (loopIterator >= division) {
    outputChannel = 1;
  } else {
  outputChannel = 0;
    
  }
  
  if (loopIterator < checkbox.getArrayValue ().length) {
    if (((outputChannel == 0) && (ready)) || ((outputChannel == 1) && (ready1)) ) {
      //println("next while cycle");
      int n = (int)checkbox.getArrayValue()[loopIterator];
      if (n==1) {
        //if (millis() > startTime + clearTime) {
          //print(n);
//println("sending " + loopIterator);
          sendCode(int(checkbox.getItem(loopIterator).internalValue()));
          startTime = millis();
          if (outputChannel == 0){
          ready = false;} else {
           ready1 = false; 
          }
          loopIterator++;
        //}
      } else {
        startTime = millis();
        loopIterator++;
      }
    }
  } else {

    /* //old way
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
     */
    loopIterator = 1;
    //println("loop completed");

    if (doAudioViz) {
      doLoop = false;
    }
  }
}
