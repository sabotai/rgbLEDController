public void submit() {
  
  //println("whatever");
  //String testString = 
  //println();
    String bufferStringCustom = str(unhex(cp5.get(Textfield.class,"Command").getText()));//cp5.get(Textfield.class,"textValue").getText()));
  myPort.write(bufferStringCustom);
  myPort.write('*');  //signal finished command
  
  
  cp5.get(Textfield.class,"Command").clear();
}


public void input(String theText) {
  // automatically receives results from controller input
  println("a textfield event for controller 'input' : "+theText);
}


void controlEvent(ControlEvent theEvent) {
  
  
  if(theEvent.isAssignableFrom(Textfield.class)) {
    println("controlEvent: accessing a string from controller '"
            +theEvent.getName()+"': "
            +theEvent.getStringValue()
            );
  }
  
}
