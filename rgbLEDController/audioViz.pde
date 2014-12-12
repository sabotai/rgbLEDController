void audioViz() {

  strokeWeight(20*(rotAmt%frameCount));

  pushMatrix();

  translate(0, -frameCount/10, -frameCount); //push back and up
  translate(width/2, 0);
  rotAmt += scaleAmt/gain;
  //println(rotAmt %frameCount);
  rotateY((rotAmt%frameCount));

  translate(-width/2, 0);
  translate((width- (scaleAmt * width))/2, (height - (scaleAmt * height))/2);
  scale(scaleAmt);
  //background(0);
  noStroke();
  stroke(255, 100);
  float maxBuffer = 0;
  fill(0, 10);
  rect(0, 0, width+frameCount, height+frameCount);
  translate(0, height/2);
  //strokeWeight(5);

  for (int i = 0; i < in.bufferSize(); i++) {
    buffer[i] = in.mix.get(i); 
    //println("buffer " + i + " " + in.mix.get(i));
    if (buffer[i] > maxBuffer) {
      maxBuffer += buffer[i];
    }
  }

  strokeWeight(strokeSize);
  stroke(255, 200);

  float avgDiff = 0;
  float lrgDiff = 0;
  for (int i = 0; i < in.bufferSize ()-1; i++) {
    float x1 = map(i, 0, in.bufferSize(), 0, width);
    float x2 = map(i+1, 0, in.bufferSize(), 0, width);

    avgDiff += (buffer[i]-(buffer[i+1]));
    //line(x1, buffer[i] * gain*5, x2, buffer[i+1] * gain/5);
    //rect(x1, buffer[i] * gain, x1+10, buffer[i+1] * gain);
    //println(buffer[i] + " is buffer[i] and   " + buffer[i+1]);
    if (buffer[i] - (buffer[i+1]) > lrgDiff) {
      lrgDiff = buffer[i] - buffer[i+1];
    }
  }
  //println(avgDiff * gain/20);
  avgDiff /= in.bufferSize();
  scaleAmt = map(abs(avgDiff), 0, lrgDiff, 0.2, 200);
  //scale(scaleAmt);
  popMatrix();



  fft.forward(in.mix);
  int many =5;
  for (int i = 0; i < fft.specSize ()-many; i+= many) {
    int xx = width/fft.specSize();
    stroke(255);
    //rect(i * xx, height, i * xx * 2, height - fft.getBand(i)*100);
    stroke(255, 0, 0);
    //stroke(55,46,3,100);
    //fill(55, 46, 3, 100);
    //
    fill(255,0,0,100);
    //line(i*xx, height, i*xx, height - fft.getBand(i)*100); 


    for (int h = i; h < i+many; h++) {
      avg += fft.getBand(h);
    }
    avg /= many;
    noStroke();

    float avgColor = (avg * gain) / height;
    //println("avgColor is " + avgColor);


    if (avgColor > audioThreshold) {
      doLoop = true; 
      //println("LOOP TYME");
    } else {
      //if (avgColor < 0.4){
      //println("STOP THE LOOP");
      doLoop = false;
    }
    //}

    avgColor = constrain(avgColor, 0, 1);
    //fill(200 * avgColor, 10*avgColor, 10*avgColor, 50*avgColor);
    fill(255 * avgColor, 100*avgColor, 3*avgColor, 20*avgColor);
    rect(i * xx, height, (i+many) * xx, height - (avg * (gain) * (width/384)));
    //println(i * xx + ", " + ((i + many) * xx));


    avg = 0;
  }

  strokeSize = abs(avgDiff * gain * 20);
}



void stop() {

  in.close();
  minim.stop();
  super.stop();
}

//code below from https://processing.org/discourse/beta/num_1228991560.html

class InputOutputBind implements AudioSignal, AudioListener
{
  private float[] leftChannel ;
  private float[] rightChannel;
  InputOutputBind(int sample)
  {
    leftChannel = new float[sample];
    rightChannel= new float[sample];
  }
  // This part is implementing AudioSignal interface, see Minim reference
  void generate(float[] samp)
  {
    arraycopy(leftChannel, samp);
  }
  void generate(float[] left, float[] right)
  {
    arraycopy(leftChannel, left);
    arraycopy(rightChannel, right);
  }
  // This part is implementing AudioListener interface, see Minim reference
  synchronized void samples(float[] samp)
  {
    arraycopy(samp, leftChannel);
  }
  synchronized void samples(float[] sampL, float[] sampR)
  {
    arraycopy(sampL, leftChannel);
    arraycopy(sampR, rightChannel);
  }
} 
//end sourced code
