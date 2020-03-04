// The world pixel by pixel 2020
// Daniel Rozin
// fliping pixels on X and Y using the copy() function
import processing.video.*;
Capture ourVideo;                                 // variable to hold the video object
void setup() {
  size(1280, 720, P3D);
  ourVideo = new Capture(this, width, height);    // open the capture in the size of the window
  ourVideo.start();
}

void draw() {                                  
  if (ourVideo.available())  ourVideo.read();           // get a fresh frame as often as we can

  copy(ourVideo, width/2, 0, width/2, height/2, width/2, 0, width/2, height/2);     // this will take care of the top right quadrant
  copy(ourVideo, width/2, 0, width/2, height/2, width/2, 0, -width/2, height/2);      // this will take care of the top left quadrant 
  copy(ourVideo, width/2, 0, width/2, height/2, width/2, height, width/2, -height/2);      // this will take care of the bottom right quadrant 
  copy(ourVideo, width/2, 0, width/2, height/2, width/2, height, -width/2, -height/2);   // this will take care of the bottom left quadrant
}
