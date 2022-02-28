// The world pixel by pixel 2022
// Daniel Rozin
// scale an image by using copy()

PImage ourImage;
void setup() {
  size(1000, 800);
  frameRate(120);
  ourImage= loadImage("https://www.petmd.com/sites/default/files/petmd-kitten-facts.jpg");
  ourImage.resize (width, height);
}

void draw() {
  image(ourImage, 0, 0);   
  copy(ourImage, mouseX, mouseY, 100, 100, mouseX, mouseY, 200, 200);
}


  // copy takes the following params:
  // source image,
  // source rect
  // destination rect
  // by changing the size of the rects you can shrink or grow an image
