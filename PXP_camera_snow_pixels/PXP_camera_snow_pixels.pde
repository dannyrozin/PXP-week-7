// The world pixel by pixel 2016
// Daniel Rozin
// snow  pixels with class and objects
import processing.video.*;
Flake[] snowFlakes= new Flake[0];
int [] floor = new int[1280];
Capture ourVideo;                                 // variable to hold the video object
void setup() {
  size(1280, 720);
  frameRate(120);
  ourVideo = new Capture(this, width, height);    // open the capture in the size of the window
  ourVideo.start();
  for (int i = 0; i < width; i++)floor[i]=height-2; ///this array will accumolate the height of snow pile columns, we start at bottom = height
}


void draw() { 
  if (ourVideo.available()) {
    ourVideo.read();           // get a fresh frame as often as we can
    image(ourVideo, 0, 0);
    for (int i = 0; i< 100; i++) {
      int randiX= (int)random(0, width);                // randomize an x and y positions
      int randiY= (int)random(0, floor[randiX]);    
      PxPGetPixel(randiX, randiY, ourVideo.pixels, width); 
      snowFlakes = (Flake[])append(snowFlakes, new Flake(randiX, randiY, R, G, B)); // create new flake and add to our array
    }
  }
  ourVideo.loadPixels();                               // load the pixels array of the video                             // load the pixels array of the window  
  loadPixels(); 

  for (int i = 0; i < snowFlakes.length; i++) {
    snowFlakes[i].drawFlake();                             // draw all the flakes we have in our growing array
  }



  updatePixels();
}

class Flake {                                            // our flake class that stores a pixel and its colors
  int posX, posY, Red, Green, Blue;
  Boolean dead = false;
  Flake(int _posX, int _posY, int _R, int _G, int _B) {
    posX= _posX;                                        // store the location of the pixel
    posY= _posY;
    Red= _R;                                            // store the colors of the pixel
    Green = _G;
    Blue = _B;
  }     
  void  drawFlake() {                                 // if your not dead go down
    if (!dead) { 
      posY+=1;
    }

    if (posY>floor[posX] && !dead) {                  // if you reached the floor then die
      floor[posX]--;                                  // and make the floor heigher at that column
      dead = true;
    }
    PxPSetPixel(posX, posY, Red, Green, Blue, 255, pixels, width);     // set the RGB of our to screen
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