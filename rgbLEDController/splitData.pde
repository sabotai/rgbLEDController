
void splitData() {

  numRows = rawData.length;
  data = new String[rawData.length][numCols]; //specify how many rows of data with the length function (to make it dynamic) and columns

  for (int i = 0; i < rawData.length; i++) { //for loop to split up the csv columns

    String[] pieces = split(rawData[i], ","); //split function (what it's splitting up, what the split cue is)

    for (int j=0; j<numCols; j++) {
      data[i][j] = pieces[j];
    }
  }
  
  
  for (int i = 2; i < numRows; i++){ //skip title and start comparison against the first one
   if (data[i][1].equals(data[i-1][1]) == false){
     division = i; //new remote type delineation
     howManyTypes++;
     println("old = " + data[i-1][1] + "  new = " + data[i][1]);
   } 
  }
  println("new type starting at row " + division);
}
