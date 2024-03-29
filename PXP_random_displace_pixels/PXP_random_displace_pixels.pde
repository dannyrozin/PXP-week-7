// The world pixel by pixel 2022
// Daniel Rozin
// randomly displaces  pixels
import processing.video.*;

Capture ourVideo;                                 // variable to hold the video object
void setup() {
  size(1280, 720);
  frameRate(120);
  ourVideo = new Capture(this, width, height);    // open the capture in the size of the window
  ourVideo.start();
}

void draw() {
  if (ourVideo.available())  ourVideo.read();           // get a fresh frame as often as we can
  ourVideo.loadPixels();                               // load the pixels array of the video                             // load the pixels array of the window  
  loadPixels(); 
 // randomSeed(0);          // add this to get the random not flicker
  for (int x =  0; x< width; x++) {                   // visit all pixels
    for (int y = 0; y< height; y++) {    
     float distToMouse= dist(mouseX, mouseY, x,y)/10;       // get the distance from the mouse to this pixel
     float sourceX= x+ random(-distToMouse,distToMouse);     // calculate a displacement porportional to the distance to mouse
      float sourceY= y+ random(-distToMouse,distToMouse);
      sourceX= constrain(sourceX, 0, width-1);               // make sure we are still in the image
      sourceY= constrain(sourceY, 0, height-1);
      PxPGetPixel(int(sourceX), int(sourceY), ourVideo.pixels, width);      // get the R,G,B of the pixel
      PxPSetPixel(x, y, R,G,B,255,pixels, width);                        // set the RGB of our to screen
    }
  }
updatePixels();
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
