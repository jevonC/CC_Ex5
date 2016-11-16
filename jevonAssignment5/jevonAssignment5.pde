//imgBottom
int cellsize=3; //dimensions of each cell in grid
int cols, rows; //number of columns are rows in system
int maxImages=9;
int imageIndex=0;
PImage[] imgBottom=new PImage[maxImages];

//imgTop
PImage imgTop;

//text stuff
String[] cummings={"[i", "carry", "your", "heart", "with", "me(i", "carry", "it", "in]"};
PFont f;
int i=0;
int inAlpha=255;

void setup() {
  size(1019, 763, P3D);

  //loading 9 images on the bottom
  String[] filenames={"hkLeungChiHouseBW.jpg", "planeBW.jpg", "taiwanSkyLanternBW.jpg", "hkRoomSmallBW.jpg", "taiwanCableCarBW.jpg", "crashPlaygroundBW.jpg", "numberedPillarsBW.jpg", "taiwanEsliteBW.jpg", "hillaryElectionNightBW.jpg" };
  for (int i=0; i<filenames.length; i++) {
    imgBottom[i]=loadImage(filenames[i]);
  }

  //numbers of columns and rows
  cols=width/cellsize; //dividing entire width by width of each cell
  rows=height/cellsize; //dividing entire height by height of each cell

  //loading one image on the top
  imgTop=loadImage("macPresent.png");

  //text stuff
  f=createFont("georgia", 120.0, true); //font, font size, anti aliasing
  textFont(f);
  textAlign(CENTER);
}

void draw() {
  background(0);

  //-------------------------------------------------------------------bottom image stuff
  //disintegration (modified from ex 15-15 from Learning Processing)
  loadPixels();
  //begin loop for columns
  for (int i=0; i<cols; i++) {
    //begin loop for rows
    for (int j=0; j<rows; j++) {

      //making x and y function of cellsize
      int x=i*cellsize+cellsize/3; //x positions: 0*3+3/3=1, 1*3+3/3=4, 2*3+3/3=7...this makes sense
      int y=j*cellsize+cellsize/3; //y positions: 0*3+3/3=1, 1*3+3/3=4, 2*3+3/3=7...this makes sense

      //using x and y to get pixel array location
      int loc=x+y*width;
      color c=imgBottom[imageIndex].pixels[loc]; //cycling through 9 images, displaying different info for each of them

      //adjust rate of change of each cell's z value based on pixel brightness, z changes over time as expressed by frameCount
      float brightnessMod=map(brightness(imgBottom[imageIndex].pixels[loc]), 0, 255, 1, 1.7); //limits variations in cells' z values' rates of change
      float z = ((frameCount*brightnessMod)%500)-500.0; //z starts at -500, z value limited from -500 to 0

      //translate to each cell's location, set fill and stroke, draw each cell as a rectangle
      pushMatrix();
      translate(x, y, z);
      rectMode(CENTER);
      fill(c);
      noStroke();      
      rect(0, 0, cellsize, cellsize); //each cell is a square
      popMatrix();
    }
  }

  //------------------------------------------------------------------------text stuff
  fill(random(255), random(255), random(255));

  //more time elapsed => higher frame count => more dramatic throbbing
  float throbMod=constrain(frameCount, 0, 20000); //don't wanna throb too much, count only up to frameCount=20000
  float throb=map(throbMod, 0, 20000, 0, 50); //limit max throb variable random deviation to 50
  println(throb);

  //"in]" special event: disappears

  if (cummings[i].equals("in]")) {
    fill(random(255), random(255), random(255), inAlpha);
    inAlpha=inAlpha-3;
  }

  //"heart" special events: follows mouse, no duplicate word, throbs harder
  if (cummings[i].equals("heart")) {
    text(cummings[i], mouseX, mouseY); //follows mouse, no duplicate word
    text(cummings[i], mouseX+random(-1*throb, throb), mouseY+random(1*throb, throb)); //throbby effect (x1)
    text(cummings[i], mouseX+random(-2*throb, 2*throb), mouseY+random(-2*throb, 2*throb)); //throbby effect (x2)
  } else {
    text(cummings[i], width/2, height/2+55); //forms a duplicate
    text(cummings[i], width/2+random(-1*(throb/2), (throb/2)), height/2+random(-1*(throb/2), (throb/2))+15); //throbby effect (x0.5)
    text(cummings[i], width/2+random(-1*throb, throb), height/2+random(1*throb, throb)+15); //throbby effect (x1)
  }


  //-------------------------------------------------------------------top image stuff
  //imageTop
  float d=dist(mouseX, mouseY, width/2, height/2);
  float maxDist= sqrt(((width/2)*(width/2))+((height/2)*(height/2)));
  float adjustTint=map(d, 0, maxDist, 0, 255);  //adjusts alpha
  tint(255, 255, 255, adjustTint);
  image(imgTop, 0, 0, width, height);


  //-----------------------------------------------------------------------horizon
  stroke(255, 255-adjustTint); //reverse adjustTint, variable initially defined to alter top image
  strokeWeight(1);
  line(0, height/2, width, height/2);
}


void mousePressed() {
  imageIndex=(imageIndex+1)%maxImages; //cycle through 9 images with every click

  //text stuff
  i=(i+1)%9;
  inAlpha=255; //resets heartAlpha!
}