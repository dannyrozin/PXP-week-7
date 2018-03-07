// The world pixel by pixel 2018
// Daniel Rozin
// scale an image

int R, G, B, A;          // you must have these global varables to use the PxPGetPixel()
PImage ourImage;
float scale = 2;
void setup() {
  size(1000, 800);
  frameRate(120);
  ourImage= loadImage("http://dreamatico.com/data_images/flowers/flowers-4.jpg");
  ourImage.resize (width, height);
  ourImage.loadPixels();                              // load the pixels array of the image
  noFill();
}

void draw() {
  image(ourImage, 0, 0);
  loadPixels(); // load the pixels array of the window  

  float shiftX = mouseX *  (1-scale);                            // we want the effect to be centered around the mouse, and we want the pixel under the mouse to stay...    
  float shiftY = mouseY *  (1-scale);                            // where it is
  for (int x = max(mouseX-100, 1); x<min(mouseX+100, width-1); x++) {     // looping 100 pixels around the mouse, we have to make sure we wont 
    for (int y = max(mouseY-100, 1); y<min(mouseY+100, height-1); y++) {  // be accessing pixels outside the bounds of our array
      if (dist (x, y, mouseX, mouseY)< 100) {
        float sourceX = x * scale+shiftX;                // calculating the source for every pixel and adding the shift...
        float sourceY = y * scale+shiftY;  
        sourceX=constrain (sourceX, 0, width-1);         //make sure we are not going outside of the image
        sourceY=constrain (sourceY, 0, height-1);
        PxPGetPixel(int(sourceX), int(sourceY), ourImage.pixels, width);      // get the RGB of our pixel and place in RGB globals

        PxPSetPixel(x, y, R, G, B, 255, pixels, width);    // sets the R,G,B values to the window
      }
    }
  }
  updatePixels();                                     //  must call updatePixels oce were done messing with pixels[]


  stroke(200, 100, 100);                             // just for fun adding rings
  strokeWeight(4);
  ellipse(mouseX, mouseY, 200, 200);
  stroke(0);
  strokeWeight(1);
  arc(mouseX, mouseY, 198, 198, PI, 2*PI);
  arc(mouseX, mouseY, 206, 206, 0, PI);
  stroke(255);

  arc(mouseX, mouseY, 198, 198, 0, PI);
  arc(mouseX, mouseY, 206, 206, PI, 2*PI);


  arc(mouseX, mouseY, 110, 110, 0, 1.6);
  arc(mouseX, mouseY, 120, 120, 0, 1.6);
  arc(mouseX, mouseY, 140, 140, 0, 1.6);
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