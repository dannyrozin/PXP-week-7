// The world pixel by pixel 2018
// Daniel Rozin
// randomly displace rectages in an image based on sound  image by using copy() 

import processing.sound.*;
Amplitude amp;
AudioIn in;
int R, G, B, A;          // you must have these global varables to use the PxPGetPixel()
PImage ourImage;
float angle =0;
void setup() {
  size(1000, 800,P3D);        // some things such as copy() work much faster in P3D mode
  frameRate(120);
  ourImage= loadImage("http://dreamatico.com/data_images/flowers/flowers-4.jpg");
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
println (frameRate);

// copy takes the following params:
// source image,
// source rect
// destination rect
// by changing the size of the rects you can shrink or grow an image
}








// our function for getting color components , it requires that you have global variables
// R,G,B   (not elegant but the simples way to go, see the example PxP methods in object for 
// a more elegant solution

void PxPGetPixel(int x, int y, int[] pixelArray, int pixelsWidth) {
  int thisPixel=pixelArray[x+y*pixelsWidth];     // getting the colors as an int from the pixels[]
  A = (thisPixel >> 24) & 0xFF;                  // we need to shift and mask to get each component alone
  R = (thisPixel >> 16) & 0xFF;                  // this is faster than calling red(), green() , blue()
  G = (thisPixel >> 8) & 0xFF;   
  B = thisPixel & 0xFF;
}


//our function for setting color components RGB into the pixels[] , we need to efine the XY of where
// to set the pixel, the RGB values we want and the pixels[] array we want to use and it's width

void PxPSetPixel(int x, int y, int r, int g, int b, int a, int[] pixelArray, int pixelsWidth) {
  a =(a << 24);                       
  r = r << 16;                       // We are packing all 4 composents into one int
  g = g << 8;                        // so we need to shift them to their places
  color argb = a | r | g | b;        // binary "or" operation adds them all into one int
  pixelArray[x+y*pixelsWidth]= argb;    // finaly we set the int with te colors into the pixels[]
}