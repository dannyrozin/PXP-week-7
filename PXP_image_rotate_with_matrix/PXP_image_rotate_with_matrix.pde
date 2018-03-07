// The world pixel by pixel 2018
// Daniel Rozin
// rotate an image by using copy() and rotate()

int R, G, B, A;          // you must have these global varables to use the PxPGetPixel()
PImage ourImage;
float angle =0;
void setup() {
  size(1000, 800);
  frameRate(120);
  ourImage= loadImage("http://dreamatico.com/data_images/flowers/flowers-4.jpg");
  ourImage.resize (width, height);
}

void draw() {
  angle+=0.01;                          // icrement our angle , we dont care if it gets too big cause rotate() will fix it
  image(ourImage, 0, 0);                // draw the whole image
  translate(mouseX, mouseY);            // we want to center around mouse
  rotate(angle);                        // anythng done after this will be rotated
  copy(ourImage, mouseX-50, mouseY-50, 100, 100, -100, -100, 200, 200);

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