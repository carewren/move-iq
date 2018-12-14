class Mood {
  float minx;
  float miny;
  float maxx;
  float maxy;
  color c;
  float diam;
  
  ArrayList<PVector> points;
  
  Mood(float x, float y, color tempC, float tempDiam) {
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;
    c = tempC;
    diam = tempDiam;
    points = new ArrayList<PVector>();
    points.add(new PVector(x, y));
  }
 
   void show() {
    noStroke();
    fill(c);
    ellipseMode(CENTER);
    ellipse(minx, miny, diam, diam);
  }
  
  void add(float x, float y) {
    points.add(new PVector(x, y));
    minx = min(minx, x);
    miny = min(miny, y);
    maxx = max(maxx, x);
    maxy = max(maxy, y);
  }
  
  

  
  void morph() {
    //alpha value ranges from 20–100 depending on delta xpos/ypos over time (?)
    //diam value ranges from 100–200 depending on delta xpos/ypos over time (?)
  }
  
  float size() {
    return (maxx-minx)*(maxy-miny);
  }
  
  boolean isNear(float x, float y) {

    // The Rectangle "clamping" strategy
    // float cx = max(min(x, maxx), minx);
    // float cy = max(min(y, maxy), miny);
    // float d = distSq(cx, cy, x, y);

    // Closest point in blob strategy
    float d = 10000000;
    for (PVector v : points) {
      float tempD = distSq(x, y, v.x, v.y);
      if (tempD < d) {
        d = tempD;
      }
    }

    if (d < distThreshold*distThreshold) {
      return true;
    } else {
      return false;
    }
  }
}
