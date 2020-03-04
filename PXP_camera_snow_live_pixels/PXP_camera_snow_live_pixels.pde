// The world pixel by pixel 2020
// Daniel Rozin
// snows live pixels, note that this just adds to an array so it will eventually slow down
import processing.video.*;
Flake[] snowFlakes= new Flake[0];
int [] floor = new int[1280];
Capture ourVideo;                                 // variable to hold the video object
void setup() {
  size(1280, 720);
  frameRate(120);
  ourVideo = new Capture(this, width, height);    // open the capture in the size of the window
  ourVideo.start();
  for (int i = 0; i < width; i++)floor[i]=height-2;   ///this array will accumolate the height of snow pile columns, we start at bottom = height
}

void draw() { 
  if (ourVideo.available()) {
    ourVideo.read();                       // get a fresh frame as often as we can
    image(ourVideo, 0, 0);                 
    for (int i = 0; i< 100; i++) {
      int randiX= (int)random(0, width);   // randomize an x and y positions
      int randiY= (int)random(0, floor[randiX]);
      snowFlakes = (Flake[])append(snowFlakes, new Flake(randiX, randiY));   // create new flake and add to our array
    }

    ourVideo.loadPixels();                               // load the pixels array of the video                             // load the pixels array of the window  
    loadPixels(); 

    for (int i = 0; i < snowFlakes.length; i++) {
      snowFlakes[i].drawFlake();                        // draw all the flakes we have in our growing array
    }

    updatePixels();
  }
}

class Flake {                                          // this is our class that stores one flake
  int posX, posY, Red, Green, Blue, sourceX, sourceY;
  Boolean dead = false;
  Flake(int _posX, int _posY) {
    posX= _posX;                                    // posX and posY are where the flake is now
    posY= _posY;
    sourceX= _posX;                                  // sourceX and sourceY are where the flake was "born"
    sourceY= _posY;
  }
  void  drawFlake() {   
    if (!dead) {                                    // if flake is not dead them move down
      posY+=1;
    }
    if (posY>=floor[posX] && !dead) {                // if you reached the floor then die
      floor[posX]--;                                 // and increase the column of the floor 
      dead = true;
    }
    PxPGetPixel(sourceX, sourceY, ourVideo.pixels, width);     // get the RGB from the original location of the pixel
    PxPSetPixel(posX, posY, R, G, B, 255, pixels, width);     // set the RGB of our to screen
    // PxPSetPixel(sourceX, sourceY, 0, 0, 0, 255, pixels, width);   // add this tp remove the original pixel
  }
}

// our function for getting color components , it requires that you have global variables
// R,G,B   (not elegant but the simples way to go, see the example PxP methods in object for 
// a more elegant solution
int R, G, B, A;          // you must have these global varables to use the PxPGetPixel()
void PxPGetPixel(int x, int y, int[] pixelArray, int pixelsWidth) {
  int thisPixel=pixelArray[x+y*pixelsWidth];     // getting the colors as an int from the pixels[]
  A = (thisPixel >> 24) & 0xFF;                  // we need to shift and mask to get each component alone
  R = (thisPixel >> 16) & 0xFF;                  // this is faster than calling red(), green() , blue()
  G = (thisPixel >> 8) & 0xFF;   
  B = thisPixel & 0xFF;
}

void mousePressed() {
  background(255);
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
