// The world pixel by pixel 2022
// Daniel Rozin
// randomly displace rectages in an image based on sound  image by using copy() 

import processing.sound.*;
Amplitude amp;
AudioIn in;
PImage ourImage;
float angle =0;
void setup() {
  size(1000, 800,P3D);        // some things such as copy() work much faster in P3D mode
  frameRate(120);
  ourImage= loadImage("https://i.natgeofe.com/k/4566f48c-4997-41c9-9854-101246c25702/ring-tailed-lemur-pair_4x3.jpg");
  ourImage.resize (width, height);
  in = new AudioIn(this, 0);             // open libraries
  amp = new Amplitude(this);            
  in.start();                            // start listening to the mic
  amp.input(in);                         // tell it to analize the microphone
}

void draw() {
  float volume= amp.analyze();                        // get the lates analasys of the volume
  volume = map(volume, 0, 0.5, 0, 60);                 // its a small number so map to 0-60
  for (int i = 0; i<500; i++) {                       // lets draw 200 random rects per frame
    float randiX= random(0, width);                       // randomize numbers for x and y
    float randiY= random(0, height);

    float sourceX=  randiX+ random(-volume, volume);       // randomize a displacement coralated to the volume
    float sourceY=  randiY+ random(-volume, volume);

    copy(ourImage, int(sourceX), int(sourceY), 50, 50, int(randiX), int(randiY), 50, 50);
  }
}


// copy takes the following params:
// source image,
// source rect
// destination rect
// by changing the size of the rects you can shrink or grow an image
