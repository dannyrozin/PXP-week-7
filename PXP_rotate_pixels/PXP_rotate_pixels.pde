// The world pixel by pixel 2019
// Daniel Rozin
// rotate pixels 
import processing.video.*;
float angle;
Capture ourVideo;                                 // variable to hold the video object
void setup() {
  size(1280, 720);
  frameRate(30);
  ourVideo = new Capture(this, width, height);    // open the capture in the size of the window
  ourVideo.start();
}

void draw() {
  image(ourVideo, 0, 0);
  if (ourVideo.available())  ourVideo.read();           // get a fresh frame as often as we can
  ourVideo.loadPixels();                               // load the pixels array of the video                             // load the pixels array of the window  
  loadPixels(); 
  angle+=0.1;
  float cosangle = cos(angle);                              // we calculate this once so that we don't need to calculate for each pixel
  float sinangle = sin(angle);  
  float shiftX =mouseX-(mouseX *cosangle-mouseY *sinangle) ;            // calculating the source pixel for the center pixel so we can center the rotation around the mouse
  float shiftY =   mouseY-(mouseX*sinangle +mouseY*cosangle);
  for (int x = max(mouseX-200, 1); x<min(mouseX+200, width-1); x++) {     // looping 200 pixels around the mouse, we have to make sure we wont 
    for (int y = max(mouseY-200, 1); y<min(mouseY+200, height-1); y++) {  // be accessing pixels outside the bounds of our array
      float distanceToMouse= dist (x, y, mouseX, mouseY);
      if (distanceToMouse< 200) {
       // try this for an interesting effect
       /*
        shiftX =mouseX-(mouseX *cosangle-mouseY *sinangle) ;            // calculating the source pixel for the center pixel so we can center the rotation around the mouse
        shiftY =   mouseY-(mouseX*sinangle +mouseY*cosangle);
        cosangle = cos(distanceToMouse/100.0);                              // we calculate this once so that we don't need to calculate for each pixel
        sinangle = sin(distanceToMouse/100.0);
        */
        
        float sourceX = x *cosangle-y *sinangle + shiftX ;        
        float sourceY = x*sinangle +y*cosangle +shiftY; 
        sourceX=constrain (sourceX, 0, width-1);         //make sure we are not going outside of the image
        sourceY=constrain (sourceY, 0, height-1);
        PxPGetPixel(int(sourceX), int(sourceY), ourVideo.pixels, width);          // get the R,G,B of the pixel

        PxPSetPixel(x, y, R, G, B, 255, pixels, width);     // set the RGB of our to screen
      }
    }
  }
  updatePixels();
  println(frameRate);
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
