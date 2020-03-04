// The world pixel by pixel 2020
// Daniel Rozin
// rotate an image by using copy() and rotate()

PImage ourImage;
float angle =0;
void setup() {
  size(1000, 800);
  frameRate(120);
  ourImage= loadImage("http://images6.fanpop.com/image/photos/40600000/Seal-Pup-seals-40692293-1024-768.jpg");
  ourImage.resize (width, height);
}

void draw() {
  angle+=0.01;                          // icrement our angle , we dont care if it gets too big cause rotate() will fix it
  image(ourImage, 0, 0);                // draw the whole image
  translate(mouseX, mouseY);            // we want to center around mouse
  rotate(angle);                        // anythng done after this will be rotated
  copy(ourImage, mouseX-50, mouseY-50, 100, 100,  -100, -100, 200, 200);
  

  // copy takes the following params:
  // source image,
  // source rect
  // destination rect
  // by changing the size of the rects you can shrink or grow an image
}
