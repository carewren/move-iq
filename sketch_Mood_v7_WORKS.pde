import processing.video.*;

Capture video;

color trackRed;
color trackBlue;
color red;
color blue;
boolean pixelRed;

float threshold = 30;
float distThreshold = 50;

ArrayList<Mood> beanieRed = new ArrayList<Mood>();
ArrayList<Mood> beanieBlue = new ArrayList<Mood>();

int gradYaxis = 1;
int gradXaxis = 2;
color c1, c2;

void setup() {
  //size(960, 540);
  fullScreen();
  String[] cameras = Capture.list();
  printArray(cameras);
  video = new Capture(this, 1920, 1080);
  video.start();
  trackRed = color(255, 0, 0);
  trackBlue = color(0, 0, 255);
  pixelRed = false;
  
  c1 = color(233, 222, 218);
  c2 = color(232, 216, 232 );
  
  //noLoop();
}

void captureEvent(Capture video) {
  video.read();
}


void draw() {
  video.loadPixels();
  
  if (pixelRed) {
    //true
    //background(255);
    setGradient(0, 0, width, height, c1, c2, gradXaxis);
  } else {
    //false
    image(video, 0, 0);
  }
  
  
  beanieRed.clear();
  
  //Begin loop to look at every pixel for RED
  for (int x = 0; x < video.width; x++) {
    for (int y = 0; y < video.height; y++) {
      int loc = x + y * video.width;
      //What is current pixel color
      color pixelColor = video.pixels[loc];
      float r1 = red(pixelColor);
      float g1 = green(pixelColor);
      float b1 = blue(pixelColor);
      float r2 = red(trackRed);
      float g2 = green(trackRed);
      float b2 = blue(trackRed);
      
      float d = distSq(r1, g1, b1, r2, g2, b2);
      
      if (d < threshold*threshold) {
        
        boolean found = false;
        for (Mood moodRed : beanieRed) {
          if (moodRed.isNear(x, y)) {
            moodRed.add(x, y);
            found = true;
            break;
          }
        }
        
        if (!found) {
          red = color(153, 0, 26, 175);
          Mood moodRed = new Mood(x, y, red, 200);
          beanieRed.add(moodRed);
        }
      }
    }
  }
    
  //Begin loop to look at every pixel for BLUE
  for (int x = 0; x < video.width; x++) {
    for (int y = 0; y < video.height; y++) {
      int loc = x + y * video.width;
      //What is current pixel color
      color pixelColor = video.pixels[loc];
      float r1 = red(pixelColor);
      float g1 = green(pixelColor);
      float b1 = blue(pixelColor);
      float r2 = red(trackBlue);
      float g2 = green(trackBlue);
      float b2 = blue(trackBlue);
      
      float d = distSq(r1, g1, b1, r2, g2, b2);
      
      if (d < threshold*threshold) {
        
        boolean found = false;
        for (Mood moodBlue : beanieBlue) {
          if (moodBlue.isNear(x, y)) {
            moodBlue.add(x, y);
            found = true;
            break;
          }
        }
        
        if (!found) {
          blue = color(0, 85, 102);
          //where 100 is standin for diam while I figure shit out
          Mood moodBlue = new Mood(x, y, blue, 100);
          beanieBlue.add(moodBlue);
        }
      }
    }
  }
  
 for (Mood moodRed : beanieRed) {
   if (moodRed.size() > 500) {
     moodRed.show();
     moodRed.morph();
   }
 }
}

void setGradient(int x, int y, float w, float h, color c1, color c2, int axis ) {

  noFill();

  if (axis == gradYaxis) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
  else if (axis == gradXaxis) {  // Left to right gradient
    for (int i = x; i <= x+w; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(i, y, i, y+h);
    }
  }
} 
  
  
  
  
  
// Custom distance functions w/ no square root for optimization
float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}


float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

//USE THIS if it's hard to name the exact pixel colors in trackRed, trackBlue
void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int loc = mouseX + mouseY*video.width;
  trackRed = video.pixels[loc];
  pixelRed = true;
}
